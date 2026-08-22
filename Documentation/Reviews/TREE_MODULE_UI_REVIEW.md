# Trees Module — UI/UX Review

**Role:** Senior UX / Product Design review (read-only)  
**Scope:** Current Trees module implementation in Bonsai World (macOS)  
**Date:** 1 August 2026  
**Sources reviewed:** Product docs (START_HERE, Constitution, Product Blueprint), Falo Design System & Component Library, and existing Trees UI (`TreeListView`, `TreeDetailView`, `NewTreeView`, image/hero sections, toolbar, membership sheet, unused `TreeBrowserView`, app shell navigation).  
**Out of scope:** Code changes, new UI, persistence design.

`TREE_MODULE.md` was requested but is not present in the repository; this review uses the Product Blueprint Trees definition and the shipped implementation. Historical review under `Reviews/` — **not** a governing document. UI pattern truth now lives in Product Blueprint §6.

---

## Executive Summary

The Trees module already expresses the right **product spine**: sidebar → tree list → detail, with **View Mode by default**, **Edit Mode on demand**, and a clear rule that **botanical identity is permanent after create**. That aligns strongly with Falo’s Workflow First / Progressive Disclosure principles and with Bonsai World’s “user first / calm / clarity” constitution.

The experience is still **partial and desktop-form heavy**. A new grower can create and open a tree, but will hit empty Reference Data pickers, placeholder Search/Sort, disabled image/gallery actions, and a Save model that does not match how edits actually apply. Information hierarchy on Tree Detail leads with a raw Tree ID and repeats botanical data. A more capable Tree Browser (search, filters, sort) already exists in code but is not the primary Trees surface—so scale and findability lag behind what the product already knows how to do.

**Verdict:** Solid conceptual foundation; not yet a calm, complete care workflow. Prioritize discoverable find/search, honest empty states, a clearer Edit/Save mental model, and a human-first Detail hierarchy before expanding chrome.

---

## Strengths

1. **Clear primary path**  
   Workspace → Trees → select tree → Detail is familiar master/detail. Empty list offers a prominent **New Tree** action. Global Quick Action **New Tree** reinforces the same intention from anywhere.

2. **View / Edit separation**  
   Detail opens read-only. Edit is an explicit toolbar action. Botanical fields stay locked. This matches Falo progressive disclosure and the core product rule that botanical identity must not be casually rewritten.

3. **Visual identity first**  
   A large 16:9 hero above the form puts the tree’s image (or a calm empty state) ahead of metadata—appropriate for a visual craft like bonsai.

4. **Sectioned form structure**  
   General → Classification → Growing → History → Notes → Collections is a coherent care narrative: who it is → how it’s classified → where/how it grows → where it came from → notes → organization.

5. **Create vs Detail roles**  
   New Tree (sheet) is the only place Genus → Species → Cultivar are chosen. Detail never reopens botanical pickers. That is the correct long-term mental model.

6. **Falo shell alignment**  
   Sidebar groups (Workspace / Quick Actions / Tools), system materials, shared spacing/typography tokens, and native toolbar patterns feel at home on macOS and consistent with other Falo Worlds.

7. **Scale-aware code already drafted**  
   `TreeBrowserView` (search, location/collection/species filters, sort) shows the team anticipates large libraries—even though it is not yet the main list.

---

## Weaknesses

### Overall workflow

- **Create asks for too much, requires too little of what matters.** The New Tree sheet mirrors nearly the full Detail form. Location is required; Genus/Species are not. A user can save a tree without botanical identity—then Detail permanently locks an empty or weak botanical state. That conflicts with “botanical identity is sacred.”
- **Live edit + Save is confusing.** In Edit Mode, field changes write to the session immediately; **Save** mainly exits Edit Mode. Users expect Save to commit and Cancel to discard; today Cancel restores a snapshot, but Save’s meaning is weak. No “Editing” badge or dirty-state language explains the mode.
- **Dead actions erode trust.** Search, Sort, Duplicate, Export, Delete, Change Primary, View Gallery appear but do nothing (or are disabled). Falo asks for one primary action and progressive disclosure—showing unfinished chrome violates calm and predictability.
- **Sidebar Workspace lists many modules that are placeholders.** New users scanning for Trees compete with Projects, Journal, Gallery, Calendar, Tasks—noise before the first successful care loop.

### Navigation

- **Trees list lacks findability.** No working search, sort, or filter on the primary list. At even modest library size, scanning botanical names alone will fail.
- **Collection → Tree drill-in uses a custom “Collections” back control** instead of a consistent navigation pattern shared with Locations/other modules.
- **More Actions menu** always present with mostly disabled items—looks like a broken product, not a reserved future menu.

### Tree Detail

- **Tree ID (full UUID) leads General.** Engineer-centric, high cognitive load, violates Constitution “User First” and Falo “Minimal Cognitive Load.” Identity for humans is Botanical Name / Display Name / photo—not a UUID.
- **Botanical redundancy.** Botanical Name already encodes Genus / Species / Cultivar; listing all four without explanation feels like a database dump. Locked fields are correct; presentation is not yet story-like.
- **Display Name is secondary in View Mode** (after ID and full botanical stack) though it is often the grower’s everyday name for the tree.
- **Health vs Tree Status** may confuse without definitions (clinical health vs collection/workflow status).
- **Collections sit below the form** with different chrome than form sections—easy to miss; membership only in Edit Mode (good for safety, but View Mode should still make membership scannable and explain how to change it).

### Reference Data

- **Empty Lists produce empty pickers** (Style, Size Class, Soil, Light, etc. when Reference Data has no rows). Edit Mode offers controls that cannot succeed—no guidance to open Settings → Reference Data / Botanical Library.
- **No in-context explanation** that botanical fields are locked *because* they were set at creation (or how to fix a mistake later—delete/recreate is intentionally not shipped, so the gap is felt).
- **Species shown as epithet** in Detail while Botanical Name shows the full binomial—correct for experts, subtle for beginners without a short legend.

### Images

- **Gallery workflow is absent** while Gallery buttons are visible (disabled) in Edit Mode—promise without path.
- **List thumbnails are placeholders**, not the primary image—weakens recognition in the list vs Detail hero.
- **Add Image only after Edit**—reasonable, but View Mode empty hero gives no hint that Edit unlocks import.
- Image import is Finder-centric (macOS-native)—fine for ship-first Mac, but the UX concept is not yet abstracted for other platforms.

### Consistency (vs Falo / Locations)

- **Locations Detail** uses shared Detail header/summary/related components; **Trees Detail** is a long Form + hero. Same World, two Detail languages.
- Location editing is sheet-based; Tree editing is inline View/Edit. Both can work, but the World should teach one “how editing feels” pattern over time.
- Falo Forms principle: “ask only what is needed”—Create form currently asks for almost everything optional on day one.

### Scalability

| Library size | Fit today |
|--------------|-----------|
| **~5 trees** | Comfortable. List + Detail works; empty states OK. |
| **~500 trees** | Painful without search/sort/filter on the main list. Scroll fatigue; no grouping by genus/location. |
| **~5,000 trees** | Not viable as shipped. Needs indexed search, filters, virtualization discipline, and likely sectioned or browser-first UI (the unused Tree Browser is closer to that future). |

### Cross-platform translation

| Platform | Fit of current interaction model |
|----------|----------------------------------|
| **Windows** | Desktop three-column + toolbar can map well if Search/Edit patterns stay consistent. Avoid Mac-only chrome metaphors in copy (“Finder”). |
| **iPhone** | Three-column split does not translate. Need stack: List → Detail → Edit (or full-screen edit). Long Form will need accordion/progressive sections. Hero still works if shorter on small screens. |
| **Android** | Same as phone: list/detail stack, FAB or top app bar for New Tree/Edit. Sheet create becomes full-screen destination. |
| **Shared risk** | Image import, disabled menus, and UUID-first Detail are platform-agnostic UX debt; fixing them helps every client. |

---

## Recommended Improvements

### Quick Wins

1. **Hide or remove non-functional toolbar actions** until they work (Search, Sort placeholders; disabled Duplicate/Export/Delete; disabled Gallery/Change Primary). Prefer absence over disabled clutter.
2. **Reorder General:** Botanical Name → Display Name → (optional collapsed) Genus / Species / Cultivar → move Tree ID to a secondary “About” or debug-only area.
3. **Require Genus + Species on New Tree** (or block Save with a clear message)—protect permanent botanical identity at the moment it is set.
4. **Simplify New Tree** to essentials: botanical hierarchy, Location, optional Display Name; defer Style/Soil/History to Edit after create (Falo progressive disclosure).
5. **Edit Mode affordance:** subtle “Editing” title suffix or banner; rename Save to **Done** if edits already apply live—or buffer edits until Save for a true commit model.
6. **Empty Reference Data pickers:** show “None available — manage in Reference Data” instead of a blank menu.
7. **View Mode hero:** one quiet line—“Edit to add a photo”—when empty.
8. **Explain locked botanical fields** with a single help string (“Set when the tree was created and cannot be changed”).

### Long-term Improvements

1. **Promote Tree Browser (or merge its capabilities)** into the main Trees list: search, sort, location/collection/species filters, result counts.
2. **Unify Detail language** with Locations: human header (photo + botanical + display name + status chips), then grouped sections—Form for Edit Mode only.
3. **Real gallery workflow:** multi-image library, set primary, View Mode can open gallery read-only; Edit Mode manages membership.
4. **List thumbnails from primary image** for fast visual scanning.
5. **Guided create:** short wizard or stepped sheet—Identity → Place → Optional details—especially valuable on phone.
6. **Mistake recovery policy (product decision):** if botanical lock is absolute, document how users correct wrong Genus/Species (future recreate/clone workflow)—UX copy must match the rule.
7. **Mobile navigation model:** list → detail → edit as separate destinations; keep the same domain rules (lock botanical; View default).
8. **Sidebar progressive disclosure:** ship with fewer Workspace items visible, or group “Coming soon” modules so Trees/Collections/Locations dominate first-run.

---

## Priority

### Critical

| Item | Why |
|------|-----|
| Working **search / find** on the primary Trees surface | Without it, the module fails above small collections and blocks daily use. |
| **Honest UI**—remove or hide non-working actions | Disabled chrome trains users to ignore the product and violates Falo calm/trust. |
| **Protect botanical create**—require Genus + Species before Save | Permanent lock on empty/wrong identity is a lasting product injury. |
| **Fix Edit Save mental model** (Done vs buffered Save) | Unpredictable save behavior breaks Falo Predictability. |

### Important

| Item | Why |
|------|-----|
| Human-first Detail hierarchy (demote UUID; elevate names + photo) | Constitution User First; readability. |
| Empty Reference Data guidance in pickers | Edit Mode otherwise feels broken. |
| Simplify New Tree to essentials | Reduce cognitive load; match progressive disclosure. |
| Collection drill-in navigation consistency | Same World, same back/up patterns. |
| Clarify Health vs Tree Status (labels or grouping) | Avoid duplicate “status” concepts. |

### Future

| Item | Why |
|------|-----|
| Full gallery + primary selection | Completes the visual care loop. |
| List thumbnails from assets | Scales recognition at 500+ trees. |
| Shared Detail component language across modules | Cross-World / cross-module consistency. |
| Phone/Android stack navigation & stepped create | Cross-platform without major UX reinvention. |
| Documented botanical correction workflow | Completes the lock rule humanely. |
| Sidebar declutter / staged module exposure | First-run clarity. |

---

## Area Notes (condensed)

### Overall workflow

Understandable at “open Trees → pick a tree → Edit.” Weaker at “create correctly,” “find among many,” and “trust what buttons do.” Important actions **New Tree** and **Edit** are discoverable; **Search** and **Gallery** are not truly available despite appearing.

### Navigation

Sidebar map is clear but crowded. List → Detail works on Mac. Edit workflow is toolbar-driven (good). Image workflow is Edit-gated Add only. Collection return path is ad hoc.

### Tree Detail

Hierarchy starts too technical; grouping is sensible; section order is mostly right; visual balance favors hero + narrow form column (good reading width). Readability suffers from UUID and botanical repetition.

### Reference Data

Locked botanical fields: strong. Dropdowns: native and fine when data exists; poor when empty. View Mode: appropriately non-interactive. Edit Mode: unlocks the right *categories* of fields, but not always usable options.

### Images

Hero placement is a strength. Gallery is a gap. Actions over-promise. List does not yet participate in the visual system.

### Consistency with Falo Design System

Aligned: calm materials, sidebar structure, progressive View/Edit, sectioned forms, spacing tokens. Misaligned: unfinished actions visible, forms asking for everything, engineer-facing ID primacy, dual Detail patterns vs Locations, limited motion/feedback confirming Edit/Save.

### Scalability

Fine for a demo library; inadequate for a serious collection without browser-grade find tools on the main path.

### Cross-platform

Domain rules (View default, botanical lock, Location required) travel well. The **three-column Mac layout and long single-page form** will need platform-specific presentation—not a different product logic.

---

## Closing

The Trees module’s **interaction philosophy is ahead of its finish**. Keep View Mode, Edit Mode, and botanical permanence—they are the right product DNA. Strip unfinished chrome, fix create-time identity and Save semantics, humanize Detail hierarchy, and bring search to the primary list. That sequence turns a promising Mac inspector into a Falo-grade care surface that can later grow to Windows and mobile without rewriting what the grower already learned.
