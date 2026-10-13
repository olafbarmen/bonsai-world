//
//  SettingsView.swift
//  Bonsai World
//
//  Settings content column — User Profile through Library (Getting Started last).
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
                settingsRow(.experience)
                settingsRow(.notifications)
                settingsRow(.social)
            }
            Section("Data") {
                settingsRow(.referenceData)
            }
            Section("Inventory") {
                settingsRow(.potBrandsAndMakers)
            }

            Section("Bonsai Knowledge") {
                settingsRow(.seedStratificationKnowledge)
            }

            Section("Library") {
                settingsRow(.libraryManagement)
                settingsRow(.gettingStarted)
            }
        }
        .faloWarmContentList()
        .bonsaiWorkspaceNavigationTitle("Settings")
        .navigationSplitViewColumnWidth(min: 220, ideal: 280)
    }

    private func settingsRow(_ pane: SettingsPane) -> some View {
        Label(pane.title, systemImage: pane.systemImage)
            .foregroundStyle(BonsaiWorldColors.textPrimary)
            .tag(pane)
            .listRowBackground(
                SidebarRowBackground(
                    isSelected: appState.selectedSettingsPane == pane,
                    baseFill: BonsaiWorldColors.canvas
                )
            )
    }
}

#Preview {
    SettingsView()
        .environment(AppState())
}
