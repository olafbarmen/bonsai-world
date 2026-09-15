//
//  ShapingAreaRecord.swift
//  Bonsai World
//
//  Working record for one Shaping area on a Tree.
//

import Foundation

struct ShapingAreaRecord: Codable, Hashable, Sendable {
    var status: ShapingAreaStatus
    var observation: String
    var developmentPlan: String
    var nextAction: String
    /// Inspiration / reference photos for this area — not tree gallery photos.
    var referenceImageIDs: [UUID]
    var history: [ShapingHistoryEntry]

    static let empty = ShapingAreaRecord()

    init(
        status: ShapingAreaStatus = .planned,
        observation: String = "",
        developmentPlan: String = "",
        nextAction: String = "",
        referenceImageIDs: [UUID] = [],
        history: [ShapingHistoryEntry] = []
    ) {
        self.status = status
        self.observation = observation
        self.developmentPlan = developmentPlan
        self.nextAction = nextAction
        self.referenceImageIDs = referenceImageIDs
        self.history = history
    }

    var hasContent: Bool {
        !observation.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            || !developmentPlan.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            || !nextAction.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            || !referenceImageIDs.isEmpty
            || !history.isEmpty
            || status != .planned
    }
}
