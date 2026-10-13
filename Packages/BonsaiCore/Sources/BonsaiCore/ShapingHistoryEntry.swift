//
//  ShapingHistoryEntry.swift
//  Bonsai World
//
//  One dated event in a Shaping area — append-only chronological history.
//

import Foundation

struct ShapingHistoryEntry: Identifiable, Codable, Hashable, Sendable {
    var id: UUID
    var date: Date
    var description: String
    var imageIDs: [UUID]
    /// Optional intent from legacy Vision characteristics (Preserve / Develop / Change).
    var intent: VisionCharacteristicKind?
    var linkedTaskID: UUID?
    var linkedWorkRecordID: UUID?

    init(
        id: UUID = UUID(),
        date: Date = .now,
        description: String,
        imageIDs: [UUID] = [],
        intent: VisionCharacteristicKind? = nil,
        linkedTaskID: UUID? = nil,
        linkedWorkRecordID: UUID? = nil
    ) {
        self.id = id
        self.date = date
        self.description = description
        self.imageIDs = imageIDs
        self.intent = intent
        self.linkedTaskID = linkedTaskID
        self.linkedWorkRecordID = linkedWorkRecordID
    }

    var sortedForDisplay: Bool { true }

    static func sortedNewestFirst(_ entries: [ShapingHistoryEntry]) -> [ShapingHistoryEntry] {
        entries.sorted { $0.date > $1.date }
    }

    static func sortedOldestFirst(_ entries: [ShapingHistoryEntry]) -> [ShapingHistoryEntry] {
        entries.sorted { $0.date < $1.date }
    }
}
