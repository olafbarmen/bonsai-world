//
//  TreeLocationMapPickerSheet.swift
//  Bonsai World
//
//  Map-based Tree placement: assign a Tree to a Location on the Garden map.
//  Trees never store coordinates — Location owns the geographic position.
//  Reuses LocationMapView (sole MapKit implementation).
//

import SwiftUI

struct TreeLocationMapPickerSheet: View {
    let gardenID: UUID
    @Binding var locationID: UUID?

    @Environment(\.dismiss) private var dismiss
    @Environment(UserProfileStore.self) private var profile
    @Environment(ReferenceDataService.self) private var referenceData
    @Environment(ReferenceDataManager.self) private var manager

    @State private var mapStyle: LocationMapStyle = .standard
    @State private var camera: LocationMapCamera = .defaultGarden
    @State private var focusRequest: LocationMapFocusRequest?
    @State private var statusMessage: String?
    @State private var isCreatingLocation = false
    @State private var pendingCoordinate: GeographicCoordinate?
    @State private var newLocationName = ""
    @State private var newLocationTypeID: UUID?
    @State private var validationMessage: String?
    @State private var didLoad = false

    private var garden: Garden? {
        _ = profile.revision
        return profile.garden(id: gardenID)
    }

    private var gardenLocations: [LocationReference] {
        _ = referenceData.locations
        _ = manager.revision
        return manager.locations(inGarden: gardenID)
    }

    private var locationTypes: [LocationType] {
        manager.locationTypesForPicker()
    }

    private var layerConfiguration: MapLayerConfiguration {
        MapLayerConfiguration(
            showsGardens: true,
            showsLocations: true,
            showsTrees: false,
            collectionFilterID: nil
        )
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                LocationMapView(
                    annotations: annotations,
                    mapStyle: $mapStyle,
                    camera: $camera,
                    focusRequest: focusRequest,
                    selectedAnnotationID: locationID,
                    layerConfiguration: layerConfiguration,
                    allowsMapClickPlacement: isCreatingLocation,
                    onMapClick: { coordinate in
                        guard isCreatingLocation else { return }
                        pendingCoordinate = coordinate
                        statusMessage = "Place saved. Enter a name and Location Type, then Save."
                        validationMessage = nil
                    },
                    onAnnotationSelect: { annotation in
                        handleAnnotationSelect(annotation)
                    }
                )
                .frame(maxWidth: .infinity, maxHeight: .infinity)

                Divider()
                footer
            }
            .navigationTitle("Select on Map")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                        .keyboardShortcut(.cancelAction)
                }
                ToolbarItem(placement: .primaryAction) {
                    if isCreatingLocation {
                        Button("Cancel Create") {
                            cancelCreate()
                        }
                    } else {
                        Button("Create New Location") {
                            beginCreate()
                        }
                    }
                }
            }
        }
        .frame(minWidth: 900, minHeight: 640)
        .task {
            guard !didLoad else { return }
            didLoad = true
            await frameGarden()
        }
    }

    private var annotations: [LocationMapAnnotation] {
        var pins: [LocationMapAnnotation] = []

        if let garden, let coordinate = garden.mapCenter ?? garden.gardenPosition {
            pins.append(
                LocationMapAnnotation(
                    id: garden.id,
                    title: garden.name,
                    subtitle: "Garden",
                    coordinate: coordinate,
                    level: .garden,
                    isHighlighted: false
                )
            )
        }

        for location in gardenLocations {
            guard let coordinate = location.geographicPosition?.coordinate else { continue }
            let isAssigned = location.id == locationID
            pins.append(
                LocationMapAnnotation(
                    id: location.id,
                    title: location.name,
                    subtitle: isAssigned ? "Current Location" : nil,
                    coordinate: coordinate,
                    level: .location,
                    isHighlighted: isAssigned
                )
            )
        }

        if isCreatingLocation, let pendingCoordinate {
            pins.append(
                LocationMapAnnotation(
                    id: pendingPinID,
                    title: newLocationName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                        ? "New Location"
                        : newLocationName,
                    subtitle: "Draft",
                    coordinate: pendingCoordinate,
                    level: .location,
                    isHighlighted: true
                )
            )
        }

        return pins
    }

    /// Ephemeral annotation id for the unsaved create pin (not persisted).
    private var pendingPinID: UUID {
        LocationCreatePinID.value
    }

    private var footer: some View {
        VStack(alignment: .leading, spacing: FaloSpacing.large) {
            HStack(alignment: .top, spacing: FaloSpacing.xxLarge) {
                VStack(alignment: .leading, spacing: FaloSpacing.small) {
                    Text("Garden")
                        .font(FaloTypography.caption)
                        .foregroundStyle(.secondary)
                    Text(garden?.name ?? "Garden")
                        .font(FaloTypography.body.weight(.semibold))

                    if let locationID, let location = referenceData.location(id: locationID) {
                        Text("Assigned: \(location.name)")
                            .font(FaloTypography.caption)
                            .foregroundStyle(.secondary)
                    } else {
                        Text("No Location assigned yet.")
                            .font(FaloTypography.caption)
                            .foregroundStyle(.secondary)
                    }
                }

                VStack(alignment: .leading, spacing: FaloSpacing.small) {
                    Text("Map View")
                        .font(FaloTypography.caption)
                        .foregroundStyle(.secondary)
                    Picker("Map View", selection: $mapStyle) {
                        ForEach(LocationMapStyle.allCases) { style in
                            Text(style.title).tag(style)
                        }
                    }
                    .pickerStyle(.segmented)
                    .labelsHidden()
                    .frame(maxWidth: 360)
                }

                Spacer(minLength: 0)
            }

            if isCreatingLocation {
                createLocationForm
            }

            if let validationMessage {
                Text(validationMessage)
                    .font(FaloTypography.caption)
                    .foregroundStyle(.orange)
            }

            if let statusMessage {
                Text(statusMessage)
                    .font(FaloTypography.caption)
                    .foregroundStyle(.secondary)
            }

            Text("Click a Location marker to assign this Tree. Trees never store coordinates — the Location owns the map position.")
                .font(FaloTypography.caption)
                .foregroundStyle(.secondary)
        }
        .padding(FaloSpacing.xLarge)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.windowBackground)
    }

    private var createLocationForm: some View {
        VStack(alignment: .leading, spacing: FaloSpacing.medium) {
            Text("Create New Location")
                .font(FaloTypography.body.weight(.semibold))

            TextField("Location Name", text: $newLocationName)

            Picker("Location Type", selection: $newLocationTypeID) {
                Text("Select Location Type").tag(Optional<UUID>.none)
                ForEach(locationTypes) { type in
                    Text(type.name).tag(Optional(type.id))
                }
            }
            .pickerStyle(.menu)

            HStack {
                Spacer(minLength: 0)
                Button("Save Location") {
                    saveNewLocation()
                }
                .keyboardShortcut(.defaultAction)
                .disabled(pendingCoordinate == nil)
            }

            Text(pendingCoordinate == nil
                ? "Click the map to place the new Location."
                : "Position ready. Save to add this Location and assign the Tree.")
                .font(FaloTypography.caption)
                .foregroundStyle(.secondary)
        }
        .padding(FaloSpacing.medium)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.quaternary.opacity(0.35))
        .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
    }

    private func handleAnnotationSelect(_ annotation: LocationMapAnnotation) {
        guard annotation.level == .location else { return }
        guard annotation.id != pendingPinID else { return }
        guard !isCreatingLocation else {
            statusMessage = "Finish or cancel Create New Location first."
            return
        }
        locationID = annotation.id
        dismiss()
    }

    private func beginCreate() {
        isCreatingLocation = true
        pendingCoordinate = nil
        newLocationName = ""
        newLocationTypeID = locationTypes.first?.id
        validationMessage = nil
        statusMessage = "Click the map to place your new Location."
    }

    private func cancelCreate() {
        isCreatingLocation = false
        pendingCoordinate = nil
        newLocationName = ""
        newLocationTypeID = nil
        validationMessage = nil
        statusMessage = "Select an existing Location, or create a new one."
    }

    private func saveNewLocation() {
        validationMessage = nil
        guard let pendingCoordinate else {
            validationMessage = "Click the map to place the new Location."
            return
        }

        var draft = manager.blankLocationDraft(gardenID: gardenID)
        draft.name = newLocationName
        draft.locationTypeID = newLocationTypeID
        draft.geographicPosition = GeographicPosition(
            coordinate: pendingCoordinate,
            lastUpdated: .now
        )

        switch manager.saveLocation(draft) {
        case .success(let savedID):
            locationID = savedID
            dismiss()
        case .failure(.missingName):
            validationMessage = "Location Name is required."
        case .failure(.missingLocationType):
            validationMessage = "Select a Location Type."
        case .failure(.missingGarden):
            validationMessage = "Garden is missing."
        case .failure(.duplicateName):
            validationMessage = "A Location with that name already exists."
        }
    }

    private func frameGarden() async {
        if let locationID,
           let location = referenceData.location(id: locationID),
           location.gardenID == gardenID,
           let coordinate = location.geographicPosition?.coordinate {
            applyCamera(LocationMapCamera(center: coordinate, visibleMeters: 400))
            statusMessage = "Current Location highlighted. Click another Location to reassign."
            return
        }

        if let coordinate = garden?.mapCenter {
            applyCamera(LocationMapCamera(center: coordinate, visibleMeters: 1_200))
            statusMessage = "Click a Location marker to place this Tree."
            return
        }

        let address = garden?.composedAddress ?? ""
        guard !address.isEmpty else {
            camera = .defaultGarden
            statusMessage = "Click a Location marker to place this Tree."
            return
        }

        do {
            let coordinate = try await AddressGeocoder.coordinate(for: address)
            applyCamera(LocationMapCamera(center: coordinate, visibleMeters: 1_200))
            statusMessage = "Click a Location marker to place this Tree."
        } catch {
            camera = .defaultGarden
            statusMessage = "Click a Location marker to place this Tree."
        }
    }

    private func applyCamera(_ focus: LocationMapCamera) {
        camera = focus
        focusRequest = LocationMapFocusRequest(camera: focus)
    }
}

/// Stable ephemeral id for the create-location draft pin (never persisted as a Location).
private enum LocationCreatePinID {
    static let value = UUID(uuidString: "C0FFEEEE-0000-4000-8000-00000000C0DE")!
}
