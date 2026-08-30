//
//  TasksDashboardCard.swift
//  Bonsai World
//
//  Dashboard Tasks card — live overdue + today from TaskService.
//  Read-only orientation: lists and deep-links into Tasks. No Complete.
//

import SwiftUI

struct TasksDashboardCard: View {
    var prominence: DashboardCardProminence = .primary

    @Environment(TaskService.self) private var taskService
    @Environment(TreeService.self) private var treeService
    @Environment(AppState.self) private var appState

    private var overdueOccurrences: [TaskOccurrence] {
        taskService.pendingOccurrences(due: .overdue)
    }

    private var todayOccurrences: [TaskOccurrence] {
        taskService.pendingOccurrences(due: .today)
    }

    private var wateringToday: [TaskOccurrence] {
        todayOccurrences.filter { taskService.expiresIfMissed(workTypeID: $0.workTypeID) }
    }

    private var otherToday: [TaskOccurrence] {
        todayOccurrences.filter { !taskService.expiresIfMissed(workTypeID: $0.workTypeID) }
    }

    var body: some View {
        DashboardCard(id: .tasks, prominence: prominence, compact: true) {
            if overdueOccurrences.isEmpty, todayOccurrences.isEmpty {
                DashboardEmptyMessage(text: "Nothing due today.")
            } else {
                VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
                    if !overdueOccurrences.isEmpty {
                        DashboardCardTapButton {
                            appState.selectSection(.tasksOverdue)
                        } label: {
                            DashboardMetricRow(
                                title: "Overdue",
                                value: "\(overdueOccurrences.count)",
                                systemImage: "exclamationmark.circle",
                                isEmphasized: true,
                                compact: true
                            )
                            .foregroundStyle(.orange)
                        }
                    }

                    ForEach(otherToday) { occurrence in
                        DashboardCardTapButton {
                            appState.selectSection(.tasksToday)
                        } label: {
                            DashboardMetricRow(
                                title: occurrence.title,
                                detail: treeName(for: occurrence.treeID),
                                compact: true
                            )
                        }
                    }

                    if !wateringToday.isEmpty {
                        DashboardCardTapButton {
                            appState.selectSection(.tasksToday)
                        } label: {
                            DashboardMetricRow(
                                title: "Watering · \(wateringToday.count)",
                                systemImage: "drop",
                                compact: true
                            )
                        }
                    }

                    if !overdueOccurrences.isEmpty, todayOccurrences.isEmpty {
                        Text("Nothing due today.")
                            .font(FaloTypography.caption)
                            .foregroundStyle(.secondary)
                            .padding(.top, FaloSpacing.xSmall)
                    }
                }
            }
        }
    }

    private func treeName(for treeID: UUID) -> String {
        treeService.getTree(id: treeID)?.bonsaiName ?? "—"
    }
}
