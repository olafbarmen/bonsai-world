//
//  ImageImportService.swift
//  Bonsai World
//
//  Finder-based single-image import into the Bonsai World Library.
//  Reads the picked file, copies bytes via StorageService, and creates ImageAsset metadata.
//  TreeDetailView must call this service — never touch the file system itself.
//  File selection and pixel decoding go through ImageFilePicking / ImagePixelSizeReading —
//  this file never references a concrete OS picker or decoder (Constitution §11).
//

import Foundation
import Observation

/// Errors specific to image import from Finder.
enum ImageImportError: Error, LocalizedError, Sendable {
    case cancelled
    case unsupportedFormat
    case unreadableFile
    case emptyFile

    var errorDescription: String? {
        switch self {
        case .cancelled:
            "Image import was cancelled."
        case .unsupportedFormat:
            "That file type is not supported. Use HEIC, JPEG, PNG, or TIFF."
        case .unreadableFile:
            "The selected image could not be read."
        case .emptyFile:
            "The selected file is empty."
        }
    }
}

/// Imports a single local image into `Images/Originals/` via StorageService.
@Observable
@MainActor
final class ImageImportService {
    private let storage: StorageService
    private let imageCatalog: ImagePreviewData
    private let filePicker: ImageFilePicking
    private let pixelSizeReader: ImagePixelSizeReading

    init(
        storage: StorageService,
        imageCatalog: ImagePreviewData,
        filePicker: ImageFilePicking = MacImagePicker(),
        pixelSizeReader: ImagePixelSizeReading = MacImagePicker()
    ) {
        self.storage = storage
        self.imageCatalog = imageCatalog
        self.filePicker = filePicker
        self.pixelSizeReader = pixelSizeReader
    }

    /// Opens the macOS open panel, copies one image into the library, and returns metadata.
    func importPrimaryImageFromFinder() async throws -> ImageAsset {
        let url = try await pickSingleImageURL()
        return try await importImage(from: url, asPrimary: true)
    }

    /// Copies `url` into the library (security-scoped). Used by the Finder picker path.
    func importImage(from url: URL, asPrimary: Bool) async throws -> ImageAsset {
        let fileExtension = normalizedExtension(for: url)
        guard Self.supportedExtensions.contains(fileExtension) else {
            throw ImageImportError.unsupportedFormat
        }

        let didAccess = url.startAccessingSecurityScopedResource()
        defer {
            if didAccess { url.stopAccessingSecurityScopedResource() }
        }

        let data: Data
        do {
            data = try Data(contentsOf: url)
        } catch {
            throw ImageImportError.unreadableFile
        }
        guard !data.isEmpty else { throw ImageImportError.emptyFile }

        let id = UUID()
        let size = pixelSizeReader.pixelSize(of: data)
        let now = Date.now
        let captureDate = ImageCaptureDateReader.captureDate(from: data) ?? now
        let relativePath = ImageAsset.originalsRelativePath(id: id, fileExtension: fileExtension)

        let asset = ImageAsset(
            id: id,
            fileName: url.lastPathComponent,
            photoName: ImageAsset.defaultPhotoName(for: captureDate),
            relativePath: relativePath,
            createdDate: now,
            modifiedDate: now,
            fileSize: Int64(data.count),
            width: size.width,
            height: size.height,
            isPrimary: asPrimary,
            photoDate: captureDate,
            caption: "",
            photographer: "",
            camera: "",
            tags: [],
            notes: ""
        )

        try await storage.saveImage(
            id: StorageAssetID(id),
            data: data,
            fileExtension: fileExtension
        )

        if asPrimary {
            imageCatalog.clearPrimaryFlags()
        }
        imageCatalog.upsert(asset)
        return asset
    }

    /// Imports a gallery photo without forcing Primary (unless `asPrimary` is true).
    func importGalleryImageFromFinder() async throws -> ImageAsset {
        let url = try await pickSingleImageURL()
        return try await importImage(from: url, asPrimary: false)
    }

    // MARK: - Finder

    private func pickSingleImageURL() async throws -> URL {
        do {
            return try await filePicker.pickImageFile(
                title: "Choose a Tree Image",
                message: "Select a HEIC, JPEG, PNG, or TIFF image.",
                prompt: "Import"
            )
        } catch is ImageFilePickingCancelled {
            throw ImageImportError.cancelled
        }
    }

    // MARK: - Helpers

    static let supportedExtensions: Set<String> = [
        "heic", "heif", "jpg", "jpeg", "png", "tif", "tiff"
    ]

    private func normalizedExtension(for url: URL) -> String {
        url.pathExtension.lowercased()
    }
}
