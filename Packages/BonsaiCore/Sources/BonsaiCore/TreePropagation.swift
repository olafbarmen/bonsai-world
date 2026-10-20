//
//  TreePropagation.swift
//  BonsaiCore
//
//  How the tree began. Distinct from Acquisition Method, which is how it
//  entered the collection.
//

import Foundation

enum TreePropagation: String, Codable, CaseIterable, Identifiable, Hashable, Sendable {
    case seed
    case cutting
    case airLayer
    case grafting
    case yamadori

    var id: Self { self }

    var title: String {
        switch self {
        case .seed: "Seed"
        case .cutting: "Cutting"
        case .airLayer: "Air Layer"
        case .grafting: "Grafting"
        case .yamadori: "Yamadori"
        }
    }
}
