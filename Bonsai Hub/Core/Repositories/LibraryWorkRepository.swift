//
//  LibraryWorkRepository.swift
//  Bonsai World
//
//  WorkRepository backed by Database/Work.json in the library package.
//  Full CRUD — Work records accumulate one entry per registered activity.
//

import Foundation
import Observation

/// On-disk work catalog envelope for `Database/Work.json`.
struct LibraryWorkFile: Codable, Hashable, Sendable {
    var records: [WorkRecord]

    init(records: [WorkRecord] = []) {
        self.records = records
    }
}

/// Errors from library work catalog persistence.
enum LibraryWorkRepositoryError: Error, LocalizedError, Sendable {
    case encodeFailed
    case writeFailed(String)

    var errorDescription: String? {
        switch self {
        case .encodeFailed:
            return "The work catalog could not be encoded."
        case .writeFailed(let detail):
            return "The work catalog could not be saved (\(detail))."
        }
    }
}

/// Library-backed `WorkRepository` implementation.
@Observable
@MainActor
final class LibraryWorkRepository: WorkRepository {
    private let storage: StorageService

    init(storage: StorageService) {
        self.storage = storage
    }

    // MARK: - Reads

    func getAllWork() -> [WorkRecord] {
        loadWorkFromDisk()
    }

    func getWork(id: UUID) -> WorkRecord? {
        loadWorkFromDisk().first { $0.id == id }
    }

    // MARK: - Writes

    @discardableResult
    func createWork(_ record: WorkRecord) throws -> WorkRecord {
        var records = loadWorkFromDisk()
        if records.contains(where: { $0.id == record.id }) {
            throw WorkRepositoryError.invalidWork("A work record with this id already exists.")
        }

        records.append(record)

        do {
            try persistAllWorkToDisk(records)
        } catch let error as LibraryWorkRepositoryError {
            throw WorkRepositoryError.invalidWork(error.localizedDescription)
        }

        return record
    }

    @discardableResult
    func updateWork(_ record: WorkRecord) throws -> WorkRecord {
        var records = loadWorkFromDisk()
        guard let index = records.firstIndex(where: { $0.id == record.id }) else {
            throw WorkRepositoryError.notFound(record.id)
        }

        records[index] = record

        do {
            try persistAllWorkToDisk(records)
        } catch let error as LibraryWorkRepositoryError {
            throw WorkRepositoryError.invalidWork(error.localizedDescription)
        }

        return record
    }

    func deleteWork(id: UUID) throws {
        var records = loadWorkFromDisk()
        guard records.contains(where: { $0.id == id }) else {
            throw WorkRepositoryError.notFound(id)
        }

        records.removeAll { $0.id == id }

        do {
            try persistAllWorkToDisk(records)
        } catch let error as LibraryWorkRepositoryError {
            throw WorkRepositoryError.invalidWork(error.localizedDescription)
        }
    }

    // MARK: - Private

    /// Loads work records from disk. Returns `[]` when the file is missing or unreadable.
    /// Does not create, seed, or modify any file.
    private func loadWorkFromDisk() -> [WorkRecord] {
        do {
            guard let data = try storage.loadPackageFile(
                relativePath: LibraryPackageLayout.workFileName
            ) else {
                return []
            }
            let decoder = JSONDecoder()
            let file = try decoder.decode(LibraryWorkFile.self, from: data)
            return file.records
        } catch {
            return []
        }
    }

    /// Encodes and writes the full work catalog to `Database/Work.json`.
    ///
    /// Overwrites any existing file. Creates the file (and parent folders) on first call.
    private func persistAllWorkToDisk(_ records: [WorkRecord]) throws {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]

        let file = LibraryWorkFile(records: records)
        let data: Data
        do {
            data = try encoder.encode(file)
        } catch {
            throw LibraryWorkRepositoryError.encodeFailed
        }

        do {
            try storage.savePackageFile(
                relativePath: LibraryPackageLayout.workFileName,
                data: data
            )
        } catch {
            throw LibraryWorkRepositoryError.writeFailed(error.localizedDescription)
        }
    }
}
