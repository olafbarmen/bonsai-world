//
//  NewTreeView.swift
//  Bonsai World
//
//  Field New Tree — same registration as Mac New Tree.
//

import SwiftUI

struct NewTreeView: View {
    @Environment(DemoLibrary.self) private var library
    @Environment(\.dismiss) private var dismiss
    @Bindable private var regional = MobileRegionalPreferences.shared

    /// Optional preselected Location (e.g. from Location Profile).
    var initialLocationID: UUID? = nil
    var onCreated: (UUID) -> Void

    @State private var genera: [Genus] = []
    @State private var speciesAll: [Species] = []
    @State private var cultivarsAll: [Cultivar] = []
    @State private var styles: [Style] = []
    @State private var sizeClasses: [SizeClass] = []
    @State private var treeStages: [TreeStage] = []
    @State private var lightConditions: [LightCondition] = []
    @State private var potTypes: [PotType] = []
    @State private var acquisitionMethods: [AcquisitionMethod] = []

    @State private var nickname = ""
    @State private var bonsaiName = ""
    @State private var isBonsaiNameOverridden = false
    @State private var showBonsaiNameOverrideAlert = false
    @State private var genusID: UUID?
    @State private var speciesID: UUID?
    @State private var cultivarID: UUID?
    @State private var styleID: UUID?
    @State private var sizeClassID: UUID?
    @State private var treeStageID: UUID?
    @State private var gardenID: UUID?
    @State private var locationID: UUID?
    @State private var lightConditionID: UUID?
    @State private var soilMixID: UUID?
    @State private var potTypeID: UUID?
    @State private var selectedCollectionIDs: Set<UUID> = []
    @State private var propagation: TreePropagation?
    @State private var acquisitionDate = Date.now
    @State private var acquisitionMethodID: UUID?
    @State private var acquisitionSourceName = ""
    @State private var purchasePriceText = ""
    @State private var acquisitionNotes = ""
    @State private var knowsLastRepotted = false
    @State private var lastRepottedDate = Date.now
    @State private var plansRepottingInterval = false
    @State private var repottingIntervalYears = 3
    @State private var isMeasurementsExpanded = false
    @State private var measurementDate = Date.now
    @State private var heightText = ""
    @State private var crownWidthText = ""
    @State private var nebariWidthText = ""
    @State private var trunkDiameterText = ""
    @State private var saveErrorMessage = ""
    @State private var saveFailed = false
    @State private var didLoadInitial = false
    @State private var isShowingNewLocation = false
    @State private var isMapPickerPresented = false

    private var speciesChoices: [Species] {
        guard let genusID else { return [] }
        return speciesAll
            .filter { $0.genusID == genusID && $0.isActive }
            .sorted { $0.sortOrder < $1.sortOrder }
    }

    private var cultivarChoices: [Cultivar] {
        guard let speciesID else { return [] }
        return cultivarsAll
            .filter { $0.speciesID == speciesID && $0.isActive }
            .sorted { $0.sortOrder < $1.sortOrder }
    }

    private var locationsForGarden: [Location] {
        guard let gardenID else { return library.orderedLocations }
        return library.locations(inGarden: gardenID)
    }

    private var manualCollections: [Collection] {
        library.collections
            .filter(\.isManual)
            .sorted { $0.name.localizedStandardCompare($1.name) == .orderedAscending }
    }

    private var genusName: String {
        genera.first { $0.id == genusID }?.name ?? ""
    }

    private var speciesLabelForNaming: String {
        guard let speciesID else { return "" }
        let species = speciesChoices.first { $0.id == speciesID }
            ?? speciesAll.first { $0.id == speciesID }
        guard let species else { return "" }
        return species.epithet.isEmpty ? species.name : species.epithet
    }

    private var cultivarName: String {
        cultivarChoices.first { $0.id == cultivarID }?.name
            ?? cultivarsAll.first { $0.id == cultivarID }?.name
            ?? ""
    }

    private var botanicalName: String {
        TreeNamingService.makeBotanicalName(
            genus: genusName,
            species: speciesLabelForNaming,
            cultivar: cultivarName
        )
    }

    private var generatedBonsaiName: String {
        guard !genusName.isEmpty, !speciesLabelForNaming.isEmpty else { return "" }
        let year = TreeNamingService.acquisitionYear(from: acquisitionDate)
        let sequence = speciesID.map { library.nextBonsaiNameSequence(for: $0) } ?? 1
        return TreeNamingService.makeBonsaiName(
            genusName: genusName,
            speciesName: speciesLabelForNaming,
            cultivarName: cultivarName.isEmpty ? nil : cultivarName,
            acquisitionYear: year,
            sequence: sequence
        )
    }

    private var resolvedBonsaiName: String {
        let trimmed = bonsaiName.trimmingCharacters(in: .whitespacesAndNewlines)
        if isBonsaiNameOverridden, !trimmed.isEmpty { return trimmed }
        return generatedBonsaiName
    }

    private var canSave: Bool {
        genusID != nil
            && speciesID != nil
            && locationID != nil
            && !resolvedBonsaiName.isEmpty
            && !library.isBonsaiNameInUse(resolvedBonsaiName)
    }

    private var sourceFieldLabel: String {
        let methodName = acquisitionMethods.first { $0.id == acquisitionMethodID }?.name
        return acquisitionSourceLabel(methodName: methodName)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("General") {
                    TextField("Nickname", text: $nickname)
                        .font(FaloTypography.body)
                        .accessibilityLabel("Nickname")

                    catalogPicker("Genus", selection: $genusID, placeholder: "Select Genus", items: genera)
                    catalogPicker("Species", selection: $speciesID, placeholder: "Select Species", items: speciesChoices)
                        .disabled(genusID == nil)
                    catalogPicker("Cultivar", selection: $cultivarID, placeholder: "Select Cultivar", items: cultivarChoices)
                        .disabled(speciesID == nil)

                    LabeledContent("Botanical Name") {
                        Text(botanicalName.isEmpty ? "Select Genus and Species" : botanicalName)
                            .font(FaloTypography.body)
                            .foregroundStyle(botanicalName.isEmpty ? BonsaiWorldColors.textSecondary : BonsaiWorldColors.textPrimary)
                    }

                    if isBonsaiNameOverridden {
                        TextField("Bonsai Name", text: $bonsaiName)
                            .font(FaloTypography.body.monospaced())
                            .accessibilityLabel("Bonsai Name")
                        if library.isBonsaiNameInUse(bonsaiName) {
                            Text("That Bonsai Name is already used.")
                                .font(FaloTypography.caption)
                                .foregroundStyle(BonsaiWorldColors.statusCritical)
                        }
                        Button("Use Generated Name") {
                            isBonsaiNameOverridden = false
                            bonsaiName = generatedBonsaiName
                        }
                    } else {
                        LabeledContent("Bonsai Name") {
                            Text(generatedBonsaiName.isEmpty ? "Select Genus and Species" : generatedBonsaiName)
                                .font(FaloTypography.body.monospaced())
                                .foregroundStyle(generatedBonsaiName.isEmpty ? BonsaiWorldColors.textSecondary : BonsaiWorldColors.textPrimary)
                        }
                        Button("Change…") {
                            showBonsaiNameOverrideAlert = true
                        }
                        .disabled(generatedBonsaiName.isEmpty)
                    }
                }

                Section("Classification") {
                    catalogPicker("Style", selection: $styleID, placeholder: "Select Style", items: styles)
                    catalogPicker("Size Class", selection: $sizeClassID, placeholder: "Select Size Class", items: sizeClasses)
                    catalogPicker("Tree Stage", selection: $treeStageID, placeholder: "Select Tree Stage", items: treeStages)
                }

                Section {
                    Picker("Garden", selection: $gardenID) {
                        Text("Select Garden").tag(Optional<UUID>.none)
                        ForEach(library.orderedGardens) { garden in
                            Text(garden.isDefault ? "\(garden.name) (Default)" : garden.name)
                                .tag(Optional(garden.id))
                        }
                    }
                    .accessibilityLabel("Garden")

                    if locationsForGarden.isEmpty {
                        Text("Empty")
                            .foregroundStyle(BonsaiWorldColors.textSecondary)
                        Button("New Location") {
                            isShowingNewLocation = true
                        }
                        .accessibilityLabel("New Location")
                    } else {
                        Picker("Location (list)", selection: $locationID) {
                            Text("Select Location").tag(Optional<UUID>.none)
                            ForEach(locationsForGarden) { location in
                                Text(location.name).tag(Optional(location.id))
                            }
                        }
                        .accessibilityLabel("Location")
                    }

                    Button("Select on Map") {
                        isMapPickerPresented = true
                    }
                    .disabled(gardenID == nil)
                    .accessibilityLabel("Select on Map")

                    catalogPicker(
                        "Light Condition",
                        selection: $lightConditionID,
                        placeholder: "Select Light Condition",
                        items: lightConditions
                    )
                    soilPicker
                    catalogPicker("Pot Type", selection: $potTypeID, placeholder: "Select Pot Type", items: potTypes)
                } header: {
                    Text("Growing")
                } footer: {
                    Text("Select on Map is preferred. Trees never store coordinates — the Location owns the map position.")
                        .font(FaloTypography.caption)
                }

                if !manualCollections.isEmpty {
                    Section {
                        ForEach(manualCollections) { collection in
                            Toggle(collection.name, isOn: collectionBinding(collection.id))
                        }
                    } header: {
                        Text("Collections")
                    } footer: {
                        Text("Optional. A tree can belong to more than one collection.")
                            .font(FaloTypography.caption)
                    }
                }

                Section("Acquisition") {
                    Picker("Propagation", selection: $propagation) {
                        Text("Select Propagation").tag(Optional<TreePropagation>.none)
                        ForEach(TreePropagation.allCases) { value in
                            Text(value.title).tag(Optional(value))
                        }
                    }
                    DatePicker("Acquisition Date", selection: $acquisitionDate, displayedComponents: .date)
                    catalogPicker(
                        "Acquisition Method",
                        selection: $acquisitionMethodID,
                        placeholder: "Select Acquisition Method",
                        items: acquisitionMethods
                    )
                    TextField(sourceFieldLabel, text: $acquisitionSourceName)
                        .accessibilityLabel(sourceFieldLabel)
                    TextField("Purchase Price (\(regional.currency.code))", text: $purchasePriceText)
                        .keyboardType(.decimalPad)
                        .accessibilityLabel("Purchase Price (\(regional.currency.code))")
                    Text("Optional. Saved for later — Economy is not built yet.")
                        .font(FaloTypography.caption)
                        .foregroundStyle(BonsaiWorldColors.textSecondary)
                    TextField("Acquisition Notes", text: $acquisitionNotes, axis: .vertical)
                        .lineLimit(2...4)
                }

                Section {
                    Toggle("Last repotted known", isOn: $knowsLastRepotted)
                    if knowsLastRepotted {
                        DatePicker("Last repotted", selection: $lastRepottedDate, displayedComponents: .date)
                    }
                    Toggle("Plan next repot", isOn: $plansRepottingInterval)
                    if plansRepottingInterval {
                        Stepper(value: $repottingIntervalYears, in: 1...20) {
                            Text(
                                repottingIntervalYears == 1
                                    ? "Every 1 year"
                                    : "Every \(repottingIntervalYears) years"
                            )
                        }
                    }
                } header: {
                    Text("Repotting")
                } footer: {
                    Text("Fill both to create an automatic Repotting Task. Due dates land in March–May.")
                        .font(FaloTypography.caption)
                }

                Section {
                    Toggle("Enter measurements", isOn: $isMeasurementsExpanded.animation())
                    if isMeasurementsExpanded {
                        DatePicker("Measurement Date", selection: $measurementDate, displayedComponents: .date)
                        measurementField("Height", role: .height, text: $heightText)
                        measurementField("Crown Width", role: .width, text: $crownWidthText)
                        measurementField("Nebari Width", role: .width, text: $nebariWidthText)
                        measurementField("Trunk Diameter", role: .diameter, text: $trunkDiameterText)
                    }
                } header: {
                    Text("Measurements (Optional)")
                } footer: {
                    Text("Optional. Entered values become the first Tree Measurement when you add the tree.")
                        .font(FaloTypography.caption)
                }
            }
            .scrollContentBackground(.hidden)
            .background(BonsaiWorldColors.canvas)
            .scrollDismissesKeyboard(.interactively)
            .navigationTitle("New Tree")
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
            .onAppear(perform: loadIfNeeded)
            .onChange(of: genusID) { _, _ in
                if let speciesID, !speciesChoices.contains(where: { $0.id == speciesID }) {
                    self.speciesID = nil
                    cultivarID = nil
                }
                refreshGeneratedBonsaiName()
            }
            .onChange(of: speciesID) { _, _ in
                if let cultivarID, !cultivarChoices.contains(where: { $0.id == cultivarID }) {
                    self.cultivarID = nil
                }
                refreshGeneratedBonsaiName()
            }
            .onChange(of: cultivarID) { _, _ in
                refreshGeneratedBonsaiName()
            }
            .onChange(of: acquisitionDate) { _, _ in
                refreshGeneratedBonsaiName()
            }
            .alert("Change Bonsai Name?", isPresented: $showBonsaiNameOverrideAlert) {
                Button("Cancel", role: .cancel) {}
                Button("Change") {
                    isBonsaiNameOverridden = true
                    bonsaiName = generatedBonsaiName
                }
            } message: {
                Text("Bonsai Name is generated as GEN-SPE-CUL-YYYY-NNN from genus, species, cultivar, and acquisition year. After you save, it cannot be changed. Use a custom name only if this tree already has one.")
            }
            .alert("Could Not Add Tree", isPresented: $saveFailed) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(saveErrorMessage)
            }
            .onChange(of: gardenID) { _, _ in
                if let locationID, !locationsForGarden.contains(where: { $0.id == locationID }) {
                    self.locationID = locationsForGarden.first?.id
                }
            }
            .sheet(isPresented: $isMapPickerPresented) {
                if let gardenID {
                    MobileSelectOnMapSheet(gardenID: gardenID, locationID: $locationID)
                }
            }
            .sheet(isPresented: $isShowingNewLocation, onDismiss: {
                if locationID == nil {
                    locationID = locationsForGarden.first?.id
                }
            }) {
                NewLocationView { id in
                    locationID = id
                    if let garden = library.location(id: id)?.gardenID {
                        gardenID = garden
                    }
                }
            }
        }
        .tint(BonsaiWorldColors.accent)
        .preferredColorScheme(.light)
    }

    private var soilPicker: some View {
        Picker("Soil Mix", selection: $soilMixID) {
            Text("Select Soil Mix").tag(Optional<UUID>.none)
            ForEach(library.orderedSoilMixes) { mix in
                Text(mix.name).tag(Optional(mix.id))
            }
        }
        .accessibilityLabel("Soil Mix")
    }

    private func catalogPicker<Item: NewTreeCatalogRow>(
        _ title: String,
        selection: Binding<UUID?>,
        placeholder: String,
        items: [Item]
    ) -> some View {
        Picker(title, selection: selection) {
            Text(placeholder).tag(Optional<UUID>.none)
            ForEach(items) { item in
                Text(item.name).tag(Optional(item.id))
            }
        }
        .accessibilityLabel(title)
    }

    private func collectionBinding(_ id: UUID) -> Binding<Bool> {
        Binding(
            get: { selectedCollectionIDs.contains(id) },
            set: { isOn in
                if isOn {
                    selectedCollectionIDs.insert(id)
                } else {
                    selectedCollectionIDs.remove(id)
                }
            }
        )
    }

    private func loadIfNeeded() {
        guard !didLoadInitial else { return }
        genera = GenusPreviewData.all.filter(\.isActive).sorted { $0.sortOrder < $1.sortOrder }
        speciesAll = SpeciesPreviewData.all
        cultivarsAll = CultivarPreviewData.all
        styles = StylePreviewData.all.filter(\.isActive).sorted { $0.sortOrder < $1.sortOrder }
        sizeClasses = SizeClassPreviewData.all.filter(\.isActive).sorted { $0.sortOrder < $1.sortOrder }
        treeStages = TreeStagePreviewData.all.filter(\.isActive).sorted { $0.sortOrder < $1.sortOrder }
        lightConditions = LightConditionPreviewData.all.filter(\.isActive).sorted { $0.sortOrder < $1.sortOrder }
        potTypes = PotTypePreviewData.all.filter(\.isActive).sorted { $0.sortOrder < $1.sortOrder }
        acquisitionMethods = AcquisitionMethodPreviewData.all.filter(\.isActive).sorted { $0.sortOrder < $1.sortOrder }

        gardenID = library.defaultGarden?.id
        if let initialLocationID, let location = library.location(id: initialLocationID) {
            locationID = location.id
            gardenID = location.gardenID
        } else if let gardenID {
            locationID = library.locations(inGarden: gardenID).first?.id
        } else {
            locationID = library.orderedLocations.first?.id
        }
        didLoadInitial = true
    }

    private func refreshGeneratedBonsaiName() {
        guard !isBonsaiNameOverridden else { return }
        bonsaiName = generatedBonsaiName
    }

    private func measurementField(
        _ title: String,
        role: MobileLinearMeasurementRole,
        text: Binding<String>
    ) -> some View {
        let unit = MobileRegionalPreferences.unitLabel(role: role, system: regional.measurementSystem)
        let labeled = "\(title) (\(unit))"
        return TextField(labeled, text: text)
            .keyboardType(.decimalPad)
            .accessibilityLabel(labeled)
    }

    private func decimal(from raw: String) -> Decimal? {
        let trimmed = raw.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return nil }
        return Decimal(string: trimmed.replacingOccurrences(of: ",", with: "."))
    }

    private func save() {
        guard let locationID else { return }
        let system = regional.measurementSystem
        let height = MobileRegionalPreferences.millimetres(
            fromDisplayText: heightText, role: .height, system: system
        )
        let crown = MobileRegionalPreferences.millimetres(
            fromDisplayText: crownWidthText, role: .width, system: system
        )
        let nebari = MobileRegionalPreferences.millimetres(
            fromDisplayText: nebariWidthText, role: .width, system: system
        )
        let trunk = MobileRegionalPreferences.millimetres(
            fromDisplayText: trunkDiameterText, role: .diameter, system: system
        )
        guard let tree = library.createTree(
            botanicalName: botanicalName,
            nickname: nickname,
            bonsaiName: resolvedBonsaiName,
            locationID: locationID,
            genusID: genusID,
            speciesID: speciesID,
            cultivarID: cultivarID,
            styleID: styleID,
            sizeClassID: sizeClassID,
            treeStageID: treeStageID,
            soilMixID: soilMixID,
            potTypeID: potTypeID,
            lightConditionID: lightConditionID,
            propagation: propagation,
            acquisitionDate: acquisitionDate,
            acquisitionMethodID: acquisitionMethodID,
            acquisitionSourceName: acquisitionSourceName,
            purchasePrice: decimal(from: purchasePriceText),
            acquisitionNotes: acquisitionNotes,
            lastRepottedDate: knowsLastRepotted ? lastRepottedDate : nil,
            repottingIntervalYears: plansRepottingInterval ? repottingIntervalYears : nil,
            heightMillimetres: isMeasurementsExpanded ? height : nil,
            crownWidthMillimetres: isMeasurementsExpanded ? crown : nil,
            nebariWidthMillimetres: isMeasurementsExpanded ? nebari : nil,
            trunkDiameterMillimetres: isMeasurementsExpanded ? trunk : nil
        ) else {
            saveErrorMessage = library.isBonsaiNameInUse(resolvedBonsaiName)
                ? "That Bonsai Name is already used."
                : "Bonsai World could not add this tree."
            saveFailed = true
            return
        }
        if isMeasurementsExpanded {
            let record = TreeMeasurementRecord(
                treeID: tree.id,
                measuredAt: measurementDate,
                heightMillimetres: height,
                crownWidthMillimetres: crown,
                nebariWidthMillimetres: nebari,
                trunkDiameterMillimetres: trunk
            )
            if record.hasAnyValue {
                library.appendInitialMeasurement(record)
            }
        }
        for collectionID in selectedCollectionIDs {
            library.addTree(tree.id, to: collectionID)
        }
        onCreated(tree.id)
        dismiss()
    }

    private func acquisitionSourceLabel(methodName: String?) -> String {
        switch methodName?.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() {
        case "nursery", "garden centre", "garden center": "Nursery Name"
        case "bonsai dealer": "Dealer Name"
        case "private seller", "online marketplace": "Seller Name"
        case "friend": "Friend Name"
        case "club member": "Member Name"
        case "seed": "Seed Supplier"
        case "cutting", "air layer": "Source Tree"
        case "yamadori": "Collection Area"
        case "gift": "Gift From"
        case "auction": "Auction Name"
        case "other": "Source Name"
        default: "Source Name"
        }
    }
}

private protocol NewTreeCatalogRow: Identifiable where ID == UUID {
    var name: String { get }
}

extension Genus: NewTreeCatalogRow {}
extension Species: NewTreeCatalogRow {}
extension Cultivar: NewTreeCatalogRow {}
extension Style: NewTreeCatalogRow {}
extension SizeClass: NewTreeCatalogRow {}
extension TreeStage: NewTreeCatalogRow {}
extension LightCondition: NewTreeCatalogRow {}
extension PotType: NewTreeCatalogRow {}
extension AcquisitionMethod: NewTreeCatalogRow {}

#Preview {
    NewTreeView(onCreated: { _ in })
        .environment(DemoLibrary.preview)
}
