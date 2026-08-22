//
//  TreeWorkspaceWindowContext.swift
//  Bonsai World
//
//  Value type for opening a Tree Workspace window (Blueprint §5.2.2).
//  One context = one focused Tree; opening the same treeID focuses that window.
//  The window hosts the full Bonsai World shell with its own AppState.
//

import Foundation

/// Opens a full Bonsai World window focused on Garden → Trees for one Tree.
struct TreeWorkspaceWindowContext: Identifiable, Codable, Hashable, Sendable {
    /// Window identity equals the Tree — one Workspace window per Tree.
    var id: UUID { treeID }
    var treeID: UUID

    init(treeID: UUID) {
        self.treeID = treeID
    }
}

extension TreeWorkspaceWindowContext {
    static let windowID = "tree-workspace"
}
