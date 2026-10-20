//
//  SpeciesCareCalendar.swift
//  Bonsai World
//
//  When a species task may appear. The alert is the start of the work, a week
//  early. Too late is not offered: after the window, a pending task is retired
//  unless the grower has already postponed it past the end.
//

import Foundation

enum SpeciesCareJob: Hashable, Sendable {
    /// Finger-pinch on single-flush pines. Two-flush pines are not this job.
    case pineCandlePinch
    /// First two leaves on Acer palmatum as the shoot opens.
    case mapleShootPinch
    /// Scissors back into the pad. Not a tip pinch, and not a hard prune.
    case juniperRunnerCut

    var systemKind: CareTaskSystemKind {
        switch self {
        case .pineCandlePinch: .pineCandlePinch
        case .mapleShootPinch: .mapleShootPinch
        case .juniperRunnerCut: .juniperRunnerCut
        }
    }

    var workTypeID: UUID {
        switch self {
        case .pineCandlePinch, .mapleShootPinch:
            CanonicalWorkTypeID.pinching
        case .juniperRunnerCut:
            CanonicalWorkTypeID.branchPruning
        }
    }

    var title: String {
        switch self {
        case .pineCandlePinch: "Pinch candles"
        case .mapleShootPinch: "Pinch maple shoots"
        case .juniperRunnerCut: "Cut juniper runners"
        }
    }

    var notes: String {
        switch self {
        case .pineCandlePinch:
            "Single-flush pine. Pinch with the fingers when the candles have extended, strong zones first. Scissors brown the needle tips. Leave a weak tree, and leave a tree repotted this spring. Postpone if the candles are still tight. If they have already opened into needles, this year's pinch has passed."
        case .mapleShootPinch:
            "Refined Japanese maple: pinch the shoot back to the first two leaves as it opens. Leave the shoot on a tree that should still thicken. Postpone if the buds have not opened."
        case .juniperRunnerCut:
            "Cut shoots that have run back into the pad with scissors. Do not pinch every tip. Leave green on every branch you keep. Do not hard-prune a tree repotted this season. Postpone if the shoots have not run."
        }
    }

    /// Temperate month when this work can first be right. Pine stays closed in spring: candles are not cut then.
    var openingTemperateMonth: Int {
        switch self {
        case .pineCandlePinch: 5
        case .mapleShootPinch: 4
        case .juniperRunnerCut: 4
        }
    }

    /// Temperate month through which the work is still right.
    var closingTemperateMonth: Int {
        switch self {
        case .pineCandlePinch: 6
        case .mapleShootPinch: 6
        case .juniperRunnerCut: 8
        }
    }

    /// Species Library id wins. A botanical name is used only when the tree has no species id.
    static func job(speciesID: UUID?, cultivarID: UUID? = nil, botanicalName: String) -> SpeciesCareJob? {
        if speciesID != nil || cultivarID != nil {
            if let speciesID, Self.juniperIDs.contains(speciesID) { return .juniperRunnerCut }
            if let cultivarID, Self.juniperIDs.contains(cultivarID) { return .juniperRunnerCut }
            switch speciesID {
            case BotanicalKnowledgeIDs.acerPalmatum:
                return .mapleShootPinch
            case BotanicalKnowledgeIDs.pinusSylvestris,
                 BotanicalKnowledgeIDs.pinusMugo,
                 BotanicalKnowledgeIDs.pinusParviflora:
                return .pineCandlePinch
            default:
                return nil
            }
        }
        let name = botanicalName.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        if name.hasPrefix("juniperus") { return .juniperRunnerCut }
        if name.hasPrefix("acer palmatum") { return .mapleShootPinch }
        if name.hasPrefix("pinus sylvestris")
            || name.hasPrefix("pinus mugo")
            || name.hasPrefix("pinus parviflora") {
            return .pineCandlePinch
        }
        return nil
    }

    private static let juniperIDs: Set<UUID> = [
        BotanicalKnowledgeIDs.juniperusChinensis,
        BotanicalKnowledgeIDs.juniperusCommunis,
        BotanicalKnowledgeIDs.juniperusProcumbens,
        BotanicalKnowledgeIDs.juniperusRigida,
        BotanicalKnowledgeIDs.juniperusSabina,
        BotanicalKnowledgeIDs.juniperusSquamata,
        BotanicalKnowledgeIDs.juniperusChinensisBlaauw,
        BotanicalKnowledgeIDs.juniperusChinensisItoigawa,
        BotanicalKnowledgeIDs.juniperusChinensisKishu,
        BotanicalKnowledgeIDs.juniperusChinensisShimpaku,
        BotanicalKnowledgeIDs.juniperusChinensisStricta,
        BotanicalKnowledgeIDs.juniperusProcumbensGreenMound,
        BotanicalKnowledgeIDs.juniperusSquamataBlueStar
    ]
}

struct SpeciesCareWindow: Equatable, Sendable {
    /// First day the task may be due. Seven days before the phase opens.
    var alert: Date
    /// Last day the work is still the right ask.
    var close: Date
    /// Alert day of the following year. A due date in between belongs to this window.
    var nextAlert: Date

    func covers(_ due: Date, calendar: Calendar) -> Bool {
        let day = calendar.startOfDay(for: due)
        return day >= alert && day < nextAlert
    }
}

enum SpeciesCareAction: Equatable, Sendable {
    case none
    case create(due: Date)
    case retire
}

enum SpeciesCareCalendar {
    static let leadDays = 7

    static func localMonth(
        temperateMonth: Int,
        hemisphere: GardenHemisphere,
        season: GardenSeason
    ) -> Int {
        let northern = CareCalendarKnowledge.northernCenter(temperateMonth: temperateMonth, season: season)
        for month in 1...12 {
            if CareCalendarKnowledge.northernEquivalent(localMonth: month, hemisphere: hemisphere) == northern {
                return month
            }
        }
        return temperateMonth
    }

    static func window(
        job: SpeciesCareJob,
        hemisphere: GardenHemisphere,
        season: GardenSeason,
        year: Int,
        calendar: Calendar
    ) -> SpeciesCareWindow? {
        guard season != .tropical else { return nil }
        let openMonth = localMonth(
            temperateMonth: job.openingTemperateMonth,
            hemisphere: hemisphere,
            season: season
        )
        let closeMonth = localMonth(
            temperateMonth: job.closingTemperateMonth,
            hemisphere: hemisphere,
            season: season
        )
        let closeYear = closeMonth < openMonth ? year + 1 : year
        guard let open = startOfMonth(year: year, month: openMonth, calendar: calendar),
        let close = startOfLastDay(year: closeYear, month: closeMonth, calendar: calendar),
        let alert = calendar.date(byAdding: .day, value: -leadDays, to: open),
        let nextOpen = startOfMonth(
            year: year + 1,
            month: localMonth(
                temperateMonth: job.openingTemperateMonth,
                hemisphere: hemisphere,
                season: season
            ),
            calendar: calendar
        ),
        let nextAlert = calendar.date(byAdding: .day, value: -leadDays, to: nextOpen)
        else { return nil }
        return SpeciesCareWindow(
            alert: calendar.startOfDay(for: alert),
            close: calendar.startOfDay(for: close),
            nextAlert: calendar.startOfDay(for: nextAlert)
        )
    }

    /// The window that is open now, or the one that has just closed so a missed task can be retired.
    static func activeWindow(
        job: SpeciesCareJob,
        on now: Date,
        hemisphere: GardenHemisphere,
        season: GardenSeason,
        calendar: Calendar
    ) -> SpeciesCareWindow? {
        guard season != .tropical else { return nil }
        let year = calendar.component(.year, from: now)
        let today = calendar.startOfDay(for: now)
        let candidates = [year - 1, year].compactMap {
            window(job: job, hemisphere: hemisphere, season: season, year: $0, calendar: calendar)
        }
        if let live = candidates.first(where: { today >= $0.alert && today <= $0.close }) {
            return live
        }
        return candidates.filter { today > $0.close }.max { $0.close < $1.close }
    }

    /// A pending task past the window is retired, unless its due date was postponed past the end.
    static func action(
        now: Date,
        window: SpeciesCareWindow,
        pendingDue: Date?,
        covered: Bool,
        calendar: Calendar
    ) -> SpeciesCareAction {
        let today = calendar.startOfDay(for: now)
        if let pendingDue {
            let due = calendar.startOfDay(for: pendingDue)
            if today > window.close && due <= window.close { return .retire }
            return .none
        }
        if covered { return .none }
        guard today >= window.alert && today <= window.close else { return .none }
        return .create(due: today)
    }

    private static func startOfMonth(year: Int, month: Int, calendar: Calendar) -> Date? {
        calendar.date(from: DateComponents(year: year, month: month, day: 1)).map {
            calendar.startOfDay(for: $0)
        }
    }

    private static func startOfLastDay(year: Int, month: Int, calendar: Calendar) -> Date? {
        guard let start = startOfMonth(year: year, month: month, calendar: calendar),
              let next = calendar.date(byAdding: .month, value: 1, to: start),
              let last = calendar.date(byAdding: .day, value: -1, to: next)
        else { return nil }
        return calendar.startOfDay(for: last)
    }
}

enum TaskPostpone {
    static let amounts = 1...7

    enum Unit: String, CaseIterable, Identifiable, Sendable {
        case days
        case weeks

        var id: Self { self }

        var title: String {
            switch self {
            case .days: "Days"
            case .weeks: "Weeks"
            }
        }

        var component: Calendar.Component {
            switch self {
            case .days: .day
            case .weeks: .weekOfYear
            }
        }
    }

    /// Pushes the later of the current due date and today. Count is kept inside 1...7.
    static func date(
        from due: Date,
        now: Date = .now,
        count: Int,
        unit: Unit,
        calendar: Calendar = .current
    ) -> Date {
        let clamped = min(amounts.upperBound, max(amounts.lowerBound, count))
        let base = max(calendar.startOfDay(for: due), calendar.startOfDay(for: now))
        return calendar.date(byAdding: unit.component, value: clamped, to: base) ?? base
    }
}
