//
//  ContextQuickActionsCatalog.swift
//  Bonsai World
//
//  World-specific Context Quick Actions per AppRoute (Architecture Version 2).
//  Trees / Pots / Yamadori creates live here (not Global). Search stays Global.
//

import Foundation

enum ContextQuickActionsCatalog {
    static let newCollectionID = "context.collection.newCollection"
    static let addTreeToCollectionID = "context.collection.addTree"
    static let editCollectionID = "context.collection.editCollection"
    static let deleteCollectionID = "context.collection.deleteCollection"
    static let finishCollectionEditID = "context.collection.finish"
    static let newLocationID = "context.locations.newLocation"
    static let cropPhotoID = "context.media.cropPhoto"
    static let deleteImageID = "context.media.deleteImage"
    static let importPhotosID = "context.media.importPhotos"
    static let nurseryNewItemID = "context.nursery.newItem"
    static let editNurseryPropagationID = "context.nursery.edit"
    static let finishNurseryPropagationEditID = "context.nursery.finish"
    static let showAllNurseryProjectsID = "context.nursery.showAll"
    static let editFieldTreeID = "context.fieldTree.edit"
    static let finishFieldTreeEditID = "context.fieldTree.finish"
    static let addFieldTreeTaskID = "context.fieldTree.addTask"

    // Seeds — batch selected (mirrors Seed Batch Detail → Actions)
    static let seedStartStratificationID = "context.seeds.startStratification"
    static let seedSkipToReadyToSowID = "context.seeds.skipToReadyToSow"
    static let seedCompleteCurrentPhaseID = "context.seeds.completeCurrentPhase"
    static let seedExtendPhaseID = "context.seeds.extendPhase"
    static let seedChangeTimeID = "context.seeds.changeTime"
    static let seedRecordSowingID = "context.seeds.recordSowing"
    static let seedRecordGerminationID = "context.seeds.recordGermination"
    static let seedUpdateSurvivalID = "context.seeds.updateSurvival"
    static let seedSeparateSeedlingsID = "context.seeds.separateSeedlings"
    static let seedCreateTreesID = "context.seeds.createTrees"
    static let seedMarkFailedID = "context.seeds.markFailed"
    static let seedShowAllBatchesID = "context.seeds.showAllBatches"

    // Trees — view (tree selected)
    static let editTreeID = "context.trees.editTree"
    static let addActivityID = "context.trees.addActivity"
    static let addImageID = "context.trees.addImage"
    static let viewImagesID = "context.trees.viewImages"
    static let showOnMapID = "context.trees.showOnMap"
    static let openTreeWorkspaceID = "context.trees.openTreeWorkspace"
    static let duplicateTreeID = "context.trees.duplicateTree"
    static let deleteTreeID = "context.trees.deleteTree"
    static let returnToCareID = "context.trees.returnToCare"
    static let addMeasurementID = "context.trees.addMeasurement"
    static let addJournalID = "context.trees.addJournal"
    static let viewTreeHistoryID = "context.trees.viewTreeHistory"
    static let addToFavoriteTreesID = "context.trees.addToFavoriteTrees"
    static let removeFromFavoriteTreesID = "context.trees.removeFromFavoriteTrees"

    // Trees — edit mode (Auto Save; Finish leaves Edit Mode — standard for future editors)
    static let cancelTreeEditID = "context.trees.cancel"

    // Pots — view (pot selected)
    static let editPotID = "context.pots.editPot"
    static let addPotImageID = "context.pots.addImage"
    static let markPotSoldID = "context.pots.markSold"
    static let markPotBrokenID = "context.pots.markBroken"
    static let markPotRetiredID = "context.pots.markRetired"
    static let returnPotToAvailableID = "context.pots.returnToAvailable"
    static let deletePotID = "context.pots.deletePot"

    // Pots — edit mode
    static let cancelPotEditID = "context.pots.cancel"

    static let addSoilID = "context.soil.addSoil"
    static let newSoilMixID = "context.soil.newMix"
    static let startSoilStocktakeID = "context.soil.startStocktake"
    static let stockReportID = "context.inventory.stockReport"
    static let soilGuidesID = "context.soil.openGuides"
    static let addInventoryStockID = "context.inventory.addStock"
    static let exportStockReportID = "context.inventory.exportStockReport"
    static let newGardenID = "context.locations.newGarden"
    static let newTaskID = "context.tasks.newTask"
    static let manageSchedulesID = "context.tasks.manageSchedules"
    static let completeAllTasksID = "context.tasks.completeAll"
    static let addMediaLibraryItemID = "context.media.addLibraryItem"
    static let addKnowledgeResourceID = "context.knowledge.addResource"
    static let addSimpleCatalogEntryID = "context.catalog.addEntry"

    // Yamadori — view
    static let editYamadoriID = "context.yamadori.edit"
    static let addYamadoriFindID = "context.yamadori.addFind"
    static let addYamadoriObservationID = "context.yamadori.addObservation"
    static let addYamadoriImageID = "context.yamadori.addImage"
    static let advanceYamadoriStatusID = "context.yamadori.advanceStatus"
    static let markYamadoriCollectedID = "context.yamadori.markCollected"
    static let transferYamadoriToTreeID = "context.yamadori.transferToTree"
    static let abandonYamadoriID = "context.yamadori.abandon"
    static let archiveYamadoriID = "context.yamadori.archive"
    static let deleteYamadoriID = "context.yamadori.delete"
    static let cancelYamadoriEditID = "context.yamadori.cancel"

    /// Context for Trees Quick Actions (selection + interaction mode).
    struct TreesContext: Hashable, Sendable {
        var selectedTreeID: UUID?
        var interactionMode: TreeDetailInteractionMode
        /// Former Trees (not in care) are view-only — no Edit / Add Photo.
        var isInCare: Bool = true
        var isFavorite: Bool = false
        /// Dedicated Tree Workspace window — hide “Open Tree Workspace” there.
        var isTreeWorkspaceWindow: Bool = false

        static let none = TreesContext(
            selectedTreeID: nil,
            interactionMode: .viewing,
            isInCare: true,
            isFavorite: false,
            isTreeWorkspaceWindow: false
        )
    }

    /// Context for Collections Quick Actions (selection + interaction mode).
    struct CollectionsContext: Hashable, Sendable {
        var selectedCollectionID: UUID?
        var selectedCollectionIsManual: Bool
        var interactionMode: TreeDetailInteractionMode

        static let none = CollectionsContext(
            selectedCollectionID: nil,
            selectedCollectionIsManual: false,
            interactionMode: .viewing
        )
    }

    /// Placeholder / module actions for the selected route.
    /// Context for Pots Quick Actions (selection + interaction mode + status).
    struct PotsContext: Hashable, Sendable {
        var selectedPotID: UUID?
        var interactionMode: TreeDetailInteractionMode
        var status: PotStatus?

        static let none = PotsContext(selectedPotID: nil, interactionMode: .viewing, status: nil)
    }

    struct YamadoriContext: Hashable, Sendable {
        var selectedYamadoriID: UUID?
        var selectedYamadoriFindID: UUID?
        var interactionMode: TreeDetailInteractionMode
        var status: YamadoriStatus?

        static let none = YamadoriContext(
            selectedYamadoriID: nil,
            selectedYamadoriFindID: nil,
            interactionMode: .viewing,
            status: nil
        )
    }

    struct FieldTreeContext: Hashable, Sendable {
        var selectedProjectID: UUID?
        var interactionMode: TreeDetailInteractionMode

        static let none = FieldTreeContext(selectedProjectID: nil, interactionMode: .viewing)
    }

    struct VegetativePropagationContext: Hashable, Sendable {
        var selectedProjectID: UUID?
        var interactionMode: TreeDetailInteractionMode
        var singularTitle: String

        static let none = VegetativePropagationContext(
            selectedProjectID: nil,
            interactionMode: .viewing,
            singularTitle: "Project"
        )
    }

    struct SeedsContext: Hashable, Sendable {
        var selectedBatchID: UUID?
        var stage: SeedBatchStage?
        /// When true, Create Trees is offered (same gate as Seed Batch Detail).
        var canCreateTrees: Bool = false

        static let none = SeedsContext(selectedBatchID: nil, stage: nil, canCreateTrees: false)
    }

    static func actions(
        for section: AppRoute?,
        treesContext: TreesContext = .none,
        collectionsContext: CollectionsContext = .none,
        potsContext: PotsContext = .none,
        yamadoriContext: YamadoriContext = .none,
        fieldTreeContext: FieldTreeContext = .none,
        vegetativeContext: VegetativePropagationContext = .none,
        seedsContext: SeedsContext = .none,
        mediaSelectedImageID: UUID? = nil
    ) -> [ActionDefinition] {
        guard let section else { return [] }

        switch section {
        case .dashboard:
            // Tasks owns Today / overdue / upcoming. No Dashboard-only task shortcuts.
            return []

        case .locationsPlaces, .locationsMap:
            return [
                ActionDefinition(
                    id: ContextQuickActionsCatalog.newLocationID,
                    title: "Add Location",
                    systemImage: "mappin.and.ellipse",
                    availability: .available,
                    help: "Create a Location in Reference Data"
                )
            ]

        case .locationsGardens:
            return [
                ActionDefinition(
                    id: newGardenID,
                    title: "Add Garden",
                    systemImage: "leaf.circle",
                    availability: .available,
                    help: "Add a garden to your profile"
                )
            ]

        case .gardenCollections:
            return collectionsActions(collectionsContext)

        case .gardenTrees, .shaping:
            return treesModuleActions(treesContext)

        case .inventoryPots:
            return potsModuleActions(potsContext) + [
                ActionDefinition(
                    id: stockReportID,
                    title: "Stock Report",
                    systemImage: "chart.bar.doc.horizontal",
                    availability: .available,
                    help: "Open the inventory stock report"
                )
            ]

        case .inventorySoil, .inventorySoilComponents, .inventorySoilMixes:
            return [
                ActionDefinition(
                    id: addSoilID,
                    title: "Add Soil",
                    systemImage: "plus",
                    availability: .available,
                    help: "Add a catalog soil type to stock with bag counts"
                ),
                ActionDefinition(
                    id: newSoilMixID,
                    title: "Add Mix",
                    systemImage: "list.bullet.rectangle",
                    availability: .available,
                    help: "Create a soil mix recipe"
                ),
                ActionDefinition(
                    id: startSoilStocktakeID,
                    title: "Start Stocktake",
                    systemImage: "checklist",
                    availability: .available,
                    help: "Count physical soil stock and set a new baseline"
                ),
                ActionDefinition(
                    id: stockReportID,
                    title: "Stock Report",
                    systemImage: "chart.bar.doc.horizontal",
                    availability: .available,
                    help: "Open the inventory stock report"
                ),
                ActionDefinition(
                    id: soilGuidesID,
                    title: "Soil & Substrate",
                    systemImage: "book",
                    availability: .available,
                    help: "Open Bonsai Handbook → Soil & Substrate"
                )
            ]

        case .inventoryWire, .inventoryTools, .inventoryChemicals,
             .inventoryConsumables, .inventoryFertilizers:
            let kind = InventoryStockKind.kind(for: section) ?? .wire
            return [
                ActionDefinition(
                    id: addInventoryStockID,
                    title: kind.addButtonTitle,
                    systemImage: "plus",
                    availability: .available,
                    help: "Add a stock line"
                ),
                ActionDefinition(
                    id: stockReportID,
                    title: "Stock Report",
                    systemImage: "chart.bar.doc.horizontal",
                    availability: .available,
                    help: "Open the inventory stock report"
                )
            ]

        case .inventoryStockReport:
            return [
                ActionDefinition(
                    id: exportStockReportID,
                    title: "Export Excel",
                    systemImage: "square.and.arrow.up",
                    availability: .available,
                    help: "Export the stock report as Excel"
                )
            ]

        case .nurseryYamadori:
            if treesContext.selectedTreeID != nil {
                // Tree tools only — Add Tree stays on Trees, not Yamadori.
                return treesActions(treesContext)
            }
            return yamadoriModuleActions(yamadoriContext)

        case .mediaImages:
            return mediaImagesActions(selectedImageID: mediaSelectedImageID)

        case .mediaDocuments, .mediaNotes, .mediaVideo, .mediaAudio:
            let kind: MediaLibraryKind = switch section {
            case .mediaDocuments: .document
            case .mediaNotes: .note
            case .mediaVideo: .video
            default: .audio
            }
            return [
                ActionDefinition(
                    id: addMediaLibraryItemID,
                    title: "Add \(kind.singularTitle)",
                    systemImage: "plus",
                    availability: .available,
                    help: "Add a \(kind.singularTitle.lowercased()) to the library"
                )
            ]

        case .knowledgeQuickGuides, .knowledgeFAQ, .knowledgeCourses,
             .knowledgeVideos, .knowledgeExternalLinks:
            let kind: KnowledgeResourceKind = switch section {
            case .knowledgeQuickGuides: .quickGuide
            case .knowledgeFAQ: .faq
            case .knowledgeCourses: .course
            case .knowledgeVideos: .videoTutorial
            default: .externalLink
            }
            return [
                ActionDefinition(
                    id: addKnowledgeResourceID,
                    title: "Add \(kind.singularTitle)",
                    systemImage: "plus",
                    availability: .available,
                    help: "Add a \(kind.singularTitle.lowercased())"
                )
            ]

        case .workshopCalendar, .workshopTasks,
             .economyPurchases, .economySales, .economyExpenses, .economyIncome,
             .economyTreeValue, .economyPotValue, .economyInventoryValue, .economyReports,
             .socialContacts, .socialLinks:
            let kind = SimpleCatalogKind.allCases.first { $0.route == section }
            let title = kind.map { "Add \($0.title)" } ?? "Add"
            return [
                ActionDefinition(
                    id: addSimpleCatalogEntryID,
                    title: title,
                    systemImage: "plus",
                    availability: .available,
                    help: "Create a new entry"
                )
            ]

        case .workshopWork:
            return []

        case .tasksOverdue, .tasksToday, .tasksThisWeek, .tasksThisMonth, .tasksThisYear, .tasksNextYear:
            return [
                ActionDefinition(
                    id: newTaskID,
                    title: "New Task",
                    systemImage: "plus",
                    availability: .available,
                    help: "Schedule a new task"
                ),
                ActionDefinition(
                    id: manageSchedulesID,
                    title: "Manage Schedules",
                    systemImage: "repeat",
                    availability: .available,
                    help: "View, pause, or delete recurring schedules"
                ),
                ActionDefinition(
                    id: completeAllTasksID,
                    title: "Complete All",
                    systemImage: "checkmark.circle",
                    availability: .available,
                    help: "Complete every instant task due in this horizon"
                )
            ]

        case .nurserySeeds:
            return seedsActions(seedsContext)

        case .nurseryCuttings, .nurseryAirLayers, .nurseryGrafting, .nurseryFieldTree:
            let kind: NurseryPropagationKind = switch section {
            case .nurseryCuttings: .cutting
            case .nurseryAirLayers: .airLayer
            case .nurseryGrafting: .grafting
            default: .fieldTree
            }
            if kind != .fieldTree, vegetativeContext.interactionMode == .editing,
               vegetativeContext.selectedProjectID != nil {
                return [
                    ActionDefinition(
                        id: finishNurseryPropagationEditID,
                        title: "Finish",
                        systemImage: "checkmark.circle",
                        availability: .available,
                        help: "Leave Edit Mode"
                    )
                ]
            }
            var actions: [ActionDefinition] = [
                ActionDefinition(
                    id: nurseryNewItemID,
                    title: "New \(kind.singularTitle)",
                    systemImage: "leaf.arrow.triangle.circlepath",
                    availability: .available,
                    help: "Create a nursery project — same as New in this workspace"
                )
            ]
            if kind != .fieldTree {
                actions.append(contentsOf: vegetativeActions(vegetativeContext, kind: kind))
            }
            if section == .nurseryFieldTree {
                actions.append(contentsOf: fieldTreeActions(fieldTreeContext))
            }
            return actions

        case .settings:
            return []

        default:
            return []
        }
    }

    private static func mediaImagesActions(selectedImageID: UUID?) -> [ActionDefinition] {
        [
            ActionDefinition(
                id: importPhotosID,
                title: "Import Photos",
                systemImage: "photo.badge.plus",
                availability: .available,
                help: "Import a photo from Finder into the library"
            ),
            ActionDefinition(
                id: cropPhotoID,
                title: "Crop",
                systemImage: "crop",
                availability: selectedImageID == nil
                    ? .disabled(reason: "Select an image first")
                    : .available,
                help: "Crop the display of this photo. The original file is not changed."
            ),
            ActionDefinition(
                id: deleteImageID,
                title: "Delete Image",
                systemImage: "trash",
                availability: selectedImageID == nil
                    ? .disabled(reason: "Select an image first")
                    : .available,
                help: "Remove this image from the library"
            )
        ]
    }

    private static func addTreeMenuAction() -> ActionDefinition {
        ActionDefinition(
            id: GlobalQuickActionsCatalog.addTreeMenuID,
            title: "Add Tree",
            systemImage: "leaf",
            availability: .available,
            help: "Add a blank tree or duplicate tree info from an existing one",
            children: [
                ActionDefinition(
                    id: GlobalQuickActionsCatalog.newTreeID,
                    title: "Blank Tree",
                    systemImage: "leaf",
                    availability: .available,
                    help: "Add a tree from a blank form"
                ),
                ActionDefinition(
                    id: GlobalQuickActionsCatalog.copyExistingTreeID,
                    title: "Duplicate Tree Info",
                    systemImage: "plus.square.on.square",
                    availability: .available,
                    help: "New Bonsai Name; botanics, placement, pot, and acquisition from a tree in My Trees"
                )
            ]
        )
    }

    private static func addPotAction() -> ActionDefinition {
        ActionDefinition(
            id: GlobalQuickActionsCatalog.newPotID,
            title: "Add Pot",
            systemImage: "circle.dashed",
            availability: .available,
            help: "Add a pot to your inventory"
        )
    }

    private static func addYamadoriAction() -> ActionDefinition {
        ActionDefinition(
            id: GlobalQuickActionsCatalog.newYamadoriID,
            title: "Add Yamadori",
            systemImage: "mountain.2",
            availability: .available,
            help: "Start a wild-material Yamadori project"
        )
    }

    /// Trees / Shaping workspace — Add Tree always (except Edit Mode).
    private static func treesModuleActions(_ context: TreesContext) -> [ActionDefinition] {
        if context.interactionMode == .editing, context.selectedTreeID != nil {
            return treesActions(context)
        }
        var actions = [addTreeMenuAction()]
        actions.append(contentsOf: treesActions(context))
        return actions
    }

    /// Pots workspace — Add Pot always (except Edit Mode).
    private static func potsModuleActions(_ context: PotsContext) -> [ActionDefinition] {
        if context.interactionMode == .editing, context.selectedPotID != nil {
            return potsActions(context)
        }
        var actions = [addPotAction()]
        actions.append(contentsOf: potsActions(context))
        return actions
    }

    /// Yamadori workspace — Add Yamadori always (except Edit Mode).
    private static func yamadoriModuleActions(_ context: YamadoriContext) -> [ActionDefinition] {
        if context.interactionMode == .editing, context.selectedYamadoriID != nil {
            return yamadoriActions(context)
        }
        var actions = [addYamadoriAction()]
        actions.append(contentsOf: yamadoriActions(context))
        return actions
    }

    /// Seeds workspace — New Seed Batch + stage Actions when a batch is selected.
    private static func seedsActions(_ context: SeedsContext) -> [ActionDefinition] {
        var actions: [ActionDefinition] = [
            ActionDefinition(
                id: nurseryNewItemID,
                title: "New Seed Batch",
                systemImage: "leaf.arrow.triangle.circlepath",
                availability: .available,
                help: "Add a seed batch — same as New Seed Batch in Seed Work"
            )
        ]
        guard context.selectedBatchID != nil, let stage = context.stage else {
            return actions
        }

        actions.append(
            ActionDefinition(
                id: seedShowAllBatchesID,
                title: "All Batches",
                systemImage: "list.bullet",
                availability: .available,
                help: "Clear selection and show the batch list"
            )
        )

        if stage == .planned {
            actions.append(contentsOf: [
                ActionDefinition(
                    id: seedStartStratificationID,
                    title: "Start Stratification",
                    systemImage: "thermometer.snowflake",
                    availability: .available,
                    help: "Begin stratification for this batch"
                ),
                ActionDefinition(
                    id: seedSkipToReadyToSowID,
                    title: "Skip to Ready to Sow",
                    systemImage: "forward.fill",
                    availability: .available,
                    help: "Skip stratification and mark ready to sow"
                )
            ])
        }
        if stage == .stratifying {
            actions.append(contentsOf: [
                ActionDefinition(
                    id: seedCompleteCurrentPhaseID,
                    title: "Complete Current Phase",
                    systemImage: "checkmark.circle",
                    availability: .available,
                    help: "Finish the current treatment phase"
                ),
                ActionDefinition(
                    id: seedChangeTimeID,
                    title: "Change Time…",
                    systemImage: "calendar",
                    availability: .available,
                    help: "Set how many days this phase should run"
                ),
                ActionDefinition(
                    id: seedExtendPhaseID,
                    title: "Extend Phase +7 Days",
                    systemImage: "calendar.badge.plus",
                    availability: .available,
                    help: "Extend the current treatment by seven days"
                )
            ])
        }
        if stage == .readyToSow || stage == .stratifying {
            actions.append(
                ActionDefinition(
                    id: seedRecordSowingID,
                    title: "Record Sowing",
                    systemImage: "leaf",
                    availability: .available,
                    help: "Record that seeds were sown"
                )
            )
        }
        if stage == .sown || stage == .germinating {
            actions.append(
                ActionDefinition(
                    id: seedRecordGerminationID,
                    title: "Record Germination",
                    systemImage: "sparkles",
                    availability: .available,
                    help: "Record germination counts"
                )
            )
        }
        if stage == .germinating || stage == .seedling || stage == .developing {
            actions.append(contentsOf: [
                ActionDefinition(
                    id: seedUpdateSurvivalID,
                    title: "Update Survival",
                    systemImage: "heart.text.square",
                    availability: .available,
                    help: "Update surviving seedling count"
                ),
                ActionDefinition(
                    id: seedSeparateSeedlingsID,
                    title: "Separate Seedlings",
                    systemImage: "arrow.triangle.branch",
                    availability: .available,
                    help: "Record seedling separation"
                )
            ])
        }
        if context.canCreateTrees {
            actions.append(
                ActionDefinition(
                    id: seedCreateTreesID,
                    title: "Create Trees",
                    systemImage: "tree",
                    availability: .available,
                    help: "Create Tree records from selected seedlings"
                )
            )
        }
        actions.append(
            ActionDefinition(
                id: seedMarkFailedID,
                title: "Mark Failed",
                systemImage: "xmark.circle",
                availability: .available,
                help: "Mark this seed batch as failed"
            )
        )
        return actions
    }

    private static func collectionsActions(_ context: CollectionsContext) -> [ActionDefinition] {
        switch context.interactionMode {
        case .editing:
            return [
                ActionDefinition(
                    id: finishCollectionEditID,
                    title: "Finish",
                    systemImage: "checkmark.circle",
                    availability: .available,
                    help: "Leave Edit Mode"
                )
            ]
        case .viewing:
            var actions: [ActionDefinition] = [
                ActionDefinition(
                    id: newCollectionID,
                    title: "Add Collection",
                    systemImage: "plus.square.on.square",
                    availability: .available,
                    help: "Create an organizational group of trees"
                )
            ]
            guard context.selectedCollectionID != nil else { return actions }

            if context.selectedCollectionIsManual {
                actions.append(
                    ActionDefinition(
                        id: addTreeToCollectionID,
                        title: "Add Existing Tree",
                        systemImage: "leaf",
                        availability: .available,
                        help: "Add existing trees to this collection"
                    )
                )
                actions.append(
                    ActionDefinition(
                        id: editCollectionID,
                        title: "Edit Collection",
                        systemImage: "pencil",
                        availability: .available,
                        help: "Edit this collection’s name, description, icon, and color"
                    )
                )
                actions.append(
                    ActionDefinition(
                        id: deleteCollectionID,
                        title: "Delete Collection",
                        systemImage: "trash",
                        availability: .available,
                        help: "Remove this collection. Trees stay in the library."
                    )
                )
            }
            return actions
        }
    }

    private static func treesActions(_ context: TreesContext) -> [ActionDefinition] {
        guard context.selectedTreeID != nil else { return [] }

        switch context.interactionMode {
        case .editing:
            return [
                ActionDefinition(
                    id: cancelTreeEditID,
                    title: "Finish",
                    systemImage: "checkmark.circle",
                    availability: .available,
                    help: "Leave Edit Mode"
                )
            ]
        case .viewing:
            var actions: [ActionDefinition] = []

            // Tree — identity / membership / record
            actions.append(ActionDefinition.sectionHeader(id: "context.trees.section.tree", title: "Tree"))
            if context.isInCare {
                actions.append(
                    ActionDefinition(
                        id: editTreeID,
                        title: "Edit Tree",
                        systemImage: "pencil",
                        availability: .available,
                        help: "Edit this tree’s details"
                    )
                )
                actions.append(
                    ActionDefinition(
                        id: duplicateTreeID,
                        title: "Duplicate Tree Info",
                        systemImage: "plus.square.on.square",
                        availability: .available,
                        help: "New Bonsai Name; botanics, placement, pot, and acquisition from this tree"
                    )
                )
            }
            if !context.isInCare {
                actions.append(
                    ActionDefinition(
                        id: returnToCareID,
                        title: "Return to My Trees",
                        systemImage: "arrow.uturn.backward",
                        availability: .available,
                        help: "Clear disposal and put this tree back in My Trees"
                    )
                )
            }
            if context.isFavorite {
                actions.append(
                    ActionDefinition(
                        id: removeFromFavoriteTreesID,
                        title: "Remove from Favorite Trees",
                        systemImage: "star.slash",
                        availability: .available,
                        help: "Remove this tree from Favorite Trees"
                    )
                )
            } else {
                actions.append(
                    ActionDefinition(
                        id: addToFavoriteTreesID,
                        title: "Add to Favorite Trees",
                        systemImage: "star",
                        availability: .available,
                        help: "Add this tree to Favorite Trees"
                    )
                )
            }

            // Register — work / measurement / photo (in care only)
            if context.isInCare {
                actions.append(ActionDefinition.separator(id: "context.trees.sep.register"))
                actions.append(ActionDefinition.sectionHeader(id: "context.trees.section.register", title: "Register"))
                actions.append(contentsOf: [
                    ActionDefinition(
                        id: addActivityID,
                        title: "Add Work",
                        systemImage: "plus",
                        availability: .available,
                        help: "Register completed work on this tree"
                    ),
                    ActionDefinition(
                        id: addMeasurementID,
                        title: "Add Measurement",
                        systemImage: "ruler",
                        availability: .available,
                        help: "Record a dated measurement session for this tree"
                    ),
                    ActionDefinition(
                        id: addImageID,
                        title: "Add Photo",
                        systemImage: "photo.badge.plus",
                        availability: .available,
                        help: "Add a photo for this tree"
                    ),
                    ActionDefinition(
                        id: addJournalID,
                        title: "Add Journal",
                        systemImage: "book",
                        availability: .available,
                        help: "Add a dated journal note for this tree"
                    )
                ])
            }

            // Navigate
            actions.append(ActionDefinition.separator(id: "context.trees.sep.navigate"))
            actions.append(ActionDefinition.sectionHeader(id: "context.trees.section.navigate", title: "Navigate"))
            if !context.isTreeWorkspaceWindow {
                actions.append(
                    ActionDefinition(
                        id: openTreeWorkspaceID,
                        title: "Open Tree Workspace",
                        systemImage: "macwindow",
                        availability: .available,
                        help: "Open this tree in its own Workspace window"
                    )
                )
            }
            actions.append(contentsOf: [
                ActionDefinition(
                    id: viewTreeHistoryID,
                    title: "View Tree History",
                    systemImage: "doc.text",
                    availability: .available,
                    help: "View and print the assembled history for this tree"
                ),
                ActionDefinition(
                    id: showOnMapID,
                    title: "Show on Map",
                    systemImage: "map",
                    availability: .available,
                    help: "Open the Garden map at this tree’s Location"
                ),
                ActionDefinition(
                    id: viewImagesID,
                    title: "View Photos",
                    systemImage: "photo.on.rectangle.angled",
                    availability: .available,
                    help: "Open Photos in Media for this tree"
                )
            ])

            // Destructive last
            actions.append(ActionDefinition.separator(id: "context.trees.sep.delete"))
            actions.append(
                ActionDefinition(
                    id: deleteTreeID,
                    title: "Delete Tree",
                    systemImage: "trash",
                    availability: .available,
                    help: "Remove a mistaken or duplicate record — not for sold, gifted, dead, or lost trees"
                )
            )
            return actions
        }
    }

    private static func potsActions(_ context: PotsContext) -> [ActionDefinition] {
        guard context.selectedPotID != nil else { return [] }

        switch context.interactionMode {
        case .editing:
            return [
                ActionDefinition(
                    id: cancelPotEditID,
                    title: "Finish",
                    systemImage: "checkmark.circle",
                    availability: .available,
                    help: "Leave Edit Mode"
                )
            ]
        case .viewing:
            var actions: [ActionDefinition] = [
                ActionDefinition(
                    id: editPotID,
                    title: "Edit Pot",
                    systemImage: "pencil",
                    availability: .available,
                    help: "Edit this pot's details"
                ),
                ActionDefinition(
                    id: addPotImageID,
                    title: "Add Photo",
                    systemImage: "photo.badge.plus",
                    availability: .available,
                    help: "Add a photo for this pot"
                )
            ]
            switch context.status {
            case .available, .inUse:
                actions.append(contentsOf: [
                    ActionDefinition(
                        id: markPotSoldID,
                        title: "Mark Sold",
                        systemImage: "tag",
                        availability: .available,
                        help: "Record this pot as sold"
                    ),
                    ActionDefinition(
                        id: markPotBrokenID,
                        title: "Mark Broken",
                        systemImage: "exclamationmark.triangle",
                        availability: .available,
                        help: "Record this pot as broken"
                    ),
                    ActionDefinition(
                        id: markPotRetiredID,
                        title: "Mark Retired",
                        systemImage: "archivebox",
                        availability: .available,
                        help: "Retire this pot from active use"
                    )
                ])
            case .sold, .broken, .retired:
                actions.append(
                    ActionDefinition(
                        id: returnPotToAvailableID,
                        title: "Return to Available",
                        systemImage: "arrow.uturn.backward",
                        availability: .available,
                        help: "Reverse a mistaken status change"
                    )
                )
            case .none:
                break
            }
            actions.append(
                ActionDefinition(
                    id: deletePotID,
                    title: "Delete Pot",
                    systemImage: "trash",
                    availability: .available,
                    help: "Remove a mistaken or duplicate record — not for sold, broken, or retired pots"
                )
            )
            return actions
        }
    }

    private static func yamadoriActions(_ context: YamadoriContext) -> [ActionDefinition] {
        guard context.selectedYamadoriID != nil else { return [] }

        switch context.interactionMode {
        case .editing:
            return [
                ActionDefinition(
                    id: cancelYamadoriEditID,
                    title: "Finish",
                    systemImage: "checkmark.circle",
                    availability: .available,
                    help: "Leave Edit Mode"
                )
            ]
        case .viewing:
            if let _ = context.selectedYamadoriFindID {
                return yamadoriFindActions(status: context.status)
            }
            return [
                ActionDefinition(
                    id: editYamadoriID,
                    title: "Edit Yamadori",
                    systemImage: "pencil",
                    availability: .available,
                    help: "Edit this trip"
                ),
                ActionDefinition(
                    id: addYamadoriFindID,
                    title: "Add Find",
                    systemImage: "plus.circle",
                    availability: .available,
                    help: "Add another Find on this trip"
                ),
                ActionDefinition(
                    id: deleteYamadoriID,
                    title: "Delete Yamadori",
                    systemImage: "trash",
                    availability: .available,
                    help: "Delete this trip and all Finds on it"
                )
            ]
        }
    }

    private static func yamadoriFindActions(status: YamadoriStatus?) -> [ActionDefinition] {
        var actions: [ActionDefinition] = [
            ActionDefinition(
                id: editYamadoriID,
                title: "Edit Find",
                systemImage: "pencil",
                availability: .available,
                help: "Edit this Find"
            ),
            ActionDefinition(
                id: addYamadoriObservationID,
                title: "Add Observation",
                systemImage: "text.badge.plus",
                availability: .available,
                help: "Add a field or recovery observation"
            ),
            ActionDefinition(
                id: addYamadoriImageID,
                title: "Add Photo",
                systemImage: "photo.badge.plus",
                availability: .available,
                help: "Add a photo to this Find"
            )
        ]

        if let status {
            switch status {
            case .scout:
                actions.append(
                    ActionDefinition(
                        id: advanceYamadoriStatusID,
                        title: "Advance Status",
                        systemImage: "arrow.right.circle",
                        availability: .available,
                        help: "Move Uncollected to Planned"
                    )
                )
            default:
                break
            }
            if status == .planned {
                actions.append(
                    ActionDefinition(
                        id: markYamadoriCollectedID,
                        title: "Mark Collected",
                        systemImage: "checkmark.seal",
                        availability: .available,
                        help: "Create a Yamadori Tree with the YAM code"
                    )
                )
            }
            if status.canTransferToTree {
                actions.append(
                    ActionDefinition(
                        id: transferYamadoriToTreeID,
                        title: "Move to My Trees",
                        systemImage: "arrow.right.square",
                        availability: .available,
                        help: "Graduate this Yamadori Tree to My Trees with a new Bonsai Name"
                    )
                )
            }
            if !status.isClosed {
                actions.append(
                    ActionDefinition(
                        id: abandonYamadoriID,
                        title: "Abandon",
                        systemImage: "xmark.circle",
                        availability: .available,
                        help: "Mark this Find as abandoned"
                    )
                )
            }
            if status == .abandoned {
                actions.append(
                    ActionDefinition(
                        id: archiveYamadoriID,
                        title: "Archive",
                        systemImage: "archivebox",
                        availability: .available,
                        help: "Archive this abandoned Find"
                    )
                )
            }
        }

        actions.append(
            ActionDefinition(
                id: deleteYamadoriID,
                title: "Delete Find",
                systemImage: "trash",
                availability: .available,
                help: "Permanently delete this Find"
            )
        )
        return actions
    }

    private static func vegetativeActions(
        _ context: VegetativePropagationContext,
        kind: NurseryPropagationKind
    ) -> [ActionDefinition] {
        guard context.selectedProjectID != nil else { return [] }
        return [
            ActionDefinition(
                id: showAllNurseryProjectsID,
                title: "All \(kind.title)",
                systemImage: "list.bullet",
                availability: .available,
                help: "Return to the \(kind.title) list"
            ),
            ActionDefinition(
                id: editNurseryPropagationID,
                title: "Edit \(kind.singularTitle)",
                systemImage: "pencil",
                availability: .available,
                help: "Edit quantity, identity, parent tree, location, and notes"
            )
        ]
    }

    private static func fieldTreeActions(_ context: FieldTreeContext) -> [ActionDefinition] {
        guard let _ = context.selectedProjectID else { return [] }
        switch context.interactionMode {
        case .editing:
            return [
                ActionDefinition(
                    id: finishFieldTreeEditID,
                    title: "Finish",
                    systemImage: "checkmark.circle",
                    availability: .available,
                    help: "Leave Edit Mode"
                )
            ]
        case .viewing:
            return [
                ActionDefinition(
                    id: editFieldTreeID,
                    title: "Edit Field Tree",
                    systemImage: "pencil",
                    availability: .available,
                    help: "Edit planting date, species, cultivar, location, and notes"
                ),
                ActionDefinition(
                    id: addFieldTreeTaskID,
                    title: "Add Task",
                    systemImage: "checklist",
                    availability: .available,
                    help: "Create a Task linked to this Field Tree"
                )
            ]
        }
    }
}
