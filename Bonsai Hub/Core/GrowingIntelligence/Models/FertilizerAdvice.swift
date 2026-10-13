//
//  FertilizerAdvice.swift
//  Bonsai World
//
//  Fertilizing domain — explorer inputs, tree groups, and structured advice.
//  Species map to groups. The engine decides. Views only display.
//  Not a dosage. Not AI.
//

import Foundation

// MARK: - Query

/// Explorer inputs for Care → Fertilizing. Not a Tree record.
struct FertilizerQuery: Hashable, Sendable {
    var kind: FertilizerKind
    var stage: FertilizerStage
    var season: FertilizerSeason
    var growth: FertilizerGrowth
    var health: FertilizerHealth
    /// When true, feeding is always suppressed (newly collected yamadori safety rule).
    var isNewlyCollectedYamadori: Bool

    init(
        kind: FertilizerKind,
        stage: FertilizerStage,
        season: FertilizerSeason,
        growth: FertilizerGrowth,
        health: FertilizerHealth = .healthy,
        isNewlyCollectedYamadori: Bool = false
    ) {
        self.kind = kind
        self.stage = stage
        self.season = season
        self.growth = growth
        self.health = health
        self.isNewlyCollectedYamadori = isNewlyCollectedYamadori
    }

    var treeGroup: FertilizerTreeGroup { kind.treeGroup }
}

// MARK: - Stage, season, growth, health

// `FertilizerKind`, `FertilizerTreeGroup`, and `FertilizerHealth` live in BonsaiCore.

enum FertilizerStage: String, Codable, CaseIterable, Identifiable, Hashable, Sendable {
    case development
    case establishment
    case refinement

    var id: Self { self }

    var title: String {
        switch self {
        case .development: "Development"
        case .establishment: "Establishment & Recovery"
        case .refinement: "Refinement"
        }
    }

    var goal: String {
        switch self {
        case .development: "Build trunk, branches, roots and overall strength"
        case .establishment: "Build strength without pushing recovery"
        case .refinement: "Control growth — shorter internodes and finer ramification"
        }
    }

    var intent: String {
        switch self {
        case .development: "Feed for growth"
        case .establishment: "Feed for establishment"
        case .refinement: "Feed for control"
        }
    }
}

enum FertilizerSeason: String, CaseIterable, Identifiable, Hashable, Sendable {
    case spring
    case summer
    case lateSummer
    case fall
    case winter

    var id: Self { self }

    var title: String {
        switch self {
        case .spring: "Spring"
        case .summer: "Summer"
        case .lateSummer: "Late summer"
        case .fall: "Fall"
        case .winter: "Winter"
        }
    }
}

enum FertilizerGrowth: String, Codable, CaseIterable, Identifiable, Hashable, Sendable {
    case dormant
    case budsSwelling
    case budsOpening
    case activeExtension
    case firstFlushHardened
    case secondFlushDeveloping
    case postDecandling
    case preparingForDormancy
    case noActiveGrowth

    var id: Self { self }

    var title: String {
        switch self {
        case .dormant: "Dormant"
        case .budsSwelling: "Buds swelling"
        case .budsOpening: "Buds opening"
        case .activeExtension: "Active extension"
        case .firstFlushHardened: "First flush hardened"
        case .secondFlushDeveloping: "Second flush developing"
        case .postDecandling: "After decandling"
        case .preparingForDormancy: "Preparing for dormancy"
        case .noActiveGrowth: "No visible growth"
        }
    }

    var isInactive: Bool {
        switch self {
        case .dormant, .noActiveGrowth, .preparingForDormancy: true
        default: false
        }
    }

    var showsClearRecovery: Bool {
        switch self {
        case .activeExtension, .firstFlushHardened, .secondFlushDeveloping: true
        default: false
        }
    }

    var isActivelyGrowing: Bool {
        switch self {
        case .budsOpening, .activeExtension, .firstFlushHardened, .secondFlushDeveloping: true
        default: false
        }
    }
}

// MARK: - Intensity and category

enum FertilizerIntensity: Int, CaseIterable, Identifiable, Hashable, Sendable, Comparable {
    case none = 0
    case pauseHold = 1
    case veryCautious = 2
    case low = 3
    case lowToModerate = 4
    case moderate = 5
    case moderateToHigher = 6
    case higher = 7

    var id: Self { self }

    var title: String {
        switch self {
        case .none: "None"
        case .pauseHold: "Pause / Hold"
        case .veryCautious: "Very Cautious"
        case .low: "Low"
        case .lowToModerate: "Low to Moderate"
        case .moderate: "Moderate"
        case .moderateToHigher: "Moderate to Higher"
        case .higher: "Higher"
        }
    }

    static func < (lhs: FertilizerIntensity, rhs: FertilizerIntensity) -> Bool {
        lhs.rawValue < rhs.rawValue
    }

    func capped(at maximum: FertilizerIntensity) -> FertilizerIntensity {
        min(self, maximum)
    }
}

enum FertilizerCategory: String, CaseIterable, Identifiable, Hashable, Sendable {
    case none
    case organicSolid
    case balanced
    case higherNitrogen
    case lowerNitrogen
    case liquidFeed
    case seaweedSupplement
    case humicSupport

    var id: Self { self }

    var title: String {
        switch self {
        case .none: "None"
        case .organicSolid: "Organic Solid / Slow-release"
        case .balanced: "Balanced Fertilizer"
        case .higherNitrogen: "Higher Nitrogen"
        case .lowerNitrogen: "Lower Nitrogen"
        case .liquidFeed: "Liquid Feed"
        case .seaweedSupplement: "Seaweed Supplement"
        case .humicSupport: "Humic / Micronutrient Support"
        }
    }

    var isPrimaryNutrient: Bool {
        switch self {
        case .organicSolid, .balanced, .higherNitrogen, .lowerNitrogen, .liquidFeed: true
        default: false
        }
    }
}

// MARK: - Advice

struct FertilizerAdvice: Hashable, Sendable {
    var intensity: FertilizerIntensity
    var category: FertilizerCategory
    var goal: String
    var whenToStart: String
    var rhythm: String?
    var seaweed: String
    var humic: String
    var caution: String
    var explanation: String
    var isPaused: Bool
    var shouldWaitForGrowth: Bool
    var isFeeding: Bool

    var summary: String {
        if isPaused { return FertilizerIntensity.pauseHold.title }
        if shouldWaitForGrowth { return "Wait for clear recovery" }
        if intensity == .none { return "Do not fertilize" }
        return "\(intensity.title) feeding"
    }

    var strength: String { intensity.title }

    var fertilizerLine: String { category.title }

    var organicSolid: String {
        if !isFeeding || isPaused || intensity == .none {
            if isPaused {
                return "None. Remove dry fertilizer where appropriate. Stop liquid feeding."
            }
            return "None"
        }
        let rhythmText = rhythm ?? FertilizerRhythm.organicSolidGuidance
        return "\(category.title). \(rhythmText)"
    }

    static let followTheLabel =
        "Follow the product label for actual application rate and frequency."
}

enum FertilizerRhythm {
    static let organicSolidGuidance =
        "Approximately 4–6 weeks where appropriate. This is a rhythm, not a dosage."
}
