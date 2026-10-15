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
            TreeListView(embedded: true)
                .frame(minHeight: 120, idealHeight: 240)

            treeDetailPane
                .frame(minHeight: 200)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .faloWorkspaceCanvas()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .faloWorkspaceCanvas()
        // Garden Trees: "Trees" sits on the My Trees / Former Trees row (same as
        // "Tree Detail" on Overview / Shaping). Shaping keeps a workspace title.
        .modifier(TreeWorkspaceNavigationTitleModifier(
            title: appState.selectedSection == .shaping ? "Shaping" : nil
        ))
    }

    @ViewBuilder
    private var treeDetailPane: some View {
        if let treeID = appState.selectedTreeID {
            TreeDetailView(mode: .edit(treeID), showsNavigationTitle: false)
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

/// Applies ``bonsaiWorkspaceNavigationTitle`` only when a title is present.
private struct TreeWorkspaceNavigationTitleModifier: ViewModifier {
    let title: String?

    func body(content: Content) -> some View {
        if let title {
            content.bonsaiWorkspaceNavigationTitle(title)
        } else {
            content
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
