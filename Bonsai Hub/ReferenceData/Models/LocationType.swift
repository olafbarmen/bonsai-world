//
//  LocationType.swift
//  Bonsai World
//
//  Reference Data — Growing — Location Type vocabulary
//  (Greenhouse, Outdoor, Bench, …). Used by Locations.
//

import Foundation

struct LocationType: ReferenceListItem {
    var id: UUID
    var name: String
    var sortOrder: Int
    var isActive: Bool

    init(id: UUID = UUID(), name: String, sortOrder: Int, isActive: Bool = true) {
        self.id = id
        self.name = name
        self.sortOrder = sortOrder
        self.isActive = isActive
    }
}
