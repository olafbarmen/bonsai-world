//
//  YamadoriSiteMapCard.swift
//  Bonsai World
//
//  Shared map for Yamadori trip area pins and Find precise pins.
//  Tap while editing places / moves the primary pin.
//

import MapKit
import SwiftUI

struct YamadoriMapPin: Identifiable, Hashable {
    enum Kind: Hashable {
        case tripArea
        case find
    }

    var id: UUID
    var title: String
    var latitude: Double
    var longitude: Double
    var kind: Kind

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

struct YamadoriSiteMapCard: View {
    var title: String = "Map"
    /// Primary pin being edited (trip area or this Find).
    @Binding var latitude: Double?
    @Binding var longitude: Double?
    var primaryTitle: String
    var isEditing: Bool
    /// Extra pins (e.g. Finds on a trip map). Not editable here.
    var secondaryPins: [YamadoriMapPin] = []
    /// Degrees of latitude span when a primary pin exists.
    var focusedLatitudeDelta: Double = 0.08
    var mapHeight: CGFloat = 200

    @State private var cameraPosition: MapCameraPosition = .region(Self.defaultRegion)

    private var primaryCoordinate: CLLocationCoordinate2D? {
        guard let latitude, let longitude else { return nil }
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    var body: some View {
        DetailCard(title: title) {
            MapReader { proxy in
                Map(position: $cameraPosition) {
                    if let primaryCoordinate {
                        Marker(primaryTitle, systemImage: "mappin.circle.fill", coordinate: primaryCoordinate)
                            .tint(BonsaiWorldColors.accent)
                    }
                    ForEach(secondaryPins) { pin in
                        Marker(pin.title, systemImage: pin.kind == .tripArea ? "mappin.circle.fill" : "leaf.fill", coordinate: pin.coordinate)
                            .tint(pin.kind == .find ? BonsaiWorldColors.statusPositive : BonsaiWorldColors.accent)
                    }
                }
                .mapStyle(.standard(elevation: .realistic))
                .frame(height: mapHeight)
                .clipShape(RoundedRectangle(cornerRadius: FaloRadius.small, style: .continuous))
                .onTapGesture { location in
                    guard isEditing else { return }
                    guard let coordinate = proxy.convert(location, from: .local) else { return }
                    latitude = coordinate.latitude
                    longitude = coordinate.longitude
                    cameraPosition = .region(region(around: coordinate, latitudeDelta: focusedLatitudeDelta))
                }
            }

            if isEditing {
                Text(primaryCoordinate == nil ? "Click the map to place a pin." : "Click the map to move the pin.")
                    .font(FaloTypography.caption)
                    .foregroundStyle(.secondary)
            } else if primaryCoordinate == nil, secondaryPins.isEmpty {
                Text("No coordinates yet.")
                    .font(FaloTypography.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .onAppear { syncCamera() }
        .onChange(of: latitude) { _, _ in syncCamera() }
        .onChange(of: longitude) { _, _ in syncCamera() }
    }

    private func syncCamera() {
        if let primaryCoordinate {
            cameraPosition = .region(region(around: primaryCoordinate, latitudeDelta: focusedLatitudeDelta))
            return
        }
        if let first = secondaryPins.first {
            cameraPosition = .region(region(around: first.coordinate, latitudeDelta: focusedLatitudeDelta))
            return
        }
        cameraPosition = .region(Self.defaultRegion)
    }

    private func region(around coordinate: CLLocationCoordinate2D, latitudeDelta: Double) -> MKCoordinateRegion {
        MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(latitudeDelta: latitudeDelta, longitudeDelta: latitudeDelta)
        )
    }

    /// Norway-centered fallback when nothing is pinned yet.
    private static var defaultRegion: MKCoordinateRegion {
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 62.0, longitude: 10.0),
            span: MKCoordinateSpan(latitudeDelta: 8.0, longitudeDelta: 8.0)
        )
    }
}
