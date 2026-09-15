//
//  TreePhotoIndex.swift
//  Bonsai World
//
//  Derived cache of Tree ↔ photo membership. Tree fields are the source of truth.
//

import Foundation

struct TreePhotoBinding: Codable, Hashable, Sendable {
    var treeID: UUID
    var primaryImageID: UUID?
    var imageIDs: [UUID]
}

struct TreePhotoIndex: Codable, Hashable, Sendable {
    var bindings: [TreePhotoBinding]
    /// When true, Tree is SSOT and the index must never fill Trees again.
    /// Legacy libraries start false so empty Trees can import from the index once.
    var treeIsPhotoSourceOfTruth: Bool

    init(bindings: [TreePhotoBinding] = [], treeIsPhotoSourceOfTruth: Bool = false) {
        self.bindings = bindings
        self.treeIsPhotoSourceOfTruth = treeIsPhotoSourceOfTruth
    }

    enum CodingKeys: String, CodingKey {
        case bindings
        case treeIsPhotoSourceOfTruth
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        bindings = try container.decodeIfPresent([TreePhotoBinding].self, forKey: .bindings) ?? []
        treeIsPhotoSourceOfTruth = try container.decodeIfPresent(Bool.self, forKey: .treeIsPhotoSourceOfTruth) ?? false
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

    /// Drops the binding for a deleted Tree. Gallery image assets are not affected.
    mutating func removeBinding(treeID: UUID) {
        bindings.removeAll { $0.treeID == treeID }
    }
}
