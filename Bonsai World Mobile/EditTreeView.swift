//
//  EditTreeView.swift
//  Bonsai World
//
//  Field Tree edit — nickname, locationID, soilMixID, notes. Permanent identity is read-only.
//  Commits through DemoLibrary on Save. No nested NavigationStack.
//

import SwiftUI

struct EditTreeView: View {
    @Environment(DemoLibrary.self) private var library
    @Environment(\.dismiss) private var dismiss

    let treeID: UUID

    @State private var nickname: String = ""
    @State private var locationID: UUID = CanonicalLocationID.altan
    @State private var soilMixID: UUID?
    @State private var healthStatus: TreeHealthStatus = .stable
    @State private var notes: String = ""
    @State private var didLoadDraft = false

    private var tree: Tree? { library.tree(id: treeID) }

    private var hasChanges: Bool {
        guard let tree else { return false }
        return nickname != tree.nickname
            || locationID != tree.locationID
            || soilMixID != tree.soilMixID
            || healthStatus != tree.healthStatus
            || notes != tree.notes
    }

    var body: some View {
        Group {
            if let tree {
                editorForm(tree)
            } else {
                ContentUnavailableView("Tree not found", systemImage: "leaf")
            }
        }
    }

    private func editorForm(_ tree: Tree) -> some View {
        Form {
            Section("Identity") {
                readOnlyRow(label: "Bonsai Name", value: MobileTreePresentation.bonsaiNameLine(for: tree))
                readOnlyRow(label: "Botanical", value: MobileTreePresentation.botanicalLine(for: tree))
                TextField("Nickname", text: $nickname)
                    .font(FaloTypography.body)
                    .foregroundStyle(BonsaiWorldColors.textPrimary)
                    .accessibilityLabel("Nickname")
            }

            Section("Location") {
                Picker("Location", selection: $locationID) {
                    ForEach(locationOptions) { item in
                        Text(item.name).tag(item.id)
                    }
                }
                .accessibilityLabel("Location")
            }

            Section("Soil Mix") {
                Picker("Soil Mix", selection: $soilMixID) {
                    Text("None").tag(Optional<UUID>.none)
                    ForEach(library.orderedSoilMixes) { mix in
                        Text(mix.name).tag(Optional(mix.id))
                    }
                }
                .accessibilityLabel("Soil Mix")
            }

            Section("Health") {
                Picker("Health", selection: $healthStatus) {
                    ForEach(TreeHealthStatus.allCases) { status in
                        Text(status.title).tag(status)
                    }
                }
                .accessibilityLabel("Health")
            }

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
        .navigationTitle("Edit Tree")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") { dismiss() }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") { save() }
                    .fontWeight(.semibold)
                    .disabled(!hasChanges)
            }
        }
        .toolbarBackground(BonsaiWorldColors.canvas, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
        .onAppear {
            guard !didLoadDraft else { return }
            nickname = tree.nickname
            locationID = tree.locationID
            soilMixID = tree.soilMixID
            healthStatus = tree.healthStatus
            notes = tree.notes
            didLoadDraft = true
        }
    }

    private var locationOptions: [CanonicalLocationID.Item] {
        var items = library.orderedLocations.map {
            CanonicalLocationID.Item(id: $0.id, name: $0.name)
        }
        if !items.contains(where: { $0.id == locationID }) {
            let name = library.locationName(for: locationID)
                ?? CanonicalLocationID.name(for: locationID)
                ?? ""
            items.insert(CanonicalLocationID.Item(id: locationID, name: name), at: 0)
        }
        return items
    }

    @ViewBuilder
    private func readOnlyRow(label: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
            Text(label)
                .font(FaloTypography.caption)
                .foregroundStyle(BonsaiWorldColors.textSecondary)
            Text(value)
                .font(FaloTypography.body)
                .foregroundStyle(BonsaiWorldColors.textPrimary)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(label), \(value)")
    }

    private func save() {
        library.updateTree(
            id: treeID,
            nickname: nickname,
            locationID: locationID,
            soilMixID: soilMixID,
            notes: notes,
            healthStatus: healthStatus
        )
        dismiss()
    }
}

#Preview {
    NavigationStack {
        EditTreeView(treeID: DemoLibrary.sampleTrees[0].id)
    }
    .environment(DemoLibrary.preview)
}
