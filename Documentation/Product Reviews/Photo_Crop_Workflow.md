# Photo Crop Workflow — Product Architecture Proposal

**Type:** Product / UX review (non-governing)  
**Date:** 22 August 2026  
**Status:** **Proposal** (Prepare/Crop tool design) — Crop UI not designed in full here. **Workflow ownership:** **Gallery** owns Import / Prepare / Primary / Compare / Organize / AI ([Gallery_Image_Ownership.md](Gallery_Image_Ownership.md); Blueprint §5.5). Tree surfaces only initiate shortcuts. Product truth for ownership is the Blueprint; this file remains the Prepare workflow proposal until Prepare is approved and folded.  
**Governing sources read:** README · START_HERE · BONSAI_CONSTITUTION · PRODUCT_BLUEPRINT · FALO_DESIGN_SYSTEM  

---

## 1. Purpose

Every imported Tree photo should be able to pass through a calm **crop-and-prepare** step before it becomes the Tree’s **Primary Photo**.

Goals:

1. **Beginners succeed in seconds** — import, frame the bonsai, save.  
2. **Craft grows with the artist** — rotate, straighten, presets, and multiple versions appear by Experience Level without changing the data model.  
3. **Originals are sacred** — the imported file is never overwritten.  
4. **Display is always intentional** — Overview, Workspace hero, list thumbnails, and Gallery cards show **edited / presentation** images, not raw camera dumps.  
5. **Platform-independent** — same workflow concept on macOS and Windows; only the host window/dialog chrome is native.

This proposal covers **product architecture only**. No implementation.

---

## 2. Product principle

> Importing a photo is like bringing a print into the studio.  
> Cropping is framing the bonsai for the wall.  
> The negative stays in the archive; the framed print hangs on the Tree.

Aligned with:

- Constitution §1 — Trees at the heart; photographs serve the Tree’s story.  
- Constitution §17 / Blueprint §1.1 — **The Software Grows with the Artist**.  
- Falo — Progressive Disclosure; one primary action; calm, not frantic.  
- Blueprint §3 — all blobs via `StorageProvider`; models store IDs / relative keys only.  
- Blueprint §5.2 / §5.5 — presence-first hero; Gallery as visual memory orbiting Trees.

---

## 3. Required end-to-end workflow

Canonical path (all Experience Levels share this spine):

```text
Photo Import
    ↓
Preview
    ↓
Crop
    ↓
Rotate (optional)
    ↓
Straighten (optional)
    ↓
Save
    ↓
Original retained (immutable archive)
    ↓
Edited presentation becomes Primary Photo
```

### Step definitions

| Step | Meaning |
|------|---------|
| **Photo Import** | User picks a file (or future camera / drag-drop). Bytes enter the library as an **Original**. |
| **Preview** | Full-frame view of the Original so the grower recognizes the shot before committing a frame. |
| **Crop** | Adjustable rectangle over the preview. Defines what will appear as the Primary Photo. |
| **Rotate** | 90° steps (and optionally free rotate later). Applied to the **edit recipe**, not the Original file. |
| **Straighten** | Fine angle correction for horizon / pot base. Optional; hidden or de-emphasized for Novice. |
| **Save** | Writes a **presentation (edited) image** (and thumbnail/hero derivatives as needed). Sets Tree **Primary Photo** to that presentation. |
| **Original retained** | `Images/Originals/…` untouched for the life of the asset (unless the grower explicitly deletes the photo record). |
| **Primary Photo** | The Tree’s hero / list / Overview image — always a **presentation**, never “raw Original only” as the product rule. |

### Exit paths

| Action | Result |
|--------|--------|
| **Save** | Original kept; presentation created; `primaryImageID` (or equivalent) points at the presentation used for display. |
| **Use Full Photo** | Still creates a presentation (full-frame / no crop, identity transform). Satisfies “display is intentional” without forcing a crop. |
| **Cancel** | No Primary change. Original may be discarded if import was never confirmed, or kept as an unassigned gallery candidate — **v1 recommendation:** Cancel after import aborts the whole Add Image flow and does not leave orphan originals (or quarantines them for cleanup). Prefer **no orphan originals** on Cancel. |
| **Replace Primary later** | New import → same workflow → new presentation becomes Primary; previous presentation remains in the Tree’s photo set unless removed. |

**Do not** open Workspace on import. Crop is a **focused preparation surface**, not a second Library.

---

## 4. User workflow (by context)

### 4.1 Entry points

All entry points open **Gallery-owned** flows (Tree actions are shortcuts only — Blueprint §5.5).

| Entry | Behaviour |
|-------|-----------|
| Tree Overview — **Add Image** / Change Primary | Shortcut → Gallery Import / Prepare / Primary, scoped to this Tree. |
| Tree Workspace — Gallery chapter / Add Photo | Tree-scoped Gallery surface (Gallery-owned), not a Tree Detail editor. |
| Gallery — Import Photos | Gallery primary entry. |
| Add Tree — optional primary | Gallery Prepare when photo attached; Skip allowed. |

### 4.2 Mental model (one sentence)

**Library window** = find the Tree.  
**Photo Prepare** = frame this photograph.  
**Tree surfaces** = live with the framed result.

### 4.3 Default path (Novice)

1. Choose photo.  
2. See preview with a simple crop rectangle (default: gentle inset or full frame).  
3. Drag corners / edges; pinch or scroll to zoom within crop when available.  
4. **Save** — done. Primary Photo updates everywhere (Overview, list, Workspace).

Rotate / Straighten are not required to finish.

### 4.4 Re-edit

From Photo Manager / Gallery / hero overflow:

- **Adjust Crop** — reopen Prepare with the **same Original** and the **last edit recipe** preloaded.  
- Saving writes a **new presentation** (or replaces the active presentation — see §7.3). Original still untouched.

---

## 5. UI layout (Photo Prepare surface)

### 5.1 Shell

| Element | Role |
|---------|------|
| **Title** | “Prepare Photo” (or “Frame Photo”) — human language, not “Image Editor”. |
| **Primary canvas** | Dominant preview of the Original with crop overlay. Edge-to-edge visual plane; chrome secondary (Falo). |
| **One primary action** | **Save** (sets Primary Photo). |
| **Secondary** | **Cancel**; **Use Full Photo**. |
| **Tools strip** | Crop always; Rotate / Straighten / Presets by Experience Level. |

Host: **native modal / sheet / dedicated tool window** — platform choice. Concept is identical on macOS and Windows. Not embedded inside the Tree list browser.

### 5.2 Layout sketch (conceptual)

```text
┌─────────────────────────────────────────────────────────┐
│  Prepare Photo                              Cancel      │
├─────────────────────────────────────────────────────────┤
│                                                         │
│              ┌─────────────────────────┐                │
│              │                         │                │
│              │     Crop rectangle      │                │
│              │     over Original       │                │
│              │                         │                │
│              └─────────────────────────┘                │
│                                                         │
├─────────────────────────────────────────────────────────┤
│  [Crop]  [Rotate]  [Straighten]  [Presets ▾]            │
│                                                         │
│              Use Full Photo              [ Save ]       │
└─────────────────────────────────────────────────────────┘
```

Rules:

- No sidebar of the full app inside Prepare.  
- No Tree field grids.  
- No competing “filters / beauty” tools in v1.  
- Darkened area outside crop; clear handles; keyboard: Esc = Cancel, Return = Save where platform-appropriate.

### 5.3 Tool disclosure

| Control | Novice | Experienced | Expert |
|---------|--------|-------------|--------|
| Crop rectangle | Yes | Yes | Yes |
| Zoom / pan inside crop | Simple | Yes | Yes |
| Rotate 90° | Hidden or overflow | Yes | Yes |
| Straighten slider | Hidden | Yes | Yes |
| Aspect lock | Optional soft | Yes | Yes |
| Presets (Portrait, Full Tree, …) | Hidden | Few | Full set |
| “Versions” / name this edit | Hidden | Optional | Yes |
| Exact degrees / numeric crop | Hidden | Hidden | Optional |

---

## 6. Experience Levels

Same Original, same library, same schema. Levels change **revelation and tools only**.

### 6.1 Novice

| Aspect | Behaviour |
|--------|-----------|
| **Intent** | “Show my tree clearly.” |
| **Tools** | Preview + Crop + Save / Use Full Photo / Cancel. |
| **Guidance** | Short empty/hint copy: “Frame the whole tree — you can change this later.” |
| **Rotate / Straighten** | Not required; omit from primary strip. |
| **Presets** | None. |
| **Versions** | One presentation per import (Primary). |
| **Remember last crop** | Silent if available; no UI. |

### 6.2 Experienced

| Aspect | Behaviour |
|--------|-----------|
| **Intent** | “Frame for craft and comparison.” |
| **Tools** | Novice + Rotate + Straighten + aspect lock + a short preset list. |
| **Presets** | Portrait · Full Tree · Pot *(labels human, not jargon)*. |
| **Versions** | May replace Primary; optional “Keep previous in Gallery.” |
| **Remember last crop** | Prefill last crop recipe for this Tree when useful. |
| **Guidance** | Quieter; tooltips only. |

### 6.3 Expert

| Aspect | Behaviour |
|--------|-----------|
| **Intent** | “Archive quality + intentional series from one capture.” |
| **Tools** | Experienced + full presets (Nebari, Detail, …) + named versions + re-edit from recipe + optional numeric precision. |
| **Versions** | Multiple presentations from one Original; choose which is Primary; others remain in Tree Gallery / filmstrip. |
| **Non-destructive** | Edit recipe always retained; re-bake anytime. |
| **Compare** | Future: before/after or version A/B *(not required for v1 Prepare)*. |

**Level-invariant:** Original immutability; StorageProvider access; Tree ownership of which presentation is Primary; no second image database.

---

## 7. Image storage strategy

### 7.1 Library package (extends existing layout)

```text
Bonsai World Library/
  Database/
  Images/
    Originals/          ← immutable imports (never cropped in place)
    Presentations/      ← baked edited images used for display (v1 name)
    Thumbnails/         ← small caches derived from Presentations (or Originals when needed)
    Hero/               ← large hero caches for Overview / Workspace
  Documents/
  …
```

Notes:

- Today’s code already uses `Images/Originals/` (+ Thumbnails / Hero). This proposal **adds Presentations** (name may be `Edited/` if preferred at implementation — product term is **Presentation**).  
- All access through `StorageProvider` / `StorageService`.  
- Models store **IDs and relative keys only** — never absolute paths (Blueprint §3).

### 7.2 What is written when

| Event | Originals | Presentations | Thumbnails / Hero |
|-------|-----------|---------------|-------------------|
| Import confirmed into Prepare | Create | — | Optional preview cache only |
| Save / Use Full Photo | Unchanged | Create (or replace active) | Generate / refresh from Presentation |
| Adjust Crop → Save | Unchanged | New or replace Presentation | Refresh |
| Delete photo from Tree | Policy: delete Presentation(s); Original deleted only if unused elsewhere | | Purge caches |

### 7.3 Non-destructive editing

Store an **edit recipe** with every Presentation:

| Field (conceptual) | Purpose |
|--------------------|---------|
| `sourceOriginalID` | Link to immutable Original |
| `cropNormalizedRect` | Unit rect in post-rotate image space |
| `rotationQuarterTurns` or degrees | Orientation |
| `straightenDegrees` | Fine angle |
| `presetID` (optional) | Portrait / Full Tree / … |
| `renderedRelativePath` | Baked file for fast display |
| `recipeVersion` | Forward-compatible schema |

**Source of truth for re-edit** = recipe + Original pixels.  
**Source of truth for daily UI** = baked Presentation (+ caches).

If the bake is missing, regenerate from recipe (Validate / open path).

### 7.4 “Only edited versions for display”

Product rule:

1. Tree **Primary Photo** references a **Presentation** identity.  
2. Overview hero, list thumbnails, Workspace hero, and Gallery grid tiles resolve through Presentations (or caches thereof).  
3. The Image Viewer may offer **Show Original** (Experienced+) without making Original the Primary.  
4. **Use Full Photo** still creates a Presentation with a full-frame recipe so the rule stays uniform.

---

## 8. Relationship model (conceptual)

```text
Tree
  ├── primaryPresentationID ──► Presentation
  │                                ├── sourceOriginalID ──► Original (ImageAsset)
  │                                ├── editRecipe
  │                                └── rendered file (Presentations/…)
  └── photoIDs / gallery ────────► Originals and/or Presentations
                                   (filmstrip shows Presentations by default)
```

### 8.1 Recommended identities

| Concept | Role |
|---------|------|
| **Original** | One imported capture. Immutable bytes. Provenance (file name, capture date, EXIF). |
| **Presentation** | One framed result derived from an Original. Owns recipe + bake. |
| **Primary Photo** | The Presentation currently chosen for Tree presence. |

Migration from today’s `Tree.primaryImageID` → `ImageAsset`:

- Treat existing assets as **Originals**.  
- On first open/edit after this ships, create a full-frame Presentation and point Primary at it **or** lazily create Presentation on next Prepare / next launch migration.  
- Do **not** fork a second library format for Experience Levels.

### 8.2 Multiple edited versions (future-ready now)

One Original → many Presentations:

| Presentation | Example use |
|--------------|-------------|
| Primary | Overview / Workspace hero |
| Nebari study | Gallery / Design chapter |
| Detail | Wiring / deadwood note |
| Exhibition crop | Show entry |

v1 may allow **only one Presentation per import** (replace on re-Save). Schema still supports many.

### 8.3 Remember previous crop (same Tree)

Store on Tree or last Presentation:

- `lastPrepareRecipe` or simply reopen the current Primary’s recipe.  

Prefill Prepare when adding a **new** photo of the same Tree (Experienced+). Novice: silent optional assist only if it never surprises (e.g. similar aspect only).

---

## 9. Fixed crop presets (future capability)

| Preset | Intent | Default aspect (illustrative) |
|--------|--------|-------------------------------|
| **Portrait** | Classic upright bonsai photo | ~3:4 or 4:5 |
| **Full Tree** | Apex to pot / ground | Free or 2:3 |
| **Pot** | Container and soil line | ~1:1 or 4:3 |
| **Nebari** | Root flare emphasis | Wide / low |
| **Detail** | Branch, jin, fruit, plaque | Free |

Rules:

- Presets set **initial** crop; grower may always adjust.  
- Presets are **labels for intent**, not separate file types.  
- Expert may save custom presets later — same Presentation model.  
- Reveal by Experience Level (§5–§6). Schema includes optional `presetID` from day one of Presentations.

---

## 10. Cross-platform compatibility

| Concern | Rule |
|---------|------|
| **Domain** | Original, Presentation, recipe, Tree Primary — platform-neutral. |
| **Storage** | Relative keys under library package; provider abstraction. |
| **UI host** | macOS: sheet or tool window. Windows: native dialog/window. Same steps and copy. |
| **Input** | Pointer drag handles; trackpad gestures where available; no OS-only gesture as the only path. |
| **Color / decode** | Prefer shared decode pipeline behind services; avoid AppKit-only types in Core models. |
| **Multi-window** | Prepare may be a transient tool surface; must not assume a single global AppState for library data. Shared Image / Tree services only. |

---

## 11. Integration with existing product surfaces

| Surface | After Save |
|---------|------------|
| **Tree Overview** | Hero shows new Primary Presentation. |
| **Tree Workspace** | Same Primary; Gallery chapter later lists Presentations. |
| **Tree list** | Thumbnail from Primary Presentation cache. |
| **Gallery module** | Browses Presentations (and optionally Originals in Expert). |
| **Add Image Quick Action** | Becomes Import → Prepare → Save (not silent copy-only). |
| **Image Viewer** | Opens Presentation by default; Show Original optional. |

No redesign of Tree Detail layout is required for this proposal — only the Add Image path gains Prepare.

---

## 12. What v1 should ship vs later

### v1 (minimum lovable Prepare)

- Import → Preview → Crop → Save / Use Full Photo / Cancel  
- Original immutable; Presentation bake; Primary points at Presentation  
- Edit recipe stored for re-open  
- Novice-simple UI; Experienced Rotate + Straighten if low-cost  
- Thumbnails / Hero regenerated from Presentation  

### v1.1 / later

- Full preset set  
- Multiple Presentations per Original  
- Remember last crop UI  
- Named versions  
- Expert numeric controls  
- Compare / before-after  
- Batch import prepare  

---

## 13. Explicit non-goals (this proposal)

- Beauty filters, LUTs, healing brushes.  
- Cloud photo libraries as the system of record (library package remains source of truth).  
- Overwriting Originals.  
- Different schemas per Experience Level.  
- Embedding a full Tree browser inside Prepare.  
- Implementing code in this review.

---

## 14. Decision checklist (for Blueprint adoption)

When approved, fold into Product Blueprint (likely §5.5 Gallery / Images and a short Trees Add Image rule in §5.2):

1. Original vs Presentation distinction is permanent.  
2. Primary Photo is always a Presentation.  
3. Prepare workflow spine is mandatory for Add / Change Primary.  
4. Experience Level matrix in §6 style is authoritative.  
5. Storage layout gains `Images/Presentations/` (or chosen synonym).  
6. Platform-neutral domain; native hosts only.

Until then, this file is **proposal only**.

---

## 15. Summary

| Question | Answer |
|----------|--------|
| **User workflow** | Import → Preview → Crop → optional Rotate/Straighten → Save; Original kept; Presentation becomes Primary. |
| **UI** | Focused Prepare surface; dominant preview; one primary Save; tools by Experience Level. |
| **Storage** | `Originals/` immutable; `Presentations/` baked display; Thumbnails/Hero from Presentations; recipes for non-destructive re-edit. |
| **Relationship** | Tree Primary → Presentation → Original; many Presentations per Original over time. |
| **Experience Levels** | Novice: crop + save; Experienced: rotate/straighten/presets; Expert: versions, full presets, precision — one model throughout. |
