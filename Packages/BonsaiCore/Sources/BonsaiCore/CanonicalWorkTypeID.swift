//
//  CanonicalWorkTypeID.swift
//  Bonsai World
//
//  Stable Work Type UUIDs matching Mac Reference Data seeds
//  (`ReferencePreviewSeed.id(list: 14, n:)`). Display names are not identifiers.
//

import Foundation

enum CanonicalWorkTypeID {
    /// Same list index as `WorkTypePreviewData`.
    static let list = 14

    static func id(n: Int) -> UUID {
        UUID(uuidString: String(format: "10000000-0000-4000-8000-%02x%010d", list, n))!
    }

    static let watering = id(n: 1)
    static let fertilizing = id(n: 2)
    static let repotting = id(n: 3)
    static let branchPruning = id(n: 5)
    static let wiring = id(n: 6)
    static let pinching = id(n: 11)
    static let wireRemoval = id(n: 7)

    /// Display names in `WorkTypePreviewData` seed order. Identity is `id(n:)`, not the name.
    static let catalog: [Item] = names.enumerated().map { index, name in
        Item(id: id(n: index + 1), name: name)
    }

    static func name(for id: UUID) -> String {
        catalog.first { $0.id == id }?.name ?? "Work"
    }

    struct Item: Identifiable, Hashable, Sendable {
        var id: UUID
        var name: String
    }

    /// Exact `WorkTypePreviewData.all` name order (n = 1…50).
    private static let names: [String] = [
        "Watering",
        "Fertilizing",
        "Repotting",
        "Root Pruning",
        "Branch Pruning",
        "Wiring",
        "Wire Removal",
        "Defoliation",
        "Partial Defoliation",
        "Pinching",
        "Candle Cutting",
        "Needle Plucking",
        "Bud Selection",
        "Deadwood Work",
        "Carving",
        "Cleaning",
        "Moss Maintenance",
        "Pest Inspection",
        "Disease Inspection",
        "Fungicide Treatment",
        "Insecticide Treatment",
        "Root Treatment",
        "Mycorrhiza Application",
        "Biostimulant Application",
        "Winter Preparation",
        "Winter Wash",
        "Move to Winter Storage",
        "Return Outdoors",
        "Frost Protection",
        "Shade Installation",
        "Shade Removal",
        "Heat Protection",
        "Seed Sowing",
        "Stratification",
        "Scarification",
        "Cutting",
        "Air Layer",
        "Grafting",
        "Division",
        "Rooting",
        "Initial Styling",
        "Restyling",
        "Refinement",
        "Exhibition Preparation",
        "Photography Session",
        "Observation",
        "Measurement",
        "Valuation",
        "Collection Review",
        "Soil Stocktake",
    ]
}
