//
//  AppNavigation.swift
//  Bonsai World
//
//  Workflow navigation — sidebar mirrors how bonsai enthusiasts work (Architecture Version 3).
//  Leaf routes select content; modules group routes in the sidebar.
//

import Foundation

// MARK: - Top-level modules (sidebar order is permanent)

/// Primary workflow modules — exact sidebar order for the Workspace section.
enum AppModule: String, CaseIterable, Identifiable, Hashable, Sendable {
    case dashboard
    case tasks
    case garden
    case shaping
    case care
    case nursery
    case yamadori
    case inventory
    case media
    case knowledge
    case settings

    // Legacy module identities — routes may still reference these; not shown in the sidebar.
    case propagation
    case locations
    case workshop
    case design
    case economy
    case social

    var id: Self { self }

    var title: String {
        switch self {
        case .dashboard: "Dashboard"
        case .tasks: "Tasks"
        case .garden: "Garden"
        case .shaping: "Shaping"
        case .care: "Care"
        case .nursery: "Nursery"
        case .yamadori: "Yamadori"
        case .inventory: "Inventory"
        case .media: "Media"
        case .knowledge: "Knowledge"
        case .settings: "Settings"
        case .propagation: "Propagation"
        case .locations: "Locations"
        case .workshop: "Workshop"
        case .design: "Design"
        case .economy: "Economy"
        case .social: "Social"
        }
    }

    var systemImage: String {
        switch self {
        case .dashboard: "square.grid.2x2"
        case .tasks: "checklist"
        case .garden: "leaf"
        case .shaping: "pencil.and.outline"
        case .care: "drop"
        case .nursery: "leaf.circle"
        case .yamadori: "mountain.2"
        case .inventory: "shippingbox"
        case .media: "photo.on.rectangle.angled"
        case .knowledge: "book"
        case .settings: "gearshape"
        case .propagation: "arrow.triangle.branch"
        case .locations: "mappin.and.ellipse"
        case .workshop: "wrench.and.screwdriver"
        case .design: "pencil.and.outline"
        case .economy: "sterlingsign.circle"
        case .social: "person.2"
        }
    }

    /// Daily workflow modules (Dashboard → Inventory).
    static var primaryWorkspaceModules: [AppModule] {
        [
            .dashboard,
            .tasks,
            .garden,
            .shaping,
            .care,
            .nursery,
            .yamadori,
            .inventory
        ]
    }

    /// Library modules below the workflow group (Media, Knowledge).
    static var libraryWorkspaceModules: [AppModule] {
        [.media, .knowledge]
    }

    /// All modules shown under Workspace in the sidebar (excludes Settings / Tools).
    static var workspaceModules: [AppModule] {
        primaryWorkspaceModules + libraryWorkspaceModules
    }

    /// Settings is pinned below Context Tools (not listed in the scrolling Tools group).
    static var toolsModules: [AppModule] {
        []
    }

    /// Child routes shown under this module in the sidebar (shipped routes only).
    var routes: [AppRoute] {
        AppRoute.routes(in: self)
    }

    /// All defined routes for this module, including future subpages not yet in navigation.
    var allRoutes: [AppRoute] {
        AppRoute.allRoutes(in: self)
    }

    /// Whether the sidebar uses a disclosure group (module header + indented subpages).
    var showsChildNavigation: Bool {
        routes.count > 1
    }

    var defaultRoute: AppRoute {
        routes.first ?? allRoutes.first ?? .dashboard
    }
}

// MARK: - Leaf routes (content selection)

/// Concrete content destinations within workflow modules.
enum AppRoute: String, CaseIterable, Identifiable, Hashable, Sendable {
    // Dashboard
    case dashboard

    // Tasks
    case tasksOverdue
    case tasksToday
    case tasksThisWeek
    case tasksThisMonth
    case tasksThisYear
    case tasksNextYear

    // Garden
    case gardenTrees
    case gardenCollections

    // Media
    case mediaImages
    case mediaDocuments
    case mediaNotes
    case mediaVideo
    case mediaAudio

    // Locations (under Garden in sidebar; legacy module retained for routing)
    case locationsGardens
    case locationsPlaces
    case locationsMap

    // Workshop (legacy — not in sidebar; routes retained)
    case workshopWork
    case workshopCalendar
    case workshopTasks

    // Nursery
    case nurserySeeds
    case nurseryCuttings
    case nurseryAirLayers
    case nurseryGrafting
    case nurseryYamadori
    case nurseryFieldTree

    // Care
    case careToday
    case careWatering
    case careFertilizing
    case careRepotting
    case carePlacement
    case careTreeHealth
    case careSeasonal
    case careWinter
    case careSpring

    // Shaping — sidebar module; same Tree Detail Shaping segment.
    case shaping

    // Shaping subpages (reserved — used inside Tree Detail later)
    case designVision
    case designStyle
    case designFrontSelection
    case designVirtual
    case designBranchPlan
    case designTrunkDevelopment
    case designRamification
    case designApex
    case designDeadwood
    case designTimeline

    // Inventory
    case inventoryPots
    case inventorySoil
    case inventorySoilComponents
    case inventorySoilMixes
    case inventoryFertilizers
    case inventoryWire
    case inventoryTools
    case inventoryChemicals
    case inventoryConsumables
    case inventoryStockReport

    // Knowledge
    case knowledgeQuickGuides
    case knowledgeHandbook
    case knowledgeCareCalendar
    case knowledgePotGuidelines
    case knowledgeSpeciesLibrary
    case knowledgeSoilGuides
    case knowledgeFertilizerGuides
    case knowledgeSeedStratification
    case knowledgeVideos
    case knowledgeCourses
    case knowledgeFAQ
    case knowledgeExternalLinks

    // Economy (legacy — not in sidebar; routes retained)
    case economyPurchases
    case economySales
    case economyExpenses
    case economyIncome
    case economyTreeValue
    case economyPotValue
    case economyInventoryValue
    case economyReports

    // Social (own module — hidden until communication features ship)
    case socialContacts
    case socialLinks
    case socialSharedTrees

    // Settings
    case settings

    var id: Self { self }

    init(tasksHorizon: TasksHorizon) {
        switch tasksHorizon {
        case .overdue: self = .tasksOverdue
        case .today: self = .tasksToday
        case .thisWeek: self = .tasksThisWeek
        case .thisMonth: self = .tasksThisMonth
        case .thisYear: self = .tasksThisYear
        case .nextYear: self = .tasksNextYear
        }
    }

    /// Whether this route is listed in the sidebar today.
    var isShippedInNavigation: Bool {
        switch self {
        case .mediaImages, .mediaVideo, .mediaDocuments:
            true
        case .mediaNotes, .mediaAudio:
            false
        case .inventorySoilComponents, .inventorySoilMixes:
            false
        case .locationsGardens, .locationsMap:
            false
        case .workshopWork, .workshopCalendar, .workshopTasks:
            false
        case .economyPurchases, .economySales, .economyExpenses, .economyIncome,
             .economyTreeValue, .economyPotValue, .economyInventoryValue, .economyReports:
            false
        case .socialContacts, .socialLinks, .socialSharedTrees:
            false
        case .nurseryFieldTree:
            // Field-grown material is a Tree (Location + Acquisition Method). Module hidden; data kept (A3).
            false
        case .knowledgeSoilGuides:
            // Soil & Substrate lives inside Bonsai Handbook — no sidebar destination.
            false
        case .knowledgePotGuidelines:
            // Pots & Containers lives inside Bonsai Handbook — not a sidebar Knowledge page.
            false
        case .knowledgeVideos, .knowledgeCourses, .knowledgeFAQ, .knowledgeExternalLinks:
            // Placeholder Knowledge destinations — keep routes, hide until content ships.
            false
        case .knowledgeQuickGuides:
            // Handbook is the reading surface. Keep the route; hide the sidebar item.
            false
        case .careToday:
            // Tasks → Today owns the day list. Care is recommendations, not a second task list.
            false
        case .careFertilizing, .carePlacement, .careWinter, .careSpring,
             .careRepotting, .careTreeHealth, .careSeasonal:
            // Care pages live on the Care workspace picker (BV1) — sidebar shows one Care row.
            false
        case .tasksOverdue, .tasksThisWeek, .tasksThisMonth, .tasksThisYear, .tasksNextYear:
            // Horizons live on the Tasks page (BJ1) — sidebar shows one Tasks row only.
            false
        case .designVision, .designStyle, .designFrontSelection, .designVirtual,
             .designBranchPlan, .designTrunkDevelopment, .designRamification,
             .designApex, .designDeadwood, .designTimeline:
            false
        default:
            true
        }
    }

    /// Hidden routes still openable from Search while the module is under development.
    var isSearchableWhileHidden: Bool {
        switch self {
        case .socialContacts, .socialLinks, .socialSharedTrees:
            true
        case .nurseryFieldTree:
            true
        case .careFertilizing, .carePlacement, .careWinter, .careSpring,
             .careRepotting, .careTreeHealth, .careSeasonal:
            // Sidebar is one Care row; Search still opens the matching Care page (BV1).
            true
        default:
            false
        }
    }

    var title: String {
        switch self {
        case .dashboard: "Dashboard"

        case .tasksOverdue: "Overdue"
        case .tasksToday: "Today"
        case .tasksThisWeek: "This Week"
        case .tasksThisMonth: "This Month"
        case .tasksThisYear: "This Year"
        case .tasksNextYear: "Next Year"

        case .gardenTrees: "Trees"
        case .gardenCollections: "Collections"

        case .mediaImages: "Images"
        case .mediaDocuments: "Documents"
        case .mediaNotes: "Notes"
        case .mediaVideo: "Videos"
        case .mediaAudio: "Audio"

        case .locationsGardens: "Gardens"
        case .locationsPlaces: "Locations"
        case .locationsMap: "Map"

        case .workshopWork: "Work"
        case .workshopCalendar: "Calendar"
        case .workshopTasks: "Tasks"

        case .nurserySeeds: "Seeds"
        case .nurseryCuttings: "Cuttings"
        case .nurseryAirLayers: "Air Layers"
        case .nurseryGrafting: "Grafting"
        case .nurseryYamadori: "Yamadori"
        case .nurseryFieldTree: "Field Tree"

        case .careToday: "Today"
        case .careWatering: "Watering"
        case .careFertilizing: "Fertilizing"
        case .careRepotting: "Repotting"
        case .carePlacement: "Placement"
        case .careTreeHealth: "Health"
        case .careSeasonal: "Seasonal Care"
        case .careWinter: "Winter Care"
        case .careSpring: "Spring Care"

        case .shaping: "Shaping"

        case .designVision: "Vision"
        case .designStyle: "Style"
        case .designFrontSelection: "Front Selection"
        case .designVirtual: "Virtual Design"
        case .designBranchPlan: "Branch Plan"
        case .designTrunkDevelopment: "Trunk Development"
        case .designRamification: "Ramification"
        case .designApex: "Apex"
        case .designDeadwood: "Deadwood"
        case .designTimeline: "Timeline"

        case .inventoryPots: "Pots"
        case .inventorySoil: "Soil"
        case .inventorySoilComponents: "Soil Components"
        case .inventorySoilMixes: "Soil Mixes"
        case .inventoryFertilizers: "Fertilizers"
        case .inventoryWire: "Wire"
        case .inventoryTools: "Tools"
        case .inventoryChemicals: "Chemicals"
        case .inventoryConsumables: "Consumables"
        case .inventoryStockReport: "Stock Report"

        case .knowledgeQuickGuides: "Quick Guides"
        case .knowledgeHandbook: "Bonsai Handbook"
        case .knowledgeCareCalendar: "Care Calendar"
        case .knowledgePotGuidelines: "Pots & Containers"
        case .knowledgeSpeciesLibrary: "Species Library"
        case .knowledgeSoilGuides: "Soil & Substrate"
        case .knowledgeFertilizerGuides: "Fertilizer Guides"
        case .knowledgeSeedStratification: "Seed Stratification"
        case .knowledgeVideos: "Video Tutorials"
        case .knowledgeCourses: "Courses"
        case .knowledgeFAQ: "FAQ"
        case .knowledgeExternalLinks: "External Links"

        case .economyPurchases: "Purchases"
        case .economySales: "Sales"
        case .economyExpenses: "Expenses"
        case .economyIncome: "Income"
        case .economyTreeValue: "Tree Value"
        case .economyPotValue: "Pot Value"
        case .economyInventoryValue: "Inventory Value"
        case .economyReports: "Reports"

        case .socialContacts: "Contacts"
        case .socialLinks: "Links"
        case .socialSharedTrees: "Shared Trees"

        case .settings: "Settings"
        }
    }

    var systemImage: String {
        module.systemImage
    }

    var module: AppModule {
        switch self {
        case .dashboard: .dashboard
        case .tasksOverdue, .tasksToday, .tasksThisWeek, .tasksThisMonth, .tasksThisYear, .tasksNextYear: .tasks
        case .gardenTrees, .gardenCollections,
             .locationsGardens, .locationsPlaces, .locationsMap: .garden
        case .mediaImages, .mediaDocuments, .mediaNotes, .mediaVideo, .mediaAudio: .media
        case .workshopWork, .workshopCalendar, .workshopTasks: .workshop
        case .nurserySeeds, .nurseryCuttings, .nurseryAirLayers, .nurseryGrafting: .nursery
        case .nurseryYamadori: .yamadori
        case .nurseryFieldTree: .propagation
        case .careToday, .careWatering, .careFertilizing, .careRepotting, .carePlacement,
             .careTreeHealth, .careSeasonal, .careWinter, .careSpring: .care
        case .shaping: .shaping
        case .designVision, .designStyle, .designFrontSelection, .designVirtual,
             .designBranchPlan, .designTrunkDevelopment, .designRamification,
             .designApex, .designDeadwood, .designTimeline: .shaping
        case .inventoryPots, .inventorySoil, .inventorySoilComponents, .inventorySoilMixes,
             .inventoryFertilizers, .inventoryWire, .inventoryTools,
             .inventoryChemicals, .inventoryConsumables, .inventoryStockReport: .inventory
        case .knowledgeQuickGuides, .knowledgeHandbook, .knowledgeCareCalendar, .knowledgePotGuidelines,
             .knowledgeSpeciesLibrary, .knowledgeSoilGuides, .knowledgeFertilizerGuides,
             .knowledgeSeedStratification,
             .knowledgeVideos, .knowledgeCourses, .knowledgeFAQ, .knowledgeExternalLinks: .knowledge
        case .economyPurchases, .economySales, .economyExpenses, .economyIncome,
             .economyTreeValue, .economyPotValue, .economyInventoryValue,
             .economyReports: .economy
        case .socialContacts, .socialLinks, .socialSharedTrees: .social
        case .settings: .settings
        }
    }

    static func routes(in module: AppModule) -> [AppRoute] {
        allRoutes(in: module).filter(\.isShippedInNavigation)
    }

    /// Canonical subpage order per module (includes future routes before they ship).
    static func allRoutes(in module: AppModule) -> [AppRoute] {
        switch module {
        case .dashboard:
            [.dashboard]
        case .tasks:
            [.tasksOverdue, .tasksToday, .tasksThisWeek, .tasksThisMonth, .tasksThisYear, .tasksNextYear]
        case .garden:
            [.gardenTrees, .gardenCollections, .locationsPlaces]
        case .shaping:
            [.shaping]
        case .care:
            [
                .careWatering, .careFertilizing,
                .carePlacement, .careWinter, .careSpring,
                .careRepotting, .careTreeHealth, .careSeasonal,
                .careToday
            ]
        case .nursery:
            [
                .nurserySeeds,
                .nurseryCuttings, .nurseryAirLayers
            ]
        case .yamadori:
            [.nurseryYamadori]
        case .propagation:
            // Legacy — Field Tree projects may still open via Search (A3). Not in sidebar.
            [.nurseryFieldTree]
        case .inventory:
            [
                .inventoryPots, .inventorySoil, .inventorySoilComponents, .inventorySoilMixes,
                .inventoryFertilizers, .inventoryWire, .inventoryTools,
                .inventoryChemicals, .inventoryConsumables, .inventoryStockReport
            ]
        case .media:
            [.mediaImages, .mediaVideo, .mediaDocuments, .mediaNotes, .mediaAudio]
        case .knowledge:
            [
                .knowledgeQuickGuides, .knowledgeHandbook, .knowledgeCareCalendar,
                .knowledgeSpeciesLibrary, .knowledgeFertilizerGuides,
                .knowledgeSeedStratification,
                .knowledgeVideos, .knowledgeCourses, .knowledgeFAQ, .knowledgeExternalLinks
            ]
        case .settings:
            [.settings]
        case .locations:
            [.locationsGardens, .locationsPlaces, .locationsMap]
        case .workshop:
            [.workshopWork, .workshopCalendar, .workshopTasks]
        case .design:
            allRoutes(in: .shaping)
        case .economy:
            [
                .economyPurchases, .economySales, .economyExpenses, .economyIncome,
                .economyTreeValue, .economyPotValue, .economyInventoryValue, .economyReports
            ]
        case .social:
            [.socialSharedTrees, .socialContacts, .socialLinks]
        }
    }

    /// Location routes grouped under Garden.
    static var gardenLocationRoutes: [AppRoute] {
        [.locationsGardens, .locationsPlaces, .locationsMap]
    }

    static func isGardenLocationRoute(_ route: AppRoute?) -> Bool {
        guard let route else { return false }
        return gardenLocationRoutes.contains(route)
    }

    var isYamadoriRoute: Bool {
        self == .nurseryYamadori
    }
}

// MARK: - Compatibility alias

/// Historical name for leaf navigation. Prefer ``AppRoute`` in new code.
typealias AppSection = AppRoute
