//
//  ImageFilePicking.swift
//  Bonsai World
//
//  Platform-independent contract for choosing image file(s) on disk.
//  Services (e.g. ImageImportService) depend on this protocol only — never on
//  a concrete OS picker. macOS conformance: Platform/macOS/MacImagePicker.swift.
//

import Foundation

/// Presents a native file chooser scoped to supported image types.
protocol ImageFilePicking: Sendable {
    /// Single-file picker (profile photo, etc.).
    func pickImageFile(title: String, message: String, prompt: String) async throws -> URL

    /// Multi-file picker (tree gallery, etc.). Empty selection / Cancel → ``ImageFilePickingCancelled``.
    func pickImageFiles(title: String, message: String, prompt: String) async throws -> [URL]
}

/// Thrown when the platform picker is dismissed without a selection.
struct ImageFilePickingCancelled: Error, LocalizedError, Sendable {
    var errorDescription: String? { "Image import was cancelled." }
}
