# Locations (Habitat) — Product Architecture

**Type:** Product / architecture review (non-governing · historical once folded)  
**Date:** 24 August 2026  
**Status:** **Approved decision** — folded into [PRODUCT_BLUEPRINT.md](../PRODUCT_BLUEPRINT.md) **§5.3**. This file remains the rationale.  
**Governing sources read:** README · START_HERE · BONSAI_CONSTITUTION · PRODUCT_BLUEPRINT · FALO_DESIGN_SYSTEM  

**Related:** [Yamadori_Module.md](Yamadori_Module.md) (wild site GPS vs bench Location) · [Inventory_2.0_Module.md](Inventory_2.0_Module.md) (physical asset register — distinct from physical *places*)

---

## 1. Naming: Locations vs Habitat

**Decision:** the user-facing name stays **Locations**. "**Habitat**" is only the internal/architecture term already used in code (`WorkingDomainID.habitat`, `LocationEnvironmentProfile` doc comments) for the domain that owns *where a tree lives and what that place is like*. No UI copy, menu, or sidebar label should say "Habitat" — this document and code comments are the only places the word appears.

| Term | Scope |
|------|-------|
| **Locations** (UI) | Sidebar entry, module title, empty states, Quick Actions — unchanged |
| **Habitat** (internal) | `WorkingDomainID` case grouping Location + Environment Profile + (future) climate/watering engines |

---

## 2. Purpose and hierarchy

**Locations** answers *"where does this tree physically live, and what is that place like?"* — distinct from **Collections**, which answer *"which trees do I want to look at together right now?"*

```text
Garden (physical property)
    ↓
Location (bench, shelf, zone within the Garden)
    ↓
Tree (exactly one Location)

Location -.owns.-> Environment Profile (sun, shade, wind, rain, humidity, airflow, winter protection)
```

- **Garden** — the grower's physical property: name, address/city/region/country, one map position (`geographicPosition`). A grower may have more than one Garden (e.g. home + a second property).
- **Location** — a place within a Garden: name, Location Type (Reference Data), Garden reference (`gardenID`), optional map position, and an **Environment Profile**.
- **Collection** (§5.4) is organizational only and never sets Location — kept as a hard boundary throughout this redesign.

---

## 3. What changed in this pass

Before this redesign, Locations had four structural problems. Each is listed with its resolution.

### 3.1 No real persistence

**Before:** `Garden` lived in a single `UserDefaults` JSON blob; `LocationReference` lived only in an in-memory seed array (`ReferencePreviewData`) with **zero persistence** — every edit was lost on quit.

**After:** Garden and Location follow the same repository pattern already proven for Tree and Collection:

| Layer | Garden | Location |
|-------|--------|----------|
| Protocol | `GardenRepository` | `LocationRepository` |
| Library-backed | `LibraryGardenRepository` → `Database/Gardens.json` | `LibraryLocationRepository` → `Database/Locations.json` |
| Pre-Library | `UserDefaultsGardenRepository` (wraps the legacy blob) | `PreviewLocationRepository` (wraps `ReferencePreviewData.locations`) |
| Migration | `GardenMigrationService` | `LocationMigrationService` |

Both repositories are **batch-oriented** (`getAll`, `get(id:)`, `replaceCatalog`, `discardPersistedCatalog`) rather than per-item CRUD, because `UserProfileStore` and `ReferenceDataManager` already manage their data as whole arrays — matching how those services actually mutate state instead of forcing a finer-grained protocol nobody calls that way.

`UserProfileStore` and `ReferenceDataManager` are constructed with the pre-Library repositories at launch and re-wired to the Library-backed ones via `attachLibraryGardenRepository` / `attachLibraryLocationRepository` once a Library exists (mirroring `makeTreeRepository`/`makeCollectionRepository` in `Bonsai_HubApp.swift`), so Gardens/Locations created before a Library exists are migrated in automatically, once, the first time one is opened.

### 3.2 Duplicate "trees at this location" UI

**Before:** `LocationsListView` showed the same tree list twice — once inline (`locationSelectionPane`) and again in the separate `LocationDetailView` column, which is what produced the confusing "Select a Location" empty state next to an already-populated inline list.

**After:** the inline pane is removed. The list column now only drives selection; `LocationDetailView` is the single place that shows full Location information, including its Trees.

### 3.3 Environment Profile collected but never used

**Before:** `LocationEnvironmentProfile` (sun, shade, wind, rain, humidity, airflow, winter protection) existed as a model but was never displayed and never consumed by anything — dead data entry.

**After:**
- `LocationDetailView` shows every Environment Profile field with an explicit "Not set" placeholder when the grower hasn't recorded it yet.
- `WeatherRiskAssessment.locationRisks(environment:snapshot:)` combines the profile with the live forecast to produce plain-language warnings, e.g.:
  - Exposed wind exposure + forecast high wind → shelter warning.
  - Outdoor winter protection + forecast frost → cover warning.
  - Fully exposed rain + high rain probability → fertilizer wash-off note.
  - Full sun + forecast heat/UV → extra watering note.

  These bullets surface at the top of the Environment card on Location Detail.

**Known limitation (explicit, not silent):** `WeatherService` is still keyed to `profile.defaultGarden` only. Risk bullets for a Location in a non-default Garden are computed against the *default* Garden's forecast until Weather gets its own multi-Garden pass — tracked as a follow-up, not hidden behind a false "it just works" impression.

### 3.4 Locations invisible outside the default Garden

**Before:** `LocationsListView` filtered everything by `profile.defaultGarden?.id` only. A second Garden's Locations could never surface on the map or in the list, even though Garden CRUD for multiple Gardens already existed elsewhere in the app.

**After:**
- `AppState.selectedGardenID` tracks which Garden is being browsed in the Locations module (falling back to the default Garden when nothing is explicitly selected).
- A Garden picker in the map chrome lets the grower switch between any of `profile.activeGardens`.
- List filtering, map annotations, and "place Garden position" all key off the browsed Garden instead of the hardcoded default.
- **New Location** creation (`LocationEditorView` → `manager.blankLocationDraft(gardenID:)`) defaults to the currently browsed Garden, so a Location created while looking at Garden B lands in Garden B, not silently in the default Garden.

---

## 4. Primary objects (as shipped)

**Garden**

| Group | Fields |
|-------|--------|
| Identity | id, name |
| Address | address, city, region, country (composed for display and geocoding fallback) |
| Position | `geographicPosition` — single source of truth for the map; never re-derived from address once set |

**Location**

| Group | Fields |
|-------|--------|
| Identity | id, name, `locationTypeID` (Reference Data), `gardenID` |
| Position | optional `geographicPosition` |
| Environment | `LocationEnvironmentProfile` (setting; morning/midday/afternoon/evening sun; shade level; wind exposure; rain exposure; humidity; airflow; watering method; winter protection) |
| Notes | `locationDescription`, `notes` |

---

## 5. Relationships with other modules

| Module | Relationship |
|--------|--------------|
| **Trees** (§5.2) | Every Tree references exactly one Location; Location Detail's "Trees Here" card reuses `LocationInspectorTreeRow` and opens Tree Overview/Workspace, never edits Trees inline. |
| **Collections** (§5.4) | Organizational only — a Collection never sets or reads Location. |
| **Weather** (Dashboard) | Reads `profile.defaultGarden` position; `WeatherRiskAssessment.locationRisks` is the bridge that lets a Location's Environment Profile react to that forecast (see §3.3 limitation). |
| **Yamadori** (§5.10) | Wild-collection site GPS is **not** a Location — a bench Location is only assigned at graduation into a Tree. |
| **Storage** (file persistence) | Distinct concept entirely — "Locations" here means physical benches/shelves, never file paths. |

---

## 6. Explicit non-goals (this pass)

- Renaming "Locations" to "Habitat" anywhere in the UI.
- Per-Garden weather forecasting (each Garden getting its own live forecast) — noted as a known follow-up in §3.3 and §3.4.
- Location capacity, climate history, or automated watering — future expansion, not required to ship a durable, non-duplicated, multi-Garden-aware Locations module.

---

## 7. Summary

| # | Topic | Answer |
|---|-------|--------|
| 1 | **Naming** | Keep **Locations** in UI; **Habitat** stays an internal/roadmap term only. |
| 2 | **Persistence** | Garden and Location are real Library records (`Database/Gardens.json`, `Database/Locations.json`), migrated automatically from any pre-Library data. |
| 3 | **UI** | One detail column, not two competing tree lists. |
| 4 | **Environment** | Environment Profile is now visible and feeds live weather risk warnings. |
| 5 | **Multi-Garden** | Grower can browse any active Garden's Locations; new Locations default to the Garden being browsed. |
| 6 | **Known follow-up** | Weather forecasting itself remains single-Garden; per-Garden weather is future work. |
