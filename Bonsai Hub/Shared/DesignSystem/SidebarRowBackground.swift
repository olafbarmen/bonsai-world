//
//  SidebarRowBackground.swift
//  Bonsai World
//
//  Organic list selection / hover — replaces cold system gray / blue highlights.
//  Use sidebar base in the nav column; canvas base in content lists.
//

import SwiftUI

struct SidebarRowBackground: View {
    var isSelected: Bool
    /// Opaque underlay so residual system highlight cannot show through.
    var baseFill: Color = BonsaiWorldColors.sidebar
    @State private var isHovered = false

    var body: some View {
        ZStack {
            baseFill

            RoundedRectangle(cornerRadius: FaloRadius.small, style: .continuous)
                .fill(fillColor)
                .overlay {
                    if isSelected {
                        RoundedRectangle(cornerRadius: FaloRadius.small, style: .continuous)
                            .strokeBorder(BonsaiWorldColors.navigationFocusRing.opacity(0.55), lineWidth: 1)
                    }
                }
                .padding(.horizontal, 2)
                .padding(.vertical, 1)
        }
        .onHover { hovering in
            isHovered = hovering
        }
    }

    private var fillColor: Color {
        if isSelected {
            return BonsaiWorldColors.sidebarSelection
        }
        if isHovered {
            return BonsaiWorldColors.sidebarHover
        }
        return .clear
    }
}
