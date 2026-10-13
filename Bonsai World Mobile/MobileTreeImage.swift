//
//  MobileTreeImage.swift
//  Bonsai World
//
//  Presentation adapter for Tree image IDs. Outside BonsaiCore.
//  Pixels come from DemoLibrary (disk-backed JPEG cache keyed by ImageAsset.id).
//

import SwiftUI
import UIKit

struct MobileTreeImage: View {
    enum Style {
        case list
        case hero
        case thumbnail
    }

    let tree: Tree
    var imageID: UUID?
    var style: Style = .list

    @Environment(DemoLibrary.self) private var library

    init(tree: Tree, imageID: UUID? = nil, style: Style = .list) {
        self.tree = tree
        self.imageID = imageID
        self.style = style
    }

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
        .accessibilityLabel(hasPixels ? "Tree photo" : "No photo")
    }

    private var resolvedID: UUID? { imageID ?? tree.listImageID }

    private var hasPixels: Bool { library.jpegData(for: resolvedID) != nil }

    private var resolvedImage: Image? {
        guard let data = library.jpegData(for: resolvedID),
              let uiImage = UIImage(data: data)
        else { return nil }
        return Image(uiImage: uiImage)
    }

    private var side: CGFloat? {
        switch style {
        case .list: 56
        case .thumbnail: 72
        case .hero: nil
        }
    }

    private var height: CGFloat {
        switch style {
        case .list: 56
        case .thumbnail: 72
        case .hero: 220
        }
    }

    private var cornerRadius: CGFloat {
        switch style {
        case .list, .thumbnail: FaloRadius.medium
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
