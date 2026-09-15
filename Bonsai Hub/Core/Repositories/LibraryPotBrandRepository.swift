//
//  LibraryPotBrandRepository.swift
//  Bonsai World
//
//  PotBrandRepository backed by Database/PotBrandsAndMakers.json in the library
//  package. Brand and Maker are persisted together — Makers always belong to a
//  Brand and both are managed on the same Settings screen.
//

import Foundation
import Observation

/// On-disk envelope for `Database/PotBrandsAndMakers.json`.
struct LibraryPotBrandsFile: Codable, Hashable, Sendable {
    /// Curated seed generation. Nil / missing means pre-versioned catalogs.
    var seedVersion: Int?
    var brands: [PotBrand]
    var makers: [PotMaker]

    init(seedVersion: Int? = nil, brands: [PotBrand] = [], makers: [PotMaker] = []) {
        self.seedVersion = seedVersion
        self.brands = brands
        self.makers = makers
    }
}

/// Errors from library pot brand catalog persistence.
enum LibraryPotBrandRepositoryError: Error, LocalizedError, Sendable {
    case encodeFailed
    case writeFailed(String)

    var errorDescription: String? {
        switch self {
        case .encodeFailed:
            return "The pot brand catalog could not be encoded."
        case .writeFailed(let detail):
            return "The pot brand catalog could not be saved (\(detail))."
        }
    }
}

/// Library-backed `PotBrandRepository` implementation.
@Observable
@MainActor
final class LibraryPotBrandRepository: PotBrandRepository {
    private let storage: StorageService

    init(storage: StorageService) {
        self.storage = storage
    }

    func getAllBrands() -> [PotBrand] {
        loadFromDisk().brands
    }

    func getAllMakers() -> [PotMaker] {
        loadFromDisk().makers
    }

    /// Replaces the entire on-disk catalog in one atomic write.
    /// When `seedVersion` is nil, preserves the version already stored on disk.
    func replaceCatalog(brands: [PotBrand], makers: [PotMaker], seedVersion: Int?) throws {
        let version = seedVersion ?? loadFromDisk().seedVersion
        do {
            try persistToDisk(LibraryPotBrandsFile(seedVersion: version, brands: brands, makers: makers))
        } catch let error as LibraryPotBrandRepositoryError {
            throw error
        }
    }

    func getSeedVersion() -> Int? {
        loadFromDisk().seedVersion
    }

    /// Removes `Database/PotBrandsAndMakers.json` when present.
    func discardPersistedCatalog() throws {
        try storage.deletePackageFile(relativePath: LibraryPackageLayout.potBrandsFileName)
    }

    // MARK: - Private

    /// Loads the catalog from disk. Returns an empty catalog when the file is
    /// missing or unreadable. Does not create, seed, or modify any file.
    private func loadFromDisk() -> LibraryPotBrandsFile {
        do {
            guard let data = try storage.loadPackageFile(
                relativePath: LibraryPackageLayout.potBrandsFileName
            ) else {
                return LibraryPotBrandsFile()
            }
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            return try decoder.decode(LibraryPotBrandsFile.self, from: data)
        } catch {
            return LibraryPotBrandsFile()
        }
    }

    /// Encodes and writes the full catalog to `Database/PotBrandsAndMakers.json`.
    ///
    /// Overwrites any existing file. Creates the file (and parent folders) on first call.
    private func persistToDisk(_ file: LibraryPotBrandsFile) throws {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        encoder.dateEncodingStrategy = .iso8601

        let data: Data
        do {
            data = try encoder.encode(file)
        } catch {
            throw LibraryPotBrandRepositoryError.encodeFailed
        }

        do {
            try storage.savePackageFile(
                relativePath: LibraryPackageLayout.potBrandsFileName,
                data: data
            )
        } catch {
            throw LibraryPotBrandRepositoryError.writeFailed(error.localizedDescription)
        }
    }
}
