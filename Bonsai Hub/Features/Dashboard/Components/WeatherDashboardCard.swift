//
//  WeatherDashboardCard.swift
//  Bonsai World
//
//  Dashboard Weather card — compact Bonsai decision support (placeholder data).
//  Visual refinement: tight table, status dots, elevated chrome.
//

import SwiftUI

struct WeatherDashboardCard: View {
    /// Future: selected Garden drives weather. Placeholder only — no selection UI logic.
    var gardenName: String = DashboardPlaceholderData.weatherGardenName

    private var hoverInfo: DashboardHoverInfo {
        DashboardPlaceholderData.hoverInfo(for: .weather)
    }

    private let labelColumnWidth: CGFloat = 64
    private let valueColumnWidth: CGFloat = 88

    var body: some View {
        VStack(alignment: .leading, spacing: DashboardSpacing.titleToContent) {
            header
            comparisonTable
            riskSection
            weekStrip
        }
        .padding(DashboardSpacing.cardPadding)
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .dashboardCardChrome()
        .help(hoverInfo.helpText)
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Weather, Garden \(gardenName)")
    }

    // MARK: - Header

    private var header: some View {
        HStack(alignment: .firstTextBaseline, spacing: FaloSpacing.small) {
            Text("Weather")
                .font(FaloTypography.headline)

            Spacer(minLength: FaloSpacing.xSmall)

            HStack(spacing: FaloSpacing.xSmall) {
                Text("Garden:")
                    .font(FaloTypography.caption)
                    .foregroundStyle(.secondary)
                Text(gardenName)
                    .font(FaloTypography.caption)
                Image(systemName: "chevron.up.chevron.down")
                    .font(.system(size: 9, weight: .semibold))
                    .foregroundStyle(.tertiary)
                    .accessibilityHidden(true)
            }
            .accessibilityElement(children: .combine)
            .accessibilityLabel("Garden \(gardenName)")
            .accessibilityHint("Garden selection will be available in a future version")
        }
    }

    // MARK: - Today / Tomorrow comparison

    private var comparisonTable: some View {
        let rows = DashboardPlaceholderData.weatherComparisonRows

        return Grid(alignment: .leading, horizontalSpacing: FaloSpacing.medium, verticalSpacing: 3) {
            GridRow {
                Color.clear
                    .frame(width: labelColumnWidth, height: 1)
                Text("Today")
                    .font(FaloTypography.caption)
                    .foregroundStyle(.secondary)
                    .frame(width: valueColumnWidth, alignment: .leading)
                Text("Tomorrow")
                    .font(FaloTypography.caption)
                    .foregroundStyle(.secondary)
                    .frame(width: valueColumnWidth, alignment: .leading)
            }

            ForEach(rows) { row in
                GridRow {
                    Text(row.label)
                        .font(FaloTypography.caption)
                        .foregroundStyle(.secondary)
                        .frame(width: labelColumnWidth, alignment: .leading)

                    parameterValue(row.todayValue, status: row.todayStatus)
                    parameterValue(row.tomorrowValue, status: row.tomorrowStatus)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func parameterValue(
        _ value: String,
        status: DashboardPlaceholderData.WeatherParameterStatusPlaceholder
    ) -> some View {
        HStack(spacing: 5) {
            Circle()
                .fill(status.color)
                .frame(width: 7, height: 7)
                .accessibilityHidden(true)
            Text(value)
                .font(FaloTypography.body)
                .monospacedDigit()
                .lineLimit(1)
        }
        .frame(width: valueColumnWidth, alignment: .leading)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(value)
    }

    // MARK: - Today's Bonsai Risks

    private var riskSection: some View {
        VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
            DashboardCardSectionLabel(title: "Today's Bonsai Risks")

            if DashboardPlaceholderData.todaysBonsaiRisks.isEmpty {
                Text(DashboardPlaceholderData.todaysBonsaiRisksEmptyMessage)
                    .font(FaloTypography.caption)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            } else {
                DashboardCardBulletList(items: DashboardPlaceholderData.todaysBonsaiRisks, compact: true)
            }

            DashboardCardNextAction(text: DashboardPlaceholderData.weatherNextAction)
        }
    }

    // MARK: - 7-day overview

    private var weekStrip: some View {
        HStack(spacing: 0) {
            ForEach(DashboardPlaceholderData.weatherWeek) { day in
                VStack(spacing: 1) {
                    Text(day.weekday)
                        .font(FaloTypography.caption)
                        .foregroundStyle(.secondary)
                    Image(systemName: day.systemImage)
                        .font(.system(size: 11, weight: .regular))
                        .symbolRenderingMode(.hierarchical)
                        .foregroundStyle(.secondary)
                        .frame(height: 13)
                    Text(day.temperature)
                        .font(FaloTypography.caption)
                        .monospacedDigit()
                }
                .frame(maxWidth: .infinity)
                .accessibilityElement(children: .combine)
                .accessibilityLabel("\(day.weekday), \(day.temperature)")
            }
        }
    }
}

#Preview {
    HStack(alignment: .top, spacing: 24) {
        TodaysCareDashboardCard(cockpitAligned: true)
        WeatherDashboardCard()
    }
    .padding()
    .frame(width: 960, height: 320)
}
