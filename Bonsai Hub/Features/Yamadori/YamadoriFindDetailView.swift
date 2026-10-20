//
//  YamadoriFindDetailView.swift
//  Bonsai World
//
//  Find detail — status, evaluation, recovery, transfer.
//

import MapKit
import SwiftUI

struct YamadoriFindDetailView: View {
    private static let autoSaveDebounceMilliseconds: UInt64 = 600
    private static let savedIndicatorMilliseconds: UInt64 = 1200

    @Environment(AppState.self) private var appState
    @Environment(YamadoriService.self) private var yamadoriService
    @Environment(ReferenceDataService.self) private var referenceData
    @Environment(TreeService.self) private var treeService
    @Environment(ImageService.self) private var imageService
    @Environment(ImageImportService.self) private var imageImportService
    @Environment(\.scenePhase) private var scenePhase

    @State private var draft: YamadoriFindDetailDraft?
    @State private var lastPersistedDraft: YamadoriFindDetailDraft?
    @State private var autoSaveStatus: TreeAutoSaveStatus = .idle
    @State private var autoSaveTask: Task<Void, Never>?
    @State private var savedIndicatorTask: Task<Void, Never>?
    @State private var isTransferPresented = false
    @State private var isCollectPresented = false
    @State private var isObservationPresented = false
    @State private var observationText = ""
    @State private var errorMessage: String?
    @State private var confirmAbandon = false
    @State private var confirmDelete = false

    private var find: YamadoriFind? {
        guard let id = appState.selectedYamadoriFindID else { return nil }
        return yamadoriService.getFind(id: id)
    }

    private var isEditing: Bool { appState.yamadoriDetailInteractionMode.isEditing }

    var body: some View {
        Group {
            if let find {
                content(for: find)
            } else {
                ContentUnavailableView(
                    "Select a Find",
                    systemImage: "leaf",
                    description: Text("Choose a Find from the trip.")
                )
            }
        }
        .onChange(of: appState.selectedYamadoriFindID) { oldID, newID in
            // Only flush when leaving this Find — not when the view first appears.
            guard oldID != nil, oldID != newID else { return }
            persistBeforeLeaving(findID: oldID)
        }
        .onChange(of: draft) { _, newDraft in
            guard isEditing, newDraft != nil else { return }
            scheduleAutoSave()
        }
        .onDisappear { flushAutoSaveIfNeeded() }
        .onChange(of: scenePhase) { _, phase in
            if phase == .inactive || phase == .background {
                flushAutoSaveIfNeeded()
            }
        }
        .onAppear { consumePendingQuickAction() }
        .onChange(of: appState.pendingYamadoriQuickAction) { _, _ in
            consumePendingQuickAction()
        }
        .sheet(isPresented: $isTransferPresented) {
            if let find {
                YamadoriTransferSheet(findID: find.id) { tree in
                    appState.selectedTreeID = tree.id
                    appState.selectedSection = .nurseryYamadori
                    appState.selectedYamadoriWorkspaceTab = .transferredTrees
                }
                .environment(yamadoriService)
                .environment(referenceData)
            }
        }
        .sheet(isPresented: $isCollectPresented) {
            if let find {
                YamadoriCollectSheet(findID: find.id) { tree in
                    appState.selectedTreeID = tree.id
                    appState.selectedSection = .nurseryYamadori
                    appState.selectedYamadoriWorkspaceTab = .yamadoriTrees
                }
                .environment(yamadoriService)
                .environment(referenceData)
            }
        }
        .sheet(isPresented: $isObservationPresented) {
            observationSheet
        }
        .alert("Could Not Update Find", isPresented: Binding(
            get: { errorMessage != nil },
            set: { if !$0 { errorMessage = nil } }
        )) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(errorMessage ?? "")
        }
        .confirmationDialog("Abandon this Find?", isPresented: $confirmAbandon, titleVisibility: .visible) {
            Button("Abandon", role: .destructive) {
                guard let find else { return }
                try? yamadoriService.setStatus(id: find.id, to: .abandoned)
            }
            Button("Cancel", role: .cancel) {}
        }
        .confirmationDialog("Delete this Find?", isPresented: $confirmDelete, titleVisibility: .visible) {
            Button("Delete Find", role: .destructive) {
                deleteSelectedFind()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This permanently deletes the Find. The trip stays.")
        }
    }

    @ViewBuilder
    private func content(for find: YamadoriFind) -> some View {
        VStack(spacing: 0) {
            if isEditing {
                TreeAutoSaveBanner(status: autoSaveStatus)
            }
            FaloAdaptiveDesktopWorkspace(profile: .treeDetail) {
                VStack(alignment: .leading, spacing: TreeDetailSpacing.cardGap) {
                    if !appState.isYamadoriFindWorkspaceWindow {
                        Button("Back to Trip") {
                            finishEditing()
                            appState.showYamadoriTrip(tripID: find.yamadoriID)
                        }
                        .buttonStyle(.borderless)
                    }
                    TreeDetailCardColumns {
                        mediaSection(find)
                        identitySection(find)
                        evaluationSection(find)
                    } column1: {
                        recoverySection(find)
                        transferSection(find)
                    } column2: {
                        YamadoriSiteMapCard(
                            title: "Find Map",
                            latitude: findMapLatitudeBinding(for: find),
                            longitude: findMapLongitudeBinding(for: find),
                            primaryTitle: displayName(for: find),
                            isEditing: isEditing,
                            secondaryPins: [],
                            focusedLatitudeDelta: 0.015,
                            mapHeight: 200
                        )
                        findLocationCard(find)
                    }

                    observationsSection(find)
                    historySection(find)
                    notesSection(find)
                }
            }
        }
        .navigationTitle(displayName(for: find))
    }

    private func identitySection(_ find: YamadoriFind) -> some View {
        DetailCard(title: "Find") {
            DetailLabeledRow(label: "Code", value: find.yamadoriCode)
            DetailLabeledRow(label: "Status", value: find.status.title)
            if isEditing, let binding = draftBinding {
                DetailEditableTextRow(label: "Display Name", text: binding.displayName)
                DetailOptionPickerRow(
                    label: "Genus",
                    selection: binding.genusID,
                    placeholder: "Select Genus",
                    options: DetailPickerOption.map(referenceData.genus)
                )
                DetailOptionPickerRow(
                    label: "Species",
                    selection: binding.speciesID,
                    placeholder: "Select Species",
                    options: DetailPickerOption.map(speciesOptions(for: binding.genusID.wrappedValue))
                )
                DetailOptionPickerRow(
                    label: "Cultivar",
                    selection: binding.cultivarID,
                    placeholder: "None",
                    options: DetailPickerOption.map(cultivarOptions(for: binding.speciesID.wrappedValue))
                )
            } else {
                DetailLabeledRow(label: "Display Name", value: find.displayName)
                DetailLabeledRow(label: "Genus", value: genusName(find.genusID))
                DetailLabeledRow(label: "Species", value: speciesName(find.speciesID))
                DetailLabeledRow(label: "Cultivar", value: cultivarName(find.cultivarID))
            }
        }
    }

    private func findLocationCard(_ find: YamadoriFind) -> some View {
        DetailCard(title: "Find Location") {
            if isEditing, let binding = draftBinding {
                DetailEditableTextRow(label: "Latitude", text: latitudeBinding(binding))
                DetailEditableTextRow(label: "Longitude", text: longitudeBinding(binding))
            } else {
                DetailLabeledRow(label: "Coordinates", value: coordinatesText(find))
            }
        }
    }

    private func findMapLatitudeBinding(for find: YamadoriFind) -> Binding<Double?> {
        Binding(
            get: { isEditing ? (draft?.latitude ?? find.latitude) : find.latitude },
            set: { newValue in
                guard isEditing else { return }
                var next = draft ?? YamadoriFindDetailDraft(from: find)
                next.latitude = newValue
                draft = next
            }
        )
    }

    private func findMapLongitudeBinding(for find: YamadoriFind) -> Binding<Double?> {
        Binding(
            get: { isEditing ? (draft?.longitude ?? find.longitude) : find.longitude },
            set: { newValue in
                guard isEditing else { return }
                var next = draft ?? YamadoriFindDetailDraft(from: find)
                next.longitude = newValue
                draft = next
            }
        )
    }

    private func coordinatesText(_ find: YamadoriFind) -> String {
        guard let lat = find.latitude, let lon = find.longitude else { return "" }
        return String(format: "%.5f, %.5f", lat, lon)
    }

    private func latitudeBinding(_ binding: Binding<YamadoriFindDetailDraft>) -> Binding<String> {
        Binding(
            get: { binding.wrappedValue.latitude.map { String($0) } ?? "" },
            set: { text in
                var draft = binding.wrappedValue
                let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
                draft.latitude = trimmed.isEmpty ? nil : Double(trimmed.replacingOccurrences(of: ",", with: "."))
                binding.wrappedValue = draft
            }
        )
    }

    private func longitudeBinding(_ binding: Binding<YamadoriFindDetailDraft>) -> Binding<String> {
        Binding(
            get: { binding.wrappedValue.longitude.map { String($0) } ?? "" },
            set: { text in
                var draft = binding.wrappedValue
                let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
                draft.longitude = trimmed.isEmpty ? nil : Double(trimmed.replacingOccurrences(of: ",", with: "."))
                binding.wrappedValue = draft
            }
        )
    }

    private func evaluationSection(_ find: YamadoriFind) -> some View {
        DetailCard(title: "Evaluation") {
            if isEditing, let binding = draftBinding {
                DetailEditableTextRow(label: "Trunk", text: binding.evaluationTrunk)
                DetailEditableTextRow(label: "Nebari", text: binding.evaluationNebari)
                DetailEditableTextRow(label: "Movement", text: binding.evaluationMovement)
                DetailEditableTextRow(label: "Taper", text: binding.evaluationTaper)
                DetailEditableTextRow(label: "Branches", text: binding.evaluationBranches)
                DetailEditableTextRow(label: "Health", text: binding.evaluationHealth)
                DetailEditableTextRow(label: "Accessibility", text: binding.evaluationAccessibility)
                DetailEditableTextRow(label: "Difficulty", text: binding.evaluationDifficulty)
                DetailEditableTextRow(label: "Overall", text: binding.evaluationOverall)
            } else {
                DetailLabeledRow(label: "Trunk", value: find.evaluationTrunk)
                DetailLabeledRow(label: "Nebari", value: find.evaluationNebari)
                DetailLabeledRow(label: "Movement", value: find.evaluationMovement)
                DetailLabeledRow(label: "Taper", value: find.evaluationTaper)
                DetailLabeledRow(label: "Branches", value: find.evaluationBranches)
                DetailLabeledRow(label: "Health", value: find.evaluationHealth)
                DetailLabeledRow(label: "Accessibility", value: find.evaluationAccessibility)
                DetailLabeledRow(label: "Difficulty", value: find.evaluationDifficulty)
                DetailLabeledRow(label: "Overall", value: find.evaluationOverall)
            }
        }
    }

    private func recoverySection(_ find: YamadoriFind) -> some View {
        DetailCard(title: "Recovery") {
            if isEditing, let binding = draftBinding {
                DetailEditableTextRow(label: "Location Notes", text: binding.recoveryLocationNotes)
                DetailEditableTextRow(label: "Care Notes", text: binding.recoveryCareNotes)
                DetailEditableTextRow(label: "Establishment", text: binding.establishmentAssessment)
            } else {
                DetailLabeledRow(label: "Location Notes", value: find.recoveryLocationNotes)
                DetailLabeledRow(label: "Care Notes", value: find.recoveryCareNotes)
                DetailLabeledRow(label: "Establishment", value: find.establishmentAssessment)
            }
        }
    }

    private func transferSection(_ find: YamadoriFind) -> some View {
        DetailCard(title: "Move to My Trees") {
            if find.status == .transferred,
               let treeID = find.linkedTreeID,
               let tree = treeService.getTree(id: treeID) {
                DetailLabeledRow(label: "Tree", value: TreePresentation.title(for: tree))
                DetailLabeledRow(
                    label: "Graduated",
                    value: find.transferDate.map { Self.dateFormatter.string(from: $0) } ?? ""
                )
                DetailLabeledRow(label: "Notes", value: find.transferNotes)
            } else if find.status.canTransferToTree {
                Button("Move to My Trees…") { isTransferPresented = true }
                    .buttonStyle(.borderless)
            } else if find.status.isUncollected {
                Button("Mark Collected…") { isCollectPresented = true }
                    .buttonStyle(.borderless)
            } else {
                DetailLabeledRow(
                    label: "Move to My Trees",
                    value: "Collect this Find first."
                )
            }
        }
    }

    private func mediaSection(_ find: YamadoriFind) -> some View {
        DetailCard(title: "Photos") {
            if let primaryID = find.primaryImageID ?? find.imageIDs.first {
                GalleryThumbnailImage(imageID: primaryID, context: .galleryCard)
                    .frame(maxWidth: .infinity)
                    .frame(height: 220)
                    .clipShape(RoundedRectangle(cornerRadius: FaloRadius.small, style: .continuous))
            }

            PotImageStrip(
                title: "Gallery",
                imageIDs: find.imageIDs,
                primaryImageID: find.primaryImageID,
                onAdd: { addImage(to: find) },
                onDropImageFiles: { sources in
                    Task { await importDroppedImages(sources, to: find) }
                },
                onSetPrimary: { id in try? yamadoriService.setPrimaryImage(findID: find.id, imageID: id) },
                onRemove: { id in try? yamadoriService.removeImage(findID: find.id, imageID: id) }
            )
        }
    }

    private func addImage(to find: YamadoriFind) {
        Task { @MainActor in
            do {
                let assets = try await imageImportService.importGalleryImagesFromFinder()
                try attachImportedAssets(assets, to: find)
            } catch is CancellationError {
                return
            } catch ImageImportError.cancelled {
                return
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }

    private func importDroppedImages(_ sources: [ImageDropSource], to find: YamadoriFind) async {
        guard !sources.isEmpty else { return }
        do {
            var assets: [ImageAsset] = []
            assets.reserveCapacity(sources.count)
            for source in sources {
                assets.append(try await imageImportService.importImage(from: source, asPrimary: false))
            }
            try attachImportedAssets(assets, to: find)
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func attachImportedAssets(_ assets: [ImageAsset], to find: YamadoriFind) throws {
        for asset in assets {
            try yamadoriService.addImage(findID: find.id, imageID: asset.id)
        }
    }

    private func observationsSection(_ find: YamadoriFind) -> some View {
        DetailCard(title: "Observations") {
            if find.observations.isEmpty {
                DetailLabeledRow(label: "Observations", value: "")
            } else {
                ForEach(find.observations.sorted { $0.date > $1.date }) { observation in
                    DetailLabeledRow(
                        label: Self.dateFormatter.string(from: observation.date),
                        value: observation.text
                    )
                }
            }
            Button("Add Observation…") { isObservationPresented = true }
                .buttonStyle(.borderless)
        }
    }

    private func historySection(_ find: YamadoriFind) -> some View {
        DetailCard(title: "History") {
            if find.history.isEmpty {
                DetailLabeledRow(label: "History", value: "")
            } else {
                ForEach(find.history.sorted { $0.date > $1.date }) { entry in
                    DetailLabeledRow(
                        label: Self.dateFormatter.string(from: entry.date),
                        value: entry.note.isEmpty ? entry.kind.title : "\(entry.kind.title) — \(entry.note)"
                    )
                }
            }
        }
    }

    private func notesSection(_ find: YamadoriFind) -> some View {
        DetailCard(title: "Notes") {
            if isEditing, let binding = draftBinding {
                DetailEditableTextRow(label: "Notes", text: binding.notes)
            } else {
                DetailLabeledRow(label: "Notes", value: find.notes)
            }
        }
    }

    private var observationSheet: some View {
        NavigationStack {
            Form {
                TextField("Observation", text: $observationText, axis: .vertical)
                    .lineLimit(4...8)
            }
            .navigationTitle("Add Observation")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        observationText = ""
                        isObservationPresented = false
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        guard let find else { return }
                        try? yamadoriService.addObservation(id: find.id, text: observationText)
                        observationText = ""
                        isObservationPresented = false
                    }
                    .disabled(observationText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }
        }
        .frame(minWidth: 360, minHeight: 240)
    }

    private var draftBinding: Binding<YamadoriFindDetailDraft>? {
        guard draft != nil else { return nil }
        return Binding(
            get: { draft! },
            set: { draft = $0 }
        )
    }

    private func beginEditing(_ find: YamadoriFind) {
        let captured = YamadoriFindDetailDraft(from: find)
        draft = captured
        lastPersistedDraft = captured
        autoSaveStatus = .idle
        appState.yamadoriDetailInteractionMode = .editing
    }

    /// Finish — flush pending Auto Save, then leave Edit Mode (does not discard).
    private func finishEditing() {
        autoSaveTask?.cancel()
        autoSaveTask = nil
        persistDraftNow(exitEditing: true)
    }

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
            persistDraftNow(exitEditing: false)
        }
    }

    private func flushAutoSaveIfNeeded() {
        guard isEditing else { return }
        guard let draft, draft != lastPersistedDraft else { return }
        autoSaveTask?.cancel()
        autoSaveTask = nil
        persistDraftNow(exitEditing: false)
    }

    private func persistBeforeLeaving(findID: UUID?) {
        if isEditing, let findID, let draft, draft != lastPersistedDraft {
            try? yamadoriService.applyFindDraft(id: findID, draft: draft)
        }
        leaveEditing()
    }

    private func persistDraftNow(exitEditing: Bool) {
        guard isEditing, let find else {
            if exitEditing { leaveEditing() }
            return
        }
        guard let currentDraft = draft else {
            if exitEditing { leaveEditing() }
            return
        }
        if currentDraft == lastPersistedDraft {
            if exitEditing { leaveEditing() }
            return
        }

        autoSaveStatus = .saving
        do {
            try yamadoriService.applyFindDraft(id: find.id, draft: currentDraft)
            if let updated = yamadoriService.getFind(id: find.id) {
                let refreshed = YamadoriFindDetailDraft(from: updated)
                draft = refreshed
                lastPersistedDraft = refreshed
            } else {
                lastPersistedDraft = currentDraft
            }
            autoSaveStatus = .saved
            showSavedThenIdle()
            if exitEditing { leaveEditing() }
        } catch {
            autoSaveStatus = .failed
            errorMessage = error.localizedDescription
        }
    }

    private func leaveEditing() {
        autoSaveTask?.cancel()
        autoSaveTask = nil
        savedIndicatorTask?.cancel()
        savedIndicatorTask = nil
        draft = nil
        lastPersistedDraft = nil
        autoSaveStatus = .idle
        appState.yamadoriDetailInteractionMode = .viewing
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

    private func handle(_ command: YamadoriQuickActionCommand) {
        guard let find else { return }
        switch command {
        case .editYamadori:
            beginEditing(find)
        case .addObservation:
            isObservationPresented = true
        case .addImage:
            addImage(to: find)
        case .advanceStatus:
            do {
                _ = try yamadoriService.advanceStatus(id: find.id)
            } catch {
                errorMessage = error.localizedDescription
            }
        case .markCollected:
            isCollectPresented = true
        case .transferToTree:
            isTransferPresented = true
        case .abandon:
            confirmAbandon = true
        case .archive:
            do {
                _ = try yamadoriService.setStatus(id: find.id, to: .archived)
            } catch {
                errorMessage = error.localizedDescription
            }
        case .deleteYamadori:
            confirmDelete = true
        case .cancel:
            finishEditing()
        case .addFind:
            break
        }
    }

    private func consumePendingQuickAction() {
        guard let request = appState.pendingYamadoriQuickAction,
              appState.selectedYamadoriFindID != nil else { return }
        handle(request.command)
        appState.clearPendingYamadoriQuickAction()
    }

    private func deleteSelectedFind() {
        guard let find else { return }
        do {
            try yamadoriService.deleteFind(id: find.id)
            appState.selectedYamadoriFindID = nil
            appState.yamadoriDetailInteractionMode = .viewing
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func displayName(for find: YamadoriFind) -> String {
        let trimmed = find.displayName.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? find.yamadoriCode : trimmed
    }

    private func genusName(_ id: UUID?) -> String {
        id.flatMap { referenceData.genus(id: $0)?.name } ?? ""
    }

    private func speciesName(_ id: UUID?) -> String {
        id.flatMap { referenceData.species(id: $0)?.name } ?? ""
    }

    private func cultivarName(_ id: UUID?) -> String {
        id.flatMap { referenceData.cultivar(id: $0)?.name } ?? ""
    }

    private func speciesOptions(for genusID: UUID?) -> [Species] {
        guard let genusID else { return [] }
        return referenceData.species(forGenusID: genusID)
    }

    private func cultivarOptions(for speciesID: UUID?) -> [Cultivar] {
        guard let speciesID else { return [] }
        return referenceData.cultivars(forSpeciesID: speciesID)
    }

    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
}
