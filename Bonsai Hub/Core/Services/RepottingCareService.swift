//
//  RepottingCareService.swift
//  Bonsai World
//
//  Auto repotting Schedule from Tree.lastRepottedDate + repottingIntervalYears.
//  Next due is snapped into March–May (grower season).
//

import Foundation
import Observation

@Observable
@MainActor
final class RepottingCareService {
    static let scheduleTitle = "Repotting"
    static let seasonFromMonth = 3
    static let seasonToMonth = 5
    static let seasonNote = "Repotting season is March–May. Next due is placed in that window."

    private let treeService: TreeService
    private let taskService: TaskService
    private let workService: WorkService

    init(treeService: TreeService, taskService: TaskService, workService: WorkService) {
        self.treeService = treeService
        self.taskService = taskService
        self.workService = workService
    }

    /// Snap a raw due date into March–May (same calendar year, or next March if after May).
    static func clampToRepottingSeason(_ date: Date, calendar: Calendar = .current) -> Date {
        let month = calendar.component(.month, from: date)
        let year = calendar.component(.year, from: date)
        if (seasonFromMonth...seasonToMonth).contains(month) {
            return calendar.startOfDay(for: date)
        }
        if month < seasonFromMonth {
            return calendar.date(from: DateComponents(year: year, month: seasonFromMonth, day: 1))
                ?? calendar.startOfDay(for: date)
        }
        return calendar.date(from: DateComponents(year: year + 1, month: seasonFromMonth, day: 1))
            ?? calendar.startOfDay(for: date)
    }

    /// Create / update / remove the auto Schedule for one tree.
    func syncSchedule(for treeID: UUID) throws {
        guard let tree = treeService.getTree(id: treeID), tree.isInCare else {
            try removeAutoSchedule(for: treeID)
            return
        }

        guard let interval = tree.repottingIntervalYears, interval >= 1,
              let lastRepotted = tree.lastRepottedDate,
              let workTypeID = workService.preferredRepottingWorkTypeID()
        else {
            try removeAutoSchedule(for: treeID)
            return
        }

        try ensureBaselineWork(treeID: treeID, lastRepotted: lastRepotted, workTypeID: workTypeID)

        let recurrence = CareRecurrenceRule(unit: .year, interval: interval)
        if var existing = autoSchedule(for: treeID) {
            var changed = false
            if existing.recurrence.interval != interval || existing.recurrence.unit != .year {
                existing.recurrence = recurrence
                changed = true
            }
            if existing.workTypeID != workTypeID {
                existing.workTypeID = workTypeID
                changed = true
            }
            if existing.title != Self.scheduleTitle {
                existing.title = Self.scheduleTitle
                changed = true
            }
            if existing.notes != Self.seasonNote {
                existing.notes = Self.seasonNote
                changed = true
            }
            if !existing.isActive {
                existing.isActive = true
                changed = true
            }
            if existing.systemKind != .autoRepotting {
                existing.systemKind = .autoRepotting
                changed = true
            }
            if changed {
                existing.modifiedDate = .now
                _ = try taskService.updateSchedule(existing)
            }
            return
        }

        _ = try taskService.createSchedule(
            title: Self.scheduleTitle,
            workTypeID: workTypeID,
            target: .trees(Set([treeID])),
            recurrence: recurrence,
            systemKind: .autoRepotting,
            notes: Self.seasonNote
        )
    }

    func recordRepotCompleted(treeID: UUID, performedAt: Date = .now) throws {
        guard var tree = treeService.getTree(id: treeID) else { return }
        tree.lastRepottedDate = performedAt
        tree.modifiedDate = .now
        _ = try treeService.updateTree(tree)
        try syncSchedule(for: treeID)
    }

    private func ensureBaselineWork(treeID: UUID, lastRepotted: Date, workTypeID: UUID) throws {
        if let existing = workService.lastCompletedRepottingDate(for: treeID) {
            let calendar = Calendar.current
            if calendar.isDate(existing, inSameDayAs: lastRepotted) || existing > lastRepotted {
                return
            }
        }
        _ = try workService.registerWork(
            workTypeID: workTypeID,
            treeIDs: [treeID],
            performedAt: lastRepotted,
            notes: "Last repotted (recorded on tree)"
        )
    }

    private func autoSchedule(for treeID: UUID) -> CareSchedule? {
        taskService.schedules.first { schedule in
            guard schedule.systemKind == .autoRepotting else { return false }
            if case .trees(let ids) = schedule.target {
                return ids.contains(treeID)
            }
            return false
        }
    }

    private func removeAutoSchedule(for treeID: UUID) throws {
        guard let existing = autoSchedule(for: treeID) else { return }
        try taskService.deleteSchedule(id: existing.id)
    }
}
