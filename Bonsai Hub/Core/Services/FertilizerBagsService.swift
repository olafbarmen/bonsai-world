//
//  FertilizerBagsService.swift
//  Bonsai World
//
//  Fertilizer bags track — place/replace on many trees, interval from AppSettings
//  (default 6 weeks). Progress: Tree.lastFertilizerBagReplacedAt. Syncs one
//  system CareTask when any enrolled tree is due.
//

import Foundation
import Observation

@Observable
@MainActor
final class FertilizerBagsService {
    static let taskTitle = "Replace fertilizer bags"

    private let treeService: TreeService
    private let taskService: TaskService
    private let workService: WorkService
    private let appSettings: AppSettings

    init(
        treeService: TreeService,
        taskService: TaskService,
        workService: WorkService,
        appSettings: AppSettings
    ) {
        self.treeService = treeService
        self.taskService = taskService
        self.workService = workService
        self.appSettings = appSettings
    }

    var intervalWeeks: Int { appSettings.fertilizerBagsIntervalWeeks }

    /// In-care trees on the bags program (have a last place/replace date).
    func enrolledTrees() -> [Tree] {
        treeService.trees
            .filter { $0.isInCare && $0.lastFertilizerBagReplacedAt != nil }
            .sorted(by: Self.sortByRegistryName)
    }

    /// Enrolled trees whose bags are due for replace.
    func treesDueForReplace(calendar: Calendar = .current, now: Date = .now) -> [Tree] {
        enrolledTrees().filter { isDue($0, calendar: calendar, now: now) }
    }

    /// In-care trees not yet on bags.
    func treesNotEnrolled() -> [Tree] {
        treeService.trees
            .filter { $0.isInCare && $0.lastFertilizerBagReplacedAt == nil }
            .sorted(by: Self.sortByRegistryName)
    }

    private static func sortByRegistryName(_ lhs: Tree, _ rhs: Tree) -> Bool {
        TreePresentation.registryName(for: lhs).localizedCaseInsensitiveCompare(
            TreePresentation.registryName(for: rhs)
        ) == .orderedAscending
    }

    func isDue(_ tree: Tree, calendar: Calendar = .current, now: Date = .now) -> Bool {
        guard let last = tree.lastFertilizerBagReplacedAt else { return false }
        guard let next = calendar.date(
            byAdding: .weekOfYear,
            value: intervalWeeks,
            to: calendar.startOfDay(for: last)
        ) else { return false }
        return calendar.startOfDay(for: now) >= next
    }

    func nextReplaceDate(for tree: Tree, calendar: Calendar = .current) -> Date? {
        guard let last = tree.lastFertilizerBagReplacedAt else { return nil }
        return calendar.date(
            byAdding: .weekOfYear,
            value: intervalWeeks,
            to: calendar.startOfDay(for: last)
        )
    }

    /// Start bags on trees (bags placed today).
    func startBags(on treeIDs: [UUID], at date: Date = .now) throws {
        let day = Calendar.current.startOfDay(for: date)
        for id in treeIDs {
            guard var tree = treeService.getTree(id: id), tree.isInCare else { continue }
            tree.lastFertilizerBagReplacedAt = day
            tree.modifiedDate = .now
            _ = try treeService.updateTree(tree)
        }
        try syncFertilizerBagsTask()
    }

    /// Mark bags replaced (resets interval).
    func markBagsReplaced(for treeIDs: [UUID], at date: Date = .now) throws {
        let day = Calendar.current.startOfDay(for: date)
        for id in treeIDs {
            guard var tree = treeService.getTree(id: id), tree.isInCare else { continue }
            guard tree.lastFertilizerBagReplacedAt != nil else { continue }
            tree.lastFertilizerBagReplacedAt = day
            tree.modifiedDate = .now
            _ = try treeService.updateTree(tree)
        }
        try syncFertilizerBagsTask()
    }

    func markBagsReplaced(for treeID: UUID, at date: Date = .now) throws {
        try markBagsReplaced(for: [treeID], at: date)
    }

    /// Remove trees from the bags program.
    func stopBags(on treeIDs: [UUID]) throws {
        for id in treeIDs {
            guard var tree = treeService.getTree(id: id) else { continue }
            tree.lastFertilizerBagReplacedAt = nil
            tree.modifiedDate = .now
            _ = try treeService.updateTree(tree)
        }
        try syncFertilizerBagsTask()
    }

    // MARK: - Tasks sync

    func syncFertilizerBagsTask(calendar: Calendar = .current, now: Date = .now) throws {
        let due = treesDueForReplace(calendar: calendar, now: now)
        let dueIDs = due.map(\.id)

        if let existing = pendingFertilizerBagsTask() {
            if dueIDs.isEmpty {
                try taskService.completeFertilizerBagsSystemTask(existing)
                return
            }
            let notes = bagsNotes(treeCount: dueIDs.count)
            let dueDate = earliestDueDate(for: due, calendar: calendar, now: now)
            guard existing.treeIDs != dueIDs
                || existing.title != Self.taskTitle
                || existing.notes != notes
                || calendar.startOfDay(for: existing.dueDate) != calendar.startOfDay(for: dueDate)
            else { return }
            var updated = existing
            updated.treeIDs = dueIDs
            updated.title = Self.taskTitle
            updated.notes = notes
            updated.dueDate = dueDate
            updated.modifiedDate = .now
            _ = try taskService.updateTask(updated)
            return
        }

        guard !dueIDs.isEmpty else { return }
        guard let workTypeID = workService.preferredFertilizingWorkTypeID() else { return }

        _ = try taskService.createFertilizerBagsSystemTask(
            workTypeID: workTypeID,
            treeIDs: dueIDs,
            dueDate: earliestDueDate(for: due, calendar: calendar, now: now),
            notes: bagsNotes(treeCount: dueIDs.count)
        )
    }

    func pendingFertilizerBagsTask() -> CareTask? {
        taskService.tasks.first {
            $0.status == .pending && $0.systemKind == .fertilizerBags
        }
    }

    private func earliestDueDate(for trees: [Tree], calendar: Calendar, now: Date) -> Date {
        let today = calendar.startOfDay(for: now)
        let dates = trees.compactMap { nextReplaceDate(for: $0, calendar: calendar) }
        let earliest = dates.min() ?? today
        return min(calendar.startOfDay(for: earliest), today)
    }

    private func bagsNotes(treeCount: Int) -> String {
        let weeks = intervalWeeks
        let weekWord = weeks == 1 ? "week" : "weeks"
        return "Replace fertilizer bags on \(treeCount) tree\(treeCount == 1 ? "" : "s"). Interval: every \(weeks) \(weekWord). Mark done in Care → Fertilizing or Complete on the task."
    }
}
