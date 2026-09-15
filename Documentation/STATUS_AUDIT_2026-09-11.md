# Bonsai World — Current Project Status Audit

> **Superseded by [STATUS_AUDIT_2026-09-12.md](STATUS_AUDIT_2026-09-12.md).** Kept as the detailed Tree/Pot/SSOT tables from the 11 Sep pass. Prefer the 12 Sep audit + [STATUS_REPORT_2026-09-12.md](STATUS_REPORT_2026-09-12.md) for current module maturity (Context Tools, Seeds, Experience planning, docs sync).

Generated from codebase audit 2026-09-11 · report only · no code changes.

Report only · inspected actual Swift codebase · documentation treated as secondary when it conflicts with code.

**Tags:** Audit only · Historical · Superseded 2026-09-12

---

## 1. Executive summary

**Snapshot:** Bonsai World is no longer a shell of empty sidebar routes. Trees, Pots, Tasks, Yamadori, Seeds, Care (shipped pages), Inventory stock, Species Library, and several Knowledge guides are real. Remaining gaps are uneven depth (generic Nursery propagation / Media catalogs), hidden modules (Social, Economy), double-storage risks (photos, measurements), and distribution/update infrastructure that is still unbuilt.

| Area | Verdict |
| --- | --- |
| Core Tree / Pot / Tasks / Yamadori | Mature — ready for grower testing |
| Care / Nursery / Inventory / Knowledge guides | Functional → Partial — usable, depth varies |
| Social / Economy / Sparkle updates / design* routes | Early / not implemented — do not treat as product |
| Docs (STATUS_REPORT Aug 2026, CHANGELOG) | Lag behind code — many “placeholders” are now real |
| Highest risk before new features | Tree photo index + measurement denormalization SSOT |

---

## 2. Current application map

**Maturity legend:** Mature = Deep, production-solid · Functional = Usable end-to-end; thinner product depth · Partial = Works but generic / incomplete product · Early = Local/preview only or thin UI · Placeholder = Route/title only · Not implemented = No real domain/UI

| Module | Purpose | Status | Major capabilities | Known gaps |
| --- | --- | --- | --- | --- |
| Dashboard | Overview cards | Mature | Live trees/tasks/weather/alerts/collections/repotting cards | Quick Guides card still treats Knowledge CRUD as empty |
| Trees | Library browse + workspace | Mature | CRUD, filters, Tree Workspace window, history print/export | — |
| Tree Detail / Edit | Overview + auto-save Edit | Mature | Hero, Current State, Health & Care, Next Work, Fertilization, Photos, Timeline, Pot two-layer, Social share card | Duplicated Found At / Identity markup; measurement edit path inconsistency |
| Shaping | Tree Detail segment | Functional | Persisted TreeShaping / areas / vision migration / history | Legacy design* routes reserved but viewless |
| Species Library | Knowledge profiles | Functional | ~14 species profiles + catalog detail | Name-matched to Reference Data — not ID-linked; limited coverage |
| Knowledge guides | Handbook / pots / soil / fertilizer / stratification | Mature | Static content-rich readers | — |
| Knowledge CRUD | Quick Guides / FAQ / Courses / Videos / Links | Functional | List/detail CRUD via KnowledgeResourceService | No seeded content — empty until grower adds |
| Tasks / Work | Horizons + Work types | Mature | Schedules, occurrences, edit/delete, Care/Task completion | Workshop Work browser exists but unshipped/orphaned |
| Garden | Trees + Collections group | Mature | Sidebar grouping | — |
| Collections | Manual + smart groups | Functional | Editor, membership, care watering section, smart collections | Logic lives inside TreeService — no CollectionService |
| Locations / Map | Places + MapKit | Mature | Locations list/detail, map layers, garden position | locationsMap / locationsGardens not shipped in sidebar (Map via detail) |
| Gardens (profile) | Geographic root | Functional | UserProfile gardens + GardensWorkspaceView | Hidden from sidebar; emptied by Empty Personal Library |
| Care | Watering / Fertilizing / etc. | Functional | Watering + Fertilizing engines; Repotting/Health/Seasonal real task UIs | Today/Placement/Winter built but nav-hidden; other GI engines empty stubs |
| Nursery — Seeds | Seed batches | Functional | Seed Work, Stratification, Overview, Germination tabs | — |
| Cuttings / Air Layers / Grafting / Development | Propagation projects | Partial | Shared NurseryPropagationWorkspaceView — CRUD, stages, Create Tree | One generic model for four kinds; thin kind-specific depth |
| Yamadori | Trips + Finds | Mature | Collect, transfer, graduate, dedicated windows | — |
| Inventory — Pots | Pot inventory | Mature | List/detail, assign/unlink, brands, photos, status lifecycle | — |
| Inventory — Soil | Stock + mixes | Mature | Stocktake, mixes, volume formatting | Separate soil component/mix routes folded into workspace |
| Inventory — other stock | Wire/tools/etc. | Functional | Generic InventoryStockWorkspaceView per kind + Stock Report Excel | Generic UI across kinds |
| Media — Images | Gallery + crop | Mature | Gallery, Image Workspace, non-destructive crop, rotate | Search/Sort still “coming soon”; mirror absent |
| Media — Docs/Video/Notes/Audio | Catalog records | Partial | MediaLibraryWorkspaceView list/detail/create | Notes/Audio hidden; little real file import/playback |
| Social | Opt-in + share levels | Early | Settings toggle; per-tree SocialShareLevel; Shared Trees preview; Contacts/Links via SimpleCatalog | Hidden from sidebar; no network sharing |
| Economy | Finance | Not implemented | Route enums only | Price fields on Tree/Pot have no consumer |
| Workshop | Work browser / calendar | Placeholder | WorkBrowserView exists for workshopWork but unshipped | Calendar/Tasks EmptyView |
| Settings | Profile, regional, RD, library | Mature | Reference Data, Brands, Library Management (export/import/empty), Social, Notifications | Experience Levels UI still missing |
| Context Tools | Sidebar actions | Functional | Rich real actions for Trees/Pots/Collections/Yamadori/Soil | Many .comingSoon stubs; Nursery catalog stale vs in-view New |

---

## 3. Tree system status

### Tree data

#### Direct Tree-owned

Identity (id, botanicalName, nickname, bonsaiName); botanical & classification IDs; healthStatus; fertilizerHealth / fertilizerKindOverride; locationID, soilMixID, potTypeID, lightConditionID; measurement cache (H/CW/NW/TD); Tree Pot Description dims; currentPotID; acquisition/disposal; notes / knownHistory; socialShareLevel; watering policy fields; vision / shaping; primaryImageID / imageIDs; created/modified.

#### Relationships

Reference Data IDs (genus/species/cultivar/style/stage/location/ soil/pot type/light/acquisition/disposal methods). Links: currentPotID, sourceYamadoriID, sourceSeedBatchID, carePolicyCollectionID, image IDs. Collections NOT on Tree — owned by Collection.treeIDs.

#### Derived / legacy

Derived: listImageID, hasPhoto, isInCare, hasDisposalRecord. Legacy: treeStatusID decode shim; unused fertilizerStage/Growth keys; vision retained after migration into shaping; projectIDs / taskIDs / journalEntryIDs declared but largely unused as SSOT.

### Tree Detail experience

| Mode / area | What exists | Notes |
| --- | --- | --- |
| View — Hero | Photo + identity + Current State + Species teaser | Mature |
| View — Row 1 | Photos, Collections, Additional Information | Additional Info not always draft-aware while editing |
| View — Social | Share level card | Gated by Settings Social |
| View — Row 2 | Health & Care, Next Work, Fertilization expandable | Health appears in hero chip and Health card |
| View — Found At / Timeline | Yamadori map + work timeline | Found At markup duplicated in Edit |
| Edit — 3 columns | Photos, Identity, Growing, Watering, Measurements \| Ownership, Known History, Collections, Pot, Fertilization \| Found At, Social, Notes | Auto-save via TreeDetailDraft |

**Tree Detail friction (not blockers):** Duplicated Found At and Identity implementations; Pot display name fallback duplicated vs TreeCurrentPotDisplay; Health surfaced twice; orphaned Tree.taskIDs / projectIDs fields.

---

## 4. Edit Tree audit

| Section | Editable | Assignable | Read-only | Derived | Managed elsewhere |
| --- | --- | --- | --- | --- | --- |
| Identity | Nickname | — | Bonsai/Botanical/Genus/Species/Cultivar (locked) | — | — |
| Growing | Style, Health, Stage, Size, Light, Soil Mix | Location | Garden label | Soil mix parts | — |
| Watering | Mode override, times/day | Care-policy Collection | Effective summary | Policy resolver | Collection care rules |
| Measurements | Add via history sheet | — | History rows | Formatting | TreeMeasurementHistoryStore |
| Ownership | Acquisition + disposal fields | Methods (RD) | — | Active/Disposed status | — |
| Collections | — | Manual membership sheet | Names/counts | — | Collection.treeIDs |
| Pot | Tree Pot Description type + dims | Inventory Pot Assign/Change/Remove | Inventory pot identity fields | — | PotService / Pot Detail |
| Fertilization | Kind override, Condition | — | Stage / mode titles | Plan text from GI | GrowingIntelligenceService |
| Found At | — | — | Find name + map | — | YamadoriService |
| Photos | Add/delete/rename/primary/dates | — | Reference images excluded | — | ImageService |
| Notes / Known History / Social | Yes (share level) | — | — | — | AppSettings Social gate |
| Tasks / Next Work | — | — | Upcoming rows | Occurrences | TaskService / WorkService |

### Read-only classification (A–F)

| Item | Class | Meaning |
| --- | --- | --- |
| Species / Botanical identity | A / C | Correct lock post-create; profile lookup is Reference/Knowledge |
| Location Garden label | C | Derived from Location → Garden — correct |
| Soil composition | C | Mix ID assignable; parts from Reference Data — correct |
| Fertilization plan | E | Computed advisory — correct architecture |
| Inventory Pot fields | F | Correct — PotService owns assignment and pot identity |
| Collections membership | F | Correct SSOT on Collection.treeIDs |
| Measurements latest on Tree | B / risk | Denormalized cache — applyDetailDraft can write without history |
| Tasks | D | Correct — TaskService owns; Tree.taskIDs unused as read path |
| Yamadori Found At | F | Correct — link only |
| Photos metadata | D | ImageService owns bytes/names |

---

## 5. Pot system status

| Layer | Fields / behavior | Verified |
| --- | --- | --- |
| Tree Pot Description | potTypeID + L/W/H/D on Tree; editable in PotSection even when inventory pot assigned (shown as fallback) | Yes |
| Inventory Pot | Tree.currentPotID ↔ Pot.linkedTreeID; PotService.assignPot / unassignCurrentPot; Assign/Change/Remove from Tree + Pot Detail | Yes — PotService is sole sync owner |
| Display priority | TreeCurrentPotDisplay.resolve: Inventory → Tree Description → none | Consistent in Overview Current State, Tree list, Tree History; Edit shows both layers stacked |

**Inconsistency (maintenance, not wrong UX):** Edit PotSection reimplements inventory title fallback instead of always calling TreeCurrentPotDisplay — risk of drift, not wrong priority.

---

## 6. Single source of truth audit

| Domain | SSOT | Primary service | Edited | Displayed |
| --- | --- | --- | --- | --- |
| Tree | Tree / Trees.json | TreeService | New Tree + Detail Edit | Lists, Detail, Dashboard |
| Species (identity) | Genus/Species/Cultivar RD | BotanicalService / RD Manager | Settings Botanical Library | Trees, lists |
| Species (knowledge) | SpeciesProfile Swift catalogs | Static catalog | Code-authored profiles | Species Library |
| Pot | Pot / Pots.json | PotService | Pot Detail | Inventory + Tree Pot section |
| Soil Mix | SoilMix RD | ReferenceData* | Settings | Tree Growing, Care |
| Location | LocationReference | ReferenceData* | Locations editors | Map, Trees, Care |
| Collection | Collection.treeIDs | TreeService (embedded) | Collection Detail | Collections, filters |
| Work | WorkRecord | WorkService | Add Work / complete task | Timeline, Care |
| Task | CareTask + CareSchedule | TaskService | Task sheets | Tasks, Next Work |
| Measurement | TreeMeasurementHistory.json | TreeMeasurementHistoryStore | Add measurement | History + Tree cache fields |
| Fertilization plan | Computed (not stored) | GrowingIntelligenceService | Inputs on Tree only | Care + Tree Fertilization |
| Images | Images/Catalog.json (+ presentations) | ImageService | Photo managers / Crop | Galleries |
| Yamadori Find | Yamadori + Find | YamadoriService | Yamadori Detail | Nursery Yamadori |

**Double storage (verified):**

1. TreePhotoIndex.json overwrites Tree.primaryImageID/imageIDs on load while Trees.json also persists those fields.
2. Tree height/crown/nebari/trunk are denormalized from measurement history; applyDetailDraft can write them without appending history.

---

## 7. Workflow audit

### Tree lifecycle

| Workflow | Status |
| --- | --- |
| Create / View / Edit Tree | Complete |
| Add Photo / Activity / Measurement | Mostly complete (measurement sync caveat) |
| Manage Pot / Location / Soil / Collections | Complete |
| View Species knowledge | Mostly complete (coverage + name match) |

### Pot lifecycle

| Workflow | Status |
| --- | --- |
| Create / Edit Pot | Complete |
| Assign / Change / Remove / Return to Available | Complete |

### Care

| Workflow | Status |
| --- | --- |
| See health / upcoming work / complete work | Mostly complete |
| Fertilization recommendation + record work | Mostly complete (advisory; no plan history) |
| Placement / Winter / Seasonal “intelligence” | Partial — tracking UIs; engines empty |

### Nursery

| Workflow | Status |
| --- | --- |
| Seeds | Mostly complete |
| Yamadori | Complete |
| Cuttings / Air Layers / Grafting / Development | Partial — shared generic project |

---

## 8. UI / information architecture

| Topic | Finding |
| --- | --- |
| Sidebar | Coherent: Dashboard → Tasks → Garden → Care → Nursery → Inventory → Media → Knowledge; Settings via profile footer |
| Hidden but real | Social, Economy, Workshop, some Care pages, Notes/Audio — searchable Social only |
| Duplicate entry points | Nursery create exists in-view while Context Tools still shows Coming Soon for Nursery |
| Context Tools | Intended action home for Trees/Pots/Collections/Yamadori — yes; incomplete for Nursery/Media Import/Workshop |
| Detail patterns | Tree/Pot/Collection share View/Edit + auto-save pattern; Locations use map-centric detail; Knowledge guides are readers |

---

## 9. Design / product debt (max 15)

| Priority | Issue | Module | Why it matters | Future sprint |
| --- | --- | --- | --- | --- |
| HIGH | Tree photo dual SSOT (Trees.json + TreePhotoIndex) | Images/Trees | Silent drift / photo loss risk on load overwrite | Data integrity |
| HIGH | Measurement cache vs history write paths diverge | Trees | Card height ≠ timeline if edit draft writes dims | Data integrity |
| HIGH | Docs claim placeholders where code is real | Docs | Misleads roadmap and tester expectations | Docs sync |
| MEDIUM | Tree Pot Description never cleared when Inventory Pot assigned | Pots | Export/API consumers can see contradictory pot data | Pot clarity |
| MEDIUM | Collections logic inside TreeService | Collections | SRP / growth bottleneck | Collections service |
| MEDIUM | SpeciesProfile matched by name not ID | Knowledge | Rename orphans knowledge | Species linking |
| MEDIUM | Generic NurseryPropagation for 4 kinds | Nursery | Product depth missing for real techniques | Nursery depth |
| MEDIUM | GI engines Environment/Placement/Recovery/Winter empty | Care | Architecture looks complete; growers get tracking only | Care intelligence |
| MEDIUM | Economy absent while price fields collected | Economy | Write-only economics data | Economy v1 or hide fields |
| MEDIUM | Social local-only + nav-hidden | Social | Share levels accumulate without network path | Park or ship preview |
| MEDIUM | Context Tools stale for Nursery / Media Import | Context Tools | Action home incomplete | Context Tools pass |
| LOW | Dead design* routes + unused ModulePlaceholderView | Navigation | Noise for contributors | Nav cleanup |
| LOW | Media catalog island (weak Tree linking) | Media | Docs/videos not part of Tree story | Media v2 |
| LOW | Fertilization plan not persisted historically | Care | Cannot show “what we advised last time” | Care programs |
| LOW | Migration accumulation | Core | Schema churn cost | Migration hygiene |

---

## 10. Completed vs remaining

### Major things now implemented

- Tree lifecycle with permanent identity lock
- Pot inventory lifecycle + Tree↔Pot sync
- Tasks + Schedules occurrence engine
- Yamadori trip/find lifecycle
- Seeds + stratification knowledge
- Care Watering + Fertilizing advisory engines
- Soil stock / stocktake + inventory stock + Stock Report Excel
- Species Library + Handbook / guides
- Gallery + non-destructive crop + rotate
- Library export/import + Empty Personal Library
- Social opt-in + per-tree share levels (local)
- MapKit Locations with Garden Position SSOT

### Major things still missing

- Sparkle / in-app updates + notarized distribution pipeline
- Economy module (beyond price fields)
- Social network / sync (beyond local preview)
- Kind-specific Nursery depth (cuttings/graft/air layer)
- Care engines beyond watering/fertilizer
- SpeciesProfile ↔ Reference Data ID link
- CollectionService extraction
- Photo index / measurement SSOT cleanup
- Experience Levels / Workspace Profiles
- Real Media file workflows (docs/video playback)

---

## 11. Recommended roadmap (max 8 sprints)

| Sprint | Purpose | Why now | In scope | Out of scope | Outcome |
| --- | --- | --- | --- | --- | --- |
| 1 · Data integrity | Collapse photo + measurement SSOT risks | Highest silent-bug risk | Photo index decision; single measurement write path | New features | One write path for photos & latest dims |
| 2 · Docs + tester pack | Align STATUS docs; optional Release zip guide | Owner/tester mismatch | Doc refresh; manual zip instructions | Sparkle | Honest map for testing week |
| 3 · Context Tools pass | Match sidebar actions to real create flows | Action home incomplete | Nursery/Media Import real actions; drop dead coming-soon | New modules | Context Tools trustworthy |
| 4 · Species linking | ID-link SpeciesProfile to RD Species | Knowledge fragile under renames | Stored speciesID(/cultivarID) on profiles | New species content | Rename-safe knowledge |
| 5 · Collections service | Extract CollectionService from TreeService | TreeService already oversized | Move CRUD/smart/care-policy | UI redesign | Cleaner ownership |
| 6 · Nursery depth decision | Kind-specific fields or explicit generic product | Four labels, one model | Grower decision + implement | Social network | Honest Nursery product |
| 7 · Care intelligence | Build or relabel Placement/Winter/etc. | Expectation gap | Real engines OR in-product “tracking only” | Economy | No false intelligence |
| 8 · Distribution + updates | Release packaging + Sparkle groundwork | Friend testing / updates planned | Signed zip path; Sparkle check on launch + Settings | App Store | Testable update channel |

---

## 12. STOP AND PAY ATTENTION

**Resolve before significant new features:**

1. TreePhotoIndex vs Trees.json photo fields — active dual write + overwrite on load.
2. Measurement history vs Tree dimension fields — applyDetailDraft can update dims without history rows.
3. Do not treat STATUS_REPORT “placeholder” language as current — Care, Nursery, Inventory, Library Management, Tasks edit/delete, and Gallery rotate are ahead of that document.
4. Economy price fields and Social share levels are collecting data without their destination modules shipped — decide keep-collecting vs park.

---

## 13. Files inspected (representative)

AppNavigation.swift · ContentView.swift · SidebarView.swift · Tree.swift · TreeDetailView.swift · TreeDetailDraft.swift · TreeOverviewPresence.swift · TreeService.swift · TreeCurrentPotDisplay.swift · Pot.swift · PotService.swift · PotSection.swift · TreeAssignPotSheet.swift · Collection.swift · AppState.swift · ContextQuickActionsCatalog.swift · GrowingIntelligenceService.swift · FertilizerEngine.swift · WateringEngine.swift · Environment/Placement/Recovery/Winter engines · NurseryPropagation* · SeedBatch* · Yamadori* · Care* views · MediaLibrary* · KnowledgeResource* · SocialShareLevel.swift · SocialSharedTreesWorkspaceView.swift · SimpleCatalogWorkspaceView.swift · LibraryManagementView.swift · LibraryEmptyPersonalService.swift · TreePhotoIndexStore.swift · TreeMeasurementHistoryStore.swift · ModulePlaceholderView.swift · Library.swift · Documentation/STATUS_REPORT_2026-08-30.md (conflict check only)

**Correction vs one exploratory pass:** Social Contacts/Links are Functional v1 via SimpleCatalogWorkspaceView (searchable while hidden), not viewless.
