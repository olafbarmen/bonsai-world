//
//  DetailCard.swift
//  Bonsai World
//
//  Falo Detail section card — title + content with shared spacing.
//  Typography: Falo Card Typography Standard v1.
//  Height follows content only — never stretched to match siblings.
//

import SwiftUI

/// A titled section container for Detail pages.
struct DetailCard<Content: View>: View {
    let title: String
    @ViewBuilder var content: () -> Content

    var body: some View {
        VStack(alignment: .leading, spacing: FaloCardTypography.titleToContent) {
            DetailSectionHeader(title: title)

            VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
                content()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(FaloSpacing.medium)
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .background {
            // Level 1 — subtle surface separation (no shadow).
            RoundedRectangle(cornerRadius: FaloRadius.medium, style: .continuous)
                .fill(BonsaiWorldColors.surface)
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel(title)
    }
}

#Preview {
    DetailCard(title: "Identity") {
        DetailLabeledRow(label: "Name", value: "Dragon Maple")
        DetailLabeledRow(label: "Botanical Name", value: "Acer palmatum")
    }
    .padding()
    .frame(width: 420)
}
