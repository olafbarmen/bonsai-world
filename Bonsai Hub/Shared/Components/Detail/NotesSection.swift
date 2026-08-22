//
//  NotesSection.swift
//  Bonsai World
//
//  Reusable Notes section for Falo Detail pages (read-only).
//

import SwiftUI

struct NotesSection: View {
    var title: String = "Notes"
    let notes: String

    private var displayNotes: String {
        let trimmed = notes.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.isEmpty ? "No notes yet." : trimmed
    }

    private var hasNotes: Bool {
        !notes.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var body: some View {
        VStack(alignment: .leading, spacing: FaloCardTypography.titleToContent) {
            DetailSectionHeader(title: title)

            Text(displayNotes)
                .font(FaloCardTypography.fieldValue)
                .foregroundStyle(hasNotes ? .primary : .secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .textSelection(.enabled)
                .padding(.vertical, FaloSpacing.xSmall)
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel(title)
    }
}

#Preview {
    NotesSection(notes: "Maintain winter minimum of 5°C.")
        .padding()
        .frame(width: 420)
}
