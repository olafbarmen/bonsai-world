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
                title: "Affected trees",
                lines: [
                    "Dragon Maple — Water",
                    "Coast Juniper — Water",
                    "Black Pine #3 — Fertilize",
                    "Olive Cascade — Repot",
                    "Trident Maple — Move"
                ]
            )
        case .alerts:
            DashboardHoverInfo(
                title: "Alert details",
                lines: [
                    "Heat Warning — afternoon peak",
                    "Frost Warning — overnight low",
                    "Inventory Low — Akadama"
                ]
            )
        case .upcoming:
            DashboardHoverInfo(
                title: "Next work",
                lines: [
                    "Today — Water maple group",
                    "This week — Fertilize deciduous",
                    "This month — Repot three pines"
                ]
            )
        case .collectionOverview:
            DashboardHoverInfo(
                title: "Collection summary",
                lines: [
                    "150 trees across 42 species",
                    "36 finished · 54 in development",
                    "22 yamadori"
                ]
            )
        case .inventoryStatus:
            DashboardHoverInfo(
                title: "Products running low",
                lines: [
                    "Akadama — reorder soon",
                    "BioGold — about two weeks left",
                    "Wire 2.0 mm — running low",
                    "Mesh — running low"
                ]
            )
        case .repotting:
            DashboardHoverInfo(
                title: "Trees due for repotting",
                lines: [
                    "Black Pine #3 — overdue",
                    "Scots Pine — due this month",
                    "Trident Maple — due this month"
                ]
            )
        case .treesRequiringAttention:
            DashboardHoverInfo(
                title: "Trees to check",
                lines: [
                    "Dragon Maple — wire inspection",
                    "Coast Juniper — weak vigour",
                    "Olive Cascade — health watch"
                ]
            )
        case .weather:
            DashboardHoverInfo(
                title: "Bonsai weather support",
                lines: [
                    "Garden — My Garden (placeholder)",
                    "Today vs Tomorrow comparison",
                    "Risk — Normal (placeholder)",
                    "Seven-day planning strip"
                ]
            )
        case .quickStatistics:
            DashboardHoverInfo(
                title: "Quick statistics",
                lines: [
                    "Average tree age — 14 years",
                    "New trees this year — 6"
                ]
            )
        }
    }
}
