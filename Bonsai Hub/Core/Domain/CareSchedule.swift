//
//  CareSchedule.swift
//  Bonsai World
//
//  Tasks domain — recurring care rules. Any Task can repeat at a chosen
//  cadence (daily watering, weekly liquid fertilizer, monthly slow-release
//  fertilizer, every-3-years repotting, annual winter work, …), optionally
//  restricted to a season (e.g. no fertilizing before August). A schedule
//  already bakes in every detail (Work Type, fertilizer, interval), so
//  completing one of its due occurrences never needs a form — see
//  ``TaskService/completeScheduleOccurrence(scheduleID:treeID:)``.
//
//  Due occurrences are computed on demand from the last matching WorkRecord
//  per (schedule, tree) — no daily/background generation job, no persisted
//  "instance" rows. See ``TaskService/pendingOccurrences(due:)``.
//

import Foundation

enum CareRecurrenceUnit: String, Codable, Sendable, CaseIterable, Identifiable {
    case day
    case week
    case month
    case year

    var id: Self { self }

    var calendarComponent: Calendar.Component {
        switch self {
        case .day: .day
        case .week: .weekOfYear
        case .month: .month
        case .year: .year
        }
    }

    /// Singular display name, e.g. "Day".
    var singular: String {
        switch self {
        case .day: "Day"
        case .week: "Week"
        case .month: "Month"
        case .year: "Year"
        }
    }

    /// Plural display name, e.g. "Days".
    var plural: String {
        switch self {
        case .day: "Days"
        case .week: "Weeks"
        case .month: "Months"
        case .year: "Years"
        }
    }
}

/// A time-of-day slot for care that happens more than once a day (e.g.
/// watering morning, midday, afternoon, and evening). Occurrences are tracked
/// by how many matching WorkRecords already exist today — not by clock time —
/// so watering "out of order" or slightly early/late still counts correctly.
enum CareDayPart: String, Codable, Sendable, CaseIterable, Identifiable, Comparable {
    case morning
    case midday
    case afternoon
    case evening

    var id: Self { self }

    var title: String {
        switch self {
        case .morning: "Morning"
        case .midday: "Midday"
        case .afternoon: "Afternoon"
        case .evening: "Evening"
        }
    }

    /// Representative hour (24h), used only to place a computed occurrence's
    /// due time within the day for sorting/display.
    var referenceHour: Int {
        switch self {
        case .morning: 7
        case .midday: 11
        case .afternoon: 15
        case .evening: 19
        }
    }

    static func < (lhs: Self, rhs: Self) -> Bool { lhs.referenceHour < rhs.referenceHour }
}

/// Either "every N days/weeks/months/years" (`dayParts` empty), or "N times a
/// day at these times" (`dayParts` non-empty — `unit`/`interval` are ignored).
struct CareRecurrenceRule: Codable, Hashable, Sendable {
    var unit: CareRecurrenceUnit
    /// Every `interval` `unit`s. Minimum 1. Ignored when `dayParts` is non-empty.
    var interval: Int
    /// When non-empty, this schedule recurs multiple times a day at these
    /// times instead of on the `unit`/`interval` cadence.
    var dayParts: Set<CareDayPart>

    init(unit: CareRecurrenceUnit, interval: Int, dayParts: Set<CareDayPart> = []) {
        self.unit = unit
        self.interval = max(1, interval)
        self.dayParts = dayParts
    }

    /// Human-readable summary, e.g. "Every day", "Every 3 years", "3x/day — Morning, Midday, Evening".
    var summary: String {
        guard dayParts.isEmpty else {
            let parts = dayParts.sorted().map(\.title).joined(separator: ", ")
            return "\(dayParts.count)x/day — \(parts)"
        }
        return interval == 1 ? "Every \(unit.singular.lowercased())" : "Every \(interval) \(unit.plural.lowercased())"
    }
}

/// Restricts a schedule to an active month range (inclusive), wrapping across
/// the year boundary when `fromMonth > toMonth` (e.g. Nov–Feb). Outside the
/// window no occurrence is due at all — no manual pausing/resuming needed
/// season to season.
struct CareScheduleSeasonalWindow: Codable, Hashable, Sendable {
    /// 1 = January … 12 = December.
    var fromMonth: Int
    var toMonth: Int

    func contains(month: Int) -> Bool {
        if fromMonth <= toMonth {
            return (fromMonth...toMonth).contains(month)
        } else {
            return month >= fromMonth || month <= toMonth
        }
    }

    var summary: String {
        "\(Self.monthName(fromMonth))–\(Self.monthName(toMonth))"
    }

    static func monthName(_ month: Int) -> String {
        let symbols = DateFormatter().shortMonthSymbols ?? []
        guard month >= 1, month <= symbols.count else { return "" }
        return symbols[month - 1]
    }

    static let allMonths: [Int] = Array(1...12)
}

/// Which Trees a Schedule applies to. `.location` and `.genus` are dynamic —
/// resolved to "whichever Trees currently match" each time due occurrences
/// are computed (see `TaskService.resolvedTreeIDs(for:)`), so a Tree moved
/// into a watered Location, or newly added to a watered Genus, is covered
/// automatically without editing the schedule.
enum CareScheduleTarget: Codable, Hashable, Sendable {
    case trees(Set<UUID>)
    case location(UUID)
    case genus(UUID)
}

/// A recurring care rule for one or more Trees. Every detail (Work Type,
/// fertilizer, cadence) is decided once when the schedule is created, so its
/// due occurrences always complete in a single action.
struct CareSchedule: Identifiable, Hashable, Sendable {
    var id: UUID
    var title: String
    /// Reference Data — Work Type.
    var workTypeID: UUID
    /// Fixes which fertilizer product this schedule uses, when relevant —
    /// lets "slow-release monthly" and "liquid weekly" track independently
    /// even on the same Tree.
    var fertilizerTypeID: UUID?
    /// Which Tree(s) this schedule applies to. Due occurrences are computed
    /// per resolved tree — each tracks its own last-done date independently.
    var target: CareScheduleTarget
    var recurrence: CareRecurrenceRule
    var seasonalWindow: CareScheduleSeasonalWindow?
    var notes: String
    var isActive: Bool

    var createdDate: Date
    var modifiedDate: Date

    init(
        id: UUID = UUID(),
        title: String,
        workTypeID: UUID,
        fertilizerTypeID: UUID? = nil,
        target: CareScheduleTarget,
        recurrence: CareRecurrenceRule,
        seasonalWindow: CareScheduleSeasonalWindow? = nil,
        notes: String = "",
        isActive: Bool = true,
        createdDate: Date = .now,
        modifiedDate: Date = .now
    ) {
        self.id = id
        self.title = title
        self.workTypeID = workTypeID
        self.fertilizerTypeID = fertilizerTypeID
        self.target = target
        self.recurrence = recurrence
        self.seasonalWindow = seasonalWindow
        self.notes = notes
        self.isActive = isActive
        self.createdDate = createdDate
        self.modifiedDate = modifiedDate
    }
}

// MARK: - Codable (tolerant of the pre-target `treeIDs` shape)

extension CareSchedule: Codable {
    private enum CodingKeys: String, CodingKey {
        case id, title, workTypeID, fertilizerTypeID, target, treeIDs
        case recurrence, seasonalWindow, notes, isActive, createdDate, modifiedDate
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        workTypeID = try container.decode(UUID.self, forKey: .workTypeID)
        fertilizerTypeID = try container.decodeIfPresent(UUID.self, forKey: .fertilizerTypeID)

        if let decodedTarget = try container.decodeIfPresent(CareScheduleTarget.self, forKey: .target) {
            target = decodedTarget
        } else {
            // Pre-target schedules stored a flat `treeIDs` array — treat that as an explicit Trees target.
            let legacyTreeIDs = try container.decodeIfPresent([UUID].self, forKey: .treeIDs) ?? []
            target = .trees(Set(legacyTreeIDs))
        }

        recurrence = try container.decode(CareRecurrenceRule.self, forKey: .recurrence)
        seasonalWindow = try container.decodeIfPresent(CareScheduleSeasonalWindow.self, forKey: .seasonalWindow)
        notes = try container.decode(String.self, forKey: .notes)
        isActive = try container.decode(Bool.self, forKey: .isActive)
        createdDate = try container.decode(Date.self, forKey: .createdDate)
        modifiedDate = try container.decode(Date.self, forKey: .modifiedDate)
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(workTypeID, forKey: .workTypeID)
        try container.encodeIfPresent(fertilizerTypeID, forKey: .fertilizerTypeID)
        try container.encode(target, forKey: .target)
        try container.encode(recurrence, forKey: .recurrence)
        try container.encodeIfPresent(seasonalWindow, forKey: .seasonalWindow)
        try container.encode(notes, forKey: .notes)
        try container.encode(isActive, forKey: .isActive)
        try container.encode(createdDate, forKey: .createdDate)
        try container.encode(modifiedDate, forKey: .modifiedDate)
    }
}
