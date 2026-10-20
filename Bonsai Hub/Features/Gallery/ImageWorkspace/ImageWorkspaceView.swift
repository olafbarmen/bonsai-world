//
//  ImageWorkspaceView.swift
//  Bonsai World
//
//  Dedicated workspace for one image (Blueprint §5.5).
//  Image Summary → Related Images → workspace content. No side inspector.
//

import SwiftUI

struct ImageWorkspaceView: View {
    let imageID: UUID

    @Environment(AppState.self) private var appState
    @Environment(GalleryService.self) private var galleryService
    @Environment(TreeService.self) private var treeService
    @Environment(ImageService.self) private var imageService
    @Environment(ImageImportService.self) private var imageImportService
    @Environment(AppSettings.self) private var appSettings
    @Environment(\.openWindow) private var openWindow

    @State private var pendingDeleteConfirmation = false

    private var experienceLevel: ImageWorkspaceExperienceLevel {
        let _ = appSettings.experienceEdition
        return .current
    }

    var body: some View {
        let _ = treeService.trees
        let _ = galleryService

        Group {
            if let entry = galleryService.entry(for: imageID) {
                workspaceContent(entry: entry)
            } else {
                ContentUnavailableView(
                    "Image Not Found",
                    systemImage: "photo",
                    description: Text("This image may have been removed from the library.")
                )
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .faloWorkspaceCanvas()
        .bonsaiWorkspaceNavigationTitle(entryTitle, onBack: { appState.showCurrentList() })
        .onChange(of: appState.pendingImageQuickAction) { _, request in
            guard let request else { return }
            handleImageTool(request.command)
            appState.clearPendingImageQuickAction()
        }
        .confirmationDialog(
            "Delete image?",
            isPresented: $pendingDeleteConfirmation,
            titleVisibility: .visible
        ) {
            Button("Delete Image", role: .destructive) {
                confirmDeleteImage()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This removes the image from the library and from any Tree or inventory it is attached to.")
        }
    }

    private func handleImageTool(_ command: ImageQuickActionCommand) {
        switch command {
        case .crop:
            openCropWorkspace()
        case .rotate:
            imageService.rotatePresentationClockwise(for: imageID)
        case .importPhotos:
            Task { await importPhotoFromFinder() }
        case .setPrimary:
            setAsTreePrimary()
        case .delete:
            pendingDeleteConfirmation = true
        }
    }

    private func openCropWorkspace() {
        openWindow(
            id: CropWorkspaceWindowContext.windowID,
            value: CropWorkspaceWindowContext(imageID: imageID)
        )
    }

    private func importPhotoFromFinder() async {
        do {
            let asset = try await imageImportService.importGalleryImageFromFinder()
            appState.openImageInPlace(imageID: asset.id)
        } catch {
            // User cancelled Finder or import failed — no parallel error UI here.
        }
    }

    private func setAsTreePrimary() {
        guard let treeID = galleryService.entry(for: imageID)?.treeID else { return }
        try? treeService.setPrimaryImage(treeID: treeID, imageID: imageID)
    }

    private func confirmDeleteImage() {
        Task {
            try? await galleryService.deleteLibraryImage(id: imageID)
            appState.showCurrentList()
        }
    }

    private var entryTitle: String {
        galleryService.entry(for: imageID)?.photoName ?? "Image"
    }

    @ViewBuilder
    private func workspaceContent(entry: GalleryEntry) -> some View {
        VStack(spacing: 0) {
            ImageWorkspaceSummaryView(
                entry: entry,
                collections: collections(for: entry),
                experienceLevel: experienceLevel
            )

            ImageWorkspaceFilmstripView(
                currentImageID: entry.id,
                relatedEntries: galleryService.relatedEntries(for: entry),
                onSelectRelated: openRelatedImage
            )

            ImageWorkspaceContentView(imageID: entry.id)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }

    private func collections(for entry: GalleryEntry) -> [Collection] {
        guard let treeID = entry.treeID else { return [] }
        return treeService.collections(for: treeID)
    }

    private func openRelatedImage(_ entry: GalleryEntry) {
        appState.openImageInPlace(imageID: entry.id)
    }
}

#Preview {
    let imageService = ImageService(
        storage: StorageService.shared,
        previewData: ImagePreviewData()
    )
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
    return ImageWorkspaceView(imageID: UUID())
        .environment(imageService)
        .environment(
            GalleryService(
                imageService: imageService,
                treeService: treeService,
                yamadoriService: yamadoriService
            )
        )
        .environment(treeService)
        .environment(yamadoriService)
        .environment(AppState())
}
