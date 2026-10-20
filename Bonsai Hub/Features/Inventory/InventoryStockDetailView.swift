//
//  InventoryStockDetailView.swift
//  Bonsai World
//

import SwiftUI

struct InventoryStockDetailView: View {
    let kind: InventoryStockKind

    @Environment(AppState.self) private var appState
    @Environment(AppSettings.self) private var appSettings
    @Environment(InventoryStockService.self) private var inventoryStock
    @Environment(ReferenceDataService.self) private var referenceData
    @Environment(ImageImportService.self) private var imageImportService

    @State private var draft: InventoryStockItem?
    @State private var errorMessage: String?
    @State private var selectedPhotoID: UUID?

    private var item: InventoryStockItem? {
        guard let id = appState.selectedInventoryStockID,
              let item = inventoryStock.item(id: id),
              item.kind == kind
        else { return nil }
        return item
    }

    private var isEditing: Bool { draft != nil }

    var body: some View {
        Group {
            if let item {
                content(for: item)
            } else {
                ContentUnavailableView(
                    "Select an item",
                    systemImage: kind.systemImage,
                    description: Text("Choose a stock line from the list.")
                )
            }
        }
        .onChange(of: appState.selectedInventoryStockID) { _, _ in
            draft = nil
            selectedPhotoID = nil
        }
        .alert("Could Not Update Stock", isPresented: Binding(
            get: { errorMessage != nil },
            set: { if !$0 { errorMessage = nil } }
        )) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(errorMessage ?? "")
        }
    }

    @ViewBuilder
    private func content(for item: InventoryStockItem) -> some View {
        let title = InventoryStockPresentation.title(for: item, referenceData: referenceData)
        let displayed = draft ?? item

        ScrollView {
            VStack(alignment: .leading, spacing: FaloSpacing.medium) {
                HStack {
                    if isEditing {
                        Button("Cancel") { draft = nil }
                            .buttonStyle(.borderless)
                        Spacer()
                        Button("Save") { save() }
                            .buttonStyle(.borderless)
                    } else {
                        Spacer()
                        Button("Edit") { draft = item }
                            .buttonStyle(.borderless)
                    }
                }
                identity(title: title, item: displayed, liveItem: item)
                inventory(displayed)
            }
            .padding(FaloSpacing.medium)
        }
        .faloScrollSurface()
        .navigationTitle(title)
    }

    @ViewBuilder
    private func identity(title: String, item: InventoryStockItem, liveItem: InventoryStockItem) -> some View {
        DetailCard(title: "Identity") {
            PotIdentityPhotosSection(
                imageIDs: liveItem.imageIDs,
                primaryImageID: liveItem.primaryImageID,
                selectedImageID: $selectedPhotoID,
                onAddImage: { addImage(to: liveItem) },
                onDropImageFiles: { sources in
                    Task { await importDroppedImages(sources, to: liveItem) }
                },
                onSetPrimary: { id in try? inventoryStock.setPrimaryImage(itemID: liveItem.id, imageID: id) },
                onRemove: { id in
                    try? inventoryStock.removeImage(itemID: liveItem.id, imageID: id)
                    if selectedPhotoID == id {
                        selectedPhotoID = inventoryStock.item(id: liveItem.id)?.listImageID
                    }
                }
            )

            DetailLabeledRow(label: kind.usesCatalog ? "Type" : "Name", value: title)
            if isEditing, var draft {
                if !kind.usesCatalog {
                    TextField("Name", text: Binding(
                        get: { draft.name },
                        set: { draft.name = $0; self.draft = draft }
                    ))
                }
                TextField("Brand (optional)", text: Binding(
                    get: { draft.brand },
                    set: { draft.brand = $0; self.draft = draft }
                ))
                TextField("Supplier (optional)", text: Binding(
                    get: { draft.supplier },
                    set: { draft.supplier = $0; self.draft = draft }
                ))
                TextField("Notes", text: Binding(
                    get: { draft.notes },
                    set: { draft.notes = $0; self.draft = draft }
                ), axis: .vertical)
                .lineLimit(2...5)
            } else {
                DetailLabeledRow(label: "Brand", value: item.brand)
                DetailLabeledRow(label: "Supplier", value: item.supplier)
                DetailLabeledRow(label: "Notes", value: item.notes)
            }
        }
    }

    @ViewBuilder
    private func inventory(_ item: InventoryStockItem) -> some View {
        DetailCard(title: "Inventory") {
            if isEditing, var draft {
                if kind == .wire {
                    Picker("Roll size", selection: Binding(
                        get: { draft.wireRollSize },
                        set: { draft.wireRollSize = $0; self.draft = draft }
                    )) {
                        ForEach(InventoryWireRollSize.allCases) { size in
                            Text(size.title).tag(Optional(size))
                        }
                    }
                    TextField("Rolls", value: Binding(
                        get: { draft.quantity },
                        set: { draft.quantity = $0; self.draft = draft }
                    ), format: .number)
                    TextField("Minimum rolls", value: Binding(
                        get: { draft.minimumQuantity },
                        set: { draft.minimumQuantity = $0; self.draft = draft }
                    ), format: .number)
                } else if kind == .fertilizer {
                    Picker("Unit", selection: Binding(
                        get: { draft.fertilizerQuantityUnit },
                        set: { draft.fertilizerQuantityUnit = $0; self.draft = draft }
                    )) {
                        ForEach(InventoryFertilizerQuantityUnit.allCases) { unit in
                            Text(unit.title).tag(Optional(unit))
                        }
                    }
                    TextField("Quantity", value: Binding(
                        get: { draft.quantity },
                        set: { draft.quantity = $0; self.draft = draft }
                    ), format: .number)
                    TextField("Minimum quantity", value: Binding(
                        get: { draft.minimumQuantity },
                        set: { draft.minimumQuantity = $0; self.draft = draft }
                    ), format: .number)
                } else {
                    TextField("Quantity", value: Binding(
                        get: { draft.quantity },
                        set: { draft.quantity = $0; self.draft = draft }
                    ), format: .number)
                    TextField("Minimum quantity", value: Binding(
                        get: { draft.minimumQuantity },
                        set: { draft.minimumQuantity = $0; self.draft = draft }
                    ), format: .number)
                }
                TextField(
                    "\(draft.resolvedUnitPriceFieldLabel) (\(appSettings.currency.code))",
                    value: Binding(
                        get: { draft.unitPrice ?? 0 },
                        set: { draft.unitPrice = $0 == 0 ? nil : $0; self.draft = draft }
                    ),
                    format: .number
                )
            } else if kind == .wire {
                DetailLabeledRow(label: "Roll size", value: item.wireRollSize?.title ?? "")
                DetailLabeledRow(
                    label: "Rolls",
                    value: item.quantity.formatted(.number.precision(.fractionLength(0...2)))
                )
                DetailLabeledRow(
                    label: "Minimum rolls",
                    value: item.minimumQuantity.formatted(.number.precision(.fractionLength(0...2)))
                )
                DetailLabeledRow(
                    label: item.resolvedUnitPriceFieldLabel,
                    value: formattedPrice(item.unitPrice)
                )
                DetailLabeledRow(label: "Line value", value: formattedPrice(item.stockValue))
                DetailLabeledRow(label: "Status", value: item.stockStatusTitle)
            } else if kind == .fertilizer {
                DetailLabeledRow(label: "Unit", value: item.fertilizerQuantityUnit?.title ?? "")
                DetailLabeledRow(
                    label: "Quantity",
                    value: item.quantity.formatted(.number.precision(.fractionLength(0...2)))
                )
                DetailLabeledRow(
                    label: "Minimum",
                    value: item.minimumQuantity.formatted(.number.precision(.fractionLength(0...2)))
                )
                DetailLabeledRow(
                    label: item.resolvedUnitPriceFieldLabel,
                    value: formattedPrice(item.unitPrice)
                )
                DetailLabeledRow(label: "Line value", value: formattedPrice(item.stockValue))
                DetailLabeledRow(label: "Status", value: item.stockStatusTitle)
            } else {
                DetailLabeledRow(
                    label: "Quantity",
                    value: item.quantity.formatted(.number.precision(.fractionLength(0...2)))
                )
                DetailLabeledRow(
                    label: "Minimum",
                    value: item.minimumQuantity.formatted(.number.precision(.fractionLength(0...2)))
                )
                DetailLabeledRow(
                    label: item.resolvedUnitPriceFieldLabel,
                    value: formattedPrice(item.unitPrice)
                )
                DetailLabeledRow(label: "Line value", value: formattedPrice(item.stockValue))
                DetailLabeledRow(label: "Status", value: item.stockStatusTitle)
            }
        }
    }

    private func formattedPrice(_ amount: Double?) -> String {
        guard let amount else { return "" }
        return CurrencyFormatting.string(Decimal(amount), currency: appSettings.currency)
    }

    private func addImage(to item: InventoryStockItem) {
        Task {
            guard let asset = try? await imageImportService.importGalleryImageFromFinder() else { return }
            attach(asset, to: item)
        }
    }

    private func importDroppedImages(_ sources: [ImageDropSource], to item: InventoryStockItem) async {
        var current = item
        for source in sources {
            guard let asset = try? await imageImportService.importImage(from: source, asPrimary: false) else { continue }
            attach(asset, to: current)
            current = inventoryStock.item(id: item.id) ?? current
        }
    }

    private func attach(_ asset: ImageAsset, to item: InventoryStockItem) {
        if item.primaryImageID == nil {
            try? inventoryStock.setPrimaryImage(itemID: item.id, imageID: asset.id)
        } else {
            var updated = item
            if !updated.imageIDs.contains(asset.id) {
                updated.imageIDs.append(asset.id)
            }
            _ = try? inventoryStock.updateItem(updated)
        }
        selectedPhotoID = asset.id
    }

    private func save() {
        guard let draft else { return }
        do {
            _ = try inventoryStock.updateItem(draft)
            self.draft = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
