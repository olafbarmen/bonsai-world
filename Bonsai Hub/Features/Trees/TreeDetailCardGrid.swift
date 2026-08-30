//
//  TreeDetailCardGrid.swift
//  Bonsai World
//
//  Tree Detail cards — three independent vertical columns (Dashboard principle).
//  Each card keeps natural height; exactly ``TreeDetailSpacing/cardGap`` between
//  cards in the same column. Columns never affect each other’s Y positions.
//  Photo band uses the same column widths (1 + 2 span).
//
//  Desktop-first layout: expands proportionally via ``FaloAdaptiveDesktopWorkspace``;
//  scrolls horizontally only below ``TreeDetailLayout/minimumContentWidth``.
//

import SwiftUI

/// Shared Tree Detail card rhythm — same gap value as Dashboard.
enum TreeDetailSpacing {
    /// Exact gap between cards in a column (and between the three columns).
    static let cardGap: CGFloat = 24
}

enum TreeDetailCardGridMetrics {
    static let columnCount: Int = 3

    /// Width of one equal column for a given content width (excluding outer margins).
    static func columnWidth(in totalWidth: CGFloat) -> CGFloat {
        FaloGridMetrics.columnWidth(
            columns: columnCount,
            in: totalWidth,
            gap: TreeDetailSpacing.cardGap
        )
    }

    /// Width spanning `columnSpan` columns including gaps between those columns.
    static func spanWidth(columns columnSpan: Int, in totalWidth: CGFloat) -> CGFloat {
        FaloGridMetrics.spanWidth(
            columnSpan: columnSpan,
            columns: columnCount,
            in: totalWidth,
            gap: TreeDetailSpacing.cardGap
        )
    }
}

/// Tree Detail canvas sizing — minimum readability floor; no maximum width.
enum TreeDetailLayout {
    /// Minimum inner width of the three-column grid. Cards never shrink below this.
    static let minimumContentWidth: CGFloat = FaloAdaptiveWorkspaceProfile.treeDetail.minimumContentWidth

    /// Content width plus page inset — horizontal scroll threshold (content-only; not a window minimum).
    static var horizontalScrollThreshold: CGFloat {
        FaloAdaptiveLayout.horizontalScrollThreshold(
            contentWidth: minimumContentWidth,
            pageInset: FaloAdaptiveWorkspaceProfile.treeDetail.pageInset
        )
    }
}

extension EnvironmentValues {
    /// Tree Detail grid width — alias for ``EnvironmentValues/faloAdaptiveContentWidth``.
    var treeDetailContentWidth: CGFloat {
        get { faloAdaptiveContentWidth }
        set { faloAdaptiveContentWidth = newValue }
    }
}

/// Three independent columns — natural card heights, no row equalization.
struct TreeDetailCardColumns<C0: View, C1: View, C2: View>: View {
    @Environment(\.treeDetailContentWidth) private var contentWidth

    @ViewBuilder var column0: () -> C0
    @ViewBuilder var column1: () -> C1
    @ViewBuilder var column2: () -> C2

    private var columnWidth: CGFloat {
        TreeDetailCardGridMetrics.columnWidth(in: contentWidth)
    }

    var body: some View {
        HStack(alignment: .top, spacing: TreeDetailSpacing.cardGap) {
            columnStack(content: column0)
                .frame(width: columnWidth, alignment: .topLeading)
                .clipped()
            columnStack(content: column1)
                .frame(width: columnWidth, alignment: .topLeading)
                .clipped()
            columnStack(content: column2)
                .frame(width: columnWidth, alignment: .topLeading)
                .clipped()
        }
        .frame(width: contentWidth, alignment: .topLeading)
    }

    private func columnStack<Content: View>(
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(alignment: .leading, spacing: TreeDetailSpacing.cardGap) {
            content()
        }
        .frame(maxWidth: .infinity, alignment: .topLeading)
    }
}

/// Photo band on the Tree Detail grid: primary = column 0, gallery = columns 1–2.
struct TreeDetailPhotoGrid<Primary: View, Gallery: View>: View {
    @Environment(\.treeDetailContentWidth) private var contentWidth

    @ViewBuilder var primary: () -> Primary
    @ViewBuilder var gallery: () -> Gallery

    private var primaryColumnWidth: CGFloat {
        TreeDetailCardGridMetrics.columnWidth(in: contentWidth)
    }

    private var galleryColumnWidth: CGFloat {
        TreeDetailCardGridMetrics.spanWidth(columns: 2, in: contentWidth)
    }

    var body: some View {
        HStack(alignment: .top, spacing: TreeDetailSpacing.cardGap) {
            primary()
                .frame(width: primaryColumnWidth, alignment: .center)

            gallery()
                .frame(width: galleryColumnWidth, alignment: .top)
        }
        .frame(width: contentWidth, alignment: .topLeading)
    }
}
