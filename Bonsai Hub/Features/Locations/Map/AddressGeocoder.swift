//
//  AddressGeocoder.swift
//  Bonsai World
//
//  Forward-geocodes a garden / home address for Location map framing.
//  Does not require device location permission.
//

import CoreLocation
import Foundation

enum AddressGeocoder {
    enum GeocodeError: Error {
        case emptyAddress
        case notFound
    }

    /// Resolves an address string to a coordinate. Safe to call from the MainActor.
    static func coordinate(for address: String) async throws -> GeographicCoordinate {
        let trimmed = address.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { throw GeocodeError.emptyAddress }

        return try await withCheckedThrowingContinuation { continuation in
            let geocoder = CLGeocoder()
            geocoder.geocodeAddressString(trimmed) { placemarks, error in
                if let error {
                    continuation.resume(throwing: error)
                    return
                }
                guard let location = placemarks?.first?.location else {
                    continuation.resume(throwing: GeocodeError.notFound)
                    return
                }
                continuation.resume(
                    returning: GeographicCoordinate(
                        latitude: location.coordinate.latitude,
                        longitude: location.coordinate.longitude
                    )
                )
            }
        }
    }
}
