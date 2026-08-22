//
//  Chemical.swift
//  Bonsai World
//
//  Reference Data — Inventory Preparation — chemicals catalog (no quantities).
//

import Foundation

struct Chemical: ReferenceListItem {
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
