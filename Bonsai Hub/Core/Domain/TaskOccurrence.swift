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
    /// Tree target when this occurrence is tree-scoped.
    let treeID: UUID?
    /// Seed Batch target when this occurrence is nursery-scoped.
    let seedBatchID: UUID?
    /// Yamadori trip target when this occurrence is nursery-scoped.
    let yamadoriID: UUID?
    /// Nursery Propagation / Field Tree project target.
    let nurseryPropagationProjectID: UUID?
    /// Library inventory scope when this occurrence is not tree/nursery-scoped.
    let libraryInventoryKind: CareTaskLibraryInventoryKind?
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
    /// thing* to the *same subject* collapse into one row.
    struct DedupeKey: Hashable {
        let treeID: UUID?
        let seedBatchID: UUID?
        let yamadoriID: UUID?
        let nurseryPropagationProjectID: UUID?
        let libraryInventoryKind: CareTaskLibraryInventoryKind?
        let workTypeID: UUID
        let fertilizerTypeID: UUID?
        let dayPart: CareDayPart?
    }

    var dedupeKey: DedupeKey {
        DedupeKey(
            treeID: treeID,
            seedBatchID: seedBatchID,
            yamadoriID: yamadoriID,
            nurseryPropagationProjectID: nurseryPropagationProjectID,
            libraryInventoryKind: libraryInventoryKind,
            workTypeID: workTypeID,
            fertilizerTypeID: fertilizerTypeID,
            dayPart: dayPart
        )
    }

    /// One occurrence per Tree the Task covers (mirrors Schedules).
    init(task: CareTask, treeID: UUID, isInstant: Bool) {
        self.id = "\(task.id.uuidString)-\(treeID.uuidString)"
        self.source = .task(task)
        self.title = task.title
        self.workTypeID = task.workTypeID
        self.treeID = treeID
        self.seedBatchID = nil
        self.yamadoriID = nil
        self.nurseryPropagationProjectID = nil
        self.libraryInventoryKind = nil
        self.dueDate = task.dueDate
        self.fertilizerTypeID = nil
        self.dayPart = nil
        self.isInstant = isInstant
    }

    /// One occurrence per Seed Batch the Task covers.
    init(task: CareTask, seedBatchID: UUID, isInstant: Bool) {
        self.id = "\(task.id.uuidString)-seed-\(seedBatchID.uuidString)"
        self.source = .task(task)
        self.title = task.title
        self.workTypeID = task.workTypeID
        self.treeID = nil
        self.seedBatchID = seedBatchID
        self.yamadoriID = nil
        self.nurseryPropagationProjectID = nil
        self.libraryInventoryKind = nil
        self.dueDate = task.dueDate
        self.fertilizerTypeID = nil
        self.dayPart = nil
        self.isInstant = isInstant
    }

    /// One occurrence per Yamadori trip the Task covers.
    init(task: CareTask, yamadoriID: UUID, isInstant: Bool) {
        self.id = "\(task.id.uuidString)-yamadori-\(yamadoriID.uuidString)"
        self.source = .task(task)
        self.title = task.title
        self.workTypeID = task.workTypeID
        self.treeID = nil
        self.seedBatchID = nil
        self.yamadoriID = yamadoriID
        self.nurseryPropagationProjectID = nil
        self.libraryInventoryKind = nil
        self.dueDate = task.dueDate
        self.fertilizerTypeID = nil
        self.dayPart = nil
        self.isInstant = isInstant
    }

    /// One occurrence per Nursery Propagation / Field Tree project the Task covers.
    init(task: CareTask, nurseryPropagationProjectID: UUID, isInstant: Bool) {
        self.id = "\(task.id.uuidString)-prop-\(nurseryPropagationProjectID.uuidString)"
        self.source = .task(task)
        self.title = task.title
        self.workTypeID = task.workTypeID
        self.treeID = nil
        self.seedBatchID = nil
        self.yamadoriID = nil
        self.nurseryPropagationProjectID = nurseryPropagationProjectID
        self.libraryInventoryKind = nil
        self.dueDate = task.dueDate
        self.fertilizerTypeID = nil
        self.dayPart = nil
        self.isInstant = isInstant
    }

    /// Library inventory Task — one row for the whole library (no Tree).
    init(task: CareTask, libraryInventoryKind: CareTaskLibraryInventoryKind, isInstant: Bool) {
        self.id = "\(task.id.uuidString)-library-\(libraryInventoryKind.rawValue)"
        self.source = .task(task)
        self.title = task.title
        self.workTypeID = task.workTypeID
        self.treeID = nil
        self.seedBatchID = nil
        self.yamadoriID = nil
        self.nurseryPropagationProjectID = nil
        self.libraryInventoryKind = libraryInventoryKind
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
        self.seedBatchID = nil
        self.yamadoriID = nil
        self.nurseryPropagationProjectID = nil
        self.libraryInventoryKind = nil
        self.dueDate = dueDate
        self.fertilizerTypeID = schedule.fertilizerTypeID
        self.dayPart = dayPart
        self.isInstant = true
    }
}
