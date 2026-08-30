//
//  CollectionMembershipSheet.swift
//  Bonsai World
//
//  Toggle Collection membership against an Edit Mode draft set.
//  Applied to TreeService only when Tree Detail Saves.
//

import SwiftUI

struct CollectionMembershipSheet: View {
    @Environment(TreeService.self) private var treeService
    @Environment(\.dismiss) private var dismiss

    @Binding var memberIDs: Set<UUID>
    @State private var isNewCollectionPresented = false

    var body: some View {
        NavigationStack {
            List {
                ForEach(treeService.manualCollections) { collection in
                    Button {
                        toggle(collection.id)
                    } label: {
                        HStack(alignment: .top, spacing: FaloSpacing.medium) {
                            CollectionListRow(
                                name: collection.name,
                                description: collection.description,
                                treeCount: collection.treeIDs.count,
                                systemImage: collection.icon ?? "square.stack.3d.up"
                            )

                            if memberIDs.contains(collection.id) {
                                Image(systemName: "checkmark")
                                    .font(.body.weight(.semibold))
                                    .foregroundStyle(.tint)
                                    .accessibilityLabel("Member")
                            }
                        }
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                }

                Section {
                    Button {
                        isNewCollectionPresented = true
                    } label: {
                        Label("+ New Collection…", systemImage: "plus")
                    }
                }
            }
            .faloScrollSurface()
            .navigationTitle("Add to Collection")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                    .keyboardShortcut(.defaultAction)
                }
            }
            .sheet(isPresented: $isNewCollectionPresented) {
                CollectionEditorView(onCreated: { collectionID in
                    memberIDs.insert(collectionID)
                    isNewCollectionPresented = false
                })
            }
        }
        .frame(minWidth: 420, minHeight: 480)
    }

    private func toggle(_ collectionID: UUID) {
        if memberIDs.contains(collectionID) {
            memberIDs.remove(collectionID)
        } else {
            memberIDs.insert(collectionID)
        }
    }
}

#Preview {
    let previewData = PreviewData()
    let treeService = TreeService.preview(previewData: previewData)
    return CollectionMembershipSheet(
        memberIDs: .constant(
            Set(
                previewData.collections
                    .filter { $0.treeIDs.contains(previewData.trees[0].id) }
                    .map(\.id)
            )
        )
    )
    .environment(AppState())
    .environment(treeService)
}
