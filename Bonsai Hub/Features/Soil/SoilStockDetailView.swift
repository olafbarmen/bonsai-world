//
//  SoilStockDetailView.swift
//  Bonsai World
//

import SwiftUI

struct SoilStockDetailView: View {
    @Environment(AppState.self) private var appState
    @Environment(SoilStockService.self) private var soilStock
    @Environment(ReferenceDataService.self) private var referenceData
    @Environment(ImageImportService.self) private var imageImportService

    @State private var draft: SoilStockItem?
    @State private var errorMessage: String?
    @State private var selectedPhotoID: UUID?

    private var item: SoilStockItem? {
        guard let id = appState.selectedSoilStockID else { return nil }
        return soilStock.item(id: id)
    }

    private var isEditing: Bool { draft != nil }

    var body: some View {
        Group {
            if let item {
                content(for: item)
            } else {
                ContentUnavailableView(
                    "Select a material",
                    systemImage: "square.stack.3d.up",
                    description: Text("Choose a soil stock line from the list.")
                )
            }
        }
        .onChange(of: appState.selectedSoilStockID) { _, _ in
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
    private func content(for item: SoilStockItem) -> some View {
        let name = referenceData.soilComponent(id: item.componentID)?.name ?? "Unknown material"
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
                identity(name: name, item: displayed, liveItem: item)
                inventory(displayed)
                purchase(displayed)
                properties(displayed)
                history(item)
            }
            .padding(FaloSpacing.medium)
        }
        .faloScrollSurface()
        .navigationTitle(name)
    }

    @ViewBuilder
    private func identity(name: String, item: SoilStockItem, liveItem: SoilStockItem) -> some View {
        DetailCard(title: "Identity") {
            PotIdentityPhotosSection(
                imageIDs: liveItem.imageIDs,
                primaryImageID: liveItem.primaryImageID,
                selectedImageID: $selectedPhotoID,
                onAddImage: { addImage(to: liveItem) },
                onSetPrimary: { id in try? soilStock.setPrimaryImage(itemID: liveItem.id, imageID: id) },
                onRemove: { id in
                    try? soilStock.removeImage(itemID: liveItem.id, imageID: id)
                    if selectedPhotoID == id {
                        selectedPhotoID = soilStock.item(id: liveItem.id)?.listImageID
                    }
                }
            )

            DetailLabeledRow(label: "Material", value: name)
            if isEditing, var draft {
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
                DetailLabeledRow(label: "Grain size", value: item.grainSize.displayTitle)
                DetailLabeledRow(label: "Brand", value: item.brand)
                DetailLabeledRow(label: "Supplier", value: item.supplier)
                DetailLabeledRow(label: "Notes", value: item.notes)
            }
        }
    }

    @ViewBuilder
    private func inventory(_ item: SoilStockItem) -> some View {
        DetailCard(title: "Inventory") {
            if isEditing, var draft {
                TextField("Bag size (L)", value: Binding(
                    get: { draft.bagSizeLiters },
                    set: { draft.bagSizeLiters = $0; self.draft = draft }
                ), format: .number)
                TextField("Bags", value: Binding(
                    get: { draft.bagCount },
                    set: { draft.bagCount = $0; self.draft = draft }
                ), format: .number)
                TextField("Open bag remaining (L, optional)", value: Binding(
                    get: { draft.openBagRemainingLiters },
                    set: { draft.openBagRemainingLiters = $0; self.draft = draft }
                ), format: .number)
                TextField("Minimum stock (L)", value: Binding(
                    get: { draft.minimumStockLiters },
                    set: { draft.minimumStockLiters = $0; self.draft = draft }
                ), format: .number)
                Text("Estimated \(SoilVolumeFormat.liters(draft.estimatedVolumeLiters))")
                    .font(FaloTypography.caption)
                    .foregroundStyle(.secondary)
            } else {
                DetailLabeledRow(label: "Bags", value: SoilVolumeFormat.bags(item.bagCount))
                DetailLabeledRow(label: "Bag size", value: "\(SoilVolumeFormat.liters(item.bagSizeLiters)) / bag")
                if item.openBagRemainingLiters > 0 {
                    DetailLabeledRow(label: "Open bag", value: SoilVolumeFormat.liters(item.openBagRemainingLiters))
                }
                DetailLabeledRow(label: "Estimated", value: SoilVolumeFormat.liters(item.estimatedVolumeLiters))
                DetailLabeledRow(
                    label: "Last actual count",
                    value: item.lastActualVolumeLiters.map(SoilVolumeFormat.liters) ?? ""
                )
                DetailLabeledRow(
                    label: "Last stocktake",
                    value: item.lastStocktakeDate.map { $0.formatted(date: .abbreviated, time: .omitted) } ?? ""
                )
                DetailLabeledRow(label: "Minimum stock", value: SoilVolumeFormat.liters(item.minimumStockLiters))
                DetailLabeledRow(label: "Status", value: item.stockStatusTitle)
            }
        }
    }

    @ViewBuilder
    private func purchase(_ item: SoilStockItem) -> some View {
        DetailCard(title: "Purchase information") {
            if isEditing, var draft {
                TextField("Batch / reference (optional)", text: Binding(
                    get: { draft.batchReference },
                    set: { draft.batchReference = $0; self.draft = draft }
                ))
                TextField("Price per bag", value: Binding(
                    get: { draft.purchasePricePerBag ?? 0 },
                    set: { draft.purchasePricePerBag = $0 == 0 ? nil : $0; self.draft = draft }
                ), format: .number)
            } else {
                DetailLabeledRow(label: "Supplier", value: item.supplier)
                DetailLabeledRow(
                    label: "Price per bag",
                    value: item.purchasePricePerBag.map { $0.formatted(.number.precision(.fractionLength(0...2))) } ?? ""
                )
                DetailLabeledRow(
                    label: "Purchase date",
                    value: item.purchaseDate.map { $0.formatted(date: .abbreviated, time: .omitted) } ?? ""
                )
                DetailLabeledRow(label: "Batch", value: item.batchReference)
            }
        }
    }

    @ViewBuilder
    private func properties(_ item: SoilStockItem) -> some View {
        DetailCard(title: "Properties") {
            if isEditing, var draft {
                Picker("Grain size", selection: Binding(
                    get: { draft.grainSize.band },
                    set: { draft.grainSize.applyBand($0); self.draft = draft }
                )) {
                    ForEach(SoilGrainSizeBand.allCases) { band in
                        Text(band.title).tag(band)
                    }
                }
                if draft.grainSize.band == .custom {
                    TextField("Min mm", value: Binding(
                        get: { draft.grainSize.minimumMillimetres },
                        set: { draft.grainSize.minimumMillimetres = $0; self.draft = draft }
                    ), format: .number)
                    TextField("Max mm", value: Binding(
                        get: { draft.grainSize.maximumMillimetres },
                        set: { draft.grainSize.maximumMillimetres = $0; self.draft = draft }
                    ), format: .number)
                }
                TextField("Particle notes (optional)", text: Binding(
                    get: { draft.grainSize.particleNotes },
                    set: { draft.grainSize.particleNotes = $0; self.draft = draft }
                ))
            } else {
                DetailLabeledRow(label: "Grain size", value: item.grainSize.displayTitle)
                DetailLabeledRow(label: "Particle notes", value: item.grainSize.particleNotes)
            }
        }
    }

    @ViewBuilder
    private func history(_ item: SoilStockItem) -> some View {
        DetailCard(title: "Stocktake history") {
            if item.stocktakes.isEmpty {
                Text("No stocktakes recorded yet.")
                    .font(FaloTypography.body)
                    .foregroundStyle(.secondary)
            } else {
                ForEach(item.stocktakes) { record in
                    VStack(alignment: .leading, spacing: 2) {
                        Text(record.date.formatted(date: .abbreviated, time: .omitted))
                            .font(FaloCardTypography.fieldValue)
                        Text("Estimated \(SoilVolumeFormat.liters(record.estimatedVolumeLiters)) · Actual \(SoilVolumeFormat.liters(record.actualVolumeLiters)) · Difference \(SoilVolumeFormat.signedLiters(record.differenceLiters))")
                            .font(FaloTypography.caption)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, FaloSpacing.xSmall)
                    Divider()
                }
            }
        }
    }

    private func addImage(to item: SoilStockItem) {
        Task {
            guard let asset = try? await imageImportService.importGalleryImageFromFinder() else { return }
            if item.primaryImageID == nil {
                try? soilStock.setPrimaryImage(itemID: item.id, imageID: asset.id)
            } else {
                var updated = item
                if !updated.imageIDs.contains(asset.id) {
                    updated.imageIDs.append(asset.id)
                }
                _ = try? soilStock.updateItem(updated)
            }
            selectedPhotoID = asset.id
        }
    }

    private func save() {
        guard let draft else { return }
        do {
            _ = try soilStock.updateItem(draft)
            self.draft = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
