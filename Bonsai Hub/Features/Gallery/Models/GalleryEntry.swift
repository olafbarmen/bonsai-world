//
//  GalleryEntry.swift
//  Bonsai World
//
//  One row in the library-wide Gallery grid — image metadata plus Tree context.
//

import Foundation

/// A photo in the Gallery browse surface with resolved Tree context.
struct GalleryEntry: Identifiable, Hashable, Sendable {
    var id: UUID { asset.id }

    let asset: ImageAsset
    let treeID: UUID?
    let treeDisplayName: String?
    let isPrimary: Bool
    let isFeatured: Bool

    var captureDate: Date { asset.captureDate }
    var photoName: String { asset.photoName }

    var hasTreeContext: Bool {
        treeID != nil && !(treeDisplayName?.isEmpty ?? true)
    }
}
