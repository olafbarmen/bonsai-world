//
//  NewSeedBatchView.swift
//  Bonsai World
//
//  Field New Seed Batch — Name + Species (text), stage Planned.
//

import SwiftUI

struct NewSeedBatchView: View {
    @Environment(DemoLibrary.self) private var library
    @Environment(\.dismiss) private var dismiss

    var onCreated: (UUID) -> Void

    @State private var name: String = ""
    @State private var species: String = ""

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
                } footer: {
                    Text("Stage starts as Planned.")
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
                    Button("Save") { save() }
                        .fontWeight(.semibold)
                        .disabled(!canSave)
                }
            }
            .toolbarBackground(BonsaiWorldColors.canvas, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }
    }

    private func save() {
        guard let batch = library.addSeedBatch(name: name, species: species) else { return }
        onCreated(batch.id)
        dismiss()
    }
}

#Preview {
    NewSeedBatchView(onCreated: { _ in })
        .environment(DemoLibrary.preview)
}
