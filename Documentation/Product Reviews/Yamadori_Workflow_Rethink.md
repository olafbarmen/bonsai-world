# Yamadori Workflow Rethink — Locked Decisions

**Type:** Product discussion → **locked for implementation** (fold into Blueprint §5.10)  
**Date:** 3 September 2026  
**Status:** **Decisions locked — implementation in progress**  
**Related:** [Yamadori_Module.md](Yamadori_Module.md) · Blueprint §5.10 · CHANGELOG 2026-09-03  

---

## 1. Summary

Yamadori is the **activity** (trip). A **Find** is a specimen in the field. When collected, the Find becomes a **Yamadori Tree** — a real **Tree** record in a separate nursery list, using the **YAM-YYYY-NNN** code as its display name until the grower moves it to **My Trees**, when it receives a normal Bonsai Name.

---

## 2. Locked decisions (2026-09-03)

| # | Question | Decision |
|---|----------|----------|
| **5.1** | When is a Tree created? | **A — at Collected.** `markCollected` creates a Tree immediately; it appears under **Yamadori Trees**. |
| **5.2** | Nursery → Yamadori navigation | **One sidebar entry: Yamadori.** Four **in-page tabs**: Yamadories · Uncollected Findings · Yamadori Trees · Transferred Trees. |
| **5.3** | Pre-collection Find stages | **A — keep Scout and Planned** as two steps (no extra list tabs). |
| **5.4** | Recovery / Established tabs | **Drop as list chrome.** Survival care happens on the Yamadori Tree (Tree Detail). **Move to My Trees** is the graduation action (was “Transfer to Tree”). |
| **5.5** | Naming | **Yamadori** = trip. **Find** = uncollected specimen. **Yamadori Tree** = collected Tree in nursery list (`YAM-YYYY-NNN`). **My Trees** = graduated Trees with normal Bonsai Name. |

---

## 3. Nursery → Yamadori (one route, four tabs)

| Tab | Shows | Detail |
|-----|-------|--------|
| **Yamadories** | Trips (planning + field work) | Trip detail → Finds on trip |
| **Uncollected Findings** | Finds in Scout / Planned | Find detail |
| **Yamadori Trees** | Collected Trees still in nursery (`yamadoriNursery`) | Tree Detail (same as My Trees) |
| **Transferred Trees** | Yamadori-origin Trees graduated to My Trees | Tree Detail |

**Former sections** (bottom of list, same pattern as Trees):

| List | Former section |
|------|----------------|
| Uncollected Findings | **Former Findings** — abandoned / archived Finds (never collected) |
| Yamadori Trees | **Former Yamadori Trees** — disposed before graduation to My Trees |
| Transferred Trees | *(no separate former block — disposed items live in Garden → Former Trees)* |

---

## 4. Lifecycle

```text
TRIP (Yamadori)
  └── FIND (Scout / Planned)
        └── mark Collected → TREE (yamadoriNursery = true, bonsaiName = YAM-YYYY-NNN)
              ├── list: Yamadori Trees
              ├── care: Tree Detail + timeline (Yamadori history folded in)
              └── Move to My Trees → yamadoriNursery = false, new Bonsai Name, Find → Transferred
```

- **Find statuses kept in schema:** `scout` · `planned` · `collected` · `transferred` · `abandoned` · `archived` (+ legacy `recovery` / `established` for migrated data).
- **Recovery / Established** are not navigation tabs; legacy Finds may still carry those values until edited.
- **Smart Collection “Yamadori”** (Trees with Acquisition Method Yamadori) remains distinct from **Yamadori Trees** nursery list.

---

## 5. Naming rules

| Stage | Display identity |
|-------|------------------|
| Find (uncollected) | Find display name or `YAM-YYYY-NNN` |
| Yamadori Tree (nursery) | **`YAM-YYYY-NNN`** as `Tree.bonsaiName` |
| My Trees (graduated) | **Genus-Species-Cultivar-Year-Number** — YAM code kept in Find history / acquisition notes only |

---

## 6. Implementation notes

- `Tree.yamadoriNursery: Bool` — `true` while in Yamadori Trees list; excluded from Garden → My Trees.
- `Tree.sourceYamadoriID` ↔ Find `linkedTreeID` set at **collection** (not graduation).
- **Move to My Trees** updates the existing Tree (does not create a second Tree).
- Trip list: no status filter tabs; sort by trip date.
- Maps: trip area pin (trip) vs precise Find coords (Find) — already shipped.

---

## 7. Migration (existing data)

| Legacy state | Migration |
|--------------|-----------|
| Find Scout / Planned | Uncollected Findings |
| Find Collected / Recovery / Established, no `linkedTreeID` | Prompt or backfill Tree on next collect action; optional one-time migration creates nursery Trees |
| Find Transferred | Transferred Trees (Tree exists, `yamadoriNursery = false`) |
| Find Abandoned / Archived (pre-collect) | Former Findings |

---

## 8. Exit criteria — met

1. Decisions 5.1–5.5 answered.  
2. UI labels use grower terms: Yamadori, Uncollected Findings, Yamadori Trees, Transferred Trees, Former Findings, Former Yamadori Trees.  
3. Migration story written (§7).  
4. Blueprint §5.10 + CHANGELOG updated; old “Collected never creates Tree” rule **superseded**.

---

## 9. Chat log

### 2026-09-03 — Locked

- Four tabs: Yamadori (trips), Uncollected findings, Yamadori Trees, Transferred trees.  
- Tree at collection with YAM name; graduation assigns Bonsai Name.  
- Former sections mirror Trees list pattern.  
- Recovery / Care not list tabs; transfer via quick action sheet.
