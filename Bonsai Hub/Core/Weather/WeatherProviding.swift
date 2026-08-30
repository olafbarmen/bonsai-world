//
//  WeatherProviding.swift
//  Bonsai World
//
//  Platform-independent contract for fetching Weather (mirrors DirectoryPicking /
//  ImageFilePicking in Platform/ — the concrete provider is swappable per OS or
//  vendor without touching WeatherService or the Dashboard UI).
//

import Foundation

protocol WeatherProviding: Sendable {
    /// Fetches a fresh snapshot for a coordinate. Throws on network or decode failure.
    func fetchWeather(latitude: Double, longitude: Double) async throws -> WeatherSnapshot
}

struct WeatherFetchError: Error, LocalizedError, Sendable {
    let message: String

    var errorDescription: String? { message }
}
