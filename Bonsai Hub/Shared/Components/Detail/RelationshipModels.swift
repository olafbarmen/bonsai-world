//
//  RelationshipModels.swift
//  Bonsai World
//
//  Domain-agnostic row models for related-entity lists on Detail pages.
//

import Foundation

/// A related collection (or similar group) shown on a Detail page.
struct RelatedCollectionItem: Identifiable, Hashable, Sendable {
    let id: UUID
    let name: String
    let treeCount: Int
}

/// A related tree (or similar item) shown on a Detail page.
struct RelatedTreeItem: Identifiable, Hashable, Sendable {
    let id: UUID
    let name: String
    let species: String
    let collectionName: String
    var imageID: UUID? = nil
}
