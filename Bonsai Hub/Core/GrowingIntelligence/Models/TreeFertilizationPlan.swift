//
//  TreeFertilizationPlan.swift
//  Bonsai World
//
//  Tree-level fertilization plan. Maps Tree state to the decision engine.
//  Does not duplicate matrix rules. Does not schedule feeding dates.
//

import Foundation

struct TreeFertilizationPlan: Hashable, Sendable {
    var recommendation: String
    var fertilizerType: String
    var when: String
    var goal: String
    var nextReview: String
    var note: String
    var reason: String?
    var isReviewRequired: Bool
    /// Always nil. Review is an interval / condition, never an automatic feeding date.
    var nextReviewDate: Date?
    var advice: FertilizerAdvice?

    static let followTheLabel = FertilizerAdvice.followTheLabel
}

enum FertilizerSeasonCalendar {
    /// Temperate northern-hemisphere context. Season is context, not the decision.
    static func season(from date: Date, calendar: Calendar = Calendar(identifier: .gregorian)) -> FertilizerSeason {
        switch calendar.component(.month, from: date) {
        case 3, 4, 5: .spring
        case 6, 7: .summer
        case 8: .lateSummer
        case 9, 10: .fall
        default: .winter
        }
    }
}

struct TreeFertilizationPlanner: Sendable {
    var engine: FertilizerEngine

    init(engine: FertilizerEngine = FertilizerEngine()) {
        self.engine = engine
    }

    func plan(
        for tree: Tree,
        treeStageName: String?,
        speciesName: String?,
        now: Date = .now,
        calendar: Calendar = Calendar(identifier: .gregorian),
        lastFertilizedAt: Date? = nil
    ) -> TreeFertilizationPlan {
        _ = lastFertilizedAt

        let season = FertilizerSeasonCalendar.season(from: now, calendar: calendar)
        let kind = resolvedKind(for: tree, speciesName: speciesName)
        let stage = resolvedFertilizerStage(from: treeStageName)
        let isNewlyCollectedYamadori = treeStageName.map(TreeStageFertilizerMapping.isNewlyCollectedYamadori) ?? false
        let growth = defaultGrowth(for: season)
        let health = resolvedHealth(from: tree)

        if isNewlyCollectedYamadori {
            return newlyCollectedYamadoriPlan(treeStageName: treeStageName, kind: kind)
        }

        if let missing = missingInputReason(kind: kind, stage: stage, treeStageName: treeStageName) {
            return reviewPlan(
                reason: missing,
                goal: stage?.goal ?? "Feed the tree you are growing"
            )
        }

        guard let kind, let stage else {
            return reviewPlan(
                reason: "Current tree condition is not confirmed.",
                goal: "Feed the tree you are growing"
            )
        }

        let queryHealth = health ?? .healthy
        let advice = engine.advice(
            for: FertilizerQuery(
                kind: kind,
                stage: stage,
                season: season,
                growth: growth,
                health: queryHealth,
                isNewlyCollectedYamadori: false
            )
        )

        if health == nil, wouldAssumeHealthyFeeding(advice) {
            return reviewPlan(
                reason: "Current tree condition is not confirmed.",
                goal: stage.goal
            )
        }

        return plan(from: advice, healthUnknown: health == nil)
    }
}

private extension TreeFertilizationPlanner {
    func resolvedKind(for tree: Tree, speciesName: String?) -> FertilizerKind? {
        if let override = tree.fertilizerKindOverride {
            return override
        }
        let name = speciesName?.trimmingCharacters(in: .whitespacesAndNewlines)
        if let name, !name.isEmpty, let mapped = FertilizerKind.kind(matchingSpeciesName: name) {
            return mapped
        }
        let botanical = tree.botanicalName.trimmingCharacters(in: .whitespacesAndNewlines)
        if !botanical.isEmpty {
            return FertilizerKind.kind(matchingSpeciesName: botanical)
        }
        return nil
    }

    func resolvedFertilizerStage(from treeStageName: String?) -> FertilizerStage? {
        guard let treeStageName else { return nil }
        return TreeStageFertilizerMapping.fertilizerStage(forTreeStageName: treeStageName)
    }

    /// Season-based default for tree-level display. Growth is not stored on Tree.
    func defaultGrowth(for season: FertilizerSeason) -> FertilizerGrowth {
        season == .winter ? .dormant : .activeExtension
    }

    /// Thriving / Stable on Tree.healthStatus is not treated as confirmed feeding health.
    func resolvedHealth(from tree: Tree) -> FertilizerHealth? {
        if let fertilizerHealth = tree.fertilizerHealth {
            return fertilizerHealth
        }
        switch tree.healthStatus {
        case .recovering: return .recovering
        case .needsAttention: return .weak
        case .thriving, .stable: return nil
        }
    }

    func missingInputReason(
        kind: FertilizerKind?,
        stage: FertilizerStage?,
        treeStageName: String?
    ) -> String? {
        if kind == nil { return "Kind of tree needs review." }
        if treeStageName == nil { return "Tree Stage needs review." }
        if stage == nil { return "Tree Stage needs review." }
        return nil
    }

    func wouldAssumeHealthyFeeding(_ advice: FertilizerAdvice) -> Bool {
        advice.isFeeding && advice.intensity > .low
    }

    func newlyCollectedYamadoriPlan(treeStageName: String?, kind: FertilizerKind?) -> TreeFertilizationPlan {
        let stage = FertilizerStage.establishment
        if let kind {
            let advice = engine.advice(
                for: FertilizerQuery(
                    kind: kind,
                    stage: stage,
                    season: .spring,
                    growth: .activeExtension,
                    health: .healthy,
                    isNewlyCollectedYamadori: true
                )
            )
            return TreeFertilizationPlan(
                recommendation: "No feeding",
                fertilizerType: FertilizerCategory.none.title,
                when: advice.whenToStart,
                goal: stage.goal,
                nextReview: "Review when the tree has established after collection",
                note: TreeFertilizationPlan.followTheLabel,
                reason: "The tree is in the initial establishment and recovery phase after collection.",
                isReviewRequired: false,
                nextReviewDate: nil,
                advice: advice
            )
        }
        return TreeFertilizationPlan(
            recommendation: "No feeding",
            fertilizerType: FertilizerCategory.none.title,
            when: "The tree is in the initial establishment and recovery phase after collection. Do not fertilize.",
            goal: stage.goal,
            nextReview: "Review when the tree has established after collection",
            note: TreeFertilizationPlan.followTheLabel,
            reason: treeStageName == nil ? "Tree Stage needs review." : nil,
            isReviewRequired: treeStageName == nil,
            nextReviewDate: nil,
            advice: nil
        )
    }

    func reviewPlan(
        reason: String,
        goal: String,
        advice: FertilizerAdvice? = nil
    ) -> TreeFertilizationPlan {
        TreeFertilizationPlan(
            recommendation: "Review tree before feeding",
            fertilizerType: FertilizerCategory.none.title,
            when: "Check current growth and condition before applying fertilizer.",
            goal: goal,
            nextReview: "Review the tree before feeding",
            note: TreeFertilizationPlan.followTheLabel,
            reason: reason,
            isReviewRequired: true,
            nextReviewDate: nil,
            advice: advice
        )
    }

    func plan(from advice: FertilizerAdvice, healthUnknown: Bool) -> TreeFertilizationPlan {
        TreeFertilizationPlan(
            recommendation: displayRecommendation(advice),
            fertilizerType: advice.fertilizerLine,
            when: displayWhen(advice),
            goal: advice.goal,
            nextReview: nextReview(for: advice),
            note: TreeFertilizationPlan.followTheLabel,
            reason: healthUnknown && advice.isFeeding
                ? "Check current growth and condition before applying fertilizer."
                : nil,
            isReviewRequired: false,
            nextReviewDate: nil,
            advice: advice
        )
    }

    func displayRecommendation(_ advice: FertilizerAdvice) -> String {
        if advice.isPaused { return FertilizerIntensity.pauseHold.title }
        if advice.intensity == .none { return "No feeding" }
        if advice.shouldWaitForGrowth { return "Very Cautious" }
        return "\(advice.intensity.title) feeding"
    }

    func displayWhen(_ advice: FertilizerAdvice) -> String {
        if advice.isPaused || advice.intensity == .none || advice.shouldWaitForGrowth {
            return advice.whenToStart
        }
        return "Now"
    }

    func nextReview(for advice: FertilizerAdvice) -> String {
        if advice.isPaused {
            return "Review after about four weeks when the tree has responded"
        }
        if advice.intensity == .none {
            return "Hold / no next feeding while dormant"
        }
        if advice.shouldWaitForGrowth {
            return "Review when active growth resumes"
        }
        if advice.intensity <= .veryCautious {
            return "Review after recovery"
        }
        return "Approximately 4–6 weeks"
    }
}
