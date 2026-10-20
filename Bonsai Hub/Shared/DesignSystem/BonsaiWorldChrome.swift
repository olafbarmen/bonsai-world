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
            // The bar and the page are light. Without this, a Mac in Dark Mode
            // draws toolbar labels and body text white on the cream surface.
            .toolbarColorScheme(.light, for: .windowToolbar)
            .preferredColorScheme(.light)
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
    func bonsaiWorkspaceNavigationTitle(
        _ title: String,
        onBack: (() -> Void)? = nil
    ) -> some View {
        modifier(BonsaiWorkspaceNavigationTitleModifier(title: title, onBack: onBack))
    }
}

private struct BonsaiWorkspaceNavigationTitleModifier: ViewModifier {
    let title: String
    var onBack: (() -> Void)? = nil
    @Environment(\.faloShellProvidesLeadingInset) private var shellProvidesLeadingInset

    private var leadingInset: CGFloat {
        shellProvidesLeadingInset ? FaloSpacing.medium : DashboardSpacing.pageInset
    }

    private var trailingInset: CGFloat {
        shellProvidesLeadingInset ? FaloSpacing.medium : DashboardSpacing.pageInset
    }

    func body(content: Content) -> some View {
        VStack(spacing: 0) {
            if let onBack {
                Button(action: onBack) {
                    HStack(spacing: FaloSpacing.xSmall) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 13, weight: .semibold))
                        Text("Back")
                            .font(FaloTypography.body)
                    }
                }
                .buttonStyle(.plain)
                .foregroundStyle(BonsaiWorldColors.accent)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, leadingInset)
                .padding(.trailing, trailingInset)
                .padding(.top, FaloSpacing.small)
                .padding(.bottom, FaloSpacing.xSmall)
                .accessibilityLabel("Back")
            }

            Text(title)
                .font(.headline)
                .foregroundStyle(BonsaiWorldColors.textPrimary)
                .frame(maxWidth: .infinity, alignment: .leading)
                // When the shell already insets the page, keep a small leading pad so
                // list-column titles (Pots / Inventory) are not clipped at the sidebar edge.
                .padding(.leading, leadingInset)
                .padding(.trailing, trailingInset)
                .padding(.top, onBack == nil ? FaloSpacing.small : 0)
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
