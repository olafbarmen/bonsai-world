//
//  LibraryPotRepository.swift
//  Bonsai World
//
//  PotRepository backed by Database/Pots.json in the library package.
//  Full CRUD — Pot records accumulate one entry per registered pot.
//

import Foundation
import Observation

/// On-disk pot catalog envelope for `Database/Pots.json`.
struct LibraryPotsFile: Codable, Hashable, Sendable {
    var pots: [Pot]

    init(pots: [Pot] = []) {
        self.pots = pots
    }
}

/// Errors from library pot catalog persistence.
enum LibraryPotRepositoryError: Error, LocalizedError, Sendable {
    case encodeFailed
    case writeFailed(String)

    var errorDescription: String? {
        switch self {
        case .encodeFailed:
            return "The pot catalog could not be encoded."
        case .writeFailed(let detail):
            return "The pot catalog could not be saved (\(detail))."
        }
    }
}

/// Library-backed `PotRepository` implementation.
@Observable
@MainActor
final class LibraryPotRepository: PotRepository {
    private let storage: StorageService

    init(storage: StorageService) {
        self.storage = storage
    }

    // MARK: - Reads

    func getAllPots() -> [Pot] {
        loadPotsFromDisk()
    }

    func getPot(id: UUID) -> Pot? {
        loadPotsFromDisk().first { $0.id == id }
    }

    // MARK: - Writes

    @discardableResult
    func createPot(_ pot: Pot) throws -> Pot {
        var pots = loadPotsFromDisk()
        if pots.contains(where: { $0.id == pot.id }) {
            throw PotRepositoryError.invalidPot("A pot with this id already exists.")
        }

        pots.append(pot)

        do {
            try persistAllPotsToDisk(pots)
        } catch let error as LibraryPotRepositoryError {
            throw PotRepositoryError.invalidPot(error.localizedDescription)
        }

        return pot
    }

    @discardableResult
    func updatePot(_ pot: Pot) throws -> Pot {
        var pots = loadPotsFromDisk()
        guard let index = pots.firstIndex(where: { $0.id == pot.id }) else {
            throw PotRepositoryError.notFound(pot.id)
        }

        pots[index] = pot

        do {
            try persistAllPotsToDisk(pots)
        } catch let error as LibraryPotRepositoryError {
            throw PotRepositoryError.invalidPot(error.localizedDescription)
        }

        return pot
    }

    func deletePot(id: UUID) throws {
        var pots = loadPotsFromDisk()
        guard pots.contains(where: { $0.id == id }) else {
            throw PotRepositoryError.notFound(id)
        }

        pots.removeAll { $0.id == id }

        do {
            try persistAllPotsToDisk(pots)
        } catch let error as LibraryPotRepositoryError {
            throw PotRepositoryError.invalidPot(error.localizedDescription)
        }
    }

    // MARK: - Private

    /// Loads pots from disk. Returns `[]` when the file is missing or unreadable.
    /// Does not create, seed, or modify any file.
    private func loadPotsFromDisk() -> [Pot] {
        do {
            guard let data = try storage.loadPackageFile(
                relativePath: LibraryPackageLayout.potsFileName
            ) else {
                return []
            }
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let file = try decoder.decode(LibraryPotsFile.self, from: data)
            return file.pots
        } catch {
            return []
        }
    }

    /// Encodes and writes the full pot catalog to `Database/Pots.json`.
    ///
    /// Overwrites any existing file. Creates the file (and parent folders) on first call.
    private func persistAllPotsToDisk(_ pots: [Pot]) throws {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        encoder.dateEncodingStrategy = .iso8601

        let file = LibraryPotsFile(pots: pots)
        let data: Data
        do {
            data = try encoder.encode(file)
        } catch {
            throw LibraryPotRepositoryError.encodeFailed
        }

        do {
            try storage.savePackageFile(
                relativePath: LibraryPackageLayout.potsFileName,
                data: data
            )
        } catch {
            throw LibraryPotRepositoryError.writeFailed(error.localizedDescription)
        }
    }
}
