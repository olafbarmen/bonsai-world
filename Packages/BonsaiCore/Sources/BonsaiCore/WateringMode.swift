//
//  WateringMode.swift
//  Bonsai World
//
//  Watering reminder / auto policy — owned by a Care-policy Collection,
//  optionally overridden on the Tree. Heat watch marks Care Watering on hot days.
//

import Foundation

enum WateringMode: String, Codable, CaseIterable, Identifiable, Hashable, Sendable {
    /// Include in Care → Watering Due and reminders.
    case remind
    /// Grower waters manually; no Due / reminder.
    case silent
    /// Covered by auto-watering; no Due / reminder.
    case auto

    var id: Self { self }

    var title: String {
        switch self {
        case .remind: "Remind"
        case .silent: "Silent"
        case .auto: "Auto-watered"
        }
    }

    var help: String {
        switch self {
        case .remind: "Show in Tasks and Care → Watering Due."
        case .silent: "No watering reminders — you decide when to water."
        case .auto: "Covered by auto-watering; not listed as due."
        }
    }

    /// Auto-watering frequency is stored as 1…3 times per day.
    static func clampedTimes(_ value: Int) -> Int {
        min(3, max(1, value))
    }
}
