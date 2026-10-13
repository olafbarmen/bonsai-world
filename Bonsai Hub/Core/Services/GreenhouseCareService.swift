//
//  GreenhouseCareService.swift
//  Bonsai World
//
//  Spring greenhouse heat / vent check — Locations with Greenhouse /
//  Cold Greenhouse / Polytunnel setting. Trigger: reminder date only.
//

import Foundation
import Observation

@Observable
@MainActor
final class GreenhouseCareService {
    static let taskTitle = "Check greenhouse heat / unlock vents"

    private let referenceData: ReferenceDataService
    private let referenceDataManager: ReferenceDataManager
    private let taskService: TaskService
    private let workService: WorkService
    private let appSettings: AppSettings

    init(
        referenceData: ReferenceDataService,
        referenceDataManager: ReferenceDataManager,
        taskService: TaskService,
        workService: WorkService,
        appSettings: AppSettings
    ) {
        self.referenceData = referenceData
        self.referenceDataManager = referenceDataManager
        self.taskService = taskService
        self.workService = workService
        self.appSettings = appSettings
    }

    func isGreenhouseSpringCheckActive(calendar: Calendar = .current, now: Date = .now) -> Bool {
        hasReachedReminderDate(calendar: calendar, now: now)
    }

    /// From greenhouse reminder date through end of June.
    func hasReachedReminderDate(calendar: Calendar = .current, now: Date = .now) -> Bool {
        let month = appSettings.greenhouseSpringReminderMonth
        let day = appSettings.greenhouseSpringReminderDay
        let year = calendar.component(.year, from: now)
        guard let start = calendar.date(from: DateComponents(year: year, month: month, day: day)),
              let end = calendar.date(from: DateComponents(year: year, month: 6, day: 30))
        else { return false }
        return now >= start && now <= end
    }

    func locationsNeedingCheck(calendar: Calendar = .current, now: Date = .now) -> [LocationReference] {
        guard isGreenhouseSpringCheckActive(calendar: calendar, now: now) else { return [] }
        let year = calendar.component(.year, from: now)
        _ = referenceDataManager.revision
        return referenceData.locations
            .filter { location in
                guard location.environment.setting?.needsGreenhouseSpringCheck == true else { return false }
                return location.greenhouseSpringCheckYear != year
            }
            .sorted {
                $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending
            }
    }

    func completeCheck(for locationIDs: [UUID], calendar: Calendar = .current, now: Date = .now) throws {
        guard !locationIDs.isEmpty else { return }
        let year = calendar.component(.year, from: now)
        for locationID in locationIDs {
            guard let location = referenceData.location(id: locationID) else { continue }
            guard location.environment.setting?.needsGreenhouseSpringCheck == true else { continue }
            referenceDataManager.setGreenhouseSpringCheckYear(id: locationID, year: year)
        }
        try syncGreenhouseSpringCheckTask(calendar: calendar, now: now)
    }

    func syncGreenhouseSpringCheckTask(calendar: Calendar = .current, now: Date = .now) throws {
        let needing = locationsNeedingCheck(calendar: calendar, now: now)
        let needingIDs = needing.map(\.id)

        if let existing = pendingGreenhouseSpringCheckTask() {
            if needingIDs.isEmpty {
                try taskService.completeGreenhouseSpringCheckSystemTask(existing)
                return
            }
            let notes = greenhouseNotes(locationCount: needingIDs.count)
            let dueDate = dueDateForCheck(calendar: calendar, now: now)
            guard existing.locationIDs != needingIDs
                || existing.title != Self.taskTitle
                || existing.notes != notes
                || existing.dueDate != dueDate
            else { return }
            var updated = existing
            updated.locationIDs = needingIDs
            updated.treeIDs = []
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

        _ = try taskService.createGreenhouseSpringCheckSystemTask(
            workTypeID: workTypeID,
            locationIDs: needingIDs,
            dueDate: dueDateForCheck(calendar: calendar, now: now),
            notes: greenhouseNotes(locationCount: needingIDs.count)
        )
    }

    func pendingGreenhouseSpringCheckTask() -> CareTask? {
        taskService.tasks.first {
            $0.status == .pending && $0.systemKind == .greenhouseSpringCheck
        }
    }

    private func dueDateForCheck(calendar: Calendar = .current, now: Date = .now) -> Date {
        let month = appSettings.greenhouseSpringReminderMonth
        let day = appSettings.greenhouseSpringReminderDay
        let year = calendar.component(.year, from: now)
        if let date = calendar.date(from: DateComponents(year: year, month: month, day: day)),
           date >= calendar.startOfDay(for: now) {
            return date
        }
        return calendar.startOfDay(for: now)
    }

    private func greenhouseNotes(locationCount: Int) -> String {
        "Open Care → Spring Care for \(locationCount) greenhouse location\(locationCount == 1 ? "" : "s"). Check heat and unlock vents."
    }
}
