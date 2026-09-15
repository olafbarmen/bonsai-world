//
//  FertilizerEngine.swift
//  Bonsai World
//
//  Growing Intelligence — fertilizing decision engine.
//  Feed the tree you are growing, not simply the month on the calendar.
//  Rule-based. Not AI. Not a gram/ml dosage.
//

import Foundation

struct FertilizerEngine: GrowingIntelligenceEngine, Sendable {
    let engineID = "growingIntelligence.fertilizer"
    let techniqueOverrides: [any FertilizerTechniqueOverride]

    init(techniqueOverrides: [any FertilizerTechniqueOverride] = [PostDecandlingOverride()]) {
        self.techniqueOverrides = techniqueOverrides
    }

    func advice(for query: FertilizerQuery) -> FertilizerAdvice {
        if query.isNewlyCollectedYamadori {
            return newlyCollectedYamadoriAdvice(for: query)
        }

        if let stopped = inactivityAdvice(for: query) {
            return stopped
        }

        if let override = techniqueOverrides.first(where: { $0.applies(to: query) }) {
            return override.advice(for: query)
        }

        if query.growth == .budsSwelling {
            return prepareAdvice(for: query)
        }

        let stage = effectiveStage(for: query)
        var intensity = FertilizerMatrix.baseline(
            stage: stage,
            group: query.treeGroup,
            season: query.season
        )
        intensity = applyGrowth(intensity, query: query, stage: stage)
        intensity = applyHealthCap(intensity, health: query.health)

        let waiting = shouldWait(stage: stage, query: query, intensity: intensity)
        if waiting {
            return waitAdvice(for: query, stage: stage, intensity: .veryCautious)
        }

        if intensity == .none {
            return stoppedAdvice(
                for: query,
                summaryWhen: "The tree is not in a feeding window. Growth and condition outweigh the calendar."
            )
        }

        return feedingAdvice(for: query, stage: stage, intensity: intensity)
    }

    func advice(
        kind: FertilizerKind,
        stage: FertilizerStage,
        season: FertilizerSeason,
        growth: FertilizerGrowth,
        health: FertilizerHealth = .healthy
    ) -> FertilizerAdvice {
        advice(
            for: FertilizerQuery(
                kind: kind,
                stage: stage,
                season: season,
                growth: growth,
                health: health
            )
        )
    }
}

// MARK: - Priority steps

private extension FertilizerEngine {
    func newlyCollectedYamadoriAdvice(for query: FertilizerQuery) -> FertilizerAdvice {
        stoppedAdvice(
            for: query,
            summaryWhen: "The tree is in the initial establishment and recovery phase after collection. Do not fertilize."
        )
    }

    func inactivityAdvice(for query: FertilizerQuery) -> FertilizerAdvice? {
        if query.growth == .dormant {
            return stoppedAdvice(
                for: query,
                summaryWhen: "The tree is dormant. Do not fertilize."
            )
        }
        if query.growth == .noActiveGrowth {
            return stoppedAdvice(
                for: query,
                summaryWhen: "No visible growth. Wait. The tree’s growth is the trigger, not the calendar."
            )
        }
        if query.growth == .preparingForDormancy {
            return stoppedAdvice(
                for: query,
                summaryWhen: "The tree is preparing for dormancy. Stop feeding."
            )
        }
        if query.season == .winter {
            return stoppedAdvice(
                for: query,
                summaryWhen: "Winter is not a feeding season. Do not fertilize."
            )
        }
        return nil
    }

    func effectiveStage(for query: FertilizerQuery) -> FertilizerStage {
        if query.health.requiresConservativeProgramme, query.stage != .establishment {
            return .establishment
        }
        return query.stage
    }

    func applyGrowth(
        _ intensity: FertilizerIntensity,
        query: FertilizerQuery,
        stage: FertilizerStage
    ) -> FertilizerIntensity {
        let group = query.treeGroup
        let season = query.season
        let growth = query.growth

        switch growth {
        case .dormant, .noActiveGrowth, .preparingForDormancy, .postDecandling:
            return intensity

        case .budsSwelling:
            return intensity

        case .budsOpening:
            if stage == .establishment { return .veryCautious }
            if stage == .refinement { return min(intensity, .low) }
            return intensity

        case .activeExtension:
            if stage == .refinement, group == .pineSingleFlush, season == .summer {
                return .low
            }
            if stage == .refinement, group.isDeciduous, season == .summer {
                return .low
            }
            if stage == .development, group == .pineSingleFlush, season == .summer {
                return .moderate
            }
            return intensity

        case .firstFlushHardened:
            if stage == .refinement, group == .pineSingleFlush,
               season == .summer || season == .lateSummer {
                return .moderate
            }
            if stage == .development, group == .pineSingleFlush, season == .summer {
                return .higher
            }
            if stage == .refinement, group.isDeciduous, season == .summer {
                return .moderate
            }
            return intensity

        case .secondFlushDeveloping:
            if group == .pineDoubleFlush, stage == .development, season == .summer {
                return .higher
            }
            return intensity
        }
    }

    func applyHealthCap(
        _ intensity: FertilizerIntensity,
        health: FertilizerHealth
    ) -> FertilizerIntensity {
        guard health.isRestricted else { return intensity }
        return intensity.capped(at: .low)
    }

    func shouldWait(
        stage: FertilizerStage,
        query: FertilizerQuery,
        intensity: FertilizerIntensity
    ) -> Bool {
        guard stage == .establishment else { return false }
        if query.season == .spring, !query.growth.showsClearRecovery {
            return true
        }
        if intensity <= .veryCautious, !query.growth.showsClearRecovery {
            return true
        }
        return false
    }
}

// MARK: - Recommendation builders

private extension FertilizerEngine {
    func feedingAdvice(
        for query: FertilizerQuery,
        stage: FertilizerStage,
        intensity: FertilizerIntensity
    ) -> FertilizerAdvice {
        let category = primaryCategory(stage: stage, intensity: intensity)
        return FertilizerAdvice(
            intensity: intensity,
            category: category,
            goal: goal(for: query, stage: stage),
            whenToStart: whenToStart(for: query, stage: stage, intensity: intensity),
            rhythm: FertilizerRhythm.organicSolidGuidance,
            seaweed: seaweedLine(stage: stage, intensity: intensity),
            humic: humicLine(stage: stage),
            caution: caution(for: query, stage: stage, feeding: true),
            explanation: explanation(for: query, stage: stage, intensity: intensity),
            isPaused: false,
            shouldWaitForGrowth: false,
            isFeeding: true
        )
    }

    func waitAdvice(
        for query: FertilizerQuery,
        stage: FertilizerStage,
        intensity: FertilizerIntensity
    ) -> FertilizerAdvice {
        FertilizerAdvice(
            intensity: intensity,
            category: .none,
            goal: stage.goal,
            whenToStart: "Wait for clear recovery and healthy new growth before solids.",
            rhythm: nil,
            seaweed: "Optional light support if the product instructions allow. Seaweed is a supplement, not the main fertilizer.",
            humic: "Root / soil support at the start of recovery. Not a complete fertilizer.",
            caution: caution(for: query, stage: stage, feeding: false),
            explanation: "A recovering or inactive tree must not be fed like a healthy development tree. Condition outweighs the calendar.",
            isPaused: false,
            shouldWaitForGrowth: true,
            isFeeding: false
        )
    }

    func prepareAdvice(for query: FertilizerQuery) -> FertilizerAdvice {
        FertilizerAdvice(
            intensity: .pauseHold,
            category: .none,
            goal: query.stage.goal,
            whenToStart: "Buds are swelling. Prepare, but do not begin cake or pellet feeding yet.",
            rhythm: nil,
            seaweed: "Optional light support if the product instructions allow. Seaweed is a supplement, not the main fertilizer.",
            humic: humicLine(stage: query.stage),
            caution: caution(for: query, stage: query.stage, feeding: false),
            explanation: "Swelling buds are a signal to get ready, not a signal to increase feeding.",
            isPaused: true,
            shouldWaitForGrowth: false,
            isFeeding: false
        )
    }

    func stoppedAdvice(for query: FertilizerQuery, summaryWhen: String) -> FertilizerAdvice {
        FertilizerAdvice(
            intensity: .none,
            category: .none,
            goal: query.stage.goal,
            whenToStart: summaryWhen,
            rhythm: nil,
            seaweed: "None. Seaweed is a supplement, not a complete fertilizer.",
            humic: "None. Humic products are support, not a complete fertilizer.",
            caution: "\(query.kind.watchFor). Do not fertilize a tree simply because the calendar says it is time. \(FertilizerAdvice.followTheLabel)",
            explanation: "Safety and the tree’s actual condition override the month.",
            isPaused: false,
            shouldWaitForGrowth: query.growth == .noActiveGrowth,
            isFeeding: false
        )
    }

    func goal(for query: FertilizerQuery, stage: FertilizerStage) -> String {
        if stage == .development {
            return FertilizerMatrix.developmentGoal(for: query.treeGroup)
        }
        return stage.goal
    }

    func primaryCategory(stage: FertilizerStage, intensity: FertilizerIntensity) -> FertilizerCategory {
        switch stage {
        case .establishment:
            return .lowerNitrogen
        case .refinement:
            return intensity >= .moderate ? .balanced : .lowerNitrogen
        case .development:
            if intensity >= .higher { return .higherNitrogen }
            if intensity >= .moderate { return .balanced }
            return .organicSolid
        }
    }

    func whenToStart(
        for query: FertilizerQuery,
        stage: FertilizerStage,
        intensity: FertilizerIntensity
    ) -> String {
        let watch = query.kind.watchFor.lowercased()
        if stage == .establishment {
            if query.growth.showsClearRecovery {
                return "Recovery is clearly underway. Keep feeding conservative. Watch \(watch)."
            }
            return "Only after recovery is clearly underway. Watch \(watch)."
        }
        if query.growth == .firstFlushHardened, query.treeGroup == .pineSingleFlush {
            return "Needles have hardened. Feeding may step up according to stage. Watch \(watch)."
        }
        if intensity <= .low {
            return "Active growth has started. Keep it controlled. Watch \(watch)."
        }
        return "Active growth has started. Begin according to stage. Watch \(watch)."
    }

    func seaweedLine(stage: FertilizerStage, intensity: FertilizerIntensity) -> String {
        if intensity <= .low || stage == .establishment {
            return "Seasonal supplement through active growth. Support, not the main meal. Not a complete fertilizer."
        }
        return "Seasonal supplement alongside the solids. Not a complete fertilizer."
    }

    func humicLine(stage: FertilizerStage) -> String {
        switch stage {
        case .establishment:
            return "Root / soil support at the start of recovery. Not a complete fertilizer."
        case .development:
            return "As needed around repot or stress. Not the main feed."
        case .refinement:
            return "Around repotting, not as routine feed. Not a complete fertilizer."
        }
    }

    func explanation(
        for query: FertilizerQuery,
        stage: FertilizerStage,
        intensity: FertilizerIntensity
    ) -> String {
        if query.health.requiresConservativeProgramme, query.stage != .establishment {
            return "Health and recovery restrict feeding. The seasonal programme is not increased."
        }
        if stage == .refinement {
            return "Refinement is fed for control, not maximum extension. \(query.kind.title) in \(query.season.title.lowercased()) at \(intensity.title.lowercased()) intensity."
        }
        return "\(query.kind.title) in \(stage.title.lowercased()), \(query.season.title.lowercased()), with \(query.growth.title.lowercased()). Season is context; growth and stage decide the strength."
    }

    func caution(
        for query: FertilizerQuery,
        stage: FertilizerStage,
        feeding: Bool
    ) -> String {
        var parts: [String] = []
        if query.health.isRestricted {
            parts.append("Do not increase feeding while the tree is weak, stressed or sick.")
        }
        if query.treeGroup.isPine, feeding {
            parts.append("Time pine by the flush, not the month.")
            if query.treeGroup == .pineSingleFlush, stage == .refinement {
                parts.append("Too much nitrogen makes long needles.")
            }
        }
        if query.treeGroup == .deciduousDefoliationTolerant, stage == .refinement, feeding {
            parts.append("Do not confuse vigorous growth with good refinement.")
        }
        if stage == .establishment, feeding {
            parts.append("When in doubt, feed less rather than more.")
        }
        parts.append("Starting point. \(FertilizerAdvice.followTheLabel)")
        return parts.joined(separator: " ")
    }
}
