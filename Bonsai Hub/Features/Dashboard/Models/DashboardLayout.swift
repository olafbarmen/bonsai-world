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

    /// Active layout — top row Today's Care | Weather, then remaining cards.
    static let refined = DashboardLayout(
        cards: [
            DashboardCardPlacement(id: .todaysCare, prominence: .primary, isFavorite: true),
            DashboardCardPlacement(id: .weather, prominence: .primary),
            DashboardCardPlacement(id: .alerts, prominence: .primary, autoHideWhenEmpty: true),
            DashboardCardPlacement(id: .upcoming, prominence: .primary),
            DashboardCardPlacement(id: .collectionOverview, prominence: .secondary),
            DashboardCardPlacement(id: .inventoryStatus, prominence: .secondary, autoHideWhenEmpty: true),
            DashboardCardPlacement(id: .repotting, prominence: .secondary, autoHideWhenEmpty: true),
            DashboardCardPlacement(
                id: .treesRequiringAttention,
                prominence: .secondary,
                autoHideWhenEmpty: true
            ),
            DashboardCardPlacement(id: .quickStatistics, prominence: .secondary, isHidden: true)
        ]
    )

    /// Alias used by placeholder data.
    static let version2 = refined
}
