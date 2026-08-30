# Context Tools — Product Architecture

**Type:** Product / architecture review (non-governing · historical once folded)  
**Date:** 23 August 2026  
**Status:** **Approved decision** — folded into [PRODUCT_BLUEPRINT.md](../PRODUCT_BLUEPRINT.md) **§7.2** (+ Constitution §7 cross-ref). This file remains the rationale.  
**Governing sources read:** README · START_HERE · BONSAI_CONSTITUTION · PRODUCT_BLUEPRINT · Falo Design System *(Swift tokens under `Shared/DesignSystem/`)*  

**Supersedes (terminology):** **Quick Actions** as the user-facing action model. Implementation names (`QuickActionsView`, `*QuickActionsCatalog`) may remain until refactor.

**Principle:** *One place. The right tools for where you are.*

---

## 1. Purpose

### 1.1 Problem with “Quick Actions” today

The current **Quick Actions** sidebar block mixes two ideas:

| Layer | Today | Grower confusion |
|-------|-------|------------------|
| **Global** | Add Tree, Search, Import — always visible | “Why is Add Tree here when I’m in Inventory?” |
| **Context** | Module actions when a route/selection applies | Correct intent, but buried under a generic label |

The label **Quick Actions** describes *speed*, not *belonging*. It does not tell the grower **which workspace** owns the commands.

### 1.2 Definition

**Context Tools** is Bonsai World’s **permanent action model**: a single, consistent region in the **bottom of the left sidebar** that shows the tools for the **currently active workspace**.

- **Location never changes** — always the same sidebar region.  
- **Contents always change** — driven by workspace, route, selection, and mode.  
- **No scattered toolbars** — domain work actions do not live in Detail headers, floating toolbars, or duplicate menus.

### 1.3 Product sentence

> **Workspace** tells you where you are. **Context Tools** tell you what you can do there.

### 1.4 Constitution alignment

**One Action – One Location** (Constitution §7) is preserved and strengthened:

- Context Tools **is** the primary action area for user work.  
- Application chrome (window title, library name) stays non-action.  
- **Settings → Library Management** owns library Import/Export — not Context Tools (Blueprint §8.1).  
- Detail **View / Edit** philosophy unchanged — Edit Mode swaps the tool set, not the region.

---

## 2. Sidebar structure

### 2.1 Permanent layout (all platforms)

```text
┌─────────────────────────┐
│  Bonsai World           │
├─────────────────────────┤
│  WORKSPACE              │  ← navigation (where can I go?)
│    Dashboard            │
│    Garden ▸             │
│    Media ▸              │
│    …                    │
│                         │
│         ·               │
│         ·               │  (flex / scroll — workspace fills)
│         ·               │
├─────────────────────────┤
│  TREE TOOLS             │  ← Context Tools (dynamic title)
│    Add Tree             │
│    Edit Tree            │
│    Open Tree Workspace  │
│    …                    │
├─────────────────────────┤
│  TOOLS                  │  ← app configuration (Settings)
│    Settings             │
└─────────────────────────┘
```

Three regions — **Workspace · Context Tools · Tools** — never four.

### 2.2 Region responsibilities

| Region | Job | Changes when |
|--------|-----|--------------|
| **Workspace** | Module and route navigation | Experience Level (§6) |
| **Context Tools** | Action commands for active workspace | Route, selection, Edit/View mode, window type |
| **Tools** | Settings and library administration entry | Never (Settings always reachable) |

### 2.3 What Context Tools is not

- Not a second navigation column.  
- Not a per-Detail overflow menu (`DetailHeader` ⋯ menus must migrate away).  
- Not a macOS toolbar duplicate for domain actions.  
- Not **Global Quick Actions** as a permanent cross-module block — workspace-scoped tools replace “global.”

### 2.4 Cross-platform presentation

| Platform | Workspace | Context Tools | Tools |
|----------|-----------|---------------|-------|
| **macOS / Windows / Linux** | Sidebar top (scroll) | Sidebar bottom (fixed anchor above Tools) | Sidebar bottom |
| **Narrow / mobile** | Primary navigation stack | **Bottom toolbar** or trailing sheet — same tool catalog, same rules | Settings entry in app menu / profile |

Mental model is identical; only layout adapter differs (Blueprint §2 platform independence).

---

## 3. Context Tools philosophy

### 3.1 Workspace-scoped naming

The section **header is always human and workspace-specific**:

| Active workspace | Context Tools title |
|------------------|---------------------|
| Garden → Trees / Tree Overview | **Tree Tools** |
| Tree Workspace window | **Tree Tools** |
| Garden → Collections | **Collection Tools** |
| Media → Images | **Image Tools** |
| Locations | **Location Tools** |
| Workshop → Work | **Work Tools** |
| Workshop → Calendar | **Calendar Tools** |
| Workshop → Tasks | **Task Tools** |
| Inventory | **Inventory Tools** |
| Nursery → Yamadori | **Yamadori Tools** |
| Dashboard | **Dashboard Tools** |
| Settings | *(hidden or empty — Tools region suffices)* |

Pattern: **`{Workspace} Tools`** — never the generic label “Quick Actions.”

### 3.2 Tool sets, not global + context

**Retire the Global / Context split** in product language and UX.

| Old | New |
|-----|-----|
| Global: Add Tree | **Tree Tools** when route is Garden → Trees (or Tree Workspace) |
| Global: Search | **Dashboard Tools** or module-specific Search when shipped |
| Global: Import | **Settings → Library Management** (§8.1) — remove from sidebar tools |
| Context: Edit Tree | **Tree Tools** when tree selected |

One flat list per scope — ordered by frequency and safety (primary create first, destructive last, hidden until allowed).

### 3.3 Context Tool scope (resolution)

A **Context Tool Scope** resolves which catalog applies:

```text
AppRoute (leaf workspace)
    + optional selection (tree, collection, location, …)
    + interaction mode (View / Edit)
    + optional window kind (main shell vs Tree Workspace window)
    + Experience Level (§6)
    → Context Tool Scope → titled tool list
```

Implementation (future): `ContextToolsCatalog.tools(for: ContextToolScope)`.

### 3.4 Interaction rules

| Rule | Meaning |
|------|---------|
| **One location** | Every domain action appears in Context Tools only — nowhere else as a primary control. |
| **View default** | Detail is read-only; **Edit Tree** (etc.) enters Edit Mode. |
| **Edit Mode swap** | Tool list becomes **Save · Cancel · Reset Changes** only (plus Finish where Auto Save modules use it). |
| **Selection-aware** | With no selection, show workspace create/discover tools (e.g. Add Tree). With selection, show entity tools (Edit, Open Workspace, …). |
| **Unfinished hidden** | No Coming Soon rows in the shipped list — hide until `.available`. |
| **Destructive last** | Delete and irreversible actions last; hidden until policy allows (§4.5 Tree Lifetime). |
| **No duplicate Create** | Add Tree lives in **Tree Tools** — not again in **Collection Tools** as a second create path. |

### 3.5 Relationship to Detail chrome

| Surface | Allowed | Migrate away |
|---------|---------|--------------|
| Context Tools sidebar | All primary domain actions | — |
| Detail View body | Read-only content, links into other modules | Inline edit controls |
| Detail header | Title, status chips | **Quick Actions ⋯ menu** (duplicate — remove) |
| Tree Detail toolbar | Cancel/Save in sheets only | Trailing action clusters on Overview |

Shortcuts (keyboard, context menu) may **invoke** Context Tools commands — they do not define a second action home.

---

## 4. Relationship to Workspace

### 4.1 Workspace drives tools

```text
User selects Workspace route
    ↓
Context Tool Scope updates
    ↓
Sidebar shows "{Workspace} Tools" + applicable commands
    ↓
User selects entity in Content List
    ↓
Scope refines (same title family — e.g. still Tree Tools)
    ↓
User enters Edit Mode
    ↓
Tool list swaps to Save / Cancel / Reset
```

### 4.2 Multi-window (Tree Workspace)

Tree Workspace windows use the **same shell**: Workspace navigation + **Tree Tools** in the same bottom sidebar region. Chapter depth (Gallery, Measure, Work) may refine tools in Expert+ — still **Tree Tools**, not per-chapter sidebars.

### 4.3 Modules reference tools; they do not host them

| Module | Owns | Context Tools |
|--------|------|-----------------|
| Trees | Tree records | **Tree Tools** catalog |
| Media → Images | Image browse/workflows | **Image Tools** catalog |
| Collections | Membership | **Collection Tools** catalog |
| Settings | Preferences | *(none — Tools section)* |

Module §4.2 template field **Quick Actions** becomes **Context Tools** — list tools by scope, not “global/context.”

---

## 5. Experience Levels

Same scopes and catalogs at every level — **progressive disclosure** controls which tools appear.

| Level | Context Tools behaviour |
|-------|-------------------------|
| **Novice** | Smaller tool sets; calm defaults; hide Expert-only commands; same sidebar region |
| **Experienced** | Full module tool sets for visible workspaces; Prepare, Featured, richer Media tools |
| **Expert** | Advanced tools (Compare, batch, AI assists) append to existing scopes — never a second Expert toolbar |

**Rules**

- Levels filter **visibility**, not **location**.  
- Advancing level never moves actions to a new region.  
- Dashboard Tools stay read-only orientation (no record editing).

---

## 6. Example tool catalogs (illustrative)

### 6.1 Tree Tools — View Mode, tree selected

Add Image · Edit Tree · Open Tree Workspace · Show on Map · View Images · *(Duplicate hidden)* · *(Delete hidden)*

### 6.2 Tree Tools — Edit Mode

Save · Cancel · Reset Changes

### 6.3 Tree Tools — no selection

Add Tree · Search *(when shipped)*

### 6.4 Collection Tools — Manual collection selected, View

Add Existing Tree · Edit Collection · *(Smart rules when Smart ships)*

### 6.5 Image Tools — Media → Images

Import Photos *(when shipped)* · *(Prepare, Set Primary when selection ships)*

### 6.6 Inventory Tools — Expert+

New Inventory Item · Add Photo · Log Maintenance · …

---

## 7. Migration from Quick Actions (implementation planning)

| Current | Target |
|---------|--------|
| `QuickActionsView` | `ContextToolsView` *(or rename in place)* |
| `GlobalQuickActionsCatalog` | Absorb into workspace catalogs |
| `ContextQuickActionsCatalog` | `ContextToolsCatalog` per scope |
| Sidebar header “Quick Actions” | Dynamic `"{Scope} Tools"` |
| User-facing copy “Quick Actions → …” | “Tree Tools → …” / “Collection Tools → …” |
| `DetailHeader` action menu | Remove — use Context Tools only |

**Not in scope of this document:** code changes.

---

## 8. Required Blueprint updates

Applied in `PRODUCT_BLUEPRINT.md`:

1. **§7.1 Workspace areas** — diagram and table: **Context Tools** replaces Quick Actions column.  
2. **§7.2 Context Tools** — full spec (replaces §7.2 Quick Actions).  
3. **§4.1 / §4.2 module template** — field renamed to **Context Tools**.  
4. **§5 module tables** — “Quick Actions” column → **Context Tools** (scope names).  
5. **§6 Experience Levels** — Context Tools visibility rules.  
6. **§8.1 Library Management** — clarify Import is not a Context Tool.  
7. **§9 status / §10.3** — Falo shell: **Workspace · Context Tools · Tools**.  
8. **Constitution §7** — primary action area = **Context Tools** (terminology alignment).  
9. **CHANGELOG** — 2026-08-23 Context Tools decision.

---

## 9. Explicit non-goals

- Implementing Swift UI in this task.  
- Redesigning Detail layouts or Images grid.  
- Adding new domain capabilities — naming and placement only.  
- Floating action buttons or module-specific toolbars as alternate homes.

---

## 10. Summary

**Context Tools** replaces **Quick Actions** as the permanent, workspace-scoped action region at the **bottom of the sidebar**. The grower always knows **where** to act; the application always knows **which** tools belong to the active workspace. *One place. The right tools for where you are.*
