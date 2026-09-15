//
//  GardensWorkspaceView.swift
//  Bonsai World
//
//  Locations / Garden → Gardens (v1) — profile gardens list.
//

import SwiftUI

struct GardensWorkspaceView: View {
    @Environment(AppState.self) private var appState
    @Environment(UserProfileStore.self) private var profile
    @State private var editorGarden: Garden?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: FaloSpacing.xxLarge) {
                VStack(alignment: .leading, spacing: FaloSpacing.small) {
                    Text("Gardens")
                        .font(FaloTypography.headline)
                    Text("\(profile.gardens.count) gardens · Address frames the map; Garden Position is placed manually.")
                        .font(FaloTypography.caption)
                        .foregroundStyle(.secondary)
                }

                DetailCard(title: "Gardens") {
                    if profile.gardens.isEmpty {
                        Text("No gardens yet. Add one to frame Locations and climate context.")
                            .foregroundStyle(.secondary)
                    } else {
                        ForEach(profile.gardens) { garden in
                            Button {
                                editorGarden = garden
                            } label: {
                                VStack(alignment: .leading, spacing: 2) {
                                    HStack {
                                        Text(garden.name)
                                            .font(FaloCardTypography.fieldValue)
                                        if garden.isDefault {
                                            Text("Default")
                                                .font(FaloTypography.caption)
                                                .foregroundStyle(.secondary)
                                        }
                                    }
                                    Text([garden.city, garden.country].filter { !$0.isEmpty }.joined(separator: ", "))
                                        .font(FaloTypography.caption)
                                        .foregroundStyle(.secondary)
                                }
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.vertical, FaloSpacing.xSmall)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }
            .padding(FaloSpacing.xLarge)
            .frame(maxWidth: 900, alignment: .leading)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .faloScrollSurface()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .faloWorkspaceCanvas()
        .bonsaiWorkspaceNavigationTitle("Gardens")
        .onAppear { consumeWantsNewGarden() }
        .onChange(of: appState.wantsNewGarden) { _, wants in
            guard wants else { return }
            consumeWantsNewGarden()
        }
        .sheet(item: $editorGarden) { garden in
            GardenEditorSheet(garden: garden)
        }
    }

    private func consumeWantsNewGarden() {
        guard appState.wantsNewGarden else { return }
        editorGarden = profile.blankGardenDraft()
        appState.wantsNewGarden = false
    }
}
