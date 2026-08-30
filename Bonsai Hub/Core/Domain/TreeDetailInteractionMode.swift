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
    /// Add Tree cannot save without a chosen Location.
    case locationRequired
    /// The chosen Location no longer exists in Reference Data.
    case locationNotFound
    /// Add Tree / copy cannot persist without Genus and Species.
    case genusAndSpeciesRequired
    /// Create / copy cannot persist a tree without a Bonsai Name.
    case bonsaiNameRequired
    /// Bonsai Name is unique across In Care and Former Trees. Delete frees it.
    case bonsaiNameAlreadyUsed

    var errorDescription: String? {
        switch self {
        case .botanicalIdentityLocked:
            return "Tree identity (Bonsai Name, Botanical Name, Genus, Species, Cultivar) cannot be changed after a tree is created."
        case .treeIdentityLocked:
            return "Tree ID cannot be changed after a tree is created."
        case .locationRequired:
            return "Choose a location, then try Save again."
        case .locationNotFound:
            return "The selected location is no longer available. Choose another location."
        case .genusAndSpeciesRequired:
            return "Choose a genus and species, then try Save again."
        case .bonsaiNameRequired:
            return "A Bonsai Name could not be generated. The tree needs a genus and species."
        case .bonsaiNameAlreadyUsed:
            return "That Bonsai Name is already used. Choose another name, or delete the mistaken tree first. Sold or former trees keep their names."
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
