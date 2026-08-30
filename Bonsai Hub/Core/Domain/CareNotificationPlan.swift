//
//  CareNotificationPlan.swift
//  Bonsai World
//
//  Platform-agnostic plan for care reminders. macOS schedules these as local
//  notifications today; the iPhone companion uses the same requests
//  (UserNotifications now, remote push later if a server exists).
//
//  - Daily digest at 07:00 local: today's due Tasks (watering catch-up included;
//    missed watering that expired is not).
//  - Overdue warning at the same 07:00: care that can still be done late
//    (fertilizing, pruning, …). Work Types flagged `expiresIfMissed` never
//    produce an overdue notification.
//

import Foundation

enum CareNotificationKind: String, Sendable, Hashable {
    case dailyDigest
    case overdueWarning
}

struct CareNotificationRequest: Identifiable, Hashable, Sendable {
    var id: String
    var kind: CareNotificationKind
    var fireDate: Date
    var title: String
    var body: String
}

enum CareNotificationPlanner {
    static let dailyHour = 7
    static let dailyMinute = 0

    /// Builds the next 07:00 local notifications from current Task counts.
    /// Call again whenever occurrences change so tomorrow's body stays accurate.
    static func plan(
        todayCount: Int,
        overdueCount: Int,
        now: Date = .now,
        calendar: Calendar = .current
    ) -> [CareNotificationRequest] {
        guard let fireDate = nextDailyFireDate(now: now, calendar: calendar) else { return [] }

        var requests: [CareNotificationRequest] = []

        if todayCount > 0 {
            requests.append(
                CareNotificationRequest(
                    id: "care.dailyDigest",
                    kind: .dailyDigest,
                    fireDate: fireDate,
                    title: "Today's tasks",
                    body: todayCount == 1
                        ? "1 task is due today."
                        : "\(todayCount) tasks are due today."
                )
            )
        }

        if overdueCount > 0 {
            requests.append(
                CareNotificationRequest(
                    id: "care.overdue",
                    kind: .overdueWarning,
                    fireDate: fireDate,
                    title: "Overdue care",
                    body: overdueCount == 1
                        ? "1 task is overdue and still needs doing."
                        : "\(overdueCount) tasks are overdue and still need doing."
                )
            )
        }

        return requests
    }

    static func nextDailyFireDate(now: Date, calendar: Calendar) -> Date? {
        var components = calendar.dateComponents([.year, .month, .day], from: now)
        components.hour = dailyHour
        components.minute = dailyMinute
        components.second = 0
        guard let todayFire = calendar.date(from: components) else { return nil }
        if todayFire > now { return todayFire }
        return calendar.date(byAdding: .day, value: 1, to: todayFire)
    }
}
