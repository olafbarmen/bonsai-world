//
//  WeatherRiskAssessment.swift
//  Bonsai World
//
//  Bonsai-specific interpretation of raw Weather data (Growing Intelligence —
//  Weather Engine, first pass). Pure functions over WeatherSnapshot; no UI,
//  no networking. Thresholds are an initial, documented assumption — tune
//  freely as real usage shows what actually matters for the grower.
//

import Foundation

enum WeatherRiskLevel: String, Hashable, Sendable {
    case normal
    case watch
    case caution
    case critical
}

enum WeatherRiskAssessment {
    struct ComparisonRow: Identifiable, Hashable, Sendable {
        let id: String
        let label: String
        let todayValue: String
        /// Low temperature, shown next to `todayValue` (High) for the Temp row only.
        let todaySecondaryValue: String?
        let tomorrowValue: String
        let tomorrowSecondaryValue: String?
        let todayLevel: WeatherRiskLevel
        let tomorrowLevel: WeatherRiskLevel

        init(
            id: String,
            label: String,
            todayValue: String,
            todaySecondaryValue: String? = nil,
            tomorrowValue: String,
            tomorrowSecondaryValue: String? = nil,
            todayLevel: WeatherRiskLevel,
            tomorrowLevel: WeatherRiskLevel
        ) {
            self.id = id
            self.label = label
            self.todayValue = todayValue
            self.todaySecondaryValue = todaySecondaryValue
            self.tomorrowValue = tomorrowValue
            self.tomorrowSecondaryValue = tomorrowSecondaryValue
            self.todayLevel = todayLevel
            self.tomorrowLevel = tomorrowLevel
        }
    }

    /// Today vs Tomorrow rows: Temp, Rain, Wind, Humidity, UV.
    static func comparisonRows(
        for snapshot: WeatherSnapshot,
        temperatureUnit: TemperatureUnit,
        measurementSystem: MeasurementSystem
    ) -> [ComparisonRow] {
        guard let today = snapshot.today else { return [] }
        let tomorrow = snapshot.tomorrow

        return [
            ComparisonRow(
                id: "temp",
                label: "Temp H/L",
                todayValue: temperatureUnit.formatted(celsius: today.maxTemperatureCelsius),
                todaySecondaryValue: temperatureUnit.formatted(celsius: today.minTemperatureCelsius),
                tomorrowValue: tomorrow.map { temperatureUnit.formatted(celsius: $0.maxTemperatureCelsius) } ?? "—",
                tomorrowSecondaryValue: tomorrow.map { temperatureUnit.formatted(celsius: $0.minTemperatureCelsius) },
                todayLevel: temperatureRisk(for: today),
                tomorrowLevel: tomorrow.map(temperatureRisk(for:)) ?? .normal
            ),
            ComparisonRow(
                id: "rain",
                label: "Rain",
                todayValue: today.precipitationProbabilityPercent.map { "\($0)%" } ?? "—",
                tomorrowValue: tomorrow?.precipitationProbabilityPercent.map { "\($0)%" } ?? "—",
                todayLevel: rainRisk(for: today),
                tomorrowLevel: tomorrow.map(rainRisk(for:)) ?? .normal
            ),
            ComparisonRow(
                id: "wind",
                label: "Wind",
                todayValue: today.windSpeedMaxKph.map { measurementSystem.formattedWindSpeed(kph: $0) } ?? "—",
                tomorrowValue: tomorrow?.windSpeedMaxKph.map { measurementSystem.formattedWindSpeed(kph: $0) } ?? "—",
                todayLevel: windRisk(for: today),
                tomorrowLevel: tomorrow.map(windRisk(for:)) ?? .normal
            ),
            ComparisonRow(
                id: "humidity",
                label: "Humidity",
                todayValue: today.middayRelativeHumidityPercent.map { "\($0)%" } ?? "—",
                tomorrowValue: tomorrow?.middayRelativeHumidityPercent.map { "\($0)%" } ?? "—",
                todayLevel: .normal,
                tomorrowLevel: .normal
            ),
            ComparisonRow(
                id: "uv",
                label: "UV",
                todayValue: today.uvIndexMax.map(uvLabel) ?? "—",
                tomorrowValue: tomorrow?.uvIndexMax.map(uvLabel) ?? "—",
                todayLevel: today.uvIndexMax.map(uvRisk) ?? .normal,
                tomorrowLevel: tomorrow?.uvIndexMax.map(uvRisk) ?? .normal
            )
        ]
    }

    /// Bonsai-facing risk bullets for today. Empty → card shows a calm "no risk" message.
    static func todaysRisks(for snapshot: WeatherSnapshot) -> [String] {
        guard let today = snapshot.today else { return [] }
        var risks: [String] = []

        if today.maxTemperatureCelsius >= 30 {
            risks.append("High heat expected — protect exposed benches and check watering more than once today.")
        }
        if today.minTemperatureCelsius <= 0 {
            risks.append("Frost risk overnight — move tender trees under cover.")
        }
        if let rain = today.precipitationProbabilityPercent, rain >= 60 {
            risks.append("Heavy rain likely — may wash fertilizer away.")
        }
        if let wind = today.windSpeedMaxKph, wind >= 35 {
            risks.append("Strong wind expected — check wiring and secure lightweight pots.")
        }
        if let uv = today.uvIndexMax, uv >= 8 {
            risks.append("Very high UV — afternoon sun may require additional watering or shade.")
        }
        return risks
    }

    static let noRisksMessage = "No significant Bonsai weather risks today."

    /// Location-specific risk bullets combining a Location's `LocationEnvironmentProfile`
    /// with today's/tomorrow's forecast. Complements ``todaysRisks(for:)``, which only
    /// looks at the Garden-wide forecast — this adds context from how exposed/protected
    /// the specific Location actually is.
    ///
    /// Limitation: `WeatherService` fetches weather for `profile.defaultGarden` only, so
    /// these warnings are only meaningful for Locations belonging to the default Garden
    /// until multi-Garden weather support lands (tracked separately from multi-Garden UI).
    static func locationRisks(
        environment: LocationEnvironmentProfile,
        snapshot: WeatherSnapshot
    ) -> [String] {
        guard let today = snapshot.today else { return [] }
        let tomorrow = snapshot.tomorrow
        var risks: [String] = []

        if environment.windExposure == .exposed {
            let highWind = (today.windSpeedMaxKph ?? 0) >= 35 || (tomorrow?.windSpeedMaxKph ?? 0) >= 35
            if highWind {
                risks.append("This Location is wind-exposed and strong wind is forecast — shelter or secure lightweight pots.")
            }
        }

        if environment.winterProtection == .outdoorWinter {
            let frostExpected = today.minTemperatureCelsius <= 0 || (tomorrow?.minTemperatureCelsius ?? 99) <= 0
            if frostExpected {
                risks.append("This Location has no winter protection and frost is forecast — cover or move tender trees.")
            }
        }

        if environment.rainExposure == .fullyExposed {
            let heavyRain = (today.precipitationProbabilityPercent ?? 0) >= 60
                || (tomorrow?.precipitationProbabilityPercent ?? 0) >= 60
            if heavyRain {
                risks.append("This Location is fully rain-exposed and heavy rain is likely — reapply fertilizer if it washes off.")
            }
        }

        if environment.shadeLevel == .fullSun {
            let highHeatOrUV = today.maxTemperatureCelsius >= 30 || (today.uvIndexMax ?? 0) >= 8
            if highHeatOrUV {
                risks.append("This Location is full sun and high heat/UV is expected — check watering more than once today.")
            }
        }

        return risks
    }

    /// A single actionable line for the card's Next Action row.
    static func nextAction(for snapshot: WeatherSnapshot) -> String {
        let risks = todaysRisks(for: snapshot)
        guard let first = risks.first else {
            return "No action needed — conditions look calm today."
        }
        return first
    }

    // MARK: - Per-parameter risk

    private static func temperatureRisk(for day: DailyWeatherForecast) -> WeatherRiskLevel {
        if day.maxTemperatureCelsius >= 35 || day.minTemperatureCelsius <= -10 { return .critical }
        if day.maxTemperatureCelsius >= 30 || day.minTemperatureCelsius <= -5 { return .caution }
        if day.maxTemperatureCelsius >= 27 || day.minTemperatureCelsius <= 0 { return .watch }
        return .normal
    }

    private static func rainRisk(for day: DailyWeatherForecast) -> WeatherRiskLevel {
        guard let probability = day.precipitationProbabilityPercent else { return .normal }
        if probability >= 80 { return .critical }
        if probability >= 60 { return .caution }
        if probability >= 35 { return .watch }
        return .normal
    }

    private static func windRisk(for day: DailyWeatherForecast) -> WeatherRiskLevel {
        guard let wind = day.windSpeedMaxKph else { return .normal }
        if wind >= 50 { return .critical }
        if wind >= 35 { return .caution }
        if wind >= 20 { return .watch }
        return .normal
    }

    private static func uvRisk(_ index: Double) -> WeatherRiskLevel {
        if index >= 11 { return .critical }
        if index >= 8 { return .caution }
        if index >= 6 { return .watch }
        return .normal
    }

    private static func uvLabel(_ index: Double) -> String {
        switch index {
        case ..<3: "Low"
        case 3..<6: "Moderate"
        case 6..<8: "High"
        case 8..<11: "Very High"
        default: "Extreme"
        }
    }
}

extension TemperatureUnit {
    func formatted(celsius: Double) -> String {
        switch self {
        case .celsius:
            "\(Int(celsius.rounded()))°"
        case .fahrenheit:
            "\(Int((celsius * 9 / 5 + 32).rounded()))°"
        }
    }
}

extension MeasurementSystem {
    func formattedWindSpeed(kph: Double) -> String {
        switch self {
        case .metric:
            "\(Int((kph / 3.6).rounded())) m/s"
        case .imperial:
            "\(Int((kph * 0.621371).rounded())) mph"
        }
    }
}
