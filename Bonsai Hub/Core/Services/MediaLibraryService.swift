//
//  MediaLibraryService.swift
//  Bonsai World
//

import Foundation
import Observation

enum MediaLibraryServiceError: Error, LocalizedError, Sendable {
    case notFound(UUID)
    case missingTitle

    var errorDescription: String? {
        switch self {
        case .notFound(let id):
            return "Media item not found (\(id.uuidString))."
        case .missingTitle:
            return "Enter a title."
        }
    }
}

@Observable
@MainActor
final class MediaLibraryService {
    private var repository: any MediaLibraryRepository
    private(set) var items: [MediaLibraryItem] = []

    init(repository: any MediaLibraryRepository) {
        self.repository = repository
        reload()
    }

    func attachRepository(_ repository: any MediaLibraryRepository) {
        self.repository = repository
        reload()
    }

    private func reload() {
        items = repository.getAllItems().sorted { $0.updatedAt > $1.updatedAt }
    }

    func item(id: UUID) -> MediaLibraryItem? {
        items.first { $0.id == id }
    }

    func items(kind: MediaLibraryKind) -> [MediaLibraryItem] {
        items.filter { $0.kind == kind }
    }

    @discardableResult
    func create(_ draft: MediaLibraryCreateDraft) throws -> MediaLibraryItem {
        let title = draft.title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !title.isEmpty else { throw MediaLibraryServiceError.missingTitle }
        let item = MediaLibraryItem(
            id: draft.id,
            kind: draft.kind,
            title: title,
            notes: draft.notes.trimmingCharacters(in: .whitespacesAndNewlines),
            relativePath: draft.relativePath
        )
        let saved = try repository.createItem(item)
        reload()
        return saved
    }

    @discardableResult
    func updateNotes(id: UUID, notes: String) throws -> MediaLibraryItem {
        guard var item = repository.getItem(id: id) else {
            throw MediaLibraryServiceError.notFound(id)
        }
        item.notes = notes.trimmingCharacters(in: .whitespacesAndNewlines)
        item.updatedAt = .now
        let saved = try repository.updateItem(item)
        reload()
        return saved
    }

    func delete(id: UUID) throws {
        try repository.deleteItem(id: id)
        reload()
    }
}
