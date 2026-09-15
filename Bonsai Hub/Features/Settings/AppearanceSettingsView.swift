//
//  AppearanceSettingsView.swift
//  Bonsai World
//
//  Settings → Appearance — Theme (Light / Dark).
//

import SwiftUI

struct AppearanceSettingsView: View {
    @Environment(AppSettings.self) private var appSettings

    var body: some View {
        @Bindable var appSettings = appSettings

        Form {
            Section {
                Picker("Theme", selection: $appSettings.theme) {
                    ForEach(AppTheme.allCases) { theme in
                        Text(theme.menuTitle).tag(theme)
                    }
                }
            } header: {
                Text("Theme")
            } footer: {
                Text("Dark uses a forest-green menu with light text. Cards stay light; the page background is slightly deeper.")
                    .foregroundStyle(BonsaiWorldColors.textSecondary)
            }
        }
        .formStyle(.grouped)
        .faloScrollSurface()
        .bonsaiWorkspaceNavigationTitle("Appearance")
    }
}

#Preview {
    AppearanceSettingsView()
        .environment(AppSettings())
}
