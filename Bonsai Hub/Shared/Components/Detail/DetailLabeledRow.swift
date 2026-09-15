//
//  DetailLabeledRow.swift
//  Bonsai World
//
//  Standard label / value row for Falo Detail cards (View Mode).
/// Typography: Falo Card Typography Standard v1.
//  Empty values use ``FaloDisplayValue`` — never hardcode placeholders in call sites.
//

import SwiftUI

struct DetailLabeledRow: View {
    /// Shared label column so cards keep one rhythm (not a 50/50 split).
    private static let labelColumnWidth: CGFloat = 140

    let label: String
    var value: String
    /// Shown when `value` is blank. Defaults to ``FaloDisplayValue/empty``.
    var emptyDisplay: String
    var monospaced: Bool
    var allowsSelection: Bool
    /// Max lines for the value. `nil` wraps without truncation.
    var valueLineLimit: Int?

    init(
        label: String,
        value: String,
        emptyDisplay: String = FaloDisplayValue.empty,
        monospaced: Bool = false,
        allowsSelection: Bool = true,
        valueLineLimit: Int? = nil
    ) {
        self.label = label
        self.value = value
        self.emptyDisplay = Self.normalizedEmpty(emptyDisplay)
        self.monospaced = monospaced
        self.allowsSelection = allowsSelection
        self.valueLineLimit = valueLineLimit
    }

    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: FaloSpacing.medium) {
            Text(label)
                .font(FaloCardTypography.fieldLabel)
                .foregroundStyle(.secondary)
                .lineLimit(2)
                .truncationMode(.tail)
                .frame(width: Self.labelColumnWidth, alignment: .leading)
                .fixedSize(horizontal: false, vertical: true)

            Group {
                if allowsSelection {
                    valueText
                        .textSelection(.enabled)
                } else {
                    valueText
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(label), \(displayValue)")
    }

    private var valueText: some View {
        Text(displayValue)
            .font(valueFont)
            .foregroundStyle(isEmpty ? .secondary : .primary)
            .multilineTextAlignment(.leading)
            .lineLimit(valueLineLimit)
            .truncationMode(.tail)
            .fixedSize(horizontal: false, vertical: true)
    }

    private var valueFont: Font {
        let base = FaloCardTypography.fieldValue
        return monospaced ? base.monospaced() : base
    }

    private var isEmpty: Bool {
        value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    private var displayValue: String {
        FaloDisplayValue.text(value, empty: emptyDisplay)
    }

    /// Maps legacy placeholders (`None`, em dash) onto the shared dash.
    private static func normalizedEmpty(_ candidate: String) -> String {
        switch candidate {
        case "None", "none", "NULL", "null", "nil", "—", "–":
            FaloDisplayValue.empty
        default:
            candidate
        }
    }
}

#Preview {
    VStack(spacing: FaloSpacing.small) {
        DetailLabeledRow(label: "Tree Name", value: "Dragon")
        DetailLabeledRow(label: "Nickname", value: "")
        DetailLabeledRow(label: "Cultivar", value: "", emptyDisplay: FaloDisplayValue.empty)
        DetailLabeledRow(
            label: "Attention",
            value: "• Strong growth\n• High water demand"
        )
    }
    .padding()
    .frame(width: 360)
}
