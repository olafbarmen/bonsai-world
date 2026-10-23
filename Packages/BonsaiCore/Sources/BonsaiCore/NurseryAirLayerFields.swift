//
//  NurseryAirLayerFields.swift
//  BonsaiCore
//
//  Air Layer technique enums — Method / Medium / Wrap stay separate.
//

import Foundation

enum NurseryAirLayerMethod: String, Codable, CaseIterable, Identifiable, Hashable, Sendable {
    case completeRing
    case partialRing
    case tourniquet
    case wedgeNotch
    case other

    var id: Self { self }

    var title: String {
        switch self {
        case .completeRing: "Complete Ring (Girdle)"
        case .partialRing: "Partial Ring"
        case .tourniquet: "Tourniquet"
        case .wedgeNotch: "Wedge / Notch"
        case .other: "Other"
        }
    }
}

enum NurseryAirLayerLocation: String, Codable, CaseIterable, Identifiable, Hashable, Sendable {
    case trunk
    case primaryBranch
    case secondaryBranch
    case leaderApex
    case rootNebari
    case other

    var id: Self { self }

    var title: String {
        switch self {
        case .trunk: "Trunk"
        case .primaryBranch: "Primary Branch"
        case .secondaryBranch: "Secondary Branch"
        case .leaderApex: "Leader / Apex"
        case .rootNebari: "Root / Nebari"
        case .other: "Other"
        }
    }
}

enum NurseryAirLayerRootingAid: String, Codable, CaseIterable, Identifiable, Hashable, Sendable {
    case none
    case rootingHormone
    case other

    var id: Self { self }

    var title: String {
        switch self {
        case .none: "None"
        case .rootingHormone: "Rooting Hormone"
        case .other: "Other"
        }
    }
}

enum NurseryAirLayerMediumPreset: String, Codable, CaseIterable, Identifiable, Hashable, Sendable {
    case longFiberSphagnum
    case sphagnumMix
    case granularMix
    case custom

    var id: Self { self }

    var title: String {
        switch self {
        case .longFiberSphagnum: "Long-fiber Sphagnum"
        case .sphagnumMix: "Sphagnum Mix"
        case .granularMix: "Granular Mix"
        case .custom: "Custom"
        }
    }
}

enum NurseryAirLayerWrapSystem: String, Codable, CaseIterable, Identifiable, Hashable, Sendable {
    case plasticFilm
    case plasticPlusFoil
    case foil
    case airLayerPot
    case other

    var id: Self { self }

    var title: String {
        switch self {
        case .plasticFilm: "Plastic Film"
        case .plasticPlusFoil: "Plastic + Foil"
        case .foil: "Foil"
        case .airLayerPot: "Air Layer Pot"
        case .other: "Other"
        }
    }
}

enum NurseryAirLayerPurpose: String, Codable, CaseIterable, Identifiable, Hashable, Sendable {
    case createNewBonsai
    case improveNebari
    case removeInverseTaper
    case reduceTrunkHeight
    case improveTrunkMovement
    case separateBranch
    case propagation
    case experimental
    case other

    var id: Self { self }

    var title: String {
        switch self {
        case .createNewBonsai: "Create New Bonsai"
        case .improveNebari: "Improve Nebari"
        case .removeInverseTaper: "Remove Inverse Taper"
        case .reduceTrunkHeight: "Reduce Trunk Height"
        case .improveTrunkMovement: "Improve Trunk Movement"
        case .separateBranch: "Separate a Branch"
        case .propagation: "Propagation"
        case .experimental: "Experimental"
        case .other: "Other"
        }
    }
}

enum NurseryAirLayerRootDevelopment: String, Codable, CaseIterable, Identifiable, Hashable, Sendable {
    case noRoots
    case callusOnly
    case earlyRoots
    case developingRoots
    case rootMassEstablished
    case readyToSeparate

    var id: Self { self }

    var title: String {
        switch self {
        case .noRoots: "No Roots"
        case .callusOnly: "Callus Only"
        case .earlyRoots: "Early Roots"
        case .developingRoots: "Developing Roots"
        case .rootMassEstablished: "Root Mass Established"
        case .readyToSeparate: "Ready to Separate"
        }
    }
}

enum NurseryAirLayerMoisture: String, Codable, CaseIterable, Identifiable, Hashable, Sendable {
    case dry
    case slightlyDry
    case good
    case wet
    case tooWet

    var id: Self { self }

    var title: String {
        switch self {
        case .dry: "Dry"
        case .slightlyDry: "Slightly Dry"
        case .good: "Good"
        case .wet: "Wet"
        case .tooWet: "Too Wet"
        }
    }
}
