//
//  ImageService.swift
//  Bonsai World
//
//  Image metadata and gallery access for Trees.
//  All file I/O goes through StorageService — never the file system directly.
//

import AppKit
import Foundation
import Observation

/// App-wide image facade. Inject via `.environment`.
@Observable
@MainActor
final class ImageService {
    private let storage: StorageService
    private let previewData: ImagePreviewData
    private let presentationStore: ImagePresentationStore
    /// Bumps when a crop recipe is saved or reset so display views reload.
    private(set) var presentationRevision: Int = 0
    /// Bumps when the image catalog gains/loses assets so Gallery refreshes.
    private(set) var catalogRevision: Int = 0
    /// In-memory decode cache only — must not invalidate @Observable views
    /// (cache writes used to re-render every ImageService observer and freeze
    /// sheets that load many tree thumbnails, e.g. Assign to Tree).
    @ObservationIgnored
    private var thumbnailCache: [String: NSImage] = [:]

    init(storage: StorageService, previewData: ImagePreviewData) {
        self.storage = storage
        self.previewData = previewData
        self.presentationStore = ImagePresentationStore(storage: storage)
        previewData.onCatalogChanged = { [weak self] in
            self?.catalogRevision += 1
        }
    }

    /// Re-load catalogs after the library package becomes ready.
    func attachStorage(_ storage: StorageService) {
        previewData.attachStorage(storage)
        presentationStore.attachStorage(storage)
        catalogRevision += 1
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

    /// All image assets in the library catalog (unordered).
    func allAssets() -> [ImageAsset] {
        previewData.allAssets()
    }

    /// Count of catalogued images — use in Gallery to establish observation when wired.
    var libraryImageCount: Int {
        let _ = catalogRevision
        return previewData.allAssets().count
    }

    /// Loads original image bytes via StorageService (for Crop and decode).
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

    /// Original pixels with the saved display crop for `context`. Original file is never modified.
    /// Pass `maxPixelSize` for list/grid thumbs so decode stays off the main thread and small.
    func loadDisplayNSImage(
        for id: UUID,
        context: ImagePresentationContext = .galleryCard,
        maxPixelSize: Int? = nil
    ) async throws -> NSImage {
        let cacheKey = "\(id.uuidString)-\(context.rawValue)-\(maxPixelSize ?? 0)-\(presentationRevision)"
        if maxPixelSize != nil, let cached = thumbnailCache[cacheKey] {
            return cached
        }

        let data = try await loadOriginalData(for: id)
        let recipe = presentationMetadata(for: id, context: context)
        let crop = recipe.cropNormalizedRect.cgRect
        let rotation = recipe.rotationDegrees
        let mirrored = recipe.isMirroredHorizontally
        let pixelSize = maxPixelSize
        let cgImage = await Task.detached(priority: .userInitiated) {
            ImagePresentationCropping.displayCGImage(
                from: data,
                normalizedCrop: crop,
                rotationDegrees: rotation,
                isMirroredHorizontally: mirrored,
                maxPixelSize: pixelSize
            )
        }.value
        guard let cgImage else {
            throw StorageError.assetNotFound(StorageAssetID(id))
        }
        let decoded = NSImage(
            cgImage: cgImage,
            size: NSSize(width: cgImage.width, height: cgImage.height)
        )
        if maxPixelSize != nil {
            thumbnailCache[cacheKey] = decoded
        }
        return decoded
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

    // MARK: - Presentation (non-destructive crop)

    /// Exact crop for `context`, or the legacy single crop, or a full-frame default.
    func presentationMetadata(
        for id: UUID,
        context: ImagePresentationContext
    ) -> ImagePresentationMetadata {
        presentationStore.metadata(for: id, context: context)
            ?? presentationStore.metadata(for: id, context: nil)
            ?? .defaultFullFrame(for: id)
    }

    /// Recipe saved for this context only — `nil` when the surface has never been cropped.
    func exactPresentationMetadata(
        for id: UUID,
        context: ImagePresentationContext
    ) -> ImagePresentationMetadata? {
        presentationStore.metadata(for: id, context: context)
    }

    /// Legacy single crop (no context), if one exists.
    func legacyPresentationMetadata(for id: UUID) -> ImagePresentationMetadata? {
        presentationStore.metadata(for: id, context: nil)
    }

    /// Persists presentation metadata only — never modifies Original bytes.
    func savePresentationMetadata(_ metadata: ImagePresentationMetadata) {
        savePresentationMetadata([metadata])
    }

    func savePresentationMetadata(_ items: [ImagePresentationMetadata]) {
        let stamped = items.map { item -> ImagePresentationMetadata in
            var saved = item
            saved.modifiedDate = .now
            return saved
        }
        presentationStore.save(stamped)
        thumbnailCache.removeAll()
        presentationRevision += 1
    }

    /// Shared clockwise rotation for an image’s recipes (0 when none saved).
    func presentationRotation(for id: UUID) -> Int {
        let degrees = presentationStore.recipes(for: id).first?.rotationDegrees ?? 0
        return ImagePresentationMetadata.normalizedRotation(degrees)
    }

    /// Shared horizontal mirror flag for an image’s recipes (false when none saved).
    func presentationIsMirroredHorizontally(for id: UUID) -> Bool {
        presentationStore.recipes(for: id).first?.isMirroredHorizontally ?? false
    }

    /// Rotate every saved recipe 90° clockwise. Creates a full-frame recipe when none exist.
    func rotatePresentationClockwise(for id: UUID) {
        let existing = presentationStore.recipes(for: id)
        if existing.isEmpty {
            savePresentationMetadata(
                ImagePresentationMetadata(
                    sourceImageID: id,
                    rotationDegrees: 90
                )
            )
            return
        }
        let updated = existing.map { item -> ImagePresentationMetadata in
            var next = item
            next.rotationDegrees = ImagePresentationMetadata.normalizedRotation(item.rotationDegrees + 90)
            next.cropNormalizedRect = item.cropNormalizedRect.rotatedClockwise90()
            return next
        }
        savePresentationMetadata(updated)
    }

    /// Removes saved crop — reverts to full-frame presentation.
    func resetPresentationMetadata(for id: UUID) {
        presentationStore.remove(for: id)
        thumbnailCache.removeAll()
        presentationRevision += 1
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
        presentationStore.remove(for: id)
        thumbnailCache.removeAll()
        presentationRevision += 1
    }

    private static func fileExtension(fromRelativePath relativePath: String, fileName: String) -> String {
        let fromPath = (relativePath as NSString).pathExtension
        if !fromPath.isEmpty { return fromPath.lowercased() }
        let fromName = (fileName as NSString).pathExtension
        if !fromName.isEmpty { return fromName.lowercased() }
        return "jpg"
    }
}
