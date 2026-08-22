# START HERE

Every developer, AI assistant, and contributor begins here.

**START_HERE is the mandatory entry point.** Do not make changes until you have read this file and the governing documents in the reading order below.

**If it isn't documented, it isn't decided.**

---

## The five governing documents

There must **never be more than five governing documents**:

| # | Document | Role |
|---|----------|------|
| 1 | [START_HERE.md](START_HERE.md) | This file — how to work |
| 2 | [BONSAI_CONSTITUTION.md](BONSAI_CONSTITUTION.md) | Immutable philosophy |
| 3 | [PRODUCT_BLUEPRINT.md](PRODUCT_BLUEPRINT.md) | Current product, architecture, Bonsai UI patterns |
| 4 | [FALO_DESIGN_SYSTEM.md](../../Documentation/FALO_DESIGN_SYSTEM.md) | Shared Falo visual and UX language |
| 5 | [FALO_COMPONENT_LIBRARY.md](../../Documentation/FALO_COMPONENT_LIBRARY.md) | Shared Falo building blocks |

**Do not create additional governing documents.** New architecture, UX principles, and workflow rules must be incorporated into one of these five.

### Non-governing material (allowed)

These may exist for process and history. They must not redefine product truth:

| Kind | Examples |
|------|----------|
| Direction | `ROADMAP.md` (themes only) |
| History | `CHANGELOG.md` (shipped work / decision log) |
| Sprint plans | `Documentation/Roadmap/*` |
| Technical appendices | `Documentation/Architecture/*` (e.g. detailed storage notes) |
| Reviews | `Documentation/Reviews/*` (architecture, UI, workflow) |
| Ideas | `Documentation/Project/00_Idea_Parking_Lot.md` |

If an appendix or review invents a rule, **fold the rule into the five** and keep the appendix historical.

---

## Reading order

1. **START_HERE**  
2. **BONSAI_CONSTITUTION**  
3. **PRODUCT_BLUEPRINT**  
4. **FALO_DESIGN_SYSTEM** (when designing or changing UI)  
5. **FALO_COMPONENT_LIBRARY** (when reusing or proposing shared components)  

Optional: Roadmap (direction), Changelog (what shipped), Architecture appendices (deep storage), Reviews (quality feedback).

---

## Decision hierarchy

**Constitution** → **Product Blueprint** → **Falo Design System / Component Library** → **Implementation**

Non-governing files never outrank the five.

---

## Development workflow

1. **Discuss** — clarify intent against Constitution and Blueprint.  
2. **Document** — update the appropriate governing document(s) before large change.  
3. **Approve** — architectural change needs explicit approval.  
4. **Implement** — code follows documentation; no invented architecture.  
5. **Review** (as needed) — Architecture Review, UI Review, Workflow Review under `Documentation/Reviews/`. Reviews recommend; they do not become governing docs.  
6. **Record** — note shipped work or approved decisions in the Changelog (history only).

Sprint plans describe delivery sequencing. They do not replace the Blueprint.

---

## Platform independence

Bonsai World ships native **macOS** first. Architecture must support **Windows**, **iPhone**, and **Android** without major refactoring.

- Domain and models stay platform independent.  
- Services stay independent when practical.  
- OS APIs stay in the platform layer.  
- UI may be native per platform; workflows and mental model stay shared.  

Details: Constitution §§10–11; Blueprint §§2 and 6.

---

## AI assistants

Before making changes:

- Read the five governing documents (reading order above).  
- Do not invent architecture, features, or new governing documents.  
- Do not refactor without explicit instruction.  
- Put new principles into Constitution or Blueprint (or Falo docs if universe-shared) — never a sixth bible.  
- Respect Quick Actions, View/Edit, one action one place, Trees at the center, and platform independence.  
- If something is not documented, ask instead of assuming.
