//
//  LibraryDashboardCard.swift
//  Bonsai World
//
//  Dashboard Library — live record gaps (photo, Tree Stage, species).
//  Counts and filters share ``DashboardCollectionSummary`` predicates with Garden → Trees.
//

import SwiftUI

struct LibraryDashboardCard: View {
    var prominence: DashboardCardProminence = .secondary
    var fillsRowHeight: Bool = false

    @Environment(TreeService.self) private var treeService
    @Environment(AppState.self) private var appState

    private var gaps: [(title: String, count: Int, filter: TreesOverviewFilter)] {
        let trees = treeService.trees
        return [
            (
                "Without a photo",
                DashboardCollectionSummary.libraryGapCount(in: trees, matching: DashboardCollectionSummary.lacksPhoto),
                .withoutPhoto
            ),
            (
                "Without status",
                DashboardCollectionSummary.libraryGapCount(in: trees, matching: DashboardCollectionSummary.lacksTreeStage),
                .withoutStatus
            ),
            (
                "Without species",
                DashboardCollectionSummary.libraryGapCount(in: trees, matching: DashboardCollectionSummary.lacksSpecies),
                .withoutSpecies
            )
        ]
    }

    var body: some View {
        DashboardCard(id: .library, prominence: prominence, fillsRowHeight: fillsRowHeight, compact: true) {
            VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
                ForEach(gaps, id: \.filter) { gap in
                    DashboardCardTapButton {
                        appState.openGardenTrees(filter: gap.filter)
                    } label: {
                        DashboardMetricRow(
                            title: gap.title,
                            value: "\(gap.count)",
                            compact: true
                        )
                    }
                }
            }
        }
    }
}
