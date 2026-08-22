//
//  GrowingIntelligenceService.swift
//  Bonsai World
//
//  Growing Intelligence domain — rule-based knowledge and recommendation facade.
//  Working name: ``WorkingDomainID/growingIntelligence`` (see ``WorkingDomainCatalog``).
//
//  Consumes (SSOT owners — no duplicated records):
//  - Trees
//  - Habitat (Gardens, Locations, environment)
//  - Workshop (care history / future work signals)
//  - Weather (future)
//  - Reference Data
//
//  Produces future recommendations (watering, fertilizing, placement, recovery,
//  seasonal / winter care). Not AI — future AI builds upon this domain.
//
//  Engines are prepared; recommendation behaviour is not implemented.
//

import Foundation
import Observation

@Observable
@MainActor
final class GrowingIntelligenceService {
    /// Working domain identity (terminology — not a storage key).
    static let workingDomain: WorkingDomainID = .growingIntelligence

    // MARK: - Engines (architecture placeholders)

    let environment: EnvironmentEngine
    let weather: WeatherEngine
    let watering: WateringEngine
    let fertilizer: FertilizerEngine
    let placement: PlacementEngine
    let recovery: RecoveryEngine
    let winter: WinterEngine
    let recommendation: RecommendationEngine

    /// Read-only access points for future engine evaluation (SSOT owners).
    private let treeService: TreeService
    private let referenceData: ReferenceDataService
    private let profile: UserProfileStore

    init(
        treeService: TreeService,
        referenceData: ReferenceDataService,
        profile: UserProfileStore,
        environment: EnvironmentEngine = EnvironmentEngine(),
        weather: WeatherEngine = WeatherEngine(),
        watering: WateringEngine = WateringEngine(),
        fertilizer: FertilizerEngine = FertilizerEngine(),
        placement: PlacementEngine = PlacementEngine(),
        recovery: RecoveryEngine = RecoveryEngine(),
        winter: WinterEngine = WinterEngine(),
        recommendation: RecommendationEngine = RecommendationEngine()
    ) {
        self.treeService = treeService
        self.referenceData = referenceData
        self.profile = profile
        self.environment = environment
        self.weather = weather
        self.watering = watering
        self.fertilizer = fertilizer
        self.placement = placement
        self.recovery = recovery
        self.winter = winter
        self.recommendation = recommendation
    }

    /// All prepared engines (order is architectural, not priority).
    var engines: [any GrowingIntelligenceEngine] {
        [environment, weather, watering, fertilizer, placement, recovery, winter, recommendation]
    }

    // MARK: - Future evaluation API

    /// Produces recommendations for a query.
    /// Intentionally empty — engines are not implemented yet.
    func recommendations(for query: GrowingIntelligenceQuery) -> [GrowingRecommendation] {
        _ = (query, treeService, referenceData, profile, engines)
        return []
    }
}
