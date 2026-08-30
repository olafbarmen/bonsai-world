//
//  ImageFilePicking.swift
//  Bonsai World
//
//  Platform-independent contract for choosing a single image file on disk.
//  Services (e.g. ImageImportService) depend on this protocol only — never on
//  a concrete OS picker. macOS conformance: Platform/macOS/MacImagePicker.swift.
//

import Foundation

/// Presents a native file chooser scoped to supported image types.
protocol ImageFilePicking: Sendable {
    func pickImageFile(title: String, message: String, prompt: String) async throws -> URL
}

/// Thrown when the platform picker is dismissed without a selection.
struct ImageFilePickingCancelled: Error, LocalizedError, Sendable {
    var errorDescription: String? { "Image import was cancelled." }
}
