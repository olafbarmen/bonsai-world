//
//  CropWorkspaceCanvasView.swift
//  Bonsai World
//
//  Dominant crop surface — Original image with movable, resizable crop frame.
//  Area outside the crop is darkened. Never modifies Original bytes.
//

import AppKit
import SwiftUI

struct CropWorkspaceCanvasView: View {
    let imageID: UUID
    @Binding var cropRect: CGRect
    @Binding var aspectMode: CropAspectRatioMode
    var hidesCropOverlay: Bool = false
    /// When set, resize handles keep this normalized width/height ratio.
    var lockedNormalizedAspect: CGFloat? = nil

    @Environment(ImageService.self) private var imageService

    @State private var displayImage: Image?
    @State private var imagePixelSize: CGSize?
    @State private var isLoading = true
    @State private var didFail = false
    @State private var activeHandle: CropHandle?
    @State private var dragStartRect: CGRect = .zero

    private let handleVisualSize: CGFloat = 12
    private let handleHitSize: CGFloat = 44

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                CropCanvasBackground()

                if let displayImage {
                    let imageFrame = fittedImageFrame(in: geometry.size, imageSize: imagePixelSize)

                    displayImage
                        .resizable()
                        .scaledToFit()
                        .frame(width: imageFrame.width, height: imageFrame.height)
                        .position(x: imageFrame.midX, y: imageFrame.midY)

                    if !hidesCropOverlay {
                        cropOverlay(imageFrame: imageFrame)
                    }
                } else if isLoading {
                    ProgressView()
                        .controlSize(.large)
                } else if didFail {
                    ContentUnavailableView(
                        "Image Unavailable",
                        systemImage: "photo",
                        description: Text("The original file could not be loaded.")
                    )
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .task(id: imageID) {
            await loadImage()
        }
    }

    @ViewBuilder
    private func cropOverlay(imageFrame: CGRect) -> some View {
        let cropViewRect = CropGeometry.viewRect(from: cropRect, in: imageFrame)
        let bodyWidth = max(cropViewRect.width - handleHitSize, 8)
        let bodyHeight = max(cropViewRect.height - handleHitSize, 8)

        ZStack {
            CropDimmingOverlay(container: imageFrame, crop: cropViewRect)

            Color.clear
                .frame(width: bodyWidth, height: bodyHeight)
                .contentShape(Rectangle())
                .position(x: cropViewRect.midX, y: cropViewRect.midY)
                .gesture(bodyDragGesture(imageFrame: imageFrame))
                .help("Drag to move crop")

            Rectangle()
                .strokeBorder(Color.white.opacity(0.95), lineWidth: 1.5)
                .frame(width: cropViewRect.width, height: cropViewRect.height)
                .position(x: cropViewRect.midX, y: cropViewRect.midY)
                .shadow(color: .black.opacity(0.25), radius: 2, y: 1)
                .allowsHitTesting(false)

            ForEach(CropHandle.allCases.filter { $0 != .body }, id: \.self) { handle in
                handleView(for: handle, cropViewRect: cropViewRect, imageFrame: imageFrame)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func handleView(for handle: CropHandle, cropViewRect: CGRect, imageFrame: CGRect) -> some View {
        let point = handlePoint(for: handle, in: cropViewRect)
        let visual = handle.isCorner ? handleVisualSize : handleVisualSize - 2

        return Circle()
            .fill(Color.white)
            .overlay {
                Circle().strokeBorder(Color.black.opacity(0.35), lineWidth: 1)
            }
            .frame(width: visual, height: visual)
            .frame(width: handleHitSize, height: handleHitSize)
            .contentShape(Rectangle())
            .position(x: point.x, y: point.y)
            .help(handleHelp(for: handle))
            .highPriorityGesture(
                DragGesture(minimumDistance: 1)
                    .onChanged { value in
                        if activeHandle == nil {
                            activeHandle = handle
                            dragStartRect = cropRect
                        }
                        guard activeHandle == handle else { return }
                        applyHandleDrag(
                            handle: handle,
                            translation: value.translation,
                            imageFrame: imageFrame,
                            startRect: dragStartRect
                        )
                    }
                    .onEnded { _ in
                        if activeHandle == handle {
                            activeHandle = nil
                            if aspectMode == .original {
                                aspectMode = .custom
                            }
                        }
                    }
            )
    }

    private func bodyDragGesture(imageFrame: CGRect) -> some Gesture {
        DragGesture(minimumDistance: 1)
            .onChanged { value in
                if activeHandle == nil {
                    activeHandle = .body
                    dragStartRect = cropRect
                }
                guard activeHandle == .body else { return }
                let normalizedDelta = CGSize(
                    width: value.translation.width / max(imageFrame.width, 1),
                    height: value.translation.height / max(imageFrame.height, 1)
                )
                cropRect = CropGeometry.move(dragStartRect, by: normalizedDelta)
            }
            .onEnded { _ in
                if activeHandle == .body {
                    activeHandle = nil
                }
            }
    }

    private func handlePoint(for handle: CropHandle, in rect: CGRect) -> CGPoint {
        switch handle {
        case .topLeft: CGPoint(x: rect.minX, y: rect.minY)
        case .top: CGPoint(x: rect.midX, y: rect.minY)
        case .topRight: CGPoint(x: rect.maxX, y: rect.minY)
        case .right: CGPoint(x: rect.maxX, y: rect.midY)
        case .bottomRight: CGPoint(x: rect.maxX, y: rect.maxY)
        case .bottom: CGPoint(x: rect.midX, y: rect.maxY)
        case .bottomLeft: CGPoint(x: rect.minX, y: rect.maxY)
        case .left: CGPoint(x: rect.minX, y: rect.midY)
        case .body: CGPoint(x: rect.midX, y: rect.midY)
        }
    }

    private func handleHelp(for handle: CropHandle) -> String {
        switch handle {
        case .body: "Drag to move crop"
        default: "Drag to resize crop"
        }
    }

    private func applyHandleDrag(
        handle: CropHandle,
        translation: CGSize,
        imageFrame: CGRect,
        startRect: CGRect
    ) {
        let normalizedTranslation = CGSize(
            width: translation.width / max(imageFrame.width, 1),
            height: translation.height / max(imageFrame.height, 1)
        )
        cropRect = CropGeometry.resize(
            rect: startRect,
            handle: handle,
            translation: normalizedTranslation,
            aspectRatio: lockedNormalizedAspect ?? aspectMode.fixedAspectRatio
        )
    }

    private func fittedImageFrame(in containerSize: CGSize, imageSize: CGSize?) -> CGRect {
        let inset = FaloSpacing.large
        let maxWidth = max(containerSize.width - inset * 2, 1)
        let maxHeight = max(containerSize.height - inset * 2, 1)

        guard let imageSize, imageSize.width > 0, imageSize.height > 0 else {
            return CGRect(
                x: (containerSize.width - maxWidth) / 2,
                y: (containerSize.height - maxHeight) / 2,
                width: maxWidth,
                height: maxHeight
            )
        }

        let scale = min(maxWidth / imageSize.width, maxHeight / imageSize.height)
        let width = imageSize.width * scale
        let height = imageSize.height * scale
        return CGRect(
            x: (containerSize.width - width) / 2,
            y: (containerSize.height - height) / 2,
            width: width,
            height: height
        )
    }

    private func loadImage() async {
        isLoading = true
        displayImage = nil
        imagePixelSize = nil
        didFail = false
        defer { isLoading = false }

        do {
            let data = try await imageService.loadOriginalData(for: imageID)
            guard let nsImage = NSImage(data: data) else {
                didFail = true
                return
            }
            imagePixelSize = pixelSize(of: nsImage)
            displayImage = Image(nsImage: nsImage)
        } catch {
            didFail = true
        }
    }

    private func pixelSize(of nsImage: NSImage) -> CGSize {
        if let rep = nsImage.representations.first, rep.pixelsWide > 0, rep.pixelsHigh > 0 {
            return CGSize(width: rep.pixelsWide, height: rep.pixelsHigh)
        }
        return nsImage.size
    }
}

// MARK: - Overlay

private struct CropCanvasBackground: View {
    var body: some View {
        Color(nsColor: .controlBackgroundColor)
            .overlay { Color.primary.opacity(0.02) }
            .ignoresSafeArea()
    }
}

private struct CropDimmingOverlay: View {
    let container: CGRect
    let crop: CGRect

    var body: some View {
        Canvas { context, size in
            var path = Path()
            path.addRect(container)
            path.addRect(crop)
            context.fill(
                path,
                with: .color(.black.opacity(0.52)),
                style: FillStyle(eoFill: true, antialiased: true)
            )
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .allowsHitTesting(false)
    }
}
