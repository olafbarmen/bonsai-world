//
//  CollectionMigrationService.swift
//  Bonsai World
//
//  One-time migration from PreviewCollectionRepository seed catalog to
//  Database/Collections.json. Orchestration only — persistence stays in
//  LibraryCollectionRepository.
//

import Foundation

/// First-run migration of preview seed collections into the library package.
@MainActor
enum CollectionMigrationService {

    enum Result: Sendable, Equatable {
        /// No active library — migration deferred.
        case skippedLibraryNotReady
        /// `Database/Collections.json` already present.
        case notRequired
        /// Preview catalog copied to disk and verified.
        case migrated(collectionCount: Int)
        /// Write or verification failed; catalog file rolled back when needed.
        case failed
    }

    /// Migrates preview collections when the persisted catalog is absent.
    static func migrateIfNeeded(
        storage: StorageService,
        libraryReady: Bool,
        previewRepository: PreviewCollectionRepository,
        libraryRepository: LibraryCollectionRepository
    ) -> Result {
        guard libraryReady else {
            return .skippedLibraryNotReady
        }

        guard !persistentCatalogExists(in: storage) else {
            return .notRequired
        }

        let sourceCollections = previewRepository.getAllCollections()
        let expectedIDs = Set(sourceCollections.map(\.id))

        do {
            try libraryRepository.replaceCatalog(with: sourceCollections)
        } catch {
            return .failed
        }

        guard verifyPersistedCatalog(
            in: storage,
            libraryRepository: libraryRepository,
            expectedCount: sourceCollections.count,
            expectedIDs: expectedIDs
        ) else {
            try? libraryRepository.discardPersistedCatalog()
            return .failed
        }

        return .migrated(collectionCount: sourceCollections.count)
    }

    /// Whether `Database/Collections.json` exists in the active library.
    static func persistentCatalogExists(in storage: StorageService) -> Bool {
        do {
            return try storage.loadPackageFile(
                relativePath: LibraryPackageLayout.collectionsFileName
            ) != nil
        } catch {
            return false
        }
    }

    // MARK: - Private

    private static func verifyPersistedCatalog(
        in storage: StorageService,
        libraryRepository: LibraryCollectionRepository,
        expectedCount: Int,
        expectedIDs: Set<UUID>
    ) -> Bool {
        guard persistentCatalogExists(in: storage) else {
            return false
        }

        let loaded = libraryRepository.getAllCollections()
        guard loaded.count == expectedCount else {
            return false
        }

        return Set(loaded.map(\.id)) == expectedIDs
    }
}
