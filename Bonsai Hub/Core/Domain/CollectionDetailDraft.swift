//
//  CollectionDetailDraft.swift
//  Bonsai World
//
//  Editable Collection metadata snapshot for Detail Edit Mode.
//  Membership stays on Collection Detail outside this draft.
//

import Foundation

struct CollectionDetailDraft: Equatable, Sendable {
    var name: String
    var description: String
    var icon: String?
    var color: String?

    static func capture(from collection: Collection) -> CollectionDetailDraft {
        CollectionDetailDraft(
            name: collection.name,
            description: collection.description,
            icon: collection.icon,
            color: collection.color
        )
    }
}
