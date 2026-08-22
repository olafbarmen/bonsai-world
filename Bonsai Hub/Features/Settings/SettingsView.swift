//
//  SettingsView.swift
//  Bonsai World
//
//  Settings content column — User Profile, Regional, Reference Data, Appearance.
//

import SwiftUI

struct SettingsView: View {
    @Environment(AppState.self) private var appState

    var body: some View {
        @Bindable var appState = appState

        List(selection: $appState.selectedSettingsPane) {
            Section("Account") {
                settingsRow(.userProfile)
            }
            Section("Preferences") {
                settingsRow(.regionalSettings)
                settingsRow(.appearance)
                settingsRow(.notifications)
            }
            Section("Data") {
                settingsRow(.referenceData)
                settingsRow(.backup)
            }
        }
        .faloScrollSurface()
        .navigationTitle("Settings")
        .navigationSplitViewColumnWidth(min: 220, ideal: 280)
    }

    private func settingsRow(_ pane: SettingsPane) -> some View {
        Label(pane.title, systemImage: pane.systemImage)
            .tag(pane)
    }
}

#Preview {
    SettingsView()
        .environment(AppState())
}
