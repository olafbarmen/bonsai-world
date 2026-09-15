# Bonsai World — Current Project Status Audit

Generated from codebase + recent working-tree passes through **2026-09-12** · report only · no product code in this doc pass.

Supersedes [STATUS_AUDIT_2026-09-11.md](STATUS_AUDIT_2026-09-11.md). Companion briefing: [STATUS_REPORT_2026-09-12.md](STATUS_REPORT_2026-09-12.md).

**Tags:** Audit · Docs sync · Working tree still ahead of last git commit on `main`

---

## 1. Executive summary

**Snapshot:** Bonsai World is a usable daily tool for one grower: Trees, Pots, Tasks, Yamadori, Seeds, Care (shipped pages), Inventory stock, Species Library, Knowledge guides, Gallery/crop, and Library export/import are real. **Context Tools** is now the grower-facing action home (truth pass + toolbar cleanup). Remaining gaps are uneven Nursery/Media depth, hidden Social/Economy, photo/measurement dual-storage risk, and no Sparkle/distribution pipeline.

| Area | Verdict |
| --- | --- |
| Core Tree / Pot / Tasks / Yamadori | Mature — ready for grower testing |
| Care / Nursery / Inventory / Knowledge guides | Functional → Partial — usable, depth varies |
| Context Tools / Seeds workspace / Experience planning UI | Functional — Context Tools trustworthy; Experience planning-only |
| Social / Economy / Sparkle / design* routes | Early / not implemented — do not treat as product |
| Docs | Synced to 2026-09-12 status report + this audit; Aug STATUS_REPORT is historical |
| Photo + measurement integrity | **Hardened** — Tree is photo SSOT (lock outside mirror); Edit Tree cannot write dims; Excel import reconciles history in-session |
| Highest remaining risk before new features | Economy/Social write-only fields; large uncommitted working tree |

---

## 2. Current application map

**Maturity legend:** Mature = Deep, production-solid · Functional = Usable end-to-end; thinner product depth · Partial = Works but generic / incomplete product · Early = Local/preview only or thin UI · Placeholder = Route/title only · Not implemented = No real domain/UI

| Module | Purpose | Status | Major capabilities | Known gaps |
| --- | --- | --- | --- | --- |
| Dashboard | Overview cards | Mature | Live trees/tasks/weather/alerts/collections/repotting cards | Quick Guides card still thin vs Knowledge CRUD |
| Trees | Library browse + workspace | Mature | CRUD, filters, Tree Workspace window, history print/export | — |
| Tree Detail / Edit | Overview + auto-save Edit | Mature | Hero, Current State, Health & Care, Next Work, Fertilization, Photos, Timeline, Pot two-layer, Social share card | Duplicated Found At / Identity markup; measurement edit path inconsistency |
| Shaping | Tree Detail segment | Functional | Persisted TreeShaping / areas / vision migration / history | Legacy design* routes reserved but viewless |
| Species Library | Knowledge profiles | Functional | ~19 species profiles + catalog detail | Name-matched to Reference Data — not ID-linked; limited coverage |
| Knowledge guides | Handbook / pots / soil / fertilizer / stratification | Mature | Static content-rich readers | — |
| Knowledge CRUD | Quick Guides / FAQ / Courses / Videos / Links | Functional | List/detail CRUD via KnowledgeResourceService | No seeded content — empty until grower adds |
| Tasks / Work | Horizons + Work types | Mature | Schedules, occurrences, edit/delete, Care/Task completion | Workshop Work browser exists but unshipped/orphaned |
| Garden | Trees + Collections group | Mature | Sidebar grouping | — |
| Collections | Manual + smart groups | Functional | Editor, membership, care watering section, smart collections | Logic lives inside TreeService — no CollectionService |
| Locations / Map | Places + MapKit | Mature | Locations list/detail, map layers, garden position | locationsMap / locationsGardens not shipped in sidebar (Map via detail) |
| Gardens (profile) | Geographic root | Functional | UserProfile gardens + GardensWorkspaceView | Hidden from sidebar; emptied by Empty Personal Library |
| Care | Watering / Fertilizing / etc. | Functional | Watering + Fertilizing engines; Repotting/Health/Seasonal/Today/Placement/Winter real task UIs with honesty lines | Today/Placement/Winter now sidebar-visible (tracking only); other GI engines empty stubs |
| Nursery — Seeds | Seed batches | Functional | **Seed Work** + **Overview** tabs; stratification tips + link to Knowledge → Seed Stratification | Photo for seed development not built |
| Cuttings / Air Layers / Grafting / Field Tree | Propagation projects | Functional | Shared tracker under sidebar **Propagation**; kind-specific stages/codes only. Field Tree = ground-grown material for later collection (renamed from Development). | Kind-specific product depth still optional |
| Yamadori | Trips + Finds | Mature | Collect, transfer, graduate, dedicated windows | — |
| Inventory — Pots | Pot inventory | Mature | List/detail, assign/unlink, brands, photos, status lifecycle | — |
| Inventory — Soil | Stock + mixes | Mature | Stocktake, mixes, volume formatting; Seeds context tag on mixes | — |
| Inventory — other stock | Wire/tools/etc. | Functional | Generic InventoryStockWorkspaceView per kind + Stock Report Excel | Generic UI across kinds |
| Media — Images | Gallery + crop | Mature | Gallery, Image Workspace, non-destructive crop, rotate; Import via Context Tools | Search/Sort still thin; mirror absent |
| Media — Docs/Video/Notes/Audio | Catalog records | Partial | MediaLibraryWorkspaceView list/detail/create | Notes/Audio hidden; little real file import/playback |
| Social | Opt-in + share levels | Early | Settings toggle; per-tree SocialShareLevel; Shared Trees preview; Contacts/Links via SimpleCatalog | Hidden from sidebar; no network sharing |
| Economy | Finance | Not implemented | Route enums only | Price fields on Tree/Pot have no consumer |
| Workshop | Work browser / calendar | Placeholder | WorkBrowserView exists for workshopWork but unshipped | Calendar/Tasks EmptyView |
| Settings | Profile, regional, RD, library | Mature | Reference Data, Brands, Library Management (export/import/empty), Social, Notifications | Experience **planning matrix** exists (not persisted / not gating) |
| Context Tools | Sidebar actions | Functional | Pinned panel; real create/import/report/edit actions; expandable Add Tree; Library vs Workspace groups | Right-click mirror parked; a few Coming Soon stubs may remain where no workflow exists |

---

## 3–7. Tree / Pot / SSOT / Workflow

Tree Detail / Edit / Pot tables from the 11 Sep audit still apply for product shape. Re-read [STATUS_AUDIT_2026-09-11.md](STATUS_AUDIT_2026-09-11.md) §§3–7 for those tables.

**Photo + measurement integrity (updated 2026-09-12):**

1. **Photos:** Tree fields are the source of truth. `TreePhotoIndex.json` is a rebuildable mirror. A separate `Database/TreePhotoSSOT.json` lock prevents a reset or restored old index from filling Trees again. Legacy empty-tree fill from the index runs at most once.
2. **Measurements:** Height / crown / nebari / trunk on Tree are a cache of the latest history row. Edit Tree does not write those fields. Add Measurement + `applyLatestMeasurement` is the write path. `reconcileMeasurementDimensions` runs at launch, library attach, and **immediately after Excel import**.

Older audit wording that treated both as open HIGH risks is outdated.

---

## 8. UI / information architecture

| Topic | Finding |
| --- | --- |
| Sidebar | Workspace: Dashboard → Tasks → Garden → Care → Nursery → Yamadori → Inventory · Library: Media → Knowledge · Settings via profile footer |
| Workspace titles | Main module pages use `.bonsaiWorkspaceNavigationTitle` (VStack chrome, not toolbar title) |
| Context Tools | Pinned below Workspace/Library lists; collapsible; icons/text share a fixed leading chevron column |
| Creates / reports | Belong in Context Tools — not window toolbar on workspace roots |
| Hidden but real | Social, Economy, Workshop, Notes/Audio |
| Detail patterns | Tree/Pot/Collection: View/Edit + auto-save; Locations map-centric; Knowledge guides are readers |

---

## 9. Design / product debt (max 15)

| Priority | Issue | Module | Why it matters | Future sprint |
| --- | --- | --- | --- | --- |
| DONE | Tree photo dual SSOT (overwrite on load) | Images/Trees | Mitigated: Tree SSOT + lock file outside mirror | — |
| DONE | Measurement cache vs Edit Tree draft writes | Trees | Mitigated: draft ignored; Add Measurement only; import reconciles | — |
| MEDIUM | Tree Pot Description never cleared when Inventory Pot assigned | Pots | Export/API consumers can see contradictory pot data | Pot clarity |
| MEDIUM | Collections logic inside TreeService | Collections | SRP / growth bottleneck | Collections service |
| MEDIUM | SpeciesProfile matched by name not ID | Knowledge | **Mitigated 2026-09-12** — profiles use frozen ``BotanicalKnowledgeIDs`` | — |
| MEDIUM | Generic NurseryPropagation for 4 kinds | Nursery | Product depth missing for real techniques | Nursery depth |
| MEDIUM | GI engines Environment/Placement/Recovery/Winter empty | Care | Architecture looks complete; growers get tracking only | Care intelligence |
| MEDIUM | Economy absent while price fields collected | Economy | Write-only economics data | Economy v1 or hide fields |
| MEDIUM | Social local-only + nav-hidden | Social | Share levels accumulate without network path | Park or ship preview |
| LOW | Dead design* routes + unused ModulePlaceholderView | Navigation | Noise for contributors | Nav cleanup |
| LOW | Media catalog island (weak Tree linking) | Media | Docs/videos not part of Tree story | Media v2 |
| LOW | Fertilization plan not persisted historically | Care | Cannot show “what we advised last time” | Care programs |
| LOW | Experience planning not persisted / not gating | Settings | Matrix is planning-only | Experience v1 |
| LOW | Migration accumulation | Core | Schema churn cost | Migration hygiene |
| DONE (2026-09) | Docs lag / Context Tools stale for Nursery–Media | Docs / Context Tools | Was misleading testers | Docs sync + Context Tools truth pass |

---

## 10. Completed vs remaining

### Major things now implemented

- Tree lifecycle with permanent identity lock
- Pot inventory lifecycle + Tree↔Pot sync
- Tasks + Schedules occurrence engine
- Yamadori trip/find lifecycle
- Seeds (Seed Work + Overview) + stratification knowledge in Knowledge
- Care Watering + Fertilizing advisory engines
- Soil stock / stocktake + inventory stock + Stock Report Excel
- Species Library (~19 profiles) + Handbook / guides
- Gallery + non-destructive crop + rotate
- Library export/import + Empty Personal Library
- Social opt-in + per-tree share levels (local)
- MapKit Locations with Garden Position SSOT
- **Context Tools truth pass** (Nursery create, Media import, stock report, etc.)
- **Workspace creates moved out of window toolbars** into Context Tools
- **Experience planning matrix** (Settings — planning only)

### Major things still missing

- Sparkle / in-app updates + notarized distribution pipeline
- Economy module (beyond price fields)
- Social network / sync (beyond local preview)
- Kind-specific Nursery depth (cuttings/graft/air layer)
- Care engines beyond watering/fertilizer
- SpeciesProfile ↔ Reference Data ID link
- CollectionService extraction
- Photo index / measurement SSOT cleanup (**hardened 2026-09-12**)
- Experience persist + sidebar gating
- Real Media file workflows (docs/video playback)
- Right-click mirror of Context Tools (parked)

---

## 11. Recommended roadmap (updated)

| Sprint | Purpose | Status |
| --- | --- | --- |
| 1 · Data integrity | Photo + measurement SSOT | **Hardened 2026-09-12** (lock file + import reconcile; keep watching) |
| 2 · Docs + tester pack | Align STATUS docs | **Done 2026-09-12** (this pass) |
| 3 · Context Tools pass | Match actions to real flows | **Done 2026-09** (truth pass + UX) |
| 4 · Species linking | ID-link SpeciesProfile to RD | **Done 2026-09-12** (frozen BotanicalKnowledgeIDs) |
| 5 · Collections service | Extract from TreeService | Open |
| 6 · Nursery depth decision | Kind-specific vs honest generic | Open — needs grower decision |
| 7 · Care intelligence | Real engines or “tracking only” labels | **Honesty labels shipped 2026-09-12**; engines beyond Watering/Fertilizing still open |
| 8 · Distribution + updates | Signed zip + Sparkle groundwork | Open |

---

## 12. STOP AND PAY ATTENTION

1. Prefer **STATUS_REPORT_2026-09-12** and **this audit** over STATUS_REPORT_2026-08-30 (historical).
2. Photo/measurement dual-write risks are **mitigated** in code (Tree photo SSOT lock file; Edit Tree cannot write dims; Excel import reconciles). Do not reopen unless a new bug appears.
3. Economy price fields and Social share levels still collect data without destination modules — decide keep-collecting vs park.
4. Do not expand right-click Context Tools unless the grower asks.
5. Large uncommitted working tree — backup / commit when the grower is ready.

---

## 13. Recent passes reflected here (Sep 2026)

- Context Tools Truth Pass + Image Workspace tools wiring
- Header toolbar cleanup → Context Tools for creates/reports
- Seeds: Seed Work + Overview only; stratification owned by Knowledge
- Experience planning matrix (Workspace / Library / Media package rows)
- Sidebar: pinned Context Tools, Library group, Add Tree expand-in-place, icon/text column alignment
- **Data integrity harden:** Tree photo SSOT lock in `Database/TreePhotoSSOT.json`; Excel import calls `reconcileMeasurementDimensions` in-session
