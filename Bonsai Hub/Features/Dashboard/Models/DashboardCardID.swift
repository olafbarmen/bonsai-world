//
//  DashboardCardID.swift
//  Bonsai World
//
//  Dashboard Version 2 — stable card identities for layout and personalization.
//

import Foundation

/// Stable identity for each Dashboard card.
/// Order is owned by ``DashboardLayout`` — not by this enum’s case order alone.
enum DashboardCardID: String, CaseIterable, Identifiable, Hashable, Codable, Sendable {
    case todaysCare
    case alerts
    case collectionOverview
    case upcoming
    case inventoryStatus
    case repotting
    case treesRequiringAttention
    case weather
    case quickStatistics

    var id: Self { self }

    var title: String {
        switch self {
        case .todaysCare: "Today's Care"
        case .alerts: "Alerts"
        case .collectionOverview: "Collection Overview"
        case .upcoming: "Upcoming"
        case .inventoryStatus: "Inventory Status"
        case .repotting: "Repotting"
        case .treesRequiringAttention: "Trees Requiring Attention"
        case .weather: "Weather"
        case .quickStatistics: "Quick Statistics"
        }
    }

    var systemImage: String {
        switch self {
        case .todaysCare: "drop.fill"
        case .alerts: "bell.badge"
        case .collectionOverview: "leaf.circle"
        case .upcoming: "calendar"
        case .inventoryStatus: "shippingbox"
        case .repotting: "arrow.triangle.2.circlepath"
        case .treesRequiringAttention: "exclamationmark.triangle"
        case .weather: "cloud.sun"
        case .quickStatistics: "chart.bar"
        }
    }

    /// Future deep-link target (Architecture Version 2 module). Not wired yet.
    var futureDestinationHint: String {
        switch self {
        case .todaysCare: "Opens Care"
        case .alerts: "Opens Alerts"
        case .collectionOverview: "Opens Garden"
        case .upcoming: "Opens Workshop"
        case .inventoryStatus: "Opens Inventory"
        case .repotting: "Opens Workshop"
        case .treesRequiringAttention: "Opens Tree"
        case .weather: "Opens Locations"
        case .quickStatistics: "Opens Garden"
        }
    }
}
