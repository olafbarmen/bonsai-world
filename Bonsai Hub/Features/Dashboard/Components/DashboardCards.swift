//
//  DashboardCards.swift
//  Bonsai World
//
//  Dashboard cards that are not wired yet — heading stays, body marks the gap.
//  Live cards live in their own files (Tasks, Weather, Alerts, …).
//

import SwiftUI

struct TodaysCareDashboardCard: View {
    var prominence: DashboardCardProminence = .primary
    var cockpitAligned: Bool = false

    var body: some View {
        DashboardCard(
            id: .todaysCare,
            prominence: prominence,
            fillsRowHeight: cockpitAligned,
            compact: cockpitAligned
        ) {
            DashboardNoFunctionYet()
        }
    }
}

struct InventoryStatusDashboardCard: View {
    var prominence: DashboardCardProminence = .secondary

    var body: some View {
        DashboardCard(id: .inventoryStatus, prominence: prominence) {
            DashboardNoFunctionYet()
        }
    }
}

struct RepottingDashboardCard: View {
    var prominence: DashboardCardProminence = .secondary

    var body: some View {
        DashboardCard(id: .repotting, prominence: prominence) {
            DashboardNoFunctionYet()
        }
    }
}

struct QuickStatisticsDashboardCard: View {
    var prominence: DashboardCardProminence = .secondary

    var body: some View {
        DashboardCard(id: .quickStatistics, prominence: prominence) {
            DashboardNoFunctionYet()
        }
    }
}
