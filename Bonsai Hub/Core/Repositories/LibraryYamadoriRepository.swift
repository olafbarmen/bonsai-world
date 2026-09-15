//
//  LibraryYamadoriRepository.swift
//  Bonsai World
//

import Foundation
import Observation

/// On-disk Yamadori catalog. Schema 2 = trips + finds. Schema 1 = fat `records` (migrated on load).
struct LibraryYamadoriFile: Codable, Hashable, Sendable {
    var schemaVersion: Int
    var trips: [Yamadori]
    var finds: [YamadoriFind]

    init(schemaVersion: Int = 2, trips: [Yamadori] = [], finds: [YamadoriFind] = []) {
        self.schemaVersion = schemaVersion
        self.trips = trips
        self.finds = finds
    }
}

/// Decode helper for v1 files that only had `records`.
private struct LibraryYamadoriFileV1: Codable, Sendable {
    var records: [LegacyYamadoriRecord]
}

enum LibraryYamadoriRepositoryError: Error, LocalizedError, Sendable {
    case encodeFailed
    case writeFailed(String)

    var errorDescription: String? {
        switch self {
        case .encodeFailed:
            return "The Yamadori catalog could not be encoded."
        case .writeFailed(let detail):
            return "The Yamadori catalog could not be saved (\(detail))."
        }
    }
}

@Observable
@MainActor
final class LibraryYamadoriRepository: YamadoriRepository {
    private let storage: StorageService
    private var trips: [Yamadori] = []
    private var finds: [YamadoriFind] = []
    private var didLoad = false

    init(storage: StorageService) {
        self.storage = storage
    }

    // MARK: - Trips

    func getAllYamadori() -> [Yamadori] {
        ensureLoaded()
        return trips
    }

    func getYamadori(id: UUID) -> Yamadori? {
        ensureLoaded()
        return trips.first { $0.id == id }
    }

    func createYamadori(_ yamadori: Yamadori) throws -> Yamadori {
        ensureLoaded()
        guard !trips.contains(where: { $0.id == yamadori.id }) else {
            throw YamadoriRepositoryError.duplicateID(yamadori.id)
        }
        trips.append(yamadori)
        try persist()
        return yamadori
    }

    func updateYamadori(_ yamadori: Yamadori) throws -> Yamadori {
        ensureLoaded()
        guard let index = trips.firstIndex(where: { $0.id == yamadori.id }) else {
            throw YamadoriRepositoryError.notFound(yamadori.id)
        }
        trips[index] = yamadori
        try persist()
        return yamadori
    }

    func deleteYamadori(id: UUID) throws {
        ensureLoaded()
        guard trips.contains(where: { $0.id == id }) else {
            throw YamadoriRepositoryError.notFound(id)
        }
        trips.removeAll { $0.id == id }
        finds.removeAll { $0.yamadoriID == id }
        try persist()
    }

    // MARK: - Finds

    func getAllFinds() -> [YamadoriFind] {
        ensureLoaded()
        return finds
    }

    func getFind(id: UUID) -> YamadoriFind? {
        ensureLoaded()
        return finds.first { $0.id == id }
    }

    func finds(forYamadoriID yamadoriID: UUID) -> [YamadoriFind] {
        ensureLoaded()
        return finds.filter { $0.yamadoriID == yamadoriID }
    }

    func createFind(_ find: YamadoriFind) throws -> YamadoriFind {
        ensureLoaded()
        guard trips.contains(where: { $0.id == find.yamadoriID }) else {
            throw YamadoriRepositoryError.notFound(find.yamadoriID)
        }
        guard !finds.contains(where: { $0.id == find.id }) else {
            throw YamadoriRepositoryError.duplicateID(find.id)
        }
        finds.append(find)
        try persist()
        return find
    }

    func updateFind(_ find: YamadoriFind) throws -> YamadoriFind {
        ensureLoaded()
        guard let index = finds.firstIndex(where: { $0.id == find.id }) else {
            throw YamadoriRepositoryError.notFound(find.id)
        }
        finds[index] = find
        try persist()
        return find
    }

    func deleteFind(id: UUID) throws {
        ensureLoaded()
        guard finds.contains(where: { $0.id == id }) else {
            throw YamadoriRepositoryError.notFound(id)
        }
        finds.removeAll { $0.id == id }
        try persist()
    }

    // MARK: - Persistence

    private func ensureLoaded() {
        guard !didLoad else { return }
        didLoad = true
        let loaded = loadFromDisk()
        trips = loaded.trips
        finds = loaded.finds
        if loaded.needsRewrite {
            try? persist()
        }
    }

    private struct LoadResult {
        var trips: [Yamadori]
        var finds: [YamadoriFind]
        var needsRewrite: Bool
    }

    private func loadFromDisk() -> LoadResult {
        do {
            guard let data = try storage.loadPackageFile(
                relativePath: LibraryPackageLayout.yamadoriFileName
            ) else {
                return LoadResult(trips: [], finds: [], needsRewrite: false)
            }
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601

            if let file = try? decoder.decode(LibraryYamadoriFile.self, from: data),
               file.schemaVersion >= 2 {
                return LoadResult(trips: file.trips, finds: file.finds, needsRewrite: false)
            }

            if let v1 = try? decoder.decode(LibraryYamadoriFileV1.self, from: data) {
                var trips: [Yamadori] = []
                var finds: [YamadoriFind] = []
                for record in v1.records {
                    let pair = record.migratedTripAndFind()
                    trips.append(pair.0)
                    finds.append(pair.1)
                }
                return LoadResult(trips: trips, finds: finds, needsRewrite: true)
            }

            return LoadResult(trips: [], finds: [], needsRewrite: false)
        } catch {
            return LoadResult(trips: [], finds: [], needsRewrite: false)
        }
    }

    private func persist() throws {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        encoder.dateEncodingStrategy = .iso8601
        let data: Data
        do {
            data = try encoder.encode(LibraryYamadoriFile(trips: trips, finds: finds))
        } catch {
            throw LibraryYamadoriRepositoryError.encodeFailed
        }
        do {
            try storage.savePackageFile(
                relativePath: LibraryPackageLayout.yamadoriFileName,
                data: data
            )
        } catch {
            throw LibraryYamadoriRepositoryError.writeFailed(error.localizedDescription)
        }
    }
}
