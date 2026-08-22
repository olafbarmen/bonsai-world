#!/usr/bin/env python3
"""
One-time development migration: Olaf Excel → Trees.json (Bonsai World).

Read-only for the workbook. Does not implement the future Import Wizard.
"""

from __future__ import annotations

import json
import re
import uuid
import zipfile
import xml.etree.ElementTree as ET
from collections import Counter, defaultdict
from datetime import datetime, timedelta, timezone
from decimal import Decimal, InvalidOperation
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
XLSX = ROOT / "Bonsai Hub/Resources/Import/Bonsai Database Olaf Barmen 3.xlsx"
OUT_JSON = ROOT / "Bonsai Hub/Resources/Import/OlafDevelopmentTrees.json"
OUT_REPORT = ROOT / "Bonsai Hub/Resources/Import/OlafDevelopmentMigrationReport.json"

LIBRARY_TREES = Path.home() / (
    "Library/Containers/no.olafbarmen.Bonsai-Hub/Data/Library/"
    "Application Support/Bonsai World Library/Database/Trees.json"
)
LIBRARY_COLLECTIONS = LIBRARY_TREES.parent / "Collections.json"

NS = "{http://schemas.openxmlformats.org/spreadsheetml/2006/main}"
RNS = "{http://schemas.openxmlformats.org/officeDocument/2006/relationships}"
TREE_NS = uuid.UUID("20000000-0000-4000-8000-000000000001")


def ref_id(list_n: int, n: int) -> str:
    return f"10000000-0000-4000-8000-{list_n:02x}{n:010d}"


def tree_id(bonsai_name: str) -> str:
    return str(uuid.uuid5(TREE_NS, bonsai_name))


# Reference Data mirrors (PreviewData seeds)
GENERA = [
    "Juniperus", "Acer", "Pinus", "Larix", "Picea", "Taxus", "Ulmus",
    "Carpinus", "Fagus", "Betula", "Pyrus",
]
SPECIES_ROWS = [
    "Juniperus chinensis", "Juniperus procumbens", "Juniperus rigida",
    "Juniperus communis", "Juniperus sabina", "Acer palmatum",
    "Acer buergerianum", "Acer japonicum", "Acer campestre",
    "Pinus thunbergii", "Pinus sylvestris", "Pinus mugo", "Pinus parviflora",
    "Larix decidua", "Larix kaempferi", "Picea abies", "Taxus baccata",
    "Ulmus parvifolia", "Ulmus minor", "Carpinus betulus", "Carpinus coreana",
    "Fagus sylvatica", "Betula pendula", "Pyrus pyraster",
]
CULTIVARS_JCH = [
    "Itoigawa", "Kishu", "Shimpaku", "Blaauw", "Blue Alps", "San Jose", "Sargentii",
]
CULTIVARS_APA = [
    "Deshojo", "Seigen", "Kiyohime", "Katsura", "Shishigashira", "Arakawa",
    "Atropurpureum", "Butterfly", "Orange Dream", "Sango kaku", "Beni Maiko",
    "Beni Hime", "Shaina", "Mikawa Yatsubusa", "Kotohime", "Little Princess",
    "Bloodgood", "Osakazuki", "Skeeters Broom", "Inaba Shidare", "Tamukeyama",
    "Viridis", "Garnet", "Red Dragon", "Orangeola", "Ukigumo", "Aoyagi",
    "Kamagata", "Hogyoku", "Moonrise", "Peaches and Cream", "Purple Ghost",
    "Amber Ghost", "Sister Ghost", "Fireglow", "Red Emperor", "Trompenburg",
    "Generic seed grown", "Field grown", "Collected yamadori",
]
STYLES = [
    "Formal Upright", "Informal Upright", "Slanting", "Cascade", "Semi-cascade",
    "Literati", "Twin Trunk", "Clump", "Forest", "Root-over-rock", "Windswept", "Broom",
]
SIZE_CLASSES = ["Mame", "Shohin", "Kifu", "Chuhin", "Dai", "Imperial"]
TREE_STATUSES = [
    "Frøplante", "Stikling", "Ungplante", "Prebonsai", "Under utvikling",
    "Bonsai", "Ferdig bonsai",
]
ACQUISITION_METHODS = [
    "Nursery", "Garden Centre", "Bonsai Dealer", "Private Seller", "Friend",
    "Club Member", "Seed", "Cutting", "Air Layer", "Yamadori", "Gift",
    "Auction", "Online Marketplace", "Other",
]
DISPOSAL_METHODS = ["Sold", "Gifted", "Donated", "Exchanged", "Died", "Lost", "Other"]
POT_TYPES = ["Treningspotte", "Plastpotte", "Keramikk", "Tokoname", "Hjemmelaget", "Ingen potte"]

# Location list 11: seed 1–6 + Excel placements 7–15
LOCATIONS = {
    "Hage": 1,
    "Drivhus": 2,
    "Kaldbenk": 3,
    "Bonsai-bord": 4,
    "Vinterlagring": 5,
    "Innendørs": 6,
    "Voksebedd nedside": 7,
    "Trapp": 8,
    "Drivhus oppside": 9,
    "Under altan": 10,
    "Benk oppside": 11,
    "Bedd Peisestue": 12,
    "Yamadoribedd": 13,
    "Jordbedd nede": 14,
    "Altan": 15,
}
FALLBACK_LOCATION = "Hage"

STYLE_MAP = {
    "Informal Upright (Moyogi)": "Informal Upright",
    "Formal Upright (Chokkan)": "Formal Upright",
    "Twin Trunk (Sokan)": "Twin Trunk",
    "Forest Planting (Yose-ue)": "Forest",
    "Broom (Hokidachi)": "Broom",
    "Literati (Bunjin)": "Literati",
}
SIZE_MAP_KEYWORDS = [
    ("imperial", "Imperial"),
    ("hachi-uye", "Imperial"),
    ("shohin", "Shohin"),
    ("omono", "Dai"),
    ("dai", "Dai"),
    ("chumono", "Chuhin"),
    ("komono", "Kifu"),
    ("mame", "Mame"),
]
STATUS_MAP = {
    "Pre-bonsai": "Prebonsai",
    "Prebonsai": "Prebonsai",
    "Bonsai": "Bonsai",
    "Stikling": "Stikling",
}
# Explicitly unsupported status values (no close Reference Data match without inventing)
STATUS_UNSUPPORTED = {"Bonsaiemne", "Bonsai Raffinering"}

ACQUISITION_MAP = {
    "Hagesenter": "Garden Centre",
    "Privat selger": "Private Seller",
    "Bonsai-forhandler": "Bonsai Dealer",
    "Yamadori": "Yamadori",
    "Gave": "Gift",
}
DISPOSAL_MAP = {
    "Gave": "Gifted",
    "Død": "Died",
    "Dod": "Died",
}

SUPPORTED_MAPPED = [
    "ID → bonsaiName",
    "Slekt → genusID / botanicalName",
    "Art → speciesID / botanicalName",
    "Kultivar → cultivarID / botanicalName",
    "Stilart → styleID",
    "Størrelseklasse → sizeClassID",
    "Anskaffelsesdato → acquisitionDate",
    "Anskaffelsesverdi → purchasePrice",
    "Hvor anskaffet → acquisitionMethodID",
    "Navn → acquisitionSourceName",
    "Dato avhendet → disposalDate",
    "Årsak → disposalMethodID",
    "Ev salgsverdi → disposalPrice",
    "Høyde i cm → heightMillimetres",
    "Fysisk plassering → locationID",
    "Potte → potTypeID",
    "Treets status → treeStatusID",
    "Notater → notes",
]
UNSUPPORTED = [
    "CARE App",
    "Antatt Spireår",
    "Verdi",
    "Estimert alder",
    "Anbefalt forhold 1",
    "Anbefalt forhold 2",
    "Anbefalt forhold3",
    "Siste arbeid",
    "Siste arbeid dato",
    "Neste arbeid",
    "Neste arbeid dato",
    "Nr",
]


def name_index(names: list[str]) -> dict[str, str]:
    return {n: ref_id(list_n, i + 1) for i, n in enumerate(names)}


def build_lookups():
    genus_ids = {n: ref_id(1, i + 1) for i, n in enumerate(GENERA)}
    species_ids = {}
    species_by_epithet = defaultdict(list)
    for i, binomial in enumerate(SPECIES_ROWS):
        sid = ref_id(2, i + 1)
        species_ids[binomial.lower()] = sid
        parts = binomial.split()
        if len(parts) >= 2:
            species_by_epithet[parts[1].lower()].append((binomial, sid, parts[0]))

    cultivars = []
    for i, name in enumerate(CULTIVARS_JCH):
        cultivars.append((name, ref_id(3, i + 1), species_ids["juniperus chinensis"]))
    offset = len(CULTIVARS_JCH)
    for i, name in enumerate(CULTIVARS_APA):
        cultivars.append((name, ref_id(3, offset + i + 1), species_ids["acer palmatum"]))

    return {
        "genus": genus_ids,
        "species": species_ids,
        "species_by_epithet": species_by_epithet,
        "cultivars": cultivars,
        "style": {n: ref_id(21, i + 1) for i, n in enumerate(STYLES)},
        "size": {n: ref_id(22, i + 1) for i, n in enumerate(SIZE_CLASSES)},
        "status": {n: ref_id(8, i + 1) for i, n in enumerate(TREE_STATUSES)},
        "acquisition": {n: ref_id(6, i + 1) for i, n in enumerate(ACQUISITION_METHODS)},
        "disposal": {n: ref_id(9, i + 1) for i, n in enumerate(DISPOSAL_METHODS)},
        "pot": {n: ref_id(7, i + 1) for i, n in enumerate(POT_TYPES)},
        "location": {n: ref_id(11, i) for n, i in LOCATIONS.items()},
    }


def read_bonsai_sheet(path: Path) -> tuple[list[str], list[list[str]]]:
    with zipfile.ZipFile(path) as z:
        shared = []
        root = ET.fromstring(z.read("xl/sharedStrings.xml"))
        for si in root.findall(f"{NS}si"):
            shared.append("".join(t.text or "" for t in si.findall(f".//{NS}t")))

        wb = ET.fromstring(z.read("xl/workbook.xml"))
        rels = ET.fromstring(z.read("xl/_rels/workbook.xml.rels"))
        rid = {}
        for rel in rels:
            t = rel.get("Target")
            if not t.startswith("xl/"):
                t = "xl/" + t
            rid[rel.get("Id")] = t

        target = None
        for s in wb.find(f"{NS}sheets"):
            if s.get("name") == "Bonsai":
                target = rid[s.get(f"{RNS}id")]
                break
        if target is None:
            raise SystemExit("Bonsai sheet not found")

        def parse_ref(ref: str) -> tuple[int, int]:
            m = re.match(r"([A-Z]+)(\d+)", ref)
            col = 0
            for ch in m.group(1):
                col = col * 26 + (ord(ch) - 64)
            return col, int(m.group(2))

        sheet = ET.fromstring(z.read(target))
        rows: dict[int, dict[int, str]] = defaultdict(dict)
        for c in sheet.findall(f".//{NS}c"):
            ref = c.get("r")
            col, row = parse_ref(ref)
            t = c.get("t")
            v = c.find(f"{NS}v")
            is_elem = c.find(f"{NS}is")
            val = ""
            if t == "inlineStr" and is_elem is not None:
                val = "".join(x.text or "" for x in is_elem.findall(f".//{NS}t"))
            elif v is not None and v.text is not None:
                val = shared[int(v.text)] if t == "s" else v.text
            rows[row][col] = val

        maxc = max(max(r) for r in rows.values())
        data = [[rows[r].get(c, "") for c in range(1, maxc + 1)] for r in sorted(rows)]
        return data[0], data[1:]


def excel_serial_to_iso(value: str) -> str | None:
    text = value.strip()
    if not text:
        return None
    try:
        serial = float(text)
    except ValueError:
        # try ISO-like
        for fmt in ("%Y-%m-%d", "%d.%m.%Y", "%d/%m/%Y"):
            try:
                return datetime.strptime(text, fmt).replace(tzinfo=timezone.utc).strftime(
                    "%Y-%m-%dT00:00:00Z"
                )
            except ValueError:
                continue
        return None
    dt = datetime(1899, 12, 30, tzinfo=timezone.utc) + timedelta(days=serial)
    return dt.strftime("%Y-%m-%dT00:00:00Z")


def parse_decimal(value: str) -> float | None:
    text = value.strip().replace(" ", "").replace(",", ".")
    if not text:
        return None
    try:
        return float(Decimal(text))
    except (InvalidOperation, ValueError):
        return None


def normalize_genus(raw: str) -> str:
    g = raw.strip()
    if g.lower().startswith("carpinus"):
        return "Carpinus"
    return g


def clean_epithet(raw: str) -> str:
    text = raw.strip()
    if not text:
        return ""
    # drop parenthetical notes: "Obtusa (Hinoki)" → Obtusa
    text = re.sub(r"\([^)]*\)", "", text).strip()
    return text


def make_botanical(genus: str, epithet: str, cultivar: str) -> str:
    parts = []
    if genus and epithet:
        binomial = f"{genus} {epithet.lower()}"
    elif genus:
        binomial = genus
    else:
        binomial = epithet
    if binomial:
        parts.append(binomial)
    if cultivar:
        parts.append(f"'{cultivar}'")
    return " ".join(parts)


def map_style(raw: str, lookups) -> tuple[str | None, str | None]:
    text = raw.strip()
    if not text:
        return None, None
    mapped = STYLE_MAP.get(text)
    if mapped and mapped in lookups["style"]:
        return lookups["style"][mapped], None
    # prefix match against Reference Data names
    for name, sid in lookups["style"].items():
        if text.lower().startswith(name.lower()):
            return sid, None
    return None, text


def map_size(raw: str, lookups) -> tuple[str | None, str | None]:
    text = raw.strip()
    if not text:
        return None, None
    low = text.lower()
    for key, name in SIZE_MAP_KEYWORDS:
        if key in low and name in lookups["size"]:
            return lookups["size"][name], None
    return None, text


def map_status(raw: str, lookups) -> tuple[str | None, str | None]:
    text = raw.strip()
    if not text:
        return None, None
    if text in STATUS_UNSUPPORTED:
        return None, text
    mapped = STATUS_MAP.get(text, text)
    if mapped in lookups["status"]:
        return lookups["status"][mapped], None
    return None, text


def map_pot(raw: str, lookups) -> tuple[str | None, str | None]:
    text = raw.strip()
    if not text:
        return None, None
    if text in lookups["pot"]:
        return lookups["pot"][text], None
    low = text.lower()
    if low.startswith("tokoname"):
        return lookups["pot"]["Tokoname"], None
    if low.startswith("glasert") or low.startswith("uglasert"):
        return lookups["pot"]["Keramikk"], None
    if "plast" in low or low.startswith("mica"):
        return lookups["pot"]["Plastpotte"], None
    return None, text


def map_cultivar(name: str, species_id: str | None, lookups) -> str | None:
    if not name:
        return None
    for cname, cid, sid in lookups["cultivars"]:
        if cname.casefold() != name.casefold():
            continue
        if species_id is None or sid == species_id:
            return cid
    return None


def abbreviate(name: str) -> str:
    letters = re.sub(r"[^A-Za-z]", "", name).upper()
    if not letters:
        return ""
    if len(letters) >= 3:
        return letters[:3]
    return letters.ljust(3, "X")


def generate_bonsai_name(genus: str, epithet: str, cultivar: str, year: int, seq: int) -> str:
    gen = abbreviate(genus)
    spe = abbreviate(epithet or genus)
    if not gen or not spe:
        return ""
    cul = abbreviate(cultivar) if cultivar else "XXX"
    if not cul:
        cul = "XXX"
    return f"{gen}-{spe}-{cul}-{year}-{seq:03d}"


def migrate() -> dict:
    if not XLSX.exists():
        raise SystemExit(f"Workbook not found: {XLSX}")

    headers, rows = read_bonsai_sheet(XLSX)
    col = {h.strip(): i for i, h in enumerate(headers)}
    # header "Årsak " has trailing space in workbook
    for key in list(col):
        col[key.strip()] = col[key]

    lookups = build_lookups()
    trees = []
    skipped = []
    invalid = []
    location_fallback = []
    unmapped = defaultdict(list)
    generated_names = []
    seq_counters: dict[str, int] = defaultdict(int)

    for row_index, row in enumerate(rows, start=2):
        def cell(name: str) -> str:
            i = col.get(name)
            if i is None:
                return ""
            return str(row[i]).strip() if i < len(row) else ""

        bonsai_name = cell("ID")
        genus_raw = cell("Slekt")
        # Skip completely empty / formula-noise rows
        meaningful = any(
            cell(h)
            for h in (
                "ID", "Slekt", "Art", "Kultivar", "Fysisk plassering", "Notater",
            )
        )
        if not meaningful:
            continue
        if not bonsai_name and not genus_raw:
            skipped.append({"row": row_index, "reason": "no ID and no Slekt"})
            continue

        genus = normalize_genus(genus_raw)
        epithet = clean_epithet(cell("Art"))
        cultivar = cell("Kultivar")

        genus_id = lookups["genus"].get(genus)
        species_id = None
        if genus and epithet:
            binomial = f"{genus} {epithet.lower()}"
            species_id = lookups["species"].get(binomial.lower())
            if species_id is None:
                for binom, sid, gname in lookups["species_by_epithet"].get(epithet.lower(), []):
                    if gname == genus:
                        species_id = sid
                        break

        cultivar_id = map_cultivar(cultivar, species_id, lookups)
        botanical = make_botanical(genus, epithet, cultivar)

        style_id, style_miss = map_style(cell("Stilart"), lookups)
        if style_miss:
            unmapped["Stilart"].append(style_miss)

        size_id, size_miss = map_size(cell("Størrelseklasse"), lookups)
        if size_miss:
            unmapped["Størrelseklasse"].append(size_miss)

        status_id, status_miss = map_status(cell("Treets status"), lookups)
        if status_miss:
            unmapped["Treets status"].append(status_miss)

        pot_id, pot_miss = map_pot(cell("Potte"), lookups)
        if pot_miss:
            unmapped["Potte"].append(pot_miss)

        placement = cell("Fysisk plassering")
        location_id = lookups["location"].get(placement)
        used_fallback = False
        if location_id is None:
            location_id = lookups["location"][FALLBACK_LOCATION]
            used_fallback = True
            if placement:
                unmapped["Fysisk plassering"].append(placement)
            else:
                location_fallback.append(bonsai_name or f"row-{row_index}")

        acq_raw = cell("Hvor anskaffet")
        acq_method = ACQUISITION_MAP.get(acq_raw)
        acq_method_id = lookups["acquisition"].get(acq_method) if acq_method else None
        if acq_raw and not acq_method_id:
            unmapped["Hvor anskaffet"].append(acq_raw)

        source_name = cell("Navn")  # seller / giver in this workbook

        disposal_date = excel_serial_to_iso(cell("Dato avhendet"))
        arsak = cell("Årsak") or cell("Årsak ")
        disp_method = DISPOSAL_MAP.get(arsak)
        disposal_method_id = lookups["disposal"].get(disp_method) if disp_method else None
        if arsak and not disposal_method_id:
            unmapped["Årsak"].append(arsak)

        acquisition_date = excel_serial_to_iso(cell("Anskaffelsesdato"))
        purchase_price = parse_decimal(cell("Anskaffelsesverdi"))
        disposal_price = parse_decimal(cell("Ev salgsverdi"))

        height_mm = None
        height_raw = cell("Høyde i cm")
        if height_raw:
            try:
                height_mm = int(round(float(height_raw.replace(",", ".")) * 10))
            except ValueError:
                invalid.append({"row": row_index, "field": "Høyde i cm", "value": height_raw})

        # Preserve Excel Bonsai Name; generate only when genuinely absent
        final_name = bonsai_name
        if not final_name:
            year = 0
            if acquisition_date:
                year = int(acquisition_date[:4])
            else:
                year = datetime.now(timezone.utc).year
            key = f"{genus}|{epithet.lower()}"
            seq_counters[key] += 1
            final_name = generate_bonsai_name(genus, epithet, cultivar, year, seq_counters[key])
            generated_names.append({"row": row_index, "bonsaiName": final_name})

        if not final_name:
            skipped.append({"row": row_index, "reason": "could not form Bonsai Name"})
            continue

        stamp = acquisition_date or datetime.now(timezone.utc).strftime("%Y-%m-%dT00:00:00Z")

        tree = {
            "id": tree_id(final_name),
            "botanicalName": botanical,
            "nickname": "",
            "bonsaiName": final_name,
            "genusID": genus_id,
            "speciesID": species_id,
            "cultivarID": cultivar_id,
            "styleID": style_id,
            "sizeClassID": size_id,
            "treeStatusID": status_id,
            "healthStatus": "stable",
            "locationID": location_id,
            "soilMixID": None,
            "potTypeID": pot_id,
            "lightConditionID": None,
            "heightMillimetres": height_mm,
            "crownWidthMillimetres": None,
            "nebariWidthMillimetres": None,
            "trunkDiameterMillimetres": None,
            "potLengthMillimetres": None,
            "potWidthMillimetres": None,
            "potHeightMillimetres": None,
            "potDiameterMillimetres": None,
            "acquisitionDate": acquisition_date,
            "acquisitionMethodID": acq_method_id,
            "acquisitionSourceName": source_name,
            "purchasePrice": purchase_price,
            "acquisitionNotes": "",
            "disposalDate": disposal_date,
            "disposalMethodID": disposal_method_id,
            "disposalPartyName": "",
            "disposalPrice": disposal_price,
            "disposalNotes": "",
            "notes": cell("Notater"),
            "primaryImageID": None,
            "imageIDs": [],
            "projectIDs": [],
            "journalEntryIDs": [],
            "taskIDs": [],
            "createdDate": stamp,
            "modifiedDate": stamp,
        }
        if used_fallback and not placement:
            pass
        trees.append(tree)

    # Duplicate bonsai names
    name_counts = Counter(t["bonsaiName"] for t in trees)
    duplicates = sorted([n for n, c in name_counts.items() if c > 1])

    # Validate
    validation_errors = []
    ids = [t["id"] for t in trees]
    if len(ids) != len(set(ids)):
        validation_errors.append("Duplicate tree UUIDs")
    for t in trees:
        if not t["bonsaiName"]:
            validation_errors.append(f"Empty bonsaiName for id {t['id']}")
        if not t["locationID"]:
            validation_errors.append(f"Missing locationID for {t['bonsaiName']}")

    catalog = {"trees": trees}
    OUT_JSON.parent.mkdir(parents=True, exist_ok=True)
    OUT_JSON.write_text(json.dumps(catalog, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")

    # Persist into active development library (replace sample catalog)
    if LIBRARY_TREES.parent.exists():
        LIBRARY_TREES.write_text(json.dumps(catalog, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")
        # Clear stale membership pointing at old sample tree IDs
        if LIBRARY_COLLECTIONS.exists():
            try:
                coll = json.loads(LIBRARY_COLLECTIONS.read_text(encoding="utf-8"))
                valid = {t["id"] for t in trees}
                for c in coll.get("collections", []):
                    c["treeIDs"] = [tid for tid in c.get("treeIDs", []) if tid in valid]
                LIBRARY_COLLECTIONS.write_text(
                    json.dumps(coll, indent=2, ensure_ascii=False) + "\n", encoding="utf-8"
                )
            except Exception as exc:  # noqa: BLE001
                validation_errors.append(f"Collections cleanup failed: {exc}")

    unmapped_summary = {
        field: sorted(Counter(vals).items(), key=lambda x: (-x[1], x[0]))
        for field, vals in unmapped.items()
    }

    report = {
        "sourceWorkbook": str(XLSX.relative_to(ROOT)),
        "importedCount": len(trees),
        "skippedCount": len(skipped),
        "skipped": skipped,
        "fieldsSuccessfullyMapped": SUPPORTED_MAPPED,
        "fieldsNotYetSupported": UNSUPPORTED,
        "duplicateBonsaiNames": duplicates,
        "invalidRecords": invalid,
        "generatedBonsaiNames": generated_names,
        "locationFallbackWhenEmpty": location_fallback,
        "unmappedReferenceValues": unmapped_summary,
        "validation": {
            "ok": len(validation_errors) == 0 and len(duplicates) == 0,
            "errors": validation_errors,
            "treeCount": len(trees),
            "uniqueBonsaiNames": len(name_counts),
        },
        "outputCatalog": str(OUT_JSON.relative_to(ROOT)),
        "libraryCatalogWritten": LIBRARY_TREES.exists(),
        "libraryCatalogPath": str(LIBRARY_TREES) if LIBRARY_TREES.exists() else None,
    }
    OUT_REPORT.write_text(json.dumps(report, indent=2, ensure_ascii=False) + "\n", encoding="utf-8")
    return report


if __name__ == "__main__":
    report = migrate()
    print(json.dumps({
        "imported": report["importedCount"],
        "skipped": report["skippedCount"],
        "duplicates": report["duplicateBonsaiNames"],
        "validation": report["validation"],
        "libraryWritten": report["libraryCatalogWritten"],
    }, indent=2))
