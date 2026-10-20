//
//  YamadoriListView.swift
//  Bonsai World
//
//  Trip list — same Table config as Garden → Trees:
//  inset, alternating rows, Table fills the pane and scrolls itself.
//

import SwiftUI

struct YamadoriListView: View {
    var embedded: Bool = false

    @Environment(AppState.self) private var appState
    @Environment(YamadoriService.self) private var yamadoriService
    @Environment(ImageService.self) private var imageService

    @State private var tableSelection: Set<Yamadori.ID> = []
    @State private var sortOrder: [KeyPathComparator<YamadoriTripListRow>] = [
        .init(\.displayName, comparator: .localizedStandard)
    ]

    private var rows: [YamadoriTripListRow] {
        yamadoriService.records.map { trip in
            let finds = yamadoriService.finds(forYamadoriID: trip.id)
            return YamadoriTripListRow(trip: trip, findCount: finds.count, imageService: imageService)
        }
    }

    private var sortedRows: [YamadoriTripListRow] {
        if sortOrder.isEmpty {
            return rows.sorted {
                $0.displayName.localizedStandardCompare($1.displayName) == .orderedAscending
            }
        }
        return rows.sorted(using: sortOrder)
    }

    private var tripTableMinimumWidth: CGFloat { 220 + 140 + 110 + 60 + 24 }

    var body: some View {
        Group {
            if rows.isEmpty {
                emptyState
            } else {
                listContent
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .faloWorkspaceCanvas()
        .modifier(YamadoriEmbeddedListChrome(embedded: embedded, title: "Yamadories"))
        .onAppear { syncSelectionFromAppState() }
        .onChange(of: appState.selectedYamadoriID) { _, _ in syncSelectionFromAppState() }
        .onChange(of: tableSelection) { _, newValue in
            let nextID = newValue.first
            guard appState.selectedYamadoriID != nextID else { return }
            appState.selectedYamadoriID = nextID
            appState.selectedYamadoriFindID = nil
            appState.yamadoriDetailInteractionMode = .viewing
        }
    }

    private var emptyState: some View {
        ContentUnavailableView {
            Label("No Yamadories", systemImage: "mountain.2")
        } description: {
            Text("Add a trip to start collecting findings.")
        } actions: {
            Button("Add Yamadori") {
                appState.presentNewYamadori()
            }
        }
    }

    /// Same structure as Trees ``listBlock`` — Table fills remaining height.
    private var listContent: some View {
        VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
            HStack(spacing: FaloSpacing.medium) {
                Text("Yamadories")
                    .font(FaloTypography.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
                    .accessibilityAddTraits(.isHeader)

                Spacer(minLength: 0)

                Button("Add Yamadori") {
                    appState.presentNewYamadori()
                }
            }
            .padding(.horizontal, FaloSpacing.medium)
            .padding(.top, FaloSpacing.small)

            tripsTable
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .environment(\.defaultMinListRowHeight, 56)
        }
        .frame(minWidth: tripTableMinimumWidth, maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .faloScrollSurface()
    }

    private var tripsTable: some View {
        Table(sortedRows, selection: $tableSelection, sortOrder: $sortOrder) {
            TableColumn("Trip", value: \.displayName, comparator: .localizedStandard) { row in
                HStack(alignment: .center, spacing: FaloSpacing.small) {
                    TreeListThumbnail(imageID: row.trip.listImageID, imageService: imageService)
                    VStack(alignment: .leading, spacing: 1) {
                        Text(row.displayName)
                            .font(FaloTypography.body.weight(.semibold))
                            .foregroundStyle(.primary)
                            .lineLimit(1)
                        Text(row.findCount == 1 ? "1 Find" : "\(row.findCount) Finds")
                            .font(FaloTypography.caption)
                            .foregroundStyle(.secondary)
                            .lineLimit(1)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(.vertical, 2)
                .frame(maxWidth: .infinity, alignment: .leading)
                .accessibilityElement(children: .combine)
            }
            .width(min: 220, max: .infinity)

            TableColumn("Location", value: \.locationLabel, comparator: .localizedStandard) { row in
                Text(row.locationLabel.isEmpty ? "—" : row.locationLabel)
                    .font(FaloTypography.body)
                    .lineLimit(1)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .width(min: 140, max: .infinity)

            TableColumn("Trip Date", value: \.tripDateSort) { row in
                Text(row.tripDateLabel.isEmpty ? "—" : row.tripDateLabel)
                    .font(FaloTypography.body)
                    .lineLimit(1)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .width(min: 110, max: .infinity)

            TableColumn("Finds", value: \.findCount) { row in
                Text("\(row.findCount)")
                    .font(FaloTypography.body)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .width(min: 60, max: 100)
        }
        .tableStyle(.inset(alternatesRowBackgrounds: true))
        .environment(imageService)
        .contextMenu(forSelectionType: Yamadori.ID.self) { selection in
            if selection.count == 1, let id = selection.first {
                Button("Open Trip Workspace") {
                    openTripWorkspace(tripID: id)
                }
                Divider()
                Button("Delete Yamadori", role: .destructive) {
                    appState.selectedYamadoriID = id
                    appState.requestYamadoriQuickAction(.deleteYamadori)
                }
            }
        } primaryAction: { selection in
            guard let id = selection.first else { return }
            openTripWorkspace(tripID: id)
        }
    }

    private func syncSelectionFromAppState() {
        let next = Set(appState.selectedYamadoriID.map { [$0] } ?? [])
        if tableSelection != next {
            tableSelection = next
        }
    }

    private func openTripWorkspace(tripID: UUID) {
        appState.openYamadoriTripInPlace(tripID: tripID)
    }
}

private struct YamadoriTripListRow: Identifiable {
    var id: UUID { trip.id }
    let trip: Yamadori
    let findCount: Int
    let imageService: ImageService

    var displayName: String {
        let name = trip.displayName.trimmingCharacters(in: .whitespacesAndNewlines)
        return name.isEmpty ? "Untitled trip" : name
    }

    var locationLabel: String {
        trip.locationDescription.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var tripDateSort: Date {
        trip.tripDate ?? .distantPast
    }

    var tripDateLabel: String {
        guard let date = trip.tripDate else { return "" }
        return date.formatted(date: .abbreviated, time: .omitted)
    }
}
