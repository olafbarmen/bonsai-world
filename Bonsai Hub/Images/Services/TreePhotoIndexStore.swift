//
//  TreePhotoIndexStore.swift
//  Bonsai World
//
//  Persists Tree photo membership (primary + gallery order) in the library package.
//

import Foundation
import Observation

@Observable
@MainActor
final class TreePhotoIndexStore {
    private(set) var index = TreePhotoIndex()
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
                return
            }
            let decoder = JSONDecoder()
            index = try decoder.decode(TreePhotoIndex.self, from: data)
        } catch {
            index = TreePhotoIndex()
        }
    }

    func binding(for treeID: UUID) -> TreePhotoBinding? {
        index.binding(for: treeID)
    }

    func saveBinding(treeID: UUID, primaryImageID: UUID?, imageIDs: [UUID]) {
        index.upsert(
            TreePhotoBinding(
                treeID: treeID,
                primaryImageID: primaryImageID,
                imageIDs: imageIDs
            )
        )
        persist()
    }

    /// Applies persisted photo membership onto in-memory trees (PreviewData era).
    func apply(to trees: inout [Tree]) {
        for i in trees.indices {
            guard let binding = index.binding(for: trees[i].id) else { continue }
            trees[i].primaryImageID = binding.primaryImageID
            trees[i].imageIDs = binding.imageIDs
        }
    }

    private func persist() {
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
