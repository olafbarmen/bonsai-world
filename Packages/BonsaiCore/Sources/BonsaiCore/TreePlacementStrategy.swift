//
//  TreePlacementStrategy.swift
//  BonsaiCore
//
//  Whether a Tree moves with the seasons, or stays outdoors year-round.
//  Home / Winter Locations are stored on Tree; ``locationID`` is standing now
//  and follows Season for seasonal trees.
//

import Foundation

/// Year-round placement policy for a Tree.
enum TreePlacementStrategy: String, Codable, CaseIterable, Identifiable, Hashable, Sendable {
    /// Moves between Home (summer) and Winter Locations by season.
    case seasonal
    /// Stays at Home year-round — no Winter/Spring Care move reminders.
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
/// Drives ``Tree/locationID`` (standing now) from Home / Winter.
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
