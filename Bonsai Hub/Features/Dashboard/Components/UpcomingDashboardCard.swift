//
//  UpcomingDashboardCard.swift
//  Bonsai World
//
//  Dashboard Upcoming Tasks — live horizon counts from TaskService (not Today).
//  Each row is Tasks, like Tasks Today. Tap opens that Tasks horizon.
//

import SwiftUI

struct UpcomingDashboardCard: View {
    var prominence: DashboardCardProminence = .primary
    var fillsRowHeight: Bool = false

    @Environment(TaskService.self) private var taskService
    @Environment(AppState.self) private var appState

    private var buckets: [(horizon: TasksHorizon, route: AppRoute)] {
        [
            (.thisWeek, .tasksThisWeek),
            (.thisMonth, .tasksThisMonth),
            (.thisYear, .tasksThisYear),
            (.nextYear, .tasksNextYear)
        ]
    }

    var body: some View {
        DashboardCard(id: .upcoming, prominence: prominence, fillsRowHeight: fillsRowHeight, compact: true) {
            VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
                ForEach(buckets, id: \.horizon) { bucket in
                    let count = taskService.pendingOccurrences(due: bucket.horizon).count
                    DashboardCardTapButton {
                        appState.selectSection(bucket.route)
                    } label: {
                        DashboardMetricRow(
                            title: "Tasks · \(bucket.horizon.title)",
                            value: "\(count)",
                            compact: true
                        )
                    }
                }
            }
        }
    }
}
