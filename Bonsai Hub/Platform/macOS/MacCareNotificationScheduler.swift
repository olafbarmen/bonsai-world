//
//  MacCareNotificationScheduler.swift
//  Bonsai World
//
//  macOS local notifications for ``CareNotificationPlanner`` — proof of the
//  same contract the iPhone companion will use. Does not push to a phone;
//  that requires the iOS app (or a later push server).
//

import Foundation
import UserNotifications

@MainActor
final class MacCareNotificationScheduler: CareNotificationScheduling {
    private static let identifierPrefix = "no.olafbarmen.Bonsai-Hub.care."

    private let center: UNUserNotificationCenter
    private var didRequestAuthorization = false

    init(center: UNUserNotificationCenter = .current()) {
        self.center = center
    }

    func apply(_ requests: [CareNotificationRequest]) {
        Task { await applyAsync(requests) }
    }

    private func applyAsync(_ requests: [CareNotificationRequest]) async {
        if !didRequestAuthorization {
            _ = try? await center.requestAuthorization(options: [.alert, .sound, .badge])
            didRequestAuthorization = true
        }

        let pending = await center.pendingNotificationRequests()
        let staleIDs = pending
            .map(\.identifier)
            .filter { $0.hasPrefix(Self.identifierPrefix) }
        if !staleIDs.isEmpty {
            center.removePendingNotificationRequests(withIdentifiers: staleIDs)
        }

        let calendar = Calendar.current
        for request in requests {
            let content = UNMutableNotificationContent()
            content.title = request.title
            content.body = request.body
            content.sound = .default

            let components = calendar.dateComponents(
                [.year, .month, .day, .hour, .minute],
                from: request.fireDate
            )
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
            let identifier = Self.identifierPrefix + request.id
            let notification = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
            try? await center.add(notification)
        }
    }
}
