# Gallery — Image Library Architecture

**Type:** Product / architecture review (non-governing · historical once folded)  
**Date:** 23 August 2026  
**Status:** **Approved decision** — folded into [PRODUCT_BLUEPRINT.md](../PRODUCT_BLUEPRINT.md) **§5.5** (+ §5.2 cross-refs). This file remains the rationale.  
**Governing sources read:** README · START_HERE · BONSAI_CONSTITUTION · PRODUCT_BLUEPRINT · FALO_DESIGN_SYSTEM  

**Supersedes scope of:** [Gallery_Image_Ownership.md](Gallery_Image_Ownership.md) (editing ownership — still valid; this document expands Gallery to full **Image Library**).  
**Domain foundation:** [Asset_Architecture.md](Asset_Architecture.md) — Gallery operates on **photo/video Assets**; Asset System owns records and blobs.  
**Related:** [Photo_Crop_Workflow.md](Photo_Crop_Workflow.md) · [Quick_Capture_Inbox.md](Quick_Capture_Inbox.md)

---

## 1. Gallery purpose

**Gallery is the Image Library of Bonsai World.**

It is not only an image editor. It is the **permanent owner** of every image and every image-related workflow in the Library.

| Gallery is | Gallery is not |
|------------|----------------|
| The central **catalog** of all visual assets | A Tree Detail photo band |
| The **authority** on how images look when displayed | A duplicate store beside Trees |
| The **visual browser** for the entire collection | A macOS-only photo app bolt-on |
| The home of **Prepare**, **Primary**, **Featured**, tags, and metadata | Quick Capture (Inbox stages first; Gallery receives routed photos) |

**Product sentence:**

> Every pixel the grower trusts in Bonsai World lives in the Gallery Image Library. Trees **reference** images; they do not **own** them.

Trees remain the heart of the product (Constitution §1). Gallery makes the bonsai **visible** — across Overview, Workspace, Dashboard, Collections, Mobile, and Assistant — from one Library truth.

---

## 2. Image ownership

### 2.1 Gallery owns

| Domain | Meaning |
|--------|---------|
| **Original images** | Immutable capture/import bytes — never overwritten |
| **Display crop** | Non-destructive **Presentation** (recipe + baked render) — default visual everywhere |
| **Primary image** | Per-Tree designated presence image (Presentation reference) |
| **Featured image** | Library-level prominence flag for browse / Dashboard / Collections — independent of Primary |
| **Image metadata** | Photo Name, Capture Date, caption, camera, photographer, notes |
| **Tags** | Grower and system tags for organization and browse |
| **Organization** | Order, albums/sets, tree links, unassigned pool |
| **Image editing** | Import, Prepare (crop / rotate / straighten), compare, re-edit |
| **Future AI analysis** | Suggest tags, crop, species hints, before/after pairing — Gallery-only |

### 2.2 Other modules own (references only)

| Module | Owns | Does not own |
|--------|------|--------------|
| **Trees** | `primaryImageID`, `imageIDs[]`, optional `featuredPresentationID` pointer | Originals, crop, Prepare UI, tags admin |
| **Tree Overview / Workspace** | Display of Gallery-resolved Presentation | Any edit workflow |
| **Dashboard / Collections** | Read Featured / Primary for cards | Image records |
| **Quick Capture** | Inbox staging until route | Gallery assets after route |
| **Assistant** | Reads Gallery metadata + thumbnails | Image editing |

### 2.3 Infrastructure vs product owner

`Images/` services (`ImageService`, storage paths) are **implementation**. **Gallery** is the **product owner** of semantics and workflows — same pattern as Collections owning membership while `TreeService` persists IDs.

---

## 3. Image lifecycle

### 3.1 Canonical lifecycle

```text
Enter Library
    ↓
Original stored (immutable)
    ↓
Optional Prepare → Presentation (display crop recipe + bake)
    ↓
Link to Tree / Collection context / unassigned pool
    ↓
Designations: Primary · Featured · (none)
    ↓
Displayed everywhere via Presentation resolver
    ↓
Re-edit Prepare → new or replaced Presentation (Original unchanged)
    ↓
Compare · Timeline · AI · Export
    ↓
Remove link or delete asset (policy; Original purge only when unused)
```

### 3.2 Entry paths

| Path | Flow |
|------|------|
| **Gallery Import** | Import → Original → Prepare → attach |
| **Tree Add Image** | Shortcut → Gallery Import (tree-scoped) |
| **Quick Capture → Route Tree/Gallery** | Inbox → Gallery attach |
| **Journal / Inventory attach** | Destination module → Gallery registers media |

All paths create **Gallery records**; no module writes silently to `Images/Originals/` without Gallery semantics.

### 3.3 Original (immutable)

- Stored once under library `Images/Originals/`.  
- **Never** cropped, rotated, or overwritten in place.  
- Provenance preserved (import name, EXIF capture date, source device).  
- Expert: **Show Original** in viewer; never the default for Primary/Featured/display.

### 3.4 Presentation / display crop (non-destructive)

- **Display crop** = the grower’s chosen frame for daily use.  
- Stored as **edit recipe** (crop rect, rotation, straighten, preset) + **baked Presentation** file for fast render.  
- Re-opening Prepare loads **Original + recipe**; Save updates Presentation.  
- **Default display rule:** all surfaces resolve **Presentation**, not raw Original.

Surfaces using default Presentation:

- Tree Workspace hero  
- Tree Overview hero  
- Tree list thumbnail  
- Dashboard tree / collection cards  
- Collections member previews  
- Mobile Companion  
- Bonsai Assistant context  

### 3.5 Primary image

| Rule | Detail |
|------|--------|
| **Scope** | One **Primary Presentation** per Tree (presence identity). |
| **Setter** | Gallery workflow only (including shortcuts from Tree). |
| **Display** | Overview, Workspace, list — Primary Presentation cache. |
| **Not** | The only image on the Tree; filmstrip may show many. |

### 3.6 Featured image

| Rule | Detail |
|------|--------|
| **Scope** | Optional **Featured** flag on a Presentation (library-wide). |
| **Purpose** | Highlight in Gallery browse, Dashboard visual cards, Collection hero strips — without forcing Primary on a Tree. |
| **Cardinality** | Many Featured images allowed; Dashboard may show curated subset. |
| **Setter** | Gallery only. |

Primary answers: *“Which photo represents this Tree?”*  
Featured answers: *“Which photos deserve prominence in the Library story?”*

### 3.7 Deletion and unlink

- **Unlink from Tree:** image remains in Gallery (may be unassigned).  
- **Delete from Gallery:** remove Presentation(s); Original removed only if no Presentation references and policy allows.  
- Tree record clears IDs; no orphan UI on Tree surfaces.

---

## 4. Image metadata

### 4.1 Core metadata (Gallery-owned)

| Field | Purpose |
|-------|---------|
| **Photo Name** | Human label (filmstrip, browse) |
| **Capture Date** | When photo was taken (EXIF or user) |
| **Import Date** | When entered Library |
| **Caption** | Short description |
| **Photographer / Camera** | Provenance |
| **Notes** | Longer context |
| **Tags** | Organization + browse filters |
| **Primary for Tree ID** | Denormalized convenience or resolved via Tree |
| **Featured** | Boolean prominence |
| **Links** | Tree ID(s), optional Collection / Journal / Inventory refs |

### 4.2 Derived metadata (future)

- Species guess (AI)  
- Location from EXIF  
- Before/After pair ID  
- Timeline event association  

Derived fields are **Gallery annotations** — never botanical identity on the Tree.

### 4.3 Tags

- Tags are **Gallery vocabulary** — grower-defined + optional Reference Data lists later.  
- Browse filters by tag (Experienced+).  
- Assistant may suggest tags; grower confirms in Gallery.

### 4.4 Who may edit metadata

| Surface | Edit metadata? |
|---------|----------------|
| **Gallery** | Yes — full |
| **Tree Overview / Workspace** | No — shortcuts to Gallery detail |
| **Quick Capture** | Caption at capture only; full metadata after route |

---

## 5. Browsing philosophy

Gallery is the **visual browser** for the complete Bonsai World image collection.

### 5.1 Principles

1. **Library-first** — Garden → Gallery shows the **whole** image collection, not only one Tree.  
2. **Filter, don’t fork** — browse modes are **views** over one catalog, not separate databases.  
3. **Presentation by default** — grid and filmstrip show display crop; Original on demand.  
4. **Contextual drill-in** — from any browse view → image detail → linked Tree / Workspace shortcut.  
5. **Progressive depth** — Novice sees simple grids; Expert sees compare, timeline, AI.

### 5.2 Browse modes (permanent IA; ship incrementally)

| Browse view | Intent |
|-------------|--------|
| **All images** | Complete Library catalog |
| **Primary images** | One presence photo per Tree |
| **Featured images** | Prominence picks across Library |
| **Latest** | Recent Capture / Import Date |
| **By Tree** | Tree-scoped film (Workspace chapter uses same filter) |
| **By Species** | Botanical filter via linked Tree |
| **By Location** | Physical place via Tree → Location |
| **By Collection** | Membership via Collection → Trees → images |
| **By Date** | Capture Date timeline |
| **By Tags** | Tag filter |
| **Before / After** | Paired Presentations (Expert) |
| **Timeline** | Chronological spine across Trees (ties to Tree Timeline chapter) |

### 5.3 UI shape (conceptual)

```text
Garden → Gallery
├── Browse rail (filters / views above)
├── Image grid or filmstrip (Presentations)
└── Detail pane
    ├── Preview (Presentation; Show Original)
    ├── Metadata + tags
    ├── Primary / Featured actions
    ├── Prepare · Compare
    └── Links → Tree · Collection · Journal
```

Tree Workspace **Gallery chapter** = **Browse: By Tree** scoped to current Tree — same Gallery engine, filtered view.

### 5.4 What browsing is not

- Not a file-system folder picker.  
- Not iCloud Photos replacement.  
- Not duplicate Tree list browser.

---

## 6. Relationship between Gallery and Tree Workspace

### 6.1 Division of labour

| Tree Workspace | Gallery |
|----------------|---------|
| The **life** of one bonsai (chapters: Now, Measure, Work, …) | The **images** of the Library |
| Shows Primary / filmstrip **read-only** | Owns all image state |
| **Gallery chapter** = filtered browse + shortcuts | Full metadata, Prepare, Primary, Featured |
| Quick Actions: Add Image, View in Gallery | Executes workflows |

### 6.2 Allowed Tree Workspace actions (shortcuts)

- **Add Image** → Gallery Import (scoped to this Tree)  
- **View Gallery** → Gallery browse filtered to this Tree  
- **Open in Prepare** → Gallery Prepare for selected Presentation  
- **Set Primary** → Gallery Primary designation  
- **Open Image Viewer** → Gallery viewer (zoom, next/previous)

### 6.2 Forbidden on Tree Workspace

- Inline crop / rotate / straighten  
- Photo metadata sheets as long-term owner (interim UI must migrate)  
- Direct writes to Originals  
- AI analysis tools  
- Tag editing as Tree-owned feature  

### 6.3 Mental model

> Tree Workspace is the **studio for one bonsai**.  
> Gallery is the **archive and frame shop** for every photograph.  
> The studio displays framed prints; it does not develop film.

Same Library, synchronized (§5.2.4). Editing in Gallery updates Workspace hero immediately.

### 6.4 Tree Overview

Same rules as Workspace for images — lighter presence (hero + optional filmstrip preview). All edit paths → Gallery.

---

## 7. Required Blueprint updates

Applied in `PRODUCT_BLUEPRINT.md` **§5.5**:

1. **Rename concept** — Gallery = **Image Library** (user-facing: “Gallery”; architectural term: Image Library).  
2. **Expand ownership** — Original, Presentation/display crop, Primary, Featured, metadata, tags, organization, editing, AI.  
3. **Display rule** — Presentation is default across all modules + Mobile + Assistant.  
4. **Add §5.5.2** — Image lifecycle + Primary vs Featured.  
5. **Add §5.5.3** — Browse views catalog.  
6. **Update §5.2** — Tree image refs only; Gallery chapter = scoped browse.  
7. **Cross-ref Quick Capture** — Inbox routes into Gallery; Gallery owns post-route life.  
8. **Update §9 status** — Image Library architecture approved; implementation Planned.  
9. **CHANGELOG** — 2026-08-23 decision.

Historical [Gallery_Image_Ownership.md](Gallery_Image_Ownership.md) remains valid for editing-ownership rationale; this document is the **expanded Image Library** definition.

---

## 8. Explicit non-goals

- Implementing code in this review.  
- Beauty filters / general photo editing suite.  
- Tree-owned image editors.  
- Second image schema per Experience Level.  
- Replacing Library Management package Import (§8.1).

---

## 9. Summary

| # | Topic | Answer |
|---|--------|--------|
| 1 | **Purpose** | Central Image Library — catalog, display authority, visual browser, workflow owner. |
| 2 | **Ownership** | Gallery owns all images and workflows; modules hold references only. |
| 3 | **Lifecycle** | Original → Presentation → link → Primary/Featured → display → re-edit → compare/AI. |
| 4 | **Metadata** | Gallery-owned fields + tags; Tree stores IDs only. |
| 5 | **Browsing** | Library-wide views (All, Primary, Featured, Latest, Species, …) over one catalog. |
| 6 | **Tree Workspace** | Displays Gallery output; launches Gallery workflows; never owns editing. |
| 7 | **Blueprint** | §5.5 expanded; cross-refs updated. |

**Permanent rule:** Original preserved. Display crop non-destructive. Gallery is the Image Library.
