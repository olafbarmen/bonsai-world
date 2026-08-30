//
//  GalleryBrowseFilter.swift
//  Bonsai World
//
//  Images browse filters under Media → Images (Blueprint §5.5.3, §5.12).
//  Add new cases here; set `isImplemented` when filter logic ships in GalleryService.
//

import Foundation

/// Images filter menu — permanent navigation pattern within Media → Images.
enum GalleryBrowseFilter: String, CaseIterable, Identifiable, Hashable, Sendable {
    // MARK: - Shipped

    case all
    case primary
    case latest

    // MARK: - Reserved (enable when filter logic ships)

    case featured
    case byTree
    case byCollection
    case bySpecies
    case byLocation
    case byPot
    case byTool
    case byYamadori
    case unattached
    case beforeAfter

    var id: Self { self }

    /// Whether this filter is active in the menu and GalleryService.
    var isImplemented: Bool {
        switch self {
        case .all, .primary, .latest:
            true
        case .featured, .byTree, .byCollection, .bySpecies, .byLocation,
             .byPot, .byTool, .byYamadori, .unattached, .beforeAfter:
            false
        }
    }

    var title: String {
        switch self {
        case .all: "All Images"
        case .primary: "Primary Images"
        case .latest: "Latest Images"
        case .featured: "Featured Images"
        case .byTree: "By Tree"
        case .byCollection: "By Collection"
        case .bySpecies: "By Species"
        case .byLocation: "By Location"
        case .byPot: "By Pot"
        case .byTool: "By Tool"
        case .byYamadori: "By Yamadori"
        case .unattached: "Unattached"
        case .beforeAfter: "Before / After"
        }
    }

    var systemImage: String {
        switch self {
        case .all: "photo.on.rectangle.angled"
        case .primary: "star.fill"
        case .latest: "clock"
        case .featured: "sparkles"
        case .byTree: "leaf"
        case .byCollection: "square.grid.2x2"
        case .bySpecies: "tree"
        case .byLocation: "mappin.and.ellipse"
        case .byPot: "cup.and.saucer"
        case .byTool: "wrench.and.screwdriver"
        case .byYamadori: "mountain.2"
        case .unattached: "photo.badge.plus"
        case .beforeAfter: "arrow.left.and.right"
        }
    }

    var emptyTitle: String {
        switch self {
        case .all: "No Images Yet"
        case .primary: "No Primary Images"
        case .latest: "No Recent Images"
        case .featured: "No Featured Images"
        case .byTree: "No Tree Images"
        case .byCollection: "No Collection Images"
        case .bySpecies: "No Species Images"
        case .byLocation: "No Location Images"
        case .byPot: "No Pot Images"
        case .byTool: "No Tool Images"
        case .byYamadori: "No Yamadori Images"
        case .unattached: "No Unattached Images"
        case .beforeAfter: "No Before / After Pairs"
        }
    }

    var emptyDescription: String {
        switch self {
        case .all:
            "Photos you add to trees will appear here — the visual memory of your collection."
        case .primary:
            "Set a Primary photo on a tree to see it in this view."
        case .latest:
            "Recently captured or imported photos will appear here."
        case .featured:
            "Featured photos will appear here when that workflow ships."
        case .byTree:
            "Browse photos grouped by tree."
        case .byCollection:
            "Browse photos from trees in a collection."
        case .bySpecies:
            "Browse photos grouped by species."
        case .byLocation:
            "Browse photos from trees at a location."
        case .byPot:
            "Browse photos linked to inventory pots."
        case .byTool:
            "Browse photos linked to inventory tools."
        case .byYamadori:
            "Browse photos from Yamadori projects."
        case .unattached:
            "Photos not yet linked to a tree will appear here."
        case .beforeAfter:
            "Compare paired photos across time."
        }
    }

    /// Menu entries for the active Experience Level — only implemented filters today.
    static func menuOptions(for level: GalleryExperienceLevel) -> [GalleryBrowseFilter] {
        allCases.filter { $0.isImplemented && $0.isAvailable(at: level) }
    }

    /// Experience Level gating for future filters (e.g. Featured at Experienced+).
    func isAvailable(at level: GalleryExperienceLevel) -> Bool {
        switch self {
        case .all, .primary, .latest:
            true
        case .featured:
            level != .novice
        case .byTree, .byCollection, .bySpecies, .byLocation, .byPot, .byTool,
             .byYamadori, .unattached, .beforeAfter:
            false
        }
    }
}
