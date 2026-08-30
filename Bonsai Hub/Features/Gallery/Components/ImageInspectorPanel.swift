//
//  ImageInspectorPanel.swift
//  Bonsai World
//
//  Horizontal image summary card for Media → Images browse.
//  Falo workspace layout — one card above the Gallery toolbar.
//

import SwiftUI

enum ImageInspectorLayout {
    static let cardHeight: CGFloat = 210
    static let thumbnailWidth: CGFloat = 105
    static let thumbnailHeight: CGFloat = 140
    static let thumbnailToColumnSpacing: CGFloat = FaloSpacing.xxLarge
    static let columnSpacing: CGFloat = FaloSpacing.xxLarge + FaloSpacing.small
}

struct ImageInspectorPanel: View {
    let entry: GalleryEntry?
    let collections: [Collection]
    var onCrop: (() -> Void)? = nil

    private var cardShape: RoundedRectangle {
        RoundedRectangle(cornerRadius: GalleryLayout.cardCornerRadius, style: .continuous)
    }

    var body: some View {
        Group {
            if let entry {
                summaryContent(for: entry)
            } else {
                emptyState
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: ImageInspectorLayout.cardHeight)
        .padding(GalleryLayout.metadataPadding)
        .background(.background, in: cardShape)
        .overlay {
            cardShape
                .strokeBorder(FaloColors.borderSubtle, lineWidth: 1)
        }
        .clipped()
        .accessibilityElement(children: .contain)
    }

    // MARK: - Summary

    private func summaryContent(for entry: GalleryEntry) -> some View {
        VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
            HStack(alignment: .center, spacing: FaloSpacing.small) {
                DetailSectionHeader(title: "Image Details")
                Spacer(minLength: 0)
                if let onCrop {
                    Button("Crop", systemImage: "crop", action: onCrop)
                        .buttonStyle(.bordered)
                        .controlSize(.small)
                        .help("Crop the display of this photo. The original file is not changed.")
                }
            }

            HStack(alignment: .center, spacing: 0) {
                thumbnailWell(for: entry)

                Spacer().frame(width: ImageInspectorLayout.thumbnailToColumnSpacing)

                metadataColumn {
                    metadataField(label: "Name", value: entry.photoName)
                    metadataField(
                        label: "Capture Date",
                        value: ImageAsset.displayCaptureDate(entry.captureDate)
                    )
                    metadataField(
                        label: "Camera",
                        value: cameraValue(for: entry),
                        isEmpty: cameraValue(for: entry) == FaloDisplayValue.empty
                    )
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                Spacer().frame(width: ImageInspectorLayout.columnSpacing)

                metadataColumn {
                    metadataField(label: "Attached Tree", value: attachedTreeValue(for: entry))
                    metadataField(
                        label: "Collection",
                        value: collectionValue(for: entry),
                        isEmpty: collections.isEmpty
                    )
                    metadataField(
                        label: "Object Type",
                        value: objectTypeValue(for: entry),
                        isEmpty: !entry.hasObjectAttachment
                    )
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                Spacer().frame(width: ImageInspectorLayout.columnSpacing)

                metadataColumn {
                    metadataField(label: "Primary", value: primaryValue(for: entry))
                    metadataField(label: "Featured", value: featuredValue(for: entry))
                    metadataField(
                        label: "Status",
                        value: statusValue(for: entry),
                        isEmpty: statusValue(for: entry) == FaloDisplayValue.empty
                    )
                    metadataField(
                        label: "AI Review",
                        value: FaloDisplayValue.empty,
                        isEmpty: true
                    )
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
        .accessibilityLabel("Image Details for \(entry.photoName)")
    }

    // MARK: - Thumbnail (GalleryImageTile presentationWell rules)

    private func thumbnailWell(for entry: GalleryEntry) -> some View {
        ZStack {
            Color.primary.opacity(0.03)

            GalleryThumbnailImage(imageID: entry.id)
                .padding(GalleryLayout.imageWellPadding)
        }
        .padding(GalleryLayout.presentationWellInset)
        .frame(width: ImageInspectorLayout.thumbnailWidth, height: ImageInspectorLayout.thumbnailHeight)
        .clipped()
        .accessibilityLabel("Thumbnail of \(entry.photoName)")
    }

    // MARK: - Metadata

    private func metadataColumn(@ViewBuilder content: () -> some View) -> some View {
        VStack(alignment: .leading, spacing: GalleryLayout.metadataLineSpacing) {
            content()
        }
    }

    private func metadataField(label: String, value: String, isEmpty: Bool = false) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(label)
                .font(FaloTypography.caption)
                .foregroundStyle(.secondary)
                .lineLimit(1)
                .truncationMode(.tail)

            Text(value)
                .font(FaloTypography.body)
                .foregroundStyle(isEmpty ? FaloColors.textSecondary : .primary)
                .lineLimit(1)
                .truncationMode(.tail)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    // MARK: - Empty State

    private var emptyState: some View {
        VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
            DetailSectionHeader(title: "Image Details")

            HStack(alignment: .center, spacing: 0) {
                ZStack {
                    Color.primary.opacity(0.03)
                    Image(systemName: "photo.on.rectangle.angled")
                        .font(FaloTypography.body)
                        .foregroundStyle(FaloColors.textSecondary.opacity(0.55))
                }
                .padding(GalleryLayout.presentationWellInset)
                .frame(width: ImageInspectorLayout.thumbnailWidth, height: ImageInspectorLayout.thumbnailHeight)
                .accessibilityHidden(true)

                Spacer().frame(width: ImageInspectorLayout.thumbnailToColumnSpacing)

                VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
                    Text("Select an Image")
                        .font(FaloTypography.body)
                        .foregroundStyle(.primary)
                        .lineLimit(1)
                        .truncationMode(.tail)

                    Text("Choose a photograph from the grid to see its summary here.")
                        .font(FaloTypography.caption)
                        .foregroundStyle(FaloColors.textSecondary)
                        .lineLimit(2)
                        .truncationMode(.tail)
                }

                Spacer(minLength: 0)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
    }

    // MARK: - Values

    private func cameraValue(for entry: GalleryEntry) -> String {
        FaloDisplayValue.text(entry.asset.camera)
    }

    private func attachedTreeValue(for entry: GalleryEntry) -> String {
        if entry.hasTreeContext, let name = entry.treeDisplayName {
            return name
        }
        return "Unattached"
    }

    private func collectionValue(for entry: GalleryEntry) -> String {
        guard !collections.isEmpty else {
            return entry.hasTreeContext
                ? "Not in any Collection"
                : "Attach to a Tree to see Collections"
        }
        return collections.map(\.name).joined(separator: ", ")
    }

    private func objectTypeValue(for entry: GalleryEntry) -> String {
        entry.objectAttachment?.kind.displayName ?? FaloDisplayValue.empty
    }

    private func primaryValue(for entry: GalleryEntry) -> String {
        entry.isPrimary ? GalleryImageStatusLabel.primary : "Not primary"
    }

    private func featuredValue(for entry: GalleryEntry) -> String {
        entry.isFeatured ? GalleryImageStatusLabel.featured : "Not featured"
    }

    private func statusValue(for entry: GalleryEntry) -> String {
        if entry.hasTreeContext {
            return GalleryImageStatusLabel.attached
        }
        if entry.isPrimary || entry.isFeatured {
            return "Unattached"
        }
        return FaloDisplayValue.empty
    }
}
