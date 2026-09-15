//
//  GalleryEntry.swift
//  Bonsai World
//
//  One row in the library-wide Gallery grid — image metadata plus Tree context.
//

import Foundation

/// A photo in the Gallery browse surface with resolved Tree / library context.
struct GalleryEntry: Identifiable, Hashable, Sendable {
    var id: UUID { asset.id }

    let asset: ImageAsset
    let treeID: UUID?
    let treeDisplayName: String?
    /// Non-tree owner (Pot, Soil stock, Inventory stock) when the image is not a tree photo.
    let libraryObjectAttachment: ImageObjectAttachment?
    let isPrimary: Bool
    let isFeatured: Bool

    var captureDate: Date { asset.captureDate }
    var photoName: String { asset.photoName }

    var hasTreeContext: Bool {
        treeID != nil && !(treeDisplayName?.isEmpty ?? true)
    }
}
