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
        let urls = try await presentOpenPanel(
            title: title,
            message: message,
            prompt: prompt,
            allowsMultipleSelection: false
        )
        guard let url = urls.first else { throw ImageFilePickingCancelled() }
        return url
    }

    @MainActor
    func pickImageFiles(title: String, message: String, prompt: String) async throws -> [URL] {
        try await presentOpenPanel(
            title: title,
            message: message,
            prompt: prompt,
            allowsMultipleSelection: true
        )
    }

    @MainActor
    private func presentOpenPanel(
        title: String,
        message: String,
        prompt: String,
        allowsMultipleSelection: Bool
    ) async throws -> [URL] {
        try await withCheckedThrowingContinuation { continuation in
            // Present on the next main-actor turn. Calling begin inside the
            // continuation locks the main thread before the panel can appear.
            Task { @MainActor in
                let panel = NSOpenPanel()
                panel.title = title
                panel.message = message
                panel.prompt = prompt
                panel.allowsMultipleSelection = allowsMultipleSelection
                panel.canChooseDirectories = false
                panel.canChooseFiles = true
                panel.allowedContentTypes = Self.allowedContentTypes

                let finish: (NSApplication.ModalResponse) -> Void = { response in
                    if response == .OK {
                        let urls = panel.urls
                        if urls.isEmpty {
                            continuation.resume(throwing: ImageFilePickingCancelled())
                        } else {
                            continuation.resume(returning: urls)
                        }
                    } else {
                        continuation.resume(throwing: ImageFilePickingCancelled())
                    }
                }

                if let window = NSApp.keyWindow ?? NSApp.mainWindow {
                    panel.beginSheetModal(for: window, completionHandler: finish)
                } else {
                    panel.begin(completionHandler: finish)
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
