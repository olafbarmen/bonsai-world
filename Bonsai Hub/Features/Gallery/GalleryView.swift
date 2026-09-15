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
    @State private var selectedImageID: UUID?
    @State private var pendingDeleteImageID: UUID?

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
        if let treeID = appState.galleryFocusTreeID {
            list = list.filter { $0.treeID == treeID }
        }
        return list
    }

    private var focusedTreeTitle: String? {
        guard let treeID = appState.galleryFocusTreeID else { return nil }
        return treeService.getTree(id: treeID).map(TreePresentation.title(for:))
    }

    private var selectedEntry: GalleryEntry? {
        guard let selectedImageID else { return nil }
        return galleryService.entry(for: selectedImageID)
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
                onCrop: selectedEntry == nil ? nil : { openCropWorkspace() },
                onDelete: selectedEntry == nil ? nil : { pendingDeleteImageID = selectedEntry?.id }
            )
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(height: Self.inspectorHeight)
            .clipped()

            Divider()

            GalleryImagesToolbar(
                filter: $filter,
                filterOptions: availableFilters,
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
            appState.selectedMediaImageID = selectedImageID
        }
        .onChange(of: filter) { _, _ in
            reconcileSelection(with: entries)
        }
        .onChange(of: appState.galleryFocusTreeID) { _, _ in
            reconcileSelection(with: entries)
        }
        .onChange(of: entries.count) { _, _ in
            reconcileSelection(with: entries)
        }
        .onChange(of: selectedImageID) { _, id in
            appState.selectedMediaImageID = id
        }
        .onChange(of: appState.mediaImageDeleteRequestID) { _, _ in
            guard let imageID = selectedImageID ?? appState.selectedMediaImageID else { return }
            pendingDeleteImageID = imageID
        }
        .onAppear { consumeWantsImportImage() }
        .onChange(of: appState.wantsImportImage) { _, wants in
            guard wants else { return }
            consumeWantsImportImage()
        }
        .confirmationDialog(
            "Delete image?",
            isPresented: Binding(
                get: { pendingDeleteImageID != nil },
                set: { if !$0 { pendingDeleteImageID = nil } }
            ),
            titleVisibility: .visible
        ) {
            Button("Delete Image", role: .destructive) {
                confirmDeletePendingImage()
            }
            Button("Cancel", role: .cancel) {
                pendingDeleteImageID = nil
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
        if entries.isEmpty {
            ContentUnavailableView(
                filter.emptyTitle,
                systemImage: filter.systemImage,
                description: Text(filter.emptyDescription)
            )
            .frame(maxWidth: .infinity, minHeight: 360)
        } else {
            GalleryImageGrid(
                entries: entries,
                selectedImageID: selectedImageID,
                showsFeaturedBadge: experienceLevel.showsFeaturedBadge,
                onSelect: { selectedImageID = $0.id },
                onOpenWorkspace: openImageWorkspace,
                onCrop: openCropWorkspace,
                onDelete: { pendingDeleteImageID = $0.id }
            )
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        }
    }

    private func collections(for entry: GalleryEntry?) -> [Collection] {
        guard let treeID = entry?.treeID else { return [] }
        return treeService.collections(for: treeID)
    }

    /// Standard list-workspace selection: keep a valid choice, else select the first row.
    /// Does not scroll — selection state and Inspector update only.
    private func reconcileSelection(with entries: [GalleryEntry]) {
        if entries.isEmpty {
            selectedImageID = nil
            return
        }

        if let selectedImageID,
           entries.contains(where: { $0.id == selectedImageID }) {
            return
        }

        selectedImageID = entries.first?.id
    }

    /// Double-click opens a dedicated Image Workspace window (Blueprint §5.5).
    private func openImageWorkspace(_ entry: GalleryEntry) {
        openWindow(
            id: ImageWorkspaceWindowContext.windowID,
            value: ImageWorkspaceWindowContext(imageID: entry.id)
        )
    }

    /// Crop Workspace — presentation recipe only; Original bytes stay untouched.
    private func openCropWorkspace() {
        guard let imageID = selectedImageID else { return }
        openCropWorkspace(imageID: imageID)
    }

    private func openCropWorkspace(_ entry: GalleryEntry) {
        selectedImageID = entry.id
        openCropWorkspace(imageID: entry.id)
    }

    private func openCropWorkspace(imageID: UUID) {
        openWindow(
            id: CropWorkspaceWindowContext.windowID,
            value: CropWorkspaceWindowContext(imageID: imageID)
        )
    }

    private func confirmDeletePendingImage() {
        guard let imageID = pendingDeleteImageID else { return }
        pendingDeleteImageID = nil
        Task {
            try? await galleryService.deleteLibraryImage(id: imageID)
            if selectedImageID == imageID {
                selectedImageID = nil
                reconcileSelection(with: entries)
            }
        }
    }

    private func consumeWantsImportImage() {
        guard appState.wantsImportImage else { return }
        appState.wantsImportImage = false
        Task { await importPhotoFromFinder() }
    }

    private func importPhotoFromFinder() async {
        do {
            let asset = try await imageImportService.importGalleryImageFromFinder()
            selectedImageID = asset.id
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
