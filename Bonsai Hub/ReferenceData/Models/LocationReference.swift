//
//  LocationReference.swift
//  Bonsai World
//
//  Habitat domain (working name) — Locations are Habitat places within a Garden.
//  Reference Data — Growing → Locations.
//  Domain terminology: ``WorkingDomainID/habitat`` / ``WorkingDomainCatalog``.
//
//  Every Location belongs to one Garden and owns Latitude / Longitude.
//  Environmental profile is owned here for Growing Intelligence (SSOT).
//  Trees reference Locations — Trees never store coordinates.
//  Collections never own Location or Garden geography.
//

import Foundation

/// A physical place in the collection. Owned by Reference Data; scoped to a Garden.
struct LocationReference: Identifiable, Codable, Hashable, Sendable {
    var id: UUID
    var name: String
    /// User Profile Garden that owns this Location.
    var gardenID: UUID
    /// Reference Data — Location Type (required).
    var locationTypeID: UUID
    var locationDescription: String
    var notes: String
    var sortOrder: Int
    var isActive: Bool
    /// Map position owned by this Location (Single Source of Truth for Location geography).
    var geographicPosition: GeographicPosition?
    /// Environmental attributes for Growing Intelligence. Owned by this Location.
    var environment: LocationEnvironmentProfile

    init(
        id: UUID = UUID(),
        name: String,
        gardenID: UUID,
        locationTypeID: UUID,
        locationDescription: String = "",
        notes: String = "",
        sortOrder: Int,
        isActive: Bool = true,
        geographicPosition: GeographicPosition? = nil,
        environment: LocationEnvironmentProfile = .unset
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
        self.environment = environment
    }

    var hasGeographicPosition: Bool {
        geographicPosition != nil
    }

    /// Location latitude — Single Source of Truth via ``geographicPosition``.
    var latitude: Double? { geographicPosition?.latitude }

    /// Location longitude — Single Source of Truth via ``geographicPosition``.
    var longitude: Double? { geographicPosition?.longitude }

    // MARK: - Codable (backward compatible before environment profile)

    private enum CodingKeys: String, CodingKey {
        case id, name, gardenID, locationTypeID, locationDescription, notes
        case sortOrder, isActive, geographicPosition, environment
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
        environment = try container.decodeIfPresent(LocationEnvironmentProfile.self, forKey: .environment) ?? .unset
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
        try container.encode(environment, forKey: .environment)
    }

    static func mapRecords(_ items: [LocationReference]) -> [ReferenceDataRecord] {
        items
            .map {
                ReferenceDataRecord(
                    id: $0.id,
                    name: $0.name,
                    sortOrder: $0.sortOrder,
                    isActive: $0.isActive
                )
            }
            .sorted {
                if $0.sortOrder != $1.sortOrder { return $0.sortOrder < $1.sortOrder }
                return $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending
            }
    }

    static func setActive(_ id: UUID, isActive: Bool, in array: inout [LocationReference]) {
        guard let index = array.firstIndex(where: { $0.id == id }) else { return }
        array[index].isActive = isActive
    }

    static func delete(_ id: UUID, from array: inout [LocationReference]) {
        array.removeAll { $0.id == id }
    }
}

/// Editor draft for Add / Edit Location (Quick Action + Reference Data).
struct LocationReferenceDraft: Identifiable, Hashable, Sendable {
    var id: UUID
    var entityID: UUID?
    var name: String
    var gardenID: UUID?
    var locationTypeID: UUID?
    var locationDescription: String
    var notes: String
    var sortOrder: Int
    var isActive: Bool
    var geographicPosition: GeographicPosition?
    var environment: LocationEnvironmentProfile

    var isNew: Bool { entityID == nil }

    static func blank(sortOrder: Int, gardenID: UUID?) -> LocationReferenceDraft {
        LocationReferenceDraft(
            id: UUID(),
            entityID: nil,
            name: "",
            gardenID: gardenID,
            locationTypeID: nil,
            locationDescription: "",
            notes: "",
            sortOrder: sortOrder,
            isActive: true,
            geographicPosition: nil,
            environment: .unset
        )
    }

    static func from(_ location: LocationReference) -> LocationReferenceDraft {
        LocationReferenceDraft(
            id: UUID(),
            entityID: location.id,
            name: location.name,
            gardenID: location.gardenID,
            locationTypeID: location.locationTypeID,
            locationDescription: location.locationDescription,
            notes: location.notes,
            sortOrder: location.sortOrder,
            isActive: location.isActive,
            geographicPosition: location.geographicPosition,
            environment: location.environment
        )
    }
}
