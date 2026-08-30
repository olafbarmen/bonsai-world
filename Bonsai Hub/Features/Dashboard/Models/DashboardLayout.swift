//
//  DashboardLayout.swift
//  Bonsai World
//
//  Dashboard layout — ordered placements for the daily workspace grid.
//  Prepared for drag & drop, hide, favorite, and resize — not implemented yet.
//

import Foundation

/// Visual weight of a Dashboard card.
enum DashboardCardProminence: String, Codable, Hashable, Sendable {
    case primary
    case secondary
}

/// One card’s place in the Dashboard layout.
struct DashboardCardPlacement: Identifiable, Hashable, Codable, Sendable {
    var id: DashboardCardID
    var prominence: DashboardCardProminence
    var isHidden: Bool
    var isFavorite: Bool
    var relativeSize: Double
    var autoHideWhenEmpty: Bool

    init(
        id: DashboardCardID,
        prominence: DashboardCardProminence,
        isHidden: Bool = false,
        isFavorite: Bool = false,
        relativeSize: Double = 1.0,
        autoHideWhenEmpty: Bool = true
    ) {
        self.id = id
        self.prominence = prominence
        self.isHidden = isHidden
        self.isFavorite = isFavorite
        self.relativeSize = relativeSize
        self.autoHideWhenEmpty = autoHideWhenEmpty
    }
}

/// Owns Dashboard card order and personalization metadata.
struct DashboardLayout: Hashable, Codable, Sendable {
    var cards: [DashboardCardPlacement]

    var visibleCards: [DashboardCardPlacement] {
        cards.filter { !$0.isHidden }
    }

    /// Active layout — live cards first, then headings kept for unwired modules.
    static let refined = DashboardLayout(
        cards: [
            DashboardCardPlacement(id: .tasks, prominence: .primary, isFavorite: true),
            DashboardCardPlacement(id: .weather, prominence: .primary),
            DashboardCardPlacement(id: .alerts, prominence: .primary),
            DashboardCardPlacement(id: .upcoming, prominence: .primary),
            DashboardCardPlacement(id: .treesRequiringAttention, prominence: .secondary),
            DashboardCardPlacement(id: .library, prominence: .secondary),
            DashboardCardPlacement(id: .recentWork, prominence: .secondary),
            DashboardCardPlacement(id: .collectionOverview, prominence: .secondary),
            DashboardCardPlacement(id: .inventoryStatus, prominence: .secondary),
            DashboardCardPlacement(id: .repotting, prominence: .secondary),
            DashboardCardPlacement(id: .quickStatistics, prominence: .secondary),
            DashboardCardPlacement(id: .todaysCare, prominence: .primary, isHidden: true)
        ]
    )

    /// Alias used by placeholder data.
    static let version2 = refined
}
