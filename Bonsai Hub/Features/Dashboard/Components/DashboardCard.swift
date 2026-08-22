//
//  DashboardCard.swift
//  Bonsai World
//
//  Dashboard card chrome — shared padding, title spacing, and elevation.
//

import SwiftUI

struct DashboardCard<Content: View>: View {
    let id: DashboardCardID
    var prominence: DashboardCardProminence = .secondary
    /// When true, card fills sibling row height (equal row tops/bottoms).
    var fillsRowHeight: Bool = false
    /// Denser internal metric rows only — does not change outer padding.
    var compact: Bool = false
    @ViewBuilder var content: () -> Content

    var onActivate: (() -> Void)?

    private var hoverInfo: DashboardHoverInfo {
        DashboardPlaceholderData.hoverInfo(for: id)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: DashboardSpacing.titleToContent) {
            header

            VStack(alignment: .leading, spacing: compact ? FaloSpacing.xSmall : FaloSpacing.small) {
                content()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(DashboardSpacing.cardPadding)
        .frame(
            maxWidth: .infinity,
            maxHeight: fillsRowHeight ? .infinity : nil,
            alignment: .topLeading
        )
        .dashboardCardChrome()
        .contentShape(RoundedRectangle(cornerRadius: DashboardCardSurface.cornerRadius, style: .continuous))
        .help(hoverInfo.helpText)
        .accessibilityElement(children: .contain)
        .accessibilityLabel(id.title)
        .accessibilityValue(hoverInfo.lines.joined(separator: ", "))
        .accessibilityAddTraits(onActivate == nil ? [] : .isButton)
    }

    private var header: some View {
        Text(id.title)
            .font(FaloTypography.headline)
            .foregroundStyle(.primary)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

/// Calm labeled row — value on the trailing edge.
struct DashboardMetricRow: View {
    let title: String
    var value: String? = nil
    var detail: String? = nil
    var systemImage: String? = nil
    var isEmphasized: Bool = false
    var compact: Bool = false

    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: compact ? FaloSpacing.small : FaloSpacing.medium) {
            if let systemImage {
                Image(systemName: systemImage)
                    .font(.system(size: compact ? 12 : 13, weight: .regular))
                    .foregroundStyle(.tertiary)
                    .frame(width: compact ? 16 : 20, alignment: .center)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(isEmphasized ? FaloTypography.headline : FaloTypography.body)
                if let detail {
                    Text(detail)
                        .font(FaloTypography.caption)
                        .foregroundStyle(.secondary)
                }
            }

            Spacer(minLength: compact ? FaloSpacing.small : FaloSpacing.medium)

            if let value {
                Text(value)
                    .font(FaloTypography.headline)
                    .foregroundStyle(.primary)
                    .monospacedDigit()
            }
        }
        .padding(.vertical, compact ? 2 : FaloSpacing.small)
    }
}

/// Quiet summary line: "150 Trees" style.
struct DashboardSummaryRow: View {
    let value: String
    let label: String

    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: FaloSpacing.small) {
            Text(value)
                .font(FaloTypography.headline)
                .monospacedDigit()
                .frame(minWidth: 36, alignment: .trailing)
            Text(label)
                .font(FaloTypography.body)
                .foregroundStyle(.secondary)
            Spacer(minLength: 0)
        }
        .padding(.vertical, FaloSpacing.small)
    }
}
