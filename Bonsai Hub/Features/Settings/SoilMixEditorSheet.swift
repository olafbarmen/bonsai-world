//
//  SoilMixEditorSheet.swift
//  Bonsai World
//
//  Add / Edit Soil Mix — name, optional description / intended use, and
//  component percentages that must total exactly 100%.
//

import SwiftUI

struct SoilMixEditorSheet: View {
    @Environment(ReferenceDataManager.self) private var manager
    @Environment(\.dismiss) private var dismiss

    let initialDraft: SoilMixDraft

    @State private var draft: SoilMixDraft

    init(draft: SoilMixDraft) {
        self.initialDraft = draft
        _draft = State(initialValue: draft)
    }

    private var components: [SoilComponent] {
        manager.soilComponentsForPicker()
    }

    private var trimmedName: String {
        draft.name.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private var canSave: Bool {
        !trimmedName.isEmpty && draft.isPercentageValid
    }

    private var percentageWarning: String? {
        if draft.parts.isEmpty {
            return "Add at least one soil component."
        }
        if draft.parts.contains(where: { $0.componentID == nil }) {
            return "Choose a soil component for every row."
        }
        if draft.parts.contains(where: { $0.percentage <= 0 }) {
            return "Each component percentage must be greater than 0."
        }
        if draft.totalPercentage != 100 {
            return "Total must equal 100%. Currently \(draft.totalPercentage)%."
        }
        return nil
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Mix") {
                    TextField("Name", text: $draft.name)
                    TextField("Description (optional)", text: $draft.mixDescription, axis: .vertical)
                        .lineLimit(2...4)
                    TextField("Intended Use (optional)", text: $draft.intendedUse)
                    TextField("Sort Order", value: $draft.sortOrder, format: .number)
                    Toggle("Active", isOn: $draft.isActive)
                }

                Section {
                    ForEach($draft.parts) { $part in
                        HStack(alignment: .firstTextBaseline, spacing: FaloSpacing.small) {
                            Picker("Component", selection: $part.componentID) {
                                Text("Select Component").tag(Optional<UUID>.none)
                                ForEach(components) { component in
                                    Text(component.name).tag(Optional(component.id))
                                }
                            }
                            .labelsHidden()
                            .frame(maxWidth: .infinity, alignment: .leading)

                            TextField(
                                "%",
                                value: $part.percentage,
                                format: .number
                            )
                            .multilineTextAlignment(.trailing)
                            .frame(width: 56)

                            Text("%")
                                .foregroundStyle(.secondary)

                            Button(role: .destructive) {
                                draft.parts.removeAll { $0.id == part.id }
                            } label: {
                                Image(systemName: "minus.circle.fill")
                            }
                            .buttonStyle(.borderless)
                            .help("Remove component")
                        }
                    }

                    Button {
                        draft.parts.append(SoilMixPartDraft())
                    } label: {
                        Label("Add Component", systemImage: "plus")
                    }
                } header: {
                    Text("Composition")
                } footer: {
                    VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
                        Text("Total: \(draft.totalPercentage)%")
                            .font(FaloTypography.body)
                            .foregroundStyle(draft.totalPercentage == 100 ? Color.primary : Color.orange)

                        if let percentageWarning {
                            Text(percentageWarning)
                                .foregroundStyle(.orange)
                        }
                    }
                    .padding(.top, FaloSpacing.xSmall)
                }
            }
            .formStyle(.grouped)
            .faloScrollSurface()
            .navigationTitle(initialDraft.isNew ? "New Soil Mix" : "Edit Soil Mix")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        guard canSave else { return }
                        var toSave = draft
                        toSave.name = trimmedName
                        if manager.saveSoilMix(toSave) {
                            dismiss()
                        }
                    }
                    .disabled(!canSave)
                }
            }
        }
        .frame(minWidth: 520, minHeight: 420)
    }
}
