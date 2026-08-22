//
//  DashboardCards.swift
//  Bonsai World
//
//  Dashboard cards — Summary / Context / Next Action with placeholder content.
//

import SwiftUI

struct TodaysCareDashboardCard: View {
    var prominence: DashboardCardProminence = .primary
    /// Top-row cockpit pairing with Weather — equal height, tighter chrome.
    var cockpitAligned: Bool = false

    var body: some View {
        DashboardCard(
            id: .todaysCare,
            prominence: prominence,
            fillsRowHeight: cockpitAligned,
            compact: cockpitAligned
        ) {
            DashboardCardBodyStack(nextAction: DashboardPlaceholderData.todaysCareNextAction) {
                ForEach(DashboardPlaceholderData.todaysCare) { item in
                    DashboardMetricRow(
                        title: item.title,
                        value: "\(item.count)",
                        systemImage: item.systemImage,
                        isEmphasized: item.id == "critical",
                        compact: cockpitAligned
                    )
                }
            } context: {
                VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
                    DashboardCardSectionLabel(title: "Highest Priority")
                    DashboardCardBulletList(
                        items: DashboardPlaceholderData.todaysCareHighestPriority,
                        compact: cockpitAligned
                    )
                }
            }
        }
    }
}

struct AlertsDashboardCard: View {
    var prominence: DashboardCardProminence = .primary

    var body: some View {
        DashboardCard(id: .alerts, prominence: prominence) {
            DashboardCardBodyStack(nextAction: DashboardPlaceholderData.alertsNextAction) {
                ForEach(DashboardPlaceholderData.alerts) { item in
                    DashboardMetricRow(
                        title: item.title,
                        detail: item.detail,
                        systemImage: item.systemImage
                    )
                }
            } context: {
                VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
                    DashboardCardSectionLabel(title: "Needs Attention")
                    DashboardCardBulletList(items: DashboardPlaceholderData.alertsNeedsAttention)
                }
            }
        }
    }
}

struct UpcomingDashboardCard: View {
    var prominence: DashboardCardProminence = .primary

    var body: some View {
        DashboardCard(id: .upcoming, prominence: prominence) {
            DashboardCardBodyStack(nextAction: DashboardPlaceholderData.upcomingNextAction) {
                ForEach(DashboardPlaceholderData.upcoming) { bucket in
                    VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
                        DashboardMetricRow(
                            title: bucket.title,
                            value: "\(bucket.count)"
                        )
                        DashboardCardBulletList(items: bucket.examples, compact: true)
                    }
                    .padding(.bottom, FaloSpacing.xSmall)
                }
            } context: {
                EmptyView()
            }
        }
    }
}

struct CollectionOverviewDashboardCard: View {
    var prominence: DashboardCardProminence = .secondary

    var body: some View {
        DashboardCard(id: .collectionOverview, prominence: prominence) {
            DashboardCardBodyStack(nextAction: DashboardPlaceholderData.collectionOverviewNextAction) {
                ForEach(DashboardPlaceholderData.collectionOverviewGroups) { group in
                    VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
                        DashboardCardSectionLabel(title: group.title)
                        ForEach(group.rows) { stat in
                            DashboardSummaryRow(value: stat.value, label: stat.label)
                        }
                    }
                    .padding(.bottom, FaloSpacing.xSmall)
                }
            } context: {
                EmptyView()
            }
        }
    }
}

struct InventoryStatusDashboardCard: View {
    var prominence: DashboardCardProminence = .secondary

    var body: some View {
        DashboardCard(id: .inventoryStatus, prominence: prominence) {
            DashboardCardBodyStack(nextAction: DashboardPlaceholderData.inventoryNextAction) {
                ForEach(DashboardPlaceholderData.inventoryStatus) { item in
                    DashboardMetricRow(
                        title: item.name,
                        detail: item.status
                    )
                }
            } context: {
                EmptyView()
            }
        }
    }
}

struct RepottingDashboardCard: View {
    var prominence: DashboardCardProminence = .secondary

    var body: some View {
        DashboardCard(id: .repotting, prominence: prominence) {
            DashboardCardBodyStack(nextAction: DashboardPlaceholderData.repottingNextAction) {
                ForEach(DashboardPlaceholderData.repotting) { stat in
                    DashboardMetricRow(title: stat.label, value: stat.value)
                }
            } context: {
                VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
                    DashboardCardSectionLabel(title: "Context")
                    DashboardCardBulletList(items: DashboardPlaceholderData.repottingContext)
                }
            }
        }
    }
}

struct TreesAttentionDashboardCard: View {
    var prominence: DashboardCardProminence = .secondary

    var body: some View {
        DashboardCard(id: .treesRequiringAttention, prominence: prominence) {
            DashboardCardBodyStack(nextAction: DashboardPlaceholderData.treesAttentionNextAction) {
                ForEach(DashboardPlaceholderData.treesRequiringAttention) { item in
                    DashboardMetricRow(
                        title: item.treeName,
                        detail: "\(item.title) — \(item.detail)"
                    )
                }
            } context: {
                EmptyView()
            }
        }
    }
}

struct QuickStatisticsDashboardCard: View {
    var prominence: DashboardCardProminence = .secondary

    var body: some View {
        DashboardCard(id: .quickStatistics, prominence: prominence) {
            Text("Hidden from refined layout.")
                .font(FaloTypography.caption)
                .foregroundStyle(.secondary)
        }
    }
}
