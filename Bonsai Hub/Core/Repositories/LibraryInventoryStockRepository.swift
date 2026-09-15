//
//  LibraryInventoryStockRepository.swift
//  Bonsai World
//
//  Wire / Tools / Chemicals / Consumables stock — Database/InventoryStock.json.
//

import Foundation
import Observation

struct LibraryInventoryStockFile: Codable, Hashable, Sendable {
    var schemaVersion: Int
    var items: [InventoryStockItem]

    init(schemaVersion: Int = 1, items: [InventoryStockItem] = []) {
        self.schemaVersion = schemaVersion
        self.items = items
    }
}

@Observable
@MainActor
final class LibraryInventoryStockRepository: InventoryStockRepository {
    private let storage: StorageService
    private var items: [InventoryStockItem] = []
    private var didLoad = false

    init(storage: StorageService) {
        self.storage = storage
    }

    func getAllItems() -> [InventoryStockItem] {
        ensureLoaded()
        return items
    }

    func getItem(id: UUID) -> InventoryStockItem? {
        ensureLoaded()
        return items.first { $0.id == id }
    }

    func createItem(_ item: InventoryStockItem) throws -> InventoryStockItem {
        ensureLoaded()
        guard !items.contains(where: { $0.id == item.id }) else {
            throw InventoryStockRepositoryError.duplicateID(item.id)
        }
        items.append(item)
        try persist()
        return item
    }

    func updateItem(_ item: InventoryStockItem) throws -> InventoryStockItem {
        ensureLoaded()
        guard let index = items.firstIndex(where: { $0.id == item.id }) else {
            throw InventoryStockRepositoryError.notFound(item.id)
        }
        items[index] = item
        try persist()
        return item
    }

    func deleteItem(id: UUID) throws {
        ensureLoaded()
        guard items.contains(where: { $0.id == id }) else {
            throw InventoryStockRepositoryError.notFound(id)
        }
        items.removeAll { $0.id == id }
        try persist()
    }

    private func ensureLoaded() {
        guard !didLoad else { return }
        didLoad = true
        items = loadFromDisk().items
    }

    private func loadFromDisk() -> LibraryInventoryStockFile {
        do {
            guard let data = try storage.loadPackageFile(relativePath: LibraryPackageLayout.inventoryStockFileName),
                  !data.isEmpty
            else { return LibraryInventoryStockFile() }
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            return try decoder.decode(LibraryInventoryStockFile.self, from: data)
        } catch {
            return LibraryInventoryStockFile()
        }
    }

    private func persist() throws {
        let file = LibraryInventoryStockFile(items: items)
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        encoder.dateEncodingStrategy = .iso8601
        let data = try encoder.encode(file)
        try storage.savePackageFile(relativePath: LibraryPackageLayout.inventoryStockFileName, data: data)
    }
}

@Observable
@MainActor
final class PreviewInventoryStockRepository: InventoryStockRepository {
    private var items: [InventoryStockItem]

    init(items: [InventoryStockItem] = []) {
        self.items = items
    }

    func getAllItems() -> [InventoryStockItem] { items }
    func getItem(id: UUID) -> InventoryStockItem? { items.first { $0.id == id } }

    func createItem(_ item: InventoryStockItem) throws -> InventoryStockItem {
        guard !items.contains(where: { $0.id == item.id }) else {
            throw InventoryStockRepositoryError.duplicateID(item.id)
        }
        items.append(item)
        return item
    }

    func updateItem(_ item: InventoryStockItem) throws -> InventoryStockItem {
        guard let index = items.firstIndex(where: { $0.id == item.id }) else {
            throw InventoryStockRepositoryError.notFound(item.id)
        }
        items[index] = item
        return item
    }

    func deleteItem(id: UUID) throws {
        guard items.contains(where: { $0.id == id }) else {
            throw InventoryStockRepositoryError.notFound(id)
        }
        items.removeAll { $0.id == id }
    }
}
