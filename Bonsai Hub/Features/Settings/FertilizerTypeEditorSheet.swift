//
//  FertilizerTypeEditorSheet.swift
//  Bonsai World
//
//  Add / Edit Fertilizer Type — Brand + Name, N / P / K, and classifications.
//

import SwiftUI

struct FertilizerTypeEditorSheet: View {
    @Environment(ReferenceDataManager.self) private var manager
    @Environment(\.dismiss) private var dismiss

    let initialDraft: FertilizerTypeDraft
    /// Fires with the saved entry — lets callers (e.g. Add Work) select it immediately
    /// instead of the grower having to reopen the picker after creating it inline.
    var onSave: (FertilizerType) -> Void = { _ in }

    @State private var draft: FertilizerTypeDraft

    init(draft: FertilizerTypeDraft, onSave: @escaping (FertilizerType) -> Void = { _ in }) {
        self.initialDraft = draft
        self.onSave = onSave
        _draft = State(initialValue: draft)
    }

    private var trimmedName: String {
        draft.name.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private var canSave: Bool {
        !trimmedName.isEmpty
    }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Brand", text: $draft.brand, prompt: Text("e.g. BioGold"))

                    TextField("Name", text: $draft.name, prompt: Text("e.g. Original"))

                    TextField("Sort Order", value: $draft.sortOrder, format: .number)

                    Toggle("Active", isOn: $draft.isActive)
                } header: {
                    Text("General")
                } footer: {
                    Text("Brand is optional. Lists show Brand + Name when both are set.")
                }

                Section {
                    TextField("N", value: $draft.nitrogen, format: .number.precision(.fractionLength(0...2)))
                    TextField("P", value: $draft.phosphorus, format: .number.precision(.fractionLength(0...2)))
                    TextField("K", value: $draft.potassium, format: .number.precision(.fractionLength(0...2)))
                } header: {
                    Text("NPK")
                } footer: {
                    let label = draft.npk
                    Text(label.isEmpty ? "Leave blank if unknown." : "Stored as \(label).")
                }

                Section {
                    Picker("Origin", selection: $draft.origin) {
                        ForEach(FertilizerOrigin.allCases) { origin in
                            Text(origin.title).tag(origin)
                        }
                    }

                    Picker("Form", selection: $draft.form) {
                        ForEach(FertilizerForm.allCases) { form in
                            Text(form.title).tag(form)
                        }
                    }

                    Picker("Release", selection: $draft.release) {
                        ForEach(FertilizerRelease.allCases) { release in
                            Text(release.title).tag(release)
                        }
                    }
                } header: {
                    Text("Classification")
                } footer: {
                    Text("Independent properties — pick the combination that matches this product, e.g. Organic / Pellet / Slow Release.")
                }
            }
            .formStyle(.grouped)
            .faloScrollSurface()
            .navigationTitle(initialDraft.isNew ? "New Fertilizer Type" : "Edit Fertilizer Type")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        guard canSave else { return }
                        var toSave = draft
                        toSave.name = trimmedName
                        toSave.brand = draft.brand.trimmingCharacters(in: .whitespacesAndNewlines)
                        if let saved = manager.saveFertilizerType(toSave) {
                            onSave(saved)
                            dismiss()
                        }
                    }
                    .disabled(!canSave)
                }
            }
        }
        .frame(minWidth: 440, minHeight: 480)
    }
}
