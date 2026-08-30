//
//  TaskService.swift
//  Bonsai World
//
//  Tasks domain — application-facing API for planned/scheduled care.
//  Tasks own completion of care that should be done; Work owns the historical
//  log of care that has been done (Product Blueprint §5.9 "Tasks vs. Work").
//
//  Completing a Task with a routine, high-frequency Work Type (starting with
//  Watering — ``WorkTypeBehaviourFlags/tasksCompleteInstantly``) writes a
//  minimal WorkRecord automatically via ``completeTaskInstantly(_:)``.
//  Completing a Task with a detailed Work Type (repotting, fertilizing, …)
//  is left to the caller: present the full Add Work sheet, then call
//  ``completeTask(_:resultingWorkRecordID:)`` once that WorkRecord is saved.
//
//  Any Task can also repeat on a cadence — daily watering, weekly liquid
//  fertilizer, monthly slow-release fertilizer, every-3-years repotting,
//  annual winter work, optionally restricted to a season (no fertilizing
//  before August). Repeating rules are ``CareSchedule``, not ``CareTask``:
//  their due occurrences are computed on demand from the last matching
//  WorkRecord per (schedule, tree) — no persisted "instance" rows, no daily
//  generation job. See ``pendingOccurrences(due:)``.
//
//  Tasks and Schedules persist through injected repositories — in-memory
//  session stores before a Library exists, Database/Tasks.json and
//  Database/Schedules.json once one is open (mirrors Work; see
//  ``attachLibraryTaskRepository(_:)`` / ``attachLibraryScheduleRepository(_:)``).
//  Platform-agnostic by design: a future Mobile Companion or Windows client
//  reads and writes through the same repository contracts against the
//  shared Library.
//

import Foundation
import Observation

/// Errors surfaced to callers creating, editing, or completing Tasks and Schedules.
enum TaskServiceError: Error, LocalizedError, Sendable {
    case noTrees
    case unknownWorkType
    case notFound(UUID)
    case alreadyCompleted
    /// This Task's Work Type is not flagged for instant completion — the
    /// caller must collect Work details (Add Work sheet) instead.
    case requiresForm

    var errorDescription: String? {
        switch self {
        case .noTrees:
            return "Select at least one tree for this task."
        case .unknownWorkType:
            return "Choose a Work Type before saving."
        case .notFound:
            return "Task not found."
        case .alreadyCompleted:
            return "This task is already completed."
        case .requiresForm:
            return "This Work Type needs details — use Add Work to complete it."
        }
    }
}

@Observable
@MainActor
final class TaskService {
    private let referenceData: ReferenceDataService
    private let workService: WorkService
    private let treeService: TreeService
    private let botanicalService: BotanicalService
    private var taskRepository: TaskRepository
    private var scheduleRepository: ScheduleRepository

    /// All tasks — loaded from the injected repository, empty session by default.
    private(set) var tasks: [CareTask] = []
    /// All recurring schedules — loaded from the injected repository.
    private(set) var schedules: [CareSchedule] = []
    private(set) var revision: Int = 0

    init(
        referenceData: ReferenceDataService,
        workService: WorkService,
        treeService: TreeService,
        botanicalService: BotanicalService,
        taskRepository: TaskRepository? = nil,
        scheduleRepository: ScheduleRepository? = nil
    ) {
        self.referenceData = referenceData
        self.workService = workService
        self.treeService = treeService
        self.botanicalService = botanicalService
        self.taskRepository = taskRepository ?? PreviewTaskRepository()
        self.scheduleRepository = scheduleRepository ?? PreviewScheduleRepository()
        tasks = self.taskRepository.getAllTasks()
        schedules = self.scheduleRepository.getAllSchedules()
        pruneExpiredMissedOneOffTasks()
    }

    /// Switches Task persistence to a Library-backed repository once one becomes
    /// available (mirrors `WorkService.attachLibraryWorkRepository(_:)`).
    func attachLibraryTaskRepository(_ repository: TaskRepository) {
        taskRepository = repository
        tasks = repository.getAllTasks()
        revision += 1
        pruneExpiredMissedOneOffTasks()
    }

    /// Switches Schedule persistence to a Library-backed repository once one becomes
    /// available.
    func attachLibraryScheduleRepository(_ repository: ScheduleRepository) {
        scheduleRepository = repository
        schedules = repository.getAllSchedules()
        revision += 1
    }

    // MARK: - Reads

    var pendingTasks: [CareTask] {
        _ = revision
        return tasks
            .filter { $0.status == .pending }
            .sorted { $0.dueDate < $1.dueDate }
    }

    func tasks(for treeID: UUID) -> [CareTask] {
        _ = revision
        return tasks
            .filter { $0.treeIDs.contains(treeID) }
            .sorted { $0.dueDate < $1.dueDate }
    }

    /// Pending tasks due within the given horizon. Overdue tasks that can
    /// still be done late appear only in `.overdue`. Work Types flagged
    /// `expiresIfMissed` whose due date has already passed are omitted.
    func pendingTasks(due horizon: TasksHorizon) -> [CareTask] {
        let calendar = Calendar.current
        let now = Date.now
        return pendingTasks.filter { task in
            belongs(
                dueDate: task.dueDate,
                expiresIfMissed: expiresIfMissed(workTypeID: task.workTypeID),
                to: horizon,
                now: now,
                calendar: calendar
            )
        }
    }

    // MARK: - Target resolution

    /// Resolves a Schedule's (or a chosen-at-creation) target to the concrete
    /// Tree IDs it currently covers. `.location`/`.genus` are resolved fresh
    /// each call, so Trees moved into a watered Location, or added to a
    /// watered Genus, are covered automatically without editing the schedule.
    func resolvedTreeIDs(for target: CareScheduleTarget) -> [UUID] {
        switch target {
        case .trees(let ids):
            return ids.filter(isTreeInCare)
        case .location(let locationID):
            return treeService.trees(at: locationID).filter(\.isInCare).map(\.id)
        case .genus(let genusID):
            return treeService.trees(genusID: genusID).filter(\.isInCare).map(\.id)
        }
    }

    /// Former Trees (disposal set) never receive Tasks.
    private func isTreeInCare(_ treeID: UUID) -> Bool {
        treeService.getTree(id: treeID)?.isInCare == true
    }

    /// Human-readable summary of a target, e.g. "3 trees", "All trees at Drivhus",
    /// "All Acer" — used in the Manage Schedules list.
    func targetDescription(_ target: CareScheduleTarget) -> String {
        switch target {
        case .trees(let ids):
            let names = ids.compactMap { treeService.getTree(id: $0)?.bonsaiName }
            return names.isEmpty ? "No trees" : names.sorted().joined(separator: ", ")
        case .location(let locationID):
            let name = referenceData.locations.first { $0.id == locationID }?.name ?? "Unknown location"
            return "All trees at \(name)"
        case .genus(let genusID):
            let name = botanicalService.genus(id: genusID)?.name ?? "Unknown genus"
            return "All \(name)"
        }
    }

    func workType(id: UUID) -> WorkType? {
        referenceData.workType(id: id)
    }

    /// Active Work Types for pickers (mirrors `WorkService.workTypes(in:)`).
    func workTypes(in category: WorkTypeCategory) -> [WorkType] {
        referenceData.workTypes.filter { $0.category == category }
    }

    /// Whether completing this task should skip the Add Work form entirely
    /// (routine, high-frequency care — Blueprint §5.9).
    func completesInstantly(_ task: CareTask) -> Bool {
        referenceData.workType(id: task.workTypeID)?.behaviour.tasksCompleteInstantly ?? false
    }

    /// Whether missed occurrences of this Work Type are dropped instead of
    /// becoming Overdue (watering: you cannot water last week).
    func expiresIfMissed(workTypeID: UUID) -> Bool {
        referenceData.workType(id: workTypeID)?.behaviour.expiresIfMissed ?? false
    }

    /// Unique In Care trees with watering due in this horizon (same source as Tasks).
    func treeIDsNeedingWater(due horizon: TasksHorizon) -> Set<UUID> {
        Set(
            pendingOccurrences(due: horizon)
                .filter { expiresIfMissed(workTypeID: $0.workTypeID) }
                .map(\.treeID)
        )
    }

    /// Unique trees with any work due in this horizon (same source as Tasks).
    func treeIDsWithWork(due horizon: TasksHorizon) -> Set<UUID> {
        Set(pendingOccurrences(due: horizon).map(\.treeID))
    }

    /// Unique trees with Repotting due overdue through this month (Tasks).
    func treeIDsNeedingRepotting() -> Set<UUID> {
        let horizons: [TasksHorizon] = [.overdue, .today, .thisWeek, .thisMonth]
        return Set(
            horizons.flatMap { pendingOccurrences(due: $0) }
                .filter { isRepotting(workTypeID: $0.workTypeID) }
                .map(\.treeID)
        )
    }

    /// Live members for Needs Water, Today's Work, and Needs Repotting.
    func liveSmartCollectionMembers() -> SmartCollectionLiveMembers {
        SmartCollectionLiveMembers(
            needsWater: treeIDsNeedingWater(due: .today),
            todaysWork: treeIDsWithWork(due: .today),
            needsRepotting: treeIDsNeedingRepotting()
        )
    }

    private func isRepotting(workTypeID: UUID) -> Bool {
        let name = workType(id: workTypeID)?.name ?? ""
        return name.localizedCaseInsensitiveContains("repot")
    }

    /// Deletes one-off Tasks whose Work Type expires if missed and whose due
    /// date is already before today (you cannot water last week). Recurring
    /// watering is not deleted — those rules catch up to today instead.
    func pruneExpiredMissedOneOffTasks() {
        let calendar = Calendar.current
        let now = Date.now
        let doomed = tasks.filter {
            $0.status == .pending
                && expiresIfMissed(workTypeID: $0.workTypeID)
                && isOverdue($0.dueDate, now: now, calendar: calendar)
        }
        for task in doomed {
            try? deleteTask(id: task.id)
        }
    }

    // MARK: - Occurrences (Tasks + due Schedules, merged)

    /// Every actionable item — one-off Tasks (one occurrence per Tree they
    /// cover) and computed due occurrences of active Schedules (one per
    /// resolved Tree), merged, de-duplicated, and sorted by due date.
    /// Nothing here is persisted for Schedules; occurrences are derived fresh
    /// from Work history each time this is read. Not bounded to any horizon —
    /// see `pendingOccurrences(due:)` and `pendingOccurrences(forTree:)`.
    ///
    /// De-duplication: when the same tree is covered by more than one rule
    /// for the same Work Type/fertilizer/day-part (e.g. an individual-tree
    /// watering rule *and* a Location watering rule that both include it),
    /// only one occurrence surfaces — completing it satisfies every rule that
    /// produced it, since "last done" is tracked from Work history alone
    /// (Work Type + fertilizer), not per-schedule.
    private func allOccurrences() -> [TaskOccurrence] {
        _ = revision
        let now = Date.now
        let calendar = Calendar.current

        var occurrences: [TaskOccurrence] = pendingTasks.flatMap { task in
            if expiresIfMissed(workTypeID: task.workTypeID), isOverdue(task.dueDate, now: now, calendar: calendar) {
                return [TaskOccurrence]()
            }
            return task.treeIDs.compactMap { treeID -> TaskOccurrence? in
                guard isTreeInCare(treeID) else { return nil }
                return TaskOccurrence(task: task, treeID: treeID, isInstant: completesInstantly(task))
            }
        }

        let currentMonth = calendar.component(.month, from: now)
        for schedule in schedules where schedule.isActive {
            if let window = schedule.seasonalWindow, !window.contains(month: currentMonth) {
                continue
            }
            let expires = expiresIfMissed(workTypeID: schedule.workTypeID)
            for treeID in resolvedTreeIDs(for: schedule.target) {
                for due in dueOccurrences(for: schedule, treeID: treeID, calendar: calendar, now: now) {
                    let dueDate: Date
                    if expires, isOverdue(due.dueDate, now: now, calendar: calendar) {
                        dueDate = calendar.startOfDay(for: now)
                    } else {
                        dueDate = due.dueDate
                    }
                    occurrences.append(TaskOccurrence(schedule: schedule, treeID: treeID, dueDate: dueDate, dayPart: due.dayPart))
                }
            }
        }

        occurrences.sort { $0.dueDate < $1.dueDate }

        var seenKeys = Set<TaskOccurrence.DedupeKey>()
        return occurrences.filter { seenKeys.insert($0.dedupeKey).inserted }
    }

    /// Every actionable item due within the given horizon. See `allOccurrences()`.
    func pendingOccurrences(due horizon: TasksHorizon) -> [TaskOccurrence] {
        let now = Date.now
        let calendar = Calendar.current
        return allOccurrences().filter {
            belongs(
                dueDate: $0.dueDate,
                expiresIfMissed: expiresIfMissed(workTypeID: $0.workTypeID),
                to: horizon,
                now: now,
                calendar: calendar
            )
        }
    }

    /// Every upcoming occurrence for a single Tree — one-off Tasks and active
    /// Schedules that cover it, each showing only its next due date, however
    /// far out. Powers Tree Detail's "Upcoming Tasks" card. Not bounded to a
    /// horizon, so long-cadence work (repotting every few years) always shows.
    func pendingOccurrences(forTree treeID: UUID) -> [TaskOccurrence] {
        allOccurrences().filter { $0.treeID == treeID }
    }

    /// Whether a due date belongs in the given horizon.
    ///
    /// Overdue items that can still be done late (fertilizing, pruning, …)
    /// appear **only** in `.overdue` — never in Today / This Week / ….
    /// Work Types flagged `expiresIfMissed` never become overdue: one-off
    /// Tasks are dropped in `allOccurrences()`, recurring rules catch up to
    /// today.
    private func belongs(
        dueDate: Date,
        expiresIfMissed: Bool,
        to horizon: TasksHorizon,
        now: Date,
        calendar: Calendar
    ) -> Bool {
        let overdue = isOverdue(dueDate, now: now, calendar: calendar)

        if horizon == .overdue {
            return overdue && !expiresIfMissed
        }
        if overdue {
            return false
        }
        if horizon == .nextYear {
            return calendar.component(.year, from: dueDate) > calendar.component(.year, from: now)
        }
        switch horizon {
        case .today:
            return calendar.isDateInToday(dueDate)
        case .thisWeek:
            return calendar.isDate(dueDate, equalTo: now, toGranularity: .weekOfYear)
        case .thisMonth:
            return calendar.isDate(dueDate, equalTo: now, toGranularity: .month)
        case .thisYear:
            return calendar.isDate(dueDate, equalTo: now, toGranularity: .year)
        case .overdue, .nextYear:
            return false
        }
    }

    private func isOverdue(_ dueDate: Date, now: Date, calendar: Calendar) -> Bool {
        dueDate < now && !calendar.isDateInToday(dueDate)
    }

    /// Due occurrences for a schedule on one tree — either a single next-due
    /// date (interval cadence) or one entry per not-yet-done day part
    /// (multiple-times-a-day cadence).
    private func dueOccurrences(
        for schedule: CareSchedule,
        treeID: UUID,
        calendar: Calendar,
        now: Date
    ) -> [(dueDate: Date, dayPart: CareDayPart?)] {
        guard !schedule.recurrence.dayParts.isEmpty else {
            guard let due = nextDueDate(for: schedule, treeID: treeID, calendar: calendar) else { return [] }
            return [(due, nil)]
        }
        return dueDayPartOccurrences(for: schedule, treeID: treeID, calendar: calendar, now: now)
    }

    /// Next due date for a schedule on one tree: last matching WorkRecord (Work
    /// Type + fertilizer, when the schedule fixes one) plus the recurrence
    /// interval, or the schedule's creation date when the tree has no matching
    /// history yet. Matches on Work Type/fertilizer alone (not `scheduleID`) so
    /// Work logged manually through any path still resets the clock.
    private func nextDueDate(for schedule: CareSchedule, treeID: UUID, calendar: Calendar) -> Date? {
        let lastPerformed = matchingHistory(for: schedule, treeID: treeID)
            .map(\.performedAt)
            .max()

        let base = lastPerformed ?? schedule.createdDate
        return calendar.date(
            byAdding: schedule.recurrence.unit.calendarComponent,
            value: schedule.recurrence.interval,
            to: base
        )
    }

    /// For "N times a day" schedules: counts how many matching WorkRecords already
    /// exist today for this tree, then returns the *remaining* day parts (in
    /// morning→evening order) as due now — not gated by clock time, since a
    /// grower may want to get ahead of the day's watering. Tracking by count
    /// rather than by clock time means watering slightly early/late, or "out of
    /// order", still counts correctly.
    private func dueDayPartOccurrences(
        for schedule: CareSchedule,
        treeID: UUID,
        calendar: Calendar,
        now: Date
    ) -> [(dueDate: Date, dayPart: CareDayPart?)] {
        let doneToday = matchingHistory(for: schedule, treeID: treeID)
            .filter { calendar.isDateInToday($0.performedAt) }
            .count

        let remaining = schedule.recurrence.dayParts.sorted().dropFirst(doneToday)
        return remaining.map { part in
            let due = calendar.date(bySettingHour: part.referenceHour, minute: 0, second: 0, of: now) ?? now
            return (due, part)
        }
    }

    /// Preview of when a Schedule will next be due for one Tree, evaluated
    /// *after* a completion has already been written — reassures the grower
    /// that completing one occurrence never removes the rule, it only pushes
    /// its next due date forward by the recurrence interval (or, for
    /// "multiple times a day" schedules, to the next remaining time slot
    /// today, or tomorrow's first slot once today's are all done).
    private func previewNextOccurrence(
        for schedule: CareSchedule,
        treeID: UUID,
        calendar: Calendar,
        now: Date
    ) -> (dueDate: Date, dayPart: CareDayPart?)? {
        guard !schedule.recurrence.dayParts.isEmpty else {
            guard let due = nextDueDate(for: schedule, treeID: treeID, calendar: calendar) else { return nil }
            return (due, nil)
        }
        if let nextToday = dueDayPartOccurrences(for: schedule, treeID: treeID, calendar: calendar, now: now).first {
            return nextToday
        }
        guard let firstPart = schedule.recurrence.dayParts.sorted().first,
              let tomorrow = calendar.date(byAdding: .day, value: 1, to: now) else { return nil }
        let due = calendar.date(bySettingHour: firstPart.referenceHour, minute: 0, second: 0, of: tomorrow) ?? tomorrow
        return (due, firstPart)
    }

    private func matchingHistory(for schedule: CareSchedule, treeID: UUID) -> [WorkRecord] {
        workService.history(for: treeID)
            .filter { $0.workTypeID == schedule.workTypeID }
            .filter { schedule.fertilizerTypeID == nil || $0.fertilizerTypeID == schedule.fertilizerTypeID }
    }

    // MARK: - Writes

    @discardableResult
    func createTask(
        title: String,
        workTypeID: UUID,
        treeIDs: [UUID],
        dueDate: Date,
        notes: String = ""
    ) throws -> CareTask {
        guard !treeIDs.isEmpty else { throw TaskServiceError.noTrees }
        guard referenceData.workType(id: workTypeID) != nil else { throw TaskServiceError.unknownWorkType }

        let task = CareTask(
            title: title.trimmingCharacters(in: .whitespacesAndNewlines),
            workTypeID: workTypeID,
            treeIDs: treeIDs,
            dueDate: dueDate,
            notes: notes.trimmingCharacters(in: .whitespacesAndNewlines)
        )

        try taskRepository.createTask(task)
        tasks.append(task)
        revision += 1
        return task
    }

    @discardableResult
    func updateTask(_ task: CareTask) throws -> CareTask {
        var updated = task
        updated.modifiedDate = .now
        try taskRepository.updateTask(updated)
        if let index = tasks.firstIndex(where: { $0.id == updated.id }) {
            tasks[index] = updated
        }
        revision += 1
        return updated
    }

    func deleteTask(id: UUID) throws {
        try taskRepository.deleteTask(id: id)
        tasks.removeAll { $0.id == id }
        revision += 1
    }

    /// Completes a Task whose Work Type is flagged `tasksCompleteInstantly` — a single
    /// action, no form. Writes a minimal WorkRecord (Tree IDs + timestamp, no required
    /// notes) linked back to this Task via `WorkRecord.scheduleID`.
    @discardableResult
    func completeTaskInstantly(_ task: CareTask) throws -> WorkRecord {
        guard task.status == .pending else { throw TaskServiceError.alreadyCompleted }
        guard completesInstantly(task) else { throw TaskServiceError.requiresForm }

        let record = try workService.registerWork(
            workTypeID: task.workTypeID,
            treeIDs: task.treeIDs,
            scheduleID: task.id
        )
        try markCompleted(task, resultingWorkRecordID: record.id)
        return record
    }

    /// Marks a Task completed after its corresponding Work has already been registered
    /// elsewhere (the Add Work sheet, for detailed Work Types that need a full form).
    @discardableResult
    func completeTask(_ task: CareTask, resultingWorkRecordID: UUID?) throws -> CareTask {
        guard task.status == .pending else { throw TaskServiceError.alreadyCompleted }
        return try markCompleted(task, resultingWorkRecordID: resultingWorkRecordID)
    }

    @discardableResult
    private func markCompleted(_ task: CareTask, resultingWorkRecordID: UUID?) throws -> CareTask {
        var updated = task
        updated.status = .completed
        updated.completedAt = .now
        updated.resultingWorkRecordID = resultingWorkRecordID
        return try updateTask(updated)
    }

    // MARK: - Schedules (writes)

    @discardableResult
    func createSchedule(
        title: String,
        workTypeID: UUID,
        target: CareScheduleTarget,
        recurrence: CareRecurrenceRule,
        seasonalWindow: CareScheduleSeasonalWindow? = nil,
        fertilizerTypeID: UUID? = nil,
        notes: String = ""
    ) throws -> CareSchedule {
        guard !resolvedTreeIDs(for: target).isEmpty else { throw TaskServiceError.noTrees }
        guard referenceData.workType(id: workTypeID) != nil else { throw TaskServiceError.unknownWorkType }

        let schedule = CareSchedule(
            title: title.trimmingCharacters(in: .whitespacesAndNewlines),
            workTypeID: workTypeID,
            fertilizerTypeID: fertilizerTypeID,
            target: target,
            recurrence: recurrence,
            seasonalWindow: seasonalWindow,
            notes: notes.trimmingCharacters(in: .whitespacesAndNewlines)
        )

        try scheduleRepository.createSchedule(schedule)
        schedules.append(schedule)
        revision += 1
        return schedule
    }

    @discardableResult
    func setSchedule(_ id: UUID, isActive: Bool) throws -> CareSchedule? {
        guard var schedule = schedules.first(where: { $0.id == id }) else {
            throw TaskServiceError.notFound(id)
        }
        schedule.isActive = isActive
        schedule.modifiedDate = .now
        try scheduleRepository.updateSchedule(schedule)
        if let index = schedules.firstIndex(where: { $0.id == id }) {
            schedules[index] = schedule
        }
        revision += 1
        return schedule
    }

    func deleteSchedule(id: UUID) throws {
        try scheduleRepository.deleteSchedule(id: id)
        schedules.removeAll { $0.id == id }
        revision += 1
    }

    // MARK: - Occurrence completion (unified)

    /// Everything needed to reverse one `completeOccurrenceInstantly(_:)` call —
    /// see `undoCompletion(_:)`.
    struct OccurrenceCompletionResult: Sendable {
        let occurrenceTitle: String
        let workRecordID: UUID
        /// Present only when the occurrence came from a one-off `CareTask` —
        /// its status must be reverted to `.pending` on undo.
        let taskID: UUID?
        /// Present only when the occurrence came from a recurring `CareSchedule`
        /// — when it will next be due, so completing "just this one" never
        /// reads as deleting or cancelling the whole rule.
        let nextDueDate: Date?
        /// Present alongside `nextDueDate` only for "multiple times a day" schedules.
        let nextDueDayPart: CareDayPart?
    }

    /// Completes any `TaskOccurrence` — dispatches to the right underlying
    /// write depending on its source. Only call this for occurrences whose
    /// `isInstant` is `true`; non-instant one-off Tasks must go through the
    /// full Add Work sheet (see `AddWorkSheet` + `completeTask(_:resultingWorkRecordID:)`).
    @discardableResult
    func completeOccurrenceInstantly(_ occurrence: TaskOccurrence) throws -> OccurrenceCompletionResult {
        switch occurrence.source {
        case .task(let task):
            let record = try completeTaskInstantly(task)
            return OccurrenceCompletionResult(
                occurrenceTitle: occurrence.title,
                workRecordID: record.id,
                taskID: task.id,
                nextDueDate: nil,
                nextDueDayPart: nil
            )
        case .schedule(let scheduleID):
            let record = try completeScheduleOccurrence(scheduleID: scheduleID, treeID: occurrence.treeID)
            let preview = schedules.first { $0.id == scheduleID }.flatMap {
                previewNextOccurrence(for: $0, treeID: occurrence.treeID, calendar: .current, now: .now)
            }
            return OccurrenceCompletionResult(
                occurrenceTitle: occurrence.title,
                workRecordID: record.id,
                taskID: nil,
                nextDueDate: preview?.dueDate,
                nextDueDayPart: preview?.dayPart
            )
        }
    }

    /// Reverses one completed occurrence: deletes the WorkRecord it wrote, and —
    /// for one-off Tasks — puts the Task back to `.pending`. Schedule occurrences
    /// need nothing else: their "due" state is derived from WorkRecord history,
    /// so deleting the record alone makes the occurrence due again.
    func undoCompletion(_ result: OccurrenceCompletionResult) {
        try? workService.deleteWork(id: result.workRecordID)
        guard let taskID = result.taskID, var task = tasks.first(where: { $0.id == taskID }) else { return }
        task.status = .pending
        task.completedAt = nil
        task.resultingWorkRecordID = nil
        try? updateTask(task)
    }

    /// Completes one due occurrence of a Schedule for a single tree — always a
    /// single action, since every detail (Work Type, fertilizer) was already
    /// decided when the Schedule was created.
    @discardableResult
    func completeScheduleOccurrence(scheduleID: UUID, treeID: UUID) throws -> WorkRecord {
        guard let schedule = schedules.first(where: { $0.id == scheduleID }) else {
            throw TaskServiceError.notFound(scheduleID)
        }
        return try workService.registerWork(
            workTypeID: schedule.workTypeID,
            treeIDs: [treeID],
            fertilizerTypeID: schedule.fertilizerTypeID,
            scheduleID: schedule.id
        )
    }
}
