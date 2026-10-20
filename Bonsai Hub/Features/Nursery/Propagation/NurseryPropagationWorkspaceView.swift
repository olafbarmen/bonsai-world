//
//  NurseryPropagationWorkspaceView.swift
//  Bonsai World
//
//  Nursery → Cuttings / Air Layers / Grafting — list ↔ detail (v1).
//

import SwiftUI

struct NurseryPropagationWorkspaceView: View {
    let kind: NurseryPropagationKind

    @Environment(AppState.self) private var appState
    @Environment(NurseryPropagationService.self) private var service

    @State private var isCreatePresented = false

    private var selectedID: UUID? {
        appState.selectedNurseryPropagationProjectID(for: kind)
    }

    private var usesSplitListDetail: Bool {
        switch kind {
        case .cutting, .airLayer, .grafting: true
        case .fieldTree: false
        }
    }

    var body: some View {
        Group {
            if let openedID = appState.openedNurseryProjectID,
               openedID == selectedID,
               service.project(id: openedID) != nil {
                NurseryPropagationDetailView(kind: kind, projectID: openedID)
            } else if usesSplitListDetail {
                vegetativeSplitWorkspace
            } else if let selectedID, service.project(id: selectedID) != nil {
                NurseryPropagationDetailView(kind: kind, projectID: selectedID)
            } else {
                NurseryPropagationListView(kind: kind, isCreatePresented: $isCreatePresented)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .faloWorkspaceCanvas()
        .bonsaiWorkspaceNavigationTitle(
            kind.title,
            onBack: appState.openedNurseryProjectID == nil ? nil : { appState.showCurrentList() }
        )
        .sheet(isPresented: $isCreatePresented) {
            NewNurseryPropagationProjectView(kind: kind)
        }
        .onAppear { consumeWantsNewNurseryProject() }
        .onChange(of: appState.wantsNewNurseryPropagationKind) { _, pending in
            guard pending == kind else { return }
            consumeWantsNewNurseryProject()
        }
    }

    /// List stays on top; detail scrolls below — same rhythm as Garden → Trees.
    private var vegetativeSplitWorkspace: some View {
        VSplitView {
            NurseryVegetativeListView(kind: kind)
                .frame(minHeight: 120, idealHeight: 240)

            vegetativeDetailPane
                .frame(minHeight: 200)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .faloWorkspaceCanvas()
        }
    }

    @ViewBuilder
    private var vegetativeDetailPane: some View {
        if let selectedID, service.project(id: selectedID) != nil {
            NurseryPropagationDetailView(kind: kind, projectID: selectedID)
        } else {
            ContentUnavailableView(
                "Select a \(kind.singularTitle)",
                systemImage: kind.systemImage,
                description: Text("Choose a row above to see details. Double-click to open.")
            )
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }

    private func consumeWantsNewNurseryProject() {
        guard appState.wantsNewNurseryPropagationKind == kind else { return }
        isCreatePresented = true
        appState.wantsNewNurseryPropagationKind = nil
    }
}

struct NurseryPropagationListView: View {
    let kind: NurseryPropagationKind
    @Binding var isCreatePresented: Bool

    @Environment(AppState.self) private var appState
    @Environment(NurseryPropagationService.self) private var service

    private var active: [NurseryPropagationProject] {
        service.activeProjects(kind: kind)
    }

    private var archived: [NurseryPropagationProject] {
        service.projects(kind: kind).filter { !$0.isActive }
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: FaloSpacing.xxLarge) {
                VStack(alignment: .leading, spacing: FaloSpacing.small) {
                    Text(kind.title)
                        .font(FaloTypography.headline)
                    Text(NurseryPropagationKind.sharedTrackerHonestyLine)
                        .font(FaloTypography.caption)
                        .foregroundStyle(.secondary)
                    Text("\(active.count) active · \(archived.count) completed / archived")
                        .font(FaloTypography.caption)
                        .foregroundStyle(.secondary)
                }

                DetailCard(title: "Active Projects") {
                    if active.isEmpty {
                        Text("No active \(kind.title.lowercased()). Create a project to start.")
                            .font(FaloTypography.body)
                            .foregroundStyle(.secondary)
                    } else {
                        ForEach(active) { project in
                            projectButton(project)
                        }
                    }
                }

                if !archived.isEmpty {
                    DetailCard(title: "Completed & Archived") {
                        ForEach(archived) { project in
                            projectButton(project)
                        }
                    }
                }
            }
            .padding(FaloSpacing.xLarge)
            .frame(maxWidth: 900, alignment: .leading)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .faloScrollSurface()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func projectButton(_ project: NurseryPropagationProject) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(project.botanicalName)
                .font(FaloCardTypography.fieldValue)
                .foregroundStyle(.primary)
            Text("\(project.quantity) · \(project.stage.title(for: project.kind)) · \(project.projectCode)")
                .font(FaloTypography.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, FaloSpacing.xSmall)
        .contentShape(Rectangle())
        .onTapGesture(count: 2) {
            openProject(project)
        }
        .onTapGesture(count: 1) {
            openProject(project)
        }
        .help("Click or double-click to open")
    }

    private func openProject(_ project: NurseryPropagationProject) {
        appState.setSelectedNurseryPropagationProjectID(project.id, for: kind)
    }
}

struct NurseryPropagationDetailView: View {
    let kind: NurseryPropagationKind
    let projectID: UUID

    @Environment(AppState.self) private var appState
    @Environment(NurseryPropagationService.self) private var service
    @Environment(ReferenceDataService.self) private var referenceData
    @Environment(TreeService.self) private var treeService
    @Environment(TaskService.self) private var taskService

    @State private var errorMessage: String?
    @State private var isCreateTreesPresented = false
    @State private var isAddTaskPresented = false
    @State private var treeCount = "1"
    @State private var treeLocationID: UUID?
    @State private var notesDraft = ""
    @State private var genusID: UUID?
    @State private var speciesID: UUID?
    @State private var cultivarID: UUID?
    @State private var plantedAt: Date = .now
    @State private var detailLocationID: UUID?
    @State private var commonNameDraft = ""
    @State private var botanicalNameDraft = ""
    @State private var quantityDraft = "1"
    @State private var parentTreeIDDraft: UUID?

    @State private var cuttingTakenAt: Date = .now
    @State private var cuttingRootMedium = ""
    @State private var cuttingSoilMix = ""
    @State private var cuttingLength = ""
    @State private var cuttingLeafCountText = ""
    @State private var cuttingWoodMaturity: NurseryCuttingWoodMaturity?
    @State private var cuttingWoodMaturityOverride = ""
    @State private var cuttingBaseTechnique: NurseryCuttingBaseTechnique?
    @State private var cuttingBaseTechniqueOverride = ""
    @State private var cuttingStructure: NurseryCuttingStructure?
    @State private var cuttingStructureOverride = ""

    @State private var airLayerStartedAt: Date = .now
    @State private var airLayerMethod: NurseryAirLayerMethod? = .completeRing
    @State private var airLayerMethodOverride = ""
    @State private var airLayerRingWidthText = ""
    @State private var airLayerLayerDiameterText = ""
    @State private var airLayerLocation: NurseryAirLayerLocation?
    @State private var airLayerLocationOverride = ""
    @State private var airLayerRootingAid: NurseryAirLayerRootingAid? = .none
    @State private var airLayerRootingAidOverride = ""
    @State private var airLayerHormoneProduct = ""
    @State private var airLayerHormoneConcentration = ""
    @State private var airLayerMediumPreset: NurseryAirLayerMediumPreset? = .longFiberSphagnum
    @State private var airLayerMediumCustom = ""
    @State private var airLayerWrapSystem: NurseryAirLayerWrapSystem?
    @State private var airLayerWrapSystemOverride = ""
    @State private var airLayerPurpose: NurseryAirLayerPurpose?
    @State private var airLayerPurposeOverride = ""
    @State private var airLayerRootDevelopment: NurseryAirLayerRootDevelopment? = .noRoots
    @State private var airLayerWinterCare = false
    @State private var airLayerWinterCareNotes = ""
    @State private var airLayerSeparated = false
    @State private var airLayerSeparationDate: Date = .now
    @State private var airLayerSeparationNotes = ""
    @State private var isWrapCheckPresented = false

    private var project: NurseryPropagationProject? {
        service.project(id: projectID)
    }

    private var isEditingFieldTree: Bool {
        kind == .fieldTree && appState.fieldTreeDetailInteractionMode == .editing
    }

    private var isEditingVegetative: Bool {
        kind != .fieldTree && appState.nurseryPropagationDetailInteractionMode == .editing
    }

    private var linkedPendingTasks: [CareTask] {
        taskService.tasks.filter {
            $0.status == .pending && $0.nurseryPropagationProjectIDs.contains(projectID)
        }
        .sorted { $0.dueDate < $1.dueDate }
    }

    var body: some View {
        Group {
            if let project {
                content(project)
            } else {
                ContentUnavailableView("Project not found", systemImage: kind.systemImage)
            }
        }
    }

    @ViewBuilder
    private func content(_ project: NurseryPropagationProject) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: FaloSpacing.xxLarge) {
                header(project)
                if kind == .fieldTree {
                    if isEditingFieldTree {
                        fieldTreeIdentityCard(project)
                    } else {
                        fieldTreeSummaryCard(project)
                        fieldTreeTasksCard
                    }
                } else if isEditingVegetative {
                    vegetativeEditCard(project)
                } else {
                    vegetativeSummaryCard(project)
                    knowledgeAndSuccessCard(project)
                    if kind == .airLayer {
                        airLayerTasksCard(project)
                    }
                }
                if !isEditingFieldTree && !isEditingVegetative {
                    actions(project)
                }
                if (kind != .fieldTree || isEditingFieldTree) && !isEditingVegetative {
                    notesCard(project)
                }
                if !isEditingVegetative {
                    eventsCard(project)
                }
            }
            .padding(FaloSpacing.xLarge)
            .frame(maxWidth: 900, alignment: .leading)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .faloScrollSurface()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .alert("Could not update", isPresented: Binding(
            get: { errorMessage != nil },
            set: { if !$0 { errorMessage = nil } }
        )) {
            Button("OK", role: .cancel) { errorMessage = nil }
        } message: {
            Text(errorMessage ?? "")
        }
        .sheet(isPresented: $isCreateTreesPresented) {
            createTreesSheet(project)
        }
        .sheet(isPresented: $isAddTaskPresented) {
            NavigationStack {
                AddTaskSheet(preselectedNurseryPropagationProjectID: project.id)
            }
            .frame(minWidth: 480, minHeight: 520)
        }
        .onAppear { loadDrafts(from: project) }
        .onChange(of: appState.nurseryPropagationDetailInteractionMode) { _, mode in
            if mode == .editing { loadDrafts(from: project) }
        }
        .onChange(of: appState.wantsAddFieldTreeTask) { _, wants in
            guard kind == .fieldTree, wants else { return }
            isAddTaskPresented = true
            appState.wantsAddFieldTreeTask = false
        }
    }

    private func loadDrafts(from project: NurseryPropagationProject) {
        notesDraft = project.notes
        treeLocationID = project.locationID ?? referenceData.locations.first?.id
        genusID = project.genusID
        speciesID = project.speciesID
        cultivarID = project.cultivarID
        plantedAt = project.plantedAt ?? project.createdAt
        detailLocationID = project.locationID
        commonNameDraft = project.commonName
        botanicalNameDraft = project.botanicalName
        quantityDraft = "\(project.quantity)"
        parentTreeIDDraft = project.parentTreeID
        cuttingTakenAt = project.cuttingTakenAt ?? project.createdAt
        cuttingRootMedium = project.cuttingRootMedium
        cuttingSoilMix = project.cuttingSoilMix
        cuttingLength = project.cuttingLength
        cuttingLeafCountText = project.cuttingLeafCount.map(String.init) ?? ""
        cuttingWoodMaturity = project.cuttingWoodMaturity
        cuttingWoodMaturityOverride = project.cuttingWoodMaturityOverride
        cuttingBaseTechnique = project.cuttingBaseTechnique
        cuttingBaseTechniqueOverride = project.cuttingBaseTechniqueOverride
        cuttingStructure = project.cuttingStructure
        cuttingStructureOverride = project.cuttingStructureOverride
        airLayerStartedAt = project.airLayerStartedAt ?? project.createdAt
        airLayerMethod = project.airLayerMethod ?? .completeRing
        airLayerMethodOverride = project.airLayerMethodOverride
        airLayerRingWidthText = project.airLayerRingWidthMM.map(formatMMDraft) ?? ""
        airLayerLayerDiameterText = project.airLayerLayerDiameterMM.map(formatMMDraft) ?? ""
        airLayerLocation = project.airLayerLocation
        airLayerLocationOverride = project.airLayerLocationOverride
        airLayerRootingAid = project.airLayerRootingAid ?? .none
        airLayerRootingAidOverride = project.airLayerRootingAidOverride
        airLayerHormoneProduct = project.airLayerHormoneProduct
        airLayerHormoneConcentration = project.airLayerHormoneConcentration
        airLayerMediumPreset = project.airLayerMediumPreset
        airLayerMediumCustom = project.airLayerMediumCustom
        airLayerWrapSystem = project.airLayerWrapSystem
        airLayerWrapSystemOverride = project.airLayerWrapSystemOverride
        airLayerPurpose = project.airLayerPurpose
        airLayerPurposeOverride = project.airLayerPurposeOverride
        airLayerRootDevelopment = project.airLayerRootDevelopment ?? .noRoots
        airLayerWinterCare = project.airLayerWinterCare ?? false
        airLayerWinterCareNotes = project.airLayerWinterCareNotes
        airLayerSeparated = project.airLayerSeparated
        airLayerSeparationDate = project.airLayerSeparationDate ?? .now
        airLayerSeparationNotes = project.airLayerSeparationNotes
    }

    private func formatMMDraft(_ value: Double) -> String {
        value.rounded() == value ? String(Int(value)) : String(format: "%.1f", value)
    }

    private func parseMM(_ text: String) -> Double? {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return nil }
        return Double(trimmed.replacingOccurrences(of: ",", with: "."))
    }

    private func vegetativeSummaryCard(_ project: NurseryPropagationProject) -> some View {
        DetailCard(title: kind.singularTitle) {
            VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
                Text("Use Context Tools → Edit \(kind.singularTitle) to change quantity, identity, technique, parent, location, and notes.")
                    .font(FaloTypography.caption)
                    .foregroundStyle(.secondary)
                DetailLabeledRow(label: "Quantity", value: "\(project.quantity)")
                if let locationID = project.locationID,
                   let location = referenceData.location(id: locationID) {
                    DetailLabeledRow(label: "Location", value: location.name)
                }
                if let parentTreeID = project.parentTreeID,
                   let parent = treeService.getTree(id: parentTreeID) {
                    DetailLabeledRow(
                        label: kind == .airLayer ? "Mother plant" : "Parent tree",
                        value: parent.bonsaiName.isEmpty ? parent.botanicalName : parent.bonsaiName
                    )
                }
                NurseryPropagationTechniqueSummaryRows(project: project)
            }
        }
    }

    private func knowledgeAndSuccessCard(_ project: NurseryPropagationProject) -> some View {
        NurseryPropagationKnowledgeCard(
            kind: kind,
            project: project,
            successRate: service.successRate(kind: kind),
            speciesSuccessRate: project.speciesID.map { service.successRate(kind: kind, speciesID: $0) },
            onOpenSpeciesProfile: project.speciesID.map { speciesID in
                { appState.openSpeciesProfile(speciesID: speciesID) }
            }
        )
    }

    private func vegetativeEditCard(_ project: NurseryPropagationProject) -> some View {
        DetailCard(title: "Edit \(kind.singularTitle)") {
            VStack(alignment: .leading, spacing: FaloSpacing.medium) {
                TextField("Quantity", text: $quantityDraft)
                Picker(kind == .airLayer ? "Mother plant" : "Parent tree", selection: $parentTreeIDDraft) {
                    if kind != .airLayer {
                        Text("None — enter manually").tag(UUID?.none)
                    }
                    ForEach(treeService.trees.sorted {
                        ($0.bonsaiName.isEmpty ? $0.botanicalName : $0.bonsaiName)
                            < ($1.bonsaiName.isEmpty ? $1.botanicalName : $1.bonsaiName)
                    }) { tree in
                        Text(tree.bonsaiName.isEmpty ? tree.botanicalName : tree.bonsaiName)
                            .tag(Optional(tree.id))
                    }
                }
                .onChange(of: parentTreeIDDraft) { _, newValue in
                    guard let newValue, let tree = treeService.getTree(id: newValue) else { return }
                    genusID = tree.genusID
                    speciesID = tree.speciesID
                    cultivarID = tree.cultivarID
                    botanicalNameDraft = tree.botanicalName
                    if commonNameDraft.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
                       let speciesID = tree.speciesID,
                       let profile = SpeciesProfileCatalog.profile(
                        speciesID: speciesID,
                        cultivarID: tree.cultivarID
                       ) {
                        commonNameDraft = profile.primaryCommonName
                    }
                    syncVegetativeBotanicalName()
                }
                TreeBotanicalHierarchyPickers(
                    genusID: $genusID,
                    speciesID: $speciesID,
                    cultivarID: $cultivarID
                )
                .onChange(of: genusID) { _, _ in syncVegetativeBotanicalName() }
                .onChange(of: speciesID) { _, _ in syncVegetativeBotanicalName() }
                .onChange(of: cultivarID) { _, _ in syncVegetativeBotanicalName() }
                TextField("Botanical name", text: $botanicalNameDraft)
                TextField("Common name", text: $commonNameDraft)
                Picker("Location", selection: $detailLocationID) {
                    Text("None").tag(UUID?.none)
                    ForEach(referenceData.locations) { location in
                        Text(location.name).tag(Optional(location.id))
                    }
                }
                TextField("Notes", text: $notesDraft, axis: .vertical)
                    .lineLimit(3...6)
                if kind == .cutting {
                    Group {
                        DatePicker("Date taken", selection: $cuttingTakenAt, displayedComponents: .date)
                        TextField("Root medium", text: $cuttingRootMedium)
                        TextField("Soil mix", text: $cuttingSoilMix)
                        TextField("Length", text: $cuttingLength)
                        TextField("Leaf count", text: $cuttingLeafCountText)
                        Picker("Wood maturity", selection: $cuttingWoodMaturity) {
                            Text("Choose…").tag(NurseryCuttingWoodMaturity?.none)
                            ForEach(NurseryCuttingWoodMaturity.allCases) { value in
                                Text(value.title).tag(Optional(value))
                            }
                        }
                        TextField("Wood maturity override", text: $cuttingWoodMaturityOverride)
                        Picker("Base technique", selection: $cuttingBaseTechnique) {
                            Text("Choose…").tag(NurseryCuttingBaseTechnique?.none)
                            ForEach(NurseryCuttingBaseTechnique.allCases) { value in
                                Text(value.title).tag(Optional(value))
                            }
                        }
                        TextField("Base technique override", text: $cuttingBaseTechniqueOverride)
                        Picker("Structure", selection: $cuttingStructure) {
                            Text("Choose…").tag(NurseryCuttingStructure?.none)
                            ForEach(NurseryCuttingStructure.allCases) { value in
                                Text(value.title).tag(Optional(value))
                            }
                        }
                        TextField("Structure override", text: $cuttingStructureOverride)
                    }
                }
                if kind == .airLayer {
                    NurseryAirLayerTechniqueFormFields(
                        startedAt: $airLayerStartedAt,
                        method: $airLayerMethod,
                        methodOverride: $airLayerMethodOverride,
                        ringWidthText: $airLayerRingWidthText,
                        layerDiameterText: $airLayerLayerDiameterText,
                        location: $airLayerLocation,
                        locationOverride: $airLayerLocationOverride,
                        rootingAid: $airLayerRootingAid,
                        rootingAidOverride: $airLayerRootingAidOverride,
                        hormoneProduct: $airLayerHormoneProduct,
                        hormoneConcentration: $airLayerHormoneConcentration,
                        mediumPreset: $airLayerMediumPreset,
                        mediumCustom: $airLayerMediumCustom,
                        wrapSystem: $airLayerWrapSystem,
                        wrapSystemOverride: $airLayerWrapSystemOverride,
                        purpose: $airLayerPurpose,
                        purposeOverride: $airLayerPurposeOverride,
                        rootDevelopment: $airLayerRootDevelopment,
                        winterCare: $airLayerWinterCare,
                        winterCareNotes: $airLayerWinterCareNotes,
                        separated: $airLayerSeparated,
                        separationDate: $airLayerSeparationDate,
                        separationNotes: $airLayerSeparationNotes
                    )
                }
                Button("Save") {
                    saveVegetativeEdits(project)
                }
                .buttonStyle(.borderedProminent)
                .disabled(botanicalNameDraft.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                    || (Int(quantityDraft) ?? 0) < 1
                    || (kind == .airLayer && parentTreeIDDraft == nil))
                Text("Or use Context Tools → Finish after Save.")
                    .font(FaloTypography.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }

    private func syncVegetativeBotanicalName() {
        let genusName = genusID.flatMap { referenceData.genus(id: $0)?.name } ?? ""
        let species = speciesID.flatMap { referenceData.species(id: $0) }
        let speciesPart = species.map { $0.epithet.isEmpty ? $0.name : $0.epithet } ?? ""
        let cultivarName = cultivarID.flatMap { referenceData.cultivar(id: $0)?.name }
        let name = TreeNamingService.makeBotanicalName(
            genus: genusName,
            species: speciesPart,
            cultivar: cultivarName
        )
        if !name.isEmpty {
            botanicalNameDraft = name
        }
    }

    private func saveVegetativeEdits(_ project: NurseryPropagationProject) {
        guard let quantity = Int(quantityDraft.trimmingCharacters(in: .whitespacesAndNewlines)),
              quantity > 0 else {
            errorMessage = "Quantity must be at least 1."
            return
        }
        let leafCount: Int?
        let leafTrimmed = cuttingLeafCountText.trimmingCharacters(in: .whitespacesAndNewlines)
        if leafTrimmed.isEmpty {
            leafCount = nil
        } else if let value = Int(leafTrimmed), value >= 0 {
            leafCount = value
        } else {
            errorMessage = "Leaf count must be a whole number."
            return
        }
        run {
            _ = try service.updateVegetativeProjectDetails(
                projectID: project.id,
                genusID: genusID,
                speciesID: speciesID,
                cultivarID: cultivarID,
                botanicalName: botanicalNameDraft,
                commonName: commonNameDraft,
                parentTreeID: parentTreeIDDraft,
                quantity: quantity,
                locationID: detailLocationID,
                notes: notesDraft,
                cuttingTakenAt: kind == .cutting ? cuttingTakenAt : nil,
                cuttingRootMedium: cuttingRootMedium,
                cuttingSoilMix: cuttingSoilMix,
                cuttingLength: cuttingLength,
                cuttingLeafCount: leafCount,
                cuttingWoodMaturity: cuttingWoodMaturity,
                cuttingWoodMaturityOverride: cuttingWoodMaturityOverride,
                cuttingBaseTechnique: cuttingBaseTechnique,
                cuttingBaseTechniqueOverride: cuttingBaseTechniqueOverride,
                cuttingStructure: cuttingStructure,
                cuttingStructureOverride: cuttingStructureOverride,
                airLayerMethod: airLayerMethod,
                airLayerMethodOverride: airLayerMethodOverride,
                airLayerRingWidthMM: parseMM(airLayerRingWidthText),
                airLayerLayerDiameterMM: parseMM(airLayerLayerDiameterText),
                airLayerLocation: airLayerLocation,
                airLayerLocationOverride: airLayerLocationOverride,
                airLayerRootingAid: airLayerRootingAid,
                airLayerRootingAidOverride: airLayerRootingAidOverride,
                airLayerHormoneProduct: airLayerHormoneProduct,
                airLayerHormoneConcentration: airLayerHormoneConcentration,
                airLayerMediumPreset: airLayerMediumPreset,
                airLayerMediumCustom: airLayerMediumCustom,
                airLayerWrapSystem: airLayerWrapSystem,
                airLayerWrapSystemOverride: airLayerWrapSystemOverride,
                airLayerPurpose: airLayerPurpose,
                airLayerPurposeOverride: airLayerPurposeOverride,
                airLayerRootDevelopment: airLayerRootDevelopment,
                airLayerStartedAt: kind == .airLayer ? airLayerStartedAt : nil,
                airLayerWinterCare: kind == .airLayer ? airLayerWinterCare : nil,
                airLayerWinterCareNotes: airLayerWinterCareNotes,
                airLayerSeparated: kind == .airLayer ? airLayerSeparated : false,
                airLayerSeparationDate: kind == .airLayer && airLayerSeparated ? airLayerSeparationDate : nil,
                airLayerSeparationNotes: airLayerSeparationNotes
            )
            appState.nurseryPropagationDetailInteractionMode = .viewing
        }
    }

    private func fieldTreeSummaryCard(_ project: NurseryPropagationProject) -> some View {
        DetailCard(title: "Field Tree") {
            VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
                Text("Use Context Tools → Edit Field Tree to change identity. Add Task links checks and field work to this project.")
                    .font(FaloTypography.caption)
                    .foregroundStyle(.secondary)
                if let plantedAt = project.plantedAt {
                    DetailLabeledRow(
                        label: "Planted",
                        value: plantedAt.formatted(date: .abbreviated, time: .omitted)
                    )
                }
                if let locationID = project.locationID,
                   let location = referenceData.location(id: locationID) {
                    DetailLabeledRow(label: "Location", value: location.name)
                }
                if !project.commonName.isEmpty {
                    DetailLabeledRow(label: "Label", value: project.commonName)
                }
            }
        }
    }

    private var fieldTreeTasksCard: some View {
        DetailCard(title: "Tasks") {
            if linkedPendingTasks.isEmpty {
                Text("No pending Tasks for this Field Tree. Use Context Tools → Add Task.")
                    .font(FaloTypography.caption)
                    .foregroundStyle(.secondary)
            } else {
                ForEach(linkedPendingTasks) { task in
                    VStack(alignment: .leading, spacing: 2) {
                        Text(task.title)
                            .font(FaloCardTypography.fieldValue)
                        Text(task.dueDate.formatted(date: .abbreviated, time: .omitted))
                            .font(FaloTypography.caption)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 4)
                }
            }
        }
    }

    @ViewBuilder
    private func airLayerTasksCard(_ project: NurseryPropagationProject) -> some View {
        let tasks = service.pendingTasks(for: project.id)
        DetailCard(title: "Wrap checks") {
            if let root = project.airLayerRootDevelopment {
                DetailLabeledRow(label: "Root development", value: root.title)
            }
            if tasks.isEmpty {
                Text("No pending Tasks. Creating an Air Layer schedules Air Layer and Check tasks.")
                    .font(FaloTypography.caption)
                    .foregroundStyle(.secondary)
            } else {
                ForEach(tasks) { task in
                    VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
                        Text(task.title)
                            .font(FaloCardTypography.fieldValue)
                        Text("Due \(task.dueDate.formatted(date: .abbreviated, time: .omitted))")
                            .font(FaloTypography.caption)
                            .foregroundStyle(.secondary)
                        if task.id == project.nextCheckTaskID
                            || task.title.localizedCaseInsensitiveContains("Check air layer") {
                            Button("Complete Wrap Check") {
                                isWrapCheckPresented = true
                            }
                            .buttonStyle(.bordered)
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
        }
        .sheet(isPresented: $isWrapCheckPresented) {
            NurseryAirLayerWrapCheckSheet(projectID: project.id) { root, moisture, notes in
                run {
                    _ = try service.completeAirLayerCheck(
                        projectID: project.id,
                        rootDevelopment: root,
                        moisture: moisture,
                        notes: notes
                    )
                }
            }
        }
    }

    private func fieldTreeIdentityCard(_ project: NurseryPropagationProject) -> some View {
        DetailCard(title: "Field Tree") {
            VStack(alignment: .leading, spacing: FaloSpacing.medium) {
                Text("One individual in the ground. Work continues in Tasks and Work until Generate Tree.")
                    .font(FaloTypography.caption)
                    .foregroundStyle(.secondary)
                DatePicker("Planted", selection: $plantedAt, displayedComponents: .date)
                TreeBotanicalHierarchyPickers(
                    genusID: $genusID,
                    speciesID: $speciesID,
                    cultivarID: $cultivarID
                )
                LabeledContent("Botanical name") {
                    Text(fieldTreeBotanicalName)
                        .foregroundStyle(fieldTreeBotanicalName.isEmpty ? .secondary : .primary)
                }
                TextField("Common name / label", text: $commonNameDraft)
                Picker("Location", selection: $detailLocationID) {
                    Text("None").tag(UUID?.none)
                    ForEach(referenceData.locations) { location in
                        Text(location.name).tag(Optional(location.id))
                    }
                }
                Button("Save Field Tree") {
                    run {
                        _ = try service.updateFieldTreeDetails(
                            projectID: project.id,
                            genusID: genusID,
                            speciesID: speciesID,
                            cultivarID: cultivarID,
                            botanicalName: fieldTreeBotanicalName,
                            commonName: commonNameDraft,
                            plantedAt: plantedAt,
                            locationID: detailLocationID,
                            notes: notesDraft
                        )
                        appState.fieldTreeDetailInteractionMode = .viewing
                    }
                }
                .disabled(fieldTreeBotanicalName.isEmpty)
            }
        }
    }

    private var fieldTreeBotanicalName: String {
        let genusName = genusID.flatMap { referenceData.genus(id: $0)?.name } ?? ""
        let speciesPart: String = {
            guard let speciesID, let species = referenceData.species(id: speciesID) else { return "" }
            return species.epithet.isEmpty ? species.name : species.epithet
        }()
        let cultivarName = cultivarID.flatMap { referenceData.cultivar(id: $0)?.name }
        return TreeNamingService.makeBotanicalName(
            genus: genusName,
            species: speciesPart,
            cultivar: cultivarName
        )
    }

    private func header(_ project: NurseryPropagationProject) -> some View {
        VStack(alignment: .leading, spacing: FaloSpacing.small) {
            Text(project.botanicalName)
                .font(FaloTypography.pageTitle)
            if !project.commonName.isEmpty {
                Text(project.commonName)
                    .font(FaloTypography.pageSubtitle)
                    .foregroundStyle(.secondary)
            }
            Text("\(project.projectCode) · \(project.stage.title(for: project.kind)) · Quantity \(project.quantity)")
                .font(FaloTypography.caption)
                .foregroundStyle(.secondary)
            if project.kind == .fieldTree, let plantedAt = project.plantedAt {
                Text("Planted \(plantedAt.formatted(date: .abbreviated, time: .omitted))")
                    .font(FaloTypography.caption)
                    .foregroundStyle(.secondary)
            }
            if let parentTreeID = project.parentTreeID,
               let parent = treeService.getTree(id: parentTreeID) {
                Text("\(kind == .airLayer ? "Mother plant" : "Parent tree"): \(parent.bonsaiName.isEmpty ? parent.botanicalName : parent.bonsaiName)")
                    .font(FaloTypography.caption)
                    .foregroundStyle(.secondary)
            }
            if !project.createdTreeIDs.isEmpty {
                Text("\(project.createdTreeIDs.count) tree(s) created")
                    .font(FaloTypography.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }

    private func actions(_ project: NurseryPropagationProject) -> some View {
        DetailCard(title: "Actions") {
            VStack(alignment: .leading, spacing: FaloSpacing.medium) {
                if project.kind == .fieldTree {
                    Text("Ongoing field work uses Tasks and Work. Generate Tree when ready for final excavation.")
                        .font(FaloTypography.caption)
                        .foregroundStyle(.secondary)
                }
                if project.kind == .cutting {
                    Text("Started → Rooting → Rooted → Potted → Transfer to Tree.")
                        .font(FaloTypography.caption)
                        .foregroundStyle(.secondary)
                }
                if project.kind == .airLayer {
                    Text("Started → Checking → Separated → Potted → Transfer to Tree.")
                        .font(FaloTypography.caption)
                        .foregroundStyle(.secondary)
                }
                if let next = nextStage(for: project), next != .completed {
                    Button(next.advanceActionTitle(for: project.kind)) {
                        run { _ = try service.advanceStage(projectID: project.id) }
                    }
                    .buttonStyle(.bordered)
                }
                if project.stage.canCreateTree && project.createdTreeIDs.count < max(project.quantity, 1) {
                    Button(transferTreeButtonTitle(for: project.kind)) {
                        treeCount = project.kind == .fieldTree ? "1" : "1"
                        isCreateTreesPresented = true
                    }
                    .buttonStyle(.borderedProminent)
                }
                if project.isActive {
                    Button("Mark Failed", role: .destructive) {
                        run { _ = try service.markFailed(projectID: project.id) }
                    }
                }
            }
        }
    }

    private func transferTreeButtonTitle(for kind: NurseryPropagationKind) -> String {
        switch kind {
        case .fieldTree: "Generate Tree…"
        case .cutting, .airLayer, .grafting: "Transfer to Tree…"
        }
    }

    private func notesCard(_ project: NurseryPropagationProject) -> some View {
        DetailCard(title: "Notes") {
            TextField("Notes", text: $notesDraft, axis: .vertical)
                .lineLimit(3...8)
            Button("Save Notes") {
                run { _ = try service.updateNotes(projectID: project.id, notes: notesDraft) }
            }
        }
    }

    private func eventsCard(_ project: NurseryPropagationProject) -> some View {
        DetailCard(title: "Timeline") {
            if project.orderedEvents.isEmpty {
                Text("No events yet.")
                    .foregroundStyle(.secondary)
            } else {
                ForEach(project.orderedEvents) { event in
                    VStack(alignment: .leading, spacing: 2) {
                        Text(event.kind.title)
                            .font(FaloCardTypography.fieldValue)
                        Text(event.date.formatted(date: .abbreviated, time: .shortened))
                            .font(FaloTypography.caption)
                            .foregroundStyle(.secondary)
                        if !event.notes.isEmpty {
                            Text(event.notes)
                                .font(FaloTypography.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
        }
    }

    private func createTreesSheet(_ project: NurseryPropagationProject) -> some View {
        NavigationStack {
            Form {
                Section {
                    if project.kind != .fieldTree {
                        TextField("Number of trees", text: $treeCount)
                    } else {
                        Text("Generates one Tree from this Field Tree.")
                            .foregroundStyle(.secondary)
                    }
                    Picker("Location", selection: $treeLocationID) {
                        Text("Select").tag(UUID?.none)
                        ForEach(referenceData.locations) { location in
                            Text(location.name).tag(Optional(location.id))
                        }
                    }
                }
            }
            .formStyle(.grouped)
            .navigationTitle(project.kind == .fieldTree ? "Generate Tree" : "Transfer to Tree")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { isCreateTreesPresented = false }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button(project.kind == .fieldTree ? "Generate" : "Transfer") {
                        createTrees(from: project)
                    }
                    .disabled(treeLocationID == nil || (project.kind != .fieldTree && (Int(treeCount) ?? 0) < 1))
                }
            }
        }
        .frame(minWidth: 420, minHeight: 280)
    }

    private func nextStage(for project: NurseryPropagationProject) -> NurseryPropagationStage? {
        let path = project.kind.mainPath
        // Legacy cuttings / air layers on Developing sit between old path and Potted — offer Mark potted.
        if project.kind == .cutting || project.kind == .airLayer, project.stage == .developing {
            return .potted
        }
        guard let index = path.firstIndex(of: project.stage), index + 1 < path.count else {
            return nil
        }
        return path[index + 1]
    }

    private func createTrees(from project: NurseryPropagationProject) {
        guard let locationID = treeLocationID else { return }
        let count = Int(treeCount) ?? 0
        run {
            _ = try service.createTrees(projectID: project.id, count: count, locationID: locationID)
            isCreateTreesPresented = false
        }
    }

    private func run(_ body: () throws -> Void) {
        do {
            try body()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

struct NewNurseryPropagationProjectView: View {
    let kind: NurseryPropagationKind

    @Environment(\.dismiss) private var dismiss
    @Environment(NurseryPropagationService.self) private var service
    @Environment(ReferenceDataService.self) private var referenceData
    @Environment(TreeService.self) private var treeService
    @Environment(AppState.self) private var appState

    @State private var genusID: UUID?
    @State private var speciesID: UUID?
    @State private var cultivarID: UUID?
    @State private var botanicalName = ""
    @State private var commonName = ""
    @State private var quantity = "1"
    @State private var parentTreeID: UUID?
    @State private var plantedAt: Date = .now
    @State private var locationID: UUID?
    @State private var notes = ""
    @State private var errorMessage: String?

    @State private var cuttingTakenAt: Date = .now
    @State private var cuttingRootMedium = ""
    @State private var cuttingSoilMix = ""
    @State private var cuttingLength = ""
    @State private var cuttingLeafCountText = ""
    @State private var cuttingWoodMaturity: NurseryCuttingWoodMaturity?
    @State private var cuttingWoodMaturityOverride = ""
    @State private var cuttingBaseTechnique: NurseryCuttingBaseTechnique?
    @State private var cuttingBaseTechniqueOverride = ""
    @State private var cuttingStructure: NurseryCuttingStructure?
    @State private var cuttingStructureOverride = ""

    @State private var airLayerStartedAt: Date = .now
    @State private var airLayerMethod: NurseryAirLayerMethod? = .completeRing
    @State private var airLayerMethodOverride = ""
    @State private var airLayerRingWidthText = ""
    @State private var airLayerLayerDiameterText = ""
    @State private var airLayerLocation: NurseryAirLayerLocation?
    @State private var airLayerLocationOverride = ""
    @State private var airLayerRootingAid: NurseryAirLayerRootingAid? = .none
    @State private var airLayerRootingAidOverride = ""
    @State private var airLayerHormoneProduct = ""
    @State private var airLayerHormoneConcentration = ""
    @State private var airLayerMediumPreset: NurseryAirLayerMediumPreset? = .longFiberSphagnum
    @State private var airLayerMediumCustom = ""
    @State private var airLayerWrapSystem: NurseryAirLayerWrapSystem?
    @State private var airLayerWrapSystemOverride = ""
    @State private var airLayerPurpose: NurseryAirLayerPurpose?
    @State private var airLayerPurposeOverride = ""
    @State private var airLayerRootDevelopment: NurseryAirLayerRootDevelopment? = .noRoots
    @State private var airLayerWinterCare = false
    @State private var airLayerWinterCareNotes = ""
    @State private var airLayerSeparated = false
    @State private var airLayerSeparationDate: Date = .now
    @State private var airLayerSeparationNotes = ""
    @State private var isWrapCheckPresented = false

    private var fieldTreeBotanicalName: String {
        let genusName = genusID.flatMap { referenceData.genus(id: $0)?.name } ?? ""
        let species = speciesID.flatMap { referenceData.species(id: $0) }
        let speciesPart = species.map { $0.epithet.isEmpty ? $0.name : $0.epithet } ?? ""
        let cultivarName = cultivarID.flatMap { referenceData.cultivar(id: $0)?.name }
        return TreeNamingService.makeBotanicalName(
            genus: genusName,
            species: speciesPart,
            cultivar: cultivarName
        )
    }

    var body: some View {
        NavigationStack {
            Form {
                if kind == .fieldTree {
                    fieldTreeForm
                } else {
                    propagationForm
                }
                if let errorMessage {
                    Section {
                        Text(errorMessage).foregroundStyle(.red)
                    }
                }
            }
            .formStyle(.grouped)
            .navigationTitle("New \(kind.singularTitle)")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Create") { create() }
                        .disabled(createDisabled)
                }
            }
            .onChange(of: genusID) { _, _ in
                if kind == .fieldTree {
                    syncFieldTreeBotanicalName()
                } else {
                    syncPropagationBotanicalName()
                }
            }
            .onChange(of: speciesID) { _, _ in
                if kind == .fieldTree {
                    syncFieldTreeBotanicalName()
                } else {
                    syncPropagationBotanicalName()
                }
            }
            .onChange(of: cultivarID) { _, _ in
                if kind == .fieldTree {
                    syncFieldTreeBotanicalName()
                } else {
                    syncPropagationBotanicalName()
                }
            }
            .onChange(of: parentTreeID) { _, newValue in
                guard kind != .fieldTree else { return }
                applyParentTree(newValue)
            }
        }
        .frame(minWidth: 520, minHeight: 640)
    }

    @ViewBuilder
    private var fieldTreeForm: some View {
        Section("Identity") {
            TreeBotanicalHierarchyPickers(
                genusID: $genusID,
                speciesID: $speciesID,
                cultivarID: $cultivarID
            )
            LabeledContent("Botanical name") {
                Text(fieldTreeBotanicalName.isEmpty ? "Select genus and species" : fieldTreeBotanicalName)
                    .foregroundStyle(fieldTreeBotanicalName.isEmpty ? .secondary : .primary)
            }
            TextField("Common name / label", text: $commonName)
        }
        Section("Field") {
            DatePicker("Planted", selection: $plantedAt, displayedComponents: .date)
            Picker("Location", selection: $locationID) {
                Text("None").tag(UUID?.none)
                ForEach(referenceData.locations) { location in
                    Text(location.name).tag(Optional(location.id))
                }
            }
            TextField("Notes", text: $notes, axis: .vertical)
                .lineLimit(3...6)
            Text("One individual. Ongoing work uses Tasks and Work. Photos come in a later slice.")
                .font(FaloTypography.caption)
                .foregroundStyle(.secondary)
        }
    }

    @ViewBuilder
    private var propagationForm: some View {
        if kind == .airLayer {
            airLayerForm
        } else {
            cuttingOrGraftForm
        }
    }

    @ViewBuilder
    private var airLayerForm: some View {
        Section("Mother plant") {
            Picker("Mother plant", selection: $parentTreeID) {
                Text("Select mother plant").tag(UUID?.none)
                ForEach(treeService.trees.sorted {
                    ($0.bonsaiName.isEmpty ? $0.botanicalName : $0.bonsaiName)
                        < ($1.bonsaiName.isEmpty ? $1.botanicalName : $1.bonsaiName)
                }) { tree in
                    Text(tree.bonsaiName.isEmpty ? tree.botanicalName : tree.bonsaiName)
                        .tag(Optional(tree.id))
                }
            }
            Text("Required. Fills identity from the library tree. Creates Air Layer and Check tasks.")
                .font(FaloTypography.caption)
                .foregroundStyle(.secondary)
            if parentTreeID != nil {
                LabeledContent("Botanical name") {
                    Text(botanicalName.isEmpty ? "—" : botanicalName)
                        .foregroundStyle(botanicalName.isEmpty ? .secondary : .primary)
                }
                if !commonName.isEmpty {
                    LabeledContent("Common name") {
                        Text(commonName)
                    }
                }
            }
        }
        Section(kind.projectNoun) {
            TextField("Quantity", text: $quantity)
            Picker("Location", selection: $locationID) {
                Text("None").tag(UUID?.none)
                ForEach(referenceData.locations) { location in
                    Text(location.name).tag(Optional(location.id))
                }
            }
            TextField("Notes", text: $notes, axis: .vertical)
                .lineLimit(3...6)
        }
        NurseryAirLayerTechniqueFormFields(
            startedAt: $airLayerStartedAt,
            method: $airLayerMethod,
            methodOverride: $airLayerMethodOverride,
            ringWidthText: $airLayerRingWidthText,
            layerDiameterText: $airLayerLayerDiameterText,
            location: $airLayerLocation,
            locationOverride: $airLayerLocationOverride,
            rootingAid: $airLayerRootingAid,
            rootingAidOverride: $airLayerRootingAidOverride,
            hormoneProduct: $airLayerHormoneProduct,
            hormoneConcentration: $airLayerHormoneConcentration,
            mediumPreset: $airLayerMediumPreset,
            mediumCustom: $airLayerMediumCustom,
            wrapSystem: $airLayerWrapSystem,
            wrapSystemOverride: $airLayerWrapSystemOverride,
            purpose: $airLayerPurpose,
            purposeOverride: $airLayerPurposeOverride,
            rootDevelopment: $airLayerRootDevelopment,
            winterCare: $airLayerWinterCare,
            winterCareNotes: $airLayerWinterCareNotes,
            separated: $airLayerSeparated,
            separationDate: $airLayerSeparationDate,
            separationNotes: $airLayerSeparationNotes
        )
    }

    @ViewBuilder
    private var cuttingOrGraftForm: some View {
        Section("Parent tree") {
            Picker("Parent tree", selection: $parentTreeID) {
                Text("None — enter manually").tag(UUID?.none)
                ForEach(treeService.trees.sorted {
                    ($0.bonsaiName.isEmpty ? $0.botanicalName : $0.bonsaiName)
                        < ($1.bonsaiName.isEmpty ? $1.botanicalName : $1.bonsaiName)
                }) { tree in
                    Text(tree.bonsaiName.isEmpty ? tree.botanicalName : tree.bonsaiName)
                        .tag(Optional(tree.id))
                }
            }
            Text("Choosing a library tree fills genus, species, cultivar, and names. You can still edit everything.")
                .font(FaloTypography.caption)
                .foregroundStyle(.secondary)
        }
        Section("Identity") {
            TreeBotanicalHierarchyPickers(
                genusID: $genusID,
                speciesID: $speciesID,
                cultivarID: $cultivarID
            )
            TextField("Botanical name", text: $botanicalName)
            TextField("Common name", text: $commonName)
            Text("Everyday name (e.g. Japanese maple) — optional. Not the same as cultivar.")
                .font(FaloTypography.caption)
                .foregroundStyle(.secondary)
        }
        Section(kind.projectNoun) {
            TextField("Quantity", text: $quantity)
            Picker("Location", selection: $locationID) {
                Text("None").tag(UUID?.none)
                ForEach(referenceData.locations) { location in
                    Text(location.name).tag(Optional(location.id))
                }
            }
            TextField("Notes", text: $notes, axis: .vertical)
                .lineLimit(3...6)
        }
        if kind == .cutting {
            NurseryCuttingTechniqueFormFields(
                takenAt: $cuttingTakenAt,
                rootMedium: $cuttingRootMedium,
                soilMix: $cuttingSoilMix,
                length: $cuttingLength,
                leafCountText: $cuttingLeafCountText,
                woodMaturity: $cuttingWoodMaturity,
                woodMaturityOverride: $cuttingWoodMaturityOverride,
                baseTechnique: $cuttingBaseTechnique,
                baseTechniqueOverride: $cuttingBaseTechniqueOverride,
                structure: $cuttingStructure,
                structureOverride: $cuttingStructureOverride
            )
        }
    }

    private var propagationBotanicalName: String {
        let genusName = genusID.flatMap { referenceData.genus(id: $0)?.name } ?? ""
        let species = speciesID.flatMap { referenceData.species(id: $0) }
        let speciesPart = species.map { $0.epithet.isEmpty ? $0.name : $0.epithet } ?? ""
        let cultivarName = cultivarID.flatMap { referenceData.cultivar(id: $0)?.name }
        let fromHierarchy = TreeNamingService.makeBotanicalName(
            genus: genusName,
            species: speciesPart,
            cultivar: cultivarName
        )
        if !fromHierarchy.isEmpty { return fromHierarchy }
        return botanicalName.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private var createDisabled: Bool {
        if kind == .fieldTree {
            return fieldTreeBotanicalName.isEmpty
        }
        if kind == .airLayer {
            return parentTreeID == nil
                || (botanicalName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                    && propagationBotanicalName.isEmpty)
        }
        return botanicalName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            && propagationBotanicalName.isEmpty
    }

    private func syncFieldTreeBotanicalName() {
        botanicalName = fieldTreeBotanicalName
    }

    private func syncPropagationBotanicalName() {
        let name = propagationBotanicalName
        if !name.isEmpty {
            botanicalName = name
        }
    }

    private func applyParentTree(_ treeID: UUID?) {
        guard let treeID, let tree = treeService.getTree(id: treeID) else { return }
        genusID = tree.genusID
        speciesID = tree.speciesID
        cultivarID = tree.cultivarID
        botanicalName = tree.botanicalName
        if commonName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty,
           let speciesID = tree.speciesID,
           let profile = SpeciesProfileCatalog.profile(speciesID: speciesID, cultivarID: tree.cultivarID) {
            commonName = profile.primaryCommonName
        }
        syncPropagationBotanicalName()
    }

    private func create() {
        do {
            let resolvedBotanical: String = {
                if kind == .fieldTree { return fieldTreeBotanicalName }
                let fromHierarchy = propagationBotanicalName
                if !fromHierarchy.isEmpty { return fromHierarchy }
                return botanicalName
            }()
            let leafCount: Int?
            let leafTrimmed = cuttingLeafCountText.trimmingCharacters(in: .whitespacesAndNewlines)
            if leafTrimmed.isEmpty {
                leafCount = nil
            } else if let value = Int(leafTrimmed), value >= 0 {
                leafCount = value
            } else {
                errorMessage = "Leaf count must be a whole number."
                return
            }
            let project = try service.createProject(
                NurseryPropagationCreateDraft(
                    kind: kind,
                    genusID: genusID,
                    speciesID: speciesID,
                    cultivarID: cultivarID,
                    botanicalName: resolvedBotanical,
                    commonName: commonName,
                    parentTreeID: kind == .fieldTree ? nil : parentTreeID,
                    quantity: kind == .fieldTree ? 1 : (Int(quantity) ?? 1),
                    plantedAt: kind == .fieldTree ? plantedAt : nil,
                    locationID: locationID,
                    notes: notes,
                    cuttingTakenAt: kind == .cutting ? cuttingTakenAt : nil,
                    cuttingRootMedium: cuttingRootMedium,
                    cuttingSoilMix: cuttingSoilMix,
                    cuttingLength: cuttingLength,
                    cuttingLeafCount: leafCount,
                    cuttingWoodMaturity: cuttingWoodMaturity,
                    cuttingWoodMaturityOverride: cuttingWoodMaturityOverride,
                    cuttingBaseTechnique: cuttingBaseTechnique,
                    cuttingBaseTechniqueOverride: cuttingBaseTechniqueOverride,
                    cuttingStructure: cuttingStructure,
                    cuttingStructureOverride: cuttingStructureOverride,
                    airLayerMethod: airLayerMethod,
                    airLayerMethodOverride: airLayerMethodOverride,
                    airLayerRingWidthMM: Double(airLayerRingWidthText.replacingOccurrences(of: ",", with: ".")),
                    airLayerLayerDiameterMM: Double(airLayerLayerDiameterText.replacingOccurrences(of: ",", with: ".")),
                    airLayerLocation: airLayerLocation,
                    airLayerLocationOverride: airLayerLocationOverride,
                    airLayerRootingAid: airLayerRootingAid,
                    airLayerRootingAidOverride: airLayerRootingAidOverride,
                    airLayerHormoneProduct: airLayerHormoneProduct,
                    airLayerHormoneConcentration: airLayerHormoneConcentration,
                    airLayerMediumPreset: airLayerMediumPreset,
                    airLayerMediumCustom: airLayerMediumCustom,
                    airLayerWrapSystem: airLayerWrapSystem,
                    airLayerWrapSystemOverride: airLayerWrapSystemOverride,
                    airLayerPurpose: airLayerPurpose,
                    airLayerPurposeOverride: airLayerPurposeOverride,
                    airLayerRootDevelopment: airLayerRootDevelopment,
                    airLayerStartedAt: kind == .airLayer ? airLayerStartedAt : nil,
                    airLayerWinterCare: kind == .airLayer ? airLayerWinterCare : nil,
                    airLayerWinterCareNotes: airLayerWinterCareNotes,
                    airLayerSeparated: kind == .airLayer ? airLayerSeparated : false,
                    airLayerSeparationDate: kind == .airLayer && airLayerSeparated ? airLayerSeparationDate : nil,
                    airLayerSeparationNotes: airLayerSeparationNotes
                )
            )
            appState.setSelectedNurseryPropagationProjectID(project.id, for: kind)
            dismiss()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
