//
//  NewYamadoriDraft.swift
//  Bonsai World
//
//  Creates one Yamadori trip plus its first Find.
//

import Foundation

struct NewYamadoriDraft: Hashable, Sendable {
    var displayName: String = ""
    var genusID: UUID?
    var speciesID: UUID?
    var cultivarID: UUID?
    var discoveryDate: Date? = .now
    var latitude: Double?
    var longitude: Double?
    var locationDescription: String = ""
    var countryRegion: String = ""
    var permissionNotes: String = ""
    var notes: String = ""
    var siteKey: String = ""
}
