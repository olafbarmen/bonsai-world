//
//  ImageObjectAttachment.swift
//  Bonsai World
//
//  The library object an image is attached to — Tree, Pot, Soil stock, Inventory stock.
//  Related Images are scoped strictly to this attachment (Blueprint §5.5).
//

import Foundation

/// Kind of object an image may belong to.
enum ImageObjectKind: String, Hashable, Sendable, Codable {
    case tree
    case pot
    case soil
    case wire
    case tool
    case chemical
    case consumable
    case fertilizer

    var displayName: String {
        switch self {
        case .tree: "Tree"
        case .pot: "Pot"
        case .soil: "Soil"
        case .wire: "Wire"
        case .tool: "Tool"
        case .chemical: "Chemical"
        case .consumable: "Consumable"
        case .fertilizer: "Fertilizer"
        }
    }

    init?(inventoryKind: InventoryStockKind) {
        switch inventoryKind {
        case .wire: self = .wire
        case .tool: self = .tool
        case .chemical: self = .chemical
        case .consumable: self = .consumable
        case .fertilizer: self = .fertilizer
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
        return libraryObjectAttachment
    }

    var hasObjectAttachment: Bool {
        objectAttachment != nil
    }
}
