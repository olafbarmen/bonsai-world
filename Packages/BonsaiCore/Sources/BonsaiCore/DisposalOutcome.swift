//
//  DisposalOutcome.swift
//  Bonsai World
//
//  Stable lifecycle group for how ownership of a tree ended.
//  Survives a renamed display name (e.g. Died → Død) so Smart Collections
//  and Dashboard keep grouping correctly.
//

import Foundation

enum DisposalOutcome: String, Codable, Hashable, Sendable, CaseIterable {
    case sold
    case gifted
    case donated
    case exchanged
    case died
    case lost
    case other

    var dashboardLabel: String {
        switch self {
        case .sold: "Sold"
        case .gifted: "Gifted"
        case .donated: "Donated"
        case .exchanged: "Exchanged"
        case .died: "Died"
        case .lost: "Lost"
        case .other: "Other"
        }
    }

    /// Infer from the authored name when a stored outcome is missing.
    static func inferred(from name: String) -> DisposalOutcome {
        let key = name.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        switch key {
        case "sold", "solgt":
            return .sold
        case "gifted", "gave bort", "gitt bort", "gift":
            return .gifted
        case "donated", "donert":
            return .donated
        case "exchanged", "byttet", "bytte":
            return .exchanged
        case "died", "dead", "død", "dode", "døde":
            return .died
        case "lost", "mistet":
            return .lost
        default:
            return .other
        }
    }
}
