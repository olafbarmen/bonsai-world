//
//  ImageObjectAttachment.swift
//  Bonsai World
//
//  The library object an image is attached to — Tree, Pot, Tool, or future types.
//  Related Images are scoped strictly to this attachment (Blueprint §5.5).
//

import Foundation

/// Kind of object an image may belong to.
enum ImageObjectKind: String, Hashable, Sendable, Codable {
    case tree
    case pot
    case tool

    var displayName: String {
        switch self {
        case .tree: "Tree"
        case .pot: "Pot"
        case .tool: "Tool"
        }
    }
}

/// Identity of the object an image is attached to.
struct ImageObjectAttachment: Hashable, Sendable {
    let kind: ImageObjectKind
    let objectID: UUID
}

extension GalleryEntry {
    /// Resolved object attachment for this image, if any.
    var objectAttachment: ImageObjectAttachment? {
        if let treeID, hasTreeContext {
            return ImageObjectAttachment(kind: .tree, objectID: treeID)
        }
        // Future: potID, toolID from ImageAsset when Inventory attachment ships.
        return nil
    }

    var hasObjectAttachment: Bool {
        objectAttachment != nil
    }
}
