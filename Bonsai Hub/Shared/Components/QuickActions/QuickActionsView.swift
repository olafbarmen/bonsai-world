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
/// Place between Workspace and Tools. Worlds supply action catalogs;
/// this view only renders them. Extend context actions by updating the
/// catalog (or provider) passed in — never by editing this view.
struct QuickActionsView: View {
    /// Always-visible actions (same across modules).
    let globalActions: [ActionDefinition]
    /// Module-specific actions for the current selection; empty when none.
    let contextActions: [ActionDefinition]
    /// Optional hook when an available action is chosen. Defaults to no-op.
    var onAction: ((ActionDefinition) -> Void)? = nil

    @State private var comingSoonTitle: String?

    var body: some View {
        Section {
            ForEach(globalActions) { definition in
                QuickActionRow(definition: definition) {
                    trigger(definition)
                }
                .listRowInsets(rowInsets)
            }

            if !contextActions.isEmpty {
                QuickActionsDivider()
                    .listRowInsets(
                        EdgeInsets(
                            top: FaloSpacing.small,
                            leading: FaloSpacing.medium,
                            bottom: FaloSpacing.small,
                            trailing: FaloSpacing.medium
                        )
                    )
                    .accessibilityHidden(true)

                ForEach(contextActions) { definition in
                    QuickActionRow(definition: definition) {
                        trigger(definition)
                    }
                    .listRowInsets(rowInsets)
                    .id(definition.id)
                }
            }
        } header: {
            SidebarSectionHeader(
                title: "Quick Actions",
                topPadding: FaloSpacing.xxLarge
            )
        }
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

    private var rowInsets: EdgeInsets {
        EdgeInsets(
            top: FaloSpacing.xSmall,
            leading: FaloSpacing.small,
            bottom: FaloSpacing.xSmall,
            trailing: FaloSpacing.small
        )
    }

    private func trigger(_ definition: ActionDefinition) {
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
    var onTrigger: () -> Void

    var body: some View {
        Button(action: onTrigger) {
            Label {
                Text(definition.title)
                    .font(FaloTypography.body)
            } icon: {
                Image(systemName: definition.systemImage ?? "circle")
                    .font(.system(size: 14, weight: .semibold))
                    .symbolRenderingMode(.hierarchical)
                    .frame(width: 22, height: 22, alignment: .center)
            }
            .padding(.vertical, FaloSpacing.xSmall)
            .frame(maxWidth: .infinity, alignment: .leading)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .disabled(!definition.isEnabled)
        .help(definition.resolvedHelp)
        .accessibilityLabel(definition.title)
    }
}

#Preview("With context") {
    List {
        QuickActionsView(
            globalActions: [
                ActionDefinition(id: "g.new", title: "New Tree", systemImage: "leaf", availability: .comingSoon),
                ActionDefinition(id: "g.search", title: "Search", systemImage: "magnifyingglass", availability: .comingSoon),
                ActionDefinition(id: "g.import", title: "Import", systemImage: "square.and.arrow.down", availability: .comingSoon)
            ],
            contextActions: [
                ActionDefinition(id: "c1", title: "New Location", systemImage: "mappin.and.ellipse", availability: .comingSoon),
                ActionDefinition(id: "c2", title: "Move Collection", systemImage: "arrow.right.doc.on.clipboard", availability: .comingSoon)
            ]
        )
    }
    .listStyle(.sidebar)
    .frame(width: 240, height: 420)
}

#Preview("Global only") {
    List {
        QuickActionsView(
            globalActions: [
                ActionDefinition(id: "g.new", title: "New Tree", systemImage: "leaf", availability: .comingSoon)
            ],
            contextActions: []
        )
    }
    .listStyle(.sidebar)
    .frame(width: 240, height: 200)
}
