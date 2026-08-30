//
//  OpenMeteoWeatherProvider.swift
//  Bonsai World
//
//  WeatherProviding implementation using Open-Meteo (open-meteo.com) —
//  free, no API key, plain HTTPS/JSON. Chosen over WeatherKit specifically
//  because it runs identically on macOS, Windows, and iPhone (URLSession
//  only — no Apple-only frameworks), matching the cross-platform mandate.
//
//  Maps Open-Meteo's WMO weather codes and response shape into the
//  provider-agnostic WeatherSnapshot — nothing Open-Meteo-specific ever
//  leaks past this file.
//

import Foundation

struct OpenMeteoWeatherProvider: WeatherProviding {
    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func fetchWeather(latitude: Double, longitude: Double) async throws -> WeatherSnapshot {
        let url = try makeURL(latitude: latitude, longitude: longitude)
        let (data, response) = try await session.data(from: url)

        if let http = response as? HTTPURLResponse, !(200...299).contains(http.statusCode) {
            throw WeatherFetchError(message: "Weather service returned status \(http.statusCode).")
        }

        let payload: OpenMeteoResponse
        do {
            payload = try JSONDecoder().decode(OpenMeteoResponse.self, from: data)
        } catch {
            throw WeatherFetchError(message: "Could not read the weather response.")
        }

        return try Self.makeSnapshot(from: payload, latitude: latitude, longitude: longitude)
    }

    private func makeURL(latitude: Double, longitude: Double) throws -> URL {
        var components = URLComponents(string: "https://api.open-meteo.com/v1/forecast")
        components?.queryItems = [
            URLQueryItem(name: "latitude", value: String(latitude)),
            URLQueryItem(name: "longitude", value: String(longitude)),
            URLQueryItem(name: "current", value: "temperature_2m,apparent_temperature,relative_humidity_2m,weather_code,wind_speed_10m"),
            URLQueryItem(name: "hourly", value: "relative_humidity_2m"),
            URLQueryItem(name: "daily", value: "weather_code,temperature_2m_max,temperature_2m_min,precipitation_probability_max,wind_speed_10m_max,uv_index_max"),
            URLQueryItem(name: "timezone", value: "auto"),
            URLQueryItem(name: "forecast_days", value: "7")
        ]
        guard let url = components?.url else {
            throw WeatherFetchError(message: "Could not build the weather request URL.")
        }
        return url
    }

    // MARK: - Mapping

    static func makeSnapshot(
        from payload: OpenMeteoResponse,
        latitude: Double,
        longitude: Double
    ) throws -> WeatherSnapshot {
        guard let current = payload.current else {
            throw WeatherFetchError(message: "Weather response was missing current conditions.")
        }
        guard let daily = payload.daily, !daily.time.isEmpty else {
            throw WeatherFetchError(message: "Weather response was missing the daily forecast.")
        }

        let dailyForecasts = (0..<daily.time.count).compactMap { index -> DailyWeatherForecast? in
            guard
                let date = Self.dayFormatter.date(from: daily.time[index]),
                let max = daily.temperature2mMax?[safe: index],
                let min = daily.temperature2mMin?[safe: index]
            else { return nil }

            return DailyWeatherForecast(
                date: date,
                condition: Self.condition(forCode: daily.weatherCode?[safe: index] ?? 0),
                minTemperatureCelsius: min,
                maxTemperatureCelsius: max,
                precipitationProbabilityPercent: (daily.precipitationProbabilityMax?[safe: index]).map { Int($0.rounded()) },
                windSpeedMaxKph: daily.windSpeed10mMax?[safe: index],
                middayRelativeHumidityPercent: Self.middayHumidity(for: daily.time[index], hourly: payload.hourly),
                uvIndexMax: daily.uvIndexMax?[safe: index]
            )
        }

        let observation = CurrentWeatherObservation(
            observedAt: Self.hourFormatter.date(from: current.time) ?? .now,
            temperatureCelsius: current.temperature2m,
            apparentTemperatureCelsius: current.apparentTemperature,
            condition: Self.condition(forCode: current.weatherCode ?? 0),
            relativeHumidityPercent: current.relativeHumidity2m.map { Int($0.rounded()) },
            windSpeedKph: current.windSpeed10m
        )

        return WeatherSnapshot(
            fetchedAt: .now,
            latitude: latitude,
            longitude: longitude,
            current: observation,
            dailyForecasts: dailyForecasts
        )
    }

    /// Relative humidity at local noon for the given calendar day, from the hourly series.
    private static func middayHumidity(for dayString: String, hourly: OpenMeteoHourly?) -> Int? {
        guard let hourly, let values = hourly.relativeHumidity2m else { return nil }
        let noonKey = "\(dayString)T12:00"
        guard let index = hourly.time.firstIndex(of: noonKey), let value = values[safe: index] else { return nil }
        return Int(value.rounded())
    }

    /// WMO weather interpretation codes (Open-Meteo docs).
    private static func condition(forCode code: Int) -> WeatherSkyCondition {
        switch code {
        case 0: .clearSky
        case 1: .mainlyClear
        case 2: .partlyCloudy
        case 3: .overcast
        case 45, 48: .fog
        case 51, 53, 55: .drizzle
        case 56, 57: .freezingDrizzle
        case 61, 63, 65: .rain
        case 66, 67: .freezingRain
        case 71, 73, 75, 77: .snow
        case 80, 81, 82: .rainShowers
        case 85, 86: .snowShowers
        case 95, 96, 99: .thunderstorm
        default: .partlyCloudy
        }
    }

    private static let dayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(identifier: "UTC")
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()

    private static let hourFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(identifier: "UTC")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm"
        return formatter
    }()
}

// MARK: - Open-Meteo response shape (private to this file's mapping)

struct OpenMeteoResponse: Decodable, Sendable {
    let current: OpenMeteoCurrent?
    let hourly: OpenMeteoHourly?
    let daily: OpenMeteoDaily?
}

struct OpenMeteoCurrent: Decodable, Sendable {
    let time: String
    let temperature2m: Double
    let apparentTemperature: Double?
    let relativeHumidity2m: Double?
    let weatherCode: Int?
    let windSpeed10m: Double?

    private enum CodingKeys: String, CodingKey {
        case time
        case temperature2m = "temperature_2m"
        case apparentTemperature = "apparent_temperature"
        case relativeHumidity2m = "relative_humidity_2m"
        case weatherCode = "weather_code"
        case windSpeed10m = "wind_speed_10m"
    }
}

struct OpenMeteoHourly: Decodable, Sendable {
    let time: [String]
    let relativeHumidity2m: [Double]?

    private enum CodingKeys: String, CodingKey {
        case time
        case relativeHumidity2m = "relative_humidity_2m"
    }
}

struct OpenMeteoDaily: Decodable, Sendable {
    let time: [String]
    let weatherCode: [Int]?
    let temperature2mMax: [Double]?
    let temperature2mMin: [Double]?
    let precipitationProbabilityMax: [Double]?
    let windSpeed10mMax: [Double]?
    let uvIndexMax: [Double]?

    private enum CodingKeys: String, CodingKey {
        case time
        case weatherCode = "weather_code"
        case temperature2mMax = "temperature_2m_max"
        case temperature2mMin = "temperature_2m_min"
        case precipitationProbabilityMax = "precipitation_probability_max"
        case windSpeed10mMax = "wind_speed_10m_max"
        case uvIndexMax = "uv_index_max"
    }
}

private extension Array {
    subscript(safe index: Int) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
