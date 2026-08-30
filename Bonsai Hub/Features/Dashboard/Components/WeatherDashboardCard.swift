//
//  WeatherDashboardCard.swift
//  Bonsai World
//
//  Dashboard Weather card — compact Bonsai decision support.
//  Live data via WeatherService (Open-Meteo) — refreshes automatically in the
//  background and whenever the app returns to the foreground.
//

import SwiftUI

struct WeatherDashboardCard: View {
    @Environment(WeatherService.self) private var weatherService
    @Environment(AppSettings.self) private var appSettings
    @Environment(\.scenePhase) private var scenePhase

    private var hoverInfo: DashboardHoverInfo {
        DashboardPlaceholderData.hoverInfo(for: .weather)
    }

    private let labelColumnWidth: CGFloat = 64
    private let valueColumnWidth: CGFloat = 88

    var body: some View {
        VStack(alignment: .leading, spacing: DashboardSpacing.titleToContent) {
            header

            switch weatherService.state {
            case .idle, .loading:
                loadingBody
            case .noGardenPosition:
                noGardenPositionBody
            case .failed(let message):
                errorBody(message)
            case .loaded:
                if let snapshot = weatherService.snapshot {
                    loadedBody(snapshot)
                } else {
                    loadingBody
                }
            }
        }
        .padding(DashboardSpacing.cardPadding)
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .dashboardCardChrome()
        .help(hoverInfo.helpText)
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Weather, Garden \(weatherService.gardenName)")
        .task {
            await weatherService.refreshIfNeeded()
        }
        .onChange(of: scenePhase) { _, newPhase in
            guard newPhase == .active else { return }
            Task { await weatherService.refreshIfNeeded() }
        }
    }

    // MARK: - Header

    private var header: some View {
        HStack(alignment: .top, spacing: FaloSpacing.small) {
            Text("Weather")
                .font(FaloTypography.headline)

            Spacer(minLength: FaloSpacing.xSmall)

            VStack(alignment: .trailing, spacing: 1) {
                HStack(spacing: FaloSpacing.xSmall) {
                    Text("Garden:")
                        .font(FaloTypography.caption)
                        .foregroundStyle(.secondary)
                    Text(weatherService.gardenName)
                        .font(FaloTypography.caption)
                    Image(systemName: "chevron.up.chevron.down")
                        .font(.system(size: 9, weight: .semibold))
                        .foregroundStyle(.tertiary)
                        .accessibilityHidden(true)
                }

                if let placeName = weatherService.gardenPlaceName {
                    Text(placeName)
                        .font(.system(size: 10))
                        .foregroundStyle(.tertiary)
                }
            }
            .accessibilityElement(children: .combine)
            .accessibilityLabel(
                weatherService.gardenPlaceName.map { "Garden \(weatherService.gardenName), \($0)" }
                    ?? "Garden \(weatherService.gardenName)"
            )
            .accessibilityHint("Garden selection will be available in a future version")
        }
    }

    // MARK: - States

    private var loadingBody: some View {
        HStack(spacing: FaloSpacing.small) {
            ProgressView()
                .controlSize(.small)
            Text("Fetching current weather…")
                .font(FaloTypography.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, minHeight: 120, alignment: .leading)
    }

    private var noGardenPositionBody: some View {
        VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
            Text("No Garden position set")
                .font(FaloTypography.body)
            Text("Place \(weatherService.gardenName) on the map in Locations to see live weather here.")
                .font(FaloTypography.caption)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, minHeight: 120, alignment: .topLeading)
    }

    private func errorBody(_ message: String) -> some View {
        VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
            Text("Weather unavailable")
                .font(FaloTypography.body)
            Text(message)
                .font(FaloTypography.caption)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, minHeight: 120, alignment: .topLeading)
    }

    @ViewBuilder
    private func loadedBody(_ snapshot: WeatherSnapshot) -> some View {
        comparisonTable(snapshot)
        riskSection(snapshot)
        weekStrip(snapshot)
    }

    // MARK: - Today / Tomorrow comparison

    private func comparisonTable(_ snapshot: WeatherSnapshot) -> some View {
        let rows = WeatherRiskAssessment.comparisonRows(
            for: snapshot,
            temperatureUnit: appSettings.temperatureUnit,
            measurementSystem: appSettings.measurementSystem
        )

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

                    parameterValue(row.todayValue, secondary: row.todaySecondaryValue, level: row.todayLevel)
                    parameterValue(row.tomorrowValue, secondary: row.tomorrowSecondaryValue, level: row.tomorrowLevel)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    /// `secondary` is the Low temperature — only the Temp row supplies it.
    private func parameterValue(_ value: String, secondary: String? = nil, level: WeatherRiskLevel) -> some View {
        HStack(spacing: 5) {
            Circle()
                .fill(level.color)
                .frame(width: 7, height: 7)
                .accessibilityHidden(true)
            HStack(spacing: 3) {
                Text(value)
                    .font(FaloTypography.body)
                    .monospacedDigit()
                    .lineLimit(1)
                if let secondary {
                    Text("/")
                        .font(FaloTypography.caption)
                        .foregroundStyle(.tertiary)
                    Text(secondary)
                        .font(FaloTypography.caption)
                        .foregroundStyle(.secondary)
                        .monospacedDigit()
                        .lineLimit(1)
                }
            }
        }
        .frame(width: valueColumnWidth, alignment: .leading)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(secondary.map { "High \(value), Low \($0)" } ?? value)
    }

    // MARK: - Today's Bonsai Risks

    private func riskSection(_ snapshot: WeatherSnapshot) -> some View {
        let risks = WeatherRiskAssessment.todaysRisks(for: snapshot)

        return VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
            DashboardCardSectionLabel(title: "Today's Bonsai Risks")

            if risks.isEmpty {
                Text(WeatherRiskAssessment.noRisksMessage)
                    .font(FaloTypography.caption)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            } else {
                DashboardCardBulletList(items: risks, compact: true)
            }

            DashboardCardNextAction(text: WeatherRiskAssessment.nextAction(for: snapshot))
        }
    }

    // MARK: - 7-day overview

    private func weekStrip(_ snapshot: WeatherSnapshot) -> some View {
        HStack(spacing: 0) {
            ForEach(snapshot.week) { day in
                let high = appSettings.temperatureUnit.formatted(celsius: day.maxTemperatureCelsius)
                let low = appSettings.temperatureUnit.formatted(celsius: day.minTemperatureCelsius)

                VStack(spacing: 1) {
                    Text(Self.weekdayFormatter.string(from: day.date))
                        .font(FaloTypography.caption)
                        .foregroundStyle(.secondary)
                    Image(systemName: day.condition.systemImageName)
                        .font(.system(size: 11, weight: .regular))
                        .symbolRenderingMode(.hierarchical)
                        .foregroundStyle(.secondary)
                        .frame(height: 13)
                    Text(high)
                        .font(FaloTypography.caption)
                        .monospacedDigit()
                    Text(low)
                        .font(.system(size: 9))
                        .monospacedDigit()
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity)
                .accessibilityElement(children: .combine)
                .accessibilityLabel(
                    "\(Self.weekdayFormatter.string(from: day.date)), High \(high), Low \(low)"
                )
            }
        }
    }

    private static let weekdayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE"
        return formatter
    }()
}

private extension WeatherRiskLevel {
    var color: Color {
        switch self {
        case .normal: Color.green
        case .watch: Color.yellow
        case .caution: Color.orange
        case .critical: Color.red
        }
    }
}

#Preview {
    let profile = UserProfileStore()
    let weatherService = WeatherService(profile: profile)
    return WeatherDashboardCard()
        .environment(profile)
        .environment(weatherService)
        .environment(AppSettings())
        .padding()
        .frame(width: 460, height: 320)
}
