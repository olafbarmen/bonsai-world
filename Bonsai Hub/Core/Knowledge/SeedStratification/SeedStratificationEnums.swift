//
//  SeedStratificationEnums.swift
//  Bonsai World
//
//  Strongly typed vocabulary for seed stratification profiles.
//  Settings → Bonsai Knowledge → Seed Stratification is the single source of truth.
//

import Foundation

enum DormancyType: String, Codable, Hashable, Sendable, CaseIterable, Identifiable {
    case noneOrMinimal
    case physical
    case physiological
    case morphological
    case morphophysiological
    case combined
    case variable
    case unknown

    var id: Self { self }

    var title: String {
        switch self {
        case .noneOrMinimal: "None or minimal"
        case .physical: "Physical"
        case .physiological: "Physiological"
        case .morphological: "Morphological"
        case .morphophysiological: "Morphophysiological"
        case .combined: "Combined"
        case .variable: "Variable"
        case .unknown: "Unknown"
        }
    }
}

/// Summary treatment family for a species profile.
enum StratificationTreatmentType: String, Codable, Hashable, Sendable, CaseIterable, Identifiable {
    case none
    case coldStratification
    case warmStratification
    case warmThenCold
    case coldThenWarm
    case scarification
    case soaking
    case combined
    case variable

    var id: Self { self }

    var title: String {
        switch self {
        case .none: "No pretreatment normally required"
        case .coldStratification: "Cold moist stratification"
        case .warmStratification: "Warm stratification"
        case .warmThenCold: "Warm → Cold stratification"
        case .coldThenWarm: "Cold → Warm stratification"
        case .scarification: "Scarification"
        case .soaking: "Soaking"
        case .combined: "Combined treatment"
        case .variable: "Variable"
        }
    }
}

/// Phase inside an ordered treatment sequence.
enum StratificationPhaseType: String, Codable, Hashable, Sendable, CaseIterable, Identifiable {
    case none
    case scarification
    case soaking
    case warmStratification
    case coldStratification
    case germination
    case other

    var id: Self { self }

    var title: String {
        switch self {
        case .none: "No treatment"
        case .scarification: "Scarification"
        case .soaking: "Soaking / hydration"
        case .warmStratification: "Warm stratification"
        case .coldStratification: "Cold stratification"
        case .germination: "Germination"
        case .other: "Other"
        }
    }
}

enum StratificationConfidenceLevel: String, Codable, Hashable, Sendable, CaseIterable, Identifiable {
    case high
    case moderate
    case variable
    case limited

    var id: Self { self }

    var title: String {
        switch self {
        case .high: "High"
        case .moderate: "Moderate"
        case .variable: "Variable"
        case .limited: "Limited"
        }
    }

    var summary: String {
        switch self {
        case .high:
            "Strong support from authoritative horticultural, forestry, or scientific sources."
        case .moderate:
            "Supported by multiple credible sources, but some variation exists."
        case .variable:
            "Significant variation between species, provenance, seed condition, or sources."
        case .limited:
            "Insufficient reliable information to provide a strong recommendation."
        }
    }

    var systemImage: String {
        switch self {
        case .high: "checkmark.seal"
        case .moderate: "checkmark.circle"
        case .variable: "arrow.left.arrow.right.circle"
        case .limited: "questionmark.circle"
        }
    }
}

enum MoistureLevel: String, Codable, Hashable, Sendable, CaseIterable, Identifiable {
    case moist
    case moderatelyMoist
    case veryMoist
    case variable

    var id: Self { self }

    var title: String {
        switch self {
        case .moist: "Moist"
        case .moderatelyMoist: "Moderately moist"
        case .veryMoist: "Very moist"
        case .variable: "Variable"
        }
    }
}

enum StratificationSourceType: String, Codable, Hashable, Sendable, CaseIterable, Identifiable {
    case government
    case university
    case scientificPaper
    case forestryManual
    case botanicalInstitution
    case horticulturalOrganization
    case secondaryReference

    var id: Self { self }

    var title: String {
        switch self {
        case .government: "Government"
        case .university: "University"
        case .scientificPaper: "Scientific paper"
        case .forestryManual: "Forestry manual"
        case .botanicalInstitution: "Botanical institution"
        case .horticulturalOrganization: "Horticultural organization"
        case .secondaryReference: "Secondary reference"
        }
    }
}

/// Knowledge-page treatment cards (educational — not the species matrix).
enum StratificationMethod: String, Codable, Hashable, Sendable, CaseIterable, Identifiable {
    case none
    case coldMoist
    case warm
    case warmThenCold
    case scarification
    case combined

    var id: Self { self }

    var title: String {
        switch self {
        case .none: "No stratification"
        case .coldMoist: "Cold moist stratification"
        case .warm: "Warm stratification"
        case .warmThenCold: "Warm → Cold stratification"
        case .scarification: "Scarification"
        case .combined: "Combined treatment"
        }
    }

    var systemImage: String {
        switch self {
        case .none: "leaf"
        case .coldMoist: "thermometer.snowflake"
        case .warm: "thermometer.sun"
        case .warmThenCold: "arrow.left.arrow.right"
        case .scarification: "scissors"
        case .combined: "list.number"
        }
    }
}

enum StratificationDifficulty: String, Codable, Hashable, Sendable, CaseIterable, Identifiable {
    case straightforward
    case moderate
    case demanding
    case unknown

    var id: Self { self }

    var title: String {
        switch self {
        case .straightforward: "Straightforward"
        case .moderate: "Moderate"
        case .demanding: "Demanding"
        case .unknown: "Unknown"
        }
    }
}
