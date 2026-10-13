//
//  TreePlacementStrategy.swift
//  BonsaiCore
//
//  Whether a Tree moves with the seasons, or stays outdoors year-round.
//  Distinct from Location (where it stands now) and SeasonPlacement (summer/winter).
//

import Foundation

/// Year-round placement policy for a Tree.
enum TreePlacementStrategy: String, Codable, CaseIterable, Identifiable, Hashable, Sendable {
    /// Moves between summer and winter placements.
    case seasonal
    /// Stays outdoors all year — no Winter/Spring Care move reminders.
    case alwaysOutdoors

    var id: Self { self }

    var title: String {
        switch self {
        case .seasonal: "Seasonal — in / out by season"
        case .alwaysOutdoors: "Always outdoors"
        }
    }
}

/// Current season mode for a seasonal Tree (not used for Always outdoors reminders).
enum TreeSeasonPlacement: String, Codable, CaseIterable, Identifiable, Hashable, Sendable {
    case summer
    case winter

    var id: Self { self }

    var title: String {
        switch self {
        case .summer: "Summer placement"
        case .winter: "Winter placement"
        }
    }
}
