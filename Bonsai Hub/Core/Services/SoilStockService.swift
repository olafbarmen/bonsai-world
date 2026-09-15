//
//  SoilStockService.swift
//  Bonsai World
//
//  Inventory → Soil stock. Views talk only to this service.
//  Does not deduct volume when mixing or repotting.
//

import Foundation
import Observation

enum SoilStockValidationError: Error, Equatable, LocalizedError, Sendable {
    case missingComponent
    case bagSizeMustBePositive
    case bagCountCannotBeNegative
    case openBagCannotBeNegative
    case minimumStockCannotBeNegative
    case invalidGrainSize
    case actualVolumeCannotBeNegative

    var errorDescription: String? {
        switch self {
        case .missingComponent:
            return "Choose a soil type from Settings."
        case .bagSizeMustBePositive:
            return "Bag size must be greater than 0 L."
        case .bagCountCannotBeNegative:
            return "Bag count cannot be negative."
        case .openBagCannotBeNegative:
            return "Open-bag remainder cannot be negative."
        case .minimumStockCannotBeNegative:
            return "Minimum stock cannot be negative."
        case .invalidGrainSize:
            return "Minimum particle size cannot be greater than maximum."
        case .actualVolumeCannotBeNegative:
            return "Actual volume cannot be negative."
        }
    }
}

struct NewSoilStockDraft: Hashable, Sendable {
    var componentID: UUID?
    var brand: String = ""
    var supplier: String = ""
    var batchReference: String = ""
    var notes: String = ""
    var grainSize = SoilGrainSize()
    var bagSizeLiters: Double = 14
    var bagCount: Double = 1
    var openBagRemainingLiters: Double = 0
    var minimumStockLiters: Double = 0
    var purchasePricePerBag: Double?
    var purchaseDate: Date?
    var hasPurchaseDate = false
    var primaryImageID: UUID?
    var imageIDs: [UUID] = []
}

@Observable
@MainActor
final class SoilStockService {
    private let repository: any SoilStockRepository
    private let taskService: TaskService?
    private let referenceData: ReferenceDataService?

    private(set) var items: [SoilStockItem]
    private(set) var preferences: SoilInventoryPreferences

    init(
        repository: any SoilStockRepository,
        taskService: TaskService? = nil,
        referenceData: ReferenceDataService? = nil
    ) {
        self.repository = repository
        self.taskService = taskService
        self.referenceData = referenceData
        self.items = repository.getAllItems()
        self.preferences = repository.getPreferences()
        syncStocktakeTask()
    }

    private func reload() {
        items = repository.getAllItems()
        preferences = repository.getPreferences()
        syncStocktakeTask()
    }

    func item(id: UUID) -> SoilStockItem? {
        items.first { $0.id == id }
    }

    var summary: SoilInventorySummary {
        SoilInventorySummary(
            materialCount: items.count,
            estimatedVolumeLiters: items.reduce(0) { $0 + $1.estimatedVolumeLiters },
            lowStockCount: items.filter(\.isLowStock).count,
            lastStocktakeDate: preferences.lastLibraryStocktakeDate
                ?? items.compactMap(\.lastStocktakeDate).max()
        )
    }

    func availableVolumeLiters(forComponentID componentID: UUID) -> Double {
        items
            .filter { $0.componentID == componentID }
            .reduce(0) { $0 + $1.estimatedVolumeLiters }
    }

    @discardableResult
    func addItem(from draft: NewSoilStockDraft) throws -> SoilStockItem {
        guard let componentID = draft.componentID else {
            throw SoilStockValidationError.missingComponent
        }
        var item = SoilStockItem(
            componentID: componentID,
            brand: draft.brand.trimmingCharacters(in: .whitespacesAndNewlines),
            supplier: draft.supplier.trimmingCharacters(in: .whitespacesAndNewlines),
            batchReference: draft.batchReference.trimmingCharacters(in: .whitespacesAndNewlines),
            notes: draft.notes.trimmingCharacters(in: .whitespacesAndNewlines),
            grainSize: draft.grainSize,
            bagSizeLiters: draft.bagSizeLiters,
            bagCount: draft.bagCount,
            openBagRemainingLiters: draft.openBagRemainingLiters,
            minimumStockLiters: draft.minimumStockLiters,
            purchasePricePerBag: draft.purchasePricePerBag,
            purchaseDate: draft.hasPurchaseDate ? draft.purchaseDate : nil,
            primaryImageID: draft.primaryImageID,
            imageIDs: draft.imageIDs
        )
        try validate(item)
        item = try repository.createItem(item)
        reload()
        return item
    }

    @discardableResult
    func updateItem(_ item: SoilStockItem) throws -> SoilStockItem {
        var next = item
        next.updatedAt = .now
        try validate(next)
        next = try repository.updateItem(next)
        reload()
        return next
    }

    func deleteItem(id: UUID) throws {
        try repository.deleteItem(id: id)
        reload()
    }

    func confirmStocktake(
        itemID: UUID,
        actualVolumeLiters: Double,
        notes: String = "",
        date: Date = .now
    ) throws {
        guard actualVolumeLiters >= 0 else {
            throw SoilStockValidationError.actualVolumeCannotBeNegative
        }
        guard let item = item(id: itemID) else {
            throw SoilStockRepositoryError.notFound(itemID)
        }
        let updated = item.applyingStocktake(actualVolumeLiters: actualVolumeLiters, date: date, notes: notes)
        _ = try repository.updateItem(updated)
        var prefs = preferences
        prefs.lastLibraryStocktakeDate = date
        try repository.updatePreferences(prefs)
        reload()
    }

    func confirmStocktakeSession(_ actuals: [UUID: Double], date: Date = .now) throws {
        for (id, actual) in actuals {
            try confirmStocktake(itemID: id, actualVolumeLiters: actual, date: date)
        }
        completePendingStocktakeTasks()
    }

    func updatePreferences(_ preferences: SoilInventoryPreferences) throws {
        try repository.updatePreferences(preferences)
        reload()
    }

    // MARK: - Images

    func setPrimaryImage(itemID: UUID, imageID: UUID) throws {
        guard var item = item(id: itemID) else {
            throw SoilStockRepositoryError.notFound(itemID)
        }
        item.primaryImageID = imageID
        if !item.imageIDs.contains(imageID) {
            item.imageIDs.insert(imageID, at: 0)
        }
        _ = try updateItem(item)
    }

    func removeImage(itemID: UUID, imageID: UUID) throws {
        guard var item = item(id: itemID) else {
            throw SoilStockRepositoryError.notFound(itemID)
        }
        item.imageIDs.removeAll { $0 == imageID }
        if item.primaryImageID == imageID {
            item.primaryImageID = item.imageIDs.first
        }
        _ = try updateItem(item)
    }

    /// Ensures exactly one pending “Soil stocktake due” Task when stocktake is due.
    func syncStocktakeTask() {
        guard let taskService else { return }

        let pending = taskService.pendingTasks.filter { $0.libraryInventoryKind == .soilStocktake }
        let shouldHaveTask = !items.isEmpty && preferences.isStocktakeDue()

        if !shouldHaveTask {
            for task in pending {
                try? taskService.deleteTask(id: task.id)
            }
            return
        }

        if !pending.isEmpty { return }

        guard let workTypeID = soilStocktakeWorkTypeID() else { return }
        let due = stocktakeDueDate()
        _ = try? taskService.createTask(
            title: "Soil stocktake due",
            workTypeID: workTypeID,
            libraryInventoryKind: .soilStocktake,
            dueDate: due,
            notes: "Count Inventory → Soil stock and adjust estimated volumes."
        )
    }

    private func completePendingStocktakeTasks() {
        guard let taskService else { return }
        for task in taskService.pendingTasks where task.libraryInventoryKind == .soilStocktake {
            _ = try? taskService.completeLibraryInventoryTask(task)
        }
    }

    private func stocktakeDueDate(now: Date = .now) -> Date {
        let calendar = Calendar.current
        if let last = preferences.lastLibraryStocktakeDate {
            let days = preferences.stocktakeFrequency.intervalDays(
                customDays: preferences.customStocktakeIntervalDays
            )
            if let next = calendar.date(byAdding: .day, value: days, to: last) {
                return min(next, now)
            }
        }
        return calendar.startOfDay(for: now)
    }

    private func soilStocktakeWorkTypeID() -> UUID? {
        guard let referenceData else { return nil }
        if let id = referenceData.workTypes.first(where: { $0.name == "Soil Stocktake" })?.id {
            return id
        }
        // Existing libraries may not have the new Work Type yet.
        return referenceData.workTypes.first(where: { $0.name == "Collection Review" })?.id
            ?? referenceData.workTypes.first(where: { $0.category == .other })?.id
    }

    private func validate(_ item: SoilStockItem) throws {
        if item.bagSizeLiters <= 0 { throw SoilStockValidationError.bagSizeMustBePositive }
        if item.bagCount < 0 { throw SoilStockValidationError.bagCountCannotBeNegative }
        if item.openBagRemainingLiters < 0 { throw SoilStockValidationError.openBagCannotBeNegative }
        if item.minimumStockLiters < 0 { throw SoilStockValidationError.minimumStockCannotBeNegative }
        if !item.grainSize.isValid { throw SoilStockValidationError.invalidGrainSize }
    }
}
