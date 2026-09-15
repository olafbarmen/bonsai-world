//
//  RepottingDashboardCard.swift
//  Bonsai World
//
//  Dashboard Repotting — overdue vs due-through-this-month counts from Tasks.
//  Same Work Type heuristic as Needs Repotting. Tap opens that Tasks horizon.
//

import SwiftUI

struct RepottingDashboardCard: View {
    var prominence: DashboardCardProminence = .secondary
    var fillsRowHeight: Bool = false

    @Environment(TaskService.self) private var taskService
    @Environment(AppState.self) private var appState

    private var overdueCount: Int {
        repotCount(due: .overdue)
    }

    /// Today + This Week + This Month — same non-overdue window as Needs Repotting.
    private var dueThroughThisMonthCount: Int {
        repotCount(due: .today) + repotCount(due: .thisWeek) + repotCount(due: .thisMonth)
    }

    private var hasRows: Bool {
        overdueCount > 0 || dueThroughThisMonthCount > 0
    }

    var body: some View {
        DashboardCard(id: .repotting, prominence: prominence, fillsRowHeight: fillsRowHeight, compact: true) {
            if !hasRows {
                DashboardCardTapButton {
                    appState.selectSection(.tasksThisMonth)
                } label: {
                    DashboardEmptyMessage(text: "No repotting due")
                }
            } else {
                VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
                    if overdueCount > 0 {
                        DashboardCardTapButton {
                            appState.selectSection(.tasksOverdue)
                        } label: {
                            DashboardMetricRow(
                                title: TasksHorizon.overdue.title,
                                value: "\(overdueCount)",
                                systemImage: "exclamationmark.circle",
                                isEmphasized: true,
                                compact: true
                            )
                            .foregroundStyle(BonsaiWorldColors.statusAttention)
                        }
                    }

                    if dueThroughThisMonthCount > 0 {
                        DashboardCardTapButton {
                            appState.selectSection(.tasksThisMonth)
                        } label: {
                            DashboardMetricRow(
                                title: TasksHorizon.thisMonth.title,
                                value: "\(dueThroughThisMonthCount)",
                                systemImage: "arrow.triangle.2.circlepath",
                                compact: true
                            )
                        }
                    }
                }
            }
        }
    }

    private func repotCount(due horizon: TasksHorizon) -> Int {
        taskService.pendingOccurrences(due: horizon).filter { occurrence in
            let name = taskService.workType(id: occurrence.workTypeID)?.name ?? ""
            return name.localizedCaseInsensitiveContains("repot")
        }.count
    }
}
