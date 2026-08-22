# Bonsai World — Architecture Review v1

**Date:** 22 August 2026  
**Scope:** Current codebase as implemented  
**Method:** README, START_HERE, Constitution, Falo Design System, Product Blueprint, codebase exploration, Sprint 0 review cross-check  
**Constraint:** Analysis only — no code or documentation changes

---

## Overall Assessment

Bonsai World has a **strong documented architecture** and a **credible macOS-first foundation**. The product vision, module template, storage philosophy, and Falo-aligned shell (sidebar, Quick Actions, adaptive workspace) are clearly defined and partially implemented.

The gap is **compliance between documentation and implementation**. Core entities (Trees, Collections, Reference Data locations) still live in session-only preview catalogs while the library package persists ancillary data (measurements, images, photo index). AppKit remains embedded in services and features. Edit Tree uses auto-save while the Blueprint specifies Save / Cancel / Reset. Several modules are routed in navigation but are placeholders.

The project is **architecturally sound in intent** but **not yet architecturally complete in execution**. Expanding feature surface before closing persistence and platform boundaries will compound rewrite cost.

---

## Project Strengths

- **Governing documentation is disciplined.** Five governing documents, clear hierarchy (Constitution → Blueprint → Falo), and explicit module templates reduce ad-hoc design.
- **Trees remain central.** Domain comments, navigation order, and workflow investment align with Constitution §1.
- **Physical vs organizational hierarchy is modeled correctly.** Garden → Location → Tree (physical); Collection ↔ Tree (organizational, many-to-many, no geography).
- **Storage abstraction exists.** `StorageProvider`, library package layout, First Launch Wizard, and relative paths follow Blueprint §3.
- **Reference Data is centralized.** Typed lists, hierarchical botanical library, Settings as the edit home — aligned with Constitution §9.
- **Shared presentation layer is emerging.** Falo design tokens, Detail cards, Quick Actions catalog, `FaloAdaptiveDesktopWorkspace` — reusable patterns for future modules.
- **Recent domain separation work is sound.** Tree measurements (history) vs pot dimensions (current Tree state); Smart Collection type prepared without UI exposure; New Tree workflow extended without leaving the dialog.

---

## Architecture Strengths

| Area | Assessment |
|------|------------|
| **Folder layout** | Matches Blueprint: `App/`, `Core/`, `Storage/`, `ReferenceData/`, `Features/`, `Shared/`, `Images/` |
| **Domain purity** | `Tree`, `Collection`, `TreeMeasurementRecord` use Foundation only — no AppKit in Core/Domain |
| **Service injection** | Environment-based composition in `Bonsai_HubApp.swift` — testable direction |
| **Repository protocol** | `TreeRepository` / `PreviewTreeRepository` — correct seam for persistence swap |
| **Identity rules** | Botanical identity locked after create in `TreeService`; UUID FKs on Tree for genus/species/cultivar |
| **Module independence (intent)** | Features scoped per module; Shared components reused rather than duplicated per screen |
| **Adaptive layout system** | `FaloAdaptiveDesktopWorkspace` with profiles — content-owned minimum width, horizontal scroll, no window forcing |

---

## Architecture Weaknesses

### 1. Project Structure

**Strengths:** Clear separation of App shell, Core, Features, Shared, Storage. Trees module is the most complete feature area.

**Weaknesses:**

- **Naming drift:** Product is “Bonsai World”; Xcode target/folder is “Bonsai Hub”. Empty `Features/Collection/` duplicates `Features/Collections/`.
- **`PreviewData` naming misleads:** `PreviewData`, `ReferencePreviewData`, and `ImagePreviewData` act as runtime catalogs, not preview-only fixtures.
- **Missing Platform layer:** Documented in Blueprint; no `Platform/` folder. OS APIs live in Services and Features.
- **Empty placeholders:** `Core/Models/`, `Core/Cloud/`, and several `Features/*` folders exist without implementation — acceptable for roadmap, but increases navigation noise.
- **`LocationReference` under ReferenceData** while `Tree` and `Collection` live in Core/Domain — physical places are domain entities stored as reference lists.

### 2. Domain Architecture

| Domain | Correct ownership | Current issues |
|--------|-------------------|----------------|
| **Tree** | Core entity; one Location; many Collections | Denormalized latest measurements + separate history; pot dims on Tree pending future Pot entity; future link IDs (`projectIDs`, `taskIDs`) on Tree before modules exist |
| **Collection** | Organizational; tree ID membership | **Dual membership:** `Tree.collectionIDs` and `Collection.treeIDs` must stay manually in sync |
| **Location** | Physical place; owns coordinates | Lives in `ReferencePreviewData`, not library Database; conflated with “location type” vocabulary in Reference Data |
| **Garden** | User profile / map framing | `UserProfileStore` (UserDefaults) — separate from library package |
| **Pot** | Future Inventory/Pot entity | Pot dimensions stored on Tree; correctly separated from measurement history but still coupled to Tree |
| **Species** | Reference Data hierarchy | Correct UUID model in Reference Data; Tree stores FKs + derived names |
| **Measurements** | History store (append-only) | Correct split from pot; Tree still mirrors latest dims for list performance |
| **Photos** | Image catalog + Tree bindings | **Triple state:** `Tree.imageIDs`, `TreePhotoIndexStore`, `ImagePreviewData` / `Catalog.json` |
| **History** | Measurement history JSON | Persisted; good. Tree ownership/acquisition history on Tree entity — appropriate |

**Data in the wrong conceptual home (today):**

- Physical **Locations** edited as Reference Data lists rather than as a first-class persisted domain module.
- **Collections** in `PreviewData` while Trees go through a repository — split persistence path.
- **Pot measurements** on Tree — acceptable interim, but blocks clean Pot module extraction.

### 3. Workflow Review

| Workflow | Constitution / Blueprint alignment | Current state |
|----------|-----------------------------------|---------------|
| **Dashboard** | Read-only orientation; navigate to act | Partial — placeholder data; cards not yet linked to modules |
| **New Tree** | Quick Action; transactional create | **Strong** — embedded Location/Collection creation, optional first measurement; Save/Cancel toolbar |
| **Edit Tree** | View default; Edit → Save/Cancel/Reset | **Diverges** — auto-save with “Finish”; no discard/revert; Blueprint §7.3 not met |
| **View Tree** | Read-only detail | Correct default |
| **Collections** | Browse → detail → open Tree; membership | Partial — add tree, membership sheet, New Tree preselect; no collection edit detail |
| **Photos** | Add from Tree context | Works — import, filmstrip, metadata; AppKit-coupled |
| **Measurements** | Dated tree sessions | Correct — history timeline, Add Measurement in Edit only; pot separate |

**Progressive Disclosure:** Generally good — optional measurements in New Tree, Ownership expandable section, collapsed measurement section, unfinished Quick Actions hidden as “Coming Soon.”

**One Action – One Location violations / risks:**

- **New Tree** toolbar Save/Cancel vs Quick Actions “New Tree” — acceptable (create sheet chrome).
- **Edit Tree “Finish”** in Quick Actions vs Blueprint “Cancel” semantics — Finish saves; no true cancel-with-revert.
- **New Location** available from Quick Actions, Reference Data Manager, New Tree, and map picker — multiple entry points, but same save path (acceptable if intentional).
- **Collection membership** editable from Tree (sheet) and Collection (add tree sheet) — same domain operation, two UIs (acceptable for workflow, but must share one service path).

**Unnecessary steps:** New Tree requiring Location before save is correct domain rule but adds friction when no locations exist — mitigated by in-dialog Location creation.

### 4. UI Architecture

| Aspect | Assessment |
|--------|------------|
| **Navigation** | Architecture v2 routes via `AppRoute` / `AppModule`; Dashboard and Trees use two-column shells; others use three-column split — intentional but increases layout variance |
| **Workspace layout** | `FaloAdaptiveDesktopWorkspace` unifies Dashboard, Tree Detail, New Tree — content scales, scrolls horizontally when narrow; window not forced to resize |
| **Card hierarchy** | Tree Detail: photo band + three proportional columns + measurement history — matches Dashboard column principle |
| **Desktop-first** | Recent correction aligns with Falo — expand to fill width, minimum content width, scroll before compress |
| **Scrolling** | Vertical + conditional horizontal — consistent across adapted workspaces |
| **Quick Actions** | Single action home in sidebar — Constitution §7 largely met; tree detail has no duplicate toolbar actions |
| **View/Edit** | View mode correct; Edit mode philosophy inconsistent with Blueprint |

**Usability note (not visual):** Tree workspace uses vertical split (list above detail) rather than Blueprint’s sidebar → list → detail — workable on macOS but differs from the documented three-area model.

### 5. Technical Debt

**Critical**

- **Dual persistence (PreviewData vs library)** — Trees, Collections, Reference Data locations lost on restart; measurements and images persist — split brain.
- **No Platform layer** — AppKit in `LibraryService`, `ImageImportService`, `TreePhotoManagerSection`, map/location views.
- **`TreeDetailView` monolith (~950 lines)** — draft, auto-save, photos, measurements, bindings, collections in one view.

**Important**

- Bidirectional collection membership sync in `PreviewData` — error-prone at scale.
- Photo state reconciliation at `TreeService` init — symptom of multiple binding stores.
- Reference Data CRUD not persisted — Settings edits are session-only.
- Edit auto-save vs Blueprint Save/Cancel — undocumented product decision.
- Hub/World and Collection/Collections naming inconsistency.

**Future**

- Empty feature folders and placeholder routes (Care, Nursery, Inventory, etc.).
- Growing Intelligence stubs.
- Smart Collection model prepared but unused.
- Workspace Profiles approved but not implemented.

### 6. Falo Compliance

| Document | Compliance |
|----------|------------|
| **Constitution** | **Partial.** Trees at center ✓; User First ✓; documentation discipline ✓; One Action mostly ✓; Safe by Default partial (Edit has no revert); Platform Independence ✗; Clear separation ✗ (PreviewData + library); User owns data ✓ (library model) |
| **Falo Design System** | **Good and improving.** Workflow first, progressive disclosure, native controls, calm card layout, adaptive workspace, readability-before-compression — recent work aligns well |
| **Product Blueprint** | **Partial.** Module template defined; Trees/Locations/Collections partial; Gallery/Journal/Tasks planned-only; Edit Mode behaviour diverges; storage Phase 1 incomplete for core entities |

---

## Technical Debt

| Item | Severity | Impact |
|------|----------|--------|
| Session-only Trees/Collections/Reference locations | Critical | Data loss on quit; blocks real product use |
| AppKit in Services/Features | Critical | Cross-platform violation |
| TreeDetailView size/complexity | Important | Maintainability, testability |
| Dual membership + dual photo binding | Important | Sync bugs, migration risk |
| Edit auto-save vs Blueprint Edit Mode | Important | Product/consistency debt |
| Reference Data not persisted | Important | Settings work ephemeral |
| Naming drift (Hub/World, Collection/s) | Minor | Developer confusion |
| 30+ placeholder navigation routes | Future | Shell weight without substance |

---

## Workflow Review

**Works well today:** New Tree (complete in-dialog workflow), Tree list → detail, View mode default, Quick Actions routing, measurement history separation, collection membership from Tree and Collection, map-based location assignment.

**Needs architectural alignment:** Edit Tree persistence model, Dashboard as dead-end (no navigation from cards), transactional discard path missing, persistence so workflows survive restart.

**Duplicated but manageable:** Multiple paths to create Location/Collection — acceptable if all call the same services (they largely do today, via Reference Data Manager and sheets).

---

## Highest Priority Improvements

1. **Establish one persistence path for core domain entities** — Trees, Collections, and Reference Data locations through library Database JSON (or equivalent), retiring PreviewData as the product store.
2. **Introduce Platform adapters** — move AppKit (panels, image decode, map) behind protocols; Services depend on abstractions.
3. **Resolve Edit Tree vs Blueprint** — either implement Save/Cancel/Reset with draft discard, or formally amend Blueprint to approve auto-save; do not leave ambiguous.
4. **Decompose `TreeDetailView`** — extract photo management, auto-save coordinator, measurement presentation, and draft bindings into focused types.
5. **Normalize binding ownership** — single source for collection membership and photo gallery order; eliminate triple reconciliation.

---

## Future Risks

- **Feature expansion on PreviewData** will require a painful migration and risk user data loss if persistence is delayed further.
- **Cross-platform** will stall until Platform layer exists; every new macOS-specific shortcut deepens lock-in.
- **Smart Collections, Pot entity, Gallery module** will fight the current Tree-embedded fields unless domain boundaries are clarified before implementation.
- **Navigation shell complexity** (2-column vs 3-column, Trees vertical split) may complicate iPhone/Android without a shared “workspace coordinator” abstraction.
- **Undocumented Edit auto-save** may confuse contributors and violate Safe by Default expectations (no undo path).
- **No Git repository** (as of review date) — process risk separate from code architecture, but threatens the documented workflow.

---

## Overall Score: **6 / 10**

**Rationale:** Documentation and structural intent deserve 8–9; implementation completeness and Constitution compliance on persistence and platform independence bring the score down. The adaptive workspace and recent domain separations (measurements, collections type, New Tree workflow) show the architecture is moving in the right direction — but the core is not yet a single coherent system end-to-end.

---

## Five Most Important Architectural Improvements (Ordered)

1. **Unify persistence** — Persist Trees, Collections, and Reference Data through the library package; remove PreviewData as the runtime source of truth.
2. **Add Platform layer** — Isolate AppKit and OS-specific APIs; keep Services and Features platform-independent.
3. **Align Edit Tree persistence with governing docs** — Transactional Save/Cancel/Reset, or document and implement auto-save as an approved pattern with explicit discard semantics.
4. **Split `TreeDetailView` responsibilities** — Reduce the monolith into composable, testable units matching Blueprint module internals.
5. **Consolidate dual-written state** — One authoritative path for collection membership and photo bindings; denormalize only at read boundaries, not with manual sync in catalog code.
