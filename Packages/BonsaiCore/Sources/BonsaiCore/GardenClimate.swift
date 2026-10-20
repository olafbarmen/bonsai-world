//
//  GardenClimate.swift
//  BonsaiCore
//
//  Garden climate for Care Calendar timing.
//  Hemisphere turns the year. Season moves work inside that year.
//  Hardiness (how cold a winter gets) stays a separate Garden field.
//

import Foundation

/// Which way the year runs. The same season name is used on both sides.
enum GardenHemisphere: String, Codable, CaseIterable, Identifiable, Hashable, Sendable {
    case northern
    case southern

    var id: Self { self }

    var title: String {
        switch self {
        case .northern: "Northern"
        case .southern: "Southern"
        }
    }

    /// Latitude below zero is south of the equator. Zero stays northern.
    static func suggested(latitude: Double) -> GardenHemisphere {
        latitude < 0 ? .southern : .northern
    }
}

/// Shape of the growing year. Temperate is the Care Calendar baseline.
enum GardenSeason: String, Codable, CaseIterable, Identifiable, Hashable, Sendable {
    case cold
    case temperate
    case mild
    case subtropical
    case tropical

    var id: Self { self }

    var title: String {
        switch self {
        case .cold: "Cold"
        case .temperate: "Temperate"
        case .mild: "Mild"
        case .subtropical: "Subtropical"
        case .tropical: "Tropical"
        }
    }

    var summary: String {
        switch self {
        case .cold:
            "Short season and a hard winter. Spring work comes later, and winter protection comes earlier."
        case .temperate:
            "The classic outdoor year. Care Calendar is written for this season."
        case .mild:
            "Earlier spring, a longer autumn, and a warmer summer."
        case .subtropical:
            "Growth through most of the year, with a weak winter."
        case .tropical:
            "No winter dormancy."
        }
    }
}

enum GardenClimate {
    static func summary(hemisphere: GardenHemisphere?, season: GardenSeason?) -> String? {
        switch (hemisphere, season) {
        case (nil, nil):
            nil
        case let (hemisphere?, nil):
            hemisphere.title
        case let (nil, season?):
            season.title
        case let (hemisphere?, season?):
            "\(hemisphere.title) · \(season.title)"
        }
    }

    static func settingsFooter(hemisphereFollowsPosition: Bool, season: GardenSeason?) -> String {
        var parts: [String] = []
        if hemisphereFollowsPosition {
            parts.append("Hemisphere follows Garden Position.")
        }
        parts.append("Southern shifts the year by six months.")
        if let season {
            parts.append(season.summary)
        } else {
            parts.append("Temperate is the Care Calendar baseline.")
        }
        return parts.joined(separator: " ")
    }
}
