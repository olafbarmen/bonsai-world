# Asset Architecture — Unified Capture Foundation

**Type:** Product / architecture review (non-governing · historical once folded)  
**Date:** 23 August 2026  
**Status:** **Approved decision** — folded into [PRODUCT_BLUEPRINT.md](../PRODUCT_BLUEPRINT.md) **§3.6** (+ §5.5 / Quick Capture cross-refs). This file remains the rationale.  
**Governing sources read:** README · START_HERE · BONSAI_CONSTITUTION · PRODUCT_BLUEPRINT · FALO_DESIGN_SYSTEM  

**Related:** [Gallery_Image_Library.md](Gallery_Image_Library.md) · [Quick_Capture_Inbox.md](Quick_Capture_Inbox.md) · [Photo_Crop_Workflow.md](Photo_Crop_Workflow.md)

**Core principle:** *Capture once. Use everywhere.*

---

## 1. Asset concept

### 1.1 Definition

An **Asset** is the **universal library record** for anything Bonsai World captures, imports, or references — photo, video, voice, text, document, link, or location hint.

Bonsai World must **not** treat images as a special case at the domain layer. Every captured item becomes an **Asset** first. Modules **link** to Assets; they do not **own** blobs or capture metadata.

### 1.2 Product sentence

> **One Asset enters the Library. Many modules may use it.**

A receipt photograph can link to **Economy**, **Inventory**, and **Journal** without being copied three times. A exhibition photo can become a Tree Primary in **Gallery** and appear in **Timeline** and **Assistant** context from the same Asset.

### 1.3 Asset kinds (v1 catalog)

| Kind | Examples | Typical blob |
|------|----------|--------------|
| **photo** | Bonsai, pot, tool, label, QR, handwritten note | Image file |
| **video** | Short workshop clip, repot timelapse | Video file |
| **voice** | Quick voice note | Audio file |
| **text** | Short note, reminder | UTF-8 text (inline or file) |
| **pdf** | Manual, care sheet | PDF file |
| **receipt** | Purchase receipt (often photo/PDF subtype) | Image or PDF |
| **qr_code** | QR on label or sign | Image + decoded payload |
| **gps** | Capture location hint | Coordinates + accuracy metadata |
| **web_link** | Reference URL | URL + optional snapshot |
| **scanned_document** | Multi-page scan | PDF or image set |

Kinds are **extensible** — one schema; new kinds do not fork the Library.

### 1.4 Asset vs module record

| Layer | Owns |
|-------|------|
| **Asset System** | Asset identity, kind, blobs, base metadata, tags, links, inbox state, lifecycle |
| **Tree** | Botanical identity, care fields — **links** to photo Assets (Primary, gallery set) |
| **Inventory** | **InventoryItem** records — **links** to label/receipt/manual Assets (§5.11) |
| **Journal** | Narrative entry — **links** to voice/text/photo Assets |
| **Gallery** | **Photo/video workflows** on visual Assets (Prepare, Primary, Featured, browse) |
| **Knowledge** | Article/guide record — **links** to PDF/web Assets |

### 1.5 What the Asset System is not

- Not a second Library (Assets live **inside** the Bonsai World Library).  
- Not Gallery (Gallery is the **visual module** over photo/video Assets).  
- Not Quick Capture (capture **creates** Assets; Inbox **stages** them).  
- Not Settings → Library Management Import (full package admin).

---

## 2. Asset lifecycle

### 2.1 Canonical lifecycle

```text
Capture / Import
    ↓
Asset created (immutable Original blob when applicable)
    ↓
Inbox pending (optional — Quick Capture default)
    ↓
Triage: Link to module(s) · or hold unlinked
    ↓
Active — referenced by Tree, Inventory, Journal, …
    ↓
Module-specific enrichment (e.g. Gallery Prepare on photo Asset)
    ↓
Use everywhere linked modules need it
    ↓
Archive or Delete (policy; blob purge when unreferenced)
```

### 2.2 States

| State | Meaning |
|-------|---------|
| **inbox_pending** | Captured; not yet triaged (Quick Capture default) |
| **active** | Linked or intentionally held in library catalog |
| **archived** | Hidden from default browse; retained (Expert) |
| **deleted** | Removed from catalog; blobs purged per policy |

### 2.3 Immutability

| Rule | Detail |
|------|--------|
| **Original blob** | Never overwritten after capture/import (same rule as Gallery Original). |
| **Derived renditions** | Presentation (display crop), thumbnails, transcripts — regenerable from Original + recipe. |
| **Metadata** | Base fields editable in Asset admin; module-specific fields stay on module records. |

### 2.4 Links (many-to-many)

**AssetLink** connects one Asset to zero or more module records:

| Field (conceptual) | Example |
|--------------------|---------|
| `assetID` | UUID |
| `targetModule` | `tree` · `inventory` · `journal` · `knowledge` · … |
| `targetRecordID` | UUID of Tree, Pot, Journal entry, etc. |
| `role` | `primary_photo` · `attachment` · `evidence` · `reference` · `label_scan` |
| `createdAt` | When link was made |

One Asset → many links. One record → many Assets. **Capture once. Use everywhere.**

### 2.5 Inbox (staging)

**Inbox** is not a separate product — it is the **inbox_pending** view over Assets.

Quick Capture creates Assets directly; Inbox triage creates **Links** and clears pending state.

---

## 3. Ownership

### 3.1 Asset System owns

- Asset catalog (all kinds)  
- Blob storage keys (via StorageProvider)  
- Base metadata: title/caption, capture date, import date, kind, tags  
- Inbox pending state  
- AssetLink graph  
- Delete/archive policy  
- Sync identity for Mobile Companion  

### 3.2 Gallery owns (photo/video Assets only)

Gallery remains the **Image Library** — but architecturally it is the **workflow and browse module** for **`kind ∈ {photo, video}`** Assets:

| Gallery owns on visual Assets | Asset System still owns |
|------------------------------|-------------------------|
| Prepare (display crop / Presentation) | Original blob |
| Primary designation (per Tree link role) | Asset record |
| Featured designation | Base metadata |
| Visual browse filters | Link graph |
| Compare, Before/After, image AI | Blob storage |

**Refinement of prior decision:** Gallery no longer “owns images” as a separate entity type — it **owns image workflows** on **Assets**. User-facing language stays **Gallery**; domain truth is **Asset + Gallery extensions**.

### 3.3 Quick Capture owns

- Capture UX (Mobile Companion primary)  
- **Creating** Assets with `inbox_pending`  
- **Not** owning Assets after save — Asset System does  

### 3.4 Modules reference only

Trees, Inventory, Journal, Knowledge, Workshop, Yamadori, Economy — store **AssetLink IDs** or resolve via Asset Service; never duplicate blobs.

---

## 4. Relationships with other modules

### 4.1 Gallery

| Before (image-only) | After (Asset foundation) |
|---------------------|---------------------------|
| Image record in Gallery | **photo** / **video** Asset |
| `primaryImageID` on Tree | Tree link role `primary_photo` → Asset → Gallery Presentation |
| Gallery Import | Creates **photo** Asset + optional immediate link |
| Browse All images | Browse Assets where `kind ∈ {photo, video}` |

Gallery UI unchanged in intent; domain unified under Asset.

### 4.2 Quick Capture

```text
Mobile: Capture
    ↓
Asset System: create Asset (inbox_pending)
    ↓
Sync to Library
    ↓
Desktop: Inbox triage
    ↓
Create AssetLink(s) → Tree / Inventory / Journal / …
    ↓
If photo → Tree: Gallery may prompt Prepare / Primary
    ↓
inbox_pending → active
```

Quick Capture never asks “which module?” at shutter — only creates Asset.

### 4.3 Mobile Companion

- Primary **capture surface** for Assets (photo, voice, text, …).  
- Offline queue creates Assets locally; sync merges into Library Asset catalog.  
- Optional: view recent captures (pending Assets).  
- Routing/triage optional on mobile v2; v1 capture-only.

### 4.4 Bonsai Assistant

- **Reads** linked Assets (thumbnails, transcripts, captions) as context.  
- May **suggest** links or tags — grower confirms in Asset/Inbox/Gallery admin.  
- Never creates duplicate blobs; may create **text** Assets for saved answers *(future)*.

### 4.5 Tree Workspace

- **Displays** Primary and filmstrip via Asset links → Gallery Presentation resolver.  
- **Shortcuts** into Gallery workflows (Prepare, Set Primary) on linked photo Assets.  
- **Does not** own Assets or blobs.  
- Timeline chapter may list linked Assets across kinds (photo, voice, work refs).

### 4.6 Inventory

- **InventoryItem** records **link** to Assets:  
  - Label photo (`label_scan`)  
  - Receipt (`evidence`)  
  - Product PDF (`reference`)  
  - Primary product photo (`primary_photo`)  
- Inventory owns item fields, stock/count, assignment, and maintenance; Asset System owns blobs. Full module: Blueprint **§5.11**.

### 4.7 Journal · Knowledge · Economy · Yamadori

| Module | Asset usage |
|--------|-------------|
| **Journal** | Attach voice, text, photo Assets to entries |
| **Knowledge** | PDF, web_link, scanned_document Assets |
| **Economy** | receipt Assets linked to expenses |
| **Yamadori** | Field photo/voice/GPS Assets; full project workflow §5.10 |

### 4.8 Storage layout (illustrative)

```text
Bonsai World Library/
  Database/
    Assets.json              ← Asset index
    AssetLinks.json          ← link graph (or embedded)
  Assets/
    Originals/               ← immutable blobs by asset ID
    Derived/                 ← presentations, thumbs, transcripts
  Inbox/                     ← optional staging metadata (or flag on Asset)
  …
```

Exact paths are implementation; **StorageProvider** rules (Blueprint §3) unchanged.

---

## 5. Experience Levels

Same Asset schema at every level. **The Software Grows with the Artist.**

### 5.1 Novice

| Area | Behaviour |
|------|-----------|
| **Capture** | Photo + short text via Mobile; desktop Inbox |
| **Triage** | Simple: link to Tree, Journal, Delete |
| **Gallery** | Primary photo; basic browse |
| **Assets** | Invisible concept — grower sees “photos and notes,” not “Assets” |

### 5.2 Experienced

| Area | Behaviour |
|------|-----------|
| **Capture** | + voice, receipt, QR |
| **Triage** | Full destinations; tags on Asset |
| **Gallery** | Prepare, Featured, filters |
| **Assets** | Optional “Library → All captures” unified browse |
| **Multi-link** | Same receipt Asset → Economy + Inventory |

### 5.3 Expert

| Area | Behaviour |
|------|-----------|
| **Capture** | GPS hint, scanned documents, batch |
| **Triage** | Multi-select; bulk link; archive |
| **Gallery** | Compare, Before/After, AI on photo Assets |
| **Assets** | Full catalog browse by kind/tag/link; diagnostics |
| **Assistant** | Rich Asset context; suggested links |

---

## 6. Required Blueprint updates

Applied in `PRODUCT_BLUEPRINT.md`:

1. **New §3.6 Assets** — Asset concept, kinds, lifecycle, links, ownership.  
2. **§5.5 Gallery** — reframed as visual Asset module (photo/video workflows); references §3.6.  
3. **Quick Capture** — folded from proposal; creates Assets, Inbox = pending view.  
4. **§5.2 Trees** — Primary/gallery refs → Asset links.  
5. **§5.11 Inventory / Journal / Knowledge** — Asset link pattern.  
6. **Architecture diagram** — Domain adds **Assets** layer under Services.  
7. **CHANGELOG** — 2026-08-23 Asset architecture decision.

### 6.1 Supersedes / refines

| Prior doc | Change |
|-----------|--------|
| **Gallery_Image_Library** | Still valid for **workflows**; domain record is Asset |
| **Quick_Capture_Inbox** | Inbox = pending Assets; fold into Blueprint |
| **ImageAsset model (code)** | Future migration to Asset — not this task |

---

## 7. Explicit non-goals

- Implementing code or migrating `ImageAsset` today.  
- Replacing Gallery module UI or browse IA.  
- External DAM (Digital Asset Management) as system of record.  
- Per-module duplicate blob stores.  
- Asset kinds that fork the schema per Experience Level.

---

## 8. Summary

| # | Topic | Answer |
|---|--------|--------|
| 1 | **Asset concept** | Universal library record for all captured/imported items; one catalog. |
| 2 | **Lifecycle** | Capture → Asset → Inbox optional → link → active → enrich → use everywhere. |
| 3 | **Ownership** | Asset System owns records + blobs + links; Gallery owns photo/video **workflows**. |
| 4 | **Modules** | Trees, Inventory, Journal, etc. link only; Gallery, Quick Capture, Assistant, Workspace as described in §4. |
| 5 | **Experience Levels** | Novice: simple capture/triage; Experienced: tags/multi-link; Expert: full catalog + AI. |
| 6 | **Blueprint** | §3.6 Assets + Gallery/Quick Capture cross-ref updates. |

**Mantras:** *Capture once. Use everywhere.* · *Capture first. Organize later.* (Quick Capture)
