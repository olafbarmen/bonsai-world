//
//  TreesAttentionDashboardCard.swift
//  Bonsai World
//
//  Dashboard Trees Requiring Attention — live Tree health (Needs Attention /
//  Recovering). Read-only; tap opens Tree Detail.
//

import SwiftUI

struct TreesAttentionDashboardCard: View {
    var prominence: DashboardCardProminence = .secondary

    @Environment(TreeService.self) private var treeService
    @Environment(AppState.self) private var appState

    private let rowLimit = 8

    private var watchedTrees: [Tree] {
        treeService.treesInCare
            .filter { $0.healthStatus == .needsAttention || $0.healthStatus == .recovering }
            .sorted { $0.bonsaiName.localizedStandardCompare($1.bonsaiName) == .orderedAscending }
    }

    var body: some View {
        DashboardCard(id: .treesRequiringAttention, prominence: prominence, compact: true) {
            if watchedTrees.isEmpty {
                DashboardEmptyMessage(text: "No trees need attention.")
            } else {
                VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
                    ForEach(watchedTrees.prefix(rowLimit)) { tree in
                        DashboardCardTapButton {
                            appState.showTreeFromMap(treeID: tree.id)
                        } label: {
                            HStack(alignment: .center, spacing: FaloSpacing.small) {
                                TreeListThumbnail(imageID: tree.listImageID)
                                DashboardMetricRow(
                                    title: tree.bonsaiName,
                                    detail: tree.healthStatus.title,
                                    compact: true
                                )
                            }
                        }
                    }

                    let extra = watchedTrees.count - rowLimit
                    if extra > 0 {
                        Text("\(extra) more in Garden")
                            .font(FaloTypography.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
    }
}
