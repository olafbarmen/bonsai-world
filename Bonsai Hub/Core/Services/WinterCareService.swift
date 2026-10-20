//
//  WinterCareService.swift
//  Bonsai World
//
//  Winter Care batch — seasonal strategy + summer placement + checklist.
//  Trigger: reminder date OR frost temp. Location (where it stands) is separate.
//

import Foundation
import Observation

@Observable
@MainActor
final class WinterCareService {
    static let taskTitle = "Winter Care"

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

    // MARK: - Season trigger

    func isWinterCareActive(snapshot: WeatherSnapshot?, calendar: Calendar = .current, now: Date = .now) -> Bool {
        if hasReachedReminderDate(calendar: calendar, now: now) { return true }
        return isFrostRisk(snapshot: snapshot)
    }

    func hasReachedReminderDate(calendar: Calendar = .current, now: Date = .now) -> Bool {
        let month = appSettings.winterCareReminderMonth
        let day = appSettings.winterCareReminderDay
        let year = calendar.component(.year, from: now)
        guard let start = calendar.date(from: DateComponents(year: year, month: month, day: day)) else {
            return false
        }
        let endYear = month >= 7 ? year + 1 : year
        guard let end = calendar.date(from: DateComponents(year: endYear, month: 3, day: 31)) else {
            return now >= start
        }
        return now >= start && now <= end
    }

    func isFrostRisk(snapshot: WeatherSnapshot?) -> Bool {
        guard let snapshot, let today = snapshot.today else { return false }
        let threshold = appSettings.winterCareFrostCelsius
        if today.minTemperatureCelsius <= threshold { return true }
        if let tomorrow = snapshot.tomorrow, tomorrow.minTemperatureCelsius <= threshold {
            return true
        }
        return false
    }

    // MARK: - Trees in scope

    /// Seasonal trees still on summer placement when Winter Care is active.
    func treesNeedingWinterCare(snapshot: WeatherSnapshot?) -> [Tree] {
        guard isWinterCareActive(snapshot: snapshot) else { return [] }
        return treeService.trees
            .filter {
                $0.isInCare
                    && $0.placementStrategy == .seasonal
                    && $0.seasonPlacement == .summer
            }
            .filter { !hasCompletedAllSteps($0) }
            .sorted {
                TreePresentation.title(for: $0).localizedCaseInsensitiveCompare(
                    TreePresentation.title(for: $1)
                ) == .orderedAscending
            }
    }

    func treesPending(step: WinterCareStep, snapshot: WeatherSnapshot?) -> [Tree] {
        treesNeedingWinterCare(snapshot: snapshot)
            .filter { !Set($0.winterCareCompletedSteps).contains(step) }
    }

    func hasCompletedAllSteps(_ tree: Tree) -> Bool {
        Set(tree.winterCareCompletedSteps).isSuperset(of: Set(WinterCareStep.allCases))
    }

    func incompleteSteps(for tree: Tree) -> [WinterCareStep] {
        WinterCareStep.allCases.filter { !Set(tree.winterCareCompletedSteps).contains($0) }
    }

    // MARK: - Checklist mutations

    func complete(step: WinterCareStep, for treeIDs: [UUID], snapshot: WeatherSnapshot?) throws {
        guard !treeIDs.isEmpty else { return }
        for treeID in treeIDs {
            guard var tree = treeService.getTree(id: treeID), tree.isInCare else { continue }
            guard tree.placementStrategy == .seasonal, tree.seasonPlacement == .summer else { continue }
            var steps = Set(tree.winterCareCompletedSteps)
            steps.insert(step)
            tree.winterCareCompletedSteps = WinterCareStep.allCases.filter { steps.contains($0) }
            if steps.isSuperset(of: Set(WinterCareStep.allCases)) {
                tree.seasonPlacement = .winter
                tree.springCareCompletedSteps = []
                tree.syncStandingLocationFromPlacement()
            }
            tree.modifiedDate = .now
            _ = try treeService.updateTree(tree)
        }
        try syncWinterCareTask(snapshot: snapshot)
    }

    /// Toggle one checklist step on a tree from Tasks (Task Details / Edit Task).
    /// Does not change Location or Season — the grower updates those separately.
    func setStep(
        _ step: WinterCareStep,
        isComplete: Bool,
        for treeID: UUID,
        snapshot: WeatherSnapshot?
    ) throws {
        guard var tree = treeService.getTree(id: treeID), tree.isInCare else { return }
        var steps = Set(tree.winterCareCompletedSteps)
        if isComplete {
            steps.insert(step)
        } else {
            steps.remove(step)
        }
        tree.winterCareCompletedSteps = WinterCareStep.allCases.filter { steps.contains($0) }
        tree.modifiedDate = .now
        _ = try treeService.updateTree(tree)
        try syncWinterCareTask(snapshot: snapshot)
    }

    /// Mark every Winter Care step done for one tree (Tasks “Complete” / “Mark all”).
    /// Does not change Location or Season.
    func markAllStepsDone(for treeID: UUID, snapshot: WeatherSnapshot?) throws {
        guard var tree = treeService.getTree(id: treeID), tree.isInCare else { return }
        tree.winterCareCompletedSteps = WinterCareStep.allCases
        tree.modifiedDate = .now
        _ = try treeService.updateTree(tree)
        try syncWinterCareTask(snapshot: snapshot)
    }

    func setPlacementStrategy(_ strategy: TreePlacementStrategy, for treeID: UUID, snapshot: WeatherSnapshot?) throws {
        guard var tree = treeService.getTree(id: treeID) else { return }
        tree.placementStrategy = strategy
        if strategy == .alwaysOutdoors {
            tree.winterCareCompletedSteps = WinterCareStep.allCases
            tree.springCareCompletedSteps = SpringCareStep.allCases
        }
        tree.syncStandingLocationFromPlacement()
        tree.modifiedDate = .now
        _ = try treeService.updateTree(tree)
        try syncWinterCareTask(snapshot: snapshot)
    }

    func setSeasonPlacement(_ season: TreeSeasonPlacement, for treeID: UUID, snapshot: WeatherSnapshot?) throws {
        guard var tree = treeService.getTree(id: treeID) else { return }
        tree.seasonPlacement = season
        if season == .summer {
            tree.winterCareCompletedSteps = []
        } else {
            tree.winterCareCompletedSteps = WinterCareStep.allCases
            tree.springCareCompletedSteps = []
        }
        tree.syncStandingLocationFromPlacement()
        tree.modifiedDate = .now
        _ = try treeService.updateTree(tree)
        try syncWinterCareTask(snapshot: snapshot)
    }

    // MARK: - Tasks sync

    func syncWinterCareTask(snapshot: WeatherSnapshot?) throws {
        let needing = treesNeedingWinterCare(snapshot: snapshot)
        let needingIDs = needing.map(\.id)

        if let existing = pendingWinterCareTask() {
            if needingIDs.isEmpty {
                try taskService.completeWinterCareSystemTask(existing)
                return
            }
            let notes = winterCareNotes(treeCount: needingIDs.count)
            let dueDate = dueDateForWinterCare()
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
        guard let workTypeID = workService.preferredWinterCareWorkTypeID() else { return }

        _ = try taskService.createWinterCareSystemTask(
            workTypeID: workTypeID,
            treeIDs: needingIDs,
            dueDate: dueDateForWinterCare(),
            notes: winterCareNotes(treeCount: needingIDs.count)
        )
    }

    func pendingWinterCareTask() -> CareTask? {
        taskService.tasks.first {
            $0.status == .pending && $0.systemKind == .winterCare
        }
    }

    private func dueDateForWinterCare(calendar: Calendar = .current, now: Date = .now) -> Date {
        let month = appSettings.winterCareReminderMonth
        let day = appSettings.winterCareReminderDay
        let year = calendar.component(.year, from: now)
        if let date = calendar.date(from: DateComponents(year: year, month: month, day: day)),
           date >= calendar.startOfDay(for: now) {
            return date
        }
        return calendar.startOfDay(for: now)
    }

    private func winterCareNotes(treeCount: Int) -> String {
        let steps = WinterCareStep.allCases.map(\.title).joined(separator: " · ")
        return "Checklist per tree: \(steps). Check off steps in Task Details (Location and Season stay as you set them). \(treeCount) tree\(treeCount == 1 ? "" : "s") still need Winter Care."
    }
}
