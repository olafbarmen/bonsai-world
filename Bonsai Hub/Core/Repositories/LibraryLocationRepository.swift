//
//  LibraryLocationRepository.swift
//  Bonsai World
//
//  LocationRepository backed by Database/Locations.json in the library package.
//

import Foundation
import Observation

/// On-disk location catalog envelope for `Database/Locations.json`.
struct LibraryLocationsFile: Codable, Hashable, Sendable {
    var locations: [LocationReference]

    init(locations: [LocationReference] = []) {
        self.locations = locations
    }
}

/// Errors from library location catalog persistence.
enum LibraryLocationRepositoryError: Error, LocalizedError, Sendable {
    case encodeFailed
    case writeFailed(String)

    var errorDescription: String? {
        switch self {
        case .encodeFailed:
            return "The location catalog could not be encoded."
        case .writeFailed(let detail):
            return "The location catalog could not be saved (\(detail))."
        }
    }
}

/// Library-backed `LocationRepository` implementation.
@Observable
@MainActor
final class LibraryLocationRepository: LocationRepository {
    private let storage: StorageService

    init(storage: StorageService) {
        self.storage = storage
    }

    func getAllLocations() -> [LocationReference] {
        loadLocationsFromDisk()
    }

    func getLocation(id: UUID) -> LocationReference? {
        loadLocationsFromDisk().first { $0.id == id }
    }

    /// Replaces the entire on-disk catalog in one atomic write.
    func replaceCatalog(with locations: [LocationReference]) throws {
        try persistAllLocationsToDisk(locations)
    }

    /// Removes `Database/Locations.json` when present.
    func discardPersistedCatalog() throws {
        try storage.deletePackageFile(relativePath: LibraryPackageLayout.locationsFileName)
    }

    // MARK: - Private

    /// Loads locations from disk. Returns `[]` when the file is missing or unreadable.
    /// Does not create, seed, or modify any file.
    private func loadLocationsFromDisk() -> [LocationReference] {
        do {
            guard let data = try storage.loadPackageFile(
                relativePath: LibraryPackageLayout.locationsFileName
            ) else {
                return []
            }
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let file = try decoder.decode(LibraryLocationsFile.self, from: data)
            return file.locations
        } catch {
            return []
        }
    }

    /// Encodes and writes the full location catalog to `Database/Locations.json`.
    ///
    /// Overwrites any existing file. Creates the file (and parent folders) on first call.
    private func persistAllLocationsToDisk(_ locations: [LocationReference]) throws {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        encoder.dateEncodingStrategy = .iso8601

        let file = LibraryLocationsFile(locations: locations)
        let data: Data
        do {
            data = try encoder.encode(file)
        } catch {
            throw LibraryLocationRepositoryError.encodeFailed
        }

        do {
            try storage.savePackageFile(
                relativePath: LibraryPackageLayout.locationsFileName,
                data: data
            )
        } catch {
            throw LibraryLocationRepositoryError.writeFailed(error.localizedDescription)
        }
    }
}
