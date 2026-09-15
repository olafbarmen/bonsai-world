//
//  SpeciesStratificationProfile.swift
//  Bonsai World
//
//  Authoritative seed stratification profile — range-based, sequence-aware.
//  Single source of truth via SeedStratificationCatalogService.
//

import Foundation

struct SpeciesStratificationProfile: Identifiable, Codable, Hashable, Sendable {
    /// Links to Botanical Library ``Species/id`` when the binomial exists there;
    /// otherwise a stable stratification-catalog UUID for the scientific name.
    var id: UUID { speciesID }
    var speciesID: UUID
    var genus: String
    var species: String
    var commonName: String
    var bonsaiRelevance: String

    var dormancyType: DormancyType
    var treatmentRequired: Bool
    var scarificationRequired: Bool
    var soakingRequired: Bool

    /// Summary treatment type for lists and compact UI.
    var treatmentType: StratificationTreatmentType
    /// Ordered phases (warm → cold → germination, etc.).
    var treatmentSequence: [StratificationTreatmentStep]
    /// Alternative protocols when literature describes more than one path.
    var alternativeTreatmentNotes: String

    var moistureRequirement: MoistureLevel
    var germinationTemperatureMin: Double?
    var germinationTemperatureMax: Double?
    var sowingDepthGuidance: String
    var monitoringNotes: String
    var whyThisTreatment: String

    var difficulty: StratificationDifficulty
    var confidenceLevel: StratificationConfidenceLevel
    var sources: [StratificationSource]
    var notes: String

    var scientificName: String {
        let g = genus.trimmingCharacters(in: .whitespacesAndNewlines)
        let s = species.trimmingCharacters(in: .whitespacesAndNewlines)
        if g.isEmpty { return s }
        if s.isEmpty { return g }
        return "\(g) \(s)"
    }

    var searchText: String {
        [scientificName, commonName, genus, treatmentType.title, confidenceLevel.title]
            .joined(separator: " ")
            .lowercased()
    }

    var orderedSequence: [StratificationTreatmentStep] {
        treatmentSequence.sorted { $0.order < $1.order }
    }

    func firstStep(of type: StratificationPhaseType) -> StratificationTreatmentStep? {
        orderedSequence.first { $0.type == type }
    }

    var coldStep: StratificationTreatmentStep? { firstStep(of: .coldStratification) }
    var warmStep: StratificationTreatmentStep? { firstStep(of: .warmStratification) }

    static func durationRangeLabel(minDays: Int?, maxDays: Int?) -> String? {
        switch (minDays, maxDays) {
        case let (min?, max?) where min == max:
            return "\(min) days"
        case let (min?, max?):
            return "\(min)–\(max) days"
        case let (min?, nil):
            return "from \(min) days"
        case let (nil, max?):
            return "up to \(max) days"
        default:
            return nil
        }
    }

    static func temperatureRangeLabel(min: Double?, max: Double?) -> String? {
        switch (min, max) {
        case let (lo?, hi?) where lo == hi:
            return String(format: "%.0f °C", lo)
        case let (lo?, hi?):
            return String(format: "%.0f–%.0f °C", lo, hi)
        case let (lo?, nil):
            return String(format: "from %.0f °C", lo)
        case let (nil, hi?):
            return String(format: "up to %.0f °C", hi)
        default:
            return nil
        }
    }

    static func suggestedMidpointDays(minDays: Int?, maxDays: Int?) -> Int? {
        guard let minDays, let maxDays, maxDays >= minDays else { return nil }
        return (minDays + maxDays) / 2
    }
}
