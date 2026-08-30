//
//  ImagePresentationStore.swift
//  Bonsai World
//
//  Persists non-destructive presentation recipes to Images/Presentations.json.
//  Original image bytes are never modified. One recipe per (image, context).
//

import Foundation
import Observation

@Observable
@MainActor
final class ImagePresentationStore {
    private struct RecipeKey: Hashable {
        let imageID: UUID
        let contextID: String
    }

    private var recipes: [RecipeKey: ImagePresentationMetadata] = [:]

    private weak var storage: StorageService?

    init(storage: StorageService? = nil) {
        self.storage = storage
        if let storage {
            loadFromDisk(storage: storage)
        }
    }

    func attachStorage(_ storage: StorageService) {
        self.storage = storage
        loadFromDisk(storage: storage)
    }

    /// Exact recipe for `context`, or the legacy single crop when `context` is `nil`.
    func metadata(for imageID: UUID, context: ImagePresentationContext?) -> ImagePresentationMetadata? {
        recipes[RecipeKey(imageID: imageID, contextID: context?.rawValue ?? "")]
    }

    func save(_ metadata: ImagePresentationMetadata) {
        save([metadata])
    }

    func save(_ items: [ImagePresentationMetadata]) {
        for item in items {
            let key = RecipeKey(
                imageID: item.sourceImageID,
                contextID: item.contextID ?? ""
            )
            recipes[key] = item
        }
        persist()
    }

    func remove(for imageID: UUID) {
        recipes = recipes.filter { $0.key.imageID != imageID }
        persist()
    }

    // MARK: - Persistence

    private func loadFromDisk(storage: StorageService) {
        do {
            guard let data = try storage.loadPackageFile(
                relativePath: LibraryPackageLayout.imagesPresentationsFileName
            ) else { return }
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let decoded = try decoder.decode([ImagePresentationMetadata].self, from: data)
            var loaded: [RecipeKey: ImagePresentationMetadata] = [:]
            for recipe in decoded {
                let key = RecipeKey(
                    imageID: recipe.sourceImageID,
                    contextID: recipe.contextID ?? ""
                )
                loaded[key] = recipe
            }
            recipes = loaded
        } catch {
            // Keep in-memory state if disk file is missing or corrupt.
        }
    }

    private func persist() {
        guard let storage else { return }
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
            encoder.dateEncodingStrategy = .iso8601
            let data = try encoder.encode(Array(recipes.values))
            try storage.savePackageFile(
                relativePath: LibraryPackageLayout.imagesPresentationsFileName,
                data: data
            )
        } catch {
            // Best-effort — Original bytes remain authoritative.
        }
    }
}
