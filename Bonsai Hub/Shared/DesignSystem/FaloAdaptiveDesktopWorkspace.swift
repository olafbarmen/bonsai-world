//
//  FaloAdaptiveDesktopWorkspace.swift
//  Bonsai World
//
//  Shared Adaptive Desktop Workspace — one layout system for all major Bonsai World surfaces.
//
//  • Expands to fill available window width (no maximum content width).
//  • Proportional regions scale via ``EnvironmentValues/faloAdaptiveContentWidth``.
//  • Each profile defines a minimum CONTENT width — never a window or column minimum.
//  • Horizontal scroll when content exceeds available width; the window is never forced to resize.
//  • Vertical scroll always available.
//
//  Falo: "The user controls the window size. Workspaces control only their own content."
//

import SwiftUI

// MARK: - Profile

/// Minimum width and inset for a module workspace.
/// Applies to scrollable content only — must never be used to constrain the application window.
struct FaloAdaptiveWorkspaceProfile: Hashable, Sendable {
    var minimumContentWidth: CGFloat
    var pageInset: CGFloat

    /// Default floor for Tree Detail, forms, and most module detail pages.
    static let standard = FaloAdaptiveWorkspaceProfile(
        minimumContentWidth: 960,
        pageInset: FaloSpacing.xLarge
    )

    /// Tree Detail / Edit Tree — three-column card grid.
    static let treeDetail = standard

    /// New Tree and similar create/edit forms.
    static let form = standard

    /// Dashboard — page inset matches ``DashboardSpacing/pageInset``.
    static let dashboard = FaloAdaptiveWorkspaceProfile(
        minimumContentWidth: 960,
        pageInset: DashboardSpacing.pageInset
    )
}

// MARK: - Layout constants

enum FaloAdaptiveLayout {
    static let defaultMinimumContentWidth: CGFloat = FaloAdaptiveWorkspaceProfile.standard.minimumContentWidth

    /// Content width plus page inset — width at which horizontal scrolling begins (content-only; not a window minimum).
    static func horizontalScrollThreshold(
        contentWidth: CGFloat,
        pageInset: CGFloat = FaloSpacing.xLarge
    ) -> CGFloat {
        contentWidth + pageInset * 2
    }
}

/// Proportional column math for adaptive workspaces (Tree Detail, Dashboard, future modules).
enum FaloGridMetrics {
    /// Width of one equal column within `totalWidth`, accounting for `gap` between columns.
    static func columnWidth(columns: Int, in totalWidth: CGFloat, gap: CGFloat) -> CGFloat {
        guard columns > 0 else { return totalWidth }
        let gaps = gap * CGFloat(columns - 1)
        return max(0, (totalWidth - gaps) / CGFloat(columns))
    }

    /// Width spanning `columnSpan` columns within a grid of `columns` total columns.
    static func spanWidth(
        columnSpan: Int,
        columns: Int,
        in totalWidth: CGFloat,
        gap: CGFloat
    ) -> CGFloat {
        let span = min(max(columnSpan, 1), columns)
        let col = columnWidth(columns: columns, in: totalWidth, gap: gap)
        return col * CGFloat(span) + gap * CGFloat(span - 1)
    }
}

// MARK: - Content width environment

private struct FaloAdaptiveContentWidthKey: EnvironmentKey {
    static let defaultValue: CGFloat = FaloAdaptiveLayout.defaultMinimumContentWidth
}

extension EnvironmentValues {
    /// Scaled inner content width — set by ``FaloAdaptiveDesktopWorkspace``.
    var faloAdaptiveContentWidth: CGFloat {
        get { self[FaloAdaptiveContentWidthKey.self] }
        set { self[FaloAdaptiveContentWidthKey.self] = newValue }
    }

    /// Legacy alias — prefer ``faloAdaptiveContentWidth``.
    var faloScaledContentWidth: CGFloat {
        get { faloAdaptiveContentWidth }
        set { faloAdaptiveContentWidth = newValue }
    }
}

// MARK: - Workspace

/// Adaptive desktop scroll surface — shared by Dashboard, Tree Detail, New Tree, and future modules.
struct FaloAdaptiveDesktopWorkspace<Content: View>: View {
    var profile: FaloAdaptiveWorkspaceProfile
    @ViewBuilder var content: () -> Content

    init(
        profile: FaloAdaptiveWorkspaceProfile = .standard,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.profile = profile
        self.content = content
    }

    /// Convenience — explicit minimum width and inset (same behaviour as a custom profile).
    init(
        minimumContentWidth: CGFloat,
        pageInset: CGFloat = FaloSpacing.xLarge,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.profile = FaloAdaptiveWorkspaceProfile(
            minimumContentWidth: minimumContentWidth,
            pageInset: pageInset
        )
        self.content = content
    }

    var body: some View {
        GeometryReader { geometry in
            let pageInset = profile.pageInset
            let minimumContentWidth = profile.minimumContentWidth
            let innerAvailable = max(0, geometry.size.width - pageInset * 2)
            let contentWidth = max(minimumContentWidth, innerAvailable)
            let needsHorizontalScroll = innerAvailable < minimumContentWidth

            ScrollView(.vertical, showsIndicators: true) {
                Group {
                    if needsHorizontalScroll {
                        ScrollView(.horizontal, showsIndicators: true) {
                            scaledContent(contentWidth: contentWidth, pageInset: pageInset)
                        }
                    } else {
                        scaledContent(contentWidth: contentWidth, pageInset: pageInset)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .faloScrollSurface()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func scaledContent(contentWidth: CGFloat, pageInset: CGFloat) -> some View {
        content()
            .environment(\.faloAdaptiveContentWidth, contentWidth)
            .frame(width: contentWidth, alignment: .topLeading)
            .padding(.horizontal, pageInset)
            .padding(.top, pageInset)
            .padding(.bottom, pageInset)
    }
}

// MARK: - Legacy aliases

typealias FaloDesktopScrollWorkspace = FaloAdaptiveDesktopWorkspace
typealias FaloDesktopLayout = FaloAdaptiveLayout
