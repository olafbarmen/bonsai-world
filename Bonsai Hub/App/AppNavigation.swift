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
    case inventory
    case media
    case knowledge
    case settings

    // Legacy module identities — routes may still reference these; not shown in the sidebar.
    case locations
    case workshop
    case design
    case economy

    var id: Self { self }

    var title: String {
        switch self {
        case .dashboard: "Dashboard"
        case .tasks: "Tasks"
        case .garden: "Garden"
        case .shaping: "Shaping"
        case .care: "Care"
        case .nursery: "Nursery"
        case .inventory: "Inventory"
        case .media: "Media"
        case .knowledge: "Knowledge"
        case .settings: "Settings"
        case .locations: "Locations"
        case .workshop: "Workshop"
        case .design: "Design"
        case .economy: "Economy"
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
        case .inventory: "shippingbox"
        case .media: "photo.on.rectangle.angled"
        case .knowledge: "book"
        case .settings: "gearshape"
        case .locations: "mappin.and.ellipse"
        case .workshop: "wrench.and.screwdriver"
        case .design: "pencil.and.outline"
        case .economy: "sterlingsign.circle"
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

    static var toolsModules: [AppModule] {
        [.settings]
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
    case nurseryDevelopment

    // Care
    case careToday
    case careWatering
    case careFertilizing
    case careRepotting
    case carePlacement
    case careTreeHealth
    case careSeasonal
    case careWinter

    // Shaping (formerly Design)
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

    // Knowledge
    case knowledgeQuickGuides
    case knowledgeHandbook
    case knowledgeSpeciesLibrary
    case knowledgeSoilGuides
    case knowledgeFertilizerGuides
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

    // Settings
    case settings

    var id: Self { self }

    /// Whether this route is listed in the sidebar today.
    var isShippedInNavigation: Bool {
        switch self {
        case .mediaImages, .mediaVideo, .mediaDocuments:
            true
        case .mediaNotes, .mediaAudio:
            false
        case .locationsGardens, .locationsMap:
            false
        case .workshopWork, .workshopCalendar, .workshopTasks:
            false
        case .economyPurchases, .economySales, .economyExpenses, .economyIncome,
             .economyTreeValue, .economyPotValue, .economyInventoryValue, .economyReports:
            false
        case .careToday, .carePlacement, .careWinter:
            false
        default:
            true
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
        case .nurseryDevelopment: "Development"

        case .careToday: "Today"
        case .careWatering: "Watering"
        case .careFertilizing: "Fertilizing"
        case .careRepotting: "Repotting"
        case .carePlacement: "Placement"
        case .careTreeHealth: "Health"
        case .careSeasonal: "Seasonal Care"
        case .careWinter: "Winter Care"

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

        case .knowledgeQuickGuides: "Quick Guides"
        case .knowledgeHandbook: "Bonsai Handbook"
        case .knowledgeSpeciesLibrary: "Species Library"
        case .knowledgeSoilGuides: "Soil Guides"
        case .knowledgeFertilizerGuides: "Fertilizer Guides"
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
        case .nurserySeeds, .nurseryCuttings, .nurseryAirLayers,
             .nurseryGrafting, .nurseryYamadori, .nurseryDevelopment: .nursery
        case .careToday, .careWatering, .careFertilizing, .careRepotting, .carePlacement,
             .careTreeHealth, .careSeasonal, .careWinter: .care
        case .designVision, .designStyle, .designFrontSelection, .designVirtual,
             .designBranchPlan, .designTrunkDevelopment, .designRamification,
             .designApex, .designDeadwood, .designTimeline: .shaping
        case .inventoryPots, .inventorySoil, .inventorySoilComponents, .inventorySoilMixes,
             .inventoryFertilizers, .inventoryWire, .inventoryTools,
             .inventoryChemicals, .inventoryConsumables: .inventory
        case .knowledgeQuickGuides, .knowledgeHandbook, .knowledgeSpeciesLibrary,
             .knowledgeSoilGuides, .knowledgeFertilizerGuides, .knowledgeVideos,
             .knowledgeCourses, .knowledgeFAQ, .knowledgeExternalLinks: .knowledge
        case .economyPurchases, .economySales, .economyExpenses, .economyIncome,
             .economyTreeValue, .economyPotValue, .economyInventoryValue,
             .economyReports: .economy
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
            [
                .designVision, .designStyle, .designFrontSelection, .designVirtual,
                .designBranchPlan, .designTrunkDevelopment, .designRamification,
                .designApex, .designDeadwood, .designTimeline
            ]
        case .care:
            [
                .careWatering, .careFertilizing, .careRepotting,
                .careTreeHealth, .careSeasonal,
                .careToday, .carePlacement, .careWinter
            ]
        case .nursery:
            [
                .nurserySeeds, .nurseryCuttings, .nurseryAirLayers,
                .nurseryGrafting, .nurseryYamadori, .nurseryDevelopment
            ]
        case .inventory:
            [
                .inventoryPots, .inventorySoil, .inventorySoilComponents, .inventorySoilMixes,
                .inventoryFertilizers, .inventoryWire, .inventoryTools,
                .inventoryChemicals, .inventoryConsumables
            ]
        case .media:
            [.mediaImages, .mediaVideo, .mediaDocuments, .mediaNotes, .mediaAudio]
        case .knowledge:
            [
                .knowledgeQuickGuides, .knowledgeHandbook, .knowledgeSpeciesLibrary,
                .knowledgeSoilGuides, .knowledgeFertilizerGuides, .knowledgeVideos,
                .knowledgeCourses, .knowledgeFAQ, .knowledgeExternalLinks
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
}

// MARK: - Compatibility alias

/// Historical name for leaf navigation. Prefer ``AppRoute`` in new code.
typealias AppSection = AppRoute
