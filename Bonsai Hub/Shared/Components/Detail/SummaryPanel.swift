//
//  SummaryPanel.swift
//  Bonsai World
//
//  Reusable Summary panel for Falo Detail pages.
//

import SwiftUI

struct SummaryPanel: View {
    var title: String = "Summary"
    let fields: [DetailField]

    var body: some View {
        VStack(alignment: .leading, spacing: FaloCardTypography.titleToContent) {
            DetailSectionHeader(title: title)

            VStack(alignment: .leading, spacing: FaloSpacing.small) {
                ForEach(fields) { field in
                    DetailFieldRow(field: field)
                }
            }
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel(title)
    }
}

struct DetailFieldRow: View {
    let field: DetailField

    var body: some View {
        HStack(alignment: .firstTextBaseline) {
            Text(field.label)
                .font(FaloCardTypography.fieldLabel)
                .foregroundStyle(.secondary)
            Spacer(minLength: FaloSpacing.medium)
            Text(field.value)
                .font(FaloCardTypography.fieldValue)
                .foregroundStyle(.primary)
                .multilineTextAlignment(.trailing)
                .textSelection(.enabled)
        }
        .padding(.vertical, FaloSpacing.small)
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    SummaryPanel(fields: [
        DetailField(label: "Collections", value: "2"),
        DetailField(label: "Trees", value: "8"),
        DetailField(label: "Created", value: "Mar 12, 2024"),
        DetailField(label: "Updated", value: "Jun 18, 2026")
    ])
    .padding()
    .frame(width: 420)
}
