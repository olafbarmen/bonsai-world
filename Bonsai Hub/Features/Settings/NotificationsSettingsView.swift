//
//  NotificationsSettingsView.swift
//  Bonsai World
//
//  Settings → Notifications (v1) — local preference toggles + Winter/Spring Care dates.
//

import SwiftUI

struct NotificationsSettingsView: View {
    @Environment(AppSettings.self) private var appSettings
    @AppStorage("bonsai.notifications.careReminders") private var careReminders = true
    @AppStorage("bonsai.notifications.taskDue") private var taskDue = true
    @AppStorage("bonsai.notifications.weatherAlerts") private var weatherAlerts = true
    @AppStorage("bonsai.notifications.nurseryChecks") private var nurseryChecks = true

    var body: some View {
        @Bindable var appSettings = appSettings

        Form {
            Section("Care") {
                Toggle("Care reminders", isOn: $careReminders)
                Toggle("Task due notices", isOn: $taskDue)
                Toggle("Weather alerts", isOn: $weatherAlerts)
            }
            Section {
                Picker("Reminder month", selection: $appSettings.winterCareReminderMonth) {
                    ForEach(1...12, id: \.self) { month in
                        Text(monthName(month)).tag(month)
                    }
                }
                Picker("Reminder day", selection: $appSettings.winterCareReminderDay) {
                    ForEach(1...28, id: \.self) { day in
                        Text("\(day)").tag(day)
                    }
                }
                HStack {
                    Text("Frost threshold")
                    Spacer()
                    Text(appSettings.temperatureUnit.formatted(celsius: appSettings.winterCareFrostCelsius))
                        .foregroundStyle(.secondary)
                    Stepper(
                        "",
                        value: $appSettings.winterCareFrostCelsius,
                        in: -10...10,
                        step: 1
                    )
                    .labelsHidden()
                }
            } header: {
                Text("Winter Care")
            } footer: {
                Text("Activates on this date (through March) or when the night low reaches the frost threshold. Applies to Seasonal trees on Summer placement — Care → Winter Care and Tasks → Winter Care.")
            }
            Section {
                Picker("Reminder month", selection: $appSettings.springCareReminderMonth) {
                    ForEach(1...12, id: \.self) { month in
                        Text(monthName(month)).tag(month)
                    }
                }
                Picker("Reminder day", selection: $appSettings.springCareReminderDay) {
                    ForEach(1...28, id: \.self) { day in
                        Text("\(day)").tag(day)
                    }
                }
            } header: {
                Text("Spring Care")
            } footer: {
                Text("Date only (no temperature) — spring can warm up and then frost again. Applies to Seasonal trees on Winter placement — Care → Spring Care and Tasks → Spring Care. Default 15 April.")
            }
            Section {
                Picker("Reminder month", selection: $appSettings.greenhouseSpringReminderMonth) {
                    ForEach(1...12, id: \.self) { month in
                        Text(monthName(month)).tag(month)
                    }
                }
                Picker("Reminder day", selection: $appSettings.greenhouseSpringReminderDay) {
                    ForEach(1...28, id: \.self) { day in
                        Text("\(day)").tag(day)
                    }
                }
            } header: {
                Text("Greenhouse spring check")
            } footer: {
                Text("Date only — check heat and unlock vents for Locations set to Greenhouse, Cold Greenhouse, or Polytunnel. Care → Spring Care and Tasks. Default 1 April.")
            }
            Section {
                Stepper(
                    value: $appSettings.fertilizerBagsIntervalWeeks,
                    in: 1...26,
                    step: 1
                ) {
                    Text("Replace every \(appSettings.fertilizerBagsIntervalWeeks) week\(appSettings.fertilizerBagsIntervalWeeks == 1 ? "" : "s")")
                }
            } header: {
                Text("Fertilizer bags")
            } footer: {
                Text("Default 6 weeks. Used by Care → Fertilizing and the “Replace fertilizer bags” Task.")
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

    private func monthName(_ month: Int) -> String {
        var components = DateComponents()
        components.month = month
        components.day = 1
        components.year = 2000
        guard let date = Calendar.current.date(from: components) else { return "\(month)" }
        return date.formatted(.dateTime.month(.wide))
    }
}
