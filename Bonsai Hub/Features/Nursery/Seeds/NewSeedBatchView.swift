//
//  NewSeedBatchView.swift
//  Bonsai World
//

import SwiftUI

struct NewSeedBatchView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(SeedBatchService.self) private var seedBatchService
    @Environment(SeedStratificationCatalogService.self) private var catalog
    @Environment(ReferenceDataService.self) private var referenceData
    @Environment(AppState.self) private var appState

    @State private var search = ""
    @State private var selectedSpeciesID: UUID?
    @State private var seedCount = "50"
    @State private var source = ""
    @State private var seedYear = Calendar.current.component(.year, from: Date())
    @State private var locationID: UUID?
    @State private var notes = ""
    @State private var errorMessage: String?

    private var matches: [SpeciesStratificationProfile] {
        let trimmed = search.trimmingCharacters(in: .whitespacesAndNewlines)
        guard trimmed.count >= 2 else { return [] }
        return Array(catalog.matching(search: trimmed).prefix(40))
    }

    private var selectedProfile: SpeciesStratificationProfile? {
        guard let selectedSpeciesID else { return nil }
        return catalog.profile(speciesID: selectedSpeciesID)
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Species") {
                    TextField("Search botanical or common name", text: $search)
                    if search.trimmingCharacters(in: .whitespacesAndNewlines).count < 2 {
                        Text("Type at least 2 characters to search.")
                            .foregroundStyle(.secondary)
                    } else if matches.isEmpty {
                        Text("No matching species.")
                            .foregroundStyle(.secondary)
                    } else {
                        Picker("Species", selection: $selectedSpeciesID) {
                            Text("Select").tag(UUID?.none)
                            ForEach(matches) { profile in
                                Text("\(profile.scientificName) — \(profile.commonName)")
                                    .tag(Optional(profile.speciesID))
                            }
                        }
                    }
                    if let selectedProfile {
                        Text(selectedProfile.treatmentType.title)
                            .foregroundStyle(.secondary)
                    }
                }
                Section("Batch") {
                    TextField("Number of seeds", text: $seedCount)
                    TextField("Source", text: $source)
                    TextField("Seed year", value: $seedYear, format: .number.grouping(.never))
                    Picker("Location", selection: $locationID) {
                        Text("None").tag(UUID?.none)
                        ForEach(referenceData.locations) { location in
                            Text(location.name).tag(Optional(location.id))
                        }
                    }
                    TextField("Notes", text: $notes, axis: .vertical)
                        .lineLimit(3...6)
                }
            }
            .formStyle(.grouped)
            .navigationTitle("New Seed Batch")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Create") { create() }
                        .disabled(selectedProfile == nil)
                }
            }
            .alert("Could Not Create Batch", isPresented: Binding(
                get: { errorMessage != nil },
                set: { if !$0 { errorMessage = nil } }
            )) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(errorMessage ?? "")
            }
        }
        .frame(minWidth: 480, minHeight: 420)
    }

    private func create() {
        guard let profile = selectedProfile else { return }
        guard let count = Int(seedCount.trimmingCharacters(in: .whitespacesAndNewlines)), count > 0 else {
            errorMessage = "Enter a valid seed count."
            return
        }
        do {
            let batch = try seedBatchService.createBatch(
                SeedBatchCreateDraft(
                    speciesID: profile.speciesID,
                    botanicalName: profile.scientificName,
                    commonName: profile.commonName,
                    initialSeedCount: count,
                    source: source,
                    collectionDate: nil,
                    acquisitionDate: .now,
                    seedYear: seedYear,
                    locationID: locationID,
                    notes: notes
                )
            )
            appState.selectedSeedBatchID = batch.id
            dismiss()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
