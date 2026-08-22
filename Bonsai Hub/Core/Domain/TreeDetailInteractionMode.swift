//
//  TreeDetailInteractionMode.swift
//  Bonsai World
//
//  View vs Edit presentation for an existing Tree Detail.
//  Platform-independent — UI adapts; rules live in services.
//

import Foundation

/// How Tree Detail presents an existing tree.
enum TreeDetailInteractionMode: String, Hashable, Sendable {
    /// Read-only information display. Default after open.
    case viewing
    /// Editable properties may change. Permanent identity stays locked.
    case editing

    var isEditing: Bool { self == .editing }
}

/// Errors for TreeService business rules.
enum TreeServiceError: Error, LocalizedError, Sendable {
    /// Bonsai Name / Botanical Name / Genus / Species / Cultivar cannot change after create.
    case botanicalIdentityLocked
    /// Tree `id` cannot change after a tree is created.
    case treeIdentityLocked

    var errorDescription: String? {
        switch self {
        case .botanicalIdentityLocked:
            return "Tree identity (Bonsai Name, Botanical Name, Genus, Species, Cultivar) cannot be changed after a tree is created."
        case .treeIdentityLocked:
            return "Tree ID cannot be changed after a tree is created."
        }
    }
}

/// Errors for Collection metadata rules in TreeService.
enum CollectionServiceError: Error, LocalizedError, Sendable {
    case nameRequired

    var errorDescription: String? {
        switch self {
        case .nameRequired:
            return "Collection name is required."
        }
    }
}
