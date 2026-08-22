//
//  LightCondition.swift
//  Bonsai World
//
//  Reference Data — light condition.
//  Not present on the Excel Lists worksheet; model reserved, preview list empty.
//

import Foundation

struct LightCondition: ReferenceListItem {
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
