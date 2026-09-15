//
//  LibraryMediaKnowledgeRepositories.swift
//  Bonsai World
//
//  Persistence for Media library items and Knowledge resources (v1).
//

import Foundation
import Observation

struct LibraryMediaCatalogFile: Codable, Hashable, Sendable {
    var schemaVersion: Int
    var items: [MediaLibraryItem]

    init(schemaVersion: Int = 1, items: [MediaLibraryItem] = []) {
        self.schemaVersion = schemaVersion
        self.items = items
    }
}

struct LibraryKnowledgeCatalogFile: Codable, Hashable, Sendable {
    var schemaVersion: Int
    var resources: [KnowledgeResource]

    init(schemaVersion: Int = 1, resources: [KnowledgeResource] = []) {
        self.schemaVersion = schemaVersion
        self.resources = resources
    }
}

enum LibraryCatalogRepositoryError: Error, LocalizedError, Sendable {
    case notFound(UUID)
    case duplicateID(UUID)
    case invalid(String)

    var errorDescription: String? {
        switch self {
        case .notFound(let id):
            return "Record not found (\(id.uuidString))."
        case .duplicateID(let id):
            return "Record already exists (\(id.uuidString))."
        case .invalid(let detail):
            return detail
        }
    }
}

@MainActor
protocol MediaLibraryRepository: AnyObject {
    func getAllItems() -> [MediaLibraryItem]
    func getItem(id: UUID) -> MediaLibraryItem?
    @discardableResult
    func createItem(_ item: MediaLibraryItem) throws -> MediaLibraryItem
    @discardableResult
    func updateItem(_ item: MediaLibraryItem) throws -> MediaLibraryItem
    func deleteItem(id: UUID) throws
}

@MainActor
protocol KnowledgeResourceRepository: AnyObject {
    func getAllResources() -> [KnowledgeResource]
    func getResource(id: UUID) -> KnowledgeResource?
    @discardableResult
    func createResource(_ resource: KnowledgeResource) throws -> KnowledgeResource
    @discardableResult
    func updateResource(_ resource: KnowledgeResource) throws -> KnowledgeResource
    func deleteResource(id: UUID) throws
}

@Observable
@MainActor
final class LibraryMediaLibraryRepository: MediaLibraryRepository {
    private let storage: StorageService
    private var items: [MediaLibraryItem] = []
    private var didLoad = false

    init(storage: StorageService) {
        self.storage = storage
    }

    func getAllItems() -> [MediaLibraryItem] {
        ensureLoaded()
        return items
    }

    func getItem(id: UUID) -> MediaLibraryItem? {
        ensureLoaded()
        return items.first { $0.id == id }
    }

    func createItem(_ item: MediaLibraryItem) throws -> MediaLibraryItem {
        ensureLoaded()
        guard !items.contains(where: { $0.id == item.id }) else {
            throw LibraryCatalogRepositoryError.duplicateID(item.id)
        }
        items.append(item)
        try persist()
        return item
    }

    func updateItem(_ item: MediaLibraryItem) throws -> MediaLibraryItem {
        ensureLoaded()
        guard let index = items.firstIndex(where: { $0.id == item.id }) else {
            throw LibraryCatalogRepositoryError.notFound(item.id)
        }
        items[index] = item
        try persist()
        return item
    }

    func deleteItem(id: UUID) throws {
        ensureLoaded()
        guard items.contains(where: { $0.id == id }) else {
            throw LibraryCatalogRepositoryError.notFound(id)
        }
        items.removeAll { $0.id == id }
        try persist()
    }

    private func ensureLoaded() {
        guard !didLoad else { return }
        didLoad = true
        items = loadFromDisk()
    }

    private func loadFromDisk() -> [MediaLibraryItem] {
        do {
            guard let data = try storage.loadPackageFile(
                relativePath: LibraryPackageLayout.mediaLibraryFileName
            ), !data.isEmpty else { return [] }
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            return try decoder.decode(LibraryMediaCatalogFile.self, from: data).items
        } catch {
            return []
        }
    }

    private func persist() throws {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        encoder.dateEncodingStrategy = .iso8601
        guard let data = try? encoder.encode(LibraryMediaCatalogFile(items: items)) else {
            throw LibraryCatalogRepositoryError.invalid("Could not encode media catalog.")
        }
        try storage.savePackageFile(relativePath: LibraryPackageLayout.mediaLibraryFileName, data: data)
    }
}

@MainActor
final class PreviewMediaLibraryRepository: MediaLibraryRepository {
    private var items: [MediaLibraryItem]
    init(items: [MediaLibraryItem] = []) { self.items = items }
    func getAllItems() -> [MediaLibraryItem] { items }
    func getItem(id: UUID) -> MediaLibraryItem? { items.first { $0.id == id } }
    func createItem(_ item: MediaLibraryItem) throws -> MediaLibraryItem {
        guard getItem(id: item.id) == nil else { throw LibraryCatalogRepositoryError.duplicateID(item.id) }
        items.append(item)
        return item
    }
    func updateItem(_ item: MediaLibraryItem) throws -> MediaLibraryItem {
        guard let index = items.firstIndex(where: { $0.id == item.id }) else {
            throw LibraryCatalogRepositoryError.notFound(item.id)
        }
        items[index] = item
        return item
    }
    func deleteItem(id: UUID) throws {
        guard items.contains(where: { $0.id == id }) else {
            throw LibraryCatalogRepositoryError.notFound(id)
        }
        items.removeAll { $0.id == id }
    }
}

@Observable
@MainActor
final class LibraryKnowledgeResourceRepository: KnowledgeResourceRepository {
    private let storage: StorageService
    private var resources: [KnowledgeResource] = []
    private var didLoad = false

    init(storage: StorageService) {
        self.storage = storage
    }

    func getAllResources() -> [KnowledgeResource] {
        ensureLoaded()
        return resources
    }

    func getResource(id: UUID) -> KnowledgeResource? {
        ensureLoaded()
        return resources.first { $0.id == id }
    }

    func createResource(_ resource: KnowledgeResource) throws -> KnowledgeResource {
        ensureLoaded()
        guard !resources.contains(where: { $0.id == resource.id }) else {
            throw LibraryCatalogRepositoryError.duplicateID(resource.id)
        }
        resources.append(resource)
        try persist()
        return resource
    }

    func updateResource(_ resource: KnowledgeResource) throws -> KnowledgeResource {
        ensureLoaded()
        guard let index = resources.firstIndex(where: { $0.id == resource.id }) else {
            throw LibraryCatalogRepositoryError.notFound(resource.id)
        }
        resources[index] = resource
        try persist()
        return resource
    }

    func deleteResource(id: UUID) throws {
        ensureLoaded()
        guard resources.contains(where: { $0.id == id }) else {
            throw LibraryCatalogRepositoryError.notFound(id)
        }
        resources.removeAll { $0.id == id }
        try persist()
    }

    private func ensureLoaded() {
        guard !didLoad else { return }
        didLoad = true
        resources = loadFromDisk()
        if resources.isEmpty {
            resources = KnowledgeResourceSeed.starterResources
            try? persist()
        }
    }

    private func loadFromDisk() -> [KnowledgeResource] {
        do {
            guard let data = try storage.loadPackageFile(
                relativePath: LibraryPackageLayout.knowledgeResourcesFileName
            ), !data.isEmpty else { return [] }
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            return try decoder.decode(LibraryKnowledgeCatalogFile.self, from: data).resources
        } catch {
            return []
        }
    }

    private func persist() throws {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        encoder.dateEncodingStrategy = .iso8601
        guard let data = try? encoder.encode(LibraryKnowledgeCatalogFile(resources: resources)) else {
            throw LibraryCatalogRepositoryError.invalid("Could not encode knowledge catalog.")
        }
        try storage.savePackageFile(
            relativePath: LibraryPackageLayout.knowledgeResourcesFileName,
            data: data
        )
    }
}

@MainActor
final class PreviewKnowledgeResourceRepository: KnowledgeResourceRepository {
    private var resources: [KnowledgeResource]
    init(resources: [KnowledgeResource] = KnowledgeResourceSeed.starterResources) {
        self.resources = resources
    }
    func getAllResources() -> [KnowledgeResource] { resources }
    func getResource(id: UUID) -> KnowledgeResource? { resources.first { $0.id == id } }
    func createResource(_ resource: KnowledgeResource) throws -> KnowledgeResource {
        guard getResource(id: resource.id) == nil else {
            throw LibraryCatalogRepositoryError.duplicateID(resource.id)
        }
        resources.append(resource)
        return resource
    }
    func updateResource(_ resource: KnowledgeResource) throws -> KnowledgeResource {
        guard let index = resources.firstIndex(where: { $0.id == resource.id }) else {
            throw LibraryCatalogRepositoryError.notFound(resource.id)
        }
        resources[index] = resource
        return resource
    }
    func deleteResource(id: UUID) throws {
        guard resources.contains(where: { $0.id == id }) else {
            throw LibraryCatalogRepositoryError.notFound(id)
        }
        resources.removeAll { $0.id == id }
    }
}

enum KnowledgeResourceSeed {
    static var starterResources: [KnowledgeResource] {
        [
            KnowledgeResource(
                kind: .quickGuide,
                title: "Watering in shallow pots",
                summary: "Check the substrate — not the calendar.",
                body: "Water thoroughly when the tree needs it. Shallow bonsai containers dry faster in sun and wind. Avoid permanent saturation."
            ),
            KnowledgeResource(
                kind: .faq,
                title: "Should I move pines indoors for winter?",
                summary: "No — outdoor dormancy is required.",
                body: "Temperate pines need winter dormancy outdoors. Protect shallow roots in severe cold rather than moving the tree indoors as routine care."
            ),
            KnowledgeResource(
                kind: .course,
                title: "First year with a nursery pine",
                summary: "A short structured path for new pine material.",
                body: "1. Establish roots and health.\n2. Decide front and trunk direction.\n3. Build primary branches before fine ramification.\n4. Keep a simple seasonal journal."
            ),
            KnowledgeResource(
                kind: .videoTutorial,
                title: "Wiring basics for deciduous trees",
                summary: "Placeholder tutorial entry — add your own link or notes.",
                body: "Use this entry to store tutorial titles and notes until video media is attached."
            ),
            KnowledgeResource(
                kind: .externalLink,
                title: "Royal Botanic Gardens, Kew — Plants of the World Online",
                summary: "Botanical name verification.",
                body: "Use for accepted scientific names and native ranges.",
                urlString: "https://powo.science.kew.org"
            ),
        ]
    }
}
