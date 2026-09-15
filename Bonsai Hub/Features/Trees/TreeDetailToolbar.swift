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
    /// Create → Bonsai Name when set, otherwise "Add Tree"; Edit → Bonsai Name.
    func treeEditorTitle(bonsaiName: String) -> String {
        let trimmed = bonsaiName.trimmingCharacters(in: .whitespacesAndNewlines)
        switch self {
        case .create:
            return trimmed.isEmpty ? "Add Tree" : trimmed
        case .edit:
            return trimmed.isEmpty ? "Tree" : trimmed
        }
    }
}
