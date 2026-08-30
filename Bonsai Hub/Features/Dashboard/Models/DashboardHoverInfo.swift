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
                lines: ["Replaced by the Tasks card.", "No function yet."]
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
                title: "Upcoming",
                lines: [
                    "This Week / Month / Year / Next Year",
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
                title: "Inventory Status",
                lines: ["No function yet.", "Needs Inventory 2.0"]
            )
        case .repotting:
            DashboardHoverInfo(
                title: "Repotting",
                lines: ["No function yet.", "Repot due will come from Tasks / Work Types"]
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
                title: "Quick statistics",
                lines: ["No function yet."]
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
        case .recentWork:
            DashboardHoverInfo(
                title: "Recent Work",
                lines: [
                    "Latest Work records from the library",
                    "Tap opens the Tree"
                ]
            )
        }
    }
}
