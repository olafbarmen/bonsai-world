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
    @Environment(\.scenePhase) private var scenePhase

    @State private var interactionMode: TreeDetailInteractionMode = .viewing
    @State private var draft: CollectionDetailDraft?
    @State private var lastPersistedDraft: CollectionDetailDraft?
    @State private var autoSaveStatus: TreeAutoSaveStatus = .idle
    @State private var autoSaveTask: Task<Void, Never>?
    @State private var savedIndicatorTask: Task<Void, Never>?

    private var collection: Collection? {
        guard let id = appState.selectedCollectionID else { return nil }
        return treeService.collection(id: id)
    }

    private var isEditing: Bool {
        interactionMode.isEditing
    }

    /// Detail header menu: membership only for Manual Collections.
    /// Edit Collection lives in sidebar Quick Actions.
    private var detailQuickActions: [ActionDefinition] {
        guard !isEditing, let collection, collection.isManual else { return [] }
        return ContextQuickActionsCatalog.actions(
            for: .gardenCollections,
            collectionsContext: ContextQuickActionsCatalog.CollectionsContext(
                selectedCollectionID: collection.id,
                selectedCollectionIsManual: true,
                interactionMode: .viewing
            )
        )
        .filter {
            $0.id == ContextQuickActionsCatalog.addTreeToCollectionID
        }
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
                    description: "Choose a collection from the list, or create one with Quick Actions → New Collection."
                )
                .onAppear {
                    publishInteractionMode(.viewing)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.windowBackground)
        .navigationTitle(headerTitle)
        .sheet(isPresented: $appState.isCollectionAddTreePresented) {
            if let collectionID = appState.selectedCollectionID {
                CollectionAddTreeSheet(collectionID: collectionID)
            }
        }
    }

    @ViewBuilder
    private func collectionDetail(_ collection: Collection) -> some View {
        let members = treeService.trees(inCollection: collection.id)

        ScrollView {
            VStack(alignment: .leading, spacing: FaloSpacing.xxLarge) {
                DetailHeader(
                    title: headerTitle,
                    subtitle: headerSubtitle,
                    quickActions: detailQuickActions,
                    onQuickAction: handleDetailMenuAction
                )

                if isEditing {
                    editingStatusRow
                    metadataEditorCard
                } else {
                    metadataViewCard(collection)
                }

                DetailCard(title: membersHeading(for: members.count)) {
                    if members.isEmpty {
                        FeaturedEmptyState(
                            title: collection.isSmart ? "Smart Collection" : "Ready for members",
                            systemImage: collection.isSmart ? "sparkles" : "leaf",
                            description: collection.isSmart
                                ? "Membership rules are not evaluated yet. This placeholder establishes Collections navigation."
                                : "Use Quick Actions → Add Existing Tree to organise trees into this collection."
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
                    .foregroundStyle(.red)
            }
        }
    }

    @ViewBuilder
    private func metadataViewCard(_ collection: Collection) -> some View {
        DetailCard(title: "Details") {
            VStack(alignment: .leading, spacing: FaloSpacing.small) {
                DetailLabeledRow(label: "Icon", value: collection.icon ?? "")
                DetailLabeledRow(
                    label: "Color",
                    value: CollectionAppearanceChoices.colorLabel(for: collection.color)
                )
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

    private func membersHeading(for count: Int) -> String {
        count == 1 ? "1 Member" : "\(count) Members"
    }

    // MARK: - Quick Actions

    private func handleQuickAction(_ command: CollectionQuickActionCommand) {
        switch command {
        case .editCollection:
            beginEditing()
        case .finish:
            finishEditing()
        }
    }

    private func handleDetailMenuAction(_ action: ActionDefinition) {
        switch action.id {
        case ContextQuickActionsCatalog.addTreeToCollectionID:
            appState.presentAddTreeToSelectedCollection()
        default:
            break
        }
    }

    // MARK: - View / Edit

    private func beginEditing() {
        guard let collection else { return }
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
                )
            )
        }
    }
}

#Preview {
    let state = AppState()
    let previewData = PreviewData()
    let store = ReferencePreviewData()
    let treeService = TreeService.preview(previewData: previewData)
    state.selectedSection = .gardenCollections
    state.selectedCollectionID = previewData.collections.first?.id
    return CollectionDetailView()
        .environment(state)
        .environment(treeService)
        .environment(ReferenceDataService(previewData: store))
}
