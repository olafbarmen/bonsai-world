//
//  AddInventoryStockView.swift
//  Bonsai World
//
//  Add Wire / Tool / Chemical / Consumable / Fertilizer stock line.
//

import SwiftUI

struct AddInventoryStockView: View {
    let kind: InventoryStockKind

    @Environment(\.dismiss) private var dismiss
    @Environment(AppState.self) private var appState
    @Environment(AppSettings.self) private var appSettings
    @Environment(InventoryStockService.self) private var inventoryStock
    @Environment(ReferenceDataService.self) private var referenceData

    @Environment(ImageImportService.self) private var imageImportService

    @State private var draft = NewInventoryStockDraft()
    @State private var selectedImageID: UUID?
    @State private var errorMessage: String?

    private var catalogOptions: [(id: UUID, name: String)] {
        switch kind {
        case .wire:
            return referenceData.wire.filter(\.isActive).sorted {
                $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending
            }.map { ($0.id, $0.name) }
        case .tool:
            return referenceData.tools.filter(\.isActive).sorted {
                $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending
            }.map { ($0.id, $0.name) }
        case .chemical:
            return referenceData.chemicals.filter(\.isActive).sorted {
                $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending
            }.map { ($0.id, $0.name) }
        case .fertilizer:
            return referenceData.fertilizerTypes.filter(\.isActive).sorted {
                $0.displayName.localizedCaseInsensitiveCompare($1.displayName) == .orderedAscending
            }.map { ($0.id, $0.displayName) }
        case .consumable:
            return referenceData.consumables.filter(\.isActive).sorted {
                $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending
            }.map { ($0.id, $0.name) }
        }
    }

    private var priceLabel: String {
        if kind == .fertilizer {
            let unit = draft.fertilizerQuantityUnit ?? .kg
            return "\(unit.priceFieldLabel) (\(appSettings.currency.code))"
        }
        return "\(kind.unitPriceFieldLabel) (\(appSettings.currency.code))"
    }

    private var canSave: Bool {
        let quantityOK = draft.quantity >= 0
        if kind == .wire {
            return draft.catalogItemID != nil && draft.wireRollSize != nil && quantityOK
        }
        if kind == .fertilizer {
            return draft.catalogItemID != nil && draft.fertilizerQuantityUnit != nil && quantityOK
        }
        if kind.usesCatalog {
            return draft.catalogItemID != nil && quantityOK
        }
        return !draft.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && quantityOK
    }

    var body: some View {
        NavigationStack {
            Form {
                if kind.usesCatalog {
                    Section {
                        Picker("Type", selection: $draft.catalogItemID) {
                            Text("Select from catalog").tag(Optional<UUID>.none)
                            ForEach(catalogOptions, id: \.id) { option in
                                Text(option.name).tag(Optional(option.id))
                            }
                        }
                        if catalogOptions.isEmpty {
                            Text(kind.catalogEmptyHint)
                                .font(FaloTypography.caption)
                                .foregroundStyle(.secondary)
                        }
                    } header: {
                        Text("Catalog")
                    } footer: {
                        Text("Types are the Settings database. This sheet only records stock.")
                    }
                } else {
                    Section("Identity") {
                        TextField("Name", text: $draft.name)
                        Text(kind.catalogEmptyHint)
                            .font(FaloTypography.caption)
                            .foregroundStyle(.secondary)
                    }
                }

                Section {
                    if kind == .wire {
                        Picker("Roll size", selection: $draft.wireRollSize) {
                            ForEach(InventoryWireRollSize.allCases) { size in
                                Text(size.title).tag(Optional(size))
                            }
                        }
                        TextField("Rolls", value: $draft.quantity, format: .number)
                        TextField("Minimum rolls", value: $draft.minimumQuantity, format: .number)
                    } else if kind == .fertilizer {
                        Picker("Unit", selection: $draft.fertilizerQuantityUnit) {
                            ForEach(InventoryFertilizerQuantityUnit.allCases) { unit in
                                Text(unit.title).tag(Optional(unit))
                            }
                        }
                        TextField("Quantity", value: $draft.quantity, format: .number)
                        TextField("Minimum quantity", value: $draft.minimumQuantity, format: .number)
                    } else {
                        TextField("Quantity", value: $draft.quantity, format: .number)
                        TextField("Minimum quantity", value: $draft.minimumQuantity, format: .number)
                    }
                    TextField(priceLabel, value: $draft.unitPrice, format: .number)
                } header: {
                    Text("Quantity")
                } footer: {
                    if kind == .wire {
                        Text("One stock line is one roll size. Add another line for the same type if you keep more than one size.")
                    } else if kind == .fertilizer {
                        Text("Choose kg, L, or pack for this line. Price is for that unit.")
                    }
                }

                StockDraftPhotosSection(
                    primaryImageID: $draft.primaryImageID,
                    imageIDs: $draft.imageIDs,
                    selectedImageID: $selectedImageID,
                    onAddImage: addImage
                )

                Section("Optional") {
                    TextField("Brand", text: $draft.brand)
                    TextField("Supplier", text: $draft.supplier)
                    TextField("Notes", text: $draft.notes, axis: .vertical)
                        .lineLimit(2...4)
                }
            }
            .formStyle(.grouped)
            .faloScrollSurface()
            .navigationTitle(kind.addButtonTitle)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") { save() }
                        .disabled(!canSave)
                }
            }
            .alert("Could Not Add Stock", isPresented: Binding(
                get: { errorMessage != nil },
                set: { if !$0 { errorMessage = nil } }
            )) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(errorMessage ?? "")
            }
            .onAppear {
                if kind == .wire, draft.wireRollSize == nil {
                    draft.wireRollSize = .grams100
                }
                if kind == .fertilizer, draft.fertilizerQuantityUnit == nil {
                    draft.fertilizerQuantityUnit = .kg
                }
            }
        }
        .frame(minWidth: 420, minHeight: 480)
    }

    private func addImage() {
        Task {
            guard let asset = try? await imageImportService.importGalleryImageFromFinder() else { return }
            if !draft.imageIDs.contains(asset.id) {
                draft.imageIDs.append(asset.id)
            }
            if draft.primaryImageID == nil {
                draft.primaryImageID = asset.id
            }
            selectedImageID = asset.id
        }
    }

    private func save() {
        do {
            let created = try inventoryStock.addItem(kind: kind, from: draft)
            appState.selectedInventoryStockID = created.id
            appState.dismissInventoryStockEditor()
            dismiss()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
