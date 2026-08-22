//
//  StorageAssetID.swift
//  Bonsai World
//
//  Stable identifier for an image or document inside the library.
//  Models store this (or an equivalent relative key) — never absolute paths.
//

import Foundation

/// Opaque asset identity resolved by `StorageProvider`.
struct StorageAssetID: Hashable, Codable, Sendable, Identifiable {
    var id: UUID

    init(_ id: UUID = UUID()) {
        self.id = id
    }
}
