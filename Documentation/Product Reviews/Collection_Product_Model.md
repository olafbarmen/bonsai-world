# Collection Product Model — Design Review

**Role:** Product design review (read-only)  
**Sprint:** 0.5  
**Date:** 22 August 2026  
**Sources:** START_HERE, Constitution, Product Blueprint, current Collection implementation, TREE_WORKFLOW_REVIEW, ROADMAP  
**Not reviewed:** Repository wiring, persistence format, or implementation quality beyond what it reveals about the product model.

This document answers the Sprint 0.5 questions about what a **Collection** is in Bonsai World — and what it must never become. It is **not** a governing document. If recommendations are approved, fold decisions into the Product Blueprint before implementation.

---

## Executive summary

A bonsai artist creates a **Collection** to hold a **named, intentional group of trees** for browsing, planning, and storytelling — without pretending those trees share a physical place. Collections are organizational lenses; Locations answer “where”; Tasks answer “what to do”; Filters answer “show me a slice right now.”

The current product model is **directionally correct** but **conceptually overloaded**: seed data treats “Favorite Trees” as a Collection, the domain already reserves Smart Collections inside the same type, Dashboard uses “Collection” to mean the whole library, and membership is stored on both Tree and Collection. The recommended model keeps **manual Collections** as first-class, durable groups; introduces **Saved Views** (not Collections) for rule-based and ad-hoc filtering; treats **Favorite** as a lightweight tree flag (with an optional pinned Collection shortcut); and gives Collections **optional manual ordering** for exhibition and study sets.

---

## 1. Why does a bonsai artist create a Collection?

Growers do not think in databases. They think in **projects of attention**:

| Grower intention | Example | What Collection provides |
|------------------|---------|---------------------------|
| **Study a theme** | “All my maples” | A stable group to revisit across seasons |
| **Plan an event** | “Exhibition 2027 candidates” | A working set that may change membership over months |
| **Cross-place grouping** | “Trees I’m proud of” spanning benches | Organization that **does not** imply shared Location |
| **Share a narrative** | “Shohin display set” | A named bundle others (or future you) can understand |
| **Reduce noise** | “Material I’m actively developing” | Fewer trees in view when planning work |

Collections exist because **Location is physical and singular** (one bench per tree) while **care and planning are thematic and overlapping** (a tree can be maple, favorite, and exhibition-bound at once).

Constitution and Blueprint already state this: Collections **orbit Trees**; they never determine where a tree lives. A Collection is a **durable bookmark into the library**, not a care obligation and not a search query.

---

## 2. Collection vs Filter vs Task vs Favorite

These four concepts solve different problems. Conflating them creates duplicate UI, confused Dashboard language, and “smart collections” that are really filters wearing a name badge.

| Concept | User question | Nature | Mutability | Typical lifetime |
|---------|---------------|--------|------------|------------------|
| **Collection** | “Which trees belong to *this group I named*?” | **Curated membership** — intentional inclusion/exclusion | Manual add/remove; membership is **stored** | Months to years (“Maples”, “Exhibition 2027”) |
| **Filter** | “Show me trees that match *these criteria right now*.” | **Ephemeral view** over the library | Changes when tree data changes; **not stored membership** | Session or until cleared |
| **Task** | “What work must I *do* for these trees?” | **Action with completion state** | Open → done; may have due date | Days to weeks |
| **Favorite** | “Which trees do I *reach for most*?” | **Personal prominence signal** on a Tree | Toggle on/off; ideally **one boolean or pin**, not a parallel group system | Until taste changes |

### Collection

- **Purpose:** Browse and plan around a **named set**.
- **Blueprint fit:** Garden → Collections module; many-to-many with Trees.
- **Current examples:** Maples, Exhibition 2027.
- **Not for:** Watering lists, overdue repots, or “all junipers” unless the grower **chooses** to maintain that set manually.

### Filter

- **Purpose:** Narrow any list (Trees, Map, Dashboard drill-down) without creating records.
- **Examples:** Location = Bench A; Species contains *Acer*; Health = Needs attention; Collection = Maples (when used as filter on Trees list or Map).
- **Already anticipated:** Locations map layer `collectionFilter`; TREE_WORKFLOW_REVIEW recommends Location / Collection / botanical filters on the main Trees path.
- **Key rule:** Applying a filter **must not** change membership. Clearing the filter restores the full list.

### Task

- **Purpose:** Actionable care work with status (Blueprint §5.9).
- **Examples:** “Repot Deshojo”, “Wire pines before bud break”.
- **Links to Trees** but owns **completion**, not grouping for browsing.
- **Anti-pattern:** A Collection named “Trees to repot this week” — that is a **Task list** or Dashboard care card, not a Collection. Tasks may **reference** a Collection (“Repot all Exhibition candidates”) but should not **be** Collections.

### Favorite

- **Purpose:** Fast personal access — “my best trees”, “daily walk-around set”.
- **Current tension:** Seed data includes **Favorite Trees** as a manual Collection. That works as a demo but blurs **prominence** (favorite) with **taxonomy** (Maples).
- **Recommended split:**
  - **Tree.isFavorite** (or equivalent single flag) for one-tap star/unstar from Tree Detail or list.
  - **Optional:** A system or user-pinned “Favorites” Saved View (“show trees where favorite = true”) — not a manually synced duplicate list unless the grower explicitly wants curation beyond the flag.

**One concept = one name** (Blueprint §10.3): Dashboard “Collection Summary” (whole library stats) is **inventory overview**, not the Collections module. Future copy should distinguish **“Your trees”** / **“Library overview”** from **“Collections”** (named groups).

---

## 3. Should Smart Collections be Collections or Saved Views?

**Recommendation: Smart Collections should be Saved Views, not Collections.**

### Why not Smart Collections as Collections?

| Issue | Explanation |
|-------|-------------|
| **Different mental model** | A Collection is “I chose these trees.” A smart set is “Show me trees matching rules.” |
| **Membership ambiguity** | If rules auto-add trees, can the user remove one? If yes, you need exceptions — complexity. If no, it behaves like a filter with a misleading name. |
| **Duplicate concepts** | Species = Maple is both a filter and a “Maples” smart collection — two homes for one idea. |
| **Dashboard / Assistant confusion** | Care signals (“needs watering”) must stay dynamic. Naming them Collections implies curation. |

### Saved Views (recommended)

A **Saved View** is a **stored filter + sort (+ optional layout)** over Trees:

- **Examples:** “All maples”, “Shohin”, “Trees without primary photo”, “Exhibition candidates (status = In Development AND style = …)”.
- **Behavior:** Membership **recomputed** when library changes.
- **UI home:** Trees list filter bar → “Save view…”; optional sidebar section “Saved Views” under Garden → Trees (not a peer of Collections in the grower’s mind — or grouped under “Browse” with clear labeling).
- **Presentation:** Distinct iconography and copy (“Saved View”, “Updates automatically”) so they are never mistaken for manual groups.

### Relationship to manual Collections

| Need | Use |
|------|-----|
| Stable exhibition shortlist with manual tweaks | **Manual Collection** |
| Live “all maples” as species are added | **Saved View** |
| “Exhibition candidates” that mix rules + hand-picks | **Future: Collection with optional rule *suggestions*** — rules propose adds; user confirms. Defer until manual Collections feel effortless (TREE_WORKFLOW_REVIEW, Blueprint “Future Expansion”). |

### Current model note

`CollectionType.smart` and `SmartCollectionDefinition` in the domain anticipate smart behavior **inside Collection**. Product-wise, that path risks the overload above. **If** the type enum remains for technical migration, product language should treat `.smart` as **deprecated in favor of Saved Views**, or rename at Blueprint approval time.

---

## 4. Should Collection own Tree membership?

**Recommendation: Yes — Collection owns membership; Tree exposes a derived or synced view for convenience only.**

### Product truth

- The grower’s act is: **“Add this tree to *Maples*”** — the Collection is the named container.
- Tree Detail should show **which Collections include this tree** (read-only in View Mode; editable in Edit Mode) — that is **membership visibility**, not a second source of truth.

### Current model

- **Dual storage:** `Collection.treeIDs` and `Tree.collectionIDs`, kept in sync in session logic.
- **TreeService** resolves members via `Tree.collectionIDs` (`trees(inCollection:)`).
- **Risk:** Two lists can diverge; growers never see IDs, but wrong counts and “ghost membership” erode trust.

### Authoritative model (product)

```text
Authoritative:  Collection.treeIDs  (ordered for manual collections)
Derived:        Tree.collectionIDs  (computed on read, or cached sync on write — invisible to UI)
```

**Operations:**

| Action | Product behavior |
|--------|------------------|
| Add tree to Collection | Collection gains ID; Tree Detail shows new membership |
| Remove tree from Collection | Collection loses ID; Tree Detail updates |
| Delete Collection | Membership gone; Trees unchanged except losing that link |
| Delete Tree | Remove tree ID from all Collections |

**Never** ask the grower to maintain membership in two places. Tree-side “Add to Collection” and Collection-side “Add Tree” are **two entry points to the same operation** (Blueprint workflow alignment).

---

## 5. Should Collections support custom ordering of Trees?

**Recommendation: Yes for manual Collections — optional, with sensible defaults.**

### Why ordering matters

| Use case | Why order matters |
|----------|-------------------|
| **Exhibition set** | Display order on a tokonoma or bench row |
| **Teaching set** | “Compare these three maples” — sequence is intentional |
| **Portfolio / photo session** | Shoot order planned in advance |

### Why not require it

- **Study groups** (Maples) often sort by name, species, or recent activity — default sort is enough.
- Forcing order on every Collection adds friction at create time.

### Recommended behavior

| Collection kind | Default order | Custom order |
|-----------------|---------------|--------------|
| **Manual Collection** | Name or recently updated (user preference) | **Optional** “Custom order” mode: drag in Collection Detail member list |
| **Saved View** | Defined by saved sort | N/A — order comes from rules |

**Progressive disclosure:** Order editing appears in Collection Detail when members exist — not in New Collection sheet (matches current create flow: metadata only, empty membership).

**Scope limit:** Custom order is **per Collection**, not global Tree rank. Trees module keeps its own sort; Collection Detail uses collection order when viewing that group.

---

## 6. Dashboard and Bonsai Assistant integration

### Dashboard

**Principle:** Dashboard **orients**; it does **not** edit Collections (Blueprint §5.1).

| Surface | Current state | Recommended integration |
|---------|---------------|-------------------------|
| **Collection Summary hero** | Placeholder library totals (“150 Trees”, species breakdown) | Rename conceptually to **Library overview** or **Garden at a glance** — whole-library aggregates, not named Collections |
| **Collection Overview card** | Placeholder groups | Show **pinned Collections** (user chooses 2–3) with member counts + deep link to Collection Detail |
| **Today’s Care / Alerts** | Placeholder | Link to **Tasks** or filtered Trees — **not** Collections |
| **Drill-down** | Not wired | Tap hero metric → Trees with **filter applied** (Saved View), not a new Collection |

**Pinned Collections:** Optional Dashboard preference — “Show Maples, Exhibition 2027 on Dashboard.” Distinct from Favorite trees.

**Anti-patterns:**

- Auto-creating Collections from Dashboard cards (“Critical tasks” collection).
- Using Collection count as care workload (that is Tasks / Care module).

### Bonsai Assistant

**Status:** Architectural concept (Idea Parking Lot — Environmental Engine, Assistant). No shipped Assistant UI.

Collections should inform the Assistant as **context scopes**, not as action queues:

| Assistant use | How Collections participate |
|---------------|----------------------------|
| **“How should I prepare my exhibition trees?”** | Scope = Collection “Exhibition 2027” → Assistant reads member trees, species, season |
| **“What maples need repotting?”** | Prefer **Saved View** (maples) + **Task/repot signals** — not a static Collection unless user maintains one |
| **Proactive nudges** | Assistant references **Tasks, Calendar, Care** — may mention “3 trees in Exhibition 2027” as context, not create Collections |

**Rules for Assistant:**

1. **Never mutate Collection membership** without explicit user confirmation.
2. **Suggest** Saved Views or Tasks before suggesting new manual Collections.
3. Treat **Favorite** as quick personal scope (“your starred trees”).
4. Distinguish **library-wide** stats from **named groups** in natural language.

---

## Current model

### Product definition (Blueprint)

- **Collection:** User-defined organizational group; many-to-many with Trees; **never** sets Location.
- **Module:** Garden → Collections (Version 2 navigation); list → detail → member trees → open Tree Detail.
- **Primary workflow:** Browse collections → open detail → scan members → act on a Tree elsewhere (Trees module).
- **Future (Blueprint):** Smart/rule-based collections without changing manual membership architecture.

### Domain shape (implementation reflects intent)

| Field / concept | Role |
|-----------------|------|
| `name`, `description` | Human identity |
| `icon`, `color` | Visual differentiation in lists and future Dashboard pins |
| `type` | `.manual` (all today) / `.smart` (reserved, unused in UI) |
| `treeIDs` | Manual membership list |
| `smartDefinition` | Placeholder rules/sort/grouping for future smart behavior |
| `Tree.collectionIDs` | Reverse membership link on Tree |

### UI / workflows shipped (partial)

| Capability | Status |
|------------|--------|
| Collections list with member counts | Shipped |
| Collection Detail (summary, member list, open Tree) | Shipped |
| New Collection (name, description, icon, color; empty membership) | Shipped |
| Add Tree to Collection (from Collection Detail) | Shipped |
| Tree Edit → Collection membership sheet | Shipped (draft until Save) |
| Collection Edit / Rename | Hidden / not shipped |
| Smart Collection UI | Not shipped |
| Custom member order | Not present |
| View Mode membership visibility on Tree Detail | Partial / easy to miss (TREE_WORKFLOW_REVIEW) |
| Dashboard live Collection data | Not wired — placeholders only |
| Map Collection filter | Partial — filter layer exists on Locations |

### Seed data semantics

Three preview Collections illustrate intended use:

1. **Maples** — taxonomic / study group  
2. **Favorite Trees** — prominence (currently modeled as manual Collection)  
3. **Exhibition 2027** — time-bound planning set  

### Service boundary

Collections are accessed through **TreeService** today (no dedicated CollectionService). Features never talk to storage directly — consistent with Blueprint direction, but Collections lack a module-owned service facade.

---

## Weaknesses

### Conceptual

1. **Favorite as Collection** — Teaches growers to maintain a duplicate list instead of starring trees.  
2. **Smart type inside Collection** — Invites rule-based and manual groups to share one noun before manual grouping is mature.  
3. **“Collection” overload on Dashboard** — Hero card means *entire library*; module means *named group*; growers may hear “collection” three ways.  
4. **Filter vs Collection blur** — Map “Collection Filter” is correct technically; product must keep “filtering by collection” distinct from “editing membership.”

### Workflow

5. **Membership visibility** — Edit path exists; View Mode should clearly show groups (TREE_WORKFLOW_REVIEW).  
6. **Asymmetric editing** — Can add trees to Collection; rename/edit Collection metadata not shipped; two entry points not yet equal.  
7. **No custom order** — Exhibition workflow will eventually need it.  
8. **Create vs enrich** — New Collection is appropriately light; adding many trees is multi-step (Add Tree sheet) — acceptable for v1, heavy for large sets.

### Model integrity

9. **Dual membership** — Two stored lists (`treeIDs` / `collectionIDs`) — product risk when counts disagree.  
10. **Collections secondary in Tree Detail** — Long form fields dominate; organizational identity feels buried.  
11. **No Saved Views** — Growers will recreate “Maples” as both Collection and (future) filter; need clear product split before Smart Collections ship.

### Integration

12. **Dashboard disconnected** — Placeholders do not validate Collection value proposition.  
13. **Assistant undefined** — No scoping rules yet; risk of Assistant inventing groups or conflating care queues with Collections.  
14. **Projects (future)** — Blueprint lists Projects for structured care efforts; boundary with “Exhibition 2027” Collection must be defined (Collection = *which trees*; Project = *structured effort over time* with tasks/journal).

---

## Alternative models

### A. Collections only (status quo + smart collections)

Everything is a Collection: favorites, rules, exhibition sets, care buckets.

| Pros | Cons |
|------|------|
| One module, one list | Filters and tasks leak into Collections |
| Matches current `CollectionType` enum | “Favorite Trees” needs manual sync |
| Simple navigation | Smart membership exceptions get painful |

**Verdict:** Reject as long-term model. Acceptable only as incremental shipping if Smart behavior is deferred.

### B. Tags instead of Collections

Trees carry many free-form tags; no Collection entity.

| Pros | Cons |
|------|------|
| Flexible, familiar | No named container detail page |
| Easy favorite + species tags | Exhibition order, icons, descriptions weak |
| | Conflicts with Blueprint module structure |

**Verdict:** Reject — violates established Blueprint module and grower language (“my exhibition set” is a *thing*, not a tag cloud).

### C. Collections + Saved Views + Favorite flag (recommended)

Manual Collections for curated sets; Saved Views for rules; Favorite for prominence; Filters ephemeral; Tasks for work.

| Pros | Cons |
|------|------|
| Clear mental models | Two browse constructs (Collection vs Saved View) need careful UX |
| Aligns with Dashboard, Map, Assistant | Requires Blueprint update and migration of smart placeholders |
| Scales to large libraries | Slightly more to learn upfront — mitigated by progressive disclosure |

**Verdict:** Adopt.

### D. Location-derived groups

Infer groups from Location only; no Collections.

| Pros | Cons |
|------|------|
| Physically grounded | Cannot group across benches |
| | Breaks exhibition/favorites/species study |

**Verdict:** Reject — contradicts Blueprint organizational layer.

---

## Recommended product model

### Core definition

> **A Collection is a named, user-curated set of trees for browsing and planning. It does not imply shared location, care schedule, or completion state.**

### Entity summary

| Entity | Owns | Does not own |
|--------|------|--------------|
| **Collection** | Name, description, icon, color, **ordered** `treeIDs` (manual) | Location, task state, filter rules (except future optional suggestions) |
| **Saved View** | Name, filter rules, sort, optional layout | Stored manual membership (computed) |
| **Filter** | Nothing persisted | — |
| **Favorite** | Boolean (or pin) on Tree | Group semantics |
| **Task** | Work, due date, completion | Browse grouping |

### Types (product language)

1. **Manual Collection** — only shipped type at Essential tier.  
2. **Saved View** — Advanced / when Smart Collections would have shipped; replaces “Smart Collection” in user-facing copy.  
3. **System Saved Views** (optional later) — “All trees”, “Favorites”, “Recently updated” — not Collections.

### Membership

- **Collection owns `treeIDs`.**
- Tree shows membership; edits go through Collection service operations whether initiated from Tree or Collection Detail.
- **Add/remove idempotent**; duplicate membership impossible.

### Ordering

- Manual Collections: default sort + optional custom order in Detail.
- Saved Views: sort defined in view definition.

### Favorites

- Introduce **Tree favorite flag** (product decision — Blueprint update).
- Deprecate **Favorite Trees** as a required seed pattern; optional migration: favorite flag = true for former members, Collection removed or kept as user choice.

### Dashboard

- **Library overview** card — whole-garden counts (trees, species, status buckets).
- **Pinned Collections** — user-selected named groups with deep links.
- Care cards → Tasks / filtered Trees, not Collections.

### Assistant

- Collections as **optional conversation scope**.
- Suggestions favor Tasks and Saved Views for dynamic care questions.
- No silent membership changes.

### Projects (future boundary)

| Collection | Project |
|------------|---------|
| Which trees belong together | Structured effort over a period |
| Browse/plan set | Tasks, journal entries, milestones |
| “Exhibition 2027 trees” | “Prepare Exhibition 2027” (work plan) |

A Project may **reference** one or more Collections; it does not replace them.

---

## Consequences for future development

### Blueprint and documentation

1. **Update Product Blueprint §5.4** when approved: define Saved Views, Favorite flag, pinned Dashboard Collections, and rename Dashboard “Collection Summary” language.  
2. **Clarify Projects vs Collections** before Projects module template ships.  
3. **Do not implement** from this review directly — promote decisions through normal workflow (discuss → document → approve → implement).

### Collections module (next implementation waves)

4. **CollectionService** (or equivalent) as module facade — TreeService should not remain the long-term owner of Collection CRUD.  
5. **View Mode membership** on Tree Detail — high priority for product clarity.  
6. **Collection Edit** (rename, description, icon, color) — completes View/Edit pattern.  
7. **Custom member ordering** — when Exhibition / Design workflows need it.  
8. **Defer Saved Views** until manual Collections and Trees filters feel effortless (ROADMAP / workflow review alignment).

### Trees module

9. **Lightweight filters** on Trees list (Location, Collection, species) — filters, not new Collections.  
10. **Favorite toggle** — one action, one place (Quick Actions context when tree selected).  
11. **Search** — must not duplicate Collection browse; search finds trees; Collections organize them.

### Dashboard

12. Wire **Library overview** from Tree aggregates.  
13. Add **pinned Collections** preference — read-only, deep link to Garden → Collections.  
14. Avoid auto-creating Collections from care metrics.

### Domain evolution

15. **`CollectionType.smart`** — either migrate to Saved View model at Blueprint approval or keep internal-only with zero user-facing “Smart Collection” until Saved Views ship.  
16. **Single membership authority** — product requires one truth; implementation should converge without changing grower-visible behavior.  
17. **Map layer** — keep “Collection filter” as **filter** language in UI (“Show: Maples collection”).

### Bonsai Assistant (when scoped)

18. Define **scope picker**: Whole library | Collection | Saved View | Favorites | Selected trees.  
19. Assistant responses cite **group name** vs **filter description** correctly in natural language.  
20. Environmental / care recommendations pull **Tasks + tree state**, not Collection membership alone.

### Testing the model (product acceptance)

| Scenario | Expected outcome |
|----------|------------------|
| User adds tree to Exhibition collection from Tree Edit | Collection Detail and Tree View both show membership |
| User filters Trees to Maples | Filter clears without changing Maples membership |
| User stars a tree | Appears in Favorites view; no manual Collection sync required |
| User asks Assistant about exhibition prep | Scoped to Exhibition Collection trees; suggests Tasks, not new Collections |
| User deletes Collection | Trees remain; only group disappears |

---

## Sprint 0.5 question checklist

| # | Question | Answer |
|---|----------|--------|
| 1 | Why create a Collection? | To name and curate a stable cross-place group for study, planning, and storytelling — not for physical placement or care completion. |
| 2 | Collection vs Filter / Task / Favorite? | Collection = curated stored group; Filter = ephemeral slice; Task = actionable work; Favorite = personal prominence on a tree. |
| 3 | Smart Collections or Saved Views? | **Saved Views** — rule-based, recomputed; not manual Collections. |
| 4 | Should Collection own membership? | **Yes** — authoritative `treeIDs`; Tree shows membership only. |
| 5 | Custom ordering? | **Yes**, optional for manual Collections; default sort otherwise. |
| 6 | Dashboard & Assistant? | Dashboard: library overview + pinned Collections (read-only); care via Tasks/filters. Assistant: Collections as optional scope; no silent membership edits; favor Tasks/Saved Views for dynamic care. |

---

## Closing

Collections are **organizational companions to Trees**, not a second location system, not a task list, and not a substitute for search. The current implementation and Blueprint foundation support that vision. The main product debt is **noun overload** (favorite, smart rules, library totals, and curated groups all called “collection”) and **dual membership** under the hood.

Splitting **Manual Collections**, **Saved Views**, **Filters**, **Tasks**, and **Favorites** into distinct grower concepts — while keeping one calm Collections module for curated groups — preserves Constitution principles (Trees at the center, workflow before features, one concept one name) and scales from a dozen trees to thousands without turning organization into administration.

---

*This review recommends product direction only. Implementation, persistence, and Blueprint updates require explicit approval through the normal governing workflow.*
