//
//  NewGardenView.swift
//  Bonsai World
//
//  Field New Garden — Name, Default, Address, Climate (no map).
//

import SwiftUI

struct NewGardenView: View {
    @Environment(DemoLibrary.self) private var library
    @Environment(\.dismiss) private var dismiss

    var onCreated: (UUID) -> Void

    @State private var name = ""
    @State private var isDefault = false
    @State private var address = ""
    @State private var postalCode = ""
    @State private var city = ""
    @State private var country = ""
    @State private var hemisphere: GardenHemisphere?
    @State private var season: GardenSeason?

    private var canSave: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("General") {
                    TextField("Garden Name", text: $name)
                        .font(FaloTypography.body)
                        .foregroundStyle(BonsaiWorldColors.textPrimary)
                        .accessibilityLabel("Garden Name")

                    Toggle("Default Garden", isOn: $isDefault)
                        .font(FaloTypography.body)
                        .accessibilityLabel("Default Garden")
                }

                Section("Address") {
                    TextField("Address", text: $address)
                        .font(FaloTypography.body)
                        .foregroundStyle(BonsaiWorldColors.textPrimary)
                        .accessibilityLabel("Address")
                    TextField("Postal Code", text: $postalCode)
                        .font(FaloTypography.body)
                        .foregroundStyle(BonsaiWorldColors.textPrimary)
                        .accessibilityLabel("Postal Code")
                    TextField("City", text: $city)
                        .font(FaloTypography.body)
                        .foregroundStyle(BonsaiWorldColors.textPrimary)
                        .accessibilityLabel("City")
                    TextField("Country", text: $country)
                        .font(FaloTypography.body)
                        .foregroundStyle(BonsaiWorldColors.textPrimary)
                        .accessibilityLabel("Country")
                }

                Section {
                    Picker("Hemisphere", selection: $hemisphere) {
                        Text("Not Set").tag(GardenHemisphere?.none)
                        ForEach(GardenHemisphere.allCases) { item in
                            Text(item.title).tag(Optional(item))
                        }
                    }
                    .font(FaloTypography.body)
                    .accessibilityLabel("Hemisphere")

                    Picker("Season", selection: $season) {
                        Text("Not Set").tag(GardenSeason?.none)
                        ForEach(GardenSeason.allCases) { item in
                            Text(item.title).tag(Optional(item))
                        }
                    }
                    .font(FaloTypography.body)
                    .accessibilityLabel("Season")
                } header: {
                    Text("Climate")
                } footer: {
                    Text(GardenClimate.settingsFooter(hemisphereFollowsPosition: false, season: season))
                        .font(FaloTypography.caption)
                }
            }
            .scrollContentBackground(.hidden)
            .background(BonsaiWorldColors.canvas)
            .scrollDismissesKeyboard(.interactively)
            .navigationTitle("New Garden")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { save() }
                        .fontWeight(.semibold)
                        .disabled(!canSave)
                }
            }
            .toolbarBackground(BonsaiWorldColors.canvas, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.light, for: .navigationBar)
        }
    }

    private func save() {
        guard let garden = library.addGarden(
            name: name,
            isDefault: isDefault,
            address: address,
            postalCode: postalCode,
            city: city,
            country: country,
            hemisphere: hemisphere,
            season: season
        ) else { return }
        onCreated(garden.id)
        dismiss()
    }
}

#Preview {
    NewGardenView(onCreated: { _ in })
        .environment(DemoLibrary.preview)
}
