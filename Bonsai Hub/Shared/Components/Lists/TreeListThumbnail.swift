//
//  TreeListThumbnail.swift
//  Bonsai World
//
//  Leading photo on every tree list — same size everywhere.
//  Leaf icon only when the tree has no image.
//
//  ImageService is passed in explicitly — macOS Table cells do not reliably
//  inherit @Environment when rows recycle during fast scrolling.
//

import AppKit
import SwiftUI

struct TreeListThumbnail: View {
    var imageID: UUID?
    let imageService: ImageService
    var onDoubleClick: (() -> Void)?
    /// Defaults match list rows; Dashboard Attention may pass a larger size.
    var width: CGFloat = Self.defaultWidth
    var height: CGFloat = Self.defaultHeight
    /// SF Symbol when `imageID` is nil or fails to load. Trees use leaf; Pots use shippingbox.
    var placeholderSystemImage: String = "leaf.fill"

    @State private var thumbnail: NSImage?

    static let defaultWidth: CGFloat = 36
    static let defaultHeight: CGFloat = 48
    /// Alias for existing call sites.
    static var width: CGFloat { defaultWidth }
    static var height: CGFloat { defaultHeight }

    var body: some View {
        let _ = imageService.presentationRevision
        let shape = RoundedRectangle(cornerRadius: FaloRadius.small, style: .continuous)
        Color.clear
            .frame(width: width, height: height)
            .overlay {
                if let thumbnail {
                    Image(nsImage: thumbnail)
                        .resizable()
                        .scaledToFill()
                } else {
                    ThumbnailPlaceholder(
                        systemImage: placeholderSystemImage,
                        width: width,
                        height: height
                    )
                }
            }
            .clipped()
            .clipShape(shape)
            .overlay {
                shape.strokeBorder(BonsaiWorldColors.border, lineWidth: 1)
            }
            .contentShape(shape)
            .onTapGesture(count: 2) {
                onDoubleClick?()
            }
            .accessibilityHidden(onDoubleClick == nil)
            .accessibilityLabel(onDoubleClick == nil ? "" : "Open image")
            .accessibilityAddTraits(onDoubleClick == nil ? [] : .isButton)
            .help(onDoubleClick == nil ? "" : "Double-click to open")
            .task(id: "\(imageID?.uuidString ?? "")-\(width)-\(height)-\(placeholderSystemImage)-\(imageService.presentationRevision)") {
                await loadThumbnail()
            }
    }

    private func loadThumbnail() async {
        guard let imageID else {
            thumbnail = nil
            return
        }
        let maxPixel = Int(max(width, height) * 2.5)
        do {
            thumbnail = try await imageService.loadDisplayNSImage(
                for: imageID,
                context: .treeThumbnail,
                maxPixelSize: max(96, maxPixel)
            )
        } catch {
            thumbnail = nil
        }
    }
}
