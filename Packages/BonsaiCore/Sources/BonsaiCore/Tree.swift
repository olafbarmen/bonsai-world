//
//  Tree.swift
//  BonsaiCore
//
//  First shared domain slice for Bonsai World Mobile.
//  Identity fields match Mac `Tree` so library sync can converge later.
//  This is not yet the full Mac Tree model.
//

import Foundation

/// Shared tree identity used by the mobile app (demo / future sync).
public struct Tree: Identifiable, Codable, Hashable, Sendable {
    public var id: UUID
    public var botanicalName: String
    public var nickname: String
    public var bonsaiName: String
    public var notes: String
    public var healthStatus: TreeHealthStatus
    public var createdDate: Date
    public var modifiedDate: Date

    public init(
        id: UUID = UUID(),
        botanicalName: String,
        nickname: String = "",
        bonsaiName: String = "",
        notes: String = "",
        healthStatus: TreeHealthStatus = .stable,
        createdDate: Date = .now,
        modifiedDate: Date = .now
    ) {
        self.id = id
        self.botanicalName = botanicalName
        self.nickname = nickname
        self.bonsaiName = bonsaiName
        self.notes = notes
        self.healthStatus = healthStatus
        self.createdDate = createdDate
        self.modifiedDate = modifiedDate
    }

    public var displayTitle: String {
        let nick = nickname.trimmingCharacters(in: .whitespacesAndNewlines)
        if !nick.isEmpty { return nick }
        let botanical = botanicalName.trimmingCharacters(in: .whitespacesAndNewlines)
        if !botanical.isEmpty { return botanical }
        let code = bonsaiName.trimmingCharacters(in: .whitespacesAndNewlines)
        return code.isEmpty ? "Untitled Tree" : code
    }

    public var displaySubtitle: String {
        let botanical = botanicalName.trimmingCharacters(in: .whitespacesAndNewlines)
        let nick = nickname.trimmingCharacters(in: .whitespacesAndNewlines)
        if !nick.isEmpty, !botanical.isEmpty, nick != botanical {
            return botanical
        }
        let code = bonsaiName.trimmingCharacters(in: .whitespacesAndNewlines)
        return code
    }
}

/// Matches Mac `TreeHealthStatus` raw values.
public enum TreeHealthStatus: String, Codable, CaseIterable, Identifiable, Hashable, Sendable {
    case thriving
    case stable
    case needsAttention
    case recovering

    public var id: Self { self }

    public var title: String {
        switch self {
        case .thriving: "Thriving"
        case .stable: "Stable"
        case .needsAttention: "Needs Attention"
        case .recovering: "Recovering"
        }
    }
}
