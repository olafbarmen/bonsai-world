//
//  GardenPositionEditorSheet.swift
//  Bonsai World
//
//  Manually place or change Garden Position on the map.
//  Address may frame the map; it never overwrites a saved Garden Position.
//

import SwiftUI

struct GardenPositionEditorSheet: View {
    let gardenID: UUID
    let gardenName: String
    let composedAddress: String
    /// When true, open framed from Address without clearing an existing draft position.
    var preferAddressFraming: Bool = false
    @Binding var position: GeographicCoordinate?

    @Environment(\.dismiss) private var dismiss

    @State private var mapStyle: LocationMapStyle = .standard
    @State private var camera: LocationMapCamera = .defaultGarden
    @State private var focusRequest: LocationMapFocusRequest?
    @State private var draftCoordinate: GeographicCoordinate?
    @State private var statusMessage: String?
    @State private var didLoad = false

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                LocationMapView(
                    annotations: annotations,
                    mapStyle: $mapStyle,
                    camera: $camera,
                    focusRequest: focusRequest,
                    selectedAnnotationID: gardenID,
                    allowsMapClickPlacement: true,
                    onMapClick: { coordinate in
                        draftCoordinate = coordinate
                        statusMessage = "Garden marker placed. Drag to adjust, then Save."
                    },
                    onAnnotationDrag: { id, coordinate in
                        guard id == gardenID else { return }
                        draftCoordinate = coordinate
                        statusMessage = "Garden marker moved. Save to keep this position."
                    },
                    onAnnotationSelect: { _ in
                        statusMessage = "Editing Garden Position for \(gardenName)."
                    }
                )
                .frame(maxWidth: .infinity, maxHeight: .infinity)

                Divider()
                footer
            }
            .navigationTitle("Garden Position")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                        .keyboardShortcut(.cancelAction)
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { save() }
                        .keyboardShortcut(.defaultAction)
                }
            }
        }
        .frame(minWidth: 900, minHeight: 640)
        .task {
            guard !didLoad else { return }
            didLoad = true
            await loadInitialState()
        }
    }

    private var annotations: [LocationMapAnnotation] {
        guard let draftCoordinate else { return [] }
        return [
            LocationMapAnnotation(
                id: gardenID,
                title: gardenName.isEmpty ? "Garden" : gardenName,
                subtitle: "Garden Position",
                coordinate: draftCoordinate,
                level: .garden,
                isDraggable: true,
                isHighlighted: true
            )
        ]
    }

    private var footer: some View {
        VStack(alignment: .leading, spacing: FaloSpacing.large) {
            HStack(alignment: .top, spacing: FaloSpacing.xxLarge) {
                VStack(alignment: .leading, spacing: FaloSpacing.small) {
                    Text("Garden")
                        .font(FaloTypography.caption)
                        .foregroundStyle(.secondary)
                    Text(gardenName.isEmpty ? "Garden" : gardenName)
                        .font(FaloTypography.body.weight(.semibold))

                    if let draftCoordinate {
                        Text(String(format: "Latitude   %.6f", draftCoordinate.latitude))
                            .font(FaloTypography.body.monospaced())
                        Text(String(format: "Longitude  %.6f", draftCoordinate.longitude))
                            .font(FaloTypography.body.monospaced())
                    } else {
                        Text("No Garden Position selected.")
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

                    Button("Re-center from Address") {
                        Task { await recenterFromAddress() }
                    }
                    .disabled(composedAddress.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    .help("Moves the map to the address area. Does not change Garden Position.")
                }

                Spacer(minLength: 0)
            }

            if let statusMessage {
                Text(statusMessage)
                    .font(FaloTypography.caption)
                    .foregroundStyle(.secondary)
            }

            Text("Click the map to place the Garden marker. Address only opens the right area — it never overwrites a saved Garden Position.")
                .font(FaloTypography.caption)
                .foregroundStyle(.secondary)
        }
        .padding(FaloSpacing.xLarge)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.windowBackground)
    }

    private func loadInitialState() async {
        draftCoordinate = position

        if preferAddressFraming {
            await recenterFromAddress(
                fallbackStatus: draftCoordinate == nil
                    ? "Click on the map to place your Garden."
                    : "Map centered from Address. Existing Garden Position is unchanged."
            )
            return
        }

        if let draftCoordinate {
            applyCamera(LocationMapCamera(center: draftCoordinate, visibleMeters: 1_200))
            statusMessage = "Current Garden Position. Drag or click to move, then Save."
            return
        }

        await recenterFromAddress(
            fallbackStatus: "Click on the map to place your Garden."
        )
    }

    private func recenterFromAddress(
        fallbackStatus: String = "Map centered from Address. Garden Position was not changed."
    ) async {
        let address = composedAddress.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !address.isEmpty else {
            if let draftCoordinate {
                applyCamera(LocationMapCamera(center: draftCoordinate, visibleMeters: 1_200))
            } else {
                camera = .defaultGarden
            }
            statusMessage = "Add an address first to re-center the map."
            return
        }

        do {
            let coordinate = try await AddressGeocoder.coordinate(for: address)
            // Framing only — never assign to draftCoordinate / position.
            applyCamera(LocationMapCamera(center: coordinate, visibleMeters: 1_200))
            statusMessage = fallbackStatus
        } catch {
            if let draftCoordinate {
                applyCamera(LocationMapCamera(center: draftCoordinate, visibleMeters: 1_200))
            } else {
                camera = .defaultGarden
            }
            statusMessage = "Could not find that address. Click the map to place your Garden."
        }
    }

    private func applyCamera(_ focus: LocationMapCamera) {
        camera = focus
        focusRequest = LocationMapFocusRequest(camera: focus)
    }

    private func save() {
        guard let draftCoordinate else {
            statusMessage = "Click on the map to place your Garden before saving."
            return
        }
        position = draftCoordinate
        dismiss()
    }
}
