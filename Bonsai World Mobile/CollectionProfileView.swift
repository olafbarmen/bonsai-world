//
//  CollectionProfileView.swift
//  Bonsai World
//
//  Collection Profile — canonical Collection + canonical Tree rows.
//  Opens the existing TreeProfileView. Manual Collections can edit identity,
//  add or remove existing trees, and delete the collection grouping.
//

import SwiftUI

private enum CollectionSoilMixFilter: Hashable {
    case all
    case none
    case mix(UUID)
}

struct CollectionProfileView: View {
    @Environment(DemoLibrary.self) private var library
    @Environment(\.dismiss) private var dismiss
    let collectionID: UUID

    @State private var isShowingAddTree = false
    @State private var confirmDelete = false
    @State private var soilMixFilter: CollectionSoilMixFilter = .all

    private var collection: Collection? { library.collection(id: collectionID) }

    var body: some View {
        Group {
            if let collection {
                profileList(collection)
            } else {
                ContentUnavailableView("Collection not found", systemImage: "square.stack.3d.up")
            }
        }
    }

    private func profileList(_ collection: Collection) -> some View {
        let members = filteredMembers(library.trees(in: collection))
        let description = collection.description.trimmingCharacters(in: .whitespacesAndNewlines)
        return List {
            Section {
                VStack(alignment: .leading, spacing: FaloSpacing.small) {
                    Text(collection.name)
                        .font(FaloTypography.pageTitle)
                        .foregroundStyle(BonsaiWorldColors.textPrimary)
                    if !description.isEmpty {
                        Text(description)
                            .font(FaloTypography.body)
                            .foregroundStyle(BonsaiWorldColors.textSecondary)
                    }
                    Text(members.count == 1 ? "1 Tree" : "\(members.count) Trees")
                        .font(FaloTypography.caption)
                        .foregroundStyle(BonsaiWorldColors.textTertiary)
                }
                .padding(.vertical, FaloSpacing.small)
                .listRowBackground(BonsaiWorldColors.surface)
            }

            Section {
                Picker("Soil Mix", selection: $soilMixFilter) {
                    Text("All").tag(CollectionSoilMixFilter.all)
                    Text("None").tag(CollectionSoilMixFilter.none)
                    ForEach(library.orderedSoilMixes) { mix in
                        Text(mix.name).tag(CollectionSoilMixFilter.mix(mix.id))
                    }
                }
                .accessibilityLabel("Soil Mix filter")
            } header: {
                Text("Filter")
            }

            Section("Trees") {
                if members.isEmpty {
                    Text(soilMixFilter == .all ? "Empty" : "No trees match this Soil Mix.")
                        .font(FaloTypography.body)
                        .foregroundStyle(BonsaiWorldColors.textSecondary)
                        .listRowBackground(BonsaiWorldColors.surface)
                        .swipeActions(edge: .leading, allowsFullSwipe: true) {
                            if collection.isManual {
                                Button("Add") {
                                    isShowingAddTree = true
                                }
                                .tint(BonsaiWorldColors.accent)
                                .accessibilityLabel("Add Existing Tree")
                            }
                        }
                } else {
                    ForEach(members) { tree in
                        NavigationLink(value: MobileRoute.tree(tree.id)) {
                            collectionTreeRow(tree)
                        }
                        .listRowBackground(BonsaiWorldColors.surface)
                        .swipeActions(edge: .leading, allowsFullSwipe: true) {
                            if collection.isManual {
                                Button("Add") {
                                    isShowingAddTree = true
                                }
                                .tint(BonsaiWorldColors.accent)
                                .accessibilityLabel("Add Existing Tree")
                            }
                        }
                        .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                            if collection.isManual {
                                Button("Remove", role: .destructive) {
                                    library.removeTree(tree.id, from: collection.id)
                                }
                                .accessibilityLabel("Remove from Collection")
                            }
                        }
                    }
                }

                if collection.isManual {
                    Button("Add Existing Tree") {
                        isShowingAddTree = true
                    }
                    .font(FaloTypography.body)
                    .foregroundStyle(BonsaiWorldColors.accent)
                    .frame(maxWidth: .infinity, minHeight: 44, alignment: .leading)
                    .contentShape(Rectangle())
                    .listRowBackground(BonsaiWorldColors.surface)
                    .accessibilityLabel("Add Existing Tree")
                    .accessibilityHint("Add a tree that is already in the library")
                }
            }

            if collection.isManual {
                Section {
                    Button("Delete Collection", role: .destructive) {
                        confirmDelete = true
                    }
                    .font(FaloTypography.body)
                    .frame(maxWidth: .infinity, minHeight: 44, alignment: .leading)
                    .contentShape(Rectangle())
                    .listRowBackground(BonsaiWorldColors.surface)
                    .accessibilityLabel("Delete Collection")
                    .accessibilityHint("Remove this collection grouping. Trees stay in the library.")
                }
            }
        }
        .listStyle(.insetGrouped)
        .scrollContentBackground(.hidden)
        .background(BonsaiWorldColors.canvas)
        .navigationTitle(collection.name)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if collection.isManual {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink(value: MobileRoute.editCollection(collection.id)) {
                        Text("Edit")
                    }
                    .accessibilityLabel("Edit Collection")
                }
            }
        }
        .sheet(isPresented: $isShowingAddTree) {
            CollectionAddTreeView(collectionID: collection.id)
        }
        .confirmationDialog(
            "Delete this collection?",
            isPresented: $confirmDelete,
            titleVisibility: .visible
        ) {
            Button("Delete", role: .destructive) {
                library.deleteCollection(id: collection.id)
                dismiss()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("Trees stay in the library. Only this collection grouping is removed.")
        }
    }

    private func filteredMembers(_ trees: [Tree]) -> [Tree] {
        switch soilMixFilter {
        case .all:
            return trees
        case .none:
            return trees.filter { $0.soilMixID == nil }
        case .mix(let id):
            return trees.filter { $0.soilMixID == id }
        }
    }

    private func collectionTreeRow(_ tree: Tree) -> some View {
        HStack(alignment: .center, spacing: FaloSpacing.medium) {
            MobileTreeImage(tree: tree, style: .list)
            VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
                Text(MobileTreePresentation.title(for: tree))
                    .font(FaloTypography.body)
                    .fontWeight(.semibold)
                    .foregroundStyle(BonsaiWorldColors.textPrimary)
                if !MobileTreePresentation.subtitle(for: tree).isEmpty {
                    Text(MobileTreePresentation.subtitle(for: tree))
                        .font(FaloTypography.caption)
                        .foregroundStyle(BonsaiWorldColors.textSecondary)
                }
                if let mixID = tree.soilMixID,
                   let mixName = library.soilMix(id: mixID)?.name,
                   !mixName.isEmpty
                {
                    Text(mixName)
                        .font(FaloTypography.caption)
                        .foregroundStyle(BonsaiWorldColors.textTertiary)
                }
                Text(tree.healthStatus.title)
                    .font(FaloTypography.caption)
                    .foregroundStyle(BonsaiWorldColors.textTertiary)
            }
        }
        .padding(.vertical, FaloSpacing.xSmall)
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    NavigationStack {
        CollectionProfileView(collectionID: UUID())
    }
    .environment(DemoLibrary.preview)
}
