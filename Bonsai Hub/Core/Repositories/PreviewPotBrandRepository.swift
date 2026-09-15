//
//  PreviewPotBrandRepository.swift
//  Bonsai World
//
//  PotBrandRepository backed by ReferencePreviewData only.
//  Used before a Library exists and by SwiftUI #Preview fixtures.
//

import Foundation

/// In-memory `PotBrandRepository` for pre-library sessions and previews.
@MainActor
final class PreviewPotBrandRepository: PotBrandRepository {
    private let store: ReferencePreviewData

    init(store: ReferencePreviewData) {
        self.store = store
    }

    func getAllBrands() -> [PotBrand] {
        store.potBrands
    }

    func getAllMakers() -> [PotMaker] {
        store.potMakers
    }

    func replaceCatalog(brands: [PotBrand], makers: [PotMaker], seedVersion: Int?) throws {
        store.potBrands = brands
        store.potMakers = makers
        _ = seedVersion
    }

    func getSeedVersion() -> Int? {
        nil
    }

    func discardPersistedCatalog() throws {
        // No persisted file before a Library exists — nothing to discard.
    }
}
