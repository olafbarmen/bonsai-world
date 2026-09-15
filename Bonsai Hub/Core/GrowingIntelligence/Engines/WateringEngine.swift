//
//  WateringEngine.swift
//  Bonsai World
//
//  Growing Intelligence — Watering Engine v1.
//  Advisory lines from Location Environment + weather only.
//  Remind-mode trees consume this in Care → Watering. No schedules, no species numbers.
//

import Foundation

struct WateringEngine: GrowingIntelligenceEngine, Sendable {
    let engineID = "growingIntelligence.watering"

    /// Info-only advice for one Location’s environment and today’s forecast.
    func advice(
        environment: LocationEnvironmentProfile,
        snapshot: WeatherSnapshot?,
        heatWatchEnabled: Bool
    ) -> WateringAdvice {
        guard let snapshot else { return .empty }

        var lines = WeatherRiskAssessment.locationRisks(
            environment: environment,
            snapshot: snapshot
        )

        if let line = dryingExposureLine(environment: environment, snapshot: snapshot),
           !lines.contains(line) {
            lines.append(line)
        }

        if let line = rainProtectedHeatLine(environment: environment, snapshot: snapshot),
           !lines.contains(line) {
            lines.append(line)
        }

        let heatWatchActive = heatWatchEnabled
            && WeatherRiskAssessment.isHeatWatchCondition(snapshot: snapshot)

        return WateringAdvice(lines: lines, heatWatchActive: heatWatchActive)
    }

    // MARK: - Extra advisory (Location Environment + weather)

    /// Wind-exposed or low humidity with heat/UV/full sun — substrate can dry faster.
    private func dryingExposureLine(
        environment: LocationEnvironmentProfile,
        snapshot: WeatherSnapshot
    ) -> String? {
        guard let today = snapshot.today else { return nil }
        let hotOrUV = today.maxTemperatureCelsius >= 27 || (today.uvIndexMax ?? 0) >= 6
        guard hotOrUV else { return nil }

        let windy = environment.windExposure == .exposed
        let dryAir = environment.humidity == .low
        let fullSun = environment.shadeLevel == .fullSun
        guard windy || dryAir || fullSun else { return nil }

        if windy && dryAir {
            return "This Location is wind-exposed with low humidity — substrate can dry faster; check watering sooner."
        }
        if windy {
            return "This Location is wind-exposed — substrate can dry faster; check watering sooner."
        }
        if dryAir {
            return "This Location has low humidity — substrate can dry faster; check watering sooner."
        }
        return "This Location is full sun — substrate can dry faster; check watering sooner."
    }

    /// Rain will not help rain-protected benches on a hot day.
    private func rainProtectedHeatLine(
        environment: LocationEnvironmentProfile,
        snapshot: WeatherSnapshot
    ) -> String? {
        guard environment.rainExposure == .rainProtected else { return nil }
        guard let today = snapshot.today else { return nil }
        guard today.maxTemperatureCelsius >= 27 else { return nil }
        return "This Location is rain protected — forecast rain will not water trees here; check substrate as usual."
    }
}
