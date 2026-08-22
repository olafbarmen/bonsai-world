# Sprint 2 — Trees Foundation

**Status:** Official implementation plan  
**Theme:** Complete the Trees module as the center of individual tree records  
**Aligns with:** [ROADMAP.md](../ROADMAP.md) (NEXT — solidify Trees), [ARCHITECTURE_REVIEW_SPRINT_0.md](../Architecture/ARCHITECTURE_REVIEW_SPRINT_0.md) (Critical + Trees Important), [PRODUCT_BLUEPRINT.md](../PRODUCT_BLUEPRINT.md)  
**Authority:** Subordinate to Constitution and Product Blueprint. This file is a **sprint plan**, not a sixth product document.

**Constraint:** macOS-first. Respect Platform Independence. No cloud. No new feature modules.

---

## 1. Sprint Goal

After Sprint 2, a grower using Bonsai World on Mac can:

1. **Create** a new tree with botanical classification, physical location, growing/history fields, and optional display name — then **Save** so it remains after relaunch.
2. **Browse** their trees in the Trees list and open any tree’s **Detail**.
3. **Edit** tree fields with clear **Save** / **Cancel** (draft → commit or discard) — no silent half-saved state.
4. Choose **where the tree lives** (physical Location) without confusing it with reference “location type” vocabulary.
5. Set **Genus → Species → Cultivar** against Reference Data using stable IDs; see a correct botanical name.
6. **Add or change a primary image** from Finder; the image and its metadata belong to the library and survive relaunch.
7. Manage **Collection membership** for a tree in a way that is consistent with saved tree data (session membership may remain interim only where Collections themselves are not yet persisted — see Scope).

Sprint 2 ends when Trees is a trustworthy local workflow inside an open Bonsai World Library — not when every Blueprint module exists.

---

## 2. Scope

### In scope

| Area | Included |
|------|----------|
| **Trees UX** | List overview, New Tree, Tree Detail, primary image, collection membership from Tree Detail |
| **Tree model** | Botanical identity via Reference Data UUIDs; physical `locationID`; reference fields; image IDs; display name |
| **Persistence (Trees-focused)** | Persist Trees (and whatever Locations / image metadata Trees require to remain consistent) into the library — ending PreviewData as the long-term store for Trees |
| **Platform (Trees-enabling)** | Extract folder/image pickers and image decode out of Services/Features into a Platform layer (macOS adapters only) |
| **Terminology** | Disambiguate physical Location vs LocationReference in Trees UI |
| **Architecture hygiene for Trees** | Split overloaded Tree Detail; transactional Save/Cancel; Features free of AppKit |
| **Documentation** | Update Blueprint / Changelog for what ships; clarify Images vs Gallery ownership in docs |
| **Quality** | Focused tests for naming + library/tree persistence paths touched this sprint |

### Supporting work allowed only as Trees dependencies

- Minimal **Locations** read/write needed so every tree has a valid physical place.
- **Platform** adapters required by library/image pickers used by Trees and First Launch.
- **Store/repository** protocols introduced for Trees (PreviewData may remain a temporary adapter only until replaced).

---

## 3. Out of Scope

Deliberately postponed — do not implement in Sprint 2:

| Item | Reason |
|------|--------|
| **Projects** | Separate module (ROADMAP LATER) |
| **Calendar** | Separate module (ROADMAP LATER) |
| **Tasks** | Separate module (ROADMAP NEXT, after Trees) |
| **Journal** | Separate module |
| **Dashboard** beyond current placeholder | Calm overview later |
| **Gallery module** (full visual browser) | Images subsystem supports Trees only; Gallery UI later |
| **Settings** / Library Location UI | Config types exist; Settings module later |
| **Cloud synchronization** | STORAGE Phases 2–4; SOMEDAY |
| **iCloud / OneDrive / Bonsai Cloud providers** | Explicitly deferred |
| **Mobile app** (iPhone / Android) | Architecture ready later; no client this sprint |
| **Windows application** | Future Platform + UI |
| **Multi-library** | Single library only |
| **Smart collections** | Manual membership only |
| **Reference Data editing / Excel live import** | Read-only Reference DataService |
| **Search / sort / advanced Tree Browser as primary UX** | List is primary; Browser retained, not the sprint focus |
| **Thumbnails / Hero derivatives** | Originals + display from bytes only |
| **Duplicate / Export / Delete tree** | Toolbar placeholders may remain disabled |
| **Full Collections persistence** | Only as required for Tree membership consistency; Collections module depth is not the sprint goal |
| **Xcode project rename Hub → World** | Optional hygiene; not a success gate |

---

## 4. Sprint Backlog

Agreed tasks, ordered by dependency. Implement in sequence unless noted parallel-safe.

---

### T1 — Platform layer for pickers and image decode

**Purpose:** Satisfy Constitution §7 / Blueprint Platform Layer so Trees and library flows do not embed AppKit in Services or Features.

**Expected Result:**

- Protocols exist for directory picking, image picking, and image inspection/decode from `Data`.
- macOS adapters implement them (`NSOpenPanel`, `NSImage` only inside Platform).
- `LibraryService`, `ImageImportService`, and Tree Feature views no longer `import AppKit`.

**Dependencies:** None (start here).

---

### T2 — Tree store / persistence decision and implementation

**Purpose:** End dual truth for Trees (Architecture Review C2). Trees must survive app relaunch inside the open library.

**Expected Result:**

- Documented decision: Trees persist in the library package (Database or equivalent library-backed store per STORAGE_ARCHITECTURE intent).
- A `TreeStore` (or equivalent) protocol; Features call the store, not ad-hoc PreviewData mutation as the product design.
- Create / update / load trees for the current library; PreviewData is removed or reduced to a store implementation that is replaced this sprint for Trees.
- Locations required by Trees remain consistent (at least load + assign existing locations; create location only if already in product flow).

**Dependencies:** T1 recommended before image-related persistence wiring; library must already be open (First Launch exists).

---

### T3 — Botanical identity on Tree (Reference Data UUIDs)

**Purpose:** Align Tree with hierarchical Reference Data (Architecture Review C3).

**Expected Result:**

- `Tree` stores `genusID` / `speciesID` / `cultivarID` (or equivalent UUID FKs); display botanical name derived via `TreeNamingService` + Reference Data.
- Cascading pickers write IDs; string-only genus/species/cultivar are not the source of truth.
- Seed/migration path for existing PreviewData trees documented or converted.

**Dependencies:** T2 model freeze before or with first persist schema.

---

### T4 — Physical Location vs LocationReference in Trees UI

**Purpose:** User-first clarity (Architecture Review C4); Blueprint physical hierarchy.

**Expected Result:**

- Tree Detail and New Tree clearly separate **physical Location** (`locationID`) from Lists vocabulary (renamed label, e.g. location type / site category).
- Every saved tree has a required physical `locationID`.
- No picker titled only “Location” for `LocationReference`.

**Dependencies:** T3 can proceed in parallel; must land before success criteria demo.

---

### T5 — Transactional Save / Cancel for New Tree and Tree Detail

**Purpose:** HIG-aligned editing; Architecture Review I2.

**Expected Result:**

- Editing uses a draft; **Save** commits to `TreeStore`; **Cancel** discards.
- No live mutation of the persisted store on every picker change.
- Empty/invalid required fields block Save with clear messaging (at minimum: physical Location + botanical selection rules as decided).

**Dependencies:** T2, T3, T4.

---

### T6 — Primary image: import + metadata persistence

**Purpose:** Complete the Trees image path for Sprint Goal (Architecture Review I3).

**Expected Result:**

- Add / Change Primary still uses Platform image picking + `StorageService` for bytes.
- `ImageAsset` metadata persists with the library and reloads with the tree.
- Hero displays primary image after relaunch without AppKit in the Feature layer.
- Gallery module UI, multi-image gallery, thumbnails — out of scope.

**Dependencies:** T1, T2.

---

### T7 — Tree Detail structure (split responsibilities)

**Purpose:** Maintainable Trees UI (Architecture Review I1); Falo calm, one-job sections.

**Expected Result:**

- `TreeDetailView` decomposed into section views / draft coordinator; Feature views do not own persistence or platform APIs.
- Shared Detail patterns and design tokens reused; no private design system.

**Dependencies:** T5 (draft model), T6 (hero section).

---

### T8 — Collection membership from Tree Detail (Trees-consistent)

**Purpose:** Keep organizational grouping usable while Trees become durable.

**Expected Result:**

- User can add/remove a tree from Collections from Tree Detail.
- Membership remains consistent with the saved tree record for this sprint’s persistence model (document any interim limit if Collections themselves stay session-only).

**Dependencies:** T2, T5.

---

### T9 — Trees list + empty states as the durable overview

**Purpose:** Solidify Trees as the center of individual records (ROADMAP NEXT).

**Expected Result:**

- `TreeListView` shows persisted trees (botanical / display name, location, status as available).
- New Tree from toolbar / Quick Actions opens create flow that saves into the store.
- Empty state invites creating the first tree.
- Advanced `TreeBrowserView` not required to ship as primary; may remain secondary/unused.

**Dependencies:** T2, T5.

---

### T10 — Documentation and ownership clarity

**Purpose:** Keep documentation source of truth (START_HERE); Architecture Review C5 / I5.

**Expected Result:**

- PRODUCT_BLUEPRINT current status updated: Trees foundation shipped; Storage Phase 1 present; domain persistence for Trees described accurately.
- CHANGELOG entry for Sprint 2 outcomes.
- Short note that `Images/` is the media subsystem for Trees (and future Gallery) — Gallery module UI still Planned.

**Dependencies:** After T2–T9 land.

---

### T11 — Focused tests

**Purpose:** Protect naming and persistence (Architecture Review I8).

**Expected Result:**

- Tests for `TreeNamingService` botanical output.
- Tests for Tree store save/load round-trip (or library-backed equivalent).
- Tests for Location vs reference field not confused at model level where applicable.

**Dependencies:** T2, T3.

---

## 5. Sprint Success Criteria

Sprint 2 is **complete** only when all of the following are true:

### User-visible

| # | Criterion |
|---|-----------|
| U1 | With a valid library open, user can **create a tree**, **Save**, quit, relaunch, and see that tree in the list. |
| U2 | User can **edit** a tree, **Save** changes, and see them after relaunch; **Cancel** discards an in-progress edit. |
| U3 | User can set **physical Location** and botanical **Genus / Species / Cultivar** without ambiguous “Location” labeling for reference vocabulary. |
| U4 | User can **add or change primary image**; image shows on Detail and survives relaunch. |
| U5 | Trees list remains the main overview; New Tree is reachable from the established Quick Action / toolbar path. |

### Architectural

| # | Criterion |
|---|-----------|
| A1 | No Feature file imports AppKit for pickers or image decode; Platform adapters own macOS UI-kit usage. |
| A2 | Trees are not authored as long-term product data solely in ephemeral PreviewData; a store/persistence path owns Trees inside the library. |
| A3 | Tree botanical identity uses Reference Data IDs as source of truth; botanical display name is derived. |
| A4 | Project builds without warnings or errors on macOS. |

### Documentation

| # | Criterion |
|---|-----------|
| D1 | Blueprint and Changelog reflect Sprint 2 Trees foundation. |
| D2 | Out-of-scope modules remain untouched (no Projects, Calendar, Tasks, Cloud, or mobile targets added). |

### Explicit non-goals (must still be true)

- No cloud sync.
- No iPhone / Android / Windows app target.
- No Gallery module browser, no Settings Library Location UI required.
- Search/sort/filter may remain placeholders.

---

## Relationship to other documents

| Document | Role |
|----------|------|
| [BONSAI_CONSTITUTION.md](../BONSAI_CONSTITUTION.md) | Non-negotiable principles (Platform Independence, separation of concerns) |
| [PRODUCT_BLUEPRINT.md](../PRODUCT_BLUEPRINT.md) | Product truth; update when Trees foundation ships |
| [ROADMAP.md](../ROADMAP.md) | Themes only; this sprint plan specializes NEXT “Solidify Trees” |
| [ARCHITECTURE_REVIEW_SPRINT_0.md](../Architecture/ARCHITECTURE_REVIEW_SPRINT_0.md) | Critical/Important findings absorbed into T1–T11 |
| [Architecture/STORAGE_ARCHITECTURE.md](../Architecture/STORAGE_ARCHITECTURE.md) | Non-governing storage appendix; governing strategy in Blueprint §3 |
| [FALO_DESIGN_SYSTEM.md](../../../Documentation/FALO_DESIGN_SYSTEM.md) | Calm UI, native patterns, reusable components |

---

## Implementation order (summary)

```text
T1 Platform
  → T2 Tree store / persistence
    → T3 Botanical IDs  ┐
    → T4 Location UX    ┼→ T5 Save/Cancel → T6 Images → T7 Detail split
                        │                 → T8 Membership
                        └→ T9 List
                              → T10 Docs + T11 Tests
```

---

*End of Sprint 2 official plan. Documentation only — no code changes in this task.*
