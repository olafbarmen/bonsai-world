//
//  RepositoryProtocols.swift
//  Bonsai World
//
//  Repository contracts for domain access.
//  Features and Views never depend on these directly — use TreeService (and future services).
//  Swap PreviewTreeRepository / PreviewCollectionRepository for library-backed implementations
//  without changing callers.
//

import Foundation

// MARK: - Tree

/// Errors from tree repository operations.
enum TreeRepositoryError: Error, LocalizedError, Sendable {
    case notFound(UUID)
    case invalidTree(String)

    var errorDescription: String? {
        switch self {
        case .notFound(let id):
            return "Tree not found (\(id.uuidString))."
        case .invalidTree(let detail):
            return detail
        }
    }
}

/// Single access point for Tree records behind TreeService.
@MainActor
protocol TreeRepository: AnyObject {
    /// All trees in the current catalog / library session.
    func getAllTrees() -> [Tree]

    /// Tree with the given id, or `nil` when absent.
    func getTree(id: UUID) -> Tree?

    /// Inserts a new tree. Fails if `id` already exists.
    @discardableResult
    func createTree(_ tree: Tree) throws -> Tree

    /// Replaces an existing tree. Fails if `id` is unknown.
    @discardableResult
    func updateTree(_ tree: Tree) throws -> Tree

    /// Removes the tree with the given id. Fails if unknown.
    func deleteTree(id: UUID) throws
}

// MARK: - Collection

/// Errors from collection repository operations.
enum CollectionRepositoryError: Error, LocalizedError, Sendable {
    case notFound(UUID)
    case invalidCollection(String)

    var errorDescription: String? {
        switch self {
        case .notFound(let id):
            return "Collection not found (\(id.uuidString))."
        case .invalidCollection(let detail):
            return detail
        }
    }
}

/// Single access point for Collection records behind TreeService (until CollectionService lands).
@MainActor
protocol CollectionRepository: AnyObject {
    /// All collections in the current catalog / library session.
    func getAllCollections() -> [Collection]

    /// Collection with the given id, or `nil` when absent.
    func getCollection(id: UUID) -> Collection?

    /// Inserts a new collection. Fails if `id` already exists.
    @discardableResult
    func createCollection(_ collection: Collection) throws -> Collection

    /// Replaces an existing collection. Fails if `id` is unknown.
    @discardableResult
    func updateCollection(_ collection: Collection) throws -> Collection

    /// Removes the collection with the given id. Fails if unknown.
    func deleteCollection(id: UUID) throws
}
