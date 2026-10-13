//
//  CollectionServiceError.swift
//  Bonsai World
//
//  Errors for Collection metadata and Care-policy membership rules.
//  Collection CRUD still lives on TreeService today — this type is the first
//  step toward a dedicated CollectionService (after Mac test backup/commit).
//

import Foundation

enum CollectionServiceError: Error, LocalizedError, Sendable {
    case nameRequired
    case carePolicyConflict(treeTitle: String, existingCollectionName: String)
    case systemCollectionLocked

    var errorDescription: String? {
        switch self {
        case .nameRequired:
            return "Collection name is required."
        case .carePolicyConflict(let treeTitle, let existingCollectionName):
            return "“\(treeTitle)” already uses Care policy Collection “\(existingCollectionName)”. Remove it from that Collection first, or clear the Care policy on one of them."
        case .systemCollectionLocked:
            return "System Smart Collections cannot be deleted."
        }
    }
}
