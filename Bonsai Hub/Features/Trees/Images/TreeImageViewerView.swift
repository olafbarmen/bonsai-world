//
//  TreeImageViewerView.swift
//  Bonsai World
//
//  Dedicated Tree Image Viewer window — display crop, fit-to-window, zoom and pan.
//  Original file is never shown here; Crop in Media → Images is the original canvas.
//  ESC / Close dismisses; selection is owned by the opener (Tree Detail).
//

import AppKit
import SwiftUI

struct TreeImageViewerView: View {
    @Environment(ImageService.self) private var imageService
    @Environment(\.dismiss) private var dismiss

    @State private var context: TreeImageViewerContext
    @State private var displayImage: Image?
    @State private var isLoading = true
    @State private var zoomMultiplier: CGFloat = 1.0
    @State private var accumulatedZoom: CGFloat = 1.0
    @State private var zoomResetTrigger = UUID()

    init(context: TreeImageViewerContext) {
        _context = State(initialValue: context)
    }

    var body: some View {
        ZStack {
            Color.black.opacity(0.92)
                .ignoresSafeArea()

            ZoomableImageCanvas(
                displayImage: displayImage,
                isLoading: isLoading,
                loadFailed: !isLoading && displayImage == nil,
                style: .viewer,
                contentPadding: FaloSpacing.large,
                resetTrigger: zoomResetTrigger,
                zoomMultiplier: $zoomMultiplier,
                accumulatedZoom: $accumulatedZoom
            )
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

            ToolbarItemGroup(placement: .primaryAction) {
                Button {
                    ZoomableImageCanvas.zoomOut(&zoomMultiplier, &accumulatedZoom)
                } label: {
                    Image(systemName: "minus.magnifyingglass")
                }
                .help("Zoom out")
                .keyboardShortcut("-", modifiers: .command)
                .disabled(displayImage == nil || accumulatedZoom <= 1.0)

                Button {
                    ZoomableImageCanvas.reset(&zoomMultiplier, &accumulatedZoom)
                } label: {
                    Text(zoomPercentageLabel)
                        .monospacedDigit()
                }
                .help("Reset zoom")
                .keyboardShortcut("0", modifiers: .command)
                .disabled(displayImage == nil || accumulatedZoom == 1.0)

                Button {
                    ZoomableImageCanvas.zoomIn(&zoomMultiplier, &accumulatedZoom)
                } label: {
                    Image(systemName: "plus.magnifyingglass")
                }
                .help("Zoom in")
                .keyboardShortcut("=", modifiers: .command)
                .disabled(displayImage == nil || accumulatedZoom >= 8.0)
            }
        }
        .navigationTitle(navigationTitle)
        .onExitCommand {
            dismiss()
        }
        .task(id: "\(context.selectedImageID.uuidString)-\(context.displayContext.rawValue)-\(imageService.presentationRevision)") {
            await loadSelectedImage()
        }
    }

    private var navigationTitle: String {
        if let index = context.selectedIndex {
            return "Image \(index + 1) of \(context.imageIDs.count)"
        }
        return "Image"
    }

    private var zoomPercentageLabel: String {
        "\(Int((accumulatedZoom * 100).rounded()))%"
    }

    private func loadSelectedImage() async {
        isLoading = true
        displayImage = nil
        ZoomableImageCanvas.reset(&zoomMultiplier, &accumulatedZoom)
        zoomResetTrigger = UUID()
        defer { isLoading = false }

        do {
            let nsImage = try await imageService.loadDisplayNSImage(
                for: context.selectedImageID,
                context: context.displayContext
            )
            displayImage = Image(nsImage: nsImage)
        } catch {
            displayImage = nil
        }
    }
}
