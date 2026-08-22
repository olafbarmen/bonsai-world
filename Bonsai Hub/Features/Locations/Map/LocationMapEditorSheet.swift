//
//  LocationMapEditorSheet.swift
//  Bonsai World
//
//  Set Position — Garden map with all Location pins; edit the target Location pin.
//  Trees inherit map position from Locations; no Tree coordinates here.
//

import SwiftUI

struct LocationMapEditorSheet: View {
    let locationID: UUID
    let locationName: String
    /// Other Locations in the same Garden (pins for context).
    let gardenLocations: [LocationReference]
    let garden: Garden?
    @Binding var position: GeographicPosition?

    @Environment(\.dismiss) private var dismiss

    @State private var mapStyle: LocationMapStyle = .standard
    @State private var camera: LocationMapCamera = .defaultGarden
    @State private var focusRequest: LocationMapFocusRequest?
    @State private var draftCoordinate: GeographicCoordinate?
    @State private var statusMessage: String?

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                LocationMapView(
                    annotations: annotations,
                    mapStyle: $mapStyle,
                    camera: $camera,
                    focusRequest: focusRequest,
                    selectedAnnotationID: locationID,
                    allowsMapClickPlacement: true,
                    onMapClick: { coordinate in
                        draftCoordinate = coordinate
                        statusMessage = "Pin placed for \(locationName). Drag to adjust, then Save."
                    },
                    onAnnotationDrag: { id, coordinate in
                        guard id == locationID else { return }
                        draftCoordinate = coordinate
                        statusMessage = "Pin moved. Save to keep this position."
                    },
                    onAnnotationSelect: { annotation in
                        if annotation.id == locationID {
                            statusMessage = "Editing \(locationName)."
                        }
                    }
                )
                .frame(maxWidth: .infinity, maxHeight: .infinity)

                Divider()
                footer
            }
            .navigationTitle("Set Position")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                    .keyboardShortcut(.cancelAction)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        save()
                    }
                    .keyboardShortcut(.defaultAction)
                }
            }
        }
        .frame(minWidth: 900, minHeight: 640)
        .task {
            await loadInitialState()
        }
    }

    private var annotations: [LocationMapAnnotation] {
        var pins: [LocationMapAnnotation] = gardenLocations.compactMap { location in
            guard location.id != locationID,
                  let coordinate = location.geographicPosition?.coordinate
            else {
                return nil
            }
            return LocationMapAnnotation(
                id: location.id,
                title: location.name,
                coordinate: coordinate,
                level: .location,
                isDraggable: false,
                isHighlighted: false
            )
        }

        if let garden, let coordinate = garden.gardenPosition {
            pins.insert(
                LocationMapAnnotation(
                    id: garden.id,
                    title: garden.name,
                    subtitle: garden.isDefault ? "Default Garden" : "Garden",
                    coordinate: coordinate,
                    level: .garden,
                    isHighlighted: true
                ),
                at: 0
            )
        }

        if let draftCoordinate {
            pins.append(
                LocationMapAnnotation(
                    id: locationID,
                    title: locationName,
                    coordinate: draftCoordinate,
                    level: .location,
                    isDraggable: true,
                    isHighlighted: true
                )
            )
        }

        return pins
    }

    private var footer: some View {
        VStack(alignment: .leading, spacing: FaloSpacing.large) {
            HStack(alignment: .top, spacing: FaloSpacing.xxLarge) {
                VStack(alignment: .leading, spacing: FaloSpacing.small) {
                    Text("Location")
                        .font(FaloTypography.caption)
                        .foregroundStyle(.secondary)
                    Text(locationName)
                        .font(FaloTypography.body.weight(.semibold))

                    if let draftCoordinate {
                        Text(String(format: "Latitude   %.6f", draftCoordinate.latitude))
                            .font(FaloTypography.body.monospaced())
                        Text(String(format: "Longitude  %.6f", draftCoordinate.longitude))
                            .font(FaloTypography.body.monospaced())
                    } else {
                        Text("No position selected.")
                            .font(FaloTypography.body)
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

            if let statusMessage {
                Text(statusMessage)
                    .font(FaloTypography.caption)
                    .foregroundStyle(.secondary)
            }

            Text("The Garden map shows every saved Location. Click to place or move this Location’s pin. Trees at this Location inherit this position. Garden Address only frames the map when Garden Position is unset.")
                .font(FaloTypography.caption)
                .foregroundStyle(.secondary)
        }
        .padding(FaloSpacing.xLarge)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.windowBackground)
    }

    private func loadInitialState() async {
        if let position {
            draftCoordinate = position.coordinate
            applyCamera(LocationMapCamera(center: position.coordinate, visibleMeters: 80))
            statusMessage = "Current pin for \(locationName). Drag or click to move."
            return
        }

        draftCoordinate = nil

        if let coordinate = garden?.gardenPosition {
            applyCamera(LocationMapCamera(center: coordinate, visibleMeters: 1_200))
            statusMessage = "Garden map ready. Click to set a position for \(locationName)."
            return
        }

        // Address frames only — never writes Garden Position.
        let address = garden?.composedAddress ?? ""
        guard !address.isEmpty else {
            camera = .defaultGarden
            statusMessage = "Click the map to set a position for \(locationName)."
            return
        }

        do {
            let coordinate = try await AddressGeocoder.coordinate(for: address)
            applyCamera(LocationMapCamera(center: coordinate, visibleMeters: 1_200))
            statusMessage = "Garden map ready. Click to set a position for \(locationName)."
        } catch {
            camera = .defaultGarden
            statusMessage = "Could not open the Garden address. Click the map to place a pin."
        }
    }

    private func applyCamera(_ focus: LocationMapCamera) {
        camera = focus
        focusRequest = LocationMapFocusRequest(camera: focus)
    }

    private func save() {
        guard let draftCoordinate else {
            statusMessage = "Place a pin on the map before saving."
            return
        }
        position = GeographicPosition(coordinate: draftCoordinate, lastUpdated: .now)
        dismiss()
    }
}
