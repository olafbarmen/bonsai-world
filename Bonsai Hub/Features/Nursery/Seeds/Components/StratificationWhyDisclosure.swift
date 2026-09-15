//
//  StratificationWhyDisclosure.swift
//  Bonsai World
//
//  Progressive disclosure — simple summary first, Why? expands explanation.
//

import SwiftUI

struct StratificationWhyDisclosure: View {
    var summaryLines: [String]
    var whyTitle: String = "Why?"
    var whyBody: String
    @State private var isExpanded = false

    var body: some View {
        VStack(alignment: .leading, spacing: FaloSpacing.small) {
            ForEach(Array(summaryLines.enumerated()), id: \.offset) { _, line in
                Text(line)
                    .font(FaloCardTypography.fieldValue)
            }

            DisclosureGroup(whyTitle, isExpanded: $isExpanded) {
                Text(whyBody)
                    .font(FaloTypography.body)
                    .foregroundStyle(.secondary)
                    .padding(.top, FaloSpacing.xSmall)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .font(FaloTypography.caption.weight(.medium))
        }
    }
}

#Preview {
    StratificationWhyDisclosure(
        summaryLines: ["Cold moist stratification", "often ~1–5 °C", "species-dependent duration"],
        whyBody: "Educational context only until a species profile is attached."
    )
    .padding()
    .frame(width: 360)
}
