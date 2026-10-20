//
//  PotProfileView.swift
//  Bonsai World
//
//  Inventory Pot profile — status, identity, linked tree.
//

import SwiftUI

struct PotProfileView: View {
    @Environment(DemoLibrary.self) private var library
    @Environment(\.dismiss) private var dismiss

    let potID: UUID

    @State private var name = ""
    @State private var material = ""
    @State private var shape = ""
    @State private var condition = ""
    @State private var notes = ""
    @State private var status: PotStatus = .available
    @State private var didLoad = false
    @State private var confirmDelete = false

    private var pot: Pot? { library.pot(id: potID) }

    private var editableStatuses: [PotStatus] {
        PotStatus.allCases
    }

    var body: some View {
        Group {
            if let pot {
                form(pot)
            } else {
                ContentUnavailableView("Pot not found", systemImage: "shippingbox")
            }
        }
        .onAppear { loadIfNeeded() }
    }

    private func form(_ pot: Pot) -> some View {
        Form {
            Section("Identity") {
                TextField("Name", text: $name)
                    .font(FaloTypography.body)
                    .foregroundStyle(BonsaiWorldColors.textPrimary)
                    .accessibilityLabel("Name")
                TextField("Material", text: $material)
                    .font(FaloTypography.body)
                    .foregroundStyle(BonsaiWorldColors.textPrimary)
                    .accessibilityLabel("Material")
                TextField("Shape", text: $shape)
                    .font(FaloTypography.body)
                    .foregroundStyle(BonsaiWorldColors.textPrimary)
                    .accessibilityLabel("Shape")
                TextField("Condition", text: $condition)
                    .font(FaloTypography.body)
                    .foregroundStyle(BonsaiWorldColors.textPrimary)
                    .accessibilityLabel("Condition")
                Picker("Status", selection: $status) {
                    ForEach(editableStatuses, id: \.self) { value in
                        Text(value.title).tag(value)
                    }
                }
                .accessibilityLabel("Status")
            }

            if let treeID = pot.linkedTreeID, let tree = library.tree(id: treeID) {
                Section("Linked Tree") {
                    NavigationLink(value: MobileRoute.tree(treeID)) {
                        Text(MobileTreePresentation.title(for: tree))
                            .font(FaloTypography.body)
                            .foregroundStyle(BonsaiWorldColors.textPrimary)
                    }
                    .listRowBackground(BonsaiWorldColors.surface)
                    Button("Remove from Tree", role: .destructive) {
                        _ = library.unassignCurrentPot(fromTreeID: treeID)
                        status = .available
                    }
                }
            }

            if !pot.history.isEmpty {
                Section("History") {
                    ForEach(pot.history.reversed().prefix(12)) { entry in
                        VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
                            Text(entry.date.formatted(date: .abbreviated, time: .omitted))
                                .font(FaloTypography.caption)
                                .foregroundStyle(BonsaiWorldColors.textSecondary)
                            Text(entry.kind.title)
                                .font(FaloTypography.body)
                                .foregroundStyle(BonsaiWorldColors.textPrimary)
                            if !entry.note.isEmpty {
                                Text(entry.note)
                                    .font(FaloTypography.caption)
                                    .foregroundStyle(BonsaiWorldColors.textSecondary)
                            }
                        }
                        .listRowBackground(BonsaiWorldColors.surface)
                    }
                }
            }

            Section("Notes") {
                TextEditor(text: $notes)
                    .frame(minHeight: 88)
                    .font(FaloTypography.body)
                    .foregroundStyle(BonsaiWorldColors.textPrimary)
                    .accessibilityLabel("Notes")
            }

            Section {
                Button("Delete Pot", role: .destructive) {
                    confirmDelete = true
                }
                .frame(maxWidth: .infinity, minHeight: 44, alignment: .leading)
                .contentShape(Rectangle())
            }
        }
        .scrollContentBackground(.hidden)
        .background(BonsaiWorldColors.canvas)
        .scrollDismissesKeyboard(.interactively)
        .navigationTitle(library.displayName(for: pot))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") { save() }
                    .fontWeight(.semibold)
            }
        }
        .toolbarBackground(BonsaiWorldColors.canvas, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarColorScheme(.light, for: .navigationBar)
        .confirmationDialog(
            "Delete this pot?",
            isPresented: $confirmDelete,
            titleVisibility: .visible
        ) {
            Button("Delete", role: .destructive) {
                library.deletePot(id: potID)
                dismiss()
            }
            Button("Cancel", role: .cancel) {}
        }
    }

    private func loadIfNeeded() {
        guard !didLoad, let pot else { return }
        name = pot.name
        material = pot.material
        shape = pot.shape
        condition = pot.condition
        notes = pot.notes
        status = pot.status
        didLoad = true
    }

    private func save() {
        if status != .inUse, let pot, let treeID = pot.linkedTreeID {
            _ = library.unassignCurrentPot(fromTreeID: treeID)
        }
        library.updatePot(
            id: potID,
            name: name,
            material: material,
            shape: shape,
            condition: condition,
            notes: notes,
            status: status
        )
    }
}

#Preview {
    NavigationStack {
        PotProfileView(potID: UUID())
    }
    .environment(DemoLibrary.preview)
}
