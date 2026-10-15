//
//  InventoryStockListView.swift
//  Bonsai World
//
//  Inventory stock list column (Pots pattern / CG1) — detail is ContentView detailColumn.
//

import SwiftUI

struct InventoryStockListView: View {
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
        .bonsaiWorkspaceNavigationTitle(kind.title)
        .onAppear { reconcileSelection() }
        .onChange(of: kind) { _, _ in reconcileSelection() }
        .onChange(of: inventoryStock.items.map(\.id)) { _, _ in reconcileSelection() }
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
