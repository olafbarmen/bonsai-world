//
//  WinterEngine.swift
//  Bonsai World
//
//  Growing Intelligence — Winter Engine v1.
//  Advisory lines from Location winterProtection + weather only.
//  Indoor / greenhouse / setting are never assumed frost free — only the
//  grower's Winter protection field on the Location.
//

import Foundation

struct WinterEngine: GrowingIntelligenceEngine, Sendable {
    let engineID = "growingIntelligence.winter"

    /// Forecast night low at or below this (°C) counts as frost / near-frost risk.
    static let frostRiskCelsius: Double = 2

    /// Info-only advice for one Location’s winter protection and the forecast.
    func advice(
        environment: LocationEnvironmentProfile,
        snapshot: WeatherSnapshot?
    ) -> WinterAdvice {
        guard let snapshot, let today = snapshot.today else { return .empty }
        guard isFrostRisk(today: today, tomorrow: snapshot.tomorrow) else {
            return .empty
        }

        let line: String
        switch environment.winterProtection {
        case .frostFree:
            line = "Cold is forecast (near or below freezing). This Location is marked frost free — that holds only if this spot stays above 0 °C. Indoor rooms and greenhouses are not frost free unless you keep them that way."
        case .frostPossible:
            line = "Frost or near-freezing is forecast. This Location allows frost — check that your protection still holds overnight."
        case .outdoorWinter:
            line = "Frost or near-freezing is forecast and this Location is outdoor winter — move tender trees under reliable cover."
        case .none:
            line = "Frost or near-freezing is forecast. Set Winter protection on this Location so advice matches how you actually protect it — indoor and greenhouse are not assumed frost free."
        }

        return WinterAdvice(lines: [line])
    }

    /// True when tonight or tomorrow night may reach the frost-risk threshold.
    func isFrostRisk(
        today: DailyWeatherForecast,
        tomorrow: DailyWeatherForecast?
    ) -> Bool {
        if today.minTemperatureCelsius <= Self.frostRiskCelsius { return true }
        if let tomorrow, tomorrow.minTemperatureCelsius <= Self.frostRiskCelsius {
            return true
        }
        return false
    }
}
