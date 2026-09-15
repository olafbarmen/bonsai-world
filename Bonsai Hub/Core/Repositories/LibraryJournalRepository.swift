//
//  LibraryJournalRepository.swift
//  Bonsai World
//
//  JournalRepository backed by Database/Journal.json in the library package.
//

import Foundation
import Observation

struct LibraryJournalFile: Codable, Hashable, Sendable {
    var records: [JournalEntry]

    init(records: [JournalEntry] = []) {
        self.records = records
    }
}

enum LibraryJournalRepositoryError: Error, LocalizedError, Sendable {
    case encodeFailed
    case writeFailed(String)

    var errorDescription: String? {
        switch self {
        case .encodeFailed:
            return "The journal catalog could not be encoded."
        case .writeFailed(let detail):
            return "The journal catalog could not be saved (\(detail))."
        }
    }
}

@Observable
@MainActor
final class LibraryJournalRepository: JournalRepository {
    private let storage: StorageService

    init(storage: StorageService) {
        self.storage = storage
    }

    func getAllEntries() -> [JournalEntry] {
        loadFromDisk()
    }

    func getEntry(id: UUID) -> JournalEntry? {
        loadFromDisk().first { $0.id == id }
    }

    @discardableResult
    func createEntry(_ entry: JournalEntry) throws -> JournalEntry {
        var records = loadFromDisk()
        if records.contains(where: { $0.id == entry.id }) {
            throw JournalRepositoryError.invalidEntry("A journal entry with this id already exists.")
        }
        let trimmed = entry.text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            throw JournalRepositoryError.invalidEntry("Journal text cannot be empty.")
        }
        var saved = entry
        saved.text = trimmed
        records.append(saved)
        try persistAll(records)
        return saved
    }

    @discardableResult
    func updateEntry(_ entry: JournalEntry) throws -> JournalEntry {
        var records = loadFromDisk()
        guard let index = records.firstIndex(where: { $0.id == entry.id }) else {
            throw JournalRepositoryError.notFound(entry.id)
        }
        let trimmed = entry.text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            throw JournalRepositoryError.invalidEntry("Journal text cannot be empty.")
        }
        var saved = entry
        saved.text = trimmed
        records[index] = saved
        try persistAll(records)
        return saved
    }

    func deleteEntry(id: UUID) throws {
        var records = loadFromDisk()
        guard records.contains(where: { $0.id == id }) else {
            throw JournalRepositoryError.notFound(id)
        }
        records.removeAll { $0.id == id }
        try persistAll(records)
    }

    private func loadFromDisk() -> [JournalEntry] {
        do {
            guard let data = try storage.loadPackageFile(
                relativePath: LibraryPackageLayout.journalFileName
            ) else {
                return []
            }
            return try JSONDecoder().decode(LibraryJournalFile.self, from: data).records
        } catch {
            return []
        }
    }

    private func persistAll(_ records: [JournalEntry]) throws {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        let data: Data
        do {
            data = try encoder.encode(LibraryJournalFile(records: records))
        } catch {
            throw JournalRepositoryError.invalidEntry(
                LibraryJournalRepositoryError.encodeFailed.localizedDescription
            )
        }
        do {
            try storage.savePackageFile(
                relativePath: LibraryPackageLayout.journalFileName,
                data: data
            )
        } catch {
            throw JournalRepositoryError.invalidEntry(
                LibraryJournalRepositoryError.writeFailed(error.localizedDescription).localizedDescription
            )
        }
    }
}
