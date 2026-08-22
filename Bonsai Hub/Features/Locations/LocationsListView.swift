//
//  LocationsListView.swift
//  Bonsai World
//
//  Habitat domain (working name) — Garden map and Locations browser.
//  Domain terminology: ``WorkingDomainID/habitat``.
//
//  Hierarchy: User → Gardens → Locations → Trees
//  Gardens own Address + Position (Map Center).
//  Locations own Latitude / Longitude (+ environment profile).
//  Trees inherit map position from Location (no stored coordinates).
//  Collections filter Trees only — never own geography.
//

import SwiftUI

struct LocationsListView: View {
    @Environment(AppState.self) private var appState
    @Environment(UserProfileStore.self) private var profile
    @Environment(ReferenceDataService.self) private var referenceData
    @Environment(ReferenceDataManager.self) private var manager
    @Environment(TreeService.self) private var treeService
    @Environment(ImageService.self) private var imageService

    @State private var mapStyle: LocationMapStyle = .standard
    @State private var camera: LocationMapCamera = .defaultGarden
    @State private var focusRequest: LocationMapFocusRequest?
    @State private var statusMessage: String?
    @State private var zoomBand: MapZoomBand = .medium
    @State private var layers = MapLayerConfiguration.default
    @State private var selectedGardenID: UUID?
    @State private var selectedMapTreeID: UUID?
    @State private var hasAppliedGardenCamera = false
    @State private var framedDefaultGardenID: UUID?

    private var defaultGarden: Garden? {
        _ = profile.revision
        return profile.defaultGarden
    }

    private var locations: [LocationReference] {
        _ = referenceData.locations
        _ = manager.revision
        _ = profile.revision
        let all = referenceData.locations
        guard let gardenID = defaultGarden?.id else { return all }
        return all.filter { $0.gardenID == gardenID }
    }

    private var selectedLocation: LocationReference? {
        guard let id = appState.selectedLocationID else { return nil }
        return referenceData.location(id: id)
    }

    private var selectedAnnotationID: UUID? {
        selectedMapTreeID ?? appState.selectedLocationID ?? selectedGardenID
    }

    private var collectionFilterID: UUID? {
        layers.collectionFilterID
    }

    /// Trees at a Location, optionally limited by Collection Filter.
    private func visibleTrees(at locationID: UUID) -> [Tree] {
        _ = treeService.trees
        let trees = treeService.trees(at: locationID)
        guard let collectionFilterID else { return trees }
        let memberIDs = Set(treeService.trees(inCollection: collectionFilterID).map(\.id))
        return trees.filter { memberIDs.contains($0.id) }
    }

    private var mapAnnotations: [LocationMapAnnotation] {
        _ = treeService.trees
        var pins: [LocationMapAnnotation] = []

        if layers.showsGardens,
           let garden = defaultGarden,
           let coordinate = garden.mapCenter {
            pins.append(
                LocationMapAnnotation(
                    id: garden.id,
                    title: garden.name,
                    subtitle: garden.isDefault ? "Default Garden" : "Garden",
                    coordinate: coordinate,
                    level: .garden,
                    isHighlighted: selectedGardenID == garden.id
                )
            )
        }

        for location in locations {
            guard let coordinate = location.geographicPosition?.coordinate else { continue }
            let trees = visibleTrees(at: location.id)
            let treeCount = trees.count
            let isSelected = location.id == appState.selectedLocationID

            if layers.showsLocations {
                pins.append(
                    LocationMapAnnotation(
                        id: location.id,
                        title: location.name,
                        subtitle: treeCount == 1 ? "1 Tree" : "\(treeCount) Trees",
                        coordinate: coordinate,
                        level: .location,
                        isDraggable: isSelected,
                        isHighlighted: isSelected
                    )
                )
            }

            guard layers.showsTrees else { continue }

            for (index, tree) in trees.enumerated() {
                let display = MapDisplayCoordinate.offset(
                    from: coordinate,
                    index: index,
                    count: trees.count
                )
                pins.append(
                    LocationMapAnnotation(
                        id: tree.id,
                        title: TreePresentation.title(for: tree),
                        subtitle: location.name,
                        coordinate: display,
                        level: .tree,
                        isHighlighted: selectedMapTreeID == tree.id,
                        iconKey: nil, // Future: species icon key
                        treeHover: MapTreeHoverInfo(
                            bonsaiName: {
                                let name = tree.bonsaiName.trimmingCharacters(in: .whitespacesAndNewlines)
                                return name.isEmpty ? TreePresentation.title(for: tree) : name
                            }(),
                            nickname: TreePresentation.nicknameIfPresent(for: tree),
                            primaryImageID: tree.primaryImageID
                        )
                    )
                )
            }
        }

        return pins
    }

    var body: some View {
        @Bindable var appState = appState

        VStack(spacing: 0) {
            mapPane
                .frame(minHeight: 220)
                .frame(maxHeight: .infinity)

            Divider()

            bottomPane(selection: $appState.selectedLocationID)
                .frame(minHeight: 180)
                .frame(maxHeight: .infinity)
        }
        .navigationTitle("Locations")
        .navigationSplitViewColumnWidth(min: 280, ideal: 360, max: 480)
        .onChange(of: appState.selectedLocationID) { _, newID in
            selectedMapTreeID = nil
            if newID != nil {
                selectedGardenID = nil
            }
            focusSelectedLocation(id: newID)
            updateLocationStatus()
        }
        .onChange(of: appState.pendingLocationMapFocusID) { _, focusID in
            guard let focusID else { return }
            selectedMapTreeID = nil
            selectedGardenID = nil
            focusSelectedLocation(id: focusID, forceZoom: true)
            appState.clearPendingLocationMapFocus()
            updateLocationStatus()
        }
        .onChange(of: profile.revision) { _, _ in
            let gardenID = profile.defaultGarden?.id
            if gardenID != framedDefaultGardenID {
                hasAppliedGardenCamera = false
                Task { await applyInitialMapCamera() }
            }
        }
        .onChange(of: layers.collectionFilterID) { _, _ in
            updateLocationStatus()
        }
        .task {
            if let focusID = appState.pendingLocationMapFocusID {
                focusSelectedLocation(id: focusID, forceZoom: true)
                appState.clearPendingLocationMapFocus()
            } else {
                await applyInitialMapCamera()
            }
        }
    }

    private var needsGardenPlacement: Bool {
        guard let garden = defaultGarden else { return false }
        return !garden.hasGardenPosition
    }

    private var mapPane: some View {
        VStack(spacing: 0) {
            LocationMapView(
                annotations: mapAnnotations,
                mapStyle: $mapStyle,
                camera: $camera,
                focusRequest: focusRequest,
                selectedAnnotationID: selectedAnnotationID,
                layerConfiguration: layers,
                allowsMapClickPlacement: needsGardenPlacement
                    || (selectedLocation != nil && zoomBand != .far),
                onMapClick: { coordinate in
                    if needsGardenPlacement {
                        placeGardenPosition(at: coordinate)
                    } else {
                        placeOrMoveSelectedPin(at: coordinate)
                    }
                },
                onAnnotationDrag: { id, coordinate in
                    guard id == appState.selectedLocationID else { return }
                    manager.updateLocationPosition(
                        id: id,
                        position: GeographicPosition(coordinate: coordinate, lastUpdated: .now)
                    )
                    statusMessage = "Position updated for \(selectedLocation?.name ?? "Location")."
                },
                onAnnotationSelect: { annotation in
                    handleMapSelection(annotation)
                },
                onZoomBandChange: { band in
                    zoomBand = band
                },
                loadThumbnailData: { imageID in
                    try? await imageService.loadOriginalData(for: imageID)
                }
            )

            mapChrome
        }
        .background(.windowBackground)
    }

    private var mapChrome: some View {
        VStack(alignment: .leading, spacing: FaloSpacing.small) {
            HStack(spacing: FaloSpacing.medium) {
                Picker("Map View", selection: $mapStyle) {
                    ForEach(LocationMapStyle.allCases) { style in
                        Text(style.title).tag(style)
                    }
                }
                .pickerStyle(.segmented)
                .frame(maxWidth: 280)

                Text(zoomLegend)
                    .font(FaloTypography.caption)
                    .foregroundStyle(.secondary)

                Spacer(minLength: 0)

                if let statusMessage {
                    Text(statusMessage)
                        .font(FaloTypography.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }
            }

            HStack(spacing: FaloSpacing.medium) {
                layerMenu

                Picker("Collection", selection: $layers.collectionFilterID) {
                    Text("All Trees").tag(Optional<UUID>.none)
                    ForEach(treeService.collections) { collection in
                        Text(collection.name).tag(Optional(collection.id))
                    }
                }
                .pickerStyle(.menu)
                .frame(maxWidth: 220)
                .help("Collection Filter — shows only Trees in the chosen Collection. Positions still come from each Tree’s Location.")

                Spacer(minLength: 0)
            }
        }
        .padding(.horizontal, FaloSpacing.medium)
        .padding(.vertical, FaloSpacing.small)
        .background(.windowBackground)
    }

    private var layerMenu: some View {
        Menu {
            Toggle("Gardens", isOn: $layers.showsGardens)
            Toggle("Locations", isOn: $layers.showsLocations)
            Toggle("Trees", isOn: $layers.showsTrees)
            Divider()
            Text("Future layers")
            Text("Work").foregroundStyle(.secondary)
            Text("Weather").foregroundStyle(.secondary)
            Text("Inventory").foregroundStyle(.secondary)
        } label: {
            Label("Layers", systemImage: "square.3.layers.3d")
        }
        .menuStyle(.borderlessButton)
        .help("Map layers. Gardens / Locations / Trees are available. Work, Weather, and Inventory are reserved.")
    }

    private var zoomLegend: String {
        switch zoomBand {
        case .far: "Garden"
        case .medium: "Garden · Locations"
        case .close: "Garden · Locations · Trees"
        }
    }

    @ViewBuilder
    private func bottomPane(selection: Binding<UUID?>) -> some View {
        if let location = selectedLocation {
            locationSelectionPane(location)
        } else {
            locationsListPane(selection: selection)
        }
    }

    private func locationsListPane(selection: Binding<UUID?>) -> some View {
        List(locations, selection: selection) { location in
            LabeledContent {
                HStack(spacing: FaloSpacing.small) {
                    if location.hasGeographicPosition {
                        Image(systemName: "mappin.circle.fill")
                            .foregroundStyle(.blue)
                            .help("Has map position")
                    }
                    Text(visibleTrees(at: location.id).count, format: .number)
                        .foregroundStyle(.secondary)
                }
            } label: {
                Text(location.name)
            }
            .tag(location.id)
        }
        .faloScrollSurface()
        .overlay {
            if locations.isEmpty {
                ContentUnavailableView(
                    "No Locations",
                    systemImage: "mappin.and.ellipse",
                    description: Text(
                        defaultGarden == nil
                            ? "Add a Garden in Settings → User Profile first."
                            : "Use Quick Actions → New Location to add one for \(defaultGarden?.name ?? "this Garden")."
                    )
                )
            }
        }
    }

    private func locationSelectionPane(_ location: LocationReference) -> some View {
        let trees = visibleTrees(at: location.id)

        return VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: FaloSpacing.medium) {
                Button {
                    appState.selectedLocationID = nil
                    selectedMapTreeID = nil
                } label: {
                    Label("Locations", systemImage: "chevron.left")
                }
                .buttonStyle(.borderless)

                Spacer(minLength: 0)
            }
            .padding(.horizontal, FaloSpacing.medium)
            .padding(.top, FaloSpacing.small)

            VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
                Text(location.name)
                    .font(FaloTypography.headline)
                Text(trees.count == 1 ? "1 Tree" : "\(trees.count) Trees")
                    .font(FaloTypography.caption)
                    .foregroundStyle(.secondary)
                if let collectionFilterID,
                   let name = treeService.collection(id: collectionFilterID)?.name {
                    Text("Filtered by \(name)")
                        .font(FaloTypography.caption)
                        .foregroundStyle(.tertiary)
                }
            }
            .padding(.horizontal, FaloSpacing.medium)
            .padding(.vertical, FaloSpacing.small)

            Divider()

            if trees.isEmpty {
                ContentUnavailableView(
                    "No Trees",
                    systemImage: "leaf",
                    description: Text(
                        collectionFilterID == nil
                            ? "No Trees are assigned to this Location."
                            : "No Trees in this Collection are assigned to this Location."
                    )
                )
            } else {
                List(trees, id: \.id) { tree in
                    Button {
                        openTree(tree)
                    } label: {
                        HStack {
                            VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
                                Text(TreePresentation.title(for: tree))
                                    .font(FaloTypography.body)
                                    .foregroundStyle(.primary)
                                if !tree.botanicalName.isEmpty {
                                    Text(tree.botanicalName)
                                        .font(FaloTypography.caption)
                                        .foregroundStyle(.secondary)
                                }
                            }
                            Spacer(minLength: 0)
                            Image(systemName: "chevron.right")
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(.tertiary)
                        }
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                }
                .faloScrollSurface()
            }
        }
        .background(.windowBackground)
    }

    private func handleMapSelection(_ annotation: LocationMapAnnotation) {
        switch annotation.level {
        case .garden:
            selectedGardenID = annotation.id
            selectedMapTreeID = nil
            appState.selectedLocationID = nil
            statusMessage = annotation.subtitle.map { "\(annotation.title) · \($0)" } ?? annotation.title

        case .location:
            selectedGardenID = nil
            selectedMapTreeID = nil
            appState.selectedLocationID = annotation.id
            updateLocationStatus()

        case .tree:
            if let tree = treeService.getTree(id: annotation.id) {
                openTree(tree)
            }

        case .work:
            break
        }
    }

    private func openTree(_ tree: Tree) {
        selectedGardenID = nil
        selectedMapTreeID = tree.id
        appState.selectedLocationID = tree.locationID
        statusMessage = "Opening \(TreePresentation.title(for: tree))…"
        appState.showTreeFromMap(treeID: tree.id)
    }

    private func updateLocationStatus() {
        guard let location = selectedLocation else { return }
        let count = visibleTrees(at: location.id).count
        let treesLabel = count == 1 ? "1 Tree" : "\(count) Trees"
        statusMessage = "\(location.name) · \(treesLabel)"
    }

    private func applyInitialMapCamera() async {
        if let id = appState.selectedLocationID,
           let location = referenceData.location(id: id),
           let position = location.geographicPosition {
            applyCamera(
                LocationMapCamera(center: position.coordinate, visibleMeters: 80),
                status: nil
            )
            hasAppliedGardenCamera = true
            framedDefaultGardenID = defaultGarden?.id
            return
        }

        guard !hasAppliedGardenCamera else { return }
        await frameDefaultGarden()
    }

    private func frameDefaultGarden() async {
        guard let garden = defaultGarden else {
            hasAppliedGardenCamera = true
            framedDefaultGardenID = nil
            return
        }

        // Map Center = Garden Position (Single Source of Truth).
        if let coordinate = garden.mapCenter {
            applyCamera(
                LocationMapCamera(center: coordinate, visibleMeters: 1_200),
                status: "Showing \(garden.name)."
            )
            selectedGardenID = garden.id
            hasAppliedGardenCamera = true
            framedDefaultGardenID = garden.id
            return
        }

        // No Garden Position yet — frame from Address only. Never persist geocode as Position.
        let address = garden.composedAddress
        guard !address.isEmpty else {
            hasAppliedGardenCamera = true
            framedDefaultGardenID = garden.id
            selectedGardenID = garden.id
            statusMessage = "Click on the map to place your Garden."
            return
        }

        do {
            let coordinate = try await AddressGeocoder.coordinate(for: address)
            applyCamera(
                LocationMapCamera(center: coordinate, visibleMeters: 1_200),
                status: "Click on the map to place your Garden."
            )
            selectedGardenID = garden.id
            hasAppliedGardenCamera = true
            framedDefaultGardenID = garden.id
        } catch {
            hasAppliedGardenCamera = true
            framedDefaultGardenID = garden.id
            selectedGardenID = garden.id
            statusMessage = "Could not find the Garden address. Click on the map to place your Garden."
        }
    }

    private func placeGardenPosition(at coordinate: GeographicCoordinate) {
        guard let garden = defaultGarden else { return }
        profile.updateGardenPosition(id: garden.id, coordinate: coordinate)
        selectedGardenID = garden.id
        appState.selectedLocationID = nil
        selectedMapTreeID = nil
        applyCamera(
            LocationMapCamera(center: coordinate, visibleMeters: 1_200),
            status: "Garden Position saved for \(garden.name)."
        )
    }

    private func focusSelectedLocation(id: UUID?, forceZoom: Bool = false) {
        guard let id,
              let location = referenceData.location(id: id),
              let position = location.geographicPosition
        else {
            if forceZoom {
                statusMessage = "This Location has no map position yet."
            }
            return
        }
        applyCamera(
            LocationMapCamera(center: position.coordinate, visibleMeters: 80),
            status: forceZoom ? "Showing \(location.name)." : nil
        )
    }

    private func applyCamera(_ focus: LocationMapCamera, status: String?) {
        camera = focus
        focusRequest = LocationMapFocusRequest(camera: focus)
        zoomBand = MapZoomBand.from(visibleMeters: focus.visibleMeters)
        if let status {
            statusMessage = status
        }
    }

    private func placeOrMoveSelectedPin(at coordinate: GeographicCoordinate) {
        guard let location = selectedLocation else {
            statusMessage = "Select a Location first."
            return
        }
        manager.updateLocationPosition(
            id: location.id,
            position: GeographicPosition(coordinate: coordinate, lastUpdated: .now)
        )
        statusMessage = "Position saved for \(location.name)."
        applyCamera(
            LocationMapCamera(center: coordinate, visibleMeters: 80),
            status: nil
        )
    }
}

#Preview {
    let store = ReferencePreviewData()
    let previewData = PreviewData()
    return LocationsListView()
        .environment(AppState())
        .environment(UserProfileStore())
        .environment(ReferenceDataService(previewData: store))
        .environment(ReferenceDataManager(store: store))
        .environment(TreeService.preview(previewData: previewData))
}
