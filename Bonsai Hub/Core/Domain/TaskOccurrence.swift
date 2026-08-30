//
//  TaskOccurrence.swift
//  Bonsai World
//
//  Tasks workspace — a single actionable row, either a one-off CareTask or a
//  computed due occurrence of a recurring CareSchedule (never persisted; see
//  ``TaskService/pendingOccurrences(due:)``). The Tasks workspace renders and
//  completes both uniformly through this type.
//

import Foundation

struct TaskOccurrence: Identifiable, Hashable, Sendable {
    enum Source: Hashable, Sendable {
        case task(CareTask)
        case schedule(scheduleID: UUID)
    }

    let id: String
    let source: Source
    let title: String
    let workTypeID: UUID
    let treeID: UUID
    let dueDate: Date
    /// Fixes which fertilizer product this occurrence uses, when the source
    /// schedule pins one. Part of the de-duplication key — see
    /// ``TaskService/pendingOccurrences(due:)``.
    let fertilizerTypeID: UUID?
    /// Present only for "multiple times a day" schedules.
    let dayPart: CareDayPart?
    /// Whether completing this occurrence can skip the Add Work form —
    /// always true for schedules (every detail is pre-decided); for one-off
    /// Tasks, mirrors the Work Type's `tasksCompleteInstantly` flag.
    let isInstant: Bool

    var isRecurring: Bool {
        if case .schedule = source { return true }
        return false
    }

    /// De-duplication key: two occurrences that would do the *same physical
    /// thing* to the *same tree* collapse into one row, however many Tasks or
    /// Schedules independently produced them (e.g. a Tree-level watering rule
    /// and a Location-level watering rule covering the same tree).
    struct DedupeKey: Hashable {
        let treeID: UUID
        let workTypeID: UUID
        let fertilizerTypeID: UUID?
        let dayPart: CareDayPart?
    }

    var dedupeKey: DedupeKey {
        DedupeKey(treeID: treeID, workTypeID: workTypeID, fertilizerTypeID: fertilizerTypeID, dayPart: dayPart)
    }

    /// One occurrence per Tree the Task covers (mirrors Schedules) — a Task
    /// created for several Trees at once surfaces once per Tree, so it shows
    /// up correctly in every one of those Trees' "Upcoming Tasks" and
    /// participates in de-duplication per Tree. Completing any one of them
    /// still completes the whole underlying Task (all Trees at once) — see
    /// ``TaskService/completeTaskInstantly(_:)``.
    init(task: CareTask, treeID: UUID, isInstant: Bool) {
        self.id = "\(task.id.uuidString)-\(treeID.uuidString)"
        self.source = .task(task)
        self.title = task.title
        self.workTypeID = task.workTypeID
        self.treeID = treeID
        self.dueDate = task.dueDate
        self.fertilizerTypeID = nil
        self.dayPart = nil
        self.isInstant = isInstant
    }

    init(schedule: CareSchedule, treeID: UUID, dueDate: Date, dayPart: CareDayPart? = nil) {
        if let dayPart {
            self.id = "\(schedule.id.uuidString)-\(treeID.uuidString)-\(dayPart.rawValue)"
            self.title = "\(schedule.title) — \(dayPart.title)"
        } else {
            self.id = "\(schedule.id.uuidString)-\(treeID.uuidString)"
            self.title = schedule.title
        }
        self.source = .schedule(scheduleID: schedule.id)
        self.workTypeID = schedule.workTypeID
        self.treeID = treeID
        self.dueDate = dueDate
        self.fertilizerTypeID = schedule.fertilizerTypeID
        self.dayPart = dayPart
        self.isInstant = true
    }
}
