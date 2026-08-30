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
    @Environment(\.scenePhase) private var scenePhase

    var mode: EditorMode
    var showsCollectionBackButton: Bool = false
    /// When false (Tree Workspace window), do not drive main-window Quick Actions.
    var publishesInteractionModeToAppState: Bool = true

    @State private var interactionMode: TreeDetailInteractionMode = .viewing
    @State private var draft: TreeDetailDraft?
    @State private var lastPersistedDraft: TreeDetailDraft?
    @State private var isMembershipSheetPresented = false
    @State private var selectedImageID: UUID?
    @State private var isImportingPrimaryImage = false
    @State private var autoSaveStatus: TreeAutoSaveStatus = .idle
    @State private var autoSaveTask: Task<Void, Never>?
    @State private var savedIndicatorTask: Task<Void, Never>?
    @State private var isAddMeasurementPresented = false
    @State private var addMeasurementPrefill: TreeMeasurementRecord?
    @State private var isAddWorkPresented = false
    @State private var showDeleteTreeConfirmation = false
    @State private var deleteFailed = false
    @State private var deleteErrorMessage = "The tree could not be deleted. Try again."
    @State private var showReturnToCareConfirmation = false
    @State private var returnToCareFailed = false
    @State private var returnToCareErrorMessage = "The tree could not be returned to My Trees. Try again."
    @State private var showDuplicateTreeConfirmation = false
    @State private var duplicateFailed = false
    @State private var duplicateErrorMessage = "Tree info could not be duplicated. Try again."

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

    /// Former Trees are history — no Edit, Add Activity, or Tasks.
    private var allowsEditing: Bool {
        tree?.isInCare == true
    }

    private var navigationTitleText: String {
        mode.treeEditorTitle(botanicalName: tree?.botanicalName ?? "")
    }

    var body: some View {
        Group {
            if let tree {
                treeDetail(tree)
                    .onAppear {
                        if tree.isInCare {
                            publishInteractionMode()
                        } else {
                            discardDraftAndReturnToViewing()
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
                        if !inCare {
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
        .background(.windowBackground)
        .navigationTitle(navigationTitleText)
        .sheet(isPresented: $isMembershipSheetPresented) {
            if let draftBinding = draftCollectionBinding {
                CollectionMembershipSheet(memberIDs: draftBinding)
            }
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
        case .viewImages:
            appState.selectSection(.mediaImages)
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
    private func treeDetail(_ tree: Tree) -> some View {
        let memberships = displayedMemberships(for: tree)

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

            if isEditing {
                TreeAutoSaveBanner(status: autoSaveStatus)
            }

            // One continuous scroll surface: image + cards move together (not sticky).
            FaloAdaptiveDesktopWorkspace(profile: .treeDetail) {
                VStack(alignment: .leading, spacing: TreeDetailSpacing.cardGap) {
                    TreeDetailActivityHeader(
                        tree: tree,
                        showsAddActivity: allowsEditing,
                        onSelectWork: { isAddWorkPresented = true }
                    )

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
                            isEditing: isEditing
                        )
                        GrowingSection(
                            styleID: styleIDBinding,
                            locationID: locationIDBinding(for: tree),
                            healthStatus: healthStatusBinding(for: tree),
                            treeStatusID: treeStatusIDBinding,
                            sizeClassID: sizeClassIDBinding,
                            lightConditionID: lightConditionIDBinding,
                            soilMixID: soilMixIDBinding,
                            styles: DetailPickerOption.map(referenceData.styles),
                            locations: DetailPickerOption.map(referenceData.locations),
                            treeStatuses: DetailPickerOption.map(referenceData.treeStatuses),
                            sizeClasses: DetailPickerOption.map(referenceData.sizeClasses),
                            lightConditions: DetailPickerOption.map(referenceData.lightConditions),
                            soilMixes: DetailPickerOption.map(referenceData.soilMixes),
                            selectedSoilMix: selectedSoilMix(for: tree),
                            soilComponentNames: soilComponentNames(for: tree),
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
                        collectionsBlock(memberships: memberships)
                        PotSection(
                            potTypeID: potTypeIDBinding,
                            potLengthMillimetres: potLengthMillimetresBinding,
                            potWidthMillimetres: potWidthMillimetresBinding,
                            potHeightMillimetres: potHeightMillimetresBinding,
                            potDiameterMillimetres: potDiameterMillimetresBinding,
                            potTypes: DetailPickerOption.map(referenceData.potTypes),
                            isEditing: isEditing
                        )
                    } column2: {
                        TreeUpcomingTasksSection(treeID: tree.id)
                        TreeNotesSection(
                            text: notesBinding(for: tree),
                            isEditing: isEditing,
                            layout: .journalColumn
                        )
                    }

                    TreeTimelineSection(records: workService.history(for: tree.id)) { workTypeID in
                        workService.workType(id: workTypeID)?.name
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
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

    private func notesBinding(for tree: Tree) -> Binding<String> {
        Binding(
            get: { isEditing ? (draft?.notes ?? tree.notes) : tree.notes },
            set: { draft?.notes = $0 }
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

    private var treeStatusIDBinding: Binding<UUID?> {
        Binding(
            get: { draft?.treeStatusID ?? tree?.treeStatusID },
            set: { draft?.treeStatusID = $0 }
        )
    }

    private func healthStatusBinding(for tree: Tree) -> Binding<TreeHealthStatus> {
        Binding(
            get: { isEditing ? (draft?.healthStatus ?? tree.healthStatus) : tree.healthStatus },
            set: { draft?.healthStatus = $0 }
        )
    }

    private func locationIDBinding(for tree: Tree) -> Binding<UUID?> {
        Binding(
            get: {
                if isEditing {
                    return draft?.locationID ?? tree.locationID
                }
                return tree.locationID
            },
            set: { draft?.locationID = $0 }
        )
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
        return sortedImageIDs(ids)
    }

    private func displayedPrimaryImageID(for tree: Tree) -> UUID? {
        if isEditing, let draft {
            return draft.primaryImageID
        }
        return tree.primaryImageID
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

    private func setPrimaryPhoto(_ imageID: UUID) {
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
            let asset = try await imageImportService.importGalleryImageFromFinder()
            if draft?.imageIDs.contains(asset.id) != true {
                draft?.imageIDs.append(asset.id)
            }
            if draft?.pendingAddedImageIDs.contains(asset.id) != true {
                draft?.pendingAddedImageIDs.append(asset.id)
            }
            // Only become Primary when the gallery was empty.
            if draft?.primaryImageID == nil {
                draft?.primaryImageID = asset.id
            }
            if let ids = draft?.imageIDs {
                draft?.imageIDs = sortedImageIDs(ids)
            }
            selectedImageID = asset.id
        } catch is CancellationError {
            return
        } catch ImageImportError.cancelled {
            return
        } catch {
            return
        }
    }
}

#Preview("View Tree") {
    let state = AppState()
    let previewData = PreviewData()
    let reference = ReferenceDataService(previewData: ReferencePreviewData())
    let storage = StorageService.shared
    let imageCatalog = ImagePreviewData()
    let measurementHistory = TreeMeasurementHistoryStore(storage: storage)
    let treeService = TreeService.preview(previewData: previewData)
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
        .environment(WorkService(referenceData: reference))
}
