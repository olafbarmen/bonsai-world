//
//  Collection.swift
//  Bonsai World
//
//  Collections are organizational — not part of the physical hierarchy.
//
//  Physical hierarchy (owns geography):
//    User → Gardens → Locations → Trees
//
//  Organizational:
//    Collections → Tree references only (many-to-many)
//
//  Gardens own Address + Garden Position (Map Center).
//  Locations own Latitude / Longitude.
//  Trees reference exactly one Location and never store coordinates.
//  Collections never own a geographic position. On the map they appear only as a Collection Filter.
//

import Foundation

// MARK: - Collection type

/// Manual membership vs rule-based Smart Collections.
/// System Smart Collection placeholders are seeded for navigation; filter rules are not evaluated yet.
enum CollectionType: String, Codable, CaseIterable, Hashable, Sendable {
    case manual
    case smart

    var displayName: String {
        switch self {
        case .manual:
            "Manual Collection"
        case .smart:
            "Smart Collection"
        }
    }
}

// MARK: - Smart Collection foundation (unused until Smart Collections ship)

/// Reserved configuration for Smart Collections — not evaluated yet.
struct SmartCollectionDefinition: Codable, Hashable, Sendable {
    /// Filter criteria that determine automatic membership (future).
    var filterRules: [SmartCollectionFilterRule] = []
    /// Optional sort order for resolved member trees (future).
    var sort: SmartCollectionSort?
    /// Optional grouping of resolved members (future).
    var grouping: SmartCollectionGrouping?
}

/// Filter rule placeholder — schema defined when Smart Collections ship.
struct SmartCollectionFilterRule: Codable, Hashable, Sendable {}

/// Sort placeholder — schema defined when Smart Collections ship.
struct SmartCollectionSort: Codable, Hashable, Sendable {}

/// Grouping placeholder — schema defined when Smart Collections ship.
struct SmartCollectionGrouping: Codable, Hashable, Sendable {}

// MARK: - Collection

struct Collection: Identifiable, Codable, Hashable, Sendable {
    var id: UUID
    var name: String
    var description: String
    /// Manual vs Smart. Existing records without this field decode as `.manual`.
    var type: CollectionType
    /// Optional accent token (for example a hex string or named token). Presentation maps this later.
    var color: String?
    /// Optional SF Symbol name for the collection.
    var icon: String?
    /// Manual member trees — **Tree IDs only**. Never stores Tree objects or a separate tree catalog.
    /// For `.manual` collections this is the membership source of truth.
    /// Smart collections (future) will resolve membership from ``smartDefinition`` instead.
    /// Membership only — never latitude / longitude.
    var treeIDs: [UUID]
    /// Smart Collection rules and presentation options. `nil` for manual collections. Unused until Smart Collections ship.
    var smartDefinition: SmartCollectionDefinition?

    init(
        id: UUID = UUID(),
        name: String,
        description: String = "",
        type: CollectionType = .manual,
        color: String? = nil,
        icon: String? = nil,
        treeIDs: [UUID] = [],
        smartDefinition: SmartCollectionDefinition? = nil
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.type = type
        self.color = color
        self.icon = icon
        self.treeIDs = treeIDs
        self.smartDefinition = smartDefinition
    }

    enum CodingKeys: String, CodingKey {
        case id, name, description, type, color, icon, treeIDs, smartDefinition
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        description = try container.decodeIfPresent(String.self, forKey: .description) ?? ""
        type = try container.decodeIfPresent(CollectionType.self, forKey: .type) ?? .manual
        color = try container.decodeIfPresent(String.self, forKey: .color)
        icon = try container.decodeIfPresent(String.self, forKey: .icon)
        treeIDs = try container.decodeIfPresent([UUID].self, forKey: .treeIDs) ?? []
        smartDefinition = try container.decodeIfPresent(SmartCollectionDefinition.self, forKey: .smartDefinition)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(description, forKey: .description)
        try container.encode(type, forKey: .type)
        try container.encodeIfPresent(color, forKey: .color)
        try container.encodeIfPresent(icon, forKey: .icon)
        try container.encode(treeIDs, forKey: .treeIDs)
        if let smartDefinition {
            try container.encode(smartDefinition, forKey: .smartDefinition)
        }
    }
}

extension Collection {
    /// Default for new and legacy collections.
    static let defaultType: CollectionType = .manual

    /// When `true`, Collection Detail shows the Kind summary row (Manual / Smart).
    static let showsKindInSummary = false

    var isManual: Bool { type == .manual }
    var isSmart: Bool { type == .smart }
}
