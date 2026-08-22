//
//  TreeWorkspaceView.swift
//  Bonsai World
//
//  Library Tree Overview — vertical split:
//  top ≈ collection data grid, bottom ≈ embedded Tree Detail.
//  Not used inside a Tree Workspace window (that shows one Tree full-area).
//

import SwiftUI

struct TreeWorkspaceView: View {
    @Environment(AppState.self) private var appState

    var body: some View {
        VSplitView {
            TreeListView()
                .frame(minHeight: 120, idealHeight: 240)

            treeDetailPane
                .frame(minHeight: 200)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.windowBackground)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.windowBackground)
    }

    @ViewBuilder
    private var treeDetailPane: some View {
        if let treeID = appState.selectedTreeID {
            TreeDetailView(mode: .edit(treeID))
        } else {
            ContentUnavailableView(
                "Select a Tree",
                systemImage: "leaf",
                description: Text("Choose a tree in the list above to see its details.")
            )
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

#Preview {
    let preview = PreviewData()
    let treeService = TreeService.preview(previewData: preview)
    return TreeWorkspaceView()
        .environment(AppState())
        .environment(treeService)
        .environment(ReferenceDataService(previewData: ReferencePreviewData()))
        .environment(TreeListColumnConfiguration(visibleColumnIDs: TreeListColumnID.defaultOrder))
        .frame(width: 1000, height: 720)
}
