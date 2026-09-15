//
//  TasksDashboardCard.swift
//  Bonsai World
//
//  Dashboard Tasks card — live today summary from TaskService, grouped by Work Type.
//  Same source and date semantics as Tasks Today / Tasks workspace. Read-only entry.
//

import SwiftUI

struct TasksDashboardCard: View {
    var prominence: DashboardCardProminence = .primary
    var fillsRowHeight: Bool = false

    @Environment(TaskService.self) private var taskService
    @Environment(AppState.self) private var appState

    private var summaries: [TaskWorkTypeSummary] {
        taskService.workTypeSummaries(due: .today)
    }

    var body: some View {
        DashboardCard(id: .tasks, prominence: prominence, fillsRowHeight: fillsRowHeight, compact: true) {
            if summaries.isEmpty {
                DashboardCardTapButton {
                    openTasksToday()
                } label: {
                    DashboardEmptyMessage(text: "No tasks today")
                }
            } else {
                VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
                    ForEach(summaries) { summary in
                        DashboardCardTapButton {
                            openTasksToday()
                        } label: {
                            DashboardMetricRow(
                                title: "\(summary.name) · \(summary.count)",
                                systemImage: symbolName(for: summary.workTypeID),
                                compact: true
                            )
                        }
                    }
                }
            }
        }
    }

    private func openTasksToday() {
        appState.selectSection(.tasksToday)
    }

    /// Preserve existing Watering visual cue; other types stay text-led.
    private func symbolName(for workTypeID: UUID) -> String? {
        taskService.expiresIfMissed(workTypeID: workTypeID) ? "drop" : nil
    }
}
