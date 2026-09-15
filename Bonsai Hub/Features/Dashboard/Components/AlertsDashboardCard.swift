//
//  AlertsDashboardCard.swift
//  Bonsai World
//
//  Dashboard Alerts — live weather risks (WeatherRiskAssessment) + overdue Tasks.
//  Same WeatherService snapshot as the Weather card. Overdue → Tasks Overdue;
//  weather risks → Locations map (default Garden).
//

import SwiftUI

struct AlertsDashboardCard: View {
    var prominence: DashboardCardProminence = .primary
    var fillsRowHeight: Bool = false

    @Environment(WeatherService.self) private var weatherService
    @Environment(TaskService.self) private var taskService
    @Environment(AppState.self) private var appState
    @Environment(UserProfileStore.self) private var profile
    @Environment(ReferenceDataService.self) private var referenceData
    @Environment(\.scenePhase) private var scenePhase

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
        DashboardCard(id: .alerts, prominence: prominence, fillsRowHeight: fillsRowHeight, compact: true) {
            if !hasAlerts {
                DashboardEmptyMessage(text: "No active alerts")
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
                            .foregroundStyle(BonsaiWorldColors.statusAttention)
                        }
                    }

                    ForEach(weatherRisks, id: \.self) { risk in
                        DashboardCardTapButton {
                            openWeatherRisks()
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
        .task {
            await weatherService.refreshIfNeeded()
        }
        .onChange(of: scenePhase) { _, newPhase in
            guard newPhase == .active else { return }
            Task { await weatherService.refreshIfNeeded() }
        }
    }

    /// Weather is keyed to the default Garden — open that Garden’s Locations map.
    private func openWeatherRisks() {
        let gardenID = profile.defaultGarden?.id
        let focusLocation = referenceData.locations
            .filter { location in
                guard location.gardenID == gardenID else { return false }
                return location.geographicPosition != nil
            }
            .sorted {
                $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending
            }
            .first

        if let focusLocation {
            appState.showLocationOnMap(locationID: focusLocation.id)
        } else {
            appState.selectSection(.locationsPlaces)
        }
    }
}
