//
//  LibraryTaskRepository.swift
//  Bonsai World
//
//  TaskRepository backed by Database/Tasks.json in the library package.
//  Full CRUD — Tasks accumulate one entry per planned activity and are edited
//  or completed individually.
//

import Foundation
import Observation

/// On-disk task catalog envelope for `Database/Tasks.json`.
struct LibraryTaskFile: Codable, Hashable, Sendable {
    var tasks: [CareTask]

    init(tasks: [CareTask] = []) {
        self.tasks = tasks
    }
}

/// Errors from library task catalog persistence.
enum LibraryTaskRepositoryError: Error, LocalizedError, Sendable {
    case encodeFailed
    case writeFailed(String)

    var errorDescription: String? {
        switch self {
        case .encodeFailed:
            return "The task catalog could not be encoded."
        case .writeFailed(let detail):
            return "The task catalog could not be saved (\(detail))."
        }
    }
}

/// Library-backed `TaskRepository` implementation.
@Observable
@MainActor
final class LibraryTaskRepository: TaskRepository {
    private let storage: StorageService

    init(storage: StorageService) {
        self.storage = storage
    }

    // MARK: - Reads

    func getAllTasks() -> [CareTask] {
        loadTasksFromDisk()
    }

    func getTask(id: UUID) -> CareTask? {
        loadTasksFromDisk().first { $0.id == id }
    }

    // MARK: - Writes

    @discardableResult
    func createTask(_ task: CareTask) throws -> CareTask {
        var tasks = loadTasksFromDisk()
        if tasks.contains(where: { $0.id == task.id }) {
            throw TaskRepositoryError.invalidTask("A task with this id already exists.")
        }

        tasks.append(task)

        do {
            try persistAllTasksToDisk(tasks)
        } catch let error as LibraryTaskRepositoryError {
            throw TaskRepositoryError.invalidTask(error.localizedDescription)
        }

        return task
    }

    @discardableResult
    func updateTask(_ task: CareTask) throws -> CareTask {
        var tasks = loadTasksFromDisk()
        guard let index = tasks.firstIndex(where: { $0.id == task.id }) else {
            throw TaskRepositoryError.notFound(task.id)
        }

        tasks[index] = task

        do {
            try persistAllTasksToDisk(tasks)
        } catch let error as LibraryTaskRepositoryError {
            throw TaskRepositoryError.invalidTask(error.localizedDescription)
        }

        return task
    }

    func deleteTask(id: UUID) throws {
        var tasks = loadTasksFromDisk()
        guard tasks.contains(where: { $0.id == id }) else {
            throw TaskRepositoryError.notFound(id)
        }

        tasks.removeAll { $0.id == id }

        do {
            try persistAllTasksToDisk(tasks)
        } catch let error as LibraryTaskRepositoryError {
            throw TaskRepositoryError.invalidTask(error.localizedDescription)
        }
    }

    // MARK: - Private

    /// Loads tasks from disk. Returns `[]` when the file is missing or unreadable.
    /// Does not create, seed, or modify any file.
    private func loadTasksFromDisk() -> [CareTask] {
        do {
            guard let data = try storage.loadPackageFile(
                relativePath: LibraryPackageLayout.tasksFileName
            ) else {
                return []
            }
            let decoder = JSONDecoder()
            let file = try decoder.decode(LibraryTaskFile.self, from: data)
            return file.tasks
        } catch {
            return []
        }
    }

    /// Encodes and writes the full task catalog to `Database/Tasks.json`.
    ///
    /// Overwrites any existing file. Creates the file (and parent folders) on first call.
    private func persistAllTasksToDisk(_ tasks: [CareTask]) throws {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]

        let file = LibraryTaskFile(tasks: tasks)
        let data: Data
        do {
            data = try encoder.encode(file)
        } catch {
            throw LibraryTaskRepositoryError.encodeFailed
        }

        do {
            try storage.savePackageFile(
                relativePath: LibraryPackageLayout.tasksFileName,
                data: data
            )
        } catch {
            throw LibraryTaskRepositoryError.writeFailed(error.localizedDescription)
        }
    }
}
