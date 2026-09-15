//
//  SoilMix.swift
//  Bonsai World
//
//  Reference Data — Soil — named mixes of Soil Components by percentage.
//  Single source of truth for Trees, and later Repotting / Inventory / Economy / Reports.
//  Trees store only `soilMixID`; composition lives here.
//

import Foundation

/// One ingredient line inside a ``SoilMix``. Percentages across a mix must total 100.
struct SoilMixPart: Identifiable, Codable, Hashable, Sendable {
    var id: UUID
    var componentID: UUID
    /// Whole-number percent of the mix (0…100). Sum of parts must equal 100.
    var percentage: Int

    init(id: UUID = UUID(), componentID: UUID, percentage: Int) {
        self.id = id
        self.componentID = componentID
        self.percentage = percentage
    }
}

/// A reusable soil recipe. Built-in and user-defined mixes are the same type.
struct SoilMix: Identifiable, Hashable, Sendable {
    var id: UUID
    var name: String
    /// Optional notes about the recipe.
    var mixDescription: String
    /// Optional guidance (e.g. deciduous, pines, shohin).
    var intendedUse: String
    /// Contextual fit — Yamadori is a condition, never a species.
    var contextTags: [SoilMixContextTag]
    /// Optional genus applicability (not a substitute for condition/context).
    var genusIDs: [UUID]
    var parts: [SoilMixPart]
    var sortOrder: Int
    var isActive: Bool

    init(
        id: UUID = UUID(),
        name: String,
        mixDescription: String = "",
        intendedUse: String = "",
        contextTags: [SoilMixContextTag] = [],
        genusIDs: [UUID] = [],
        parts: [SoilMixPart] = [],
        sortOrder: Int,
        isActive: Bool = true
    ) {
        self.id = id
        self.name = name
        self.mixDescription = mixDescription
        self.intendedUse = intendedUse
        self.contextTags = contextTags
        self.genusIDs = genusIDs
        self.parts = parts
        self.sortOrder = sortOrder
        self.isActive = isActive
    }

    var totalPercentage: Int {
        parts.reduce(0) { $0 + $1.percentage }
    }

    var isPercentageValid: Bool {
        !parts.isEmpty && totalPercentage == 100
    }

    static func mapRecords(_ items: [SoilMix]) -> [ReferenceDataRecord] {
        items
            .map {
                ReferenceDataRecord(
                    id: $0.id,
                    name: $0.name,
                    sortOrder: $0.sortOrder,
                    isActive: $0.isActive,
                    subtitle: $0.intendedUse.isEmpty ? nil : $0.intendedUse
                )
            }
            .sorted {
                if $0.sortOrder != $1.sortOrder { return $0.sortOrder < $1.sortOrder }
                return $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending
            }
    }

    static func setActive(_ id: UUID, isActive: Bool, in array: inout [SoilMix]) {
        guard let index = array.firstIndex(where: { $0.id == id }) else { return }
        array[index].isActive = isActive
    }

    static func delete(_ id: UUID, from array: inout [SoilMix]) {
        array.removeAll { $0.id == id }
    }
}

extension SoilMix: Codable {
    enum CodingKeys: String, CodingKey {
        case id, name, mixDescription, intendedUse, contextTags, genusIDs, parts, sortOrder, isActive
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        id = try c.decode(UUID.self, forKey: .id)
        name = try c.decode(String.self, forKey: .name)
        mixDescription = try c.decodeIfPresent(String.self, forKey: .mixDescription) ?? ""
        intendedUse = try c.decodeIfPresent(String.self, forKey: .intendedUse) ?? ""
        contextTags = try c.decodeIfPresent([SoilMixContextTag].self, forKey: .contextTags) ?? []
        genusIDs = try c.decodeIfPresent([UUID].self, forKey: .genusIDs) ?? []
        parts = try c.decodeIfPresent([SoilMixPart].self, forKey: .parts) ?? []
        sortOrder = try c.decode(Int.self, forKey: .sortOrder)
        isActive = try c.decodeIfPresent(Bool.self, forKey: .isActive) ?? true
    }

    func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(id, forKey: .id)
        try c.encode(name, forKey: .name)
        try c.encode(mixDescription, forKey: .mixDescription)
        try c.encode(intendedUse, forKey: .intendedUse)
        try c.encode(contextTags, forKey: .contextTags)
        try c.encode(genusIDs, forKey: .genusIDs)
        try c.encode(parts, forKey: .parts)
        try c.encode(sortOrder, forKey: .sortOrder)
        try c.encode(isActive, forKey: .isActive)
    }
}

/// Editor draft for Add / Edit Soil Mix (composition + 100% validation).
struct SoilMixDraft: Identifiable, Hashable, Sendable {
    var id: UUID
    var entityID: UUID?
    var name: String
    var mixDescription: String
    var intendedUse: String
    var contextTags: [SoilMixContextTag]
    var genusIDs: [UUID]
    var sortOrder: Int
    var isActive: Bool
    var parts: [SoilMixPartDraft]

    var isNew: Bool { entityID == nil }

    var totalPercentage: Int {
        parts.reduce(0) { $0 + max(0, $1.percentage) }
    }

    var isPercentageValid: Bool {
        !parts.isEmpty
            && parts.allSatisfy { $0.componentID != nil && $0.percentage > 0 }
            && totalPercentage == 100
    }

    static func blank(sortOrder: Int) -> SoilMixDraft {
        SoilMixDraft(
            id: UUID(),
            entityID: nil,
            name: "",
            mixDescription: "",
            intendedUse: "",
            contextTags: [],
            genusIDs: [],
            sortOrder: sortOrder,
            isActive: true,
            parts: []
        )
    }

    static func from(_ mix: SoilMix) -> SoilMixDraft {
        SoilMixDraft(
            id: UUID(),
            entityID: mix.id,
            name: mix.name,
            mixDescription: mix.mixDescription,
            intendedUse: mix.intendedUse,
            contextTags: mix.contextTags,
            genusIDs: mix.genusIDs,
            sortOrder: mix.sortOrder,
            isActive: mix.isActive,
            parts: mix.parts.map {
                SoilMixPartDraft(id: $0.id, componentID: $0.componentID, percentage: $0.percentage)
            }
        )
    }
}

struct SoilMixPartDraft: Identifiable, Hashable, Sendable {
    var id: UUID
    var componentID: UUID?
    var percentage: Int

    init(id: UUID = UUID(), componentID: UUID? = nil, percentage: Int = 0) {
        self.id = id
        self.componentID = componentID
        self.percentage = percentage
    }
}
