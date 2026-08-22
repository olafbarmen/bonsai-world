//
//  RegionalSettingsView.swift
//  Bonsai World
//
//  Settings → Regional Settings — display preferences only (no addresses).
//

import SwiftUI

struct RegionalSettingsView: View {
    @Environment(AppSettings.self) private var appSettings

    var body: some View {
        @Bindable var appSettings = appSettings

        Form {
            Section {
                Picker("Currency", selection: $appSettings.currency) {
                    ForEach(AppCurrency.allCases) { currency in
                        Text(currency.menuTitle).tag(currency)
                    }
                }
            } header: {
                Text("Currency")
            } footer: {
                Text("Changing currency updates how prices are shown. It does not convert amounts.")
            }

            Section {
                Picker("Measurement System", selection: $appSettings.measurementSystem) {
                    ForEach(MeasurementSystem.allCases) { system in
                        Text(system.menuTitle).tag(system)
                    }
                }
                Picker("Temperature Unit", selection: $appSettings.temperatureUnit) {
                    ForEach(TemperatureUnit.allCases) { unit in
                        Text(unit.menuTitle).tag(unit)
                    }
                }
            } header: {
                Text("Units")
            } footer: {
                Text("Measurement values are stored in millimetres. Temperature is for future Weather display.")
            }

            Section {
                Picker("Date Format", selection: $appSettings.dateFormat) {
                    ForEach(AppDateFormat.allCases) { format in
                        Text(format.menuTitle).tag(format)
                    }
                }
                Picker("Time Format", selection: $appSettings.timeFormat) {
                    ForEach(AppTimeFormat.allCases) { format in
                        Text(format.menuTitle).tag(format)
                    }
                }
                Picker("First Day of Week", selection: $appSettings.firstDayOfWeek) {
                    ForEach(FirstDayOfWeek.allCases) { day in
                        Text(day.menuTitle).tag(day)
                    }
                }
            } header: {
                Text("Calendar")
            }
        }
        .formStyle(.grouped)
        .faloScrollSurface()
        .navigationTitle("Regional Settings")
    }
}

#Preview {
    RegionalSettingsView()
        .environment(AppSettings())
}
