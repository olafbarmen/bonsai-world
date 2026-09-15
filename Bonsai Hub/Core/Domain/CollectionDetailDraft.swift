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
    var isCarePolicyCollection: Bool
    var wateringMode: WateringMode
    var autoTimesPerDay: Int
    var heatWatchEnabled: Bool

    static func capture(from collection: Collection) -> CollectionDetailDraft {
        CollectionDetailDraft(
            name: collection.name,
            description: collection.description,
            icon: collection.icon,
            color: collection.color,
            isCarePolicyCollection: collection.isCarePolicyCollection,
            wateringMode: collection.wateringMode,
            autoTimesPerDay: collection.autoTimesPerDay,
            heatWatchEnabled: collection.heatWatchEnabled
        )
    }
}
