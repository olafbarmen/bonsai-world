//
//  AlertsDashboardCard.swift
//  Bonsai World
//
//  Dashboard Alerts — overdue Tasks, Care seasonal gaps (Winter / Spring /
//  Greenhouse / Placement), and weather risks. Same WeatherService snapshot
//  as the Weather card.
//

import SwiftUI

struct AlertsDashboardCard: View {
    var prominence: DashboardCardProminence = .primary
    var fillsRowHeight: Bool = false

    @Environment(WeatherService.self) private var weatherService
    @Environment(TaskService.self) private var taskService
    @Environment(TreeService.self) private var treeService
    @Environment(WorkService.self) private var workService
    @Environment(AppState.self) private var appState
    @Environment(UserProfileStore.self) private var profile
    @Environment(ReferenceDataService.self) private var referenceData
    @Environment(WinterCareService.self) private var winterCare
    @Environment(SpringCareService.self) private var springCare
    @Environment(GreenhouseCareService.self) private var greenhouseCare
    @Environment(GrowingIntelligenceService.self) private var growingIntelligence
    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        // Snapshot once per body — overdue/pendingOccurrences is expensive if repeated.
        let snapshot = weatherService.snapshot
        let overdueCount = taskService.pendingOccurrences(due: .overdue).count
        let weatherRisks = snapshot.map { WeatherRiskAssessment.todaysRisks(for: $0) } ?? []
        let healthAttentionCount = treeService.trees.filter {
            $0.isInCare
                && ($0.healthStatus == .needsAttention || $0.healthStatus == .recovering)
        }.count
        let overdueRepottingCount = taskService.pendingOccurrences(due: .overdue).filter {
            workService.isRepotting(workTypeID: $0.workTypeID)
        }.count
        let winterCareCount = winterCare.treesNeedingWinterCare(snapshot: snapshot).count
        let springCareCount = springCare.treesNeedingSpringCare().count
        let greenhouseCount = greenhouseCare.locationsNeedingCheck().count
        let winterActive = winterCare.isWinterCareActive(snapshot: snapshot)
        let springActive = springCare.isSpringCareActive()
        let placementGapCount = growingIntelligence.placementAdvice(
            winterCareActive: winterActive,
            springCareActive: springActive
        ).items.count
        let hasAlerts = overdueCount > 0
            || healthAttentionCount > 0
            || overdueRepottingCount > 0
            || winterCareCount > 0
            || springCareCount > 0
            || greenhouseCount > 0
            || placementGapCount > 0
            || !weatherRisks.isEmpty

        DashboardCard(id: .alerts, prominence: prominence, fillsRowHeight: fillsRowHeight, compact: true) {
            if !hasAlerts {
                DashboardEmptyMessage(text: "No active alerts")
            } else {
                VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
                    if overdueCount > 0 {
                        careMetricRow(
                            title: "Overdue",
                            value: "\(overdueCount)",
                            systemImage: "exclamationmark.circle",
                            emphasized: true
                        ) {
                            appState.selectSection(.tasksOverdue)
                        }
                    }

                    if healthAttentionCount > 0 {
                        careMetricRow(
                            title: "Health",
                            value: "\(healthAttentionCount)",
                            systemImage: TreeHealthStatus.needsAttention.systemImage,
                            emphasized: true
                        ) {
                            appState.selectSection(.careTreeHealth)
                        }
                    }

                    if overdueRepottingCount > 0 {
                        careMetricRow(
                            title: "Repotting overdue",
                            value: "\(overdueRepottingCount)",
                            systemImage: "arrow.triangle.2.circlepath",
                            emphasized: true
                        ) {
                            appState.selectSection(.careRepotting)
                        }
                    }

                    if winterCareCount > 0 {
                        careMetricRow(
                            title: "Winter Care",
                            value: "\(winterCareCount)",
                            systemImage: "snowflake"
                        ) {
                            appState.selectSection(.careWinter)
                        }
                    }

                    if springCareCount > 0 {
                        careMetricRow(
                            title: "Spring Care",
                            value: "\(springCareCount)",
                            systemImage: "leaf"
                        ) {
                            appState.selectSection(.careSpring)
                        }
                    }

                    if greenhouseCount > 0 {
                        careMetricRow(
                            title: "Greenhouse check",
                            value: "\(greenhouseCount)",
                            systemImage: "thermometer.sun"
                        ) {
                            appState.selectSection(.careSpring)
                        }
                    }

                    if placementGapCount > 0 {
                        careMetricRow(
                            title: "Placement gaps",
                            value: "\(placementGapCount)",
                            systemImage: "mappin.and.ellipse"
                        ) {
                            appState.selectSection(.carePlacement)
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

    @ViewBuilder
    private func careMetricRow(
        title: String,
        value: String,
        systemImage: String,
        emphasized: Bool = false,
        action: @escaping () -> Void
    ) -> some View {
        DashboardCardTapButton(action: action) {
            DashboardMetricRow(
                title: title,
                value: value,
                systemImage: systemImage,
                isEmphasized: emphasized,
                compact: true
            )
            .foregroundStyle(emphasized ? BonsaiWorldColors.statusAttention : .primary)
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
