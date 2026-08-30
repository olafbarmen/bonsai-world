//
//  GrowingSection.swift
//  Bonsai World
//
//  Tree Detail — Growing card (situation + health in grower order).
//  Preferred Location workflow: Garden → Location → Select on Map.
//  Trees never store coordinates — Location owns the map position.
//

import SwiftUI

struct GrowingSection: View {
    @Binding var styleID: UUID?
    @Binding var locationID: UUID?
    @Binding var healthStatus: TreeHealthStatus
    @Binding var treeStatusID: UUID?
    @Binding var sizeClassID: UUID?
    @Binding var lightConditionID: UUID?
    @Binding var soilMixID: UUID?

    let styles: [DetailPickerOption]
    /// Active Locations from Reference Data (alternative picker).
    let locations: [DetailPickerOption]
    let treeStatuses: [DetailPickerOption]
    let sizeClasses: [DetailPickerOption]
    let lightConditions: [DetailPickerOption]
    let soilMixes: [DetailPickerOption]
    /// Resolved Soil Mix for composition disclosure (includes inactive).
    let selectedSoilMix: SoilMix?
    /// Component display names keyed by Soil Component id.
    let soilComponentNames: [UUID: String]

    var isEditing: Bool

    @Environment(UserProfileStore.self) private var profile
    @Environment(ReferenceDataService.self) private var referenceData

    @State private var placementGardenID: UUID?
    @State private var isMapPickerPresented = false
    @State private var isSoilMixExpanded = false

    private var gardens: [Garden] {
        _ = profile.revision
        return profile.activeGardens
    }

    private var resolvedGardenID: UUID? {
        if let placementGardenID { return placementGardenID }
        if let locationID, let gardenID = referenceData.location(id: locationID)?.gardenID {
            return gardenID
        }
        return profile.defaultGarden?.id
    }

    private var locationsForSelectedGarden: [DetailPickerOption] {
        guard let gardenID = resolvedGardenID else { return locations }
        let ids = Set(
            referenceData.locations
                .filter { $0.gardenID == gardenID }
                .map(\.id)
        )
        let filtered = locations.filter { ids.contains($0.id) }
        return filtered.isEmpty ? locations : filtered
    }

    private var locationDisplayName: String {
        guard let locationID else { return "" }
        if let name = referenceData.location(id: locationID)?.name {
            return name
        }
        return DetailOptionPickerRow.displayName(for: locationID, in: locations)
    }

    private var gardenDisplayName: String {
        guard let id = resolvedGardenID else { return "" }
        return profile.garden(id: id)?.name ?? ""
    }

    var body: some View {
        DetailCard(title: "Growing") {
            if isEditing {
                DetailOptionPickerRow(
                    label: "Style",
                    selection: $styleID,
                    placeholder: "Select Style",
                    options: styles
                )
                locationPlacementBlock
                healthPicker
                DetailOptionPickerRow(
                    label: "Growing Status",
                    selection: $treeStatusID,
                    placeholder: "Select Growing Status",
                    options: treeStatuses
                )
                DetailOptionPickerRow(
                    label: "Size Class",
                    selection: $sizeClassID,
                    placeholder: "Select Size Class",
                    options: sizeClasses
                )
                DetailOptionPickerRow(
                    label: "Light",
                    selection: $lightConditionID,
                    placeholder: "Select Light Condition",
                    options: lightConditions
                )
                soilMixBlock
            } else {
                DetailLabeledRow(
                    label: "Style",
                    value: DetailOptionPickerRow.displayName(for: styleID, in: styles)
                )
                DetailLabeledRow(label: "Garden", value: gardenDisplayName)
                DetailLabeledRow(label: "Location", value: locationDisplayName)
                DetailLabeledRow(label: "Health", value: healthStatus.title)
                DetailLabeledRow(
                    label: "Growing Status",
                    value: DetailOptionPickerRow.displayName(for: treeStatusID, in: treeStatuses)
                )
                DetailLabeledRow(
                    label: "Size Class",
                    value: DetailOptionPickerRow.displayName(for: sizeClassID, in: sizeClasses)
                )
                DetailLabeledRow(
                    label: "Light",
                    value: DetailOptionPickerRow.displayName(for: lightConditionID, in: lightConditions)
                )
                soilMixBlock
            }
        }
        .onAppear {
            Task { @MainActor in
                syncPlacementGarden()
            }
        }
        .onChange(of: locationID) { _, _ in
            Task { @MainActor in
                syncPlacementGarden()
            }
        }
        .onChange(of: soilMixID) { _, _ in
            isSoilMixExpanded = false
        }
        .sheet(isPresented: $isMapPickerPresented) {
            if let gardenID = resolvedGardenID {
                TreeLocationMapPickerSheet(
                    gardenID: gardenID,
                    locationID: $locationID
                )
            }
        }
    }

    @ViewBuilder
    private var healthPicker: some View {
        VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
            Text("Health")
                .font(FaloTypography.caption)
                .foregroundStyle(.secondary)

            Picker("Health", selection: $healthStatus) {
                ForEach(TreeHealthStatus.allCases) { status in
                    Text(status.title).tag(status)
                }
            }
            .labelsHidden()
            .pickerStyle(.menu)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    @ViewBuilder
    private var locationPlacementBlock: some View {
        VStack(alignment: .leading, spacing: FaloSpacing.small) {
            Text("Placement")
                .font(FaloTypography.caption)
                .foregroundStyle(.secondary)

            Picker("Garden", selection: Binding(
                get: { resolvedGardenID },
                set: { newValue in
                    placementGardenID = newValue
                }
            )) {
                Text("Select Garden").tag(Optional<UUID>.none)
                ForEach(gardens) { garden in
                    Text(garden.isDefault ? "\(garden.name) (Default)" : garden.name)
                        .tag(Optional(garden.id))
                }
            }
            .pickerStyle(.menu)
            .labelsHidden()

            HStack(alignment: .firstTextBaseline, spacing: FaloSpacing.medium) {
                VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
                    Text("Location")
                        .font(FaloTypography.caption)
                        .foregroundStyle(.secondary)
                    Text(
                        locationDisplayName.isEmpty
                            ? "Not set — Select on Map"
                            : locationDisplayName
                    )
                    .font(FaloTypography.body)
                    .foregroundStyle(locationDisplayName.isEmpty ? .secondary : .primary)
                }

                Spacer(minLength: 0)

                Button("Select on Map") {
                    syncPlacementGarden()
                    isMapPickerPresented = true
                }
                .disabled(resolvedGardenID == nil)
                .help("Preferred: assign this Tree by choosing a Location on the Garden map.")
            }

            DetailOptionPickerRow(
                label: "Location (list)",
                selection: $locationID,
                placeholder: "Select Location",
                options: locationsForSelectedGarden
            )
            .help("Alternative to Select on Map.")
        }
        .padding(.vertical, FaloSpacing.xSmall)
    }

    @ViewBuilder
    private var soilMixBlock: some View {
        VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
            if isEditing {
                DetailOptionPickerRow(
                    label: "Soil Mix",
                    selection: $soilMixID,
                    placeholder: "Select Soil Mix",
                    options: soilMixes
                )
            } else {
                DetailLabeledRow(
                    label: "Soil Mix",
                    value: selectedSoilMix?.name
                        ?? DetailOptionPickerRow.displayName(for: soilMixID, in: soilMixes)
                )
            }

            if let mix = selectedSoilMix, !mix.parts.isEmpty {
                Button {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        isSoilMixExpanded.toggle()
                    }
                } label: {
                    HStack(spacing: FaloSpacing.xSmall) {
                        Image(systemName: isSoilMixExpanded ? "chevron.down" : "chevron.right")
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(.secondary)
                        Text(isSoilMixExpanded ? "Hide composition" : "Show composition")
                            .font(FaloTypography.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                .buttonStyle(.plain)
                .padding(.leading, FaloSpacing.xSmall)

                if isSoilMixExpanded {
                    VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
                        ForEach(mix.parts) { part in
                            Text(compositionLine(for: part))
                                .font(FaloTypography.body)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .padding(.leading, FaloSpacing.medium)
                    .padding(.bottom, FaloSpacing.xSmall)
                }
            }
        }
    }

    private func syncPlacementGarden() {
        if placementGardenID == nil {
            if let locationID, let gardenID = referenceData.location(id: locationID)?.gardenID {
                placementGardenID = gardenID
            } else {
                placementGardenID = profile.defaultGarden?.id
            }
        }
    }

    private func compositionLine(for part: SoilMixPart) -> String {
        let name = soilComponentNames[part.componentID] ?? "Unknown component"
        return "\(part.percentage)% \(name)"
    }
}
