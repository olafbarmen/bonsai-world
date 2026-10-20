//
//  SpringCareService.swift
//  Bonsai World
//
//  Spring Care batch — seasonal trees on winter placement.
//  Trigger: reminder date only (no temperature — spring can swing warm then frost).
//

import Foundation
import Observation

@Observable
@MainActor
final class SpringCareService {
    static let taskTitle = "Spring Care"

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

    func isSpringCareActive(calendar: Calendar = .current, now: Date = .now) -> Bool {
        hasReachedReminderDate(calendar: calendar, now: now)
    }

    /// From spring reminder date through end of June.
    func hasReachedReminderDate(calendar: Calendar = .current, now: Date = .now) -> Bool {
        let month = appSettings.springCareReminderMonth
        let day = appSettings.springCareReminderDay
        let year = calendar.component(.year, from: now)
        guard let start = calendar.date(from: DateComponents(year: year, month: month, day: day)),
              let end = calendar.date(from: DateComponents(year: year, month: 6, day: 30))
        else { return false }
        return now >= start && now <= end
    }

    func treesNeedingSpringCare() -> [Tree] {
        guard isSpringCareActive() else { return [] }
        return treeService.trees
            .filter {
                $0.isInCare
                    && $0.placementStrategy == .seasonal
                    && $0.seasonPlacement == .winter
            }
            .filter { !hasCompletedAllSteps($0) }
            .sorted {
                TreePresentation.title(for: $0).localizedCaseInsensitiveCompare(
                    TreePresentation.title(for: $1)
                ) == .orderedAscending
            }
    }

    func treesPending(step: SpringCareStep) -> [Tree] {
        treesNeedingSpringCare()
            .filter { !Set($0.springCareCompletedSteps).contains(step) }
    }

    func hasCompletedAllSteps(_ tree: Tree) -> Bool {
        Set(tree.springCareCompletedSteps).isSuperset(of: Set(SpringCareStep.allCases))
    }

    func incompleteSteps(for tree: Tree) -> [SpringCareStep] {
        SpringCareStep.allCases.filter { !Set(tree.springCareCompletedSteps).contains($0) }
    }

    func complete(step: SpringCareStep, for treeIDs: [UUID]) throws {
        guard !treeIDs.isEmpty else { return }
        for treeID in treeIDs {
            guard var tree = treeService.getTree(id: treeID), tree.isInCare else { continue }
            guard tree.placementStrategy == .seasonal, tree.seasonPlacement == .winter else { continue }
            var steps = Set(tree.springCareCompletedSteps)
            steps.insert(step)
            tree.springCareCompletedSteps = SpringCareStep.allCases.filter { steps.contains($0) }
            if steps.isSuperset(of: Set(SpringCareStep.allCases)) {
                tree.seasonPlacement = .summer
                tree.winterCareCompletedSteps = []
                tree.syncStandingLocationFromPlacement()
            }
            tree.modifiedDate = .now
            _ = try treeService.updateTree(tree)
        }
        try syncSpringCareTask()
    }

    func syncSpringCareTask() throws {
        let needing = treesNeedingSpringCare()
        let needingIDs = needing.map(\.id)

        if let existing = pendingSpringCareTask() {
            if needingIDs.isEmpty {
                try taskService.completeSpringCareSystemTask(existing)
                return
            }
            let notes = springCareNotes(treeCount: needingIDs.count)
            let dueDate = dueDateForSpringCare()
            guard existing.treeIDs != needingIDs
                || existing.title != Self.taskTitle
                || existing.notes != notes
                || existing.dueDate != dueDate
            else { return }
            var updated = existing
            updated.treeIDs = needingIDs
            updated.title = Self.taskTitle
            updated.notes = notes
            updated.dueDate = dueDate
            updated.modifiedDate = .now
            _ = try taskService.updateTask(updated)
            return
        }

        guard !needingIDs.isEmpty else { return }
        guard let workTypeID = workService.preferredWinterCareWorkTypeID()
                ?? workService.preferredPlacementWorkTypeID()
        else { return }

        _ = try taskService.createSpringCareSystemTask(
            workTypeID: workTypeID,
            treeIDs: needingIDs,
            dueDate: dueDateForSpringCare(),
            notes: springCareNotes(treeCount: needingIDs.count)
        )
    }

    func pendingSpringCareTask() -> CareTask? {
        taskService.tasks.first {
            $0.status == .pending && $0.systemKind == .springCare
        }
    }

    private func dueDateForSpringCare(calendar: Calendar = .current, now: Date = .now) -> Date {
        let month = appSettings.springCareReminderMonth
        let day = appSettings.springCareReminderDay
        let year = calendar.component(.year, from: now)
        if let date = calendar.date(from: DateComponents(year: year, month: month, day: day)),
           date >= calendar.startOfDay(for: now) {
            return date
        }
        return calendar.startOfDay(for: now)
    }

    private func springCareNotes(treeCount: Int) -> String {
        let steps = SpringCareStep.allCases.map(\.title).joined(separator: " · ")
        return "Checklist: \(steps). Open Care → Spring Care for \(treeCount) tree\(treeCount == 1 ? "" : "s"). Update Location after you move."
    }
}
