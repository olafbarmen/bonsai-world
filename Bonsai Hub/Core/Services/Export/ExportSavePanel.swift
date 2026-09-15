//
//  ExportSavePanel.swift
//  Bonsai World
//
//  macOS save panel for library export destinations.
//  Panel creation must run on @MainActor — the withCheckedContinuation closure is not.
//

import AppKit
import UniformTypeIdentifiers

enum ExportSavePanel {
    @MainActor
    static func chooseURL(suggestedName: String, contentType: UTType) async -> URL? {
        await withCheckedContinuation { continuation in
            Task { @MainActor in
                let panel = NSSavePanel()
                panel.canCreateDirectories = true
                panel.allowedContentTypes = [contentType]
                panel.isExtensionHidden = false
                // Set after content types so macOS does not restore yesterday’s filename.
                panel.nameFieldStringValue = suggestedName

                if let window = NSApp.keyWindow ?? NSApp.mainWindow {
                    panel.beginSheetModal(for: window) { response in
                        continuation.resume(returning: response == .OK ? panel.url : nil)
                    }
                } else {
                    panel.begin { response in
                        continuation.resume(returning: response == .OK ? panel.url : nil)
                    }
                }

                // Re-assert after the panel is on screen — NSSavePanel sometimes
                // replaces the field with the last-used name from the same folder.
                panel.nameFieldStringValue = suggestedName
            }
        }
    }
}
