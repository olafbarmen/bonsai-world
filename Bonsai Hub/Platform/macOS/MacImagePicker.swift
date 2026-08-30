//
//  MacImagePicker.swift
//  Bonsai World
//
//  macOS conformance for ImageFilePicking and ImagePixelSizeReading. The only
//  file in the module allowed to reference NSOpenPanel / NSImage for import —
//  everything else (ImageImportService, Views) talks to these protocols only.
//

import AppKit
import Foundation
import UniformTypeIdentifiers

/// Stateless — the plain initializer stays usable as a default parameter value
/// from any isolation context; only the AppKit-touching methods are @MainActor.
struct MacImagePicker: ImageFilePicking, ImagePixelSizeReading {
    private static let allowedContentTypes: [UTType] = [.heic, .jpeg, .png, .tiff]

    @MainActor
    func pickImageFile(title: String, message: String, prompt: String) async throws -> URL {
        try await withCheckedThrowingContinuation { continuation in
            let panel = NSOpenPanel()
            panel.title = title
            panel.message = message
            panel.prompt = prompt
            panel.allowsMultipleSelection = false
            panel.canChooseDirectories = false
            panel.canChooseFiles = true
            panel.allowedContentTypes = Self.allowedContentTypes

            panel.begin { response in
                if response == .OK, let url = panel.url {
                    continuation.resume(returning: url)
                } else {
                    continuation.resume(throwing: ImageFilePickingCancelled())
                }
            }
        }
    }

    // Synchronous, non-isolated: NSImage decoding does not require the main thread,
    // and the protocol requirement itself is nonisolated (Swift 6 mode disallows
    // satisfying a sync requirement with an actor-isolated method).
    func pixelSize(of data: Data) -> (width: Int, height: Int) {
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
