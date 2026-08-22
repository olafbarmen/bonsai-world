//
//  WorkTypePreviewData.swift
//  Bonsai World
//
//  Professional default Work Types library (Reference Data → Work → Work Types).
//  Users may add unlimited custom types; there is no built-in vs custom split.
//

import Foundation

enum WorkTypePreviewData {
    private static func item(
        _ n: Int,
        _ name: String,
        _ category: WorkTypeCategory
    ) -> WorkType {
        WorkType(
            id: ReferencePreviewSeed.id(list: 14, n: n),
            name: name,
            category: category,
            sortOrder: n,
            behaviour: .default
        )
    }

    static let all: [WorkType] = {
        var n = 0
        func next(_ name: String, _ category: WorkTypeCategory) -> WorkType {
            n += 1
            return item(n, name, category)
        }

        return [
            // Maintenance
            next("Watering", .maintenance),
            next("Fertilizing", .maintenance),
            next("Repotting", .maintenance),
            next("Root Pruning", .maintenance),
            next("Branch Pruning", .maintenance),
            next("Wiring", .maintenance),
            next("Wire Removal", .maintenance),
            next("Defoliation", .maintenance),
            next("Partial Defoliation", .maintenance),
            next("Pinching", .maintenance),
            next("Candle Cutting", .maintenance),
            next("Needle Plucking", .maintenance),
            next("Bud Selection", .maintenance),
            next("Deadwood Work", .maintenance),
            next("Carving", .maintenance),
            next("Cleaning", .maintenance),
            next("Moss Maintenance", .maintenance),

            // Health
            next("Pest Inspection", .health),
            next("Disease Inspection", .health),
            next("Fungicide Treatment", .health),
            next("Insecticide Treatment", .health),
            next("Root Treatment", .health),
            next("Mycorrhiza Application", .health),
            next("Biostimulant Application", .health),

            // Seasonal
            next("Winter Preparation", .seasonal),
            next("Winter Wash", .seasonal),
            next("Move to Winter Storage", .seasonal),
            next("Return Outdoors", .seasonal),
            next("Frost Protection", .seasonal),
            next("Shade Installation", .seasonal),
            next("Shade Removal", .seasonal),
            next("Heat Protection", .seasonal),

            // Propagation
            next("Seed Sowing", .propagation),
            next("Stratification", .propagation),
            next("Scarification", .propagation),
            next("Cutting", .propagation),
            next("Air Layer", .propagation),
            next("Grafting", .propagation),
            next("Division", .propagation),
            next("Rooting", .propagation),

            // Styling
            next("Initial Styling", .styling),
            next("Restyling", .styling),
            next("Refinement", .styling),
            next("Exhibition Preparation", .styling),
            next("Photography Session", .styling),

            // Other
            next("Observation", .other),
            next("Measurement", .other),
            next("Valuation", .other),
            next("Collection Review", .other),
        ]
    }()
}
