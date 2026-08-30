//
//  LocationMigrationService.swift
//  Bonsai World
//
//  One-time migration from PreviewLocationRepository seed catalog to
//  Database/Locations.json. Orchestration only — persistence stays in
//  LibraryLocationRepository.
//

import Foundation

/// First-run migration of preview seed locations into the library package.
@MainActor
enum LocationMigrationService {

    enum Result: Sendable, Equatable {
        /// No active library — migration deferred.
        case skippedLibraryNotReady
        /// `Database/Locations.json` already present.
        case notRequired
        /// Preview catalog copied to disk and verified.
        case migrated(locationCount: Int)
        /// Write or verification failed; catalog file rolled back when needed.
        case failed
    }

    /// Migrates preview locations when the persisted catalog is absent.
    @discardableResult
    static func migrateIfNeeded(
        storage: StorageService,
        libraryReady: Bool,
        previewRepository: PreviewLocationRepository,
        libraryRepository: LibraryLocationRepository
    ) -> Result {
        guard libraryReady else {
            return .skippedLibraryNotReady
        }

        guard !persistentCatalogExists(in: storage) else {
            return .notRequired
        }

        let sourceLocations = previewRepository.getAllLocations()
        let expectedIDs = Set(sourceLocations.map(\.id))

        do {
            try libraryRepository.replaceCatalog(with: sourceLocations)
        } catch {
            return .failed
        }

        guard verifyPersistedCatalog(
            in: storage,
            libraryRepository: libraryRepository,
            expectedCount: sourceLocations.count,
            expectedIDs: expectedIDs
        ) else {
            try? libraryRepository.discardPersistedCatalog()
            return .failed
        }

        return .migrated(locationCount: sourceLocations.count)
    }

    /// Whether `Database/Locations.json` exists in the active library.
    static func persistentCatalogExists(in storage: StorageService) -> Bool {
        do {
            return try storage.loadPackageFile(relativePath: LibraryPackageLayout.locationsFileName) != nil
        } catch {
            return false
        }
    }

    // MARK: - Private

    private static func verifyPersistedCatalog(
        in storage: StorageService,
        libraryRepository: LibraryLocationRepository,
        expectedCount: Int,
        expectedIDs: Set<UUID>
    ) -> Bool {
        guard persistentCatalogExists(in: storage) else {
            return false
        }

        let loaded = libraryRepository.getAllLocations()
        guard loaded.count == expectedCount else {
            return false
        }

        return Set(loaded.map(\.id)) == expectedIDs
    }
}
