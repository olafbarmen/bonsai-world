//
//  MobileAssetImage.swift
//  Bonsai World
//
//  Presentation for catalog image IDs (Tree or Find). Pixels from DemoLibrary.
//

import SwiftUI
import UIKit

struct MobileAssetImage: View {
    enum Style {
        case thumbnail
        case hero
        /// Square tile that fills the proposed width (Images browse grid).
        case grid
    }

    let imageID: UUID
    var style: Style = .thumbnail

    @Environment(DemoLibrary.self) private var library

    var body: some View {
        let image = resolvedImage
        Group {
            if let image {
                image
                    .resizable()
                    .scaledToFill()
            } else {
                placeholder
            }
        }
        .frame(width: side, height: height)
        .frame(maxWidth: style == .hero || style == .grid ? .infinity : nil)
        .frame(maxHeight: style == .grid ? .infinity : nil)
        .clipped()
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .strokeBorder(BonsaiWorldColors.border, lineWidth: 1)
        }
        .accessibilityLabel(image == nil ? "No photo" : "Photo")
    }

    private var resolvedImage: Image? {
        _ = library.imageRevision
        let maxPixel: CGFloat
        switch style {
        case .hero: maxPixel = 800
        case .grid: maxPixel = 320
        case .thumbnail: maxPixel = 160
        }
        guard let url = library.residentImageURL(for: imageID),
              let uiImage = MobileImageThumbnail.image(at: url, maxPixel: maxPixel)
        else { return nil }
        return Image(uiImage: uiImage)
    }

    private var side: CGFloat? {
        switch style {
        case .thumbnail: 72
        case .hero, .grid: nil
        }
    }

    private var height: CGFloat? {
        switch style {
        case .thumbnail: 72
        case .hero: 220
        case .grid: nil
        }
    }

    private var cornerRadius: CGFloat {
        switch style {
        case .thumbnail: FaloRadius.medium
        case .hero, .grid: FaloRadius.hero
        }
    }

    private var placeholder: some View {
        ZStack {
            BonsaiWorldColors.surface
            Image(systemName: "leaf.fill")
                .font(.system(size: (style == .hero || style == .grid) ? FaloIconSize.emptyState : FaloIconSize.informational))
                .foregroundStyle(BonsaiWorldColors.accent)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
