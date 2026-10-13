# Bonsai World — Roadmap

Lightweight direction only. Themes and priorities — **not** specifications and **not** a governing document.

Detailed implementation belongs in [PRODUCT_BLUEPRINT.md](PRODUCT_BLUEPRINT.md). Philosophy belongs in [BONSAI_CONSTITUTION.md](BONSAI_CONSTITUTION.md). Current maturity: [STATUS_REPORT_2026-09-12.md](STATUS_REPORT_2026-09-12.md).

---

## NOW

- Grower testing of the daily loop: Trees · Tasks · Locations · Collections · Photos · Dashboard  
- Decide next depth: Species ID-linking, Nursery kind depth, or Care intelligence honesty  
- Commit / backup the large uncommitted working tree when ready  
- Photo + measurement integrity was hardened 2026-09-12 — reopen only if a bug appears  

---

## NEXT

- ~~SpeciesProfile ↔ Reference Data ID link~~ (done — ``BotanicalKnowledgeIDs``)  
- CollectionService extraction from TreeService (after test backup; not a grower blocker)  
- Nursery depth decision (kind-specific fields vs explicit generic product)  
- Care Placement / Winter / etc.: honesty “tracking only” labels **shipped**; real engines still open  
- Experience packages: persist planning choices and optional sidebar gating  
- Release packaging groundwork (signed zip path; later Sparkle)  

---

## LATER

- Deeper Media (Search/Sort, mirror, docs/video playback, Tree linking)  
- Social beyond local preview (or park share-level collection)  
- Workshop / Calendar surfaces if still wanted  
- Platform layer extraction for pickers / image decode  
- Friend-testing update channel  

---

## SOMEDAY

- Cloud providers under Core (Blueprint storage Phases 2–4)  
- Complete-tier modules when approved  
- Optional licensing that may *enable* or *recommend* an Experience package — never forking the app or library schema  
- **Economy** — future analysis module for collection financial insight (not accounting). Aggregates Trees, Inventory, Propagation, and future Sales/Purchases; owns no master data; other modules must never depend on it. **Do not implement until** Trees, Reference Data, Inventory, and core bonsai workflows are stable. Details: [Idea Parking Lot — Economy](Project/00_Idea_Parking_Lot.md#idea-1--economy-module)  
- **Falo Botanical Icon Library** — custom Genus-mapped botanical icons (and later workflow / system families) for the Falo Design System; Trees use botanical icons as placeholders until a primary image exists. **Do not implement until** Trees, Reference Data, and core modules are stable. Details: [Idea Parking Lot — Botanical Icon Library](Project/00_Idea_Parking_Lot.md#idea-2--falo-botanical-icon-library)  
