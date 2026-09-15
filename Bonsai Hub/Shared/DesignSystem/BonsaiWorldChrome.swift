//
//  BonsaiWorldChrome.swift
//  Bonsai World
//
//  App-level tint and warm shell surfaces — avoids cold system gray chrome.
//

import SwiftUI

extension View {
    /// Applies Bonsai World control accent and warm window-toolbar / window fill.
    /// Hides the default window title (bundle name) — section identity uses
    /// ``bonsaiWorkspaceNavigationTitle(_:)``.
    func bonsaiWorldChrome() -> some View {
        self
            .tint(BonsaiWorldColors.accent)
            .toolbarBackground(BonsaiWorldColors.canvas, for: .windowToolbar)
            .toolbarBackground(.visible, for: .windowToolbar)
            .toolbar(removing: .title)
            .containerBackground(BonsaiWorldColors.canvas, for: .window)
    }

    /// Main workspace / content column fill — warm canvas, not system window gray.
    func faloWorkspaceCanvas() -> some View {
        background(BonsaiWorldColors.canvas)
    }

    /// Content-column `List` chrome — hide system scroll fill, warm canvas, World tint.
    /// Pair each selectable row with `SidebarRowBackground(baseFill: .canvas)`.
    func faloWarmContentList() -> some View {
        self
            .scrollContentBackground(.hidden)
            .background(BonsaiWorldColors.canvas)
            .tint(BonsaiWorldColors.accent)
    }

    /// Workspace page title above content.
    ///
    /// Uses a real `VStack` (not `safeAreaInset`, not `ignoresSafeArea`).
    /// `HSplitView` / `NavigationSplitView` children often ignore top `safeAreaInset`
    /// and draw under the toolbar — clipping the first lines (Species Library, etc.).
    /// Do not wrap in `ignoresSafeArea(.top)` — that asserts with `GeometryReader` (Dashboard).
    func bonsaiWorkspaceNavigationTitle(_ title: String) -> some View {
        modifier(BonsaiWorkspaceNavigationTitleModifier(title: title))
    }
}

private struct BonsaiWorkspaceNavigationTitleModifier: ViewModifier {
    let title: String
    @Environment(\.faloShellProvidesLeadingInset) private var shellProvidesLeadingInset

    func body(content: Content) -> some View {
        VStack(spacing: 0) {
            Text(title)
                .font(.headline)
                .foregroundStyle(BonsaiWorldColors.textPrimary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(
                    .leading,
                    shellProvidesLeadingInset ? 0 : DashboardSpacing.pageInset
                )
                .padding(
                    .trailing,
                    shellProvidesLeadingInset ? 0 : DashboardSpacing.pageInset
                )
                .padding(.top, FaloSpacing.small)
                .padding(.bottom, FaloSpacing.medium)
                .accessibilityAddTraits(.isHeader)

            content
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(BonsaiWorldColors.canvas)
    }
}

enum BonsaiWorldTableZebra {
    /// Odd visual indices get the surface stripe (0-based).
    static func isAlternate(at index: Int) -> Bool {
        !index.isMultiple(of: 2)
    }
}
