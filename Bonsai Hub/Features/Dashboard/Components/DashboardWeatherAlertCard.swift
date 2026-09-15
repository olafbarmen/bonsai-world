//
//  DashboardWeatherAlertCard.swift
//  Bonsai World
//
//  Compact live weather risk. Empty when conditions are calm — no invented alerts.
//

import SwiftUI

struct DashboardWeatherAlertCard: View {
    @Environment(WeatherService.self) private var weatherService
    @Environment(\.scenePhase) private var scenePhase

    private var risks: [String] {
        guard let snapshot = weatherService.snapshot else { return [] }
        return WeatherRiskAssessment.todaysRisks(for: snapshot)
    }

    var body: some View {
        DashboardCard(id: .alerts, prominence: .secondary, compact: true, titleOverride: "Weather") {
            if let first = risks.first {
                VStack(alignment: .leading, spacing: FaloSpacing.small) {
                    HStack(alignment: .firstTextBaseline, spacing: FaloSpacing.small) {
                        Image(systemName: "wind")
                            .font(.system(size: FaloIconSize.row, weight: .medium))
                            .symbolRenderingMode(.hierarchical)
                            .foregroundStyle(BonsaiWorldColors.statusAttention)
                            .frame(width: 22, alignment: .center)
                            .accessibilityHidden(true)
                        Text(first)
                            .font(FaloTypography.body)
                            .foregroundStyle(BonsaiWorldColors.textPrimary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    if risks.count > 1 {
                        Text("\(risks.count - 1) more in Alerts")
                            .font(FaloTypography.caption)
                            .foregroundStyle(BonsaiWorldColors.textSecondary)
                    }
                }
            } else {
                DashboardEmptyMessage(text: "No weather alerts.")
            }
        }
        .task {
            await weatherService.refreshIfNeeded()
        }
        .onChange(of: scenePhase) { _, newPhase in
            guard newPhase == .active else { return }
            Task { await weatherService.refreshIfNeeded() }
        }
    }
}
