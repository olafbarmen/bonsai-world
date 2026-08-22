# Idea Parking Lot

**Process document — not product documentation.**

This file captures ideas discovered during development so they are not forgotten and are not implemented immediately.

It is not one of the five product documents. Product truth lives in START_HERE, the Constitution, Product Blueprint, Roadmap, and Changelog.

---

## Purpose

Write ideas here first. Protect focus. Review later. Implement only after an idea is promoted to the Roadmap and further detailed in the Product Blueprint when required.

---

## Status definitions

| Status | Meaning | Section |
|--------|---------|---------|
| **New** | Captured and awaiting review. Not approved. | Active Ideas |
| **Deferred** | Reviewed and kept for later. Not on the Roadmap. Not rejected. | Active Ideas |
| **Promoted** | Accepted for product direction, added to [ROADMAP.md](../ROADMAP.md), and archived here for history. | Archived Ideas |
| **Rejected** | Not accepted. Kept for historical reference. | Archived Ideas |

---

## Transitions

Allowed transitions only:

```text
New  →  Deferred
New  →  Promoted
New  →  Rejected

Deferred  →  Promoted
Deferred  →  Rejected
```

**Promoted** and **Rejected** are terminal. Do not move archived ideas back to Active Ideas. If a rejected or promoted theme must be reconsidered, add a **new** idea.

When promoting:

1. Add the theme to [ROADMAP.md](../ROADMAP.md).  
2. Set the idea status to **Promoted**.  
3. Move the idea entry from Active Ideas to Archived Ideas.  
4. Detail implementation in [PRODUCT_BLUEPRINT.md](../PRODUCT_BLUEPRINT.md) only after it is approved for the current product.

---

## Rules

1. New ideas discovered during development must be added here before implementation.
2. Adding an idea does not mean it is approved.
3. An idea from this file may affect the Roadmap only after it is **Promoted** (added to [ROADMAP.md](../ROADMAP.md) and moved to Archived Ideas).
4. **Rejected** ideas remain in Archived Ideas for historical reference.
5. Never delete ideas; archive them instead.
6. Do not implement from this file directly. Existing Roadmap themes that did not originate here remain valid product direction.

---

## Template

Copy this block for each new idea.

```text
### Idea #N

- **ID:** #N
- **Title:**
- **Area:**
- **Reason:**
- **Status:** New | Deferred | Promoted | Rejected
```

---

## Active Ideas

### Idea #3 — Environmental Engine

- **ID:** #3
- **Title:** Environmental Engine — Integrate Data Sources, not Products
- **Area:** Infrastructure / IoT / Assistant
- **Reason:** Bonsai Hub must not be designed around vendor hardware (RainPoint, Netatmo, Gardena, etc.). A common Environmental Engine should translate all external sources into one environmental model so Care, Monitoring, Assistant, AI, Analytics, and Tree History never depend on product-specific APIs.
- **Status:** New
- **Maturity:** Hypothesis (architectural concept — no implementation)

#### Description

Bonsai Hub should never be designed around specific hardware products such as RainPoint, Netatmo, Gardena or other vendors.

Instead it should introduce a common **Environmental Engine** responsible for handling all environmental information regardless of source.

Every external integration becomes a **translator** that converts vendor-specific data into Bonsai Hub's common environmental model.

Example:

```text
RainPoint
Netatmo
Home Assistant
Weather Station
Manual Input
        │
        ▼
Environmental Engine
        │
        ▼
Assistant
Monitoring
AI
Analytics
Care
Tree History
```

The rest of Bonsai Hub should never need to know where the information originated.

#### Initial Environmental Data Types

- Air Temperature
- Soil Temperature
- Soil Moisture
- Air Humidity
- Rainfall
- Wind
- UV Index
- Light Level
- Irrigation Status
- Water Consumption
- Battery Status
- Device Health

#### Potential Uses

**Assistant**

- Water today.
- Delay watering because rain is expected.
- Greenhouse temperature becoming critical.

**Monitoring Center**

- Greenhouse above threshold.
- Soil moisture too low.
- Irrigation completed but moisture unchanged.
- Sensor offline.
- Low battery.

**Historical Analysis**

Store environmental conditions together with tree history.

Examples:

- Weather during bud break.
- Soil temperature before repotting.
- Rainfall during growing season.
- Temperature history.

**Analytics**

Future versions may correlate:

- Growth
- Health
- Watering
- Fertilizing
- Repotting
- Environmental conditions

to identify patterns and improve recommendations.

#### Design Principle

Integrate with **data sources**, not products.

Products change.

Data remains.

#### Notes

This is an architectural concept rather than a feature.

The Environmental Engine is intended to become the common layer used by multiple future modules, including:

- Care
- Monitoring Center
- Bonsai Assistant
- AI
- Tree History
- Analytics

No implementation work is required at this stage.

Only capture and organise this idea for review when Infrastructure- and IoT-architecture matures.

---

## Archived Ideas

### Idea #1 — Economy module

- **ID:** #1
- **Title:** Economy — collection financial insight (analysis, not accounting)
- **Area:** Future feature module / Dashboard widgets
- **Reason:** Growers need calm insight into acquisition cost, estimated collection value, inventory spend, and (later) sales — without turning Bonsai World into an accounting product. Economy should read existing module data only.
- **Status:** Promoted (added to [ROADMAP.md](../ROADMAP.md) → SOMEDAY)

#### Purpose

Economy is a **future** module that provides financial insight into the user’s bonsai collection.

- It is **not** an accounting system.
- It is an **analysis** module built on data from other Bonsai World modules.
- It **owns no master data**.
- It only aggregates and analyses data from:
  - Trees
  - Inventory
  - Propagation
  - Sales (future)
  - Purchases (future)

#### Planned features

**Collection Economy**

- Total acquisition value
- Total estimated collection value
- Value development
- Collection statistics

**Tree Economy**

- Acquisition price
- Estimated value
- Sale value (future)
- Profit/Loss (future)

**Inventory Economy**

- Purchases
- Inventory value
- Material consumption
- Supplier statistics

**Reports**

- Annual purchases
- Annual sales
- Annual investments
- Collection value over time

**Dashboard integration (future widgets)**

- Collection Value
- Annual Investment
- Inventory Value
- Economy Summary

#### Architecture

- Economy **depends on** other modules.
- Other modules **must never depend on** Economy.
- Economy contains **no duplicated data**.
- It reads existing data through **shared services**.
- Full §4.2 module template belongs in [PRODUCT_BLUEPRINT.md](../PRODUCT_BLUEPRINT.md) only when Economy is approved for build — not before.

#### Implementation gate

Do **not** implement Economy until all of the following are true:

1. Trees are complete.
2. Reference Data is complete.
3. Inventory is implemented.
4. Core bonsai workflows are stable.

### Idea #2 — Falo Botanical Icon Library

- **ID:** #2
- **Title:** Falo Botanical Icon Library — Genus-mapped botanical icons for Trees (and future Falo Worlds)
- **Area:** Falo Design System / Tree presentation / shared icon families
- **Reason:** Trees need a calm, meaningful visual before a primary image exists. Mapping icons by Genus keeps the cue botanical and automatic, while the library itself belongs in the shared Falo Design System for reuse across applications.
- **Status:** Promoted (added to [ROADMAP.md](../ROADMAP.md) → SOMEDAY)

#### Purpose

Create a **custom botanical icon library** for Bonsai World.

- The library shall become part of the **Falo Design System**.
- It may later be reused across future Falo applications.

#### Background

- Every Tree should display a meaningful icon **before** a primary image has been added.
- Icons are selected **automatically from the Tree’s Genus**.
- When the Tree has a primary image, the **image replaces the icon**.

#### Architecture

Icons are mapped by Genus (vector assets named by genus), for example:

- Acer → `acer.svg`
- Juniperus → `juniperus.svg`
- Pinus → `pinus.svg`
- Ulmus → `ulmus.svg`

If no genus-specific icon exists, display the **default Falo Tree icon**.

#### Icon style

The entire library must follow **one** visual style:

- Custom designed  
- Minimalistic  
- Hand-crafted appearance  
- Vector graphics  
- Consistent stroke width  
- Scalable  
- Designed for light and dark mode  

Icons must live in / extend the **Falo Design System** (and Component Library when assets are catalogued) — not as one-off Bonsai World decorations.

#### Structure — future icon families

| Family | Represents |
|--------|------------|
| **Botanical Icons** | Genus |
| **Workflow Icons** | Bonsai activities |
| **System Icons** | Application navigation |

#### Future workflow

1. **Phase 1** — Trees use Botanical Icons as placeholders.  
2. **Phase 2** — Primary Tree images automatically replace Botanical Icons.

Fold detailed product rules into [PRODUCT_BLUEPRINT.md](../PRODUCT_BLUEPRINT.md) and shared Falo Design System / Component Library docs only when this idea is approved for build.

#### Implementation gate

Do **not** implement until all of the following are true:

1. Trees are complete.  
2. Reference Data is complete.  
3. Core modules are stable.  
