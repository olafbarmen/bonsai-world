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
            // Must not intercept clicks — a full-bleed NSView background steals
            // traffic lights (red / yellow / green) and the sidebar toggle.
            .background(WindowTitleSync(title: windowTitle).allowsHitTesting(false))
    }
}

/// Keeps the macOS window title bar in sync with the focused Tree name.
private struct WindowTitleSync: NSViewRepresentable {
    let title: String

    func makeNSView(context: Context) -> NSView {
        let view = TitleSyncPassthroughView()
        applyTitle(to: view)
        return view
    }

    func updateNSView(_ nsView: NSView, context: Context) {
        applyTitle(to: nsView)
    }

    private func applyTitle(to view: NSView) {
        DispatchQueue.main.async {
            guard let window = view.window, window.title != title else { return }
            window.title = title
        }
    }
}

/// NSView that never claims mouse hits (so window chrome stays clickable).
private final class TitleSyncPassthroughView: NSView {
    override func hitTest(_ point: NSPoint) -> NSView? { nil }
}
