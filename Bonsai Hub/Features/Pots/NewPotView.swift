//
//  NewPotView.swift
//  Bonsai World
//
//  Add Pot sheet. Uses PotService for create; ReferenceDataService for Pot Type
//  and Brand/Maker pickers. Brand and Maker are never created here — Settings →
//  Pot Brands & Makers is the only place new Brand/Maker records are made, so this
//  sheet can never silently create a duplicate manufacturer record.
//

import SwiftUI

struct NewPotView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(AppState.self) private var appState
    @Environment(AppSettings.self) private var appSettings
    @Environment(PotService.self) private var potService
    @Environment(ReferenceDataService.self) private var referenceData

    @State private var name = ""
    @State private var potTypeID: UUID?
    @State private var brandID: UUID?
    @State private var makerID: UUID?

    @State private var isPhysicalExpanded = false
    @State private var material = ""
    @State private var glaze = ""
    @State private var shape = ""
    @State private var lengthMillimetres: Int?
    @State private var widthMillimetres: Int?
    @State private var heightMillimetres: Int?
    @State private var diameterMillimetres: Int?
    @State private var condition = ""

    @State private var isPurchaseExpanded = false
    @State private var purchaseDate = Date.now
    @State private var hasPurchaseDate = false
    @State private var purchasePriceText = ""
    @State private var purchaseSellerName = ""
    @State private var purchaseNotes = ""

    @State private var notes = ""

    private var system: MeasurementSystem { appSettings.measurementSystem }

    private var makersForSelectedBrand: [PotMaker] {
        referenceData.potMakersSelectable(forBrandID: brandID)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Name", text: $name)
                        .help("Optional grower-facing label, e.g. \"Blue Yixing round #2\"")

                    Picker("Pot Type", selection: $potTypeID) {
                        Text("Select Pot Type").tag(Optional<UUID>.none)
                        ForEach(referenceData.potTypes) { type in
                            Text(type.name).tag(Optional(type.id))
                        }
                    }

                    Picker("Brand / Kiln", selection: $brandID) {
                        Text("Unknown / Not Set").tag(Optional<UUID>.none)
                        ForEach(referenceData.potBrands) { brand in
                            Text(brand.name).tag(Optional(brand.id))
                        }
                    }
                    .onChange(of: brandID) { _, newBrandID in
                        if let makerID,
                           let maker = referenceData.potMaker(id: makerID),
                           let makerBrandID = maker.brandID,
                           makerBrandID != newBrandID {
                            self.makerID = nil
                        }
                    }

                    Picker("Maker / Potter", selection: $makerID) {
                        Text("Unknown / Not Set").tag(Optional<UUID>.none)
                        ForEach(makersForSelectedBrand) { maker in
                            Text(maker.name).tag(Optional(maker.id))
                        }
                    }

                    if referenceData.potBrands.isEmpty {
                        Text("No Brands yet. Add them in Settings → Pot Brands & Makers.")
                            .font(FaloTypography.caption)
                            .foregroundStyle(.secondary)
                    }
                } header: {
                    Text("Identity")
                } footer: {
                    Text("Brand / Kiln and Maker / Potter come from Settings → Pot Brands & Makers. Add a Brand or Maker there first if you don't see it here.")
                        .font(FaloTypography.caption)
                }

                DisclosureGroup("Physical", isExpanded: $isPhysicalExpanded) {
                    TextField("Material", text: $material)
                    TextField("Glaze", text: $glaze)
                    TextField("Shape", text: $shape)
                    dimensionField(title: "Length", dimension: .potLength, value: $lengthMillimetres)
                    dimensionField(title: "Width", dimension: .potWidth, value: $widthMillimetres)
                    dimensionField(title: "Height", dimension: .potHeight, value: $heightMillimetres)
                    dimensionField(title: "Diameter", dimension: .potDiameter, value: $diameterMillimetres)
                    TextField("Condition", text: $condition)
                }

                DisclosureGroup("Purchase", isExpanded: $isPurchaseExpanded) {
                    Toggle("Purchased", isOn: $hasPurchaseDate)
                    if hasPurchaseDate {
                        DatePicker("Purchase Date", selection: $purchaseDate, displayedComponents: .date)
                        TextField("Purchase Price (\(appSettings.currency.code))", text: $purchasePriceText)
                        TextField("Seller", text: $purchaseSellerName)
                        TextField("Purchase Notes", text: $purchaseNotes, axis: .vertical)
                            .lineLimit(2...4)
                    }
                }

                Section("Notes") {
                    TextField("Notes", text: $notes, axis: .vertical)
                        .lineLimit(2...4)
                }
            }
            .formStyle(.grouped)
            .faloScrollSurface()
            .navigationTitle("New Pot")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { handleCancel() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { handleSave() }
                }
            }
        }
        .frame(minWidth: 480, minHeight: 560)
    }

    @ViewBuilder
    private func dimensionField(
        title: String,
        dimension: MeasurementDimension,
        value: Binding<Int?>
    ) -> some View {
        let unit = MeasurementService.unitLabel(dimension: dimension, system: system)
        let role = dimension.linearRole ?? .width
        TextField(
            "\(title) (\(unit))",
            text: Binding(
                get: {
                    MeasurementService.editableNumericString(millimetres: value.wrappedValue, role: role, system: system)
                },
                set: {
                    value.wrappedValue = MeasurementService.millimetres(fromDisplayText: $0, role: role, system: system)
                }
            )
        )
    }

    private func handleCancel() {
        dismiss()
        appState.dismissPotEditor()
    }

    private func handleSave() {
        let draft = NewPotDraft(
            name: name,
            potTypeID: potTypeID,
            brandID: brandID,
            makerID: makerID,
            material: material,
            glaze: glaze,
            shape: shape,
            lengthMillimetres: lengthMillimetres,
            widthMillimetres: widthMillimetres,
            heightMillimetres: heightMillimetres,
            diameterMillimetres: diameterMillimetres,
            condition: condition,
            purchaseDate: hasPurchaseDate ? purchaseDate : nil,
            purchasePrice: hasPurchaseDate ? CurrencyFormatting.parseAmount(purchasePriceText) : nil,
            purchaseSellerName: hasPurchaseDate ? purchaseSellerName : "",
            purchaseNotes: hasPurchaseDate ? purchaseNotes : "",
            notes: notes
        )
        guard let created = try? potService.createPot(fromDraft: draft) else { return }
        dismiss()
        appState.dismissPotEditor()
        appState.selectedSection = .inventoryPots
        appState.selectedPotID = created.id
    }
}
