//
//  DashboardCardSection.swift
//  Bonsai World
//
//  Shared visual structure for Dashboard cards:
//  Summary → Context → Next Action (presentation only).
//

import SwiftUI

/// Quiet subsection label inside a Dashboard card.
struct DashboardCardSectionLabel: View {
    let title: String

    var body: some View {
        Text(title)
            .font(FaloTypography.caption)
            .foregroundStyle(.secondary)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

/// Empty-state line inside a live Dashboard card (function exists, nothing to show).
struct DashboardEmptyMessage: View {
    let text: String

    var body: some View {
        Text(text)
            .font(FaloTypography.body)
            .foregroundStyle(.secondary)
            .padding(.vertical, FaloSpacing.small)
    }
}

/// Heading is kept; the module behind this card is not wired yet.
struct DashboardNoFunctionYet: View {
    var body: some View {
        DashboardEmptyMessage(text: "No function yet.")
    }
}

/// Full-width plain tap target for Dashboard rows (deep-link only).
struct DashboardCardTapButton<Label: View>: View {
    let action: () -> Void
    @ViewBuilder var label: () -> Label

    var body: some View {
        Button(action: action) {
            label()
                .frame(maxWidth: .infinity, alignment: .leading)
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

/// Compact bullet list for context lines.
struct DashboardCardBulletList: View {
    let items: [String]
    var compact: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: compact ? 2 : FaloSpacing.xSmall) {
            ForEach(items, id: \.self) { item in
                HStack(alignment: .firstTextBaseline, spacing: FaloSpacing.xSmall) {
                    Text("·")
                        .foregroundStyle(.tertiary)
                    Text(item)
                        .font(FaloTypography.caption)
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

/// Next-step line — visual only; not a button.
struct DashboardCardNextAction: View {
    let text: String

    var body: some View {
        VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
            DashboardCardSectionLabel(title: "Next Action")
            Text(text)
                .font(FaloTypography.body)
                .foregroundStyle(.primary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Next Action, \(text)")
    }
}

/// Groups Summary / Context / Next Action with light separators.
struct DashboardCardBodyStack<Summary: View, Context: View>: View {
    var nextAction: String?
    @ViewBuilder var summary: () -> Summary
    @ViewBuilder var context: () -> Context

    init(
        nextAction: String? = nil,
        @ViewBuilder summary: @escaping () -> Summary,
        @ViewBuilder context: @escaping () -> Context
    ) {
        self.nextAction = nextAction
        self.summary = summary
        self.context = context
    }

    var body: some View {
        VStack(alignment: .leading, spacing: FaloSpacing.medium) {
            summary()

            context()

            if let nextAction, !nextAction.isEmpty {
                DashboardCardNextAction(text: nextAction)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
