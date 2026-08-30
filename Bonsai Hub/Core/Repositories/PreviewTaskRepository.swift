//
//  PreviewTaskRepository.swift
//  Bonsai World
//
//  TaskRepository backed by an in-memory array only.
//  Used before a Library is open (first launch) and for SwiftUI #Preview fixtures —
//  not the runtime store once a library is ready.
//

import Foundation
import Observation

/// In-memory `TaskRepository` for previews and pre-library sessions.
@Observable
@MainActor
final class PreviewTaskRepository: TaskRepository {
    private var tasks: [CareTask]

    init(tasks: [CareTask] = []) {
        self.tasks = tasks
    }

    func getAllTasks() -> [CareTask] {
        tasks
    }

    func getTask(id: UUID) -> CareTask? {
        tasks.first { $0.id == id }
    }

    @discardableResult
    func createTask(_ task: CareTask) throws -> CareTask {
        guard !tasks.contains(where: { $0.id == task.id }) else {
            throw TaskRepositoryError.invalidTask("A task with this id already exists.")
        }
        tasks.append(task)
        return task
    }

    @discardableResult
    func updateTask(_ task: CareTask) throws -> CareTask {
        guard let index = tasks.firstIndex(where: { $0.id == task.id }) else {
            throw TaskRepositoryError.notFound(task.id)
        }
        tasks[index] = task
        return task
    }

    func deleteTask(id: UUID) throws {
        guard tasks.contains(where: { $0.id == id }) else {
            throw TaskRepositoryError.notFound(id)
        }
        tasks.removeAll { $0.id == id }
    }
}
