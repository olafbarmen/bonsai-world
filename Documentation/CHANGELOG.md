# Bonsai World — Changelog

Minimal historical record of **shipped functionality** and **approved decisions**.

**Not a governing document.** Product truth lives in the five governing documents listed in [START_HERE.md](START_HERE.md). Do not redesign features here.

---

## 2026-08-22

### Decision

- **Tree Overview + Tree Workspace** adopted as permanent Trees architecture in [PRODUCT_BLUEPRINT.md](PRODUCT_BLUEPRINT.md) §5.2: one-click Overview in Garden → Trees split view; double-click / Open Tree Workspace opens a dedicated multi-window craft surface; one Library; synchronized; Experience Levels defined; flagship concept before implementation. Historical proposal: [Product Reviews/Tree_Detail_Workspace_Redesign.md](Product%20Reviews/Tree_Detail_Workspace_Redesign.md).

---

## 0.2.0

### Shipped

- Renamed the application’s user-facing identity from Bonsai Hub to **Bonsai World** (UI title, display name, product documentation).
- Adopted the standard Falo sidebar structure: **Workspace**, **Quick Actions**, and **Tools**.
- Introduced reusable `QuickActionsView` with catalog-driven Global and Context actions (New Tree, Search, Import + per-module placeholders). Extend context via `ContextQuickActionsCatalog` without changing the view.
- Toolbar shows the application title **Bonsai World**; sidebar and content use native system backgrounds and shared Falo spacing/typography tokens.
- Locations reference Detail page: structured Header, Summary, Information, related Trees/Collections, Statistics, Notes, and Recent Activity using reusable shared Detail components. Edit opens the existing Location editor sheet; no inline editing or persistence.

### Decision

- Application shell follows Falo Universe Design System navigation and workspace philosophy. Shared shell UI under `Shared/` is structured for reuse by future Falo Worlds; product modules remain World-specific.
- **Physical vs organizational:** Hierarchy is World → Location → Tree. Collections are user-defined groups (many-to-many with trees) and never determine a tree’s Location. Preview collections: Maples, Favorite Trees, Exhibition 2027. Smart collections reserved for later.
- **Collections module (initial):** Sidebar **Collections**, reusable `CollectionsList`, `CollectionDetailView` with member trees, drill-in to `TreeDetailView`. No editing or persistence.
- **Collection membership:** Tree Detail shows memberships and an Add to Collection sheet that toggles PreviewData membership in session; Collection Detail updates immediately. Not persisted.
- **Create Collection:** Sidebar Quick Actions → **New Collection** only; sheet validates name and inserts into PreviewData, then opens the new Collection Detail (starts with zero trees).
- **Reference Data:** Strongly typed master data under `ReferenceData/` seeded verbatim from Excel `Lists` (`Documentation/Project/bonsai_registry_ultimate.xlsx`). Per-list PreviewData files; pickers via `ReferenceDataService`; management via `ReferenceDataManager` (Settings → Reference Data). Style / SizeClass / WorkType / LightCondition / SoilType have no Lists section (empty until edited). No persistence or Excel import.
- **New Tree (UI):** `NewTreeView` sheet from Global Quick Actions; Form sections General / Classification / Growing / History / Notes; all pickers from `ReferenceDataService`. Uses shared `TreeDetailToolbar` (Create mode); Save is a TODO stub.
- **Tree Detail hero:** Sticky 16:9 primary-image hero with empty placeholder and image toolbar (Add / Change Primary / Gallery — UI only). Inspector-style form sections below.
- **Botanical hierarchy:** `Species.genusID` and `Cultivar.speciesID`; `ReferenceDataService.species(for:)` / `cultivars(for:)`; cascading Genus → Species → Cultivar pickers on Tree Detail and New Tree.
- **Automatic naming:** `TreeNamingService.makeBotanicalName` → `Genus Species` / `Genus Species 'Cultivar'`; Tree Detail shows read-only Botanical Name + optional Display Name. Year/sequence reserved for later.
- **Tree Detail fields:** Classification / Growing / History / Notes use `ReferenceDataService` pickers (Style, Size Class, Tree Status, Location, Light Condition, Soil Type, Pot Type, Acquisition Source) plus Acquisition Date and Notes editor. Session-only writes into PreviewData; no persistence or validation. `SoilType` model + empty PreviewData (not on Lists).
- **Tree Detail toolbar:** Shared `TreeDetailToolbar` for Create and Edit — Cancel (leading), Save + More Actions (trailing: Duplicate / Export disabled; Delete disabled in Create). Titles: "New Tree" vs Botanical Name. Save/Cancel are TODO stubs (no persistence).
- **Tree List:** `TreeListView` is the main Trees overview — PreviewData list with thumbnail placeholder, Botanical Name, optional Display Name, Location, and Tree Status. Toolbar: New Tree + Search/Sort placeholders. Selection opens Tree Detail. Empty state offers New Tree via existing Quick Action path.
- **Tree Browser:** `TreeBrowserView` (advanced filters) retained for later; Trees module content column uses `TreeListView`.
- **Tree naming (service prepared):** `TreeNamingService` documents permanent Name rules; imports preserve Names. New Tree workflow does not generate Names yet (UI placeholder).
- **Storage strategy (approved):** Governing strategy lives in Product Blueprint §3 — `StorageProvider` abstraction; Phases 1–4; user-owned library; models store identifiers / relative keys only. Detailed notes: [Architecture/STORAGE_ARCHITECTURE.md](Architecture/STORAGE_ARCHITECTURE.md) (non-governing appendix).
- **Storage foundation (Phase 1):** `Storage/` — `StorageProvider` protocol, `LocalStorageProvider`, `StorageService` (shared + environment). Default library under Application Support. Library location configuration prepared for Settings. No iCloud/OneDrive/Bonsai Cloud providers; no database persistence yet.
- **Image architecture (prepared):** `Images/` — `ImageAsset` metadata model; `Tree.primaryImageID` / `imageIDs`; `ImageService` (metadata + gallery via `StorageService`); library folders `Images/Originals`, `Thumbnails`, `Hero`. No import, thumbnails, or pixel loading yet.
- **Primary image import:** `ImageImportService` — Finder picker (HEIC/JPEG/PNG/TIFF) → copy into `Images/Originals/` via `StorageService` → `ImageAsset` metadata → `Tree.primaryImageID`. Tree Detail Add Image shows the image immediately. No gallery, multi-import, drag & drop, or thumbnails yet.
- **Library management:** `Library` model + `LibraryService` — single local library; create/open/verify folder structure via `StorageService`. No auto-create on launch; `resolveLaunchLibrary()` opens last bookmark or default path when valid.
- **First Launch Wizard:** Welcome screen when no valid library is ready — Create New Library (folder picker → `LibraryService`) or Open Existing Library (validate required folders; clear error if invalid). Extensible option catalog for future iCloud / backup / sample flows.
- **Platform Independence (approved):** Cross-platform readiness is a permanent architectural principle. Ship native macOS first; architecture must support future Windows, iPhone, and Android without major refactoring. Constitution §§10–11; Blueprint §§2 and 6.
- **Tree domain model (complete):** `Tree` is identity + botanical/classification/growing/history IDs + image IDs + relationship ID arrays (collections/projects/journal/tasks) + created/modified dates. No UI, platform, or business logic on the model; related entities by UUID only.
- **Tree repository architecture:** `TreeRepository` protocol + `PreviewTreeRepository` (PreviewData only) + `TreeService` as the sole app-facing Tree API. Views → TreeService → TreeRepository → PreviewData. Persistence backends can replace PreviewTreeRepository later without changing Views.
- **Trees views on TreeService:** `TreeListView`, `TreeDetailView`, `NewTreeView`, `TreeBrowserView`, and `CollectionMembershipSheet` no longer access PreviewData; all Tree reads/writes go through TreeService.
- **Tree Detail View / Edit Mode:** Tree Detail opens in View Mode (read-only, no dropdowns). Edit Mode drafts until Save or Cancel. Botanical identity stays locked. Governing UI rules: Blueprint §6.
- **Trees Quick Actions:** Global — New Tree, Search, Import. Context when a tree is selected — Edit Tree, Add Image, View Gallery, Duplicate, Delete. In Edit Mode context becomes Save, Cancel, Reset Changes. Actions live in Quick Actions only.
- **Workspace Profiles (approved):** One application; Essential / Advanced / Complete control visibility only. Constitution §17; Blueprint §5.
- **Reference Data Manager:** Settings → Reference Data — in-session CRUD. Botanical Library (`BotanicalService`): Genus → Species → Cultivar. Flat lists for other Lists categories. No persistence.
- **Documentation consolidation (approved):** Restored the rule of **exactly five governing documents** (START_HERE, Constitution, Product Blueprint, Falo Design System, Falo Component Library). Product Principles and UI Framework content folded into Constitution and Blueprint; storage strategy summarized in Blueprint §3; `STORAGE_ARCHITECTURE` demoted to `Architecture/` appendix. Roadmap, Changelog, Reviews, and sprint plans remain non-governing.

---

## 0.1.0

### Shipped

- Application shell with `NavigationSplitView`, sidebar navigation via `AppSection`, and placeholder detail titles for all planned feature modules.
- Central `AppState` (`@Observable`) as the single source of truth for selected `AppSection` navigation, injected from the application root.
- Initial domain models: `Location`, `Collection`, and `Tree` (`Identifiable` / `Codable`) with Collection → Location and Tree → Collection relationships.
- Interim `PreviewData` catalog (3 Locations, 5 Collections, 20 Trees) with valid relationships for UI development.
- First Locations screen: list of locations with collection counts, driven by `AppState` navigation and `PreviewData`.
- Locations upgraded to reference master/detail module: list + detail summary (collections, trees, created, updated), toolbar Quick Actions (`+`), placeholder New Location editor. No persistence or save logic.
- Locations CRUD navigation: create/edit via shared `EditorMode`, detail Edit button, Cancel/Save workflow prepared without persistence.

### Decision

- Initial documentation framework established.
- Documentation folder structure created.
- Five product documentation model adopted: START_HERE, BONSAI_CONSTITUTION, PRODUCT_BLUEPRINT, ROADMAP, and CHANGELOG.
- Idea Parking Lot adopted as process documentation (not one of the five product documents).
- **Locations vs Storage:** Locations owns physical places where trees and materials live; Core Storage owns local persistence of application data and files; Core Cloud owns cloud-related persistence and resolution. These concerns must not be conflated.
- Idea Parking Lot statuses defined as New, Deferred, Promoted, and Rejected, with explicit transitions and archival rules.
