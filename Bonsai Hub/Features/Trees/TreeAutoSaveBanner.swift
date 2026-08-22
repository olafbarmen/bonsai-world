//
//  TreeAutoSaveBanner.swift
//  Bonsai World
//
//  Quiet auto-save status for Tree Detail (Saving… / Saved / error).
//

import SwiftUI

struct TreeAutoSaveBanner: View {
    let status: TreeAutoSaveStatus

    var body: some View {
        Group {
            switch status {
            case .idle:
                EmptyView()
            case .saving:
                label("Saving…", systemImage: "arrow.triangle.2.circlepath", tint: .secondary)
            case .saved:
                label("Saved", systemImage: "checkmark.circle", tint: .secondary)
            case .failed:
                label("Unable to save changes", systemImage: "exclamationmark.triangle.fill", tint: .orange)
            }
        }
        .animation(.easeInOut(duration: 0.2), value: status)
        .accessibilityElement(children: .combine)
    }

    private func label(_ title: String, systemImage: String, tint: Color) -> some View {
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
