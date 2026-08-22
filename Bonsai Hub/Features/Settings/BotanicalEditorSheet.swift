//
//  BotanicalEditorSheet.swift
//  Bonsai World
//
//  Context-aware Add / Edit. No Type picker — kind and parents come from selection.
//

import SwiftUI

struct BotanicalEditorSheet: View {
    @Environment(BotanicalService.self) private var botanical
    @Environment(\.dismiss) private var dismiss

    let initialDraft: BotanicalDraft

    @State private var draft: BotanicalDraft

    init(draft: BotanicalDraft) {
        self.initialDraft = draft
        _draft = State(initialValue: draft)
    }

    private var trimmedName: String {
        draft.name.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private var canSave: Bool {
        botanical.validate(draft) == nil
    }

    var body: some View {
        NavigationStack {
            Form {
                contextFields

                TextField(draft.kind.nameFieldLabel, text: $draft.name)

                TextField("Sort Order", value: $draft.sortOrder, format: .number)

                Toggle("Active", isOn: $draft.isActive)
            }
            .formStyle(.grouped)
            .faloScrollSurface()
            .navigationTitle(navigationTitle)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        var toSave = draft
                        toSave.name = trimmedName
                        if botanical.save(toSave) {
                            dismiss()
                        }
                    }
                    .disabled(!canSave)
                }
            }
        }
        .frame(minWidth: 420, minHeight: 280)
    }

    private var navigationTitle: String {
        initialDraft.isNew ? "New \(draft.kind.title)" : "Edit \(draft.kind.title)"
    }

    @ViewBuilder
    private var contextFields: some View {
        switch draft.kind {
        case .genus:
            EmptyView()

        case .species:
            LabeledContent("Genus") {
                Text(FaloDisplayValue.text(draft.genusID.flatMap { botanical.genusName(id: $0) }))
                    .foregroundStyle(.secondary)
            }

        case .cultivar:
            LabeledContent("Genus") {
                Text(FaloDisplayValue.text(draft.genusID.flatMap { botanical.genusName(id: $0) }))
                    .foregroundStyle(.secondary)
            }
            LabeledContent("Species") {
                Text(speciesContextLabel)
                    .foregroundStyle(.secondary)
            }
        }
    }

    private var speciesContextLabel: String {
        guard let speciesID = draft.speciesID,
              let species = botanical.species(id: speciesID) else {
            return FaloDisplayValue.empty
        }
        return botanical.speciesColumnLabel(species)
    }
}
