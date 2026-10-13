//
//  WinterCareStep.swift
//  BonsaiCore
//
//  Checklist steps inside the Winter Care batch task.
//

import Foundation

/// Ordered Winter Care checklist steps (complete per tree, multi-select friendly).
enum WinterCareStep: String, Codable, CaseIterable, Identifiable, Hashable, Sendable {
    case washPot
    case cleanTrunk
    case limeSulfur
    case protectForWinter

    var id: Self { self }

    var title: String {
        switch self {
        case .washPot: "Wash pot"
        case .cleanTrunk: "Clean trunk"
        case .limeSulfur: "Apply diluted lime sulfur"
        case .protectForWinter: "Protect for winter"
        }
    }

    var help: String {
        switch self {
        case .washPot:
            "Clean the pot before winter storage."
        case .cleanTrunk:
            "Remove algae or green growth from the trunk."
        case .limeSulfur:
            "Spray with diluted lime sulfur where you use it."
        case .protectForWinter:
            "Move indoors, place against a wall, pack with leaves, or otherwise protect for winter."
        }
    }
}
