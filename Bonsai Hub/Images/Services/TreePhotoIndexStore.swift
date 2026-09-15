//
//  TreePhotoIndexStore.swift
//  Bonsai World
//
//  Derived mirror of Tree photo membership (primary + gallery order).
//  Tree.primaryImageID / Tree.imageIDs are the source of truth.
//  The index is rebuilt from Trees on every library load. Legacy fill from
//  the index runs at most once, gated by Database/TreePhotoSSOT.json — not by
//  the mirror file itself — so a lost or restored old index cannot overwrite Trees.
//

import Foundation
import Observation

/// Persisted lock: Tree owns photos; never fill Trees from the photo index again.
private struct TreePhotoSSOTState: Codable, Hashable, Sendable {
    var treeIsPhotoSourceOfTruth: Bool
}

@Observable
@MainActor
final class TreePhotoIndexStore {
    private(set) var index = TreePhotoIndex()
    /// Authoritative migration lock (separate file from the mirror).
    private var ssotLocked = false
    private let storage: StorageService

    init(storage: StorageService) {
        self.storage = storage
        reload()
    }

    func reload() {
        do {
            guard let data = try storage.loadPackageFile(
                relativePath: LibraryPackageLayout.treePhotoIndexFileName
            ) else {
                index = TreePhotoIndex()
                loadOrBootstrapSSOTLock(indexFlag: false)
                return
            }
            let decoder = JSONDecoder()
            index = try decoder.decode(TreePhotoIndex.self, from: data)
            loadOrBootstrapSSOTLock(indexFlag: index.treeIsPhotoSourceOfTruth)
        } catch {
            // Corrupt mirror: start empty. Do not clear an existing SSOT lock.
            index = TreePhotoIndex()
            loadOrBootstrapSSOTLock(indexFlag: false)
        }
    }

    var treeIsPhotoSourceOfTruth: Bool {
        ssotLocked
    }

    func binding(for treeID: UUID) -> TreePhotoBinding? {
        index.binding(for: treeID)
    }

    /// Mirrors Tree photo membership into the index (derived cache only).
    func saveBinding(treeID: UUID, primaryImageID: UUID?, imageIDs: [UUID]) {
        index.upsert(
            TreePhotoBinding(
                treeID: treeID,
                primaryImageID: primaryImageID,
                imageIDs: imageIDs
            )
        )
        index.treeIsPhotoSourceOfTruth = ssotLocked
        persistIndex()
    }

    /// Removes photo membership for a deleted Tree. Does not delete gallery assets.
    func removeBinding(treeID: UUID) {
        guard index.binding(for: treeID) != nil else { return }
        index.removeBinding(treeID: treeID)
        index.treeIsPhotoSourceOfTruth = ssotLocked
        persistIndex()
    }

    /// One-time legacy bridge: fills trees that have no photo membership from the index.
    /// Never overwrites a tree that already has photos. No-op once SSOT is locked.
    @discardableResult
    func migrateMissingPhotosIfNeeded(into trees: inout [Tree]) -> [UUID] {
        guard !ssotLocked else { return [] }
        var migrated: [UUID] = []
        for i in trees.indices {
            guard trees[i].primaryImageID == nil, trees[i].imageIDs.isEmpty else { continue }
            guard let binding = index.binding(for: trees[i].id) else { continue }
            let hasIndexPhotos = binding.primaryImageID != nil || !binding.imageIDs.isEmpty
            guard hasIndexPhotos else { continue }
            trees[i].primaryImageID = binding.primaryImageID
            trees[i].imageIDs = binding.imageIDs
            migrated.append(trees[i].id)
        }
        return migrated
    }

    /// Rebuilds the index as a derived mirror of Tree SSOT and locks migration off.
    /// Safe to call on every library open — Tree always wins after this.
    func rebuildFromTreesAsSourceOfTruth(_ trees: [Tree]) {
        ssotLocked = true
        index = TreePhotoIndex(
            bindings: trees.map {
                TreePhotoBinding(
                    treeID: $0.id,
                    primaryImageID: $0.primaryImageID,
                    imageIDs: $0.imageIDs
                )
            },
            treeIsPhotoSourceOfTruth: true
        )
        persistIndex()
        persistSSOTLock()
    }

    // MARK: - Persistence

    /// Prefer the dedicated lock file. If missing, adopt the legacy flag from the
    /// mirror once, then write the lock file so future corrupt mirrors cannot unlock.
    private func loadOrBootstrapSSOTLock(indexFlag: Bool) {
        do {
            if let data = try storage.loadPackageFile(
                relativePath: LibraryPackageLayout.treePhotoSSOTStateFileName
            ) {
                let state = try JSONDecoder().decode(TreePhotoSSOTState.self, from: data)
                ssotLocked = state.treeIsPhotoSourceOfTruth
                return
            }
        } catch {
            // Fall through to bootstrap.
        }
        ssotLocked = indexFlag
        if ssotLocked {
            persistSSOTLock()
        }
    }

    private func persistSSOTLock() {
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
            let data = try encoder.encode(TreePhotoSSOTState(treeIsPhotoSourceOfTruth: ssotLocked))
            try storage.savePackageFile(
                relativePath: LibraryPackageLayout.treePhotoSSOTStateFileName,
                data: data
            )
        } catch {
            // Best-effort.
        }
    }

    private func persistIndex() {
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
            let data = try encoder.encode(index)
            try storage.savePackageFile(
                relativePath: LibraryPackageLayout.treePhotoIndexFileName,
                data: data
            )
        } catch {
            // Best-effort.
        }
    }
}
