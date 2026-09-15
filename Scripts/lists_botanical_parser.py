#!/usr/bin/env python3
"""
Parse botanical Reference Data from the Lists worksheet in Olaf's Excel workbook.

Layout (Lists):
  Column A (row 4+): master genus list
  Columns B–AL:
    Row 1 — genus for the column
    Row 2 — species epithet when the column lists cultivars
    Row 4+ — species epithets (no row 2) or cultivar names (row 2 set)
"""

from __future__ import annotations

import zipfile
import xml.etree.ElementTree as ET
from dataclasses import dataclass
from pathlib import Path
from string import ascii_uppercase

NS = "{http://schemas.openxmlformats.org/spreadsheetml/2006/main}"

GENUS_ALIASES = {
    "Lind": "Tilia",
    "Caprinus": "Carpinus",
}

DEFAULT_XLSX = (
    Path(__file__).resolve().parents[1]
    / "Bonsai Hub/Resources/Import/Bonsai Database Olaf Barmen 3.xlsx"
)


@dataclass(frozen=True)
class ParsedBotanical:
    genera: list[str]
    species: list[tuple[str, str, str, str]]  # genus, epithet, binomial, code
    cultivars: list[tuple[str, str]]  # name, binomial


def clean_genus_key(raw: str) -> str:
    raw = raw.strip()
    if raw in GENUS_ALIASES:
        return GENUS_ALIASES[raw]
    if "(" in raw:
        return raw.split("(")[0].strip()
    return raw


def normalize_epithet(genus: str, entry: str) -> str:
    text = entry.strip()
    prefix = f"{genus} "
    if text.lower().startswith(prefix.lower()):
        text = text[len(prefix) :].strip()
    if not text:
        return text
    return text[0].lower() + text[1:] if len(text) > 1 else text.lower()


def species_code(genus: str, epithet: str) -> str:
    genus_letter = next((c for c in genus if c.isalpha()), "X").upper()
    epithet_letters = "".join(c for c in epithet if c.isalpha()).upper()
    suffix = epithet_letters[:2] if len(epithet_letters) >= 2 else epithet_letters.ljust(2, "X")
    return genus_letter + suffix


def unique_species_code(genus: str, epithet: str, used: set[str]) -> str:
    candidates = []
    genus_letter = next((c for c in genus if c.isalpha()), "X").upper()
    epithet_letters = "".join(c for c in epithet if c.isalpha()).upper()
    candidates.append(genus_letter + epithet_letters[:2].ljust(2, "X")[:2])
    for length in range(3, min(len(epithet_letters), 5) + 1):
        candidates.append((genus_letter + epithet_letters[: length])[:4])
    for candidate in candidates:
        if candidate not in used:
            used.add(candidate)
            return candidate
    base = candidates[0]
    index = 2
    while f"{base}{index}" in used:
        index += 1
    code = f"{base}{index}"
    used.add(code)
    return code


def column_letters_through(last: str = "AL") -> list[str]:
    columns: list[str] = []
    for letter in ascii_uppercase:
        columns.append(letter)
    for first in ascii_uppercase:
        for second in ascii_uppercase:
            pair = first + second
            columns.append(pair)
            if pair == last:
                return columns
    return columns


def parse_cell_ref(ref: str) -> tuple[str, int]:
    col = "".join(character for character in ref if character.isalpha())
    row = int("".join(character for character in ref if character.isdigit()))
    return col, row


def load_lists_sheet(xlsx_path: Path) -> tuple[dict[int, dict[str, str]], int]:
    with zipfile.ZipFile(xlsx_path) as archive:
        shared_strings: list[str] = []
        shared_root = ET.fromstring(archive.read("xl/sharedStrings.xml"))
        for item in shared_root.findall(f"{NS}si"):
            shared_strings.append("".join((node.text or "") for node in item.iter(f"{NS}t")))

        workbook = ET.fromstring(archive.read("xl/workbook.xml"))
        relationships = ET.fromstring(archive.read("xl/_rels/workbook.xml.rels"))
        relationship_targets = {
            rel.attrib["Id"]: rel.attrib["Target"] for rel in relationships
        }

        lists_target = None
        for sheet in workbook.find(f"{NS}sheets"):
            if sheet.attrib.get("name", "").lower() == "lists":
                rel_id = sheet.attrib[
                    "{http://schemas.openxmlformats.org/officeDocument/2006/relationships}id"
                ]
                lists_target = "xl/" + relationship_targets[rel_id].lstrip("/")
                break
        if lists_target is None:
            raise ValueError("Lists worksheet not found")

        sheet_root = ET.fromstring(archive.read(lists_target))
        rows: dict[int, dict[str, str]] = {}
        max_row = 0
        for row_element in sheet_root.findall(f".//{NS}sheetData/{NS}row"):
            row_number = int(row_element.attrib["r"])
            max_row = max(max_row, row_number)
            rows[row_number] = {}
            for cell in row_element.findall(f"{NS}c"):
                reference = cell.attrib.get("r", "")
                column, _ = parse_cell_ref(reference)
                value_element = cell.find(f"{NS}v")
                if value_element is None:
                    value = ""
                elif cell.attrib.get("t") == "s":
                    value = shared_strings[int(value_element.text)]
                else:
                    value = value_element.text or ""
                rows[row_number][column] = value.strip()

    return rows, max_row


def parse_botanical_lists(xlsx_path: Path = DEFAULT_XLSX) -> ParsedBotanical:
    rows, max_row = load_lists_sheet(xlsx_path)

    genera: list[str] = []
    genus_index_by_key: dict[str, int] = {}
    for row_number in range(4, max_row + 1):
        raw = rows.get(row_number, {}).get("A", "").strip()
        if not raw:
            continue
        key = clean_genus_key(raw).lower()
        if key in genus_index_by_key:
            continue
        genus_index_by_key[key] = len(genera)
        genera.append(raw)

    species_rows: list[tuple[str, str, str]] = []
    cultivar_rows: list[tuple[str, str]] = []
    seen_species: set[str] = set()

    for column in column_letters_through("AL")[1:]:
        genus_raw = rows.get(1, {}).get(column, "").strip()
        if not genus_raw:
            continue
        genus = clean_genus_key(genus_raw)
        row2 = rows.get(2, {}).get(column, "").strip()
        entries = [
            rows.get(row_number, {}).get(column, "").strip()
            for row_number in range(4, max_row + 1)
        ]
        entries = [entry for entry in entries if entry]

        if row2:
            epithet = normalize_epithet(genus, row2)
            binomial = f"{genus} {epithet}"
            key = binomial.lower()
            if key not in seen_species:
                seen_species.add(key)
                species_rows.append((genus, epithet, binomial))
            for cultivar in entries:
                cultivar_rows.append((cultivar, binomial))
        else:
            for entry in entries:
                epithet = normalize_epithet(genus, entry)
                binomial = f"{genus} {epithet}"
                key = binomial.lower()
                if key not in seen_species:
                    seen_species.add(key)
                    species_rows.append((genus, epithet, binomial))

    used_codes: set[str] = set()
    species_with_codes: list[tuple[str, str, str, str]] = []
    for genus, epithet, binomial in species_rows:
        code = unique_species_code(genus, epithet, used_codes)
        species_with_codes.append((genus, epithet, binomial, code))

    return ParsedBotanical(
        genera=genera,
        species=species_with_codes,
        cultivars=cultivar_rows,
    )


if __name__ == "__main__":
    import json
    import sys

    path = Path(sys.argv[1]) if len(sys.argv) > 1 else DEFAULT_XLSX
    parsed = parse_botanical_lists(path)
    print(
        json.dumps(
            {
                "genera": len(parsed.genera),
                "species": len(parsed.species),
                "cultivars": len(parsed.cultivars),
            },
            indent=2,
        )
    )
