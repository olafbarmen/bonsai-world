//
//  EditLocationView.swift
//  Bonsai World
//
//  Field Location edit — Name, Garden, Location Type, map pin, Description, Notes.
//  Save / Cancel. No nested NavigationStack.
//

import SwiftUI

struct EditLocationView: View {
    @Environment(DemoLibrary.self) private var library
    @Environment(\.dismiss) private var dismiss

    let locationID: UUID

    @State private var name = ""
    @State private var gardenID = CanonicalLocationID.defaultGardenID
    @State private var locationTypeID = CanonicalLocationID.defaultLocationTypeID
    @State private var descriptionText = ""
    @State private var notes = ""
    @State private var latitude: Double?
    @State private var longitude: Double?
    @State private var didLoadDraft = false

    private var location: Location? { library.location(id: locationID) }

    private var canSave: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var body: some View {
        Group {
            if location != nil {
                editorForm
            } else {
                ContentUnavailableView("Location not found", systemImage: "mappin.and.ellipse")
            }
        }
    }

    private var editorForm: some View {
        Form {
            Section {
                TextField("Name", text: $name)
                    .font(FaloTypography.body)
                    .foregroundStyle(BonsaiWorldColors.textPrimary)
                    .accessibilityLabel("Name")

                Picker("Garden", selection: $gardenID) {
                    ForEach(gardenOptions) { item in
                        Text(item.name).tag(item.id)
                    }
                }
                .accessibilityLabel("Garden")

                Picker("Location Type", selection: $locationTypeID) {
                    ForEach(locationTypeOptions) { item in
                        Text(item.name).tag(item.id)
                    }
                }
                .accessibilityLabel("Location Type")

                TextField("Description", text: $descriptionText, axis: .vertical)
                    .font(FaloTypography.body)
                    .foregroundStyle(BonsaiWorldColors.textPrimary)
                    .lineLimit(2...5)
                    .accessibilityLabel("Description")

                TextField("Notes", text: $notes, axis: .vertical)
                    .font(FaloTypography.body)
                    .foregroundStyle(BonsaiWorldColors.textPrimary)
                    .lineLimit(2...6)
                    .accessibilityLabel("Notes")
            } header: {
                Text("General")
            } footer: {
                Text("Name, Garden, and Location Type are required.")
                    .font(FaloTypography.caption)
            }

            Section("Map") {
                MobileYamadoriMapCard(
                    latitude: $latitude,
                    longitude: $longitude,
                    primaryTitle: name.isEmpty ? "Location" : name
                )
                .listRowInsets(EdgeInsets(
                    top: FaloSpacing.small,
                    leading: FaloSpacing.medium,
                    bottom: FaloSpacing.small,
                    trailing: FaloSpacing.medium
                ))
            }
        }
        .scrollContentBackground(.hidden)
        .background(BonsaiWorldColors.canvas)
        .scrollDismissesKeyboard(.interactively)
        .navigationTitle("Edit Location")
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
            guard !didLoadDraft, let location else { return }
            name = location.name
            gardenID = location.gardenID
            locationTypeID = location.locationTypeID
            descriptionText = location.locationDescription
            notes = location.notes
            latitude = location.latitude
            longitude = location.longitude
            didLoadDraft = true
        }
    }

    private var gardenOptions: [CanonicalLocationID.Item] {
        pickerOptions(library.orderedGardens.map {
            CanonicalLocationID.Item(id: $0.id, name: $0.name)
        }, selected: gardenID, name: { library.gardenName(for: $0) })
    }

    private var locationTypeOptions: [CanonicalLocationID.Item] {
        pickerOptions(
            CanonicalLocationID.locationTypeCatalog,
            selected: locationTypeID,
            name: CanonicalLocationID.locationTypeName
        )
    }

    private func save() {
        let position: GeographicPosition? = {
            guard let latitude, let longitude else { return nil }
            return GeographicPosition(latitude: latitude, longitude: longitude)
        }()
        library.updateLocation(
            id: locationID,
            name: name,
            description: descriptionText,
            notes: notes,
            gardenID: gardenID,
            locationTypeID: locationTypeID,
            geographicPosition: position
        )
        dismiss()
    }
}

#Preview {
    NavigationStack {
        EditLocationView(locationID: CanonicalLocationID.altan)
    }
    .environment(DemoLibrary.preview)
}
