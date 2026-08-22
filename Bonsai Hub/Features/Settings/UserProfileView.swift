//
//  UserProfileView.swift
//  Bonsai World
//
//  Settings → User Profile — General + Gardens.
//  Default Garden is the geographic root for Maps / Weather / AI.
//

import SwiftUI

struct UserProfileView: View {
    @Environment(UserProfileStore.self) private var profile

    @State private var gardenEditor: Garden?
    @State private var gardenPendingDelete: Garden?

    var body: some View {
        @Bindable var profile = profile

        Form {
            Section {
                TextField("Name", text: $profile.name)
                TextField("Email", text: $profile.email)
                    .textContentType(.emailAddress)
                Picker("Language", selection: $profile.language) {
                    ForEach(AppLanguage.allCases) { language in
                        Text(language.menuTitle).tag(language)
                    }
                }
            } header: {
                Text("General")
            } footer: {
                Text("Email is optional.")
                    .font(FaloTypography.caption)
            }

            Section {
                ForEach(profile.gardens) { garden in
                    gardenRow(garden)
                }

                Button("Add Garden") {
                    gardenEditor = profile.blankGardenDraft()
                }
            } header: {
                Text("Gardens")
            } footer: {
                Text("The Default Garden sets map context and future Weather / AI. Address opens the map area; Garden Position is placed manually and is the reference for Locations.")
                    .font(FaloTypography.caption)
            }
        }
        .formStyle(.grouped)
        .faloScrollSurface()
        .navigationTitle("User Profile")
        .sheet(item: $gardenEditor) { garden in
            GardenEditorSheet(garden: garden)
                .environment(profile)
        }
        .confirmationDialog(
            "Delete Garden?",
            isPresented: Binding(
                get: { gardenPendingDelete != nil },
                set: { if !$0 { gardenPendingDelete = nil } }
            ),
            titleVisibility: .visible
        ) {
            Button("Delete", role: .destructive) {
                if let gardenPendingDelete {
                    profile.deleteGarden(id: gardenPendingDelete.id)
                }
                gardenPendingDelete = nil
            }
            Button("Cancel", role: .cancel) {
                gardenPendingDelete = nil
            }
        } message: {
            Text("Locations linked to this Garden keep their coordinates, but you must reassign them to another Garden.")
        }
    }

    private func gardenRow(_ garden: Garden) -> some View {
        VStack(alignment: .leading, spacing: FaloSpacing.small) {
            HStack {
                VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
                    HStack(spacing: FaloSpacing.small) {
                        Text(garden.name)
                            .font(FaloTypography.body.weight(.semibold))
                        if garden.isDefault {
                            Text("Default")
                                .font(FaloTypography.caption)
                                .foregroundStyle(.secondary)
                        }
                        if !garden.isActive {
                            Text("Inactive")
                                .font(FaloTypography.caption)
                                .foregroundStyle(.secondary)
                        }
                    }

                    Text(garden.composedAddress.isEmpty ? "No address" : garden.composedAddress)
                        .font(FaloTypography.caption)
                        .foregroundStyle(.secondary)

                    Text(garden.hasGardenPosition ? "Position Set" : "Position Not Set")
                        .font(FaloTypography.caption)
                        .foregroundStyle(.secondary)

                    if let coordinate = garden.gardenPosition {
                        Text(String(format: "%.5f, %.5f", coordinate.latitude, coordinate.longitude))
                            .font(FaloTypography.caption.monospaced())
                            .foregroundStyle(.tertiary)
                    }
                }

                Spacer(minLength: FaloSpacing.medium)

                Menu {
                    Button("Edit") {
                        gardenEditor = garden
                    }
                    if !garden.isDefault {
                        Button("Make Default") {
                            profile.setDefaultGarden(id: garden.id)
                        }
                    }
                    Button(garden.isActive ? "Mark Inactive" : "Mark Active") {
                        profile.setGardenActive(id: garden.id, isActive: !garden.isActive)
                    }
                    if profile.gardens.count > 1 {
                        Divider()
                        Button("Delete", role: .destructive) {
                            gardenPendingDelete = garden
                        }
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
                .menuStyle(.borderlessButton)
            }
        }
        .padding(.vertical, FaloSpacing.xSmall)
    }
}

#Preview {
    UserProfileView()
        .environment(UserProfileStore())
}
