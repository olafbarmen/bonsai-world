//
//  ImageImportService.swift
//  Bonsai World
//
//  Finder-based single-image import into the Bonsai World Library.
//  Reads the picked file, copies bytes via StorageService, and creates ImageAsset metadata.
//  TreeDetailView must call this service — never touch the file system itself.
//

import AppKit
import Foundation
import Observation
import UniformTypeIdentifiers

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

    init(storage: StorageService, imageCatalog: ImagePreviewData) {
        self.storage = storage
        self.imageCatalog = imageCatalog
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
        let size = pixelSize(of: data)
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
        try await withCheckedThrowingContinuation { continuation in
            let panel = NSOpenPanel()
            panel.title = "Choose a Tree Image"
            panel.message = "Select a HEIC, JPEG, PNG, or TIFF image."
            panel.prompt = "Import"
            panel.allowsMultipleSelection = false
            panel.canChooseDirectories = false
            panel.canChooseFiles = true
            panel.allowedContentTypes = Self.allowedContentTypes

            panel.begin { response in
                if response == .OK, let url = panel.url {
                    continuation.resume(returning: url)
                } else {
                    continuation.resume(throwing: ImageImportError.cancelled)
                }
            }
        }
    }

    // MARK: - Helpers

    private static let allowedContentTypes: [UTType] = [
        .heic,
        .jpeg,
        .png,
        .tiff
    ]

    static let supportedExtensions: Set<String> = [
        "heic", "heif", "jpg", "jpeg", "png", "tif", "tiff"
    ]

    private func normalizedExtension(for url: URL) -> String {
        url.pathExtension.lowercased()
    }

    private func pixelSize(of data: Data) -> (width: Int, height: Int) {
        guard let image = NSImage(data: data) else { return (0, 0) }
        if let rep = image.representations.first {
            let wide = rep.pixelsWide
            let high = rep.pixelsHigh
            if wide > 0, high > 0 {
                return (wide, high)
            }
        }
        return (Int(image.size.width.rounded()), Int(image.size.height.rounded()))
    }
}
