//
//  YamadoriListView.swift
//  Bonsai World
//
//  Trip list — Table layout matching Garden → Trees (inset, alternating rows).
//

import SwiftUI

struct YamadoriListView: View {
    var embedded: Bool = false

    @Environment(AppState.self) private var appState
    @Environment(YamadoriService.self) private var yamadoriService
    @Environment(ImageService.self) private var imageService
    @Environment(\.openWindow) private var openWindow

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

    var body: some View {
        Group {
            if rows.isEmpty {
                emptyState
            } else {
                listScroll
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

    private var listScroll: some View {
        ScrollView {
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

                tripsTable
            }
            .padding(.top, FaloSpacing.small)
            .padding(.bottom, FaloSpacing.xLarge)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .faloScrollSurface()
    }

    private var tripTableMinimumWidth: CGFloat { 220 + 140 + 110 + 60 + 24 }

    private var tripsTable: some View {
        let height = tableHeight(for: sortedRows.count)
        return GeometryReader { geo in
            ScrollView(.horizontal, showsIndicators: true) {
                tripTableContent
                    .frame(width: max(geo.size.width, tripTableMinimumWidth), height: height)
            }
        }
        .frame(height: height)
    }

    private var tripTableContent: some View {
        Table(sortedRows, selection: $tableSelection, sortOrder: $sortOrder) {
            TableColumn("Trip", value: \.displayName, comparator: .localizedStandard) { row in
                HStack(spacing: FaloSpacing.medium) {
                    TreeListThumbnail(imageID: row.trip.listImageID, imageService: imageService)
                    VStack(alignment: .leading, spacing: 2) {
                        Text(row.displayName)
                            .font(FaloTypography.body)
                            .lineLimit(1)
                        Text(row.findCount == 1 ? "1 Find" : "\(row.findCount) Finds")
                            .font(FaloTypography.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                .padding(.vertical, FaloSpacing.xSmall)
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
        .scrollDisabled(true)
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

    private func tableHeight(for rowCount: Int) -> CGFloat {
        let header: CGFloat = 28
        let row: CGFloat = 44
        return header + CGFloat(max(rowCount, 1)) * row
    }

    private func syncSelectionFromAppState() {
        let next = Set(appState.selectedYamadoriID.map { [$0] } ?? [])
        if tableSelection != next {
            tableSelection = next
        }
    }

    private func openTripWorkspace(tripID: UUID) {
        appState.selectedYamadoriID = tripID
        openWindow(
            id: YamadoriTripWorkspaceWindowContext.windowID,
            value: YamadoriTripWorkspaceWindowContext(tripID: tripID)
        )
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
