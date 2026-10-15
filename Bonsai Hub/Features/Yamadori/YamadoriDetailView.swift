//
//  YamadoriDetailView.swift
//  Bonsai World
//
//  Trip detail — site, plan, checklists, and Finds.
//

import MapKit
import SwiftUI

struct YamadoriDetailView: View {
    @Environment(AppState.self) private var appState
    @Environment(YamadoriService.self) private var yamadoriService
    @Environment(TreeService.self) private var treeService
    @Environment(ImageService.self) private var imageService
    @Environment(\.openWindow) private var openWindow

    @State private var draft: YamadoriTripDetailDraft?
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
        .onChange(of: appState.selectedYamadoriID) { _, _ in
            draft = nil
            appState.yamadoriDetailInteractionMode = .viewing
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
        .navigationTitle(displayName(for: trip))
    }

    private func identitySection(_ trip: Yamadori) -> some View {
        DetailCard(title: "Trip") {
            if isEditing, let binding = draftBinding {
                DetailEditableTextRow(label: "Display Name", text: binding.displayName)
            } else {
                DetailLabeledRow(label: "Display Name", value: trip.displayName)
            }
            DetailLabeledRow(
                label: "Trip Date",
                value: trip.tripDate.map { Self.dateFormatter.string(from: $0) } ?? ""
            )
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
                if draft == nil { draft = YamadoriTripDetailDraft(from: trip) }
                draft?.latitude = newValue
            }
        )
    }

    private func tripMapLongitudeBinding(for trip: Yamadori) -> Binding<Double?> {
        Binding(
            get: { isEditing ? (draft?.longitude ?? trip.longitude) : trip.longitude },
            set: { newValue in
                guard isEditing else { return }
                if draft == nil { draft = YamadoriTripDetailDraft(from: trip) }
                draft?.longitude = newValue
            }
        )
    }

    private var findsSection: some View {
        DetailCard(title: "Finds") {
            if tripFinds.isEmpty {
                DetailLabeledRow(label: "Finds", value: "None yet")
            } else {
                ForEach(tripFinds) { find in
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(findDisplayName(find))
                                .font(FaloTypography.body)
                            Text("\(find.yamadoriCode) · \(find.status.title)")
                                .font(FaloTypography.caption)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundStyle(.tertiary)
                    }
                    .contentShape(Rectangle())
                    .onTapGesture(count: 2) {
                        openWindow(
                            id: YamadoriFindWorkspaceWindowContext.windowID,
                            value: YamadoriFindWorkspaceWindowContext(
                                findID: find.id,
                                tripID: find.yamadoriID
                            )
                        )
                    }
                    .onTapGesture(count: 1) {
                        let tree = find.linkedTreeID.flatMap { treeService.getTree(id: $0) }
                        appState.openYamadoriFindAtLastPosition(find: find, tree: tree)
                    }
                    .contextMenu {
                        Button("Open Find Workspace") {
                            openWindow(
                                id: YamadoriFindWorkspaceWindowContext.windowID,
                                value: YamadoriFindWorkspaceWindowContext(
                                    findID: find.id,
                                    tripID: find.yamadoriID
                                )
                            )
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
        draft = YamadoriTripDetailDraft(from: trip)
        appState.yamadoriDetailInteractionMode = .editing
    }

    private func commitDraft(for trip: Yamadori) {
        guard let draft else { return }
        do {
            try yamadoriService.applyTripDraft(id: trip.id, draft: draft)
            self.draft = nil
            appState.yamadoriDetailInteractionMode = .viewing
        } catch {
            errorMessage = error.localizedDescription
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
            draft = nil
            appState.yamadoriDetailInteractionMode = .viewing
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
            let tree = find.linkedTreeID.flatMap { treeService.getTree(id: $0) }
            appState.openYamadoriFindAtLastPosition(find: find, tree: tree)
        } catch {
            errorMessage = error.localizedDescription
        }
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
