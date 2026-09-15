//
//  TaskWorkTypeSummary.swift
//  Bonsai World
//
//  Aggregated pending TaskOccurrence counts by Work Type for a TasksHorizon.
//  Shared by Dashboard Tasks (and later Upcoming) — not a separate task store.
//

import Foundation

struct TaskWorkTypeSummary: Identifiable, Hashable, Sendable {
    let workTypeID: UUID
    let name: String
    let count: Int
    let categorySortOrder: Int
    let workTypeSortOrder: Int

    var id: UUID { workTypeID }
}
