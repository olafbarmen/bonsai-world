//
//  InventoryStockWorkspaceView.swift
//  Bonsai World
//
//  Shared helpers for Inventory stock list/detail (CG1 — Pots pattern via ContentView).
//

import SwiftUI

struct InventoryStockListRow: View {
    let item: InventoryStockItem
    let name: String
    let imageService: ImageService
    let placeholderSystemImage: String

    var body: some View {
        HStack(spacing: FaloSpacing.medium) {
            TreeListThumbnail(
                imageID: item.listImageID,
                imageService: imageService,
                placeholderSystemImage: placeholderSystemImage
            )

            VStack(alignment: .leading, spacing: 2) {
                HStack {
                    Text(name)
                        .font(FaloCardTypography.fieldValue)
                    Spacer()
                    Text(item.stockStatusTitle)
                        .font(FaloTypography.caption)
                        .foregroundStyle(.secondary)
                }
                Text(item.quantitySummary)
                    .font(FaloTypography.caption)
                    .foregroundStyle(.secondary)
                if item.isLowStock {
                    let minLabel = item.kind == .wire ? "min rolls" : "min"
                    Text("Low stock · \(minLabel) \(item.minimumQuantity.formatted(.number.precision(.fractionLength(0...2))))")
                        .font(FaloTypography.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding(.vertical, FaloSpacing.xSmall)
    }
}

@MainActor
enum InventoryStockPresentation {
    static func title(for item: InventoryStockItem, referenceData: ReferenceDataService) -> String {
        if let catalogID = item.catalogItemID {
            switch item.kind {
            case .wire:
                if let name = referenceData.wire(id: catalogID)?.name { return name }
            case .tool:
                if let name = referenceData.tool(id: catalogID)?.name { return name }
            case .chemical:
                if let name = referenceData.chemical(id: catalogID)?.name { return name }
            case .fertilizer:
                if let name = referenceData.fertilizerType(id: catalogID)?.displayName { return name }
            case .consumable:
                if let name = referenceData.consumable(id: catalogID)?.name { return name }
            }
        }
        let trimmed = item.name.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? "Untitled" : trimmed
    }
}
