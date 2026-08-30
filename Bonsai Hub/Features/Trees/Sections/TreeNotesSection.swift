//
//  TreeNotesSection.swift
//  Bonsai World
//
//  Notes card for Tree Detail — uses Falo DetailCard.
//  Journal column layout reserves vertical space for a future chronological journal.
//

import SwiftUI

enum TreeNotesLayout {
    /// Standard card height in a multi-card column.
    case standard
    /// Third-column journal column — taller body for future expansion.
    case journalColumn
}

struct TreeNotesSection: View {
    @Binding var text: String
    var isEditing: Bool
    var layout: TreeNotesLayout = .standard

    private var editorMinHeight: CGFloat {
        switch layout {
        case .standard: 120
        case .journalColumn: 520
        }
    }

    private var viewMinHeight: CGFloat {
        switch layout {
        case .standard: 0
        case .journalColumn: 520
        }
    }

    var body: some View {
        DetailCard(title: "Notes") {
            if isEditing {
                TextEditor(text: $text)
                    .font(FaloCardTypography.fieldValue)
                    .frame(minHeight: editorMinHeight, maxHeight: .infinity, alignment: .topLeading)
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
                    .frame(maxWidth: .infinity, minHeight: viewMinHeight, alignment: .topLeading)
                    .textSelection(.enabled)
                    .padding(.vertical, FaloSpacing.xSmall)
            }

            if layout == .journalColumn {
                Text("Future journal entries will appear here chronologically.")
                    .font(FaloTypography.caption)
                    .foregroundStyle(.tertiary)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: layout == .journalColumn ? .infinity : nil, alignment: .topLeading)
    }

    private var isEmpty: Bool {
        text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    private var displayText: String {
        isEmpty ? "No notes yet." : text
    }
}
