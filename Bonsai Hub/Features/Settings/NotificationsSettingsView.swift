//
//  NotificationsSettingsView.swift
//  Bonsai World
//
//  Settings → Notifications (v1) — local preference toggles.
//

import SwiftUI

struct NotificationsSettingsView: View {
    @AppStorage("bonsai.notifications.careReminders") private var careReminders = true
    @AppStorage("bonsai.notifications.taskDue") private var taskDue = true
    @AppStorage("bonsai.notifications.weatherAlerts") private var weatherAlerts = true
    @AppStorage("bonsai.notifications.nurseryChecks") private var nurseryChecks = true

    var body: some View {
        Form {
            Section("Care") {
                Toggle("Care reminders", isOn: $careReminders)
                Toggle("Task due notices", isOn: $taskDue)
                Toggle("Weather alerts", isOn: $weatherAlerts)
            }
            Section("Nursery") {
                Toggle("Nursery check reminders", isOn: $nurseryChecks)
            }
            Section {
                Text("These preferences are stored on this Mac. Delivery uses the Care notification system when available.")
                    .font(FaloTypography.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .formStyle(.grouped)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .faloWorkspaceCanvas()
        .bonsaiWorkspaceNavigationTitle("Notifications")
        .padding(FaloSpacing.xLarge)
    }
}
