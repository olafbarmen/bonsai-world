# Quick Capture (Inbox) — Product Architecture Proposal

**Type:** Product / architecture review (non-governing)  
**Date:** 23 August 2026  
**Status:** **Approved decision** — folded into [PRODUCT_BLUEPRINT.md](../PRODUCT_BLUEPRINT.md) **§3.6.1**. Capture Items are **Assets** with `inbox_pending`. See [Asset_Architecture.md](Asset_Architecture.md).  
**Governing sources read:** README · START_HERE · BONSAI_CONSTITUTION · PRODUCT_BLUEPRINT · FALO_DESIGN_SYSTEM  

**Related:** [Gallery_Image_Ownership.md](Gallery_Image_Ownership.md) · [Photo_Crop_Workflow.md](Photo_Crop_Workflow.md)

---

## 1. Purpose

**Quick Capture** is Bonsai World’s **fast, pre-classification capture workflow** for moments away from the desk — exhibition halls, nurseries, workshops, garden benches, and supply aisles.

### Core principle

> **Capture first. Organize later.**

The grower must never choose a destination while capturing. Every item enters a temporary **Inbox**. Organization happens later, calmly, in the desktop application (or on mobile when time allows).

### What Quick Capture is

| Aspect | Definition |
|--------|------------|
| **Job** | Preserve a moment, label, receipt, voice thought, or reference **before it is lost** — with minimum friction. |
| **Primary surface** | **Mobile Companion** (iPhone / Android) — camera, microphone, and one-line text at arm’s length. |
| **Secondary surface** | Desktop **Inbox triage** — review, route, or delete captured items. |
| **Output** | Routed items become first-class records in their **destination modules**; unrouted items stay in Inbox until processed. |

### What Quick Capture is not

- Not a second Library or cloud product.  
- Not a replacement for **Gallery** (organized tree-linked images and Prepare workflows — §5.5).  
- Not a replacement for **Add Tree** (registering a bonsai in the Library).  
- Not a place to crop, compare, or set Primary Photo at capture time.  
- Not a long-form Journal editor at capture time.  
- Not a Smart Collection or Dashboard feed.

### Typical capture examples

| Capture | Later destination (examples) |
|---------|------------------------------|
| Fertilizer label photo | Product · Inventory · Knowledge |
| Bonsai pot photo | Pot · Inventory |
| Tool photo | Tool · Inventory |
| Bonsai at exhibition | Tree · Gallery |
| QR code | Knowledge · External link · Product |
| Handwritten note photo | Journal · Knowledge · Tree note |
| Receipt | Economy · Inventory purchase |
| Product label | Product · Inventory |
| Quick voice note | Journal · Tree · Task *(when Workshop ships)* |
| Short text note | Journal · Tree · Inbox reminder |

---

## 2. User workflow

### 2.1 Mobile Companion — capture (primary)

```text
Open Quick Capture
    ↓
Choose medium (Photo · Voice · Text) — or platform default (camera)
    ↓
Capture (one tap / one hold where possible)
    ↓
Optional: one-line caption or auto timestamp only
    ↓
Save to Inbox
    ↓
Done — return to life
```

**Rules at capture:**

- No Tree picker.  
- No module picker.  
- No tags required.  
- No crop / rotate / Prepare.  
- No “where does this go?” dialog.

Optional **one-line note** (e.g. “Tokoname pot, 23 cm”) is allowed — it is metadata on the Inbox item, not classification.

### 2.2 Desktop — triage (organize later)

```text
Open Inbox (badge shows pending count)
    ↓
Review captured items (newest first, or by capture date)
    ↓
For each item: Route · Delete · Keep in Inbox
    ↓
Route → choose destination + complete destination-specific step
    ↓
Item leaves Inbox; becomes a record in the target module
```

### 2.3 Route destinations (v1 set)

| Destination | Meaning |
|-------------|---------|
| **Tree** | Attach to an existing Tree (photo → Gallery path; note → Journal / Tree note). |
| **Pot** | Create or link Inventory pot record. |
| **Tool** | Create or link Inventory tool record. |
| **Product** | Create or link Inventory product (fertilizer, soil, wire, etc.). |
| **Gallery** | Library Gallery asset not yet tied to a Tree *(or “general visual memory”)*. |
| **Knowledge** | Reference / guide / external link material. |
| **Inventory** | Generic Inventory entry when subtype unclear. |
| **Journal** | Standalone or Tree-linked journal entry with media. |
| **Delete** | Remove capture and backing blobs from Inbox. |

**Add Tree** is intentionally **not** a capture destination — registering a bonsai remains **Add Tree** on desktop. A capture may **assist** Add Tree later (e.g. route photo → new Tree during triage wizard) but capture does not replace botanical registration.

### 2.4 End-to-end diagram

```text
┌─────────────────┐     sync      ┌─────────────────┐
│ Mobile Companion │ ────────────► │  Bonsai World   │
│  Quick Capture   │               │     Library     │
└────────┬────────┘               └────────┬────────┘
         │                                  │
         ▼                                  ▼
    Inbox (pending) ◄──────────────► Inbox (same items)
         │                                  │
         │         (later, desktop)         │
         └──────────────► Triage ──────────┘
                              │
              ┌───────────────┼───────────────┐
              ▼               ▼               ▼
           Tree/Gallery   Inventory      Journal
           Knowledge      Economy        Delete
```

### 2.5 Dashboard relationship

Dashboard may **surface** “N items in Inbox” as an attention card — read-only orientation. **Triage lives in Inbox**, not on Dashboard as a second product surface.

---

## 3. Inbox concept

### 3.1 Definition

The **Inbox** is a **temporary staging queue** inside the active Bonsai World Library. It holds **Capture Items** until the grower routes or deletes them.

| Property | Rule |
|----------|------|
| **Temporary** | Inbox is not permanent storage for knowledge — it is a **waiting room**. |
| **Honest backlog** | Pending count is visible; zero Inbox is a valid calm state. |
| **Same Library** | Inbox items are part of the library package — not a separate cloud inbox product. |
| **No orphan blobs** | Every capture has an Inbox record + stored media (when applicable). |

### 3.2 Capture Item (conceptual model)

| Field (conceptual) | Purpose |
|--------------------|---------|
| `id` | Stable UUID |
| `kind` | `photo` · `voice` · `text` · `photo+text` · `voice+text` |
| `capturedAt` | When captured (device time; normalized on sync) |
| `importedAt` | When received into Library |
| `caption` | Optional one-line user note at capture |
| `mediaIDs` | Relative keys to blobs in library storage |
| `transcript` | Optional speech-to-text (future) |
| `status` | `pending` · `routed` · `deleted` |
| `routedTo` | Destination module + target record ID(s) when routed |
| `captureDevice` | Optional provenance (Mobile Companion, desktop quick-add) |
| `locationHint` | Optional coarse geo (future, opt-in) |

**Status `routed`:** item may remain visible in Inbox history (Experienced+) or archive out of default Inbox view — product choice at implementation; default **Novice** sees only `pending`.

### 3.3 Inbox UI (desktop)

| Element | Role |
|---------|------|
| **Inbox list** | Cards: thumbnail / waveform / text preview + capture date + optional caption. |
| **Detail pane** | Full preview; Route / Delete actions. |
| **Route sheet** | Destination picker → destination module hands off (see §5 Gallery). |
| **Badge** | Sidebar or Tools entry: pending count. |

**Navigation home (proposal):** **Tools → Inbox** or **Dashboard attention → Inbox**. Not a top-level Version 2 module — Inbox is a **cross-cutting capture service**, not competing with Garden / Workshop / Inventory.

### 3.4 Inbox UI (mobile)

| Element | Role |
|---------|------|
| **Quick Capture** | Primary screen — large capture buttons; minimal chrome. |
| **Recent captures** | Short list of last N items sent to Inbox ( reassurance only ). |
| **No triage required on phone** | Routing on mobile is **optional v2**; v1 mobile is capture-only. |

Falo: **one primary action** on mobile = **Capture**.

### 3.5 Retention policy (product)

| Level | Policy |
|-------|--------|
| **Pending** | Kept until routed or deleted — no silent expiry in v1. |
| **Routed** | Source media retained per destination module rules (Gallery Originals, Journal attachments, etc.). |
| **Deleted** | Remove Inbox record + unreferenced blobs per Library hygiene rules. |

Future: optional “archive routed items after 30 days” — Expert setting only.

---

## 4. Synchronization

### 4.1 Principle

Quick Capture **must** sync automatically with Bonsai World. The grower captures on phone; the desktop Library receives the same Inbox items without manual export/import.

### 4.2 One Library

| Rule | Meaning |
|------|---------|
| **Single library truth** | Mobile Companion writes into the **same** active Bonsai World Library the desktop uses. |
| **No second inbox cloud** | No separate “Capture Cloud” schema — Inbox lives in the library package. |
| **StorageProvider** | All blobs via abstraction (Blueprint §3); relative keys only in models. |
| **Conflict-free capture** | New captures **append** with new UUIDs — no merge conflicts on capture itself. |

### 4.3 Sync phases (delivery planning)

| Phase | Mechanism | Notes |
|-------|-----------|-------|
| **S0 — Local only** | Desktop “Quick Add to Inbox” for dev/testing | No mobile yet; validates Inbox + triage. |
| **S1 — Same network / manual pair** | Companion pairs to Library on LAN or cable | First mobile path. |
| **S2 — iCloud / provider sync** | Library provider syncs entire package (Phase 2 storage) | Inbox folder syncs with Library. |
| **S3 — Bonsai Cloud** | Dedicated provider (Phase 4) | Same Inbox semantics. |

**Platform independence:** sync logic in **services**; iOS/Android/macOS/Windows adapters in platform layer (Constitution §11).

### 4.4 Offline mobile

| Scenario | Behaviour |
|----------|-----------|
| No network | Capture locally on device; queue uploads when Library reachable. |
| Partial sync | Item shows `pending upload` on mobile; desktop sees after sync completes. |
| Library switched on desktop | Mobile must re-pair / follow active library — one active library per grower session. |

### 4.5 What sync is not

- Not Library Management Import (§8.1) — that is full package administration.  
- Not Gallery Import Photos — that is intentional photo ingestion into Gallery workflows.  
- Not a realtime collaboration feed between users.

---

## 5. Relationship with Gallery

### 5.1 Division of responsibility

| Concern | Owner |
|---------|--------|
| **Fast capture of any photo** | **Quick Capture → Inbox** |
| **Prepare, crop, Primary, compare, organize tree photos** | **Gallery** (§5.5) |
| **Attach photo to Tree** | Triage **Route → Tree** hands off to **Gallery** |
| **Library-wide visual browse** | **Gallery** module |

Quick Capture **feeds** Gallery; it does **not** duplicate Gallery editing.

### 5.2 Route → Tree (photo)

```text
Inbox photo
    ↓
Route → Tree (pick Tree)
    ↓
Gallery: import Original into Tree’s set
    ↓
Optional: Prepare (crop) before Primary — Gallery workflow
    ↓
Inbox item marked routed; Tree / Gallery own the asset
```

### 5.3 Route → Gallery (no Tree yet)

Photo becomes a **Gallery library asset** (unassigned or general album). If later linked to a Tree, normal Gallery attach rules apply.

### 5.4 Route → Inventory / Knowledge (photo)

Photo attaches to **Inventory** or **Knowledge** record as that module defines. Gallery Prepare may still apply when the destination uses presentation images — delegated to owning module, not Inbox.

### 5.5 Voice and text

Voice/text captures routed to **Journal** or **Tree** create Journal entries or notes with optional media refs — not Gallery items unless a photo is part of the capture.

### 5.6 Anti-patterns (forbidden)

- Crop at Quick Capture time.  
- Set Primary at capture time.  
- “Which Tree is this?” at shutter press.  
- Parallel image store outside Library Inbox/Gallery/Images layout.

---

## 6. Experience Levels

Same Library and Inbox schema at every level. **The Software Grows with the Artist** (§1.1, §6).

### 6.1 Novice

| Aspect | Behaviour |
|--------|-----------|
| **Mobile** | Photo + short text only; one-tap capture; voice optional or hidden. |
| **Desktop Inbox** | Simple list; Route to **Tree**, **Journal**, **Delete** prominently; other destinations in “More…” |
| **Guidance** | “Capture now — organize when you’re back at your desk.” |
| **Gallery handoff** | After Route → Tree, calm prompt: “Prepare photo for this tree?” (Gallery) — skippable. |
| **Badge** | Gentle pending count on Inbox entry. |

### 6.2 Experienced

| Aspect | Behaviour |
|--------|-----------|
| **Mobile** | Photo, voice, text; optional caption; batch capture session. |
| **Desktop Inbox** | Full destination set; filter by kind/date; bulk delete. |
| **Routing** | Route → Pot / Tool / Product / Inventory / Gallery / Knowledge. |
| **History** | View recently routed items. |
| **Mobile triage** | Optional: light routing on phone when convenient. |

### 6.3 Expert

| Aspect | Behaviour |
|--------|-----------|
| **Mobile** | Voice + auto-transcript; QR detection hint; location hint (opt-in). |
| **Desktop** | Multi-select route; keyboard triage; link capture to Economy (receipts). |
| **AI assists** | Suggest destination (“looks like a fertilizer label → Product?”) — **suggestions only**, never auto-route without confirm. |
| **Gallery** | Batch route multiple exhibition photos to one Tree; then Gallery compare. |
| **Retention** | Archive routed Inbox history; diagnostics for failed sync items. |

**Level-invariant:** Capture never requires classification; one Library; Inbox sync semantics identical.

---

## 7. Future expansion

### 7.1 Mobile Companion capabilities

- Live Activity / widget: **Capture** without opening full app.  
- Apple Watch / Wear OS glance capture → Inbox.  
- Background upload queue with retry.  
- Exhibition mode: rapid-fire photos → single Inbox session.

### 7.2 Desktop triage intelligence

- OCR on labels and receipts.  
- QR / barcode → Product or Knowledge draft.  
- “Create Tree from this capture” **wizard** (uses capture as Primary candidate — still **Add Tree** domain rules).  
- Split one capture into multiple destinations (Experienced+).

### 7.3 Cross-module links

| Destination | Future link |
|-------------|-------------|
| **Workshop / Tasks** | Voice note → task with due date |
| **Economy** | Receipt → expense record |
| **Propagation** | Yamadori / cutting field photo |
| **Design** | Reference photo for style study |
| **Assistant** | “What is this label?” on Inbox item |

### 7.4 Storage layout (illustrative)

```text
Bonsai World Library/
  Database/
    Inbox.json              ← Capture Item index
  Inbox/
    Pending/                ← blobs for pending items
    Archive/                ← optional routed history (Expert)
  Images/                   ← Gallery-owned after route (Originals / Presentations)
  Audio/                    ← voice captures (until routed)
  Documents/
  …
```

Exact folder names are implementation; **Inbox is first-class in the library package**.

### 7.5 Delivery roadmap (proposed)

| Stage | Deliverable |
|-------|-------------|
| **QC0 — Decision** | Blueprint § module; this proposal approved |
| **QC1 — Desktop Inbox** | Manual “Add to Inbox”; triage UI; Route → Tree / Journal / Delete |
| **QC2 — Gallery handoff** | Route → Tree uses Gallery attach + optional Prepare |
| **QC3 — Mobile capture** | Companion app: photo + text → sync |
| **QC4 — Full destinations** | Inventory, Product, Pot, Tool, Knowledge, Gallery |
| **QC5 — Voice + sync hardening** | Offline queue; provider sync |
| **QC6 — Intelligence** | OCR, suggestions, batch triage |

---

## 8. Blueprint adoption checklist

When approved, fold into Product Blueprint:

1. New section **§5.x Quick Capture / Inbox** (or Tools adjunct — not Version 2 top-level module).  
2. Cross-ref §5.5 Gallery — capture vs prepare vs organize.  
3. Cross-ref §3 Storage — Inbox folder in library package.  
4. Cross-ref §6 Experience Levels — table above.  
5. Cross-ref §10 Mobile Companion (new subsection if needed).  
6. Dashboard card: Inbox attention only.  
7. Explicit rule: **Capture first. Organize later.**

Until then, this file is **proposal only**.

---

## 9. Summary

| # | Topic | Answer |
|---|--------|--------|
| 1 | **Purpose** | Fast pre-classification capture away from desk; preserve moments before they are lost. |
| 2 | **User workflow** | Mobile: capture → Inbox. Desktop: review → route or delete. No destination at capture time. |
| 3 | **Inbox** | Temporary staging queue in the Library; Capture Items until routed/deleted. |
| 4 | **Synchronization** | Same Library via StorageProvider; mobile append-only capture; phased sync (pair → iCloud → cloud). |
| 5 | **Gallery** | Quick Capture feeds Inbox; Gallery owns attach, Prepare, Primary, compare after Route → Tree/Gallery. |
| 6 | **Experience Levels** | Novice: photo/text, simple routes; Experienced: full destinations; Expert: AI hints, batch, archive. |
| 7 | **Future** | Widgets, OCR, receipts, voice, exhibition burst, Assistant — always Inbox-first capture. |

**Product mantra:** *Capture first. Organize later.*
