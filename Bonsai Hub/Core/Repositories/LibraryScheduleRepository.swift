//
//  LibraryScheduleRepository.swift
//  Bonsai World
//
//  ScheduleRepository backed by Database/Schedules.json in the library package.
//  Full CRUD — schedules accumulate one entry per recurring care rule.
//

import Foundation
import Observation

/// On-disk schedule catalog envelope for `Database/Schedules.json`.
struct LibraryScheduleFile: Codable, Hashable, Sendable {
    var schedules: [CareSchedule]

    init(schedules: [CareSchedule] = []) {
        self.schedules = schedules
    }
}

/// Errors from library schedule catalog persistence.
enum LibraryScheduleRepositoryError: Error, LocalizedError, Sendable {
    case encodeFailed
    case writeFailed(String)

    var errorDescription: String? {
        switch self {
        case .encodeFailed:
            return "The schedule catalog could not be encoded."
        case .writeFailed(let detail):
            return "The schedule catalog could not be saved (\(detail))."
        }
    }
}

/// Library-backed `ScheduleRepository` implementation.
@Observable
@MainActor
final class LibraryScheduleRepository: ScheduleRepository {
    private let storage: StorageService

    init(storage: StorageService) {
        self.storage = storage
    }

    // MARK: - Reads

    func getAllSchedules() -> [CareSchedule] {
        loadSchedulesFromDisk()
    }

    func getSchedule(id: UUID) -> CareSchedule? {
        loadSchedulesFromDisk().first { $0.id == id }
    }

    // MARK: - Writes

    @discardableResult
    func createSchedule(_ schedule: CareSchedule) throws -> CareSchedule {
        var schedules = loadSchedulesFromDisk()
        if schedules.contains(where: { $0.id == schedule.id }) {
            throw ScheduleRepositoryError.invalidSchedule("A schedule with this id already exists.")
        }

        schedules.append(schedule)

        do {
            try persistAllSchedulesToDisk(schedules)
        } catch let error as LibraryScheduleRepositoryError {
            throw ScheduleRepositoryError.invalidSchedule(error.localizedDescription)
        }

        return schedule
    }

    @discardableResult
    func updateSchedule(_ schedule: CareSchedule) throws -> CareSchedule {
        var schedules = loadSchedulesFromDisk()
        guard let index = schedules.firstIndex(where: { $0.id == schedule.id }) else {
            throw ScheduleRepositoryError.notFound(schedule.id)
        }

        schedules[index] = schedule

        do {
            try persistAllSchedulesToDisk(schedules)
        } catch let error as LibraryScheduleRepositoryError {
            throw ScheduleRepositoryError.invalidSchedule(error.localizedDescription)
        }

        return schedule
    }

    func deleteSchedule(id: UUID) throws {
        var schedules = loadSchedulesFromDisk()
        guard schedules.contains(where: { $0.id == id }) else {
            throw ScheduleRepositoryError.notFound(id)
        }

        schedules.removeAll { $0.id == id }

        do {
            try persistAllSchedulesToDisk(schedules)
        } catch let error as LibraryScheduleRepositoryError {
            throw ScheduleRepositoryError.invalidSchedule(error.localizedDescription)
        }
    }

    // MARK: - Private

    /// Loads schedules from disk. Returns `[]` when the file is missing or unreadable.
    /// Does not create, seed, or modify any file.
    private func loadSchedulesFromDisk() -> [CareSchedule] {
        do {
            guard let data = try storage.loadPackageFile(
                relativePath: LibraryPackageLayout.schedulesFileName
            ) else {
                return []
            }
            let decoder = JSONDecoder()
            let file = try decoder.decode(LibraryScheduleFile.self, from: data)
            return file.schedules
        } catch {
            return []
        }
    }

    /// Encodes and writes the full schedule catalog to `Database/Schedules.json`.
    ///
    /// Overwrites any existing file. Creates the file (and parent folders) on first call.
    private func persistAllSchedulesToDisk(_ schedules: [CareSchedule]) throws {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]

        let file = LibraryScheduleFile(schedules: schedules)
        let data: Data
        do {
            data = try encoder.encode(file)
        } catch {
            throw LibraryScheduleRepositoryError.encodeFailed
        }

        do {
            try storage.savePackageFile(
                relativePath: LibraryPackageLayout.schedulesFileName,
                data: data
            )
        } catch {
            throw LibraryScheduleRepositoryError.writeFailed(error.localizedDescription)
        }
    }
}
