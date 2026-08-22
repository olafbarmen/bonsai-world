//
//  WorkingDomainCatalog.swift
//  Bonsai World
//
//  Single place for working domain display names and purpose copy.
//  Rename a domain here — keep ``WorkingDomainID`` stable.
//  Mapped to Architecture Version 2 routes.
//

import Foundation

/// Human-facing definition of a working domain.
///
/// Not persisted. Not a feature module. Architecture terminology only.
struct WorkingDomainDefinition: Identifiable, Hashable, Sendable {
    var id: WorkingDomainID
    /// Working name shown when domain language is used (e.g. "Workshop").
    var workingName: String
    var purpose: String
    var status: WorkingDomainStatus
    /// Future responsibilities (documentation for architects / AI / growers).
    var futureResponsibilities: [String]
    /// Technical navigation routes that contribute to this domain (if any).
    var contributingSections: [AppRoute]
    /// Whether Growing Intelligence may consume this domain as an input source.
    var feedsGrowingIntelligence: Bool
}

/// Catalog of working domains. Edit names here for future renaming.
enum WorkingDomainCatalog {
    static var all: [WorkingDomainDefinition] {
        WorkingDomainID.allCases.map(definition(for:))
    }

    static var introduced: [WorkingDomainDefinition] {
        WorkingDomainID.introduced.map(definition(for:))
    }

    static func definition(for id: WorkingDomainID) -> WorkingDomainDefinition {
        switch id {
        case .workshop:
            WorkingDomainDefinition(
                id: .workshop,
                workingName: "Workshop",
                purpose: "Where practical work is planned and recorded.",
                status: .active,
                futureResponsibilities: [
                    "Wiring",
                    "Pruning",
                    "Repotting",
                    "Root Pruning",
                    "Fertilizing",
                    "Watering",
                    "Winter Preparation",
                    "Winter Wash",
                    "Deadwood Work"
                ],
                contributingSections: [.workshopWork, .workshopCalendar, .workshopTasks],
                feedsGrowingIntelligence: true
            )

        case .habitat:
            WorkingDomainDefinition(
                id: .habitat,
                workingName: "Habitat",
                purpose: "Everything describing the environment where a tree grows.",
                status: .active,
                futureResponsibilities: [
                    "Gardens",
                    "Locations",
                    "Sun",
                    "Shade",
                    "Wind",
                    "Rain",
                    "Humidity",
                    "Air Flow",
                    "Irrigation",
                    "Winter Protection",
                    "Microclimate"
                ],
                contributingSections: [.locationsGardens, .locationsPlaces, .locationsMap],
                feedsGrowingIntelligence: true
            )

        case .nursery:
            WorkingDomainDefinition(
                id: .nursery,
                workingName: "Nursery",
                purpose: "Everything related to creating and developing trees.",
                status: .active,
                futureResponsibilities: [
                    "Seeds",
                    "Germination",
                    "Cuttings",
                    "Air Layers",
                    "Grafting",
                    "Yamadori",
                    "Young Trees",
                    "Development",
                    "Trunk Building",
                    "Ramification",
                    "Refinement",
                    "Exhibition Preparation"
                ],
                contributingSections: [
                    .nurserySeeds, .nurseryCuttings, .nurseryAirLayers,
                    .nurseryGrafting, .nurseryYamadori, .nurseryDevelopment
                ],
                feedsGrowingIntelligence: true
            )

        case .growingIntelligence:
            WorkingDomainDefinition(
                id: .growingIntelligence,
                workingName: "Growing Intelligence",
                purpose: "The central knowledge and recommendation system. Rule-based — not AI. Future AI builds upon it.",
                status: .active,
                futureResponsibilities: [
                    "Watering recommendations",
                    "Fertilizing recommendations",
                    "Placement recommendations",
                    "Recovery recommendations",
                    "Seasonal care",
                    "Winter care"
                ],
                contributingSections: AppRoute.routes(in: .care),
                feedsGrowingIntelligence: false
            )

        case .gallery:
            WorkingDomainDefinition(
                id: .gallery,
                workingName: "Gallery",
                purpose: "Visual memory of the collection.",
                status: .reserved,
                futureResponsibilities: [],
                contributingSections: [.gardenGallery],
                feedsGrowingIntelligence: false
            )

        case .journal:
            WorkingDomainDefinition(
                id: .journal,
                workingName: "Journal",
                purpose: "Written history and observations.",
                status: .reserved,
                futureResponsibilities: [],
                contributingSections: [],
                feedsGrowingIntelligence: false
            )

        case .learning:
            WorkingDomainDefinition(
                id: .learning,
                workingName: "Learning",
                purpose: "Knowledge and practice for the grower.",
                status: .reserved,
                futureResponsibilities: AppRoute.routes(in: .knowledge).map(\.title),
                contributingSections: AppRoute.routes(in: .knowledge),
                feedsGrowingIntelligence: false
            )

        case .marketplace:
            WorkingDomainDefinition(
                id: .marketplace,
                workingName: "Marketplace",
                purpose: "Exchange and discovery beyond the garden.",
                status: .reserved,
                futureResponsibilities: [],
                contributingSections: [],
                feedsGrowingIntelligence: false
            )
        }
    }

    /// Working name for a domain ID (rename-friendly entry point).
    static func workingName(for id: WorkingDomainID) -> String {
        definition(for: id).workingName
    }

    /// Domain that a navigation route contributes to, if any.
    static func domain(for section: AppRoute) -> WorkingDomainID? {
        all.first { $0.contributingSections.contains(section) }?.id
    }
}

extension AppRoute {
    /// Working domain this route contributes to (terminology only — does not change UI titles).
    var workingDomainID: WorkingDomainID? {
        WorkingDomainCatalog.domain(for: self)
    }
}
