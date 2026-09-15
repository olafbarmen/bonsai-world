//
//  SocialSettingsView.swift
//  Bonsai World
//
//  Settings → Social — opt in to Social (local sharing prep).
//

import SwiftUI

struct SocialSettingsView: View {
    @Environment(AppSettings.self) private var appSettings

    var body: some View {
        @Bindable var appSettings = appSettings

        Form {
            Section {
                Toggle("Social", isOn: $appSettings.isSocialEnabled)
            } header: {
                Text("Participation")
            } footer: {
                Text(
                    appSettings.isSocialEnabled
                        ? "Social is on. Choose a share level on each Tree. Sharing stays in this library for now — network sharing comes later."
                        : "When Social is off, Trees are not offered for sharing — even if a share level is set."
                )
                .foregroundStyle(BonsaiWorldColors.textSecondary)
            }

            Section("Share levels") {
                ForEach(SocialShareLevel.allCases) { level in
                    VStack(alignment: .leading, spacing: 2) {
                        Text(level.title)
                            .font(FaloTypography.body)
                        Text(level.detail)
                            .font(FaloTypography.caption)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 2)
                }
            }
        }
        .formStyle(.grouped)
        .faloScrollSurface()
        .bonsaiWorkspaceNavigationTitle("Social")
    }
}
