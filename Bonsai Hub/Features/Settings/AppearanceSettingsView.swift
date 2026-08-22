//
//  AppearanceSettingsView.swift
//  Bonsai World
//
//  Settings → Appearance — reserved for future visual preferences.
//

import SwiftUI

struct AppearanceSettingsView: View {
    var body: some View {
        ContentUnavailableView(
            "Appearance",
            systemImage: "paintbrush",
            description: Text("Appearance preferences will appear here in a later release.")
        )
        .navigationTitle("Appearance")
    }
}

#Preview {
    AppearanceSettingsView()
}
