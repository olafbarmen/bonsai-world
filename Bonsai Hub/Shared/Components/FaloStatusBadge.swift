//
//  FaloStatusBadge.swift
//  Bonsai World
//
//  Status with text and a quiet tint — never colour alone.
//

import SwiftUI

struct FaloStatusBadge: View {
    let title: String
    var tint: Color

    var body: some View {
        Text(title)
            .font(FaloTypography.caption)
            .foregroundStyle(BonsaiWorldColors.textPrimary)
            .padding(.horizontal, FaloSpacing.small)
            .padding(.vertical, 3)
            .background {
                Capsule(style: .continuous)
                    .fill(BonsaiWorldColors.statusTintFill(tint))
            }
            .overlay {
                Capsule(style: .continuous)
                    .strokeBorder(BonsaiWorldColors.statusTintStroke(tint), lineWidth: 1)
            }
            .accessibilityLabel(title)
    }
}
