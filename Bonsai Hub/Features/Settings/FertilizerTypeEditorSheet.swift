//
//  FertilizerTypeEditorSheet.swift
//  Bonsai World
//
//  Add / Edit Fertilizer Type — one entry per product the grower actually uses.
//  Name carries product/brand identity (e.g. "BioGold Original"); Form, Release,
//  and Origin are independent classifications so future fertilizing rules per
//  Tree can match on any axis without being locked to flat combinations.
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
                    TextField("Name", text: $draft.name, prompt: Text("e.g. BioGold Original"))

                    TextField("NPK", text: $draft.npk, prompt: Text("e.g. 6-3-6"))

                    TextField("Sort Order", value: $draft.sortOrder, format: .number)

                    Toggle("Active", isOn: $draft.isActive)
                } header: {
                    Text("General")
                } footer: {
                    Text("Name is the product as you know it — it can carry the brand, e.g. “BioGold Original”.")
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
                        if let saved = manager.saveFertilizerType(toSave) {
                            onSave(saved)
                            dismiss()
                        }
                    }
                    .disabled(!canSave)
                }
            }
        }
        .frame(minWidth: 440, minHeight: 420)
    }
}
