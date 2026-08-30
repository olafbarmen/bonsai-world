//
//  RepositoryProtocols.swift
//  Bonsai World
//
//  Repository contracts for domain access.
//  Features and Views never depend on these directly — use TreeService (and future services).
//  Swap PreviewTreeRepository / PreviewCollectionRepository for library-backed implementations
//  without changing callers.
//

import Foundation

// MARK: - Tree

/// Errors from tree repository operations.
enum TreeRepositoryError: Error, LocalizedError, Sendable {
    case notFound(UUID)
    case invalidTree(String)

    var errorDescription: String? {
        switch self {
        case .notFound(let id):
            return "Tree not found (\(id.uuidString))."
        case .invalidTree(let detail):
            return detail
        }
    }
}

/// Single access point for Tree records behind TreeService.
@MainActor
protocol TreeRepository: AnyObject {
    /// All trees in the current catalog / library session.
    func getAllTrees() -> [Tree]

    /// Tree with the given id, or `nil` when absent.
    func getTree(id: UUID) -> Tree?

    /// Inserts a new tree. Fails if `id` already exists.
    @discardableResult
    func createTree(_ tree: Tree) throws -> Tree

    /// Replaces an existing tree. Fails if `id` is unknown.
    @discardableResult
    func updateTree(_ tree: Tree) throws -> Tree

    /// Removes the tree with the given id. Fails if unknown.
    func deleteTree(id: UUID) throws
}

// MARK: - Collection

/// Errors from collection repository operations.
enum CollectionRepositoryError: Error, LocalizedError, Sendable {
    case notFound(UUID)
    case invalidCollection(String)

    var errorDescription: String? {
        switch self {
        case .notFound(let id):
            return "Collection not found (\(id.uuidString))."
        case .invalidCollection(let detail):
            return detail
        }
    }
}

/// Single access point for Collection records behind TreeService (until CollectionService lands).
@MainActor
protocol CollectionRepository: AnyObject {
    /// All collections in the current catalog / library session.
    func getAllCollections() -> [Collection]

    /// Collection with the given id, or `nil` when absent.
    func getCollection(id: UUID) -> Collection?

    /// Inserts a new collection. Fails if `id` already exists.
    @discardableResult
    func createCollection(_ collection: Collection) throws -> Collection

    /// Replaces an existing collection. Fails if `id` is unknown.
    @discardableResult
    func updateCollection(_ collection: Collection) throws -> Collection

    /// Removes the collection with the given id. Fails if unknown.
    func deleteCollection(id: UUID) throws
}

// MARK: - Garden

/// Single access point for Garden records behind UserProfileStore.
///
/// Unlike Tree/Collection, callers already hold the full array in memory and
/// mutate it there (Gardens are few, edited rarely) — so this contract is
/// batch-oriented (`replaceCatalog`) rather than per-item CRUD.
@MainActor
protocol GardenRepository: AnyObject {
    /// All gardens in the current catalog / library session.
    func getAllGardens() -> [Garden]

    /// Garden with the given id, or `nil` when absent.
    func getGarden(id: UUID) -> Garden?

    /// Replaces the entire catalog in one write.
    func replaceCatalog(with gardens: [Garden]) throws

    /// Removes the persisted catalog file, if any (migration rollback).
    func discardPersistedCatalog() throws
}

// MARK: - Location

/// Single access point for LocationReference records behind ReferenceDataManager/Service.
///
/// Batch-oriented like ``GardenRepository`` — ReferenceDataManager already holds
/// the full array in memory and mutates it there.
@MainActor
protocol LocationRepository: AnyObject {
    /// All locations in the current catalog / library session.
    func getAllLocations() -> [LocationReference]

    /// Location with the given id, or `nil` when absent.
    func getLocation(id: UUID) -> LocationReference?

    /// Replaces the entire catalog in one write.
    func replaceCatalog(with locations: [LocationReference]) throws

    /// Removes the persisted catalog file, if any (migration rollback).
    func discardPersistedCatalog() throws
}

// MARK: - Work

/// Errors from work repository operations.
enum WorkRepositoryError: Error, LocalizedError, Sendable {
    case notFound(UUID)
    case invalidWork(String)

    var errorDescription: String? {
        switch self {
        case .notFound(let id):
            return "Work record not found (\(id.uuidString))."
        case .invalidWork(let detail):
            return detail
        }
    }
}

/// Single access point for WorkRecord entries behind WorkService.
///
/// CRUD-shaped like Tree/Collection — Work records grow one entry at a time as
/// growers register activities, rather than being edited as a small in-memory batch.
/// Platform-agnostic by design: a future Mobile Companion or Windows client reads
/// and writes through this same contract against the shared Library package.
@MainActor
protocol WorkRepository: AnyObject {
    /// All work records in the current catalog / library session.
    func getAllWork() -> [WorkRecord]

    /// Work record with the given id, or `nil` when absent.
    func getWork(id: UUID) -> WorkRecord?

    /// Inserts a new work record. Fails if `id` already exists.
    @discardableResult
    func createWork(_ record: WorkRecord) throws -> WorkRecord

    /// Replaces an existing work record. Fails if `id` is unknown.
    @discardableResult
    func updateWork(_ record: WorkRecord) throws -> WorkRecord

    /// Removes the work record with the given id. Fails if unknown.
    func deleteWork(id: UUID) throws
}

// MARK: - Task

/// Errors from task repository operations.
enum TaskRepositoryError: Error, LocalizedError, Sendable {
    case notFound(UUID)
    case invalidTask(String)

    var errorDescription: String? {
        switch self {
        case .notFound(let id):
            return "Task not found (\(id.uuidString))."
        case .invalidTask(let detail):
            return detail
        }
    }
}

/// Single access point for CareTask entries behind TaskService.
///
/// CRUD-shaped like Work — Tasks grow and complete one entry at a time.
/// Platform-agnostic by design: a future Mobile Companion or Windows client reads
/// and writes through this same contract against the shared Library package.
@MainActor
protocol TaskRepository: AnyObject {
    /// All tasks in the current catalog / library session.
    func getAllTasks() -> [CareTask]

    /// Task with the given id, or `nil` when absent.
    func getTask(id: UUID) -> CareTask?

    /// Inserts a new task. Fails if `id` already exists.
    @discardableResult
    func createTask(_ task: CareTask) throws -> CareTask

    /// Replaces an existing task. Fails if `id` is unknown.
    @discardableResult
    func updateTask(_ task: CareTask) throws -> CareTask

    /// Removes the task with the given id. Fails if unknown.
    func deleteTask(id: UUID) throws
}

// MARK: - Schedule

/// Errors from schedule repository operations.
enum ScheduleRepositoryError: Error, LocalizedError, Sendable {
    case notFound(UUID)
    case invalidSchedule(String)

    var errorDescription: String? {
        switch self {
        case .notFound(let id):
            return "Schedule not found (\(id.uuidString))."
        case .invalidSchedule(let detail):
            return detail
        }
    }
}

/// Single access point for CareSchedule entries behind TaskService.
///
/// CRUD-shaped like Task/Work — schedules grow one entry at a time as
/// growers set up recurring care.
@MainActor
protocol ScheduleRepository: AnyObject {
    /// All schedules in the current catalog / library session.
    func getAllSchedules() -> [CareSchedule]

    /// Schedule with the given id, or `nil` when absent.
    func getSchedule(id: UUID) -> CareSchedule?

    /// Inserts a new schedule. Fails if `id` already exists.
    @discardableResult
    func createSchedule(_ schedule: CareSchedule) throws -> CareSchedule

    /// Replaces an existing schedule. Fails if `id` is unknown.
    @discardableResult
    func updateSchedule(_ schedule: CareSchedule) throws -> CareSchedule

    /// Removes the schedule with the given id. Fails if unknown.
    func deleteSchedule(id: UUID) throws
}
