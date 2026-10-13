//
//  InventoryItemProfileView.swift
//  Bonsai World
//
//  Inventory item profile — Name, Kind, Quantity, Minimum + Delete.
//

import SwiftUI

struct InventoryItemProfileView: View {
    @Environment(DemoLibrary.self) private var library
    @Environment(\.dismiss) private var dismiss

    let itemID: UUID

    @State private var name: String = ""
    @State private var kind: InventoryStockKind = .consumable
    @State private var quantityText: String = "1"
    @State private var minimumText: String = "0"
    @State private var didLoad = false
    @State private var confirmDelete = false

    private var item: InventoryStockItem? { library.inventoryItem(id: itemID) }

    private var parsedQuantity: Double? {
        Double(quantityText.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: ",", with: "."))
    }

    private var parsedMinimum: Double? {
        Double(minimumText.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: ",", with: "."))
    }

    private var canSave: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            && (parsedQuantity ?? -1) >= 0
            && (parsedMinimum ?? -1) >= 0
    }

    var body: some View {
        Group {
            if item != nil {
                form
            } else {
                ContentUnavailableView("Item not found", systemImage: "shippingbox")
            }
        }
        .onAppear { loadIfNeeded() }
    }

    private var form: some View {
        Form {
            Section {
                HStack(alignment: .firstTextBaseline, spacing: FaloSpacing.small) {
                    TextField("Name", text: $name)
                        .font(FaloTypography.body)
                        .foregroundStyle(BonsaiWorldColors.textPrimary)
                        .accessibilityLabel("Name")
                    if let item, library.isInventoryLowStock(item) {
                        Text("Low")
                            .font(FaloTypography.caption.weight(.semibold))
                            .foregroundStyle(BonsaiWorldColors.statusAttention)
                            .accessibilityLabel("Low stock")
                    }
                }

                Picker("Kind", selection: $kind) {
                    ForEach(InventoryStockKind.allCases) { value in
                        Text(value.title).tag(value)
                    }
                }
                .accessibilityLabel("Kind")

                TextField("Quantity", text: $quantityText)
                    .font(FaloTypography.body)
                    .foregroundStyle(BonsaiWorldColors.textPrimary)
                    .keyboardType(.decimalPad)
                    .accessibilityLabel("Quantity")

                HStack(spacing: FaloSpacing.medium) {
                    Button {
                        adjustQuantity(by: -1)
                    } label: {
                        Text("−")
                            .font(FaloTypography.body.weight(.semibold))
                            .frame(maxWidth: .infinity, minHeight: 44)
                    }
                    .buttonStyle(.bordered)
                    .accessibilityLabel("Decrease quantity by 1")

                    Button {
                        adjustQuantity(by: 1)
                    } label: {
                        Text("+")
                            .font(FaloTypography.body.weight(.semibold))
                            .frame(maxWidth: .infinity, minHeight: 44)
                    }
                    .buttonStyle(.bordered)
                    .accessibilityLabel("Increase quantity by 1")
                }

                TextField("Minimum", text: $minimumText)
                    .font(FaloTypography.body)
                    .foregroundStyle(BonsaiWorldColors.textPrimary)
                    .keyboardType(.decimalPad)
                    .accessibilityLabel("Minimum")
            } footer: {
                Text("Low stock when Quantity is below Minimum (or Quantity is 0).")
                    .font(FaloTypography.caption)
            }

            Section {
                Button("Delete Item", role: .destructive) {
                    confirmDelete = true
                }
                .font(FaloTypography.body)
                .frame(maxWidth: .infinity, minHeight: 44, alignment: .leading)
                .contentShape(Rectangle())
                .accessibilityLabel("Delete Item")
                .accessibilityHint("Remove this inventory item from the library.")
            }
        }
        .scrollContentBackground(.hidden)
        .background(BonsaiWorldColors.canvas)
        .scrollDismissesKeyboard(.interactively)
        .navigationTitle(item?.name ?? "Item")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") { save() }
                    .fontWeight(.semibold)
                    .disabled(!canSave)
            }
        }
        .toolbarBackground(BonsaiWorldColors.canvas, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .confirmationDialog(
            "Delete this item?",
            isPresented: $confirmDelete,
            titleVisibility: .visible
        ) {
            Button("Delete", role: .destructive) {
                library.deleteInventoryItem(id: itemID)
                dismiss()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Removes the stock line from Inventory.")
        }
    }

    private func loadIfNeeded() {
        guard !didLoad, let item else { return }
        name = item.name
        kind = item.kind
        quantityText = item.quantity.formatted(.number.precision(.fractionLength(0...2)))
        minimumText = item.minimumQuantity.formatted(.number.precision(.fractionLength(0...2)))
        didLoad = true
    }

    private func save() {
        guard let quantity = parsedQuantity, let minimum = parsedMinimum else { return }
        library.updateInventoryItem(
            id: itemID,
            name: name,
            kind: kind,
            quantity: quantity,
            minimumQuantity: minimum
        )
    }

    private func adjustQuantity(by delta: Double) {
        library.adjustInventoryQuantity(id: itemID, by: delta)
        if let item = library.inventoryItem(id: itemID) {
            quantityText = item.quantity.formatted(.number.precision(.fractionLength(0...2)))
        }
    }
}

#Preview {
    NavigationStack {
        InventoryItemProfileView(itemID: UUID())
    }
    .environment(DemoLibrary.preview)
}
