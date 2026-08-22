//
//  AcquisitionMethod.swift
//  Bonsai World
//
//  Reference Data — how a tree was acquired (method of obtaining ownership).
//

import Foundation

struct AcquisitionMethod: ReferenceListItem {
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
