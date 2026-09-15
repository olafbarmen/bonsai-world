//
//  FertilizerEngineTests.swift
//  Bonsai World
//

import Testing
@testable import Bonsai_Hub

struct FertilizerEngineTests {
    private let engine = FertilizerEngine()

    // MARK: - Specified cases

    @Test func pineEstablishmentSpringNewShootsIsVeryCautious() {
        let advice = engine.advice(
            kind: .pineSingleFlush,
            stage: .establishment,
            season: .spring,
            growth: .budsOpening
        )
        #expect(advice.intensity == .veryCautious)
        #expect(advice.shouldWaitForGrowth)
        #expect(!advice.isFeeding)
        #expect(advice.summary == "Wait for clear recovery")
    }

    @Test func japaneseMapleDevelopmentSpringBudsOpeningIsHigher() {
        let advice = engine.advice(
            kind: .japaneseMaple,
            stage: .development,
            season: .spring,
            growth: .budsOpening
        )
        #expect(advice.intensity == .higher)
        #expect(advice.isFeeding)
        #expect(advice.category == .higherNitrogen)
        #expect(advice.goal == "Build trunk and branches")
    }

    @Test func beechRefinementSpringLeavesOpeningIsLowControlled() {
        let advice = engine.advice(
            kind: .beech,
            stage: .refinement,
            season: .spring,
            growth: .budsOpening
        )
        #expect(advice.intensity == .low)
        #expect(advice.isFeeding)
        #expect(advice.category == .lowerNitrogen)
        #expect(advice.goal.contains("Control growth"))
        #expect(advice.explanation.contains("Refinement"))
    }

    @Test func larchDevelopmentSpringActiveGrowthIsModerateToHigher() {
        let advice = engine.advice(
            kind: .larch,
            stage: .development,
            season: .spring,
            growth: .budsOpening
        )
        #expect(advice.intensity == .moderateToHigher)
        #expect(advice.isFeeding)
        #expect(advice.goal == "Rapid structural development")
    }

    @Test func doubleFlushPineRefinementPostDecandlingPauses() {
        let advice = engine.advice(
            kind: .pineDoubleFlush,
            stage: .refinement,
            season: .summer,
            growth: .postDecandling
        )
        #expect(advice.intensity == .pauseHold)
        #expect(advice.isPaused)
        #expect(!advice.isFeeding)
        #expect(advice.category == .none)
        #expect(advice.whenToStart.contains("four weeks"))
        #expect(!advice.organicSolid.lowercased().contains("biogold"))
    }

    @Test func winterDormantIsNoFeeding() {
        for kind in FertilizerKind.allCases {
            for stage in FertilizerStage.allCases {
                let advice = engine.advice(
                    kind: kind,
                    stage: stage,
                    season: .winter,
                    growth: .dormant
                )
                #expect(advice.intensity == .none)
                #expect(!advice.isFeeding)
                #expect(advice.category == .none)
            }
        }
    }

    @Test func weakOrInactiveDevelopmentSummerDoesNotIncrease() {
        let inactive = engine.advice(
            kind: .juniper,
            stage: .development,
            season: .summer,
            growth: .noActiveGrowth,
            health: .weak
        )
        #expect(inactive.intensity == .none)
        #expect(!inactive.isFeeding)

        let weakActive = engine.advice(
            kind: .juniper,
            stage: .development,
            season: .summer,
            growth: .activeExtension,
            health: .weak
        )
        let healthy = engine.advice(
            kind: .juniper,
            stage: .development,
            season: .summer,
            growth: .activeExtension,
            health: .healthy
        )
        #expect(healthy.intensity == .higher)
        #expect(weakActive.intensity < healthy.intensity)
        #expect(weakActive.intensity <= .low)
        #expect(weakActive.caution.contains("weak"))
    }

    @Test func healthyActiveGrowthUsesGroupAndStageNotCalendarAlone() {
        let juniperSummer = engine.advice(
            kind: .juniper,
            stage: .development,
            season: .summer,
            growth: .activeExtension
        )
        let juniperSpring = engine.advice(
            kind: .juniper,
            stage: .development,
            season: .spring,
            growth: .activeExtension
        )
        let beechSummer = engine.advice(
            kind: .beech,
            stage: .refinement,
            season: .summer,
            growth: .activeExtension
        )
        #expect(juniperSummer.intensity == .higher)
        #expect(juniperSpring.intensity == .moderate)
        #expect(beechSummer.intensity == .low)
        #expect(juniperSummer.rhythm?.contains("4–6 weeks") == true)
        #expect(juniperSummer.seaweed.contains("Not a complete fertilizer"))
        #expect(juniperSummer.humic.contains("Not the main feed"))
        #expect(juniperSummer.caution.contains("Follow the product label"))
    }

    // MARK: - Safety and mapping

    @Test func springDormantDoesNotFeed() {
        let advice = engine.advice(
            kind: .japaneseMaple,
            stage: .development,
            season: .spring,
            growth: .dormant
        )
        #expect(advice.intensity == .none)
        #expect(!advice.isFeeding)
    }

    @Test func tridentMapleSharesDefoliationGroupWithJapaneseMaple() {
        #expect(FertilizerKind.tridentMaple.treeGroup == .deciduousDefoliationTolerant)
        #expect(FertilizerKind.japaneseMaple.treeGroup == .deciduousDefoliationTolerant)
        #expect(FertilizerKind.beech.treeGroup == .deciduousNoDefoliation)
    }

    @Test func speciesNameMapsIntoGroupsWithoutGuessingUnknowns() {
        #expect(FertilizerKind.kind(matchingSpeciesName: "Acer palmatum") == .japaneseMaple)
        #expect(FertilizerKind.kind(matchingSpeciesName: "Acer buergerianum") == .tridentMaple)
        #expect(FertilizerKind.kind(matchingSpeciesName: "Pinus thunbergii") == .pineDoubleFlush)
        #expect(FertilizerKind.kind(matchingSpeciesName: "Fagus sylvatica") == .beech)
        #expect(FertilizerKind.kind(matchingSpeciesName: "Serissa foetida") == nil)
    }

    @Test func seaweedAndHumicAreNeverPrimary() {
        let advice = engine.advice(
            kind: .beech,
            stage: .development,
            season: .summer,
            growth: .activeExtension
        )
        #expect(advice.category.isPrimaryNutrient)
        #expect(advice.category != .seaweedSupplement)
        #expect(advice.category != .humicSupport)
        #expect(advice.seaweed.lowercased().contains("supplement") || advice.seaweed.contains("Not a complete"))
    }
}
