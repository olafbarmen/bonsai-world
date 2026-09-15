//
//  DashboardStatStrip.swift
//  Bonsai World
//
//  Four live metrics from DashboardCollectionSummary + Tasks.
//

import SwiftUI

struct DashboardStatStrip: View {
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

    /// Same set as Garden → Trees with Development filter (excludes Yamadori nursery).
    private var developmentTreesCount: Int {
        let stageIDs = DashboardCollectionSummary.developmentStageIDs(in: referenceData.treeStages)
        return DashboardCollectionSummary.gardenTreesInCare(from: treeService.trees)
            .filter { DashboardCollectionSummary.isDevelopmentTree($0, developmentStageIDs: stageIDs) }
            .count
    }

    var body: some View {
        HStack(alignment: .top, spacing: DashboardSpacing.cardGap) {
            FaloStatCard(
                title: "My Trees",
                value: value(for: "inCare"),
                subtitle: "In care",
                systemImage: "leaf",
                action: { appState.selectSection(.gardenTrees) }
            )
            FaloStatCard(
                title: "Development Trees",
                value: developmentTreesCount.formatted(.number),
                subtitle: "Tree Stage",
                systemImage: "leaf.arrow.circlepath",
                action: { appState.openGardenTrees(filter: .developmentStage) }
            )
            FaloStatCard(
                title: "Yamadori",
                value: value(for: "yamadori"),
                subtitle: "In care",
                systemImage: "mountain.2",
                action: { appState.selectSection(.nurseryYamadori) }
            )
            FaloStatCard(
                title: "Tasks Today",
                value: "\(tasksTodayCount)",
                subtitle: "Due today",
                systemImage: "checklist",
                action: { appState.selectSection(.tasksToday) }
            )
        }
    }

    private func value(for id: String) -> String {
        let count = metrics.first(where: { $0.id == id })?.count ?? 0
        return count.formatted(.number)
    }
}
