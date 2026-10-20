//
//  DashboardHoverInfo.swift
//  Bonsai World
//
//  Dashboard layout — hover-only supplementary information.
//  Hover never navigates and never opens modules.
//

import Foundation

/// Placeholder hover copy for a Dashboard card.
struct DashboardHoverInfo: Hashable, Sendable {
    var title: String
    var lines: [String]

    var helpText: String {
        ([title] + lines.map { "• \($0)" }).joined(separator: "\n")
    }
}

extension DashboardPlaceholderData {
    static func hoverInfo(for id: DashboardCardID) -> DashboardHoverInfo {
        switch id {
        case .todaysCare:
            DashboardHoverInfo(
                title: "Today’s Care",
                lines: ["Replaced by the Tasks card.", "Hidden from the live Dashboard."]
            )
        case .alerts:
            DashboardHoverInfo(
                title: "Alerts",
                lines: [
                    "Overdue opens Tasks → Overdue",
                    "Weather risks open Locations → Map"
                ]
            )
        case .upcoming:
            DashboardHoverInfo(
                title: "Upcoming Tasks",
                lines: [
                    "Tasks This Week / Month / Year / Next Year",
                    "Today lives on the Tasks card",
                    "Tap a row to open that Tasks horizon"
                ]
            )
        case .collectionOverview:
            DashboardHoverInfo(
                title: "Collections",
                lines: [
                    "Named Collections with member counts",
                    "Library totals live on My Trees",
                    "Tap opens the Collection"
                ]
            )
        case .inventoryStatus:
            DashboardHoverInfo(
                title: "Inventory Alerts",
                lines: [
                    "Low stock across Soil, Wire, Tools, Chemicals, Consumables, Fertilizers",
                    "Same Low rule as each Inventory stock list",
                    "Tap opens the stock item"
                ]
            )
        case .repotting:
            DashboardHoverInfo(
                title: "Repotting",
                lines: [
                    "Repotting Tasks overdue through This Month",
                    "Same rule as Needs Repotting",
                    "Overdue opens Tasks → Overdue",
                    "This Month opens Tasks → This Month"
                ]
            )
        case .treesRequiringAttention:
            DashboardHoverInfo(
                title: "Trees to check",
                lines: [
                    "Health: Needs Attention or Recovering",
                    "Tap opens Tree Detail"
                ]
            )
        case .weather:
            DashboardHoverInfo(
                title: "Bonsai weather support",
                lines: [
                    "Live forecast for the default Garden",
                    "Today vs Tomorrow comparison",
                    "Bonsai-specific risk flags (heat, frost, rain, wind, UV)",
                    "Seven-day planning strip"
                ]
            )
        case .quickStatistics:
            DashboardHoverInfo(
                title: "Quick Statistics",
                lines: [
                    "Same counts as the Stat Strip",
                    "My Trees, Development Trees, Yamadori, Tasks Today",
                    "Tap opens the matching destination"
                ]
            )
        case .careCalendar:
            DashboardHoverInfo(
                title: "Care Calendar",
                lines: [
                    "This month on the default Garden",
                    "Tap opens Care Calendar"
                ]
            )
        case .tasks:
            DashboardHoverInfo(
                title: "Today’s care",
                lines: [
                    "Overdue opens Tasks → Overdue",
                    "Today’s rows open Tasks → Today",
                    "Watering is one count, not one row per tree",
                    "Complete lives in Tasks, not here"
                ]
            )
        case .library:
            DashboardHoverInfo(
                title: "Library records",
                lines: [
                    "Trees missing photo, status, or species",
                    "Tap opens Garden → Trees"
                ]
            )
        case .knowledge:
            DashboardHoverInfo(
                title: "Knowledge",
                lines: [
                    "Species Library, Bonsai Handbook, Fertilizer Guides",
                    "Tap opens the Knowledge destination"
                ]
            )
        case .recentWork:
            DashboardHoverInfo(
                title: "Recent Work",
                lines: [
                    "Latest Work records from the library",
                    "Tap opens the Tree"
                ]
            )
        case .shapingInProgress:
            DashboardHoverInfo(
                title: "In Progress",
                lines: [
                    "Shaping areas marked In Progress",
                    "Tap opens Shaping"
                ]
            )
        }
    }
}
