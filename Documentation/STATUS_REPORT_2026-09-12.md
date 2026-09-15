# Bonsai World — Project Status Report

**Date:** 12 September 2026  
**Product name (user-facing):** Bonsai World  
**Engineering name (Xcode / folders):** Bonsai Hub  
**Platform shipping now:** native macOS (SwiftUI)  

**Supersedes:** [STATUS_REPORT_2026-08-30.md](STATUS_REPORT_2026-08-30.md) (keep as history).  
**Companion audit:** [STATUS_AUDIT_2026-09-12.md](STATUS_AUDIT_2026-09-12.md).

This file is a briefing for discussion and testing. It is **not** a governing document. Product truth remains: START_HERE → Constitution → Product Blueprint → Falo Design System / Component Library.

**Important:** Most product work after the last `main` commit is still **local / uncommitted**. This report describes the **working tree as of 12 Sep 2026**.

---

## 1. What this product is

Bonsai World is a calm, everyday place to organize a bonsai collection and support ongoing care.

It should help the grower know what they have, where it lives, what needs attention, and what has been done — without turning care into administration.

**Trees are the core.** One product, one library, one data model. Experience packages appear in Settings as a **planning matrix only** (not persisted, not gating the sidebar yet).

Future clients (Windows, iPhone, Android) remain an architectural target. Domain, services, and storage contracts stay platform-independent where practical.

---

## 2. How the grower and the tools work together

- **One concept = one name.** (e.g. **Duplicate Tree Info**, **My Trees**, not “In Care” in UI.)
- **The grower decides design and labels** — assistants ask yes/no or numbered choices.
- **Confirm before coding.**
- **UI copy is English**; user content may be Norwegian.
- **Context Tools** is the single action home for the current workspace (replaces grower-facing “Quick Actions”).
- Workspace module pages use **`.bonsaiWorkspaceNavigationTitle`** — title above content, not in the window toolbar.

---

## 3. Architecture (as built)

| Layer | Role |
|-------|------|
| **Views** (`Features/`, `Shared/`) | SwiftUI. Read/write through services. |
| **Services** | Tree, Task, Work, Pot, Yamadori, Image, Weather, Reference Data, Inventory/Soil/Nursery, Library export/import, … |
| **Repositories** | Protocol + Library (JSON in user library package) + Preview. |
| **Domain** | Identifiers only — no file paths. |
| **Storage** | User-owned library folder. Images: originals + non-destructive presentation crops. |
| **Platform** | macOS pickers, image decode, notifications. |

**Shell:** `NavigationSplitView` — Workspace + Library lists, pinned **Context Tools**, profile → Settings. Dedicated windows: Tree Workspace, Image Workspace, Crop Workspace, Tree Image Viewer, Yamadori windows.

---

## 4. Navigation (shipped)

**Workspace**

1. Dashboard  
2. Tasks (Overdue → Next Year horizons)  
3. Garden → Trees, Collections, Locations  
4. Care → Watering, Fertilizing, Repotting, Health, Seasonal (+ hidden Today / Placement / Winter)  
5. Nursery → Seeds, Cuttings, Air Layers, Grafting, Field Tree, Yamadori  
6. Inventory → Pots, Soil, Wire, Tools, Chemicals, Consumables, Fertilizers  

**Library**

7. Media → Images (live); Documents / Video (catalog); Notes / Audio hidden  
8. Knowledge → Species Library, guides, Seed Stratification, CRUD resource kinds  

**Tools:** Settings via profile footer (profile, regional, Reference Data, brands, library management, Social, notifications, Experience planning).

Blueprint §10 Version 2 list is **not** the shipped sidebar. Code is Version 3+: Tasks first-class; Locations under Garden; no Workshop/Economy in the sidebar.

---

## 5. Module status (honest)

Legend: **Live** · **Partial** · **Shell** · **Hidden**

| Module | Status | Notes |
|--------|--------|--------|
| Dashboard | Live | My Trees, Tasks, Weather, Alerts, Upcoming, attention, Library gaps, Recent Work, Collections, Repotting cards |
| Tasks / Work | Live | Schedules, horizons, complete/undo, Tree Detail Tasks card |
| Trees | Live | My Trees / Former Trees, Add Tree (Blank / Duplicate), View/Edit auto-save, photos, pot, timeline |
| Collections | Live / Partial | Manual + smart; care watering; logic still inside TreeService |
| Locations | Live | MapKit, gardens, environment → weather text |
| Care | Partial | Watering + Fertilizing engines; other pages mostly task/tracking UIs |
| Seeds | Live | **Seed Work** + **Overview**; tips link to Knowledge Stratification |
| Yamadori | Live | Trips + Finds, collect → graduate |
| Other Nursery kinds | Partial | One generic propagation model for four labels |
| Pots / Soil / stock | Live | Assign pot, stocktake, Stock Report Excel |
| Media Images | Live | Gallery, crop, rotate; Import from Context Tools |
| Other Media | Partial | Catalog CRUD; weak file playback |
| Knowledge guides / Species | Live | ~19 species profiles; name-matched to RD |
| Knowledge CRUD | Live shell | Empty until grower adds content |
| Context Tools | Live | Pinned; truthful actions; Add Tree expands in place |
| Settings / Library Mgmt | Live | Export/import/empty personal library |
| Experience | Planning UI | Matrix only — no persist, no gating |
| Social | Hidden / Early | Local share levels + SimpleCatalog |
| Economy / Workshop | Shell | Not product |

---

## 6. Product language (agreed)

| Use this | Do not use |
|----------|------------|
| Bonsai World | Bonsai Hub (except engineering) |
| My Trees | In Care (UI) |
| Former Trees | — |
| Duplicate Tree Info | Two names for the same copy action |
| Context Tools | Quick Actions (grower-facing) |
| Seed Work / Overview | Extra Seeds tabs that duplicate Knowledge |
| My Collections / Smart Collections | Invented section names |

Internal IDs may still say `isInCare`, `*QuickActions*`. That is engineering, not UI.

---

## 7. What changed since 30 Aug (high level)

Already in Changelog for early September, plus working-tree passes through mid-September:

- Full Nursery / Inventory / Care / Knowledge / Yamadori depth beyond Aug “placeholders”
- Species Library expanded (Acer, Larix, Pinus, Juniper cultivars, Zelkova, …)
- Gallery rotate shipped; Library export/import
- **Context Tools** rename + truth pass + pinned panel + toolbar cleanup
- Seeds simplified to Seed Work + Overview; stratification owned by Knowledge
- Experience planning matrix in Settings
- Workspace navigation title chrome on module pages

---

## 8. Known leftovers (grower picks next)

**Hardening**

1. ~~Photo index vs Trees.json SSOT~~ — mitigated (Tree owns photos; separate lock file)  
2. ~~Measurement cache vs history write path~~ — mitigated (Edit Tree blocked; Excel import syncs history now)  
3. Commit / backup the large uncommitted working tree  

**Product depth**

4. SpeciesProfile ↔ Reference Data ID link  
5. Nursery kind-specific depth (or honest “generic” product)  
6. Care engines beyond watering/fertilizer (or label tracking-only)  
7. Experience persist + gating  
8. Media Search/Sort, mirror, docs/video playback  

**Parked unless asked**

- Right-click mirror of Context Tools  
- Reopening photo/measurement integrity without a new bug report  

**Distribution**

- Signed zip / Sparkle / notarization — not built  

---

## 9. Risks / tensions

1. **Uncommitted working tree** — months of product outside git; backup risk remains high.  
2. **Blueprint / older reviews** may still say “placeholder” in places — prefer this report + Sep 12 audit.  
3. **Experience matrix** can be mistaken for live gating — it is planning only.  
4. **Economy / Social** still collect fields without full destination modules.  

---

## 10. Suggested questions for a mentor / next session

1. Harden (git backup) or deepen Nursery / Care / Species linking next?  
2. Keep collecting Economy/Social fields, or park them in UI?  
3. When should Experience packages start hiding modules?  
4. Is one generic Nursery propagation model enough for v1?  

---

## 11. How to read the repo

1. `Documentation/START_HERE.md`  
2. `Documentation/BONSAI_CONSTITUTION.md`  
3. `Documentation/PRODUCT_BLUEPRINT.md`  
4. This status report + `STATUS_AUDIT_2026-09-12.md`  
5. `Documentation/CHANGELOG.md` for shipped history  

Launch from agent/terminal: `Scripts/build_and_launch.sh` (see `Scripts/README.md`).
