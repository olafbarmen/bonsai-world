//
//  PotImageStrip.swift
//  Bonsai World
//
//  Small titled thumbnail row shared by Pot Media (Photos / Actual Stamp Photos)
//  and by Brand/Maker Stamp Reference display. Read-only when `onAdd` is nil.
//

import SwiftUI

struct PotImageStrip: View {
    let title: String
    let imageIDs: [UUID]
    var primaryImageID: UUID?
    var onAdd: (() -> Void)?
    var onSetPrimary: ((UUID) -> Void)?
    var onRemove: ((UUID) -> Void)?

    private static let thumbnailSize: CGFloat = 72

    var body: some View {
        VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
            HStack {
                Text(title)
                    .font(FaloCardTypography.fieldLabel)
                    .foregroundStyle(.secondary)
                Spacer()
                if let onAdd {
                    Button("Add", action: onAdd)
                        .buttonStyle(.borderless)
                }
            }

            if imageIDs.isEmpty {
                Text(FaloDisplayValue.empty)
                    .font(FaloCardTypography.fieldValue)
                    .foregroundStyle(.secondary)
            } else {
                ScrollView(.horizontal) {
                    HStack(spacing: FaloSpacing.small) {
                        ForEach(imageIDs, id: \.self) { imageID in
                            thumbnail(for: imageID)
                        }
                    }
                }
            }
        }
    }

    private func thumbnail(for imageID: UUID) -> some View {
        GalleryThumbnailImage(imageID: imageID, context: .galleryCard)
            .frame(width: Self.thumbnailSize, height: Self.thumbnailSize)
            .clipShape(RoundedRectangle(cornerRadius: FaloRadius.small, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: FaloRadius.small, style: .continuous)
                    .strokeBorder(imageID == primaryImageID ? BonsaiWorldColors.accent : BonsaiWorldColors.border, lineWidth: imageID == primaryImageID ? 2 : 1)
            }
            .contextMenu {
                if let onSetPrimary {
                    Button("Set as Primary") { onSetPrimary(imageID) }
                }
                if let onRemove {
                    Button("Remove", role: .destructive) { onRemove(imageID) }
                }
            }
    }
}
