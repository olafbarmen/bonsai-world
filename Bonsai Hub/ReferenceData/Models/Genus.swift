//
//  Genus.swift
//  Bonsai World
//
//  Reference Data — botanical genus.
//  Derived from the leading word of each Lists "Species" binomial (not invented).
//

import Foundation

struct Genus: Identifiable, Codable, Hashable {
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
