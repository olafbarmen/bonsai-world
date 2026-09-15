//
//  JournalService.swift
//  Bonsai World
//
//  Tree-scoped journal notes. Timeline and Tree History are consumers.
//

import Foundation
import Observation

enum JournalServiceError: Error, LocalizedError, Sendable {
    case emptyText

    var errorDescription: String? {
        switch self {
        case .emptyText:
            return "Write a journal note before saving."
        }
    }
}

@Observable
@MainActor
final class JournalService {
    private var journalRepository: JournalRepository

    private(set) var entries: [JournalEntry] = []
    private(set) var revision: Int = 0

    init(journalRepository: JournalRepository? = nil) {
        self.journalRepository = journalRepository ?? PreviewJournalRepository()
        entries = self.journalRepository.getAllEntries()
    }

    func attachLibraryJournalRepository(_ repository: JournalRepository) {
        journalRepository = repository
        entries = repository.getAllEntries()
        revision += 1
    }

    /// Newest first.
    func history(for treeID: UUID) -> [JournalEntry] {
        _ = revision
        return entries
            .filter { $0.treeID == treeID }
            .sorted { $0.recordedAt > $1.recordedAt }
    }

    @discardableResult
    func registerEntry(
        treeID: UUID,
        recordedAt: Date = .now,
        text: String,
        isBeforeOwnership: Bool = false
    ) throws -> JournalEntry {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { throw JournalServiceError.emptyText }

        let entry = JournalEntry(
            treeID: treeID,
            recordedAt: recordedAt,
            text: trimmed,
            isBeforeOwnership: isBeforeOwnership
        )
        try journalRepository.createEntry(entry)
        entries.append(entry)
        revision += 1
        return entry
    }

    @discardableResult
    func updateEntry(_ entry: JournalEntry) throws -> JournalEntry {
        var updated = entry
        updated.modifiedDate = .now
        let saved = try journalRepository.updateEntry(updated)
        if let index = entries.firstIndex(where: { $0.id == saved.id }) {
            entries[index] = saved
        }
        revision += 1
        return saved
    }

    func deleteEntry(id: UUID) throws {
        try journalRepository.deleteEntry(id: id)
        entries.removeAll { $0.id == id }
        revision += 1
    }
}
