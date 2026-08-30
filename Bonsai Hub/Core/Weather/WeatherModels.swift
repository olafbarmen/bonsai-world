//
//  WeatherModels.swift
//  Bonsai World
//
//  Weather domain model — provider-agnostic (Blueprint "Weather (future)").
//  Providers (Open-Meteo today, others later) map their own payloads into these
//  types; the Dashboard and future Growing Intelligence engines only ever see
//  this shape. No networking, no SwiftUI, no platform import — safe to reuse
//  unchanged on Windows and iPhone.
//

import Foundation

/// Sky condition, independent of any provider's numeric weather code.
enum WeatherSkyCondition: String, Codable, Sendable {
    case clearSky
    case mainlyClear
    case partlyCloudy
    case overcast
    case fog
    case drizzle
    case freezingDrizzle
    case rain
    case freezingRain
    case rainShowers
    case snow
    case snowShowers
    case thunderstorm

    /// SF Symbol name. Rendering only — the enum itself stays platform-neutral.
    var systemImageName: String {
        switch self {
        case .clearSky: "sun.max"
        case .mainlyClear: "sun.max"
        case .partlyCloudy: "cloud.sun"
        case .overcast: "cloud"
        case .fog: "cloud.fog"
        case .drizzle, .freezingDrizzle: "cloud.drizzle"
        case .rain: "cloud.rain"
        case .freezingRain: "cloud.sleet"
        case .rainShowers: "cloud.sun.rain"
        case .snow: "cloud.snow"
        case .snowShowers: "cloud.snow.fill"
        case .thunderstorm: "cloud.bolt"
        }
    }
}

/// One day's forecast — used for Today/Tomorrow comparison and the 7-day strip.
struct DailyWeatherForecast: Identifiable, Hashable, Sendable {
    var id: Date { date }
    var date: Date
    var condition: WeatherSkyCondition
    var minTemperatureCelsius: Double
    var maxTemperatureCelsius: Double
    /// 0–100. `nil` when the provider did not return a probability for this day.
    var precipitationProbabilityPercent: Int?
    var windSpeedMaxKph: Double?
    /// Midday relative humidity — closest same-shape value to a daily "humidity" figure.
    var middayRelativeHumidityPercent: Int?
    /// WHO/EPA UV Index scale (0 = none, 11+ = extreme).
    var uvIndexMax: Double?
}

/// Live conditions at the moment of the fetch.
struct CurrentWeatherObservation: Hashable, Sendable {
    var observedAt: Date
    var temperatureCelsius: Double
    var apparentTemperatureCelsius: Double?
    var condition: WeatherSkyCondition
    var relativeHumidityPercent: Int?
    var windSpeedKph: Double?
}

/// Everything the Weather card (and future Growing Intelligence engines) need for one Garden.
struct WeatherSnapshot: Hashable, Sendable {
    var fetchedAt: Date
    var latitude: Double
    var longitude: Double
    var current: CurrentWeatherObservation
    /// Index 0 == today, 1 == tomorrow, … Ordered by the provider.
    var dailyForecasts: [DailyWeatherForecast]

    var today: DailyWeatherForecast? { dailyForecasts.first }
    var tomorrow: DailyWeatherForecast? { dailyForecasts.count > 1 ? dailyForecasts[1] : nil }
    /// Next 7 days including today, for the week strip.
    var week: [DailyWeatherForecast] { Array(dailyForecasts.prefix(7)) }
}
