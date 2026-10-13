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
    private static let winterCareReminderMonthKey = "falo.appSettings.winterCareReminderMonth"
    private static let winterCareReminderDayKey = "falo.appSettings.winterCareReminderDay"
    private static let winterCareFrostCelsiusKey = "falo.appSettings.winterCareFrostCelsius"
    private static let springCareReminderMonthKey = "falo.appSettings.springCareReminderMonth"
    private static let springCareReminderDayKey = "falo.appSettings.springCareReminderDay"
    private static let greenhouseSpringReminderMonthKey = "falo.appSettings.greenhouseSpringReminderMonth"
    private static let greenhouseSpringReminderDayKey = "falo.appSettings.greenhouseSpringReminderDay"

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

    /// Calendar month (1…12) when Winter Care reminders may start — default October.
    var winterCareReminderMonth: Int {
        didSet {
            let clamped = min(12, max(1, winterCareReminderMonth))
            if clamped != winterCareReminderMonth {
                winterCareReminderMonth = clamped
                return
            }
            guard winterCareReminderMonth != oldValue else { return }
            UserDefaults.standard.set(winterCareReminderMonth, forKey: Self.winterCareReminderMonthKey)
        }
    }

    /// Day of month for Winter Care reminder start — default 15.
    var winterCareReminderDay: Int {
        didSet {
            let clamped = min(28, max(1, winterCareReminderDay))
            if clamped != winterCareReminderDay {
                winterCareReminderDay = clamped
                return
            }
            guard winterCareReminderDay != oldValue else { return }
            UserDefaults.standard.set(winterCareReminderDay, forKey: Self.winterCareReminderDayKey)
        }
    }

    /// Night low at or below this (°C) also activates Winter Care (seasonal trees on summer placement).
    var winterCareFrostCelsius: Double {
        didSet {
            guard winterCareFrostCelsius != oldValue else { return }
            UserDefaults.standard.set(winterCareFrostCelsius, forKey: Self.winterCareFrostCelsiusKey)
        }
    }

    /// Calendar month (1…12) when Spring Care reminders may start — default April.
    var springCareReminderMonth: Int {
        didSet {
            let clamped = min(12, max(1, springCareReminderMonth))
            if clamped != springCareReminderMonth {
                springCareReminderMonth = clamped
                return
            }
            guard springCareReminderMonth != oldValue else { return }
            UserDefaults.standard.set(springCareReminderMonth, forKey: Self.springCareReminderMonthKey)
        }
    }

    /// Day of month for Spring Care reminder start — default 15.
    var springCareReminderDay: Int {
        didSet {
            let clamped = min(28, max(1, springCareReminderDay))
            if clamped != springCareReminderDay {
                springCareReminderDay = clamped
                return
            }
            guard springCareReminderDay != oldValue else { return }
            UserDefaults.standard.set(springCareReminderDay, forKey: Self.springCareReminderDayKey)
        }
    }

    /// Calendar month (1…12) when greenhouse spring heat / vent check starts — default April.
    var greenhouseSpringReminderMonth: Int {
        didSet {
            let clamped = min(12, max(1, greenhouseSpringReminderMonth))
            if clamped != greenhouseSpringReminderMonth {
                greenhouseSpringReminderMonth = clamped
                return
            }
            guard greenhouseSpringReminderMonth != oldValue else { return }
            UserDefaults.standard.set(greenhouseSpringReminderMonth, forKey: Self.greenhouseSpringReminderMonthKey)
        }
    }

    /// Day of month for greenhouse spring check — default 1.
    var greenhouseSpringReminderDay: Int {
        didSet {
            let clamped = min(28, max(1, greenhouseSpringReminderDay))
            if clamped != greenhouseSpringReminderDay {
                greenhouseSpringReminderDay = clamped
                return
            }
            guard greenhouseSpringReminderDay != oldValue else { return }
            UserDefaults.standard.set(greenhouseSpringReminderDay, forKey: Self.greenhouseSpringReminderDayKey)
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
        experienceEdition: ExperienceEdition? = nil,
        winterCareReminderMonth: Int? = nil,
        winterCareReminderDay: Int? = nil,
        winterCareFrostCelsius: Double? = nil,
        springCareReminderMonth: Int? = nil,
        springCareReminderDay: Int? = nil,
        greenhouseSpringReminderMonth: Int? = nil,
        greenhouseSpringReminderDay: Int? = nil
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
        if let winterCareReminderMonth {
            self.winterCareReminderMonth = min(12, max(1, winterCareReminderMonth))
        } else {
            let stored = UserDefaults.standard.object(forKey: Self.winterCareReminderMonthKey) as? Int
            self.winterCareReminderMonth = min(12, max(1, stored ?? 10))
        }
        if let winterCareReminderDay {
            self.winterCareReminderDay = min(28, max(1, winterCareReminderDay))
        } else {
            let stored = UserDefaults.standard.object(forKey: Self.winterCareReminderDayKey) as? Int
            self.winterCareReminderDay = min(28, max(1, stored ?? 15))
        }
        if let winterCareFrostCelsius {
            self.winterCareFrostCelsius = winterCareFrostCelsius
        } else if UserDefaults.standard.object(forKey: Self.winterCareFrostCelsiusKey) != nil {
            self.winterCareFrostCelsius = UserDefaults.standard.double(forKey: Self.winterCareFrostCelsiusKey)
        } else {
            self.winterCareFrostCelsius = 2
        }
        if let springCareReminderMonth {
            self.springCareReminderMonth = min(12, max(1, springCareReminderMonth))
        } else {
            let stored = UserDefaults.standard.object(forKey: Self.springCareReminderMonthKey) as? Int
            self.springCareReminderMonth = min(12, max(1, stored ?? 4))
        }
        if let springCareReminderDay {
            self.springCareReminderDay = min(28, max(1, springCareReminderDay))
        } else {
            let stored = UserDefaults.standard.object(forKey: Self.springCareReminderDayKey) as? Int
            self.springCareReminderDay = min(28, max(1, stored ?? 15))
        }
        if let greenhouseSpringReminderMonth {
            self.greenhouseSpringReminderMonth = min(12, max(1, greenhouseSpringReminderMonth))
        } else {
            let stored = UserDefaults.standard.object(forKey: Self.greenhouseSpringReminderMonthKey) as? Int
            self.greenhouseSpringReminderMonth = min(12, max(1, stored ?? 4))
        }
        if let greenhouseSpringReminderDay {
            self.greenhouseSpringReminderDay = min(28, max(1, greenhouseSpringReminderDay))
        } else {
            let stored = UserDefaults.standard.object(forKey: Self.greenhouseSpringReminderDayKey) as? Int
            self.greenhouseSpringReminderDay = min(28, max(1, stored ?? 1))
        }
        BonsaiWorldColors.apply(self.theme)
        ExperienceEditionStore.apply(self.experienceEdition)
    }
}
