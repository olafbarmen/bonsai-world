//
//  StratificationPhaseType.swift
//  BonsaiCore
//
//  Phase inside an ordered seed treatment sequence.
//

import Foundation

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
