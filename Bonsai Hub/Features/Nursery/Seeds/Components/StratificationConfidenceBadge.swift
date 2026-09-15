//
//  StratificationConfidenceBadge.swift
//  Bonsai World
//
//  Reusable evidence-quality indicator for stratification recommendations.
//

import SwiftUI

struct StratificationConfidenceBadge: View {
    var level: StratificationConfidenceLevel
    var showsSummary: Bool = true

    var body: some View {
        VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
            Label(level.title, systemImage: level.systemImage)
                .font(FaloCardTypography.fieldValue)
                .foregroundStyle(.primary)

            if showsSummary {
                Text(level.summary)
                    .font(FaloTypography.caption)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .accessibilityElement(children: .combine)
    }
}

struct StratificationConfidenceLegend: View {
    var body: some View {
        VStack(alignment: .leading, spacing: FaloSpacing.medium) {
            ForEach(StratificationConfidenceLevel.allCases) { level in
                StratificationConfidenceBadge(level: level)
            }
        }
    }
}

#Preview {
    StratificationConfidenceLegend()
        .padding()
        .frame(width: 420)
}
