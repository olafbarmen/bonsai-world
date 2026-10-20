//
//  TreeDetailView.swift
//  Bonsai World
//
//  Tree Detail — View Mode by default; Edit Mode with Auto Save.
//  Finish leaves Edit Mode. Permanent identity is never editable.
//

import SwiftUI

struct TreeDetailView: View {
    /// Debounce after the last edit before persisting (ms).
    private static let autoSaveDebounceMilliseconds: UInt64 = 600
    /// How long “Saved” remains visible.
    private static let savedIndicatorMilliseconds: UInt64 = 1200

    @Environment(AppState.self) private var appState
    @Environment(TreeService.self) private var treeService
    @Environment(ReferenceDataService.self) private var referenceData
    @Environment(ImageService.self) private var imageService
    @Environment(ImageImportService.self) private var imageImportService
    @Environment(TreeMeasurementHistoryStore.self) private var measurementHistory
    @Environment(WorkService.self) private var workService
    @Environment(JournalService.self) private var journalService
    @Environment(GrowingIntelligenceService.self) private var growingIntelligence
    @Environment(PotService.self) private var potService
    @Environment(YamadoriService.self) private var yamadoriService
    @Environment(TaskService.self) private var taskService
    @Environment(WinterCareService.self) private var winterCareService
    @Environment(RepottingCareService.self) private var repottingCare
    @Environment(WeatherService.self) private var weatherService
    @Environment(AppSettings.self) private var appSettings
    @Environment(\.scenePhase) private var scenePhase

    var mode: EditorMode
    var showsCollectionBackButton: Bool = false
    /// When false (embedded under Trees / Yamadori library chrome), do not set a second toolbar title.
    var showsNavigationTitle: Bool = true
    /// When false (Tree Workspace window), do not drive main-window Quick Actions.
    var publishesInteractionModeToAppState: Bool = true

    @State private var interactionMode: TreeDetailInteractionMode = .viewing
    @State private var draft: TreeDetailDraft?
    @State private var lastPersistedDraft: TreeDetailDraft?
    @State private var isMembershipSheetPresented = false
    @State private var isAssignPotSheetPresented = false
    @State private var showRemovePotConfirmation = false
    @State private var potAssignmentErrorMessage: String?
    @State private var selectedImageID: UUID?
    @State private var isImportingPrimaryImage = false
    @State private var autoSaveStatus: TreeAutoSaveStatus = .idle
    @State private var autoSaveTask: Task<Void, Never>?
    @State private var savedIndicatorTask: Task<Void, Never>?
    @State private var isAddMeasurementPresented = false
    @State private var addMeasurementPrefill: TreeMeasurementRecord?
    @State private var isAddWorkPresented = false
    @State private var isAddJournalPresented = false
    @State private var isTreeHistoryPresented = false
    @State private var showDeleteTreeConfirmation = false
    @State private var deleteFailed = false
    @State private var deleteErrorMessage = "The tree could not be deleted. Try again."
    @State private var showReturnToCareConfirmation = false
    @State private var returnToCareFailed = false
    @State private var returnToCareErrorMessage = "The tree could not be returned to My Trees. Try again."
    @State private var showDuplicateTreeConfirmation = false
    @State private var duplicateFailed = false
    @State private var duplicateErrorMessage = "Tree info could not be duplicated. Try again."
    @State private var isFertilizationExpanded = false
    @State private var isFoundAtExpanded = false

    private var treeID: UUID? {
        mode.editingID ?? appState.selectedTreeID
    }

    private var tree: Tree? {
        guard let id = treeID else { return nil }
        return treeService.getTree(id: id)
    }

    private var isEditing: Bool {
        interactionMode.isEditing
    }

    /// Former Trees are history — no Edit, Add Work, or Tasks.
    private var allowsEditing: Bool {
        tree?.isInCare == true
    }

    private var navigationTitleText: String {
        mode.treeEditorTitle(bonsaiName: tree?.bonsaiName ?? "")
    }

    var body: some View {
        VStack(spacing: 0) {
            Group {
            if let tree {
                treeDetail(
                    tree,
                    segment: Binding(
                        get: { appState.treeDetailSegment },
                        set: { newSegment in
                            appState.treeDetailSegment = newSegment
                            syncSidebar(for: newSegment)
                        }
                    )
                )
                    .onAppear {
                        if tree.isInCare {
                            publishInteractionMode()
                        } else {
                            discardDraftAndReturnToViewing()
                            if appState.treeDetailSegment == .shaping {
                                appState.treeDetailSegment = .overview
                            }
                        }
                        syncSelectedImage(for: tree, reason: .treeOpened)
                        migrateMeasurementsIfNeeded(for: tree)
                    }
                    .onChange(of: tree.id) { _, _ in
                        discardDraftAndReturnToViewing()
                        syncSelectedImage(for: tree, reason: .treeOpened)
                        migrateMeasurementsIfNeeded(for: tree)
                    }
                    .onChange(of: tree.isInCare) { _, inCare in
                        // Stay in Edit while finishing disposal fields (date, notes, …).
                        // Autosave may mark the tree Former before the grower leaves Edit.
                        if !inCare, !isEditing {
                            discardDraftAndReturnToViewing()
                        }
                    }
                    .onChange(of: tree.primaryImageID) { _, _ in
                        guard !isEditing else { return }
                        syncSelectedImage(for: tree, reason: .primaryChangedExternally)
                    }
                    .onChange(of: tree.imageIDs) { _, _ in
                        guard !isEditing else { return }
                        syncSelectedImage(for: tree, reason: .galleryChanged)
                    }
                    .onChange(of: appState.pendingTreeQuickAction) { _, request in
                        guard publishesInteractionModeToAppState else { return }
                        guard let request else { return }
                        Task { @MainActor in
                            handleQuickAction(request.command)
                            appState.clearPendingTreeQuickAction()
                        }
                    }
                    .onChange(of: draft) { _, newDraft in
                        guard isEditing, newDraft != nil else { return }
                        scheduleAutoSave()
                    }
                    .onDisappear {
                        flushAutoSaveIfNeeded()
                    }
                    .onChange(of: scenePhase) { _, phase in
                        if phase == .inactive || phase == .background {
                            flushAutoSaveIfNeeded()
                        }
                    }
            } else {
                ContentUnavailableView(
                    "Select a Tree",
                    systemImage: "leaf",
                    description: Text("Choose a tree to see its details.")
                )
                .onAppear {
                    publishInteractionMode(.viewing)
                }
            }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .faloWorkspaceCanvas()
        .modifier(TreeDetailNavigationTitleModifier(
            showsNavigationTitle: showsNavigationTitle,
            title: navigationTitleText,
            onBack: appState.treeWorkspaceTreeID == treeID
                ? { appState.showCurrentList() }
                : nil
        ))
        .sheet(isPresented: $isMembershipSheetPresented) {
            if let draftBinding = draftCollectionBinding {
                CollectionMembershipSheet(memberIDs: draftBinding)
            }
        }
        .sheet(isPresented: $isAssignPotSheetPresented) {
            if let tree {
                TreeAssignPotSheet(
                    treeID: tree.id,
                    excludingPotID: TreeCurrentPotDisplay.resolvedInventoryPot(
                        for: tree,
                        potService: potService
                    )?.id
                )
            }
        }
        .confirmationDialog(
            "Remove Inventory Pot?",
            isPresented: $showRemovePotConfirmation,
            titleVisibility: .visible
        ) {
            Button("Remove Pot", role: .destructive) {
                removeInventoryPotAssignment()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Unlinks this pot from the tree. The pot returns to Available and is not deleted.")
        }
        .alert(
            "Couldn't Update Pot",
            isPresented: Binding(
                get: { potAssignmentErrorMessage != nil },
                set: { if !$0 { potAssignmentErrorMessage = nil } }
            )
        ) {
            Button("OK", role: .cancel) { potAssignmentErrorMessage = nil }
        } message: {
            Text(potAssignmentErrorMessage ?? "")
        }
        .sheet(isPresented: $isAddMeasurementPresented) {
            if let tree, let prefill = addMeasurementPrefill {
                NavigationStack {
                    AddMeasurementSheet(treeID: tree.id, initial: prefill) { record in
                        saveNewMeasurement(record)
                    }
                }
            }
        }
        .onChange(of: isAddMeasurementPresented) { _, presented in
            if !presented { addMeasurementPrefill = nil }
        }
        .sheet(isPresented: $isAddWorkPresented) {
            if let tree {
                NavigationStack {
                    AddWorkSheet(treeID: tree.id)
                }
            }
        }
        .sheet(isPresented: $isAddJournalPresented) {
            if let tree {
                NavigationStack {
                    AddJournalSheet(treeID: tree.id)
                }
            }
        }
        .sheet(isPresented: $isTreeHistoryPresented) {
            if let tree {
                NavigationStack {
                    TreeHistorySheet(document: treeHistoryDocument(for: tree))
                }
            }
        }
        .confirmationDialog(
            "Delete Tree?",
            isPresented: $showDeleteTreeConfirmation,
            titleVisibility: .visible
        ) {
            Button("Delete", role: .destructive) {
                performDeleteTree()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            if let tree {
                Text("“\(TreePresentation.title(for: tree))” will be removed from the library. This cannot be undone. Use this only for a mistaken or duplicate record — not for sold, gifted, dead, or lost trees.")
            } else {
                Text("This tree will be removed from the library. This cannot be undone.")
            }
        }
        .alert("Could Not Delete Tree", isPresented: $deleteFailed) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(deleteErrorMessage)
        }
        .confirmationDialog(
            "Return to My Trees?",
            isPresented: $showReturnToCareConfirmation,
            titleVisibility: .visible
        ) {
            Button("Return to My Trees") {
                performReturnToCare()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            if let tree {
                Text("“\(TreePresentation.title(for: tree))” will leave Former Trees. The disposal record (date, method, notes) is cleared. Tasks and editing become available again.")
            } else {
                Text("The disposal record will be cleared and this tree will return to My Trees.")
            }
        }
        .alert("Could Not Return to My Trees", isPresented: $returnToCareFailed) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(returnToCareErrorMessage)
        }
        .confirmationDialog(
            "Duplicate Tree Info?",
            isPresented: $showDuplicateTreeConfirmation,
            titleVisibility: .visible
        ) {
            Button("Duplicate Tree Info") {
                performDuplicateTree()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            if let tree {
                Text("Create a tree from “\(TreePresentation.title(for: tree))” with a new Bonsai Name. Botanics, placement, pot, and acquisition are copied. Photos, measurements, and notes stay on the original.")
            } else {
                Text("Create a tree with a new Bonsai Name. Photos and history stay on the original.")
            }
        }
        .alert("Could Not Duplicate Tree Info", isPresented: $duplicateFailed) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(duplicateErrorMessage)
        }
    }

    private var draftCollectionBinding: Binding<Set<UUID>>? {
        guard draft != nil else { return nil }
        return Binding(
            get: { draft?.collectionIDs ?? [] },
            set: { draft?.collectionIDs = $0 }
        )
    }

    // MARK: - Quick Actions

    private func handleQuickAction(_ command: TreeQuickActionCommand) {
        switch command {
        case .editTree:
            guard allowsEditing else { return }
            beginEditing()
        case .addActivity:
            guard allowsEditing else { return }
            isAddWorkPresented = true
        case .addImage:
            guard allowsEditing else { return }
            Task { await addImageFromQuickAction() }
        case .showOnMap:
            showTreeLocationOnMap()
        case .cancel:
            finishEditing()
        case .addMeasurement:
            guard allowsEditing else { return }
            presentAddMeasurement()
        case .addJournal:
            guard allowsEditing else { return }
            isAddJournalPresented = true
        case .viewTreeHistory:
            isTreeHistoryPresented = true
        case .viewImages:
            if let treeID {
                appState.showTreeImages(treeID: treeID)
            } else {
                appState.selectSection(.mediaImages)
            }
        case .duplicateTree:
            guard allowsEditing else { return }
            showDuplicateTreeConfirmation = true
        case .deleteTree:
            showDeleteTreeConfirmation = true
        case .returnToCare:
            showReturnToCareConfirmation = true
        }
    }

    private func performDuplicateTree() {
        guard let tree else { return }
        let genusName = tree.genusID.flatMap { referenceData.genus(id: $0)?.name } ?? ""
        let speciesName: String = {
            guard let id = tree.speciesID, let species = referenceData.species(id: id) else {
                return ""
            }
            return species.epithet.isEmpty ? species.name : species.epithet
        }()
        let cultivarName = tree.cultivarID.flatMap { referenceData.cultivar(id: $0)?.name }
        do {
            let copy = try treeService.duplicateTree(
                id: tree.id,
                genusName: genusName,
                speciesName: speciesName,
                cultivarName: cultivarName
            )
            appState.selectedTreeID = copy.id
        } catch {
            duplicateErrorMessage = error.localizedDescription.isEmpty
                ? "Tree info could not be duplicated. Try again."
                : error.localizedDescription
            duplicateFailed = true
        }
    }

    private func performReturnToCare() {
        guard let id = treeID else { return }
        do {
            try treeService.returnToCare(id: id)
        } catch {
            returnToCareErrorMessage = error.localizedDescription.isEmpty
                ? "The tree could not be returned to My Trees. Try again."
                : error.localizedDescription
            returnToCareFailed = true
        }
    }

    private func performDeleteTree() {
        guard let id = treeID else { return }
        discardDraftAndReturnToViewing()
        do {
            // Pot must unlink while the Tree still exists (clears Tree.currentPotID).
            try? potService.unassignCurrentPot(fromTreeID: id)
            taskService.unlinkDeletedTree(id)
            yamadoriService.clearLinkedTreeReference(treeID: id)
            measurementHistory.removeAll(for: id)
            try treeService.deleteTree(id: id)
            appState.selectedTreeID = nil
        } catch {
            deleteErrorMessage = error.localizedDescription.isEmpty
                ? "The tree could not be deleted. Try again."
                : error.localizedDescription
            deleteFailed = true
        }
    }

    private func showTreeLocationOnMap() {
        guard let tree else { return }
        let location = referenceData.location(id: tree.locationID)
        guard let location, location.hasGeographicPosition else {
            // Still open Locations so the user can set a position.
            appState.showLocationOnMap(locationID: tree.locationID)
            return
        }
        appState.showLocationOnMap(locationID: location.id)
    }

    private func addImageFromQuickAction() async {
        guard tree != nil else { return }
        if !isEditing {
            beginEditing()
        }
        await importGalleryImage()
    }

    // MARK: - View / Edit

    private func beginEditing() {
        guard allowsEditing, let tree else { return }
        let membership = Set(treeService.collections(for: tree.id).filter(\.isManual).map(\.id))
        var captured = TreeDetailDraft.capture(from: tree, collectionIDs: membership)
        captured.imageIDs = sortedImageIDs(captured.imageIDs)
        draft = captured
        lastPersistedDraft = captured
        autoSaveStatus = .idle
        publishInteractionMode(.editing)
        syncSelectedImage(for: tree, reason: .editingBegan)
    }

    /// Leaves Edit Mode. Does not discard. Does not run a manual Save —
    /// only completes any pending Auto Save debounce, then returns to View Mode.
    private func finishEditing() {
        autoSaveTask?.cancel()
        autoSaveTask = nil
        Task { await persistDraftNow(exitEditing: true) }
    }

    private func discardDraftAndReturnToViewing() {
        autoSaveTask?.cancel()
        autoSaveTask = nil
        savedIndicatorTask?.cancel()
        savedIndicatorTask = nil
        draft = nil
        lastPersistedDraft = nil
        autoSaveStatus = .idle
        publishInteractionMode(.viewing)
    }

    private func publishInteractionMode(_ mode: TreeDetailInteractionMode? = nil) {
        let next = mode ?? interactionMode
        interactionMode = next
        guard publishesInteractionModeToAppState else { return }
        // Sidebar Quick Actions read AppState during the same frame Detail appears.
        Task { @MainActor in
            appState.treeDetailInteractionMode = next
        }
    }

    // MARK: - Auto Save

    private func scheduleAutoSave() {
        guard isEditing, let draft else { return }
        guard draft != lastPersistedDraft else { return }

        autoSaveTask?.cancel()
        autoSaveTask = Task { @MainActor in
            do {
                try await Task.sleep(nanoseconds: Self.autoSaveDebounceMilliseconds * 1_000_000)
            } catch {
                return
            }
            guard !Task.isCancelled else { return }
            await persistDraftNow(exitEditing: false)
        }
    }

    /// Immediate persist of pending edits (app resign / navigate away).
    private func flushAutoSaveIfNeeded() {
        guard isEditing else { return }
        guard let draft, draft != lastPersistedDraft else { return }
        autoSaveTask?.cancel()
        autoSaveTask = nil
        Task { await persistDraftNow(exitEditing: false) }
    }

    @MainActor
    private func persistDraftNow(exitEditing: Bool) async {
        guard isEditing, let tree else {
            if exitEditing { discardDraftAndReturnToViewing() }
            return
        }
        guard var currentDraft = draft else {
            if exitEditing { discardDraftAndReturnToViewing() }
            return
        }

        if currentDraft == lastPersistedDraft {
            if exitEditing {
                discardDraftAndReturnToViewing()
                if let updated = treeService.getTree(id: tree.id) {
                    syncSelectedImage(for: updated, reason: .editingEnded)
                }
            }
            return
        }

        autoSaveStatus = .saving
        do {
            for (id, name) in currentDraft.photoNames {
                imageService.updatePhotoName(id: id, photoName: name)
            }
            for (id, date) in currentDraft.photoCaptureDates {
                imageService.updateCaptureDate(id: id, captureDate: date)
            }
            let deleted = currentDraft.pendingDeletedImageIDs
            currentDraft.pendingDeletedImageIDs = []
            currentDraft.pendingAddedImageIDs = []
            currentDraft.photoNames = [:]
            currentDraft.photoCaptureDates = [:]
            currentDraft.imageIDs = sortedImageIDs(currentDraft.imageIDs)
            try treeService.applyDetailDraft(id: tree.id, draft: currentDraft)
            try? repottingCare.syncSchedule(for: tree.id)
            if let primary = currentDraft.primaryImageID {
                imageService.setPrimaryFlag(id: primary)
            }
            for id in deleted {
                try? await imageService.deletePhoto(id: id)
            }

            if let updated = treeService.getTree(id: tree.id) {
                let membership = Set(treeService.collections(for: updated.id).filter(\.isManual).map(\.id))
                let refreshed = TreeDetailDraft.capture(from: updated, collectionIDs: membership)
                draft = refreshed
                lastPersistedDraft = refreshed
                syncSelectedImage(
                    for: updated,
                    reason: exitEditing ? .editingEnded : .galleryChanged
                )
            } else {
                lastPersistedDraft = currentDraft
                draft = currentDraft
            }

            autoSaveStatus = .saved
            showSavedThenIdle()

            if exitEditing {
                discardDraftAndReturnToViewing()
            }
        } catch {
            autoSaveStatus = .failed
            // Stay in Edit Mode so the user can keep editing or retry via further changes.
        }
    }

    private func showSavedThenIdle() {
        savedIndicatorTask?.cancel()
        savedIndicatorTask = Task { @MainActor in
            do {
                try await Task.sleep(nanoseconds: Self.savedIndicatorMilliseconds * 1_000_000)
            } catch {
                return
            }
            guard !Task.isCancelled else { return }
            if autoSaveStatus == .saved {
                autoSaveStatus = .idle
            }
        }
    }

    private func handleCollectionBack() {
        if isEditing {
            finishEditing()
        }
        appState.selectedTreeID = nil
        publishInteractionMode(.viewing)
    }

    @ViewBuilder
    private func treeDetail(_ tree: Tree, segment: Binding<TreeDetailSegment>) -> some View {
        let memberships = displayedMemberships(for: tree)
        let showsShapingSegment = allowsEditing
        let activeSegment = showsShapingSegment ? segment.wrappedValue : .overview

        VStack(spacing: 0) {
            if showsCollectionBackButton {
                HStack {
                    Button {
                        handleCollectionBack()
                    } label: {
                        Label("Collections", systemImage: "chevron.left")
                    }
                    .buttonStyle(.borderless)
                    Spacer()
                }
                .padding(.horizontal, FaloSpacing.xLarge)
                .padding(.top, FaloSpacing.medium)
            }

            if showsShapingSegment {
                WorkspaceSegmentPickerChrome(
                    title: "Tree Detail",
                    selection: segment,
                    options: TreeDetailSegment.allCases.map { ($0.title, $0) }
                )
            }

            if isEditing, activeSegment == .overview {
                TreeAutoSaveBanner(status: autoSaveStatus)
            }

            if activeSegment == .shaping, showsShapingSegment {
                ShapingEditorView(treeID: tree.id)
                    .environment(imageService)
                    .environment(imageImportService)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                treeOverviewContent(tree: tree, memberships: memberships)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func syncSidebar(for segment: TreeDetailSegment) {
        switch segment {
        case .overview where appState.selectedSection == .shaping:
            appState.selectedSection = .gardenTrees
        case .shaping where appState.selectedSection == .gardenTrees:
            appState.selectedSection = .shaping
        default:
            break
        }
    }

    @ViewBuilder
    private func treeOverviewContent(tree: Tree, memberships: [Collection]) -> some View {
        FaloAdaptiveDesktopWorkspace(profile: isEditing ? .treeDetail : .treeOverview) {
            VStack(alignment: .leading, spacing: isEditing ? TreeDetailSpacing.cardGap : TreeOverviewSpacing.cardGap) {
                if isEditing {
                    treeOverviewEditColumns(tree: tree, memberships: memberships)
                    TreeTimelineSection(
                        events: timelineEvents(for: tree),
                        onViewTreeHistory: { isTreeHistoryPresented = true }
                    )
                } else {
                    treeOverviewViewMode(tree: tree, memberships: memberships)
                }
            }
        }
        .background(isEditing ? Color.clear : BonsaiWorldColors.canvas)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    // MARK: - View Mode (hero + 4-column Dashboard grid)

    @ViewBuilder
    private func treeOverviewViewMode(tree: Tree, memberships: [Collection]) -> some View {
        TreeOverviewContentWidthReader { contentWidth in
            overviewGrid(tree: tree, memberships: memberships, contentWidth: contentWidth)
        }
    }

    @ViewBuilder
    private func overviewGrid(tree: Tree, memberships: [Collection], contentWidth: CGFloat) -> some View {
        let gap = TreeOverviewSpacing.cardGap
        let column = TreeOverviewGridMetrics.columnWidth(in: contentWidth)
        let span2 = TreeOverviewGridMetrics.spanWidth(2, in: contentWidth)
        let fullWidth = TreeOverviewGridMetrics.spanWidth(4, in: contentWidth)
        let notesExcerpt = overviewNotesExcerpt(tree.notes)
        let stageTitle = treeStageDisplayName(for: tree)
        let locationTitle = locationDisplayName(for: tree)
        let imageIDs = displayedImageIDs(for: tree)
        let plan = fertilizationPlan(for: tree)
        let sourceFind = sourceYamadoriFind(for: tree)

        VStack(alignment: .leading, spacing: gap) {
            // Hero pads inside the raised surface — columns must fit the *inner* width
            // or the card overflows and the trailing corners look square when clipped.
            let heroInnerWidth = max(0, fullWidth - (2 * TreeOverviewSpacing.cardPadding))
            let heroColumn = TreeOverviewGridMetrics.columnWidth(in: heroInnerWidth)
            overviewHero(
                tree: tree,
                columnWidth: heroColumn,
                notesExcerpt: notesExcerpt,
                stageTitle: stageTitle.isEmpty ? nil : stageTitle,
                locationTitle: locationTitle,
                photoCount: imageIDs.count
            )
            .frame(width: fullWidth, alignment: .topLeading)

            // Row 1 — Tree Information: Photos (2) + Collections (1) + Additional Information (1).
            FaloEqualHeightRow(spacing: gap) {
                TreeOverviewPhotosCard(
                    imageIDs: imageIDs,
                    imageService: imageService,
                    allowsEditing: allowsEditing,
                    onSelectImage: { selectedImageID = $0 },
                    onAddPhoto: { handleQuickAction(.addImage) },
                    onDropImageFiles: allowsEditing
                        ? { sources in Task { await importDroppedGalleryImages(sources) } }
                        : nil,
                    onViewAll: imageIDs.isEmpty
                        ? nil
                        : { handleQuickAction(.viewImages) },
                    fillsRowHeight: true
                )
                .frame(width: span2)

                TreeOverviewCollectionsCard(
                    items: memberships.map { ($0.id, $0.name) },
                    onSelect: { appState.showCollection($0) },
                    fillsRowHeight: true
                )
                    .frame(width: column)

                TreeOverviewAdditionalInfoCard(
                    acquired: overviewAcquiredLabel(for: tree),
                    source: overviewSourceLabel(for: tree),
                    value: overviewValueLabel(for: tree),
                    fillsRowHeight: true
                )
                .frame(width: column)
            }

            // Row 2 — Work & Care: Health & Care (1) + Next Work (2) + Fertilization (1).
            FaloEqualHeightRow(spacing: gap) {
                TreeOverviewHealthCareCard(
                    healthTitle: tree.healthStatus.title,
                    healthSystemImage: tree.healthStatus.systemImage,
                    healthNeedsAttention: tree.healthStatus == .needsAttention
                        || tree.healthStatus == .recovering,
                    healthCause: tree.healthCause,
                    placementStrategy: tree.placementStrategy,
                    onPlacementStrategyChange: allowsEditing
                        ? { newValue in setPlacementStrategy(newValue, for: tree.id) }
                        : nil,
                    seasonPlacement: tree.seasonPlacement,
                    onSeasonPlacementChange: allowsEditing
                        ? { newValue in setSeasonPlacement(newValue, for: tree.id) }
                        : nil,
                    lastWateredLabel: overviewRelativeDateLabel(lastWateredAt(for: tree)),
                    lastFertilizedLabel: overviewRelativeDateLabel(lastFertilizedAt(for: tree)),
                    fillsRowHeight: true
                )
                .frame(width: column)

                TreeUpcomingTasksSection(
                    treeID: tree.id,
                    title: "Next Work",
                    includesOverdue: false,
                    usesDashboardChrome: true,
                    fillsRowHeight: true
                )
                .frame(width: span2)

                ExpandableSection(
                    title: "Fertilization",
                    summaryRows: [
                        ExpandableSectionSummaryRow(label: "Recommendation", value: plan.recommendation),
                        ExpandableSectionSummaryRow(label: "When", value: plan.when),
                    ].filter { !$0.value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty },
                    chrome: .overview,
                    fillsRowHeight: true,
                    isExpanded: $isFertilizationExpanded
                ) {
                    TreeFertilizationSection(
                        plan: plan,
                        seasonTitle: FertilizerSeasonCalendar.season(from: .now).title,
                        treeStageName: treeStageDisplayName(for: tree),
                        fertilizationModeTitle: fertilizationModeTitle(for: tree),
                        fertilizerHealth: .constant(tree.fertilizerHealth),
                        fertilizerKindOverride: .constant(tree.fertilizerKindOverride),
                        isEditing: false,
                        showsCardChrome: false
                    )
                }
                .frame(width: column)
            }

            // Historical origin (Yamadori) — above Timeline, not part of Work & Care.
            if let find = sourceFind {
                ExpandableSection(
                    title: "Found At",
                    summaryRows: [
                        ExpandableSectionSummaryRow(
                            label: "Find",
                            value: find.displayName.isEmpty ? find.yamadoriCode : find.displayName
                        )
                    ],
                    chrome: .overview,
                    fillsRowHeight: false,
                    isExpanded: $isFoundAtExpanded
                ) {
                    VStack(alignment: .leading, spacing: FaloSpacing.small) {
                        Button {
                            appState.openYamadoriFindAtLastPosition(find: find, tree: tree)
                        } label: {
                            HStack {
                                Text(find.displayName.isEmpty ? find.yamadoriCode : find.displayName)
                                    .font(FaloTypography.body)
                                    .foregroundStyle(.primary)
                                Spacer()
                                Text("Open")
                                    .font(FaloTypography.caption)
                                    .foregroundStyle(BonsaiWorldColors.accent)
                                Image(systemName: "chevron.right")
                                    .font(.caption.weight(.semibold))
                                    .foregroundStyle(.tertiary)
                            }
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)

                        YamadoriSiteMapCard(
                            title: "Found At",
                            latitude: .constant(find.latitude),
                            longitude: .constant(find.longitude),
                            primaryTitle: find.displayName.isEmpty ? find.yamadoriCode : find.displayName,
                            isEditing: false,
                            secondaryPins: [],
                            focusedLatitudeDelta: 0.015,
                            mapHeight: 200
                        )
                    }
                }
                .frame(width: span2, alignment: .topLeading)
            }

            TreeTimelineSection(
                events: timelineEvents(for: tree),
                usesRaisedChrome: true,
                onViewTreeHistory: { isTreeHistoryPresented = true }
            )
            .frame(width: fullWidth, alignment: .topLeading)

            // Social is neither tree metadata, work, nor history — after Timeline.
            TreeSocialShareCard(
                level: tree.socialShareLevel,
                isSocialEnabled: appSettings.isSocialEnabled,
                isEditing: false,
                onChange: { setSocialShareLevel($0, for: tree) }
            )
            .frame(width: fullWidth, alignment: .topLeading)
        }
        .frame(width: contentWidth, alignment: .topLeading)
    }

    @ViewBuilder
    private func overviewHero(
        tree: Tree,
        columnWidth: CGFloat,
        notesExcerpt: String?,
        stageTitle: String?,
        locationTitle: String?,
        photoCount: Int
    ) -> some View {
        // Fixed 5:6 hero height — does not grow when the window widens.
        let photoHeight = TreeOverviewGridMetrics.heroColumnHeight

        TreeOverviewHeroBanner(
            bonsaiName: tree.bonsaiName,
            botanicalName: tree.botanicalName,
            nickname: tree.nickname,
            genusName: genusDisplayName(for: tree),
            speciesName: speciesDisplayName(for: tree),
            cultivarName: cultivarDisplayName(for: tree),
            propagation: propagationDisplay(for: tree),
            origin: originDisplayName(for: tree),
            countryOfOrigin: countryOfOriginDisplay(for: tree),
            healthTitle: tree.healthStatus.title,
            healthSystemImage: tree.healthStatus.systemImage,
            healthNeedsAttention: tree.healthStatus == .needsAttention
                || tree.healthStatus == .recovering,
            locationTitle: locationTitle,
            stageTitle: stageTitle,
            notesExcerpt: notesExcerpt,
            photoCount: photoCount,
            columnWidth: columnWidth,
            photoHeight: photoHeight
        ) {
            overviewPresencePhoto(tree: tree, maxHeight: photoHeight)
        } currentState: {
            TreeOverviewCurrentStateCard(
                actionableRows: currentStateRows(for: tree),
                fillsRowHeight: true
            )
        } species: {
            overviewSpeciesTeaser(for: tree, fillsRowHeight: true)
        }
    }

    @ViewBuilder
    private func overviewSpeciesTeaser(for tree: Tree, fillsRowHeight: Bool) -> some View {
        if let speciesID = tree.speciesID,
           let speciesProfile = SpeciesProfileCatalog.profile(
            speciesID: speciesID,
            cultivarID: tree.cultivarID
           ) {
            TreeOverviewSpeciesTeaser(
                scientificName: speciesProfile.scientificName,
                commonName: speciesProfile.primaryCommonName,
                summaryLine: speciesProfile.summaryLine,
                onOpenProfile: { appState.openSpeciesProfile(speciesID: speciesProfile.id) },
                fillsRowHeight: fillsRowHeight
            )
        } else {
            TreeOverviewSpeciesTeaser.notRegistered(
                botanicalName: tree.botanicalName.isEmpty
                    ? speciesDisplayName(for: tree)
                    : tree.botanicalName,
                fillsRowHeight: fillsRowHeight
            )
        }
    }

    @ViewBuilder
    private func overviewPresencePhoto(tree: Tree, maxHeight: CGFloat) -> some View {
        TreePhotoManagerSection(
            treeID: tree.id,
            imageIDs: displayedImageIDs(for: tree),
            primaryImageID: displayedPrimaryImageID(for: tree),
            photoNames: displayedPhotoNames(for: tree),
            captureDates: displayedCaptureDates(for: tree),
            selectedImageID: $selectedImageID,
            isEditing: false,
            showsFilmstrip: false,
            previewMaxHeight: maxHeight,
            onAddImage: {},
            onSelectImage: { selectedImageID = $0 },
            onSetPrimary: { setPrimaryPhoto($0) },
            onUpdatePhotoMetadata: { id, name, date in
                updatePhotoMetadata(id: id, name: name, captureDate: date)
            },
            onDeletePhoto: { deletePhoto(id: $0) }
        )
        .frame(maxWidth: .infinity, maxHeight: maxHeight, alignment: .top)
    }

    private func currentStateRows(
        for tree: Tree
    ) -> [(label: String, value: String, systemImage: String, action: (() -> Void)?)] {
        var rows: [(String, String, String, (() -> Void)?)] = []
        let stage = treeStageDisplayName(for: tree)
        if !stage.isEmpty { rows.append(("Stage", stage, "leaf", nil)) }
        let light = DetailOptionPickerRow.displayName(
            for: tree.lightConditionID,
            in: DetailPickerOption.map(referenceData.lightConditions)
        )
        if !light.isEmpty { rows.append(("Light", light, "sun.max", nil)) }
        let soil = DetailOptionPickerRow.displayName(
            for: tree.soilMixID,
            in: DetailPickerOption.map(referenceData.soilMixes)
        )
        if !soil.isEmpty { rows.append(("Soil", soil, "circle.grid.cross", nil)) }
        let potDisplay = TreeCurrentPotDisplay.resolve(
            tree: tree,
            potService: potService,
            referenceData: referenceData
        )
        if let potTitle = potDisplay.title, !potTitle.isEmpty {
            let openPot: (() -> Void)? = {
                guard let potID = TreeCurrentPotDisplay.resolvedInventoryPot(
                    for: tree,
                    potService: potService
                )?.id else { return nil }
                return { appState.showInventoryPot(potID) }
            }()
            rows.append(("Pot", potTitle, "archivebox", openPot))
        }
        let style = DetailOptionPickerRow.displayName(
            for: tree.styleID,
            in: DetailPickerOption.map(referenceData.styles)
        )
        if !style.isEmpty { rows.append(("Style", style, "paintbrush", nil)) }
        return rows
    }

    private func overviewNotesExcerpt(_ notes: String) -> String? {
        let trimmed = notes.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return nil }
        if trimmed.count <= 120 { return trimmed }
        return String(trimmed.prefix(117)) + "…"
    }

    /// Relative date for Overview care rows — `nil` when no event (row is omitted, not "-").
    private func overviewRelativeDateLabel(_ date: Date?) -> String? {
        guard let date else { return nil }
        if Calendar.current.isDateInToday(date) { return "Today" }
        if Calendar.current.isDateInYesterday(date) { return "Yesterday" }
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: date, relativeTo: .now)
    }

    private func lastWateredAt(for tree: Tree) -> Date? {
        workService.history(for: tree.id)
            .filter { taskService.expiresIfMissed(workTypeID: $0.workTypeID) }
            .map(\.performedAt)
            .max()
    }

    private func overviewAcquiredLabel(for tree: Tree) -> String {
        guard let date = tree.acquisitionDate else { return "" }
        return date.formatted(date: .abbreviated, time: .omitted)
    }

    private func overviewSourceLabel(for tree: Tree) -> String {
        let source = tree.acquisitionSourceName.trimmingCharacters(in: .whitespacesAndNewlines)
        if !source.isEmpty { return source }
        return DetailOptionPickerRow.displayName(
            for: tree.acquisitionMethodID,
            in: DetailPickerOption.map(referenceData.acquisitionMethods)
        )
    }

    private func overviewValueLabel(for tree: Tree) -> String {
        CurrencyFormatting.string(tree.purchasePrice, currency: appSettings.currency, empty: "")
    }

    private func locationDisplayName(for tree: Tree) -> String? {
        let name = referenceData.location(id: tree.locationID)?.name
            ?? DetailOptionPickerRow.displayName(
                for: tree.locationID,
                in: DetailPickerOption.map(referenceData.locations)
            )
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? nil : trimmed
    }

    // MARK: - Edit Mode (existing form columns)

    @ViewBuilder
    private func treeOverviewEditColumns(tree: Tree, memberships: [Collection]) -> some View {
                TreeDetailCardColumns {
                        TreePhotoManagerSection(
                            treeID: tree.id,
                            imageIDs: displayedImageIDs(for: tree),
                            primaryImageID: displayedPrimaryImageID(for: tree),
                            photoNames: displayedPhotoNames(for: tree),
                            captureDates: displayedCaptureDates(for: tree),
                            selectedImageID: $selectedImageID,
                            isEditing: isEditing,
                            onAddImage: {
                                Task { await importGalleryImage() }
                            },
                            onDropImageFiles: { sources in
                                Task { await importDroppedGalleryImages(sources) }
                            },
                            onSelectImage: { imageID in
                                selectedImageID = imageID
                            },
                            onSetPrimary: { imageID in
                                setPrimaryPhoto(imageID)
                            },
                            onUpdatePhotoMetadata: { imageID, name, date in
                                updatePhotoMetadata(id: imageID, name: name, captureDate: date)
                            },
                            onDeletePhoto: { imageID in
                                deletePhoto(id: imageID)
                            }
                        )
                        IdentitySection(
                            bonsaiName: tree.bonsaiName,
                            botanicalName: tree.botanicalName,
                            nickname: nicknameBinding(for: tree),
                            genusName: genusDisplayName(for: tree),
                            speciesName: speciesDisplayName(for: tree),
                            cultivarName: cultivarDisplayName(for: tree),
                            origin: originDisplayName(for: tree),
                            propagation: propagationBinding(for: tree),
                            propagationTitle: propagationDisplay(for: tree),
                            countryOfOrigin: countryOfOriginBinding(for: tree),
                            originYear: originYearBinding(for: tree),
                            isEditing: isEditing
                        )
                        GrowingSection(
                            styleID: styleIDBinding,
                            locationID: standingLocationIDBinding(for: tree),
                            homeLocationID: homeLocationIDBinding(for: tree),
                            winterLocationID: winterLocationIDBinding(for: tree),
                            healthStatus: healthStatusBinding(for: tree),
                            healthCause: healthCauseBinding(for: tree),
                            lastRepottedDate: lastRepottedDateBinding(for: tree),
                            repottingIntervalYears: repottingIntervalYearsBinding(for: tree),
                            placementStrategy: placementStrategyBinding(for: tree),
                            seasonPlacement: seasonPlacementBinding(for: tree),
                            treeStageID: treeStageIDBinding,
                            sizeClassID: sizeClassIDBinding,
                            lightConditionID: lightConditionIDBinding,
                            soilMixID: soilMixIDBinding,
                            styles: DetailPickerOption.map(referenceData.styles),
                            locations: DetailPickerOption.map(referenceData.locations),
                            treeStages: DetailPickerOption.map(referenceData.treeStages),
                            sizeClasses: DetailPickerOption.map(referenceData.sizeClasses),
                            lightConditions: DetailPickerOption.map(referenceData.lightConditions),
                            soilMixes: DetailPickerOption.map(referenceData.soilMixes),
                            selectedSoilMix: selectedSoilMix(for: tree),
                            soilComponentNames: soilComponentNames(for: tree),
                            isEditing: isEditing
                        )
                        TreeWateringPolicySection(
                            effective: treeService.effectiveWateringPolicy(for: tree.id),
                            carePolicyCollections: treeService.carePolicyCollections(),
                            carePolicyCollectionID: carePolicyCollectionIDBinding(for: tree),
                            wateringModeOverride: wateringModeOverrideBinding(for: tree),
                            autoTimesPerDayOverride: autoTimesPerDayOverrideBinding(for: tree),
                            isEditing: isEditing
                        )
                        MeasurementHistorySection(
                            records: measurementHistory.timeline(for: tree.id),
                            onAddMeasurement: isEditing
                                ? { presentAddMeasurement() }
                                : nil
                        )
                    } column1: {
                        OwnershipSection(
                            acquisitionDate: acquisitionDateBinding,
                            acquisitionMethodID: acquisitionMethodIDBinding,
                            acquisitionSourceName: acquisitionSourceNameBinding,
                            purchasePrice: purchasePriceBinding,
                            acquisitionNotes: acquisitionNotesBinding,
                            disposalDate: disposalDateBinding,
                            disposalMethodID: disposalMethodIDBinding,
                            disposalPartyName: disposalPartyNameBinding,
                            disposalPrice: disposalPriceBinding,
                            disposalNotes: disposalNotesBinding,
                            acquisitionMethods: DetailPickerOption.map(referenceData.acquisitionMethods),
                            disposalMethods: DetailPickerOption.map(referenceData.disposalMethods),
                            isEditing: isEditing
                        )
                        TreeKnownHistorySection(
                            text: knownHistoryBinding(for: tree),
                            isEditing: isEditing
                        )
                        collectionsBlock(memberships: memberships)
                        PotSection(
                            inventoryPot: TreeCurrentPotDisplay.resolvedInventoryPot(
                                for: tree,
                                potService: potService
                            ),
                            inventoryPotDisplayName: inventoryPotDisplayName(for: tree),
                            potTypeID: potTypeIDBinding,
                            potColor: potColorBinding,
                            potLengthMillimetres: potLengthMillimetresBinding,
                            potWidthMillimetres: potWidthMillimetresBinding,
                            potHeightMillimetres: potHeightMillimetresBinding,
                            potDiameterMillimetres: potDiameterMillimetresBinding,
                            potTypes: DetailPickerOption.map(referenceData.potTypes),
                            isEditing: isEditing,
                            onAssignInventoryPot: { isAssignPotSheetPresented = true },
                            onChangeInventoryPot: { isAssignPotSheetPresented = true },
                            onRemoveInventoryPot: { showRemovePotConfirmation = true },
                            onOpenInventoryPot: {
                                if let potID = tree.currentPotID {
                                    appState.showInventoryPot(potID)
                                }
                            }
                        )
                        TreeFertilizationSection(
                            plan: fertilizationPlan(for: tree),
                            seasonTitle: FertilizerSeasonCalendar.season(from: .now).title,
                            treeStageName: treeStageDisplayName(for: tree),
                            fertilizationModeTitle: fertilizationModeTitle(for: tree),
                            fertilizerHealth: fertilizerHealthBinding(for: tree),
                            fertilizerKindOverride: fertilizerKindOverrideBinding(for: tree),
                            isEditing: isEditing
                        )
                    } column2: {
                        if let find = sourceYamadoriFind(for: tree) {
                            VStack(alignment: .leading, spacing: FaloSpacing.small) {
                                if !isEditing {
                                    Button {
                                        appState.openYamadoriFindAtLastPosition(find: find, tree: tree)
                                    } label: {
                                        HStack {
                                            Text(find.displayName.isEmpty ? find.yamadoriCode : find.displayName)
                                                .font(FaloTypography.body)
                                                .foregroundStyle(.primary)
                                            Spacer()
                                            Text("Open")
                                                .font(FaloTypography.caption)
                                                .foregroundStyle(BonsaiWorldColors.accent)
                                            Image(systemName: "chevron.right")
                                                .font(.caption.weight(.semibold))
                                                .foregroundStyle(.tertiary)
                                        }
                                        .contentShape(Rectangle())
                                    }
                                    .buttonStyle(.plain)
                                }

                                YamadoriSiteMapCard(
                                    title: "Found At",
                                    latitude: .constant(find.latitude),
                                    longitude: .constant(find.longitude),
                                    primaryTitle: find.displayName.isEmpty ? find.yamadoriCode : find.displayName,
                                    isEditing: false,
                                    secondaryPins: [],
                                    focusedLatitudeDelta: 0.015,
                                    mapHeight: 200
                                )
                            }
                        }
                        TreeSocialShareCard(
                            level: tree.socialShareLevel,
                            isSocialEnabled: appSettings.isSocialEnabled,
                            isEditing: true,
                            onChange: { setSocialShareLevel($0, for: tree) }
                        )
                        TreeNotesSection(
                            text: notesBinding(for: tree),
                            isEditing: isEditing,
                            layout: .journalColumn
                        )
                    }
    }

    private func displayedMemberships(for tree: Tree) -> [Collection] {
        if isEditing, let draft {
            return treeService.collections.filter { $0.isManual && draft.collectionIDs.contains($0.id) }
        }
        return treeService.collections(for: tree.id).filter(\.isManual)
    }

    private func collectionsBlock(memberships: [Collection]) -> some View {
        DetailCard(title: "Collections") {
            RelatedCollectionsSection(
                title: "Collections",
                showsHeader: false,
                items: memberships.map {
                    RelatedCollectionItem(
                        id: $0.id,
                        name: $0.name,
                        treeCount: $0.treeIDs.count
                    )
                },
                showsDisclosureIndicator: false,
                emptyTitle: "Not in any Collection",
                emptyDescription: isEditing
                    ? "Use Add to Collection to organize this tree."
                    : "This tree is not in any Collection."
            )

            if isEditing {
                Button {
                    isMembershipSheetPresented = true
                } label: {
                    Label("Add to Collection", systemImage: "plus")
                }
                .buttonStyle(.bordered)
                .padding(.top, FaloSpacing.small)
            }
        }
    }

    // MARK: - Draft bindings (Edit Mode only writes local draft)

    private func nicknameBinding(for tree: Tree) -> Binding<String> {
        Binding(
            get: { isEditing ? (draft?.nickname ?? tree.nickname) : tree.nickname },
            set: { draft?.nickname = $0 }
        )
    }

    private func countryOfOriginBinding(for tree: Tree) -> Binding<String> {
        Binding(
            get: { isEditing ? (draft?.countryOfOrigin ?? tree.countryOfOrigin) : tree.countryOfOrigin },
            set: { draft?.countryOfOrigin = $0 }
        )
    }

    private func countryOfOriginDisplay(for tree: Tree) -> String {
        let value = isEditing
            ? (draft?.countryOfOrigin ?? tree.countryOfOrigin)
            : tree.countryOfOrigin
        return value.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private func propagationBinding(for tree: Tree) -> Binding<TreePropagation?> {
        Binding(
            get: { isEditing ? (draft?.propagation ?? tree.propagation) : tree.propagation },
            set: { draft?.propagation = $0 }
        )
    }

    private func propagationDisplay(for tree: Tree) -> String {
        let value = isEditing ? (draft?.propagation ?? tree.propagation) : tree.propagation
        return value?.title ?? ""
    }

    private func originYearBinding(for tree: Tree) -> Binding<Int?> {
        Binding(
            get: { isEditing ? (draft?.originYear ?? tree.originYear) : tree.originYear },
            set: { draft?.originYear = Tree.sanitizedOriginYear($0) }
        )
    }

    private func notesBinding(for tree: Tree) -> Binding<String> {
        Binding(
            get: { isEditing ? (draft?.notes ?? tree.notes) : tree.notes },
            set: { draft?.notes = $0 }
        )
    }

    private func knownHistoryBinding(for tree: Tree) -> Binding<String> {
        Binding(
            get: { isEditing ? (draft?.knownHistory ?? tree.knownHistory) : tree.knownHistory },
            set: { draft?.knownHistory = $0 }
        )
    }

    private func carePolicyCollectionIDBinding(for tree: Tree) -> Binding<UUID?> {
        Binding(
            get: { isEditing ? (draft?.carePolicyCollectionID ?? tree.carePolicyCollectionID) : tree.carePolicyCollectionID },
            set: { draft?.carePolicyCollectionID = $0 }
        )
    }

    private func wateringModeOverrideBinding(for tree: Tree) -> Binding<WateringMode?> {
        Binding(
            get: { isEditing ? (draft?.wateringModeOverride ?? tree.wateringModeOverride) : tree.wateringModeOverride },
            set: { draft?.wateringModeOverride = $0 }
        )
    }

    private func autoTimesPerDayOverrideBinding(for tree: Tree) -> Binding<Int?> {
        Binding(
            get: { isEditing ? (draft?.autoTimesPerDayOverride ?? tree.autoTimesPerDayOverride) : tree.autoTimesPerDayOverride },
            set: { draft?.autoTimesPerDayOverride = $0 }
        )
    }

    private var styleIDBinding: Binding<UUID?> {
        Binding(
            get: { draft?.styleID ?? tree?.styleID },
            set: { draft?.styleID = $0 }
        )
    }

    private var sizeClassIDBinding: Binding<UUID?> {
        Binding(
            get: { draft?.sizeClassID ?? tree?.sizeClassID },
            set: { draft?.sizeClassID = $0 }
        )
    }

    private var treeStageIDBinding: Binding<UUID?> {
        Binding(
            get: { draft?.treeStageID ?? tree?.treeStageID },
            set: { draft?.treeStageID = $0 }
        )
    }

    private func healthStatusBinding(for tree: Tree) -> Binding<TreeHealthStatus> {
        Binding(
            get: { isEditing ? (draft?.healthStatus ?? tree.healthStatus) : tree.healthStatus },
            set: { draft?.healthStatus = $0 }
        )
    }

    private func healthCauseBinding(for tree: Tree) -> Binding<String> {
        Binding(
            get: { isEditing ? (draft?.healthCause ?? tree.healthCause) : tree.healthCause },
            set: { draft?.healthCause = $0 }
        )
    }

    private func lastRepottedDateBinding(for tree: Tree) -> Binding<Date?> {
        Binding(
            get: { isEditing ? (draft?.lastRepottedDate ?? tree.lastRepottedDate) : tree.lastRepottedDate },
            set: { draft?.lastRepottedDate = $0 }
        )
    }

    private func repottingIntervalYearsBinding(for tree: Tree) -> Binding<Int?> {
        Binding(
            get: {
                isEditing
                    ? (draft?.repottingIntervalYears ?? tree.repottingIntervalYears)
                    : tree.repottingIntervalYears
            },
            set: { draft?.repottingIntervalYears = $0 }
        )
    }

    private func placementStrategyBinding(for tree: Tree) -> Binding<TreePlacementStrategy> {
        Binding(
            get: { isEditing ? (draft?.placementStrategy ?? tree.placementStrategy) : tree.placementStrategy },
            set: { newValue in
                draft?.placementStrategy = newValue
                if newValue == .alwaysOutdoors {
                    draft?.winterCareCompletedSteps = WinterCareStep.allCases
                    draft?.springCareCompletedSteps = SpringCareStep.allCases
                }
                syncDraftStandingLocation()
            }
        )
    }

    private func seasonPlacementBinding(for tree: Tree) -> Binding<TreeSeasonPlacement> {
        Binding(
            get: { isEditing ? (draft?.seasonPlacement ?? tree.seasonPlacement) : tree.seasonPlacement },
            set: { newValue in
                draft?.seasonPlacement = newValue
                if newValue == .summer {
                    draft?.winterCareCompletedSteps = []
                } else {
                    draft?.winterCareCompletedSteps = WinterCareStep.allCases
                    draft?.springCareCompletedSteps = []
                }
                syncDraftStandingLocation()
            }
        )
    }

    private func setPlacementStrategy(_ strategy: TreePlacementStrategy, for treeID: UUID) {
        do {
            try winterCareService.setPlacementStrategy(
                strategy,
                for: treeID,
                snapshot: weatherService.snapshot
            )
        } catch {}
    }

    private func setSeasonPlacement(_ season: TreeSeasonPlacement, for treeID: UUID) {
        do {
            try winterCareService.setSeasonPlacement(
                season,
                for: treeID,
                snapshot: weatherService.snapshot
            )
        } catch {}
    }

    private func treeStageDisplayName(for tree: Tree) -> String {
        let stageID = isEditing ? (draft?.treeStageID ?? tree.treeStageID) : tree.treeStageID
        guard let stageID, let name = referenceData.treeStage(id: stageID)?.name else {
            return ""
        }
        return name
    }

    private func fertilizationModeTitle(for tree: Tree) -> String {
        let name = treeStageDisplayName(for: tree)
        guard !name.isEmpty else { return "" }
        return TreeStageFertilizerMapping.fertilizationModeTitle(forTreeStageName: name) ?? ""
    }

    private func fertilizerHealthBinding(for tree: Tree) -> Binding<FertilizerHealth?> {
        Binding(
            get: { isEditing ? (draft?.fertilizerHealth ?? tree.fertilizerHealth) : tree.fertilizerHealth },
            set: { draft?.fertilizerHealth = $0 }
        )
    }

    private func fertilizerKindOverrideBinding(for tree: Tree) -> Binding<FertilizerKind?> {
        Binding(
            get: { isEditing ? (draft?.fertilizerKindOverride ?? tree.fertilizerKindOverride) : tree.fertilizerKindOverride },
            set: { draft?.fertilizerKindOverride = $0 }
        )
    }

    private func fertilizationPlan(for tree: Tree) -> TreeFertilizationPlan {
        growingIntelligence.fertilizationPlan(
            for: treeForFertilizationPlan(tree),
            lastFertilizedAt: lastFertilizedAt(for: tree)
        )
    }

    private func treeForFertilizationPlan(_ tree: Tree) -> Tree {
        guard isEditing, let draft else { return tree }
        var live = tree
        live.fertilizerHealth = draft.fertilizerHealth
        live.fertilizerKindOverride = draft.fertilizerKindOverride
        live.healthStatus = draft.healthStatus
        live.healthCause = draft.healthCause
        live.treeStageID = draft.treeStageID
        return live
    }

    private func lastFertilizedAt(for tree: Tree) -> Date? {
        workService.history(for: tree.id)
            .filter { workService.workType(id: $0.workTypeID)?.behaviour.requiresFertilizer == true }
            .map(\.performedAt)
            .max()
    }

    private func standingLocationIDBinding(for tree: Tree) -> Binding<UUID?> {
        Binding(
            get: {
                if isEditing {
                    return draft?.locationID ?? tree.locationID
                }
                return tree.locationID
            },
            set: { _ in
                // Standing now is derived from Home / Winter / Season.
            }
        )
    }

    private func homeLocationIDBinding(for tree: Tree) -> Binding<UUID?> {
        Binding(
            get: {
                if isEditing {
                    return draft?.homeLocationID ?? tree.homeLocationID
                }
                return tree.homeLocationID
            },
            set: { newValue in
                draft?.homeLocationID = newValue
                syncDraftStandingLocation()
            }
        )
    }

    private func winterLocationIDBinding(for tree: Tree) -> Binding<UUID?> {
        Binding(
            get: {
                if isEditing {
                    return draft?.winterLocationID ?? tree.winterLocationID
                }
                return tree.winterLocationID
            },
            set: { newValue in
                draft?.winterLocationID = newValue
                syncDraftStandingLocation()
            }
        )
    }

    /// Keeps draft ``locationID`` (standing now) aligned with Home / Winter / Season.
    private func syncDraftStandingLocation() {
        guard var draft else { return }
        let home = draft.homeLocationID ?? tree?.homeLocationID
        guard let home else { return }
        var probe = Tree(
            locationID: draft.locationID ?? home,
            homeLocationID: home,
            winterLocationID: draft.winterLocationID,
            placementStrategy: draft.placementStrategy,
            seasonPlacement: draft.seasonPlacement
        )
        probe.syncStandingLocationFromPlacement()
        draft.locationID = probe.locationID
        self.draft = draft
    }

    private var lightConditionIDBinding: Binding<UUID?> {
        Binding(
            get: { draft?.lightConditionID ?? tree?.lightConditionID },
            set: { draft?.lightConditionID = $0 }
        )
    }

    private var soilMixIDBinding: Binding<UUID?> {
        Binding(
            get: { draft?.soilMixID ?? tree?.soilMixID },
            set: { draft?.soilMixID = $0 }
        )
    }

    private var potTypeIDBinding: Binding<UUID?> {
        Binding(
            get: { draft?.potTypeID ?? tree?.potTypeID },
            set: { draft?.potTypeID = $0 }
        )
    }

    private var potColorBinding: Binding<String> {
        Binding(
            get: { draft?.potColor ?? tree?.potColor ?? "" },
            set: { draft?.potColor = $0 }
        )
    }

    /// Inventory Pot display name only (for Edit Tree inventory block).
    private func inventoryPotDisplayName(for tree: Tree) -> String {
        guard let pot = TreeCurrentPotDisplay.resolvedInventoryPot(for: tree, potService: potService) else {
            return ""
        }
        let trimmed = pot.name.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmed.isEmpty { return trimmed }
        if let potTypeID = pot.potTypeID, let type = referenceData.potType(id: potTypeID) {
            return type.name
        }
        return "Untitled Pot"
    }

    private func removeInventoryPotAssignment() {
        guard let treeID else { return }
        do {
            try potService.unassignCurrentPot(fromTreeID: treeID)
        } catch {
            potAssignmentErrorMessage = error.localizedDescription
        }
    }

    private func sourceYamadoriFind(for tree: Tree) -> YamadoriFind? {
        guard let findID = tree.sourceYamadoriID else { return nil }
        return yamadoriService.getFind(id: findID)
    }

    private func selectedSoilMix(for tree: Tree) -> SoilMix? {
        let id = isEditing ? (draft?.soilMixID ?? tree.soilMixID) : tree.soilMixID
        guard let id else { return nil }
        return referenceData.soilMix(id: id)
    }

    private func soilComponentNames(for tree: Tree) -> [UUID: String] {
        var names = Dictionary(
            uniqueKeysWithValues: referenceData.soilComponents.map { ($0.id, $0.name) }
        )
        if let mix = selectedSoilMix(for: tree) {
            for part in mix.parts where names[part.componentID] == nil {
                if let component = referenceData.soilComponent(id: part.componentID) {
                    names[component.id] = component.name
                }
            }
        }
        return names
    }

    private var potLengthMillimetresBinding: Binding<Int?> {
        Binding(
            get: { isEditing ? (draft?.potLengthMillimetres ?? tree?.potLengthMillimetres) : tree?.potLengthMillimetres },
            set: { draft?.potLengthMillimetres = $0 }
        )
    }

    private var potWidthMillimetresBinding: Binding<Int?> {
        Binding(
            get: { isEditing ? (draft?.potWidthMillimetres ?? tree?.potWidthMillimetres) : tree?.potWidthMillimetres },
            set: { draft?.potWidthMillimetres = $0 }
        )
    }

    private var potHeightMillimetresBinding: Binding<Int?> {
        Binding(
            get: { isEditing ? (draft?.potHeightMillimetres ?? tree?.potHeightMillimetres) : tree?.potHeightMillimetres },
            set: { draft?.potHeightMillimetres = $0 }
        )
    }

    private var potDiameterMillimetresBinding: Binding<Int?> {
        Binding(
            get: { isEditing ? (draft?.potDiameterMillimetres ?? tree?.potDiameterMillimetres) : tree?.potDiameterMillimetres },
            set: { draft?.potDiameterMillimetres = $0 }
        )
    }

    private func migrateMeasurementsIfNeeded(for tree: Tree) {
        measurementHistory.ensureMigrated(from: tree)
    }

    private func presentAddMeasurement() {
        guard let tree else { return }
        measurementHistory.ensureMigrated(from: tree)
        let prefill = measurementHistory.latest(for: tree.id)
            ?? TreeMeasurementRecord.fromLatestFields(on: tree)
        addMeasurementPrefill = prefill
        isAddMeasurementPresented = true
    }

    private func saveNewMeasurement(_ record: TreeMeasurementRecord) {
        measurementHistory.append(record)
        try? treeService.applyLatestMeasurement(treeID: record.treeID, from: record)
        if isEditing {
            draft?.heightMillimetres = record.heightMillimetres
            draft?.crownWidthMillimetres = record.crownWidthMillimetres
            draft?.nebariWidthMillimetres = record.nebariWidthMillimetres
            draft?.trunkDiameterMillimetres = record.trunkDiameterMillimetres
            if let draft {
                lastPersistedDraft = draft
            }
        }
        addMeasurementPrefill = nil
    }

    private var acquisitionMethodIDBinding: Binding<UUID?> {
        Binding(
            get: { draft?.acquisitionMethodID ?? tree?.acquisitionMethodID },
            set: { draft?.acquisitionMethodID = $0 }
        )
    }

    private var acquisitionDateBinding: Binding<Date?> {
        Binding(
            get: { draft?.acquisitionDate ?? tree?.acquisitionDate },
            set: { draft?.acquisitionDate = $0 }
        )
    }

    private var acquisitionSourceNameBinding: Binding<String> {
        Binding(
            get: { draft?.acquisitionSourceName ?? tree?.acquisitionSourceName ?? "" },
            set: { draft?.acquisitionSourceName = $0 }
        )
    }

    private var purchasePriceBinding: Binding<Decimal?> {
        Binding(
            get: { draft?.purchasePrice ?? tree?.purchasePrice },
            set: { draft?.purchasePrice = $0 }
        )
    }

    private var acquisitionNotesBinding: Binding<String> {
        Binding(
            get: { draft?.acquisitionNotes ?? tree?.acquisitionNotes ?? "" },
            set: { draft?.acquisitionNotes = $0 }
        )
    }

    private var disposalMethodIDBinding: Binding<UUID?> {
        Binding(
            get: { draft?.disposalMethodID ?? tree?.disposalMethodID },
            set: { draft?.disposalMethodID = $0 }
        )
    }

    private var disposalDateBinding: Binding<Date?> {
        Binding(
            get: { draft?.disposalDate ?? tree?.disposalDate },
            set: { draft?.disposalDate = $0 }
        )
    }

    private var disposalPartyNameBinding: Binding<String> {
        Binding(
            get: { draft?.disposalPartyName ?? tree?.disposalPartyName ?? "" },
            set: { draft?.disposalPartyName = $0 }
        )
    }

    private var disposalPriceBinding: Binding<Decimal?> {
        Binding(
            get: { draft?.disposalPrice ?? tree?.disposalPrice },
            set: { draft?.disposalPrice = $0 }
        )
    }

    private var disposalNotesBinding: Binding<String> {
        Binding(
            get: { draft?.disposalNotes ?? tree?.disposalNotes ?? "" },
            set: { draft?.disposalNotes = $0 }
        )
    }

    /// Gallery IDs for the photo manager (draft while editing), oldest Capture Date first.
    private func displayedImageIDs(for tree: Tree) -> [UUID] {
        let ids: [UUID]
        if isEditing, let draft {
            ids = draft.imageIDs
        } else {
            ids = tree.imageIDs
        }
        let referenceIDs = treeService.referenceImageIDs(for: tree)
        return sortedImageIDs(ids.filter { !referenceIDs.contains($0) })
    }

    private func displayedPrimaryImageID(for tree: Tree) -> UUID? {
        let referenceIDs = treeService.referenceImageIDs(for: tree)
        let primary: UUID?
        if isEditing, let draft {
            primary = draft.primaryImageID
        } else {
            primary = tree.primaryImageID
        }
        if let primary, referenceIDs.contains(primary) { return nil }
        return primary
    }

    private func displayedPhotoNames(for tree: Tree) -> [UUID: String] {
        var names: [UUID: String] = [:]
        for id in displayedImageIDs(for: tree) {
            if isEditing, let override = draft?.photoNames[id] {
                let trimmed = override.trimmingCharacters(in: .whitespacesAndNewlines)
                let capture = displayedCaptureDate(for: id)
                names[id] = trimmed.isEmpty ? ImageAsset.defaultPhotoName(for: capture) : trimmed
            } else {
                names[id] = imageService.photoName(for: id)
            }
        }
        return names
    }

    private func displayedCaptureDates(for tree: Tree) -> [UUID: Date] {
        var dates: [UUID: Date] = [:]
        for id in displayedImageIDs(for: tree) {
            dates[id] = displayedCaptureDate(for: id)
        }
        return dates
    }

    private func displayedCaptureDate(for id: UUID) -> Date {
        if isEditing, let override = draft?.photoCaptureDates[id] {
            return override
        }
        return imageService.captureDate(for: id)
    }

    /// Chronological Timeline from Work, Measurement, and Photo registrations.
    private func timelineEvents(for tree: Tree) -> [TreeTimelineEvent] {
        let system = appSettings.measurementSystem
        let photoNames = displayedPhotoNames(for: tree)
        let photoEvents: [(id: UUID, date: Date, name: String)] = displayedImageIDs(for: tree).map { id in
            (id, displayedCaptureDate(for: id), photoNames[id] ?? imageService.photoName(for: id))
        }
        return TreeTimelineAssembler.events(
            workRecords: workService.history(for: tree.id),
            workTypeName: { workService.workType(id: $0)?.name },
            measurements: measurementHistory.timeline(for: tree.id),
            measurementDetail: { record in
                timelineMeasurementDetail(record, system: system)
            },
            photoEvents: photoEvents,
            journalEntries: journalService.history(for: tree.id)
        )
    }

    private func treeHistoryDocument(for tree: Tree) -> TreeHistoryDocument {
        let events = timelineEvents(for: tree)
        let journals = journalService.history(for: tree.id)
        var identity: [String] = [
            "Name: \(TreePresentation.title(for: tree))"
        ]
        if !tree.botanicalName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            identity.append("Botanical: \(tree.botanicalName)")
        }
        let stage = treeStageDisplayName(for: tree).trimmingCharacters(in: .whitespacesAndNewlines)
        if !stage.isEmpty, stage != FaloDisplayValue.empty {
            identity.append("Stage: \(stage)")
        }
        if let location = locationDisplayName(for: tree), !location.isEmpty {
            identity.append("Location: \(location)")
        }

        var acquisition: [String] = []
        if let date = tree.acquisitionDate {
            acquisition.append("Date: \(date.formatted(date: .abbreviated, time: .omitted))")
        }
        if let methodID = tree.acquisitionMethodID,
           let method = referenceData.acquisitionMethod(id: methodID)?.name {
            acquisition.append("Method: \(method)")
        }
        let source = tree.acquisitionSourceName.trimmingCharacters(in: .whitespacesAndNewlines)
        if !source.isEmpty {
            acquisition.append("Source: \(source)")
        }
        let acqNotes = tree.acquisitionNotes.trimmingCharacters(in: .whitespacesAndNewlines)
        if !acqNotes.isEmpty {
            acquisition.append(acqNotes)
        }

        var yamadori: [String] = []
        if let find = sourceYamadoriFind(for: tree) {
            let name = find.displayName.isEmpty ? find.yamadoriCode : find.displayName
            yamadori.append("Find: \(name)")
            if !find.yamadoriCode.isEmpty, find.displayName.isEmpty == false {
                yamadori.append("Code: \(find.yamadoriCode)")
            }
        }

        let workHistory = workService.history(for: tree.id)

        let wateringLines = careWorkLines(
            from: workHistory,
            matching: workService.isWatering(workTypeID:),
            fallbackTypeName: "Watering"
        )
        let wateringSummaryLine: String? = workService.lastCompletedWateringDate(for: tree.id).map {
            "Last watered: \($0.formatted(date: .abbreviated, time: .omitted))"
        }

        let fertilizingLines = careWorkLines(
            from: workHistory,
            matching: workService.isFertilizing(workTypeID:),
            fallbackTypeName: "Fertilizing"
        )
        let fertilizingSummaryLine: String? = workService.lastCompletedFertilizingDate(for: tree.id).map {
            "Last fertilized: \($0.formatted(date: .abbreviated, time: .omitted))"
        }

        let potDisplay = TreeCurrentPotDisplay.resolve(
            tree: tree,
            potService: potService,
            referenceData: referenceData
        )
        let currentPotLine: String? = {
            guard let title = potDisplay.title, !title.isEmpty else { return nil }
            switch potDisplay.source {
            case .inventoryPot: return "Current pot: \(title) (inventory)"
            case .treeDescription: return "Current pot: \(title)"
            case .none: return nil
            }
        }()

        let repottingLines = careWorkLines(
            from: workHistory,
            matching: workService.isRepotting(workTypeID:),
            fallbackTypeName: "Repotting"
        )

        let careWorkIDs = Set(
            workHistory
                .filter {
                    workService.isWatering(workTypeID: $0.workTypeID)
                        || workService.isFertilizing(workTypeID: $0.workTypeID)
                        || workService.isRepotting(workTypeID: $0.workTypeID)
                }
                .map(\.id)
        )
        let historyTimeline = events.filter { !careWorkIDs.contains($0.id) }

        let photoNames = displayedPhotoNames(for: tree)
        let developmentPhotos: [TreeHistoryPhoto] = displayedImageIDs(for: tree)
            .map { id in
                TreeHistoryPhoto(
                    id: id,
                    date: displayedCaptureDate(for: id),
                    name: photoNames[id] ?? imageService.photoName(for: id)
                )
            }
            .sorted { lhs, rhs in
                if lhs.date != rhs.date { return lhs.date < rhs.date }
                return lhs.id.uuidString < rhs.id.uuidString
            }

        return TreeHistoryDocument.assemble(
            tree: tree,
            identityLines: identity,
            acquisitionLines: acquisition,
            yamadoriLines: yamadori,
            journalEntries: journals,
            wateringSummaryLine: wateringSummaryLine,
            wateringLines: wateringLines,
            fertilizingSummaryLine: fertilizingSummaryLine,
            fertilizingLines: fertilizingLines,
            currentPotLine: currentPotLine,
            repottingLines: repottingLines,
            developmentPhotos: developmentPhotos,
            timelineEvents: historyTimeline,
            notes: tree.notes
        )
    }

    private func careWorkLines(
        from records: [WorkRecord],
        matching: (UUID) -> Bool,
        fallbackTypeName: String
    ) -> [String] {
        records
            .filter { matching($0.workTypeID) }
            .sorted { $0.performedAt > $1.performedAt }
            .map { record in
                let date = record.performedAt.formatted(date: .abbreviated, time: .omitted)
                let typeName = workService.workType(id: record.workTypeID)?.name ?? fallbackTypeName
                let notes = record.notes.trimmingCharacters(in: .whitespacesAndNewlines)
                return notes.isEmpty ? "\(date) — \(typeName)" : "\(date) — \(typeName): \(notes)"
            }
    }

    private func timelineMeasurementDetail(
        _ record: TreeMeasurementRecord,
        system: MeasurementSystem
    ) -> String? {
        let parts: [(String, Int?, MeasurementDimension)] = [
            ("H", record.heightMillimetres, .height),
            ("C", record.crownWidthMillimetres, .crownWidth),
            ("N", record.nebariWidthMillimetres, .nebariWidth),
            ("T", record.trunkDiameterMillimetres, .trunkDiameter)
        ]
        let formatted = parts.compactMap { label, millimetres, dimension -> String? in
            guard millimetres != nil else { return nil }
            let value = MeasurementService.string(
                millimetres: millimetres,
                dimension: dimension,
                system: system,
                empty: ""
            )
            guard !value.isEmpty else { return nil }
            return "\(label) \(value)"
        }
        return formatted.isEmpty ? nil : formatted.joined(separator: " · ")
    }

    /// Oldest Capture Date first; stable tie-break on id.
    private func sortedImageIDs(_ ids: [UUID]) -> [UUID] {
        ids.sorted { a, b in
            let dateA = displayedCaptureDate(for: a)
            let dateB = displayedCaptureDate(for: b)
            if dateA != dateB {
                return dateA < dateB
            }
            return a.uuidString < b.uuidString
        }
    }

    private enum ImageSelectionSyncReason {
        case treeOpened
        case editingBegan
        case editingEnded
        case galleryChanged
        case primaryChangedExternally
    }

    private func syncSelectedImage(for tree: Tree, reason: ImageSelectionSyncReason) {
        let ids = displayedImageIDs(for: tree)
        guard !ids.isEmpty else {
            selectedImageID = nil
            return
        }

        let primary = displayedPrimaryImageID(for: tree)

        switch reason {
        case .treeOpened, .editingEnded:
            if let primary, ids.contains(primary) {
                selectedImageID = primary
            } else {
                selectedImageID = ids.first
            }

        case .editingBegan, .galleryChanged, .primaryChangedExternally:
            if let selectedImageID, ids.contains(selectedImageID) {
                return
            }
            if let primary, ids.contains(primary) {
                selectedImageID = primary
            } else {
                selectedImageID = ids.first
            }
        }
    }

    private func setSocialShareLevel(_ level: SocialShareLevel, for tree: Tree) {
        var updated = tree
        updated.socialShareLevel = level
        do {
            _ = try treeService.updateTree(updated)
        } catch {
            // Keep UI quiet — share level is non-critical; reload keeps the prior value.
        }
    }

    private func setPrimaryPhoto(_ imageID: UUID) {
        guard !treeService.isReferenceImage(imageID) else { return }
        selectedImageID = imageID
        if isEditing {
            draft?.primaryImageID = imageID
            if draft?.imageIDs.contains(imageID) != true {
                draft?.imageIDs.append(imageID)
                draft?.imageIDs = sortedImageIDs(draft?.imageIDs ?? [imageID])
            }
        } else if let tree {
            try? treeService.setPrimaryImage(treeID: tree.id, imageID: imageID)
            imageService.setPrimaryFlag(id: imageID)
        }
    }

    private func updatePhotoMetadata(id: UUID, name: String, captureDate: Date) {
        if isEditing {
            draft?.photoNames[id] = name
            draft?.photoCaptureDates[id] = captureDate
            if let ids = draft?.imageIDs {
                draft?.imageIDs = sortedImageIDs(ids)
            }
        } else if let tree {
            imageService.updatePhotoMetadata(id: id, photoName: name, captureDate: captureDate)
            let sorted = sortedImageIDs(tree.imageIDs)
            if sorted != tree.imageIDs {
                try? treeService.setImageIDs(treeID: tree.id, imageIDs: sorted)
            }
        }
    }

    private func deletePhoto(id: UUID) {
        if isEditing {
            draft?.imageIDs.removeAll { $0 == id }
            draft?.photoNames.removeValue(forKey: id)
            draft?.photoCaptureDates.removeValue(forKey: id)
            if draft?.pendingAddedImageIDs.contains(id) == true {
                draft?.pendingAddedImageIDs.removeAll { $0 == id }
                Task { try? await imageService.deletePhoto(id: id) }
            } else if draft?.pendingDeletedImageIDs.contains(id) != true {
                draft?.pendingDeletedImageIDs.append(id)
            }
            if draft?.primaryImageID == id {
                draft?.primaryImageID = draft?.imageIDs.first
            }
            if selectedImageID == id {
                selectedImageID = draft?.primaryImageID ?? draft?.imageIDs.first
            }
            return
        }

        guard let tree else { return }
        Task {
            try? treeService.removeImage(treeID: tree.id, imageID: id)
            try? await imageService.deletePhoto(id: id)
            if selectedImageID == id, let updated = treeService.getTree(id: tree.id) {
                syncSelectedImage(for: updated, reason: .galleryChanged)
            }
        }
    }

    // MARK: - Botanical display (always locked)

    private func genusDisplayName(for tree: Tree) -> String {
        tree.genusID.flatMap { referenceData.genus(id: $0)?.name } ?? ""
    }

    private func speciesDisplayName(for tree: Tree) -> String {
        guard let speciesID = tree.speciesID,
              let species = referenceData.species(id: speciesID) else {
            return ""
        }
        let epithet = species.epithet
        return epithet.isEmpty ? species.name : epithet
    }

    private func cultivarDisplayName(for tree: Tree) -> String {
        tree.cultivarID.flatMap { referenceData.cultivar(id: $0)?.name } ?? ""
    }

    /// Origin glance for Identity — acquisition method, else source name (Ownership keeps full detail).
    private func originDisplayName(for tree: Tree) -> String {
        let methodID = isEditing ? (draft?.acquisitionMethodID ?? tree.acquisitionMethodID) : tree.acquisitionMethodID
        if let methodID,
           let name = referenceData.acquisitionMethod(id: methodID)?.name,
           !name.isEmpty {
            return name
        }
        let source = isEditing
            ? (draft?.acquisitionSourceName ?? tree.acquisitionSourceName)
            : tree.acquisitionSourceName
        return source.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    // MARK: - Gallery import

    private func importGalleryImage() async {
        guard isEditing, draft != nil else { return }
        guard !isImportingPrimaryImage else { return }
        isImportingPrimaryImage = true
        defer { isImportingPrimaryImage = false }

        do {
            let assets = try await imageImportService.importGalleryImagesFromFinder()
            attachImportedGalleryAssets(assets)
        } catch is CancellationError {
            return
        } catch ImageImportError.cancelled {
            return
        } catch {
            return
        }
    }

    private func importDroppedGalleryImages(_ sources: [ImageDropSource]) async {
        guard allowsEditing else { return }
        guard !sources.isEmpty else { return }
        // Overview drop can happen before Edit — same path as Add photo quick action.
        if !isEditing {
            beginEditing()
        }
        guard draft != nil else { return }
        guard !isImportingPrimaryImage else { return }
        isImportingPrimaryImage = true
        defer { isImportingPrimaryImage = false }

        do {
            var assets: [ImageAsset] = []
            assets.reserveCapacity(sources.count)
            for source in sources {
                assets.append(try await imageImportService.importImage(from: source, asPrimary: false))
            }
            attachImportedGalleryAssets(assets)
        } catch {
            return
        }
    }

    private func attachImportedGalleryAssets(_ assets: [ImageAsset]) {
        guard !assets.isEmpty else { return }
        let galleryWasEmpty = draft?.primaryImageID == nil
        for asset in assets {
            if draft?.imageIDs.contains(asset.id) != true {
                draft?.imageIDs.append(asset.id)
            }
            if draft?.pendingAddedImageIDs.contains(asset.id) != true {
                draft?.pendingAddedImageIDs.append(asset.id)
            }
        }
        // Only become Primary when the gallery was empty — first of the batch.
        if galleryWasEmpty, let first = assets.first {
            draft?.primaryImageID = first.id
        }
        if let ids = draft?.imageIDs {
            draft?.imageIDs = sortedImageIDs(ids)
        }
        selectedImageID = assets.last?.id
    }
}

#Preview("View Tree") {
    let state = AppState()
    let previewData = PreviewData()
    let referencePreview = ReferencePreviewData()
    let reference = ReferenceDataService(previewData: referencePreview)
    let storage = StorageService.shared
    let imageCatalog = ImagePreviewData()
    let measurementHistory = TreeMeasurementHistoryStore(storage: storage)
    let treeService = TreeService.preview(previewData: previewData)
    let workService = WorkService(referenceData: reference)
    let botanical = BotanicalService(store: referencePreview)
    let taskService = TaskService(
        referenceData: reference,
        workService: workService,
        treeService: treeService,
        botanicalService: botanical
    )
    let treeID = treeService.trees.first!.id
    state.selectedTreeID = treeID
    return TreeDetailView(mode: .edit(treeID))
        .environment(state)
        .environment(AppSettings())
        .environment(treeService)
        .environment(reference)
        .environment(measurementHistory)
        .environment(ImageService(storage: storage, previewData: imageCatalog))
        .environment(ImageImportService(storage: storage, imageCatalog: imageCatalog))
        .environment(workService)
        .environment(JournalService())
        .environment(taskService)
        .environment(PotService.preview(treeService: treeService))
        .environment(YamadoriService.preview(treeService: treeService))
        .environment(
            GrowingIntelligenceService(
                treeService: treeService,
                referenceData: reference,
                profile: UserProfileStore()
            )
        )
}

// MARK: - Navigation title

private struct TreeDetailNavigationTitleModifier: ViewModifier {
    var showsNavigationTitle: Bool
    var title: String
    var onBack: (() -> Void)? = nil

    func body(content: Content) -> some View {
        if showsNavigationTitle {
            content.bonsaiWorkspaceNavigationTitle(title, onBack: onBack)
        } else {
            // Embedded under library chrome — no system/navigation title (avoids toolbar rule).
            content
        }
    }
}
