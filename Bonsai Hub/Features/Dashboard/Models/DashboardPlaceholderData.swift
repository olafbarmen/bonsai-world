//
//  DashboardPlaceholderData.swift
//  Bonsai World
//
//  Dashboard layout — static placeholder content only.
//  No live services, no business logic.
//

import Foundation

enum DashboardPlaceholderData {
    static let identity = DashboardIdentity.placeholder
    static let layout = DashboardLayout.refined

    // MARK: - Collection Summary Hero
    //
    // Live data — see ``DashboardCollectionSummary``. No placeholder numbers here.

    // MARK: - Today's Care

    struct CareItem: Identifiable, Hashable, Sendable {
        let id: String
        let title: String
        let count: Int
        let systemImage: String
    }

    static let todaysCare: [CareItem] = [
        CareItem(id: "water", title: "Trees to Water", count: 7, systemImage: "drop"),
        CareItem(id: "fertilize", title: "Trees to Fertilize", count: 3, systemImage: "leaf"),
        CareItem(id: "repot", title: "Trees to Repot", count: 2, systemImage: "arrow.triangle.2.circlepath"),
        CareItem(id: "move", title: "Trees to Move", count: 1, systemImage: "arrow.up.right.and.arrow.down.left"),
        CareItem(id: "critical", title: "Critical Tasks", count: 1, systemImage: "exclamationmark.circle")
    ]

    static let todaysCareHighestPriority: [String] = [
        "Japanese Maple 'Deshojo'",
        "Black Pine #3",
        "Trident Maple"
    ]

    static let todaysCareNextAction = "Repot Japanese Maple."

    // MARK: - Alerts

    struct AlertItem: Identifiable, Hashable, Sendable {
        let id: String
        let title: String
        let detail: String
        let systemImage: String
    }

    static let alerts: [AlertItem] = [
        AlertItem(id: "heat", title: "Heat Warning", detail: "Protect exposed benches this afternoon", systemImage: "thermometer.sun"),
        AlertItem(id: "frost", title: "Frost Warning", detail: "Move tender trees tonight", systemImage: "snowflake"),
        AlertItem(id: "inventory", title: "Inventory Low", detail: "Reorder Akadama before weekend work", systemImage: "shippingbox")
    ]

    static let alertsNeedsAttention: [String] = [
        "Two trees missing photos.",
        "One tree missing cultivar.",
        "One overdue inspection."
    ]

    static let alertsNextAction = "Complete photo and cultivar records for trees marked incomplete."

    // MARK: - Collection Overview

    struct OverviewGroup: Identifiable, Hashable, Sendable {
        let id: String
        let title: String
        let rows: [OverviewStat]
    }

    struct OverviewStat: Identifiable, Hashable, Sendable {
        let id: String
        let label: String
        let value: String
    }

    static let collectionOverviewGroups: [OverviewGroup] = [
        OverviewGroup(
            id: "collection",
            title: "Collection",
            rows: [
                OverviewStat(id: "total", label: "Trees", value: "150"),
                OverviewStat(id: "species", label: "Species", value: "42")
            ]
        ),
        OverviewGroup(
            id: "development",
            title: "Development",
            rows: [
                OverviewStat(id: "finished", label: "Finished Bonsai", value: "36"),
                OverviewStat(id: "inDev", label: "In Development", value: "54"),
                OverviewStat(id: "yamadori", label: "Yamadori", value: "22")
            ]
        )
    ]

    static let collectionOverviewNextAction = "Review Development trees that may be ready for refinement."

    // MARK: - Upcoming

    struct UpcomingBucket: Identifiable, Hashable, Sendable {
        let id: String
        let title: String
        let count: Int
        let examples: [String]
    }

    static let upcoming: [UpcomingBucket] = [
        UpcomingBucket(
            id: "today",
            title: "Today",
            count: 4,
            examples: [
                "Water maple group",
                "Check wiring on juniper",
                "Move tender trees before evening"
            ]
        ),
        UpcomingBucket(
            id: "7",
            title: "Next 7 Days",
            count: 9,
            examples: [
                "Fertilize deciduous",
                "Inspect copper wire",
                "Clean benches after rain"
            ]
        ),
        UpcomingBucket(
            id: "30",
            title: "Next 30 Days",
            count: 15,
            examples: [
                "Repot three pines",
                "Review winter protection",
                "Plan autumn defoliation"
            ]
        )
    ]

    static let upcomingNextAction = "Start with today’s maple watering before heat builds."

    // MARK: - Inventory Status

    struct InventoryItem: Identifiable, Hashable, Sendable {
        let id: String
        let name: String
        let status: String
    }

    static let inventoryStatus: [InventoryItem] = [
        InventoryItem(id: "akadama", name: "Akadama", status: "Reorder Soon"),
        InventoryItem(id: "biogold", name: "BioGold", status: "Running Low"),
        InventoryItem(id: "wire", name: "Wire 2.0 mm", status: "Running Low"),
        InventoryItem(id: "mesh", name: "Mesh", status: "Enough Stock")
    ]

    static let inventoryNextAction = "Reorder Akadama before the next repotting session."

    // MARK: - Repotting

    struct RepottingStat: Identifiable, Hashable, Sendable {
        let id: String
        let label: String
        let value: String
    }

    static let repotting: [RepottingStat] = [
        RepottingStat(id: "due", label: "Trees Due", value: "5"),
        RepottingStat(id: "overdue", label: "Trees Overdue", value: "2"),
        RepottingStat(id: "recent", label: "Recently Repotted", value: "4")
    ]

    static let repottingContext: [String] = [
        "Black Pine #3 is overdue.",
        "Two deciduous trees are due this month."
    ]

    static let repottingNextAction = "Schedule overdue Black Pine #3 for the next cool morning."

    // MARK: - Trees Requiring Attention

    struct AttentionItem: Identifiable, Hashable, Sendable {
        let id: String
        let title: String
        let detail: String
        let treeName: String
    }

    static let treesRequiringAttention: [AttentionItem] = [
        AttentionItem(
            id: "wire",
            title: "Wire Inspection",
            detail: "Check bite on primary branch",
            treeName: "Dragon Maple"
        ),
        AttentionItem(
            id: "weak",
            title: "Weak Tree",
            detail: "Reduced vigour this week",
            treeName: "Coast Juniper"
        ),
        AttentionItem(
            id: "health",
            title: "Health Watch",
            detail: "Possible pest pressure",
            treeName: "Olive Cascade"
        )
    ]

    static let treesAttentionNextAction = "Inspect Dragon Maple wiring before it bites in."

    // MARK: - Weather
    //
    // Live data — see ``WeatherService`` and ``WeatherRiskAssessment``. No placeholder numbers here.
}
