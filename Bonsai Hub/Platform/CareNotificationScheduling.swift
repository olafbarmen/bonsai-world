//
//  CareNotificationScheduling.swift
//  Bonsai World
//
//  Platform-independent contract for delivering care reminders.
//  macOS: Platform/macOS/MacCareNotificationScheduler.swift (local UserNotifications).
//  iPhone companion implements the same protocol with UserNotifications
//  (and later APNs if a server exists). Constitution §11 — OS APIs stay isolated.
//

import Foundation

@MainActor
protocol CareNotificationScheduling: AnyObject {
    /// Replaces previously scheduled care notifications with this plan.
    func apply(_ requests: [CareNotificationRequest])
}
