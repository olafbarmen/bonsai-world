//
//  TreeOverviewSpacing.swift
//  Bonsai World
//
//  Tree Overview View Mode rhythm — matches Dashboard so modules share flow and feel.
//

import CoreGraphics

enum TreeOverviewSpacing {
    /// Between Overview modules — same as ``DashboardSpacing/cardGap``.
    static let cardGap: CGFloat = DashboardSpacing.cardGap
    /// Outer page inset — same as ``DashboardSpacing/pageInset``.
    static let pageInset: CGFloat = DashboardSpacing.pageInset
    /// Inside a raised module — same as ``DashboardSpacing/cardPadding``.
    static let cardPadding: CGFloat = DashboardSpacing.cardPadding
    /// Title → body inside a module — same as ``DashboardSpacing/titleToContent``.
    static let titleToContent: CGFloat = DashboardSpacing.titleToContent
}

/// Tree Overview View Mode — 4-column grid matching Dashboard column width.
enum TreeOverviewGridMetrics {
    static let columnCount: Int = 4

    /// Stable reference width for the hero 5:6 photo well.
    /// Sized so Identity (incl. Origin) + notes + chips fit without clipping.
    /// Hero height stays fixed when the window widens; only column widths grow.
    private static let heroPhotoReferenceWidth: CGFloat = 250

    /// Fixed hero column height (5:6 from ``heroPhotoReferenceWidth``).
    /// Shared by photo, summary/identity, Current State, and Species so bottoms align.
    static var heroColumnHeight: CGFloat {
        GalleryLayout.portraitSize(width: heroPhotoReferenceWidth).height
    }

    /// Fixed hero photo well width — pairs with ``heroColumnHeight`` for 5:6.
    static var heroPhotoWidth: CGFloat { heroPhotoReferenceWidth }

    static func columnWidth(in totalWidth: CGFloat) -> CGFloat {
        FaloGridMetrics.columnWidth(
            columns: columnCount,
            in: totalWidth,
            gap: TreeOverviewSpacing.cardGap
        )
    }

    static func spanWidth(_ columnSpan: Int, in totalWidth: CGFloat) -> CGFloat {
        FaloGridMetrics.spanWidth(
            columnSpan: columnSpan,
            columns: columnCount,
            in: totalWidth,
            gap: TreeOverviewSpacing.cardGap
        )
    }
}
