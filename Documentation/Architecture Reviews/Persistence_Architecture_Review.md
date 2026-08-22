# Bonsai World — Persistence Architecture Review

**Date:** 22 August 2026  
**Type:** Persistence architecture review (analysis only)  
**Constraint:** No source code modified  

**Governing documents read**

- [README.md](../../README.md)
- [START_HERE.md](../START_HERE.md)
- [BONSAI_CONSTITUTION.md](../BONSAI_CONSTITUTION.md)
- [PRODUCT_BLUEPRINT.md](../PRODUCT_BLUEPRINT.md)
- [STORAGE_ARCHITECTURE.md](../Architecture/STORAGE_ARCHITECTURE.md) (non-governing appendix)

**Objective:** Document exactly how Bonsai World stores and loads data today, before any migration work begins.

---

## Executive Summary

Bonsai World operates with a **split persistence model**. The library package infrastructure (`StorageService` → `LocalStorageProvider` → Bonsai World Library folder) is real and used for manifest metadata, image bytes, image catalog, measurement history, and photo index. Core domain entities — **Trees, Collections, Locations, and Reference Data** — remain **session-only in memory**, seeded from static preview catalogs on every launch.

**Gardens** and **regional Settings** persist in **UserDefaults**, outside the library package. This creates a **split brain**: photo bindings and measurement history survive app restart, but the Trees they reference revert to seed data unless IDs happen to match.

The correct long-term model (per Product Blueprint §3) is: all library-owned data through `StorageProvider`, models holding IDs only, Features never touching paths. The repository seam (`TreeRepository`) is already in place for Trees. Migration should extend that pattern incrementally — not rewrite the storage layer.

---

## Current Storage Topology

```text
┌─────────────────────────────────────────────────────────────────────────┐
│                         Bonsai World Library (disk)                      │
│  Library.json                    ← manifest (persisted)                  │
│  Database/                                                               │
│    TreeMeasurementHistory.json   ← persisted                             │
│    TreePhotoIndex.json           ← persisted (interim)                   │
│  Images/                                                                 │
│    Catalog.json                  ← persisted (ImageAsset metadata)     │
│    Originals/{uuid}.{ext}        ← persisted (image bytes)               │
└─────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────┐
│                    UserDefaults (app install scope)                      │
│  bonsai.world.lastLibraryBookmark  ← library location bookmark         │
│  falo.userProfile.v1               ← name, email, language, gardens      │
│  falo.appSettings.*                ← currency, units, date/time format   │
│  falo.treeList.visibleColumnIDs    ← tree list column prefs              │
└─────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────┐
│                    In-memory only (session / seed)                       │
│  PreviewData                       ← Trees, Collections, bonsai sequences│
│  ReferencePreviewData              ← all Reference Data incl. Locations  │
│  (static *PreviewData.swift seeds) ← initial values on every cold start  │
└─────────────────────────────────────────────────────────────────────────┘
```

---

## Domain Analysis

### 1. Trees

| Question | Answer |
|----------|--------|
| **Where stored today?** | In-memory array `PreviewData.trees`. Loaded from hard-coded seed (`PreviewData.makeImportedTrees()`) on every app launch. |
| **Persisted or session-only?** | **Session-only.** No `Database/Trees.json` or equivalent exists. |
| **Load owner** | `PreviewTreeRepository` → reads `PreviewData.trees`. `TreeService.init` additionally merges photo bindings from `TreePhotoIndexStore.apply(to:)` and writes reconciled trees back via `repository.updateTree`. |
| **Save owner** | `PreviewTreeRepository` → `PreviewData.insertTree` / `replaceTree` / `removeTree`. All writes are in-memory. `TreeService` orchestrates creates/updates and also calls `TreePhotoIndexStore.saveBinding` on every tree write. |
| **PreviewData involved?** | **Yes — sole store.** `PreviewTreeRepository` is a thin wrapper. |
| **Duplicate storage?** | **Yes.** (1) `Tree.imageIDs` / `primaryImageID` on the Tree record in PreviewData. (2) `TreePhotoIndexStore` persists the same bindings to `Database/TreePhotoIndex.json`. (3) Denormalized latest measurement fields on Tree (`heightMillimetres`, etc.) duplicate the latest entry in `TreeMeasurementHistoryStore`. |
| **Single source of truth?** | **No.** Trees are authoritative in-session only. Photo bindings have a persisted shadow copy that wins on startup reconciliation. Latest measurements exist on both Tree and history file. |

**Additional notes:** `PreviewData.speciesBonsaiNameSequenceHighWater` (Bonsai Name sequence per species) is also session-only. Deleting and recreating trees in a new session can reuse sequences incorrectly.

---

### 2. Collections

| Question | Answer |
|----------|--------|
| **Where stored today?** | In-memory array `PreviewData.collections`, seeded by `PreviewData.makeCollections()`. |
| **Persisted or session-only?** | **Session-only.** |
| **Load owner** | `PreviewData.init` (seed). `TreeService.collections` reads `catalog.collections` (the same `PreviewData` instance). |
| **Save owner** | `PreviewData.addCollection`, `toggleMembership`, `ensureMembership`, `insertTree` / `replaceTree` (membership sync). `TreeService.addCollection`, `toggleMembership`, `addTreesToCollection` delegate to PreviewData. |
| **PreviewData involved?** | **Yes — sole store.** |
| **Duplicate storage?** | **Yes — bidirectional membership.** `Tree.collectionIDs` and `Collection.treeIDs` must stay manually in sync. `PreviewData` maintains both sides in `toggleMembership`, `insertTree`, `replaceTree`, `removeTree`. |
| **Single source of truth?** | **No.** Two mirrored fields with manual sync logic in PreviewData. No persisted authority. |

---

### 3. Locations

| Question | Answer |
|----------|--------|
| **Where stored today?** | `ReferencePreviewData.locations` — in-memory array seeded from `LocationReferencePreviewData.all`. |
| **Persisted or session-only?** | **Session-only.** Settings edits and New Location workflows mutate memory only. |
| **Load owner** | `ReferencePreviewData.init` loads static seed. `ReferenceDataService.locations` reads filtered/sorted from store. `ReferenceDataManager.locations(inGarden:)` reads store directly. |
| **Save owner** | `ReferenceDataManager.saveLocation` / `updateLocationPosition` / `setActive` / `delete` mutate `ReferencePreviewData.locations` in memory. Location editor sheets call the manager. |
| **PreviewData involved?** | **Yes** — via `ReferencePreviewData` (not `PreviewData`). |
| **Duplicate storage?** | **No duplicate file**, but Locations are conceptually a **domain entity** stored inside the Reference Data aggregate rather than as a first-class library database record. |
| **Single source of truth?** | **In-session only.** `ReferencePreviewData.locations` is authoritative until quit. Trees hold `locationID` FK references that become orphaned or wrong after restart if IDs change. |

**FK dependencies:** Each `LocationReference` requires `gardenID` (→ Gardens) and `locationTypeID` (→ Reference Data Location Types).

---

### 4. Gardens

| Question | Answer |
|----------|--------|
| **Where stored today?** | `UserProfileStore.gardens` — encoded as part of `PersistedProfile` in UserDefaults key `falo.userProfile.v1`. |
| **Persisted or session-only?** | **Persisted** — but in **UserDefaults**, not in the Bonsai World Library package. |
| **Load owner** | `UserProfileStore.loadOrCreate()` on app init. Falls back to seed garden (`GardenSeed.defaultGardenID`) with legacy address migration. |
| **Save owner** | `UserProfileStore.saveGarden`, `setDefaultGarden`, `setGardenActive`, `deleteGarden`, `updateGardenPosition` — all call `persistIfNeeded()` → UserDefaults. |
| **PreviewData involved?** | **No.** `GardenSeed.defaultGardenID` is a stable UUID used by location seed data. |
| **Duplicate storage?** | **Conceptual split:** Gardens live outside the library while Locations (which reference `gardenID`) will eventually need library persistence. Location seed data hard-codes `GardenSeed.defaultGardenID`. |
| **Single source of truth?** | **Yes for Gardens themselves** — UserDefaults is the only store. **No** for the overall Habitat model because Locations are not co-located. |

---

### 5. Reference Data

Reference Data covers many list types. All share one in-memory aggregate.

| Question | Answer |
|----------|--------|
| **Where stored today?** | `ReferencePreviewData` — single `@Observable` object holding arrays for genus, species, cultivars, styles, pot types, soil mixes, locations, suppliers, etc. Initial values from static `*PreviewData.swift` seed files under `ReferenceData/PreviewData/`. |
| **Persisted or session-only?** | **Session-only** for all lists. |
| **Load owner** | `ReferencePreviewData.init` (static seeds). `ReferenceDataService` (read-only pickers). `BotanicalService` (botanical hierarchy reads). |
| **Save owner** | `ReferenceDataManager` (flat lists, soil mixes, work types, locations). `BotanicalService` (genus/species/cultivar CRUD). Both mutate `ReferencePreviewData` and call `store.noteMutation()`. |
| **PreviewData involved?** | **Yes** — `ReferencePreviewData` is the runtime store (distinct from tree `PreviewData`). |
| **Duplicate storage?** | Trees store denormalized `botanicalName` string plus FK IDs (`genusID`, `speciesID`, `cultivarID`). Reference names can drift from master data within a session but reset on cold start anyway. |
| **Single source of truth?** | **In-session only.** Settings is the intended edit home; changes are lost on quit. |

**Special cases:**

- **Botanical Library** (Genus → Species → Cultivar): `BotanicalService` owns writes; explicitly documented as no persistence.
- **Locations**: saved via dedicated `ReferenceDataManager.saveLocation` (not flat `save(_:in:)` for `.locations` category).
- **Soil Mixes / Work Types**: dedicated save methods with validation.

---

### 6. Measurements

| Question | Answer |
|----------|--------|
| **Where stored today?** | (1) **History:** `Database/TreeMeasurementHistory.json` via `TreeMeasurementHistoryStore`. (2) **Latest values:** denormalized fields on `Tree` in PreviewData (`heightMillimetres`, `crownWidthMillimetres`, `nebariWidthMillimetres`, `trunkDiameterMillimetres`). Pot dimensions are **not** in history — they live on Tree only. |
| **Persisted or session-only?** | **History: persisted.** Latest-on-Tree: **session-only** (part of PreviewData). |
| **Load owner** | `TreeMeasurementHistoryStore.reload()` on init — reads JSON via `StorageService.loadPackageFile`. Tree latest fields loaded with Trees from PreviewData seed. |
| **Save owner** | `TreeMeasurementHistoryStore.append` → `persist()`. `TreeService.applyLatestMeasurement` updates Tree via repository. New Tree workflow and Add Measurement sheet call history store + tree service. `ensureMigrated(from:)` seeds history from Tree fields once. |
| **PreviewData involved?** | **Indirectly** — latest values on Tree are in PreviewData. History store is independent. |
| **Duplicate storage?** | **Yes.** Latest measurement exists in both history file (as most recent record) and Tree denormalized fields. They can diverge within a session if one path is updated without the other. |
| **Single source of truth?** | **History file is authoritative for timeline.** Tree fields are a performance/display cache — but that cache is not persisted today. |

---

### 7. Photos

| Question | Answer |
|----------|--------|
| **Where stored today?** | (1) **Metadata:** `Images/Catalog.json` via `ImagePreviewData`. (2) **Bytes:** `Images/Originals/{uuid}.{ext}` via `StorageService.saveImage`. (3) **Tree bindings:** `Tree.primaryImageID` + `Tree.imageIDs` in PreviewData; mirrored in `Database/TreePhotoIndex.json` via `TreePhotoIndexStore`. (4) **Catalog primary flag:** `ImageAsset.isPrimary` in catalog (cleared/set by import). |
| **Persisted or session-only?** | **Metadata, bytes, and photo index: persisted.** Tree-embedded IDs: **session-only** (PreviewData) but reconciled from index on startup. |
| **Load owner** | `ImagePreviewData.init` → `loadFromDisk`. `TreePhotoIndexStore.reload()` on init. `TreeService.init` applies index to trees. `ImageService` reads catalog for display. |
| **Save owner** | `ImageImportService.importImage` → storage bytes + catalog upsert. `TreeService.createTree` / `updateTree` → photo index save. `ImageService.deletePhoto` → bytes + catalog. Tree detail edits photo membership via TreeService. |
| **PreviewData involved?** | **Yes** — `ImagePreviewData` (misleading name; it **is** persisted). Tree image ID arrays in tree `PreviewData`. |
| **Duplicate storage?** | **Yes — triple state for bindings:** Tree.imageIDs, TreePhotoIndex.json, and ImageAsset.isPrimary. Membership can disagree across the three until reconciliation. |
| **Single source of truth?** | **Partial.** Image bytes + metadata catalog are persisted and coherent. Tree ↔ image **membership** is split between session Tree records and persisted index; startup reconciliation favours the index. |

---

### 8. Settings

Settings spans several concerns with different persistence homes:

| Sub-domain | Store | Location | Persisted? |
|------------|-------|----------|------------|
| **Regional preferences** (currency, units, date/time) | `AppSettings` | UserDefaults (`falo.appSettings.*`) | Yes (app scope) |
| **User profile** (name, email, language) | `UserProfileStore` | UserDefaults (`falo.userProfile.v1`) | Yes (app scope) |
| **Gardens** | `UserProfileStore.gardens` | Same UserDefaults blob | Yes (app scope) |
| **Tree list columns** | `TreeListColumnConfiguration` | UserDefaults (`falo.treeList.visibleColumnIDs`) | Yes (app scope) |
| **Library location** | `StorageService` | UserDefaults (`bonsai.world.lastLibraryBookmark`) + security-scoped bookmark | Yes (app scope) |
| **Library manifest** | `LibraryService` | `Library.json` in library package | Yes (library scope) |
| **Reference Data edits** | `ReferencePreviewData` | Memory | **No** |
| **Workspace Profile** | — | Not implemented | — |
| **Library location picker UI** | `LibraryService` | First Launch Wizard only | Partial |

| Question | Answer |
|----------|--------|
| **Where stored today?** | Split across UserDefaults and library manifest as above. |
| **Persisted or session-only?** | **Mixed.** Preferences and profile persist outside library. Reference Data edits do not. |
| **Load owner** | Each store loads independently in `Bonsai_HubApp.init`. |
| **Save owner** | `AppSettings` (didSet → UserDefaults). `UserProfileStore` (mutation → UserDefaults). `LibraryService` (manifest → StorageService). `ReferenceDataManager` / `BotanicalService` (memory only). |
| **PreviewData involved?** | Reference Data yes; other settings no. |
| **Duplicate storage?** | Legacy migration: garden address was once in AppSettings, now in UserProfileStore. |
| **Single source of truth?** | Per sub-domain yes; **no unified Settings persistence model** yet. Blueprint reserves library location in Settings — not fully shipped. |

---

## Cross-Domain Dependencies

```text
Garden (UserDefaults)
  └── LocationReference.gardenID
        └── Tree.locationID (required FK)
              ├── Tree.collectionIDs ↔ Collection.treeIDs
              ├── Tree.genusID / speciesID / cultivarID → Botanical Reference Data
              ├── Tree.styleID, sizeClassID, treeStatusID, potTypeID, lightConditionID,
              │     soilMixID, acquisitionMethodID, disposalMethodID → flat Reference Data
              ├── Tree.imageIDs / primaryImageID → ImageAsset (Catalog.json) + bytes
              │     └── TreePhotoIndex.json (mirror)
              └── TreeMeasurementRecord.treeID → TreeMeasurementHistory.json

LocationReference.locationTypeID → LocationType (Reference Data)

ImageAsset.id ← referenced by Tree bindings (no FK enforcement)

Collection.treeIDs → Tree.id (logical FK; no cascade on delete)

GrowingIntelligenceService → TreeService + ReferenceDataService + UserProfileStore (read-only consumers)
```

### Dependency matrix

| From | To | Relationship | Risk if split persistence continues |
|------|----|--------------|--------------------------------------|
| Tree | Location | Required UUID FK | Orphan references after location edits; seed mismatch on restart |
| Tree | Collection | Many-to-many (dual-written) | Membership lost on restart; sync bugs |
| Tree | Reference Data | Many optional UUID FKs | Picker labels break if seed IDs change |
| Tree | ImageAsset | UUID refs | Persisted photos reference seed tree IDs that may not exist next session |
| Tree | Measurement history | treeID | History survives but trees reset — **orphaned measurement records** |
| Tree | TreePhotoIndex | treeID | Index survives but trees reset — **orphaned bindings** |
| Location | Garden | Required gardenID | Garden in UserDefaults; Location in memory — **split Habitat model** |
| Location | LocationType | Required type FK | Type list session-only |
| Collection | Tree | treeIDs | Same as Tree ↔ Collection |

---

## Architectural Risks

| Risk | Severity | Description |
|------|----------|-------------|
| **Split brain (core domain vs library)** | Critical | Measurements, photos, and bindings persist; Trees and Collections do not. Restart produces orphaned library data and user-visible data loss. |
| **Dual membership sync** | Important | `Tree.collectionIDs` ↔ `Collection.treeIDs` maintained manually in PreviewData — error-prone when persistence lands. |
| **Triple photo binding state** | Important | Tree, photo index, and catalog primary flag can disagree. |
| **Gardens outside library** | Important | Habitat model split across UserDefaults and (future) library Locations. Multi-machine / library-move scenarios break. |
| **Reference Data ephemeral** | Important | Settings work lost every session; undermines Constitution §9 (Reference Data is master data). |
| **Misleading PreviewData naming** | Minor | `ImagePreviewData` persists; `PreviewData` sounds preview-only but is the runtime tree store. |
| **Best-effort persist errors swallowed** | Minor | History, catalog, and index stores catch errors silently — corruption may go unnoticed. |
| **Bonsai Name sequence not persisted** | Important | Sequence high-water mark lost on restart. |

---

## Migration Plan

Incremental steps. Each step has a clear objective, is independently testable, avoids breaking existing behaviour, and reduces debt. **Do not rewrite StorageService or the provider abstraction** — extend it.

---

### Step 1 — Persist Trees to the library package

**Objective:** Implement `LibraryTreeRepository` conforming to `TreeRepository`, reading/writing `Database/Trees.json` via `StorageService`. Swap it in at app composition instead of `PreviewTreeRepository`.

**Behaviour:**
- On first open (file missing): seed once from current `PreviewData.makeImportedTrees()`, persist immediately, then use file as source.
- On subsequent launches: load from file only (no re-seed).
- `TreeService` API unchanged.

**Test:** Create a tree with a unique nickname → quit app → relaunch → tree still present. Edit tree → quit → relaunch → edits preserved.

**Debt reduced:** Closes the largest split-brain gap; aligns with existing repository seam.

---

### Step 2 — Persist Bonsai Name sequence high-water marks

**Objective:** Save `speciesBonsaiNameSequenceHighWater` to `Database/BonsaiNameSequences.json` (or envelope field in Trees file). Load on startup; update on tree create/delete.

**Test:** Create tree for a species → note sequence N → delete tree → create another → sequence is N+1, not reused.

**Debt reduced:** Identity generation survives restart.

---

### Step 3 — Persist Collections with unified membership authority

**Objective:** Add `Database/Collections.json` and a `CollectionRepository`. Move membership writes to repository layer with **one authoritative representation** (recommend: Collection owns `treeIDs`; Tree `collectionIDs` computed or synced on read/write in repository only — not in Views).

**Test:** Create collection, add tree membership → quit → relaunch → collection and membership intact. Toggle membership from Tree detail and Collection detail → both views agree.

**Debt reduced:** Eliminates dual-write in PreviewData for collections.

---

### Step 4 — Co-locate Gardens in the library package

**Objective:** Move `Garden` records from UserDefaults to `Database/Gardens.json` (or `Database/UserProfile.json` including profile fields). Migrate existing UserDefaults data on first launch. Keep `UserProfileStore` as the API; change its backing store.

**Test:** Edit garden name/position → quit → relaunch → preserved. Existing UserDefaults gardens migrate once.

**Debt reduced:** Habitat geographic root lives with the library the user owns (Constitution §12).

---

### Step 5 — Persist Locations to the library

**Objective:** Persist `LocationReference` records to `Database/Locations.json`. `ReferenceDataManager.saveLocation` writes through a small `LocationStore` using StorageService. Seed from `LocationReferencePreviewData` only when file empty **and** default garden exists.

**Test:** Create New Location from New Tree dialog → quit → relaunch → location available in pickers. Map position edits survive restart.

**Debt reduced:** Physical hierarchy (Garden → Location → Tree) fully library-backed.

---

### Step 6 — Persist flat Reference Data lists

**Objective:** One JSON file per category (or a single `Database/ReferenceData.json` with typed sections). Wire `ReferenceDataManager` flat saves and `setActive`/`delete` to persist. Exclude botanical hierarchy (Step 7).

**Test:** Add a Style in Settings → quit → relaunch → style appears in Tree pickers.

**Debt reduced:** Master data edits survive restart (Constitution §9).

---

### Step 7 — Persist Botanical Library

**Objective:** Persist genus/species/cultivar to `Database/BotanicalLibrary.json` (hierarchical). Wire `BotanicalService` mutations to persist.

**Test:** Add cultivar → quit → relaunch → available in New Tree botanical picker.

**Debt reduced:** Botanical identity source of truth is durable.

---

### Step 8 — Consolidate photo bindings into Tree records

**Objective:** With Trees persisted, make `Tree.imageIDs` / `primaryImageID` authoritative. On migration load, merge `TreePhotoIndex.json` into Trees once, then stop dual-writing. Deprecate index file (keep read-only migration path for one release).

**Test:** Import photos, set primary, reorder gallery → quit → relaunch → gallery intact without index file. Existing libraries with index-only data migrate cleanly.

**Debt reduced:** Removes triple binding state.

---

### Step 9 — Clarify measurement latest-value strategy

**Objective:** Document and implement one rule: history file owns timeline; Tree latest fields are a denormalized cache updated only via `TreeService.applyLatestMeasurement` / history append. Persist Tree fields as part of Step 1. Add startup check: if Tree latest disagrees with history latest, prefer history.

**Test:** Add measurement → Tree list shows new height → quit → relaunch → list and history agree.

**Debt reduced:** Single rule for latest vs history.

---

### Step 10 — Retire PreviewData as runtime store

**Objective:** Remove tree/collection arrays from `PreviewData` (or rename to `SeedData` used only for first-run seeding). Keep static seed files for development previews in SwiftUI `#Preview` only.

**Test:** Full regression: all modules load from library JSON. Previews still work with in-memory fixtures.

**Debt reduced:** Naming and architecture match Blueprint intent.

---

### Step 11 — Settings: library vs machine scope (optional polish)

**Objective:** Confirm which Settings belong in library (`Database/Settings.json` — e.g. nothing yet) vs app install (UserDefaults — regional units, window prefs). Document decision in Blueprint. Move tree list column prefs if they should travel with library.

**Test:** Open library on second machine (future) — domain data intact; machine prefs independent.

**Debt reduced:** Clear ownership before cloud/multi-device.

---

## Recommended Migration Order

Steps 1 → 2 → 3 address the critical path (Trees, identity, Collections). Steps 4 → 5 complete Habitat. Steps 6 → 7 complete Reference Data. Steps 8 → 9 clean up duplication. Steps 10 → 11 finish retirement and scope clarity.

**Do not parallelize Steps 1 and 8** — photo consolidation depends on persisted Trees.

---

## Files Analysed

### Governing documentation
- `README.md`
- `Documentation/START_HERE.md`
- `Documentation/BONSAI_CONSTITUTION.md`
- `Documentation/PRODUCT_BLUEPRINT.md`
- `Documentation/Architecture/STORAGE_ARCHITECTURE.md`

### App composition
- `Bonsai Hub/App/Bonsai_HubApp.swift`

### Storage layer
- `Bonsai Hub/Storage/Services/StorageService.swift`
- `Bonsai Hub/Storage/Services/LibraryService.swift`
- `Bonsai Hub/Storage/Providers/LocalStorageProvider.swift`
- `Bonsai Hub/Storage/Protocols/StorageProvider.swift`
- `Bonsai Hub/Storage/Models/Library.swift`

### Domain — Trees & Collections
- `Bonsai Hub/Core/Domain/Tree.swift`
- `Bonsai Hub/Core/Domain/Collection.swift`
- `Bonsai Hub/Core/Services/TreeService.swift`
- `Bonsai Hub/Core/Repositories/RepositoryProtocols.swift`
- `Bonsai Hub/Core/Repositories/PreviewTreeRepository.swift`
- `Bonsai Hub/Shared/PreviewData/PreviewData.swift`

### Domain — Habitat
- `Bonsai Hub/Core/Profile/Garden.swift`
- `Bonsai Hub/Core/Profile/UserProfileStore.swift`
- `Bonsai Hub/ReferenceData/Models/LocationReference.swift`
- `Bonsai Hub/ReferenceData/PreviewData/LocationReferencePreviewData.swift`

### Reference Data
- `Bonsai Hub/ReferenceData/PreviewData/ReferencePreviewData.swift`
- `Bonsai Hub/ReferenceData/Services/ReferenceDataService.swift`
- `Bonsai Hub/ReferenceData/Services/ReferenceDataManager.swift`
- `Bonsai Hub/ReferenceData/Services/BotanicalService.swift`

### Measurements
- `Bonsai Hub/Core/Services/TreeMeasurementHistoryStore.swift`

### Photos
- `Bonsai Hub/Images/PreviewData/ImagePreviewData.swift`
- `Bonsai Hub/Images/Services/ImageService.swift`
- `Bonsai Hub/Images/Services/ImageImportService.swift`
- `Bonsai Hub/Images/Services/TreePhotoIndexStore.swift`
- `Bonsai Hub/Images/Models/TreePhotoIndex.swift`

### Settings
- `Bonsai Hub/Core/Settings/AppSettings.swift`
- `Bonsai Hub/Features/Trees/TreeListColumnConfiguration.swift`

---

## Summary for Implementation Planning

| Item | Value |
|------|-------|
| **Current persistence architecture** | Hybrid: library package persists manifest, images (bytes + catalog), measurement history, and interim photo index; core domain (Trees, Collections, Locations, Reference Data) is session-only via PreviewData aggregates; Gardens and app preferences in UserDefaults. |
| **Highest architectural risk** | **Split brain** — persisted measurements and photos reference Tree IDs that reset to seed data on every cold start, causing data loss and orphaned library files. |
| **Recommended first implementation step** | **Step 1: `LibraryTreeRepository` + `Database/Trees.json`** — swap behind existing `TreeRepository` protocol without changing Features or TreeService public API. |
