//
//  UpcomingDashboardCard.swift
//  Bonsai World
//
//  Dashboard Upcoming — live horizon counts from TaskService (not Today).
//  Today lives on the Tasks card. Read-only; tap opens that Tasks horizon.
//

import SwiftUI

struct UpcomingDashboardCard: View {
    var prominence: DashboardCardProminence = .primary

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
        DashboardCard(id: .upcoming, prominence: prominence, compact: true) {
            VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
                ForEach(buckets, id: \.horizon) { bucket in
                    let count = taskService.pendingOccurrences(due: bucket.horizon).count
                    DashboardCardTapButton {
                        appState.selectSection(bucket.route)
                    } label: {
                        DashboardMetricRow(
                            title: bucket.horizon.title,
                            value: "\(count)",
                            compact: true
                        )
                    }
                }
            }
        }
    }
}
