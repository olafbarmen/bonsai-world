//
//  NewYamadoriView.swift
//  Bonsai World
//

import SwiftUI

struct NewYamadoriView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(AppState.self) private var appState
    @Environment(YamadoriService.self) private var yamadoriService
    @Environment(ReferenceDataService.self) private var referenceData

    @State private var displayName = ""
    @State private var genusID: UUID?
    @State private var speciesID: UUID?
    @State private var cultivarID: UUID?
    @State private var discoveryDate = Date.now
    @State private var hasDiscoveryDate = true
    @State private var latitudeText = ""
    @State private var longitudeText = ""
    @State private var locationDescription = ""
    @State private var countryRegion = ""
    @State private var permissionNotes = ""
    @State private var notes = ""
    @State private var errorMessage: String?

    private var speciesForGenus: [Species] {
        guard let genusID else { return [] }
        return referenceData.species(forGenusID: genusID)
    }

    private var cultivarsForSpecies: [Cultivar] {
        guard let speciesID else { return [] }
        return referenceData.cultivars(forSpeciesID: speciesID)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Identity") {
                    TextField("Display Name", text: $displayName)
                    Picker("Genus", selection: $genusID) {
                        Text("Select Genus").tag(Optional<UUID>.none)
                        ForEach(referenceData.genus) { genus in
                            Text(genus.name).tag(Optional(genus.id))
                        }
                    }
                    .onChange(of: genusID) { _, _ in
                        speciesID = nil
                        cultivarID = nil
                    }

                    Picker("Species", selection: $speciesID) {
                        Text("Select Species").tag(Optional<UUID>.none)
                        ForEach(speciesForGenus) { species in
                            Text(species.name).tag(Optional(species.id))
                        }
                    }
                    .disabled(genusID == nil)
                    .onChange(of: speciesID) { _, _ in
                        cultivarID = nil
                    }

                    Picker("Cultivar", selection: $cultivarID) {
                        Text("None").tag(Optional<UUID>.none)
                        ForEach(cultivarsForSpecies) { cultivar in
                            Text(cultivar.name).tag(Optional(cultivar.id))
                        }
                    }
                    .disabled(speciesID == nil)

                    Toggle("Discovery Date", isOn: $hasDiscoveryDate)
                    if hasDiscoveryDate {
                        DatePicker("Date", selection: $discoveryDate, displayedComponents: .date)
                    }
                }

                Section("Wild Site") {
                    TextField("Location Description", text: $locationDescription)
                    TextField("Country / Region", text: $countryRegion)
                    TextField("Latitude", text: $latitudeText)
                    TextField("Longitude", text: $longitudeText)
                    TextField("Permission Notes", text: $permissionNotes, axis: .vertical)
                        .lineLimit(2...4)
                }

                Section("Notes") {
                    TextField("Notes", text: $notes, axis: .vertical)
                        .lineLimit(3...6)
                }
            }
            .formStyle(.grouped)
            .navigationTitle("New Yamadori")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        appState.dismissYamadoriEditor()
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Create") { create() }
                }
            }
            .alert("Could Not Create Yamadori", isPresented: Binding(
                get: { errorMessage != nil },
                set: { if !$0 { errorMessage = nil } }
            )) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(errorMessage ?? "")
            }
        }
        .frame(minWidth: 480, minHeight: 520)
    }

    private func create() {
        var draft = NewYamadoriDraft()
        draft.displayName = displayName
        draft.genusID = genusID
        draft.speciesID = speciesID
        draft.cultivarID = cultivarID
        draft.discoveryDate = hasDiscoveryDate ? discoveryDate : nil
        draft.latitude = Double(latitudeText.replacingOccurrences(of: ",", with: "."))
        draft.longitude = Double(longitudeText.replacingOccurrences(of: ",", with: "."))
        draft.locationDescription = locationDescription
        draft.countryRegion = countryRegion
        draft.permissionNotes = permissionNotes
        draft.notes = notes

        do {
            let created = try yamadoriService.createYamadori(fromDraft: draft)
            appState.selectedSection = .nurseryYamadori
            appState.selectedYamadoriWorkspaceTab = .yamadories
            appState.selectedYamadoriID = created.trip.id
            appState.selectedYamadoriFindID = nil
            appState.dismissYamadoriEditor()
            dismiss()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
