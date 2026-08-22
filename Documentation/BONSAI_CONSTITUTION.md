# Bonsai World Constitution

**Status:** Immutable philosophy (change only with explicit architectural approval)

This document defines the principles every future decision must respect.

It is not a roadmap, not a feature list, and not an implementation guide. Product shape and UI patterns live in the Product Blueprint. Shared visual language lives in the Falo Design System.

---

## 1. Purpose

Bonsai World exists to help people organize and care for a bonsai collection with clarity and calm.

**Trees are the heart of Bonsai World.** Every workflow ultimately supports the Tree. Collections, Locations, Gallery, Journal, Propagation, Calendar, and Tasks exist to serve trees — or the grower’s relationship to them. Secondary modules orbit; they do not compete for primacy.

If a change does not clearly serve people who grow and tend bonsai, it does not belong.

---

## 2. User First

Users are the center of every decision.

Prefer clarity, reduced friction, and lasting usefulness over novelty. Product language must be human and understandable — not engineer jargon.

If a beginner cannot understand a label or workflow, rewrite it.

---

## 3. Documentation is the Single Source of Truth

**If it isn't documented, it isn't decided.**

There must **never be more than five governing documents**:

1. [START_HERE.md](START_HERE.md) — entry point and how to work  
2. [BONSAI_CONSTITUTION.md](BONSAI_CONSTITUTION.md) — this file  
3. [PRODUCT_BLUEPRINT.md](PRODUCT_BLUEPRINT.md) — current product architecture and feature set  
4. [FALO_DESIGN_SYSTEM.md](../../Documentation/FALO_DESIGN_SYSTEM.md) — shared Falo visual and UX language  
5. [FALO_COMPONENT_LIBRARY.md](../../Documentation/FALO_COMPONENT_LIBRARY.md) — shared Falo building blocks  

**Do not create additional governing documents.** New architectural decisions, UX principles, and workflow rules must be incorporated into one of these five.

Roadmaps, changelogs, sprint plans, storage appendices, and reviews may exist as **process or historical** material. They are not governing and must not contradict or replace the five.

Code follows documentation. The five override informal prompts when they conflict.

---

## 4. Architecture Before Implementation

Never redesign the architecture without explicit approval.

Large work follows: discuss → document (in the five) → approve → implement.

Ownership boundaries are decided before code is written. Shortcuts create long-term debt.

Reviews (architecture, UI, workflow) support quality; they do not invent a sixth source of truth.

---

## 5. Simplicity Over Complexity

Whenever a new capability is proposed, first ask:

> Can an existing capability solve this?

If yes: improve what exists. Do not build a parallel solution.

Remove complexity whenever possible. Progressive disclosure beats crowded chrome. Unfinished actions stay hidden until they work. Fewer excellent capabilities beat many mediocre ones.

---

## 6. Workflow before Features

Users think in **workflows**: what needs care, where a tree lives, what happened last season, what to do next.

They do not think in tables, foreign keys, or screen inventories.

Design the path from intention to outcome. Never expose database structures or internal identifiers as primary UI. If a beginner cannot see the workflow, the feature is not finished.

---

## 7. One Action – One Location

Every action exists in **only one place**.

**Quick Actions** is the primary action area for user work. Toolbars and other chrome stay reserved for global application function — not a second copy of the same command.

If an action appears twice, remove one occurrence.

---

## 8. Safe by Default

The default experience must be safe.

Detail pages open in **View Mode** (read-only). Editing is intentional: enter **Edit Mode**, then Save or Cancel.

**Botanical identity** (Genus, Species, Cultivar, and the Botanical Name derived from them) becomes **immutable** after a Tree has been created. Correction workflows, if ever needed, must be explicit product decisions — never quiet inline edits.

---

## 9. Reference Data is Master Data

Reference Data is shared master data for the whole World. It is managed **centrally** (Settings), not reinvented inside each operational module.

**Hierarchical data stays hierarchical** (for example Genus → Species → Cultivar). Pickers consume the same source of truth. When vocabulary is wrong or incomplete, fix it at the source.

---

## 10. Native Experience, macOS First to Ship

Bonsai World is **initially** developed as a native macOS application.

Prefer **native controls** and platform conventions. Custom UI only when it clearly improves usability — not for decoration or novelty.

Shipping on macOS first does **not** mean the product is architecturally macOS-only. See Platform Independence.

---

## 11. Platform Independence

Cross-platform readiness is a permanent architectural principle. The product must remain reachable on **macOS**, **Windows**, **iPhone**, and **Android** without rewriting what a Tree is or how care works.

- **Business logic** and **models** must remain platform independent.  
- **Services** should be platform independent whenever practical.  
- **Platform-specific implementations** must be isolated (platform layer / adapters).  
- **UI** may be platform specific; the grower’s mental model must not.  
- **No feature** may depend on OS APIs unless that code belongs to the platform layer.

---

## 12. User Owns the Data

The grower owns the **Bonsai World Library**.

The application is a steward, not a jailer. Users must not be locked into a single storage provider. Local and future cloud options serve the library; they do not own it.

---

## 13. Consistency and Reuse

Reuse established patterns, language, and shared building blocks. Prefer existing components and services before creating new ones.

Users should always know where they are and what to do next. Inconsistency erodes trust faster than missing capabilities.

UI patterns for Bonsai World are defined in the Product Blueprint and must align with the Falo Design System.

---

## 14. Clear Separation of Responsibilities

Every layer, module, and type has one clear job.

Presentation presents. Coordination coordinates. Domain services own domain operations. Models describe domain shape. Storage persists the library. Do not mix responsibilities. Do not invent a parallel source of truth.

---

## 15. Long-Term Maintainability

Prefer decisions that remain understandable and evolvable over years.

Short-term convenience that creates hidden coupling, duplicated truth, or undocumented behavior is not acceptable.

---

## 16. Explicit Approval for Architectural Change

Architectural changes require documented approval in the governing set before implementation.

Prefer incremental, reviewed change over sweeping redesigns.

---

## 17. One Application — The Software Grows with the Artist

Bonsai World is **always one application**. There are never separate Beginner, Intermediate, or Professional editions, products, or databases.

**The software grows with the artist.** Users never change products—they grow into them. One Library. One data model. Three **User Experience Levels** (Novice, Experienced, Expert) that increase capability without forcing complexity.

Experience Levels (and Workspace Profiles that implement them) control only **presentation, navigation, guidance, and available tools**. They never fork storage, schemas, or domain truth.

- The **complete data model** always exists; hidden modules and tools remain supported.  
- Advancing or simplifying the experience never requires migration, conversion, or import/export and never loses data.  
- Levels are **independent of licensing**.  
- Every future feature must define Novice, Experienced, and Expert behaviour (or state that it is level-invariant).

Official level rules and profile mapping live in the Product Blueprint. The interaction method is **Progressive Disclosure** in the Falo Design System; this section is the immutable product stance.

---

## Final principle

When in doubt, choose the solution that:

- Serves people who care for bonsai  
- Advances a real workflow  
- Makes the experience simpler  
- Respects the five governing documents  
- Remains maintainable over time  

Everything else is secondary.
