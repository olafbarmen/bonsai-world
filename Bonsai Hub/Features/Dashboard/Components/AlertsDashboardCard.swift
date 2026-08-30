//
//  AlertsDashboardCard.swift
//  Bonsai World
//
//  Dashboard Alerts — live weather risks + overdue Tasks. Read-only; tap deep-links.
//

import SwiftUI

struct AlertsDashboardCard: View {
    var prominence: DashboardCardProminence = .primary

    @Environment(WeatherService.self) private var weatherService
    @Environment(TaskService.self) private var taskService
    @Environment(AppState.self) private var appState

    private var overdueCount: Int {
        taskService.pendingOccurrences(due: .overdue).count
    }

    private var weatherRisks: [String] {
        guard let snapshot = weatherService.snapshot else { return [] }
        return WeatherRiskAssessment.todaysRisks(for: snapshot)
    }

    private var hasAlerts: Bool {
        overdueCount > 0 || !weatherRisks.isEmpty
    }

    var body: some View {
        DashboardCard(id: .alerts, prominence: prominence, compact: true) {
            if !hasAlerts {
                DashboardEmptyMessage(text: "No alerts.")
            } else {
                VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
                    if overdueCount > 0 {
                        DashboardCardTapButton {
                            appState.selectSection(.tasksOverdue)
                        } label: {
                            DashboardMetricRow(
                                title: "Overdue",
                                value: "\(overdueCount)",
                                systemImage: "exclamationmark.circle",
                                isEmphasized: true,
                                compact: true
                            )
                            .foregroundStyle(.orange)
                        }
                    }

                    ForEach(weatherRisks, id: \.self) { risk in
                        DashboardCardTapButton {
                            appState.selectSection(.locationsMap)
                        } label: {
                            DashboardMetricRow(
                                title: risk,
                                systemImage: "exclamationmark.triangle",
                                compact: true
                            )
                        }
                    }
                }
            }
        }
    }
}
