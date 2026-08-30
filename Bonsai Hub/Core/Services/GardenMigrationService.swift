//
//  GardenMigrationService.swift
//  Bonsai World
//
//  One-time migration from UserDefaultsGardenRepository to Database/Gardens.json.
//  Orchestration only — persistence stays in LibraryGardenRepository.
//

import Foundation

/// First-run migration of UserDefaults gardens into the library package.
@MainActor
enum GardenMigrationService {

    enum Result: Sendable, Equatable {
        /// No active library — migration deferred.
        case skippedLibraryNotReady
        /// `Database/Gardens.json` already present.
        case notRequired
        /// UserDefaults catalog copied to disk and verified.
        case migrated(gardenCount: Int)
        /// Write or verification failed; catalog file rolled back when needed.
        case failed
    }

    /// Migrates UserDefaults gardens when the persisted catalog is absent.
    @discardableResult
    static func migrateIfNeeded(
        storage: StorageService,
        libraryReady: Bool,
        sourceRepository: GardenRepository,
        libraryRepository: LibraryGardenRepository
    ) -> Result {
        guard libraryReady else {
            return .skippedLibraryNotReady
        }

        guard !persistentCatalogExists(in: storage) else {
            return .notRequired
        }

        let sourceGardens = sourceRepository.getAllGardens()
        let expectedIDs = Set(sourceGardens.map(\.id))

        do {
            try libraryRepository.replaceCatalog(with: sourceGardens)
        } catch {
            return .failed
        }

        guard verifyPersistedCatalog(
            in: storage,
            libraryRepository: libraryRepository,
            expectedCount: sourceGardens.count,
            expectedIDs: expectedIDs
        ) else {
            try? libraryRepository.discardPersistedCatalog()
            return .failed
        }

        return .migrated(gardenCount: sourceGardens.count)
    }

    /// Whether `Database/Gardens.json` exists in the active library.
    static func persistentCatalogExists(in storage: StorageService) -> Bool {
        do {
            return try storage.loadPackageFile(relativePath: LibraryPackageLayout.gardensFileName) != nil
        } catch {
            return false
        }
    }

    // MARK: - Private

    private static func verifyPersistedCatalog(
        in storage: StorageService,
        libraryRepository: LibraryGardenRepository,
        expectedCount: Int,
        expectedIDs: Set<UUID>
    ) -> Bool {
        guard persistentCatalogExists(in: storage) else {
            return false
        }

        let loaded = libraryRepository.getAllGardens()
        guard loaded.count == expectedCount else {
            return false
        }

        return Set(loaded.map(\.id)) == expectedIDs
    }
}
