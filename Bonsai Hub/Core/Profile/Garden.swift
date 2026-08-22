//
//  Garden.swift
//  Bonsai World
//
//  Habitat domain (working name) — Garden is the geographic root of Habitat.
//  Technical owners: User Profile Gardens + Location Reference Data.
//  Domain terminology: ``WorkingDomainID/habitat`` / ``WorkingDomainCatalog``.
//
//  Garden owns:
//    - Address (frames the map near the right area)
//    - Garden Position (manually placed — never auto-geocoded)
//    - Map Center (identical to Garden Position — Single Source of Truth)
//    - Climate context for Growing Intelligence (region, hardiness, elevation)
//
//  Trees never store coordinates — they reference Locations, which belong to a Garden.
//

import Foundation

/// A physical garden / collection site owned by the User.
struct Garden: Identifiable, Codable, Hashable, Sendable {
    var id: UUID
    var name: String

    // MARK: Address (map framing only — never becomes Garden Position automatically)

    var address: String
    var postalCode: String
    var city: String
    var country: String

    // MARK: Climate context (Growing Intelligence — owned by Garden)

    /// Free-text region / locality within the country (e.g. county, state).
    var region: String
    /// USDA / local hardiness zone label when known (e.g. "7b").
    var hardinessZone: String
    /// Elevation in metres above sea level. `nil` until recorded.
    var elevationMeters: Double?

    // MARK: Garden Position (manual — master reference for Locations)

    /// Manually selected Garden Position latitude. Never auto-geocoded from Address.
    var latitude: Double?
    /// Manually selected Garden Position longitude. Never auto-geocoded from Address.
    var longitude: Double?

    var isActive: Bool
    /// Only one Garden may be default. Controls map / weather / AI geographic context.
    var isDefault: Bool

    init(
        id: UUID = UUID(),
        name: String,
        address: String = "",
        postalCode: String = "",
        city: String = "",
        country: String = "",
        region: String = "",
        hardinessZone: String = "",
        elevationMeters: Double? = nil,
        latitude: Double? = nil,
        longitude: Double? = nil,
        isActive: Bool = true,
        isDefault: Bool = false
    ) {
        self.id = id
        self.name = name
        self.address = address
        self.postalCode = postalCode
        self.city = city
        self.country = country
        self.region = region
        self.hardinessZone = hardinessZone
        self.elevationMeters = elevationMeters
        self.latitude = latitude
        self.longitude = longitude
        self.isActive = isActive
        self.isDefault = isDefault
    }

    /// Manually selected Garden Position. `nil` until the user places the Garden marker.
    var gardenPosition: GeographicCoordinate? {
        guard let latitude, let longitude else { return nil }
        return GeographicCoordinate(latitude: latitude, longitude: longitude)
    }

    /// Map Center for the Garden map.
    /// Single Source of Truth: identical to ``gardenPosition`` — never a separate stored coordinate.
    var mapCenter: GeographicCoordinate? { gardenPosition }

    /// Alias for map / hierarchy code that reads the Garden marker coordinate.
    var geographicCoordinate: GeographicCoordinate? { gardenPosition }

    var hasGardenPosition: Bool { gardenPosition != nil }

    /// Single-line address for display and one-shot map framing (never written as Position).
    var composedAddress: String {
        [address, postalCode, city, country]
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }
            .joined(separator: ", ")
    }

    mutating func setGardenPosition(_ coordinate: GeographicCoordinate) {
        latitude = coordinate.latitude
        longitude = coordinate.longitude
    }

    mutating func clearGardenPosition() {
        latitude = nil
        longitude = nil
    }

    // MARK: - Codable (backward compatible with gardens saved before climate fields)

    private enum CodingKeys: String, CodingKey {
        case id, name, address, postalCode, city, country
        case region, hardinessZone, elevationMeters
        case latitude, longitude, isActive, isDefault
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        address = try container.decodeIfPresent(String.self, forKey: .address) ?? ""
        postalCode = try container.decodeIfPresent(String.self, forKey: .postalCode) ?? ""
        city = try container.decodeIfPresent(String.self, forKey: .city) ?? ""
        country = try container.decodeIfPresent(String.self, forKey: .country) ?? ""
        region = try container.decodeIfPresent(String.self, forKey: .region) ?? ""
        hardinessZone = try container.decodeIfPresent(String.self, forKey: .hardinessZone) ?? ""
        elevationMeters = try container.decodeIfPresent(Double.self, forKey: .elevationMeters)
        latitude = try container.decodeIfPresent(Double.self, forKey: .latitude)
        longitude = try container.decodeIfPresent(Double.self, forKey: .longitude)
        isActive = try container.decodeIfPresent(Bool.self, forKey: .isActive) ?? true
        isDefault = try container.decodeIfPresent(Bool.self, forKey: .isDefault) ?? false
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(address, forKey: .address)
        try container.encode(postalCode, forKey: .postalCode)
        try container.encode(city, forKey: .city)
        try container.encode(country, forKey: .country)
        try container.encode(region, forKey: .region)
        try container.encode(hardinessZone, forKey: .hardinessZone)
        try container.encodeIfPresent(elevationMeters, forKey: .elevationMeters)
        try container.encodeIfPresent(latitude, forKey: .latitude)
        try container.encodeIfPresent(longitude, forKey: .longitude)
        try container.encode(isActive, forKey: .isActive)
        try container.encode(isDefault, forKey: .isDefault)
    }
}

/// Stable seed id for the preview Default Garden.
enum GardenSeed {
    static let defaultGardenID = UUID(uuidString: "A1B2C3D4-E5F6-7890-ABCD-EF1234567890")!
}
