//
//  CollectionAddTreeSheet.swift
//  Bonsai World
//
//  Collection Detail → Add Existing Tree.
//  Picker of Trees that are not yet members. Selecting a Tree adds membership
//  immediately (Collection-owned treeIDs). Collections never create or delete Trees.
//

import SwiftUI

struct CollectionAddTreeSheet: View {
    @Environment(TreeService.self) private var treeService
    @Environment(ImageService.self) private var imageService
    @Environment(\.dismiss) private var dismiss

    let collectionID: UUID
    @State private var errorMessage: String?

    private var collectionName: String {
        treeService.collection(id: collectionID)?.name ?? "Collection"
    }

    /// Trees from the global repository that are not yet members of this collection.
    private var candidateTrees: [Tree] {
        _ = treeService.collections
        return treeService.treesInCare
            .filter { !treeService.isMember(treeID: $0.id, collectionID: collectionID) }
            .sorted {
                TreePresentation.title(for: $0).localizedCaseInsensitiveCompare(
                    TreePresentation.title(for: $1)
                ) == .orderedAscending
            }
    }

    var body: some View {
        NavigationStack {
            Group {
                if candidateTrees.isEmpty {
                    ContentUnavailableView(
                        "No Trees Available",
                        systemImage: "leaf",
                        description: Text("Every tree is already in “\(collectionName)”. Add trees with Context Tools → Add Tree, then add them here.")
                    )
                } else {
                    List(candidateTrees) { tree in
                        Button {
                            addTree(tree.id)
                        } label: {
                            HStack(alignment: .center, spacing: FaloSpacing.medium) {
                                TreeListThumbnail(imageID: tree.listImageID, imageService: imageService)
                                VStack(alignment: .leading, spacing: 2) {
                                    Text(TreePresentation.title(for: tree))
                                        .foregroundStyle(.primary)
                                    Text(tree.botanicalName)
                                        .font(FaloTypography.caption)
                                        .foregroundStyle(.secondary)
                                        .lineLimit(1)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                        .accessibilityHint("Adds this tree to the collection")
                    }
                    .faloScrollSurface()
                }
            }
            .navigationTitle("Add Existing Tree")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") {
                        dismiss()
                    }
                    .keyboardShortcut(.cancelAction)
                }
            }
        }
        .frame(minWidth: 420, minHeight: 420)
        .alert(
            "Couldn't Add Tree",
            isPresented: Binding(
                get: { errorMessage != nil },
                set: { if !$0 { errorMessage = nil } }
            )
        ) {
            Button("OK", role: .cancel) { errorMessage = nil }
        } message: {
            Text(errorMessage ?? "")
        }
    }

    /// Adds membership only — does not create or delete the Tree.
    private func addTree(_ treeID: UUID) {
        do {
            try treeService.addTreesToCollection(treeIDs: [treeID], collectionID: collectionID)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
