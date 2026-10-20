//
//  YamadoriDetailView.swift
//  Bonsai World
//
//  Trip detail — site, plan, checklists, and Finds.
//

import MapKit
import SwiftUI

struct YamadoriDetailView: View {
    private static let autoSaveDebounceMilliseconds: UInt64 = 600
    private static let savedIndicatorMilliseconds: UInt64 = 1200

    @Environment(AppState.self) private var appState
    @Environment(YamadoriService.self) private var yamadoriService
    @Environment(TreeService.self) private var treeService
    @Environment(ImageService.self) private var imageService
    @Environment(\.scenePhase) private var scenePhase

    @State private var draft: YamadoriTripDetailDraft?
    @State private var lastPersistedDraft: YamadoriTripDetailDraft?
    @State private var autoSaveStatus: TreeAutoSaveStatus = .idle
    @State private var autoSaveTask: Task<Void, Never>?
    @State private var savedIndicatorTask: Task<Void, Never>?
    @State private var errorMessage: String?
    @State private var confirmDelete = false

    private var trip: Yamadori? {
        guard let id = appState.selectedYamadoriID else { return nil }
        return yamadoriService.getYamadori(id: id)
    }

    private var tripFinds: [YamadoriFind] {
        guard let trip else { return [] }
        return yamadoriService.finds(forYamadoriID: trip.id)
            .sorted {
                $0.yamadoriCode.localizedCaseInsensitiveCompare($1.yamadoriCode) == .orderedAscending
            }
    }

    private var isEditing: Bool { appState.yamadoriDetailInteractionMode.isEditing }

    var body: some View {
        Group {
            if let trip {
                content(for: trip)
            } else {
                ContentUnavailableView(
                    "Select a Yamadori",
                    systemImage: "mountain.2",
                    description: Text("Choose a trip from the list.")
                )
            }
        }
        .onChange(of: appState.selectedYamadoriID) { oldID, _ in
            persistBeforeLeaving(tripID: oldID)
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
        .alert("Could Not Update Yamadori", isPresented: Binding(
            get: { errorMessage != nil },
            set: { if !$0 { errorMessage = nil } }
        )) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(errorMessage ?? "")
        }
        .confirmationDialog("Delete this Yamadori?", isPresented: $confirmDelete, titleVisibility: .visible) {
            Button("Delete Trip and Finds", role: .destructive) {
                deleteSelectedTrip()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This permanently deletes the trip and all Finds on it.")
        }
    }

    private func consumePendingQuickAction() {
        guard let request = appState.pendingYamadoriQuickAction,
              appState.selectedYamadoriFindID == nil else { return }
        handle(request.command)
        appState.clearPendingYamadoriQuickAction()
    }

    @ViewBuilder
    private func content(for trip: Yamadori) -> some View {
        VStack(spacing: 0) {
            if isEditing {
                TreeAutoSaveBanner(status: autoSaveStatus)
            }
            FaloAdaptiveDesktopWorkspace(profile: .treeDetail) {
                VStack(alignment: .leading, spacing: TreeDetailSpacing.cardGap) {
                    TreeDetailCardColumns {
                        YamadoriSiteMapCard(
                            title: "Area Map",
                            latitude: tripMapLatitudeBinding(for: trip),
                            longitude: tripMapLongitudeBinding(for: trip),
                            primaryTitle: displayName(for: trip),
                            isEditing: isEditing,
                            secondaryPins: findMapPins,
                            focusedLatitudeDelta: 0.12,
                            mapHeight: 220
                        )
                        identitySection(trip)
                        wildSiteCard(trip)
                    } column1: {
                        findsSection
                    } column2: {
                        collectionPlanSection(trip)
                        notesSection(trip)
                    }
                }
            }
        }
        .navigationTitle(displayName(for: trip))
    }

    private func identitySection(_ trip: Yamadori) -> some View {
        DetailCard(title: "Trip") {
            if isEditing, let binding = draftBinding {
                DetailEditableTextRow(label: "Display Name", text: binding.displayName)
                VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
                    Text("Trip Date")
                        .font(FaloTypography.caption)
                        .foregroundStyle(.secondary)
                    DatePicker(
                        "Trip Date",
                        selection: Binding(
                            get: { binding.wrappedValue.tripDate ?? .now },
                            set: { binding.wrappedValue.tripDate = $0 }
                        ),
                        displayedComponents: .date
                    )
                    .labelsHidden()
                    .datePickerStyle(.compact)
                }
                .padding(.vertical, FaloSpacing.xSmall)
            } else {
                DetailLabeledRow(label: "Display Name", value: trip.displayName)
                DetailLabeledRow(
                    label: "Trip Date",
                    value: trip.tripDate.map { Self.dateFormatter.string(from: $0) } ?? ""
                )
            }
            DetailLabeledRow(label: "Finds", value: "\(tripFinds.count)")
        }
    }

    private func wildSiteCard(_ trip: Yamadori) -> some View {
        DetailCard(title: "Wild Site") {
            if isEditing, let binding = draftBinding {
                DetailEditableTextRow(label: "Location Description", text: binding.locationDescription)
                DetailEditableTextRow(label: "Country / Region", text: binding.countryRegion)
                DetailEditableTextRow(label: "Latitude", text: latitudeBinding(binding))
                DetailEditableTextRow(label: "Longitude", text: longitudeBinding(binding))
                DetailEditableTextRow(label: "Permission Notes", text: binding.permissionNotes)
                DetailEditableTextRow(label: "Land Ownership", text: binding.landOwnershipNotes)
            } else {
                DetailLabeledRow(label: "Location Description", value: trip.locationDescription)
                DetailLabeledRow(label: "Country / Region", value: trip.countryRegion)
                DetailLabeledRow(label: "Coordinates", value: coordinatesText(trip))
                DetailLabeledRow(label: "Permission Notes", value: trip.permissionNotes)
                DetailLabeledRow(label: "Land Ownership", value: trip.landOwnershipNotes)
            }
        }
    }

    private var findMapPins: [YamadoriMapPin] {
        tripFinds.compactMap { find in
            guard let lat = find.latitude, let lon = find.longitude else { return nil }
            return YamadoriMapPin(
                id: find.id,
                title: findDisplayName(find),
                latitude: lat,
                longitude: lon,
                kind: .find
            )
        }
    }

    private func tripMapLatitudeBinding(for trip: Yamadori) -> Binding<Double?> {
        Binding(
            get: { isEditing ? (draft?.latitude ?? trip.latitude) : trip.latitude },
            set: { newValue in
                guard isEditing else { return }
                var next = draft ?? YamadoriTripDetailDraft(from: trip)
                next.latitude = newValue
                draft = next
            }
        )
    }

    private func tripMapLongitudeBinding(for trip: Yamadori) -> Binding<Double?> {
        Binding(
            get: { isEditing ? (draft?.longitude ?? trip.longitude) : trip.longitude },
            set: { newValue in
                guard isEditing else { return }
                var next = draft ?? YamadoriTripDetailDraft(from: trip)
                next.longitude = newValue
                draft = next
            }
        )
    }

    private var findsSection: some View {
        DetailCard(title: "Finds") {
            if tripFinds.isEmpty {
                DetailLabeledRow(label: "Finds", value: "None yet")
            } else {
                ForEach(tripFinds) { find in
                    Button {
                        openFind(find)
                    } label: {
                        HStack {
                            VStack(alignment: .leading, spacing: 2) {
                                Text(findDisplayName(find))
                                    .font(FaloTypography.body)
                                    .foregroundStyle(.primary)
                                Text("\(find.yamadoriCode) · \(find.status.title)")
                                    .font(FaloTypography.caption)
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundStyle(.tertiary)
                        }
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                    .disabled(isEditing)
                    .contextMenu {
                        Button("Open Find") {
                            openFind(find)
                        }
                        Button("Open Find Workspace") {
                            appState.openYamadoriFindInPlace(findID: find.id, tripID: find.yamadoriID)
                        }
                    }
                }
            }
            Button("Add Find") { addFind() }
                .disabled(isEditing)
        }
    }

    private func collectionPlanSection(_ trip: Yamadori) -> some View {
        DetailCard(title: "Collection Plan") {
            if isEditing, let binding = draftBinding {
                DetailEditableTextRow(label: "Window Notes", text: binding.collectionWindowNotes)
                DetailEditableTextRow(label: "Preparation", text: binding.preparationNotes)
                DetailEditableTextRow(label: "Equipment", text: binding.equipmentNotes)
                DetailEditableTextRow(label: "Plan Notes", text: binding.collectionPlanNotes)
            } else {
                DetailLabeledRow(label: "Window Notes", value: trip.collectionWindowNotes)
                DetailLabeledRow(label: "Preparation", value: trip.preparationNotes)
                DetailLabeledRow(label: "Equipment", value: trip.equipmentNotes)
                DetailLabeledRow(label: "Plan Notes", value: trip.collectionPlanNotes)
            }

            checklistBlock(title: "Pre-Collection", items: trip.preCollectionChecklist, kit: false, tripID: trip.id)
            checklistBlock(title: "Collection Kit", items: trip.collectionKitChecklist, kit: true, tripID: trip.id)
        }
    }

    private func checklistBlock(title: String, items: [YamadoriChecklistItem], kit: Bool, tripID: UUID) -> some View {
        VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
            Text(title)
                .font(FaloCardTypography.fieldLabel)
                .foregroundStyle(.secondary)
            ForEach(items) { item in
                Toggle(item.title, isOn: Binding(
                    get: { item.isComplete },
                    set: { newValue in
                        try? yamadoriService.setChecklistItem(
                            id: tripID,
                            itemID: item.id,
                            isComplete: newValue,
                            kit: kit
                        )
                    }
                ))
                .disabled(isEditing)
            }
        }
    }

    private func notesSection(_ trip: Yamadori) -> some View {
        DetailCard(title: "Notes") {
            if isEditing, let binding = draftBinding {
                DetailEditableTextRow(label: "Notes", text: binding.notes)
            } else {
                DetailLabeledRow(label: "Notes", value: trip.notes)
            }
        }
    }

    // MARK: - Edit / actions

    private var draftBinding: Binding<YamadoriTripDetailDraft>? {
        guard draft != nil else { return nil }
        return Binding(
            get: { draft! },
            set: { draft = $0 }
        )
    }

    private func beginEditing(_ trip: Yamadori) {
        let captured = YamadoriTripDetailDraft(from: trip)
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

    private func persistBeforeLeaving(tripID: UUID?) {
        if isEditing, let tripID, let draft, draft != lastPersistedDraft {
            try? yamadoriService.applyTripDraft(id: tripID, draft: draft)
        }
        leaveEditing()
    }

    private func persistDraftNow(exitEditing: Bool) {
        guard isEditing, let trip else {
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
            try yamadoriService.applyTripDraft(id: trip.id, draft: currentDraft)
            if let updated = yamadoriService.getYamadori(id: trip.id) {
                let refreshed = YamadoriTripDetailDraft(from: updated)
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
        guard let trip else { return }
        switch command {
        case .editYamadori:
            beginEditing(trip)
        case .addFind:
            addFind()
        case .deleteYamadori:
            confirmDelete = true
        case .cancel:
            finishEditing()
        default:
            break
        }
    }

    private func deleteSelectedTrip() {
        guard let trip else { return }
        do {
            try yamadoriService.deleteYamadori(id: trip.id)
            appState.selectedYamadoriID = nil
            appState.selectedYamadoriFindID = nil
            appState.yamadoriDetailInteractionMode = .viewing
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func addFind() {
        guard let trip else { return }
        do {
            let find = try yamadoriService.createFind(onYamadoriID: trip.id)
            openFind(find)
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    /// Opens Find at its home tab (Uncollected Findings / Yamadori Trees / Transferred).
    private func openFind(_ find: YamadoriFind) {
        let tree = find.linkedTreeID.flatMap { treeService.getTree(id: $0) }
        appState.openYamadoriFindAtLastPosition(find: find, tree: tree)
    }

    private func displayName(for trip: Yamadori) -> String {
        let trimmed = trip.displayName.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmed.isEmpty { return trimmed }
        if !trip.locationDescription.isEmpty { return trip.locationDescription }
        return "Yamadori"
    }

    private func findDisplayName(_ find: YamadoriFind) -> String {
        let trimmed = find.displayName.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? find.yamadoriCode : trimmed
    }

    private func coordinatesText(_ trip: Yamadori) -> String {
        guard let lat = trip.latitude, let lon = trip.longitude else { return "" }
        return String(format: "%.5f, %.5f", lat, lon)
    }

    private func latitudeBinding(_ binding: Binding<YamadoriTripDetailDraft>) -> Binding<String> {
        Binding(
            get: { binding.wrappedValue.latitude.map { String($0) } ?? "" },
            set: { text in
                var draft = binding.wrappedValue
                draft.latitude = Double(text.replacingOccurrences(of: ",", with: "."))
                binding.wrappedValue = draft
            }
        )
    }

    private func longitudeBinding(_ binding: Binding<YamadoriTripDetailDraft>) -> Binding<String> {
        Binding(
            get: { binding.wrappedValue.longitude.map { String($0) } ?? "" },
            set: { text in
                var draft = binding.wrappedValue
                draft.longitude = Double(text.replacingOccurrences(of: ",", with: "."))
                binding.wrappedValue = draft
            }
        )
    }

    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter
    }()
}
