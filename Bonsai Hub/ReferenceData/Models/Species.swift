//
//  Species.swift
//  Bonsai World
//
//  Reference Data — botanical species from Lists worksheet ("Species" + "Code").
//  `name` is the full binomial as authored in Excel (e.g. "Acer palmatum").
//  `genusID` links each Species to its Genus (first word of the binomial).
//

import Foundation

struct Species: Identifiable, Codable, Hashable {
    var id: UUID
    var name: String
    /// Parent Genus (Lists hierarchy: Species belong to Genus).
    var genusID: UUID
    /// Short code from the Lists "Code" column (e.g. APA).
    var code: String?
    var sortOrder: Int
    var isActive: Bool

    init(
        id: UUID = UUID(),
        name: String,
        genusID: UUID,
        code: String? = nil,
        sortOrder: Int,
        isActive: Bool = true
    ) {
        self.id = id
        self.name = name
        self.genusID = genusID
        self.code = code
        self.sortOrder = sortOrder
        self.isActive = isActive
    }

    /// Species epithet (second word of the binomial), when present.
    var epithet: String {
        let parts = name.split(separator: " ").map(String.init)
        return parts.count >= 2 ? parts[1] : ""
    }
}
