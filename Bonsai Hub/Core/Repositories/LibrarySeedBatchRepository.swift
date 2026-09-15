//
//  LibrarySeedBatchRepository.swift
//  Bonsai World
//

import Foundation
import Observation

struct LibrarySeedBatchesFile: Codable, Hashable, Sendable {
    var schemaVersion: Int
    var batches: [SeedBatch]

    init(schemaVersion: Int = 1, batches: [SeedBatch] = []) {
        self.schemaVersion = schemaVersion
        self.batches = batches
    }
}

enum LibrarySeedBatchRepositoryError: Error, LocalizedError, Sendable {
    case encodeFailed
    case writeFailed(String)

    var errorDescription: String? {
        switch self {
        case .encodeFailed:
            return "The seed batch catalog could not be encoded."
        case .writeFailed(let detail):
            return "The seed batch catalog could not be saved (\(detail))."
        }
    }
}

@Observable
@MainActor
final class LibrarySeedBatchRepository: SeedBatchRepository {
    private let storage: StorageService
    private var batches: [SeedBatch] = []
    private var didLoad = false

    init(storage: StorageService) {
        self.storage = storage
    }

    func getAllBatches() -> [SeedBatch] {
        ensureLoaded()
        return batches
    }

    func getBatch(id: UUID) -> SeedBatch? {
        ensureLoaded()
        return batches.first { $0.id == id }
    }

    func createBatch(_ batch: SeedBatch) throws -> SeedBatch {
        ensureLoaded()
        guard !batches.contains(where: { $0.id == batch.id }) else {
            throw SeedBatchRepositoryError.duplicateID(batch.id)
        }
        batches.append(batch)
        try persist()
        return batch
    }

    func updateBatch(_ batch: SeedBatch) throws -> SeedBatch {
        ensureLoaded()
        guard let index = batches.firstIndex(where: { $0.id == batch.id }) else {
            throw SeedBatchRepositoryError.notFound(batch.id)
        }
        batches[index] = batch
        try persist()
        return batch
    }

    func deleteBatch(id: UUID) throws {
        ensureLoaded()
        guard batches.contains(where: { $0.id == id }) else {
            throw SeedBatchRepositoryError.notFound(id)
        }
        batches.removeAll { $0.id == id }
        try persist()
    }

    private func ensureLoaded() {
        guard !didLoad else { return }
        didLoad = true
        batches = loadFromDisk()
    }

    private func loadFromDisk() -> [SeedBatch] {
        do {
            guard let data = try storage.loadPackageFile(relativePath: LibraryPackageLayout.seedBatchesFileName),
                  !data.isEmpty
            else { return [] }
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let file = try decoder.decode(LibrarySeedBatchesFile.self, from: data)
            return file.batches
        } catch {
            return []
        }
    }

    private func persist() throws {
        let file = LibrarySeedBatchesFile(batches: batches)
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        encoder.dateEncodingStrategy = .iso8601
        guard let data = try? encoder.encode(file) else {
            throw SeedBatchRepositoryError.invalidBatch(
                LibrarySeedBatchRepositoryError.encodeFailed.localizedDescription
            )
        }
        do {
            try storage.savePackageFile(relativePath: LibraryPackageLayout.seedBatchesFileName, data: data)
        } catch {
            throw SeedBatchRepositoryError.invalidBatch(
                LibrarySeedBatchRepositoryError.writeFailed(error.localizedDescription).localizedDescription
            )
        }
    }
}

@MainActor
final class PreviewSeedBatchRepository: SeedBatchRepository {
    private var batches: [SeedBatch]

    init(batches: [SeedBatch] = []) {
        self.batches = batches
    }

    func getAllBatches() -> [SeedBatch] { batches }

    func getBatch(id: UUID) -> SeedBatch? {
        batches.first { $0.id == id }
    }

    func createBatch(_ batch: SeedBatch) throws -> SeedBatch {
        guard getBatch(id: batch.id) == nil else {
            throw SeedBatchRepositoryError.duplicateID(batch.id)
        }
        batches.append(batch)
        return batch
    }

    func updateBatch(_ batch: SeedBatch) throws -> SeedBatch {
        guard let index = batches.firstIndex(where: { $0.id == batch.id }) else {
            throw SeedBatchRepositoryError.notFound(batch.id)
        }
        batches[index] = batch
        return batch
    }

    func deleteBatch(id: UUID) throws {
        guard batches.contains(where: { $0.id == id }) else {
            throw SeedBatchRepositoryError.notFound(id)
        }
        batches.removeAll { $0.id == id }
    }
}
