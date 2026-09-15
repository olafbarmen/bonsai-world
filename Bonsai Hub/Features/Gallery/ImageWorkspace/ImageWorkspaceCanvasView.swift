//
//  ImageWorkspaceCanvasView.swift
//  Bonsai World
//
//  Dominant image region — fit-to-window by default, pinch/scroll zoom.
//  Shows the saved display crop. Original pixels are only shown in Crop Workspace.
//

import AppKit
import SwiftUI

struct ImageWorkspaceCanvasView: View {
    let imageID: UUID

    @Environment(ImageService.self) private var imageService

    @State private var displayImage: Image?
    @State private var isLoading = true
    @State private var didFail = false
    @State private var zoomMultiplier: CGFloat = 1.0
    @State private var accumulatedZoom: CGFloat = 1.0
    @State private var zoomResetTrigger = UUID()

    var body: some View {
        ZoomableImageCanvas(
            displayImage: displayImage,
            isLoading: isLoading,
            loadFailed: didFail,
            style: .workspace,
            contentPadding: 0,
            resetTrigger: zoomResetTrigger,
            zoomMultiplier: $zoomMultiplier,
            accumulatedZoom: $accumulatedZoom
        )
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .task(id: "\(imageID.uuidString)-\(imageService.presentationRevision)") {
            await loadImage()
        }
    }

    private func loadImage() async {
        isLoading = true
        displayImage = nil
        didFail = false
        ZoomableImageCanvas.reset(&zoomMultiplier, &accumulatedZoom)
        zoomResetTrigger = UUID()
        defer { isLoading = false }

        do {
            let nsImage = try await imageService.loadDisplayNSImage(for: imageID)
            displayImage = Image(nsImage: nsImage)
        } catch {
            didFail = true
        }
    }
}
