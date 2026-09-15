//
//  ImportFilePanel.swift
//  Bonsai World
//
//  macOS open panel for library import sources.
//

import AppKit
import UniformTypeIdentifiers

enum ImportFilePanel {
    @MainActor
    static func chooseFile(contentTypes: [UTType], prompt: String = "Choose") async -> URL? {
        await withCheckedContinuation { continuation in
            Task { @MainActor in
                let panel = NSOpenPanel()
                panel.canChooseFiles = true
                panel.canChooseDirectories = false
                panel.allowsMultipleSelection = false
                panel.allowedContentTypes = contentTypes
                panel.prompt = prompt

                if let window = NSApp.keyWindow ?? NSApp.mainWindow {
                    panel.beginSheetModal(for: window) { response in
                        continuation.resume(returning: response == .OK ? panel.url : nil)
                    }
                } else {
                    panel.begin { response in
                        continuation.resume(returning: response == .OK ? panel.url : nil)
                    }
                }
            }
        }
    }
}
