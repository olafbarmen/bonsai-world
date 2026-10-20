//
//  Garden.swift
//  Bonsai World
//
//  Physical garden / collection site. iOS copy of Mac `Garden` JSON keys
//  (`Database/Gardens.json`). Shape only — no UI or map.
//

import Foundation

struct Garden: Identifiable, Codable, Hashable, Sendable {
    var id: UUID
    var name: String
    var address: String
    var postalCode: String
    var city: String
    var country: String
    var hemisphere: GardenHemisphere?
    var season: GardenSeason?
    var region: String
    var hardinessZone: String
    var elevationMeters: Double?
    var latitude: Double?
    var longitude: Double?
    var isActive: Bool
    var isDefault: Bool

    var climateSummary: String? {
        GardenClimate.summary(hemisphere: hemisphere, season: season)
    }

    init(
        id: UUID = UUID(),
        name: String,
        address: String = "",
        postalCode: String = "",
        city: String = "",
        country: String = "",
        hemisphere: GardenHemisphere? = nil,
        season: GardenSeason? = nil,
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
        self.hemisphere = hemisphere
        self.season = season
        self.region = region
        self.hardinessZone = hardinessZone
        self.elevationMeters = elevationMeters
        self.latitude = latitude
        self.longitude = longitude
        self.isActive = isActive
        self.isDefault = isDefault
    }

    static var seedCatalog: [Garden] {
        [
            Garden(
                id: CanonicalLocationID.defaultGardenID,
                name: CanonicalLocationID.defaultGardenName,
                isDefault: true
            ),
        ]
    }

    enum CodingKeys: String, CodingKey {
        case id, name, address, postalCode, city, country
        case hemisphere, season
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
        hemisphere = try container.decodeIfPresent(GardenHemisphere.self, forKey: .hemisphere)
        season = try container.decodeIfPresent(GardenSeason.self, forKey: .season)
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
        try container.encodeIfPresent(hemisphere, forKey: .hemisphere)
        try container.encodeIfPresent(season, forKey: .season)
        try container.encode(region, forKey: .region)
        try container.encode(hardinessZone, forKey: .hardinessZone)
        try container.encodeIfPresent(elevationMeters, forKey: .elevationMeters)
        try container.encodeIfPresent(latitude, forKey: .latitude)
        try container.encodeIfPresent(longitude, forKey: .longitude)
        try container.encode(isActive, forKey: .isActive)
        try container.encode(isDefault, forKey: .isDefault)
    }
}
