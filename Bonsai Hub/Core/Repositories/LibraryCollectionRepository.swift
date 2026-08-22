//
//  LibraryCollectionRepository.swift
//  Bonsai World
//
//  CollectionRepository backed by Database/Collections.json in the library package.
//  Full CRUD for Manual Collections. Smart Collections are not evaluated yet.
//

import Foundation
import Observation

/// On-disk collection catalog envelope for `Database/Collections.json`.
struct LibraryCollectionsFile: Codable, Hashable, Sendable {
    var collections: [Collection]

    init(collections: [Collection] = []) {
        self.collections = collections
    }
}

/// Errors from library collection catalog persistence.
enum LibraryCollectionRepositoryError: Error, LocalizedError, Sendable {
    case encodeFailed
    case writeFailed(String)

    var errorDescription: String? {
        switch self {
        case .encodeFailed:
            return "The collection catalog could not be encoded."
        case .writeFailed(let detail):
            return "The collection catalog could not be saved (\(detail))."
        }
    }
}

/// Library-backed `CollectionRepository` implementation.
@Observable
@MainActor
final class LibraryCollectionRepository: CollectionRepository {
    private let storage: StorageService

    init(storage: StorageService) {
        self.storage = storage
    }

    // MARK: - Reads

    func getAllCollections() -> [Collection] {
        loadCollectionsFromDisk()
    }

    func getCollection(id: UUID) -> Collection? {
        loadCollectionsFromDisk().first { $0.id == id }
    }

    // MARK: - Writes

    @discardableResult
    func createCollection(_ collection: Collection) throws -> Collection {
        var collections = loadCollectionsFromDisk()
        if collections.contains(where: { $0.id == collection.id }) {
            throw CollectionRepositoryError.invalidCollection(
                "A collection with this id already exists."
            )
        }

        collections.append(collection)

        do {
            try persistAllCollectionsToDisk(collections)
        } catch let error as LibraryCollectionRepositoryError {
            throw CollectionRepositoryError.invalidCollection(error.localizedDescription)
        }

        return collection
    }

    @discardableResult
    func updateCollection(_ collection: Collection) throws -> Collection {
        var collections = loadCollectionsFromDisk()
        guard let index = collections.firstIndex(where: { $0.id == collection.id }) else {
            throw CollectionRepositoryError.notFound(collection.id)
        }

        collections[index] = collection

        do {
            try persistAllCollectionsToDisk(collections)
        } catch let error as LibraryCollectionRepositoryError {
            throw CollectionRepositoryError.invalidCollection(error.localizedDescription)
        }

        return collection
    }

    func deleteCollection(id: UUID) throws {
        var collections = loadCollectionsFromDisk()
        guard collections.contains(where: { $0.id == id }) else {
            throw CollectionRepositoryError.notFound(id)
        }

        collections.removeAll { $0.id == id }

        do {
            try persistAllCollectionsToDisk(collections)
        } catch let error as LibraryCollectionRepositoryError {
            throw CollectionRepositoryError.invalidCollection(error.localizedDescription)
        }
    }

    /// Replaces the entire on-disk catalog in one atomic write.
    func replaceCatalog(with collections: [Collection]) throws {
        try persistAllCollectionsToDisk(collections)
    }

    /// Removes `Database/Collections.json` when present.
    func discardPersistedCatalog() throws {
        try storage.deletePackageFile(relativePath: LibraryPackageLayout.collectionsFileName)
    }

    // MARK: - Private

    /// Loads collections from disk. Returns `[]` when the file is missing or unreadable.
    /// Does not create, seed, or modify any file.
    private func loadCollectionsFromDisk() -> [Collection] {
        do {
            guard let data = try storage.loadPackageFile(
                relativePath: LibraryPackageLayout.collectionsFileName
            ) else {
                return []
            }
            let decoder = JSONDecoder()
            let file = try decoder.decode(LibraryCollectionsFile.self, from: data)
            return file.collections
        } catch {
            return []
        }
    }

    /// Encodes and writes the full collection catalog to `Database/Collections.json`.
    ///
    /// Overwrites any existing file. Creates the file (and parent folders) on first call.
    private func persistAllCollectionsToDisk(_ collections: [Collection]) throws {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]

        let file = LibraryCollectionsFile(collections: collections)
        let data: Data
        do {
            data = try encoder.encode(file)
        } catch {
            throw LibraryCollectionRepositoryError.encodeFailed
        }

        do {
            try storage.savePackageFile(
                relativePath: LibraryPackageLayout.collectionsFileName,
                data: data
            )
        } catch {
            throw LibraryCollectionRepositoryError.writeFailed(error.localizedDescription)
        }
    }
}
