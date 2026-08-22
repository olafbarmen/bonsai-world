//
//  TreePhotoIndex.swift
//  Bonsai World
//
//  Persists Tree ↔ photo membership until full Tree database persistence lands.
//

import Foundation

struct TreePhotoBinding: Codable, Hashable, Sendable {
    var treeID: UUID
    var primaryImageID: UUID?
    var imageIDs: [UUID]
}

struct TreePhotoIndex: Codable, Hashable, Sendable {
    var bindings: [TreePhotoBinding]

    init(bindings: [TreePhotoBinding] = []) {
        self.bindings = bindings
    }

    func binding(for treeID: UUID) -> TreePhotoBinding? {
        bindings.first { $0.treeID == treeID }
    }

    mutating func upsert(_ binding: TreePhotoBinding) {
        if let index = bindings.firstIndex(where: { $0.treeID == binding.treeID }) {
            bindings[index] = binding
        } else {
            bindings.append(binding)
        }
    }
}
