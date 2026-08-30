//
//  FertilizerType.swift
//  Bonsai World
//
//  Reference Data — Fertilizer — one entry per product the grower actually uses.
//  Name carries product/brand identity together (e.g. "BioGold Original"); Form,
//  Release, and Origin are independent, fixed classifications so future fertilizing
//  rules per Tree can match on any axis without being locked to flat combinations.
//

import Foundation

/// Physical application form — fixed vocabulary, not user-editable.
enum FertilizerForm: String, CaseIterable, Codable, Identifiable, Hashable, Sendable {
    case granular
    case pellet
    case liquid
    case powder
    case tablet
    case stick

    var id: Self { self }

    var title: String {
        switch self {
        case .granular: "Granular"
        case .pellet: "Pellet"
        case .liquid: "Liquid"
        case .powder: "Powder"
        case .tablet: "Tablet"
        case .stick: "Stick"
        }
    }
}

/// Nutrient release speed — fixed vocabulary, not user-editable.
enum FertilizerRelease: String, CaseIterable, Codable, Identifiable, Hashable, Sendable {
    case immediate
    case slowRelease

    var id: Self { self }

    var title: String {
        switch self {
        case .immediate: "Immediate"
        case .slowRelease: "Slow Release"
        }
    }
}

/// Nutrient origin — fixed vocabulary, not user-editable.
enum FertilizerOrigin: String, CaseIterable, Codable, Identifiable, Hashable, Sendable {
    case organic
    case mineral
    case organicMineral

    var id: Self { self }

    var title: String {
        switch self {
        case .organic: "Organic"
        case .mineral: "Mineral"
        case .organicMineral: "Organic-Mineral"
        }
    }
}

/// A specific fertilizer product the grower registers once and reuses everywhere
/// (Work registration pickers, future fertilizing rules per Tree).
struct FertilizerType: Identifiable, Codable, Hashable, Sendable {
    var id: UUID
    /// Product identity as the grower knows it — carries brand, e.g. "BioGold Original".
    var name: String
    var form: FertilizerForm
    var release: FertilizerRelease
    var origin: FertilizerOrigin
    /// Free-text NPK label, e.g. "6-3-6" — formats vary too much across brands for a strict numeric model.
    var npk: String
    var sortOrder: Int
    var isActive: Bool

    init(
        id: UUID = UUID(),
        name: String,
        form: FertilizerForm = .pellet,
        release: FertilizerRelease = .slowRelease,
        origin: FertilizerOrigin = .organic,
        npk: String = "",
        sortOrder: Int,
        isActive: Bool = true
    ) {
        self.id = id
        self.name = name
        self.form = form
        self.release = release
        self.origin = origin
        self.npk = npk
        self.sortOrder = sortOrder
        self.isActive = isActive
    }

    /// "Origin / Form / Release" summary for list rows and pickers, e.g. "Organic / Pellet / Slow Release".
    var classificationSummary: String {
        "\(origin.title) / \(form.title) / \(release.title)"
    }

    static func mapRecords(_ items: [FertilizerType]) -> [ReferenceDataRecord] {
        items
            .map {
                ReferenceDataRecord(
                    id: $0.id,
                    name: $0.name,
                    sortOrder: $0.sortOrder,
                    isActive: $0.isActive,
                    subtitle: $0.classificationSummary
                )
            }
            .sorted {
                if $0.sortOrder != $1.sortOrder { return $0.sortOrder < $1.sortOrder }
                return $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending
            }
    }

    static func setActive(_ id: UUID, isActive: Bool, in array: inout [FertilizerType]) {
        guard let index = array.firstIndex(where: { $0.id == id }) else { return }
        array[index].isActive = isActive
    }

    static func delete(_ id: UUID, from array: inout [FertilizerType]) {
        array.removeAll { $0.id == id }
    }
}

/// Editor draft for Add / Edit Fertilizer Type.
struct FertilizerTypeDraft: Identifiable, Hashable, Sendable {
    var id: UUID
    var entityID: UUID?
    var name: String
    var form: FertilizerForm
    var release: FertilizerRelease
    var origin: FertilizerOrigin
    var npk: String
    var sortOrder: Int
    var isActive: Bool

    var isNew: Bool { entityID == nil }

    static func blank(sortOrder: Int) -> FertilizerTypeDraft {
        FertilizerTypeDraft(
            id: UUID(),
            entityID: nil,
            name: "",
            form: .pellet,
            release: .slowRelease,
            origin: .organic,
            npk: "",
            sortOrder: sortOrder,
            isActive: true
        )
    }

    static func from(_ fertilizerType: FertilizerType) -> FertilizerTypeDraft {
        FertilizerTypeDraft(
            id: UUID(),
            entityID: fertilizerType.id,
            name: fertilizerType.name,
            form: fertilizerType.form,
            release: fertilizerType.release,
            origin: fertilizerType.origin,
            npk: fertilizerType.npk,
            sortOrder: fertilizerType.sortOrder,
            isActive: fertilizerType.isActive
        )
    }
}
