//
//  SoilMixProfileView.swift
//  Bonsai World
//
//  Soil Mix profile — name, composition %, notes + Delete.
//

import SwiftUI

struct SoilMixProfileView: View {
    @Environment(DemoLibrary.self) private var library
    @Environment(\.dismiss) private var dismiss

    let mixID: UUID

    @State private var name: String = ""
    @State private var notes: String = ""
    @State private var partLines: [SoilMixPartDraftLine] = SoilMixPartDraftLine.emptyLines()
    @State private var didLoad = false
    @State private var confirmDelete = false

    private var mix: SoilMix? { library.soilMix(id: mixID) }

    private var canSave: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var body: some View {
        Group {
            if mix != nil {
                form
            } else {
                ContentUnavailableView("Soil Mix not found", systemImage: "square.stack.3d.up")
            }
        }
        .onAppear { loadIfNeeded() }
    }

    private var form: some View {
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

            Section("Used by") {
                let users = library.trees(usingSoilMix: mixID)
                if users.isEmpty {
                    Text("Empty")
                        .font(FaloTypography.body)
                        .foregroundStyle(BonsaiWorldColors.textSecondary)
                } else {
                    Text(users.count == 1 ? "1 Tree" : "\(users.count) Trees")
                        .font(FaloTypography.caption)
                        .foregroundStyle(BonsaiWorldColors.textSecondary)
                    ForEach(users) { tree in
                        NavigationLink(value: MobileRoute.tree(tree.id)) {
                            Text(MobileTreePresentation.title(for: tree))
                                .font(FaloTypography.body)
                                .foregroundStyle(BonsaiWorldColors.textPrimary)
                        }
                    }
                }
            }

            Section("Used by Seeds") {
                let batches = library.seedBatches(usingSoilMix: mixID)
                if batches.isEmpty {
                    Text("Empty")
                        .font(FaloTypography.body)
                        .foregroundStyle(BonsaiWorldColors.textSecondary)
                } else {
                    Text(batches.count == 1 ? "1 Seed Batch" : "\(batches.count) Seed Batches")
                        .font(FaloTypography.caption)
                        .foregroundStyle(BonsaiWorldColors.textSecondary)
                    ForEach(batches) { batch in
                        NavigationLink(value: MobileRoute.seedBatch(batch.id)) {
                            Text(batch.botanicalName.isEmpty ? batch.batchCode : batch.botanicalName)
                                .font(FaloTypography.body)
                                .foregroundStyle(BonsaiWorldColors.textPrimary)
                        }
                    }
                }
            }

            Section {
                Button("Delete Mix", role: .destructive) {
                    confirmDelete = true
                }
                .font(FaloTypography.body)
                .frame(maxWidth: .infinity, minHeight: 44, alignment: .leading)
                .contentShape(Rectangle())
                .accessibilityLabel("Delete Mix")
                .accessibilityHint("Remove this soil mix. Trees keep their other fields.")
            }
        }
        .scrollContentBackground(.hidden)
        .background(BonsaiWorldColors.canvas)
        .scrollDismissesKeyboard(.interactively)
        .navigationTitle(mix?.name ?? "Soil Mix")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") { save() }
                    .fontWeight(.semibold)
                    .disabled(!canSave)
            }
        }
        .toolbarBackground(BonsaiWorldColors.canvas, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .confirmationDialog(
            "Delete this soil mix?",
            isPresented: $confirmDelete,
            titleVisibility: .visible
        ) {
            Button("Delete", role: .destructive) {
                library.deleteSoilMix(id: mixID)
                dismiss()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Trees that used this mix keep their other fields. The Soil Mix link is cleared.")
        }
    }

    private func loadIfNeeded() {
        guard !didLoad, let mix else { return }
        name = mix.name
        notes = mix.mixDescription
        partLines = SoilMixPartDraftLine.from(mix.parts)
        didLoad = true
    }

    private func save() {
        library.updateSoilMix(
            id: mixID,
            name: name,
            notes: notes,
            parts: SoilMixPartDraftLine.toParts(partLines)
        )
    }
}

#Preview {
    NavigationStack {
        SoilMixProfileView(mixID: UUID())
    }
    .environment(DemoLibrary.preview)
}
