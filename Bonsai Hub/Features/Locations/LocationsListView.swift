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
    @Environment(TaskService.self) private var taskService
    @Environment(ImageService.self) private var imageService

    @State private var mapStyle: LocationMapStyle = .standard
    @State private var camera: LocationMapCamera = .defaultGarden
    @State private var focusRequest: LocationMapFocusRequest?
    @State private var statusMessage: String?
    @State private var zoomBand: MapZoomBand = .medium
    @State private var layers = MapLayerConfiguration.default
    @State private var selectedMapTreeID: UUID?
    @State private var hasAppliedGardenCamera = false
    @State private var framedGardenID: UUID?

    /// Garden currently framed/filtered on the map (Phase 4 — multi-Garden support).
    /// Falls back to the default Garden when nothing has been explicitly picked, or
    /// when the picked Garden was deactivated/removed.
    private var browsedGarden: Garden? {
        _ = profile.revision
        if let id = appState.selectedGardenID,
           let garden = profile.garden(id: id),
           garden.isActive {
            return garden
        }
        return profile.defaultGarden
    }

    private var locations: [LocationReference] {
        _ = referenceData.locations
        _ = manager.revision
        _ = profile.revision
        let all = referenceData.locations
        guard let gardenID = browsedGarden?.id else { return all }
        return all.filter { $0.gardenID == gardenID }
    }

    private var selectedLocation: LocationReference? {
        guard let id = appState.selectedLocationID else { return nil }
        return referenceData.location(id: id)
    }

    private var selectedAnnotationID: UUID? {
        selectedMapTreeID ?? appState.selectedLocationID ?? browsedGarden?.id
    }

    private var collectionFilterID: UUID? {
        layers.collectionFilterID
    }

    /// Trees at a Location, optionally limited by Collection Filter.
    private func visibleTrees(at locationID: UUID) -> [Tree] {
        _ = treeService.trees
        let trees = treeService.trees(at: locationID)
        guard let collectionFilterID else { return trees }
        let memberIDs = Set(
            treeService.trees(
                inCollection: collectionFilterID,
                disposalMethods: referenceData.disposalMethods,
                liveMembers: taskService.liveSmartCollectionMembers()
            ).map(\.id)
        )
        return trees.filter { memberIDs.contains($0.id) }
    }

    private var mapAnnotations: [LocationMapAnnotation] {
        _ = treeService.trees
        var pins: [LocationMapAnnotation] = []

        if layers.showsGardens,
           let garden = browsedGarden,
           let coordinate = garden.mapCenter {
            pins.append(
                LocationMapAnnotation(
                    id: garden.id,
                    title: garden.name,
                    subtitle: garden.isDefault ? "Default Garden" : "Garden",
                    coordinate: coordinate,
                    level: .garden,
                    isHighlighted: appState.selectedLocationID == nil && selectedMapTreeID == nil
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
            focusSelectedLocation(id: newID)
            updateLocationStatus()
        }
        .onChange(of: appState.pendingLocationMapFocusID) { _, focusID in
            guard let focusID else { return }
            selectedMapTreeID = nil
            focusSelectedLocation(id: focusID, forceZoom: true)
            appState.clearPendingLocationMapFocus()
            updateLocationStatus()
        }
        .onChange(of: profile.revision) { _, _ in
            let gardenID = browsedGarden?.id
            if gardenID != framedGardenID {
                hasAppliedGardenCamera = false
                Task { await applyInitialMapCamera() }
            }
        }
        .onChange(of: appState.selectedGardenID) { _, _ in
            appState.selectedLocationID = nil
            selectedMapTreeID = nil
            hasAppliedGardenCamera = false
            Task { await applyInitialMapCamera() }
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
        guard let garden = browsedGarden else { return false }
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
            // Hero-surface framing (matches TreePhotoManagerSection's photo hero) so the map
            // reads as a card like every other module surface, instead of full-bleed.
            .clipShape(RoundedRectangle(cornerRadius: FaloRadius.hero, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: FaloRadius.hero, style: .continuous)
                    .strokeBorder(Color.primary.opacity(0.08), lineWidth: 1)
            }
            .padding(FaloSpacing.medium)

            mapChrome
        }
        .background(.windowBackground)
    }

    private var mapChrome: some View {
        @Bindable var appState = appState
        return VStack(alignment: .leading, spacing: FaloSpacing.small) {
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

                if profile.activeGardens.count > 1 {
                    Picker("Garden", selection: $appState.selectedGardenID) {
                        ForEach(profile.activeGardens) { garden in
                            Text(garden.name).tag(Optional(garden.id))
                        }
                    }
                    .pickerStyle(.menu)
                    .frame(maxWidth: 180)
                    .help("Garden — shows Locations for the chosen Garden. Weather still follows your default Garden.")
                }

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

    private func bottomPane(selection: Binding<UUID?>) -> some View {
        locationsListPane(selection: selection)
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
        .background {
            RoundedRectangle(cornerRadius: FaloRadius.hero, style: .continuous)
                .fill(Color.primary.opacity(0.03))
        }
        .overlay {
            if locations.isEmpty {
                ContentUnavailableView(
                    "No Locations",
                    systemImage: "mappin.and.ellipse",
                    description: Text(
                        browsedGarden == nil
                            ? "Add a Garden in Settings → User Profile first."
                            : "Use Quick Actions → New Location to add one for \(browsedGarden?.name ?? "this Garden")."
                    )
                )
            }
        }
        // Same hero-surface framing as the map above and the Detail cards on the right,
        // so the Locations list reads as a peer module surface, not a bare system list.
        .overlay {
            RoundedRectangle(cornerRadius: FaloRadius.hero, style: .continuous)
                .strokeBorder(Color.primary.opacity(0.08), lineWidth: 1)
        }
        .clipShape(RoundedRectangle(cornerRadius: FaloRadius.hero, style: .continuous))
        .padding(FaloSpacing.medium)
    }

    private func handleMapSelection(_ annotation: LocationMapAnnotation) {
        switch annotation.level {
        case .garden:
            selectedMapTreeID = nil
            appState.selectedLocationID = nil
            statusMessage = annotation.subtitle.map { "\(annotation.title) · \($0)" } ?? annotation.title

        case .location:
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
            framedGardenID = browsedGarden?.id
            return
        }

        guard !hasAppliedGardenCamera else { return }
        await frameBrowsedGarden()
    }

    private func frameBrowsedGarden() async {
        guard let garden = browsedGarden else {
            hasAppliedGardenCamera = true
            framedGardenID = nil
            return
        }

        // Map Center = Garden Position (Single Source of Truth).
        if let coordinate = garden.mapCenter {
            applyCamera(
                LocationMapCamera(center: coordinate, visibleMeters: 1_200),
                status: "Showing \(garden.name)."
            )
            hasAppliedGardenCamera = true
            framedGardenID = garden.id
            return
        }

        // No Garden Position yet — frame from Address only. Never persist geocode as Position.
        let address = garden.composedAddress
        guard !address.isEmpty else {
            hasAppliedGardenCamera = true
            framedGardenID = garden.id
            statusMessage = "Click on the map to place your Garden."
            return
        }

        do {
            let coordinate = try await AddressGeocoder.coordinate(for: address)
            applyCamera(
                LocationMapCamera(center: coordinate, visibleMeters: 1_200),
                status: "Click on the map to place your Garden."
            )
            hasAppliedGardenCamera = true
            framedGardenID = garden.id
        } catch {
            hasAppliedGardenCamera = true
            framedGardenID = garden.id
            statusMessage = "Could not find the Garden address. Click on the map to place your Garden."
        }
    }

    private func placeGardenPosition(at coordinate: GeographicCoordinate) {
        guard let garden = browsedGarden else { return }
        profile.updateGardenPosition(id: garden.id, coordinate: coordinate)
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
    let treeService = TreeService.preview(previewData: previewData)
    let referenceData = ReferenceDataService(previewData: store)
    let workService = WorkService(referenceData: referenceData)
    let taskService = TaskService(
        referenceData: referenceData,
        workService: workService,
        treeService: treeService,
        botanicalService: BotanicalService(store: store)
    )
    return LocationsListView()
        .environment(AppState())
        .environment(UserProfileStore())
        .environment(referenceData)
        .environment(ReferenceDataManager(store: store))
        .environment(treeService)
        .environment(taskService)
}
