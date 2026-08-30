//
//  WorkTypeEditorSheet.swift
//  Bonsai World
//
//  Add / Edit Work Type — General fields + prepared behaviour flags.
//  Behaviour toggles are stored only; workflows do not enforce them yet.
//

import SwiftUI

struct WorkTypeEditorSheet: View {
    @Environment(ReferenceDataManager.self) private var manager
    @Environment(\.dismiss) private var dismiss

    let initialDraft: WorkTypeDraft

    @State private var draft: WorkTypeDraft

    init(draft: WorkTypeDraft) {
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
                Section("General") {
                    TextField("Name", text: $draft.name)

                    Picker("Category", selection: $draft.category) {
                        ForEach(WorkTypeCategory.allCases) { category in
                            Text(category.title).tag(category)
                        }
                    }

                    TextField("Description", text: $draft.workDescription, axis: .vertical)
                        .lineLimit(2...5)

                    TextField("Notes", text: $draft.notes, axis: .vertical)
                        .lineLimit(2...4)

                    TextField("Sort Order", value: $draft.sortOrder, format: .number)

                    Toggle("Active", isOn: $draft.isActive)
                }

                Section {
                    behaviourToggle("Requires Soil Mix", \.requiresSoilMix)
                    behaviourToggle("Requires Pot", \.requiresPot)
                    behaviourToggle("Requires Fertilizer", \.requiresFertilizer)
                    behaviourToggle("Requires Product", \.requiresProduct)
                    behaviourToggle("Requires Wire", \.requiresWire)
                    behaviourToggle("Requires Measurements", \.requiresMeasurements)
                    behaviourToggle("Creates Tree History", \.createsTreeHistory)
                    behaviourToggle("Affects Inventory", \.affectsInventory)
                    behaviourToggle("Affects Economy", \.affectsEconomy)
                    behaviourToggle("Can be applied to multiple Trees", \.canApplyToMultipleTrees)
                    behaviourToggle("Can be scheduled", \.canBeScheduled)
                    behaviourToggle("Can use Templates", \.canUseTemplates)
                    behaviourToggle("Tasks complete instantly (no form)", \.tasksCompleteInstantly)
                    behaviourToggle("Expires if missed (never overdue)", \.expiresIfMissed)
                } header: {
                    Text("Behaviour")
                } footer: {
                    Text("“Expires if missed” is for care you cannot do late (watering). Forgotten occurrences disappear instead of stacking as Overdue. Fertilizing and similar work should leave this off.")
                }
            }
            .formStyle(.grouped)
            .faloScrollSurface()
            .navigationTitle(initialDraft.isNew ? "New Work Type" : "Edit Work Type")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        guard canSave else { return }
                        var toSave = draft
                        toSave.name = trimmedName
                        if manager.saveWorkType(toSave) {
                            dismiss()
                        }
                    }
                    .disabled(!canSave)
                }
            }
        }
        .frame(minWidth: 480, minHeight: 520)
    }

    private func behaviourToggle(
        _ title: String,
        _ keyPath: WritableKeyPath<WorkTypeBehaviourFlags, Bool>
    ) -> some View {
        Toggle(title, isOn: Binding(
            get: { draft.behaviour[keyPath: keyPath] },
            set: { draft.behaviour[keyPath: keyPath] = $0 }
        ))
    }
}
