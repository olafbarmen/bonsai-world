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
    }

    let imageID: UUID
    var style: Style = .thumbnail

    @Environment(DemoLibrary.self) private var library

    var body: some View {
        Group {
            if let image = resolvedImage {
                image
                    .resizable()
                    .scaledToFill()
            } else {
                placeholder
            }
        }
        .frame(width: side, height: height)
        .frame(maxWidth: style == .hero ? .infinity : nil)
        .clipped()
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                .strokeBorder(BonsaiWorldColors.border, lineWidth: 1)
        }
        .accessibilityLabel(hasPixels ? "Photo" : "No photo")
    }

    private var hasPixels: Bool { library.jpegData(for: imageID) != nil }

    private var resolvedImage: Image? {
        guard let data = library.jpegData(for: imageID),
              let uiImage = UIImage(data: data)
        else { return nil }
        return Image(uiImage: uiImage)
    }

    private var side: CGFloat? {
        switch style {
        case .thumbnail: 72
        case .hero: nil
        }
    }

    private var height: CGFloat {
        switch style {
        case .thumbnail: 72
        case .hero: 220
        }
    }

    private var cornerRadius: CGFloat {
        switch style {
        case .thumbnail: FaloRadius.medium
        case .hero: FaloRadius.hero
        }
    }

    private var placeholder: some View {
        ZStack {
            BonsaiWorldColors.surface
            Image(systemName: "leaf.fill")
                .font(.system(size: style == .hero ? FaloIconSize.emptyState : FaloIconSize.informational))
                .foregroundStyle(BonsaiWorldColors.accent)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
