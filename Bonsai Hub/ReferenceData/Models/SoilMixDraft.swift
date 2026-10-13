//
//  SoilMixDraft.swift
//  Bonsai World
//
//  Reference Data helpers for Soil Mix — core type lives in BonsaiCore.
//

import Foundation

extension SoilMix {
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
