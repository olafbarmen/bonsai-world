//
//  SeedBatchListView.swift
//  Bonsai World
//
//  Seeds batch list — Table layout matching Garden → Trees (inset, warm zebra).
//  Single-click selects; double-click opens a window.
//

import SwiftUI

enum SeedBatchListScope: Hashable, Sendable {
    case active
    case all
}

struct SeedBatchListView: View {
    var scope: SeedBatchListScope = .active

    @Environment(AppState.self) private var appState
    @Environment(SeedBatchService.self) private var seedBatchService
    @Environment(ReferenceDataService.self) private var referenceData
    @Environment(\.openWindow) private var openWindow

    @State private var tableSelection: Set<UUID> = []
    @State private var sortOrder: [KeyPathComparator<SeedBatchListRow>] = [
        .init(\.botanicalName, comparator: .localizedStandard)
    ]

    private var activeRows: [SeedBatchListRow] {
        seedBatchService.activeBatches.map(makeRow)
    }

    private var archivedRows: [SeedBatchListRow] {
        seedBatchService.batches.filter { !$0.stage.isActive }.map(makeRow)
    }

    private var allActiveSorted: [SeedBatchListRow] { sorted(activeRows) }
    private var allArchivedSorted: [SeedBatchListRow] { sorted(archivedRows) }

    var body: some View {
        Group {
            if seedBatchService.batches.isEmpty {
                ContentUnavailableView(
                    "No Seed Batches",
                    systemImage: "leaf.circle",
                    description: Text("Use Context Tools → New Seed Batch to start one.")
                )
            } else if scope == .active, activeRows.isEmpty {
                ContentUnavailableView(
                    "No Active Batches",
                    systemImage: "leaf.circle",
                    description: Text("Create a batch or open Overview for completed ones.")
                )
            } else {
                listScroll
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear { syncSelectionFromAppState() }
        .onChange(of: appState.selectedSeedBatchID) { _, _ in
            syncSelectionFromAppState()
        }
        .onChange(of: tableSelection) { _, newValue in
            let nextID = newValue.first
            guard appState.selectedSeedBatchID != nextID else { return }
            appState.selectedSeedBatchID = nextID
        }
    }

    private var listScroll: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: FaloSpacing.xxLarge) {
                listBlock(
                    title: scope == .active ? "Active Batches" : "Active Batches",
                    rows: allActiveSorted,
                    emptyMessage: scope == .all ? "No active batches." : nil
                )
                if scope == .all, !archivedRows.isEmpty {
                    listBlock(
                        title: "Completed & Archived",
                        rows: allArchivedSorted,
                        emptyMessage: nil
                    )
                }
            }
            .padding(.top, FaloSpacing.small)
            .padding(.bottom, FaloSpacing.xLarge)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .faloScrollSurface()
    }

    @ViewBuilder
    private func listBlock(
        title: String,
        rows: [SeedBatchListRow],
        emptyMessage: String?
    ) -> some View {
        VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
            Text(title)
                .font(FaloTypography.caption.weight(.semibold))
                .foregroundStyle(.secondary)
                .padding(.horizontal, FaloSpacing.medium)
                .accessibilityAddTraits(.isHeader)

            if rows.isEmpty, let emptyMessage {
                Text(emptyMessage)
                    .font(FaloTypography.body)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, FaloSpacing.medium)
            } else if !rows.isEmpty {
                horizontallyScrollableTable(rows)
            }
        }
    }

    private var tableMinimumWidth: CGFloat { 220 + 120 + 70 + 70 + 120 + 24 }

    private func horizontallyScrollableTable(_ rows: [SeedBatchListRow]) -> some View {
        let height = tableHeight(for: rows.count)
        return GeometryReader { geo in
            ScrollView(.horizontal, showsIndicators: true) {
                batchesTable(rows)
                    .frame(width: max(geo.size.width, tableMinimumWidth), height: height)
            }
        }
        .frame(height: height)
    }

    private func batchesTable(_ rows: [SeedBatchListRow]) -> some View {
        Table(rows, selection: $tableSelection, sortOrder: $sortOrder) {
            TableColumn("Seed Batch", value: \.botanicalName, comparator: .localizedStandard) { row in
                VStack(alignment: .leading, spacing: 2) {
                    Text(row.botanicalName)
                        .font(FaloTypography.body)
                        .lineLimit(1)
                    Text(row.batchCode)
                        .font(FaloTypography.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }
                .padding(.vertical, FaloSpacing.xSmall)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .width(min: 220, max: .infinity)

            TableColumn("Stage", value: \.stageTitle, comparator: .localizedStandard) { row in
                Text(row.stageTitle)
                    .font(FaloTypography.body)
                    .lineLimit(1)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .width(min: 120, max: .infinity)

            TableColumn("Viable", value: \.viableCount) { row in
                Text("\(row.viableCount)")
                    .font(FaloTypography.body)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .width(min: 70, max: 90)

            TableColumn("Sown", value: \.sownCount) { row in
                Text("\(row.sownCount)")
                    .font(FaloTypography.body)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .width(min: 70, max: 90)

            TableColumn("Location", value: \.locationName, comparator: .localizedStandard) { row in
                Text(row.locationName.isEmpty ? "—" : row.locationName)
                    .font(FaloTypography.body)
                    .lineLimit(1)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .width(min: 120, max: .infinity)
        }
        .tableStyle(.inset(alternatesRowBackgrounds: false))
        .faloWarmTableZebraRows()
        .scrollDisabled(true)
        .contextMenu(forSelectionType: UUID.self) { selection in
            if selection.count == 1, let id = selection.first {
                Button("Open in New Window") {
                    openBatchWindow(batchID: id)
                }
            }
        } primaryAction: { selection in
            guard let id = selection.first else { return }
            openBatchWindow(batchID: id)
        }
    }

    private func tableHeight(for rowCount: Int) -> CGFloat {
        let headerHeight: CGFloat = 30
        let rowHeight: CGFloat = 52
        return headerHeight + CGFloat(rowCount) * rowHeight
    }

    private func sorted(_ rows: [SeedBatchListRow]) -> [SeedBatchListRow] {
        if sortOrder.isEmpty {
            return rows.sorted {
                $0.botanicalName.localizedStandardCompare($1.botanicalName) == .orderedAscending
            }
        }
        return rows.sorted(using: sortOrder)
    }

    private func makeRow(_ batch: SeedBatch) -> SeedBatchListRow {
        let location: String = {
            guard let locationID = batch.locationID,
                  let loc = referenceData.location(id: locationID) else { return "" }
            return loc.name
        }()
        return SeedBatchListRow(
            id: batch.id,
            botanicalName: batch.botanicalName,
            batchCode: batch.batchCode,
            stageTitle: batch.stage.title,
            viableCount: batch.viableSeedCount,
            sownCount: batch.sownSeedCount,
            locationName: location
        )
    }

    private func syncSelectionFromAppState() {
        if let id = appState.selectedSeedBatchID {
            tableSelection = [id]
        } else {
            tableSelection = []
        }
    }

    private func openBatchWindow(batchID: UUID) {
        appState.selectedSeedBatchID = batchID
        openWindow(
            id: SeedBatchWorkspaceWindowContext.windowID,
            value: SeedBatchWorkspaceWindowContext(batchID: batchID)
        )
    }
}

private struct SeedBatchListRow: Identifiable, Sendable {
    var id: UUID
    var botanicalName: String
    var batchCode: String
    var stageTitle: String
    var viableCount: Int
    var sownCount: Int
    var locationName: String
}
