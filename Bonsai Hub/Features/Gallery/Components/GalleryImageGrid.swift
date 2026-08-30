//
//  GalleryImageGrid.swift
//  Bonsai World
//
//  Uniform photo grid — fixed card size, generous spacing between cards.
//

import SwiftUI

struct GalleryImageGrid: View {
    let entries: [GalleryEntry]
    let selectedImageID: UUID?
    let showsFeaturedBadge: Bool
    let onSelect: (GalleryEntry) -> Void
    let onOpenWorkspace: (GalleryEntry) -> Void

    private var columns: [GridItem] {
        [
            GridItem(
                .adaptive(
                    minimum: GalleryLayout.cardMinimumWidth,
                    maximum: GalleryLayout.cardWidth
                ),
                spacing: GalleryLayout.gridSpacing,
                alignment: .top
            )
        ]
    }

    var body: some View {
        LazyVGrid(columns: columns, alignment: .leading, spacing: GalleryLayout.gridSpacing) {
            ForEach(entries) { entry in
                GalleryImageTile(
                    entry: entry,
                    isSelected: entry.id == selectedImageID,
                    showsFeaturedBadge: showsFeaturedBadge,
                    onSelect: { onSelect(entry) },
                    onOpenWorkspace: { onOpenWorkspace(entry) }
                )
            }
        }
        .padding(.top, FaloSpacing.xSmall)
        .padding(.bottom, FaloSpacing.xxLarge)
    }
}
