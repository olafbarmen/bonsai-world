//
//  GalleryView.swift
//  Bonsai World
//
//  Library-wide Image Library browse — calm, image-focused grid (Blueprint §5.5).
//

import SwiftUI

struct GalleryView: View {
    @Environment(GalleryService.self) private var galleryService
    @Environment(TreeService.self) private var treeService
    @Environment(YamadoriService.self) private var yamadoriService
    @Environment(ImageService.self) private var imageService
    @Environment(ImageImportService.self) private var imageImportService
    @Environment(AppState.self) private var appState
    @Environment(AppSettings.self) private var appSettings
    @Environment(\.openWindow) private var openWindow

    @State private var filter: GalleryBrowseFilter = .all
    @State private var searchText = ""
    @State private var imageSort: GalleryImageSort = .latest
    @State private var treeFilterID: UUID?
    @State private var selectedImageIDs: Set<UUID> = []
    @State private var selectionAnchorID: UUID?
    @State private var pendingDeleteImageIDs: Set<UUID> = []
    @State private var isImportingDroppedImages = false

    /// Fixed inspector strip — never expands; grid keeps all remaining height.
    private static let inspectorHeight: CGFloat = 170

    private var experienceLevel: GalleryExperienceLevel {
        let _ = appSettings.experienceEdition
        return .current
    }
    private var availableFilters: [GalleryBrowseFilter] {
        GalleryBrowseFilter.menuOptions(for: experienceLevel)
    }

    private var entries: [GalleryEntry] {
        let _ = imageService.catalogRevision
        var list = galleryService.entries(filter: filter)
        if filter == .byTree, let treeFilterID {
            list = list.filter { $0.treeID == treeFilterID }
        }
        if let treeID = appState.galleryFocusTreeID {
            list = list.filter { $0.treeID == treeID }
        }
        list = list.filter(matchesSearch)
        return sorted(list)
    }

    private var treeFilterChoices: [GalleryTreeFilterChoice] {
        let _ = imageService.catalogRevision
        var seen = Set<UUID>()
        var choices: [GalleryTreeFilterChoice] = []
        for entry in galleryService.entries(filter: .byTree) {
            guard let id = entry.treeID, seen.insert(id).inserted else { continue }
            choices.append(
                GalleryTreeFilterChoice(
                    id: id,
                    title: entry.treeDisplayName ?? "Untitled Tree"
                )
            )
        }
        return choices.sorted {
            $0.title.localizedCaseInsensitiveCompare($1.title) == .orderedAscending
        }
    }

    /// Tree the drop card attaches to. The Photos-for banner wins; otherwise the Tree menu.
    private var dropTreeID: UUID? {
        if let treeID = appState.galleryFocusTreeID {
            return treeID
        }
        if filter == .byTree {
            return treeFilterID
        }
        return nil
    }

    private var focusedTreeTitle: String? {
        guard let treeID = appState.galleryFocusTreeID else { return nil }
        return treeService.getTree(id: treeID).map(TreePresentation.title(for:))
    }

    private var primarySelectedImageID: UUID? {
        if selectedImageIDs.count == 1 { return selectedImageIDs.first }
        if let selectionAnchorID, selectedImageIDs.contains(selectionAnchorID) {
            return selectionAnchorID
        }
        return selectedImageIDs.first
    }

    private var selectedEntry: GalleryEntry? {
        guard selectedImageIDs.count == 1, let primarySelectedImageID else { return nil }
        return galleryService.entry(for: primarySelectedImageID)
    }

    var body: some View {
        let _ = treeService.trees
        let _ = yamadoriService.finds
        let _ = imageService.libraryImageCount

        VStack(spacing: 0) {
            if let focusedTreeTitle {
                HStack(spacing: FaloSpacing.small) {
                    Text("Photos for \(focusedTreeTitle)")
                        .font(FaloTypography.caption)
                        .foregroundStyle(.secondary)
                    Spacer(minLength: FaloSpacing.small)
                    Button("Show all images") {
                        appState.clearGalleryTreeFocus()
                    }
                    .buttonStyle(.borderless)
                    .font(FaloTypography.caption)
                }
                .padding(.horizontal, FaloSpacing.xLarge)
                .padding(.vertical, FaloSpacing.small)
                Divider()
            }

            ImageInspectorPanel(
                entry: selectedEntry,
                collections: collections(for: selectedEntry),
                selectionCount: selectedImageIDs.count,
                onCrop: selectedEntry == nil ? nil : { openCropWorkspace() },
                onDelete: selectedImageIDs.isEmpty ? nil : { pendingDeleteImageIDs = selectedImageIDs }
            )
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(height: Self.inspectorHeight)
            .clipped()

            Divider()

            GalleryImagesToolbar(
                filter: $filter,
                filterOptions: availableFilters,
                searchText: $searchText,
                imageSort: $imageSort,
                treeFilterID: $treeFilterID,
                treeChoices: treeFilterChoices,
                imageCountLabel: entries.isEmpty ? nil : imageCountLabel
            )
            .padding(.horizontal, FaloSpacing.xLarge)

            ScrollView {
                content
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .faloScrollSurface()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .faloWorkspaceCanvas()
        .bonsaiWorkspaceNavigationTitle("Images")
        .onAppear {
            reconcileSelection(with: entries)
            appState.selectedMediaImageID = primarySelectedImageID
        }
        .onChange(of: filter) { _, newFilter in
            if newFilter == .byTree {
                imageSort = .tree
            }
            reconcileSelection(with: entries)
        }
        .onChange(of: searchText) { _, _ in
            reconcileSelection(with: entries)
        }
        .onChange(of: treeFilterID) { _, _ in
            reconcileSelection(with: entries)
        }
        .onChange(of: appState.galleryFocusTreeID) { _, _ in
            reconcileSelection(with: entries)
        }
        .onChange(of: entries.count) { _, _ in
            reconcileSelection(with: entries)
        }
        .onChange(of: selectedImageIDs) { _, _ in
            appState.selectedMediaImageID = primarySelectedImageID
        }
        .onChange(of: appState.mediaImageDeleteRequestID) { _, _ in
            if !selectedImageIDs.isEmpty {
                pendingDeleteImageIDs = selectedImageIDs
            } else if let imageID = appState.selectedMediaImageID {
                pendingDeleteImageIDs = [imageID]
            }
        }
        .onDeleteCommand {
            guard !selectedImageIDs.isEmpty else { return }
            pendingDeleteImageIDs = selectedImageIDs
        }
        .onAppear { consumeWantsImportImage() }
        .onChange(of: appState.wantsImportImage) { _, wants in
            guard wants else { return }
            consumeWantsImportImage()
        }
        .confirmationDialog(
            deleteDialogTitle,
            isPresented: Binding(
                get: { !pendingDeleteImageIDs.isEmpty },
                set: { if !$0 { pendingDeleteImageIDs = [] } }
            ),
            titleVisibility: .visible
        ) {
            Button(deleteDialogButtonTitle, role: .destructive) {
                confirmDeletePendingImages()
            }
            Button("Cancel", role: .cancel) {
                pendingDeleteImageIDs = []
            }
        } message: {
            Text("This removes the image from the library and from any Tree or inventory it is attached to.")
        }
    }

    private var imageCountLabel: String {
        "\(entries.count) \(entries.count == 1 ? "image" : "images")"
    }

    @ViewBuilder
    private var content: some View {
        if entries.isEmpty, !trimmedSearch.isEmpty {
            ContentUnavailableView.search(text: trimmedSearch)
                .frame(maxWidth: .infinity, minHeight: 360)
        } else if entries.isEmpty, dropTreeID == nil {
            ContentUnavailableView(
                filter.emptyTitle,
                systemImage: filter.systemImage,
                description: Text(filter.emptyDescription)
            )
            .frame(maxWidth: .infinity, minHeight: 360)
        } else {
            GalleryImageGrid(
                entries: entries,
                selectedImageIDs: selectedImageIDs,
                showsFeaturedBadge: experienceLevel.showsFeaturedBadge,
                onSelect: select,
                onOpenWorkspace: openImageWorkspace,
                onCrop: openCropWorkspace,
                onDelete: requestDelete,
                onDropImages: dropTreeID == nil ? nil : { sources in
                    Task { await importDroppedImages(sources) }
                }
            )
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        }
    }

    private func collections(for entry: GalleryEntry?) -> [Collection] {
        guard let treeID = entry?.treeID else { return [] }
        return treeService.collections(for: treeID)
    }

    private var trimmedSearch: String {
        searchText.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private var deleteDialogTitle: String {
        pendingDeleteImageIDs.count <= 1
            ? "Delete image?"
            : "Delete \(pendingDeleteImageIDs.count) images?"
    }

    private var deleteDialogButtonTitle: String {
        pendingDeleteImageIDs.count <= 1
            ? "Delete Image"
            : "Delete \(pendingDeleteImageIDs.count) images"
    }

    private func matchesSearch(_ entry: GalleryEntry) -> Bool {
        let needle = trimmedSearch
        guard !needle.isEmpty else { return true }
        var fields = [entry.photoName, entry.treeDisplayName ?? ""]
        if let treeID = entry.treeID, let tree = treeService.getTree(id: treeID) {
            fields.append(tree.bonsaiName)
            fields.append(tree.botanicalName)
            fields.append(tree.nickname)
        }
        return fields.contains { $0.localizedStandardContains(needle) }
    }

    private func sorted(_ list: [GalleryEntry]) -> [GalleryEntry] {
        switch imageSort {
        case .latest:
            return list.sorted { lhs, rhs in
                if lhs.captureDate != rhs.captureDate {
                    return lhs.captureDate > rhs.captureDate
                }
                return lhs.photoName.localizedCaseInsensitiveCompare(rhs.photoName) == .orderedAscending
            }
        case .tree:
            return list.sorted { lhs, rhs in
                let order = sortName(lhs).localizedCaseInsensitiveCompare(sortName(rhs))
                if order != .orderedSame { return order == .orderedAscending }
                return lhs.captureDate > rhs.captureDate
            }
        }
    }

    private func sortName(_ entry: GalleryEntry) -> String {
        if let treeID = entry.treeID, let tree = treeService.getTree(id: treeID) {
            return TreePresentation.registryLabel(for: tree)
        }
        return entry.treeDisplayName ?? entry.photoName
    }

    private func select(_ entry: GalleryEntry, _ modifiers: GallerySelectionModifiers) {
        if modifiers.contains(.shift),
           let anchor = selectionAnchorID,
           let start = entries.firstIndex(where: { $0.id == anchor }),
           let end = entries.firstIndex(where: { $0.id == entry.id }) {
            let range = min(start, end)...max(start, end)
            selectedImageIDs = Set(entries[range].map(\.id))
            return
        }

        if modifiers.contains(.command) {
            if selectedImageIDs.contains(entry.id) {
                selectedImageIDs.remove(entry.id)
            } else {
                selectedImageIDs.insert(entry.id)
            }
            selectionAnchorID = entry.id
            return
        }

        selectedImageIDs = [entry.id]
        selectionAnchorID = entry.id
    }

    private func requestDelete(_ entry: GalleryEntry) {
        if selectedImageIDs.contains(entry.id), selectedImageIDs.count > 1 {
            pendingDeleteImageIDs = selectedImageIDs
        } else {
            pendingDeleteImageIDs = [entry.id]
        }
    }

    /// Standard list-workspace selection: keep a valid choice, else select the first row.
    /// Does not scroll — selection state and Inspector update only.
    private func reconcileSelection(with entries: [GalleryEntry]) {
        let visible = Set(entries.map(\.id))
        selectedImageIDs.formIntersection(visible)
        if let selectionAnchorID, !visible.contains(selectionAnchorID) {
            self.selectionAnchorID = selectedImageIDs.first
        }
        if selectedImageIDs.isEmpty, let first = entries.first?.id {
            selectedImageIDs = [first]
            selectionAnchorID = first
        }
    }

    /// Double-click opens the image in this window.
    private func openImageWorkspace(_ entry: GalleryEntry) {
        appState.openImageInPlace(imageID: entry.id)
    }

    /// Crop Workspace — presentation recipe only; Original bytes stay untouched.
    private func openCropWorkspace() {
        guard let imageID = primarySelectedImageID else { return }
        openCropWorkspace(imageID: imageID)
    }

    private func openCropWorkspace(_ entry: GalleryEntry) {
        selectedImageIDs = [entry.id]
        selectionAnchorID = entry.id
        openCropWorkspace(imageID: entry.id)
    }

    private func openCropWorkspace(imageID: UUID) {
        openWindow(
            id: CropWorkspaceWindowContext.windowID,
            value: CropWorkspaceWindowContext(imageID: imageID)
        )
    }

    private func confirmDeletePendingImages() {
        let ids = pendingDeleteImageIDs
        guard !ids.isEmpty else { return }
        pendingDeleteImageIDs = []
        Task {
            for id in ids {
                try? await galleryService.deleteLibraryImage(id: id)
            }
            selectedImageIDs.subtract(ids)
            reconcileSelection(with: entries)
        }
    }

    private func consumeWantsImportImage() {
        guard appState.wantsImportImage else { return }
        appState.wantsImportImage = false
        Task { await importPhotoFromFinder() }
    }

    private func importDroppedImages(_ sources: [ImageDropSource]) async {
        guard let treeID = dropTreeID else { return }
        guard !sources.isEmpty, !isImportingDroppedImages else { return }
        guard var tree = treeService.getTree(id: treeID) else { return }
        isImportingDroppedImages = true
        defer { isImportingDroppedImages = false }

        do {
            var assets: [ImageAsset] = []
            assets.reserveCapacity(sources.count)
            for source in sources {
                assets.append(try await imageImportService.importImage(from: source, asPrimary: false))
            }
            guard !assets.isEmpty else { return }
            let galleryWasEmpty = tree.primaryImageID == nil && tree.imageIDs.isEmpty
            for asset in assets where !tree.imageIDs.contains(asset.id) {
                tree.imageIDs.append(asset.id)
            }
            if galleryWasEmpty, let first = assets.first {
                tree.primaryImageID = first.id
            }
            try treeService.updateTree(tree)
            if let lastID = assets.last?.id {
                selectedImageIDs = [lastID]
                selectionAnchorID = lastID
                appState.selectedMediaImageID = lastID
            }
        } catch {
            return
        }
    }

    private func importPhotoFromFinder() async {
        do {
            let asset = try await imageImportService.importGalleryImageFromFinder()
            selectedImageIDs = [asset.id]
            selectionAnchorID = asset.id
            appState.selectedMediaImageID = asset.id
        } catch {
            // User cancelled Finder or import failed.
        }
    }
}

#Preview {
    let treeService = TreeService(
        repository: PreviewTreeRepository(previewData: PreviewData()),
        collectionRepository: PreviewCollectionRepository(previewData: PreviewData()),
        photoIndex: TreePhotoIndexStore(storage: StorageService.shared),
        bonsaiNameSequences: BonsaiNameSequenceStore(
            storage: StorageService.shared,
            libraryPersistenceEnabled: false
        )
    )
    let yamadoriService = YamadoriService(
        repository: PreviewYamadoriRepository(),
        treeService: treeService
    )
    GalleryView()
        .environment(AppState())
        .environment(yamadoriService)
        .environment(
            GalleryService(
                imageService: ImageService(
                    storage: StorageService.shared,
                    previewData: ImagePreviewData()
                ),
                treeService: treeService,
                yamadoriService: yamadoriService
            )
        )
}
