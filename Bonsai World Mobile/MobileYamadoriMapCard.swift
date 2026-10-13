//
//  MobileYamadoriMapCard.swift
//  Bonsai World
//
//  Find precise pin — tap to place/move, Use Current Location.
//

import CoreLocation
import MapKit
import SwiftUI

struct MobileYamadoriMapCard: View {
    @Binding var latitude: Double?
    @Binding var longitude: Double?
    var primaryTitle: String
    var mapHeight: CGFloat = 220

    @State private var cameraPosition: MapCameraPosition = .region(Self.defaultRegion)
    @StateObject private var locationHelper = MobileLocationHelper()

    private var primaryCoordinate: CLLocationCoordinate2D? {
        guard let latitude, let longitude else { return nil }
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: FaloSpacing.small) {
            MapReader { proxy in
                Map(position: $cameraPosition) {
                    if let primaryCoordinate {
                        Marker(primaryTitle, systemImage: "mappin.circle.fill", coordinate: primaryCoordinate)
                            .tint(BonsaiWorldColors.accent)
                    }
                }
                .mapStyle(.standard)
                .frame(height: mapHeight)
                .clipShape(RoundedRectangle(cornerRadius: FaloRadius.small, style: .continuous))
                .onTapGesture { location in
                    guard let coordinate = proxy.convert(location, from: .local) else { return }
                    latitude = coordinate.latitude
                    longitude = coordinate.longitude
                    cameraPosition = .region(region(around: coordinate))
                }
            }

            Text(primaryCoordinate == nil ? "Tap the map to place a pin." : "Tap the map to move the pin.")
                .font(FaloTypography.caption)
                .foregroundStyle(BonsaiWorldColors.textSecondary)

            Button("Use Current Location") {
                locationHelper.requestAndLocate { coordinate in
                    latitude = coordinate.latitude
                    longitude = coordinate.longitude
                    cameraPosition = .region(region(around: coordinate, latitudeDelta: 0.01))
                }
            }
            .font(FaloTypography.body.weight(.semibold))
            .frame(maxWidth: .infinity, minHeight: 44, alignment: .leading)
            .accessibilityLabel("Use Current Location")

            if primaryCoordinate != nil {
                Button("Clear Pin") {
                    latitude = nil
                    longitude = nil
                    cameraPosition = .region(Self.defaultRegion)
                }
                .font(FaloTypography.body)
                .frame(maxWidth: .infinity, minHeight: 44, alignment: .leading)
                .accessibilityLabel("Clear Pin")
            }

            if let message = locationHelper.statusMessage {
                Text(message)
                    .font(FaloTypography.caption)
                    .foregroundStyle(BonsaiWorldColors.textTertiary)
            }
        }
        .onAppear { syncCamera() }
        .onChange(of: latitude) { _, _ in syncCamera() }
        .onChange(of: longitude) { _, _ in syncCamera() }
    }

    private func syncCamera() {
        if let primaryCoordinate {
            cameraPosition = .region(region(around: primaryCoordinate))
        } else {
            cameraPosition = .region(Self.defaultRegion)
        }
    }

    private func region(around coordinate: CLLocationCoordinate2D, latitudeDelta: Double = 0.08) -> MKCoordinateRegion {
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

@MainActor
private final class MobileLocationHelper: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var statusMessage: String?

    private let manager = CLLocationManager()
    private var onLocation: ((CLLocationCoordinate2D) -> Void)?

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
    }

    func requestAndLocate(onLocation: @escaping (CLLocationCoordinate2D) -> Void) {
        self.onLocation = onLocation
        statusMessage = nil
        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            manager.requestLocation()
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
        case .denied, .restricted:
            statusMessage = "Location access is off. Enable it in Settings."
        @unknown default:
            statusMessage = "Location is unavailable."
        }
    }

    nonisolated func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        Task { @MainActor in
            switch manager.authorizationStatus {
            case .authorizedAlways, .authorizedWhenInUse:
                self.manager.requestLocation()
            case .denied, .restricted:
                statusMessage = "Location access is off. Enable it in Settings."
            default:
                break
            }
        }
    }

    nonisolated func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let coordinate = locations.last?.coordinate else { return }
        Task { @MainActor in
            onLocation?(coordinate)
            onLocation = nil
            statusMessage = nil
        }
    }

    nonisolated func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        Task { @MainActor in
            statusMessage = "Could not read current location."
            onLocation = nil
        }
    }
}
