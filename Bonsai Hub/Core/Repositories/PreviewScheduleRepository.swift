//
//  PreviewScheduleRepository.swift
//  Bonsai World
//
//  ScheduleRepository backed by an in-memory array only.
//  Used before a Library is open (first launch) and for SwiftUI #Preview fixtures —
//  not the runtime store once a library is ready.
//

import Foundation
import Observation

/// In-memory `ScheduleRepository` for previews and pre-library sessions.
@Observable
@MainActor
final class PreviewScheduleRepository: ScheduleRepository {
    private var schedules: [CareSchedule]

    init(schedules: [CareSchedule] = []) {
        self.schedules = schedules
    }

    func getAllSchedules() -> [CareSchedule] {
        schedules
    }

    func getSchedule(id: UUID) -> CareSchedule? {
        schedules.first { $0.id == id }
    }

    @discardableResult
    func createSchedule(_ schedule: CareSchedule) throws -> CareSchedule {
        guard !schedules.contains(where: { $0.id == schedule.id }) else {
            throw ScheduleRepositoryError.invalidSchedule("A schedule with this id already exists.")
        }
        schedules.append(schedule)
        return schedule
    }

    @discardableResult
    func updateSchedule(_ schedule: CareSchedule) throws -> CareSchedule {
        guard let index = schedules.firstIndex(where: { $0.id == schedule.id }) else {
            throw ScheduleRepositoryError.notFound(schedule.id)
        }
        schedules[index] = schedule
        return schedule
    }

    func deleteSchedule(id: UUID) throws {
        guard schedules.contains(where: { $0.id == id }) else {
            throw ScheduleRepositoryError.notFound(id)
        }
        schedules.removeAll { $0.id == id }
    }
}
