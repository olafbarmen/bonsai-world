# Bonsai World — Storage Architecture

**Status:** Technical appendix — **not a governing document**  
**Governing truth:** [PRODUCT_BLUEPRINT.md](../PRODUCT_BLUEPRINT.md) §3 (Storage philosophy) and [BONSAI_CONSTITUTION.md](../BONSAI_CONSTITUTION.md) (User Owns the Data, Platform Independence)  
**Extends:** [FALO_ARCHITECTURE.md](../../../Documentation/FALO_ARCHITECTURE.md)

This file keeps **detailed** phase notes, library package layout, and Settings location options for implementers. It must not contradict the Constitution or Product Blueprint. If strategy changes, update the Blueprint first, then this appendix.

**Do not implement additional cloud providers until an explicit implementation task.** Phase 1 local foundation (`StorageProvider`, `LocalStorageProvider`, `StorageService`) is in code under `Storage/`. This appendix may hold **prep contracts** (below) without enabling iCloud in the product.

---

## Purpose

- Expand the Blueprint’s storage philosophy for implementers.  
- Keep domain models storage-agnostic.  
- Support backends (iCloud, OneDrive, Bonsai Cloud) as additional **Storage Providers**.

---

## Scope

**In scope:** Phase details, `StorageProvider` rules, library location options, package structure, separation from Locations, Phase 2 prep contract.

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

**In progress (A1 + B2 + C1):** shared ubiquity container `iCloud.no.olafbarmen.BonsaiWorld` with package root `Documents/Bonsai World Library` on Mac and iPhone. First Launch / Settings offer **Use iCloud**; single-writer lease `Database/WriterLease.json` warns when another device wrote recently. ZIP remains the safety net. Not a CloudKit merge engine.

Optional iCloud-backed provider; same model contracts. Onboarding and Settings may enable iCloud Drive when the container is available.

### Phase 3 — Windows providers

Providers for Windows local / OneDrive (or equivalent) without model rewrites.

### Phase 4 — Bonsai Cloud

Dedicated cloud provider; same abstraction.

Workspace Profiles never select or fork providers.

---

## Phase 2 prep contract (not implemented)

Prep only — **no iCloud Drive Library Location, no CloudKit, no live sync** until the grower approves an implementation task. Goal: know what Phase 2 must satisfy so companion work does not invent a second library shape.

### Gates before enabling iCloud

1. Mac Library package layout and local repositories are stable (Phase 1 truth).  
2. Product decision: **companion readiness** (at least: what the iPhone app may read/write in v1) — do not promise “Mac and iPhone” sync in shipping UI before that.  
3. Explicit implementation task approved (this appendix is not that task).

### What `StorageProvider` must keep working

| Requirement | Why |
|-------------|-----|
| Same relative package paths (`Database/`, `Images/…`, documents, metadata) | Features stay path-agnostic; Mac and future clients share one package shape |
| Atomic whole-file writes for JSON/catalog blobs (as Phase 1 does today) | Avoid half-written libraries when a provider swaps backends |
| Opaque location config (kind + bookmark / equivalent) — no absolute paths in models | User-owned library; move/rename root without rewriting Trees |
| Fail closed when provider kind is not implemented (`providerUnavailable`) | `iCloudDrive` / `oneDrive` / `bonsaiCloud` stay non-selectable until real providers exist |

### One writer (v1 cloud)

Until a real sync engine exists, treat the library as **one active writer at a time**.

- Whole-file JSON replace is not safe if two Macs (or Mac + phone) edit the same files while cloud file replication is mid-flight.  
- Phase 2 **must not** ship as “open on two devices at once” without conflict rules.  
- Acceptable interim (only if later approved as a separate slice): library root in iCloud Drive with an explicit single-writer warning — **still not approved here**.

### Conflict (must be designed before multi-writer)

Any multi-device Phase 2+ needs an agreed policy before enablement, e.g.:

- last-writer-wins per file (weak; document risk), or  
- per-record merge with conflict surfacing in Settings / Library Management, or  
- device lock / “library in use elsewhere”.

Do not invent UI for this until the product choice is made. Export ZIP remains the safety net today.

### Package layout (shared contract)

Conceptual layout (names illustrative; match what `LocalStorageProvider` already ensures):

```text
Bonsai World Library/
  Database/          (Trees, Tasks, Work, stock, …)
  Images/
    Originals/
    Thumbnails/
    Hero/
  Documents/
  Library.json       (manifest / metadata)
  …
```

Models reference assets by ID / relative key. Features never build absolute paths. A future iCloud provider stores **the same package**, not a parallel schema.

### Out of scope for this prep note

- Enabling Settings → Library Location → **iCloud Drive**  
- Changing First Launch to create libraries in iCloud  
- CloudKit / push / conflict UI  
- iPhone app target  

Those require a separate, grower-approved implementation pass.

---

## Library package (planned)

See Phase 2 prep contract package layout above. Models reference assets by ID / relative key. Features never build absolute paths.

---

## Settings — Library Location (reserved)

Future Settings options choose where the library lives (local default, user folder, iCloud, etc.). Presentation is platform-native; semantics stay in Core. Phase 1 selectable kinds only: Internal SSD, External SSD, Custom Folder. Cloud kinds exist on `LibraryLocationKind` but remain non-selectable until providers ship.

---

## Locations vs Storage

**Locations** = physical places for trees. **Storage** = persistence of the library. Never conflate. See Product Blueprint.
