//
//  MacDirectoryPicker.swift
//  Bonsai World
//
//  macOS conformance for DirectoryPicking. The only file in the module allowed
//  to reference NSOpenPanel for folder selection — everything else (LibraryService,
//  Views) talks to the DirectoryPicking protocol only.
//

import AppKit
import Foundation

/// Stateless — the plain initializer stays usable as a default parameter value
/// from any isolation context; only the panel-touching method is @MainActor.
struct MacDirectoryPicker: DirectoryPicking {
    @MainActor
    func pickDirectory(title: String, message: String, prompt: String) async throws -> URL {
        try await withCheckedThrowingContinuation { continuation in
            let panel = NSOpenPanel()
            panel.title = title
            panel.message = message
            panel.prompt = prompt
            panel.canChooseFiles = false
            panel.canChooseDirectories = true
            panel.allowsMultipleSelection = false
            panel.canCreateDirectories = true

            panel.begin { response in
                if response == .OK, let url = panel.url {
                    continuation.resume(returning: url)
                } else {
                    continuation.resume(throwing: DirectoryPickingCancelled())
                }
            }
        }
    }
}
