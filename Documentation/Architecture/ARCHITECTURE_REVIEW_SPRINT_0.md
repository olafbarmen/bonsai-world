# Architecture Review — Sprint 0

**Product:** Bonsai World  
**Type:** Architecture review (documentation only)  
**Date:** 2026-08-01  
**Constraint:** No source code modified  

**Governing documents read (only)**

- [START_HERE.md](../START_HERE.md)
- [BONSAI_CONSTITUTION.md](../BONSAI_CONSTITUTION.md)
- [PRODUCT_BLUEPRINT.md](../PRODUCT_BLUEPRINT.md)
- [FALO_ARCHITECTURE.md](../../../Documentation/FALO_ARCHITECTURE.md)
- [Architecture/STORAGE_ARCHITECTURE.md](STORAGE_ARCHITECTURE.md) (non-governing appendix; strategy in Product Blueprint §3)
- [FALO_DESIGN_SYSTEM.md](../../../Documentation/FALO_DESIGN_SYSTEM.md)

This review compares the **current codebase** to those documents. It does not invent features or change product scope.

**Issue severity**

| Severity | Meaning |
|----------|---------|
| **Critical** | Must be fixed before Sprint 2 continues |
| **Important** | Should be fixed during Sprint 2 |
| **Future** | Can safely wait |

---

## Executive Summary

Bonsai World’s **documented architecture is strong**: Platform Independence (Constitution §7), explicit Domain / Services / Storage / Platform / UI layering (Blueprint), and a phased `StorageProvider` strategy (STORAGE_ARCHITECTURE). The **implementation is a solid macOS-first foundation** with a Falo-aligned shell, typed Reference Data, library create/open, and a partial Trees module.

The gap is compliance. The Platform layer is **documented but absent**. AppKit (`NSOpenPanel`, `NSImage`) lives in Services and in `TreeDetailView`, violating Constitution §7. Domain data still lives in **PreviewData** while the library package already stores files — a dual source of truth (Constitution §10). Tree botanical fields are **strings** while Reference Data is **UUID-hierarchical**. Tree Detail labels Lists “Locations” as “Location,” colliding with physical Locations.

**Verdict:** Foundations are worth keeping. **Do not expand Sprint 2 feature work** until Critical issues are resolved. Then deepen Trees / Locations / Collections on one persistence path and a real Platform boundary.

---

## Strengths

### Project structure

- Top-level folders match Blueprint intent: `App/`, `Core/`, `Storage/`, `ReferenceData/`, `Features/`, `Shared/`, `Images/`.
- Features are module-scoped; Shared holds reusable Detail, list, browser, and Quick Action building blocks (Falo Design System reuse).
- Storage is correctly isolated behind `StorageProvider` / `StorageService` (Features do not reference `LocalStorageProvider`).

### Architecture

- Domain models (`Tree`, `Location`, `Collection`) use Foundation only — no AppKit in Core/Domain.
- Physical hierarchy (World → Location → Tree) is distinct from organizational Collections (many-to-many).
- Reusable services exist and are environment-injected: `StorageService`, `LibraryService`, `ReferenceDataService`, `ImageService`, `ImageImportService`, `TreeNamingService`.
- First Launch Wizard correctly gates the main UI until a valid library is ready.

### Storage

- Phase 1 of STORAGE_ARCHITECTURE is present: provider protocol, local provider, service facade, library package layout, bookmarks for last library.
- Trees and `ImageAsset` store identifiers / relative paths — not absolute file paths.
- Cloud providers are correctly deferred.

### Reference Data

- Typed Lists models with `sortOrder` / `isActive`.
- Genus → Species → Cultivar hierarchy with cascading pickers.
- Single read facade (`ReferenceDataService`) — good hook for future editing behind a separate write API.

### Trees

- List → Detail flow; botanical naming service; primary image import via Storage; collection membership model is correct.
- Shared `TreeDetailToolbar` prepares Create/Edit HIG chrome.

### Design / shell

- `NavigationSplitView` with Workspace · Quick Actions · Tools matches Falo navigation and workspace philosophy.
- Shared design tokens (spacing, typography, radius); native window chrome.

---

## Critical Issues

Must be fixed before Sprint 2 continues.

### C1 — Platform layer missing

**Docs:** Constitution §7; Blueprint Platform Layer; START_HERE platform independence.

**Code:** `LibraryService` imports AppKit and uses `NSOpenPanel`; `ImageImportService` uses `NSOpenPanel` and `NSImage`; `TreeDetailView` imports AppKit and decodes with `NSImage`.

**Why Critical:** Services and Features own OS APIs. Every new picker or decode path will deepen macOS lock-in and block shared services for iPhone.

**Direction:** Platform protocols (directory pick, image pick, image inspect) + macOS adapters; Services depend on protocols; Features never import AppKit.

---

### C2 — Dual source of truth (PreviewData vs library)

**Docs:** Constitution §10 (one clear job / no parallel truth); STORAGE_ARCHITECTURE (Database in library package; models via provider).

**Code:** Trees, Locations, Collections, and image **metadata** live in session Preview catalogs; library on disk holds folders, `Library.json`, and image **bytes**; Save/Cancel on Trees are TODOs while Tree Detail mutates PreviewData on field change.

**Why Critical:** Expanding CRUD on PreviewData guarantees a rewrite when Database persistence arrives.

**Direction:** Decide Sprint 2 persistence (library Database vs explicit PreviewData sunset). Introduce store/repository protocols. Features must not treat PreviewData as the long-term product store.

---

### C3 — Tree botanical identity inconsistent with Reference Data

**Docs:** Blueprint Trees + Reference Data; maintainability / import compatibility.

**Code:** Reference Data uses UUID hierarchy (`Species.genusID`, `Cultivar.speciesID`); `Tree` stores `genus` / `species` / `cultivar` as `String`; UI resolves UUIDs then flattens to strings.

**Why Critical:** Breaks stable import/edit, rename of master data, and clean Database schema.

**Direction:** Prefer `genusID` / `speciesID` / `cultivarID` on Tree; derive display names via `TreeNamingService`; document Excel mapping before first persist.

---

### C4 — Location vs LocationReference collision

**Docs:** Blueprint Locations vs Storage terminology; User First clarity; Tree requires physical `locationID`.

**Code:** Tree Detail Growing section titles Lists vocabulary (`locationReferenceID`) as **“Location”**; New Tree correctly picks physical `locationID`.

**Why Critical:** Users and importers will confuse physical place with reference vocabulary; wrong field becomes “where the tree lives.”

**Direction:** Distinct labels (e.g. physical location vs location type/category); Tree Detail must edit physical `locationID`.

---

### C5 — Documentation / naming drift vs codebase

**Docs:** START_HERE — documentation is source of truth.

**Code / docs:** PRODUCT_BLUEPRINT §7 still says “Core storage is not implemented” while Phase 1 Storage **is** implemented; Xcode project/target still “Bonsai Hub”; empty `Features/Collection/` beside `Features/Collections/`.

**Why Critical:** Stale truth causes Sprint 2 to re-implement or ignore Storage.

**Direction:** Correct Blueprint status (Storage Phase 1 shipped; domain Database not); resolve Collection folder naming; plan Hub → World naming alignment.

---

## Important Improvements

Should be fixed during Sprint 2.

### I1 — TreeDetailView overload (~460 lines)

Owns form state, botanical mapping, PreviewData writes, image import, and AppKit decode. Violates clear separation of responsibilities.

**Fix:** Section views + coordinator / store API; Views present only.

### I2 — No transactional Save/Cancel

Chrome implies commit/discard; behavior is live PreviewData mutation with stub Save.

**Fix:** Draft → commit/discard over store protocols.

### I3 — Image metadata not persisted in the library

Bytes in `Images/Originals/`; `ImageAsset` catalog is session-only (`ImagePreviewData`).

**Fix:** Persist metadata with the library when domain persistence lands.

### I4 — File-system probes outside StorageProvider

`LibraryService` / related paths use `FileManager` existence checks. STORAGE_ARCHITECTURE: resolve locations inside the provider.

**Fix:** Expose existence/validation only via StorageProvider APIs.

### I5 — Images vs Gallery ownership underspecified

`Images/` peer subsystem; empty `Features/Gallery/`; Blueprint says Gallery prepared via Images.

**Fix:** Document: Images = media subsystem; Gallery consumes it — no second import path.

### I6 — Structural hygiene

Empty `Features/Collection/`; Hub vs World branding; empty `Core/Models/` / `Core/Cloud/` placeholders.

**Fix:** Remove duplicate Collection folder; align naming; leave Cloud empty until Phase 2+.

### I7 — Cross-platform contract realism

Stack is Swift + SwiftUI. Platform Independence means portable **contracts**, not a shared Android binary.

**Fix:** Treat Codable domain + StorageProvider + service protocols as the portable surface; Windows/Android = new UI + Platform/Storage adapters on the same library package shape.

### I8 — Missing focused tests

Library create/open validation and `TreeNamingService` are easy to regress.

**Fix:** Unit tests alongside persistence work.

---

## Future Improvements

Can safely wait.

| ID | Item |
|----|------|
| F1 | iCloud / OneDrive / Bonsai Cloud providers (STORAGE Phases 2–4) |
| F2 | Multi-library support |
| F3 | Smart / rule-based collections |
| F4 | Hero / thumbnail generation pipelines |
| F5 | Reference Data editing UI and live Excel import |
| F6 | Windows and Android UI clients |
| F7 | Populate `Core/Cloud/` |
| F8 | Deep Gallery, Projects, Journal, Tasks, Calendar |
| F9 | Settings → Library Location UI (config types already prepared) |
| F10 | Schema registry beyond Swift type names |

---

## Evaluation by Area

### 1. Project structure

| Topic | Assessment | Severity if issue |
|-------|------------|-------------------|
| Folder organization | Good match to Blueprint; Storage top-level correct | — |
| Naming consistency | Hub vs World; Collection vs Collections; Location label clash | Critical / Important |
| Feature organization | Active modules clear; empty placeholders need hygiene | Important |

### 2. Architecture

| Topic | Assessment | Severity if issue |
|-------|------------|-------------------|
| Separation of concerns | Domain clean; Views/Services leak platform & persistence | Critical |
| Layering | Documented well; Platform layer not implemented | Critical |
| Dependencies | Features → services good; AppKit into Features bad | Critical |
| Reusable services | Strong set; need Platform injection | Important |

### 3. Cross-platform readiness

| Target | Assessment |
|--------|------------|
| **macOS** | Current ship target; UI may stay SwiftUI/AppKit — OS APIs must move to Platform |
| **iPhone** | Share Domain/Services/Storage **after** AppKit extraction; new UI + Files/Photos adapters |
| **Windows** | Strategy only — new UI + StorageProvider + Platform; same library package |
| **Android** | Same as Windows — not a SwiftUI port |

**macOS-specific today:** `NSOpenPanel`, `NSImage`, security-scoped bookmarks, `UserDefaults` library bookmark, SwiftUI shell (UI layer acceptable).

### 4. Storage

| Topic | Assessment | Severity if issue |
|-------|------------|-------------------|
| Storage architecture | Phase 1 aligned with STORAGE_ARCHITECTURE | — |
| Library architecture | Create/open/validate + First Launch Wizard | — |
| Image architecture | IDs + relative paths correct; metadata session-only | Important |
| Future cloud readiness | Strategy ready; no premature cloud code | Future |

### 5. Reference Data

| Topic | Assessment | Severity if issue |
|-------|------------|-------------------|
| Architecture | Typed models + service facade | — |
| Extensibility | Empty lists reserved; good | — |
| Hierarchical data | Genus/Species/Cultivar working | — |
| Future editing | No write API — correct to defer | Future |
| Import compatibility | At risk until Tree stores stable IDs | Critical |

### 6. Trees module

| Topic | Assessment | Severity if issue |
|-------|------------|-------------------|
| Current strengths | List/detail, naming, image IDs, collections | — |
| Missing architecture | Store protocol, transactional Save, Platform-free views, physical Location on Detail | Critical / Important |
| Scalability | PreviewData + fat Detail will not scale | Critical / Important |

---

## Recommended Sprint 2 Adjustments

Do **not** open Sprint 2 with new modules (Tasks, Journal, Projects, etc.). Re-scope Sprint 2 to **architecture hardening**, then deepen Trees / Locations / Collections.

### Phase A — Unblock (Critical)

1. Platform protocols + macOS adapters; remove AppKit from Services and Features (**C1**).
2. Domain persistence decision + store/repository protocols; stop treating PreviewData as product storage (**C2**).
3. Tree botanical identity (UUID FKs) (**C3**).
4. Disambiguate Location vs LocationReference; edit physical `locationID` on Tree Detail (**C4**).
5. Correct Blueprint status and naming/folder hygiene (**C5**, **I6**).

### Phase B — Trees depth (Important)

1. Transactional Save/Cancel (**I2**).
2. Split Tree Detail (**I1**).
3. Persist image metadata in the library (**I3**).
4. StorageProvider as sole FS boundary (**I4**).
5. Clarify Images vs Gallery ownership (**I5**).
6. Focused tests (**I8**).
7. Document portable contracts for future clients (**I7**).

### Explicitly defer

Cloud providers, multi-library, smart collections, Gallery depth, Reference Data admin, Windows/Android clients, other Blueprint modules (**F1–F10**).

### Definition of ready for broader feature work

- No Feature imports AppKit/UIKit for pickers or decoding.
- Features use store/service APIs — not ad-hoc PreviewData as the long-term design.
- Tree taxonomy and Location terminology match Reference Data and the Blueprint.
- Product Blueprint status matches the codebase.

---

## Priority summary

| Priority | Items |
|----------|--------|
| **Critical** | C1 Platform layer · C2 Dual truth / persistence · C3 Botanical IDs · C4 Location terminology · C5 Doc/structure truth |
| **Important** | I1–I8 Tree Detail split, transactions, image metadata, FS boundary, Images/Gallery, hygiene, cross-platform contract note, tests |
| **Future** | F1–F10 Cloud, multi-library, smart collections, media pipelines, RD editing, other platforms, Core Cloud, later features, Settings location UI, schema registry |

---

*End of Sprint 0 architecture review. Documentation only — no code changes.*
