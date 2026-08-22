//
//  LocationReferenceEditorSheet.swift
//  Bonsai World
//
//  Shared Location editor — Reference Data Manager and Quick Action.
//  Every Location belongs to one Garden. Trees never store coordinates.
//

import SwiftUI

struct LocationReferenceEditorSheet: View {
    @Environment(ReferenceDataManager.self) private var manager
    @Environment(UserProfileStore.self) private var profile
    @Environment(AppState.self) private var appState
    @Environment(\.dismiss) private var dismiss

    let initialDraft: LocationReferenceDraft
    /// When set (e.g. nested in New Tree), save returns here instead of navigating the app.
    var onSaved: ((UUID) -> Void)? = nil

    @State private var draft: LocationReferenceDraft
    @State private var validationMessage: String?
    @State private var isMapPresented = false

    init(draft: LocationReferenceDraft, onSaved: ((UUID) -> Void)? = nil) {
        self.initialDraft = draft
        self.onSaved = onSaved
        _draft = State(initialValue: draft)
    }

    private var locationTypes: [LocationType] {
        manager.locationTypesForPicker()
    }

    private var gardens: [Garden] {
        _ = profile.revision
        return profile.activeGardens
    }

    private var trimmedName: String {
        draft.name.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private var mapLocationTitle: String {
        trimmedName.isEmpty ? "Location" : trimmedName
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Name", text: $draft.name)

                    Picker("Garden", selection: $draft.gardenID) {
                        Text("Select Garden").tag(Optional<UUID>.none)
                        ForEach(gardens) { garden in
                            Text(garden.isDefault ? "\(garden.name) (Default)" : garden.name)
                                .tag(Optional(garden.id))
                        }
                    }
                    .pickerStyle(.menu)

                    Picker("Location Type", selection: $draft.locationTypeID) {
                        Text("Select Location Type").tag(Optional<UUID>.none)
                        ForEach(locationTypes) { type in
                            Text(type.name).tag(Optional(type.id))
                        }
                    }
                    .pickerStyle(.menu)

                    TextField("Description", text: $draft.locationDescription, axis: .vertical)
                        .lineLimit(2...5)

                    TextField("Notes", text: $draft.notes, axis: .vertical)
                        .lineLimit(2...6)

                    Toggle("Active", isOn: $draft.isActive)
                } header: {
                    Text("General")
                } footer: {
                    Text("Name, Garden, and Location Type are required.")
                        .font(FaloTypography.caption)
                }

                mapSection

                if let validationMessage {
                    Section {
                        Text(validationMessage)
                            .foregroundStyle(.orange)
                            .font(FaloTypography.body)
                    }
                }
            }
            .formStyle(.grouped)
            .faloScrollSurface()
            .navigationTitle(initialDraft.isNew ? "New Location" : "Edit Location")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        close()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        save()
                    }
                    .keyboardShortcut(.defaultAction)
                }
            }
            .sheet(isPresented: $isMapPresented) {
                LocationMapEditorSheet(
                    locationID: draft.entityID ?? draft.id,
                    locationName: mapLocationTitle,
                    gardenLocations: gardenSiblingLocations,
                    garden: draft.gardenID.flatMap { profile.garden(id: $0) },
                    position: $draft.geographicPosition
                )
            }
            .onAppear {
                if draft.gardenID == nil {
                    draft.gardenID = profile.defaultGarden?.id
                }
            }
        }
        .frame(minWidth: 480, minHeight: 560)
    }

    private var gardenSiblingLocations: [LocationReference] {
        guard let gardenID = draft.gardenID else { return [] }
        return manager.locations(inGarden: gardenID)
    }

    @ViewBuilder
    private var mapSection: some View {
        Section {
            if let position = draft.geographicPosition {
                LabeledContent("Latitude") {
                    Text(String(format: "%.6f", position.latitude))
                        .font(FaloTypography.body.monospaced())
                        .textSelection(.enabled)
                }
                LabeledContent("Longitude") {
                    Text(String(format: "%.6f", position.longitude))
                        .font(FaloTypography.body.monospaced())
                        .textSelection(.enabled)
                }
                LabeledContent("Last Updated") {
                    Text(position.lastUpdated.formatted(date: .abbreviated, time: .shortened))
                }

                Button("Set Position") {
                    isMapPresented = true
                }
                Button("Clear Position", role: .destructive) {
                    draft.geographicPosition = nil
                }
            } else {
                Text("No position selected.")
                    .foregroundStyle(.secondary)

                Button("Set Position") {
                    isMapPresented = true
                }
            }
        } header: {
            Text("Map")
        } footer: {
            Text("Opens the Garden map. Location pins are independent of Garden Address. Prefer a saved Garden Position as the map reference. Trees at this Location inherit this position.")
                .font(FaloTypography.caption)
        }
    }

    private func save() {
        validationMessage = nil

        var toSave = draft
        toSave.name = trimmedName

        if trimmedName.isEmpty {
            validationMessage = message(for: .missingName)
            return
        }
        if toSave.gardenID == nil {
            validationMessage = message(for: .missingGarden)
            return
        }
        if toSave.locationTypeID == nil {
            validationMessage = message(for: .missingLocationType)
            return
        }

        switch manager.saveLocation(toSave) {
        case .success(let savedID):
            if let onSaved {
                onSaved(savedID)
                dismiss()
            } else {
                appState.selectedLocationID = savedID
                close()
            }
        case .failure(let error):
            validationMessage = message(for: error)
        }
    }

    private func close() {
        if onSaved == nil {
            appState.dismissLocationEditor()
        }
        dismiss()
    }

    private func message(for error: ReferenceDataManager.LocationSaveError) -> String {
        switch error {
        case .missingName:
            "Name is required."
        case .missingGarden:
            "Garden is required."
        case .missingLocationType:
            "Location Type is required."
        case .duplicateName:
            "A Location with this name already exists."
        }
    }
}
