//
//  TreeStageLegacyCatalog.swift
//  Bonsai World
//
//  Legacy Tree Status / Development Stage names and stable IDs for migration.
//

import Foundation

enum TreeStageLegacyCatalog {
    /// Former Norwegian Tree Status values (list 8).
    private static let norwegianStatusNames = [
        "Frøplante",
        "Stikling",
        "Ungplante",
        "Prebonsai",
        "Under utvikling",
        "Bonsai",
        "Ferdig bonsai",
    ]

    /// Former English Development Stage values (list 20).
    private static let developmentStageNames = [
        "Seed",
        "Seedling",
        "Cutting",
        "Nursery Stock",
        "Yamadori",
        "Pre-Bonsai",
        "In Training",
        "Refinement",
        "Exhibition",
    ]

    static func legacyName(for id: UUID) -> String? {
        if let match = norwegianStatusNames.enumerated().first(where: {
            ReferencePreviewSeed.id(list: 8, n: $0.offset + 1) == id
        }) {
            return match.element
        }
        if let match = developmentStageNames.enumerated().first(where: {
            ReferencePreviewSeed.id(list: 20, n: $0.offset + 1) == id
        }) {
            return match.element
        }
        return nil
    }

    /// Maps legacy display names to canonical Tree Stage names.
    static func canonicalStageName(fromLegacyName name: String) -> String? {
        let trimmed = name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return nil }

        if let exact = TreeStagePreviewData.canonicalNames.first(where: {
            $0.caseInsensitiveCompare(trimmed) == .orderedSame
        }) {
            return exact
        }

        switch ReferencePreviewSeed.normalized(trimmed) {
        case "frøplante": return "Seedling"
        case "stikling": return "Cutting"
        case "ungplante": return "Nursery Stock"
        case "prebonsai", "pre-bonsai": return "Pre-Bonsai"
        case "under utvikling": return "In Training"
        case "bonsai": return "In Training"
        case "ferdig bonsai", "finished bonsai", "finished": return "Refinement"
        case "seed": return "Seedling"
        case "seedling": return "Seedling"
        case "cutting": return "Cutting"
        case "nursery stock": return "Nursery Stock"
        case "yamadori": return TreeStageFertilizerMapping.newlyCollectedYamadoriName
        case normalizedYamadoriNewlyCollected: return TreeStageFertilizerMapping.newlyCollectedYamadoriName
        case "in training": return "In Training"
        case "refinement": return "Refinement"
        case "exhibition": return "Exhibition"
        default:
            return nil
        }
    }

    /// Values that need grower review when migrating automatically.
    static func migrationNote(forLegacyName name: String) -> String? {
        switch ReferencePreviewSeed.normalized(name) {
        case "seed":
            return "Seed was mapped to Seedling. Ungerminated seed state is not tracked as a Tree Stage."
        case "ferdig bonsai", "finished bonsai", "finished", "exhibition":
            return nil
        default:
            return nil
        }
    }

    static func migratedStageID(from legacyID: UUID) -> UUID? {
        guard let legacyName = legacyName(for: legacyID),
              let canonical = canonicalStageName(fromLegacyName: legacyName)
        else { return nil }
        return TreeStagePreviewData.id(for: canonical)
    }

    private static var normalizedYamadoriNewlyCollected: String {
        ReferencePreviewSeed.normalized(TreeStageFertilizerMapping.newlyCollectedYamadoriName)
    }
}
