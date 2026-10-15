//
//  SoilMixDetailView.swift
//  Bonsai World
//
//  Soil → Mixes detail column (CG1).
//

import SwiftUI

struct SoilMixDetailView: View {
    @Environment(AppState.self) private var appState
    @Environment(ReferenceDataService.self) private var referenceData
    @Environment(ReferenceDataManager.self) private var manager
    @Environment(SoilStockService.self) private var soilStock

    @State private var editorDraft: SoilMixDraft?
    @State private var targetVolumeLiters: Double = 20

    var body: some View {
        Group {
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
        .sheet(item: $editorDraft) { draft in
            SoilMixEditorSheet(draft: draft)
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
}
