//
//  ShapingTextField.swift
//  Bonsai World
//
//  White editable text area for Shaping — consistent with Notes fields.
//

import SwiftUI

struct ShapingTextField: View {
    let label: String
    @Binding var text: String
    var minHeight: CGFloat = 72

    var body: some View {
        VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
            Text(label)
                .font(FaloCardTypography.fieldLabel)
                .foregroundStyle(.secondary)

            TextEditor(text: $text)
                .font(FaloCardTypography.fieldValue)
                .fontWeight(.regular)
                .foregroundStyle(.primary)
                .scrollContentBackground(.hidden)
                .frame(minHeight: minHeight, alignment: .topLeading)
                .padding(FaloSpacing.small)
                .background {
                    RoundedRectangle(cornerRadius: FaloRadius.small, style: .continuous)
                        .fill(Color(nsColor: .textBackgroundColor))
                }
                .overlay {
                    RoundedRectangle(cornerRadius: FaloRadius.small, style: .continuous)
                        .strokeBorder(Color.primary.opacity(0.08), lineWidth: 1)
                }
                .accessibilityLabel(label)
        }
    }
}
