//
//  DetailHeader.swift
//  Bonsai World
//
//  Reusable Detail page header: title, subtitle, optional Edit / quick-actions menu.
//  Prefer Context Tools in the sidebar for module actions; leave quickActions empty
//  when the header should show title only.
//

import SwiftUI

struct DetailHeader: View {
    let title: String
    var subtitle: String?
    var onEdit: (() -> Void)?
    /// Context Tools for the current entity. Empty shows a disabled menu.
    var quickActions: [ActionDefinition] = []
    var onQuickAction: ((ActionDefinition) -> Void)?

    @State private var comingSoonTitle: String?

    var body: some View {
        HStack(alignment: .top, spacing: FaloSpacing.large) {
            VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
                Text(title)
                    .font(.title2.weight(.semibold))
                    .foregroundStyle(.primary)
                    .textSelection(.enabled)

                if let subtitle, !subtitle.isEmpty {
                    Text(subtitle)
                        .font(FaloTypography.body)
                        .foregroundStyle(.secondary)
                }
            }

            Spacer(minLength: FaloSpacing.medium)

            HStack(spacing: FaloSpacing.small) {
                if let onEdit {
                    Button("Edit", action: onEdit)
                        .keyboardShortcut("e", modifiers: [.command])
                }

                if !quickActions.isEmpty {
                    Menu {
                        ForEach(quickActions) { action in
                            Button {
                                trigger(action)
                            } label: {
                                Label(action.title, systemImage: action.systemImage ?? "circle")
                            }
                            .disabled(!action.isEnabled)
                        }
                    } label: {
                        Label("Context Tools", systemImage: "ellipsis.circle")
                            .labelStyle(.iconOnly)
                    }
                    .menuStyle(.borderlessButton)
                    .menuIndicator(.hidden)
                    .help("Context Tools")
                }
            }
        }
        .accessibilityElement(children: .contain)
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

    private func trigger(_ action: ActionDefinition) {
        switch action.availability {
        case .comingSoon:
            comingSoonTitle = action.title
        case .available:
            onQuickAction?(action)
        case .disabled:
            break
        }
    }
}

#Preview {
    DetailHeader(
        title: "South Bench Greenhouse",
        subtitle: "Greenhouse",
        onEdit: {},
        quickActions: [
            ActionDefinition(id: "1", title: "Move Collection", systemImage: "arrow.right.doc.on.clipboard", availability: .comingSoon)
        ]
    )
    .padding()
    .frame(width: 480)
}
