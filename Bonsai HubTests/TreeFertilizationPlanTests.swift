//
//  TreeFertilizationPlanTests.swift
//  Bonsai World
//

import Foundation
import Testing
@testable import Bonsai_Hub

struct TreeFertilizationPlanTests {
    private let planner = TreeFertilizationPlanner()
    private let locationID = UUID()

    private var spring: Date { date(year: 2026, month: 4, day: 15) }

    @Test func healthyJapaneseMapleInTrainingSpringIsHigher() {
        let tree = makeTree(
            botanicalName: "Acer palmatum",
            stageName: "In Training",
            health: .healthy
        )
        let plan = planner.plan(
            for: tree,
            treeStageName: "In Training",
            speciesName: "Acer palmatum",
            now: spring
        )
        #expect(plan.recommendation == "Higher feeding")
        #expect(plan.when == "Now")
        #expect(plan.nextReview == "Approximately 4–6 weeks")
        #expect(plan.nextReviewDate == nil)
        #expect(!plan.isReviewRequired)
        #expect(plan.advice?.intensity == .higher)
    }

    @Test func unknownHealthDoesNotAssumeHealthyFeeding() {
        let tree = makeTree(
            botanicalName: "Acer palmatum",
            healthStatus: .stable,
            stageName: "In Training",
            health: nil
        )
        let plan = planner.plan(
            for: tree,
            treeStageName: "In Training",
            speciesName: "Acer palmatum",
            now: spring
        )
        #expect(plan.isReviewRequired)
        #expect(plan.recommendation == "Review tree before feeding")
        #expect(plan.reason == "Current tree condition is not confirmed.")
        #expect(plan.advice == nil)
        #expect(plan.nextReviewDate == nil)
    }

    @Test func pineEstablishmentRecoveryIsVeryCautious() {
        let tree = makeTree(
            botanicalName: "Pinus parviflora",
            healthStatus: .recovering,
            stageName: "Pre-Bonsai",
            health: .recovering
        )
        let plan = planner.plan(
            for: tree,
            treeStageName: "Pre-Bonsai",
            speciesName: "Pinus parviflora",
            now: spring
        )
        #expect(plan.advice?.intensity == .veryCautious || plan.isReviewRequired || plan.recommendation.contains("Cautious"))
    }

    @Test func winterTreeIsNoFeeding() {
        let tree = makeTree(
            botanicalName: "Acer palmatum",
            stageName: "In Training",
            health: .healthy
        )
        let winter = date(year: 2026, month: 1, day: 15)
        let plan = planner.plan(
            for: tree,
            treeStageName: "In Training",
            speciesName: "Acer palmatum",
            now: winter
        )
        #expect(plan.recommendation == "No feeding")
        #expect(plan.advice?.isFeeding == false)
        #expect(plan.advice?.intensity == FertilizerIntensity.none)
        #expect(plan.nextReviewDate == nil)
    }

    @Test func missingTreeStageRequiresReview() {
        let tree = makeTree(
            botanicalName: "Acer palmatum",
            stageName: nil,
            health: .healthy
        )
        let plan = planner.plan(
            for: tree,
            treeStageName: nil,
            speciesName: "Acer palmatum",
            now: spring
        )
        #expect(plan.isReviewRequired)
        #expect(plan.reason == "Tree Stage needs review.")
    }

    @Test func recordedFertilizationDoesNotScheduleAFeedingDate() {
        let tree = makeTree(
            botanicalName: "Acer palmatum",
            stageName: "In Training",
            health: .healthy
        )
        let lastFed = date(year: 2026, month: 4, day: 1)
        let withRecord = planner.plan(
            for: tree,
            treeStageName: "In Training",
            speciesName: "Acer palmatum",
            now: spring,
            lastFertilizedAt: lastFed
        )
        let withoutRecord = planner.plan(
            for: tree,
            treeStageName: "In Training",
            speciesName: "Acer palmatum",
            now: spring
        )
        #expect(withRecord.nextReviewDate == nil)
        #expect(withRecord.nextReview == "Approximately 4–6 weeks")
        #expect(!withRecord.nextReview.contains("2026"))
        #expect(withRecord.recommendation == "Higher feeding")
        #expect(withRecord.recommendation == withoutRecord.recommendation)
        #expect(withRecord.nextReview == withoutRecord.nextReview)
    }

    private func makeTree(
        botanicalName: String,
        healthStatus: TreeHealthStatus = .stable,
        stageName: String?,
        health: FertilizerHealth? = nil,
        kindOverride: FertilizerKind? = nil
    ) -> Tree {
        Tree(
            botanicalName: botanicalName,
            treeStageID: stageName.flatMap { TreeStagePreviewData.id(for: $0) },
            healthStatus: healthStatus,
            fertilizerHealth: health,
            fertilizerKindOverride: kindOverride,
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
