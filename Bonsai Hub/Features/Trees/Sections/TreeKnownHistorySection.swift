//
//  TreeKnownHistorySection.swift
//  Bonsai World
//
//  Short summary of history known before the tree entered the grower’s care.
//  Detailed dated notes belong in Journal (Before ownership).
//

import SwiftUI

struct TreeKnownHistorySection: View {
    @Binding var text: String
    var isEditing: Bool
    var showsCardChrome: Bool = true

    var body: some View {
        Group {
            if showsCardChrome {
                DetailCard(title: "Known History") { bodyContent }
            } else {
                bodyContent
            }
        }
    }

    @ViewBuilder
    private var bodyContent: some View {
        if isEditing {
            TextEditor(text: $text)
                .font(FaloCardTypography.fieldValue)
                .frame(minHeight: 100, maxHeight: .infinity, alignment: .topLeading)
                .padding(FaloSpacing.small)
                .background {
                    RoundedRectangle(cornerRadius: FaloRadius.small, style: .continuous)
                        .strokeBorder(Color.primary.opacity(0.08), lineWidth: 1)
                }
                .accessibilityLabel("Known History")

            Text("Summary of what you know before this tree entered your care. Use Add Journal for dated notes.")
                .font(FaloTypography.caption)
                .foregroundStyle(.secondary)
        } else if isEmpty {
            Text(FaloDisplayValue.empty)
                .font(FaloCardTypography.fieldValue)
                .foregroundStyle(.secondary)
        } else {
            Text(text)
                .font(FaloCardTypography.fieldValue)
                .foregroundStyle(.primary)
                .frame(maxWidth: .infinity, alignment: .topLeading)
                .textSelection(.enabled)
        }
    }

    private var isEmpty: Bool {
        text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
