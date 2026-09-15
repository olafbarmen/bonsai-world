//
//  DashboardCards.swift
//  Bonsai World
//
//  Compatibility aliases for older Dashboard layout catalogs.
//  Live cards live in their own files.
//

import SwiftUI

/// Alias — live Dashboard uses ``InventoryAlertsDashboardCard``.
struct InventoryStatusDashboardCard: View {
    var prominence: DashboardCardProminence = .secondary
    var fillsRowHeight: Bool = false

    var body: some View {
        InventoryAlertsDashboardCard(prominence: prominence, fillsRowHeight: fillsRowHeight)
    }
}
