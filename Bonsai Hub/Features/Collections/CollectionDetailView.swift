//
//  CollectionDetailView.swift
//  Bonsai World
//
//  Collections module Detail — View Mode by default; Edit Mode for metadata (Auto Save).
//  Membership is managed here in both modes; Smart Collection rules are not edited yet.
//

import SwiftUI

struct CollectionDetailView: View {
    private static let autoSaveDebounceMilliseconds: UInt64 = 600
    private static let savedIndicatorMilliseconds: UInt64 = 1200

    @Environment(AppState.self) private var appState
    @Environment(ReferenceDataService.self) private var referenceData
    @Environment(TreeService.self) private var treeService
    @Environment(TaskService.self) private var taskService
    @Environment(\.scenePhase) private var scenePhase

    @State private var interactionMode: TreeDetailInteractionMode = .viewing
    @State private var draft: CollectionDetailDraft?
    @State private var lastPersistedDraft: CollectionDetailDraft?
    @State private var autoSaveStatus: TreeAutoSaveStatus = .idle
    @State private var autoSaveTask: Task<Void, Never>?
    @State private var savedIndicatorTask: Task<Void, Never>?
    @State private var confirmDelete = false

    private var collection: Collection? {
        guard let id = appState.selectedCollectionID else { return nil }
        return treeService.collection(id: id)
    }

    private var isEditing: Bool {
        interactionMode.isEditing
    }

    private var headerTitle: String {
        if isEditing, let draft {
            let trimmed = draft.name.trimmingCharacters(in: .whitespacesAndNewlines)
            return trimmed.isEmpty ? "Collection" : trimmed
        }
        return collection?.name ?? "Collection"
    }

    private var headerSubtitle: String? {
        if isEditing { return nil }
        let description = collection?.description ?? ""
        return description.isEmpty ? nil : description
    }

    var body: some View {
        @Bindable var appState = appState

        Group {
            if let collection {
                collectionDetail(collection)
                    .onAppear {
                        publishInteractionMode()
                    }
                    .onChange(of: collection.id) { _, _ in
                        discardDraftAndReturnToViewing()
                    }
                    .onChange(of: appState.pendingCollectionQuickAction) { _, request in
                        guard let request else { return }
                        Task { @MainActor in
                            handleQuickAction(request.command)
                            appState.clearPendingCollectionQuickAction()
                        }
                    }
                    .confirmationDialog(
                        "Delete this collection?",
                        isPresented: $confirmDelete,
                        titleVisibility: .visible
                    ) {
                        Button("Delete", role: .destructive) {
                            deleteSelectedCollection()
                        }
                        Button("Cancel", role: .cancel) {}
                    } message: {
                        Text("Trees stay in the library. Only this collection grouping is removed.")
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
                FeaturedEmptyState(
                    title: "Select a Collection",
                    systemImage: "square.stack.3d.up",
                    description: "Choose a collection from the list, or create one with Context Tools → New Collection."
                )
                .onAppear {
                    publishInteractionMode(.viewing)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .faloWorkspaceCanvas()
        .navigationTitle(headerTitle)
        .sheet(isPresented: $appState.isCollectionAddTreePresented) {
            if let collectionID = appState.selectedCollectionID {
                CollectionAddTreeSheet(collectionID: collectionID)
            }
        }
    }

    @ViewBuilder
    private func collectionDetail(_ collection: Collection) -> some View {
        let members = treeService.trees(
            inCollection: collection.id,
            disposalMethods: referenceData.disposalMethods,
            liveMembers: taskService.liveSmartCollectionMembers()
        )

        ScrollView {
            VStack(alignment: .leading, spacing: FaloSpacing.xxLarge) {
                DetailHeader(
                    title: headerTitle,
                    subtitle: headerSubtitle
                )

                if isEditing {
                    editingStatusRow
                    metadataEditorCard
                    if collection.isManual {
                        CollectionCareWateringSection(
                            isCarePolicyCollection: carePolicyBinding,
                            wateringMode: wateringModeBinding,
                            autoTimesPerDay: autoTimesBinding,
                            heatWatchEnabled: heatWatchBinding,
                            isEditing: true
                        )
                    }
                } else {
                    // Icon / color show in the list — Details card only while editing.
                    // BR1: Watering card only when this Collection is a care-policy group.
                    if collection.isManual, collection.isCarePolicyCollection {
                        CollectionCareWateringSection(
                            isCarePolicyCollection: .constant(true),
                            wateringMode: .constant(collection.wateringMode),
                            autoTimesPerDay: .constant(collection.autoTimesPerDay),
                            heatWatchEnabled: .constant(collection.heatWatchEnabled),
                            isEditing: false
                        )
                    }
                }

                DetailCard(title: membersHeading(for: members.count)) {
                    if members.isEmpty {
                        FeaturedEmptyState(
                            title: collection.isSmart ? "Smart Collection" : "Ready for members",
                            systemImage: collection.isSmart ? "sparkles" : "leaf",
                            description: smartEmptyDescription(for: collection)
                        )
                        .frame(minHeight: 180)
                    } else {
                        RelatedTreesSection(
                            title: membersHeading(for: members.count),
                            showsHeader: false,
                            items: memberTreeItems(members),
                            onSelect: { item in
                                appState.selectedTreeID = item.id
                            },
                            onRemove: collection.isManual
                                ? { item in
                                    removeMember(treeID: item.id, from: collection.id)
                                }
                                : nil
                        )
                    }
                }
            }
            .padding(FaloSpacing.xLarge)
            .frame(maxWidth: 720, alignment: .leading)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .faloScrollSurface()
    }

    private var editingStatusRow: some View {
        HStack(spacing: FaloSpacing.small) {
            Text("Editing")
                .font(FaloTypography.caption)
                .foregroundStyle(.secondary)
            Spacer()
            switch autoSaveStatus {
            case .idle:
                EmptyView()
            case .saving:
                Text("Saving…")
                    .font(FaloTypography.caption)
                    .foregroundStyle(.secondary)
            case .saved:
                Text("Saved")
                    .font(FaloTypography.caption)
                    .foregroundStyle(.secondary)
            case .failed:
                Text("Couldn’t save")
                    .font(FaloTypography.caption)
                    .foregroundStyle(BonsaiWorldColors.statusCritical)
            }
        }
    }

    private var metadataEditorCard: some View {
        DetailCard(title: "Details") {
            VStack(alignment: .leading, spacing: FaloSpacing.medium) {
                DetailEditableTextRow(
                    label: "Name",
                    text: nameBinding
                )

                VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
                    Text("Description")
                        .font(FaloCardTypography.fieldLabel)
                        .foregroundStyle(.secondary)
                    TextField("Description", text: descriptionBinding, axis: .vertical)
                        .font(FaloCardTypography.fieldValue)
                        .textFieldStyle(.roundedBorder)
                        .lineLimit(3...6)
                }
                .padding(.vertical, FaloSpacing.xSmall)

                VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
                    Text("Icon")
                        .font(FaloCardTypography.fieldLabel)
                        .foregroundStyle(.secondary)
                    Picker("Icon", selection: iconBinding) {
                        Text(FaloDisplayValue.empty).tag(String?.none)
                        ForEach(CollectionAppearanceChoices.icons, id: \.self) { symbol in
                            Label(symbol, systemImage: symbol)
                                .tag(Optional(symbol))
                        }
                    }
                    .pickerStyle(.menu)
                    .labelsHidden()

                    if let icon = draft?.icon {
                        Label("Preview", systemImage: icon)
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(.vertical, FaloSpacing.xSmall)

                VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
                    Text("Color")
                        .font(FaloCardTypography.fieldLabel)
                        .foregroundStyle(.secondary)
                    Picker("Color", selection: colorBinding) {
                        Text(FaloDisplayValue.empty).tag(String?.none)
                        ForEach(CollectionAppearanceChoices.colors, id: \.hex) { choice in
                            Text(choice.label).tag(Optional(choice.hex))
                        }
                    }
                    .pickerStyle(.menu)
                    .labelsHidden()

                    if let hex = draft?.color, let color = Color(collectionHex: hex) {
                        HStack {
                            Text("Preview")
                                .foregroundStyle(.secondary)
                            Spacer()
                            Circle()
                                .fill(color)
                                .frame(width: 18, height: 18)
                        }
                    }
                }
                .padding(.vertical, FaloSpacing.xSmall)
            }
        }
    }

    private var nameBinding: Binding<String> {
        Binding(
            get: { draft?.name ?? "" },
            set: { draft?.name = $0 }
        )
    }

    private var descriptionBinding: Binding<String> {
        Binding(
            get: { draft?.description ?? "" },
            set: { draft?.description = $0 }
        )
    }

    private var iconBinding: Binding<String?> {
        Binding(
            get: { draft?.icon },
            set: { draft?.icon = $0 }
        )
    }

    private var colorBinding: Binding<String?> {
        Binding(
            get: { draft?.color },
            set: { draft?.color = $0 }
        )
    }

    private var carePolicyBinding: Binding<Bool> {
        Binding(
            get: { draft?.isCarePolicyCollection ?? false },
            set: { draft?.isCarePolicyCollection = $0 }
        )
    }

    private var wateringModeBinding: Binding<WateringMode> {
        Binding(
            get: { draft?.wateringMode ?? .silent },
            set: { draft?.wateringMode = $0 }
        )
    }

    private var autoTimesBinding: Binding<Int> {
        Binding(
            get: { draft?.autoTimesPerDay ?? 1 },
            set: { draft?.autoTimesPerDay = TreeWateringPolicyResolver.clampedTimes($0) }
        )
    }

    private var heatWatchBinding: Binding<Bool> {
        Binding(
            get: { draft?.heatWatchEnabled ?? false },
            set: { draft?.heatWatchEnabled = $0 }
        )
    }

    private func membersHeading(for count: Int) -> String {
        count == 1 ? "1 Member" : "\(count) Members"
    }

    private func smartEmptyDescription(for collection: Collection) -> String {
        if let outcome = SystemSmartCollections.lifecycleOutcome(for: collection.id) {
            return "Trees with ownership \(outcome.dashboardLabel) appear here automatically."
        }
        if SystemSmartCollections.isNeedsWater(collection.id) {
            return "Trees with watering due today appear here automatically — the same trees as Tasks → Today."
        }
        if SystemSmartCollections.isTodaysWork(collection.id) {
            return "Trees with work due today appear here automatically — the same trees as Tasks → Today."
        }
        if SystemSmartCollections.isNeedsRepotting(collection.id) {
            return "Trees with Repotting due (overdue through this month) appear here automatically from Tasks."
        }
        if SystemSmartCollections.isNeedsPhotos(collection.id) {
            return "My Trees without a photo appear here automatically — the same gap as Dashboard → Library."
        }
        if SystemSmartCollections.isFavoriteTrees(collection.id) {
            return "Use Context Tools → Add to Favorite Trees on a tree."
        }
        return "Use Context Tools → Add Existing Tree to organise trees into this collection."
    }

    // MARK: - Quick Actions

    private func handleQuickAction(_ command: CollectionQuickActionCommand) {
        switch command {
        case .editCollection:
            guard collection?.isManual == true else { return }
            beginEditing()
        case .deleteCollection:
            guard collection?.isManual == true else { return }
            confirmDelete = true
        case .finish:
            finishEditing()
        }
    }

    private func deleteSelectedCollection() {
        guard let collection, collection.isManual else { return }
        let id = collection.id
        do {
            try treeService.deleteCollection(id: id)
            if appState.selectedCollectionID == id {
                appState.selectedCollectionID = nil
            }
            if appState.lastOpenedCollectionID == id {
                appState.lastOpenedCollectionID = nil
            }
            discardDraftAndReturnToViewing()
        } catch {
            // Keep selection; grower can retry.
        }
    }

    // MARK: - View / Edit

    private func beginEditing() {
        guard let collection, collection.isManual else { return }
        let captured = CollectionDetailDraft.capture(from: collection)
        draft = captured
        lastPersistedDraft = captured
        autoSaveStatus = .idle
        publishInteractionMode(.editing)
    }

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
        Task { @MainActor in
            appState.collectionDetailInteractionMode = next
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

    private func flushAutoSaveIfNeeded() {
        guard isEditing else { return }
        guard let draft, draft != lastPersistedDraft else { return }
        autoSaveTask?.cancel()
        autoSaveTask = nil
        Task { await persistDraftNow(exitEditing: false) }
    }

    @MainActor
    private func persistDraftNow(exitEditing: Bool) async {
        guard isEditing, let collection else {
            if exitEditing { discardDraftAndReturnToViewing() }
            return
        }
        guard let currentDraft = draft else {
            if exitEditing { discardDraftAndReturnToViewing() }
            return
        }

        if currentDraft == lastPersistedDraft {
            if exitEditing {
                discardDraftAndReturnToViewing()
            }
            return
        }

        autoSaveStatus = .saving
        do {
            try treeService.applyCollectionDetailDraft(id: collection.id, draft: currentDraft)
            if let updated = treeService.collection(id: collection.id) {
                let refreshed = CollectionDetailDraft.capture(from: updated)
                draft = refreshed
                lastPersistedDraft = refreshed
            } else {
                lastPersistedDraft = currentDraft
            }
            autoSaveStatus = .saved
            showSavedThenIdle()
            if exitEditing {
                discardDraftAndReturnToViewing()
            }
        } catch {
            autoSaveStatus = .failed
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

    /// Removes membership only — the Tree remains in the library.
    private func removeMember(treeID: UUID, from collectionID: UUID) {
        treeService.removeTreeFromCollection(treeID: treeID, collectionID: collectionID)
    }

    private func memberTreeItems(_ trees: [Tree]) -> [RelatedTreeItem] {
        trees.map { tree in
            RelatedTreeItem(
                id: tree.id,
                name: TreePresentation.title(for: tree),
                species: tree.botanicalName,
                collectionName: FaloDisplayValue.text(
                    referenceData.location(id: tree.locationID)?.name
                ),
                imageID: tree.listImageID
            )
        }
    }
}

#Preview {
    let state = AppState()
    let previewData = PreviewData()
    let store = ReferencePreviewData()
    let treeService = TreeService.preview(previewData: previewData)
    let referenceData = ReferenceDataService(previewData: store)
    let workService = WorkService(referenceData: referenceData)
    let taskService = TaskService(
        referenceData: referenceData,
        workService: workService,
        treeService: treeService,
        botanicalService: BotanicalService(store: store)
    )
    state.selectedSection = .gardenCollections
    state.selectedCollectionID = previewData.collections.first?.id
    return CollectionDetailView()
        .environment(state)
        .environment(treeService)
        .environment(referenceData)
        .environment(taskService)
        .environment(ImageService(storage: .shared, previewData: ImagePreviewData()))
}
