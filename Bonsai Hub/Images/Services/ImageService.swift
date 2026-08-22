//
//  ImageService.swift
//  Bonsai World
//
//  Image metadata and gallery access for Trees.
//  All file I/O goes through StorageService — never the file system directly.
//

import Foundation
import Observation

/// App-wide image facade. Inject via `.environment`.
@Observable
@MainActor
final class ImageService {
    private let storage: StorageService
    private let previewData: ImagePreviewData

    init(storage: StorageService, previewData: ImagePreviewData) {
        self.storage = storage
        self.previewData = previewData
    }

    // MARK: - Metadata

    /// Loads metadata for a single image asset (catalog only).
    func metadata(for id: UUID) -> ImageAsset? {
        previewData.asset(id: id)
    }

    /// Loads metadata for many assets, preserving `ids` order.
    func metadata(for ids: [UUID]) -> [ImageAsset] {
        previewData.assets(ids: ids)
    }

    // MARK: - Tree gallery

    /// Primary image metadata for a tree, if `primaryImageID` resolves.
    func primaryImage(for tree: Tree) -> ImageAsset? {
        guard let primaryImageID = tree.primaryImageID else { return nil }
        return previewData.asset(id: primaryImageID)
    }

    /// Gallery image metadata for a tree (`imageIDs` order).
    func galleryImages(for tree: Tree) -> [ImageAsset] {
        previewData.assets(ids: tree.imageIDs)
    }

    // MARK: - Storage bridge

    /// Storage identity matching an `ImageAsset.id`.
    func storageAssetID(for imageID: UUID) -> StorageAssetID {
        StorageAssetID(imageID)
    }

    /// Loads original image bytes via StorageService (for display).
    func loadOriginalData(for id: UUID) async throws -> Data {
        guard let asset = previewData.asset(id: id) else {
            throw StorageError.assetNotFound(StorageAssetID(id))
        }
        let fileExtension = Self.fileExtension(fromRelativePath: asset.relativePath, fileName: asset.fileName)
        return try await storage.loadImage(
            id: StorageAssetID(id),
            fileExtension: fileExtension
        )
    }

    /// Display name for filmstrip (Photo Name, never file name).
    func photoName(for id: UUID) -> String {
        previewData.displayName(for: id)
    }

    /// Capture Date for filmstrip / sorting (falls back to Import Date).
    func captureDate(for id: UUID) -> Date {
        previewData.asset(id: id)?.captureDate ?? .now
    }

    func setPrimaryFlag(id: UUID) {
        previewData.setPrimaryFlag(id: id)
    }

    func updatePhotoName(id: UUID, photoName: String) {
        previewData.updatePhotoName(id: id, photoName: photoName)
    }

    func updateCaptureDate(id: UUID, captureDate: Date) {
        previewData.updateCaptureDate(id: id, captureDate: captureDate)
    }

    func updatePhotoMetadata(id: UUID, photoName: String, captureDate: Date) {
        previewData.updatePhotoMetadata(id: id, photoName: photoName, captureDate: captureDate)
    }

    /// Removes catalog entry and deletes original bytes from the library.
    func deletePhoto(id: UUID) async throws {
        let asset = previewData.asset(id: id)
        let fileExtension: String
        if let asset {
            fileExtension = Self.fileExtension(fromRelativePath: asset.relativePath, fileName: asset.fileName)
        } else {
            fileExtension = "jpg"
        }
        try await storage.deleteImage(id: StorageAssetID(id), fileExtension: fileExtension)
        previewData.remove(id: id)
    }

    private static func fileExtension(fromRelativePath relativePath: String, fileName: String) -> String {
        let fromPath = (relativePath as NSString).pathExtension
        if !fromPath.isEmpty { return fromPath.lowercased() }
        let fromName = (fileName as NSString).pathExtension
        if !fromName.isEmpty { return fromName.lowercased() }
        return "jpg"
    }
}
