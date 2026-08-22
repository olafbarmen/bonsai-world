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

enum LocationWateringMethod: String, Codable, CaseIterable, Identifiable, Hashable, Sendable {
    case manual
    case automatic

    var id: Self { self }

    var title: String {
        switch self {
        case .manual: "Manual"
        case .automatic: "Automatic"
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
struct LocationEnvironmentProfile: Codable, Hashable, Sendable {
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
    var wateringMethod: LocationWateringMethod?
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
        wateringMethod: LocationWateringMethod? = nil,
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
        self.wateringMethod = wateringMethod
        self.winterProtection = winterProtection
    }
}
