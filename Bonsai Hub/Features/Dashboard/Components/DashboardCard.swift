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
    /// When set, replaces ``DashboardCardID/title``.
    var titleOverride: String? = nil
    var showsHeader: Bool = true
    @ViewBuilder var content: () -> Content

    var onActivate: (() -> Void)?

    private var hoverInfo: DashboardHoverInfo {
        DashboardPlaceholderData.hoverInfo(for: id)
    }

    private var resolvedTitle: String { titleOverride ?? id.title }

    var body: some View {
        VStack(alignment: .leading, spacing: DashboardSpacing.titleToContent) {
            if showsHeader {
                header
            }

            VStack(alignment: .leading, spacing: compact ? FaloSpacing.xSmall : FaloSpacing.small) {
                content()
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            if fillsRowHeight {
                Spacer(minLength: 0)
            }
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
        .accessibilityLabel(resolvedTitle)
        .accessibilityValue(hoverInfo.lines.joined(separator: ", "))
        .accessibilityAddTraits(onActivate == nil ? [] : .isButton)
    }

    private var header: some View {
        Text(resolvedTitle)
            .font(FaloTypography.sectionHeading)
            .foregroundStyle(BonsaiWorldColors.textPrimary)
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
                    .font(.system(size: compact ? FaloIconSize.row : FaloIconSize.informational, weight: .medium))
                    .symbolRenderingMode(.hierarchical)
                    .foregroundStyle(BonsaiWorldColors.accent)
                    .frame(width: compact ? 22 : 24, alignment: .center)
                    .accessibilityHidden(true)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(isEmphasized ? FaloTypography.sectionHeading : FaloTypography.body)
                    .foregroundStyle(BonsaiWorldColors.textPrimary)
                if let detail {
                    Text(detail)
                        .font(FaloTypography.caption)
                        .foregroundStyle(BonsaiWorldColors.textSecondary)
                }
            }

            Spacer(minLength: compact ? FaloSpacing.small : FaloSpacing.medium)

            if let value {
                Text(value)
                    .font(FaloTypography.sectionHeading)
                    .foregroundStyle(BonsaiWorldColors.textPrimary)
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
