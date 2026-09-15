//
//  FertilizerType.swift
//  Bonsai World
//
//  Reference Data — Fertilizer — one entry per product the grower actually uses.
//  Brand (optional) + Name (product). Form, Release, and Origin are independent
//  classifications so fertilizing rules can match on any axis.
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
/// (Work registration pickers, Inventory stock, future fertilizing rules per Tree).
struct FertilizerType: Identifiable, Hashable, Sendable {
    var id: UUID
    /// Optional brand — e.g. "BioGold". Combined with ``name`` in ``displayName``.
    var brand: String
    /// Product name as the grower knows it — e.g. "Original".
    var name: String
    var form: FertilizerForm
    var release: FertilizerRelease
    var origin: FertilizerOrigin
    /// Stored NPK label, e.g. "6-3-6" — built from editor N / P / K fields.
    var npk: String
    var sortOrder: Int
    var isActive: Bool

    init(
        id: UUID = UUID(),
        brand: String = "",
        name: String,
        form: FertilizerForm = .pellet,
        release: FertilizerRelease = .slowRelease,
        origin: FertilizerOrigin = .organic,
        npk: String = "",
        sortOrder: Int,
        isActive: Bool = true
    ) {
        self.id = id
        self.brand = brand
        self.name = name
        self.form = form
        self.release = release
        self.origin = origin
        self.npk = npk
        self.sortOrder = sortOrder
        self.isActive = isActive
    }

    /// Brand + Name for lists and pickers — e.g. "BioGold Original".
    var displayName: String {
        let brand = brand.trimmingCharacters(in: .whitespacesAndNewlines)
        let name = name.trimmingCharacters(in: .whitespacesAndNewlines)
        if !brand.isEmpty, !name.isEmpty { return "\(brand) \(name)" }
        if !name.isEmpty { return name }
        return brand
    }

    /// "Origin / Form / Release" summary for list rows and pickers.
    var classificationSummary: String {
        "\(origin.title) / \(form.title) / \(release.title)"
    }

    static func mapRecords(_ items: [FertilizerType]) -> [ReferenceDataRecord] {
        items
            .map {
                var subtitle = $0.classificationSummary
                let npk = $0.npk.trimmingCharacters(in: .whitespacesAndNewlines)
                if !npk.isEmpty {
                    subtitle = "\(subtitle) · \(npk)"
                }
                return ReferenceDataRecord(
                    id: $0.id,
                    name: $0.displayName,
                    sortOrder: $0.sortOrder,
                    isActive: $0.isActive,
                    subtitle: subtitle
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

    /// Parse free-text NPK into N / P / K (supports "5.5-6.5-3.5").
    static func parseNPK(_ npk: String) -> (n: Double?, p: Double?, k: Double?) {
        let parts = npk
            .split(separator: "-", omittingEmptySubsequences: false)
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
        func value(at index: Int) -> Double? {
            guard parts.indices.contains(index), !parts[index].isEmpty else { return nil }
            return Double(parts[index].replacingOccurrences(of: ",", with: "."))
        }
        return (value(at: 0), value(at: 1), value(at: 2))
    }

    /// Build stored NPK from optional N / P / K. Empty when all unset.
    static func formatNPK(n: Double?, p: Double?, k: Double?) -> String {
        guard n != nil || p != nil || k != nil else { return "" }
        func part(_ value: Double?) -> String {
            guard let value else { return "" }
            return Self.formatNPKComponent(value)
        }
        return "\(part(n))-\(part(p))-\(part(k))"
    }

    private static func formatNPKComponent(_ value: Double) -> String {
        if value.rounded() == value {
            return String(Int(value))
        }
        return String(format: "%g", value)
    }
}

extension FertilizerType: Codable {
    enum CodingKeys: String, CodingKey {
        case id, brand, name, form, release, origin, npk, sortOrder, isActive
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        id = try c.decode(UUID.self, forKey: .id)
        brand = try c.decodeIfPresent(String.self, forKey: .brand) ?? ""
        name = try c.decode(String.self, forKey: .name)
        form = try c.decodeIfPresent(FertilizerForm.self, forKey: .form) ?? .pellet
        release = try c.decodeIfPresent(FertilizerRelease.self, forKey: .release) ?? .slowRelease
        origin = try c.decodeIfPresent(FertilizerOrigin.self, forKey: .origin) ?? .organic
        npk = try c.decodeIfPresent(String.self, forKey: .npk) ?? ""
        sortOrder = try c.decodeIfPresent(Int.self, forKey: .sortOrder) ?? 0
        isActive = try c.decodeIfPresent(Bool.self, forKey: .isActive) ?? true
    }

    func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(id, forKey: .id)
        try c.encode(brand, forKey: .brand)
        try c.encode(name, forKey: .name)
        try c.encode(form, forKey: .form)
        try c.encode(release, forKey: .release)
        try c.encode(origin, forKey: .origin)
        try c.encode(npk, forKey: .npk)
        try c.encode(sortOrder, forKey: .sortOrder)
        try c.encode(isActive, forKey: .isActive)
    }
}

/// Editor draft for Add / Edit Fertilizer Type.
struct FertilizerTypeDraft: Identifiable, Hashable, Sendable {
    var id: UUID
    var entityID: UUID?
    var brand: String
    var name: String
    var form: FertilizerForm
    var release: FertilizerRelease
    var origin: FertilizerOrigin
    var nitrogen: Double?
    var phosphorus: Double?
    var potassium: Double?
    var sortOrder: Int
    var isActive: Bool

    var isNew: Bool { entityID == nil }

    var npk: String {
        FertilizerType.formatNPK(n: nitrogen, p: phosphorus, k: potassium)
    }

    static func blank(sortOrder: Int) -> FertilizerTypeDraft {
        FertilizerTypeDraft(
            id: UUID(),
            entityID: nil,
            brand: "",
            name: "",
            form: .pellet,
            release: .slowRelease,
            origin: .organic,
            nitrogen: nil,
            phosphorus: nil,
            potassium: nil,
            sortOrder: sortOrder,
            isActive: true
        )
    }

    static func from(_ fertilizerType: FertilizerType) -> FertilizerTypeDraft {
        let parsed = FertilizerType.parseNPK(fertilizerType.npk)
        return FertilizerTypeDraft(
            id: UUID(),
            entityID: fertilizerType.id,
            brand: fertilizerType.brand,
            name: fertilizerType.name,
            form: fertilizerType.form,
            release: fertilizerType.release,
            origin: fertilizerType.origin,
            nitrogen: parsed.n,
            phosphorus: parsed.p,
            potassium: parsed.k,
            sortOrder: fertilizerType.sortOrder,
            isActive: fertilizerType.isActive
        )
    }
}
