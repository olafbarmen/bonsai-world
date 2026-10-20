//
//  NewInventoryItemView.swift
//  Bonsai World
//
//  Field New Inventory — Name + Kind + Quantity + Minimum.
//

import SwiftUI

struct NewInventoryItemView: View {
    @Environment(DemoLibrary.self) private var library
    @Environment(\.dismiss) private var dismiss

    var onCreated: (UUID) -> Void

    @State private var name: String = ""
    @State private var kind: InventoryStockKind = .consumable
    @State private var quantityText: String = "1"
    @State private var minimumText: String = "0"

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
        NavigationStack {
            Form {
                Section {
                    TextField("Name", text: $name)
                        .font(FaloTypography.body)
                        .foregroundStyle(BonsaiWorldColors.textPrimary)
                        .accessibilityLabel("Name")

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

                    TextField("Minimum", text: $minimumText)
                        .font(FaloTypography.body)
                        .foregroundStyle(BonsaiWorldColors.textPrimary)
                        .keyboardType(.decimalPad)
                        .accessibilityLabel("Minimum")
                } footer: {
                    Text("Low stock when Quantity is below Minimum (or Quantity is 0).")
                        .font(FaloTypography.caption)
                }
            }
            .scrollContentBackground(.hidden)
            .background(BonsaiWorldColors.canvas)
            .scrollDismissesKeyboard(.interactively)
            .navigationTitle("New Item")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { save() }
                        .fontWeight(.semibold)
                        .disabled(!canSave)
                }
            }
            .toolbarBackground(BonsaiWorldColors.canvas, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.light, for: .navigationBar)
        }
    }

    private func save() {
        guard let quantity = parsedQuantity, let minimum = parsedMinimum else { return }
        guard let item = library.addInventoryItem(
            name: name,
            kind: kind,
            quantity: quantity,
            minimumQuantity: minimum
        ) else { return }
        onCreated(item.id)
        dismiss()
    }
}

#Preview {
    NewInventoryItemView(onCreated: { _ in })
        .environment(DemoLibrary.preview)
}
