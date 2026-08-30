//
//  LibraryDashboardCard.swift
//  Bonsai World
//
//  Dashboard Library — live record gaps (photo, status, species). Read-only.
//

import SwiftUI

struct LibraryDashboardCard: View {
    var prominence: DashboardCardProminence = .secondary

    @Environment(TreeService.self) private var treeService
    @Environment(AppState.self) private var appState

    private var trees: [Tree] { treeService.treesInCare }

    private var withoutPhoto: Int {
        trees.count { $0.primaryImageID == nil && $0.imageIDs.isEmpty }
    }

    private var withoutStatus: Int {
        trees.count { $0.treeStatusID == nil }
    }

    private var withoutSpecies: Int {
        trees.count { $0.speciesID == nil }
    }

    private var gaps: [(title: String, count: Int)] {
        [
            ("Without a photo", withoutPhoto),
            ("Without status", withoutStatus),
            ("Without species", withoutSpecies)
        ]
        .filter { $0.count > 0 }
    }

    var body: some View {
        DashboardCard(id: .library, prominence: prominence, compact: true) {
            if gaps.isEmpty {
                DashboardEmptyMessage(text: "Library is complete.")
            } else {
                VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
                    ForEach(gaps, id: \.title) { gap in
                        DashboardCardTapButton {
                            appState.selectSection(.gardenTrees)
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
}
