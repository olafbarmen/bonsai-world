//
//  DateTimeRegionalPreferences.swift
//  Bonsai World
//
//  Regional date / time / calendar preferences (display only).
//

import Foundation

enum AppDateFormat: String, CaseIterable, Codable, Identifiable, Hashable, Sendable {
    case dayMonthYear
    case monthDayYear
    case yearMonthDay

    var id: String { rawValue }

    var menuTitle: String {
        switch self {
        case .dayMonthYear: "DD/MM/YYYY"
        case .monthDayYear: "MM/DD/YYYY"
        case .yearMonthDay: "YYYY-MM-DD"
        }
    }
}

enum AppTimeFormat: String, CaseIterable, Codable, Identifiable, Hashable, Sendable {
    case twentyFourHour
    case twelveHour

    var id: String { rawValue }

    var menuTitle: String {
        switch self {
        case .twentyFourHour: "24-hour"
        case .twelveHour: "12-hour"
        }
    }
}

enum FirstDayOfWeek: String, CaseIterable, Codable, Identifiable, Hashable, Sendable {
    case monday
    case sunday
    case saturday

    var id: String { rawValue }

    var menuTitle: String {
        switch self {
        case .monday: "Monday"
        case .sunday: "Sunday"
        case .saturday: "Saturday"
        }
    }
}
