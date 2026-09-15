//
//  ShapingHistoryList.swift
//  Bonsai World
//
//  Chronological history for one Shaping area.
//

import SwiftUI

struct ShapingHistoryList: View {
    let treeID: UUID
    let entries: [ShapingHistoryEntry]
    @Environment(ImageService.self) private var imageService
    @Environment(\.openWindow) private var openWindow

    var body: some View {
        VStack(alignment: .leading, spacing: FaloSpacing.small) {
            Text("History")
                .font(FaloCardTypography.fieldLabel)
                .foregroundStyle(.secondary)

            if entries.isEmpty {
                Text("No history yet.")
                    .font(FaloTypography.caption)
                    .foregroundStyle(.secondary)
            } else {
                VStack(spacing: 0) {
                    ForEach(Array(ShapingHistoryEntry.sortedNewestFirst(entries).enumerated()), id: \.element.id) { index, entry in
                        ShapingHistoryRow(treeID: treeID, entry: entry, openWindow: openWindow)
                        if index < entries.count - 1 {
                            Divider()
                                .padding(.vertical, FaloSpacing.xSmall)
                        }
                    }
                }
            }
        }
    }
}

private struct ShapingHistoryRow: View {
    let treeID: UUID
    let entry: ShapingHistoryEntry
    let openWindow: OpenWindowAction
    @Environment(ImageService.self) private var imageService

    private var trimmedDescription: String {
        entry.description.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var body: some View {
        HStack(alignment: .top, spacing: FaloSpacing.small) {
            Text(entry.date.formatted(date: .abbreviated, time: .omitted))
                .font(FaloTypography.caption)
                .foregroundStyle(.secondary)
                .frame(width: 88, alignment: .leading)

            VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
                if let intent = entry.intent {
                    Text(intent.title)
                        .font(FaloTypography.caption)
                        .foregroundStyle(.tertiary)
                }
                Text(trimmedDescription.isEmpty ? "—" : trimmedDescription)
                    .font(FaloCardTypography.fieldValue)
                    .foregroundStyle(.primary)
                    .frame(maxWidth: .infinity, alignment: .leading)

                if !entry.imageIDs.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: FaloSpacing.xSmall) {
                            ForEach(entry.imageIDs, id: \.self) { imageID in
                                TreeListThumbnail(imageID: imageID, imageService: imageService) {
                                    openHistoryImage(imageID)
                                }
                            }
                        }
                    }
                }
            }
        }
        .padding(.vertical, FaloSpacing.xSmall)
    }

    private func openHistoryImage(_ imageID: UUID) {
        guard !entry.imageIDs.isEmpty else { return }
        let context = TreeImageViewerContext(
            treeID: treeID,
            imageIDs: entry.imageIDs,
            selectedImageID: imageID,
            displayContext: .galleryCard
        )
        openWindow(id: TreeImageViewerContext.windowID, value: context)
    }
}
