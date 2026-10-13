//
//  NewSoilMixView.swift
//  Bonsai World
//
//  Field New Soil Mix — Name, 2–3 component %, Notes.
//

import SwiftUI

struct NewSoilMixView: View {
    @Environment(DemoLibrary.self) private var library
    @Environment(\.dismiss) private var dismiss

    var onCreated: (UUID) -> Void

    @State private var name: String = ""
    @State private var notes: String = ""
    @State private var partLines: [SoilMixPartDraftLine] = SoilMixPartDraftLine.emptyLines()

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
                }

                SoilMixPartsEditor(lines: $partLines)

                Section("Notes") {
                    TextEditor(text: $notes)
                        .frame(minHeight: 88)
                        .font(FaloTypography.body)
                        .foregroundStyle(BonsaiWorldColors.textPrimary)
                        .accessibilityLabel("Notes")
                }
            }
            .scrollContentBackground(.hidden)
            .background(BonsaiWorldColors.canvas)
            .scrollDismissesKeyboard(.interactively)
            .navigationTitle("New Soil Mix")
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
        let parts = SoilMixPartDraftLine.toParts(partLines)
        guard let mix = library.addSoilMix(name: name, notes: notes, parts: parts) else { return }
        onCreated(mix.id)
        dismiss()
    }
}

#Preview {
    NewSoilMixView(onCreated: { _ in })
        .environment(DemoLibrary.preview)
}
