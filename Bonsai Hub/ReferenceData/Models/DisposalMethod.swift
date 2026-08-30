//
//  DisposalMethod.swift
//  Bonsai World
//
//  Reference Data — how ownership of a tree ended.
//

import Foundation

/// Stable lifecycle group for a disposal method. Survives a renamed display name
/// (e.g. Died → Død) so Smart Collections and Dashboard keep grouping correctly.
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

struct DisposalMethod: ReferenceListItem {
    var id: UUID
    var name: String
    var sortOrder: Int
    var isActive: Bool
    var outcome: DisposalOutcome

    init(id: UUID = UUID(), name: String, sortOrder: Int, isActive: Bool = true) {
        self.id = id
        self.name = name
        self.sortOrder = sortOrder
        self.isActive = isActive
        self.outcome = DisposalOutcome.inferred(from: name)
    }

    init(
        id: UUID = UUID(),
        name: String,
        sortOrder: Int,
        isActive: Bool = true,
        outcome: DisposalOutcome
    ) {
        self.id = id
        self.name = name
        self.sortOrder = sortOrder
        self.isActive = isActive
        self.outcome = outcome
    }

    enum CodingKeys: String, CodingKey {
        case id, name, sortOrder, isActive, outcome
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        sortOrder = try container.decode(Int.self, forKey: .sortOrder)
        isActive = try container.decodeIfPresent(Bool.self, forKey: .isActive) ?? true
        if let stored = try container.decodeIfPresent(DisposalOutcome.self, forKey: .outcome) {
            outcome = stored
        } else {
            outcome = DisposalOutcome.inferred(from: name)
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(sortOrder, forKey: .sortOrder)
        try container.encode(isActive, forKey: .isActive)
        try container.encode(outcome, forKey: .outcome)
    }
}
