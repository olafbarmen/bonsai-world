//
//  LibraryGardenRepository.swift
//  Bonsai World
//
//  GardenRepository backed by Database/Gardens.json in the library package.
//

import Foundation
import Observation

/// On-disk garden catalog envelope for `Database/Gardens.json`.
struct LibraryGardensFile: Codable, Hashable, Sendable {
    var gardens: [Garden]

    init(gardens: [Garden] = []) {
        self.gardens = gardens
    }
}

/// Errors from library garden catalog persistence.
enum LibraryGardenRepositoryError: Error, LocalizedError, Sendable {
    case encodeFailed
    case writeFailed(String)

    var errorDescription: String? {
        switch self {
        case .encodeFailed:
            return "The garden catalog could not be encoded."
        case .writeFailed(let detail):
            return "The garden catalog could not be saved (\(detail))."
        }
    }
}

/// Library-backed `GardenRepository` implementation.
@Observable
@MainActor
final class LibraryGardenRepository: GardenRepository {
    private let storage: StorageService

    init(storage: StorageService) {
        self.storage = storage
    }

    func getAllGardens() -> [Garden] {
        loadGardensFromDisk()
    }

    func getGarden(id: UUID) -> Garden? {
        loadGardensFromDisk().first { $0.id == id }
    }

    /// Replaces the entire on-disk catalog in one atomic write.
    func replaceCatalog(with gardens: [Garden]) throws {
        try persistAllGardensToDisk(gardens)
    }

    /// Removes `Database/Gardens.json` when present.
    func discardPersistedCatalog() throws {
        try storage.deletePackageFile(relativePath: LibraryPackageLayout.gardensFileName)
    }

    // MARK: - Private

    /// Loads gardens from disk. Returns `[]` when the file is missing or unreadable.
    /// Does not create, seed, or modify any file.
    private func loadGardensFromDisk() -> [Garden] {
        do {
            guard let data = try storage.loadPackageFile(
                relativePath: LibraryPackageLayout.gardensFileName
            ) else {
                return []
            }
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let file = try decoder.decode(LibraryGardensFile.self, from: data)
            return file.gardens
        } catch {
            return []
        }
    }

    /// Encodes and writes the full garden catalog to `Database/Gardens.json`.
    ///
    /// Overwrites any existing file. Creates the file (and parent folders) on first call.
    private func persistAllGardensToDisk(_ gardens: [Garden]) throws {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        encoder.dateEncodingStrategy = .iso8601

        let file = LibraryGardensFile(gardens: gardens)
        let data: Data
        do {
            data = try encoder.encode(file)
        } catch {
            throw LibraryGardenRepositoryError.encodeFailed
        }

        do {
            try storage.savePackageFile(
                relativePath: LibraryPackageLayout.gardensFileName,
                data: data
            )
        } catch {
            throw LibraryGardenRepositoryError.writeFailed(error.localizedDescription)
        }
    }
}
