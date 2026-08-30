//
//  DirectoryPicking.swift
//  Bonsai World
//
//  Platform-independent contract for choosing a folder on disk.
//  Services (e.g. LibraryService) depend on this protocol only — never on a
//  concrete OS picker. macOS conformance: Platform/macOS/MacDirectoryPicker.swift.
//  Windows / iOS provide their own conformance when those platforms ship
//  (Constitution §11 — platform-specific implementations stay isolated).
//

import Foundation

/// Presents a native folder chooser and returns the chosen location.
protocol DirectoryPicking: Sendable {
    func pickDirectory(title: String, message: String, prompt: String) async throws -> URL
}

/// Thrown when the platform picker is dismissed without a selection.
struct DirectoryPickingCancelled: Error, LocalizedError, Sendable {
    var errorDescription: String? { "No folder was selected." }
}
