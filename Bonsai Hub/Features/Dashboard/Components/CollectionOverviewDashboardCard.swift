//
//  CollectionOverviewDashboardCard.swift
//  Bonsai World
//
//  Dashboard Collection Overview — live named Collections (not library totals).
//  Library totals live on My Trees. Read-only; tap opens the Collection.
//

import SwiftUI

struct CollectionOverviewDashboardCard: View {
    var prominence: DashboardCardProminence = .secondary

    @Environment(TreeService.self) private var treeService
    @Environment(AppState.self) private var appState

    private let rowLimit = 8

    private var collections: [Collection] {
        treeService.collections
            .filter(\.isManual)
            .sorted { $0.name.localizedStandardCompare($1.name) == .orderedAscending }
    }

    var body: some View {
        DashboardCard(id: .collectionOverview, prominence: prominence, compact: true) {
            if collections.isEmpty {
                DashboardEmptyMessage(text: "No collections yet.")
            } else {
                VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
                    ForEach(collections.prefix(rowLimit)) { collection in
                        DashboardCardTapButton {
                            openCollection(collection.id)
                        } label: {
                            DashboardMetricRow(
                                title: collection.name,
                                value: "\(collection.treeIDs.count)",
                                systemImage: collection.icon,
                                compact: true
                            )
                        }
                    }

                    let extra = collections.count - rowLimit
                    if extra > 0 {
                        Text("\(extra) more in Garden")
                            .font(FaloTypography.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
    }

    private func openCollection(_ id: UUID) {
        appState.selectedCollectionID = id
        appState.lastOpenedCollectionID = id
        appState.selectSection(.gardenCollections)
    }
}
