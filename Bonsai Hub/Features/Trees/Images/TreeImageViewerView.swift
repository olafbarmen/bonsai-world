//
//  TreeImageViewerView.swift
//  Bonsai World
//
//  Dedicated Tree Image Viewer window — original resolution, fit-to-window.
//  ESC / Close dismisses; selection is owned by the opener (Tree Detail).
//  Ready for future zoom, pan, next/previous, slideshow, compare, history.
//

import AppKit
import SwiftUI

struct TreeImageViewerView: View {
    @Environment(ImageService.self) private var imageService
    @Environment(\.dismiss) private var dismiss

    @State private var context: TreeImageViewerContext
    @State private var displayImage: Image?
    @State private var isLoading = true

    init(context: TreeImageViewerContext) {
        _context = State(initialValue: context)
    }

    var body: some View {
        ZStack {
            Color.black.opacity(0.92)
                .ignoresSafeArea()

            if let displayImage {
                displayImage
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(FaloSpacing.large)
            } else if isLoading {
                ProgressView()
                    .controlSize(.large)
                    .tint(.white)
            } else {
                ContentUnavailableView(
                    "Image Unavailable",
                    systemImage: "photo",
                    description: Text("The original file could not be loaded.")
                )
                .foregroundStyle(.white)
            }
        }
        .frame(minWidth: 640, minHeight: 480)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Close") {
                    dismiss()
                }
                .keyboardShortcut(.cancelAction)
                .help("Close image viewer")
            }
        }
        .navigationTitle(navigationTitle)
        .onExitCommand {
            dismiss()
        }
        .task(id: context.selectedImageID) {
            await loadSelectedImage()
        }
    }

    private var navigationTitle: String {
        if let index = context.selectedIndex {
            return "Image \(index + 1) of \(context.imageIDs.count)"
        }
        return "Image"
    }

    private func loadSelectedImage() async {
        isLoading = true
        displayImage = nil
        defer { isLoading = false }

        do {
            let data = try await imageService.loadOriginalData(for: context.selectedImageID)
            guard let nsImage = NSImage(data: data) else { return }
            displayImage = Image(nsImage: nsImage)
        } catch {
            displayImage = nil
        }
    }
}
