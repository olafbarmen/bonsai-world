//
//  KnowledgeResourceService.swift
//  Bonsai World
//

import Foundation
import Observation

enum KnowledgeResourceServiceError: Error, LocalizedError, Sendable {
    case notFound(UUID)
    case missingTitle

    var errorDescription: String? {
        switch self {
        case .notFound(let id):
            return "Knowledge resource not found (\(id.uuidString))."
        case .missingTitle:
            return "Enter a title."
        }
    }
}

@Observable
@MainActor
final class KnowledgeResourceService {
    private var repository: any KnowledgeResourceRepository
    private(set) var resources: [KnowledgeResource] = []

    init(repository: any KnowledgeResourceRepository) {
        self.repository = repository
        reload()
    }

    func attachRepository(_ repository: any KnowledgeResourceRepository) {
        self.repository = repository
        reload()
    }

    private func reload() {
        resources = repository.getAllResources().sorted {
            $0.title.localizedCaseInsensitiveCompare($1.title) == .orderedAscending
        }
    }

    func resource(id: UUID) -> KnowledgeResource? {
        resources.first { $0.id == id }
    }

    func resources(kind: KnowledgeResourceKind) -> [KnowledgeResource] {
        resources.filter { $0.kind == kind }
    }

    @discardableResult
    func create(_ draft: KnowledgeResourceCreateDraft) throws -> KnowledgeResource {
        let title = draft.title.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !title.isEmpty else { throw KnowledgeResourceServiceError.missingTitle }
        let resource = KnowledgeResource(
            kind: draft.kind,
            title: title,
            summary: draft.summary.trimmingCharacters(in: .whitespacesAndNewlines),
            body: draft.body.trimmingCharacters(in: .whitespacesAndNewlines),
            urlString: draft.urlString.trimmingCharacters(in: .whitespacesAndNewlines)
        )
        let saved = try repository.createResource(resource)
        reload()
        return saved
    }

    @discardableResult
    func update(_ resource: KnowledgeResource) throws -> KnowledgeResource {
        var next = resource
        next.updatedAt = .now
        let saved = try repository.updateResource(next)
        reload()
        return saved
    }

    func delete(id: UUID) throws {
        try repository.deleteResource(id: id)
        reload()
    }
}
