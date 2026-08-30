//
//  ImageWorkspaceSummaryView.swift
//  Bonsai World
//
//  Compact Image Summary — thumbnail identifies the image; metadata explains the object.
//  Detailed viewing belongs in dedicated image tools (Crop, Compare, AI, …).
//

import SwiftUI

struct ImageWorkspaceSummaryView: View {
    let entry: GalleryEntry
    let collections: [Collection]
    let experienceLevel: ImageWorkspaceExperienceLevel

    var body: some View {
        HStack(alignment: .top, spacing: FaloSpacing.large) {
            thumbnail

            HStack(alignment: .top, spacing: FaloSpacing.xxLarge) {
                metadataColumn {
                    summaryField(label: "Name", value: entry.photoName, emphasizesValue: true)
                    summaryField(
                        label: "Capture Date",
                        value: ImageAsset.displayCaptureDate(entry.captureDate)
                    )
                    summaryField(
                        label: "Camera",
                        value: cameraValue,
                        isMuted: cameraValue == FaloDisplayValue.empty
                    )
                }

                metadataColumn {
                    summaryField(label: "Attached Object", value: attachedObjectValue)
                    summaryField(label: "Collection", value: collectionValue, isMuted: collections.isEmpty)
                    summaryField(label: "Object Type", value: objectTypeValue, isMuted: !entry.hasObjectAttachment)
                }

                metadataColumn {
                    summaryField(label: "Primary", value: primaryValue)
                    summaryField(label: "Featured", value: featuredValue)
                    summaryField(
                        label: "Status",
                        value: statusValue,
                        isMuted: !entry.hasTreeContext && !entry.isPrimary && !entry.isFeatured
                    )
                    summaryField(label: "AI Review", value: aiReviewValue, isMuted: true)
                }

                Spacer(minLength: 0)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, FaloSpacing.large)
        .padding(.vertical, FaloSpacing.medium)
        .background(.bar)
        .overlay(alignment: .bottom) {
            Rectangle()
                .fill(FaloColors.borderSubtle)
                .frame(height: 1)
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Image summary for \(entry.photoName)")
    }

    // MARK: - Thumbnail

    private var thumbnail: some View {
        ZStack {
            RoundedRectangle(cornerRadius: FaloRadius.small, style: .continuous)
                .fill(Color.primary.opacity(0.03))

            GalleryThumbnailImage(imageID: entry.id)
                .padding(FaloSpacing.xSmall)
        }
        .frame(
            width: ImageWorkspaceLayout.summaryThumbnailWidth,
            height: ImageWorkspaceLayout.summaryThumbnailHeight
        )
        .clipShape(RoundedRectangle(cornerRadius: FaloRadius.small, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: FaloRadius.small, style: .continuous)
                .strokeBorder(FaloColors.borderSubtle, lineWidth: 1)
        }
        .accessibilityLabel("Identification thumbnail for \(entry.photoName)")
    }

    // MARK: - Values

    private var cameraValue: String {
        FaloDisplayValue.text(entry.asset.camera)
    }

    private var attachedObjectValue: String {
        if entry.hasTreeContext, let name = entry.treeDisplayName {
            return name
        }
        return "Unattached"
    }

    private var collectionValue: String {
        guard !collections.isEmpty else {
            return entry.hasTreeContext
                ? "Not in any Collection"
                : "Attach to a Tree to see Collections"
        }
        return collections.map(\.name).joined(separator: ", ")
    }

    private var objectTypeValue: String {
        entry.objectAttachment?.kind.displayName ?? FaloDisplayValue.empty
    }

    private var primaryValue: String {
        entry.isPrimary ? GalleryImageStatusLabel.primary : "Not primary"
    }

    private var featuredValue: String {
        if experienceLevel.showsFeaturedStatus {
            return entry.isFeatured ? GalleryImageStatusLabel.featured : "Not featured"
        }
        return entry.isFeatured ? GalleryImageStatusLabel.featured : FaloDisplayValue.empty
    }

    private var statusValue: String {
        if entry.hasTreeContext {
            return GalleryImageStatusLabel.attached
        }
        if entry.isPrimary || entry.isFeatured {
            return "Unattached"
        }
        return FaloDisplayValue.empty
    }

    private var aiReviewValue: String {
        FaloDisplayValue.empty
    }

    // MARK: - Primitives

    private func metadataColumn(@ViewBuilder content: () -> some View) -> some View {
        VStack(alignment: .leading, spacing: FaloSpacing.small) {
            content()
        }
        .frame(minWidth: ImageWorkspaceLayout.summaryColumnMinWidth, alignment: .leading)
    }

    private func summaryField(
        label: String,
        value: String,
        emphasizesValue: Bool = false,
        isMuted: Bool = false
    ) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(label)
                .font(FaloCardTypography.fieldLabel)
                .foregroundStyle(.secondary)

            Text(value)
                .font(emphasizesValue ? FaloCardTypography.fieldValue : FaloCardTypography.fieldLabel)
                .foregroundStyle(isMuted ? FaloColors.textSecondary : .primary)
                .lineLimit(2)
        }
    }
}

enum ImageWorkspaceLayout {
    static let summaryThumbnailWidth: CGFloat = 90
    static let summaryThumbnailHeight: CGFloat = 120
    static let summaryColumnMinWidth: CGFloat = 140
    static let filmstripHeight: CGFloat = 118
}
