//
//  ReferenceDataCategory.swift
//  Bonsai World
//
//  Categories managed in Settings → Reference Data.
//  Botanical taxonomy is one hierarchical library — not separate lists.
//

import Foundation

enum ReferenceDataCategory: String, CaseIterable, Identifiable, Hashable {
    case botanicalLibrary

    // Acquisition
    case acquisitionMethods
    case disposalMethods
    case suppliers
    case countries

    // Tree
    case styles
    case sizeClasses
    case treeStatuses
    case developmentStages

    // Work
    case workTypes

    // Growing
    case locations
    case locationTypes
    case potTypes
    case lightConditions

    // Soil
    case soilComponents
    case soilMixes

    // Fertilizer
    case fertilizerTypes

    // Inventory Preparation (lists only — no quantities)
    case inventoryPots
    case tools
    case wire
    case chemicals

    var id: Self { self }

    var title: String {
        switch self {
        case .botanicalLibrary: "Botanical Library"
        case .acquisitionMethods: "Acquisition Methods"
        case .disposalMethods: "Disposal Methods"
        case .suppliers: "Suppliers"
        case .countries: "Countries"
        case .styles: "Styles"
        case .sizeClasses: "Size Classes"
        case .treeStatuses: "Tree Status"
        case .developmentStages: "Development Stages"
        case .workTypes: "Work Types"
        case .locations: "Locations"
        case .locationTypes: "Location Types"
        case .potTypes: "Pot Types"
        case .lightConditions: "Light Conditions"
        case .soilComponents: "Soil Components"
        case .soilMixes: "Soil Mixes"
        case .fertilizerTypes: "Fertilizer Types"
        case .inventoryPots: "Pots"
        case .tools: "Tools"
        case .wire: "Wire"
        case .chemicals: "Chemicals"
        }
    }

    var group: ReferenceDataCategoryGroup {
        switch self {
        case .botanicalLibrary:
            .botanical
        case .acquisitionMethods, .disposalMethods, .suppliers, .countries:
            .acquisition
        case .styles, .sizeClasses, .treeStatuses, .developmentStages:
            .tree
        case .workTypes:
            .work
        case .locations, .locationTypes, .potTypes, .lightConditions:
            .growing
        case .soilComponents, .soilMixes:
            .soil
        case .fertilizerTypes:
            .fertilizer
        case .inventoryPots, .tools, .wire, .chemicals:
            .inventory
        }
    }
}

enum ReferenceDataCategoryGroup: String, CaseIterable, Identifiable {
    case botanical
    case acquisition
    case tree
    case work
    case growing
    case soil
    case fertilizer
    case inventory

    var id: Self { self }

    var title: String {
        switch self {
        case .botanical: "Botanical"
        case .acquisition: "Acquisition"
        case .tree: "Tree"
        case .work: "Work"
        case .growing: "Growing"
        case .soil: "Soil"
        case .fertilizer: "Fertilizer"
        case .inventory: "Inventory Preparation"
        }
    }

    var categories: [ReferenceDataCategory] {
        ReferenceDataCategory.allCases.filter { $0.group == self }
    }
}

/// Row model for flat Reference Data Manager lists (UI-facing).
struct ReferenceDataRecord: Identifiable, Hashable, Sendable {
    var id: UUID
    var name: String
    var sortOrder: Int
    var isActive: Bool
    /// Optional parent label (unused for flat lists).
    var subtitle: String?
    var parentID: UUID?
}

/// Draft for Add / Edit sheets on flat reference lists.
struct ReferenceDataDraft: Identifiable, Hashable, Sendable {
    /// Stable identity for sheet presentation.
    var id: UUID
    /// Existing entity id when editing; `nil` when creating.
    var entityID: UUID?
    var name: String
    var sortOrder: Int
    var isActive: Bool
    var parentID: UUID?

    var isNew: Bool { entityID == nil }

    static func blank(sortOrder: Int, parentID: UUID? = nil) -> ReferenceDataDraft {
        ReferenceDataDraft(
            id: UUID(),
            entityID: nil,
            name: "",
            sortOrder: sortOrder,
            isActive: true,
            parentID: parentID
        )
    }
}

enum SettingsPane: String, CaseIterable, Identifiable, Hashable {
    case userProfile
    case regionalSettings
    case referenceData
    case appearance
    case notifications
    case backup

    var id: Self { self }

    var title: String {
        switch self {
        case .userProfile: "User Profile"
        case .regionalSettings: "Regional Settings"
        case .referenceData: "Reference Data"
        case .appearance: "Appearance"
        case .notifications: "Notifications"
        case .backup: "Backup"
        }
    }

    var systemImage: String {
        switch self {
        case .userProfile: "person.crop.circle"
        case .regionalSettings: "globe"
        case .referenceData: "list.bullet.rectangle"
        case .appearance: "paintbrush"
        case .notifications: "bell"
        case .backup: "externaldrive"
        }
    }
}
