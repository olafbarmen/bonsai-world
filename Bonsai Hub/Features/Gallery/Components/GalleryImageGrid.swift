//
//  GalleryImageGrid.swift
//  Bonsai World
//
//  Uniform photo grid — fixed card size, generous spacing between cards.
//

import SwiftUI
#if os(macOS)
import AppKit
#endif

struct GallerySelectionModifiers: OptionSet {
    let rawValue: Int

    static let command = GallerySelectionModifiers(rawValue: 1 << 0)
    static let shift = GallerySelectionModifiers(rawValue: 1 << 1)

    static var current: GallerySelectionModifiers {
        #if os(macOS)
        let flags = NSEvent.modifierFlags
        var mods: GallerySelectionModifiers = []
        if flags.contains(.command) { mods.insert(.command) }
        if flags.contains(.shift) { mods.insert(.shift) }
        return mods
        #else
        return []
        #endif
    }
}

struct GalleryImageGrid: View {
    let entries: [GalleryEntry]
    let selectedImageIDs: Set<UUID>
    let showsFeaturedBadge: Bool
    let onSelect: (GalleryEntry, GallerySelectionModifiers) -> Void
    let onOpenWorkspace: (GalleryEntry) -> Void
    var onCrop: (GalleryEntry) -> Void = { _ in }
    var onDelete: (GalleryEntry) -> Void = { _ in }
    /// Last cell when a tree is selected. Dropped files attach to that tree.
    var onDropImages: (([ImageDropSource]) -> Void)? = nil

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
                    isSelected: selectedImageIDs.contains(entry.id),
                    showsFeaturedBadge: showsFeaturedBadge,
                    onSelect: { onSelect(entry, $0) },
                    onOpenWorkspace: { onOpenWorkspace(entry) },
                    onCrop: { onCrop(entry) },
                    onDelete: { onDelete(entry) }
                )
            }
            if let onDropImages {
                GalleryImageDropTile(onDrop: onDropImages)
            }
        }
        .padding(.top, FaloSpacing.xSmall)
        .padding(.bottom, FaloSpacing.xxLarge)
    }
}
