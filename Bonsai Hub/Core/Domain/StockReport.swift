//
//  StockReportArea.swift
//  Bonsai World
//
//  Inventory areas included in Stock Report.
//

import Foundation

enum StockReportArea: String, CaseIterable, Identifiable, Hashable, Sendable {
    case pots
    case soil
    case fertilizers
    case wire
    case tools
    case chemicals
    case consumables

    var id: Self { self }

    var title: String {
        switch self {
        case .pots: "Pots"
        case .soil: "Soil"
        case .fertilizers: "Fertilizers"
        case .wire: "Wire"
        case .tools: "Tools"
        case .chemicals: "Chemicals"
        case .consumables: "Consumables"
        }
    }

    var systemImage: String {
        switch self {
        case .pots: "shippingbox"
        case .soil: "square.stack.3d.up"
        case .fertilizers: "leaf.circle"
        case .wire: "circle.hexagongrid"
        case .tools: "wrench.and.screwdriver"
        case .chemicals: "testtube.2"
        case .consumables: "shippingbox"
        }
    }

    /// Whether this area has a live stock module yet.
    var isStockAvailable: Bool {
        true
    }

    var unavailableMessage: String {
        "No stock module for this area yet."
    }

    var appRoute: AppRoute? {
        switch self {
        case .pots: .inventoryPots
        case .soil: .inventorySoil
        case .fertilizers: .inventoryFertilizers
        case .wire: .inventoryWire
        case .tools: .inventoryTools
        case .chemicals: .inventoryChemicals
        case .consumables: .inventoryConsumables
        }
    }

    static func area(for route: AppRoute) -> StockReportArea? {
        switch route {
        case .inventoryPots: .pots
        case .inventorySoil, .inventorySoilComponents, .inventorySoilMixes: .soil
        case .inventoryFertilizers: .fertilizers
        case .inventoryWire: .wire
        case .inventoryTools: .tools
        case .inventoryChemicals: .chemicals
        case .inventoryConsumables: .consumables
        default: nil
        }
    }
}

struct StockReportLine: Identifiable, Hashable, Sendable {
    var id: UUID
    var name: String
    var quantityLabel: String
    var unitPrice: Double?
    var lineValue: Double?
    var isLowStock: Bool
}

struct StockReportSection: Identifiable, Hashable, Sendable {
    var id: StockReportArea { area }
    var area: StockReportArea
    var lines: [StockReportLine]
    var placeholderMessage: String?

    var lineCount: Int { lines.count }

    var sectionValue: Double {
        lines.compactMap(\.lineValue).reduce(0, +)
    }

    var hasPricedLines: Bool {
        lines.contains { $0.lineValue != nil }
    }

    var lowStockCount: Int {
        lines.filter(\.isLowStock).count
    }
}

struct StockReport: Hashable, Sendable {
    var sections: [StockReportSection]
    var generatedAt: Date

    var totalValue: Double {
        sections.map(\.sectionValue).reduce(0, +)
    }

    var totalLines: Int {
        sections.map(\.lineCount).reduce(0, +)
    }

    var lowStockCount: Int {
        sections.map(\.lowStockCount).reduce(0, +)
    }
}
