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
    @Environment(\.openWindow) private var openWindow

    private var experienceLevel: ImageWorkspaceExperienceLevel { .current }

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
        .background(.windowBackground)
        .navigationTitle(entryTitle)
        .onChange(of: appState.pendingImageQuickAction) { _, request in
            guard let request else { return }
            handleImageTool(request.command)
            appState.clearPendingImageQuickAction()
        }
    }

    private func handleImageTool(_ command: ImageQuickActionCommand) {
        switch command {
        case .crop:
            openCropWorkspace()
        case .importPhotos, .attachToTree, .rotate, .setPrimary, .setFeatured, .compare, .delete:
            break
        }
    }

    private func openCropWorkspace() {
        openWindow(
            id: CropWorkspaceWindowContext.windowID,
            value: CropWorkspaceWindowContext(imageID: imageID)
        )
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
        openWindow(
            id: ImageWorkspaceWindowContext.windowID,
            value: ImageWorkspaceWindowContext(imageID: entry.id)
        )
    }
}

#Preview {
    ImageWorkspaceView(imageID: UUID())
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
