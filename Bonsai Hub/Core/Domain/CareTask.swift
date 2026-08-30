//
//  CareTask.swift
//  Bonsai World
//
//  Tasks domain — planned/scheduled care, distinct from WorkRecord (history of
//  care already performed). See Product Blueprint §5.9 "Tasks vs. Work".
//
//  Named `CareTask`, not `Task`, to avoid clashing with Swift's concurrency `Task`.
//

import Foundation

enum CareTaskStatus: String, Codable, Hashable, Sendable, CaseIterable {
    case pending
    case completed
    case cancelled
}

/// A planned care activity for one or more Trees, tied to a Work Type so its
/// completion behaviour (instant vs. full Add Work form) is known in advance.
struct CareTask: Identifiable, Codable, Hashable, Sendable {
    var id: UUID
    var title: String
    /// Reference Data — Work Type. Drives completion behaviour
    /// (``WorkTypeBehaviourFlags/tasksCompleteInstantly``).
    var workTypeID: UUID
    /// One or more trees this task applies to.
    var treeIDs: [UUID]
    var dueDate: Date
    var notes: String
    var status: CareTaskStatus
    var completedAt: Date?
    /// The WorkRecord created when this task was completed, once known.
    var resultingWorkRecordID: UUID?

    var createdDate: Date
    var modifiedDate: Date

    init(
        id: UUID = UUID(),
        title: String,
        workTypeID: UUID,
        treeIDs: [UUID],
        dueDate: Date,
        notes: String = "",
        status: CareTaskStatus = .pending,
        completedAt: Date? = nil,
        resultingWorkRecordID: UUID? = nil,
        createdDate: Date = .now,
        modifiedDate: Date = .now
    ) {
        self.id = id
        self.title = title
        self.workTypeID = workTypeID
        self.treeIDs = treeIDs
        self.dueDate = dueDate
        self.notes = notes
        self.status = status
        self.completedAt = completedAt
        self.resultingWorkRecordID = resultingWorkRecordID
        self.createdDate = createdDate
        self.modifiedDate = modifiedDate
    }
}
