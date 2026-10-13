//
//  Location.swift
//  Bonsai World
//
//  Physical place a Tree lives. Canonical shared domain (macOS + iOS).
//  JSON keys match Mac `LocationReference` / `Database/Locations.json`.
//  Shape only — no UI, Garden picker, map, or environment.
//

import Foundation

struct Location: Identifiable, Codable, Hashable, Sendable {
    var id: UUID
    var name: String
    /// User Profile Garden that owns this Location. Stored; not edited on iOS in this sprint.
    var gardenID: UUID
    /// Reference Data — Location Type. Stored; not edited on iOS in this sprint.
    var locationTypeID: UUID
    var locationDescription: String
    var notes: String
    var sortOrder: Int
    var isActive: Bool
    /// Map pin owned by this Location. Trees never store coordinates.
    var geographicPosition: GeographicPosition?

    init(
        id: UUID = UUID(),
        name: String,
        gardenID: UUID,
        locationTypeID: UUID,
        locationDescription: String = "",
        notes: String = "",
        sortOrder: Int,
        isActive: Bool = true,
        geographicPosition: GeographicPosition? = nil
    ) {
        self.id = id
        self.name = name
        self.gardenID = gardenID
        self.locationTypeID = locationTypeID
        self.locationDescription = locationDescription
        self.notes = notes
        self.sortOrder = sortOrder
        self.isActive = isActive
        self.geographicPosition = geographicPosition
    }

    var latitude: Double? { geographicPosition?.latitude }
    var longitude: Double? { geographicPosition?.longitude }

    enum CodingKeys: String, CodingKey {
        case id, name, gardenID, locationTypeID, locationDescription, notes
        case sortOrder, isActive, geographicPosition
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        gardenID = try container.decode(UUID.self, forKey: .gardenID)
        locationTypeID = try container.decode(UUID.self, forKey: .locationTypeID)
        locationDescription = try container.decodeIfPresent(String.self, forKey: .locationDescription) ?? ""
        notes = try container.decodeIfPresent(String.self, forKey: .notes) ?? ""
        sortOrder = try container.decode(Int.self, forKey: .sortOrder)
        isActive = try container.decodeIfPresent(Bool.self, forKey: .isActive) ?? true
        geographicPosition = try container.decodeIfPresent(GeographicPosition.self, forKey: .geographicPosition)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(gardenID, forKey: .gardenID)
        try container.encode(locationTypeID, forKey: .locationTypeID)
        try container.encode(locationDescription, forKey: .locationDescription)
        try container.encode(notes, forKey: .notes)
        try container.encode(sortOrder, forKey: .sortOrder)
        try container.encode(isActive, forKey: .isActive)
        try container.encodeIfPresent(geographicPosition, forKey: .geographicPosition)
    }
}
