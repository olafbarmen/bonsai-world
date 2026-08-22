//
//  DetailSectionHeader.swift
//  Bonsai World
//
//  Card section marker — Falo Card Typography Standard v1.
//

import SwiftUI

struct DetailSectionHeader: View {
    let title: String

    var body: some View {
        Text(title)
            .font(FaloCardTypography.sectionTitle)
            .foregroundStyle(.secondary)
            .textCase(.uppercase)
            .tracking(FaloCardTypography.sectionTitleTracking)
            .lineLimit(1)
            .truncationMode(.tail)
            .frame(maxWidth: .infinity, alignment: .leading)
            .accessibilityAddTraits(.isHeader)
    }
}
