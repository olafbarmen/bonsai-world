//
//  ImageImportService.swift
//  Bonsai World
//
//  Finder-based image import into the Bonsai World Library.
//  Reads picked file(s), copies bytes via StorageService, and creates ImageAsset metadata.
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
        let url = try await pickSingleImageURL(
            title: "Choose a Tree Image",
            message: "Select a HEIC, JPEG, PNG, or TIFF image.",
            prompt: "Import"
        )
        return try await importImage(from: url, asPrimary: true)
    }

    /// Profile / sidebar avatar — same library import path, profile-oriented picker copy.
    func importProfileImageFromFinder() async throws -> ImageAsset {
        let url = try await pickSingleImageURL(
            title: "Choose Profile Photo",
            message: "Select a HEIC, JPEG, PNG, or TIFF image.",
            prompt: "Choose"
        )
        return try await importImage(from: url, asPrimary: false)
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
        return try await importImage(
            data: data,
            fileExtension: fileExtension,
            fileName: url.lastPathComponent,
            asPrimary: asPrimary
        )
    }

    /// Imports image bytes (Photos drag-and-drop, etc.).
    func importImage(
        data: Data,
        fileExtension: String,
        fileName: String,
        asPrimary: Bool
    ) async throws -> ImageAsset {
        let ext = fileExtension.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        guard Self.supportedExtensions.contains(ext) else {
            throw ImageImportError.unsupportedFormat
        }
        guard !data.isEmpty else { throw ImageImportError.emptyFile }

        let id = UUID()
        let size = pixelSizeReader.pixelSize(of: data)
        let now = Date.now
        let captureDate = ImageCaptureDateReader.captureDate(from: data) ?? now
        let relativePath = ImageAsset.originalsRelativePath(id: id, fileExtension: ext)
        let resolvedName = fileName.trimmingCharacters(in: .whitespacesAndNewlines)
        let asset = ImageAsset(
            id: id,
            fileName: resolvedName.isEmpty ? "Photo.\(ext)" : resolvedName,
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
            fileExtension: ext
        )

        if asPrimary {
            imageCatalog.clearPrimaryFlags()
        }
        imageCatalog.upsert(asset)
        return asset
    }

    func importImage(from source: ImageDropSource, asPrimary: Bool) async throws -> ImageAsset {
        switch source {
        case .fileURL(let url):
            return try await importImage(from: url, asPrimary: asPrimary)
        case .imageData(let data, let fileExtension, let fileName):
            return try await importImage(
                data: data,
                fileExtension: fileExtension,
                fileName: fileName,
                asPrimary: asPrimary
            )
        }
    }

    /// Imports one gallery photo (single-file Finder panel).
    func importGalleryImageFromFinder() async throws -> ImageAsset {
        let url = try await pickSingleImageURL(
            title: "Choose a Tree Image",
            message: "Select a HEIC, JPEG, PNG, or TIFF image.",
            prompt: "Import"
        )
        return try await importImage(from: url, asPrimary: false)
    }

    /// Multi-select Finder import for tree galleries (and similar). Order matches picker selection.
    func importGalleryImagesFromFinder() async throws -> [ImageAsset] {
        let urls = try await pickImageURLs(
            title: "Choose Tree Images",
            message: "Select one or more HEIC, JPEG, PNG, or TIFF images.",
            prompt: "Import",
            allowMultiple: true
        )
        var imported: [ImageAsset] = []
        imported.reserveCapacity(urls.count)
        for url in urls {
            imported.append(try await importImage(from: url, asPrimary: false))
        }
        return imported
    }

    // MARK: - Finder

    private func pickSingleImageURL(title: String, message: String, prompt: String) async throws -> URL {
        let urls = try await pickImageURLs(
            title: title,
            message: message,
            prompt: prompt,
            allowMultiple: false
        )
        guard let url = urls.first else { throw ImageImportError.cancelled }
        return url
    }

    private func pickImageURLs(
        title: String,
        message: String,
        prompt: String,
        allowMultiple: Bool
    ) async throws -> [URL] {
        do {
            if allowMultiple {
                return try await filePicker.pickImageFiles(
                    title: title,
                    message: message,
                    prompt: prompt
                )
            }
            let url = try await filePicker.pickImageFile(
                title: title,
                message: message,
                prompt: prompt
            )
            return [url]
        } catch is ImageFilePickingCancelled {
            throw ImageImportError.cancelled
        }
    }

    // MARK: - Helpers

    static let supportedExtensions: Set<String> = [
        "heic", "heif", "jpg", "jpeg", "png", "tif", "tiff", "webp"
    ]

    private func normalizedExtension(for url: URL) -> String {
        url.pathExtension.lowercased()
    }
}
