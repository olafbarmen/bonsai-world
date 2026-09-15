//
//  DashboardHeaderView.swift
//  Bonsai World
//
//  Greeting + live weather/date. Name from User Profile — never placeholder copy.
//

import SwiftUI

struct DashboardHeaderView: View {
    @Environment(UserProfileStore.self) private var profile
    @Environment(WeatherService.self) private var weatherService
    @Environment(AppSettings.self) private var appSettings

    var body: some View {
        HStack(alignment: .center, spacing: FaloSpacing.large) {
            VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
                Text(greetingLine)
                    .font(FaloTypography.greeting)
                    .foregroundStyle(BonsaiWorldColors.textPrimary)
                    .accessibilityAddTraits(.isHeader)

                Text("Here is what is happening in your collection today.")
                    .font(FaloTypography.pageSubtitle)
                    .foregroundStyle(BonsaiWorldColors.textSecondary)
            }

            Spacer(minLength: FaloSpacing.medium)

            weatherAndDate
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .task {
            await weatherService.refreshIfNeeded()
        }
    }

    private var greetingLine: String {
        let trimmed = profile.name.trimmingCharacters(in: .whitespacesAndNewlines)
        let first = trimmed.split(separator: " ").first.map(String.init)
        if let first, !first.isEmpty {
            return "\(greetingWord), \(first)"
        }
        return greetingWord
    }

    private var greetingWord: String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12: return "Good morning"
        case 12..<18: return "Good afternoon"
        default: return "Good evening"
        }
    }

    private var weatherAndDate: some View {
        VStack(alignment: .trailing, spacing: 2) {
            if let snapshot = weatherService.snapshot {
                HStack(spacing: FaloSpacing.small) {
                    Image(systemName: snapshot.current.condition.systemImageName)
                        .font(.system(size: HeaderWeatherScale.icon, weight: .medium))
                        .symbolRenderingMode(.hierarchical)
                        .foregroundStyle(BonsaiWorldColors.accent)
                        .accessibilityHidden(true)
                    Text(appSettings.temperatureUnit.formatted(celsius: snapshot.current.temperatureCelsius))
                        .font(HeaderWeatherScale.temperature)
                        .foregroundStyle(BonsaiWorldColors.textPrimary)
                        .monospacedDigit()
                    Text(conditionTitle(snapshot.current.condition))
                        .font(HeaderWeatherScale.condition)
                        .foregroundStyle(BonsaiWorldColors.textSecondary)
                }
                .accessibilityElement(children: .combine)
            }

            Text(Date.now.formatted(.dateTime.weekday(.wide).day().month(.wide).year()))
                .font(HeaderWeatherScale.date)
                .foregroundStyle(BonsaiWorldColors.textSecondary)
        }
    }

    private func conditionTitle(_ condition: WeatherSkyCondition) -> String {
        switch condition {
        case .clearSky: "Clear"
        case .mainlyClear: "Mainly clear"
        case .partlyCloudy: "Partly cloudy"
        case .overcast: "Overcast"
        case .fog: "Fog"
        case .drizzle, .freezingDrizzle: "Drizzle"
        case .rain: "Rain"
        case .freezingRain: "Freezing rain"
        case .rainShowers: "Showers"
        case .snow, .snowShowers: "Snow"
        case .thunderstorm: "Thunderstorm"
        }
    }
}

/// Compact header weather — modestly larger than row/caption defaults; not a card.
private enum HeaderWeatherScale {
    static let icon: CGFloat = 21
    static let temperature: Font = .system(size: 17, weight: .semibold, design: .default)
    static let condition: Font = .system(size: 12, weight: .regular, design: .default)
    static let date: Font = .system(size: 11, weight: .regular, design: .default)
}
