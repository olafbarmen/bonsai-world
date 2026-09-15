//
//  NurseryPropagationTechniqueViews.swift
//  Bonsai World
//
//  Kind-specific Cuttings / Air Layers technique fields for create, edit, and summary.
//

import SwiftUI

struct NurseryCuttingTechniqueFormFields: View {
    @Binding var takenAt: Date
    @Binding var rootMedium: String
    @Binding var soilMix: String
    @Binding var length: String
    @Binding var leafCountText: String
    @Binding var woodMaturity: NurseryCuttingWoodMaturity?
    @Binding var woodMaturityOverride: String
    @Binding var baseTechnique: NurseryCuttingBaseTechnique?
    @Binding var baseTechniqueOverride: String
    @Binding var structure: NurseryCuttingStructure?
    @Binding var structureOverride: String

    var body: some View {
        Section("Cutting technique") {
            DatePicker("Date taken", selection: $takenAt, displayedComponents: .date)
            TextField("Root medium", text: $rootMedium)
            TextField("Soil mix", text: $soilMix)
            TextField("Length", text: $length)
            TextField("Leaf count", text: $leafCountText)

            Picker("Wood maturity", selection: $woodMaturity) {
                Text("Choose…").tag(NurseryCuttingWoodMaturity?.none)
                ForEach(NurseryCuttingWoodMaturity.allCases) { value in
                    Text(value.title).tag(Optional(value))
                }
            }
            TextField("Wood maturity override", text: $woodMaturityOverride)

            Picker("Base technique", selection: $baseTechnique) {
                Text("Choose…").tag(NurseryCuttingBaseTechnique?.none)
                ForEach(NurseryCuttingBaseTechnique.allCases) { value in
                    Text(value.title).tag(Optional(value))
                }
            }
            TextField("Base technique override", text: $baseTechniqueOverride)

            Picker("Structure", selection: $structure) {
                Text("Choose…").tag(NurseryCuttingStructure?.none)
                ForEach(NurseryCuttingStructure.allCases) { value in
                    Text(value.title).tag(Optional(value))
                }
            }
            TextField("Structure override", text: $structureOverride)
        }
    }
}

struct NurseryAirLayerTechniqueFormFields: View {
    @Binding var startedAt: Date
    @Binding var method: NurseryAirLayerMethod?
    @Binding var methodOverride: String
    @Binding var ringWidthText: String
    @Binding var layerDiameterText: String
    @Binding var location: NurseryAirLayerLocation?
    @Binding var locationOverride: String
    @Binding var rootingAid: NurseryAirLayerRootingAid?
    @Binding var rootingAidOverride: String
    @Binding var hormoneProduct: String
    @Binding var hormoneConcentration: String
    @Binding var mediumPreset: NurseryAirLayerMediumPreset?
    @Binding var mediumCustom: String
    @Binding var wrapSystem: NurseryAirLayerWrapSystem?
    @Binding var wrapSystemOverride: String
    @Binding var purpose: NurseryAirLayerPurpose?
    @Binding var purposeOverride: String
    @Binding var rootDevelopment: NurseryAirLayerRootDevelopment?
    @Binding var winterCare: Bool
    @Binding var winterCareNotes: String
    @Binding var separated: Bool
    @Binding var separationDate: Date
    @Binding var separationNotes: String

    var body: some View {
        Group {
            techniqueBlock
            rootingSetupBlock
            purposeBlock
        }
    }

    private var techniqueBlock: some View {
        Section("Technique") {
            DatePicker("Started", selection: $startedAt, displayedComponents: .date)
            Picker("Method", selection: $method) {
                Text("Choose…").tag(NurseryAirLayerMethod?.none)
                ForEach(NurseryAirLayerMethod.allCases) { value in
                    Text(value.title).tag(Optional(value))
                }
            }
            TextField("Method override", text: $methodOverride)
            TextField("Ring width (mm)", text: $ringWidthText)
            Text("Recommended: about 1–2 × branch/trunk diameter.")
                .font(FaloTypography.caption)
                .foregroundStyle(.secondary)
            TextField("Layer diameter (mm)", text: $layerDiameterText)
            Picker("Location on tree", selection: $location) {
                Text("Choose…").tag(NurseryAirLayerLocation?.none)
                ForEach(NurseryAirLayerLocation.allCases) { value in
                    Text(value.title).tag(Optional(value))
                }
            }
            TextField("Location override", text: $locationOverride)
        }
    }

    private var rootingSetupBlock: some View {
        Section("Rooting setup") {
            Picker("Rooting aid", selection: $rootingAid) {
                Text("Choose…").tag(NurseryAirLayerRootingAid?.none)
                ForEach(NurseryAirLayerRootingAid.allCases) { value in
                    Text(value.title).tag(Optional(value))
                }
            }
            TextField("Rooting aid override", text: $rootingAidOverride)
            if rootingAid == .rootingHormone || rootingAid == .other {
                TextField("Hormone product / name", text: $hormoneProduct)
                TextField("Concentration (optional)", text: $hormoneConcentration)
            }
            Picker("Medium", selection: $mediumPreset) {
                Text("Choose…").tag(NurseryAirLayerMediumPreset?.none)
                ForEach(NurseryAirLayerMediumPreset.allCases) { value in
                    Text(value.title).tag(Optional(value))
                }
            }
            TextField("Medium details", text: $mediumCustom)
            Picker("Wrap system", selection: $wrapSystem) {
                Text("Choose…").tag(NurseryAirLayerWrapSystem?.none)
                ForEach(NurseryAirLayerWrapSystem.allCases) { value in
                    Text(value.title).tag(Optional(value))
                }
            }
            TextField("Wrap system override", text: $wrapSystemOverride)
        }
    }

    private var purposeBlock: some View {
        Section("Purpose & monitoring") {
            Picker("Purpose", selection: $purpose) {
                Text("Choose…").tag(NurseryAirLayerPurpose?.none)
                ForEach(NurseryAirLayerPurpose.allCases) { value in
                    Text(value.title).tag(Optional(value))
                }
            }
            TextField("Purpose override", text: $purposeOverride)
            Picker("Root development", selection: $rootDevelopment) {
                Text("Choose…").tag(NurseryAirLayerRootDevelopment?.none)
                ForEach(NurseryAirLayerRootDevelopment.allCases) { value in
                    Text(value.title).tag(Optional(value))
                }
            }
            Toggle("Winter care attention", isOn: $winterCare)
            TextField("Winter care notes", text: $winterCareNotes, axis: .vertical)
                .lineLimit(2...4)
            Toggle("Separated", isOn: $separated)
            if separated {
                DatePicker("Separation date", selection: $separationDate, displayedComponents: .date)
                TextField("Separation notes", text: $separationNotes, axis: .vertical)
                    .lineLimit(2...4)
            }
        }
    }
}

struct NurseryAirLayerWrapCheckSheet: View {
    @Environment(\.dismiss) private var dismiss
    let projectID: UUID
    var onComplete: (NurseryAirLayerRootDevelopment?, NurseryAirLayerMoisture?, String) -> Void

    @State private var rootDevelopment: NurseryAirLayerRootDevelopment? = nil
    @State private var moisture: NurseryAirLayerMoisture? = nil
    @State private var notes = ""

    var body: some View {
        NavigationStack {
            Form {
                Picker("Root development", selection: $rootDevelopment) {
                    Text("Choose…").tag(NurseryAirLayerRootDevelopment?.none)
                    ForEach(NurseryAirLayerRootDevelopment.allCases) { value in
                        Text(value.title).tag(Optional(value))
                    }
                }
                Picker("Moisture", selection: $moisture) {
                    Text("Choose…").tag(NurseryAirLayerMoisture?.none)
                    ForEach(NurseryAirLayerMoisture.allCases) { value in
                        Text(value.title).tag(Optional(value))
                    }
                }
                TextField("Notes", text: $notes, axis: .vertical)
                    .lineLimit(2...5)
            }
            .formStyle(.grouped)
            .navigationTitle("Wrap Check")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Complete") {
                        onComplete(rootDevelopment, moisture, notes)
                        dismiss()
                    }
                }
            }
        }
        .frame(minWidth: 420, minHeight: 360)
    }
}

struct NurseryPropagationTechniqueSummaryRows: View {
    let project: NurseryPropagationProject

    var body: some View {
        Group {
            switch project.kind {
            case .cutting:
                cuttingRows
            case .airLayer:
                airLayerRows
            case .grafting, .fieldTree:
                EmptyView()
            }
        }
    }

    @ViewBuilder
    private var cuttingRows: some View {
        if let takenAt = project.cuttingTakenAt {
            DetailLabeledRow(
                label: "Date taken",
                value: takenAt.formatted(date: .abbreviated, time: .omitted)
            )
        }
        if !project.cuttingRootMedium.isEmpty {
            DetailLabeledRow(label: "Root medium", value: project.cuttingRootMedium)
        }
        if !project.cuttingSoilMix.isEmpty {
            DetailLabeledRow(label: "Soil mix", value: project.cuttingSoilMix)
        }
        if !project.cuttingLength.isEmpty {
            DetailLabeledRow(label: "Length", value: project.cuttingLength)
        }
        if let leafCount = project.cuttingLeafCount {
            DetailLabeledRow(label: "Leaf count", value: "\(leafCount)")
        }
        if !project.cuttingWoodMaturityDisplay.isEmpty {
            DetailLabeledRow(label: "Wood maturity", value: project.cuttingWoodMaturityDisplay)
        }
        if !project.cuttingBaseTechniqueDisplay.isEmpty {
            DetailLabeledRow(label: "Base technique", value: project.cuttingBaseTechniqueDisplay)
        }
        if !project.cuttingStructureDisplay.isEmpty {
            DetailLabeledRow(label: "Structure", value: project.cuttingStructureDisplay)
        }
    }

    @ViewBuilder
    private var airLayerRows: some View {
        if let startedAt = project.airLayerStartedAt {
            DetailLabeledRow(
                label: "Started",
                value: startedAt.formatted(date: .abbreviated, time: .omitted)
            )
        }
        if !project.airLayerMethodDisplay.isEmpty {
            DetailLabeledRow(label: "Method", value: project.airLayerMethodDisplay)
        }
        if let width = project.airLayerRingWidthMM {
            DetailLabeledRow(label: "Ring width", value: "\(formatMM(width)) mm")
        }
        if let diameter = project.airLayerLayerDiameterMM {
            DetailLabeledRow(label: "Layer diameter", value: "\(formatMM(diameter)) mm")
        }
        if !project.airLayerLocationDisplay.isEmpty {
            DetailLabeledRow(label: "Location on tree", value: project.airLayerLocationDisplay)
        }
        if !project.airLayerRootingAidDisplay.isEmpty {
            DetailLabeledRow(label: "Rooting aid", value: project.airLayerRootingAidDisplay)
        }
        if !project.airLayerHormoneProduct.isEmpty {
            let concentration = project.airLayerHormoneConcentration.trimmingCharacters(in: .whitespacesAndNewlines)
            let value = concentration.isEmpty
                ? project.airLayerHormoneProduct
                : "\(project.airLayerHormoneProduct) — \(concentration)"
            DetailLabeledRow(label: "Hormone", value: value)
        }
        if !project.airLayerMediumDisplay.isEmpty {
            DetailLabeledRow(label: "Medium", value: project.airLayerMediumDisplay)
        }
        if !project.airLayerWrapSystemDisplay.isEmpty {
            DetailLabeledRow(label: "Wrap system", value: project.airLayerWrapSystemDisplay)
        }
        if !project.airLayerPurposeDisplay.isEmpty {
            DetailLabeledRow(label: "Purpose", value: project.airLayerPurposeDisplay)
        }
        if let root = project.airLayerRootDevelopment {
            DetailLabeledRow(label: "Root development", value: root.title)
        }
        if let winter = project.airLayerWinterCare {
            DetailLabeledRow(label: "Winter care", value: winter ? "Yes" : "No")
        }
        if !project.airLayerWinterCareNotes.isEmpty {
            DetailLabeledRow(label: "Winter care notes", value: project.airLayerWinterCareNotes)
        }
        if project.airLayerSeparated {
            DetailLabeledRow(label: "Separated", value: "Yes")
            if let date = project.airLayerSeparationDate {
                DetailLabeledRow(
                    label: "Separation date",
                    value: date.formatted(date: .abbreviated, time: .omitted)
                )
            }
            if !project.airLayerSeparationNotes.isEmpty {
                DetailLabeledRow(label: "Separation notes", value: project.airLayerSeparationNotes)
            }
        }
    }

    private func formatMM(_ value: Double) -> String {
        value.rounded() == value ? String(Int(value)) : String(format: "%.1f", value)
    }
}

struct NurseryPropagationKnowledgeCard: View {
    let kind: NurseryPropagationKind
    let project: NurseryPropagationProject
    let successRate: NurseryPropagationSuccessRate
    let speciesSuccessRate: NurseryPropagationSuccessRate?
    let onOpenSpeciesProfile: (() -> Void)?

    private var profile: SpeciesProfile? {
        guard let speciesID = project.speciesID else { return nil }
        return SpeciesProfileCatalog.profile(speciesID: speciesID, cultivarID: project.cultivarID)
    }

    var body: some View {
        DetailCard(title: "Knowledge & success") {
            VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
                DetailLabeledRow(label: "\(kind.title) success", value: successRate.displayLabel)
                if let speciesSuccessRate, project.speciesID != nil {
                    DetailLabeledRow(
                        label: "This species",
                        value: speciesSuccessRate.displayLabel
                    )
                }

                if let profile {
                    if kind == .airLayer, !profile.traits.airLayering.isEmpty {
                        DetailLabeledRow(label: "Species air layering", value: profile.traits.airLayering)
                    }
                    if let horizon = speciesTimeHorizonHint(in: profile) {
                        DetailLabeledRow(label: "Species timing", value: horizon)
                    }
                    if let onOpenSpeciesProfile {
                        Button("Open Species Profile") {
                            onOpenSpeciesProfile()
                        }
                        .buttonStyle(.bordered)
                        .padding(.top, 4)
                    }
                } else {
                    Text("Set species on this project to link Species Library guidance and species timing.")
                        .font(FaloTypography.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
    }

    private func speciesTimeHorizonHint(in profile: SpeciesProfile) -> String? {
        let preferredIDs = ["air-layering", "airlayering", "cuttings", "cutting", "propagation", "timing"]
        for preferred in preferredIDs {
            if let section = profile.sections.first(where: { $0.id.localizedCaseInsensitiveContains(preferred) }) {
                if let paragraph = section.paragraphs.first(where: { !$0.isEmpty }) {
                    return clipped(paragraph)
                }
                if let bullet = section.bullets.first(where: { !$0.isEmpty }) {
                    return clipped(bullet)
                }
            }
        }
        return nil
    }

    private func clipped(_ text: String) -> String {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard trimmed.count > 180 else { return trimmed }
        return String(trimmed.prefix(177)) + "…"
    }
}
