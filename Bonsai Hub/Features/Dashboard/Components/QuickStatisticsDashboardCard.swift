//
//  QuickStatisticsDashboardCard.swift
//  Bonsai World
//
//  Dashboard Quick Statistics — same live counts and destinations as the Stat Strip.
//

import SwiftUI

struct QuickStatisticsDashboardCard: View {
    var prominence: DashboardCardProminence = .secondary
    var fillsRowHeight: Bool = false

    @Environment(TreeService.self) private var treeService
    @Environment(ReferenceDataService.self) private var referenceData
    @Environment(TaskService.self) private var taskService
    @Environment(AppState.self) private var appState

    private var metrics: [DashboardCollectionSummary.Metric] {
        DashboardCollectionSummary.heroMetrics(
            trees: treeService.trees,
            treeStages: referenceData.treeStages,
            acquisitionMethods: referenceData.acquisitionMethods,
            disposalMethods: referenceData.disposalMethods
        )
    }

    private var tasksTodayCount: Int {
        taskService.pendingOccurrences(due: .today).count
    }

    private var developmentTreesCount: Int {
        let stageIDs = DashboardCollectionSummary.developmentStageIDs(in: referenceData.treeStages)
        return DashboardCollectionSummary.gardenTreesInCare(from: treeService.trees)
            .filter { DashboardCollectionSummary.isDevelopmentTree($0, developmentStageIDs: stageIDs) }
            .count
    }

    private var rows: [(title: String, value: String, image: String, action: () -> Void)] {
        [
            (
                "My Trees",
                value(for: "inCare"),
                "leaf",
                { appState.selectSection(.gardenTrees) }
            ),
            (
                "Development Trees",
                developmentTreesCount.formatted(.number),
                "leaf.arrow.circlepath",
                { appState.openGardenTrees(filter: .developmentStage) }
            ),
            (
                "Yamadori",
                value(for: "yamadori"),
                "mountain.2",
                { appState.selectSection(.nurseryYamadori) }
            ),
            (
                "Tasks Today",
                "\(tasksTodayCount)",
                "checklist",
                { appState.selectSection(.tasksToday) }
            )
        ]
    }

    var body: some View {
        DashboardCard(id: .quickStatistics, prominence: prominence, fillsRowHeight: fillsRowHeight, compact: true) {
            VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
                ForEach(Array(rows.enumerated()), id: \.offset) { _, row in
                    DashboardCardTapButton(action: row.action) {
                        DashboardMetricRow(
                            title: row.title,
                            value: row.value,
                            systemImage: row.image,
                            compact: true
                        )
                    }
                }
            }
        }
    }

    private func value(for id: String) -> String {
        let count = metrics.first(where: { $0.id == id })?.count ?? 0
        return count.formatted(.number)
    }
}
