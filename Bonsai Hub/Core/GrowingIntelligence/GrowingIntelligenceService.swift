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
//  Engines: Fertilizing, Watering, Winter, and Placement (gaps v1) are live;
//  other engines remain architectural placeholders.
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

    /// Decision-engine lookup for Care → Fertilizing. Explorer inputs — not a Tree query.
    func fertilizerAdvice(_ query: FertilizerQuery) -> FertilizerAdvice {
        fertilizer.advice(for: query)
    }

    /// Care → Watering advisory v1 — Location Environment + weather only.
    /// Never changes Tasks, Due, or Watering policy.
    func wateringAdvice(
        environment: LocationEnvironmentProfile,
        snapshot: WeatherSnapshot?,
        heatWatchEnabled: Bool
    ) -> WateringAdvice {
        watering.advice(
            environment: environment,
            snapshot: snapshot,
            heatWatchEnabled: heatWatchEnabled
        )
    }

    /// Care → Winter Care advisory v1 — Location winterProtection + weather only.
    /// Never assumes indoor/greenhouse are frost free. Never changes Tasks or Work.
    func winterAdvice(
        environment: LocationEnvironmentProfile,
        snapshot: WeatherSnapshot?
    ) -> WinterAdvice {
        winter.advice(environment: environment, snapshot: snapshot)
    }

    /// Care → Placement advisory v1 — gaps only (missing Location; seasonal season vs Winter/Spring Care).
    /// Never invents a destination. Never changes Tasks or Work.
    func placementAdvice(
        winterCareActive: Bool,
        springCareActive: Bool
    ) -> PlacementAdvice {
        placement.advice(
            trees: treeService.trees,
            title: { TreePresentation.title(for: $0) },
            hasResolvedLocation: { referenceData.location(id: $0.locationID) != nil },
            winterCareActive: winterCareActive,
            springCareActive: springCareActive
        )
    }

    func fertilizerAdvice(
        kind: FertilizerKind,
        stage: FertilizerStage,
        season: FertilizerSeason,
        growth: FertilizerGrowth,
        health: FertilizerHealth = .healthy
    ) -> FertilizerAdvice {
        fertilizer.advice(
            kind: kind,
            stage: stage,
            season: season,
            growth: growth,
            health: health
        )
    }

    /// Tree-level plan. Maps Tree state into the shared engine. Does not schedule dates.
    func fertilizationPlan(
        for tree: Tree,
        now: Date = .now,
        lastFertilizedAt: Date? = nil
    ) -> TreeFertilizationPlan {
        let speciesName = tree.speciesID.flatMap { referenceData.species(id: $0)?.name }
        let treeStageName = tree.treeStageID.flatMap { referenceData.treeStage(id: $0)?.name }
        return TreeFertilizationPlanner(engine: fertilizer).plan(
            for: tree,
            treeStageName: treeStageName,
            speciesName: speciesName,
            now: now,
            lastFertilizedAt: lastFertilizedAt
        )
    }

    /// Produces recommendations for a query.
    /// Watering / fertilizing Care surfaces call dedicated advice APIs; this list stays empty for now.
    func recommendations(for query: GrowingIntelligenceQuery) -> [GrowingRecommendation] {
        _ = (query, treeService, referenceData, profile, engines)
        return []
    }
}
