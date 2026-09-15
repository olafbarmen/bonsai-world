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
    case referenceImages
    case uncollectedFindings
    case yamadoriTrees
    case pots
    case profilePhoto
    case wire
    case tools
    case chemicals
    case consumables
    case fertilizers
    case soil

    // MARK: - Reserved (enable when filter logic ships)

    case featured
    case byTree
    case byCollection
    case bySpecies
    case byLocation
    case byYamadori
    case unattached
    case beforeAfter

    var id: Self { self }

    /// Whether this filter is active in the menu and GalleryService.
    var isImplemented: Bool {
        switch self {
        case .all, .primary, .latest, .referenceImages, .uncollectedFindings, .yamadoriTrees,
             .pots, .profilePhoto, .wire, .tools, .chemicals, .consumables, .fertilizers, .soil:
            true
        case .featured, .byTree, .byCollection, .bySpecies, .byLocation,
             .byYamadori, .unattached, .beforeAfter:
            false
        }
    }

    var title: String {
        switch self {
        case .all: "All Images"
        case .primary: "Primary Images"
        case .latest: "Latest Images"
        case .referenceImages: "Reference Images"
        case .uncollectedFindings: "Uncollected Findings"
        case .yamadoriTrees: "Yamadori Trees"
        case .pots: "Pots"
        case .profilePhoto: "Profile Photo"
        case .wire: "Wire"
        case .tools: "Tools"
        case .chemicals: "Chemicals"
        case .consumables: "Consumables"
        case .fertilizers: "Fertilizers"
        case .soil: "Soil"
        case .featured: "Featured Images"
        case .byTree: "By Tree"
        case .byCollection: "By Collection"
        case .bySpecies: "By Species"
        case .byLocation: "By Location"
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
        case .referenceImages: "photo.artframe"
        case .uncollectedFindings: "leaf"
        case .yamadoriTrees: "tree"
        case .pots: "shippingbox"
        case .profilePhoto: "person.crop.circle"
        case .wire: "circle.hexagongrid"
        case .tools: "wrench.and.screwdriver"
        case .chemicals: "testtube.2"
        case .consumables: "shippingbox"
        case .fertilizers: "leaf.circle"
        case .soil: "square.stack.3d.up"
        case .featured: "sparkles"
        case .byTree: "leaf"
        case .byCollection: "square.grid.2x2"
        case .bySpecies: "tree"
        case .byLocation: "mappin.and.ellipse"
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
        case .referenceImages: "No Reference Images"
        case .uncollectedFindings: "No Uncollected Finding Images"
        case .yamadoriTrees: "No Yamadori Tree Images"
        case .pots: "No Pot Images"
        case .profilePhoto: "No Profile Photo"
        case .wire: "No Wire Images"
        case .tools: "No Tool Images"
        case .chemicals: "No Chemical Images"
        case .consumables: "No Consumable Images"
        case .fertilizers: "No Fertilizer Images"
        case .soil: "No Soil Images"
        case .featured: "No Featured Images"
        case .byTree: "No Tree Images"
        case .byCollection: "No Collection Images"
        case .bySpecies: "No Species Images"
        case .byLocation: "No Location Images"
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
        case .referenceImages:
            "Images added on Shaping → Vision appear here. They are not tree photos."
        case .uncollectedFindings:
            "Photos on Uncollected Findings appear here."
        case .yamadoriTrees:
            "Photos on Yamadori Trees appear here."
        case .pots:
            "Photos on Inventory → Pots appear here."
        case .profilePhoto:
            "Your profile photo from Settings appears here."
        case .soil:
            "Photos on Inventory → Soil → Stock appear here."
        case .wire:
            "Photos on Inventory → Wire appear here."
        case .tools:
            "Photos on Inventory → Tools appear here."
        case .chemicals:
            "Photos on Inventory → Chemicals appear here."
        case .consumables:
            "Photos on Inventory → Consumables appear here."
        case .fertilizers:
            "Photos on Inventory → Fertilizers appear here."
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
        case .all, .primary, .latest, .referenceImages, .uncollectedFindings, .yamadoriTrees,
             .pots, .profilePhoto, .wire, .tools, .chemicals, .consumables, .fertilizers, .soil:
            true
        case .featured:
            level != .novice
        case .byTree, .byCollection, .bySpecies, .byLocation,
             .byYamadori, .unattached, .beforeAfter:
            false
        }
    }
}
