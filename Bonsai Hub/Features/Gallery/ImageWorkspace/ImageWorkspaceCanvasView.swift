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

    private let minZoom: CGFloat = 0.5
    private let maxZoom: CGFloat = 4.0

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ImageWorkspaceCanvasBackground()

                if let displayImage {
                    ScrollView([.horizontal, .vertical], showsIndicators: true) {
                        displayImage
                            .resizable()
                            .scaledToFit()
                            .frame(
                                width: geometry.size.width * zoomMultiplier,
                                height: geometry.size.height * zoomMultiplier
                            )
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if isLoading {
                    ProgressView()
                        .controlSize(.large)
                } else if didFail {
                    ContentUnavailableView(
                        "Image Unavailable",
                        systemImage: "photo",
                        description: Text("The image could not be loaded.")
                    )
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .gesture(magnificationGesture)
        .onTapGesture(count: 2) {
            resetZoom()
        }
        .help("Scroll or pinch to zoom. Double-click to reset.")
        .task(id: "\(imageID.uuidString)-\(imageService.presentationRevision)") {
            await loadImage()
        }
    }

    private var magnificationGesture: some Gesture {
        MagnificationGesture()
            .onChanged { value in
                let proposed = accumulatedZoom * value
                zoomMultiplier = min(max(proposed, minZoom), maxZoom)
            }
            .onEnded { value in
                accumulatedZoom = min(max(accumulatedZoom * value, minZoom), maxZoom)
                zoomMultiplier = accumulatedZoom
            }
    }

    private func resetZoom() {
        zoomMultiplier = 1.0
        accumulatedZoom = 1.0
    }

    private func loadImage() async {
        isLoading = true
        displayImage = nil
        didFail = false
        resetZoom()
        defer { isLoading = false }

        do {
            let nsImage = try await imageService.loadDisplayNSImage(for: imageID)
            displayImage = Image(nsImage: nsImage)
        } catch {
            didFail = true
        }
    }
}

/// Calm neutral backdrop behind the photograph.
private struct ImageWorkspaceCanvasBackground: View {
    var body: some View {
        Color(nsColor: .controlBackgroundColor)
            .overlay {
                Color.primary.opacity(0.02)
            }
            .ignoresSafeArea()
    }
}
