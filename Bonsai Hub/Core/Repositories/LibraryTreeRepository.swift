//
//  LibraryTreeRepository.swift
//  Bonsai World
//
//  TreeRepository backed by Database/Trees.json in the library package.
//
//  deleteTree is a low-level catalog primitive for accidental / duplicate
//  correction only (Blueprint §4.5). End-of-ownership and end-of-life must
//  preserve the Tree via disposal / lifecycle fields on updateTree — never delete.
//

import Foundation
import Observation

/// On-disk tree catalog envelope for `Database/Trees.json`.
struct LibraryTreesFile: Codable, Hashable, Sendable {
    var trees: [Tree]

    init(trees: [Tree] = []) {
        self.trees = trees
    }
}

/// Errors from library tree catalog persistence.
enum LibraryTreeRepositoryError: Error, LocalizedError, Sendable {
    case encodeFailed
    case writeFailed(String)

    var errorDescription: String? {
        switch self {
        case .encodeFailed:
            return "The tree catalog could not be encoded."
        case .writeFailed(let detail):
            return "The tree catalog could not be saved (\(detail))."
        }
    }
}

/// Library-backed `TreeRepository` implementation.
@Observable
@MainActor
final class LibraryTreeRepository: TreeRepository {
    private let storage: StorageService

    init(storage: StorageService) {
        self.storage = storage
    }

    // MARK: - Reads

    func getAllTrees() -> [Tree] {
        loadTreesFromDisk()
    }

    func getTree(id: UUID) -> Tree? {
        loadTreesFromDisk().first { $0.id == id }
    }

    // MARK: - Writes

    @discardableResult
    func createTree(_ tree: Tree) throws -> Tree {
        var trees = loadTreesFromDisk()
        if trees.contains(where: { $0.id == tree.id }) {
            throw TreeRepositoryError.invalidTree("A tree with this id already exists.")
        }

        var inserted = tree
        if inserted.createdDate == .distantPast {
            inserted.createdDate = .now
        }
        inserted.modifiedDate = .now
        trees.append(inserted)

        do {
            try persistAllTreesToDisk(trees)
        } catch let error as LibraryTreeRepositoryError {
            throw TreeRepositoryError.invalidTree(error.localizedDescription)
        }

        return inserted
    }

    @discardableResult
    func updateTree(_ tree: Tree) throws -> Tree {
        var trees = loadTreesFromDisk()
        guard let index = trees.firstIndex(where: { $0.id == tree.id }) else {
            throw TreeRepositoryError.notFound(tree.id)
        }

        let existing = trees[index]
        var updated = tree
        updated.id = existing.id
        // Permanent registry code — never overwritten from an incoming draft.
        updated.bonsaiName = existing.bonsaiName
        updated.createdDate = existing.createdDate
        updated.modifiedDate = .now
        trees[index] = updated

        do {
            try persistAllTreesToDisk(trees)
        } catch let error as LibraryTreeRepositoryError {
            throw TreeRepositoryError.invalidTree(error.localizedDescription)
        }

        return updated
    }

    /// Physically removes a Tree from the catalog.
    ///
    /// **Product rule (Blueprint §4.5):** call only for accidental registration or
    /// duplicate-record correction (development / invalid data). Sold, gifted, dead,
    /// and lost outcomes must keep the Tree and record disposal via ``updateTree``.
    func deleteTree(id: UUID) throws {
        var trees = loadTreesFromDisk()
        guard trees.contains(where: { $0.id == id }) else {
            throw TreeRepositoryError.notFound(id)
        }

        trees.removeAll { $0.id == id }

        do {
            try persistAllTreesToDisk(trees)
        } catch let error as LibraryTreeRepositoryError {
            throw TreeRepositoryError.invalidTree(error.localizedDescription)
        }
    }

    /// Replaces the entire on-disk catalog in one atomic write.
    func replaceCatalog(with trees: [Tree]) throws {
        try persistAllTreesToDisk(trees)
    }

    /// Removes `Database/Trees.json` when present.
    func discardPersistedCatalog() throws {
        try storage.deletePackageFile(relativePath: LibraryPackageLayout.treesFileName)
    }

    // MARK: - Private

    /// Loads trees from disk. Returns `[]` when the file is missing or unreadable.
    /// Does not create, seed, or modify any file.
    private func loadTreesFromDisk() -> [Tree] {
        do {
            guard let data = try storage.loadPackageFile(
                relativePath: LibraryPackageLayout.treesFileName
            ) else {
                return []
            }
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let file = try decoder.decode(LibraryTreesFile.self, from: data)
            return file.trees
        } catch {
            return []
        }
    }

    /// Encodes and writes the full tree catalog to `Database/Trees.json`.
    ///
    /// Overwrites any existing file. Creates the file (and parent folders) on first call.
    private func persistAllTreesToDisk(_ trees: [Tree]) throws {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        encoder.dateEncodingStrategy = .iso8601

        let file = LibraryTreesFile(trees: trees)
        let data: Data
        do {
            data = try encoder.encode(file)
        } catch {
            throw LibraryTreeRepositoryError.encodeFailed
        }

        do {
            try storage.savePackageFile(
                relativePath: LibraryPackageLayout.treesFileName,
                data: data
            )
        } catch {
            throw LibraryTreeRepositoryError.writeFailed(error.localizedDescription)
        }
    }
}
