//
//  DetailEditableTextRow.swift
//  Bonsai World
//
//  Label + text field for Falo Detail Edit Mode.
//  Typography: Falo Card Typography Standard v1.
//

import SwiftUI

struct DetailEditableTextRow: View {
    let label: String
    @Binding var text: String
    var help: String? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
            Text(label)
                .font(FaloCardTypography.fieldLabel)
                .foregroundStyle(.secondary)

            TextField(label, text: $text)
                .font(FaloCardTypography.fieldValue)
                .textFieldStyle(.roundedBorder)
                .labelsHidden()
                .help(help ?? label)
        }
        .padding(.vertical, FaloSpacing.xSmall)
        .accessibilityElement(children: .contain)
    }
}

#Preview {
    DetailEditableTextRow(label: "Tree Name", text: .constant("Dragon"))
        .padding()
}
