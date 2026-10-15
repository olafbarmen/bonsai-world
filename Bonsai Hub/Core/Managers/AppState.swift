//
//  AppState.swift
//  Bonsai World
//

import Foundation
import Observation

/// Ephemeral Garden → Trees list filter (Dashboard entry points). Cleared on normal Trees navigation.
enum TreesOverviewFilter: Hashable, Sendable {
    case none
    /// Same Development Tree Stage set as ``DashboardCollectionSummary`` metric `"development"`.
    case developmentStage
    /// Same photo gap as Dashboard Library / Needs Photos.
    case withoutPhoto
    /// Trees with no Tree Stage (`treeStageID == nil`).
    case withoutStatus
    /// Trees with no Species (`speciesID == nil`).
    case withoutSpecies

    var chipTitle: String? {
        switch self {
        case .none: nil
        case .developmentStage: "Development Trees"
        case .withoutPhoto: "Without a photo"
        case .withoutStatus: "Without status"
        case .withoutSpecies: "Without species"
        }
    }

    var chipSystemImage: String? {
        switch self {
        case .none: nil
        case .developmentStage: "leaf.arrow.circlepath"
        case .withoutPhoto: "photo"
        case .withoutStatus: "circle.dashed"
        case .withoutSpecies: "leaf"
        }
    }
}

@Observable
@MainActor
final class AppState {
    /// Global sidebar destination (Architecture Version 2 leaf route).
    var selectedSection: AppRoute? = .dashboard

    /// Tasks page horizon (Overdue / Today / …). Sidebar is one Tasks row; picker is on-page.
    var tasksHorizon: TasksHorizon = .today

    /// Care page (Watering / Winter Care / …). Sidebar is one Care row; picker is on-page (BV1).
    var carePage: CarePage = .watering

    /// Selected location within the Locations module (master/detail).
    var selectedLocationID: UUID?

    /// Garden currently being browsed in the Locations module (map filter + Garden
    /// picker). Also the default Garden for new Locations created from that module.
    /// `nil` means "use the default Garden" — not cleared on navigation, so the
    /// grower's last-picked Garden persists across visits to Locations.
    var selectedGardenID: UUID?

    /// Selected collection within the Collections module (master/detail).
    var selectedCollectionID: UUID?

    /// Last Collection the grower opened — survives leaving the Collections route.
    var lastOpenedCollectionID: UUID?

    /// Selected tree for Tree Detail (Collections member drill-in or Trees module).
    var selectedTreeID: UUID?

    /// Overview vs Shaping on Tree Detail / Tree Workspace.
    var treeDetailSegment: TreeDetailSegment = .overview

    /// Ephemeral filter for Garden → Trees (e.g. Dashboard → Development Trees).
    var treesOverviewFilter: TreesOverviewFilter = .none

    /// When true, the next ``handleSelectedSectionChange`` for `.gardenTrees` keeps ``treesOverviewFilter``.
    private var preserveTreesOverviewFilterOnce = false

    /// Selected Work Type within the Workshop / Work route (master/detail foundation).
    var selectedWorkTypeID: UUID?

    /// Selected pot within the Inventory → Pots module (master/detail).
    var selectedPotID: UUID?

    /// Pot Detail View / Edit mode — drives Pots context Quick Actions.
    var potDetailInteractionMode: TreeDetailInteractionMode = .viewing

    /// One-shot Quick Action request for the active Pot Detail.
    var pendingPotQuickAction: PotQuickActionRequest?

    /// Pot create sheet: `nil` when dismissed.
    var potEditor: EditorMode?

    /// Active tab inside Inventory → Soil (Overview · Stock · Mixes · Knowledge).
    var selectedSoilWorkspaceTab: SoilWorkspaceTab = .stock

    /// Selected soil stock line.
    var selectedSoilStockID: UUID?

    /// Selected soil mix in Inventory → Soil → Mixes.
    var selectedSoilMixID: UUID?

    /// Add Soil sheet.
    var soilStockEditor: EditorMode?

    /// Stocktake sheet.
    var isSoilStocktakePresented = false

    /// Selected Wire / Tool / Chemical / Consumable stock line.
    var selectedInventoryStockID: UUID?

    /// Add inventory stock sheet — kind when presented, nil when dismissed.
    var inventoryStockEditorKind: InventoryStockKind?

    /// Stock Report scroll focus after navigating from an area toolbar.
    var pendingStockReportArea: StockReportArea?

    /// One-shot: open New Mix editor after switching to Mixes.
    var wantsNewSoilMix = false

    /// One-shot: open New Seed Batch sheet (Nursery → Seeds → Seed Work).
    var wantsNewSeedBatch = false

    /// One-shot: open New propagation project for this kind.
    var wantsNewNurseryPropagationKind: NurseryPropagationKind?

    /// One-shot: run Media → Images Finder import via ImageImportService.
    var wantsImportImage = false

    /// One-shot: open New Media library item sheet for this kind.
    var wantsNewMediaLibraryKind: MediaLibraryKind?

    /// One-shot: open New Knowledge resource sheet for this kind.
    var wantsNewKnowledgeResourceKind: KnowledgeResourceKind?

    /// One-shot: open Simple Catalog create sheet for this kind.
    var wantsNewSimpleCatalogKind: SimpleCatalogKind?

    /// One-shot: open Add Garden editor.
    var wantsNewGarden = false

    /// One-shot: Tasks workspace — New Task / Manage Schedules / Complete All.
    var wantsNewTask = false
    var wantsManageSchedules = false
    var wantsCompleteAllTasks = false

    /// One-shot: Stock Report → Export Excel.
    var wantsExportStockReport = false

    /// Selected Yamadori trip within Nursery → Yamadori (master/detail).
    var selectedYamadoriID: UUID?

    /// Selected Find within the active Yamadori trip (nil = trip detail).
    var selectedYamadoriFindID: UUID?

    /// Active tab inside Nursery → Yamadori (single sidebar entry).
    var selectedYamadoriWorkspaceTab: YamadoriWorkspaceTab = .yamadories

    /// Active tab inside Nursery → Seeds (Seed Work · Stratification · Overview · Germination).
    var selectedSeedWorkspaceTab: SeedWorkspaceTab = .seedWork

    /// Selected Seed Batch in Seed Work.
    var selectedSeedBatchID: UUID?

    /// One-shot Context Tools request for the active Seed Batch Detail.
    var pendingSeedBatchQuickAction: SeedBatchQuickActionRequest?

    /// Selected Nursery propagation project (Cuttings / Air Layers / Grafting / Field Tree).
    var selectedCuttingProjectID: UUID?
    var selectedAirLayerProjectID: UUID?
    var selectedGraftProjectID: UUID?
    var selectedFieldTreeProjectID: UUID?

    func selectedNurseryPropagationProjectID(for kind: NurseryPropagationKind) -> UUID? {
        switch kind {
        case .cutting: selectedCuttingProjectID
        case .airLayer: selectedAirLayerProjectID
        case .grafting: selectedGraftProjectID
        case .fieldTree: selectedFieldTreeProjectID
        }
    }

    func setSelectedNurseryPropagationProjectID(_ id: UUID?, for kind: NurseryPropagationKind) {
        switch kind {
        case .cutting: selectedCuttingProjectID = id
        case .airLayer: selectedAirLayerProjectID = id
        case .grafting: selectedGraftProjectID = id
        case .fieldTree: selectedFieldTreeProjectID = id
        }
    }

    /// Yamadori / Find Detail Edit mode — drives Yamadori context Quick Actions.
    var yamadoriDetailInteractionMode: TreeDetailInteractionMode = .viewing

    /// Field Tree detail Edit mode — drives Field Tree Context Tools.
    var fieldTreeDetailInteractionMode: TreeDetailInteractionMode = .viewing
    /// Cuttings / Air Layers / Grafting detail Edit mode.
    var nurseryPropagationDetailInteractionMode: TreeDetailInteractionMode = .viewing
    /// One-shot: open Add Task for the selected Field Tree.
    var wantsAddFieldTreeTask = false

    /// One-shot Quick Action request for the active Yamadori or Find Detail.
    var pendingYamadoriQuickAction: YamadoriQuickActionRequest?

    /// Yamadori create sheet: `nil` when dismissed.
    var yamadoriEditor: EditorMode?

    /// Tree Detail View / Edit mode — drives Trees context Quick Actions.
    var treeDetailInteractionMode: TreeDetailInteractionMode = .viewing

    /// Collection Detail View / Edit mode — drives Collections context Quick Actions.
    var collectionDetailInteractionMode: TreeDetailInteractionMode = .viewing

    /// One-shot Quick Action request for the active Tree Detail.
    var pendingTreeQuickAction: TreeQuickActionRequest?

    /// One-shot Quick Action request for the active Collection Detail.
    var pendingCollectionQuickAction: CollectionQuickActionRequest?

    /// Location editor sheet: `nil` when dismissed.
    var locationEditor: EditorMode?

    /// Collection create sheet: `nil` when dismissed.
    var collectionEditor: EditorMode?

    /// Tree create sheet: `nil` when dismissed.
    var treeEditor: EditorMode?

    /// Optional Collections to preselect in New Tree (cleared when the sheet dismisses).
    var newTreePreselectedCollectionIDs: Set<UUID> = []

    /// Collection → Add Tree sheet.
    var isCollectionAddTreePresented = false

    /// Global Add Tree → Copy Existing Tree picker.
    var isCopyExistingTreePresented = false

    /// Quick Actions → Search.
    var isSearchPresented = false

    /// Settings content selection (e.g. Reference Data).
    var selectedSettingsPane: SettingsPane?

    /// One-shot Locations map focus (e.g. Tree → Show on Map).
    var pendingLocationMapFocusID: UUID?

    /// Selected chapter in Knowledge → Bonsai Handbook.
    var selectedHandbookChapter: BonsaiHandbookChapter = .designGuidelines

    /// One-shot Handbook lesson target (search, Shaping area → Design Guidelines).
    var pendingHandbookTopic: HandbookTopic?

    /// Selected Species Profile in Knowledge → Species Library (profile id).
    var selectedSpeciesProfileID: UUID?

    /// Non-nil when this window is a **Tree Workspace** for exactly one Tree.
    /// The content area shows that Tree only — never the Library tree browser.
    /// `nil` in the Library window.
    var treeWorkspaceTreeID: UUID?

    /// Non-nil when this window is a dedicated **Image Workspace** for one image.
    /// The content area shows that image only — never the Media browser.
    var imageWorkspaceImageID: UUID?

    /// Selected image in Media → Images browse (drives Context Tools Crop).
    var selectedMediaImageID: UUID?

    /// Selected catalog item in Media → Documents / Videos / Notes / Audio.
    var selectedMediaDocumentID: UUID?
    var selectedMediaVideoID: UUID?
    var selectedMediaNoteID: UUID?
    var selectedMediaAudioID: UUID?

    func selectedMediaLibraryItemID(for kind: MediaLibraryKind) -> UUID? {
        switch kind {
        case .document: selectedMediaDocumentID
        case .video: selectedMediaVideoID
        case .note: selectedMediaNoteID
        case .audio: selectedMediaAudioID
        }
    }

    func setSelectedMediaLibraryItemID(_ id: UUID?, for kind: MediaLibraryKind) {
        switch kind {
        case .document: selectedMediaDocumentID = id
        case .video: selectedMediaVideoID = id
        case .note: selectedMediaNoteID = id
        case .audio: selectedMediaAudioID = id
        }
    }

    /// Selected Knowledge resource (Quick Guides / FAQ / Courses / Video Tutorials / External Links).
    var selectedKnowledgeQuickGuideID: UUID?
    var selectedKnowledgeFAQID: UUID?
    var selectedKnowledgeCourseID: UUID?
    var selectedKnowledgeVideoTutorialID: UUID?
    var selectedKnowledgeExternalLinkID: UUID?

    func selectedKnowledgeResourceID(for kind: KnowledgeResourceKind) -> UUID? {
        switch kind {
        case .quickGuide: selectedKnowledgeQuickGuideID
        case .faq: selectedKnowledgeFAQID
        case .course: selectedKnowledgeCourseID
        case .videoTutorial: selectedKnowledgeVideoTutorialID
        case .externalLink: selectedKnowledgeExternalLinkID
        }
    }

    func setSelectedKnowledgeResourceID(_ id: UUID?, for kind: KnowledgeResourceKind) {
        switch kind {
        case .quickGuide: selectedKnowledgeQuickGuideID = id
        case .faq: selectedKnowledgeFAQID = id
        case .course: selectedKnowledgeCourseID = id
        case .videoTutorial: selectedKnowledgeVideoTutorialID = id
        case .externalLink: selectedKnowledgeExternalLinkID = id
        }
    }

    /// Selected Simple Catalog entry (Economy + Workshop Calendar/Tasks).
    var selectedSimpleCatalogEntryIDs: [SimpleCatalogKind: UUID] = [:]

    func selectedSimpleCatalogEntryID(for kind: SimpleCatalogKind) -> UUID? {
        selectedSimpleCatalogEntryIDs[kind]
    }

    func setSelectedSimpleCatalogEntryID(_ id: UUID?, for kind: SimpleCatalogKind) {
        if let id {
            selectedSimpleCatalogEntryIDs[kind] = id
        } else {
            selectedSimpleCatalogEntryIDs.removeValue(forKey: kind)
        }
    }

    /// When set, Media → Images shows only this Tree’s photos (from Tree Detail → View all).
    var galleryFocusTreeID: UUID?

    /// One-shot Image Tools request for the active Image Workspace.
    var pendingImageQuickAction: ImageQuickActionRequest?

    /// Bumps when Context Tools asks Media → Images to delete the selected image.
    private(set) var mediaImageDeleteRequestID: Int = 0

    func requestDeleteSelectedMediaImage() {
        mediaImageDeleteRequestID &+= 1
    }

    /// Whether this window is a dedicated Tree Workspace (one Tree, not a browser).
    var isTreeWorkspaceWindow: Bool { treeWorkspaceTreeID != nil }

    /// Focused Yamadori trip when this window is a trip workspace (nil in Library).
    var yamadoriWorkspaceTripID: UUID?

    /// Focused Yamadori Find when this window is a Find workspace (nil in Library).
    var yamadoriWorkspaceFindID: UUID?

    /// Whether this window is a dedicated Image Workspace (one image, not a browser).
    var isImageWorkspaceWindow: Bool { imageWorkspaceImageID != nil }

    var isYamadoriTripWorkspaceWindow: Bool { yamadoriWorkspaceTripID != nil }
    var isYamadoriFindWorkspaceWindow: Bool { yamadoriWorkspaceFindID != nil }

    /// Fresh navigation state for a Tree Workspace window focused on one Tree.
    /// Shares no UI state with other windows — only library services are shared.
    static func makeTreeWorkspace(treeID: UUID) -> AppState {
        let state = AppState()
        state.treeWorkspaceTreeID = treeID
        state.selectedSection = .gardenTrees
        state.selectedTreeID = treeID
        return state
    }

    /// Fresh navigation state for a Yamadori trip workspace window.
    static func makeYamadoriTripWorkspace(tripID: UUID) -> AppState {
        let state = AppState()
        state.yamadoriWorkspaceTripID = tripID
        state.selectedSection = .nurseryYamadori
        state.selectedYamadoriWorkspaceTab = .yamadories
        state.selectedYamadoriID = tripID
        return state
    }

    /// Fresh navigation state for a Yamadori Find workspace window.
    static func makeYamadoriFindWorkspace(findID: UUID, tripID: UUID) -> AppState {
        let state = AppState()
        state.yamadoriWorkspaceFindID = findID
        state.selectedSection = .nurseryYamadori
        state.selectedYamadoriWorkspaceTab = .uncollectedFindings
        state.selectedYamadoriFindID = findID
        state.selectedYamadoriID = tripID
        return state
    }

    /// Fresh navigation state for an Image Workspace window focused on one image.
    static func makeImageWorkspace(imageID: UUID) -> AppState {
        let state = AppState()
        state.imageWorkspaceImageID = imageID
        state.selectedSection = .mediaImages
        return state
    }

    func selectSection(_ section: AppRoute?) {
        if section == .gardenTrees {
            treesOverviewFilter = .none
            preserveTreesOverviewFilterOnce = false
        } else {
            treesOverviewFilter = .none
            preserveTreesOverviewFilterOnce = false
        }
        selectedSection = section
        handleSelectedSectionChange(section)
    }

    /// Opens Garden → Trees with an ephemeral overview filter (Dashboard entry points).
    func openGardenTrees(filter: TreesOverviewFilter) {
        treesOverviewFilter = filter
        treeDetailSegment = .overview
        if selectedSection == .gardenTrees {
            preserveTreesOverviewFilterOnce = false
            return
        }
        preserveTreesOverviewFilterOnce = true
        selectedSection = .gardenTrees
    }

    func clearTreesOverviewFilter() {
        treesOverviewFilter = .none
        preserveTreesOverviewFilterOnce = false
    }

    /// Clears module-local selections after ``selectedSection`` changes.
    ///
    /// Use from sidebar-driven `onChange` via a deferred `Task` so AppState is not
    /// mutated during the same view update that wrote ``selectedSection``.
    func handleSelectedSectionChange(_ section: AppRoute?) {
        clearSelections(except: section)
        if section == .gardenTrees {
            if preserveTreesOverviewFilterOnce {
                preserveTreesOverviewFilterOnce = false
            } else {
                treesOverviewFilter = .none
            }
        } else {
            treesOverviewFilter = .none
            preserveTreesOverviewFilterOnce = false
        }
        switch section {
        case .inventorySoilComponents:
            selectedSection = .inventorySoil
            selectedSoilWorkspaceTab = .stock
        case .inventorySoilMixes:
            selectedSection = .inventorySoil
            selectedSoilWorkspaceTab = .mixes
        case .nurseryGrafting:
            // Grafting is Work on a Tree — no longer a Nursery destination.
            selectedSection = .tasksToday
            tasksHorizon = .today
        case .tasksOverdue:
            tasksHorizon = .overdue
            selectedSection = .tasksToday
        case .tasksToday:
            // Keep current horizon when re-tapping Tasks; only default when arriving fresh via route title.
            selectedSection = .tasksToday
        case .tasksThisWeek:
            tasksHorizon = .thisWeek
            selectedSection = .tasksToday
        case .tasksThisMonth:
            tasksHorizon = .thisMonth
            selectedSection = .tasksToday
        case .tasksThisYear:
            tasksHorizon = .thisYear
            selectedSection = .tasksToday
        case .tasksNextYear:
            tasksHorizon = .nextYear
            selectedSection = .tasksToday
        case .careWatering:
            // Keep current carePage when re-tapping Care (BV1).
            selectedSection = .careWatering
        case .careFertilizing, .carePlacement, .careWinter, .careSpring,
             .careRepotting, .careTreeHealth, .careSeasonal:
            if let section, let page = CarePage(route: section) {
                carePage = page
            }
            selectedSection = .careWatering
        case .careToday:
            // Tasks owns the day list.
            selectedSection = .tasksToday
            tasksHorizon = .today
        case .knowledgeSoilGuides:
            // Soil & Substrate lives inside Bonsai Handbook — no sidebar destination.
            selectedSection = .knowledgeHandbook
            selectedHandbookChapter = .soilGuides
        case .knowledgePotGuidelines:
            // Pots & Containers lives inside Bonsai Handbook — no sidebar destination.
            selectedSection = .knowledgeHandbook
            selectedHandbookChapter = .potGuidelines
        case .shaping:
            treeDetailSegment = .shaping
        case .gardenTrees:
            treeDetailSegment = .overview
        default:
            break
        }
        if section == .settings, selectedSettingsPane == nil {
            selectedSettingsPane = .userProfile
        }
    }

    /// Opens Locations Map and zooms to the Location pin (Tree inherits map position from Location).
    func showLocationOnMap(locationID: UUID) {
        selectedLocationID = locationID
        pendingLocationMapFocusID = locationID
        selectSection(.locationsMap)
    }

    /// Opens Tree Detail from a Garden map Tree marker.
    func showTreeFromMap(treeID: UUID) {
        selectedTreeID = treeID
        selectSection(.gardenTrees)
    }

    func clearPendingLocationMapFocus() {
        pendingLocationMapFocusID = nil
    }

    /// Opens Knowledge → Bonsai Handbook at a chapter (and optional Design Guidelines section).
    func openHandbook(chapter: BonsaiHandbookChapter, designSection: DesignGuidelineSection? = nil) {
        selectedHandbookChapter = chapter
        pendingHandbookTopic = designSection.map(HandbookTopic.design)
        selectSection(.knowledgeHandbook)
    }

    /// Opens Knowledge → Bonsai Handbook at a numbered lesson.
    func openHandbookTopic(_ topic: HandbookTopic) {
        selectedHandbookChapter = topic.chapter
        pendingHandbookTopic = topic
        if selectedSection != .knowledgeHandbook {
            selectSection(.knowledgeHandbook)
        }
    }

    /// Opens Knowledge → Bonsai Handbook at a Design Guidelines section.
    func openDesignGuidelines(section: DesignGuidelineSection) {
        openHandbook(chapter: .designGuidelines, designSection: section)
    }

    func clearPendingHandbookTopic() {
        pendingHandbookTopic = nil
    }

    /// Opens Knowledge → Species Library focused on this Botanical Library species.
    func openSpeciesProfile(speciesID: UUID) {
        selectedSpeciesProfileID = speciesID
        selectSection(.knowledgeSpeciesLibrary)
    }

    func presentNewLocation() {
        selectedSection = .locationsPlaces
        locationEditor = .create
    }

    func presentEditLocation(id: UUID) {
        locationEditor = .edit(id)
    }

    func dismissLocationEditor() {
        locationEditor = nil
    }

    func presentNewCollection() {
        selectedSection = .gardenCollections
        selectedTreeID = nil
        collectionEditor = .create
    }

    func dismissCollectionEditor() {
        collectionEditor = nil
    }

    func presentNewTree(preselectedCollectionIDs: Set<UUID> = []) {
        newTreePreselectedCollectionIDs = preselectedCollectionIDs
        if preselectedCollectionIDs.isEmpty {
            selectedSection = .gardenTrees
            selectedCollectionID = nil
        }
        treeEditor = .create
    }

    /// Opens New Tree with the given Collection already selected (Collection → Create New Tree).
    func presentNewTree(inCollection collectionID: UUID) {
        presentNewTree(preselectedCollectionIDs: [collectionID])
    }

    func dismissTreeEditor() {
        treeEditor = nil
        newTreePreselectedCollectionIDs = []
    }

    func presentCopyExistingTree() {
        selectedSection = .gardenTrees
        isCopyExistingTreePresented = true
    }

    func dismissCopyExistingTree() {
        isCopyExistingTreePresented = false
    }

    func presentSearch() {
        isSearchPresented = true
    }

    /// Opens Add Tree for the currently selected Manual Collection.
    func presentAddTreeToSelectedCollection() {
        guard selectedCollectionID != nil else { return }
        selectedSection = .gardenCollections
        isCollectionAddTreePresented = true
    }

    func dismissCollectionAddTree() {
        isCollectionAddTreePresented = false
    }

    func requestTreeQuickAction(_ command: TreeQuickActionCommand) {
        pendingTreeQuickAction = TreeQuickActionRequest(command: command)
    }

    func clearPendingTreeQuickAction() {
        pendingTreeQuickAction = nil
    }

    func requestCollectionQuickAction(_ command: CollectionQuickActionCommand) {
        pendingCollectionQuickAction = CollectionQuickActionRequest(command: command)
    }

    func clearPendingCollectionQuickAction() {
        pendingCollectionQuickAction = nil
    }

    func requestImageQuickAction(_ command: ImageQuickActionCommand) {
        pendingImageQuickAction = ImageQuickActionRequest(command: command)
    }

    func clearPendingImageQuickAction() {
        pendingImageQuickAction = nil
    }

    /// Opens Garden → Collections focused on one Collection.
    func showCollection(_ id: UUID) {
        selectedCollectionID = id
        lastOpenedCollectionID = id
        selectSection(.gardenCollections)
    }

    /// Opens Inventory → Pots focused on one Pot.
    func showInventoryPot(_ id: UUID) {
        selectedPotID = id
        selectSection(.inventoryPots)
    }

    /// Opens Media → Images filtered to one Tree’s photos.
    func showTreeImages(treeID: UUID) {
        galleryFocusTreeID = treeID
        selectSection(.mediaImages)
    }

    func clearGalleryTreeFocus() {
        galleryFocusTreeID = nil
    }

    func presentNewPot() {
        selectedSection = .inventoryPots
        potEditor = .create
    }

    func dismissPotEditor() {
        potEditor = nil
    }

    func presentAddSoil() {
        selectedSection = .inventorySoil
        selectedSoilWorkspaceTab = .stock
        soilStockEditor = .create
    }

    func presentNewSeedBatch() {
        selectedSection = .nurserySeeds
        selectedSeedWorkspaceTab = .seedWork
        wantsNewSeedBatch = true
    }

    func requestSeedBatchQuickAction(_ command: SeedBatchQuickActionCommand) {
        pendingSeedBatchQuickAction = SeedBatchQuickActionRequest(command: command)
    }

    func clearPendingSeedBatchQuickAction() {
        pendingSeedBatchQuickAction = nil
    }

    func presentNewNurseryPropagation(kind: NurseryPropagationKind) {
        guard kind != .grafting else {
            // Grafting belongs on a Tree as Work / Task — not Nursery create.
            selectedSection = .tasksToday
            return
        }
        selectedSection = kind.route
        wantsNewNurseryPropagationKind = kind
    }

    func presentImportImage() {
        selectedSection = .mediaImages
        wantsImportImage = true
    }

    func dismissSoilStockEditor() {
        soilStockEditor = nil
    }

    func presentSoilStocktake() {
        selectedSection = .inventorySoil
        selectedSoilWorkspaceTab = .stock
        isSoilStocktakePresented = true
    }

    /// Opens Nursery → Seeds focused on one Seed Batch (Seed Work).
    func showSeedBatch(batchID: UUID) {
        selectedSeedBatchID = batchID
        selectedSeedWorkspaceTab = .seedWork
        selectSection(.nurserySeeds)
    }

    /// Opens Nursery → Yamadori focused on one trip.
    func showYamadoriTrip(tripID: UUID) {
        selectedYamadoriID = tripID
        selectedYamadoriFindID = nil
        selectedYamadoriWorkspaceTab = .yamadories
        selectSection(.nurseryYamadori)
    }

    /// Opens Propagation → Field Tree focused on one project.
    func showFieldTree(projectID: UUID) {
        selectedFieldTreeProjectID = projectID
        fieldTreeDetailInteractionMode = .viewing
        selectSection(.nurseryFieldTree)
    }

    func presentAddInventoryStock(kind: InventoryStockKind) {
        selectedSection = kind.appRoute
        inventoryStockEditorKind = kind
    }

    func dismissInventoryStockEditor() {
        inventoryStockEditorKind = nil
    }

    func presentStockReport(focusing area: StockReportArea? = nil) {
        pendingStockReportArea = area
        selectedSection = .inventoryStockReport
    }

    func requestPotQuickAction(_ command: PotQuickActionCommand) {
        pendingPotQuickAction = PotQuickActionRequest(command: command)
    }

    func clearPendingPotQuickAction() {
        pendingPotQuickAction = nil
    }

    func presentNewYamadori() {
        selectedSection = .nurseryYamadori
        selectedYamadoriWorkspaceTab = .yamadories
        yamadoriEditor = .create
    }

    func dismissYamadoriEditor() {
        yamadoriEditor = nil
    }

    func requestYamadoriQuickAction(_ command: YamadoriQuickActionCommand) {
        pendingYamadoriQuickAction = YamadoriQuickActionRequest(command: command)
    }

    func clearPendingYamadoriQuickAction() {
        pendingYamadoriQuickAction = nil
    }

    /// Opens a Find at its current home: Uncollected Findings, Yamadori Trees, or Transferred Trees.
    func openYamadoriFindAtLastPosition(find: YamadoriFind, tree: Tree?) {
        selectedSection = .nurseryYamadori
        yamadoriDetailInteractionMode = .viewing
        treeDetailInteractionMode = .viewing
        if let tree {
            selectedYamadoriWorkspaceTab = tree.yamadoriNursery ? .yamadoriTrees : .transferredTrees
            selectedTreeID = tree.id
            selectedYamadoriFindID = nil
            selectedYamadoriID = nil
            pendingYamadoriQuickAction = nil
        } else {
            selectedYamadoriWorkspaceTab = .uncollectedFindings
            selectedYamadoriFindID = find.id
            selectedYamadoriID = find.yamadoriID
            selectedTreeID = nil
        }
    }

    private func clearSelections(except section: AppRoute?) {
        let module = section?.module

        if !AppRoute.isGardenLocationRoute(section) {
            selectedLocationID = nil
            pendingLocationMapFocusID = nil
        }
        if section != .gardenCollections {
            selectedCollectionID = nil
            collectionDetailInteractionMode = .viewing
            pendingCollectionQuickAction = nil
        }
        // Tree Detail may be shown from Collections, Trees, Shaping, or Yamadori tree tabs.
        if section != .gardenTrees, section != .shaping {
            if section != .nurseryYamadori || !selectedYamadoriWorkspaceTab.showsTreeDetail {
                selectedTreeID = nil
                treeDetailInteractionMode = .viewing
                pendingTreeQuickAction = nil
            }
        }
        if section != .mediaImages {
            selectedMediaImageID = nil
            pendingImageQuickAction = nil
            galleryFocusTreeID = nil
        }
        if section != .mediaDocuments { selectedMediaDocumentID = nil }
        if section != .mediaVideo { selectedMediaVideoID = nil }
        if section != .mediaNotes { selectedMediaNoteID = nil }
        if section != .mediaAudio { selectedMediaAudioID = nil }
        if section != .knowledgeQuickGuides { selectedKnowledgeQuickGuideID = nil }
        if section != .knowledgeFAQ { selectedKnowledgeFAQID = nil }
        if section != .knowledgeCourses { selectedKnowledgeCourseID = nil }
        if section != .knowledgeVideos { selectedKnowledgeVideoTutorialID = nil }
        if section != .knowledgeExternalLinks { selectedKnowledgeExternalLinkID = nil }
        if let section, let catalogKind = SimpleCatalogKind.allCases.first(where: { $0.route == section }) {
            selectedSimpleCatalogEntryIDs = selectedSimpleCatalogEntryIDs.filter { $0.key == catalogKind }
        } else {
            selectedSimpleCatalogEntryIDs = [:]
        }
        if section != .inventoryPots {
            selectedPotID = nil
            potDetailInteractionMode = .viewing
            pendingPotQuickAction = nil
        }
        if section != .nurseryYamadori {
            selectedYamadoriID = nil
            selectedYamadoriFindID = nil
            selectedYamadoriWorkspaceTab = .yamadories
            yamadoriDetailInteractionMode = .viewing
            pendingYamadoriQuickAction = nil
        }
        if section != .nurserySeeds {
            selectedSeedWorkspaceTab = .seedWork
            selectedSeedBatchID = nil
            pendingSeedBatchQuickAction = nil
        }
        if section != .nurseryCuttings {
            selectedCuttingProjectID = nil
        }
        if section != .nurseryAirLayers {
            selectedAirLayerProjectID = nil
        }
        if section != .nurseryGrafting {
            selectedGraftProjectID = nil
        }
        if section != .nurseryCuttings
            && section != .nurseryAirLayers
            && section != .nurseryGrafting {
            nurseryPropagationDetailInteractionMode = .viewing
        }
        if section != .nurseryFieldTree {
            selectedFieldTreeProjectID = nil
            fieldTreeDetailInteractionMode = .viewing
            wantsAddFieldTreeTask = false
        }
        if section != .inventorySoil {
            selectedSoilWorkspaceTab = .stock
            selectedSoilStockID = nil
            selectedSoilMixID = nil
        }
        if section.flatMap(InventoryStockKind.kind(for:)) == nil {
            selectedInventoryStockID = nil
            inventoryStockEditorKind = nil
        }
        if section != .inventoryStockReport {
            pendingStockReportArea = nil
        }
        if section == .gardenCollections {
            selectedTreeID = nil
            treeDetailInteractionMode = .viewing
            pendingTreeQuickAction = nil
        }
        if module != .settings {
            selectedSettingsPane = nil
        }
        if section != .knowledgeHandbook {
            pendingHandbookTopic = nil
        }
        if section != .knowledgeSpeciesLibrary {
            selectedSpeciesProfileID = nil
        }

        // Tree Workspace windows always re-focus their single Tree when returning to Trees or Shaping.
        if section == .gardenTrees || section == .shaping, let workspaceTreeID = treeWorkspaceTreeID {
            selectedTreeID = workspaceTreeID
        }
    }
}
