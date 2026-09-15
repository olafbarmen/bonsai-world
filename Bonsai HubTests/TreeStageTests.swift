//
//  TreeStageTests.swift
//  Bonsai World
//

import Foundation
import Testing
@testable import Bonsai_Hub

struct TreeStageTests {
    private let engine = FertilizerEngine()
    private let locationID = UUID()

    // MARK: - Fertilization mode mapping

    @Test(arguments: [
        ("Seedling", FertilizerStage.development),
        ("Cutting", FertilizerStage.development),
        ("Nursery Stock", FertilizerStage.development),
        ("Yamadori – Newly Collected", FertilizerStage.establishment),
        ("Pre-Bonsai", FertilizerStage.development),
        ("In Training", FertilizerStage.development),
        ("Refinement", FertilizerStage.refinement),
        ("Exhibition", FertilizerStage.refinement),
    ])
    func treeStageMapsToFertilizerStage(name: String, expected: FertilizerStage) {
        #expect(TreeStageFertilizerMapping.fertilizerStage(forTreeStageName: name) == expected)
    }

    // MARK: - Yamadori newly collected safety rule

    @Test func newlyCollectedYamadoriSpringIsNoFeeding() {
        assertNoFeeding(season: .spring, growth: .activeExtension)
    }

    @Test func newlyCollectedYamadoriSummerIsNoFeeding() {
        assertNoFeeding(season: .summer, growth: .activeExtension)
    }

    @Test func newlyCollectedYamadoriDevelopmentLikeGrowthIsNoFeeding() {
        assertNoFeeding(season: .spring, growth: .budsOpening)
        assertNoFeeding(season: .summer, growth: .firstFlushHardened)
    }

    @Test func newlyCollectedYamadoriTreePlanIsNoFeedingInSpring() {
        let tree = makeTree(stageName: TreeStageFertilizerMapping.newlyCollectedYamadoriName)
        let plan = planner.plan(
            for: tree,
            treeStageName: TreeStageFertilizerMapping.newlyCollectedYamadoriName,
            speciesName: "Acer palmatum",
            now: date(year: 2026, month: 4, day: 15)
        )
        #expect(plan.recommendation == "No feeding")
        #expect(plan.advice?.intensity == FertilizerIntensity.none)
        #expect(plan.advice?.isFeeding == false)
    }

    // MARK: - Acquisition method independence

    @Test func yamadoriAcquisitionDoesNotImplyNewlyCollectedStage() {
        let yamadoriMethodID = UUID()
        var tree = makeTree(stageName: "In Training")
        tree.acquisitionMethodID = yamadoriMethodID

        let plan = planner.plan(
            for: tree,
            treeStageName: "In Training",
            speciesName: "Acer palmatum",
            now: date(year: 2026, month: 4, day: 15)
        )
        #expect(plan.recommendation != "No feeding" || plan.advice?.isFeeding == true)
        #expect(!TreeStageFertilizerMapping.isNewlyCollectedYamadori("In Training"))
    }

    // MARK: - Legacy migration

    @Test(arguments: [
        ("Frøplante", "Seedling"),
        ("Stikling", "Cutting"),
        ("Ungplante", "Nursery Stock"),
        ("Prebonsai", "Pre-Bonsai"),
        ("Under utvikling", "In Training"),
        ("Bonsai", "In Training"),
        ("Ferdig bonsai", "Refinement"),
        ("Yamadori", TreeStageFertilizerMapping.newlyCollectedYamadoriName),
        ("Seed", "Seedling"),
    ])
    func legacyNamesMigrateToCanonical(legacy: String, canonical: String) {
        #expect(TreeStageLegacyCatalog.canonicalStageName(fromLegacyName: legacy) == canonical)
    }

    private let planner = TreeFertilizationPlanner()

    private func assertNoFeeding(season: FertilizerSeason, growth: FertilizerGrowth) {
        let advice = engine.advice(
            for: FertilizerQuery(
                kind: .japaneseMaple,
                stage: .establishment,
                season: season,
                growth: growth,
                health: .healthy,
                isNewlyCollectedYamadori: true
            )
        )
        #expect(advice.intensity == FertilizerIntensity.none)
        #expect(!advice.isFeeding)
        #expect(advice.whenToStart.contains("Do not fertilize"))
    }

    private func makeTree(stageName: String) -> Tree {
        Tree(
            botanicalName: "Acer palmatum",
            treeStageID: TreeStagePreviewData.id(for: stageName),
            healthStatus: .stable,
            fertilizerHealth: .healthy,
            locationID: locationID
        )
    }

    private func date(year: Int, month: Int, day: Int) -> Date {
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = day
        return Calendar(identifier: .gregorian).date(from: components)!
    }
}
