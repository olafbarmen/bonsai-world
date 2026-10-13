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
    var region: String
    var hardinessZone: String
    var elevationMeters: Double?
    var latitude: Double?
    var longitude: Double?
    var isActive: Bool
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
}
