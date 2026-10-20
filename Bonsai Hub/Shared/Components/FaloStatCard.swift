//
//  FaloStatCard.swift
//  Bonsai World
//
//  Compact metric tile — live values only. Reusable beyond Dashboard.
//  Icon sits LEFT of content as a visual anchor (not above the metric).
//

import SwiftUI

struct FaloStatCard: View {
    let title: String
    let value: String
    var subtitle: String
    var systemImage: String
    var action: (() -> Void)?

    /// ~15% below ``FaloIconSize/metric`` / ``metricWell`` — StatStrip density only.
    private enum CompactMetric {
        static let icon: CGFloat = 41
        static let well: CGFloat = 61
        static let value: Font = .system(size: 24, weight: .semibold, design: .default)
        static let label: Font = .system(size: 11, weight: .medium, design: .default)
    }

    var body: some View {
        Group {
            if let action {
                Button(action: action) { content }
                    .buttonStyle(.plain)
            } else {
                content
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(title), \(value), \(subtitle)")
        .accessibilityAddTraits(action == nil ? [] : .isButton)
    }

    private var content: some View {
        HStack(alignment: .center, spacing: FaloSpacing.medium) {
            Image(systemName: systemImage)
                .font(.system(size: CompactMetric.icon, weight: .medium))
                .symbolRenderingMode(.hierarchical)
                .foregroundStyle(BonsaiWorldColors.accent)
                .frame(width: CompactMetric.well, height: CompactMetric.well)
                .background {
                    RoundedRectangle(cornerRadius: FaloRadius.small, style: .continuous)
                        .fill(BonsaiWorldColors.accentSubtle)
                }
                .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
                Text(value)
                    .font(CompactMetric.value)
                    .foregroundStyle(BonsaiWorldColors.textPrimary)
                    .monospacedDigit()
                    .minimumScaleFactor(0.7)
                    .lineLimit(1)

                Text(title)
                    .font(CompactMetric.label)
                    .foregroundStyle(BonsaiWorldColors.textPrimary)
                    .lineLimit(1)

                Text(subtitle)
                    .font(FaloTypography.caption)
                    .foregroundStyle(BonsaiWorldColors.textSecondary)
                    .lineLimit(1)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.horizontal, FaloSpacing.large)
        .padding(.vertical, FaloSpacing.medium)
        .frame(maxWidth: .infinity, alignment: .leading)
        .faloRaisedSurface(fillOpacity: 0.55)
    }
}
