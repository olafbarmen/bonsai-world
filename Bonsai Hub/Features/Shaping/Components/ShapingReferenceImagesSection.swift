//
//  ShapingReferenceImagesSection.swift
//  Bonsai World
//
//  Reference image strip for Vision or a Shaping area — library photos, not tree gallery.
//

import SwiftUI

struct ShapingReferenceImagesSection: View {
    let treeID: UUID
    @Binding var imageIDs: [UUID]
    var showsTitle: Bool = true
    var helperText: String?

    @Environment(ImageService.self) private var imageService
    @Environment(ImageImportService.self) private var imageImportService
    @Environment(\.openWindow) private var openWindow

    @State private var isImporting = false

    var body: some View {
        VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
            if showsTitle {
                Text("Reference Images")
                    .font(FaloCardTypography.fieldLabel)
                    .foregroundStyle(.secondary)
            }

            if let helperText {
                Text(helperText)
                    .font(FaloTypography.caption)
                    .foregroundStyle(.secondary)
            }

            if imageIDs.isEmpty {
                Text("No Reference Images yet.")
                    .font(FaloCardTypography.fieldValue)
                    .foregroundStyle(.secondary)
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: FaloSpacing.small) {
                        ForEach(imageIDs, id: \.self) { imageID in
                            TreeListThumbnail(imageID: imageID, imageService: imageService) {
                                openReferenceImage(imageID)
                            }
                        }
                    }
                }
            }

            Button {
                Task { await addReferenceImage() }
            } label: {
                Label("Add Photo", systemImage: "plus")
            }
            .buttonStyle(.bordered)
            .fixedSize(horizontal: true, vertical: false)
            .disabled(isImporting)
            .accessibilityLabel("Add Photo")
        }
    }

    private func addReferenceImage() async {
        isImporting = true
        defer { isImporting = false }
        do {
            let asset = try await imageImportService.importGalleryImageFromFinder()
            guard !imageIDs.contains(asset.id) else { return }
            imageIDs.append(asset.id)
        } catch {
            return
        }
    }

    private func openReferenceImage(_ imageID: UUID) {
        guard !imageIDs.isEmpty else { return }
        let context = TreeImageViewerContext(
            treeID: treeID,
            imageIDs: imageIDs,
            selectedImageID: imageID,
            displayContext: .galleryCard
        )
        openWindow(id: TreeImageViewerContext.windowID, value: context)
    }
}
