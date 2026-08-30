# Inventory 2.0 — Product Architecture

**Type:** Product / architecture review (non-governing · historical once folded)  
**Date:** 23 August 2026  
**Status:** **Approved decision** — folded into [PRODUCT_BLUEPRINT.md](../PRODUCT_BLUEPRINT.md) **§5.11** (+ Version 2 / cross-module refs). This file remains the rationale.  
**Governing sources read:** README · START_HERE · BONSAI_CONSTITUTION · PRODUCT_BLUEPRINT · Falo Design System *(Swift tokens under `Shared/DesignSystem/`; `FALO_DESIGN_SYSTEM.md` referenced by START_HERE)*  

**Related:** [Asset_Architecture.md](Asset_Architecture.md) · [Quick_Capture_Inbox.md](Quick_Capture_Inbox.md) · [Gallery_Image_Library.md](Gallery_Image_Library.md) · [Yamadori_Module.md](Yamadori_Module.md)

**Principle:** *Own it. Document it. Maintain it. Use it.*

---

## 1. Purpose

### 1.1 Definition

**Inventory** is Bonsai World’s **central register of physical items** the grower owns that support the bonsai hobby.

It is **not** a flat equipment list. Each **Inventory Item** is a durable record of something real — with identity, provenance, condition, storage, media, and lifecycle — that may stay in the Library for decades.

### 1.2 Product sentence

> Inventory is where the grower knows **what they own**, **what it cost**, **where it lives**, and **how it supports the craft** — from a shohin pot to a bag of akadama to a greenhouse sensor.

### 1.3 What Inventory is

| Aspect | Meaning |
|--------|---------|
| **Job** | Register, document, locate, maintain, and use physical hobby assets |
| **Time horizon** | Entire ownership — purchase through retirement, sale, or disposal |
| **Scope** | Everything physical that supports bonsai except **Trees** (Trees module) and **wild sites** (Yamadori) |
| **Feel** | Calm asset register + workshop cupboard — not accounting software |

### 1.4 What Inventory is not

- Not **Reference Data** — Settings lists (pot types, tool names, wire gauges) are **vocabulary**; Inventory holds **owned instances**.  
- Not **Economy** — Economy **reads** purchase and value fields; Inventory **owns** them.  
- Not **Gallery** — photos and receipts are **Assets**; Inventory **links** via Asset System (§3.6).  
- Not **Locations** — bench/garden places where **trees** live; Inventory owns **storage places** for **items** (shed, toolbox, pot rack). A pot **assigned to a Tree** links both.  
- Not **Knowledge** — guides and courses are learning content; a **physical book** the grower owns is an Inventory Item that may link to Knowledge.  
- Not **stock ERP** — stock management is a **future capability** on the same schema, not a separate product.

### 1.5 Constitution alignment

Trees remain the heart (Constitution §1). Inventory **orbits** — pots, wire, and tools exist to serve trees and craft. One Library, one schema at every Experience Level (§17). Reference Data stays in Settings (§9); Inventory consumes pickers, never redefines master vocabulary inline.

### 1.6 Distinction: Reference Data “Inventory Preparation” vs Inventory module

| Concept | Owner | Example |
|---------|-------|---------|
| **Reference Data — Inventory Preparation** | Settings → Reference Data | List entry “Yagimoku 15 cm oval” — reusable label |
| **Inventory Item** | Inventory module | *This* Yagimoku pot bought 2023, serial photo, stored on Rack B, assigned to Tree X |

Quick Capture **Pot** / **Tool** / **Product** triage creates **Inventory Items**, optionally pre-filled from Reference Data pickers.

---

## 2. Information architecture

### 2.1 Primary object: InventoryItem

One domain type for all physical assets. **Kind** drives which optional fields and Detail sections appear — not separate apps or schemas.

**InventoryItem** *(conceptual)*

| Group | Fields (illustrative) |
|-------|------------------------|
| **Identity** | id, name, kind, status, createdDate, modifiedDate |
| **Description** | notes, manufacturer, model, serialNumber, barcode |
| **Provenance** | purchaseDate, purchasePrice, currency, currentValue, supplierID *(Reference Data)*, warrantyExpiry |
| **Physical** | kind-specific attributes (see §2.3) |
| **Storage** | storagePlaceID, storageNotes |
| **Stock** *(consumables)* | quantity, unit, reorderThreshold, lastRestockDate *(future alerts)* |
| **Assignment** | assignedTreeID *(pots, turntables when dedicated)*, onLoanTo, loanDueDate *(future)* |
| **Links** | assetLinkIDs (via Asset System), maintenanceRecordIDs, workRecordIDs, economyTransactionIDs *(future read-back)* |

### 2.2 Inventory kinds (canonical catalog)

Kinds are **filters and Detail templates**, not separate stores.

| Kind | Examples | Stock fields |
|------|----------|--------------|
| **pot** | Bonsai pots, mica pots, training pots | No |
| **growing_container** | Nursery cans, colanders, grow boxes | Optional |
| **tool** | Concave cutters, jin pliers, scissors, saws | No |
| **turntable** | Workshop turntables | No |
| **display_stand** | Exhibition stands, tables | No |
| **wire** | Aluminum, copper, annealed — by gauge | Yes |
| **soil** | Bagged akadama, pumice, lava | Yes |
| **soil_component** | Bulk component stock | Yes |
| **soil_mix** | Prepared mix batches *(may link Reference Data soilMixID)* | Yes |
| **fertilizer** | BioGold, liquid feeds | Yes |
| **chemical** | Lime sulfur, insecticides, fungicides | Yes |
| **consumable** | Mesh, raffia, grafting tape, chopsticks | Yes |
| **greenhouse_equipment** | Heaters, fans, shade cloth systems | No |
| **irrigation** | Timers, drippers, pumps | No |
| **grow_light** | LED panels, fixtures | No |
| **sensor** | Moisture, temp/humidity loggers | No |
| **camera** | DSLR, phone rig, macro lens | No |
| **book** | Physical books, magazines | No |
| **reference_material** | Printed charts, species cards | No |
| **exhibition_equipment** | Transport crates, display accents | No |
| **other** | Anything else — catch-all | Optional |

Version 2 sidebar routes (§10.2) are **permanent IA filters** over this catalog — not separate databases. New kinds extend the enum; routes group kinds for navigation calm.

### 2.3 Kind-specific attributes (progressive disclosure)

Stored on InventoryItem or a typed extension — one persistence model, optional fields by kind.

| Kind | Typical extra fields |
|------|---------------------|
| **pot** | potTypeID, material, shape, length/width/height/diameter mm, drainage holes, artist/maker, glaze |
| **wire** | gauge mm, material, length on spool |
| **soil / component / mix** | volume, particle size, brand, linked soilMixID |
| **fertilizer / chemical** | NPK or active ingredient, application notes, safety sheet Asset |
| **tool** | tool catalog ref, sharpenedDate, condition |
| **book** | author, ISBN, linked Knowledge article *(future)* |

### 2.4 Storage places

Inventory owns **StoragePlace** — where items are kept when not on a tree.

| Field | Meaning |
|-------|---------|
| name | “Pot Rack B”, “Tool Drawer”, “Soil Shed” |
| notes | Access, climate |
| optional locationID | Link to a **Locations** record when storage shares a garden structure |

**Do not** conflate StoragePlace with tree **Location** (bench). A pot **on** a tree links `assignedTreeID`; when repotted into storage, clear assignment and set `storagePlaceID`.

### 2.5 Maintenance and history

**MaintenanceRecord** *(owned by Inventory, may link Workshop Work)*

| Field | Meaning |
|-------|---------|
| date | When service happened |
| summary | Sharpening, calibration, repair, refill |
| cost | Optional — Economy reads later |
| workRecordID | Optional link to **Workshop → Work** |
| assetLinkIDs | Before/after photos via Assets |

Timeline on Item Detail aggregates: purchase, assignments, maintenance, stock adjustments, loan events.

### 2.6 Module navigation (Version 2)

```text
Inventory (Expert+)
├── All Items                    ← default list; search everything
├── Pots
├── Growing Containers
├── Tools
├── Turntables & Stands          ← turntable, display_stand
├── Wire
├── Soil & Components            ← soil, soil_component, soil_mix
├── Fertilizers & Chemicals
├── Consumables
├── Infrastructure               ← greenhouse, irrigation, grow_light, sensor
├── Studio & Exhibition          ← camera, exhibition_equipment
└── Library & Reference          ← book, reference_material
```

Standard shell: Sidebar → sectioned/filtered List → Item Detail → Quick Actions (Blueprint §7).

**Dashboard “Inventory” card** (§5.1) = read-only **consumables attention** (low stock) — deep-links into Inventory filters, not a second register.

---

## 3. Item lifecycle

### 3.1 Canonical flow

```text
Acquire (purchase, gift, inherit, make)
    ↓
Register (New Inventory Item — kind, name, key facts)
    ↓
Document (Assets: photos, receipt, manual, warranty PDF)
    ↓
Store (StoragePlace · optional Tree assignment for pots)
    ↓
Use (Workshop work references tools; repot assigns pot to Tree)
    ↓
Maintain (MaintenanceRecord · reminders *(future)*)
    ↓
Retire (sold · gifted · lost · disposed · consumed-depleted)
```

### 3.2 Status model

| Status | Meaning |
|--------|---------|
| **active** | In use or available (default) |
| **assigned** | Dedicated to a Tree or long-term setup *(pots, turntables)* |
| **in_storage** | Not currently in use |
| **on_loan** | Lent to someone *(future)* |
| **maintenance_due** | Flagged for service *(future reminder)* |
| **depleted** | Consumable exhausted |
| **retired** | Kept for history but not in active use |
| **sold** | Ownership ended by sale |
| **lost** | Missing |
| **disposed** | Discarded responsibly |

Retirement **preserves** the record and linked Assets — same spirit as Tree Lifetime (§4.5). Delete only for mistaken duplicate registration.

### 3.3 Pot ↔ Tree relationship

| Rule | Detail |
|------|--------|
| **Inventory owns the pot object** | Maker, purchase, photos, storage history |
| **Tree links to current pot** | `Tree.currentPotInventoryItemID` *(when implemented)* — optional |
| **Repot workflow** | End assignment on old pot → assign new pot → optional Workshop Work record |
| **Dimensions** | Authoritative on **InventoryItem** for pots; Tree Overview **displays** linked pot; legacy `potTypeID` + mm fields on Tree migrate toward link + display snapshot |
| **Economy** | Pot value from Inventory; Economy aggregates “Pot Value” |

Tree Workspace **Ownership / pot** chapter shows linked Inventory pot as read-first with shortcut **Open in Inventory** — not a second pot editor.

### 3.4 Consumables and stock *(architecture now; alerts later)*

| Rule | Detail |
|------|--------|
| **Quantity lives on InventoryItem** | wire spools, soil bags, fertilizer |
| **Workshop consumption** *(future)* | Work record may decrement wire / log mix batch |
| **Reorder threshold** | Optional; Dashboard surfaces “Running low” |
| **No double counting** | One bag of akadama = one Item; partial use adjusts quantity |

Stock management ships incrementally; schema supports it from day one.

---

## 4. Experience Levels

Same **InventoryItem** schema at every level. Module visibility follows Workspace Profile (§6).

| Capability | Novice | Experienced | Expert |
|------------|--------|-------------|--------|
| **Inventory module** | Hidden | Hidden *(default)* | Full module |
| **See pot on Tree** | If linked — name/thumbnail only | + purchase year, dimensions | + value, full history link |
| **Quick Capture → Inventory** | Hidden | Receipt/label → Inbox *(optional Experienced triage)* | Full Pot/Tool/Product routes |
| **Add Inventory Item** | — | — | Yes |
| **Stock / reorder fields** | — | — | Yes |
| **Maintenance timeline** | — | — | Yes |
| **Insurance pack export** *(future)* | — | — | Yes |
| **Tool lending** *(future)* | — | — | Yes |
| **Assistant inventory scope** | Hidden | Hidden | Opt-in |

**Experienced exception *(optional product tuning)*:** Wire/soil **stock glance** on Dashboard without full Inventory navigation — still reads Inventory data, never a parallel list.

---

## 5. Relationships with other modules

### 5.1 Gallery & Assets

| Step | Module |
|------|--------|
| Photo of pot / receipt / label | Quick Capture → **Asset** |
| Link to Item | **AssetLink** on InventoryItem |
| Label / product photo roles | `label_scan`, `evidence`, `reference`, `primary_photo` |
| Prepare / crop | **Gallery** on photo Assets |
| Manual PDF | `pdf` or `scanned_document` Asset |

Inventory **never** stores blobs. Gallery owns photo workflows (§5.5).

### 5.2 Quick Capture & Mobile Companion

| Capture | Typical triage |
|---------|----------------|
| Pot photo | **Pot** → new or existing InventoryItem |
| Tool photo | **Tool** → InventoryItem |
| Product / label | **Product** → fertilizer, soil, chemical Item |
| Receipt | **Economy** + **Inventory** multi-link on same receipt Asset |
| QR / barcode | Pre-fill manufacturer or reorder *(future)* |

Mobile-primary for field purchases and shed documentation; desktop Inbox for batch triage (§3.6.1).

### 5.3 Workshop

| Link | Direction |
|------|-----------|
| **Tools used** | Work record → `toolInventoryItemIDs[]` |
| **Wire / mix consumed** *(future)* | Work → consumable Items, quantity delta |
| **Maintenance** | MaintenanceRecord ↔ Work record |
| **Repot** | Work on Tree + pot assignment change |

Workshop owns **work semantics**; Inventory owns **item truth** and assignment history.

### 5.4 Economy

| Rule | Detail |
|------|--------|
| **Inventory owns** | purchaseDate, purchasePrice, currentValue, supplier |
| **Economy reads** | Aggregates — Inventory Value, Pot Value, purchases, supplier stats |
| **Economy never owns master rows** | No duplicate Item records |
| **Receipt Asset** | One Asset → links to Economy expense + Inventory Item |

Economy implementation gate unchanged: Inventory must exist first (Idea Parking Lot / ROADMAP).

### 5.5 Tree Workspace

| Surface | Behaviour |
|---------|-----------|
| **Overview / Growing** | Show linked pot summary (Gallery Presentation via Item’s primary photo Asset) |
| **Ownership chapter** | Acquisition + linked pot history |
| **Quick Action** | Assign Pot → picker over Inventory pots → sets `currentPotInventoryItemID` |
| **No inline pot CRUD** | Shortcuts to Inventory Detail |

### 5.6 Mobile Companion

- Capture receipt and label Assets at nursery or club sale.  
- Optional: quick **New Item** with photo + price only; enrich on desktop.  
- Offline queue → Library Asset catalog → Inbox triage.

### 5.7 Bonsai Assistant

- **Read-only** context: Item kind, linked Assets, maintenance due, stock level.  
- Scoped suggestions: “Which pot fits this tree?” — queries Inventory pots by dimensions; grower confirms assignment.  
- Product recommendations *(future)* — external links as Assets; no affiliate store inside Inventory.

### 5.8 Yamadori · Exhibition · Knowledge

| Module | Relationship |
|--------|--------------|
| **Yamadori** | Collection-day equipment checklist may reference Inventory Items *(future picker)* |
| **Exhibition** *(Expert)* | Display stands, transport crates as Items; link to exhibition plan |
| **Knowledge** | Physical **book** Items may link to handbook entries — content vs owned copy |

---

## 6. Required Blueprint updates

Applied in `PRODUCT_BLUEPRINT.md`:

1. **New §5.11 Inventory** — full module template (purpose, objects, IA, lifecycle, navigation, Quick Actions, Detail, relationships, Experience Levels).  
2. **§10.2 Inventory** — expanded responsibility and kind catalog; filters not separate stores.  
3. **§3.6 Assets / Quick Capture** — cross-ref §5.11; Pot/Tool/Product triage creates Inventory Items.  
4. **§5.2 Trees** — pot link pattern (`currentPotInventoryItemID`); Tree displays, Inventory owns.  
5. **§5.1 Dashboard** — Inventory card = consumables attention from Inventory service.  
6. **§6 Expert profile** — Inventory visibility unchanged in intent; §5.11 is authoritative.  
7. **Reference Data** — clarify Settings **Inventory Preparation** lists vs operational Inventory (§5.11).  
8. **Asset_Architecture.md §4.6** — cross-ref §5.11.  
9. **CHANGELOG** — 2026-08-23 Inventory 2.0 decision.

---

## 7. Future capabilities (same architecture)

| Capability | Notes |
|------------|-------|
| **Insurance documentation** | Export Item list + Asset pack (photos, receipts, serials) |
| **Maintenance reminders** | Calendar/Tasks read `maintenance_due` — Tasks owns completion |
| **Tool lending** | `on_loan` status + borrower + due date |
| **Product recommendations** | Assistant + Knowledge links — not Inventory-owned commerce |
| **Stock management** | Quantity, thresholds, consumption from Workshop |
| **Purchase planning** | Wish list Items or tags — not separate module |

---

## 8. Explicit non-goals

- Implementing code or Swift models.  
- Turning Inventory into accounting (no ledger, no VAT engine).  
- Duplicating photo blobs outside Asset System.  
- Merging Reference Data catalog rows with owned Items without an explicit **Register from catalog** action.  
- Expert-only Inventory blocking Novice data capture — Quick Capture may still create Items; Expert reveals full module.

---

## 9. Delivery roadmap (proposed)

| Stage | Deliverable |
|-------|-------------|
| **I0** | Blueprint + domain model (this document) |
| **I1** | InventoryItem CRUD, kinds, StoragePlace, Asset links, All Items + Pots/Tools routes |
| **I2** | Quick Capture → Inventory triage; Gallery primary photo on Items |
| **I3** | Tree pot assignment link; repot workflow hooks |
| **I4** | Consumables stock fields; Dashboard low-stock card live |
| **I5** | Workshop tool links + maintenance timeline |
| **I6** | Economy read API; insurance export; lending + reminders |

---

## 10. Summary

Inventory 2.0 establishes a **single permanent asset register** — **`InventoryItem`** with **kind-based filters**, **Asset-linked documentation**, **storage and assignment semantics**, and **Economy-ready provenance** — while Reference Data remains **vocabulary in Settings**. *Own it. Document it. Maintain it. Use it.*
