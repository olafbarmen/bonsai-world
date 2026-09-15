//
//  InventoryStockWorkspaceView.swift
//  Bonsai World
//
//  Shared Inventory stock workspace for Wire / Tools / Chemicals / Consumables.
//

import SwiftUI

struct InventoryStockWorkspaceView: View {
    let kind: InventoryStockKind

    var body: some View {
        InventoryStockSplitView(kind: kind)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .faloWorkspaceCanvas()
            .bonsaiWorkspaceNavigationTitle(kind.title)
    }
}

struct InventoryStockSplitView: View {
    let kind: InventoryStockKind

    @Environment(AppState.self) private var appState
    @Environment(InventoryStockService.self) private var inventoryStock
    @Environment(ReferenceDataService.self) private var referenceData
    @Environment(ImageService.self) private var imageService

    @State private var search = ""
    @State private var showLowOnly = false

    private var rows: [InventoryStockItem] {
        inventoryStock.items(for: kind)
            .filter { !showLowOnly || $0.isLowStock }
            .filter { item in
                let needle = search.trimmingCharacters(in: .whitespacesAndNewlines)
                guard !needle.isEmpty else { return true }
                let title = displayName(for: item)
                return title.localizedCaseInsensitiveContains(needle)
                    || item.brand.localizedCaseInsensitiveContains(needle)
                    || item.supplier.localizedCaseInsensitiveContains(needle)
            }
            .sorted {
                displayName(for: $0).localizedCaseInsensitiveCompare(displayName(for: $1)) == .orderedAscending
            }
    }

    var body: some View {
        @Bindable var appState = appState

        HSplitView {
            VStack(spacing: 0) {
                header
                Divider()
                List(rows, selection: $appState.selectedInventoryStockID) { item in
                    InventoryStockListRow(
                        item: item,
                        name: displayName(for: item),
                        imageService: imageService,
                        placeholderSystemImage: kind.systemImage
                    )
                    .tag(item.id)
                }
                .faloScrollSurface()
                .overlay {
                    if inventoryStock.items(for: kind).isEmpty {
                        ContentUnavailableView(
                            kind.emptyListTitle,
                            systemImage: kind.systemImage,
                            description: Text(kind.emptyListDescription)
                        )
                    } else if rows.isEmpty {
                        ContentUnavailableView(
                            "No Matching Stock",
                            systemImage: "line.3.horizontal.decrease.circle",
                            description: Text("Try a different search or filter.")
                        )
                    }
                }
            }
            .frame(minWidth: 280, idealWidth: 380)

            InventoryStockDetailView(kind: kind)
                .frame(minWidth: 360)
        }
        .onAppear {
            reconcileSelection()
        }
        .onChange(of: kind) { _, _ in
            reconcileSelection()
        }
        .onChange(of: inventoryStock.items.map(\.id)) { _, _ in
            reconcileSelection()
        }
    }

    private var header: some View {
        HStack {
            TextField("Search", text: $search)
                .textFieldStyle(.roundedBorder)
            Toggle("Low stock", isOn: $showLowOnly)
                .toggleStyle(.checkbox)
        }
        .padding(FaloSpacing.medium)
    }

    private func reconcileSelection() {
        if let selected = appState.selectedInventoryStockID,
           let item = inventoryStock.item(id: selected),
           item.kind == kind {
            return
        }
        appState.selectedInventoryStockID = nil
    }

    private func displayName(for item: InventoryStockItem) -> String {
        InventoryStockPresentation.title(for: item, referenceData: referenceData)
    }
}

private struct InventoryStockListRow: View {
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
