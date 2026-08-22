//
//  WorkType.swift
//  Bonsai World
//
//  Reference Data — Work Types (care, health, seasonal, propagation, styling).
//  Owned exclusively by Reference Data. The Work module consumes these types;
//  Trees only display generated Work History that references a Work Type id.
//

import Foundation

/// High-level grouping for Work Types in Reference Data and the Work module.
enum WorkTypeCategory: String, CaseIterable, Codable, Identifiable, Hashable, Sendable {
    case maintenance
    case health
    case seasonal
    case propagation
    case styling
    case other

    var id: Self { self }

    var title: String {
        switch self {
        case .maintenance: "Maintenance"
        case .health: "Health"
        case .seasonal: "Seasonal"
        case .propagation: "Propagation"
        case .styling: "Styling"
        case .other: "Other"
        }
    }

    var sortOrder: Int {
        switch self {
        case .maintenance: 0
        case .health: 1
        case .seasonal: 2
        case .propagation: 3
        case .styling: 4
        case .other: 5
        }
    }
}

/// Future behaviour flags for Work Types. Stored now; not enforced by workflows yet.
struct WorkTypeBehaviourFlags: Codable, Hashable, Sendable {
    var requiresSoilMix: Bool
    var requiresPot: Bool
    var requiresFertilizer: Bool
    var requiresProduct: Bool
    var requiresWire: Bool
    var requiresMeasurements: Bool
    var createsTreeHistory: Bool
    var affectsInventory: Bool
    var affectsEconomy: Bool
    var canApplyToMultipleTrees: Bool
    var canBeScheduled: Bool
    var canUseTemplates: Bool

    static let `default` = WorkTypeBehaviourFlags(
        requiresSoilMix: false,
        requiresPot: false,
        requiresFertilizer: false,
        requiresProduct: false,
        requiresWire: false,
        requiresMeasurements: false,
        createsTreeHistory: true,
        affectsInventory: false,
        affectsEconomy: false,
        canApplyToMultipleTrees: false,
        canBeScheduled: false,
        canUseTemplates: false
    )
}

/// A catalogued kind of work. Built-in and user-defined types share this model.
struct WorkType: Identifiable, Codable, Hashable, Sendable {
    var id: UUID
    var name: String
    var category: WorkTypeCategory
    /// Optional longer explanation of the work type.
    var workDescription: String
    var notes: String
    var sortOrder: Int
    var isActive: Bool
    /// Prepared for future Work workflows — not enforced yet.
    var behaviour: WorkTypeBehaviourFlags

    init(
        id: UUID = UUID(),
        name: String,
        category: WorkTypeCategory = .other,
        workDescription: String = "",
        notes: String = "",
        sortOrder: Int,
        isActive: Bool = true,
        behaviour: WorkTypeBehaviourFlags = .default
    ) {
        self.id = id
        self.name = name
        self.category = category
        self.workDescription = workDescription
        self.notes = notes
        self.sortOrder = sortOrder
        self.isActive = isActive
        self.behaviour = behaviour
    }

    static func mapRecords(_ items: [WorkType]) -> [ReferenceDataRecord] {
        items
            .map {
                ReferenceDataRecord(
                    id: $0.id,
                    name: $0.name,
                    sortOrder: $0.sortOrder,
                    isActive: $0.isActive,
                    subtitle: $0.category.title
                )
            }
            .sorted {
                if $0.sortOrder != $1.sortOrder { return $0.sortOrder < $1.sortOrder }
                return $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending
            }
    }

    static func setActive(_ id: UUID, isActive: Bool, in array: inout [WorkType]) {
        guard let index = array.firstIndex(where: { $0.id == id }) else { return }
        array[index].isActive = isActive
    }

    static func delete(_ id: UUID, from array: inout [WorkType]) {
        array.removeAll { $0.id == id }
    }
}

/// Editor draft for Add / Edit Work Type.
struct WorkTypeDraft: Identifiable, Hashable, Sendable {
    var id: UUID
    var entityID: UUID?
    var name: String
    var category: WorkTypeCategory
    var workDescription: String
    var notes: String
    var sortOrder: Int
    var isActive: Bool
    var behaviour: WorkTypeBehaviourFlags

    var isNew: Bool { entityID == nil }

    static func blank(sortOrder: Int) -> WorkTypeDraft {
        WorkTypeDraft(
            id: UUID(),
            entityID: nil,
            name: "",
            category: .maintenance,
            workDescription: "",
            notes: "",
            sortOrder: sortOrder,
            isActive: true,
            behaviour: .default
        )
    }

    static func from(_ workType: WorkType) -> WorkTypeDraft {
        WorkTypeDraft(
            id: UUID(),
            entityID: workType.id,
            name: workType.name,
            category: workType.category,
            workDescription: workType.workDescription,
            notes: workType.notes,
            sortOrder: workType.sortOrder,
            isActive: workType.isActive,
            behaviour: workType.behaviour
        )
    }
}
