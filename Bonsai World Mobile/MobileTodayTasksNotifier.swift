//
//  MobileTodayTasksNotifier.swift
//  Bonsai World
//
//  Local 07:00 reminder when there are Today tasks. Grower can disable in Settings.
//

import Foundation
import UserNotifications

enum MobileTodayTasksNotifier {
    static let requestID = "bonsai.world.today.tasks.0700"
    private static let enabledKey = "bonsai.world.today.tasks.enabled"

    /// Grower preference. Default on.
    static var isEnabled: Bool {
        get {
            if UserDefaults.standard.object(forKey: enabledKey) == nil { return true }
            return UserDefaults.standard.bool(forKey: enabledKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: enabledKey)
        }
    }

    /// Request permission (if needed) and schedule or clear the daily 07:00 notification.
    static func sync(todayCount: Int) {
        let center = UNUserNotificationCenter.current()
        guard isEnabled else {
            center.removePendingNotificationRequests(withIdentifiers: [requestID])
            return
        }

        center.getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .notDetermined:
                center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
                    guard granted else { return }
                    applySchedule(todayCount: todayCount, center: center)
                }
            case .authorized, .provisional, .ephemeral:
                applySchedule(todayCount: todayCount, center: center)
            case .denied:
                center.removePendingNotificationRequests(withIdentifiers: [requestID])
            @unknown default:
                break
            }
        }
    }

    private static func applySchedule(todayCount: Int, center: UNUserNotificationCenter) {
        center.removePendingNotificationRequests(withIdentifiers: [requestID])
        guard todayCount > 0 else { return }

        let content = UNMutableNotificationContent()
        content.title = "Today's Tasks"
        content.body = todayCount == 1
            ? "1 task is due today."
            : "\(todayCount) tasks are due today."
        content.sound = .default

        var date = DateComponents()
        date.hour = 7
        date.minute = 0
        let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
        let request = UNNotificationRequest(identifier: requestID, content: content, trigger: trigger)
        center.add(request)
    }
}
