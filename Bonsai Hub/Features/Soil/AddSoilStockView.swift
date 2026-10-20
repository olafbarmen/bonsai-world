//
//  AddSoilStockView.swift
//  Bonsai World
//
//  Add a stock line by picking a catalog type from Settings.
//

import SwiftUI

struct AddSoilStockView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(AppState.self) private var appState
    @Environment(SoilStockService.self) private var soilStock
    @Environment(ReferenceDataService.self) private var referenceData

    @Environment(ImageImportService.self) private var imageImportService

    @State private var draft = NewSoilStockDraft()
    @State private var selectedImageID: UUID?
    @State private var errorMessage: String?

    private var catalog: [SoilComponent] {
        referenceData.soilComponents.filter(\.isActive).sorted {
            $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending
        }
    }

    private var canSave: Bool {
        draft.componentID != nil && draft.bagSizeLiters > 0 && draft.bagCount >= 0
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Picker("Soil type", selection: $draft.componentID) {
                        Text("Select from catalog").tag(Optional<UUID>.none)
                        ForEach(catalog) { component in
                            Text(component.name).tag(Optional(component.id))
                        }
                    }
                    if catalog.isEmpty {
                        Text("Add soil types in Settings → Reference Data → Soil Components, then return here to record how many bags you own.")
                            .font(FaloTypography.caption)
                            .foregroundStyle(.secondary)
                    }
                } header: {
                    Text("Catalog")
                } footer: {
                    Text("Types are the Settings database. This sheet only records stock.")
                }

                Section("Grain size") {
                    Picker("Grain size", selection: $draft.grainSize.band) {
                        ForEach(SoilGrainSizeBand.allCases) { band in
                            Text(band.title).tag(band)
                        }
                    }
                    .onChange(of: draft.grainSize.band) { _, band in
                        draft.grainSize.applyBand(band)
                    }
                    if draft.grainSize.band == .custom {
                        TextField("Minimum mm", value: $draft.grainSize.minimumMillimetres, format: .number)
                        TextField("Maximum mm", value: $draft.grainSize.maximumMillimetres, format: .number)
                    }
                    TextField("Particle notes (optional)", text: $draft.grainSize.particleNotes)
                }

                Section("Bags") {
                    TextField("Bag size (L)", value: $draft.bagSizeLiters, format: .number)
                    TextField("Number of bags", value: $draft.bagCount, format: .number)
                    TextField("Open bag remaining (L, optional)", value: $draft.openBagRemainingLiters, format: .number)
                    Text("Estimated \(SoilVolumeFormat.liters(max(0, draft.bagCount) * max(0, draft.bagSizeLiters) + max(0, draft.openBagRemainingLiters)))")
                        .foregroundStyle(.secondary)
                    TextField("Minimum stock (L)", value: $draft.minimumStockLiters, format: .number)
                }

                StockDraftPhotosSection(
                    primaryImageID: $draft.primaryImageID,
                    imageIDs: $draft.imageIDs,
                    selectedImageID: $selectedImageID,
                    onAddImage: addImage,
                    onDropImageFiles: { sources in
                        Task { await importDroppedImages(sources) }
                    }
                )

                Section("Optional") {
                    TextField("Brand", text: $draft.brand)
                    TextField("Supplier", text: $draft.supplier)
                    TextField("Batch / reference", text: $draft.batchReference)
                    Toggle("Purchase date", isOn: $draft.hasPurchaseDate)
                    if draft.hasPurchaseDate {
                        DatePicker("Purchase date", selection: Binding(
                            get: { draft.purchaseDate ?? .now },
                            set: { draft.purchaseDate = $0 }
                        ), displayedComponents: .date)
                    }
                    TextField("Price per bag", value: Binding(
                        get: { draft.purchasePricePerBag ?? 0 },
                        set: { draft.purchasePricePerBag = $0 == 0 ? nil : $0 }
                    ), format: .number)
                    TextField("Notes", text: $draft.notes, axis: .vertical)
                        .lineLimit(2...4)
                }
            }
            .formStyle(.grouped)
            .faloScrollSurface()
            .navigationTitle("Add Soil")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") { save() }
                        .disabled(!canSave)
                }
            }
            .alert("Could Not Add Soil", isPresented: Binding(
                get: { errorMessage != nil },
                set: { if !$0 { errorMessage = nil } }
            )) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(errorMessage ?? "")
            }
        }
        .frame(minWidth: 460, minHeight: 520)
    }

    private func addImage() {
        Task {
            guard let asset = try? await imageImportService.importGalleryImageFromFinder() else { return }
            attach(asset)
        }
    }

    private func importDroppedImages(_ sources: [ImageDropSource]) async {
        for source in sources {
            guard let asset = try? await imageImportService.importImage(from: source, asPrimary: false) else { continue }
            attach(asset)
        }
    }

    private func attach(_ asset: ImageAsset) {
        if !draft.imageIDs.contains(asset.id) {
            draft.imageIDs.append(asset.id)
        }
        if draft.primaryImageID == nil {
            draft.primaryImageID = asset.id
        }
        selectedImageID = asset.id
    }

    private func save() {
        do {
            let created = try soilStock.addItem(from: draft)
            appState.selectedSection = .inventorySoil
            appState.selectedSoilWorkspaceTab = .stock
            appState.selectedSoilStockID = created.id
            appState.dismissSoilStockEditor()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
