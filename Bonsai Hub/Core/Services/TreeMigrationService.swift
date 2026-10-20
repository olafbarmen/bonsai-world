//
//  TreeMigrationService.swift
//  Bonsai World
//
//  One-time migration from PreviewTreeRepository seed catalog to
//  Database/Trees.json. Orchestration only — persistence stays in
//  LibraryTreeRepository.
//

import Foundation

/// First-run tree catalog. New libraries start empty.
/// The development seed in OlafDevelopmentTrees.json is never copied in.
@MainActor
enum TreeMigrationService {

    enum Result: Sendable, Equatable {
        /// No active library — migration deferred.
        case skippedLibraryNotReady
        /// `Database/Trees.json` already present.
        case notRequired
        /// Empty catalog written and verified.
        case migrated(treeCount: Int)
        /// Write or verification failed; catalog file rolled back when needed.
        case failed
    }

    /// Writes an empty `Database/Trees.json` when the catalog is absent.
    /// Existing libraries are left as they are.
    static func migrateIfNeeded(
        storage: StorageService,
        libraryReady: Bool,
        libraryRepository: LibraryTreeRepository,
        bonsaiNameSequences: BonsaiNameSequenceStore
    ) -> Result {
        guard libraryReady else {
            return .skippedLibraryNotReady
        }

        guard !persistentCatalogExists(in: storage) else {
            return .notRequired
        }

        do {
            try libraryRepository.replaceCatalog(with: [])
        } catch {
            return .failed
        }

        guard verifyPersistedCatalog(
            in: storage,
            libraryRepository: libraryRepository,
            expectedCount: 0,
            expectedIDs: []
        ) else {
            try? libraryRepository.discardPersistedCatalog()
            return .failed
        }

        bonsaiNameSequences.reconcile(with: [])
        return .migrated(treeCount: 0)
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
