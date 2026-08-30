//
//  LocationMapView.swift
//  Bonsai World
//
//  Reusable MapKit map — Garden → Location → Tree hierarchy.
//  Single MapKit implementation. Do not duplicate MapKit code.
//

import AppKit
import MapKit
import SwiftUI

/// Native Apple MapKit surface with hierarchical markers, layers, and zoom visibility.
///
/// - Garden: large green circle (Garden Position / Map Center)
/// - Location: blue pin (owns Latitude / Longitude)
/// - Tree: small dark-green bonsai marker (inherits Location coordinates — no stored coords)
///
/// Tree hover shows Bonsai Name / Nickname / thumbnail. Click opens Tree Details via callback.
///
/// Future: species icons via ``LocationMapAnnotation/iconKey``, Work / Weather / Inventory layers.
struct LocationMapView: View {
    var annotations: [LocationMapAnnotation]
    @Binding var mapStyle: LocationMapStyle
    @Binding var camera: LocationMapCamera
    var focusRequest: LocationMapFocusRequest?
    var selectedAnnotationID: UUID?
    var layerConfiguration: MapLayerConfiguration = .default
    var allowsMapClickPlacement: Bool = true
    var onMapClick: ((GeographicCoordinate) -> Void)?
    var onAnnotationDrag: ((UUID, GeographicCoordinate) -> Void)?
    var onAnnotationSelect: ((LocationMapAnnotation) -> Void)?
    var onZoomBandChange: ((MapZoomBand) -> Void)?
    /// Loads original image bytes for Tree hover thumbnails.
    var loadThumbnailData: ((UUID) async -> Data?)?

    var body: some View {
        LocationMapKitRepresentable(
            annotations: annotations,
            mapStyle: mapStyle,
            camera: $camera,
            focusRequest: focusRequest,
            selectedAnnotationID: selectedAnnotationID,
            layerConfiguration: layerConfiguration,
            allowsMapClickPlacement: allowsMapClickPlacement,
            onMapClick: onMapClick,
            onAnnotationDrag: onAnnotationDrag,
            onAnnotationSelect: onAnnotationSelect,
            onZoomBandChange: onZoomBandChange,
            loadThumbnailData: loadThumbnailData
        )
    }
}

// MARK: - MapKit bridge (sole MapKit implementation)

private struct LocationMapKitRepresentable: NSViewRepresentable {
    var annotations: [LocationMapAnnotation]
    var mapStyle: LocationMapStyle
    @Binding var camera: LocationMapCamera
    var focusRequest: LocationMapFocusRequest?
    var selectedAnnotationID: UUID?
    var layerConfiguration: MapLayerConfiguration
    var allowsMapClickPlacement: Bool
    var onMapClick: ((GeographicCoordinate) -> Void)?
    var onAnnotationDrag: ((UUID, GeographicCoordinate) -> Void)?
    var onAnnotationSelect: ((LocationMapAnnotation) -> Void)?
    var onZoomBandChange: ((MapZoomBand) -> Void)?
    var loadThumbnailData: ((UUID) async -> Data?)?

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeNSView(context: Context) -> MKMapView {
        let mapView = MKMapView(frame: .zero)
        mapView.delegate = context.coordinator
        mapView.showsZoomControls = true
        mapView.showsCompass = true
        mapView.showsScale = true
        mapView.isZoomEnabled = true
        mapView.isScrollEnabled = true
        mapView.isRotateEnabled = true
        mapView.isPitchEnabled = false

        let click = NSClickGestureRecognizer(
            target: context.coordinator,
            action: #selector(Coordinator.handleMapClick(_:))
        )
        click.numberOfClicksRequired = 1
        mapView.addGestureRecognizer(click)

        applyStyle(mapStyle, to: mapView)
        applyCamera(camera, to: mapView, animated: false)
        context.coordinator.currentBand = MapZoomBand.from(visibleMeters: camera.visibleMeters)
        syncAnnotations(on: mapView, coordinator: context.coordinator)
        return mapView
    }

    func updateNSView(_ mapView: MKMapView, context: Context) {
        context.coordinator.parent = self
        applyStyle(mapStyle, to: mapView)

        if context.coordinator.lastFocusToken != focusRequest?.token,
           let focusRequest {
            context.coordinator.lastFocusToken = focusRequest.token
            applyCamera(focusRequest.camera, to: mapView, animated: true)
            camera = focusRequest.camera
            let band = MapZoomBand.from(visibleMeters: focusRequest.camera.visibleMeters)
            if band != context.coordinator.currentBand {
                context.coordinator.currentBand = band
                onZoomBandChange?(band)
            }
        }

        syncAnnotations(on: mapView, coordinator: context.coordinator)
        syncSelection(on: mapView)
    }

    private func applyStyle(_ style: LocationMapStyle, to mapView: MKMapView) {
        let desired: MKMapType
        switch style {
        case .standard: desired = .standard
        case .satellite: desired = .satellite
        case .hybrid: desired = .hybrid
        }
        if mapView.mapType != desired {
            mapView.mapType = desired
        }
    }

    private func applyCamera(_ camera: LocationMapCamera, to mapView: MKMapView, animated: Bool) {
        let coordinate = camera.center.clLocationCoordinate
        let region = MKCoordinateRegion(
            center: coordinate,
            latitudinalMeters: camera.visibleMeters,
            longitudinalMeters: camera.visibleMeters
        )
        mapView.setRegion(region, animated: animated)
    }

    private func visibleAnnotations(band: MapZoomBand) -> [LocationMapAnnotation] {
        annotations.filter {
            band.includes($0.level) && layerConfiguration.includes($0.level)
        }
    }

    private func syncAnnotations(on mapView: MKMapView, coordinator: Coordinator) {
        let desired = visibleAnnotations(band: coordinator.currentBand)
        let desiredIDs = Set(desired.map(\.id))
        let existing = mapView.annotations.compactMap { $0 as? LocationMapPointAnnotation }

        for annotation in existing where !desiredIDs.contains(annotation.annotationID) {
            mapView.removeAnnotation(annotation)
        }

        let remaining = mapView.annotations.compactMap { $0 as? LocationMapPointAnnotation }
        let remainingByID = Dictionary(uniqueKeysWithValues: remaining.map { ($0.annotationID, $0) })

        for model in desired {
            let coordinate = model.coordinate.clLocationCoordinate
            if let annotation = remainingByID[model.id] {
                if !coordinator.isDragging {
                    if annotation.coordinate.latitude != coordinate.latitude
                        || annotation.coordinate.longitude != coordinate.longitude {
                        annotation.coordinate = coordinate
                    }
                }
                annotation.title = model.title
                annotation.subtitle = model.subtitle
                annotation.model = model
                refreshView(for: annotation, on: mapView)
            } else {
                let annotation = LocationMapPointAnnotation(model: model, coordinate: coordinate)
                mapView.addAnnotation(annotation)
            }
        }
    }

    private func refreshView(for annotation: LocationMapPointAnnotation, on mapView: MKMapView) {
        guard let view = mapView.view(for: annotation) else { return }
        configure(view, with: annotation.model, on: mapView)
    }

    private func syncSelection(on mapView: MKMapView) {
        let points = mapView.annotations.compactMap { $0 as? LocationMapPointAnnotation }
        if let selectedAnnotationID,
           let selected = points.first(where: { $0.annotationID == selectedAnnotationID }) {
            if mapView.selectedAnnotations.contains(where: {
                ($0 as? LocationMapPointAnnotation)?.annotationID == selectedAnnotationID
            }) == false {
                mapView.selectAnnotation(selected, animated: true)
            }
        }
    }

    private func configure(_ view: MKAnnotationView, with model: LocationMapAnnotation, on mapView: MKMapView) {
        view.isDraggable = model.isDraggable
        view.canShowCallout = model.level != .tree
        view.displayPriority = model.isHighlighted ? .required : .defaultHigh

        switch model.level {
        case .garden:
            if let circle = view as? HierarchyCircleAnnotationView {
                circle.apply(model: model)
            }
        case .location:
            if let marker = view as? MKMarkerAnnotationView {
                marker.markerTintColor = model.isHighlighted
                    ? NSColor.systemBlue.blended(withFraction: 0.25, of: .white) ?? .systemBlue
                    : .systemBlue
                marker.glyphImage = NSImage(systemSymbolName: "mappin", accessibilityDescription: nil)
                marker.titleVisibility = .adaptive
                marker.subtitleVisibility = .adaptive
            }
        case .tree:
            if let bonsai = view as? BonsaiAnnotationView {
                bonsai.loadThumbnailData = loadThumbnailData
                bonsai.tooltipHost = mapView
                bonsai.apply(model: model)
            }
        case .work:
            if let marker = view as? MKMarkerAnnotationView {
                marker.markerTintColor = .systemOrange
                marker.glyphImage = NSImage(systemSymbolName: "wrench", accessibilityDescription: nil)
            }
        }
    }

    final class Coordinator: NSObject, MKMapViewDelegate {
        var parent: LocationMapKitRepresentable
        var lastFocusToken: UUID?
        var isDragging = false
        var currentBand: MapZoomBand = .medium

        init(parent: LocationMapKitRepresentable) {
            self.parent = parent
        }

        @objc func handleMapClick(_ gesture: NSClickGestureRecognizer) {
            guard parent.allowsMapClickPlacement else { return }
            guard let mapView = gesture.view as? MKMapView else { return }
            guard gesture.state == .ended else { return }

            let point = gesture.location(in: mapView)
            for annotation in mapView.annotations {
                guard let view = mapView.view(for: annotation) else { continue }
                let local = gesture.location(in: view)
                if view.bounds.insetBy(dx: -10, dy: -10).contains(local) {
                    return
                }
            }

            let coordinate = mapView.convert(point, toCoordinateFrom: mapView)
            parent.onMapClick?(GeographicCoordinate(
                latitude: coordinate.latitude,
                longitude: coordinate.longitude
            ))
        }

        func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
            // Deferred: `updateNSView` calls `setRegion` (via `applyCamera`), which triggers
            // this delegate method synchronously — writing straight into `parent.camera`
            // here would mutate SwiftUI state mid-update (and can spin forever, since the
            // resulting re-render can trigger another region change). Push to the next run
            // loop turn so the write always lands after SwiftUI's current update finishes.
            DispatchQueue.main.async { [weak self, weak mapView] in
                guard let self, let mapView else { return }
                let meters = self.approximateVisibleMeters(for: mapView.region)
                self.parent.camera = LocationMapCamera(
                    center: GeographicCoordinate(
                        latitude: mapView.region.center.latitude,
                        longitude: mapView.region.center.longitude
                    ),
                    visibleMeters: meters
                )
                let band = MapZoomBand.from(visibleMeters: meters)
                guard band != self.currentBand else { return }
                self.currentBand = band
                self.parent.onZoomBandChange?(band)
                self.parent.syncAnnotations(on: mapView, coordinator: self)
            }
        }

        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            guard let point = annotation as? LocationMapPointAnnotation else { return nil }
            let model = point.model

            switch model.level {
            case .garden:
                let reuseID = "HierarchyGarden"
                let view = (mapView.dequeueReusableAnnotationView(withIdentifier: reuseID) as? HierarchyCircleAnnotationView)
                    ?? HierarchyCircleAnnotationView(annotation: point, reuseIdentifier: reuseID)
                view.annotation = point
                view.apply(model: model)
                return view

            case .location:
                let reuseID = "HierarchyLocation"
                let view = (mapView.dequeueReusableAnnotationView(withIdentifier: reuseID) as? MKMarkerAnnotationView)
                    ?? MKMarkerAnnotationView(annotation: point, reuseIdentifier: reuseID)
                view.annotation = point
                parent.configure(view, with: model, on: mapView)
                return view

            case .tree:
                let reuseID = "HierarchyTree"
                let view = (mapView.dequeueReusableAnnotationView(withIdentifier: reuseID) as? BonsaiAnnotationView)
                    ?? BonsaiAnnotationView(annotation: point, reuseIdentifier: reuseID)
                view.annotation = point
                view.loadThumbnailData = parent.loadThumbnailData
                view.tooltipHost = mapView
                view.apply(model: model)
                return view

            case .work:
                let reuseID = "HierarchyWork"
                let view = (mapView.dequeueReusableAnnotationView(withIdentifier: reuseID) as? MKMarkerAnnotationView)
                    ?? MKMarkerAnnotationView(annotation: point, reuseIdentifier: reuseID)
                view.annotation = point
                parent.configure(view, with: model, on: mapView)
                return view
            }
        }

        func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
            guard let point = view.annotation as? LocationMapPointAnnotation else { return }
            // Deferred: `updateNSView`'s `syncSelection()` calls `selectAnnotation(_:animated:)`,
            // which triggers this delegate method synchronously — calling straight into
            // `onAnnotationSelect` (which sets SwiftUI state) here would mutate state mid-update.
            // Same fix as `regionDidChangeAnimated` above.
            let model = point.model
            DispatchQueue.main.async { [weak self] in
                self?.parent.onAnnotationSelect?(model)
            }
        }

        func mapView(
            _ mapView: MKMapView,
            annotationView view: MKAnnotationView,
            didChange newState: MKAnnotationView.DragState,
            fromOldState oldState: MKAnnotationView.DragState
        ) {
            switch newState {
            case .starting:
                isDragging = true
            case .ending, .canceling:
                isDragging = false
                view.dragState = .none
                guard let point = view.annotation as? LocationMapPointAnnotation else { return }
                parent.onAnnotationDrag?(
                    point.annotationID,
                    GeographicCoordinate(
                        latitude: point.coordinate.latitude,
                        longitude: point.coordinate.longitude
                    )
                )
            default:
                break
            }
        }

        private func approximateVisibleMeters(for region: MKCoordinateRegion) -> Double {
            let centerLat = region.center.latitude * .pi / 180
            let metersPerDegreeLat = 111_320.0
            let height = region.span.latitudeDelta * metersPerDegreeLat
            let width = region.span.longitudeDelta * 111_320.0 * cos(centerLat)
            return max(height, width)
        }
    }
}

// MARK: - Annotation model bridge

private final class LocationMapPointAnnotation: MKPointAnnotation {
    var model: LocationMapAnnotation

    var annotationID: UUID { model.id }

    init(model: LocationMapAnnotation, coordinate: CLLocationCoordinate2D) {
        self.model = model
        super.init()
        self.coordinate = coordinate
        self.title = model.title
        self.subtitle = model.subtitle
    }
}

// MARK: - Garden marker (large green circle)

private final class HierarchyCircleAnnotationView: MKAnnotationView {
    private let circleLayer = CALayer()

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        wantsLayer = true
        layer?.addSublayer(circleLayer)
        centerOffset = .zero
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func apply(model: LocationMapAnnotation) {
        let size: CGFloat = model.isHighlighted ? 36 : 30
        frame = CGRect(x: 0, y: 0, width: size, height: size)
        centerOffset = .zero
        circleLayer.frame = bounds
        circleLayer.cornerRadius = size / 2
        circleLayer.backgroundColor = NSColor.systemGreen.cgColor
        circleLayer.borderWidth = model.isHighlighted ? 3 : 2
        circleLayer.borderColor = NSColor.white.cgColor
        circleLayer.shadowOpacity = 0.35
        circleLayer.shadowRadius = 2
        circleLayer.shadowOffset = CGSize(width: 0, height: 1)
        canShowCallout = true
        isDraggable = model.isDraggable
        displayPriority = .required
    }
}

// MARK: - Tree marker (small dark-green bonsai — not Apple pin)

private final class BonsaiAnnotationView: MKAnnotationView {
    private let disc = CALayer()
    private let imageView = NSImageView()
    private var hoverInfo: MapTreeHoverInfo?
    private var tooltipView: TreeHoverTooltipView?
    private var loadTask: Task<Void, Never>?

    var loadThumbnailData: ((UUID) async -> Data?)?
    weak var tooltipHost: NSView?

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        wantsLayer = true
        layer?.addSublayer(disc)
        imageView.imageScaling = .scaleProportionallyUpOrDown
        imageView.contentTintColor = .white
        addSubview(imageView)
        centerOffset = .zero
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func apply(model: LocationMapAnnotation) {
        // Future: resolve model.iconKey to a species-specific glyph.
        let size: CGFloat = model.isHighlighted ? 22 : 18
        frame = CGRect(x: 0, y: 0, width: size, height: size)
        centerOffset = .zero

        disc.frame = bounds
        disc.cornerRadius = size / 2
        disc.backgroundColor = NSColor(calibratedRed: 0.12, green: 0.42, blue: 0.22, alpha: 1).cgColor
        disc.borderWidth = model.isHighlighted ? 2 : 1
        disc.borderColor = NSColor.white.cgColor

        let inset = size * 0.22
        imageView.frame = bounds.insetBy(dx: inset, dy: inset)
        let symbolName = model.iconKey ?? "leaf.fill"
        imageView.image = NSImage(systemSymbolName: symbolName, accessibilityDescription: "Bonsai")
        imageView.contentTintColor = .white

        hoverInfo = model.treeHover
        // Hover owns the rich tooltip; avoid the default MapKit callout.
        canShowCallout = false
        isDraggable = false
        displayPriority = model.isHighlighted ? .required : .defaultHigh
        updateTrackingAreas()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        hideTooltip()
        hoverInfo = nil
        loadTask?.cancel()
        loadTask = nil
    }

    override func updateTrackingAreas() {
        super.updateTrackingAreas()
        trackingAreas.forEach { removeTrackingArea($0) }
        let area = NSTrackingArea(
            rect: bounds.insetBy(dx: -4, dy: -4),
            options: [.activeInKeyWindow, .mouseEnteredAndExited, .inVisibleRect],
            owner: self,
            userInfo: nil
        )
        addTrackingArea(area)
    }

    override func mouseEntered(with event: NSEvent) {
        super.mouseEntered(with: event)
        showTooltip()
    }

    override func mouseExited(with event: NSEvent) {
        super.mouseExited(with: event)
        hideTooltip()
    }

    private func showTooltip() {
        guard let hoverInfo, let host = tooltipHost else { return }
        hideTooltip()

        let tip = TreeHoverTooltipView(frame: .zero)
        tip.configure(
            bonsaiName: hoverInfo.bonsaiName,
            nickname: hoverInfo.nickname,
            thumbnail: nil
        )
        tip.translatesAutoresizingMaskIntoConstraints = true
        tip.wantsLayer = true
        host.addSubview(tip)
        tooltipView = tip
        positionTooltip(tip, in: host)

        if let imageID = hoverInfo.primaryImageID, let loader = loadThumbnailData {
            loadTask?.cancel()
            loadTask = Task { @MainActor in
                let data = await loader(imageID)
                guard !Task.isCancelled, let data, let image = NSImage(data: data) else { return }
                tip.configure(
                    bonsaiName: hoverInfo.bonsaiName,
                    nickname: hoverInfo.nickname,
                    thumbnail: image
                )
                positionTooltip(tip, in: host)
            }
        }
    }

    private func positionTooltip(_ tip: TreeHoverTooltipView, in host: NSView) {
        tip.layoutSubtreeIfNeeded()
        let size = tip.fittingSize
        tip.frame.size = size
        let markerInHost = convert(bounds, to: host)
        var origin = CGPoint(
            x: markerInHost.midX - size.width / 2,
            y: markerInHost.maxY + 8
        )
        origin.x = min(max(8, origin.x), host.bounds.width - size.width - 8)
        origin.y = min(max(8, origin.y), host.bounds.height - size.height - 8)
        tip.frame.origin = origin
    }

    private func hideTooltip() {
        loadTask?.cancel()
        loadTask = nil
        tooltipView?.removeFromSuperview()
        tooltipView = nil
    }
}

// MARK: - Tree hover tooltip (AppKit)

private final class TreeHoverTooltipView: NSView {
    private let thumbnailView = NSImageView()
    private let bonsaiLabel = NSTextField(labelWithString: "")
    private let nicknameLabel = NSTextField(labelWithString: "")
    private let stack = NSStackView()

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        wantsLayer = true
        layer?.cornerRadius = 8
        layer?.backgroundColor = NSColor.windowBackgroundColor.withAlphaComponent(0.96).cgColor
        layer?.borderWidth = 1
        layer?.borderColor = NSColor.separatorColor.cgColor
        layer?.shadowOpacity = 0.25
        layer?.shadowRadius = 6
        layer?.shadowOffset = CGSize(width: 0, height: -1)

        thumbnailView.imageScaling = .scaleProportionallyUpOrDown
        thumbnailView.wantsLayer = true
        thumbnailView.layer?.cornerRadius = 6
        thumbnailView.layer?.masksToBounds = true

        bonsaiLabel.font = .systemFont(ofSize: 12, weight: .semibold)
        bonsaiLabel.lineBreakMode = .byTruncatingTail
        nicknameLabel.font = .systemFont(ofSize: 11)
        nicknameLabel.textColor = .secondaryLabelColor
        nicknameLabel.lineBreakMode = .byTruncatingTail

        let textStack = NSStackView(views: [bonsaiLabel, nicknameLabel])
        textStack.orientation = .vertical
        textStack.alignment = .leading
        textStack.spacing = 2

        stack.orientation = .horizontal
        stack.alignment = .centerY
        stack.spacing = 8
        stack.edgeInsets = NSEdgeInsets(top: 8, left: 8, bottom: 8, right: 10)
        stack.addArrangedSubview(thumbnailView)
        stack.addArrangedSubview(textStack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stack)

        NSLayoutConstraint.activate([
            thumbnailView.widthAnchor.constraint(equalToConstant: 40),
            thumbnailView.heightAnchor.constraint(equalToConstant: 40),
            stack.leadingAnchor.constraint(equalTo: leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: trailingAnchor),
            stack.topAnchor.constraint(equalTo: topAnchor),
            stack.bottomAnchor.constraint(equalTo: bottomAnchor),
            widthAnchor.constraint(lessThanOrEqualToConstant: 240)
        ])
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(bonsaiName: String, nickname: String?, thumbnail: NSImage?) {
        bonsaiLabel.stringValue = bonsaiName.isEmpty ? "Untitled Tree" : bonsaiName
        if let nickname, !nickname.isEmpty {
            nicknameLabel.stringValue = nickname
            nicknameLabel.isHidden = false
        } else {
            nicknameLabel.stringValue = ""
            nicknameLabel.isHidden = true
        }
        if let thumbnail {
            thumbnailView.image = thumbnail
            thumbnailView.contentTintColor = nil
        } else {
            thumbnailView.image = NSImage(systemSymbolName: "leaf.fill", accessibilityDescription: "Bonsai")
            thumbnailView.contentTintColor = .secondaryLabelColor
        }
        needsLayout = true
    }

    override var fittingSize: NSSize {
        stack.fittingSize
    }
}

private extension GeographicCoordinate {
    var clLocationCoordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
