//
//  SoilMix.swift
//  BonsaiCore
//
//  Named soil recipes. Trees store soilMixID; composition lives here.
//

import Foundation

enum SoilMixContextTag: String, Codable, Hashable, Sendable, CaseIterable, Identifiable {
    case yamadori
    case development
    case recovery
    case refinement
    case seeds

    var id: Self { self }

    var title: String {
        switch self {
        case .yamadori: "Yamadori"
        case .development: "Development"
        case .recovery: "Recovery"
        case .refinement: "Refinement"
        case .seeds: "Seeds"
        }
    }
}

/// One ingredient line inside a ``SoilMix``. Percentages across a mix should total 100.
struct SoilMixPart: Identifiable, Hashable, Sendable {
    var id: UUID
    /// Catalog component when known. Free-text field lines still store a stable UUID.
    var componentID: UUID
    /// Free-text component name (field). Empty when resolved only via catalog.
    var componentName: String
    /// Whole-number percent of the mix (0…100). Sum of parts should equal 100.
    var percentage: Int

    init(
        id: UUID = UUID(),
        componentID: UUID = UUID(),
        componentName: String = "",
        percentage: Int
    ) {
        self.id = id
        self.componentID = componentID
        self.componentName = componentName
        self.percentage = percentage
    }
}

extension SoilMixPart: Codable {
    enum CodingKeys: String, CodingKey {
        case id, componentID, componentName, percentage
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        id = try c.decodeIfPresent(UUID.self, forKey: .id) ?? UUID()
        componentID = try c.decode(UUID.self, forKey: .componentID)
        componentName = try c.decodeIfPresent(String.self, forKey: .componentName) ?? ""
        percentage = try c.decode(Int.self, forKey: .percentage)
    }

    func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(id, forKey: .id)
        try c.encode(componentID, forKey: .componentID)
        try c.encode(componentName, forKey: .componentName)
        try c.encode(percentage, forKey: .percentage)
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
        sortOrder: Int = 0,
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

    /// Short composition line for lists (e.g. "Akadama 50% · Pumice 25%").
    var compositionSummary: String {
        let lines = parts
            .filter { $0.percentage > 0 || !$0.componentName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
            .map { part -> String in
                let name = part.componentName.trimmingCharacters(in: .whitespacesAndNewlines)
                let label = name.isEmpty ? "Component" : name
                return "\(label) \(part.percentage)%"
            }
        return lines.joined(separator: " · ")
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
        sortOrder = try c.decodeIfPresent(Int.self, forKey: .sortOrder) ?? 0
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
