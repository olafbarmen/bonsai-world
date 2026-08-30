//
//  PreviewLocationRepository.swift
//  Bonsai World
//
//  LocationRepository backed by ReferencePreviewData only.
//  Used before a Library exists (First Launch Wizard), as the
//  LocationMigrationService source, and by SwiftUI #Preview fixtures.
//

import Foundation

/// In-memory `LocationRepository` for pre-library sessions and previews.
@MainActor
final class PreviewLocationRepository: LocationRepository {
    private let store: ReferencePreviewData

    init(store: ReferencePreviewData) {
        self.store = store
    }

    func getAllLocations() -> [LocationReference] {
        store.locations
    }

    func getLocation(id: UUID) -> LocationReference? {
        store.locations.first { $0.id == id }
    }

    func replaceCatalog(with locations: [LocationReference]) throws {
        store.locations = locations
    }

    func discardPersistedCatalog() throws {
        // No persisted file before a Library exists — nothing to discard.
    }
}
