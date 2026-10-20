//
//  NewSeedBatchView.swift
//  Bonsai World
//
//  Field New Seed Batch — Mac NewSeedBatchView fields the model already supports.
//

import SwiftUI

struct NewSeedBatchView: View {
    @Environment(DemoLibrary.self) private var library
    @Environment(\.dismiss) private var dismiss

    var onCreated: (UUID) -> Void

    @State private var name: String = ""
    @State private var species: String = ""
    @State private var seedCount = "50"
    @State private var source = ""
    @State private var seedYear = Calendar.current.component(.year, from: Date())
    @State private var locationID: UUID?
    @State private var notes = ""

    private var canSave: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Name", text: $name)
                        .font(FaloTypography.body)
                        .foregroundStyle(BonsaiWorldColors.textPrimary)
                        .accessibilityLabel("Name")
                    TextField("Species", text: $species)
                        .font(FaloTypography.body)
                        .foregroundStyle(BonsaiWorldColors.textPrimary)
                        .accessibilityLabel("Species")
                } header: {
                    Text("Species")
                } footer: {
                    Text("Stage starts as Planned.")
                }

                Section {
                    TextField("Number of seeds", text: $seedCount)
                        .keyboardType(.numberPad)
                        .font(FaloTypography.body)
                        .foregroundStyle(BonsaiWorldColors.textPrimary)
                        .accessibilityLabel("Number of seeds")
                    TextField("Source", text: $source)
                        .font(FaloTypography.body)
                        .foregroundStyle(BonsaiWorldColors.textPrimary)
                        .accessibilityLabel("Source")
                    TextField("Seed year", value: $seedYear, format: .number.grouping(.never))
                        .keyboardType(.numberPad)
                        .font(FaloTypography.body)
                        .foregroundStyle(BonsaiWorldColors.textPrimary)
                        .accessibilityLabel("Seed year")
                    Picker("Location", selection: $locationID) {
                        Text("None").tag(Optional<UUID>.none)
                        ForEach(library.orderedLocations) { location in
                            Text(location.name).tag(Optional(location.id))
                        }
                    }
                    .accessibilityLabel("Location")
                    TextField("Notes", text: $notes, axis: .vertical)
                        .lineLimit(3...6)
                        .font(FaloTypography.body)
                        .foregroundStyle(BonsaiWorldColors.textPrimary)
                        .accessibilityLabel("Notes")
                } header: {
                    Text("Batch")
                }
            }
            .scrollContentBackground(.hidden)
            .background(BonsaiWorldColors.canvas)
            .scrollDismissesKeyboard(.interactively)
            .navigationTitle("New Seed Batch")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Create") { save() }
                        .fontWeight(.semibold)
                        .disabled(!canSave)
                }
            }
            .toolbarBackground(BonsaiWorldColors.canvas, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.light, for: .navigationBar)
        }
    }

    private func save() {
        let count = Int(seedCount.trimmingCharacters(in: .whitespacesAndNewlines)) ?? 0
        guard let batch = library.addSeedBatch(
            name: name,
            species: species,
            initialSeedCount: max(0, count),
            source: source,
            seedYear: seedYear,
            locationID: locationID,
            notes: notes
        ) else { return }
        onCreated(batch.id)
        dismiss()
    }
}

#Preview {
    NewSeedBatchView(onCreated: { _ in })
        .environment(DemoLibrary.preview)
}
