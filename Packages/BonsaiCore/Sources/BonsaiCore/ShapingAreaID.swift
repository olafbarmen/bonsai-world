//
//  ShapingAreaID.swift
//  Bonsai World
//
//  Identifiers for practical Shaping / development areas on one Tree.
//

import Foundation

enum ShapingAreaGroup: String, CaseIterable, Identifiable, Sendable {
    case coreDesign
    case deadwoodAndTechnique
    case branchAndDevelopment

    var id: Self { self }

    var title: String {
        switch self {
        case .coreDesign: "Core Design"
        case .deadwoodAndTechnique: "Deadwood & Technique"
        case .branchAndDevelopment: "Branch & Development"
        }
    }

    var areas: [ShapingAreaID] {
        switch self {
        case .coreDesign:
            [
                .frontSelection, .nebari, .trunkMovement, .trunk, .taper,
                .primaryBranches, .secondaryBranches, .ramification, .apex, .overallSilhouette,
            ]
        case .deadwoodAndTechnique:
            [.deadwood, .shari, .jin, .bending, .wiring, .threadGrafting, .grafting]
        case .branchAndDevelopment:
            [.branchDevelopment]
        }
    }
}

enum ShapingAreaID: String, Codable, CaseIterable, Identifiable, Hashable, Sendable {
    case frontSelection
    case nebari
    case trunkMovement
    case trunk
    case taper
    case primaryBranches
    case secondaryBranches
    case ramification
    case apex
    case overallSilhouette
    case deadwood
    case shari
    case jin
    case bending
    case wiring
    case threadGrafting
    case grafting
    case branchDevelopment

    var id: Self { self }

    var title: String {
        switch self {
        case .frontSelection: "Front Selection"
        case .nebari: "Nebari"
        case .trunkMovement: "Trunk Movement"
        case .trunk: "Trunk"
        case .taper: "Taper"
        case .primaryBranches: "Primary Branches"
        case .secondaryBranches: "Secondary Branches"
        case .ramification: "Ramification"
        case .apex: "Apex"
        case .overallSilhouette: "Overall Silhouette"
        case .deadwood: "Deadwood"
        case .shari: "Shari"
        case .jin: "Jin"
        case .bending: "Bending"
        case .wiring: "Wiring"
        case .threadGrafting: "Thread Grafting"
        case .grafting: "Grafting"
        case .branchDevelopment: "Branch Development"
        }
    }

    static var allGrouped: [(ShapingAreaGroup, [ShapingAreaID])] {
        ShapingAreaGroup.allCases.map { ($0, $0.areas) }
    }
}
