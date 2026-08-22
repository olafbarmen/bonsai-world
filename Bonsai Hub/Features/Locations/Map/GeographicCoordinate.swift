//
//  GeographicCoordinate.swift
//  Bonsai World
//
//  Platform-independent lat/long for Location geographic positions.
//  MapKit adapters convert to/from CLLocationCoordinate2D at the UI boundary.
//  Trees never store coordinates — they reference Locations.
//

import Foundation

/// A point on Earth. Domain model — no MapKit types.
struct GeographicCoordinate: Hashable, Codable, Sendable {
    var latitude: Double
    var longitude: Double

    /// Default map framing when a Location has no position yet.
    static let defaultMapCenter = GeographicCoordinate(
        latitude: 59.9228,
        longitude: 10.7510
    )

    var isValid: Bool {
        (-90...90).contains(latitude) && (-180...180).contains(longitude)
    }
}

/// Optional geographic position owned by a Location.
struct GeographicPosition: Hashable, Codable, Sendable {
    var latitude: Double
    var longitude: Double
    var lastUpdated: Date

    init(latitude: Double, longitude: Double, lastUpdated: Date = .now) {
        self.latitude = latitude
        self.longitude = longitude
        self.lastUpdated = lastUpdated
    }

    init(coordinate: GeographicCoordinate, lastUpdated: Date = .now) {
        self.latitude = coordinate.latitude
        self.longitude = coordinate.longitude
        self.lastUpdated = lastUpdated
    }

    var coordinate: GeographicCoordinate {
        GeographicCoordinate(latitude: latitude, longitude: longitude)
    }
}
