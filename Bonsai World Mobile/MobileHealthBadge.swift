//
//  MobileHealthBadge.swift
//  Bonsai World
//
//  Falo status treatment for TreeHealthStatus — same tint roles as Mac.
//

import SwiftUI

struct MobileHealthBadge: View {
    let status: TreeHealthStatus

    var body: some View {
        Text(status.title)
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
            .accessibilityLabel("Health \(status.title)")
    }

    private var tint: Color {
        switch status {
        case .needsAttention: BonsaiWorldColors.statusAttention
        case .recovering: BonsaiWorldColors.statusInformation
        case .thriving, .stable: BonsaiWorldColors.accent
        }
    }
}
