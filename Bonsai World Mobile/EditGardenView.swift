//
//  EditGardenView.swift
//  Bonsai World
//
//  Field Garden edit — Name, Default, Address, Climate. Save / Cancel.
//

import SwiftUI

struct EditGardenView: View {
    @Environment(DemoLibrary.self) private var library
    @Environment(\.dismiss) private var dismiss

    let gardenID: UUID

    @State private var name = ""
    @State private var isDefault = false
    @State private var address = ""
    @State private var postalCode = ""
    @State private var city = ""
    @State private var country = ""
    @State private var hemisphere: GardenHemisphere?
    @State private var season: GardenSeason?
    @State private var hemisphereFollowsPosition = false
    @State private var didLoadDraft = false

    private var garden: Garden? { library.garden(id: gardenID) }

    private var canSave: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var body: some View {
        Group {
            if garden != nil {
                editorForm
            } else {
                ContentUnavailableView("Garden not found", systemImage: "mappin.and.ellipse")
            }
        }
    }

    private var editorForm: some View {
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

            climateSection
        }
        .scrollContentBackground(.hidden)
        .background(BonsaiWorldColors.canvas)
        .scrollDismissesKeyboard(.interactively)
        .navigationTitle("Edit Garden")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
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
        .onAppear {
            guard !didLoadDraft, let garden else { return }
            name = garden.name
            isDefault = garden.isDefault
            address = garden.address
            postalCode = garden.postalCode
            city = garden.city
            country = garden.country
            hemisphere = garden.hemisphere
            season = garden.season
            if hemisphere == nil, let latitude = garden.latitude {
                hemisphere = GardenHemisphere.suggested(latitude: latitude)
                hemisphereFollowsPosition = true
            }
            didLoadDraft = true
        }
    }

    private var climateSection: some View {
        Section {
            Picker("Hemisphere", selection: $hemisphere) {
                Text("Not Set").tag(GardenHemisphere?.none)
                ForEach(GardenHemisphere.allCases) { item in
                    Text(item.title).tag(Optional(item))
                }
            }
            .font(FaloTypography.body)
            .accessibilityLabel("Hemisphere")
            .onChange(of: hemisphere) { _, newValue in
                guard hemisphereFollowsPosition else { return }
                let suggested = garden?.latitude.map { GardenHemisphere.suggested(latitude: $0) }
                if newValue != suggested {
                    hemisphereFollowsPosition = false
                }
            }

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
            Text(GardenClimate.settingsFooter(
                hemisphereFollowsPosition: hemisphereFollowsPosition,
                season: season
            ))
            .font(FaloTypography.caption)
        }
    }

    private func save() {
        library.updateGarden(
            id: gardenID,
            name: name,
            isDefault: isDefault,
            address: address,
            postalCode: postalCode,
            city: city,
            country: country,
            hemisphere: hemisphere,
            season: season,
            includeClimate: true
        )
        dismiss()
    }
}

#Preview {
    NavigationStack {
        EditGardenView(gardenID: CanonicalLocationID.defaultGardenID)
    }
    .environment(DemoLibrary.preview)
}
