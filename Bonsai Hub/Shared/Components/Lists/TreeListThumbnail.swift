//
//  TreeListThumbnail.swift
//  Bonsai World
//
//  Leading photo on every tree list — same size everywhere.
//  Leaf icon only when the tree has no image.
//

import AppKit
import SwiftUI

struct TreeListThumbnail: View {
    var imageID: UUID?

    @Environment(ImageService.self) private var imageService
    @State private var thumbnail: NSImage?

    static let width: CGFloat = 36
    static let height: CGFloat = 48

    var body: some View {
        let _ = imageService.presentationRevision
        let shape = RoundedRectangle(cornerRadius: FaloRadius.small, style: .continuous)
        Color.clear
            .frame(width: Self.width, height: Self.height)
            .overlay {
                if let thumbnail {
                    Image(nsImage: thumbnail)
                        .resizable()
                        .scaledToFill()
                } else {
                    ThumbnailPlaceholder(
                        systemImage: "leaf.fill",
                        width: Self.width,
                        height: Self.height
                    )
                }
            }
            .clipped()
            .clipShape(shape)
            .overlay {
                shape.strokeBorder(Color.primary.opacity(0.08), lineWidth: 1)
            }
            .accessibilityHidden(true)
            .task(id: "\(imageID?.uuidString ?? "")-\(imageService.presentationRevision)") {
                await loadThumbnail()
            }
    }

    private func loadThumbnail() async {
        guard let imageID else {
            thumbnail = nil
            return
        }
        do {
            thumbnail = try await imageService.loadDisplayNSImage(
                for: imageID,
                context: .treeThumbnail,
                maxPixelSize: 96
            )
        } catch {
            thumbnail = nil
        }
    }
}
