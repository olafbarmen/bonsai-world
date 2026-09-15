//
//  TreeStageFertilizerMapping.swift
//  Bonsai World
//
//  Maps authoritative Tree Stage names to fertilization engine stages.
//

import Foundation

enum TreeStageFertilizerMapping {
    static let newlyCollectedYamadoriName = "Yamadori – Newly Collected"

    static func fertilizerStage(forTreeStageName name: String) -> FertilizerStage? {
        switch normalized(name) {
        case "seedling", "cutting", "nursery stock", "pre-bonsai", "in training":
            return .development
        case normalized(newlyCollectedYamadoriName):
            return .establishment
        case "refinement", "exhibition":
            return .refinement
        default:
            return nil
        }
    }

    static func isNewlyCollectedYamadori(_ name: String) -> Bool {
        normalized(name) == normalized(newlyCollectedYamadoriName)
    }

    static func fertilizationModeTitle(forTreeStageName name: String) -> String? {
        fertilizerStage(forTreeStageName: name)?.title
    }

    private static func normalized(_ name: String) -> String {
        ReferencePreviewSeed.normalized(name)
    }
}
