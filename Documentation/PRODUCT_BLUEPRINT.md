# Bonsai World — Product Blueprint

**Status:** Single source of truth for the **current product** architecture, feature set, and Bonsai-specific UI patterns  
**Authority:** Subordinate only to the Constitution; must align with the Falo Design System  

This document describes what Bonsai World is planned to be and **how its Workspace UI works**. Immutable philosophy lives in [BONSAI_CONSTITUTION.md](BONSAI_CONSTITUTION.md). Shared Falo visual language lives in the Design System and Component Library.

Anything not yet built is marked **Planned**. Do not treat Planned items as shipped.

Direction themes may appear in a non-governing Roadmap. Shipped history may appear in a non-governing Changelog. Neither replaces this Blueprint.

---

## 1. Product vision

Bonsai World should be the calm, everyday place to organize a bonsai collection and support ongoing care.

It helps the grower know what they have, where it lives, what needs attention, and what has been done — without turning care into administrative overhead.

**Trees are the core.** Development begins as a **native macOS** application. Architecture supports future **Windows**, **iPhone**, and **Android** clients that share the same domain, services, storage contracts, and UI mental model without major refactoring.

### 1.1 The Software Grows with the Artist

**Status:** Approved core product principle (Constitution §17; Falo Design System — beside Progressive Disclosure).

Bonsai World is **one product**, **one library**, and **one data model**. Users never change products—they grow into them.

| Pillar | Meaning |
|--------|---------|
| **One Library** | The grower owns a single Bonsai World Library. |
| **One Database / data model** | No lite schema, no expert schema, no edition fork. |
| **One Product** | No separate Novice / Expert apps or SKUs as different products. |
| **Three User Experience Levels** | **Novice**, **Experienced**, **Expert** — see §6. |
| **Increasing capability without increasing complexity** | More tools appear as confidence grows; the Novice path stays calm. |
| **Reveal with mastery** | Navigation, guidance, and tools deepen with the artist—not with a second product. |

**Experience Levels affect:** presentation, navigation density, guidance, empty-state teaching, **Context Tools**, and which module surfaces are available.

**Experience Levels never:** change the underlying data model; create incompatible workflows; orphan or convert data when the grower advances; fork storage providers.

**Relationship to Progressive Disclosure:** Progressive Disclosure (Falo) is how screens reveal depth in the moment. *The Software Grows with the Artist* is how the **whole World** deepens over the grower’s practice. Both are required; neither replaces the other.

**Future features:** Every new capability must define behaviour for **Novice**, **Experienced**, and **Expert** (or explicitly declare level-invariant) before implementation — see §4.2 and §6.

---

## 2. High-level architecture

**Current shipping target:** native macOS application.  
**Architectural target:** platform-independent core with platform-specific UI and adapters.

```text
UI (platform-specific)
  → Features / Shared presentation
    → Services (domain operations; platform-independent when practical)
      → Domain (models & business rules; platform-independent)
        → Assets (universal capture catalog — §3.6)
        → Storage (provider abstraction; platform adapters underneath)
Platform layer — OS APIs, pickers, bookmarks, notifications, etc.
```

### Layers

| Layer | Owns | Must not |
|-------|------|----------|
| **Domain** | Tree, Location, Collection, **Asset** shape; naming; identity invariants | OS frameworks; file paths; window chrome |
| **Services** | Domain operations and workflows; **AssetService**, Gallery workflows on visual Assets | Call AppKit/UIKit directly — use Platform adapters |
| **Storage** | Persistence of the user-owned library via `StorageProvider` | Own physical “Locations” (benches); leak paths to Features |
| **Platform** | OS dialogs, bookmarks, notifications, decode helpers | Become a second home for business rules |
| **UI** | Presentation (native per platform) | Own persistence rules or duplicate domain truth |

**Composition today (macOS):** App → Features → Shared → Core / Storage. Shared does not own domain data.

### Top-level folders (planned)

| Area | Role |
|------|------|
| `App/` | Shell and entry |
| `Core/Domain/`, `Core/Models/`, `Core/Services/`, `Core/Managers/` | Domain and operations |
| `Storage/` | Phase 1 local persistence |
| `Core/Cloud/` | Cloud providers (Phases 2–4) |
| `ReferenceData/` | Master data models and services |
| `Features/` | One folder per **independent feature module** |
| `Shared/` | Reusable presentation |
| `Shared/PreviewData/` | Interim in-memory catalog (not long-term persistence) |
| `Resources/` | Assets |
| `Platform/` (planned) | OS adapters |

---

## 3. Storage philosophy

The grower owns the **Bonsai World Library**. The app must not lock users into one storage provider.

### Rules

1. All library file/blob access goes through a **`StorageProvider`** abstraction.  
2. Models store **identifiers or relative keys only** — never absolute paths or provider-specific locations.  
3. **No View, Model, or Feature** may access file paths directly.  
4. Adding iCloud, OneDrive, or Bonsai Cloud means **adding a provider**, not rewriting Tree/Image models.  
5. **User Experience Levels / Workspace Profiles never select or fork** storage providers.

### Phases

| Phase | Goal |
|-------|------|
| **1 — Local** | Fully functional macOS app on local library (`StorageService` + `LocalStorageProvider`) |
| **2 — iCloud** | Optional iCloud-backed provider |
| **3 — Windows providers** | e.g. OneDrive / local Windows paths via providers |
| **4 — Bonsai Cloud** | Dedicated cloud provider |

Library location is chosen by the user (**Settings → Library Management** when shipped). Physical **Locations** (benches, shelves) are a feature module — never conflated with file storage.

**Library administration** (Import, Export, Backup, Restore, Validate, Diagnostics) is **not** part of daily bonsai work. It lives under **Settings → Library Management** (§8.1) — never as primary Workspace navigation or competing Context Tools for routine care.

Detailed phase notes may live under `Documentation/Architecture/`; **this section is the governing storage strategy**.

### 3.6 Assets (unified capture foundation)

**Status:** **Approved.** Implementation Planned. Rationale: [Product Reviews/Asset_Architecture.md](Product%20Reviews/Asset_Architecture.md).

**Principle:** *Capture once. Use everywhere.*

Every captured or imported item is an **Asset** — not a special-case image file. Modules **link** to Assets; they do not **own** blobs.

| Rule | Meaning |
|------|---------|
| **Asset System owns** | Asset catalog, blobs (via StorageProvider), base metadata, tags, **AssetLink** graph, inbox-pending state, lifecycle |
| **Modules reference** | Trees, Inventory, Journal, Knowledge, Economy, Workshop, Yamadori store links — never duplicate blobs |
| **Gallery** | **Workflow and browse module** for **`photo` / `video` Assets** — Prepare, Primary, Featured, visual browse (§5.5) |
| **Quick Capture** | Creates Assets (`inbox_pending`); Mobile Companion primary surface ([§3.6.1](#361-quick-capture)) |
| **Inbox** | View over **pending Assets** — not a separate product |

#### Asset kinds (extensible catalog)

`photo` · `video` · `voice` · `text` · `pdf` · `receipt` · `qr_code` · `gps` · `web_link` · `scanned_document`

#### Asset lifecycle

```text
Capture / Import → Asset (Original immutable) → inbox_pending (optional)
    → triage / AssetLink → active → module enrichment (e.g. Gallery Prepare)
    → use everywhere linked → archive / delete
```

#### AssetLink (many-to-many)

One Asset may link to many module records (Tree, Pot, Journal entry, …). One record may link to many Assets. Roles include `primary_photo`, `attachment`, `evidence`, `reference`, `label_scan`.

#### 3.6.1 Quick Capture

**Principle:** *Capture first. Organize later.*

| Aspect | Rule |
|--------|------|
| **Job** | Fast capture away from desk — photo, voice, text, receipt, QR, … |
| **Creates** | **Asset** with `inbox_pending` — no module picker at capture time |
| **Mobile Companion** | Primary capture UI; syncs Assets into Library |
| **Desktop Inbox** | Triage pending Assets → create AssetLinks → active |
| **Destinations** | Tree · Pot · Tool · Product · Gallery · Inventory · Journal · Knowledge · Yamadori · Delete *(via links)* — Pot/Tool/Product create or link **Inventory Items** (§5.11) |

Quick Capture does **not** replace Add Tree or Gallery Prepare.

---

## 4. Standard module architecture

Bonsai World is built from **independent feature modules**. Every module follows the **same architecture and user experience** (Constitution + §6 + §7 UI framework). Modules do not invent private shells, action homes, or edit philosophies.

### 4.1 Shared rules for every module

- Lives under `Features/<Module>/`; talks to Services / Domain — not to storage paths or OS APIs.  
- Appears in Workspace (or Tools) per navigation order and **User Experience Level** / Workspace Profile (§6).  
- Uses Sidebar → Content List → Detail → **Context Tools** (stack on narrow devices).
- **Context Tools** is the only action home; unfinished tools stay hidden.
- Detail opens in **View Mode**; **Edit Mode** uses draft Save / Cancel / Reset Changes.  
- Consumes **Reference Data** from Settings; never edits master data inline.  
- Grows by extending workflows inside the same architecture — not by forking the module.  
- Defines how it behaves for **Novice**, **Experienced**, and **Expert** (§1.1, §6).

### 4.2 Standard module template (mandatory)

Every current and **future** module must be defined in this Blueprint using **all** of the following fields. Do not add a module without completing this template.

| Field | Meaning |
|-------|---------|
| **Purpose** | Why the module exists |
| **Primary Objects** | Domain objects the module owns |
| **Primary Workflow** | How users naturally work inside the module |
| **Navigation** | Where it appears in Workspace |
| **Context Tools** | Tools for the active workspace — sidebar bottom, dynamic title (e.g. Tree Tools, Image Tools). Scope: route + selection + View/Edit mode. |
| **Detail View** | How View Mode and Edit Mode work |
| **Reference Data** | Which Reference Data the module depends on |
| **Relationships** | How it relates to other modules |
| **Experience Levels** | How the module behaves for **Novice**, **Experienced**, and **Expert** (presentation, navigation, guidance, tools). Required for every future feature and module. Use “level-invariant” only when truly unchanged across levels. |
| **Future Expansion** | How it can grow without changing its architecture |

**Settings**, **Projects**, and Expert-depth modules (Exhibition, Research, Analytics, Breeding, …) follow the same template when specified; they are listed briefly in §5 and §8 until fully templated.

### 4.3 Cross-cutting domain rules

```text
World → Location → Tree (exactly one Location)
Collection → Tree (0…n; many-to-many; does not set Location)
```

| Term | Meaning | Owner module |
|------|---------|--------------|
| **Location** | Where a tree physically lives | Locations |
| **Collection** | Focused working set of trees (see §4.4) | Collections |
| **Tree** | Individual bonsai | Trees |

**Immutable botanical identity:** After a Tree is created, Genus, Species, Cultivar, and derived Botanical Name are immutable in operational UI and services. Create may set identity once.

**Tree Lifetime:** A Tree is a living record with permanent history. See **§4.5**. Deletion is exceptional; lifecycle status covers normal end-of-ownership and end-of-life outcomes.

**Reference Data (global):** Edited only in Settings (Reference Data / Botanical Library). Hierarchical botanical data stays Genus → Species → Cultivar. Empty pickers guide users to Settings.

### 4.4 Collection philosophy

**Status:** Approved product model.

#### Definition

A **Collection** is a **focused working set of Trees** that share a common purpose, characteristic, task, or relationship.

Collections help the bonsai artist **focus on a specific part of the collection** without changing the underlying Tree library. Trees remain the heart of Bonsai World; Collections are organizational lenses that orbit them. A Collection **never** determines Location.

#### Collection types

The product supports two **internal** Collection types:

| Type | Membership |
|------|------------|
| **Manual Collection** | User adds and removes trees explicitly. |
| **Smart Collection** | Membership is **automatically populated** from rules (see below). |

These are **implementation types**. The user interface presents both simply as **Collections** — one module, one list, one Detail pattern.

When creating a new Collection, the user chooses **Manual** or **Smart**. After creation, both types behave like any other Collection in browse, Detail, and navigation workflows.

#### Collection navigation

**Status:** Approved product model. **List sections and system Smart placeholders shipped;** filter evaluation for Smart membership remains planned.

Collections remain a **three-pane module**:

| Pane | Role |
|------|------|
| **Sidebar** | Workspace navigation (Garden → Collections) and **Context Tools** (§7.2) |
| **Collection List** | All Collections for the library, organized into **sections** (see below) |
| **Collection Detail** | Selected Collection — members and metadata |

**Do not** introduce an additional navigation column (or sidebar tier) for Collection Types, Manual vs Smart, or similar type browsers. Type is an **internal** distinction; the grower stays in one Collections module with one list and one Detail.

##### Collection List sections

The Collection List organizes rows into calm, labeled sections within the same content column. Example structure:

```text
SMART COLLECTIONS
  Favorite Trees
  Today's Work
  Needs Water
  Needs Repotting
  Needs Photos

MY COLLECTIONS
  Exhibition 2027
  Maples
  Shohin
```

| Section | Contents |
|---------|----------|
| **Smart Collections** | System and user Smart Collections. Hide the section when empty. |
| **My Collections** | Manual Collections created by the grower. |

Until additional Smart Collections exist beyond system placeholders, **Smart Collections** still lists the built-in placeholders. Section chrome must not imply a second module or a fourth pane.

Selecting a row in either section opens the **same** Collection Detail pattern. Membership, Edit Collection, and Add Existing Tree workflows do not change by section.

#### Smart Collections

**Smart Collections are Collections.** The product does **not** use the term **Saved Views**.

A Smart Collection is automatically populated based on **rules** defined at create or edit time. Examples (planned):

- Today's Work
- Needs Attention
- Needs Water / Water Today
- Needs Repotting
- Favorite Trees
- Yamadori
- Trees in Greenhouse
- No Main Photo

Rule evaluation and refresh are domain/service concerns; the grower sees a normal Collection with members that update as the library and care context change. In the UI, Smart Collections appear in the **Smart Collections** list section (§4.4 Collection navigation) — not in a separate navigation column. Attention-oriented Smart Collections also surface on **Dashboard** (§5.1).

**Note:** Smart Collection **“Yamadori”** filters **Trees** whose origin is wild collection — not active **Yamadori Projects** (pre-collection). See **§5.10 Yamadori**.

#### Membership ownership

**Collections own Tree membership.** `Collection.treeIDs` (or equivalent ordered membership on the Collection record) is the **single source of truth**.

- **Tree objects must never maintain a list of Collection IDs.**
- **Tree Overview** and **Tree Workspace** **may display** which Collections include this tree (resolved at read time from Collections).
- Add/remove membership from **Tree Overview**, **Tree Workspace**, or **Collection Detail** — all are entry points to the **same** Collection-owned operation.

#### Favorites

**Favorite is a Tree property** (for example `isFavorite` on Tree).

The application **may automatically expose** a Smart Collection named **Favorite Trees** whose rules reflect trees marked favorite. That Collection is a **working view** over the favorite flag — not a manually synced duplicate list.

#### Custom ordering

| Type | Ordering |
|------|----------|
| **Manual Collection** | Optional **user-defined tree order** — for exhibition planning, project work, and storytelling. Default sort when custom order is not set. |
| **Smart Collection** | **Rule-based ordering** defined in the Smart Collection configuration. |

#### Collections vs Tasks

**Tasks** own actionable work and completion state. A Smart Collection such as **Water Today** is a **focused working set** for browsing and planning — not a substitute for the Tasks module. Tasks and Smart Collections may overlap in subject matter but serve different workflows (see §5.9).

#### Dashboard relationship

Collections are **working views**. Dashboard surfaces Collections that **require attention** (for example Water Today, Repotting Due, Exhibition 2028, Favorite Trees) — not a flat inventory of every Collection. Dashboard remains read-only orientation; deep links open the owning Collection or **Tree Overview** / **Tree Workspace** (see §5.1, §5.2).

#### Default Collection selection

**Status:** Approved product policy. **Shipped** (session selection; last-opened remembered in-app).

The Collections module shall **never open with an empty Detail pane when Collections exist**.

When the grower enters Collections (or returns without a valid selection), Bonsai World shall **automatically select** a Collection:

1. **First available Smart Collection** (list order under Smart Collections).
2. **Otherwise** — the **last opened** Collection (when it still exists).
3. **Otherwise** — the first **My Collections** (Manual) row.

The empty **“Select a Collection”** Detail state shall appear **only** when the library contains **no** Collections. It must not appear merely because nothing has been clicked yet.

**Purpose:** Collections feel like an **active workspace** — Detail always shows a working set when any Collection exists — without adding a fourth navigation pane.

**Relationship to Smart Collections:** System Smart placeholders establish permanent navigation. Attention surfacing remains on **Dashboard** (§5.1). Filter-based Smart membership is planned separately.

### 4.5 Tree Lifetime

**Status:** Approved product policy. **Not implemented** in application code yet.

#### Principle

A **Tree** represents a **living object with a permanent history**.

The grower’s library is a steward of that history — botanical identity, photographs, measurements, journal, work, and Collection membership over time. Normal workflows must **preserve** the Tree and its complete history.

#### No deletion in normal use

**Trees must never be deleted during normal use.**

Deletion is **only** permitted for:

| Case | Intent |
|------|--------|
| **Accidental registration** | A Tree was created by mistake and has no meaningful history to keep. |
| **Duplicate records** | Two records represent the same physical tree; one may be removed after an explicit correction workflow. |

All other situations — sale, gift, death, loss, retirement from display, transfer of ownership — **shall preserve the Tree** and its complete history. Those outcomes are expressed as **lifecycle status**, not deletion.

#### Lifecycle status

Trees shall support a **lifecycle status** that replaces deletion in normal workflows. Planned supporting states include:

| Status | Meaning (product language) |
|--------|----------------------------|
| **Active** | Living tree in the grower’s care (default). |
| **Sold** | Ownership ended by sale; history retained. |
| **Gifted** | Ownership ended by gift; history retained. |
| **Dead** | Tree died; history retained. |
| **Lost** | Tree lost or whereabouts unknown; history retained. |

Additional statuses may be approved later without changing the rule that **status ≠ deletion**.

Changing lifecycle status is an intentional workflow (View → Edit or a dedicated action when shipped). It must never silently remove history, images, or related records.

Relationship to existing fields (when implemented): lifecycle status is the **product** model for “what happened to this tree.” Existing acquisition / disposal / classification fields may support or be aligned with this status; they must not invent a parallel “delete to dispose” path.

#### Presentation rules

**Collections**, **Tasks**, **Dashboard**, and future **Smart Collections** shall **respect Tree lifecycle status** when presenting Trees:

- Default care and attention surfaces emphasize **Active** trees (and other statuses only when the grower asks or when a view is explicitly about non-active trees).
- Non-active trees remain findable (search, filters, dedicated views) so history is never orphaned.
- Smart Collection rules may filter by lifecycle status (for example “Active only” or “Sold this year”).
- Removing a Tree from a Collection never deletes the Tree (§4.4); changing lifecycle status never deletes the Tree (§4.5).

#### Delete action (product)

| Action | Policy |
|--------|--------|
| **Delete Tree** | Hidden until a correct accidental/duplicate correction workflow ships. Never the path for Sold / Gifted / Dead / Lost. |
| **Change lifecycle status** | Normal path for end-of-ownership and end-of-life outcomes *(Planned)*. |

---

## 5. Module definitions

Status labels: **Partial** = usable but incomplete; **Planned** = not shipped; **Prepared** = subsystem exists, module surface incomplete.

---

### 5.1 Dashboard

| Field | Definition |
|-------|------------|
| **Purpose** | Orient the grower — what needs attention and where to go next — without becoming an editing surface. |
| **Primary Objects** | None owned. Aggregates read-only signals from other modules (counts, reminders, recent activity — as decided). |
| **Primary Workflow** | Open Dashboard → scan overview → navigate into Trees, Collections, Tasks, Calendar, or other modules to act. |
| **Navigation** | Workspace position **1**. Essential+. |
| **Context Tools** | **Global (planned):** Continue Working, View Today’s Tasks (when real). No create/edit of domain records here. |
| **Detail View** | No domain Detail. Cards/sections are read-only orientation; deep links open the owning module’s Detail. |
| **Reference Data** | None owned. May display labels resolved from other modules’ Reference Data. |
| **Relationships** | Read-only consumer of Trees, Locations, **Collections** (working views — see §4.4), Gallery, Journal, Calendar, Tasks, **Inventory** (low-stock / consumables attention — §5.11), (and Propagation when visible). Never owns their records. **Collections on Dashboard:** surface Collections that **require attention** (for example Water Today, Repotting Due, Exhibition 2028, Favorite Trees) — not a simple list of all Collections. Library-wide counts (total trees, species breakdown) are **My Trees** on Dashboard — distinct from named **Collections**. **Inventory card:** consumables attention from **Inventory** service — not a second asset register. **Tree Lifetime (§4.5):** default attention and care signals respect lifecycle status (emphasize Active; do not treat Sold / Gifted / Dead / Lost as “missing” trees to recreate). |
| **Future Expansion** | Add widgets and attention-oriented Collection cards without inventing edit workflows; keep calm overview. Profile may hide advanced widgets later. Auto-hide Collection cards when empty. |

**Status:** Partial — My Trees (whole-library counts), Weather, Tasks, Alerts, Upcoming, Trees Requiring Attention, Library, Recent Work, and Collection Overview are live (read-only deep links). Inventory Status, Repotting, and Quick Statistics keep their headings with “No function yet.” Today's Care is hidden (replaced by Tasks). Detail column hidden. Drag & drop / layout personalization not yet. Attention-oriented Smart Collections not yet wired.

---

### 5.2 Trees

| Field | Definition |
|-------|------------|
| **Purpose** | Own the individual bonsai record — identity, place, care fields, images, personal flags, and **lifecycle status**. **Heart of Bonsai World.** A Tree is a living object with permanent history (§4.5). The grower meets each Tree through **Tree Overview** (browse) and **Tree Workspace** (deep work) — two depths of the **same** Tree, never two products. |
| **Primary Objects** | **Tree** (botanical IDs, `locationID`, **`isFavorite`**, **lifecycle status** *(Planned)*, classification/growing/history fields, image IDs, notes). Tree does **not** store Collection membership IDs — see §4.4. **Tree Overview** and **Tree Workspace** are presentation surfaces — not separate domain entities. |
| **Primary Workflow** | Browse Garden → Trees list → **one-click** selects **Tree Overview** (View) → light Edit when needed; **double-click** (or **Open Tree Workspace**) opens the Tree’s personal **Tree Workspace** window; add via **Add Tree**; add primary image; toggle favorite; membership via Collections; change **lifecycle status** for Sold / Gifted / Dead / Lost *(Planned)* instead of deleting. |
| **Navigation** | Version 2: **Garden → Trees**. Essential+ (all Experience Levels). |
| **Context Tools** | **Tree Tools** when Garden → Trees: Add Tree · Search *(when shipped)*. **Tree selected, View:** Edit Tree · Add Image · Open Tree Workspace · View Images · Show on Map · Duplicate *(hide)* · Delete *(hide — §4.5)*. **Edit Mode:** Save · Cancel · Reset Changes. Tree Workspace window: same **Tree Tools** family. Import/Export → Settings → Library Management (§8.1). |
| **Detail View** | See **§5.2.1 Tree Overview** and **§5.2.2 Tree Workspace**. View Mode default; Edit intentional. Botanical identity locked after create. Human hierarchy first (presence, photo, place) — not UUID-led or taxonomy-first. Observation before administration. |
| **Reference Data** | Botanical Library (Genus → Species → Cultivar); Style; Size Class; Tree Status; Light; Soil; Pot; Acquisition Source; consumes **Locations** as place pickers. Lifecycle status vocabulary may live as Reference Data or a fixed domain enum when implemented — one source of truth. |
| **Relationships** | Exactly one **Location**; member of zero or more **Collections** (membership owned by Collections); **Asset links** for photos and attachments — **Asset System** owns Assets (§3.6); **Gallery** owns photo/video workflows (§5.5); Primary = `primary_photo` link role on a photo Asset. Optional **`currentPotInventoryItemID`** — **Inventory** owns pot record (§5.11); Tree displays linked pot. Future Journal / Tasks / Calendar / Projects / Workshop Work link by Tree ID. Related modules **respect lifecycle status** when listing Trees (§4.5). Orbiting modules open *into* the Tree story; they do not compete as alternate homes for the bonsai. |
| **Experience Levels** | See **§5.2.5**. Same Tree and Library at every level; Novice / Experienced / Expert only change presentation density, chapter visibility, guidance, and tools (§1.1, §6). |
| **Future Expansion** | See **§5.2.6**. |

**Status:** Architecture **approved** (Tree Overview + Tree Workspace). Implementation **Partial** — list + embedded detail (form-card layout), View/Edit, Quick Actions, TreeService, library persistence; Overview redesign and Tree Workspace window **not yet implemented**. Collection membership aligned with §4.4. **Tree Lifetime (§4.5)** approved — lifecycle status and delete restriction not yet implemented in code.

#### 5.2.1 Tree Overview

**Definition:** The embedded surface inside **Garden → Trees** (list above, overview below). Optimized for **browsing and comparing many trees**.

| Aspect | Rule |
|--------|------|
| **Job** | Recognize the tree, see place and health, spot attention, make light corrections, open deep work when needed. |
| **Selection** | **One-click** (or list selection) shows Overview for that Tree. Fast navigation across the collection. |
| **Editing** | **Lightweight** — View default; Edit via **Tree Tools** for nickname, place, growing summaries, notes, collections, pot dimensions, health/status, add measurement. **Add / prepare photo** and **set Primary** are **shortcuts into Media** (§5.5) — Overview displays presence; it does not own image editors. |
| **Presence first** | Hero photo + identity + place + quiet health / lifecycle chips before administrative field grids. Classification, ownership, pot dimensions, and full measurement history are **secondary** (collapsed / preview) — not equal peer cards. |
| **Not** | A second application; a place to dump Journal, full Timeline, Design, or Assistant as always-on panels. |

#### 5.2.2 Tree Workspace

**Definition:** The **complete working environment for one bonsai**. Flagship craft surface of Bonsai World.

| Aspect | Rule |
|--------|------|
| **Job** | Enter the life of one Tree — observe, remember, plan, register work, journal, design. |
| **Open** | **Double-click** a Tree in the list, or **Tree Tools → Open Tree Workspace**. |
| **Window** | Opens in its **own macOS window**. **Not** a larger copy of Overview. |
| **Feel** | The bonsai’s personal workspace. The database supports the tree; it does not dominate the screen. |
| **Chapters** (permanent IA; ship incrementally) | **Now** · **Timeline** · **Gallery** · **Measure** · **Work** · **Journal** · **Collections** · **Design** · **Documents** · **Ownership** · **Assistant** — revealed by Experience Level (§5.2.5). |
| **Hero** | Dominant photo plane; identity beside or below — not admin stickers on the image. |

#### 5.2.3 Navigation between Overview and Workspace

| Action | Result |
|--------|--------|
| One-click / list selection | **Tree Overview** in the Garden → Trees split view |
| Double-click tree row | Open or focus **Tree Workspace** for that Tree |
| **Tree Tools → Open Tree Workspace** | Same |
| From Workspace: **Show in Library** / **Reveal in List** | Focus main window; select the Tree; show **Tree Overview** |
| Close Workspace window | Main library unchanged; list selection preserved |
| From Collections member list | Same one-click / double-click rules |
| Show on Map | Jump to Locations (orbiting module) — does not replace Workspace |

**Do not** open Workspace on every single-click (destroys browse rhythm).  
**Do not** implement Workspace as Overview with more cards.

#### 5.2.4 Window behavior and synchronization

| Rule | Meaning |
|------|---------|
| **Multi-window** | Multiple Tree Workspaces may be open at once (one or more Trees). Native multi-window on macOS first; mental model portable to other platforms. |
| **One Library** | Every Overview and every Workspace window operates on the **same** active Bonsai World Library. No per-window library fork. |
| **One Tree record** | Edits in Overview or Workspace write the **same** Tree (and related IDs). Botanical locks and lifecycle rules apply everywhere. |
| **Synchronization** | All open surfaces stay **synchronized** with library truth — when a Tree is saved in one window, other open Overview/Workspace views for that Tree reflect the update without inventing a second store. |
| **No second product** | Workspace is not a separate app, edition, or schema. |

#### 5.2.5 Experience Levels (Trees)

| Capability | Novice | Experienced | Expert |
|------------|--------|-------------|--------|
| Tree Overview (browse) | Presence + place + health; light Edit | + Situation density; disclosures | Full disclosures available |
| Open Tree Workspace | Yes | Yes | Yes |
| Workspace **Now** | Plain attention language | + task / work cues | + richer workshop links |
| Gallery | View Primary (Gallery Presentation); Add Image → Gallery | Tree-scoped Gallery browse + metadata | Library browse, Featured, Compare, AI *(Gallery-owned)* |
| Timeline / History | Simple history list | Filtered timeline | Full spine |
| Measure | Optional latest height | Full sessions | Trends / denser history |
| Work | Soft cues in Overview/Now | Register Work + history | Advanced work types |
| Journal | Optional short notes | Full tree-scoped journal | Rich + media refs |
| Design / Documents | Hidden | Teaser or optional Documents | Full Design + Documents |
| Ownership | One-line acquired if useful | Full acquisition | Acquisition + disposal / economy prep |
| Assistant | Hidden | Opt-in | Opt-in, richer |
| Classification / soil science | Behind botanical name | Available in disclosures | Dense |
| Delete Tree | Hidden | Hidden | Hidden until correction workflow (§4.5) |

#### 5.2.6 Future expansion (Trees)

Ship order is delivery planning; architecture stays fixed:

1. Calm **Tree Overview** (presence-first; end equal card warehouse).  
2. **Tree Workspace** v1 window (Presence + Now + Gallery + Measure).  
3. **Timeline** spine (photos, measurements, work, journal, lifecycle).  
4. **Work** + **Journal** chapters in Workspace.  
5. **Design** + **Documents** (Expert depth).  
6. **Assistant** scoped to this Tree (and optional Collection).  
7. Search/filter (including lifecycle), move-tree workflow, ephemeral list filters — without forking Overview/Workspace.

---

### 5.3 Locations

| Field | Definition |
|-------|------------|
| **Purpose** | Define **physical places** where trees live (benches, shelves, zones) within a **Garden** — the grower's physical property. UI keeps the shipped name **Locations**; "Habitat" is only an internal/roadmap term (see [Product Reviews/Locations_Habitat_Module.md](Product%20Reviews/Locations_Habitat_Module.md)). |
| **Primary Objects** | **Garden** (name, address/city/region/country, map position) — the property; **Location** (name, type, Garden reference, map position, **Environment Profile**: sun/shade, wind exposure, rain exposure, humidity, airflow, winter protection). |
| **Primary Workflow** | Pick a Garden (when more than one) → browse its Locations on map/list → open Detail → see Environment, weather risk warnings, and trees at that place → Edit location facts when needed → create New Location (defaults to the Garden being browsed). |
| **Navigation** | Workspace position **3**. Essential+. |
| **Context Tools** | **Global / context (planned when shipped):** New Location; Edit Location; *(hide unfinished)*. **Edit Mode:** Save; Cancel; Reset Changes. |
| **Detail View** | Single detail column — no duplicate inline "trees here" list. Header (name, type, Garden, tree count, work dates); Environment card (every Environment Profile field, "Not set" placeholder when absent, weather risk bullets when available); Notes card; Trees Here card. View by default; Edit intentional. |
| **Reference Data** | Location Type is shared Reference Data; Garden and Location records themselves are owned here (not reinvented inside Trees). |
| **Persistence** | Garden and Location are first-class Library records (`Database/Gardens.json`, `Database/Locations.json`) via the same repository pattern as Tree/Collection — not UserDefaults or in-memory-only. A one-time migration moves any pre-Library data in automatically the first time a Library is opened. |
| **Multi-Garden** | A Garden picker lets the grower browse any active Garden's Locations and map; "New Location" defaults to the Garden currently being browsed, not always the default Garden. |
| **Weather integration** | `WeatherRiskAssessment.locationRisks` combines a Location's Environment Profile with the current forecast (for example exposed + high wind → shelter warning; outdoor winter + forecast frost → cover warning) and surfaces the resulting bullets on Location Detail. **Known limitation:** Weather itself is still keyed to the **default Garden** only, so risk warnings for Locations in a non-default Garden reflect the default Garden's forecast until Weather gains its own multi-Garden pass. |
| **Relationships** | Many Trees reference one Location; one Location belongs to one Garden. Distinct from file **Storage**. Collections do not set Location. |
| **Future Expansion** | Per-Garden weather; Location capacity; climate notes — without merging into Storage or Collections. |

**Status:** Partial (master/detail reference module with real Library persistence, map, Environment Profile, weather risk warnings, and multi-Garden browsing implemented; per-Garden weather forecasting not yet implemented).

---

### 5.4 Collections

| Field | Definition |
|-------|------------|
| **Purpose** | Provide **focused working sets** of trees so the grower can concentrate on a purpose, characteristic, task, or relationship — without altering the underlying Tree library. Full philosophy: **§4.4**. |
| **Primary Objects** | **Collection** — name, description, optional icon/color, **type** (Manual or Smart), **`treeIDs`** (Manual membership; authoritative), **smart rules and sort** (Smart; membership computed). Manual Collections may store **custom member order**. |
| **Primary Workflow** | Enter Collections → **auto-select** first Smart Collection, else last opened, else first Manual (§4.4) so Detail is never empty when Collections exist → scan member trees → **one-click** opens **Tree Overview**, **double-click** opens **Tree Workspace** (§5.2); **New Collection** → Manual create; adjust Manual membership from Tree or Collection Detail; Smart membership rules planned. |
| **Navigation** | **Three-pane module:** Sidebar → **sectioned Collection List** (Smart Collections / My Collections) → Collection Detail. **No** extra column for Collection Types. Workspace: Version 1 position **4**; Version 2 **Garden → Collections**. Essential+. Full model: **§4.4 Collection navigation**. |
| **Context Tools** | **Context:** New Collection *(shipped — Manual only until Smart ships)*. Add Existing Tree *(shipped)*. Edit Collection *(shipped — metadata: name, description, icon, color)*. Membership changes must not duplicate as a second **Add Tree**. **Edit Mode:** Auto Save; **Finish** leaves Edit Mode (same pattern as Tree Overview). Smart rules editing — hide until Smart Collections ship. |
| **Detail View** | Always shows a selected Collection when any exist (§4.4 default selection). “Select a Collection” only when the library has **zero** Collections. View members; Edit for metadata, Manual membership, Smart rules, and optional custom order when implemented. Member **one-click** → **Tree Overview**; **double-click** → **Tree Workspace** (§5.2). UI does **not** expose “Manual Collection” / “Smart Collection” as separate module names — only **Collections**, grouped in list sections. |
| **Reference Data** | None required for core membership; Smart rules may reference botanical, Location, care, and Tree fields. Optional labels later via Settings lists. |
| **Relationships** | Many-to-many with Trees — **Collections own membership** (§4.4). **Never** determines Location. **Favorite Trees** may be a system Smart Collection over Tree `isFavorite`. Dashboard surfaces **attention-oriented** Collections (§5.1). Tasks module owns completion; Smart Collections such as Water Today are browse/plan lenses, not task records. Member presentation **respects Tree lifecycle status** (§4.5) — default views emphasize Active trees unless the Collection or filter asks otherwise. |
| **Future Expansion** | List sections (**Smart Collections** / **Your Collections**); persist last-selected Collection; system Smart Collections; additional Smart rule types (including lifecycle status); Dashboard pinning; Bonsai Assistant may scope conversation to a Collection — without mutating membership silently. |

**Status:** Partial (three-pane list/detail with Smart / My sections, system Smart placeholders, Manual membership, Edit Collection metadata, default selection). Smart filter evaluation, Tree `isFavorite`, and custom order — **Planned** per §4.4.

---

### 5.5 Gallery (Image Library)

| Field | Definition |
|-------|------------|
| **Purpose** | **The Image Library of Bonsai World** — visual browser and **workflow owner for `photo` / `video` Assets** (§3.6). Prepare, Primary, Featured, compare, and image AI operate on Assets; the **Asset System** owns records and blobs. |
| **Primary Objects** | **photo** / **video** Assets; **Presentation** (display crop on photo Assets); **Primary** / **Featured** link roles; tags and visual metadata. Trees store **Asset link references** — not duplicate image records. |
| **Ownership** | **Asset System** owns all Asset records and blobs. **Gallery** owns **photo/video workflows**: Prepare; Primary; Featured; visual browse; compare; image AI. Tree Overview / Workspace / Detail **display** Gallery-resolved Presentations and offer **shortcuts** — never own Assets. Dashboard, Collections, Mobile, Assistant **read** linked Assets. **Quick Capture** creates Assets; Gallery enriches photo Assets after link (§3.6). |
| **Display rule** | **Presentation (display crop) is the default visual everywhere** — Tree Workspace, Tree Overview, Dashboard, Collections, Mobile, Assistant, list thumbnails. Original is archive + re-edit source; **Show Original** is optional (Experienced+). Original is **never** overwritten. |
| **Primary Workflow** | Import / receive → store Original → optional Prepare → link to Tree(s) → set Primary / Featured → browse / organize / compare. Entry: **Media → Images**, Tree shortcuts, Quick Capture route. |
| **Navigation** | **Media → Images** (library-wide visual browser). Essential+. Tree Workspace **Images chapter** = browse **filtered to one Tree** — same engine, not a second product. **Garden** owns living bonsai only (Trees, Collections). |
| **Context Tools** | **Global:** Import Photos. **Context:** Prepare Photo; Set Primary; Set Featured; Compare; Organize; Edit Metadata / Tags. Tree **Add Image** / **View Images** = shortcuts into Media. |
| **Detail View** | Image detail: Presentation preview, metadata, tags, links to Trees/Collections, Prepare, Compare, Primary/Featured actions. Does not edit botanical identity. |
| **Reference Data** | Optional tag vocabularies from Settings later. |
| **Relationships** | Serves **Trees** (Primary presence), **Dashboard** / **Collections** (Featured), **Journal** / **Inventory** (media refs), **Assistant** (read-only context). Uses shared Images / Storage infrastructure; **product owner is Gallery**. Distinct from Settings → Library Management Import (§8.1). |
| **Experience Levels** | **Novice:** Import, Primary, simple browse (All, By Tree, Latest). **Experienced:** Prepare, tags, Featured, richer filters. **Expert:** Compare, Before/After, timeline browse, AI assists. One schema (§1.1, §6). |
| **Future Expansion** | Full browse catalog (§5.5.3), albums, export, AI analysis — always under Gallery Image Library. |

**Status:** **Image Library architecture approved.** **Media → Images** browse **Partial** (read-only grid). Internal `Gallery*` types remain implementation names. Interim photo UI in Tree Detail must migrate to Media ownership.

#### 5.5.1 Image lifecycle (Media-owned workflows; Gallery internal)

```text
Enter Library → Original (immutable) → Prepare → Presentation (display crop)
    → link to Tree / pool → Primary · Featured → displayed everywhere
    → re-edit / compare / AI → unlink or delete (policy)
```

| Stage | Rule |
|-------|------|
| **Original** | Never overwritten; provenance preserved. |
| **Presentation** | Non-destructive recipe + baked render; default display asset. |
| **Primary** | One Presentation per Tree for presence (Overview, Workspace, list). |
| **Featured** | Optional library prominence for browse / Dashboard / Collections — independent of Primary. |
| **Display** | All modules resolve Presentation via Gallery — not raw Original. |

Prepare tool design: [Product Reviews/Photo_Crop_Workflow.md](Product%20Reviews/Photo_Crop_Workflow.md). Asset foundation: [Product Reviews/Asset_Architecture.md](Product%20Reviews/Asset_Architecture.md). Image Library definition: [Product Reviews/Gallery_Image_Library.md](Product%20Reviews/Gallery_Image_Library.md).

#### 5.5.2 Gallery ↔ Tree Workspace

| Tree Workspace | Gallery (Image Library) |
|----------------|-------------------------|
| Shows Primary / filmstrip (read-only) | Owns all image state and edits |
| Gallery chapter = browse this Tree | Same engine, tree-filtered view |
| Shortcuts: Add Image, View Images, Prepare, Set Primary | Executes workflows |

Tree Workspace **must not** host crop, metadata admin, tags, or AI tools. Same rule for Tree Overview.

#### 5.5.3 Browse views (permanent IA; ship incrementally)

Library-wide visual browser — one catalog, many filters:

All images · Primary images · Featured images · Latest · By Tree · By Species · By Location · By Collection · By Pot · By Tool · By Yamadori · Unattached · Before/After · Timeline

Browse views are **filters** (menu on Media → Images), not separate stores. Tree-scoped Images (Overview filmstrip, Workspace chapter) uses **By Tree**.

#### 5.5.4 Delivery roadmap

1. **Tree-scoped Gallery** — browse one Tree; set Primary; Import entry.  
2. **Prepare** — non-destructive display crop (Presentations).  
3. **Library Images** — **Media → Images**; global browse (All, Latest, Primary).  
4. **Featured + tags** — prominence and filters.  
5. **Compare / Before-After / Timeline browse**.  
6. **AI image analysis** — Gallery only.

---

### 5.6 Propagation

| Field | Definition |
|-------|------------|
| **Purpose** | Develop new material (seeds, cuttings, air layers, grafts) that may become Trees. |
| **Primary Objects** | Propagation records per method (Seeds, Cuttings, Air Layering, Grafting — as specified when built). |
| **Primary Workflow** | Track material → care steps → graduate into a **Tree** when ready (explicit workflow). |
| **Navigation** | Workspace position **6**. **Advanced+ only** (hidden in Essential). |
| **Context Tools** | Method-specific New / Edit / Graduate to Tree *(when shipped)*. Edit Mode: Save; Cancel; Reset Changes. |
| **Detail View** | View material status; Edit care fields. Graduation creates/links a Tree without bypassing botanical create rules. |
| **Reference Data** | Botanical Library and care lists as needed; does not fork taxonomy. |
| **Relationships** | Feeds **Trees**; may note source Location; does not replace Locations or Tree identity. |
| **Future Expansion** | New methods as sub-workflows inside Propagation — not separate apps or schemas. |

**Status:** Planned. Domain must remain representable while hidden. Distinct from **Yamadori** (§5.10) — Propagation is controlled nursery methods; Yamadori is wild-material **projects**.

---

### 5.10 Yamadori

| Field | Definition |
|-------|------------|
| **Purpose** | **Long-term project management** for discovering, evaluating, preparing, and collecting trees from nature. Not a list of Trees — a **Yamadori Project** may exist for years before graduation. Principle: *Observe. Prepare. Collect. Develop.* Rationale: [Product Reviews/Yamadori_Module.md](Product%20Reviews/Yamadori_Module.md). |
| **Primary Objects** | **YamadoriProject** — status, wild-site GPS, access/permission notes, evaluation (estimated species/age, difficulty, priority), root prep and collection plans, timeline, **`linkedTreeID`** after graduation. Media via **Asset links** (§3.6) — not embedded blobs. |
| **Primary Workflow** | Discover → register GPS + Assets → observe (seasonal) → evaluate → plan/execute root prep → plan collection → collect → **Graduate to Tree** (Add Tree wizard) → project **archived** as permanent history. |
| **Navigation** | **Nursery → Yamadori** (Architecture Version 2 §10.2). **Experienced+** (hidden in Novice Essential). List → Project Detail → **Yamadori Tools**. |
| **Context Tools** | **Global (when shipped):** New Yamadori Project. **Context:** Add Observation; Link Asset; Plan Collection; Log Root Prep; **Graduate to Tree** *(when status allows)*. Edit Mode: Save; Cancel; Reset Changes. |
| **Detail View** | View-first project: site map pin, timeline, linked Assets (Gallery browse), plans, permission/access, evaluation fields. Graduate opens **Add Tree** pre-fill — botanical identity confirmed at collection, not at discovery. |
| **Reference Data** | Botanical Library for **estimates** only until graduation; Work Types for linked Workshop records. |
| **Relationships** | **Assets** (photos, voice, GPS), **Quick Capture** / **Mobile Companion** (field entry), **Gallery** (photo workflows on Assets), **Calendar** (collection/root-prep events), **Workshop** (root prep work records), **Journal** (observations), **Add Tree** (graduation), **Assistant** (read-only project scope). Wild site GPS ≠ grower **Location** (bench assigned at graduation). Smart Collection “Yamadori” = **Trees**, not projects (§4.4). |
| **Experience Levels** | **Novice:** hidden. **Experienced:** register, observe, Assets, basic evaluate, graduate. **Expert:** full planning, weather log, helpers/equipment, Calendar/Workshop integration, Gallery compare, Assistant. One schema (§6). |
| **Future Expansion** | Project export/report; map clusters of active sites; permission renewal reminders — same YamadoriProject architecture. |

**Status:** **Architecture approved.** Implementation **Planned**. Domain must remain representable while Nursery route is placeholder.

#### 5.10.1 Yamadori project statuses

`discovered` · `observing` · `evaluating` · `root_prep_planned` · `root_prep_active` · `collection_planned` · `collection_scheduled` · `collected` *(linked Tree)* · `abandoned` · `access_lost` · `in_situ_lost`

#### 5.10.2 Graduation rule

**Graduate to Tree** creates a **Tree** via **Add Tree** (§5.2) — estimated fields pre-fill; grower confirms botanical identity. Project record is **read-only archive** with `linkedTreeID`. Original project documentation is **never** discarded on graduation.

---

### 5.7 Journal

| Field | Definition |
|-------|------------|
| **Purpose** | Chronological observations and notes about trees and care. |
| **Primary Objects** | **Journal entry** (date, text, linked Tree IDs, optional media refs). |
| **Primary Workflow** | Browse timeline → open entry → Edit; create New Entry from **Journal Tools** or from a Tree. |
| **Navigation** | Workspace position **7**. Essential+. |
| **Context Tools** | New Entry; Edit Entry *(when shipped)*. Edit Mode: Save; Cancel; Reset Changes. |
| **Detail View** | View entry; Edit body and links. Not a task checklist (Tasks owns completion). |
| **Reference Data** | Optional work types / tags from Settings. |
| **Relationships** | Links to **Trees** (and optionally Gallery). Complements Tasks/Calendar without owning scheduling. |
| **Future Expansion** | Filters by tree/season; rich media — same entry architecture. |

**Status:** Planned.

---

### 5.8 Calendar

| Field | Definition |
|-------|------------|
| **Purpose** | Time-based care windows and scheduled work. |
| **Primary Objects** | **Calendar events / care windows** (dates, linked Trees or Tasks as decided). |
| **Primary Workflow** | Browse by date → open event → Edit; add event for seasonal care. |
| **Navigation** | Workspace position **8**. Essential+. |
| **Context Tools** | Add Event; Edit Event *(when shipped)*. Edit Mode: Save; Cancel; Reset Changes. |
| **Detail View** | View schedule item; Edit timing and links. Does not redefine Task completion state. |
| **Reference Data** | Optional care categories from Settings. |
| **Relationships** | Coordinates with **Tasks** and **Trees**; may surface on Dashboard. |
| **Future Expansion** | Recurrence, season templates — without absorbing Tasks or Journal. |

**Status:** Planned.

---

### 5.9 Tasks

| Field | Definition |
|-------|------------|
| **Purpose** | Actionable care work items and completion. |
| **Primary Objects** | **Task** (title, status, due date, linked Tree IDs). |
| **Primary Workflow** | Browse open work → open Task → complete or Edit; create New Task. |
| **Navigation** | Workspace position **9**. Essential+. |
| **Context Tools** | New Task; Edit Task; Complete *(when shipped)*. Edit Mode: Save; Cancel; Reset Changes. |
| **Detail View** | View task; Edit fields; completion is first-class. Not long-form Journal narrative. |
| **Reference Data** | Work Types and similar lists from Settings. |
| **Relationships** | Links to **Trees**; may appear on Calendar/Dashboard; Projects (when specified) may group tasks without owning day-to-day task truth alone. Default care Tasks **respect Tree lifecycle status** (§4.5) — do not schedule routine care for Sold / Gifted / Dead / Lost unless the grower explicitly scopes to those trees. **Work** stays the single history of care performed — completing a Task never creates a second, competing history (see Tasks vs. Work below). |
| **Future Expansion** | Templates; iPhone companion delivering the same 07:00 / Overdue notifications — same Task object and **Task Tools** home. |

#### Tasks vs. Work

**Tasks** own completion of care that **should be done**; **Work** owns the historical log of care that **has been done** (Changelog 2026-08-28). Completing most Tasks opens the full **Add Work** form (Work Type, date, notes, fertilizer when required) — appropriate for infrequent, detail-worthy care such as repotting, wiring, or fertilizing.

**Routine, high-frequency Work Types — starting with Watering — are the exception.** Completing that Task is a single action with no form: it silently writes a minimal `WorkRecord` (linked Tree IDs + timestamp, no required notes) so care history and future Growing Intelligence recommendations are not lost, without asking the grower to fill out a form for something they may do daily. This keeps Work as the one source of care history while keeping Tasks' completion gesture light for care that repeats constantly.

**Missed watering expires.** Work Types flagged **Expires if missed** (Watering by default) cannot be done late — a forgotten watering is dropped, never listed as Overdue, and never notified. Recurring watering catch-up shows as due **today**. Fertilizing and similar care stay Overdue until completed. **Overdue** is its own Tasks horizon (not mixed into Today). Care reminders: today's tasks and overdue warnings fire at **07:00 local**; the same `CareNotificationPlanner` contract is what the iPhone companion will deliver (macOS local notifications are the current proof).

**Status:** Planned.

---

### 5.11 Inventory

| Field | Definition |
|-------|------------|
| **Purpose** | **Central register of physical items** the grower owns that support the bonsai hobby — pots, tools, soil, wire, infrastructure, books, exhibition gear. Not a flat equipment list; each **Inventory Item** is a durable ownership record. Principle: *Own it. Document it. Maintain it. Use it.* Rationale: [Product Reviews/Inventory_2.0_Module.md](Product%20Reviews/Inventory_2.0_Module.md). |
| **Primary Objects** | **InventoryItem** (kind, status, provenance, kind-specific attributes, optional stock fields); **StoragePlace** (where items live when not on a tree); **MaintenanceRecord** (service history, optional Workshop link). Media via **Asset links** (§3.6) — not embedded blobs. |
| **Primary Workflow** | Acquire → Register → Document (Assets) → Store → Use (assign pot to Tree, tools in Workshop) → Maintain → Retire (sold / lost / disposed / depleted). |
| **Navigation** | **Inventory** (Architecture Version 2 §10.2). **Expert+** (hidden Novice / Experienced default). Sectioned list: All Items + kind filters (Pots, Tools, Wire, Soil, …). |
| **Context Tools** | **Global (when shipped):** New Inventory Item. **Context:** Add Photo / Receipt; Log Maintenance; Assign to Tree *(pots)*; Adjust Stock *(consumables)*. Edit Mode: Save; Cancel; Reset Changes. |
| **Detail View** | View-first Item: identity, provenance, storage, linked Assets (Gallery browse), assignment, maintenance timeline, stock *(consumables)*. Kind drives progressive disclosure — one schema, not separate apps. |
| **Reference Data** | Consumes **Inventory Preparation** lists (Settings) as vocabulary — pot types, tool names, wire, chemicals, suppliers. Reference Data rows are **catalog labels**; Inventory Items are **owned instances**. Does not edit Reference Data inline. |
| **Relationships** | **Assets** / **Gallery** (photos, receipts, manuals); **Quick Capture** / **Mobile** (field capture → triage); **Workshop** (tools used, maintenance, repot); **Trees** (`currentPotInventoryItemID` — Tree displays, Inventory owns pot); **Economy** (reads purchase/value — never duplicates Items); **Dashboard** (low-stock attention card); **Assistant** (read-only Item scope). Distinct from **Locations** (tree benches) and **Knowledge** (learning content vs owned books). |
| **Experience Levels** | **Novice:** hidden. **Experienced:** hidden *(optional Dashboard stock glance reads Inventory)*. **Expert:** full module, stock, maintenance, insurance export *(future)*. One schema (§6). |
| **Future Expansion** | Insurance packs, maintenance reminders, tool lending, purchase planning, Workshop consumption — same InventoryItem architecture. |

**Status:** **Architecture approved.** Implementation **Planned**. Settings **Inventory Preparation** lists remain Reference Data until Items ship.

#### 5.11.1 Inventory kinds (filters — not separate stores)

`pot` · `growing_container` · `tool` · `turntable` · `display_stand` · `wire` · `soil` · `soil_component` · `soil_mix` · `fertilizer` · `chemical` · `consumable` · `greenhouse_equipment` · `irrigation` · `grow_light` · `sensor` · `camera` · `book` · `reference_material` · `exhibition_equipment` · `other`

Version 2 sidebar routes group these kinds for navigation calm — one **InventoryItem** catalog.

#### 5.11.2 Item statuses

`active` · `assigned` · `in_storage` · `on_loan` *(future)* · `maintenance_due` *(future)* · `depleted` · `retired` · `sold` · `lost` · `disposed`

Retirement preserves history — delete only for mistaken duplicates (same spirit as Tree Lifetime §4.5).

#### 5.11.3 Pot assignment rule

**Inventory owns the pot.** **Tree** holds optional `currentPotInventoryItemID`. Repot: end old assignment → assign new Item → optional Workshop Work. Tree Overview / Workspace **display** linked pot; **Assign Pot** shortcuts to Inventory picker — no second pot editor on Tree.

---

### 5.12 Media

| Field | Definition |
|-------|------------|
| **Purpose** | **Permanent home for all digital assets** in Bonsai World — browse, organize, and find photos, documents, notes, video, and audio. **Garden** owns living bonsai; **Media** owns digital content. Other modules (**Garden**, **Inventory**, **Yamadori**, **Journal**, …) **reference** Media assets via Asset links (§3.6) — they do not own blobs. |
| **Primary Objects** | **Asset** catalog (§3.6); per-type browse surfaces under Media routes. **Images** *(shipped)* — photo Assets and image workflows (§5.5). Future: Documents, Notes, Video, Audio routes. |
| **Primary Workflow** | Capture / import → Asset → link to owning module → browse in **Media** by type and filter → enrich (Prepare, metadata) in Media-owned workflows. |
| **Navigation** | Top-level **Media** (Version 2 §10). Sub-routes: **Images** *(shipped)*; Documents · Notes · Video · Audio *(future — `AppRoute.isShippedInNavigation`)*. |
| **Context Tools** | Type-specific when shipped (e.g. Images: Import Photos). Tree **View Images** opens Media → Images. |
| **Detail View** | Per media type. **Images:** read-only grid + preview *(Partial)*; editing workflows ship under §5.5. |
| **Reference Data** | Optional tag vocabularies (Settings) for visual Assets. |
| **Relationships** | **Asset System** (§3.6) owns records; **Images** surface owns photo browse/workflows (§5.5). **Gallery** remains valid as **internal** implementation naming (`Features/Gallery/`). Consumed by Trees, Dashboard, Collections, Inventory, Yamadori, Assistant. |
| **Experience Levels** | **Images** Essential+ (same as former Gallery). Future media types define level behaviour when shipped. |
| **Future Expansion** | Enable `mediaDocuments`, `mediaNotes`, `mediaVideo`, `mediaAudio` routes; unified Media search; cross-type Asset browse. |

**Status:** **Architecture approved.** **Images** browse **Partial**. Other media routes reserved in navigation enum — not in sidebar until shipped.

#### 5.12.1 Media route extension

```text
Media
├── Images          ← shipped (AppRoute.mediaImages)
├── Documents       ← future (AppRoute.mediaDocuments)
├── Notes           ← future (AppRoute.mediaNotes)
├── Video           ← future (AppRoute.mediaVideo)
└── Audio           ← future (AppRoute.mediaAudio)
```

To ship a new media type: set `isShippedInNavigation = true` on the route; add ContentView surface; implement browse under `Features/Media/` or extend existing type folder.

---

## 6. User Experience Levels & Workspace Profiles

**Status:** Approved. **Not implemented** in Settings UI yet.  
**Principle:** §1.1 *The Software Grows with the Artist* · Constitution §17 · Falo Progressive Disclosure + Growing with the Artist.

### 6.1 User Experience Levels (grower-facing)

| Level | Intent |
|-------|--------|
| **Novice** | Maintain and enjoy living trees with a calm daily loop. Few modules; essential fields; clear guidance. |
| **Experienced** | Develop material and craft with richer organization, care, and workshop depth. |
| **Expert** | Professional depth — design systems, inventory, economy, research, and advanced tools — without leaving the same library. |

**Default:** Novice (safe by default).

**What levels change**

- Presentation density (which Detail sections and Dashboard cards appear)  
- Navigation (which modules and sub-routes are visible)  
- Guidance (empty states, teaching copy, progressive hints)  
- Available tools (**Context Tools**, editors, advanced workflows)

**What levels never change**

- The underlying data model or library format  
- Domain ownership (Trees remain Trees; Collections own membership; etc.)  
- Compatibility of workflows — advancing must not break Novice-created data  
- Storage provider selection

### 6.2 Workspace Profiles (implementation mapping)

Workspace Profiles are the **settings mechanism** that realize Experience Levels. Grower-facing language prefers **Novice / Experienced / Expert**. Profile names below remain valid for documentation continuity until Settings UI ships.

| Experience Level | Profile (legacy name) | Module visibility (baseline) |
|------------------|----------------------|------------------------------|
| **Novice** | Essential | Dashboard, Garden (Trees, Collections), **Media (Images)**, Locations, Workshop (Tasks, Calendar as shipped), Settings |
| **Experienced** | Advanced | Novice + Nursery / Propagation; richer Garden and Workshop surfaces |
| **Expert** | Complete | Experienced + Design, Inventory, Knowledge (as module), Economy, Exhibition, Research, Analytics, Breeding, further tools |

Exact leaf-route visibility is refined as Version 2 modules ship; the table is the **visibility intent**, not a second product matrix.

**Rules**

1. Visibility and disclosure only — one data model.  
2. Free switching between levels; no data loss.  
3. Independent of licensing.  
4. Settings always reachable.  
5. Reserve **Settings → Workspace → Experience Level** (or Workspace Profile) — do not implement until scheduled.  
6. **Every future feature** must document Novice / Experienced / Expert behaviour in the Blueprint (module template §4.2) before coding.

**Projects** (planned): care-oriented; Novice/Experienced until its full module template is written. **Settings** (Tools): preferences, Reference Data, Experience Level, **Library Management** (§8.1) — always available; template when expanded.

---

## 7. UI framework (Bonsai World)

Specializes the Falo Design System. **All modules in §5 must reuse these patterns.** Do not invent parallel UI. Experience Levels (§1.1, §6) specialize *how much* of each pattern is revealed — never a second shell.

Cross-platform: shared **mental model**; native chrome may differ (split vs stack).

### 7.1 Workspace areas

```text
Sidebar
├── Workspace          (navigation — top, scrollable)
├── Context Tools      (actions — bottom anchor, dynamic title)
└── Tools              (Settings — bottom)
Content List → Detail View → Inspector (future)
```

| Area | Responsibility |
|------|----------------|
| **Sidebar — Workspace** | Where can I go? Filtered by **User Experience Level** / Workspace Profile (§6). No duplicate Create/Edit/Save in navigation rows. |
| **Content List** | What am I working with? Selection drives Detail and refines Context Tools. |
| **Detail View** | What is this? View Mode by default; Edit on demand via Context Tools. For Trees, the embedded Detail is **Tree Overview** (§5.2.1). |
| **Sidebar — Context Tools** | What can I do here? **Sole action home.** Title reflects workspace (Tree Tools, Collection Tools, …). See **§7.2**. |
| **Sidebar — Tools** | Settings and library administration entry (§8.1). Not domain work. |
| **Inspector (future)** | Optional supporting context — never a second Edit or action home. |
| **Tree Workspace windows** | Same shell: Workspace + **Context Tools** + Tools (§5.2.2–§5.2.4). |

Trees use **two depths**: Overview inside the split view; Workspace in its own window. Both follow View/Edit and Context Tools; both share library synchronization (§5.2.4).

### 7.2 Context Tools

**Status:** **Approved.** Replaces user-facing **Quick Actions**. Rationale: [Product Reviews/Context_Tools.md](Product%20Reviews/Context_Tools.md).

**Principle:** *One place. The right tools for where you are.*

#### 7.2.1 Sidebar placement

Context Tools occupy the **bottom of the left sidebar**, above **Tools** (Settings). Location is **fixed** across all workspaces and platforms; only the **title and command list** change.

#### 7.2.2 Workspace-scoped titles

| Active workspace (examples) | Section title |
|----------------------------|---------------|
| Garden → Trees, Tree Workspace | **Tree Tools** |
| Garden → Collections | **Collection Tools** |
| Media → Images | **Image Tools** |
| Locations | **Location Tools** |
| Workshop → Work / Calendar / Tasks | **Work Tools** / **Calendar Tools** / **Task Tools** |
| Inventory | **Inventory Tools** |
| Dashboard | **Dashboard Tools** |
| Settings | *(empty — Tools region suffices)* |

Pattern: **`{Workspace} Tools`**. Never use “Quick Actions” as the primary navigation label.

#### 7.2.3 Scope resolution

```text
AppRoute + selection + View/Edit mode + window kind + Experience Level
    → Context Tool Scope → catalog + title
```

**Retire Global / Context split:** there is no permanent cross-module tool block. Commands belong to the **active workspace** (e.g. Add Tree → **Tree Tools** when in Garden → Trees). Library **Import / Export** → **Settings → Library Management** only (§8.1).

#### 7.2.4 Rules

1. Every domain action in **one** place — Context Tools only.  
2. **View (default):** workspace-appropriate tools; selection refines the list.  
3. **Edit Mode:** **Save · Cancel · Reset Changes** only (plus **Finish** where Auto Save modules define it).  
4. Unfinished tools **hidden** — not shown as disabled placeholders.  
5. Destructive tools last; hidden until policy allows (e.g. Tree Lifetime §4.5).  
6. Detail headers and floating toolbars **must not** duplicate Context Tools (migrate `DetailHeader` overflow menus away).  
7. Keyboard shortcuts and context menus may invoke Context Tools commands — they do not define a second home.

#### 7.2.5 Cross-platform

macOS, Windows, Linux, and Web share the same scopes and catalogs. Narrow viewports may render Context Tools as a **bottom bar** or sheet — same mental model, platform adapter only (§2 platform independence).

### 7.3 View Mode / Edit Mode

| Mode | Behavior |
|------|----------|
| **View (default)** | Read-only; Edit via Context Tools |
| **Edit** | Draft until Save or Cancel; Reset restores last commit |

**Always read-only in operational detail:** botanical identity after create; system IDs as primary UI; derived botanical labels as free-text source; Reference Data definitions.

### 7.4 Navigation order

Matches §5 positions: Dashboard → Trees → Locations → Collections → Gallery → Propagation → Journal → Calendar → Tasks. Tools (Settings) outside this sequence.

### 7.5 Consistency patterns

Lists, Detail, Editors, Sheets, Dialogs/confirmations, Empty states — as previously defined: human scanning, View-then-Edit, one next step via Context Tools, empty Reference Data → Settings.

### 7.6 Native First

Prefer platform-native controls. Custom controls need a clear usability benefit.

---

## 8. Other modules (template required before build)

| Module | Role | Note |
|--------|------|------|
| **Settings** | Preferences, Reference Data / Botanical Library, Experience Level, **Library Management** (§8.1) | Tools group; always visible |
| **Projects** | Structured care efforts | Planned; write full §4.2 template (including Experience Levels) before implementation |
| **Exhibition / Research / Analytics / Breeding** | Expert-depth | Planned; each needs the standard template |

### 8.1 Library Management

**Status:** Approved product structure. **Not implemented** in Settings UI yet.

Library administration is **not** part of the daily bonsai workflow. Growers care for trees in Workspace modules; they administer the **Bonsai World Library** file package in Settings.

```text
Settings
└── Library Management
    ├── Import
    ├── Export
    ├── Backup
    ├── Restore
    ├── Validate Library
    └── Library Diagnostics
```

| Function | Purpose |
|----------|---------|
| **Import** | Bring trees / catalog data into the active library (e.g. Excel, future interchange formats). |
| **Export** | Leave with a portable copy of library data. |
| **Backup** | Create a recoverable snapshot of the library package. |
| **Restore** | Replace or recover the library from a backup. |
| **Validate Library** | Check package integrity and structural consistency. |
| **Library Diagnostics** | Support / troubleshooting information (paths, provider, health) — never a daily care surface. |

#### Design principles

1. **Main navigation stays on daily bonsai work** — Dashboard, Garden, Locations, Workshop, and related modules. No Import / Export / Backup leaf in Workspace.  
2. **Administrative tools belong in Settings** — discoverable under Tools → Settings → Library Management.  
3. **Progressive Disclosure** — a single Library Management pane lists the functions; deep options appear when a function is chosen.  
4. **Experience Levels** — Library Management remains available at **all** levels (library ownership is universal). Novice sees clear Import / Export / Backup / Restore. Validate and Diagnostics may be quieter or secondary until Experienced/Expert — never hidden so far they are undiscoverable.  
5. **Unobtrusive but findable** — not Context Tools for routine library admin; optional rare entry from First Launch / empty-library guidance may deep-link to Settings.

#### Relationship to other Settings panes

| Settings area | Owns |
|---------------|------|
| **User Profile / Regional / Appearance / Notifications** | Person and preferences |
| **Workspace / Experience Level** | How much of the World is revealed (§6) |
| **Reference Data / Botanical Library** | Master vocabulary inside the library |
| **Library Management** | The library **package** as a whole (in/out, integrity, recovery) |

Library Management does **not** replace Reference Data editing or Tree add workflows. **Add Tree** remains in **Tree Tools** (Garden → Trees). **Import Photos** (camera rolls / tree images) is **Media-owned** (§5.5) — Tree **Add Image** is a shortcut into Media workflows. Distinct from full-library **Library Management → Import**.

#### Impact on future Import / Export

1. Implement Import and Export **only** under Settings → Library Management (complete §4.2-style Settings pane notes before coding).  
2. Do **not** add Library Import as a permanent Context Tool or Workspace module.  
3. First-launch / empty-library copy may link to Import here without promoting admin into daily chrome.  
4. Import must follow naming and domain rules (preserve imported names; Collections only when data supports them; no invented values) — same library schema; no edition fork.  
5. Export / Backup / Restore operate on the **StorageProvider** library package (§3); they never invent a second database product.

---

## 9. Current product status

**Partial.** Shell: `NavigationSplitView`, Falo sidebar (**Workspace · Context Tools · Tools**), title **Bonsai World**. Locations, Collections, and Trees (list → embedded detail, View/Edit, Context Tools *implementation still uses Quick Actions naming in code*) on TreeService / library persistence. Reference Data and Botanical Library in Settings (session). Image import for primary image prepared (**interim in Tree Detail** — **Gallery owns image workflows** §5.5; Gallery module surface Planned). Storage Phase 1 foundation present; Experience Level / Workspace Profile UI not complete. Sidebar order in code may still lag §7.4 / §10 — **§10 / §5 navigation is the product truth**. **The Software Grows with the Artist** (§1.1) and **User Experience Levels** (§6) approved; Settings control not yet implemented. **Library Management** under Settings (§8.1) approved — Import / Export / Backup / Restore / Validate / Diagnostics not yet implemented. **Collection philosophy (§4.4)** — three-pane navigation, sectioned list, system Smart placeholders, default selection — and **Tree Lifetime (§4.5)** approved; Smart filter evaluation not yet implemented. **Tree Overview + Tree Workspace** (§5.2) **approved** as permanent Trees architecture — Overview redesign and Workspace window **partial** (dedicated Workspace window exists; Overview layout redesign not yet implemented).

When the product changes, update **this Blueprint**. When philosophy changes, update the **Constitution**. When shared Falo patterns change, update the **Design System** or **Component Library**. When a **new module** is proposed, complete the **§4.2 template** here before coding.

---

## 10. Architecture Version 2

**Status:** Active navigation architecture (permanent application structure).  
**Relationship to Version 1:** Version 1 (§5 / §7.4) remains historical product context. Version 2 **supersedes** Version 1 navigation order and module ownership. Do not overwrite Version 1 sections above.

### 10.1 Navigation philosophy

Bonsai Hub (Bonsai World) is organized around how bonsai enthusiasts naturally think and work.

- The application must be understandable without reading a manual.
- Every module has **one clear responsibility**.
- **One concept = one name** — avoid duplicated concepts and synonym drift.
- Future modules must fit naturally into this structure.
- Architecture stays modular: leaf routes can ship incrementally without reshaping the sidebar.

Main navigation order (permanent):

1. **Dashboard**
2. **Garden**
3. **Media**
4. **Locations**
5. **Workshop**
6. **Nursery**
7. **Care**
8. **Design**
9. **Inventory**
10. **Knowledge**
11. **Economy**
12. **Settings** (Tools group)

### 10.2 Module responsibilities

| Module | Responsibility | Contains / prepares |
|--------|----------------|---------------------|
| **Dashboard** | Daily overview | Today's Tasks, Notifications, Calendar, Recent Activity, Quick Statistics; **attention-oriented Collections** (§4.4) |
| **Garden** | Living bonsai collection | Trees (**Tree Overview** + **Tree Workspace** — §5.2), **Collections** (Manual and Smart working sets — §4.4) |
| **Media** | Digital assets — browse, organize, find | **Images** *(shipped)*; Documents · Notes · Video · Audio *(future routes reserved — §5.12)* |
| **Locations** | Where trees physically grow | Gardens (physical properties), Locations, Map; future environment (Sun, Shade, Wind, Rain, Humidity, Air Flow, Winter Protection) — no calculations yet |
| **Workshop** | All practical bonsai work | Work, Calendar, Tasks; future work types (Wiring, Pruning, Repotting, Root Pruning, Watering, Fertilizing, Deadwood, Winter Preparation, Winter Wash) — no new work logic yet |
| **Nursery** | Development of new bonsai material | Seeds, Cuttings, Air Layers, Grafting, **Yamadori** (§5.10 — wild-material **projects**), Propagation (§5.6), Development |
| **Care** | Daily care and recommendations | Today, Watering, Fertilizing, Placement, Tree Health, Seasonal Care, Winter Care — recommendations from Growing Intelligence later |
| **Design** | Creative planning and artistic development | Vision, Style, Front Selection, Virtual Design, Branch Plan, Trunk Development, Ramification, Apex, Deadwood, Timeline — no design tools yet |
| **Inventory** | Physical asset register (single source of truth for owned items) | All Items + kind filters: Pots, Growing Containers, Tools, Turntables & Stands, Wire, Soil & Components, Fertilizers & Chemicals, Consumables, Infrastructure (greenhouse, irrigation, lights, sensors), Studio & Exhibition (cameras), Library (books, reference). **InventoryItem** + **StoragePlace** — §5.11. Stock alerts and lending ship incrementally on same schema. |
| **Knowledge** | Learning and education | Quick Guides, Bonsai Handbook, Species Library, Soil Guides, Fertilizer Guides, Video Tutorials, Courses, FAQ, External Links — no content yet |
| **Economy** | Financial overview | Purchases, Sales, Expenses, Income, Tree Value, Pot Value, Inventory Value, Reports — no calculations yet |
| **Settings** | Preferences and system | User Profile, Regional Settings, Reference Data, Appearance, Notifications, Experience Level / Workspace, **Library Management** (Import, Export, Backup, Restore, Validate Library, Library Diagnostics — §8.1) |

### 10.3 Design principles

1. **One responsibility per module** — if a feature fits two modules, choose the grower’s mental model, not the technical convenience.
2. **Consistent naming** — the same concept keeps the same name in navigation, domain language, and documentation.
3. **Migration without deletion** — existing behaviour moves under Version 2 ownership; data models are not removed for navigation refactors.
4. **Placeholders are structural** — empty routes establish permanent homes; they do not imply shipped behaviour. Visibility still respects Experience Levels (§6) when Settings ships.
5. **Incremental delivery** — implement one route at a time inside this shell; do not invent parallel navigation trees.
6. **Falo shell unchanged** — **Workspace · Context Tools · Tools**; visual language follows the Falo Design System.
7. **The Software Grows with the Artist** — one product and data model; Novice / Experienced / Expert reveal depth without forking the World (§1.1, §6).
8. **Library administration in Settings** — Import / Export / Backup / Restore / Validate / Diagnostics under **Library Management** (§8.1); never primary Workspace navigation.
9. **Trees: two depths** — **Tree Overview** for browse; **Tree Workspace** for deep craft in its own window; one Library, synchronized (§5.2).

### 10.4 Migration notes (Version 1 → Version 2)

| Version 1 | Version 2 home |
|-----------|----------------|
| Dashboard | Dashboard |
| Trees | Garden → Trees |
| Collections | Garden → Collections |
| Gallery / Images (§5.5) | **Media → Images** |
| Locations | Locations → Locations / Map (Gardens prepared) |
| Work | Workshop → Work |
| Calendar | Workshop → Calendar |
| Tasks | Workshop → Tasks |
| Propagation | Nursery (Seeds … Development) |
| Journal | Reserved working domain; not a Version 2 top-level module |
| Settings | Settings (unchanged ownership) |

Code mapping: `AppModule` (top-level) + `AppRoute` (leaf selection). `AppSection` is a compatibility alias for `AppRoute`.
