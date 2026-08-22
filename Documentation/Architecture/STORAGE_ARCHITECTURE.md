# Bonsai World — Storage Architecture

**Status:** Technical appendix — **not a governing document**  
**Governing truth:** [PRODUCT_BLUEPRINT.md](../PRODUCT_BLUEPRINT.md) §3 (Storage philosophy) and [BONSAI_CONSTITUTION.md](../BONSAI_CONSTITUTION.md) (User Owns the Data, Platform Independence)  
**Extends:** [FALO_ARCHITECTURE.md](../../../Documentation/FALO_ARCHITECTURE.md)

This file keeps **detailed** phase notes, library package layout, and Settings location options for implementers. It must not contradict the Constitution or Product Blueprint. If strategy changes, update the Blueprint first, then this appendix.

**Do not implement additional cloud providers or database persistence until an explicit implementation task.** Phase 1 local foundation (`StorageProvider`, `LocalStorageProvider`, `StorageService`) is in code under `Storage/`.

---

## Purpose

- Expand the Blueprint’s storage philosophy for implementers.  
- Keep domain models storage-agnostic.  
- Support backends (iCloud, OneDrive, Bonsai Cloud) as additional **Storage Providers**.

---

## Scope

**In scope:** Phase details, `StorageProvider` rules, library location options, package structure, separation from Locations.

**Out of scope:** Concrete Swift APIs, database engine choice, schemas, UI mockups beyond Settings option names.

Product feature scope remains in the Product Blueprint.

---

## Relationship to Core ownership

| Concern | Owner |
|---------|--------|
| Physical places | **Locations** feature |
| Local persistence | **Core Storage** (Phase 1) |
| Cloud persistence | **Core Cloud** (Phases 2–4) |

Features use storage through Core. They must not redefine how files are stored or resolve absolute paths themselves.

---

## Architecture principles

### 1. StorageProvider abstraction

All file and library blob operations go through a **StorageProvider** (save/load/delete image and document, and equivalents). The active provider follows the user’s Library Location. The app depends on the abstraction, not a backend.

### 2. Storage independence

Adding OneDrive or Bonsai Cloud means adding a provider — not changing Tree, Image, or Document models, and not teaching Views new path schemes.

### 3. No direct file-path access outside Storage

No View, Model, or Feature may directly access file paths. Only Core storage resolves real locations.

### 4. Models store identity, not location

Models may store stable identifiers and/or **relative** keys inside the library package only.

### 5. User-owned library

Data lives in a Bonsai World Library whose root is chosen in Settings (when shipped).

### 6. Document before implement

Large storage work: discuss → update Blueprint → approve → implement. This appendix follows.

---

## Roadmap (detail)

### Phase 1 — Local Storage

Fully functional macOS app using **local storage only**. `StorageService` + `LocalStorageProvider`. Default library under Application Support (or user-chosen folder). No cloud.

### Phase 2 — iCloud

Optional iCloud-backed provider; same model contracts.

### Phase 3 — Windows providers

Providers for Windows local / OneDrive (or equivalent) without model rewrites.

### Phase 4 — Bonsai Cloud

Dedicated cloud provider; same abstraction.

Workspace Profiles never select or fork providers.

---

## Library package (planned)

Conceptual layout (names illustrative):

```text
Bonsai World Library/
  Database/          (or equivalent store)
  Images/
    Originals/
    Thumbnails/
    Hero/
  Documents/
  …
```

Models reference assets by ID / relative key. Features never build absolute paths.

---

## Settings — Library Location (reserved)

Future Settings options choose where the library lives (local default, user folder, iCloud, etc.). Presentation is platform-native; semantics stay in Core.

---

## Locations vs Storage

**Locations** = physical places for trees. **Storage** = persistence of the library. Never conflate. See Product Blueprint.
