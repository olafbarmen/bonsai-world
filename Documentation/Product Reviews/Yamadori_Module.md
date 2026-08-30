# Yamadori Module — Product Architecture

**Type:** Product / architecture review (non-governing · historical once folded)  
**Date:** 23 August 2026  
**Status:** **Approved decision** — folded into [PRODUCT_BLUEPRINT.md](../PRODUCT_BLUEPRINT.md) **§5.10** (+ Nursery / cross-module refs). This file remains the rationale.  
**Governing sources read:** README · START_HERE · BONSAI_CONSTITUTION · PRODUCT_BLUEPRINT · FALO_DESIGN_SYSTEM  

**Related:** [Asset_Architecture.md](Asset_Architecture.md) · [Quick_Capture_Inbox.md](Quick_Capture_Inbox.md) · [Gallery_Image_Library.md](Gallery_Image_Library.md)

**Principle:** *Observe. Prepare. Collect. Develop.*

---

## 1. Purpose

### 1.1 Definition

**Yamadori** is Bonsai World’s **long-term project system** for discovering, evaluating, preparing, and collecting trees from nature.

It is **not** a list of collected trees. A **Yamadori Project** may live in the Library for **years** before it becomes a **Tree**. Until collection, it is a **project** — with its own identity, site, history, and plan.

### 1.2 Product sentence

> A Yamadori Project is the story of a tree **before** it enters the collection.  
> When the tree is collected, the project becomes **permanent history** — and a **Tree** is born.

### 1.3 What Yamadori is

| Aspect | Meaning |
|--------|---------|
| **Job** | Manage wild-material projects from first sighting through collection day |
| **Time horizon** | Months to years — observation seasons, root prep cycles, permission waiting |
| **Outcome** | **Graduation** — explicit workflow creates a **Tree**; project archive retained |
| **Feel** | Field journal + expedition planner — not a Tree record prematurely |

### 1.4 What Yamadori is not

- Not a **Tree** before collection (no fake Tree rows).  
- Not **Propagation** (seeds, cuttings, air layers — controlled nursery methods).  
- Not a **Collection** (organizational view of existing Trees).  
- Not **Locations** (Yamadori sites are **wild/field GPS**; bench Location comes at graduation).  
- Not duplicate **Assets** — photos and voice notes link via Asset System (§3.6).

### 1.5 Constitution alignment

Trees remain the heart (Constitution §1). Yamadori **orbits** — it is the path **to** a Tree for wild-collected material. Graduation must follow **Add Tree** botanical rules; Yamadori estimates do not lock taxonomy until the grower confirms at collection.

### 1.6 Distinction: Yamadori Project vs Smart Collection “Yamadori”

| Concept | Meaning |
|---------|---------|
| **Yamadori module** | Pre-collection **projects** (this document) |
| **Smart Collection “Yamadori”** *(planned)* | **Trees** in the library whose origin is wild collection — a **filter** over existing Trees, not projects |

Same word, different life stage. UI copy must not conflate them.

---

## 2. Lifecycle

### 2.1 Project phases (canonical)

```text
Discover
    ↓
Register (GPS + first Assets)
    ↓
Observe (seasonal visits, notes, photos)
    ↓
Evaluate (potential, species estimate, difficulty, priority)
    ↓
Plan root preparation
    ↓
Execute root preparation (Workshop / field work log)
    ↓
Plan collection (calendar, equipment, helpers, permission)
    ↓
Collect
    ↓
Graduate → Tree created (Add Tree workflow)
    ↓
Project archived — historical documentation preserved
```

Alternate exits: **Abandoned** · **Access lost** · **Passed** (e.g. tree died in situ) — lifecycle status, not Delete-first.

### 2.2 Status model (conceptual)

| Status | Meaning |
|--------|---------|
| **discovered** | First registered; minimal data |
| **observing** | Active seasonal observation |
| **evaluating** | Deliberate potential assessment |
| **root_prep_planned** | Root work scheduled / designed |
| **root_prep_active** | Root preparation in progress |
| **collection_planned** | Target collection window identified |
| **collection_scheduled** | Date/helpers/equipment confirmed |
| **collected** | Graduated — `linkedTreeID` set |
| **abandoned** | Grower closed project without collection |
| **access_lost** | Permission or site access ended |
| **in_situ_lost** | Material no longer viable on site |

Statuses are **human-readable** project state — not Tree lifecycle (§4.5).

### 2.3 Graduation (collection → Tree)

| Rule | Detail |
|------|--------|
| **Trigger** | Grower confirms **Collect** / **Graduate to Tree** |
| **Creates** | New **Tree** via **Add Tree** rules (botanical identity confirmed at this moment) |
| **Pre-fill** | Estimated species, linked photo Assets, yamadori origin note, collection date |
| **Links** | `YamadoriProject.linkedTreeID` → Tree; Asset links copied or extended to Tree |
| **Archive** | Project becomes **read-only** historical record — never deleted on graduation |
| **Gallery** | Field photos remain on project; selected Assets may gain Tree links + Primary candidacy |

The **original Yamadori Project remains** as documentation of how the tree was found, prepared, and collected.

### 2.4 Data the project owns vs links

| Yamadori Project owns | Links to (does not duplicate) |
|----------------------|-------------------------------|
| Project identity, name/code, status, priority, difficulty | |
| Wild **site GPS** + access notes | Optional map (Locations map tech) |
| Permission / owner contact summary | |
| Estimated species, age (non-binding) | Botanical Library for pickers |
| Equipment list, helpers (text / refs) | **Inventory** Items for gear (§5.11) |
| Evaluation notes | |
| Root prep plan summary | **Workshop Work** records for each visit |
| Collection plan summary | **Calendar** events |
| Weather observation log | Journal-style entries or inline |
| Collection history timeline | **Assets** for all media |

---

## 3. User workflow

### 3.1 Discover in the field (Mobile Companion)

```text
Quick Capture → photo / voice / GPS Asset
    ↓
Save to Inbox (or “New Yamadori” shortcut)
    ↓
Desktop or mobile: Register Yamadori Project
    ↓
Link Assets · set GPS · first observation note
```

**Capture first** (§3.6) — no species or collection date required at discovery.

### 3.2 Observe over seasons

- Revisit project from **Nursery → Yamadori** list.  
- Add observation entries (date, notes, weather, photos via Asset links).  
- Compare photos in **Gallery** (Before/After across visits).  
- **Assistant** *(opt-in)*: “What changed since last visit?” scoped to project.

### 3.3 Evaluate and prioritize

- Set **collection priority**, **difficulty**, **estimated species/age**.  
- Record **owner/permission** status and **access notes**.  
- Dashboard *(future)* may surface “Yamadori ready for collection” — attention, not a second module.

### 3.4 Prepare roots

- Plan root preparation (notes + **Calendar** target windows).  
- Log each field/workshop session as **Workshop Work** linked to project.  
- Track **root preparation history** on project timeline.

### 3.5 Plan and execute collection

- Schedule collection day — **Calendar** event linked to project.  
- Checklist: equipment, helpers, permission, weather window.  
- Day-of: capture Assets; voice notes; GPS verify.

### 3.6 Graduate

```text
Confirm collection complete
    ↓
Add Tree (graduation wizard — pre-filled)
    ↓
Assign bench Location (physical Location module)
    ↓
Optional: set Primary photo from field Asset (Gallery)
    ↓
Project → collected (archive)
    ↓
Open new Tree in Overview / Workspace
```

### 3.3 Desktop module shape (conceptual)

```text
Nursery → Yamadori
├── Project list (status, priority, site region, last visit)
└── Project Detail
    ├── Header (status, priority, difficulty, hero Asset)
    ├── Site (map pin, access notes, permission)
    ├── Timeline (observations, root prep, weather)
    ├── Assets (Gallery-scoped browse)
    ├── Plans (root prep · collection)
    ├── Links (Calendar · Workshop · Journal)
    └── Graduate to Tree (when ready)
```

Standard shell: Sidebar → List → Detail → Quick Actions (Blueprint §7).

---

## 4. Experience Levels

Same **YamadoriProject** schema at every level. Nursery / Yamadori visibility follows Workspace Profile (Experienced+ baseline).

### 4.1 Novice

| Aspect | Behaviour |
|--------|-----------|
| **Visibility** | Hidden or teaser only — wild collection is Advanced craft |
| **If exposed** | Read-only demo/sample project; no Graduate without guidance |

### 4.2 Experienced

| Aspect | Behaviour |
|--------|-----------|
| **Visibility** | **Nursery → Yamadori** available |
| **Projects** | Register, observe, photos, GPS, notes, basic evaluate |
| **Planning** | Simple collection date; root prep notes (inline) |
| **Graduate** | Wizard with clear steps; species required at graduation |
| **Capture** | Quick Capture → Inbox → link to Yamadori |

### 4.3 Expert

| Aspect | Behaviour |
|--------|-----------|
| **Projects** | Full field: priority, difficulty, helpers, equipment, weather log |
| **Planning** | Calendar integration, Workshop work types, multi-year timeline |
| **Gallery** | Compare visits; Featured field shots |
| **Assistant** | Project-scoped advice; species/habitat hints *(suggestions only)* |
| **Archive** | Abandoned / access_lost analytics; export project report |

---

## 5. Relationships with other modules

### 5.1 Mobile Companion

- Primary **field capture** surface for Yamadori.  
- Quick Capture → Assets → link to Yamadori Project (direct or via Inbox).  
- GPS Asset at discovery registers site coordinates.  
- Offline queue; sync to Library Asset catalog.

### 5.2 Quick Capture & Assets

| Step | Module |
|------|--------|
| Shutter / voice in field | Quick Capture → **Asset** |
| Inbox triage | Route link → **YamadoriProject** |
| Photo compare | **Gallery** on linked photo Assets |
| No blob duplication | **Asset System** §3.6 |

### 5.3 Gallery

- All project photos are **photo Assets** linked to Yamadori.  
- Gallery browse: filter **By Yamadori Project**.  
- Prepare / compare for seasonal documentation — not required for Tree Primary until graduation.  
- At graduation: grower may set Tree Primary from existing Asset.

### 5.4 Calendar

- **Collection day** and **root prep windows** as Calendar events.  
- Events **link** to YamadoriProject — Calendar owns schedule; Yamadori owns project truth.  
- Dashboard may read upcoming Yamadori events.

### 5.5 Workshop

- **Root preparation visits** and field work as **Work** records.  
- Work links to YamadoriProject (and optionally to future Tree after graduation for history).  
- Workshop owns completion semantics; Yamadori owns project timeline aggregation.

### 5.6 Journal

- Long-form observation entries may live as **Journal entries** linked to Yamadori.  
- Short notes may stay inline on project timeline.  
- After graduation: journal entries may **also** link to new Tree — Asset once, link twice.

### 5.7 Tree creation (Add Tree)

- **Graduation = Add Tree** — not a shortcut that bypasses botanical rules.  
- Yamadori **estimated species** pre-fills pickers; grower confirms Genus/Species at collection.  
- `Tree` origin metadata notes Yamadori project ID.  
- Smart Collection “Yamadori” *(future)* filters Trees with yamadori origin — not active projects.

### 5.8 Bonsai Assistant

- **Read-only** context: project status, linked Assets, recent observations.  
- Scoped chat: “Plan root prep for Project X” — does not mutate permission or GPS silently.  
- Suggestions require grower confirmation in Yamadori Detail.

### 5.9 Locations

| Concept | Module |
|---------|--------|
| **Wild site GPS** | YamadoriProject site coordinates |
| **Bench / garden home** | **Location** on Tree at graduation |
| **Map** | Shared map tech; Yamadori pins distinct from bench pins |

Do not conflate wild collection site with grower’s **Locations** master data unless the grower explicitly promotes a site.

### 5.10 Propagation & Nursery siblings

| Module | Role |
|--------|------|
| **Propagation** | Seeds, cuttings, air layers, grafts — controlled material |
| **Yamadori** | Wild material projects — field discovery to collection |
| **Nursery** | Navigation home for both (Version 2 §10.2) |

Shared pattern: **Graduate to Tree** when material enters the collection.

---

## 6. Required Blueprint updates

Applied in `PRODUCT_BLUEPRINT.md`:

1. **New §5.10 Yamadori** — full module template (purpose, objects, workflow, navigation, Quick Actions, Detail, relationships, Experience Levels).  
2. **§10.2 Nursery** — Yamadori as first-class sub-route alongside Propagation.  
3. **§3.6 Quick Capture** — Yamadori as triage destination (already listed; cross-ref §5.10).  
4. **§4.4 Smart Collections** — clarify “Yamadori” Smart Collection = **Trees**, not projects.  
5. **§5.6 Propagation** — cross-ref; distinct from Yamadori.  
6. **CHANGELOG** — 2026-08-23 Yamadori module decision.

---

## 7. Primary objects (conceptual schema)

**YamadoriProject**

| Group | Fields (illustrative) |
|-------|------------------------|
| **Identity** | id, name, code, status, createdDate, modifiedDate |
| **Site** | latitude, longitude, accuracy, altitude, accessNotes, permissionSummary, landownerContact |
| **Assessment** | estimatedGenusID, estimatedSpeciesID, estimatedAge, difficulty, collectionPriority |
| **Planning** | rootPrepPlan, collectionPlan, equipmentNotes, helpersNotes |
| **Graduation** | collectedDate, linkedTreeID |
| **Links** | assetLinkIDs (via Asset System), calendarEventIDs, workRecordIDs, journalEntryIDs |

Timeline events may be embedded or normalized — implementation choice; product truth is **one project timeline**.

---

## 8. Explicit non-goals

- Implementing code or Swift models.  
- Replacing Add Tree with auto-created Trees without grower confirmation.  
- Storing photos outside Asset System.  
- Yamadori projects as Collection members before graduation.  
- Legal/permits document management as a full DMS *(simple notes + Asset PDFs suffice for v1)*.

---

## 9. Delivery roadmap (proposed)

| Stage | Deliverable |
|-------|-------------|
| **Y0** | Blueprint + domain model (this document) |
| **Y1** | Project CRUD, GPS, Asset links, timeline notes |
| **Y2** | Mobile Quick Capture → Yamadori; Gallery project browse |
| **Y3** | Calendar + Workshop links; root prep / collection plans |
| **Y4** | Graduate to Tree wizard |
| **Y5** | Expert: weather log, compare, Assistant scope, export |

---

## 10. Summary

| # | Topic | Answer |
|---|--------|--------|
| 1 | **Purpose** | Long-term wild-material **project** system — years before Tree. |
| 2 | **Lifecycle** | Discover → observe → evaluate → prepare → plan → collect → graduate → archive. |
| 3 | **Workflow** | Field capture via Assets; desktop/mobile project detail; explicit Graduation. |
| 4 | **Experience Levels** | Experienced+ module; Expert adds planning depth and Assistant. |
| 5 | **Relationships** | Assets, Quick Capture, Gallery, Calendar, Workshop, Add Tree, Assistant — link, don’t own. |
| 6 | **Blueprint** | §5.10 Yamadori + Nursery cross-refs. |

**Mantra:** *Observe. Prepare. Collect. Develop.*
