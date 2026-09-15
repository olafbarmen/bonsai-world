//
//  InventoryStockKind.swift
//  Bonsai World
//
//  Inventory stock modules that share list / detail / photos (Wire, Tools,
//  Chemicals, Consumables, Fertilizers). Soil stays on its own richer stock model.
//

import Foundation

enum InventoryStockKind: String, Codable, CaseIterable, Identifiable, Hashable, Sendable {
    case wire
    case tool
    case chemical
    case consumable
    case fertilizer

    var id: Self { self }

    var title: String {
        switch self {
        case .wire: "Wire"
        case .tool: "Tools"
        case .chemical: "Chemicals"
        case .consumable: "Consumables"
        case .fertilizer: "Fertilizers"
        }
    }

    var systemImage: String {
        switch self {
        case .wire: "circle.hexagongrid"
        case .tool: "wrench.and.screwdriver"
        case .chemical: "testtube.2"
        case .consumable: "shippingbox"
        case .fertilizer: "leaf.circle"
        }
    }

    /// Settings catalog picker — all inventory stock kinds use Reference Data.
    var usesCatalog: Bool {
        true
    }

    var catalogEmptyHint: String {
        switch self {
        case .wire:
            "Add wire types in Settings → Reference Data → Wire, then return here to record stock."
        case .tool:
            "Add tools in Settings → Reference Data → Tools, then return here to record stock."
        case .chemical:
            "Add chemicals in Settings → Reference Data → Chemicals, then return here to record stock."
        case .consumable:
            "Add consumables in Settings → Reference Data → Consumables, then return here to record stock."
        case .fertilizer:
            "Add fertilizer types in Settings → Reference Data → Fertilizer Types, then return here to record stock."
        }
    }

    var addButtonTitle: String {
        switch self {
        case .wire: "Add Wire"
        case .tool: "Add Tool"
        case .chemical: "Add Chemical"
        case .consumable: "Add Consumable"
        case .fertilizer: "Add Fertilizer"
        }
    }

    var emptyListTitle: String {
        "\(title) stock is empty."
    }

    var emptyListDescription: String {
        switch self {
        case .wire: "Add the wire gauges and materials you currently keep."
        case .tool: "Add the tools you currently keep."
        case .chemical: "Add the treatments and chemicals you currently keep."
        case .consumable: "Add other consumable supplies you currently keep."
        case .fertilizer: "Add the fertilizers you currently keep."
        }
    }

    /// Add / edit label for unit cost (Settings currency applied in the UI).
    /// Fertilizer uses the selected quantity unit label instead.
    var unitPriceFieldLabel: String {
        switch self {
        case .wire: "Price per roll"
        case .tool, .chemical, .consumable: "Price per unit"
        case .fertilizer: "Price per unit"
        }
    }

    /// Fertilizer stock chooses kg / L / pack per line.
    var usesFertilizerQuantityUnit: Bool {
        self == .fertilizer
    }

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
