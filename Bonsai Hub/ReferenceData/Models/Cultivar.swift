//
//  Cultivar.swift
//  Bonsai World
//
//  Reference Data — Lists worksheet section "Varieties".
//  `speciesID` links each Cultivar to its Species (Lists hierarchy).
//

import Foundation

struct Cultivar: Identifiable, Codable, Hashable {
    var id: UUID
    var name: String
    /// Parent Species (Lists hierarchy: Cultivars belong to a Species).
    var speciesID: UUID
    var sortOrder: Int
    var isActive: Bool

    init(
        id: UUID = UUID(),
        name: String,
        speciesID: UUID,
        sortOrder: Int,
        isActive: Bool = true
    ) {
        self.id = id
        self.name = name
        self.speciesID = speciesID
        self.sortOrder = sortOrder
        self.isActive = isActive
    }
}
