//
//  FertilizerCatalogMatcher.swift
//  Bonsai World
//
//  Maps FertilizerAdvice categories to the grower's Fertilizer Types.
//  Coarse heuristics only (origin / form / release / NPK) — not a dose engine.
//

import Foundation

enum FertilizerCatalogMatcher {
    /// Active catalog products that loosely fit the recommendation category.
    /// Prefer NPK when present; fall back to form/origin so the list is not empty.
    static func matchingTypes(
        from types: [FertilizerType],
        category: FertilizerCategory
    ) -> [FertilizerType] {
        let active = types.filter(\.isActive)
        guard category != .none else { return [] }

        let strict = active.filter { matchesStrict($0, category: category) }
        if !strict.isEmpty { return strict.sorted(by: displayNameSort) }

        let fallback = active.filter { matchesFallback($0, category: category) }
        return fallback.sorted(by: displayNameSort)
    }

    // MARK: - Strict

    private static func matchesStrict(_ type: FertilizerType, category: FertilizerCategory) -> Bool {
        switch category {
        case .none:
            return false
        case .organicSolid:
            return isOrganicSolid(type)
        case .liquidFeed:
            return type.form == .liquid
        case .seaweedSupplement:
            return type.displayName.localizedCaseInsensitiveContains("seaweed")
        case .humicSupport:
            return type.displayName.localizedCaseInsensitiveContains("humic")
        case .balanced:
            return isBalancedNPK(type)
        case .higherNitrogen:
            return isHigherNitrogen(type)
        case .lowerNitrogen:
            return isLowerNitrogen(type)
        }
    }

    private static func matchesFallback(_ type: FertilizerType, category: FertilizerCategory) -> Bool {
        switch category {
        case .none:
            return false
        case .organicSolid, .balanced, .higherNitrogen, .lowerNitrogen:
            return isOrganicSolid(type) || type.form == .liquid
        case .liquidFeed:
            return type.form == .liquid
        case .seaweedSupplement:
            return type.form == .liquid && type.origin == .organic
        case .humicSupport:
            return false
        }
    }

    private static func isOrganicSolid(_ type: FertilizerType) -> Bool {
        guard type.form != .liquid else { return false }
        switch type.origin {
        case .organic, .organicMineral:
            return true
        case .mineral:
            return type.release == .slowRelease
                && (type.form == .granular || type.form == .pellet)
        }
    }

    private static func isBalancedNPK(_ type: FertilizerType) -> Bool {
        guard let n = nitrogen(type), let p = phosphorus(type), let k = potassium(type) else {
            return false
        }
        let values = [n, p, k]
        guard let minV = values.min(), let maxV = values.max(), minV > 0 else { return false }
        return maxV / minV <= 1.75
    }

    private static func isHigherNitrogen(_ type: FertilizerType) -> Bool {
        guard let n = nitrogen(type), let p = phosphorus(type), let k = potassium(type) else {
            return false
        }
        return n > p && n > k
    }

    private static func isLowerNitrogen(_ type: FertilizerType) -> Bool {
        guard let n = nitrogen(type), let p = phosphorus(type), let k = potassium(type) else {
            return false
        }
        return n < p || n < k
    }

    private static func nitrogen(_ type: FertilizerType) -> Double? {
        FertilizerType.parseNPK(type.npk).n
    }

    private static func phosphorus(_ type: FertilizerType) -> Double? {
        FertilizerType.parseNPK(type.npk).p
    }

    private static func potassium(_ type: FertilizerType) -> Double? {
        FertilizerType.parseNPK(type.npk).k
    }

    private static func displayNameSort(_ lhs: FertilizerType, _ rhs: FertilizerType) -> Bool {
        lhs.displayName.localizedCaseInsensitiveCompare(rhs.displayName) == .orderedAscending
    }
}
