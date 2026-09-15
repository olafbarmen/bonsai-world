//
//  InventoryAlertsDashboardCard.swift
//  Bonsai World
//
//  Dashboard Inventory Alerts — low stock across Soil and Wire / Tools /
//  Chemicals / Consumables / Fertilizers. Tap opens the matching stock line.
//

import SwiftUI

struct InventoryAlertsDashboardCard: View {
    var prominence: DashboardCardProminence = .secondary
    var fillsRowHeight: Bool = false

    @Environment(SoilStockService.self) private var soilStock
    @Environment(InventoryStockService.self) private var inventoryStock
    @Environment(ReferenceDataService.self) private var referenceData
    @Environment(AppState.self) private var appState

    private let rowLimit = 8

    private var alerts: [InventoryDashboardAlert] {
        (soilAlerts + stockAlerts).sorted {
            $0.sortName.localizedCaseInsensitiveCompare($1.sortName) == .orderedAscending
        }
    }

    private var soilAlerts: [InventoryDashboardAlert] {
        soilStock.items
            .filter(\.isLowStock)
            .map { item in
                let name = referenceData.soilComponent(id: item.componentID)?.name ?? "Unknown material"
                return InventoryDashboardAlert(
                    sortName: name,
                    title: name,
                    value: item.stockStatusTitle,
                    detail: "Soil · \(SoilVolumeFormat.liters(item.estimatedVolumeLiters))",
                    systemImage: StockReportArea.soil.systemImage,
                    destination: .soil(itemID: item.id)
                )
            }
    }

    private var stockAlerts: [InventoryDashboardAlert] {
        inventoryStock.items
            .filter(\.isLowStock)
            .map { item in
                let name = InventoryStockPresentation.title(for: item, referenceData: referenceData)
                let area = stockReportArea(for: item.kind)
                return InventoryDashboardAlert(
                    sortName: "\(area.title) \(name)",
                    title: name,
                    value: item.stockStatusTitle,
                    detail: "\(area.title) · \(item.quantitySummary)",
                    systemImage: item.kind.systemImage,
                    destination: .inventoryStock(kind: item.kind, itemID: item.id)
                )
            }
    }

    var body: some View {
        DashboardCard(
            id: .inventoryStatus,
            prominence: prominence,
            fillsRowHeight: fillsRowHeight,
            compact: true,
            titleOverride: "Inventory Alerts"
        ) {
            if alerts.isEmpty {
                DashboardEmptyMessage(text: "No inventory alerts")
            } else {
                VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
                    ForEach(alerts.prefix(rowLimit)) { alert in
                        DashboardCardTapButton {
                            open(alert)
                        } label: {
                            DashboardMetricRow(
                                title: alert.title,
                                value: alert.value,
                                detail: alert.detail,
                                systemImage: alert.systemImage,
                                compact: true
                            )
                        }
                    }

                    let extra = alerts.count - rowLimit
                    if extra > 0 {
                        Text("\(extra) more in Inventory")
                            .font(FaloTypography.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
    }

    private func stockReportArea(for kind: InventoryStockKind) -> StockReportArea {
        switch kind {
        case .wire: .wire
        case .tool: .tools
        case .chemical: .chemicals
        case .consumable: .consumables
        case .fertilizer: .fertilizers
        }
    }

    private func open(_ alert: InventoryDashboardAlert) {
        switch alert.destination {
        case .soil(let itemID):
            appState.selectSection(.inventorySoil)
            appState.selectedSoilWorkspaceTab = .stock
            appState.selectedSoilStockID = itemID
            appState.selectedInventoryStockID = nil
        case .inventoryStock(let kind, let itemID):
            appState.selectSection(kind.appRoute)
            appState.selectedInventoryStockID = itemID
        }
    }
}

private struct InventoryDashboardAlert: Identifiable {
    enum Destination {
        case soil(itemID: UUID)
        case inventoryStock(kind: InventoryStockKind, itemID: UUID)
    }

    var id: String {
        switch destination {
        case .soil(let itemID):
            "soil-\(itemID.uuidString)"
        case .inventoryStock(let kind, let itemID):
            "\(kind.rawValue)-\(itemID.uuidString)"
        }
    }

    var sortName: String
    var title: String
    var value: String
    var detail: String
    var systemImage: String
    var destination: Destination
}
