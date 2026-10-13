//
//  InventoryListView.swift
//  Bonsai World
//
//  Field Inventory — stock list grouped by kind + New + Low-only + ± quantity.
//

import SwiftUI

struct InventoryListView: View {
    @Environment(DemoLibrary.self) private var library

    var initialLowOnly: Bool = false
    var onCreatedItem: ((UUID) -> Void)? = nil

    @State private var lowOnly = false
    @State private var didApplyInitialFilter = false
    @State private var isShowingNew = false
    @State private var pendingCreatedID: UUID?
    @State private var searchText = ""

    private var baseItems: [InventoryStockItem] {
        var items = lowOnly ? library.lowInventoryStock : library.orderedInventoryStock
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        if !query.isEmpty {
            items = items.filter { $0.name.localizedCaseInsensitiveContains(query) }
        }
        return items
    }

    var body: some View {
        Group {
            if library.orderedInventoryStock.isEmpty {
                ContentUnavailableView {
                    Label("No inventory yet", systemImage: "shippingbox")
                } description: {
                    Text("Add an inventory item.")
                } actions: {
                    Button("New Item") {
                        isShowingNew = true
                    }
                    .accessibilityLabel("New Item")
                }
            } else {
                stockList
            }
        }
        .navigationTitle("Inventory")
        .navigationBarTitleDisplayMode(.large)
        .searchable(text: $searchText, prompt: "Search name")
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Toggle("Low only", isOn: $lowOnly)
                    .toggleStyle(.button)
                    .accessibilityLabel("Low only")
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button("New Item") {
                    isShowingNew = true
                }
                .accessibilityLabel("New Item")
            }
        }
        .onAppear {
            guard !didApplyInitialFilter else { return }
            lowOnly = initialLowOnly
            didApplyInitialFilter = true
        }
        .sheet(isPresented: $isShowingNew, onDismiss: {
            if let id = pendingCreatedID {
                pendingCreatedID = nil
                onCreatedItem?(id)
            }
        }) {
            NewInventoryItemView { id in
                pendingCreatedID = id
            }
        }
    }

    private var stockList: some View {
        List {
            if !searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                Section {
                    Text(matchCountCaption)
                        .font(FaloTypography.caption)
                        .foregroundStyle(BonsaiWorldColors.textSecondary)
                        .listRowBackground(BonsaiWorldColors.surface)
                        .accessibilityLabel(matchCountCaption)
                }
            }

            if baseItems.isEmpty {
                Section {
                    Text(emptyFilterMessage)
                        .font(FaloTypography.body)
                        .foregroundStyle(BonsaiWorldColors.textSecondary)
                        .listRowBackground(BonsaiWorldColors.surface)
                    if lowOnly {
                        Button("Show all") {
                            lowOnly = false
                        }
                        .font(FaloTypography.body)
                        .foregroundStyle(BonsaiWorldColors.accent)
                        .listRowBackground(BonsaiWorldColors.surface)
                        .accessibilityLabel("Show all")
                    }
                    Button("New Item") {
                        isShowingNew = true
                    }
                    .font(FaloTypography.body)
                    .foregroundStyle(BonsaiWorldColors.accent)
                    .listRowBackground(BonsaiWorldColors.surface)
                    .accessibilityLabel("New Item")
                }
            } else {
                ForEach(InventoryStockKind.allCases) { kind in
                    let items = baseItems.filter { $0.kind == kind }
                    if items.isEmpty {
                        if searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !lowOnly {
                            Section(kind.title) {
                                Text("Empty")
                                    .font(FaloTypography.body)
                                    .foregroundStyle(BonsaiWorldColors.textSecondary)
                                    .listRowBackground(BonsaiWorldColors.surface)
                            }
                        }
                    } else {
                        Section(kind.title) {
                            ForEach(items) { item in
                                NavigationLink(value: MobileRoute.inventoryItem(item.id)) {
                                    itemRow(item)
                                }
                                .listRowBackground(BonsaiWorldColors.surface)
                                .swipeActions(edge: .leading, allowsFullSwipe: false) {
                                    Button("+1") {
                                        library.adjustInventoryQuantity(id: item.id, by: 1)
                                    }
                                    .tint(BonsaiWorldColors.accent)
                                    .accessibilityLabel("Increase quantity by 1")

                                    Button("−1") {
                                        library.adjustInventoryQuantity(id: item.id, by: -1)
                                    }
                                    .tint(BonsaiWorldColors.textSecondary)
                                    .accessibilityLabel("Decrease quantity by 1")
                                }
                                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                    Button("Delete", role: .destructive) {
                                        library.deleteInventoryItem(id: item.id)
                                    }
                                    .accessibilityLabel("Delete Item")
                                }
                            }
                        }
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
        .scrollContentBackground(.hidden)
        .background(BonsaiWorldColors.canvas)
    }

    private var emptyFilterMessage: String {
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        if !query.isEmpty {
            return lowOnly ? "No low stock items match this search." : "No items match this search."
        }
        if lowOnly {
            return "No low stock items"
        }
        return "No inventory yet"
    }

    private var matchCountCaption: String {
        let count = baseItems.count
        let matchPart = count == 1 ? "1 match" : "\(count) matches"
        if lowOnly {
            return "\(matchPart) · Low only"
        }
        return matchPart
    }

    private func itemRow(_ item: InventoryStockItem) -> some View {
        VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
            HStack(spacing: FaloSpacing.small) {
                Text(item.name)
                    .font(FaloTypography.body)
                    .fontWeight(.semibold)
                    .foregroundStyle(BonsaiWorldColors.textPrimary)
                if library.isInventoryLowStock(item) {
                    Text("Low")
                        .font(FaloTypography.caption)
                        .foregroundStyle(BonsaiWorldColors.textPrimary)
                        .padding(.horizontal, FaloSpacing.xSmall)
                        .padding(.vertical, 2)
                        .background {
                            Capsule(style: .continuous)
                                .fill(BonsaiWorldColors.statusTintFill(BonsaiWorldColors.statusAttention))
                        }
                        .overlay {
                            Capsule(style: .continuous)
                                .strokeBorder(BonsaiWorldColors.statusTintStroke(BonsaiWorldColors.statusAttention), lineWidth: 1)
                        }
                        .accessibilityLabel("Low stock")
                }
            }
            Text(item.quantitySummary)
                .font(FaloTypography.caption)
                .foregroundStyle(BonsaiWorldColors.textSecondary)
        }
        .padding(.vertical, FaloSpacing.xSmall)
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    NavigationStack {
        InventoryListView()
    }
    .environment(DemoLibrary.preview)
}
