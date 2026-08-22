//
//  TreeNotesSection.swift
//  Bonsai World
//
//  Notes card for Tree Detail — uses Falo DetailCard.
//

import SwiftUI

struct TreeNotesSection: View {
    @Binding var text: String
    var isEditing: Bool

    var body: some View {
        DetailCard(title: "Notes") {
            if isEditing {
                TextEditor(text: $text)
                    .font(FaloCardTypography.fieldValue)
                    .frame(minHeight: 120)
                    .padding(FaloSpacing.small)
                    .background {
                        RoundedRectangle(cornerRadius: FaloRadius.small, style: .continuous)
                            .strokeBorder(Color.primary.opacity(0.08), lineWidth: 1)
                    }
                    .accessibilityLabel("Notes")
            } else {
                Text(displayText)
                    .font(FaloCardTypography.fieldValue)
                    .foregroundStyle(isEmpty ? .secondary : .primary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .textSelection(.enabled)
                    .padding(.vertical, FaloSpacing.xSmall)
            }
        }
    }

    private var isEmpty: Bool {
        text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    private var displayText: String {
        isEmpty ? "No notes yet." : text
    }
}
