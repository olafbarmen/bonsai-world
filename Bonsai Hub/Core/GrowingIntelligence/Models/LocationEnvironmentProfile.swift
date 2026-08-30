//
//  LocationEnvironmentProfile.swift
//  Bonsai World
//
//  Habitat domain — environmental attributes owned by a Location (SSOT).
//  Growing Intelligence consumes these values — it never duplicates them.
//  Domain terminology: ``WorkingDomainID/habitat``.
//  Prepared for watering / fertilizer / placement / winter engines.
//

import Foundation

// MARK: - Environment setting

/// Physical enclosure / setting of a Location.
enum LocationEnvironmentSetting: String, Codable, CaseIterable, Identifiable, Hashable, Sendable {
    case indoor
    case outdoor
    case greenhouse
    case coldGreenhouse
    case polytunnel

    var id: Self { self }

    var title: String {
        switch self {
        case .indoor: "Indoor"
        case .outdoor: "Outdoor"
        case .greenhouse: "Greenhouse"
        case .coldGreenhouse: "Cold Greenhouse"
        case .polytunnel: "Polytunnel"
        }
    }
}

// MARK: - Shade

enum LocationShadeLevel: String, Codable, CaseIterable, Identifiable, Hashable, Sendable {
    case fullSun
    case partialShade
    case fullShade

    var id: Self { self }

    var title: String {
        switch self {
        case .fullSun: "Full Sun"
        case .partialShade: "Partial Shade"
        case .fullShade: "Full Shade"
        }
    }
}

// MARK: - Wind

enum LocationWindExposure: String, Codable, CaseIterable, Identifiable, Hashable, Sendable {
    case sheltered
    case moderate
    case exposed

    var id: Self { self }

    var title: String {
        switch self {
        case .sheltered: "Sheltered"
        case .moderate: "Moderate"
        case .exposed: "Exposed"
        }
    }
}

// MARK: - Rain

enum LocationRainExposure: String, Codable, CaseIterable, Identifiable, Hashable, Sendable {
    case fullyExposed
    case partialProtection
    case rainProtected

    var id: Self { self }

    var title: String {
        switch self {
        case .fullyExposed: "Fully Exposed"
        case .partialProtection: "Partial Protection"
        case .rainProtected: "Rain Protected"
        }
    }
}

// MARK: - Humidity

enum LocationHumidityLevel: String, Codable, CaseIterable, Identifiable, Hashable, Sendable {
    case low
    case medium
    case high

    var id: Self { self }

    var title: String {
        switch self {
        case .low: "Low"
        case .medium: "Medium"
        case .high: "High"
        }
    }
}

// MARK: - Air flow

enum LocationAirFlow: String, Codable, CaseIterable, Identifiable, Hashable, Sendable {
    case poor
    case moderate
    case excellent

    var id: Self { self }

    var title: String {
        switch self {
        case .poor: "Poor"
        case .moderate: "Moderate"
        case .excellent: "Excellent"
        }
    }
}

// MARK: - Watering method

/// A Location may have more than one — e.g. drip nozzles AND a sprinkler,
/// used manually when home and automatically while traveling.
enum LocationWateringMethod: String, Codable, CaseIterable, Identifiable, Hashable, Sendable {
    case manual
    case drip
    case soakerHose
    case sprinkler

    var id: Self { self }

    var title: String {
        switch self {
        case .manual: "Manual"
        case .drip: "Drip / Nozzles"
        case .soakerHose: "Soaker Hose"
        case .sprinkler: "Sprinkler"
        }
    }
}

// MARK: - Winter

enum LocationWinterProtection: String, Codable, CaseIterable, Identifiable, Hashable, Sendable {
    case frostFree
    case frostPossible
    case outdoorWinter

    var id: Self { self }

    var title: String {
        switch self {
        case .frostFree: "Frost Free"
        case .frostPossible: "Frost Possible"
        case .outdoorWinter: "Outdoor Winter"
        }
    }
}

// MARK: - Profile (owned by Location)

/// Environmental profile for a Location.
/// Optional fields remain unset until the grower records them.
struct LocationEnvironmentProfile: Hashable, Sendable {
    /// Indoor / Outdoor / Greenhouse / Cold Greenhouse / Polytunnel.
    var setting: LocationEnvironmentSetting?

    // MARK: Sun (time-of-day exposure)

    var morningSun: Bool
    var middaySun: Bool
    var afternoonSun: Bool
    var eveningSun: Bool

    var shadeLevel: LocationShadeLevel?
    var windExposure: LocationWindExposure?
    var rainExposure: LocationRainExposure?
    var humidity: LocationHumidityLevel?
    var airFlow: LocationAirFlow?
    /// A Location may combine methods — e.g. drip + sprinkler installed,
    /// used manually when home and switched to automatic while traveling.
    var wateringMethods: Set<LocationWateringMethod>
    var winterProtection: LocationWinterProtection?

    static let unset = LocationEnvironmentProfile()

    init(
        setting: LocationEnvironmentSetting? = nil,
        morningSun: Bool = false,
        middaySun: Bool = false,
        afternoonSun: Bool = false,
        eveningSun: Bool = false,
        shadeLevel: LocationShadeLevel? = nil,
        windExposure: LocationWindExposure? = nil,
        rainExposure: LocationRainExposure? = nil,
        humidity: LocationHumidityLevel? = nil,
        airFlow: LocationAirFlow? = nil,
        wateringMethods: Set<LocationWateringMethod> = [],
        winterProtection: LocationWinterProtection? = nil
    ) {
        self.setting = setting
        self.morningSun = morningSun
        self.middaySun = middaySun
        self.afternoonSun = afternoonSun
        self.eveningSun = eveningSun
        self.shadeLevel = shadeLevel
        self.windExposure = windExposure
        self.rainExposure = rainExposure
        self.humidity = humidity
        self.airFlow = airFlow
        self.wateringMethods = wateringMethods
        self.winterProtection = winterProtection
    }

    // MARK: - Codable (backward compatible: old single `wateringMethod` -> new `wateringMethods` set)

    private enum CodingKeys: String, CodingKey {
        case setting, morningSun, middaySun, afternoonSun, eveningSun
        case shadeLevel, windExposure, rainExposure, humidity, airFlow
        case wateringMethods
        case wateringMethod // legacy single-value key, pre-multi-select
        case winterProtection
    }
}

extension LocationEnvironmentProfile: Codable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        setting = Self.decodeTolerant(LocationEnvironmentSetting.self, container, .setting)
        morningSun = try container.decodeIfPresent(Bool.self, forKey: .morningSun) ?? false
        middaySun = try container.decodeIfPresent(Bool.self, forKey: .middaySun) ?? false
        afternoonSun = try container.decodeIfPresent(Bool.self, forKey: .afternoonSun) ?? false
        eveningSun = try container.decodeIfPresent(Bool.self, forKey: .eveningSun) ?? false
        shadeLevel = Self.decodeTolerant(LocationShadeLevel.self, container, .shadeLevel)
        windExposure = Self.decodeTolerant(LocationWindExposure.self, container, .windExposure)
        rainExposure = Self.decodeTolerant(LocationRainExposure.self, container, .rainExposure)
        humidity = Self.decodeTolerant(LocationHumidityLevel.self, container, .humidity)
        airFlow = Self.decodeTolerant(LocationAirFlow.self, container, .airFlow)
        winterProtection = Self.decodeTolerant(LocationWinterProtection.self, container, .winterProtection)

        if let methods = (try? container.decodeIfPresent(Set<LocationWateringMethod>.self, forKey: .wateringMethods)) ?? nil {
            wateringMethods = methods
        } else if let legacy: LocationWateringMethod = Self.decodeTolerant(LocationWateringMethod.self, container, .wateringMethod) {
            // Pre-multi-select data. A recognized legacy value (e.g. old "manual")
            // maps directly; an unrecognized/removed one (old "automatic") is
            // dropped rather than thrown, since it can't be mapped to a specific
            // device — the grower re-selects the actual equipment once.
            wateringMethods = [legacy]
        } else {
            wateringMethods = []
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(setting, forKey: .setting)
        try container.encode(morningSun, forKey: .morningSun)
        try container.encode(middaySun, forKey: .middaySun)
        try container.encode(afternoonSun, forKey: .afternoonSun)
        try container.encode(eveningSun, forKey: .eveningSun)
        try container.encodeIfPresent(shadeLevel, forKey: .shadeLevel)
        try container.encodeIfPresent(windExposure, forKey: .windExposure)
        try container.encodeIfPresent(rainExposure, forKey: .rainExposure)
        try container.encodeIfPresent(humidity, forKey: .humidity)
        try container.encodeIfPresent(airFlow, forKey: .airFlow)
        try container.encode(wateringMethods, forKey: .wateringMethods)
        try container.encodeIfPresent(winterProtection, forKey: .winterProtection)
    }

    /// Decodes an optional String-backed enum field without throwing when the raw
    /// value is unknown (removed/renamed case from an older app version). A single
    /// unrecognized field must never fail decoding of an entire Location catalog —
    /// see `LibraryLocationRepository.loadLocationsFromDisk()`, which returns `[]`
    /// for the whole file on any decode error.
    private static func decodeTolerant<T: RawRepresentable>(
        _ type: T.Type,
        _ container: KeyedDecodingContainer<CodingKeys>,
        _ key: CodingKeys
    ) -> T? where T.RawValue == String {
        guard let raw = (try? container.decodeIfPresent(String.self, forKey: key)) ?? nil else { return nil }
        return T(rawValue: raw)
    }
}
