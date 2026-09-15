//
//  QuickActionsView.swift
//  Bonsai World
//
//  Reusable Falo Quick Actions sidebar component.
//  Renders supplied Global + Context action lists — no World or module knowledge.
//

import SwiftUI

/// Shared Falo Quick Actions block for any application sidebar.
///
/// Pinned below the scrolling Workspace list so actions stay visible while
/// navigating. Rows mirror Workspace modules (Tasks / Garden): chevron + icon
/// + title; nested actions expand underneath like subpages — never a system Menu.
struct QuickActionsView: View {
    /// Section header — "Context Tools" in Library; "Image Tools" etc. in workspaces.
    var sectionTitle: String = "Context Tools"
    /// Always-visible actions (same across modules).
    let globalActions: [ActionDefinition]
    /// Module-specific actions for the current selection; empty when none.
    let contextActions: [ActionDefinition]
    /// Hard cap for the whole block (header + rows). Content taller than this scrolls.
    /// Pass half the sidebar column height from `SidebarView`.
    var maxHeight: CGFloat? = nil
    /// Optional hook when an available action is chosen. Defaults to no-op.
    var onAction: ((ActionDefinition) -> Void)? = nil

    @State private var isSectionExpanded = true
    @State private var expandedMenuIDs: Set<String> = []
    @State private var comingSoonTitle: String?

    /// Matches `QuickActionRow` main / subpage heights.
    private static let rowHeight: CGFloat = 26
    private static let subpageRowHeight: CGFloat = 22
    private static let sectionHeaderHeight: CGFloat = 22
    private static let dividerHeight: CGFloat = 10
    private static let headerHeight: CGFloat = 34
    private static let actionsBottomPadding: CGFloat = 8
    private static let chevronColumn: CGFloat = 12

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            sectionHeader

            if isSectionExpanded {
                let actionsHeight = actionsViewportHeight
                ScrollView(.vertical, showsIndicators: needsScroll) {
                    actionsStack
                }
                .scrollDisabled(!needsScroll)
                .frame(height: actionsHeight, alignment: .top)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        // Own height = header + actions viewport, never above the passed cap.
        .frame(height: blockHeight, alignment: .top)
        .clipped()
        .alert(
            "Coming Soon",
            isPresented: Binding(
                get: { comingSoonTitle != nil },
                set: { if !$0 { comingSoonTitle = nil } }
            )
        ) {
            Button("OK", role: .cancel) { comingSoonTitle = nil }
        } message: {
            Text(comingSoonTitle.map { "“\($0)” is not available yet." } ?? "")
        }
    }

    /// Total height of the Context Tools block (never exceeds `maxHeight` when set).
    private var blockHeight: CGFloat {
        let content = isSectionExpanded
            ? Self.headerHeight + actionsViewportHeight
            : Self.headerHeight
        guard let maxHeight, maxHeight > 0 else { return content }
        return min(content, maxHeight)
    }

    /// True when estimated rows would exceed the allowed viewport under the cap.
    private var needsScroll: Bool {
        guard maxHeight != nil else { return false }
        return estimatedActionsHeight > actionsViewportHeight + 0.5
    }

    /// Visible height for the action list: full content, or remaining room under the cap.
    private var actionsViewportHeight: CGFloat {
        let estimated = estimatedActionsHeight
        guard let maxHeight, maxHeight > 0 else { return estimated }
        let roomForActions = max(0, maxHeight - Self.headerHeight)
        return min(estimated, roomForActions)
    }

    /// Approximate intrinsic height of all action rows (no GeometryReader / ViewThatFits).
    private var estimatedActionsHeight: CGFloat {
        var height = Self.actionsBottomPadding
        for definition in globalActions {
            height += heightContribution(for: definition)
        }
        if !contextActions.isEmpty {
            if !globalActions.isEmpty {
                height += Self.dividerHeight
            }
            for definition in contextActions {
                switch definition.kind {
                case .separator:
                    height += Self.dividerHeight
                case .sectionHeader:
                    height += Self.sectionHeaderHeight
                case .action:
                    height += heightContribution(for: definition)
                }
            }
        }
        return height
    }

    private func heightContribution(for definition: ActionDefinition) -> CGFloat {
        var height = Self.rowHeight
        if definition.hasMenu, expandedMenuIDs.contains(definition.id) {
            height += CGFloat(definition.children.count) * Self.subpageRowHeight
        }
        return height
    }

    private var actionsStack: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(globalActions) { definition in
                actionBlock(definition)
            }

            if !contextActions.isEmpty {
                if !globalActions.isEmpty {
                    QuickActionsDivider()
                        .padding(.horizontal, FaloSpacing.small)
                }

                ForEach(contextActions) { definition in
                    switch definition.kind {
                    case .separator:
                        QuickActionsDivider()
                            .padding(.horizontal, FaloSpacing.small)
                            .accessibilityHidden(true)
                    case .sectionHeader:
                        Text(definition.title)
                            .font(.system(size: 10, weight: .medium))
                            .foregroundStyle(BonsaiWorldColors.sidebarTextSecondary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.horizontal, FaloSpacing.small)
                            .padding(.leading, Self.chevronColumn + FaloSpacing.xSmall)
                            .padding(.top, FaloSpacing.small)
                            .accessibilityAddTraits(.isHeader)
                    case .action:
                        actionBlock(definition)
                    }
                }
            }
        }
        .padding(.bottom, FaloSpacing.small)
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    /// Same chevron + label pattern as Workspace “Tasks” / “Garden”.
    private var sectionHeader: some View {
        Button {
            withAnimation(.easeInOut(duration: 0.15)) {
                isSectionExpanded.toggle()
            }
        } label: {
            HStack(spacing: FaloSpacing.xSmall) {
                Image(systemName: isSectionExpanded ? "chevron.down" : "chevron.right")
                    .font(.system(size: 9, weight: .semibold))
                    .foregroundStyle(BonsaiWorldColors.sidebarTextSecondary)
                    .frame(width: Self.chevronColumn, alignment: .center)
                    .accessibilityHidden(true)

                Text(sectionTitle)
                    .font(.system(size: 10, weight: .medium))
                    .foregroundStyle(BonsaiWorldColors.sidebarTextSecondary)
                    .textCase(.uppercase)
                    .tracking(1.1)

                Spacer(minLength: 0)
            }
            .padding(.top, FaloSpacing.medium)
            .padding(.bottom, FaloSpacing.xSmall)
            .padding(.horizontal, FaloSpacing.small)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .accessibilityLabel(sectionTitle)
        .accessibilityValue(isSectionExpanded ? "Expanded" : "Collapsed")
        .accessibilityAddTraits(.isHeader)
    }

    @ViewBuilder
    private func actionBlock(_ definition: ActionDefinition) -> some View {
        if definition.hasMenu {
            expandableAction(definition)
        } else {
            QuickActionRow(
                definition: definition,
                showsLeadingChevronSlot: true,
                isDisclosureExpanded: false,
                showsChevronGlyph: false,
                onAction: trigger
            )
            .padding(.horizontal, FaloSpacing.small)
        }
    }

    private func expandableAction(_ definition: ActionDefinition) -> some View {
        let isOpen = expandedMenuIDs.contains(definition.id)
        return VStack(alignment: .leading, spacing: 0) {
            QuickActionRow(
                definition: definition,
                showsLeadingChevronSlot: true,
                isDisclosureExpanded: isOpen,
                showsChevronGlyph: true,
                onAction: { _ in
                    // No height animation — animated sidebar growth was locking window resize.
                    if isOpen {
                        expandedMenuIDs.remove(definition.id)
                    } else {
                        expandedMenuIDs.insert(definition.id)
                    }
                }
            )
            .padding(.horizontal, FaloSpacing.small)

            if isOpen {
                ForEach(definition.children) { child in
                    QuickActionRow(
                        definition: child,
                        showsLeadingChevronSlot: true,
                        isDisclosureExpanded: false,
                        showsChevronGlyph: false,
                        isSubpage: true,
                        onAction: trigger
                    )
                    .padding(.horizontal, FaloSpacing.small)
                }
            }
        }
        // Keep expand/collapse from participating in window ideal-size fights.
        .animation(nil, value: isOpen)
    }

    private func trigger(_ definition: ActionDefinition) {
        guard definition.kind == .action else { return }
        switch definition.availability {
        case .comingSoon:
            comingSoonTitle = definition.title
        case .available:
            onAction?(definition)
        case .disabled:
            break
        }
    }
}

/// Quiet separator between Global and Context Quick Actions.
struct QuickActionsDivider: View {
    var body: some View {
        Rectangle()
            .fill(FaloColors.borderSubtle)
            .frame(height: 1)
            .frame(maxWidth: .infinity)
            .padding(.vertical, FaloSpacing.xSmall)
            .accessibilityHidden(true)
    }
}

struct QuickActionRow: View {
    let definition: ActionDefinition
    /// Reserve the same 12pt leading column as Tasks / Add Tree (keeps icons + titles aligned).
    var showsLeadingChevronSlot: Bool = true
    var isDisclosureExpanded: Bool = false
    /// Draw chevron.down / chevron.right; when false the slot stays empty for alignment.
    var showsChevronGlyph: Bool = false
    /// Indented like Workspace subpages (Overdue / Today under Tasks).
    var isSubpage: Bool = false
    var appearance: QuickActionRowAppearance = .standard
    var onAction: (ActionDefinition) -> Void

    var body: some View {
        Button {
            onAction(definition)
        } label: {
            rowLabel
        }
        .buttonStyle(.plain)
        .disabled(!definition.isEnabled)
        .help(definition.resolvedHelp)
        .accessibilityLabel(definition.title)
        .accessibilityValue(
            showsChevronGlyph
                ? (isDisclosureExpanded ? "Expanded" : "Collapsed")
                : ""
        )
    }

    /// HStack only — system Label / Menu add trailing chevrons and override fonts.
    private var rowLabel: some View {
        HStack(spacing: FaloSpacing.xSmall) {
            if showsLeadingChevronSlot {
                Group {
                    if showsChevronGlyph {
                        Image(systemName: isDisclosureExpanded ? "chevron.down" : "chevron.right")
                            .font(.system(size: 9, weight: .semibold))
                            .foregroundStyle(BonsaiWorldColors.sidebarTextPrimary)
                    } else {
                        Color.clear
                    }
                }
                .frame(width: 12, alignment: .center)
                .accessibilityHidden(true)
            }

            HStack(spacing: FaloSpacing.small) {
                if let systemImage = definition.systemImage {
                    Image(systemName: systemImage)
                        .font(.system(size: FaloIconSize.navigation, weight: .regular))
                        .symbolRenderingMode(.monochrome)
                        .foregroundStyle(appearance.iconColor)
                        .frame(width: 20, height: 20, alignment: .center)
                }

                Text(definition.title)
                    .font(appearance.titleFont)
                    .foregroundStyle(appearance.titleColor)

                Spacer(minLength: 0)
            }
        }
        .padding(.leading, isSubpage ? (FaloSpacing.large + FaloSpacing.small) : 0)
        .frame(maxWidth: .infinity, maxHeight: isSubpage ? 22 : 26, alignment: .leading)
        .contentShape(Rectangle())
    }
}

/// Visual weight for Quick Action rows.
enum QuickActionRowAppearance: Sendable {
    /// Main sidebar Context Tools — same size/weight as sidebar subpages.
    case standard
    /// Crop Tools and similar — quieter secondary text.
    case quieter

    var titleFont: Font {
        .system(size: 12, weight: .regular)
    }

    var titleColor: Color {
        switch self {
        case .standard: BonsaiWorldColors.sidebarTextPrimary
        case .quieter: BonsaiWorldColors.sidebarTextSecondary
        }
    }

    var iconColor: Color {
        switch self {
        case .standard: BonsaiWorldColors.sidebarAccent
        case .quieter: BonsaiWorldColors.sidebarTextSecondary
        }
    }
}

#Preview("Pinned panel") {
    VStack(spacing: 0) {
        Text("Workspace list…")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        Divider()
        QuickActionsView(
            globalActions: GlobalQuickActionsCatalog.actions,
            contextActions: [
                ActionDefinition(id: "c1", title: "Add Location", systemImage: "mappin.and.ellipse", availability: .available),
            ]
        )
    }
    .frame(width: 240, height: 520)
    .background(BonsaiWorldColors.sidebar)
}
