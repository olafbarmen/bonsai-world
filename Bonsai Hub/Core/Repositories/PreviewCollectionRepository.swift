//
//  PreviewCollectionRepository.swift
//  Bonsai World
//
//  CollectionRepository backed by PreviewData only.
//  Used for first launch (pre-library), CollectionMigrationService seeding,
//  and SwiftUI #Preview fixtures — not the runtime store once a library is ready.
//

import Foundation
import Observation

/// In-memory `CollectionRepository` for previews, wizard bootstrap, and migration source.
@Observable
@MainActor
final class PreviewCollectionRepository: CollectionRepository {
    private let previewData: PreviewData

    init(previewData: PreviewData) {
        self.previewData = previewData
    }

    func getAllCollections() -> [Collection] {
        previewData.collections
    }

    func getCollection(id: UUID) -> Collection? {
        previewData.collection(id: id)
    }

    @discardableResult
    func createCollection(_ collection: Collection) throws -> Collection {
        if previewData.collection(id: collection.id) != nil {
            throw CollectionRepositoryError.invalidCollection("A collection with this id already exists.")
        }
        return previewData.insertCollection(collection)
    }

    @discardableResult
    func updateCollection(_ collection: Collection) throws -> Collection {
        guard previewData.collection(id: collection.id) != nil else {
            throw CollectionRepositoryError.notFound(collection.id)
        }
        return previewData.replaceCollection(collection)
    }

    func deleteCollection(id: UUID) throws {
        guard previewData.collection(id: id) != nil else {
            throw CollectionRepositoryError.notFound(id)
        }
        previewData.removeCollection(id: id)
    }
}
