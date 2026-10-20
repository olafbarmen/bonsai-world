//
//  MobileSelectOnMapSheet.swift
//  Bonsai World
//
//  New Tree → Select on Map. Assigns a Location. Trees never store coordinates.
//

import MapKit
import SwiftUI

struct MobileSelectOnMapSheet: View {
    let gardenID: UUID
    @Binding var locationID: UUID?

    @Environment(DemoLibrary.self) private var library
    @Environment(\.dismiss) private var dismiss

    @State private var cameraPosition: MapCameraPosition = .automatic
    @State private var selectedLocationID: UUID?
    @State private var isShowingNewLocation = false

    private var garden: Garden? { library.garden(id: gardenID) }

    private var pinnedLocations: [Location] {
        library.locations(inGarden: gardenID).filter { $0.latitude != nil && $0.longitude != nil }
    }

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: FaloSpacing.medium) {
                Map(position: $cameraPosition, selection: $selectedLocationID) {
                    if let garden, let latitude = garden.latitude, let longitude = garden.longitude {
                        Marker(garden.name, systemImage: "leaf", coordinate: coordinate(latitude, longitude))
                            .tint(BonsaiWorldColors.textSecondary)
                    }
                    ForEach(pinnedLocations) { location in
                        if let latitude = location.latitude, let longitude = location.longitude {
                            Marker(location.name, coordinate: coordinate(latitude, longitude))
                                .tint(location.id == locationID ? BonsaiWorldColors.accent : BonsaiWorldColors.textPrimary)
                                .tag(location.id)
                        }
                    }
                }
                .mapStyle(.standard)
                .frame(maxWidth: .infinity, maxHeight: .infinity)

                if pinnedLocations.isEmpty {
                    Text("No Location on the map yet.")
                        .font(FaloTypography.caption)
                        .foregroundStyle(BonsaiWorldColors.textSecondary)
                }

                if let locationID, let name = library.locationName(for: locationID) {
                    Text("Assigned: \(name)")
                        .font(FaloTypography.caption)
                        .foregroundStyle(BonsaiWorldColors.textSecondary)
                }

                Text("Tap a Location marker to assign this Tree. Trees never store coordinates — the Location owns the map position.")
                    .font(FaloTypography.caption)
                    .foregroundStyle(BonsaiWorldColors.textSecondary)
            }
            .padding(FaloSpacing.medium)
            .background(BonsaiWorldColors.canvas)
            .navigationTitle("Select on Map")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .primaryAction) {
                    Button("Create New Location") {
                        isShowingNewLocation = true
                    }
                }
            }
            .toolbarBackground(BonsaiWorldColors.canvas, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarColorScheme(.light, for: .navigationBar)
            .onAppear(perform: frameMap)
            .onChange(of: selectedLocationID) { _, newValue in
                guard let newValue else { return }
                locationID = newValue
                dismiss()
            }
            .sheet(isPresented: $isShowingNewLocation) {
                NewLocationView(initialGardenID: gardenID) { id in
                    locationID = id
                    dismiss()
                }
            }
        }
        .tint(BonsaiWorldColors.accent)
        .preferredColorScheme(.light)
    }

    private func frameMap() {
        if let locationID,
           let location = library.location(id: locationID),
           let latitude = location.latitude,
           let longitude = location.longitude {
            cameraPosition = .region(region(latitude, longitude, span: 0.02))
            return
        }
        if let garden, let latitude = garden.latitude, let longitude = garden.longitude {
            cameraPosition = .region(region(latitude, longitude, span: 0.05))
            return
        }
        if let location = pinnedLocations.first,
           let latitude = location.latitude,
           let longitude = location.longitude {
            cameraPosition = .region(region(latitude, longitude, span: 0.05))
            return
        }
        let fallback = GeographicCoordinate.defaultMapCenter
        cameraPosition = .region(region(fallback.latitude, fallback.longitude, span: 0.2))
    }

    private func coordinate(_ latitude: Double, _ longitude: Double) -> CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    private func region(_ latitude: Double, _ longitude: Double, span: Double) -> MKCoordinateRegion {
        MKCoordinateRegion(
            center: coordinate(latitude, longitude),
            span: MKCoordinateSpan(latitudeDelta: span, longitudeDelta: span)
        )
    }
}
