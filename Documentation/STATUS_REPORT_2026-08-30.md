# Bonsai World — Project Status Report

**Date:** 30 August 2026  
**Product name (user-facing):** Bonsai World  
**Engineering name (Xcode / folders):** Bonsai Hub  
**Platform shipping now:** native macOS (SwiftUI)  
**Last git commit on `main`:** `be40051` — *Establish Tree Workspace multi-window and library foundation*  
**Important:** Almost all work after that commit is still **local and uncommitted**. This report describes the **working tree as of 30 Aug 2026**, not only what is in the last commit.

This file is a briefing for discussion. It is **not** a governing document. Product truth remains: START_HERE → Constitution → Product Blueprint → Falo Design System / Component Library.

---

## 1. What this product is

Bonsai World is a calm, everyday place to organize a bonsai collection and support ongoing care.

It should help the grower know:

- what they have
- where it lives
- what needs attention
- what has been done

without turning care into administration.

**Trees are the core.** One product, one library, one data model. Experience Levels (Novice / Experienced / Expert) are approved architecture but **not implemented as a Settings control**. The grower is not supposed to switch products as they become more advanced.

Future clients (Windows, iPhone, Android) are an architectural target. Domain, services, and storage contracts are meant to stay platform-independent. Only pickers, notifications, and UI sit in a platform layer.

---

## 2. How the grower and the tools work together

Decisions that matter in practice:

- **One concept = one name.** Two names for the same action confuse the grower (example: they unified **Duplicate Tree Info**; they rejected **In Care** in the UI in favour of **My Trees**).
- **The grower decides design and labels.** The coding assistant must ask yes/no or numbered choices. It must not invent a third name “to be helpful.”
- **Confirm before coding.** Plan first; implement after explicit approval.
- **UI copy is English.** User content (location names, notes) may be Norwegian.
- **Documentation is the source of truth** — but several governing/status sections are **behind the code** (see §10).

---

## 3. Architecture (as built)

### 3.1 Layers

| Layer | Role |
|-------|------|
| **Views** (`Features/`, `Shared/`) | SwiftUI. Read/write only through services. |
| **Services** (`TreeService`, `TaskService`, `WorkService`, `ImageService`, `WeatherService`, `ReferenceDataService`, …) | One owner per rule. No SwiftUI in the write path where it matters for a future companion. |
| **Repositories** | Protocol + Library (JSON in the user-owned library package) + Preview (in-memory). |
| **Domain** | `Tree`, `Collection`, `Location`, `CareTask`, `CareSchedule`, `WorkRecord`, … Identifiers only — no file paths. |
| **Storage** | `StorageProvider` / `StorageService`. User-owned library folder. Images as originals + non-destructive presentation crops. |
| **Platform** | macOS pickers, image decode, care notification scheduling. |

### 3.2 Persistence (live)

User library JSON (not PreviewData-only anymore) for:

- Trees, Collections
- Gardens, Locations
- Work (`Database/Work.json`)
- Tasks (`Database/Tasks.json`)
- Schedules (`Database/Schedules.json`)
- Images (catalog + originals + presentation recipes)

Reference Data is still largely **session / Settings CRUD**, not a full Import/Export library admin story.

### 3.3 Shell

`NavigationSplitView`:

1. **Workspace** (sidebar modules)
2. **Quick Actions** (global + context) — code name still Quick Actions; Blueprint decided **Context Tools** (rename not shipped)
3. **Tools** (Settings)

Dedicated windows exist for: Tree Workspace, Image Workspace, Crop Workspace, Tree Image Viewer.

---

## 4. Navigation as shipped (code: “Architecture Version 3”)

Sidebar order in the running app (not the same as Blueprint §10 Version 2 list):

**Daily workflow**

1. Dashboard  
2. Tasks (Overdue, Today, This Week, This Month, This Year, Next Year)  
3. Garden → Trees, Collections, Locations (+ Map; Gardens sub-route reserved)  
4. Shaping (Vision, Style, Front, … — routes exist, not a real design studio)  
5. Care (Watering, Fertilizing, Repotting, Health, Seasonal, … — mostly placeholders)  
6. Nursery (Seeds, Cuttings, … Yamadori, Development — placeholders)  
7. Inventory (Pots, Soil, Wire, … — placeholders)

**Library group**

8. Media → Images (live), Videos / Documents (reserved), Notes / Audio (hidden)  
9. Knowledge (guides, handbook, … — placeholders)

**Tools**

10. Settings (profile, regional, reference data, appearance, notifications, …)

Blueprint §10 still lists Garden → Media → Locations → Workshop → Nursery → Care → Design → Inventory → Knowledge → Economy. **The app moved on.** Locations live under Garden. Tasks is a first-class module. Workshop / Economy are legacy route IDs, not sidebar modules.

---

## 5. Module status (honest)

Legend: **Live** = real data, usable every day. **Partial** = real pieces + gaps. **Shell** = route/heading only.

### 5.1 Dashboard — Partial (daily cockpit is real)

**Live**

- **My Trees** hero: counts (My Trees, Finished Bonsai, Development Trees, Yamadori, Without Status, Died/Sold/other outcomes when present) + species breakdown  
- **Tasks:** overdue + today (watering folded as Watering · N)  
- **Weather:** Open-Meteo for the default Garden position; today/tomorrow comparison; bonsai risk lines; 7-day strip  
- Wind display (30 Aug): **m/s** (metric), **mph** (imperial)  
- **Alerts:** overdue + weather risks  
- **Upcoming:** This Week / Month / Year / Next Year counts  
- **Trees Requiring Attention:** health Needs Attention / Recovering  
- **Library:** missing photo / status / species  
- **Recent Work**  
- **Collection Overview:** named My Collections  

**Not live (heading + “No function yet”)**

- Inventory Status  
- Repotting  
- Quick Statistics  

**Hidden:** Today's Care (replaced by Tasks)

Garden picker on Weather is reserved (not selectable yet).

### 5.2 Tasks — Live (strongest new module)

- One-off **Tasks** and recurring **Schedules** (interval or multiple times per day; optional season)  
- Targets: specific trees, a whole **Location**, or a whole **Genus**  
- Overdue vs Today; missed watering **expires** (never overdue)  
- Complete: instant Work for `expiresIfMissed` / schedule rows; otherwise Add Work form  
- Dedup when several rules hit the same tree + work type  
- Undo banner after complete  
- Manage Schedules (pause / delete)  
- Detail sheet from Tasks or Tree Detail → Tasks card  
- **Not yet:** edit/delete a Task or Schedule from the detail sheet  

### 5.3 Trees — Live (core catalog)

- **My Trees** + **Former Trees** (disposal set = former; view-only except Show on Map, View Images, Delete, Return to My Trees)  
- Add Tree menu: **New Tree** + **Duplicate Tree Info**  
- Generated Bonsai Name `GEN-SPE-CUL-YYYY-NNN`; unique; delete reuses lowest unused number; former trees keep their names  
- Genus + Species required  
- View / Edit (auto-save) on Tree Detail  
- Photos, measurements, pot, ownership, notes, timeline (Work), upcoming tasks  
- Tree Workspace window (double-click)  
- Quick Actions: Edit, Add Image, Duplicate Tree Info, Add/Remove Favorite Trees, Show on Map, View Images, Delete, Return to My Trees  

**30 Aug:** all tree lists use the same 36×48 photo (primary, else first gallery image; leaf icon only if none). Lists: Trees, Locations → Trees Here, Collections members, Add Existing Tree, Duplicate Tree Info, Add Task picker, Trees Requiring Attention.

### 5.4 Collections — Partial / Live for daily use

**My Collections** (manual, always open): create, edit, add/remove members.

**Smart Collections** (collapsed):

| Collection | Membership |
|------------|------------|
| Favorite Trees | Stored IDs — **Add to / Remove from Favorite Trees** in Quick Actions (30 Aug) |
| Today's Work | Live from Tasks → Today |
| Needs Water | Live: watering due today (`expiresIfMissed`) |
| Needs Repotting | Live: Repotting overdue through this month |
| Needs Photos | Live: My Trees with no photo |

**Former Trees** (collapsed, last): Died, Sold, Gifted, Donated, Exchanged, Lost — from disposal outcome.

### 5.5 Locations — Live

- Gardens + Locations persist in the library  
- Location Detail: map, details, environment profile, notes, Trees Here  
- Environment feeds weather risk text when the location is in the default Garden  
- Map of places / trees  
- Weather fetch is still **default Garden only**

### 5.6 Media / Images — Partial

- Media → Images browser, Image Workspace, Crop Workspace  
- Non-destructive display crop (per context: tree thumbnail, gallery card, …)  
- Original file is not rewritten  
- Rotate / Mirror: Coming Soon  
- Gallery as full “Image Library owner of all image workflows” is **approved**, not finished  
- Unified **Asset** model (photo/video/voice/PDF/…) is **approved**, not built  

### 5.7 Work — Live on the tree

- Add Activity → Work writes `WorkRecord`  
- Timeline on Tree Detail  
- Location “last work” can read real history  

### 5.8 Settings — Partial

- User profile / default Garden  
- Regional (measurement system, temperature)  
- Reference Data manager (botanical + lists, including redesigned Fertilizer Types)  
- **Coming Soon globally:** Search, Import  
- Library Management (export / backup / restore / validate): **not built**  
- Experience Level / Workspace Profile UI: **not built**

### 5.9 Shell modules that are not products yet

Shaping, Care (as its own module), Nursery, Inventory, Knowledge, Economy: **structural routes**. Inventory 2.0, Yamadori-as-project, Quick Capture / Inbox, Care recommendations (Growing Intelligence) are **decided on paper**, not shipped.

---

## 6. Product language (agreed — do not invent synonyms)

| Use this | Do not use |
|----------|------------|
| Bonsai World | Bonsai Hub (except engineering) |
| My Trees | In Care (UI) |
| Former Trees | Old Acquisition, “Care Smart” |
| Duplicate Tree Info | Duplicate Tree + Copy Existing Tree as two names |
| Add Tree | New Tree / Create Tree (UI) |
| My Collections / Smart Collections / Favorite Trees | New section names |
| Return to My Trees | Return to Care (UI) |
| Locations | Habitat (user-facing) |
| Quick Actions (what the grower sees today) | Context Tools (approved rename, not shipped) |

Internal IDs may still say `isInCare`, `returnToCareID`, `copyExistingTreeID`. That is engineering, not UI.

---

## 7. What shipped in the last few days (29–30 Aug)

Already in Changelog (29 Aug) plus working-tree work on 30 Aug:

- Collections list: same heading size; order My Collections → Smart Collections → Former Trees  
- Live Smart Collections (Needs Water, Today's Work, Needs Repotting, Needs Photos)  
- Favorite Trees toggle via Quick Actions (30 Aug)  
- Weather wind units m/s / mph (30 Aug)  
- Tree list photos everywhere, same size (30 Aug)  
- Dashboard cards filled with live data (gaps left visible)  
- Naming, uniqueness, delete-reuse, Former Trees view-only, Return to My Trees  

---

## 8. Known leftover (named only — grower picks)

Dashboard still empty:

1. Inventory Status  
2. Repotting  
3. Quick Statistics  

Global:

4. Search  
5. Import  

Product holes (already named in Blueprint / reviews, not invented here):

- Task / Schedule edit-delete from the detail sheet  
- Weather garden picker  
- Crop rotate / mirror  
- Context Tools rename  
- Experience Levels Settings  
- Library Management (backup / export / …)  
- Inventory 2.0, Yamadori project, Quick Capture, Care module as recommendations  
- Blueprint / Roadmap / §9 status text are **out of date** vs the app  

---

## 9. Risks / tensions worth discussing with a mentor

1. **Docs lag the app.** Blueprint §9 still says Smart Collections are placeholders and Gallery is planned. Roadmap “NOW/NEXT” still talks as if Tasks and Trees are future. Mentors reading only the Blueprint will misjudge maturity.

2. **Navigation truth split.** Blueprint Version 2 vs code Version 3 (Tasks first-class; Locations under Garden; Shaping not Design; no Workshop/Economy in the sidebar).

3. **Quick Actions vs Context Tools.** Approved product model is Context Tools; the grower still sees Quick Actions. Two names for one place.

4. **Huge uncommitted working tree.** Months of real product sit outside git. Backup and review risk is high. Last commit does not represent the app.

5. **No GitHub remote** at the time this report was written. The repo is local `main` only. ChatGPT cannot clone it until a remote exists and is pushed.

6. **Smart vs stored membership.** Favorite Trees uses stored IDs on a Smart Collection. Other Smart Collections resolve live. That mix is workable but should stay explicit.

7. **Scope gravity.** Inventory, Nursery, Knowledge, Economy, Growing Intelligence, Mobile Companion are designed early. The daily loop that is actually live is: Trees + Locations + Collections + Tasks/Work + Photos + Dashboard/Weather.

---

## 10. Suggested questions for a mentor

1. Given what is live, is this already a **usable daily tool** for one grower, or still a **platform with a catalog**?  
2. Should the next effort be **hardening** (git, docs, backup, Search) or **the next empty module** (Inventory, Care, Nursery)?  
3. Should Blueprint §10 be rewritten to match Version 3 navigation, or should the sidebar move back toward Version 2?  
4. Is Favorite Trees correctly a Smart Collection with stored IDs, or should it become a flag on Tree?  
5. When should Experience Levels start hiding Shaping / Nursery / Knowledge so Novice only sees Dashboard, Tasks, Garden, Media, Settings?

---

## 11. How to read the repo (when it is on GitHub)

Start here, in order:

1. `Documentation/START_HERE.md`  
2. `Documentation/BONSAI_CONSTITUTION.md`  
3. `Documentation/PRODUCT_BLUEPRINT.md`  
4. `Documentation/CHANGELOG.md` (shipped history; this report is newer than the last dated section)  
5. This file  

Code entry points:

- Shell: `Bonsai Hub/App/` (`Bonsai_HubApp.swift`, `SidebarView.swift`, `AppNavigation.swift`)  
- Trees: `Bonsai Hub/Core/Services/TreeService.swift`, `Features/Trees/`  
- Tasks: `Bonsai Hub/Core/Services/TaskService.swift`, `Features/Tasks/`  
- Dashboard: `Bonsai Hub/Features/Dashboard/`  
- Weather: `Bonsai Hub/Core/Weather/`  
- Collections: `Features/Collections/`, `Core/Domain/SystemSmartCollections.swift`
