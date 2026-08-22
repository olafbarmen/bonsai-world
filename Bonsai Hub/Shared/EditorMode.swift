//
//  EditorMode.swift
//  Bonsai Hub
//

import Foundation

/// Shared create/edit presentation mode for entity editors.
enum EditorMode: Hashable, Identifiable {
    case create
    case edit(UUID)

    var id: String {
        switch self {
        case .create:
            "create"
        case .edit(let uuid):
            "edit-\(uuid.uuidString)"
        }
    }

    var editingID: UUID? {
        switch self {
        case .create:
            nil
        case .edit(let uuid):
            uuid
        }
    }

    func title(entityName: String) -> String {
        switch self {
        case .create:
            "New \(entityName)"
        case .edit:
            "Edit \(entityName)"
        }
    }
}
