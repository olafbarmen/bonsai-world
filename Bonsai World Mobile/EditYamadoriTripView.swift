//
//  EditYamadoriTripView.swift
//  Bonsai World
//
//  Edit Trip — same fields as Mac Yamadori trip edit (identity, Wild Site, Collection Plan, Notes).
//

import SwiftUI

struct EditYamadoriTripView: View {
    @Environment(DemoLibrary.self) private var library
    @Environment(\.dismiss) private var dismiss

    let tripID: UUID

    @State private var displayName: String = ""
    @State private var tripDate: Date = .now
    @State private var locationDescription: String = ""
    @State private var countryRegion: String = ""
    @State private var latitudeText: String = ""
    @State private var longitudeText: String = ""
    @State private var permissionNotes: String = ""
    @State private var landOwnershipNotes: String = ""
    @State private var collectionWindowNotes: String = ""
    @State private var preparationNotes: String = ""
    @State private var equipmentNotes: String = ""
    @State private var collectionPlanNotes: String = ""
    @State private var preCollectionChecklist: [YamadoriChecklistItem] = []
    @State private var collectionKitChecklist: [YamadoriChecklistItem] = []
    @State private var notes: String = ""
    @State private var didLoad = false

    private var canSave: Bool {
        !displayName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Trip") {
                    TextField("Display Name", text: $displayName)
                        .font(FaloTypography.body)
                        .foregroundStyle(BonsaiWorldColors.textPrimary)
                        .accessibilityLabel("Display Name")

                    DatePicker("Trip Date", selection: $tripDate, displayedComponents: .date)
                }

                Section("Wild Site") {
                    TextField("Location Description", text: $locationDescription, axis: .vertical)
                        .lineLimit(2...5)
                        .accessibilityLabel("Location Description")

                    TextField("Country / Region", text: $countryRegion)
                        .accessibilityLabel("Country / Region")

                    TextField("Latitude", text: $latitudeText)
                        .keyboardType(.numbersAndPunctuation)
                        .accessibilityLabel("Latitude")

                    TextField("Longitude", text: $longitudeText)
                        .keyboardType(.numbersAndPunctuation)
                        .accessibilityLabel("Longitude")

                    TextField("Permission Notes", text: $permissionNotes, axis: .vertical)
                        .lineLimit(2...5)
                        .accessibilityLabel("Permission Notes")

                    TextField("Land Ownership", text: $landOwnershipNotes, axis: .vertical)
                        .lineLimit(2...5)
                        .accessibilityLabel("Land Ownership")
                }

                Section("Collection Plan") {
                    TextField("Window Notes", text: $collectionWindowNotes, axis: .vertical)
                        .lineLimit(2...5)
                        .accessibilityLabel("Window Notes")

                    TextField("Preparation", text: $preparationNotes, axis: .vertical)
                        .lineLimit(2...5)
                        .accessibilityLabel("Preparation")

                    TextField("Equipment", text: $equipmentNotes, axis: .vertical)
                        .lineLimit(2...5)
                        .accessibilityLabel("Equipment")

                    TextField("Plan Notes", text: $collectionPlanNotes, axis: .vertical)
                        .lineLimit(2...5)
                        .accessibilityLabel("Plan Notes")
                }

                Section("Pre-Collection") {
                    ForEach($preCollectionChecklist) { $item in
                        Toggle(item.title, isOn: $item.isComplete)
                    }
                }

                Section("Collection Kit") {
                    ForEach($collectionKitChecklist) { $item in
                        Toggle(item.title, isOn: $item.isComplete)
                    }
                }

                Section("Notes") {
                    TextField("Notes", text: $notes, axis: .vertical)
                        .lineLimit(3...8)
                        .accessibilityLabel("Notes")
                }
            }
            .scrollContentBackground(.hidden)
            .background(BonsaiWorldColors.canvas)
            .scrollDismissesKeyboard(.interactively)
            .navigationTitle("Edit Trip")
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
            .onAppear { loadIfNeeded() }
        }
    }

    private func loadIfNeeded() {
        guard !didLoad, let trip = library.yamadoriTrip(id: tripID) else { return }
        displayName = trip.displayName
        tripDate = trip.tripDate ?? trip.createdDate
        locationDescription = trip.locationDescription
        countryRegion = trip.countryRegion
        latitudeText = trip.latitude.map { String($0) } ?? ""
        longitudeText = trip.longitude.map { String($0) } ?? ""
        permissionNotes = trip.permissionNotes
        landOwnershipNotes = trip.landOwnershipNotes
        collectionWindowNotes = trip.collectionWindowNotes
        preparationNotes = trip.preparationNotes
        equipmentNotes = trip.equipmentNotes
        collectionPlanNotes = trip.collectionPlanNotes
        preCollectionChecklist = trip.preCollectionChecklist
        collectionKitChecklist = trip.collectionKitChecklist
        notes = trip.notes
        didLoad = true
    }

    private func save() {
        library.updateYamadoriTrip(
            id: tripID,
            displayName: displayName,
            tripDate: tripDate,
            latitude: parsedCoordinate(latitudeText),
            longitude: parsedCoordinate(longitudeText),
            updateCoordinates: true,
            locationDescription: locationDescription,
            countryRegion: countryRegion,
            permissionNotes: permissionNotes,
            landOwnershipNotes: landOwnershipNotes,
            collectionWindowNotes: collectionWindowNotes,
            preparationNotes: preparationNotes,
            equipmentNotes: equipmentNotes,
            collectionPlanNotes: collectionPlanNotes,
            preCollectionChecklist: preCollectionChecklist,
            collectionKitChecklist: collectionKitChecklist,
            notes: notes
        )
        dismiss()
    }

    private func parsedCoordinate(_ text: String) -> Double? {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return nil }
        return Double(trimmed.replacingOccurrences(of: ",", with: "."))
    }
}

#Preview {
    EditYamadoriTripView(tripID: UUID())
        .environment(DemoLibrary.preview)
}
