//
//  SoilMixContext.swift
//  Bonsai World
//
//  Mix applicability is contextual — never a species. Yamadori is a condition,
//  not a taxonomic value.
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
