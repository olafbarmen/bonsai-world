//
//  GalleryImageTile.swift
//  Bonsai World
//
//  Image Card — compact, image-dominant tile for Media → Images.
//

import SwiftUI

/// Image Card used by the Media → Images grid.
struct GalleryImageTile: View {
    let entry: GalleryEntry
    var isSelected: Bool = false
    let showsFeaturedBadge: Bool
    let onSelect: () -> Void
    let onOpenWorkspace: () -> Void

    private var cardShape: RoundedRectangle {
        RoundedRectangle(cornerRadius: GalleryLayout.cardCornerRadius, style: .continuous)
    }

    var body: some View {
        Button(action: onSelect) {
            ZStack(alignment: .topTrailing) {
                VStack(alignment: .leading, spacing: 0) {
                    presentationWell
                    metadataSection
                }

                badgeArea
                    .padding(GalleryLayout.badgeAreaInset)
            }
            .frame(maxWidth: .infinity, alignment: .top)
            .background(.background, in: cardShape)
            .overlay {
                cardShape
                    .strokeBorder(
                        isSelected ? Color.accentColor : FaloColors.borderSubtle,
                        lineWidth: isSelected ? 2 : 1
                    )
            }
        }
        .buttonStyle(GalleryCardButtonStyle())
        .simultaneousGesture(
            TapGesture(count: 2).onEnded {
                onOpenWorkspace()
            }
        )
        .accessibilityLabel(accessibilityLabel)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
        .accessibilityHint("Single-click to select. Double-click to open Image Workspace.")
    }

    /// Image well — Presentation crop fills the card (Original is never modified).
    private var presentationWell: some View {
        ZStack {
            Color.primary.opacity(0.03)

            GalleryThumbnailImage(imageID: entry.id)
                .padding(GalleryLayout.imageWellPadding)
        }
        .padding(GalleryLayout.presentationWellInset)
        .frame(maxWidth: .infinity)
        .aspectRatio(GalleryLayout.imageAspectRatio, contentMode: .fit)
        .clipped()
    }

    private var metadataSection: some View {
        HStack(alignment: .firstTextBaseline, spacing: FaloSpacing.xSmall) {
            Text(entry.photoName)
                .font(FaloTypography.body.weight(.semibold))
                .foregroundStyle(.primary)
                .lineLimit(1)
                .truncationMode(.tail)
                .frame(maxWidth: .infinity, alignment: .leading)

            Text(ImageAsset.displayCaptureDate(entry.captureDate))
                .font(FaloTypography.caption)
                .foregroundStyle(FaloColors.textSecondary)
                .layoutPriority(1)
                .fixedSize(horizontal: true, vertical: false)
        }
        .padding(.horizontal, GalleryLayout.metadataPadding)
        .padding(.top, GalleryLayout.metadataTopPadding)
        .padding(.bottom, GalleryLayout.metadataTopPadding)
        .frame(maxWidth: .infinity, minHeight: metadataRowHeight, alignment: .center)
    }

    /// Single-line caption strip — title truncates; date always visible.
    private var metadataRowHeight: CGFloat {
        GalleryLayout.metadataTopPadding + 20 + GalleryLayout.metadataTopPadding
    }

    private var badgeArea: some View {
        VStack(alignment: .trailing, spacing: 3) {
            if entry.isPrimary {
                ImageCardBadge(title: GalleryImageStatusLabel.primary, systemImage: "star.fill")
            }
            if showsFeaturedBadge, entry.isFeatured {
                ImageCardBadge(title: GalleryImageStatusLabel.featured, systemImage: "sparkles")
            }
            if entry.hasTreeContext {
                ImageCardBadge(title: GalleryImageStatusLabel.attached, systemImage: "link")
            }
        }
        .frame(minWidth: 24, minHeight: 24, alignment: .topTrailing)
        .accessibilityHidden(true)
    }

    private var attachedTreeLabel: String {
        if let treeName = entry.treeDisplayName, entry.hasTreeContext {
            return treeName
        }
        return "Unattached"
    }

    private var accessibilityLabel: String {
        var parts: [String] = [entry.photoName, attachedTreeLabel]
        parts.append(ImageAsset.displayCaptureDate(entry.captureDate))
        if entry.hasTreeContext { parts.append(GalleryImageStatusLabel.attached) }
        if entry.isPrimary { parts.append(GalleryImageStatusLabel.primary) }
        if entry.isFeatured { parts.append(GalleryImageStatusLabel.featured) }
        return parts.joined(separator: ", ")
    }
}

// MARK: - Badge

private struct ImageCardBadge: View {
    let title: String
    let systemImage: String

    var body: some View {
        Image(systemName: systemImage)
            .font(.system(size: 10, weight: .semibold))
            .foregroundStyle(.secondary)
            .padding(5)
            .background(.ultraThinMaterial, in: Circle())
            .help(title)
    }
}

// MARK: - Chrome

private struct GalleryCardButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .opacity(configuration.isPressed ? 0.92 : 1)
            .scaleEffect(configuration.isPressed ? 0.99 : 1)
            .animation(.easeOut(duration: 0.14), value: configuration.isPressed)
    }
}
