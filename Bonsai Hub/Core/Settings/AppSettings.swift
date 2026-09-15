//
//  AppSettings.swift
//  Bonsai World
//
//  Regional / display preferences (including Appearance theme).
//  Gardens and addresses live in UserProfileStore — never here.
//

import Foundation
import Observation

/// Global regional preferences. Inject via `.environment`.
@Observable
@MainActor
final class AppSettings {
    private static let currencyKey = "falo.appSettings.currencyCode"
    private static let measurementSystemKey = "falo.appSettings.measurementSystem"
    private static let temperatureUnitKey = "falo.appSettings.temperatureUnit"
    private static let dateFormatKey = "falo.appSettings.dateFormat"
    private static let timeFormatKey = "falo.appSettings.timeFormat"
    private static let firstDayOfWeekKey = "falo.appSettings.firstDayOfWeek"
    private static let themeKey = "falo.appSettings.theme"
    private static let socialEnabledKey = "falo.appSettings.isSocialEnabled"
    private static let experienceEditionKey = "falo.appSettings.experienceEdition"

    var currency: AppCurrency {
        didSet {
            guard currency != oldValue else { return }
            UserDefaults.standard.set(currency.rawValue, forKey: Self.currencyKey)
        }
    }

    var measurementSystem: MeasurementSystem {
        didSet {
            guard measurementSystem != oldValue else { return }
            UserDefaults.standard.set(measurementSystem.rawValue, forKey: Self.measurementSystemKey)
        }
    }

    var temperatureUnit: TemperatureUnit {
        didSet {
            guard temperatureUnit != oldValue else { return }
            UserDefaults.standard.set(temperatureUnit.rawValue, forKey: Self.temperatureUnitKey)
        }
    }

    var dateFormat: AppDateFormat {
        didSet {
            guard dateFormat != oldValue else { return }
            UserDefaults.standard.set(dateFormat.rawValue, forKey: Self.dateFormatKey)
        }
    }

    var timeFormat: AppTimeFormat {
        didSet {
            guard timeFormat != oldValue else { return }
            UserDefaults.standard.set(timeFormat.rawValue, forKey: Self.timeFormatKey)
        }
    }

    var firstDayOfWeek: FirstDayOfWeek {
        didSet {
            guard firstDayOfWeek != oldValue else { return }
            UserDefaults.standard.set(firstDayOfWeek.rawValue, forKey: Self.firstDayOfWeekKey)
        }
    }

    /// Appearance theme — Light (default) or Dark (hybrid sidebar / canvas).
    var theme: AppTheme {
        didSet {
            guard theme != oldValue else { return }
            UserDefaults.standard.set(theme.rawValue, forKey: Self.themeKey)
            BonsaiWorldColors.apply(theme)
        }
    }

    /// When false, Trees are not offered for Social sharing (share levels are ignored).
    var isSocialEnabled: Bool {
        didSet {
            guard isSocialEnabled != oldValue else { return }
            UserDefaults.standard.set(isSocialEnabled, forKey: Self.socialEnabledKey)
        }
    }

    /// Need-based edition: Essentials / Practice / Complete (presentation only).
    var experienceEdition: ExperienceEdition {
        didSet {
            guard experienceEdition != oldValue else { return }
            UserDefaults.standard.set(experienceEdition.rawValue, forKey: Self.experienceEditionKey)
            ExperienceEditionStore.apply(experienceEdition)
        }
    }

    init(
        currency: AppCurrency? = nil,
        measurementSystem: MeasurementSystem? = nil,
        temperatureUnit: TemperatureUnit? = nil,
        dateFormat: AppDateFormat? = nil,
        timeFormat: AppTimeFormat? = nil,
        firstDayOfWeek: FirstDayOfWeek? = nil,
        theme: AppTheme? = nil,
        isSocialEnabled: Bool? = nil,
        experienceEdition: ExperienceEdition? = nil
    ) {
        self.currency = currency
            ?? UserDefaults.standard.string(forKey: Self.currencyKey).flatMap(AppCurrency.init)
            ?? .nok
        self.measurementSystem = measurementSystem
            ?? UserDefaults.standard.string(forKey: Self.measurementSystemKey).flatMap(MeasurementSystem.init)
            ?? .metric
        self.temperatureUnit = temperatureUnit
            ?? UserDefaults.standard.string(forKey: Self.temperatureUnitKey).flatMap(TemperatureUnit.init)
            ?? .celsius
        self.dateFormat = dateFormat
            ?? UserDefaults.standard.string(forKey: Self.dateFormatKey).flatMap(AppDateFormat.init)
            ?? .dayMonthYear
        self.timeFormat = timeFormat
            ?? UserDefaults.standard.string(forKey: Self.timeFormatKey).flatMap(AppTimeFormat.init)
            ?? .twentyFourHour
        self.firstDayOfWeek = firstDayOfWeek
            ?? UserDefaults.standard.string(forKey: Self.firstDayOfWeekKey).flatMap(FirstDayOfWeek.init)
            ?? .monday
        self.theme = theme
            ?? UserDefaults.standard.string(forKey: Self.themeKey).flatMap(AppTheme.init)
            ?? .light
        if let isSocialEnabled {
            self.isSocialEnabled = isSocialEnabled
        } else if UserDefaults.standard.object(forKey: Self.socialEnabledKey) != nil {
            self.isSocialEnabled = UserDefaults.standard.bool(forKey: Self.socialEnabledKey)
        } else {
            self.isSocialEnabled = false
        }
        self.experienceEdition = experienceEdition
            ?? UserDefaults.standard.string(forKey: Self.experienceEditionKey).flatMap(ExperienceEdition.init)
            ?? .complete
        BonsaiWorldColors.apply(self.theme)
        ExperienceEditionStore.apply(self.experienceEdition)
    }
}
