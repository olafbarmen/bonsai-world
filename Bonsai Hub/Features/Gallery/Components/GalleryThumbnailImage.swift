//
//  GalleryThumbnailImage.swift
//  Bonsai World
//
//  Async thumbnail for Gallery tiles. Shows Presentation crop when one is saved;
//  otherwise the full Original. Original bytes are never modified.
//

import AppKit
import SwiftUI

struct GalleryThumbnailImage: View {
    let imageID: UUID
    var context: ImagePresentationContext = .galleryCard

    @Environment(ImageService.self) private var imageService

    @State private var image: Image?
    @State private var didFail = false

    var body: some View {
        let _ = imageService.presentationRevision
        Color.clear
            .overlay {
                if let image {
                    image
                        .resizable()
                        .scaledToFill()
                } else if didFail {
                    placeholder(systemImage: "photo")
                } else {
                    placeholder(systemImage: "photo")
                        .overlay {
                            ProgressView()
                                .controlSize(.small)
                        }
                }
            }
            .clipped()
            .task(id: "\(imageID.uuidString)-\(context.rawValue)-\(imageService.presentationRevision)") {
                await load()
            }
    }

    private func placeholder(systemImage: String) -> some View {
        Image(systemName: systemImage)
            .font(.system(size: 26, weight: .light))
            .foregroundStyle(FaloColors.textSecondary.opacity(0.45))
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
    }

    private func load() async {
        image = nil
        didFail = false
        do {
            let nsImage = try await imageService.loadDisplayNSImage(for: imageID, context: context, maxPixelSize: 512)
            image = Image(nsImage: nsImage)
        } catch {
            didFail = true
        }
    }
}
