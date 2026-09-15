//
//  WorkTypePreviewData.swift
//  Bonsai World
//
//  Professional default Work Types library (Reference Data → Work → Work Types).
//  Users may add unlimited custom types; there is no built-in vs custom split.
//
//  Seed IDs use sequential `n` — keep call order stable so existing Work / Task
//  records keep resolving the same Work Type UUIDs.
//

import Foundation

enum WorkTypePreviewData {
    private static func item(
        _ n: Int,
        _ name: String,
        _ category: WorkTypeCategory,
        behaviour: WorkTypeBehaviourFlags = .default
    ) -> WorkType {
        WorkType(
            id: ReferencePreviewSeed.id(list: 14, n: n),
            name: name,
            category: category,
            sortOrder: n,
            behaviour: behaviour
        )
    }

    private static var requiresFertilizer: WorkTypeBehaviourFlags {
        var flags = WorkTypeBehaviourFlags.default
        flags.requiresFertilizer = true
        return flags
    }

    /// Routine, high-frequency care (Blueprint §5.9 "Tasks vs. Work"): completing a Task
    /// of this Work Type is a single click, no form.
    private static var tasksCompleteInstantly: WorkTypeBehaviourFlags {
        var flags = WorkTypeBehaviourFlags.default
        flags.tasksCompleteInstantly = true
        flags.expiresIfMissed = true
        return flags
    }

    static let all: [WorkType] = {
        var n = 0
        func next(
            _ name: String,
            _ category: WorkTypeCategory,
            behaviour: WorkTypeBehaviourFlags = .default
        ) -> WorkType {
            n += 1
            return item(n, name, category, behaviour: behaviour)
        }

        return [
            // n = 1…17 — categories updated; order frozen for stable seed IDs
            next("Watering", .maintenance, behaviour: tasksCompleteInstantly),
            next("Fertilizing", .maintenance, behaviour: requiresFertilizer),
            next("Repotting", .maintenance),
            next("Root Pruning", .maintenance),
            next("Branch Pruning", .shaping),
            next("Wiring", .shaping),
            next("Wire Removal", .shaping),
            next("Defoliation", .shaping),
            next("Partial Defoliation", .shaping),
            next("Pinching", .shaping),
            next("Candle Cutting", .shaping),
            next("Needle Plucking", .shaping),
            next("Bud Selection", .shaping),
            next("Deadwood Work", .shaping),
            next("Carving", .shaping),
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

            // Propagation — Grafting moved to Shaping (same seed n as before)
            next("Seed Sowing", .propagation),
            next("Stratification", .propagation),
            next("Scarification", .propagation),
            next("Cutting", .propagation),
            next("Air Layer", .propagation),
            next("Grafting", .shaping),
            next("Division", .propagation),
            next("Rooting", .propagation),

            // Styling — preparation / presentation
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
            next("Soil Stocktake", .other, behaviour: {
                var flags = WorkTypeBehaviourFlags.default
                flags.affectsInventory = true
                flags.createsTreeHistory = false
                return flags
            }()),
        ]
    }()
}
