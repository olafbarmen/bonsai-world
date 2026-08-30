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
    @Environment(ImageService.self) private var imageService
    @Environment(AppState.self) private var appState
    @Environment(\.openWindow) private var openWindow

    @State private var filter: GalleryBrowseFilter = .all
    @State private var selectedImageID: UUID?

    /// Fixed inspector strip — never expands; grid keeps all remaining height.
    private static let inspectorHeight: CGFloat = 170

    private var experienceLevel: GalleryExperienceLevel { .current }
    private var availableFilters: [GalleryBrowseFilter] {
        GalleryBrowseFilter.menuOptions(for: experienceLevel)
    }

    private var entries: [GalleryEntry] {
        galleryService.entries(filter: filter)
    }

    private var selectedEntry: GalleryEntry? {
        guard let selectedImageID else { return nil }
        return galleryService.entry(for: selectedImageID)
    }

    var body: some View {
        let _ = treeService.trees
        let _ = imageService.libraryImageCount

        VStack(spacing: 0) {
            ImageInspectorPanel(
                entry: selectedEntry,
                collections: collections(for: selectedEntry),
                onCrop: selectedEntry == nil ? nil : { openCropWorkspace() }
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
        .background(.windowBackground)
        .navigationTitle("Images")
        .onAppear {
            reconcileSelection(with: entries)
            appState.selectedMediaImageID = selectedImageID
        }
        .onChange(of: filter) { _, _ in
            reconcileSelection(with: entries)
        }
        .onChange(of: entries.count) { _, _ in
            reconcileSelection(with: entries)
        }
        .onChange(of: selectedImageID) { _, id in
            appState.selectedMediaImageID = id
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
                onOpenWorkspace: openImageWorkspace
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
        openWindow(
            id: CropWorkspaceWindowContext.windowID,
            value: CropWorkspaceWindowContext(imageID: imageID)
        )
    }
}

#Preview {
    GalleryView()
        .environment(AppState())
        .environment(
            GalleryService(
                imageService: ImageService(
                    storage: StorageService.shared,
                    previewData: ImagePreviewData()
                ),
                treeService: TreeService(
                    repository: PreviewTreeRepository(previewData: PreviewData()),
                    collectionRepository: PreviewCollectionRepository(previewData: PreviewData()),
                    photoIndex: TreePhotoIndexStore(storage: StorageService.shared),
                    bonsaiNameSequences: BonsaiNameSequenceStore(
                        storage: StorageService.shared,
                        libraryPersistenceEnabled: false
                    )
                )
            )
        )
}
