//
//  PreviewJournalRepository.swift
//  Bonsai World
//
//  In-memory JournalRepository for previews and pre-library sessions.
//

import Foundation
import Observation

@Observable
@MainActor
final class PreviewJournalRepository: JournalRepository {
    private var records: [JournalEntry]

    init(records: [JournalEntry] = []) {
        self.records = records
    }

    func getAllEntries() -> [JournalEntry] {
        records
    }

    func getEntry(id: UUID) -> JournalEntry? {
        records.first { $0.id == id }
    }

    @discardableResult
    func createEntry(_ entry: JournalEntry) throws -> JournalEntry {
        guard !records.contains(where: { $0.id == entry.id }) else {
            throw JournalRepositoryError.invalidEntry("A journal entry with this id already exists.")
        }
        let trimmed = entry.text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            throw JournalRepositoryError.invalidEntry("Journal text cannot be empty.")
        }
        var saved = entry
        saved.text = trimmed
        records.append(saved)
        return saved
    }

    @discardableResult
    func updateEntry(_ entry: JournalEntry) throws -> JournalEntry {
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
        return saved
    }

    func deleteEntry(id: UUID) throws {
        guard records.contains(where: { $0.id == id }) else {
            throw JournalRepositoryError.notFound(id)
        }
        records.removeAll { $0.id == id }
    }
}
