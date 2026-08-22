//
//  PotType.swift
//  Bonsai World
//
//  Reference Data — Lists worksheet section "Pots".
//

import Foundation

struct PotType: ReferenceListItem {
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
