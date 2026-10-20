//
//  GardenEditorSheet.swift
//  Bonsai World
//
//  Add / Edit Garden — Address frames the map; Garden Position is placed manually.
//

import SwiftUI

struct GardenEditorSheet: View {
    @Environment(UserProfileStore.self) private var profile
    @Environment(\.dismiss) private var dismiss

    @State private var draft: Garden
    @State private var validationMessage: String?
    @State private var isExisting = false
    @State private var isPositionEditorPresented = false
    @State private var preferAddressFraming = false
    @State private var positionDraft: GeographicCoordinate?
    /// True only while Hemisphere was filled from Garden Position in this edit.
    @State private var hemisphereFollowsPosition = false

    init(garden: Garden) {
        _draft = State(initialValue: garden)
        _positionDraft = State(initialValue: garden.gardenPosition)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("General") {
                    TextField("Garden Name", text: $draft.name)
                    Toggle("Active", isOn: $draft.isActive)
                    Toggle("Default Garden", isOn: $draft.isDefault)
                }

                Section {
                    TextField("Address", text: $draft.address)
                    TextField("Postal Code", text: $draft.postalCode)
                    TextField("City", text: $draft.city)
                    TextField("Country", text: $draft.country)
                } header: {
                    Text("Address")
                } footer: {
                    Text("Used only to open the map near the right area. It never sets Garden Position automatically.")
                        .font(FaloTypography.caption)
                }

                gardenPositionSection

                climateSection

                if let validationMessage {
                    Section {
                        Text(validationMessage)
                            .foregroundStyle(BonsaiWorldColors.statusAttention)
                    }
                }
            }
            .formStyle(.grouped)
            .faloScrollSurface()
            .navigationTitle(isExisting ? "Edit Garden" : "New Garden")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { save() }
                        .keyboardShortcut(.defaultAction)
                }
            }
            .onAppear {
                isExisting = profile.garden(id: draft.id) != nil
                positionDraft = draft.gardenPosition
                applySuggestedHemisphere()
            }
            .onChange(of: draft.hemisphere) { _, newValue in
                guard hemisphereFollowsPosition else { return }
                let suggested = positionDraft.map { GardenHemisphere.suggested(latitude: $0.latitude) }
                if newValue != suggested {
                    hemisphereFollowsPosition = false
                }
            }
            .sheet(isPresented: $isPositionEditorPresented) {
                GardenPositionEditorSheet(
                    gardenID: draft.id,
                    gardenName: draft.name,
                    composedAddress: draft.composedAddress,
                    preferAddressFraming: preferAddressFraming,
                    position: $positionDraft
                )
                .onDisappear {
                    preferAddressFraming = false
                    applyPositionDraftToGarden()
                }
            }
        }
        .frame(minWidth: 440, minHeight: 520)
    }

    @ViewBuilder
    private var gardenPositionSection: some View {
        Section {
            LabeledContent("Status") {
                Text(positionDraft == nil ? "Not Set" : "Position Set")
                    .foregroundStyle(positionDraft == nil ? .secondary : .primary)
            }

            if let coordinate = positionDraft {
                LabeledContent("Latitude") {
                    Text(String(format: "%.6f", coordinate.latitude))
                        .font(FaloTypography.body.monospaced())
                        .textSelection(.enabled)
                }
                LabeledContent("Longitude") {
                    Text(String(format: "%.6f", coordinate.longitude))
                        .font(FaloTypography.body.monospaced())
                        .textSelection(.enabled)
                }

                Button("Change Position") {
                    openPositionEditor(preferAddressFraming: false)
                }
                Button("Re-center from Address") {
                    openPositionEditor(preferAddressFraming: true)
                }
                .disabled(draft.composedAddress.isEmpty)
                .help("Opens the map at the address. Does not overwrite Garden Position.")

                Button("Clear Position", role: .destructive) {
                    positionDraft = nil
                    draft.clearGardenPosition()
                    if hemisphereFollowsPosition {
                        draft.hemisphere = nil
                        hemisphereFollowsPosition = false
                    }
                }
            } else {
                Button("Set Position") {
                    openPositionEditor(preferAddressFraming: !draft.composedAddress.isEmpty)
                }
                Button("Re-center from Address") {
                    openPositionEditor(preferAddressFraming: true)
                }
                .disabled(draft.composedAddress.isEmpty)
                .help("Opens the map at the address so you can place the Garden marker.")
            }
        } header: {
            Text("Garden Position")
        } footer: {
            Text("The exact physical location you place on the map. Locations use this as their geographic reference.")
                .font(FaloTypography.caption)
        }
    }

    private var climateSection: some View {
        Section {
            Picker("Hemisphere", selection: $draft.hemisphere) {
                Text("Not Set").tag(GardenHemisphere?.none)
                ForEach(GardenHemisphere.allCases) { hemisphere in
                    Text(hemisphere.title).tag(Optional(hemisphere))
                }
            }
            Picker("Season", selection: $draft.season) {
                Text("Not Set").tag(GardenSeason?.none)
                ForEach(GardenSeason.allCases) { season in
                    Text(season.title).tag(Optional(season))
                }
            }
        } header: {
            Text("Climate")
        } footer: {
            Text(GardenClimate.settingsFooter(
                hemisphereFollowsPosition: hemisphereFollowsPosition,
                season: draft.season
            ))
            .font(FaloTypography.caption)
        }
    }

    private func openPositionEditor(preferAddressFraming: Bool) {
        self.preferAddressFraming = preferAddressFraming
        isPositionEditorPresented = true
    }

    private func applyPositionDraftToGarden() {
        if let positionDraft {
            draft.setGardenPosition(positionDraft)
        } else {
            draft.clearGardenPosition()
            if hemisphereFollowsPosition {
                draft.hemisphere = nil
                hemisphereFollowsPosition = false
            }
        }
        applySuggestedHemisphere()
    }

    /// Fills Hemisphere from latitude only while the grower has not chosen one.
    private func applySuggestedHemisphere() {
        guard draft.hemisphere == nil || hemisphereFollowsPosition else { return }
        guard let latitude = positionDraft?.latitude else { return }
        hemisphereFollowsPosition = true
        draft.hemisphere = GardenHemisphere.suggested(latitude: latitude)
    }

    private func save() {
        validationMessage = nil
        let trimmedName = draft.name.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty else {
            validationMessage = "Garden Name is required."
            return
        }

        draft.name = trimmedName
        applyPositionDraftToGarden()

        let saved = profile.saveGarden(draft)
        if saved.isDefault {
            profile.setDefaultGarden(id: saved.id)
        }
        dismiss()
    }
}
