//
//  NewYamadoriDraft.swift
//  Bonsai World
//
//  Creates one Yamadori trip. Finds are added separately (CB1).
//

import Foundation

struct NewYamadoriDraft: Hashable, Sendable {
    var displayName: String = ""
    var discoveryDate: Date? = .now
    var latitude: Double?
    var longitude: Double?
    var locationDescription: String = ""
    var countryRegion: String = ""
    var permissionNotes: String = ""
    var notes: String = ""
    var siteKey: String = ""
}
