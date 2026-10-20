//
//  TreeAutoSaveBanner.swift
//  Bonsai World
//
//  Quiet auto-save status for Tree Detail (Saving… / Saved / error).
//  Always reserves the same height so idle ↔ saving does not shift the page.
//

import SwiftUI

struct TreeAutoSaveBanner: View {
    let status: TreeAutoSaveStatus

    var body: some View {
        label(
            title: statusTitle,
            systemImage: statusSystemImage,
            tint: statusTint
        )
        .opacity(status == .idle ? 0 : 1)
        .accessibilityHidden(status == .idle)
        .animation(.easeInOut(duration: 0.2), value: status)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(status == .idle ? "" : statusTitle)
    }

    private var statusTitle: String {
        switch status {
        case .idle: "Saved"
        case .saving: "Saving…"
        case .saved: "Saved"
        case .failed: "Unable to save changes"
        }
    }

    private var statusSystemImage: String {
        switch status {
        case .idle, .saved: "checkmark.circle"
        case .saving: "arrow.triangle.2.circlepath"
        case .failed: "exclamationmark.triangle.fill"
        }
    }

    private var statusTint: Color {
        switch status {
        case .failed: BonsaiWorldColors.statusWarning
        default: .secondary
        }
    }

    private func label(title: String, systemImage: String, tint: Color) -> some View {
        HStack(spacing: FaloSpacing.small) {
            Image(systemName: systemImage)
                .font(.system(size: 12, weight: .semibold))
            Text(title)
                .font(FaloTypography.caption)
                .fontWeight(.medium)
        }
        .foregroundStyle(tint)
        .padding(.horizontal, FaloSpacing.xLarge)
        .padding(.vertical, FaloSpacing.small)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}
