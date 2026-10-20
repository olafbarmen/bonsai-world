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
    /// Live Tasks orientation — overdue + today.
    case tasks
    /// This month's Care Calendar reading for the default Garden.
    case careCalendar
    /// Live library record gaps (photo, status, species).
    case library
    /// Knowledge module entry points (Handbook, Species, Fertilizer, Soil, …).
    case knowledge
    /// Live recent Work history.
    case recentWork
    /// Shaping areas marked In Progress.
    case shapingInProgress

    var id: Self { self }

    var title: String {
        switch self {
        case .todaysCare: "Today's Care"
        case .alerts: "Alerts"
        case .collectionOverview: "Collection Overview"
        case .upcoming: "Upcoming Tasks"
        case .inventoryStatus: "Inventory Alerts"
        case .repotting: "Repotting"
        case .treesRequiringAttention: "Trees Requiring Attention"
        case .weather: "Weather"
        case .quickStatistics: "Quick Statistics"
        case .tasks: "Tasks"
        case .careCalendar: "Care Calendar"
        case .library: "Library"
        case .knowledge: "Knowledge"
        case .recentWork: "Recent Work"
        case .shapingInProgress: "In Progress"
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
        case .tasks: "checklist"
        case .careCalendar: "calendar"
        case .library: "books.vertical"
        case .knowledge: "book"
        case .recentWork: "clock.arrow.circlepath"
        case .shapingInProgress: "pencil.and.outline"
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
        case .tasks: "Opens Tasks"
        case .careCalendar: "Opens Care Calendar"
        case .library: "Opens Garden"
        case .knowledge: "Opens Knowledge"
        case .recentWork: "Opens Tree"
        case .shapingInProgress: "Opens Shaping"
        }
    }
}
