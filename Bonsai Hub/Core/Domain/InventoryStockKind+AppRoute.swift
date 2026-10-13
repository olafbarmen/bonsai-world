//
//  InventoryStockKind+AppRoute.swift
//  Bonsai World
//
//  Mac navigation bridge for inventory stock kinds.
//

import Foundation

extension InventoryStockKind {
    var appRoute: AppRoute {
        switch self {
        case .wire: .inventoryWire
        case .tool: .inventoryTools
        case .chemical: .inventoryChemicals
        case .consumable: .inventoryConsumables
        case .fertilizer: .inventoryFertilizers
        }
    }

    static func kind(for route: AppRoute) -> InventoryStockKind? {
        switch route {
        case .inventoryWire: .wire
        case .inventoryTools: .tool
        case .inventoryChemicals: .chemical
        case .inventoryConsumables: .consumable
        case .inventoryFertilizers: .fertilizer
        default: nil
        }
    }
}
