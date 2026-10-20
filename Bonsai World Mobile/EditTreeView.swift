//
//  EditTreeView.swift
//  Bonsai World
//
//  Field Tree edit — Overview fields matching Mac New Tree / Tree Detail Overview.
//  Commits through DemoLibrary on Save. No nested NavigationStack.
//

import SwiftUI

struct EditTreeView: View {
    @Environment(DemoLibrary.self) private var library
    @Environment(\.dismiss) private var dismiss
    @Bindable private var regional = MobileRegionalPreferences.shared

    let treeID: UUID

    @State private var nickname: String = ""
    @State private var locationID: UUID = CanonicalLocationID.altan
    @State private var soilMixID: UUID?
    @State private var potTypeID: UUID?
    @State private var lightConditionID: UUID?
    @State private var styleID: UUID?
    @State private var sizeClassID: UUID?
    @State private var treeStageID: UUID?
    @State private var healthStatus: TreeHealthStatus = .stable
    @State private var healthCause: String = ""
    @State private var notes: String = ""
    @State private var propagation: TreePropagation?
    @State private var acquisitionDate = Date.now
    @State private var knowsAcquisitionDate = false
    @State private var acquisitionMethodID: UUID?
    @State private var acquisitionSourceName = ""
    @State private var purchasePriceText = ""
    @State private var acquisitionNotes = ""
    @State private var knowsLastRepotted = false
    @State private var lastRepottedDate = Date.now
    @State private var plansRepottingInterval = false
    @State private var repottingIntervalYears = 3
    @State private var selectedCollectionIDs: Set<UUID> = []
    @State private var isMeasurementsExpanded = false
    @State private var measurementDate = Date.now
    @State private var heightText = ""
    @State private var crownWidthText = ""
    @State private var nebariWidthText = ""
    @State private var trunkDiameterText = ""

    @State private var styles: [Style] = []
    @State private var sizeClasses: [SizeClass] = []
    @State private var treeStages: [TreeStage] = []
    @State private var lightConditions: [LightCondition] = []
    @State private var potTypes: [PotType] = []
    @State private var acquisitionMethods: [AcquisitionMethod] = []
    @State private var didLoadDraft = false
    @State private var isAssignPotPresented = false
    @State private var confirmRemovePot = false

    private var tree: Tree? { library.tree(id: treeID) }

    private var manualCollections: [Collection] {
        library.collections
            .filter(\.isManual)
            .sorted { $0.name.localizedStandardCompare($1.name) == .orderedAscending }
    }

    private var sourceFieldLabel: String {
        let methodName = acquisitionMethods.first { $0.id == acquisitionMethodID }?.name
        return acquisitionSourceLabel(methodName: methodName)
    }

    private var hasChanges: Bool {
        guard let tree else { return false }
        let expectedCollections = Set(
            manualCollections.filter { $0.treeIDs.contains(treeID) }.map(\.id)
        )
        let measurementPending = isMeasurementsExpanded && hasMeasurementInput
        return nickname != tree.nickname
            || locationID != tree.locationID
            || soilMixID != tree.soilMixID
            || potTypeID != tree.potTypeID
            || lightConditionID != tree.lightConditionID
            || styleID != tree.styleID
            || sizeClassID != tree.sizeClassID
            || treeStageID != tree.treeStageID
            || healthStatus != tree.healthStatus
            || healthCause != tree.healthCause
            || notes != tree.notes
            || propagation != tree.propagation
            || knowsAcquisitionDate != (tree.acquisitionDate != nil)
            || (knowsAcquisitionDate && !Calendar.current.isDate(acquisitionDate, inSameDayAs: tree.acquisitionDate ?? acquisitionDate))
            || acquisitionMethodID != tree.acquisitionMethodID
            || acquisitionSourceName != tree.acquisitionSourceName
            || purchasePriceText != purchasePriceDisplay(tree.purchasePrice)
            || acquisitionNotes != tree.acquisitionNotes
            || knowsLastRepotted != (tree.lastRepottedDate != nil)
            || (knowsLastRepotted && !Calendar.current.isDate(lastRepottedDate, inSameDayAs: tree.lastRepottedDate ?? lastRepottedDate))
            || plansRepottingInterval != (tree.repottingIntervalYears != nil)
            || (plansRepottingInterval && repottingIntervalYears != (tree.repottingIntervalYears ?? repottingIntervalYears))
            || selectedCollectionIDs != expectedCollections
            || measurementPending
    }

    private var hasMeasurementInput: Bool {
        [heightText, crownWidthText, nebariWidthText, trunkDiameterText]
            .contains { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
    }

    var body: some View {
        Group {
            if let tree {
                editorForm(tree)
            } else {
                ContentUnavailableView("Tree not found", systemImage: "leaf")
            }
        }
    }

    private func editorForm(_ tree: Tree) -> some View {
        Form {
            Section("Identity") {
                readOnlyRow(label: "Bonsai Name", value: MobileTreePresentation.bonsaiNameLine(for: tree))
                readOnlyRow(label: "Botanical", value: MobileTreePresentation.botanicalLine(for: tree))
                TextField("Nickname", text: $nickname)
                    .font(FaloTypography.body)
                    .foregroundStyle(BonsaiWorldColors.textPrimary)
                    .accessibilityLabel("Nickname")
            }

            Section("Classification") {
                catalogPicker("Style", selection: $styleID, items: styles)
                catalogPicker("Size Class", selection: $sizeClassID, items: sizeClasses)
                catalogPicker("Tree Stage", selection: $treeStageID, items: treeStages)
            }

            Section("Location") {
                Picker("Location", selection: $locationID) {
                    ForEach(locationOptions) { item in
                        Text(item.name).tag(item.id)
                    }
                }
                .accessibilityLabel("Location")
            }

            Section {
                catalogPicker("Light Condition", selection: $lightConditionID, items: lightConditions)
                Picker("Soil Mix", selection: $soilMixID) {
                    Text("None").tag(Optional<UUID>.none)
                    ForEach(library.orderedSoilMixes) { mix in
                        Text(mix.name).tag(Optional(mix.id))
                    }
                }
                .accessibilityLabel("Soil Mix")
                catalogPicker("Pot Type", selection: $potTypeID, items: potTypes)
            } header: {
                Text("Growing")
            } footer: {
                Text("Pot Type is Tree Pot Description.")
                    .font(FaloTypography.caption)
            }

            Section("Inventory Pot") {
                if let pot = library.pot(linkedToTreeID: treeID) {
                    NavigationLink(value: MobileRoute.pot(pot.id)) {
                        Text(library.displayName(for: pot))
                            .font(FaloTypography.body)
                            .foregroundStyle(BonsaiWorldColors.textPrimary)
                    }
                    Button("Change Inventory Pot") {
                        isAssignPotPresented = true
                    }
                    .accessibilityLabel("Change Inventory Pot")
                    Button("Remove Inventory Pot", role: .destructive) {
                        confirmRemovePot = true
                    }
                    .accessibilityLabel("Remove Inventory Pot")
                } else {
                    Button("Assign Inventory Pot") {
                        isAssignPotPresented = true
                    }
                    .accessibilityLabel("Assign Inventory Pot")
                }
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
                Toggle("Acquisition Date known", isOn: $knowsAcquisitionDate)
                if knowsAcquisitionDate {
                    DatePicker("Acquisition Date", selection: $acquisitionDate, displayedComponents: .date)
                }
                catalogPicker(
                    "Acquisition Method",
                    selection: $acquisitionMethodID,
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
                Text("Optional. Entered values append to Tree Measurement History and update current dimensions.")
                    .font(FaloTypography.caption)
            }

            Section("Health") {
                Picker("Health", selection: $healthStatus) {
                    ForEach(TreeHealthStatus.allCases) { status in
                        Text(status.title).tag(status)
                    }
                }
                .accessibilityLabel("Health")
                TextField("Cause", text: $healthCause)
                    .font(FaloTypography.body)
                    .foregroundStyle(BonsaiWorldColors.textPrimary)
                    .accessibilityLabel("Cause")
            }

            Section("Notes") {
                TextEditor(text: $notes)
                    .frame(minHeight: 88)
                    .font(FaloTypography.body)
                    .foregroundStyle(BonsaiWorldColors.textPrimary)
                    .accessibilityLabel("Notes")
            }
        }
        .scrollContentBackground(.hidden)
        .background(BonsaiWorldColors.canvas)
        .scrollDismissesKeyboard(.interactively)
        .navigationTitle("Edit Tree")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") { dismiss() }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") { save() }
                    .fontWeight(.semibold)
                    .disabled(!hasChanges)
            }
        }
        .toolbarBackground(BonsaiWorldColors.canvas, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarColorScheme(.light, for: .navigationBar)
        .onAppear {
            guard !didLoadDraft else { return }
            loadCatalogs()
            loadDraft(from: tree)
            didLoadDraft = true
        }
        .sheet(isPresented: $isAssignPotPresented) {
            AssignInventoryPotView(
                treeID: treeID,
                excludingPotID: library.pot(linkedToTreeID: treeID)?.id
            )
        }
        .confirmationDialog(
            "Remove inventory pot from this tree?",
            isPresented: $confirmRemovePot,
            titleVisibility: .visible
        ) {
            Button("Remove Inventory Pot", role: .destructive) {
                _ = library.unassignCurrentPot(fromTreeID: treeID)
            }
            Button("Cancel", role: .cancel) {}
        }
    }

    private var locationOptions: [CanonicalLocationID.Item] {
        var items = library.orderedLocations.map {
            CanonicalLocationID.Item(id: $0.id, name: $0.name)
        }
        if !items.contains(where: { $0.id == locationID }) {
            let name = library.locationName(for: locationID)
                ?? CanonicalLocationID.name(for: locationID)
                ?? ""
            items.insert(CanonicalLocationID.Item(id: locationID, name: name), at: 0)
        }
        return items
    }

    private func loadCatalogs() {
        styles = StylePreviewData.all.filter(\.isActive).sorted { $0.sortOrder < $1.sortOrder }
        sizeClasses = SizeClassPreviewData.all.filter(\.isActive).sorted { $0.sortOrder < $1.sortOrder }
        treeStages = TreeStagePreviewData.all.filter(\.isActive).sorted { $0.sortOrder < $1.sortOrder }
        lightConditions = LightConditionPreviewData.all.filter(\.isActive).sorted { $0.sortOrder < $1.sortOrder }
        potTypes = PotTypePreviewData.all.filter(\.isActive).sorted { $0.sortOrder < $1.sortOrder }
        acquisitionMethods = AcquisitionMethodPreviewData.all.filter(\.isActive).sorted { $0.sortOrder < $1.sortOrder }
    }

    private func loadDraft(from tree: Tree) {
        nickname = tree.nickname
        locationID = tree.locationID
        soilMixID = tree.soilMixID
        potTypeID = tree.potTypeID
        lightConditionID = tree.lightConditionID
        styleID = tree.styleID
        sizeClassID = tree.sizeClassID
        treeStageID = tree.treeStageID
        healthStatus = tree.healthStatus
        healthCause = tree.healthCause
        notes = tree.notes
        propagation = tree.propagation
        if let date = tree.acquisitionDate {
            knowsAcquisitionDate = true
            acquisitionDate = date
        }
        acquisitionMethodID = tree.acquisitionMethodID
        acquisitionSourceName = tree.acquisitionSourceName
        purchasePriceText = purchasePriceDisplay(tree.purchasePrice)
        acquisitionNotes = tree.acquisitionNotes
        if let date = tree.lastRepottedDate {
            knowsLastRepotted = true
            lastRepottedDate = date
        }
        if let years = tree.repottingIntervalYears {
            plansRepottingInterval = true
            repottingIntervalYears = years
        }
        selectedCollectionIDs = Set(
            manualCollections.filter { $0.treeIDs.contains(treeID) }.map(\.id)
        )
    }

    @ViewBuilder
    private func readOnlyRow(label: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
            Text(label)
                .font(FaloTypography.caption)
                .foregroundStyle(BonsaiWorldColors.textSecondary)
            Text(value)
                .font(FaloTypography.body)
                .foregroundStyle(BonsaiWorldColors.textPrimary)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(label), \(value)")
    }

    private func catalogPicker<Item: EditTreeCatalogRow>(
        _ title: String,
        selection: Binding<UUID?>,
        items: [Item]
    ) -> some View {
        Picker(title, selection: selection) {
            Text("Select \(title)").tag(Optional<UUID>.none)
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

    private func save() {
        library.updateTree(
            id: treeID,
            nickname: nickname,
            locationID: locationID,
            soilMixID: soilMixID,
            potTypeID: potTypeID,
            lightConditionID: lightConditionID,
            styleID: styleID,
            sizeClassID: sizeClassID,
            treeStageID: treeStageID,
            propagation: propagation,
            acquisitionDate: knowsAcquisitionDate ? acquisitionDate : nil,
            acquisitionMethodID: acquisitionMethodID,
            acquisitionSourceName: acquisitionSourceName,
            purchasePrice: decimal(from: purchasePriceText),
            acquisitionNotes: acquisitionNotes,
            lastRepottedDate: knowsLastRepotted ? lastRepottedDate : nil,
            repottingIntervalYears: plansRepottingInterval ? repottingIntervalYears : nil,
            notes: notes,
            healthStatus: healthStatus,
            healthCause: healthCause,
            manualCollectionIDs: selectedCollectionIDs
        )
        if isMeasurementsExpanded, hasMeasurementInput {
            let system = regional.measurementSystem
            library.appendTreeMeasurement(
                treeID: treeID,
                measuredAt: measurementDate,
                heightMillimetres: MobileRegionalPreferences.millimetres(
                    fromDisplayText: heightText, role: .height, system: system
                ),
                crownWidthMillimetres: MobileRegionalPreferences.millimetres(
                    fromDisplayText: crownWidthText, role: .width, system: system
                ),
                nebariWidthMillimetres: MobileRegionalPreferences.millimetres(
                    fromDisplayText: nebariWidthText, role: .width, system: system
                ),
                trunkDiameterMillimetres: MobileRegionalPreferences.millimetres(
                    fromDisplayText: trunkDiameterText, role: .diameter, system: system
                )
            )
        }
        dismiss()
    }

    private func purchasePriceDisplay(_ price: Decimal?) -> String {
        guard let price else { return "" }
        return "\(price)"
    }

    private func decimal(from raw: String) -> Decimal? {
        let trimmed = raw.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return nil }
        return Decimal(string: trimmed.replacingOccurrences(of: ",", with: "."))
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

private protocol EditTreeCatalogRow: Identifiable where ID == UUID {
    var name: String { get }
}

extension Style: EditTreeCatalogRow {}
extension SizeClass: EditTreeCatalogRow {}
extension TreeStage: EditTreeCatalogRow {}
extension LightCondition: EditTreeCatalogRow {}
extension PotType: EditTreeCatalogRow {}
extension AcquisitionMethod: EditTreeCatalogRow {}

#Preview {
    NavigationStack {
        EditTreeView(treeID: DemoLibrary.sampleTrees[0].id)
    }
    .environment(DemoLibrary.preview)
}
