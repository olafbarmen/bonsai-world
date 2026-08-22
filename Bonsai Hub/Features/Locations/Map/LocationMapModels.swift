//
//  LocationMapModels.swift
//  Bonsai World
//
//  Shared map presentation models for LocationMapView.
//
//  Hierarchy (Single Source of Truth):
//    User → Gardens → Locations → Trees
//
//  Gardens own Address + Garden Position (Map Center).
//  Locations own Latitude / Longitude.
//  Trees inherit display position from their assigned Location — no stored coordinates.
//  Collections are logical groups; they never own geographic position (filter only).
//

import Foundation

/// Visual map base layer. Maps to MKMapType at the MapKit boundary.
enum LocationMapStyle: String, CaseIterable, Identifiable, Sendable {
    case standard
    case satellite
    case hybrid

    var id: Self { self }

    var title: String {
        switch self {
        case .standard: "Standard"
        case .satellite: "Satellite"
        case .hybrid: "Hybrid"
        }
    }
}

/// Hierarchy level for map markers. Colour, size, and zoom visibility follow this level.
enum MapHierarchyLevel: String, Hashable, Codable, Sendable {
    case garden
    case location
    case tree
    /// Reserved for future Work navigation markers.
    case work
}

/// Map content layers. Coordinates remain owned by Garden / Location only.
enum MapContentLayer: String, CaseIterable, Identifiable, Sendable {
    case gardens
    case locations
    case trees
    case collectionFilter
    /// Future — do not implement yet.
    case work
    /// Future — do not implement yet.
    case weather
    /// Future — do not implement yet.
    case inventory

    var id: Self { self }

    var title: String {
        switch self {
        case .gardens: "Gardens"
        case .locations: "Locations"
        case .trees: "Trees"
        case .collectionFilter: "Collection Filter"
        case .work: "Work"
        case .weather: "Weather"
        case .inventory: "Inventory"
        }
    }

    /// Layers available in the current product surface.
    var isAvailable: Bool {
        switch self {
        case .gardens, .locations, .trees, .collectionFilter:
            true
        case .work, .weather, .inventory:
            false
        }
    }
}

/// Toggleable layer state + optional Collection filter.
///
/// Collection Filter never assigns coordinates — it only limits which Tree markers
/// (derived from Location positions) are shown.
struct MapLayerConfiguration: Equatable, Sendable {
    var showsGardens: Bool = true
    var showsLocations: Bool = true
    var showsTrees: Bool = true
    /// `nil` = show all Trees. Otherwise only Trees belonging to that Collection.
    var collectionFilterID: UUID?

    static let `default` = MapLayerConfiguration()

    func includes(_ level: MapHierarchyLevel) -> Bool {
        switch level {
        case .garden: showsGardens
        case .location: showsLocations
        case .tree: showsTrees
        case .work: false
        }
    }
}

/// Zoom bands that control which hierarchy levels are visible.
enum MapZoomBand: String, Hashable, Sendable {
    /// Far — Garden only.
    case far
    /// Medium — Garden + Locations.
    case medium
    /// Close — Garden + Locations + Trees.
    case close

    /// Approximate visible width thresholds (metres).
    static func from(visibleMeters: Double) -> MapZoomBand {
        if visibleMeters > 2_500 { return .far }
        if visibleMeters > 400 { return .medium }
        return .close
    }

    func includes(_ level: MapHierarchyLevel) -> Bool {
        switch self {
        case .far:
            level == .garden
        case .medium:
            level == .garden || level == .location
        case .close:
            true
        }
    }
}

/// One marker on ``LocationMapView``.
///
/// Garden / Location / Tree each own their marker presentation.
/// Tree markers use the Location’s coordinate (optionally offset for display only).
///
/// Future: species icons (`iconKey`), clustering, Work / route / inventory overlays.
struct LocationMapAnnotation: Identifiable, Hashable, Sendable {
    var id: UUID
    var title: String
    /// Callout / status subtitle (e.g. Location tree count).
    var subtitle: String?
    var coordinate: GeographicCoordinate
    var level: MapHierarchyLevel
    var isDraggable: Bool
    var isHighlighted: Bool
    /// Future species / Work icon key. `nil` → generic marker for the level.
    var iconKey: String?
    /// Tree marker hover tooltip (Tree markers only).
    var treeHover: MapTreeHoverInfo?

    init(
        id: UUID,
        title: String,
        subtitle: String? = nil,
        coordinate: GeographicCoordinate,
        level: MapHierarchyLevel,
        isDraggable: Bool = false,
        isHighlighted: Bool = false,
        iconKey: String? = nil,
        treeHover: MapTreeHoverInfo? = nil
    ) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
        self.level = level
        self.isDraggable = isDraggable
        self.isHighlighted = isHighlighted
        self.iconKey = iconKey
        self.treeHover = treeHover
    }
}

/// Hover tooltip payload for a Tree marker. No coordinates — Tree identity only.
struct MapTreeHoverInfo: Hashable, Sendable {
    var bonsaiName: String
    var nickname: String?
    /// Primary image asset id. `nil` → default Bonsai icon.
    var primaryImageID: UUID?
}

/// Camera / framing request for the reusable map.
struct LocationMapCamera: Equatable, Sendable {
    var center: GeographicCoordinate
    /// Approximate visible width in meters (garden-scale by default).
    var visibleMeters: Double

    static let defaultGarden = LocationMapCamera(
        center: .defaultMapCenter,
        visibleMeters: 1_200
    )
}

/// One-shot focus pulse. Changing `token` re-applies framing for the same coordinate.
struct LocationMapFocusRequest: Equatable, Sendable {
    var token: UUID
    var camera: LocationMapCamera

    init(camera: LocationMapCamera, token: UUID = UUID()) {
        self.token = token
        self.camera = camera
    }
}

/// Map / inspector selection state.
///
/// Prepared for future multi-selection, batch Work / watering / fertilizing,
/// and drag-and-drop between Locations — not implemented yet.
struct LocationMapSelection: Hashable, Sendable {
    var locationID: UUID?
    /// Future multi-select of Tree markers / inspector rows.
    var treeIDs: Set<UUID> = []
    /// Legacy annotation set for batch / clustering experiments.
    var annotationIDs: Set<UUID> = []
}

// MARK: - Display helpers (no stored Tree coordinates)

enum MapDisplayCoordinate {
    /// Fans Trees around a Location coordinate for readability only.
    /// Does not persist — Trees still inherit the Location’s geographic position.
    static func offset(
        from base: GeographicCoordinate,
        index: Int,
        count: Int,
        radiusMeters: Double = 5
    ) -> GeographicCoordinate {
        guard count > 1 else { return base }
        let angle = (2 * Double.pi * Double(index)) / Double(count)
        let metersPerDegreeLat = 111_320.0
        let metersPerDegreeLon = 111_320.0 * cos(base.latitude * .pi / 180)
        let dLat = (radiusMeters * sin(angle)) / metersPerDegreeLat
        let dLon = (radiusMeters * cos(angle)) / max(metersPerDegreeLon, 1)
        return GeographicCoordinate(
            latitude: base.latitude + dLat,
            longitude: base.longitude + dLon
        )
    }
}
