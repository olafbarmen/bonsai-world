//
//  TreeDetailToolbar.swift
//  Bonsai World
//
//  Toolbar for Add Tree sheet only (create Cancel / Save).
//  Tree Detail actions live exclusively in Quick Actions.
//

import SwiftUI

/// Toolbar for the Add Tree sheet.
struct TreeDetailToolbar: ToolbarContent {
    var onCancel: () -> Void
    var onSave: () -> Void

    var body: some ToolbarContent {
        ToolbarItem(placement: .cancellationAction) {
            Button("Cancel", action: onCancel)
                .keyboardShortcut(.cancelAction)
        }
        ToolbarItem(placement: .confirmationAction) {
            Button("Save", action: onSave)
                .keyboardShortcut(.defaultAction)
        }
    }
}

extension EditorMode {
    /// Navigation title for the tree editor surface.
    /// Create → Botanical Name when generated, otherwise "Add Tree"; Edit → Botanical Name.
    func treeEditorTitle(botanicalName: String) -> String {
        let trimmed = botanicalName.trimmingCharacters(in: .whitespacesAndNewlines)
        switch self {
        case .create:
            return trimmed.isEmpty ? "Add Tree" : trimmed
        case .edit:
            return trimmed.isEmpty ? "Tree" : trimmed
        }
    }
}
