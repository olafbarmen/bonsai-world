//
//  HeroImageSection.swift
//  Bonsai World
//
//  Legacy primary-image hero. Tree Detail now uses TreePhotoManagerSection.
//  Kept for compatibility aliases and previews.
//

import SwiftUI

/// Visual model for a primary image.
struct HeroImagePresentation: Equatable {
    var image: Image?
    var assetID: UUID?
}

/// Compatibility shell — prefer ``TreePhotoManagerSection`` for Tree Detail.
struct HeroImageSection: View {
    static let defaultFixedHeight: CGFloat = TreePhotoManagerSection.defaultFixedHeight

    var presentation: HeroImagePresentation = HeroImagePresentation()
    var isEditing: Bool = true
    var fixedHeight: CGFloat = Self.defaultFixedHeight
    var onAddImage: () -> Void = {}

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: FaloRadius.hero, style: .continuous)
                .fill(Color.primary.opacity(0.04))

            RoundedRectangle(cornerRadius: FaloRadius.hero, style: .continuous)
                .strokeBorder(Color.primary.opacity(0.06), lineWidth: 1)

            if let image = presentation.image {
                image
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ContentUnavailableView(
                    "No primary image",
                    systemImage: "tree.fill"
                )
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: fixedHeight)
        .clipShape(RoundedRectangle(cornerRadius: FaloRadius.hero, style: .continuous))
        .clipped()
        .overlay(alignment: .bottomLeading) {
            if isEditing {
                Button(action: onAddImage) {
                    Label("Add Image", systemImage: "plus")
                }
                .buttonStyle(.bordered)
                .controlSize(.small)
                .padding(FaloSpacing.medium)
            }
        }
    }
}

typealias TreePrimaryImagePresentation = HeroImagePresentation
typealias TreeHeroImageSection = HeroImageSection
