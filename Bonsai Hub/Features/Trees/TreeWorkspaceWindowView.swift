//
//  TreeWorkspaceWindowView.swift
//  Bonsai World
//
//  Tree Workspace window (Blueprint §5.2.2 / §5.2.4).
//  Full Bonsai World shell (Sidebar, toolbar, Quick Actions, Tools) dedicated
//  to one Tree — not a second Library / tree browser.
//

import SwiftUI

/// Full-app window whose content area is one Tree (Tree Detail for now).
struct TreeWorkspaceWindowView: View {
    /// Window-local navigation and UI state (selection, edit mode, sheets).
    @State private var appState: AppState

    let treeID: UUID

    init(treeID: UUID) {
        self.treeID = treeID
        _appState = State(initialValue: AppState.makeTreeWorkspace(treeID: treeID))
    }

    var body: some View {
        ContentView()
            .environment(appState)
            .frame(minWidth: 1000, minHeight: 640)
    }
}
