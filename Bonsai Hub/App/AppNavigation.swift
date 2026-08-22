//
//  AppNavigation.swift
//  Bonsai World
//
//  Architecture Version 2 — permanent application navigation structure.
//  Top-level modules mirror how bonsai enthusiasts think and work.
//  Leaf routes select content; modules group routes in the sidebar.
//

import Foundation

// MARK: - Top-level modules (sidebar order is permanent)

/// Architecture Version 2 main modules — exact product navigation order.
enum AppModule: String, CaseIterable, Identifiable, Hashable, Sendable {
    case dashboard
    case garden
    case locations
    case workshop
    case nursery
    case care
    case design
    case inventory
    case knowledge
    case economy
    case settings

    var id: Self { self }

    var title: String {
        switch self {
        case .dashboard: "Dashboard"
        case .garden: "Garden"
        case .locations: "Locations"
        case .workshop: "Workshop"
        case .nursery: "Nursery"
        case .care: "Care"
        case .design: "Design"
        case .inventory: "Inventory"
        case .knowledge: "Knowledge"
        case .economy: "Economy"
        case .settings: "Settings"
        }
    }

    var systemImage: String {
        switch self {
        case .dashboard: "square.grid.2x2"
        case .garden: "leaf"
        case .locations: "mappin.and.ellipse"
        case .workshop: "wrench.and.screwdriver"
        case .nursery: "leaf.circle"
        case .care: "drop"
        case .design: "pencil.and.outline"
        case .inventory: "shippingbox"
        case .knowledge: "book"
        case .economy: "sterlingsign.circle"
        case .settings: "gearshape"
        }
    }

    /// Workspace modules (excludes Settings / Tools).
    static var workspaceModules: [AppModule] {
        [
            .dashboard,
            .garden,
            .locations,
            .workshop,
            .nursery,
            .care,
            .design,
            .inventory,
            .knowledge,
            .economy
        ]
    }

    static var toolsModules: [AppModule] {
        [.settings]
    }

    /// Child routes shown under this module in the sidebar. Empty = leaf module.
    var routes: [AppRoute] {
        AppRoute.routes(in: self)
    }

    var defaultRoute: AppRoute {
        routes.first ?? .dashboard
    }
}

// MARK: - Leaf routes (content selection)

/// Concrete content destinations within Architecture Version 2 modules.
enum AppRoute: String, CaseIterable, Identifiable, Hashable, Sendable {
    // Dashboard
    case dashboard

    // Garden
    case gardenTrees
    case gardenCollections
    case gardenGallery

    // Locations
    case locationsGardens
    case locationsPlaces
    case locationsMap

    // Workshop
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
    case carePlacement
    case careTreeHealth
    case careSeasonal
    case careWinter

    // Design
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

    // Economy
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

    var title: String {
        switch self {
        case .dashboard: "Dashboard"

        case .gardenTrees: "Trees"
        case .gardenCollections: "Collections"
        case .gardenGallery: "Gallery"

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
        case .carePlacement: "Placement"
        case .careTreeHealth: "Tree Health"
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
        case .gardenTrees, .gardenCollections, .gardenGallery: .garden
        case .locationsGardens, .locationsPlaces, .locationsMap: .locations
        case .workshopWork, .workshopCalendar, .workshopTasks: .workshop
        case .nurserySeeds, .nurseryCuttings, .nurseryAirLayers,
             .nurseryGrafting, .nurseryYamadori, .nurseryDevelopment: .nursery
        case .careToday, .careWatering, .careFertilizing, .carePlacement,
             .careTreeHealth, .careSeasonal, .careWinter: .care
        case .designVision, .designStyle, .designFrontSelection, .designVirtual,
             .designBranchPlan, .designTrunkDevelopment, .designRamification,
             .designApex, .designDeadwood, .designTimeline: .design
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
        switch module {
        case .dashboard: [.dashboard]
        case .garden: [.gardenTrees, .gardenCollections, .gardenGallery]
        case .locations: [.locationsGardens, .locationsPlaces, .locationsMap]
        case .workshop: [.workshopWork, .workshopCalendar, .workshopTasks]
        case .nursery: [
            .nurserySeeds, .nurseryCuttings, .nurseryAirLayers,
            .nurseryGrafting, .nurseryYamadori, .nurseryDevelopment
        ]
        case .care: [
            .careToday, .careWatering, .careFertilizing, .carePlacement,
            .careTreeHealth, .careSeasonal, .careWinter
        ]
        case .design: [
            .designVision, .designStyle, .designFrontSelection, .designVirtual,
            .designBranchPlan, .designTrunkDevelopment, .designRamification,
            .designApex, .designDeadwood, .designTimeline
        ]
        case .inventory: [
            .inventoryPots, .inventorySoil, .inventorySoilComponents, .inventorySoilMixes,
            .inventoryFertilizers, .inventoryWire, .inventoryTools,
            .inventoryChemicals, .inventoryConsumables
        ]
        case .knowledge: [
            .knowledgeQuickGuides, .knowledgeHandbook, .knowledgeSpeciesLibrary,
            .knowledgeSoilGuides, .knowledgeFertilizerGuides, .knowledgeVideos,
            .knowledgeCourses, .knowledgeFAQ, .knowledgeExternalLinks
        ]
        case .economy: [
            .economyPurchases, .economySales, .economyExpenses, .economyIncome,
            .economyTreeValue, .economyPotValue, .economyInventoryValue, .economyReports
        ]
        case .settings: [.settings]
        }
    }
}

// MARK: - Compatibility alias

/// Historical name for leaf navigation. Prefer ``AppRoute`` in new code.
typealias AppSection = AppRoute
