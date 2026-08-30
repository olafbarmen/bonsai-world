# Gallery Owns Image Editing — Ownership Decision

**Type:** Product / architecture review (non-governing · historical once folded)  
**Date:** 22 August 2026  
**Status:** **Approved decision** — folded into [PRODUCT_BLUEPRINT.md](../PRODUCT_BLUEPRINT.md) **§5.5** (and Trees §5.2 cross-refs). This file remains the rationale.  
**Governing sources read:** README · START_HERE · BONSAI_CONSTITUTION · PRODUCT_BLUEPRINT · FALO_DESIGN_SYSTEM  

**Related:** [Photo_Crop_Workflow.md](Photo_Crop_Workflow.md) (Prepare/Crop **design** — owned by Gallery; crop UI not designed here).

---

## 1. Decision

**Gallery is the owner of all image management.**

That includes:

- Import Photos  
- Crop  
- Rotate  
- Straighten  
- Select Primary Photo  
- Compare Photos  
- Organize Photos  
- Future AI image tools  

**Tree Detail / Tree Overview / Tree Workspace are not owners of image editing.**

They may **initiate** Gallery-owned workflows (shortcuts) and **display** the results (Primary Photo, filmstrip presence). The workflow, tools, and product responsibility always belong to Gallery.

Same pattern as Collections owning membership while Tree surfaces can open “Add to Collection.”

---

## 2. Current architecture (as built / as documented)

### 2.1 Product docs (before this decision)

| Source | What it said |
|--------|----------------|
| Blueprint §5.5 Gallery | “Browse and organize”; import “primarily from Tree context (Add Image)”; Gallery Import “when shipped.” |
| Blueprint §5.2 Trees | Context Quick Action **Add Image**; Overview may “add photo”; Workspace chapter **Gallery**. |
| Blueprint §8.1 | “Add Image remains Tree / Gallery context.” |
| Photo Crop proposal | Prepare flow entered from Tree Add Image; ownership of the *tool* left ambiguous. |

### 2.2 Implementation today (Trees-centric)

| Responsibility | Where it lives now |
|----------------|-------------------|
| Finder import → `Images/Originals/` | `ImageImportService` called from **TreeDetailView** |
| Attach IDs / set primary on draft | **TreeDetailView** (`primaryImageID`, `imageIDs`) |
| Photo band UI (preview + filmstrip) | **TreePhotoManagerSection** inside Tree Detail |
| Set primary / delete / edit photo name & capture date | Callbacks owned by **Tree Detail** |
| Open image viewer window | **TreePhotoManagerSection** / Trees Features |
| Quick Action **Add Image** | Trees context → Tree Detail handler |
| Image metadata catalog / load pixels | `Images/` services (`ImageService`, `ImageAsset`) — shared infrastructure |
| Garden → Gallery module UI | Placeholder only |

**Verdict:** Image *infrastructure* is partly shared (`Images/`), but **product workflows are incorrectly concentrated in Tree Detail.** Gallery module does not yet own Import, Prepare, Primary selection, or organization.

---

## 3. Recommended ownership

### 3.1 Gallery owns (product + workflow)

| Capability | Notes |
|------------|--------|
| **Import Photos** | Single and batch; Tree-scoped or library-wide entry. |
| **Prepare / Crop / Rotate / Straighten** | Entire Prepare surface (see Photo Crop proposal). |
| **Select Primary Photo** | Choosing which presentation is Primary for a Tree. |
| **Compare Photos** | Side-by-side, before/after, multi-select compare. |
| **Organize Photos** | Filmstrip order, albums/sets when shipped, tags, remove from Tree, delete asset policy. |
| **Photo metadata editing** | Photo Name, Capture Date, caption, photographer, etc. |
| **Image Viewer (deep)** | Zoom, pan, next/previous, slideshow — Gallery capability; may open from Tree shortcut. |
| **Future AI image tools** | Background remove, suggest crop, etc. — Gallery only. |
| **Presentations / originals policy** | Non-destructive original vs display presentation rules. |

### 3.2 Trees own (references + presence only)

| Capability | Notes |
|------------|--------|
| **Store links** | `primaryImageID` / `imageIDs` (or equivalent) on the Tree record — data, not workflow UI ownership. |
| **Display Primary** | Overview hero / Workspace presence / list thumbnail — **read** Gallery results. |
| **Light filmstrip presence** | May show the Tree’s photos for orientation; actions that *edit* open Gallery. |
| **Initiate shortcuts** | Add Image, View in Gallery, Change Primary, Prepare Photo — open Gallery-owned flows scoped to this Tree. |

### 3.3 Shared infrastructure (not a third product owner)

`StorageProvider`, `ImageService`, `ImageImportService`, `ImageAsset` models — **Core/Storage/Images** services used by Gallery (and readable by Trees for display). Product owner of workflows remains **Gallery**.

### 3.4 Shortcuts from Tree Detail (allowed)

| Shortcut | Opens (Gallery-owned) |
|----------|------------------------|
| **Add Image** | Import (+ Prepare when shipped), scoped to this Tree |
| **Change / Set Primary** | Gallery Primary selection for this Tree |
| **View Gallery** / filmstrip “Open” | Gallery or Gallery Viewer for this Tree’s set |
| **Edit Photo** / Prepare | Gallery Prepare (crop/rotate/straighten) |
| **Photo Information** | Gallery metadata editor (not a Tree-owned sheet long-term) |

Tree Detail must **not** reimplement these tools locally as a parallel editor.

### 3.5 What Tree Detail must stop owning (product intent)

- Being the system of record for import UX  
- Crop / rotate / straighten / AI  
- Long-term home for photo metadata administration  
- Compare and organize as Tree-only features  

Display chrome may remain on Overview until Gallery UI ships, but **new** editing capability is specified and built under Gallery.

---

## 4. Required Blueprint updates

Applied in `PRODUCT_BLUEPRINT.md`:

1. **§5.5 Gallery** — Purpose, ownership clause, primary workflow, Quick Actions, relationships, Experience Levels, future expansion / roadmap.  
2. **§5.2 Trees** — Quick Actions and relationships: Add Image / View Gallery are **shortcuts into Gallery**; Trees do not own image editing.  
3. **§5.2.1 / §5.2.5** — “Add photo” / Gallery chapter = presence + launch Gallery; editing depth is Gallery-owned.  
4. **§8.1** — Clarify Library Import vs Gallery **Import Photos**.  
5. **§9** — Status note: ownership approved; Gallery surface still Planned.

---

## 5. Future Gallery roadmap (ownership sequence)

Delivery order is planning; ownership is fixed now:

| Stage | Gallery delivers | Trees / others |
|-------|------------------|----------------|
| **G0 — Ownership (now)** | Documented owner of all image workflows | Shortcuts only; display Primary |
| **G1 — Tree-scoped Gallery** | Browse this Tree’s photos; set Primary; basic organize; import entry | Add Image / View Gallery shortcuts |
| **G2 — Prepare** | Crop / rotate / straighten; originals vs presentations | Hero updates from Primary Presentation |
| **G3 — Library Gallery** | Garden → Gallery module: browse across Trees; Import Photos global | Deep links to Tree |
| **G4 — Compare** | Compare, before/after, multi-select | Optional Workspace chapter embed of Gallery views |
| **G5 — Depth** | Albums/sets, export, timeline visuals, Expert tools | — |
| **G6 — AI** | Suggest crop, cleanup, tagging assists | Never Tree-owned AI editors |

Workspace chapter **Gallery** (Blueprint §5.2.2) is a **Tree-scoped window into Gallery**, not a second image product.

---

## 6. Alignment checks

| Principle | How this decision fits |
|-----------|------------------------|
| Constitution §1 Trees at heart | Photos serve Trees; Gallery orbits; Primary still appears on the Tree. |
| One concept = one name | Image editing lives under **Gallery**, not “Tree Photo Manager” as a product. |
| Software Grows with the Artist | Gallery reveals Prepare / Compare / AI by Experience Level — one schema. |
| Platform independence | Gallery workflows are domain-owned; hosts are native. |
| Collections parallel | Membership owned by Collections; image workflows owned by Gallery. |

---

## 7. Explicit non-goals (this decision)

- Designing the Crop tool UI (see Photo Crop proposal; owned by Gallery).  
- Implementing code or moving Swift files.  
- Removing Tree photo *display* from Overview.  
- Merging Gallery into Library Management (library package Import ≠ Import Photos).

---

## 8. Summary

| Question | Answer |
|----------|--------|
| **Current responsibilities** | Tree Detail owns import, primary, filmstrip edit, metadata sheets; Gallery module is a placeholder; `Images/` is shared plumbing. |
| **Recommended responsibilities** | Gallery owns all image management workflows; Trees display + shortcut; services stay shared infrastructure. |
| **Blueprint** | §5.5 ownership + §5.2 / §8.1 cross-refs updated. |
| **Roadmap** | G0 ownership → G1 tree-scoped Gallery → G2 Prepare → G3 library Gallery → G4 Compare → G5 depth → G6 AI. |
