//
//  JournalEntry.swift
//  Bonsai World
//
//  Tree-scoped journal note — narrative, not a substitute for Work / Measurement / Photo.
//  Timeline and Tree History consume these entries; they do not own registration.
//

import Foundation

/// One dated journal note for a single Tree.
struct JournalEntry: Identifiable, Codable, Hashable, Sendable {
    var id: UUID
    var treeID: UUID
    /// When the note applies (grower-facing date).
    var recordedAt: Date
    var text: String
    /// True when the note describes history before this tree entered the grower’s care.
    var isBeforeOwnership: Bool
    var createdDate: Date
    var modifiedDate: Date

    init(
        id: UUID = UUID(),
        treeID: UUID,
        recordedAt: Date = .now,
        text: String,
        isBeforeOwnership: Bool = false,
        createdDate: Date = .now,
        modifiedDate: Date = .now
    ) {
        self.id = id
        self.treeID = treeID
        self.recordedAt = recordedAt
        self.text = text
        self.isBeforeOwnership = isBeforeOwnership
        self.createdDate = createdDate
        self.modifiedDate = modifiedDate
    }
}
