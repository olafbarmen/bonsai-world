//
//  LibrarySoilStockRepository.swift
//  Bonsai World
//
//  Soil stock backed by Database/SoilStock.json. Catalog types stay in Settings.
//

import Foundation
import Observation

struct LibrarySoilStockFile: Codable, Hashable, Sendable {
    var schemaVersion: Int
    var items: [SoilStockItem]
    var preferences: SoilInventoryPreferences

    init(
        schemaVersion: Int = 1,
        items: [SoilStockItem] = [],
        preferences: SoilInventoryPreferences = SoilInventoryPreferences()
    ) {
        self.schemaVersion = schemaVersion
        self.items = items
        self.preferences = preferences
    }
}

@Observable
@MainActor
final class LibrarySoilStockRepository: SoilStockRepository {
    private let storage: StorageService
    private var items: [SoilStockItem] = []
    private var preferences = SoilInventoryPreferences()
    private var didLoad = false

    init(storage: StorageService) {
        self.storage = storage
    }

    func getAllItems() -> [SoilStockItem] {
        ensureLoaded()
        return items
    }

    func getItem(id: UUID) -> SoilStockItem? {
        ensureLoaded()
        return items.first { $0.id == id }
    }

    func getPreferences() -> SoilInventoryPreferences {
        ensureLoaded()
        return preferences
    }

    func createItem(_ item: SoilStockItem) throws -> SoilStockItem {
        ensureLoaded()
        guard !items.contains(where: { $0.id == item.id }) else {
            throw SoilStockRepositoryError.duplicateID(item.id)
        }
        items.append(item)
        try persist()
        return item
    }

    func updateItem(_ item: SoilStockItem) throws -> SoilStockItem {
        ensureLoaded()
        guard let index = items.firstIndex(where: { $0.id == item.id }) else {
            throw SoilStockRepositoryError.notFound(item.id)
        }
        items[index] = item
        try persist()
        return item
    }

    func deleteItem(id: UUID) throws {
        ensureLoaded()
        guard items.contains(where: { $0.id == id }) else {
            throw SoilStockRepositoryError.notFound(id)
        }
        items.removeAll { $0.id == id }
        try persist()
    }

    func updatePreferences(_ preferences: SoilInventoryPreferences) throws {
        ensureLoaded()
        self.preferences = preferences
        try persist()
    }

    private func ensureLoaded() {
        guard !didLoad else { return }
        didLoad = true
        let file = loadFromDisk()
        items = file.items
        preferences = file.preferences
    }

    private func loadFromDisk() -> LibrarySoilStockFile {
        do {
            guard let data = try storage.loadPackageFile(relativePath: LibraryPackageLayout.soilStockFileName),
                  !data.isEmpty
            else { return LibrarySoilStockFile() }
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            return try decoder.decode(LibrarySoilStockFile.self, from: data)
        } catch {
            return LibrarySoilStockFile()
        }
    }

    private func persist() throws {
        let file = LibrarySoilStockFile(items: items, preferences: preferences)
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        encoder.dateEncodingStrategy = .iso8601
        guard let data = try? encoder.encode(file) else {
            throw SoilStockRepositoryError.invalidItem("The soil stock catalog could not be encoded.")
        }
        do {
            try storage.savePackageFile(relativePath: LibraryPackageLayout.soilStockFileName, data: data)
        } catch {
            throw SoilStockRepositoryError.invalidItem("The soil stock catalog could not be saved (\(error.localizedDescription)).")
        }
    }
}

@Observable
@MainActor
final class PreviewSoilStockRepository: SoilStockRepository {
    private var items: [SoilStockItem]
    private var preferences: SoilInventoryPreferences

    init(items: [SoilStockItem] = [], preferences: SoilInventoryPreferences = SoilInventoryPreferences()) {
        self.items = items
        self.preferences = preferences
    }

    func getAllItems() -> [SoilStockItem] { items }
    func getItem(id: UUID) -> SoilStockItem? { items.first { $0.id == id } }
    func getPreferences() -> SoilInventoryPreferences { preferences }

    func createItem(_ item: SoilStockItem) throws -> SoilStockItem {
        guard !items.contains(where: { $0.id == item.id }) else {
            throw SoilStockRepositoryError.duplicateID(item.id)
        }
        items.append(item)
        return item
    }

    func updateItem(_ item: SoilStockItem) throws -> SoilStockItem {
        guard let index = items.firstIndex(where: { $0.id == item.id }) else {
            throw SoilStockRepositoryError.notFound(item.id)
        }
        items[index] = item
        return item
    }

    func deleteItem(id: UUID) throws {
        guard items.contains(where: { $0.id == id }) else {
            throw SoilStockRepositoryError.notFound(id)
        }
        items.removeAll { $0.id == id }
    }

    func updatePreferences(_ preferences: SoilInventoryPreferences) throws {
        self.preferences = preferences
    }
}
