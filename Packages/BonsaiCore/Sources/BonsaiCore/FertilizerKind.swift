//
//  FertilizerKind.swift
//  Bonsai World
//
//  Grower-facing kind of tree for fertilization. Stored on Tree as an optional override.
//  Species map to groups. The engine decides. Views only display.
//

import Foundation

/// Grower-facing kind of tree. Add a case and map it to a group — do not rewrite the engine.
enum FertilizerKind: String, Codable, CaseIterable, Identifiable, Hashable, Sendable {
    case pineSingleFlush
    case pineDoubleFlush
    case juniper
    case spruceFir
    case larch
    case japaneseMaple
    case tridentMaple
    case beech

    var id: Self { self }

    var title: String {
        switch self {
        case .pineSingleFlush: "Pine – Single Flush"
        case .pineDoubleFlush: "Pine – Double Flush"
        case .juniper: "Juniper"
        case .spruceFir: "Spruce / Fir"
        case .larch: "Larch"
        case .japaneseMaple: "Japanese Maple"
        case .tridentMaple: "Trident Maple"
        case .beech: "Beech"
        }
    }

    var treeGroup: FertilizerTreeGroup {
        switch self {
        case .pineSingleFlush: .pineSingleFlush
        case .pineDoubleFlush: .pineDoubleFlush
        case .juniper: .juniper
        case .spruceFir: .spruceFir
        case .larch: .larch
        case .japaneseMaple, .tridentMaple: .deciduousDefoliationTolerant
        case .beech: .deciduousNoDefoliation
        }
    }

    var watchFor: String {
        switch treeGroup {
        case .pineSingleFlush, .pineDoubleFlush: "Candles and needle length"
        case .juniper: "New shoots"
        case .spruceFir: "New growth"
        case .larch: "Needle emergence"
        case .deciduousDefoliationTolerant: "Shoot extension"
        case .deciduousNoDefoliation: "Leaf and shoot growth"
        }
    }

    /// Maps a botanical binomial onto a kind when the name is known.
    /// Unknown species return nil — they need an explicit mapping, not a guess.
    static func kind(matchingSpeciesName name: String) -> FertilizerKind? {
        let lowered = name.lowercased()
        if lowered.contains("thunbergii") || lowered.contains("densiflora") {
            return .pineDoubleFlush
        }
        if lowered.contains("parviflora") || lowered.contains("mugo") || lowered.contains("sylvestris") || lowered.contains("pinus") {
            return .pineSingleFlush
        }
        if lowered.contains("juniper") {
            return .juniper
        }
        if lowered.contains("picea") || lowered.contains("abies") {
            return .spruceFir
        }
        if lowered.contains("larix") {
            return .larch
        }
        if lowered.contains("buergerianum") {
            return .tridentMaple
        }
        if lowered.contains("palmatum") || lowered.contains("japonicum") {
            return .japaneseMaple
        }
        if lowered.contains("fagus") {
            return .beech
        }
        return nil
    }
}

/// Engine grouping. Species never get their own algorithm.
enum FertilizerTreeGroup: String, CaseIterable, Identifiable, Hashable, Sendable {
    case pineSingleFlush
    case pineDoubleFlush
    case juniper
    case spruceFir
    case larch
    case deciduousDefoliationTolerant
    case deciduousNoDefoliation

    var id: Self { self }

    var title: String {
        switch self {
        case .pineSingleFlush: "Pine – Single Flush"
        case .pineDoubleFlush: "Pine – Double Flush"
        case .juniper: "Juniper"
        case .spruceFir: "Spruce / Fir"
        case .larch: "Larch"
        case .deciduousDefoliationTolerant: "Deciduous – Defoliation Tolerant"
        case .deciduousNoDefoliation: "Deciduous – No Defoliation Strategy"
        }
    }

    var isPine: Bool {
        self == .pineSingleFlush || self == .pineDoubleFlush
    }

    var isDeciduous: Bool {
        self == .deciduousDefoliationTolerant || self == .deciduousNoDefoliation
    }
}
