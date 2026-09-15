//
//  InventoryStockService.swift
//  Bonsai World
//
//  Inventory stock for Wire / Tools / Chemicals / Consumables / Fertilizers.
//

import Foundation
import Observation

enum InventoryStockValidationError: Error, Equatable, LocalizedError, Sendable {
    case missingCatalogItem
    case missingName
    case missingWireRollSize
    case missingFertilizerQuantityUnit
    case quantityCannotBeNegative
    case minimumCannotBeNegative

    var errorDescription: String? {
        switch self {
        case .missingCatalogItem:
            return "Choose a type from Settings."
        case .missingName:
            return "Enter a name."
        case .missingWireRollSize:
            return "Choose a roll size."
        case .missingFertilizerQuantityUnit:
            return "Choose a quantity unit."
        case .quantityCannotBeNegative:
            return "Quantity cannot be negative."
        case .minimumCannotBeNegative:
            return "Minimum quantity cannot be negative."
        }
    }
}

@Observable
@MainActor
final class InventoryStockService {
    private let repository: any InventoryStockRepository

    private(set) var items: [InventoryStockItem]

    init(repository: any InventoryStockRepository) {
        self.repository = repository
        self.items = repository.getAllItems()
    }

    private func reload() {
        items = repository.getAllItems()
    }

    func items(for kind: InventoryStockKind) -> [InventoryStockItem] {
        items.filter { $0.kind == kind }
    }

    func item(id: UUID) -> InventoryStockItem? {
        items.first { $0.id == id }
    }

    @discardableResult
    func addItem(kind: InventoryStockKind, from draft: NewInventoryStockDraft) throws -> InventoryStockItem {
        if kind.usesCatalog {
            guard draft.catalogItemID != nil else { throw InventoryStockValidationError.missingCatalogItem }
        } else {
            let trimmed = draft.name.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !trimmed.isEmpty else { throw InventoryStockValidationError.missingName }
        }
        if kind == .wire {
            guard draft.wireRollSize != nil else { throw InventoryStockValidationError.missingWireRollSize }
        }
        if kind == .fertilizer {
            guard draft.fertilizerQuantityUnit != nil else {
                throw InventoryStockValidationError.missingFertilizerQuantityUnit
            }
        }
        var item = InventoryStockItem(
            kind: kind,
            catalogItemID: draft.catalogItemID,
            name: draft.name.trimmingCharacters(in: .whitespacesAndNewlines),
            brand: draft.brand.trimmingCharacters(in: .whitespacesAndNewlines),
            supplier: draft.supplier.trimmingCharacters(in: .whitespacesAndNewlines),
            notes: draft.notes.trimmingCharacters(in: .whitespacesAndNewlines),
            quantity: draft.quantity,
            minimumQuantity: draft.minimumQuantity,
            wireRollSize: kind == .wire ? draft.wireRollSize : nil,
            fertilizerQuantityUnit: kind == .fertilizer ? draft.fertilizerQuantityUnit : nil,
            unitPrice: draft.unitPrice,
            primaryImageID: draft.primaryImageID,
            imageIDs: draft.imageIDs
        )
        try validate(item)
        item = try repository.createItem(item)
        reload()
        return item
    }

    @discardableResult
    func updateItem(_ item: InventoryStockItem) throws -> InventoryStockItem {
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

    func setPrimaryImage(itemID: UUID, imageID: UUID) throws {
        guard var item = item(id: itemID) else {
            throw InventoryStockRepositoryError.notFound(itemID)
        }
        item.primaryImageID = imageID
        if !item.imageIDs.contains(imageID) {
            item.imageIDs.insert(imageID, at: 0)
        }
        _ = try updateItem(item)
    }

    func removeImage(itemID: UUID, imageID: UUID) throws {
        guard var item = item(id: itemID) else {
            throw InventoryStockRepositoryError.notFound(itemID)
        }
        item.imageIDs.removeAll { $0 == imageID }
        if item.primaryImageID == imageID {
            item.primaryImageID = item.imageIDs.first
        }
        _ = try updateItem(item)
    }

    private func validate(_ item: InventoryStockItem) throws {
        if item.kind.usesCatalog, item.catalogItemID == nil {
            throw InventoryStockValidationError.missingCatalogItem
        }
        if !item.kind.usesCatalog,
           item.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            throw InventoryStockValidationError.missingName
        }
        if item.kind == .wire, item.wireRollSize == nil {
            throw InventoryStockValidationError.missingWireRollSize
        }
        if item.kind == .fertilizer, item.fertilizerQuantityUnit == nil {
            throw InventoryStockValidationError.missingFertilizerQuantityUnit
        }
        if item.quantity < 0 { throw InventoryStockValidationError.quantityCannotBeNegative }
        if item.minimumQuantity < 0 { throw InventoryStockValidationError.minimumCannotBeNegative }
    }
}
