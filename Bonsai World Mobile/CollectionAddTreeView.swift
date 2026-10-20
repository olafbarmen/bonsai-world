//
//  CollectionAddTreeView.swift
//  Bonsai World
//
//  Collection Profile → Add Existing Tree.
//  Picker of Trees that are not yet members. Selecting a Tree adds membership
//  immediately (Collection-owned treeIDs). Collections never create or delete Trees.
//

import SwiftUI

struct CollectionAddTreeView: View {
    @Environment(DemoLibrary.self) private var library
    @Environment(\.dismiss) private var dismiss

    let collectionID: UUID

    private var memberIDs: Set<UUID> {
        Set(library.collection(id: collectionID)?.treeIDs ?? [])
    }

    private var candidateTrees: [Tree] {
        library.myTrees
            .filter { !memberIDs.contains($0.id) }
            .sorted {
                MobileTreePresentation.title(for: $0).localizedStandardCompare(
                    MobileTreePresentation.title(for: $1)
                ) == .orderedAscending
            }
    }

    var body: some View {
        NavigationStack {
            Group {
                if candidateTrees.isEmpty {
                    ContentUnavailableView(
                        "No Trees Available",
                        systemImage: "leaf"
                    )
                } else {
                    List(candidateTrees) { tree in
                        Button {
                            library.addTree(tree.id, to: collectionID)
                        } label: {
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
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                        .listRowBackground(BonsaiWorldColors.surface)
                        .accessibilityHint("Adds this tree to the collection")
                    }
                    .listStyle(.insetGrouped)
                    .scrollContentBackground(.hidden)
                    .background(BonsaiWorldColors.canvas)
                }
            }
            .navigationTitle("Add Existing Tree")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Done") { dismiss() }
                }
            }
            .toolbarBackground(BonsaiWorldColors.canvas, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.light, for: .navigationBar)
        }
    }
}

#Preview {
    CollectionAddTreeView(collectionID: UUID())
        .environment(DemoLibrary.preview)
}
