# Trees Module — Workflow Review

**Role:** Product Owner · UX Designer · Bonsai enthusiast (read-only)  
**Scope:** End-to-end Trees workflows as experienced by a grower  
**Date:** 1 August 2026  
**Sources:** START_HERE, Constitution, Product Blueprint, Falo Design System, Changelog / product status.  
**Not reviewed:** Source code, implementation quality, persistence engines.

`TREE_MODULE.md` was requested but is not present. This review uses the Blueprint Trees definition, Constitution principles, and documented shipped / partial behavior.

**Note:** Later documentation consolidation folded Product Principles into the Constitution and UI patterns into the Blueprint. This review is historical and **not** a governing document.

This document answers: *How does a bonsai enthusiast actually work through Trees today — and where does the path fight how growers think?*

---

## Executive Summary

Trees already carries the right **care DNA**: the tree is the center; Detail opens safely in View Mode; botanical identity is permanent after create; actions are consolidating into Quick Actions; Location (where it lives) is distinct from Collection (how I group it).

What is missing is not another panel — it is **complete, honest workflows**. A grower who thinks in “I got a new tree,” “where did I put the maples,” “show me this tree’s photo,” or “move that juniper to the shade bench” still meets form-shaped create, unfinished Search / Gallery / Import, and gaps between intention and outcome.

**Verdict:** The product philosophy is ahead of the journey. Protect what is already right (safe View, locked botanical identity, one-action direction). Close the everyday loops — create cleanly, find quickly, place and group without confusion, photograph without friction — before adding more chrome. Anything that still feels like filling a database record instead of caring for a tree should be redesigned as a workflow.

---

## Review lens

For each journey below:

| Question | Focus |
|----------|--------|
| Intuitive? | Does the next step feel obvious without training? |
| Enthusiast expectation? | Would a grower expect this path in a serious collection app? |
| Simplifiable? | Can steps or decisions be removed? |
| Click budget? | Is effort proportional to the job? |
| Complexity hidden? | Does Essential-level work stay calm? |

Judged against the **Constitution** (workflow before features, one action one place, safe by default, Reference Data as master data, Trees at the heart, progressive complexity) and Blueprint UI patterns.

---

## Workflow-by-workflow evaluation

### 1. Creating a Tree

**Grower intention:** “I have a new tree. Put it in my world.”

| Question | Assessment |
|----------|------------|
| Intuitive? | Partially. New Tree from Quick Actions is the right entry. The sheet then asks for nearly a full inventory form (classification, growing, history, notes) on day one. |
| Enthusiast expectation? | Growers expect: what is it (botanical), what do I call it, where does it sit, maybe a photo. Not every soil/style/source field before the tree “exists.” |
| Simplifiable? | Yes. Identity → Place → optional Display Name (and optional photo) first; defer style, soil, history to Edit after create. |
| Clicks? | Higher than needed for “register this tree.” Too many optional decisions before Save. |
| Complexity hidden? | No. Create mirrors the Detail schema — classic **database structure before workflow**. |

**Principles:** Violates Progressive Complexity and Workflow before Features when Genus/Species can be weak or empty while Location is required — then botanical lock makes a thin identity permanent. Safe by Default is incomplete at create time.

**Recommendation:** Require Genus + Species before Save. Shorten New Tree to essentials. Treat optional growing/history as post-create enrichment.

---

### 2. Viewing a Tree

**Grower intention:** “Show me this tree — who it is, how it looks, where it lives.”

| Question | Assessment |
|----------|------------|
| Intuitive? | Yes for the spine: Trees → select → Detail. Hero image first is right for bonsai. |
| Enthusiast expectation? | Expect botanical name, everyday name, photo, location, status — not a UUID-led “General” block or repeated botanical fields that feel like a schema dump. |
| Simplifiable? | Yes. Lead with photo + human names + place; demote technical identity. |
| Clicks? | List → Detail is a reasonable two-step for browse. |
| Complexity hidden? | View Mode correctly hides editing controls — strong Safe by Default. Presentation still shows engineer-shaped fields. |

**Principles:** Safe by Default is a strength. Beautiful Through Simplicity and User First still need a human hierarchy on Detail.

**Recommendation:** Keep View Mode. Reorder identity for humans. Make membership and location scannable without entering Edit.

---

### 3. Editing a Tree

**Grower intention:** “Update status, notes, growing conditions — carefully.”

| Question | Assessment |
|----------|------------|
| Intuitive? | Direction is right: Edit is intentional; Save / Cancel / Reset live in context Quick Actions. |
| Enthusiast expectation? | Expect Edit → change → Save commits / Cancel discards. Locked botanical fields match “species doesn’t casually change.” |
| Simplifiable? | Mode switch is fine; ensure language matches the draft model (Editing / dirty state). |
| Clicks? | Select tree → Edit Tree → change → Save is acceptable for serious records. |
| Complexity hidden? | Botanical lock hides dangerous edits well. Empty Reference Data pickers still expose unusable complexity. |

**Principles:** Aligns with Safe by Default and One Action – One Location (Edit in Quick Actions). Predictability depends on Save/Cancel meaning exactly what growers expect.

**Recommendation:** Keep draft → Save / Cancel. Clarify Editing state. Guide empty pickers to Reference Data. Never re-open botanical identity inline.

---

### 4. Adding Images

**Grower intention:** “Photograph this tree / attach the shot I just took.”

| Question | Assessment |
|----------|------------|
| Intuitive? | Partially. Add Image as a tree-context Quick Action matches how growers think. Gallery / Change Primary remain incomplete while visible or promised. |
| Enthusiast expectation? | Expect: add photo from the tree; see it on the tree; later browse many photos over seasons. Not “edit mode as a tax” without explanation, and not disabled Gallery forever. |
| Simplifiable? | Primary photo should be a short path from the selected tree. Multi-image gallery can wait as progressive depth. |
| Clicks? | Select → Add Image → pick file is reasonable on Mac. Extra Edit gate without guidance feels like friction. |
| Complexity hidden? | Hero empty state should teach the next step. Unfinished Gallery actions hide nothing — they advertise unfinished product. |

**Principles:** Trees at the Heart (visual memory belongs on the Tree). Beautiful Through Simplicity: hide Gallery until it works. Cross Platform First: “Finder” language is Mac-only in spirit.

**Recommendation:** Make primary image the complete Essential workflow. Hide View Gallery until it works. Teach empty hero quietly. Keep import behind platform adapters without Mac-only product language.

---

### 5. Assigning Locations

**Grower intention:** “This tree lives on the shade bench / cold frame / indoor shelf.”

| Question | Assessment |
|----------|------------|
| Intuitive? | Conceptually yes when Location means a physical place. Confusion appears if reference “location-like” vocabulary and physical Locations blur. |
| Enthusiast expectation? | Every tree has exactly one place. Moving a tree means changing that place — a common care act, not a rare admin chore. |
| Simplifiable? | Choosing place at create is correct. Changing place should feel like “move,” not hunting a foreign-key field in a long form. |
| Clicks? | Create-time location is one decision (good). Relocate via Edit → Location picker is acceptable short-term; a dedicated Move action would match language better later. |
| Complexity hidden? | Physical vs organizational distinction in the Blueprint is correct — the UI must keep teaching it. |

**Principles:** Workflow before Features — “where does it live?” is a grower sentence. Reference Data / Locations as master data: pickers must consume the same Locations truth.

**Recommendation:** Keep one Location per tree. Prefer grower language (“Location” / later “Move”) over ID-shaped presentation. Ensure Locations module and Tree Edit stay one source of place truth.

---

### 6. Assigning Collections

**Grower intention:** “Put this in Maples / Exhibition / Favorites.”

| Question | Assessment |
|----------|------------|
| Intuitive? | Membership from Tree Detail matches “this tree belongs in…” Collections never set Location — that rule matches how growers organize (groups ≠ benches). |
| Enthusiast expectation? | Membership is many groups, optional. Expect to see membership while viewing; change it intentionally. Drill-in from Collection → Tree is natural. |
| Simplifiable? | Avoid dual edit paths (Tree side and Collection side) that diverge. One clear mental model: membership can be managed from either side later, but with the same rules. |
| Clicks? | Edit → Add to Collection sheet is a bit heavy for “tag this as Favorite,” but safe. View Mode should still show which collections apply. |
| Complexity hidden? | Collections below the form can be easy to miss — organizational work feels secondary to field dump. |

**Principles:** Trees at the Heart; Collections orbit. One Action – One Location: don’t invent a second New Tree path from Collections. Progressive Complexity: smart collections stay Future.

**Recommendation:** Keep manual membership. Make membership visible in View Mode. Align Collection ↔ Tree navigation. Defer smart rules.

---

### 7. Searching

**Grower intention:** “Find my Pinus / the tree I call ‘Dragon’ / anything on the top shelf.”

| Question | Assessment |
|----------|------------|
| Intuitive? | Search appears in Global Quick Actions but is not a finished workflow — intention without outcome. |
| Enthusiast expectation? | Search is table stakes above a handful of trees. Growers search names, species, sometimes place. |
| Simplifiable? | One Search entry (Quick Actions) is correct — don’t also scatter search fields. Make that one entry work. |
| Clicks? | Today: click Search → nothing useful. Worst click budget: effort with no result. |
| Complexity hidden? | Showing Search before it works *increases* complexity and destroys trust. |

**Principles:** Violates Workflow before Features, One Action – One Location (action present without path), Beautiful Through Simplicity, and Trees at the Heart (you cannot care for what you cannot find).

**Recommendation:** Critical — either ship working find on the primary Trees surface or hide Search until it does. Prefer botanical name, display name, and later location/species.

---

### 8. Filtering

**Grower intention:** “Show only maples / only outdoor / only exhibition candidates.”

| Question | Assessment |
|----------|------------|
| Intuitive? | Not available on the primary list journey. A richer browser exists as reserved capability, not the daily path. |
| Enthusiast expectation? | Filters by location, species/genus, collection, and status are how large collections are managed. |
| Simplifiable? | Start with 2–3 Essential filters (Location, Collection, botanical), not a full query builder. |
| Clicks? | Filter chips or a simple filter bar beats deep multi-panel tooling for daily use. |
| Complexity hidden? | Correct to keep advanced browser later — wrong to leave growers with scroll-only browsing as libraries grow. |

**Principles:** Progressive Complexity — Essential gets simple filters; Advanced/Complete can deepen. Workflow before Features — filter by how growers group work, not by every column.

**Recommendation:** Important — bring lightweight filter/sort onto the main Trees path. Keep heavy browser as progressive depth, not a parallel product.

---

### 9. Moving Trees

**Grower intention:** “I moved it to the other bench / indoors for winter.”

| Question | Assessment |
|----------|------------|
| Intuitive? | No dedicated Move workflow. Relocation is “edit the Location field.” Accurate in data terms; weak in care language. |
| Enthusiast expectation? | Moving trees is seasonal and frequent. Growers say “move,” not “update locationID.” |
| Simplifiable? | Short term: Edit → change Location → Save is enough if labeled clearly. Medium term: context action **Move Tree** that only asks for the new place. |
| Clicks? | Full Edit Mode for a single place change is more ceremony than the job deserves. |
| Complexity hidden? | Forcing full Edit for a move exposes unrelated fields — complexity not hidden. |

**Principles:** Workflow before Features — seasonal move is a first-class care workflow. One Action – One Location — one Move action, not Move in three menus.

**Recommendation:** Structural — introduce Move as a focused workflow (or a single-purpose sheet) once Edit is stable. Still writes the same one Location; only the path changes.

---

### 10. Future growth

**Grower intention over years:** Journal seasons, gallery timelines, tasks/calendar care, propagation into trees, exhibition sets — always around the same tree.

| Question | Assessment |
|----------|------------|
| Intuitive? | Sidebar already names future modules; they don’t yet complete loops from the Tree. Risk: grower thinks the World is broken rather than incomplete. |
| Enthusiast expectation? | The tree page becomes the hub: photos over time, notes, work done, where it lived. |
| Simplifiable? | Hide or stage unfinished modules (Workspace Profiles / Coming soon) so Essential stays Trees, Locations, Collections, Gallery, Journal path when ready. |
| Clicks? | Future depth should open from the Tree without re-navigating the whole World for every related fact. |
| Complexity hidden? | Profiles (Essential / Advanced / Complete) are the right philosophy — not yet felt in the shell. |

**Principles:** Progressive Complexity and Trees at the Heart. Cross Platform First — journeys must stay the same on phone (stack) even if chrome differs.

**Recommendation:** Future — Tree as hub for related Gallery / Journal / Tasks when those modules ship. Profiles control visibility. Do not invent parallel “tree databases” inside other modules.

---

## Workflow Strengths

1. **Correct care spine** — Workspace → Trees → Detail matches how people browse a collection.  
2. **Safe by Default** — View Mode first; Edit is intentional; botanical identity does not casually rewrite.  
3. **Create is the botanical gate** — Genus → Species → Cultivar belongs at create; Detail lock matches permanence growers understand (“that’s a Japanese maple”).  
4. **Quick Actions as the action home** — New Tree, Edit, Add Image, Save/Cancel direction aligns with One Action – One Location.  
5. **Location ≠ Collection** — Physical place vs organizational group matches real benches vs “favorites / exhibition.”  
6. **Visual-first Detail** — Hero before metadata respects bonsai as a visual craft.  
7. **Reference Data as shared vocabulary** — Styles, soils, statuses, botanical library are central master data, not reinvented per tree.  
8. **Room to grow without forking the product** — Workspace Profiles and one data model support Progressive Complexity.

---

## Workflow Weaknesses

1. **Create mirrors the database** — Full form at birth; optional botanical weakness can become permanent.  
2. **Search is a dead end** — Growers cannot find; the World does not scale past a demo collection.  
3. **Filter / sort absent on the main path** — Browse is scroll-only.  
4. **Move is not a workflow** — Seasonal relocation is buried in Edit.  
5. **Image loop incomplete** — Primary add exists; Gallery and list recognition lag; unfinished actions teach distrust.  
6. **Detail still reads like a record inspector** — UUID primacy, botanical repetition, Health vs Status ambiguity.  
7. **Empty Reference Data breaks Edit** — Pickers without guidance feel broken, not progressive.  
8. **Placeholder modules compete with Trees** — First-run attention leaks away from the heart of the product.  
9. **Collection membership easy to miss** — Organizational workflow sits below a long form.  
10. **Cross-journey honesty** — Import, Duplicate, Delete, Gallery appear or are catalogued before the workflow is real.

### Database structure vs user workflow (explicit)

| Feels like structure | Grower workflow it should be |
|----------------------|------------------------------|
| Long New Tree form matching Detail sections | Register a tree: identity → place → name → (later) details |
| Tree ID leading General | Recognize *this* tree (photo + names) |
| Genus / Species / Cultivar listed beside Botanical Name without story | One botanical identity, with hierarchy only when choosing or teaching |
| Edit entire record to change Location | Move tree to another place |
| Collection IDs managed as a side block | “This tree is in …” groups |
| Search Quick Action without find | Find tree by name / species / place |
| Gallery button before gallery journey | See photos of this tree over time |

---

## Quick Wins

1. **Hide unfinished actions** (Search, Import, Gallery, Duplicate, Delete) until the workflow works — or wire Search for real.  
2. **Require Genus + Species on create** before Save; protect permanent identity.  
3. **Shorten New Tree** to botanical hierarchy, Location, optional Display Name (photo optional when reliable).  
4. **Humanize View Detail order** — photo, Botanical Name, Display Name, Location, status; demote Tree ID.  
5. **Empty picker guidance** — “None yet — manage in Reference Data / Botanical Library.”  
6. **Locked botanical help string** — one calm sentence why it cannot change.  
7. **Empty hero teaching** — quiet next step for adding a photo.  
8. **Show collection membership in View Mode** — change only in Edit (or a single membership action).

---

## Structural Improvements

1. **Find as a first-class Trees workflow** — Search + light filters/sort on the primary list (or promote browser capabilities into that path).  
2. **Move Tree workflow** — focused place change without full-form Edit.  
3. **Create → Enrich pattern** — birth essentials; growing/history/notes as progressive Edit.  
4. **Tree as hub** — related Gallery / Journal / Tasks open from the tree when those modules ship.  
5. **One editing language across Worlds** — Trees draft/Save and Locations sheet edit should feel like one family of “intentional change.”  
6. **Workspace Profiles in the shell** — Essential surfaces Trees, Locations, Collections first; Advanced/Complete reveal the rest.  
7. **Botanical mistake policy (product decision)** — if lock is absolute, document the humane correction path (future) so support and UX copy match.  
8. **Mobile journey map** — same workflows as stack: List → Detail → Edit / Move / Add Photo — not a different product logic.

---

## Future Ideas

*(Parking-lot quality — not approved scope.)*

- Seasonal **Move** batch: “Winter — move these indoors.”  
- **Care today** from Dashboard into filtered Trees (needs attention).  
- Timeline on the Tree: photos + journal + work as one story.  
- Propagation “graduates” into a Tree with lineage visible.  
- Exhibition Collection as a temporary organizational lens, not a second location.  
- Voice/quick capture later on mobile: photo + short note on the selected tree.  
- Smart collections (rules) only after manual membership feels effortless.

---

## Priority

### Critical

| Item | Why |
|------|-----|
| Working **find / search** (or hide Search) | Without find, Trees fails as a real collection tool. |
| **Honest action catalog** — no dead Search / Gallery / Import / etc. | Dead actions violate calm, trust, and One Action – One Location. |
| **Protect create-time botanical identity** (require Genus + Species) | Permanent lock on empty/wrong identity injures the heart of the record. |
| **Create essentials only** | Stops database-shaped birth; matches enthusiast expectation. |

### Important

| Item | Why |
|------|-----|
| Light **filter / sort** on main Trees path | Daily management of serious collections. |
| **Human Detail hierarchy** (demote UUID; clarify Health vs Status) | Viewing must feel like meeting a tree. |
| **Reference Data empty-state guidance** in pickers | Edit must not feel broken. |
| **Visible membership in View Mode** | Collections orbit the Tree clearly. |
| **Primary image loop completeness** + hide Gallery until ready | Visual care is core to bonsai. |
| Clarify **Move** vs full Edit (label or focused action) | Seasonal work is a real grower verb. |

### Future

| Item | Why |
|------|-----|
| Dedicated **Move Tree** workflow / batch seasonal moves | Care language at scale. |
| Tree hub for Gallery / Journal / Tasks | Trees at the Heart over years. |
| Workspace Profiles felt in navigation | Progressive Complexity made real. |
| Documented botanical correction path | Completes Safe by Default humanely. |
| Phone / Android stack journeys | Cross Platform First without new mental models. |
| Smart collections | Only after manual grouping is loved. |

---

## Closing

A bonsai enthusiast does not open Trees to “maintain records.” They open it to **know what they have, where it lives, how it looks, and what to do next**.

Bonsai World already chose the right principles for that life: safe viewing, permanent botanical identity, Quick Actions as the home of work, Trees at the center, complexity later via profiles.

The work now is to **finish the journeys those principles imply** — create cleanly, find reliably, place and group without confusion, photograph with trust — and to remove every leftover path that still feels like filling a database instead of caring for a tree.
