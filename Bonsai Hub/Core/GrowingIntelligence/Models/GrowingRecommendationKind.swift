//
//  GrowingRecommendationKind.swift
//  Bonsai World
//
//  Future recommendation kinds produced by Growing Intelligence.
//  Kinds only — no recommendation logic, messaging, or scheduling yet.
//

import Foundation

/// Placeholder kinds for future Growing Intelligence outputs.
/// Engines will emit these; AI may later explain them — not generate them.
enum GrowingRecommendationKind: String, Codable, CaseIterable, Identifiable, Hashable, Sendable {
    case waterToday
    case delayWatering
    case fertilizeToday
    case delayFertilizing
    case recommendedFertilizer
    case recommendedPlacement
    case moveToGreenhouse
    case moveOutdoors
    case recoveryComplete
    case winterPreparation
    case frostWarning
    case heatWarning

    var id: Self { self }

    /// Human-facing label for future UI. Not used by engines yet.
    var title: String {
        switch self {
        case .waterToday: "Water Today"
        case .delayWatering: "Delay Watering"
        case .fertilizeToday: "Fertilize Today"
        case .delayFertilizing: "Delay Fertilizing"
        case .recommendedFertilizer: "Recommended Fertilizer"
        case .recommendedPlacement: "Recommended Placement"
        case .moveToGreenhouse: "Move to Greenhouse"
        case .moveOutdoors: "Move Outdoors"
        case .recoveryComplete: "Recovery Complete"
        case .winterPreparation: "Winter Preparation"
        case .frostWarning: "Frost Warning"
        case .heatWarning: "Heat Warning"
        }
    }
}

/// Future recommendation shell. Owns no Tree / Location / Weather copies.
struct GrowingRecommendation: Identifiable, Hashable, Sendable {
    var id: UUID
    var kind: GrowingRecommendationKind
    /// Tree this recommendation concerns (resolved from Tree SSOT).
    var treeID: UUID?
    /// Location context when relevant (resolved from Location SSOT).
    var locationID: UUID?
    /// Optional Reference Data link (e.g. fertilizer type) — future.
    var referenceID: UUID?

    init(
        id: UUID = UUID(),
        kind: GrowingRecommendationKind,
        treeID: UUID? = nil,
        locationID: UUID? = nil,
        referenceID: UUID? = nil
    ) {
        self.id = id
        self.kind = kind
        self.treeID = treeID
        self.locationID = locationID
        self.referenceID = referenceID
    }
}
