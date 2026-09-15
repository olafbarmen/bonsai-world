//
//  StockReportBuilder.swift
//  Bonsai World
//
//  Builds on-screen / export stock valuation from live inventory services.
//

import Foundation

@MainActor
enum StockReportBuilder {
    static func build(
        pots: [Pot],
        soilItems: [SoilStockItem],
        inventoryItems: [InventoryStockItem],
        referenceData: ReferenceDataService
    ) -> StockReport {
        let sections = StockReportArea.allCases.map { area in
            section(
                for: area,
                pots: pots,
                soilItems: soilItems,
                inventoryItems: inventoryItems,
                referenceData: referenceData
            )
        }
        return StockReport(sections: sections, generatedAt: .now)
    }

    private static func section(
        for area: StockReportArea,
        pots: [Pot],
        soilItems: [SoilStockItem],
        inventoryItems: [InventoryStockItem],
        referenceData: ReferenceDataService
    ) -> StockReportSection {
        guard area.isStockAvailable else {
            return StockReportSection(
                area: area,
                lines: [],
                placeholderMessage: area.unavailableMessage
            )
        }

        switch area {
        case .pots:
            return StockReportSection(area: area, lines: potLines(pots), placeholderMessage: nil)
        case .soil:
            return StockReportSection(
                area: area,
                lines: soilLines(soilItems, referenceData: referenceData),
                placeholderMessage: nil
            )
        case .wire, .tools, .chemicals, .consumables, .fertilizers:
            let kind: InventoryStockKind = switch area {
            case .wire: .wire
            case .tools: .tool
            case .chemicals: .chemical
            case .consumables: .consumable
            case .fertilizers: .fertilizer
            default: .consumable
            }
            return StockReportSection(
                area: area,
                lines: inventoryLines(
                    inventoryItems.filter { $0.kind == kind },
                    referenceData: referenceData
                ),
                placeholderMessage: nil
            )
        }
    }

    private static func potLines(_ pots: [Pot]) -> [StockReportLine] {
        pots
            .sorted {
                potName($0).localizedCaseInsensitiveCompare(potName($1)) == .orderedAscending
            }
            .map { pot in
                let price = pot.purchasePrice.map { NSDecimalNumber(decimal: $0).doubleValue }
                return StockReportLine(
                    id: pot.id,
                    name: potName(pot),
                    quantityLabel: "1 · \(pot.status.title)",
                    unitPrice: price,
                    lineValue: price,
                    isLowStock: false
                )
            }
    }

    private static func potName(_ pot: Pot) -> String {
        let trimmed = pot.name.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? "Untitled Pot" : trimmed
    }

    private static func soilLines(
        _ items: [SoilStockItem],
        referenceData: ReferenceDataService
    ) -> [StockReportLine] {
        items
            .sorted {
                let lhs = referenceData.soilComponent(id: $0.componentID)?.name ?? ""
                let rhs = referenceData.soilComponent(id: $1.componentID)?.name ?? ""
                return lhs.localizedCaseInsensitiveCompare(rhs) == .orderedAscending
            }
            .map { item in
                let name = referenceData.soilComponent(id: item.componentID)?.name ?? "Unknown material"
                let bags = item.bagCount.formatted(.number.precision(.fractionLength(0...2)))
                let quantityLabel = "\(bags) bags · \(SoilVolumeFormat.liters(item.estimatedVolumeLiters))"
                let unitPrice = item.purchasePricePerBag
                let lineValue = unitPrice.map { max(0, item.bagCount) * max(0, $0) }
                return StockReportLine(
                    id: item.id,
                    name: name,
                    quantityLabel: quantityLabel,
                    unitPrice: unitPrice,
                    lineValue: lineValue,
                    isLowStock: item.isLowStock
                )
            }
    }

    private static func inventoryLines(
        _ items: [InventoryStockItem],
        referenceData: ReferenceDataService
    ) -> [StockReportLine] {
        items
            .sorted {
                let lhs = InventoryStockPresentation.title(for: $0, referenceData: referenceData)
                let rhs = InventoryStockPresentation.title(for: $1, referenceData: referenceData)
                return lhs.localizedCaseInsensitiveCompare(rhs) == .orderedAscending
            }
            .map { item in
                StockReportLine(
                    id: item.id,
                    name: InventoryStockPresentation.title(for: item, referenceData: referenceData),
                    quantityLabel: item.quantitySummary,
                    unitPrice: item.unitPrice,
                    lineValue: item.stockValue,
                    isLowStock: item.isLowStock
                )
            }
    }
}
