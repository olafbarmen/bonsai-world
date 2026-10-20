//
//  CollectionMigrationService.swift
//  Bonsai World
//
//  One-time first library: system Smart Collections only.
//  Manual collections from the development catalog are not copied.
//

import Foundation

/// First-run system Smart Collections for a new library package.
@MainActor
enum CollectionMigrationService {

    enum Result: Sendable, Equatable {
        /// No active library — migration deferred.
        case skippedLibraryNotReady
        /// `Database/Collections.json` already present.
        case notRequired
        /// Empty catalog written and verified.
        case migrated(collectionCount: Int)
        /// Write or verification failed; catalog file rolled back when needed.
        case failed
    }

    /// Writes system Smart Collections when the catalog is absent.
    /// Manual collections from the development catalog are not copied.
    static func migrateIfNeeded(
        storage: StorageService,
        libraryReady: Bool,
        libraryRepository: LibraryCollectionRepository
    ) -> Result {
        guard libraryReady else {
            return .skippedLibraryNotReady
        }

        guard !persistentCatalogExists(in: storage) else {
            return .notRequired
        }

        // System lists only. Manual names from the development catalog stay out of a new library.
        let sourceCollections = SystemSmartCollections.makeCollections()
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
