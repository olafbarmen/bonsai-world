//
//  ReferenceDataEditorSheet.swift
//  Bonsai World
//
//  Add / Edit sheet for a flat Reference Data item (Name, Sort Order, Active).
//

import SwiftUI

struct ReferenceDataEditorSheet: View {
    @Environment(ReferenceDataManager.self) private var manager
    @Environment(\.dismiss) private var dismiss

    let category: ReferenceDataCategory
    let initialDraft: ReferenceDataDraft

    @State private var draft: ReferenceDataDraft

    init(category: ReferenceDataCategory, draft: ReferenceDataDraft) {
        self.category = category
        self.initialDraft = draft
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
                TextField("Name", text: $draft.name)

                TextField(
                    "Sort Order",
                    value: $draft.sortOrder,
                    format: .number
                )

                Toggle("Active", isOn: $draft.isActive)
            }
            .formStyle(.grouped)
            .faloScrollSurface()
            .navigationTitle(initialDraft.isNew ? "New \(category.title)" : "Edit \(category.title)")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        guard canSave else { return }
                        var toSave = draft
                        toSave.name = trimmedName
                        if manager.save(toSave, in: category) {
                            dismiss()
                        }
                    }
                    .disabled(!canSave)
                }
            }
        }
        .frame(minWidth: 420, minHeight: 280)
    }
}
