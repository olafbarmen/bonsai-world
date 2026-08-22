# Tree Detail & Tree Workspace — Product & UX Redesign Proposal

**Type:** Product / UX review (non-governing · historical)  
**Date:** 22 August 2026  
**Status:** **Approved and folded into** [PRODUCT_BLUEPRINT.md](../PRODUCT_BLUEPRINT.md) **§5.2** (Tree Overview + Tree Workspace). This file remains historical; product truth is the Blueprint.  
**Governing sources read:** README · START_HERE · BONSAI_CONSTITUTION · PRODUCT_BLUEPRINT · FALO_DESIGN_SYSTEM  

---

## 1. Purpose of this redesign

Tree Detail is the screen growers will open **thousands of times**. Today it works as a correct, View/Edit, Quick-Action-driven record surface — but it still **feels like a database form**.

The goal:

> The user should feel they are opening a **living tree**, not a row in a table.  
> The database supports the tree; it must not dominate the screen.  
> Observation before administration.

This proposal defines **two complementary experiences** that share one Tree and one data model:

| Surface | Role |
|---------|------|
| **Embedded Tree Detail** | Lives in the Trees split view (list above, detail below). Fast browse, orient, light care. |
| **Tree Workspace** | Opens in its **own macOS window** on **double-click**. Deep time with one bonsai — the flagship craft surface. |

Neither forks the Library. Both respect Constitution §1 (Trees at the heart), §17 / Blueprint §1.1 (**The Software Grows with the Artist**), and Falo Progressive Disclosure.

---

## 2. Diagnosis of the current Tree Detail

### What works (keep)

- Trees split view as primary browse workflow (`TreeWorkspaceView`: list + detail).
- View Mode default; intentional Edit via Quick Actions.
- Locked botanical identity after create.
- Photo band as the strongest visual element today.
- Collection membership as a relationship (Collection-owned), not a second location.
- Auto Save + Finish pattern (align long-term with Blueprint Save/Cancel language when Edit Mode is hardened).
- Measurement History as dated craft memory (seed of Timeline).

### What feels like a database

| Issue | Effect |
|-------|--------|
| **Equal card grid** (Identity / Growing / Classification / Status / Pot / Ownership / Notes / Collections) | Everything competes; nothing is the “tree.” |
| **Classification as a peer card** | Genus/Species/Cultivar read as admin taxonomy, not quiet identity under the name. |
| **Ownership expanded as a primary column** | Acquisition/disposal economics sit beside “where it lives” and “how it looks.” |
| **Pot Measurements as a top-tier card** | Technical dimensions before presence and place. |
| **No “now” story** | No upcoming work, recent care, or “what needs attention on this tree.” |
| **No life narrative** | Journal, work history, and design intent absent — only field groups. |
| **Photo band still “manager chrome”** | Feels like asset admin more than looking at the bonsai. |
| **Same surface for scan and deep work** | Split-view Detail cannot comfortably hold timeline + gallery + journal without becoming a form warehouse. |

### Current card inventory (as built)

Top → bottom today:

1. Photo manager band  
2. Grid: Identity | Growing | Classification  
3. Grid: Pot Measurements | Status | Ownership  
4. Grid: (empty) | Notes | Collections  
5. Measurement History (full width)

---

## 3. Design philosophy (flagship principles)

1. **Presence first** — The first seconds are photo + identity + place + health signal. Not field grids.
2. **Observation before administration** — What do I see? What needs care? Then: edit facts.
3. **One Tree, two depths** — Embedded Detail = glance and orient; Workspace = inhabit.
4. **Cards earn their place** — Falo: if removing a card does not hurt understanding, it should not be a card. Prefer sections, spacing, and hierarchy over equal panels.
5. **The Software Grows with the Artist** — Same Tree record; Novice / Experienced / Expert only change revelation and tools.
6. **Orbiting modules stay orbiting** — Journal, Workshop, Gallery, Assistant open *into* the Tree story; they do not become competing “home screens.”
7. **Lifecycle, not deletion** — Sold / Gifted / Dead / Lost are status in the story (§4.5), never a Delete-first path.

---

## 4. Information architecture — shared layers

Both surfaces draw from the same conceptual layers. Depth differs by surface and Experience Level.

| Layer | Intent | Examples |
|-------|--------|----------|
| **A. Presence** | “This is the living tree.” | Hero photo, nickname, botanical label, lifecycle badge, favorite |
| **B. Situation** | “Where it is and how it is.” | Location, light, style, size class, health, tree status |
| **C. Attention** | “What needs me now.” | Due water/repot/wire, open tasks, seasonal cue |
| **D. Memory** | “How it has lived.” | Photo timeline, measurements, work history, journal |
| **E. Stewardship** | “How I organize and own it.” | Collections, acquisition, disposal, documents |
| **F. Craft depth** | “How I develop it.” | Design sketches, front/apex plans, long-horizon notes |
| **G. Guidance** | “Help me think.” | Assistant scoped to this Tree |

**Embedded Detail** emphasizes **A → C**, with light **D/E**.  
**Tree Workspace** opens the full stack **A → G** as a calm, sectioned living document — not a denser form.

---

## 5. Embedded Tree Detail (split view)

### 5.1 Job to be done

While scanning the collection:

- Confirm which tree I’m looking at  
- See presence (photo) and situation (place, health)  
- Spot attention (“needs water / repot”) when available  
- Make a small correction (nickname, location, notes, add a photo)  
- Jump into deep work (open Tree Workspace) or related modules  

It must stay **comfortable under the list**. It is not a second application.

### 5.2 Proposed visual hierarchy (top → bottom)

```
┌─────────────────────────────────────────────────────────┐
│  PRESENCE BAND (not a “card stack”)                     │
│  Hero photo (dominant) │ Identity column                │
│                        │  Nickname / Botanical          │
│                        │  Lifecycle · Favorite · Place  │
│                        │  Quiet health / status chips   │
├─────────────────────────────────────────────────────────┤
│  ATTENTION STRIP (only when something is due)           │
│  “Repot due · Water today · 1 open task” → actions      │
├─────────────────────────────────────────────────────────┤
│  SITUATION (one calm section — not three equal cards)   │
│  Style · Size · Light · Pot type · Soil (summary)       │
├─────────────────────────────────────────────────────────┤
│  RECENT MEMORY (compact)                                │
│  Last work · Last photo date · Latest measurement       │
├─────────────────────────────────────────────────────────┤
│  DISCLOSURES (collapsed by default)                     │
│  Notes · Collections · Ownership · Classification       │
│  Pot dimensions · Measurement history (preview)         │
└─────────────────────────────────────────────────────────┘
```

### 5.3 Card / section verdict (current → proposed)

| Current card | Verdict | Placement |
|--------------|---------|-----------|
| **Photo manager** | **Keep, reshape** | Presence band — hero first; filmstrip / metadata secondary (Experienced+) |
| **Identity** | **Keep, merge into Presence** | Not a peer card; name stack beside/under hero |
| **Growing** | **Keep, demote density** | Situation section — Location is first-class; soil composition collapsed |
| **Classification** | **Collapse / demote** | Disclosure “Botanical classification” — always locked; never compete with Presence |
| **Status** | **Split** | Health + Tree Status → Presence chips; Size Class → Situation |
| **Pot Measurements** | **Collapse** | Disclosure “Current pot dimensions” — not top-tier |
| **Ownership** | **Collapse** | Disclosure “Acquisition & disposal” — Expert/Experienced; Novice sees “Acquired {year/source}” one line if useful |
| **Notes** | **Keep, demote** | Disclosure or short preview under Situation |
| **Collections** | **Keep, demote** | Compact chips / disclosure — membership, not a tall card |
| **Measurement History** | **Preview only in Detail** | Latest + “Open history…” → Workspace; full strip is Workspace-grade |

### 5.4 What should disappear from Embedded Detail

- Equal-weight **3-column card warehouse**  
- Full **Ownership** panel as a permanent column  
- Full **Measurement History** strip as default (preview only)  
- Any future **Journal / Work / Design / Assistant** as always-on panels in the split (those belong in Workspace or focused sheets)  
- UUID-led or taxonomy-first chrome  

### 5.5 Editing workflow (Embedded)

| Mode | Behavior |
|------|----------|
| **View** | Default. Observation. Photo openable. Chips and summaries only. |
| **Edit** | Enter via Quick Action **Edit Tree**. Draft + Save/Cancel/Reset per Blueprint (Auto Save may remain as implementation detail if product language stays Finish/Save-aligned). |
| **Scope of Edit in Detail** | Nickname, place, growing summaries, notes, collections, pot dims, health/status, add photo, add measurement. |
| **Not in Detail Edit** | Deep gallery curation, multi-year timeline authoring, journal essays, work-session logging UI — offer **Open in Tree Workspace** or module deep links. |

Botanical identity remains immutable after create (Constitution).

### 5.6 Navigation (Embedded)

- Single-click / list selection → Embedded Detail (current).  
- **Double-click row** (or Quick Action **Open Tree Workspace**) → dedicated window.  
- From Collections member list: same rules.  
- **Show on Map** remains a context jump to Locations (orbiting module).  

### 5.7 Experience Levels — Embedded Detail

| Section | Novice | Experienced | Expert |
|---------|--------|-------------|--------|
| **Presence (photo + name + place)** | Always | Always | Always |
| **Lifecycle badge** | Simple (Active / …) when shipped | Full labels | Full + quiet history cue |
| **Attention strip** | Plain language (“Needs water”) | + task counts | + workshop-linked actions |
| **Situation** | Location, Style, Health | + Light, Size, Pot type | + Soil mix summary |
| **Soil composition** | Hidden | Disclosure | Disclosure + edit |
| **Classification disclosure** | Hidden (botanical name enough) | Optional | Visible |
| **Ownership disclosure** | One-line acquired | Full acquisition | Acquisition + disposal |
| **Collections** | Chips if any | Add/remove | Add/remove + Smart awareness |
| **Notes** | Short field | Full | Full |
| **Pot dimensions** | Hidden | Disclosure | Disclosure |
| **Measurement preview** | Latest height only (if any) | Latest session | Latest + open full history |
| **Quick Actions** | Edit, Add Image, Open Workspace | + Show on Map, Add Measurement | + Gallery, Register Work (when shipped) |
| **Delete** | Hidden | Hidden | Hidden until correction workflow (§4.5) |

---

## 6. Tree Workspace (dedicated window)

### 6.1 Job to be done

**Enter the life of one bonsai** for sustained work: look, remember, plan, record, design.

This is not “Detail but bigger.” It is the **Tree’s room** in the house of Bonsai World.

### 6.2 How it differs from Embedded Detail

| Dimension | Embedded Detail | Tree Workspace |
|-----------|-----------------|----------------|
| **Context** | Under the collection list | Alone in its window |
| **Mindset** | Browse / orient / nudge | Inhabit / craft / remember |
| **Time horizon** | Now + last touch | Seasons and years |
| **Photo** | Hero for recognition | Hero + Gallery + compare (future) |
| **History** | Preview | Timeline spine |
| **Work** | Attention cues | Register Work, history, upcoming tasks |
| **Journal** | Link / none | First-class entries for this Tree |
| **Design** | Absent | Sketches / front / intent (Expert) |
| **Assistant** | Absent or quiet tip | Optional pane scoped to this Tree |
| **Admin fields** | Disclosures | Still demoted — never the hero |

### 6.3 Proposed Workspace structure

**Window title:** Nickname if set, else botanical name · Bonsai Name as quiet subtitle (permanent registry, not hero).

**Primary composition (prefer one calm scroll with sticky Presence; internal chapter nav allowed):**

```
┌─ PRESENCE HERO (dominant photo plane) ───────────────────┐
│  Photo dominates. Name / place / lifecycle beside or     │
│  below — not as stickers on the foliage.                 │
├─ STORY RAIL (chapter navigation) ────────────────────────┤
│  Now · Timeline · Gallery · Measure · Work · Journal · … │
├─ ACTIVE SECTION BODY ────────────────────────────────────┤
│  Content for the selected story chapter                  │
└──────────────────────────────────────────────────────────┘
```

**Story chapters (permanent homes — ship incrementally):**

| Chapter | Content | Level |
|---------|---------|-------|
| **Now** | Attention, situation summary, next actions, open tasks | All |
| **Timeline** | Unified memory: photos, measurements, work, journal anchors | Exp+; Novice sees simplified “History” |
| **Gallery** | All images, primary, captions, future compare | All (depth grows) |
| **Measure** | Full measurement history + add session | Exp+; Novice: simple height log |
| **Work** | Register Work, work history, links to Workshop types | Exp+ |
| **Journal** | Chronological observations for this Tree | Exp+; Novice: “Notes over time” optional |
| **Collections** | Membership management | All |
| **Design** | Sketches, front, style intent, deadwood plans | Expert |
| **Documents** | Attachments, certificates, invoices | Expert (or Exp+) |
| **Ownership** | Acquisition / disposal / value prep | Exp+ / Expert |
| **Assistant** | Conversation scoped to this Tree (+ optional Collection) | Progressive; quiet entry Exp+ / Expert |

### 6.4 Hero photo rules (Workspace)

Aligned with Falo calm + Constitution presence:

- Hero is **the tree**, edge-to-edge or near full-bleed within the Presence chapter.  
- Do **not** cover the hero with detached promo chips, stat stickers, or admin badges.  
- Identity text sits **beside or below** the photo plane, not as stickers on foliage.  
- Double-click hero → immersive viewer (existing image viewer path).

### 6.5 Timeline (flagship memory)

A single chronological spine for **this Tree only**:

- Photo events  
- Measurement sessions  
- Registered work  
- Journal entries  
- Lifecycle changes (when shipped)  

Filters by type for Experienced/Expert. Novice sees a gentle “History” list without filter chrome.

This replaces the urge to dump every module into equal cards.

### 6.6 Work registration

- **Register Work** from Workspace Quick Actions / Now chapter → writes Workshop-owned work linked by Tree ID (orbiting module owns types; Tree owns the link).  
- Embedded Detail only surfaces **attention** and “Register Work…” deep link when level allows.  

### 6.7 Journal

- Entries live in Journal domain, **always linked to Tree ID**.  
- Workspace is the primary authoring surface for tree-scoped journal.  
- Embedded Detail may show “Latest note” one-liner + Open Journal.  

### 6.8 Assistant integration (future)

- Pane or chapter: **context = this Tree** (and optionally its Collections).  
- Never invent botanical identity.  
- Suggests observation questions, seasonal care, “what changed since last photo” — Progressive Disclosure; off by default for Novice.  
- Blueprint already allows Assistant scoped to a Collection; Tree scope is the natural twin.

### 6.9 Experience Levels — Tree Workspace

| Capability | Novice | Experienced | Expert |
|------------|--------|-------------|--------|
| Open Workspace window | Yes | Yes | Yes |
| Presence hero + Now | Yes | Yes | Yes |
| Gallery | Add / view primary | Full film + metadata | Compare / timelines |
| History / Timeline | Simple list | Filtered timeline | Full spine + export later |
| Measure | Optional height | Full dimensions | Trends / denser history |
| Work | Soft cues only | Register Work + history | Batch / advanced types |
| Journal | Optional short notes | Full journal | Rich + media refs |
| Design chapter | Hidden | Hidden or teaser | Full |
| Documents | Hidden | Optional | Full |
| Ownership | Minimal | Full | Full + economy prep |
| Assistant | Hidden | Opt-in | Opt-in, richer tools |
| Classification / soil science | Hidden behind name | Available | Dense |

---

## 7. Navigation between Detail and Workspace

| Action | Result |
|--------|--------|
| Click tree in list | Embedded Detail (selection) |
| **Double-click** tree in list | Open / focus **Tree Workspace** window for that Tree |
| Quick Action **Open Tree Workspace** | Same |
| From Workspace: **Show in Library** / **Reveal in List** | Focus main window, select tree in list, Embedded Detail |
| Close Workspace window | Main library unchanged; selection preserved |
| Edit in either surface | **Same Tree record**, same locks, same lifecycle rules |
| Multiple Workspace windows | Allowed (one per Tree or multiple Trees) — native macOS multi-window; do not force single-document app |

**Do not** open Workspace for every single-click — that would destroy browse rhythm.

**Do not** make Workspace a duplicate of Embedded Detail with more cards — that fails the “living tree” test.

---

## 8. Photo experience (both surfaces)

| Concern | Embedded | Workspace |
|---------|----------|-----------|
| Primary job | Recognize the tree | Study the tree over time |
| Hero | Strong, calm | Dominant Presence |
| Filmstrip | Experienced+ | Gallery chapter |
| Add Image | Quick Action / Edit | Gallery + Quick Action |
| Viewer window | Double-click photo | Double-click / Gallery open |
| View Gallery QA | Ships when Gallery chapter/module ready | Primary home |

---

## 9. Measurements

| Concern | Embedded | Workspace |
|---------|----------|-----------|
| Pot dimensions | Collapsed disclosure | Measure chapter (Current pot) |
| Tree body | Latest preview | Full history + Add Measurement |
| Mental model | “How big is it now?” | “How has it grown?” |

Keep pot vs body distinction (current pot on Tree vs measurement history) — clearer copy for Novice.

---

## 10. Collections & ownership

- **Collections:** chips + membership sheet; Collection remains source of truth (§4.4).  
- **Ownership:** not a hero. Collapsed in Detail; chapter or disclosure in Workspace. Disposal = lifecycle story, not Delete.  

---

## 11. Long-term evolution — signature experience

### Phase narrative (product, not sprint plan)

1. **Calm Presence** — Reshape Embedded Detail: hero + identity + situation + disclosures; kill equal card grid.  
2. **Tree Workspace v1** — Double-click window with Presence + Now + Gallery + Measure.  
3. **Timeline spine** — Unify memory events.  
4. **Work + Journal in Workspace** — Craft loop without leaving the tree.  
5. **Design + Documents (Expert)** — Depth without Novice noise.  
6. **Assistant** — Optional co-pilot in the Tree’s room.  

### Success criteria (qualitative)

- A Novice can open a tree and feel **“this is my bonsai”** in under three seconds.  
- An Expert can spend an hour in Workspace without hunting a parallel “database screen.”  
- Advancing Experience Level **reveals** chapters; it never migrates or forks data (§1.1 / Constitution §17).  
- Reviews still describe Trees as the heart — and the UI finally feels like it.

---

## 12. Alignment checklist (governing docs)

| Requirement | How this proposal honors it |
|-------------|----------------------------|
| Trees at the heart | Dual surfaces both orbit one Tree |
| View / Edit | Preserved; depth differs by surface |
| Quick Actions | Context actions; no duplicate Save in chrome |
| One concept one name | “Tree Workspace” ≠ new entity; same Tree |
| Progressive Disclosure | Disclosures + chapters |
| Grows with the Artist | Level matrix on every major section |
| Platform independence | Windowed Workspace is macOS-first presentation; mental model portable |
| No sixth bible | Review only; fold into Blueprint when approved |
| Lifecycle ≠ delete | Ownership/status demoted; Delete stays exceptional |

---

## 13. Decisions requested (before any implementation)

1. Approve **two-depth model**: Embedded Detail vs Tree Workspace (double-click).  
2. Approve **Presence-first** Embedded layout and demotion of Classification / Ownership / Pot dims / full Measurement History.  
3. Approve **Workspace story chapters** list (Now, Timeline, Gallery, Measure, Work, Journal, …) as permanent IA — ship order later.  
4. Approve Experience Level matrices in §5.7 and §6.9 (or amend).  
5. Confirm Edit Mode product language for Trees: Blueprint Save/Cancel vs current Auto Save + Finish — one rule before UI polish.  
6. On approval: update Blueprint §5.2 Detail View + Future Expansion; optionally §7 shell notes for multi-window Tree Workspace.

---

## 14. Explicit non-goals (this proposal)

- No code, no visual mock implementation in-app.  
- No new governing document.  
- No fork of Tree schema for “Workspace entities.”  
- No Dashboard redesign.  
- No forcing Journal/Work to become top-level competitors to Trees.

---

*End of proposal.*
