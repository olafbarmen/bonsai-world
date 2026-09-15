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

    /// Aligns botanical IDs (genus / species / cultivar) on existing trees.
    /// Does not change Botanical Name or Bonsai Name. Used for catalog repair only.
    func repairBotanicalIdentities(_ trees: [Tree]) throws

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

// MARK: - Journal

enum JournalRepositoryError: Error, LocalizedError, Sendable {
    case notFound(UUID)
    case invalidEntry(String)

    var errorDescription: String? {
        switch self {
        case .notFound(let id):
            return "Journal entry not found (\(id.uuidString))."
        case .invalidEntry(let detail):
            return detail
        }
    }
}

/// Single access point for JournalEntry records behind JournalService.
@MainActor
protocol JournalRepository: AnyObject {
    func getAllEntries() -> [JournalEntry]
    func getEntry(id: UUID) -> JournalEntry?
    @discardableResult
    func createEntry(_ entry: JournalEntry) throws -> JournalEntry
    @discardableResult
    func updateEntry(_ entry: JournalEntry) throws -> JournalEntry
    func deleteEntry(id: UUID) throws
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

// MARK: - Pot

/// Errors from pot repository operations.
enum PotRepositoryError: Error, LocalizedError, Sendable {
    case notFound(UUID)
    case invalidPot(String)

    var errorDescription: String? {
        switch self {
        case .notFound(let id):
            return "Pot not found (\(id.uuidString))."
        case .invalidPot(let detail):
            return detail
        }
    }
}

/// Single access point for Pot records behind PotService.
///
/// CRUD-shaped like Tree/Work — Pots accumulate one at a time as growers register
/// inventory, rather than being edited as a small in-memory batch.
@MainActor
protocol PotRepository: AnyObject {
    /// All pots in the current catalog / library session.
    func getAllPots() -> [Pot]

    /// Pot with the given id, or `nil` when absent.
    func getPot(id: UUID) -> Pot?

    /// Inserts a new pot. Fails if `id` already exists.
    @discardableResult
    func createPot(_ pot: Pot) throws -> Pot

    /// Replaces an existing pot. Fails if `id` is unknown.
    @discardableResult
    func updatePot(_ pot: Pot) throws -> Pot

    /// Removes the pot with the given id. Fails if unknown. Reserved for
    /// mistaken / duplicate records — never for Sold, Broken, or Retired pots.
    func deletePot(id: UUID) throws
}

// MARK: - Yamadori

enum YamadoriRepositoryError: Error, LocalizedError, Sendable {
    case notFound(UUID)
    case duplicateID(UUID)
    case invalidYamadori(String)

    var errorDescription: String? {
        switch self {
        case .notFound(let id):
            return "Yamadori not found (\(id.uuidString))."
        case .duplicateID(let id):
            return "Yamadori already exists (\(id.uuidString))."
        case .invalidYamadori(let detail):
            return detail
        }
    }
}

@MainActor
protocol YamadoriRepository: AnyObject {
    func getAllYamadori() -> [Yamadori]
    func getYamadori(id: UUID) -> Yamadori?
    @discardableResult
    func createYamadori(_ yamadori: Yamadori) throws -> Yamadori
    @discardableResult
    func updateYamadori(_ yamadori: Yamadori) throws -> Yamadori
    func deleteYamadori(id: UUID) throws

    func getAllFinds() -> [YamadoriFind]
    func getFind(id: UUID) -> YamadoriFind?
    func finds(forYamadoriID yamadoriID: UUID) -> [YamadoriFind]
    @discardableResult
    func createFind(_ find: YamadoriFind) throws -> YamadoriFind
    @discardableResult
    func updateFind(_ find: YamadoriFind) throws -> YamadoriFind
    func deleteFind(id: UUID) throws
}

// MARK: - Seed Batch

enum SeedBatchRepositoryError: Error, LocalizedError, Sendable {
    case notFound(UUID)
    case duplicateID(UUID)
    case invalidBatch(String)

    var errorDescription: String? {
        switch self {
        case .notFound(let id):
            return "Seed batch not found (\(id.uuidString))."
        case .duplicateID(let id):
            return "Seed batch already exists (\(id.uuidString))."
        case .invalidBatch(let detail):
            return detail
        }
    }
}

@MainActor
protocol SeedBatchRepository: AnyObject {
    func getAllBatches() -> [SeedBatch]
    func getBatch(id: UUID) -> SeedBatch?
    @discardableResult
    func createBatch(_ batch: SeedBatch) throws -> SeedBatch
    @discardableResult
    func updateBatch(_ batch: SeedBatch) throws -> SeedBatch
    func deleteBatch(id: UUID) throws
}

// MARK: - Nursery Propagation (Cuttings / Air Layers / Grafting)

enum NurseryPropagationRepositoryError: Error, LocalizedError, Sendable {
    case notFound(UUID)
    case duplicateID(UUID)
    case invalidProject(String)

    var errorDescription: String? {
        switch self {
        case .notFound(let id):
            return "Propagation project not found (\(id.uuidString))."
        case .duplicateID(let id):
            return "Propagation project already exists (\(id.uuidString))."
        case .invalidProject(let detail):
            return detail
        }
    }
}

@MainActor
protocol NurseryPropagationRepository: AnyObject {
    func getAllProjects() -> [NurseryPropagationProject]
    func getProject(id: UUID) -> NurseryPropagationProject?
    @discardableResult
    func createProject(_ project: NurseryPropagationProject) throws -> NurseryPropagationProject
    @discardableResult
    func updateProject(_ project: NurseryPropagationProject) throws -> NurseryPropagationProject
    func deleteProject(id: UUID) throws
}

// MARK: - Pot Brand & Maker

/// Single access point for Pot Brand / Pot Maker records behind ReferenceDataManager.
///
/// Batch-oriented like ``LocationRepository`` — ReferenceDataManager already holds
/// the full arrays in memory and mutates them there. Brand and Maker share one
/// repository because Makers always belong to a Brand and the two are edited together
/// in Settings → Pot Brands & Makers.
@MainActor
protocol PotBrandRepository: AnyObject {
    /// All pot brands in the current catalog / library session.
    func getAllBrands() -> [PotBrand]

    /// All pot makers in the current catalog / library session.
    func getAllMakers() -> [PotMaker]

    /// Replaces both catalogs in one write.
    /// Pass `seedVersion` to set the curated seed generation; pass `nil` to keep
    /// whatever version is already on disk (typical for user edits).
    func replaceCatalog(brands: [PotBrand], makers: [PotMaker], seedVersion: Int?) throws

    /// Curated seed generation stored with the catalog, if any.
    func getSeedVersion() -> Int?

    /// Removes the persisted catalog file, if any (migration rollback).
    func discardPersistedCatalog() throws
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

// MARK: - Soil stock

enum SoilStockRepositoryError: Error, LocalizedError, Sendable {
    case notFound(UUID)
    case duplicateID(UUID)
    case invalidItem(String)

    var errorDescription: String? {
        switch self {
        case .notFound(let id):
            return "Soil stock item not found (\(id.uuidString))."
        case .duplicateID(let id):
            return "Soil stock item already exists (\(id.uuidString))."
        case .invalidItem(let detail):
            return detail
        }
    }
}

@MainActor
protocol SoilStockRepository: AnyObject {
    func getAllItems() -> [SoilStockItem]
    func getItem(id: UUID) -> SoilStockItem?
    func getPreferences() -> SoilInventoryPreferences
    @discardableResult
    func createItem(_ item: SoilStockItem) throws -> SoilStockItem
    @discardableResult
    func updateItem(_ item: SoilStockItem) throws -> SoilStockItem
    func deleteItem(id: UUID) throws
    func updatePreferences(_ preferences: SoilInventoryPreferences) throws
}

enum InventoryStockRepositoryError: Error, LocalizedError, Sendable {
    case notFound(UUID)
    case duplicateID(UUID)

    var errorDescription: String? {
        switch self {
        case .notFound(let id):
            return "Inventory stock item not found (\(id.uuidString))."
        case .duplicateID(let id):
            return "Inventory stock item already exists (\(id.uuidString))."
        }
    }
}

@MainActor
protocol InventoryStockRepository: AnyObject {
    func getAllItems() -> [InventoryStockItem]
    func getItem(id: UUID) -> InventoryStockItem?
    @discardableResult
    func createItem(_ item: InventoryStockItem) throws -> InventoryStockItem
    @discardableResult
    func updateItem(_ item: InventoryStockItem) throws -> InventoryStockItem
    func deleteItem(id: UUID) throws
}
