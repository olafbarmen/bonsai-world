//
//  DashboardPlaceholderData.swift
//  Bonsai World
//
//  Dashboard layout — static placeholder content only.
//  No live services, no business logic.
//

import Foundation
import SwiftUI

enum DashboardPlaceholderData {
    static let identity = DashboardIdentity.placeholder
    static let layout = DashboardLayout.refined

    // MARK: - Collection Summary Hero

    struct HeroMetric: Identifiable, Hashable, Sendable {
        let id: String
        let label: String
        let value: String
    }

    struct HeroListItem: Identifiable, Hashable, Sendable {
        let id: String
        let title: String
        var detail: String? = nil
    }

    /// Column 1 — overall collection counts (future: TreeService aggregates).
    static let heroCollection: [HeroMetric] = [
        HeroMetric(id: "total", label: "Trees", value: "150"),
        HeroMetric(id: "finished", label: "Finished Bonsai", value: "36"),
        HeroMetric(id: "development", label: "Development Trees", value: "54"),
        HeroMetric(id: "yamadori", label: "Yamadori", value: "22")
    ]

    /// Dominant Species list with counts (future: botanical frequency from Trees).
    static let heroSpecies: [HeroListItem] = [
        HeroListItem(id: "acer", title: "Acer palmatum", detail: "34"),
        HeroListItem(id: "juniper", title: "Juniper", detail: "22"),
        HeroListItem(id: "larch", title: "Larch", detail: "18"),
        HeroListItem(id: "pine", title: "Pine", detail: "16"),
        HeroListItem(id: "beech", title: "Beech", detail: "12"),
        HeroListItem(id: "spruce", title: "Spruce", detail: "10"),
        HeroListItem(id: "azalea", title: "Azalea", detail: "8"),
        HeroListItem(id: "elm", title: "Elm", detail: "6"),
        HeroListItem(id: "hornbeam", title: "Hornbeam", detail: "5"),
        HeroListItem(id: "cotoneaster", title: "Cotoneaster", detail: "4"),
        HeroListItem(id: "olive", title: "Olive", detail: "3"),
        HeroListItem(id: "boxwood", title: "Boxwood", detail: "3"),
        HeroListItem(id: "oak", title: "Oak", detail: "2"),
        HeroListItem(id: "yew", title: "Yew", detail: "2")
    ]

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

    /// Future: selected Garden. Placeholder display name only.
    static let weatherGardenName = "My Garden"

    struct WeatherComparisonRow: Identifiable, Hashable, Sendable {
        let id: String
        let label: String
        let todayValue: String
        let tomorrowValue: String
        /// Placeholder Bonsai status color — not calculated.
        let todayStatus: WeatherParameterStatusPlaceholder
        /// Placeholder Bonsai status color — not calculated.
        let tomorrowStatus: WeatherParameterStatusPlaceholder
    }

    /// Design-only status dots for weather parameters. Future: derived from weather, species, garden, stage.
    enum WeatherParameterStatusPlaceholder: String, Hashable, Sendable {
        case normal
        case watch
        case caution
        case critical

        var color: Color {
            switch self {
            case .normal: Color.green
            case .watch: Color.yellow
            case .caution: Color.orange
            case .critical: Color.red
            }
        }
    }

    /// Shared short labels; Today / Tomorrow values side by side.
    static let weatherComparisonRows: [WeatherComparisonRow] = [
        WeatherComparisonRow(
            id: "temp",
            label: "Temp",
            todayValue: "18°",
            tomorrowValue: "16°",
            todayStatus: .normal,
            tomorrowStatus: .normal
        ),
        WeatherComparisonRow(
            id: "rain",
            label: "Rain",
            todayValue: "40%",
            tomorrowValue: "70%",
            todayStatus: .watch,
            tomorrowStatus: .caution
        ),
        WeatherComparisonRow(
            id: "wind",
            label: "Wind",
            todayValue: "12 km/h",
            tomorrowValue: "18 km/h",
            todayStatus: .normal,
            tomorrowStatus: .watch
        ),
        WeatherComparisonRow(
            id: "humidity",
            label: "Humidity",
            todayValue: "62%",
            tomorrowValue: "74%",
            todayStatus: .normal,
            tomorrowStatus: .normal
        ),
        WeatherComparisonRow(
            id: "uv",
            label: "UV",
            todayValue: "Moderate",
            tomorrowValue: "Low",
            todayStatus: .watch,
            tomorrowStatus: .normal
        )
    ]

    /// Placeholder Bonsai-facing risks for today. Empty → show calm empty copy.
    static let todaysBonsaiRisks: [String] = [
        "Heavy rain may wash fertilizer away.",
        "Afternoon sun may require additional watering."
    ]

    static let todaysBonsaiRisksEmptyMessage = "No significant Bonsai weather risks today."

    static let weatherNextAction = "Water exposed benches after the afternoon sun peak."

    struct WeatherWeekDay: Identifiable, Hashable, Sendable {
        let id: String
        let weekday: String
        let systemImage: String
        let temperature: String
    }

    /// Compact seven-day planning strip — day, icon, temperature only.
    static let weatherWeek: [WeatherWeekDay] = [
        WeatherWeekDay(id: "mon", weekday: "Mon", systemImage: "sun.max", temperature: "18°"),
        WeatherWeekDay(id: "tue", weekday: "Tue", systemImage: "cloud.sun", temperature: "17°"),
        WeatherWeekDay(id: "wed", weekday: "Wed", systemImage: "cloud.rain", temperature: "15°"),
        WeatherWeekDay(id: "thu", weekday: "Thu", systemImage: "sun.max", temperature: "19°"),
        WeatherWeekDay(id: "fri", weekday: "Fri", systemImage: "cloud.bolt", temperature: "14°"),
        WeatherWeekDay(id: "sat", weekday: "Sat", systemImage: "cloud.sun.fill", temperature: "16°"),
        WeatherWeekDay(id: "sun", weekday: "Sun", systemImage: "cloud", temperature: "15°")
    ]
}
