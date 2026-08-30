//
//  ImagePreviewData.swift
//  Bonsai World
//
//  Image / Tree Photo metadata catalog.
//  Persists to Images/Catalog.json via StorageService.
//

import Foundation
import Observation

/// Image metadata store. Loads/saves the library photo catalog.
@Observable
@MainActor
final class ImagePreviewData {
    /// All known image assets keyed by identity.
    var assets: [UUID: ImageAsset]

    private weak var storage: StorageService?

    init(assets: [ImageAsset] = ImagePreviewSeed.all, storage: StorageService? = nil) {
        self.assets = Dictionary(uniqueKeysWithValues: assets.map { ($0.id, $0) })
        self.storage = storage
        if let storage {
            loadFromDisk(storage: storage)
        }
    }

    /// Attach storage and reload catalog from disk (call after library is ready).
    func attachStorage(_ storage: StorageService) {
        self.storage = storage
        loadFromDisk(storage: storage)
    }

    func asset(id: UUID) -> ImageAsset? {
        assets[id]
    }

    func assets(ids: [UUID]) -> [ImageAsset] {
        ids.compactMap { assets[$0] }
    }

    func allAssets() -> [ImageAsset] {
        Array(assets.values)
    }

    func displayName(for id: UUID) -> String {
        guard let asset = assets[id] else {
            return ImageAsset.defaultPhotoName()
        }
        let name = asset.photoName.trimmingCharacters(in: .whitespacesAndNewlines)
        return name.isEmpty ? ImageAsset.defaultPhotoName(for: asset.captureDate) : name
    }

    func upsert(_ asset: ImageAsset) {
        assets[asset.id] = asset
        persist()
    }

    func updatePhotoName(id: UUID, photoName: String) {
        guard var asset = assets[id] else { return }
        let trimmed = photoName.trimmingCharacters(in: .whitespacesAndNewlines)
        asset.photoName = trimmed.isEmpty
            ? ImageAsset.defaultPhotoName(for: asset.captureDate)
            : trimmed
        asset.modifiedDate = .now
        assets[id] = asset
        persist()
    }

    func updateCaptureDate(id: UUID, captureDate: Date) {
        guard var asset = assets[id] else { return }
        asset.captureDate = captureDate
        asset.modifiedDate = .now
        assets[id] = asset
        persist()
    }

    func updatePhotoMetadata(id: UUID, photoName: String, captureDate: Date) {
        guard var asset = assets[id] else { return }
        let trimmed = photoName.trimmingCharacters(in: .whitespacesAndNewlines)
        asset.captureDate = captureDate
        asset.photoName = trimmed.isEmpty
            ? ImageAsset.defaultPhotoName(for: captureDate)
            : trimmed
        asset.modifiedDate = .now
        assets[id] = asset
        persist()
    }

    func remove(id: UUID) {
        assets.removeValue(forKey: id)
        persist()
    }

    /// Clears `isPrimary` on all catalog assets (before promoting a new primary).
    func clearPrimaryFlags() {
        var changed = false
        for (id, var asset) in assets where asset.isPrimary {
            asset.isPrimary = false
            assets[id] = asset
            changed = true
        }
        if changed { persist() }
    }

    func setPrimaryFlag(id: UUID) {
        clearPrimaryFlags()
        guard var asset = assets[id] else { return }
        asset.isPrimary = true
        asset.modifiedDate = .now
        assets[id] = asset
        persist()
    }

    // MARK: - Persistence

    private func loadFromDisk(storage: StorageService) {
        do {
            guard let data = try storage.loadPackageFile(
                relativePath: LibraryPackageLayout.imagesCatalogFileName
            ) else { return }
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let decoded = try decoder.decode([ImageAsset].self, from: data)
            assets = Dictionary(uniqueKeysWithValues: decoded.map { ($0.id, $0) })
        } catch {
            // Keep in-memory catalog if disk catalog is missing or corrupt.
        }
    }

    private func persist() {
        guard let storage else { return }
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
            encoder.dateEncodingStrategy = .iso8601
            let data = try encoder.encode(Array(assets.values))
            try storage.savePackageFile(
                relativePath: LibraryPackageLayout.imagesCatalogFileName,
                data: data
            )
        } catch {
            // Best-effort persistence; bytes on disk remain authoritative for pixels.
        }
    }
}

/// Seed metadata placeholders. Empty until import — do not invent files.
enum ImagePreviewSeed {
    static let all: [ImageAsset] = []
}
