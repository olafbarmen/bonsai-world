//
//  TasksHorizon.swift
//  Bonsai World
//
//  Time-horizon grouping for the Tasks workspace (sidebar entries + TaskService
//  filtering). Pure domain enum — no UI dependencies.
//

import Foundation

enum TasksHorizon: String, CaseIterable, Identifiable, Sendable {
    /// Forgotten care that can still be done late (fertilizing, pruning, …).
    /// Work Types flagged `expiresIfMissed` (watering) never appear here.
    case overdue
    case today
    case thisWeek
    case thisMonth
    case thisYear
    /// Everything due after the current calendar year — one entry per
    /// Task/Schedule (its next due date only, however far out), so
    /// long-cadence work (e.g. repotting a Scots Pine every 4 years) always
    /// has a home and never silently disappears just because it isn't due
    /// "this year".
    case nextYear

    var id: Self { self }

    var title: String {
        switch self {
        case .overdue: "Overdue"
        case .today: "Today"
        case .thisWeek: "This Week"
        case .thisMonth: "This Month"
        case .thisYear: "This Year"
        case .nextYear: "Next Year"
        }
    }
}
