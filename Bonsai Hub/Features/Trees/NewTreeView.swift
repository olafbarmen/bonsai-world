//
//  NewTreeView.swift
//  Bonsai World
//
//  Add Tree sheet. Uses TreeService for create; ReferenceDataService for Lists pickers.
//  Sheet Cancel/Save toolbar is add-flow chrome only — Trees module actions live in Quick Actions.
//

import SwiftUI

/// Location list picker tags — includes embedded create without leaving New Tree.
private enum NewTreeLocationListTag: Hashable {
    case unset
    case location(UUID)
    case createNew
}

struct NewTreeView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(AppState.self) private var appState
    @Environment(AppSettings.self) private var appSettings
    @Environment(TreeService.self) private var treeService
    @Environment(ReferenceDataService.self) private var referenceData
    @Environment(ReferenceDataManager.self) private var referenceDataManager
    @Environment(TreeMeasurementHistoryStore.self) private var measurementHistory
    @Environment(UserProfileStore.self) private var profile

    private let mode: EditorMode = .create

    // MARK: - General

    @State private var nickname = ""
    @State private var genusID: UUID?
    @State private var speciesID: UUID?
    @State private var cultivarID: UUID?

    // MARK: - Classification

    @State private var styleID: UUID?
    @State private var sizeClassID: UUID?
    @State private var treeStatusID: UUID?

    // MARK: - Growing

    @State private var placementGardenID: UUID?
    @State private var locationID: UUID?
    @State private var isMapPickerPresented = false
    @State private var lightConditionID: UUID?
    @State private var soilMixID: UUID?
    @State private var potTypeID: UUID?

    // MARK: - Acquisition

    @State private var acquisitionMethodID: UUID?
    @State private var acquisitionDate = Date.now
    @State private var acquisitionSourceName = ""
    @State private var purchasePriceText = ""
    @State private var acquisitionNotes = ""

    @State private var selectedCollectionIDs: Set<UUID> = []

    // MARK: - Optional measurements

    @State private var isMeasurementsExpanded = false
    @State private var measurementDate = Date.now
    @State private var heightMillimetres: Int?
    @State private var crownWidthMillimetres: Int?
    @State private var nebariWidthMillimetres: Int?
    @State private var trunkDiameterMillimetres: Int?

    // MARK: - Embedded create sheets

    @State private var isNewLocationPresented = false
    @State private var newLocationDraft: LocationReferenceDraft?
    @State private var isNewCollectionPresented = false

    @State private var saveFailed = false
    @State private var saveErrorMessage = "Choose a genus, species, and location, then try Save again."

    /// Generated Botanical Name — always mirrors current Genus / Species / Cultivar.
    @State private var botanicalName = ""

    /// Generated Bonsai Name (GEN-SPE-CUL-YYYY-NNN), or a confirmed manual override.
    @State private var bonsaiName = ""
    @State private var isBonsaiNameOverridden = false
    @State private var showBonsaiNameOverrideAlert = false

    private var genusName: String {
        genusID.flatMap { referenceData.genus(id: $0)?.name } ?? ""
    }

    /// Species epithet when available; otherwise the stored species name (naming rules).
    private var speciesLabelForNaming: String {
        guard let speciesID, let species = referenceData.species(id: speciesID) else {
            return ""
        }
        let epithet = species.epithet
        return epithet.isEmpty ? species.name : epithet
    }

    private var cultivarName: String {
        cultivarID.flatMap { referenceData.cultivar(id: $0)?.name } ?? ""
    }

    private var acquisitionMethodName: String {
        acquisitionMethodID.flatMap { referenceData.acquisitionMethod(id: $0)?.name } ?? ""
    }

    private var acquisitionSourceFieldLabel: String {
        OwnershipFieldLabels.acquisitionSourceLabel(
            methodName: acquisitionMethodName.isEmpty ? nil : acquisitionMethodName
        )
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("General") {
                    TextField("Nickname", text: $nickname)
                        .help("Optional personal name for this tree")

                    TreeBotanicalHierarchyPickers(
                        genusID: $genusID,
                        speciesID: $speciesID,
                        cultivarID: $cultivarID
                    )

                    LabeledContent("Botanical Name") {
                        Text(botanicalNameDisplay)
                            .foregroundStyle(botanicalName.isEmpty ? .secondary : .primary)
                            .textSelection(.enabled)
                            .id(botanicalName)
                    }
                    .help("Generated automatically from Genus, Species, and Cultivar — not editable")

                    LabeledContent("Bonsai Name") {
                        if isBonsaiNameOverridden {
                            VStack(alignment: .leading, spacing: 4) {
                                HStack(spacing: 8) {
                                    TextField("Bonsai Name", text: $bonsaiName)
                                        .font(.body.monospaced())
                                    Button("Use Generated Name") {
                                        revertBonsaiNameToGenerated()
                                    }
                                    .help("Restore the automatic GEN-SPE-CUL-YYYY-NNN name")
                                }
                                if treeService.isBonsaiNameInUse(bonsaiName) {
                                    Text("That Bonsai Name is already used.")
                                        .font(FaloTypography.caption)
                                        .foregroundStyle(.red)
                                }
                            }
                        } else {
                            HStack(spacing: 8) {
                                Text(bonsaiNameDisplay)
                                    .foregroundStyle(bonsaiName.isEmpty ? .secondary : .primary)
                                    .textSelection(.enabled)
                                    .font(.body.monospaced())
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .id(bonsaiName)
                                Button("Change…") {
                                    showBonsaiNameOverrideAlert = true
                                }
                                .disabled(makeBonsaiNamePreview().isEmpty)
                                .help("Use an existing Bonsai Name instead of the generated one")
                            }
                        }
                    }
                    .help(
                        isBonsaiNameOverridden
                            ? "Custom Bonsai Name — locked after you save"
                            : "Generated automatically as GEN-SPE-CUL-YYYY-NNN from hierarchy and acquisition year"
                    )
                }

                Section("Classification") {
                    referencePicker(
                        title: "Style",
                        selection: $styleID,
                        placeholder: "Select Style",
                        items: referenceData.styles
                    )

                    referencePicker(
                        title: "Size Class",
                        selection: $sizeClassID,
                        placeholder: "Select Size Class",
                        items: referenceData.sizeClasses
                    )

                    referencePicker(
                        title: "Tree Status",
                        selection: $treeStatusID,
                        placeholder: "Select Tree Status",
                        items: referenceData.treeStatuses
                    )
                }

                Section {
                    Picker("Garden", selection: $placementGardenID) {
                        Text("Select Garden").tag(Optional<UUID>.none)
                        ForEach(profile.activeGardens) { garden in
                            Text(garden.isDefault ? "\(garden.name) (Default)" : garden.name)
                                .tag(Optional(garden.id))
                        }
                    }
                    .pickerStyle(.menu)

                    LabeledContent("Location") {
                        Text(locationDisplayName)
                            .foregroundStyle(locationID == nil ? .secondary : .primary)
                    }

                    Button("Select on Map") {
                        isMapPickerPresented = true
                    }
                    .disabled(placementGardenID == nil)
                    .help("Preferred: assign this Tree by choosing a Location on the Garden map.")

                    referenceLocationPicker(
                        title: "Location (list)",
                        selection: $locationID,
                        placeholder: "Select Location",
                        items: locationsForPlacementGarden
                    )

                    referencePicker(
                        title: "Light Condition",
                        selection: $lightConditionID,
                        placeholder: "Select Light Condition",
                        items: referenceData.lightConditions
                    )

                    referencePicker(
                        title: "Soil Mix",
                        selection: $soilMixID,
                        placeholder: "Select Soil Mix",
                        items: referenceData.soilMixes
                    )

                    referencePicker(
                        title: "Pot Type",
                        selection: $potTypeID,
                        placeholder: "Select Pot Type",
                        items: referenceData.potTypes
                    )
                } header: {
                    Text("Growing")
                } footer: {
                    Text("Select on Map is preferred. Trees never store coordinates — the Location owns the map position.")
                        .font(FaloTypography.caption)
                }

                Section {
                    CollectionTokenPicker(
                        collections: treeService.manualCollections,
                        selectedIDs: $selectedCollectionIDs,
                        onCreateNew: presentNewCollection
                    )
                } header: {
                    Text("Collections")
                } footer: {
                    Text("Optional. A tree can belong to more than one collection.")
                        .font(FaloTypography.caption)
                }

                Section("Acquisition") {
                    DatePicker(
                        "Acquisition Date",
                        selection: $acquisitionDate,
                        displayedComponents: .date
                    )

                    referencePicker(
                        title: "Acquisition Method",
                        selection: $acquisitionMethodID,
                        placeholder: "Select Acquisition Method",
                        items: referenceData.acquisitionMethods
                    )

                    TextField(acquisitionSourceFieldLabel, text: $acquisitionSourceName)

                    TextField("Purchase Price (\(appSettings.currency.code))", text: $purchasePriceText)
                        .help("Numeric amount only. Display currency is set in Settings → Regional Settings.")

                    TextField("Acquisition Notes", text: $acquisitionNotes, axis: .vertical)
                        .lineLimit(2...4)
                }

                NewTreeOptionalMeasurementsSection(
                    isExpanded: $isMeasurementsExpanded,
                    measuredAt: $measurementDate,
                    heightMillimetres: $heightMillimetres,
                    crownWidthMillimetres: $crownWidthMillimetres,
                    nebariWidthMillimetres: $nebariWidthMillimetres,
                    trunkDiameterMillimetres: $trunkDiameterMillimetres
                )
            }
            .formStyle(.grouped)
            .faloScrollSurface()
            .navigationTitle(mode.treeEditorTitle(botanicalName: botanicalName))
            .toolbar {
                TreeDetailToolbar(
                    onCancel: handleCancel,
                    onSave: handleSave
                )
            }
            .alert("Could Not Add Tree", isPresented: $saveFailed) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(saveErrorMessage)
            }
            .alert("Change Bonsai Name?", isPresented: $showBonsaiNameOverrideAlert) {
                Button("Cancel", role: .cancel) {}
                Button("Change") {
                    isBonsaiNameOverridden = true
                }
            } message: {
                Text("Bonsai Name is generated as GEN-SPE-CUL-YYYY-NNN from genus, species, cultivar, and acquisition year. After you save, it cannot be changed. Use a custom name only if this tree already has one.")
            }
            .onAppear {
                ensureDefaultPlacement()
                applyPreselectedCollections()
                refreshAutomaticNames()
            }
            .onChange(of: genusID) { _, _ in
                refreshAutomaticNames()
            }
            .onChange(of: speciesID) { _, _ in
                refreshAutomaticNames()
            }
            .onChange(of: cultivarID) { _, _ in
                refreshAutomaticNames()
            }
            .onChange(of: acquisitionDate) { _, _ in
                refreshAutomaticNames()
            }
            .onChange(of: locationID) { _, newID in
                if let newID, let gardenID = referenceData.location(id: newID)?.gardenID {
                    placementGardenID = gardenID
                }
            }
            .sheet(isPresented: $isMapPickerPresented) {
                if let gardenID = placementGardenID {
                    TreeLocationMapPickerSheet(
                        gardenID: gardenID,
                        locationID: $locationID
                    )
                }
            }
            .sheet(isPresented: $isNewLocationPresented, onDismiss: {
                newLocationDraft = nil
            }) {
                if let newLocationDraft {
                    LocationReferenceEditorSheet(draft: newLocationDraft) { savedID in
                        locationID = savedID
                        if let gardenID = referenceData.location(id: savedID)?.gardenID {
                            placementGardenID = gardenID
                        }
                        isNewLocationPresented = false
                        self.newLocationDraft = nil
                    }
                }
            }
            .sheet(isPresented: $isNewCollectionPresented) {
                CollectionEditorView(onCreated: { collectionID in
                    selectedCollectionIDs.insert(collectionID)
                    isNewCollectionPresented = false
                })
            }
        }
        .frame(minHeight: 640)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var locationDisplayName: String {
        guard let locationID,
              let name = referenceData.location(id: locationID)?.name
        else {
            return "Not set — Select on Map"
        }
        return name
    }

    private var locationsForPlacementGarden: [LocationReference] {
        guard let placementGardenID else { return referenceData.locations }
        return referenceData.locations.filter { $0.gardenID == placementGardenID }
    }

    private var botanicalNameDisplay: String {
        let trimmed = botanicalName.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? "Select Genus and Species" : trimmed
    }

    private var bonsaiNameDisplay: String {
        let trimmed = bonsaiName.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? "Select Genus and Species" : trimmed
    }

    /// Regenerates Botanical Name, and Bonsai Name unless the grower overrode it.
    private func refreshAutomaticNames() {
        botanicalName = TreeNamingService.makeBotanicalName(
            genus: genusName,
            species: speciesLabelForNaming,
            cultivar: cultivarName
        )
        if !isBonsaiNameOverridden {
            bonsaiName = makeBonsaiNamePreview()
        }
    }

    private func revertBonsaiNameToGenerated() {
        isBonsaiNameOverridden = false
        bonsaiName = makeBonsaiNamePreview()
    }

    /// Saved Bonsai Name: the typed override if present, otherwise the generated preview.
    private func resolvedBonsaiNameForSave() -> String {
        let trimmed = bonsaiName.trimmingCharacters(in: .whitespacesAndNewlines)
        if isBonsaiNameOverridden, !trimmed.isEmpty {
            return trimmed
        }
        return makeBonsaiNamePreview()
    }

    /// Preview of the permanent Bonsai Name for the current form state (does not consume sequence).
    private func makeBonsaiNamePreview() -> String {
        guard genusName.isEmpty == false, speciesLabelForNaming.isEmpty == false else {
            return ""
        }
        let year = TreeNamingService.acquisitionYear(from: acquisitionDate)
        let sequence: Int = {
            guard let speciesID else { return 1 }
            return treeService.nextBonsaiNameSequence(for: speciesID)
        }()
        return TreeNamingService.makeBonsaiName(
            genusName: genusName,
            speciesName: speciesLabelForNaming,
            cultivarName: cultivarName.isEmpty ? nil : cultivarName,
            acquisitionYear: year,
            sequence: sequence
        )
    }

    private func parsePurchasePrice() -> Decimal? {
        CurrencyFormatting.parseAmount(purchasePriceText)
    }

    private func applyPreselectedCollections() {
        selectedCollectionIDs = appState.newTreePreselectedCollectionIDs
    }

    private func ensureDefaultPlacement() {
        if placementGardenID == nil {
            placementGardenID = profile.defaultGarden?.id
        }
        if let locationID,
           let gardenID = referenceData.location(id: locationID)?.gardenID {
            placementGardenID = gardenID
        }
    }

    private func handleCancel() {
        dismiss()
        appState.dismissTreeEditor()
    }

    /// Gathers current form state into a draft. TreeService owns validation and
    /// Tree construction — this view never builds a `Tree` or checks Location itself.
    private func makeDraft() -> NewTreeDraft {
        NewTreeDraft(
            nickname: nickname,
            botanicalName: botanicalName,
            bonsaiName: resolvedBonsaiNameForSave(),
            genusID: genusID,
            speciesID: speciesID,
            cultivarID: cultivarID,
            styleID: styleID,
            sizeClassID: sizeClassID,
            treeStatusID: treeStatusID,
            locationID: locationID,
            soilMixID: soilMixID,
            potTypeID: potTypeID,
            lightConditionID: lightConditionID,
            acquisitionDate: acquisitionDate,
            acquisitionMethodID: acquisitionMethodID,
            acquisitionSourceName: acquisitionSourceName,
            purchasePrice: parsePurchasePrice(),
            acquisitionNotes: acquisitionNotes
        )
    }

    private func handleSave() {
        do {
            let created = try treeService.createTree(
                fromDraft: makeDraft(),
                validLocationIDs: Set(referenceData.locations.map(\.id)),
                joiningCollectionIDs: selectedCollectionIDs
            )
            let newID = created.id

            if let record = initialMeasurementRecord(for: newID) {
                measurementHistory.append(record)
                try? treeService.applyLatestMeasurement(treeID: newID, from: record)
            }

            dismiss()
            appState.dismissTreeEditor()
            appState.selectedSection = .gardenTrees
            appState.selectedTreeID = newID
        } catch {
            saveErrorMessage = error.localizedDescription.isEmpty
                ? "Something went wrong while adding the tree. Try Save again."
                : error.localizedDescription
            saveFailed = true
        }
    }

    private func presentNewLocation() {
        newLocationDraft = referenceDataManager.blankLocationDraft(
            gardenID: placementGardenID ?? profile.defaultGarden?.id
        )
        isNewLocationPresented = true
    }

    private func presentNewCollection() {
        isNewCollectionPresented = true
    }

    private func initialMeasurementRecord(for treeID: UUID) -> TreeMeasurementRecord? {
        let record = TreeMeasurementRecord(
            treeID: treeID,
            measuredAt: measurementDate,
            heightMillimetres: heightMillimetres,
            crownWidthMillimetres: crownWidthMillimetres,
            nebariWidthMillimetres: nebariWidthMillimetres,
            trunkDiameterMillimetres: trunkDiameterMillimetres,
            notes: ""
        )
        return record.hasAnyValue ? record : nil
    }

    private func referenceLocationPicker(
        title: String,
        selection: Binding<UUID?>,
        placeholder: String,
        items: [LocationReference]
    ) -> some View {
        Picker(title, selection: locationListSelection(selection: selection, items: items)) {
            Text(placeholder).tag(NewTreeLocationListTag.unset)
            ForEach(items) { item in
                Text(item.name).tag(NewTreeLocationListTag.location(item.id))
            }
            Divider()
            Text("+ New Location…").tag(NewTreeLocationListTag.createNew)
        }
    }

    private func locationListSelection(
        selection: Binding<UUID?>,
        items: [LocationReference]
    ) -> Binding<NewTreeLocationListTag> {
        Binding(
            get: {
                guard let id = selection.wrappedValue else { return .unset }
                guard items.contains(where: { $0.id == id }) else { return .unset }
                return .location(id)
            },
            set: { newValue in
                switch newValue {
                case .unset:
                    selection.wrappedValue = nil
                case .location(let id):
                    selection.wrappedValue = id
                case .createNew:
                    presentNewLocation()
                }
            }
        )
    }

    private func referencePicker<Item: Identifiable>(
        title: String,
        selection: Binding<UUID?>,
        placeholder: String,
        items: [Item]
    ) -> some View where Item.ID == UUID, Item: ReferenceNamedItem {
        Picker(title, selection: selection) {
            Text(placeholder).tag(Optional<UUID>.none)
            ForEach(items) { item in
                Text(item.name).tag(Optional(item.id))
            }
        }
    }
}

#Preview {
    let preview = PreviewData()
    let store = ReferencePreviewData()
    return NewTreeView()
        .environment(AppState())
        .environment(AppSettings())
        .environment(UserProfileStore())
        .environment(TreeService.preview(previewData: preview))
        .environment(ReferenceDataService(previewData: store))
        .environment(ReferenceDataManager(store: store))
        .environment(TreeMeasurementHistoryStore(storage: StorageService.shared))
}
