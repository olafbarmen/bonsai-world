//
//  FaloAdaptiveDesktopWorkspace.swift
//  Bonsai World
//
//  Shared Adaptive Desktop Workspace — one layout system for all major Bonsai World surfaces.
//
//  • Expands to fill available window width (no maximum content width) unless a profile
//    sets ``locksContentToMinimumWidth``.
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
    /// When true, content width stays at ``minimumContentWidth`` (cards do not grow with the window;
    /// horizontal scroll when the window is narrower).
    var locksContentToMinimumWidth: Bool = false

    /// Default floor for Tree Detail, forms, and most module detail pages.
    /// Page inset matches Dashboard so shell + workspace share one rhythm.
    static let standard = FaloAdaptiveWorkspaceProfile(
        minimumContentWidth: 960,
        pageInset: DashboardSpacing.pageInset
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

    /// Tree Overview View Mode — same width math and inset as Dashboard (4 equal columns).
    static let treeOverview = dashboard

    /// Tasks list — lower floor so the card follows a narrow window; rows keep Complete visible.
    static let tasksList = FaloAdaptiveWorkspaceProfile(
        minimumContentWidth: 520,
        pageInset: DashboardSpacing.pageInset
    )
}

// MARK: - Layout constants

enum FaloAdaptiveLayout {
    static let defaultMinimumContentWidth: CGFloat = FaloAdaptiveWorkspaceProfile.standard.minimumContentWidth

    /// Content width plus page inset — width at which horizontal scrolling begins (content-only; not a window minimum).
    static func horizontalScrollThreshold(
        contentWidth: CGFloat,
        pageInset: CGFloat = DashboardSpacing.pageInset
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

private struct FaloShellProvidesLeadingInsetKey: EnvironmentKey {
    static let defaultValue = false
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

    /// When true, the NavigationSplitView shell already applied Dashboard horizontal insets —
    /// workspace skips its own leading and trailing padding to avoid double air.
    var faloShellProvidesLeadingInset: Bool {
        get { self[FaloShellProvidesLeadingInsetKey.self] }
        set { self[FaloShellProvidesLeadingInsetKey.self] = newValue }
    }
}

// MARK: - Workspace

/// Adaptive desktop scroll surface — shared by Dashboard, Tree Detail, New Tree, and future modules.
struct FaloAdaptiveDesktopWorkspace<Content: View>: View {
    var profile: FaloAdaptiveWorkspaceProfile
    @ViewBuilder var content: () -> Content
    @Environment(\.faloShellProvidesLeadingInset) private var shellProvidesLeadingInset

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
        pageInset: CGFloat = DashboardSpacing.pageInset,
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
            let leadingInset = shellProvidesLeadingInset ? 0 : pageInset
            let trailingInset = shellProvidesLeadingInset ? 0 : pageInset
            let minimumContentWidth = profile.minimumContentWidth
            let horizontalChrome = leadingInset + trailingInset
            let innerAvailable = max(0, geometry.size.width - horizontalChrome)
            let contentWidth = profile.locksContentToMinimumWidth
                ? minimumContentWidth
                : max(minimumContentWidth, innerAvailable)
            let needsHorizontalScroll = innerAvailable < contentWidth

            ScrollView(.vertical, showsIndicators: true) {
                Group {
                    if needsHorizontalScroll {
                        ScrollView(.horizontal, showsIndicators: true) {
                            scaledContent(
                                contentWidth: contentWidth,
                                leadingInset: leadingInset,
                                trailingInset: trailingInset,
                                pageInset: pageInset
                            )
                        }
                    } else {
                        scaledContent(
                            contentWidth: contentWidth,
                            leadingInset: leadingInset,
                            trailingInset: trailingInset,
                            pageInset: pageInset
                        )
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .faloScrollSurface()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func scaledContent(
        contentWidth: CGFloat,
        leadingInset: CGFloat,
        trailingInset: CGFloat,
        pageInset: CGFloat
    ) -> some View {
        content()
            .environment(\.faloAdaptiveContentWidth, contentWidth)
            .frame(width: contentWidth, alignment: .topLeading)
            .padding(.leading, leadingInset)
            .padding(.trailing, trailingInset)
            .padding(.top, pageInset)
            .padding(.bottom, pageInset)
    }
}

// MARK: - Legacy aliases

typealias FaloDesktopScrollWorkspace = FaloAdaptiveDesktopWorkspace
typealias FaloDesktopLayout = FaloAdaptiveLayout
