//
//  WeatherService.swift
//  Bonsai World
//
//  App-wide Weather access for the Dashboard (and future Growing Intelligence
//  engines). Reads the default Garden's position from UserProfileStore (SSOT —
//  Weather never stores its own coordinate) and refreshes on a timer so the
//  Dashboard always shows current conditions without user action.
//
//  Known limitation (multi-Garden, tracked for a future pass): this service is
//  keyed to `profile.defaultGarden` only. Locations belonging to a non-default
//  Garden (see AppState.selectedGardenID in the Locations module) will show
//  WeatherRiskAssessment.locationRisks() computed against the default Garden's
//  forecast, which may not reflect that Location's actual conditions.
//
//  Usage:
//    @Environment(WeatherService.self) private var weatherService
//

import Foundation
import Observation

@Observable
@MainActor
final class WeatherService {
    enum LoadState: Equatable, Sendable {
        case idle
        case loading
        case loaded
        case failed(String)
        /// The active Garden has no position placed on the map yet.
        case noGardenPosition
    }

    private let provider: any WeatherProviding
    private let profile: UserProfileStore
    private let refreshInterval: TimeInterval

    private(set) var snapshot: WeatherSnapshot?
    private(set) var state: LoadState = .idle
    private(set) var lastUpdated: Date?

    private var refreshTask: Task<Void, Never>?

    init(
        profile: UserProfileStore,
        provider: any WeatherProviding = OpenMeteoWeatherProvider(),
        refreshInterval: TimeInterval = 30 * 60
    ) {
        self.profile = profile
        self.provider = provider
        self.refreshInterval = refreshInterval
    }

    var gardenName: String {
        profile.defaultGarden?.name ?? "My Garden"
    }

    /// Settlement-level place name (City), never the street Address — set on the Garden
    /// itself (Settings → Gardens), never derived from coordinates. Falls back to Region
    /// or Country when City is blank; `nil` when the Garden has none of those set.
    var gardenPlaceName: String? {
        guard let garden = profile.defaultGarden else { return nil }
        let city = garden.city.trimmingCharacters(in: .whitespacesAndNewlines)
        if !city.isEmpty { return city }
        let region = garden.region.trimmingCharacters(in: .whitespacesAndNewlines)
        if !region.isEmpty { return region }
        let country = garden.country.trimmingCharacters(in: .whitespacesAndNewlines)
        return country.isEmpty ? nil : country
    }

    /// Starts (or restarts) the background refresh loop. Safe to call once at app launch;
    /// keeps refreshing for the lifetime of the app so the card never goes stale.
    func startAutoRefresh() {
        refreshTask?.cancel()
        refreshTask = Task { [weak self] in
            guard let self else { return }
            while !Task.isCancelled {
                await self.refresh()
                try? await Task.sleep(for: .seconds(self.refreshInterval))
            }
        }
    }

    func stopAutoRefresh() {
        refreshTask?.cancel()
        refreshTask = nil
    }

    /// Cheap call for view `.task` / scenePhase hooks — skips the network round trip
    /// when the last fetch is still fresh.
    func refreshIfNeeded(minimumInterval: TimeInterval = 5 * 60) async {
        if let lastUpdated, snapshot != nil, Date.now.timeIntervalSince(lastUpdated) < minimumInterval {
            return
        }
        await refresh()
    }

    func refresh() async {
        guard let coordinate = profile.defaultGarden?.gardenPosition else {
            state = .noGardenPosition
            snapshot = nil
            return
        }

        state = .loading
        do {
            let result = try await provider.fetchWeather(latitude: coordinate.latitude, longitude: coordinate.longitude)
            snapshot = result
            lastUpdated = .now
            state = .loaded
        } catch {
            state = .failed(error.localizedDescription)
        }
    }
}
