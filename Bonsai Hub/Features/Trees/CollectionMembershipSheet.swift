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

    var body: some View {
        NavigationStack {
            List(treeService.manualCollections) { collection in
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
    .environment(treeService)
}
