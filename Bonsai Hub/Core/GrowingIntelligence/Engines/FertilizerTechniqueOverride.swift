//
//  FertilizerTechniqueOverride.swift
//  Bonsai World
//
//  Technique-specific fertilizing overrides. Add a new type and register it
//  on FertilizerEngine — do not hide overrides inside seasonal switches.
//

import Foundation

protocol FertilizerTechniqueOverride: Sendable {
    var id: String { get }
    func applies(to query: FertilizerQuery) -> Bool
    func advice(for query: FertilizerQuery) -> FertilizerAdvice
}

/// Double-flush pine after decandling — pause feeding. Guidance, not a timer.
struct PostDecandlingOverride: FertilizerTechniqueOverride {
    let id = "fertilizer.technique.postDecandling"

    func applies(to query: FertilizerQuery) -> Bool {
        query.growth == .postDecandling && query.treeGroup == .pineDoubleFlush
    }

    func advice(for query: FertilizerQuery) -> FertilizerAdvice {
        let weakNote = query.health.isRestricted
            ? " A weak tree may need longer before any feed resumes."
            : ""
        return FertilizerAdvice(
            intensity: .pauseHold,
            category: .none,
            goal: query.stage.goal,
            whenToStart: "Stop normal fertilization at decandling. After about four weeks, feeding can gradually resume when the tree’s condition allows — not on a blind timer.",
            rhythm: nil,
            seaweed: "None. Seaweed is a supplement, not a reason to keep feeding through the pause.",
            humic: "None. Humic products are support, not a complete fertilizer, and not a substitute during the pause.",
            caution: "Remove dry fertilizer where appropriate. Stop liquid feeding. Let the tree respond to the decandling.\(weakNote) \(FertilizerAdvice.followTheLabel)",
            explanation: "Decandling is a technique pause. The tree’s response is the authority, not the calendar.",
            isPaused: true,
            shouldWaitForGrowth: false,
            isFeeding: false
        )
    }
}
