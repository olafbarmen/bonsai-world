//
//  GalleryLayout.swift
//  Bonsai World
//
//  Image Card metrics — image-dominant, metadata defines minimum card height.
//

import CoreGraphics

enum GalleryLayout {
    /// Standard Falo card corner radius (8–10 pt).
    static let cardCornerRadius: CGFloat = FaloRadius.medium

    /// Preferred outer width for each Image Card in the grid.
    static let cardWidth: CGFloat = 280

    /// Narrowest card width before the grid reflows to fewer columns.
    static let cardMinimumWidth: CGFloat = 220

    /// Image presentation area — typical height at `cardMinimumWidth` (3:4 well).
    static var imageFrameHeight: CGFloat {
        cardMinimumWidth / imageAspectRatio
    }

    /// Margin between photograph area and card border (all sides of the well).
    static let presentationWellInset: CGFloat = FaloSpacing.small

    /// Inner padding around the image inside the well — keeps pixels off rounded corners.
    static let imageWellPadding: CGFloat = FaloSpacing.small

    /// Uniform inset for all caption text from card edges.
    static let metadataPadding: CGFloat = FaloSpacing.small

    /// Extra space above the caption block (below the image well).
    static let metadataTopPadding: CGFloat = FaloSpacing.small

    /// Extra space below the last caption line — prevents bottom clipping.
    static let metadataBottomPadding: CGFloat = FaloSpacing.medium

    /// Vertical space between caption lines.
    static let metadataLineSpacing: CGFloat = 2

    /// Reserved badge corner inset from card top-trailing.
    static let badgeAreaInset: CGFloat = FaloSpacing.small

    /// Space between cards.
    static let gridSpacing: CGFloat = FaloSpacing.xLarge

    /// Minimum caption strip height — three lines plus padding; drives card height.
    static var metadataMinHeight: CGFloat {
        let titleLine: CGFloat = 16
        let attachedLine: CGFloat = 14
        let dateLine: CGFloat = 13
        let lineGaps = metadataLineSpacing * 2
        return metadataTopPadding
            + titleLine + lineGaps + attachedLine + dateLine
            + metadataBottomPadding
    }

    /// Typical total card height when metadata uses its minimum.
    static var cardHeight: CGFloat {
        imageFrameHeight + metadataMinHeight
    }

    /// Width:height for tree photographs — mild portrait (not a tall 9:16).
    static let imageAspectRatio: CGFloat = 3.0 / 4.0

    /// Outer size for a 3:4 well with the given width.
    static func portraitSize(width: CGFloat) -> CGSize {
        CGSize(width: width, height: width / imageAspectRatio)
    }

    // MARK: - Legacy aliases

    static let statusRowHeight: CGFloat = 0
    static let presentationToMetadataSpacing: CGFloat = 0
    static let metadataRegionHeight: CGFloat = metadataMinHeight
    static let metadataBarHeight: CGFloat = metadataMinHeight
    static let cardInnerPadding: CGFloat = imageWellPadding
}
