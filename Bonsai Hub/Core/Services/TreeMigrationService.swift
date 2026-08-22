//
//  TreeMigrationService.swift
//  Bonsai World
//
//  One-time migration from PreviewTreeRepository seed catalog to
//  Database/Trees.json. Orchestration only — persistence stays in
//  LibraryTreeRepository.
//

import Foundation

/// First-run migration of preview seed trees into the library package.
@MainActor
enum TreeMigrationService {

    enum Result: Sendable, Equatable {
        /// No active library — migration deferred.
        case skippedLibraryNotReady
        /// `Database/Trees.json` already present.
        case notRequired
        /// Preview catalog copied to disk and verified.
        case migrated(treeCount: Int)
        /// Write or verification failed; catalog file rolled back when needed.
        case failed
    }

    /// Migrates preview trees when the persisted catalog is absent.
    static func migrateIfNeeded(
        storage: StorageService,
        libraryReady: Bool,
        previewRepository: PreviewTreeRepository,
        libraryRepository: LibraryTreeRepository,
        bonsaiNameSequences: BonsaiNameSequenceStore
    ) -> Result {
        guard libraryReady else {
            return .skippedLibraryNotReady
        }

        guard !persistentCatalogExists(in: storage) else {
            return .notRequired
        }

        let sourceTrees = previewRepository.getAllTrees()
        let expectedIDs = Set(sourceTrees.map(\.id))

        do {
            try libraryRepository.replaceCatalog(with: sourceTrees)
        } catch {
            return .failed
        }

        guard verifyPersistedCatalog(
            in: storage,
            libraryRepository: libraryRepository,
            expectedCount: sourceTrees.count,
            expectedIDs: expectedIDs
        ) else {
            try? libraryRepository.discardPersistedCatalog()
            return .failed
        }

        bonsaiNameSequences.reconcile(with: sourceTrees)
        return .migrated(treeCount: sourceTrees.count)
    }

    /// Whether `Database/Trees.json` exists in the active library.
    static func persistentCatalogExists(in storage: StorageService) -> Bool {
        do {
            return try storage.loadPackageFile(relativePath: LibraryPackageLayout.treesFileName) != nil
        } catch {
            return false
        }
    }

    // MARK: - Private

    private static func verifyPersistedCatalog(
        in storage: StorageService,
        libraryRepository: LibraryTreeRepository,
        expectedCount: Int,
        expectedIDs: Set<UUID>
    ) -> Bool {
        guard persistentCatalogExists(in: storage) else {
            return false
        }

        let loaded = libraryRepository.getAllTrees()
        guard loaded.count == expectedCount else {
            return false
        }

        return Set(loaded.map(\.id)) == expectedIDs
    }
}
