//
//  SoilMixesView.swift
//  Bonsai World
//
//  User-owned recipes. Components come from Settings catalog; quantities stay in Stock.
//

import SwiftUI

struct SoilMixesView: View {
    @Environment(AppState.self) private var appState
    @Environment(ReferenceDataService.self) private var referenceData
    @Environment(ReferenceDataManager.self) private var manager
    @Environment(SoilStockService.self) private var soilStock

    @State private var search = ""
    @State private var contextFilter: SoilMixContextTag?
    @State private var editorDraft: SoilMixDraft?
    @State private var targetVolumeLiters: Double = 20

    private var mixes: [SoilMix] {
        referenceData.soilMixes
            .filter(\.isActive)
            .filter { mix in
                if let contextFilter {
                    return mix.contextTags.contains(contextFilter)
                }
                return true
            }
            .filter { mix in
                let needle = search.trimmingCharacters(in: .whitespacesAndNewlines)
                guard !needle.isEmpty else { return true }
                return mix.name.localizedCaseInsensitiveContains(needle)
                    || mix.intendedUse.localizedCaseInsensitiveContains(needle)
            }
            .sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending }
    }

    var body: some View {
        @Bindable var appState = appState

        HSplitView {
            VStack(spacing: 0) {
                VStack(alignment: .leading, spacing: FaloSpacing.small) {
                    TextField("Search mixes", text: $search)
                        .textFieldStyle(.roundedBorder)
                    Picker("Context", selection: $contextFilter) {
                        Text("Any context").tag(Optional<SoilMixContextTag>.none)
                        ForEach(SoilMixContextTag.allCases) { tag in
                            Text(tag.title).tag(Optional(tag))
                        }
                    }
                    .labelsHidden()
                }
                .padding(FaloSpacing.medium)

                Divider()

                List(mixes, selection: $appState.selectedSoilMixID) { mix in
                    VStack(alignment: .leading, spacing: 2) {
                        Text(mix.name)
                            .font(FaloCardTypography.fieldValue)
                        Text(mixSubtitle(mix))
                            .font(FaloTypography.caption)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, FaloSpacing.xSmall)
                    .tag(mix.id)
                }
                .faloScrollSurface()
                .overlay {
                    if referenceData.soilMixes.isEmpty {
                        ContentUnavailableView(
                            "You haven't created any soil mixes yet.",
                            systemImage: "list.bullet.rectangle",
                            description: Text("Create your own mix from the materials in your stock.")
                        )
                    }
                }
            }
            .frame(minWidth: 260, idealWidth: 340)

            mixDetail
                .frame(minWidth: 380)
        }
        .sheet(item: $editorDraft) { draft in
            SoilMixEditorSheet(draft: draft)
        }
        .onAppear { consumeWantsNewSoilMix() }
        .onChange(of: appState.wantsNewSoilMix) { _, wants in
            guard wants else { return }
            consumeWantsNewSoilMix()
        }
    }

    private func consumeWantsNewSoilMix() {
        guard appState.wantsNewSoilMix else { return }
        editorDraft = manager.blankSoilMixDraft()
        appState.wantsNewSoilMix = false
    }

    @ViewBuilder
    private var mixDetail: some View {
        if let id = appState.selectedSoilMixID,
           let mix = referenceData.soilMix(id: id) {
            ScrollView {
                VStack(alignment: .leading, spacing: FaloSpacing.medium) {
                    DetailCard(title: mix.name) {
                        DetailLabeledRow(label: "Intended use", value: mix.intendedUse)
                        DetailLabeledRow(label: "Context", value: mix.contextTags.map(\.title).joined(separator: ", "))
                        DetailLabeledRow(label: "Notes", value: mix.mixDescription)
                        if !mix.isPercentageValid {
                            Text("This mix does not total 100% and is not valid.")
                                .font(FaloTypography.body)
                                .foregroundStyle(.secondary)
                        }
                        Button("Edit Mix") {
                            editorDraft = manager.soilMixDraft(for: mix.id)
                        }
                    }

                    DetailCard(title: "Components") {
                        ForEach(mix.parts) { part in
                            let name = referenceData.soilComponent(id: part.componentID)?.name ?? "Unknown"
                            DetailLabeledRow(label: name, value: "\(part.percentage)%")
                        }
                        DetailLabeledRow(label: "Total", value: "\(mix.totalPercentage)%")
                    }

                    calculator(for: mix)
                }
                .padding(FaloSpacing.medium)
            }
            .faloScrollSurface()
        } else {
            ContentUnavailableView(
                "Select a mix",
                systemImage: "list.bullet.rectangle",
                description: Text("Choose a recipe, or create a new mix.")
            )
        }
    }

    private func calculator(for mix: SoilMix) -> some View {
        DetailCard(title: "Volume calculator") {
            Text("Planning only — stock is not deducted.")
                .font(FaloTypography.caption)
                .foregroundStyle(.secondary)
            TextField("Target volume (L)", value: $targetVolumeLiters, format: .number)
            if mix.isPercentageValid {
                ForEach(mix.parts) { part in
                    let name = referenceData.soilComponent(id: part.componentID)?.name ?? "Unknown"
                    let required = targetVolumeLiters * Double(part.percentage) / 100
                    let available = soilStock.availableVolumeLiters(forComponentID: part.componentID)
                    let enough = available + 0.0001 >= required
                    VStack(alignment: .leading, spacing: 2) {
                        DetailLabeledRow(label: name, value: SoilVolumeFormat.liters(required))
                        Text("Available \(SoilVolumeFormat.liters(available)) · \(enough ? "Sufficient" : "Short")")
                            .font(FaloTypography.caption)
                            .foregroundStyle(.secondary)
                            .accessibilityLabel("\(name) available \(SoilVolumeFormat.liters(available)), \(enough ? "sufficient" : "short")")
                    }
                }
            }
        }
    }

    private func mixSubtitle(_ mix: SoilMix) -> String {
        var parts: [String] = []
        if !mix.contextTags.isEmpty {
            parts.append(mix.contextTags.map(\.title).joined(separator: ", "))
        }
        if !mix.intendedUse.isEmpty {
            parts.append(mix.intendedUse)
        }
        parts.append(mix.isPercentageValid ? "100%" : "\(mix.totalPercentage)%")
        return parts.joined(separator: " · ")
    }
}
