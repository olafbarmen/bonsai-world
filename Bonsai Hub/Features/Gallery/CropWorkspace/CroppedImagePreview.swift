//
//  CroppedImagePreview.swift
//  Bonsai World
//
//  Live preview of a normalized crop inside a target frame.
//  Crops pixels first (same recipe as Tree / Gallery), then fills the frame.
//  Drag pans this frame's crop. Other Live Preview frames stay unchanged.
//

import AppKit
import SwiftUI

struct CroppedImagePreview: View {
    let croppedImage: Image
    let frameSize: CGSize
    var cornerRadius: CGFloat = FaloRadius.small
    var isActive: Bool = false

    var body: some View {
        let shape = RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)

        Color.clear
            .frame(width: frameSize.width, height: frameSize.height)
            .overlay {
                croppedImage
                    .resizable()
                    .scaledToFill()
            }
            .clipped()
            .clipShape(shape)
            .overlay {
                shape.strokeBorder(
                    isActive ? Color.accentColor : FaloColors.borderSubtle,
                    lineWidth: isActive ? 2 : 1
                )
            }
            .background {
                shape.fill(Color.primary.opacity(0.04))
            }
    }
}

/// Loads an Original, applies the live crop, and fills the preview tile.
struct CroppedImagePreviewLoader: View {
    let imageID: UUID
    @Binding var cropRect: CGRect
    let frameSize: CGSize
    var cornerRadius: CGFloat = FaloRadius.small
    var isActive: Bool = false
    var onActivate: () -> CGRect

    @Environment(ImageService.self) private var imageService

    @State private var sourceImage: NSImage?
    @State private var croppedDisplay: Image?
    @State private var panStartRect: CGRect?

    var body: some View {
        Group {
            if let croppedDisplay {
                CroppedImagePreview(
                    croppedImage: croppedDisplay,
                    frameSize: frameSize,
                    cornerRadius: cornerRadius,
                    isActive: isActive
                )
            } else {
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .fill(Color.primary.opacity(0.04))
                    .frame(width: frameSize.width, height: frameSize.height)
                    .overlay { ProgressView().controlSize(.small) }
            }
        }
        .contentShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
        .onTapGesture {
            _ = onActivate()
        }
        .highPriorityGesture(panGesture)
        .onHover { hovering in
            if hovering {
                NSCursor.openHand.set()
            } else {
                NSCursor.arrow.set()
            }
        }
        .help("Drag to pan this frame. Other frames keep their own crop.")
        .task(id: imageID) {
            await loadSource()
            applyCrop()
        }
        .onChange(of: cropRect) { _, _ in
            applyCrop()
        }
    }

    private var panGesture: some Gesture {
        DragGesture(minimumDistance: 2)
            .onChanged { value in
                if panStartRect == nil {
                    panStartRect = onActivate()
                    NSCursor.closedHand.set()
                }
                guard let panStartRect else { return }
                let delta = CGSize(
                    width: -value.translation.width / max(frameSize.width, 1) * panStartRect.width,
                    height: -value.translation.height / max(frameSize.height, 1) * panStartRect.height
                )
                cropRect = CropGeometry.move(panStartRect, by: delta)
            }
            .onEnded { _ in
                panStartRect = nil
                NSCursor.openHand.set()
            }
    }

    private func loadSource() async {
        sourceImage = nil
        croppedDisplay = nil
        do {
            let data = try await imageService.loadOriginalData(for: imageID)
            let nsImage = await Task.detached(priority: .userInitiated) {
                NSImage(data: data)
            }.value
            guard let nsImage else { return }
            sourceImage = downscaled(nsImage, maxDimension: 720)
            applyCrop()
        } catch {
            sourceImage = nil
        }
    }

    private func applyCrop() {
        guard let sourceImage else { return }
        let cropped = ImagePresentationCropping.croppedImage(
            from: sourceImage,
            normalizedCrop: cropRect
        )
        croppedDisplay = Image(nsImage: cropped)
    }

    private func downscaled(_ image: NSImage, maxDimension: CGFloat) -> NSImage {
        let size = image.size
        let longest = max(size.width, size.height)
        guard longest > maxDimension, longest > 0 else { return image }
        let scale = maxDimension / longest
        let target = NSSize(width: size.width * scale, height: size.height * scale)
        let copy = NSImage(size: target)
        copy.lockFocus()
        image.draw(
            in: NSRect(origin: .zero, size: target),
            from: NSRect(origin: .zero, size: size),
            operation: .copy,
            fraction: 1
        )
        copy.unlockFocus()
        return copy
    }
}
