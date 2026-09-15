//
//  TreeWorkspaceWindowView.swift
//  Bonsai World
//
//  Tree Workspace window (Blueprint §5.2.2 / §5.2.4).
//  Full Bonsai World shell (Sidebar, toolbar, Quick Actions, Tools) dedicated
//  to one Tree — not a second Library / tree browser.
//

import AppKit
import SwiftUI

/// Full-app window whose content area is one Tree (Tree Detail for now).
struct TreeWorkspaceWindowView: View {
    /// Window-local navigation and UI state (selection, edit mode, sheets).
    @State private var appState: AppState
    @Environment(TreeService.self) private var treeService

    let treeID: UUID

    init(treeID: UUID) {
        self.treeID = treeID
        _appState = State(initialValue: AppState.makeTreeWorkspace(treeID: treeID))
    }

    private var windowTitle: String {
        if let tree = treeService.getTree(id: treeID) {
            return TreePresentation.title(for: tree)
        }
        return "Tree Workspace"
    }

    var body: some View {
        ContentView()
            .environment(appState)
            .frame(minWidth: 1000, minHeight: 640)
            .background(WindowTitleSync(title: windowTitle))
    }
}

/// Keeps the macOS window title bar in sync with the focused Tree name.
private struct WindowTitleSync: NSViewRepresentable {
    let title: String

    func makeNSView(context: Context) -> NSView {
        let view = NSView()
        applyTitle(to: view)
        return view
    }

    func updateNSView(_ nsView: NSView, context: Context) {
        applyTitle(to: nsView)
    }

    private func applyTitle(to view: NSView) {
        DispatchQueue.main.async {
            view.window?.title = title
        }
    }
}
