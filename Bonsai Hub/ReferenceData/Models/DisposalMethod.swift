//
//  DisposalMethod.swift
//  Bonsai World
//
//  Reference Data — how ownership of a tree ended.
//

import Foundation

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
