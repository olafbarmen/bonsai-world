//
//  TreePhotoManagerSection.swift
//  Bonsai World
//
//  Tree Detail photo manager — Hero preview with a horizontal filmstrip below.
//  Selecting a thumbnail updates the Hero image.
//

import AppKit
import SwiftUI

struct TreePhotoManagerSection: View {
    /// Legacy height hint for compatibility shells.
    static let defaultFixedHeight: CGFloat = 320

    /// Portrait Primary Image container (mild 3:4 — trees are taller than wide).
    private static let mainAspectRatio: CGFloat = GalleryLayout.imageAspectRatio
    private static let thumbnailWidth: CGFloat = 48
    private static let thumbnailHeight: CGFloat = 64
    private static let filmstripItemWidth: CGFloat = 64
    private static let filmstripMinHeight: CGFloat = 112

    let treeID: UUID
    let imageIDs: [UUID]
    let primaryImageID: UUID?
    /// Resolved Photo Names for filmstrip (id → display name).
    let photoNames: [UUID: String]
    /// Resolved Capture Dates for filmstrip (id → date).
    let captureDates: [UUID: Date]
    @Binding var selectedImageID: UUID?
    var isEditing: Bool = false
    var onAddImage: () -> Void = {}
    var onSelectImage: (UUID) -> Void = { _ in }
    var onSetPrimary: (UUID) -> Void = { _ in }
    var onUpdatePhotoMetadata: (UUID, String, Date) -> Void = { _, _, _ in }
    var onDeletePhoto: (UUID) -> Void = { _ in }

    @Environment(ImageService.self) private var imageService
    @Environment(\.openWindow) private var openWindow

    @State private var mainImage: Image?
    @State private var thumbnails: [UUID: Image] = [:]
    @State private var infoPhotoID: UUID?
    @State private var infoName: String = ""
    @State private var infoCaptureDate: Date = .now
    @State private var deleteTargetID: UUID?
    /// When dismissing Photo Information to show delete confirmation, skip metadata commit.
    @State private var suppressInfoCommitOnDismiss = false

    var body: some View {
        let _ = imageService.presentationRevision
        VStack(alignment: .leading, spacing: FaloSpacing.small) {
            mainPreview
            filmstrip
        }
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .clipped()
        .task(id: imageIDs) {
            await loadThumbnails()
        }
        .task(id: selectedImageID) {
            await loadMainImage()
        }
        .onChange(of: imageService.presentationRevision) { _, _ in
            thumbnails = [:]
            Task {
                await loadThumbnails()
                await loadMainImage()
            }
        }
        .sheet(isPresented: Binding(
            get: { infoPhotoID != nil },
            set: { presented in
                guard !presented else { return }
                // Already cleared programmatically (e.g. Delete → confirm).
                guard infoPhotoID != nil else { return }
                dismissPhotoInformation(commitEdits: !suppressInfoCommitOnDismiss)
            }
        )) {
            photoInformationSheet
        }
        .confirmationDialog(
            "Delete photo?",
            isPresented: Binding(
                get: { deleteTargetID != nil },
                set: { if !$0 { deleteTargetID = nil } }
            ),
            titleVisibility: .visible
        ) {
            Button("Delete", role: .destructive) {
                if let deleteTargetID {
                    onDeletePhoto(deleteTargetID)
                }
                deleteTargetID = nil
            }
            Button("Cancel", role: .cancel) {
                deleteTargetID = nil
            }
        } message: {
            Text("This photo will be removed from the tree.")
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Tree photos")
    }

    // MARK: - Filmstrip

    private var filmstrip: some View {
        VStack(spacing: 0) {
            ScrollView(.horizontal, showsIndicators: true) {
                HStack(spacing: FaloSpacing.xSmall) {
                    ForEach(imageIDs, id: \.self) { imageID in
                        filmstripItem(imageID)
                    }
                }
                .padding(.horizontal, FaloSpacing.small)
                .padding(.vertical, FaloSpacing.small)
            }
            .frame(minHeight: Self.filmstripMinHeight)
            .faloScrollSurface()

            if isEditing {
                addImageButton
                    .padding(.horizontal, FaloSpacing.small)
                    .padding(.bottom, FaloSpacing.small)
            }
        }
        .background {
            RoundedRectangle(cornerRadius: FaloRadius.hero, style: .continuous)
                .fill(Color.primary.opacity(0.03))
        }
        .overlay {
            RoundedRectangle(cornerRadius: FaloRadius.hero, style: .continuous)
                .strokeBorder(Color.primary.opacity(0.06), lineWidth: 1)
        }
        .clipShape(RoundedRectangle(cornerRadius: FaloRadius.hero, style: .continuous))
    }

    private func filmstripItem(_ imageID: UUID) -> some View {
        let isSelected = selectedImageID == imageID
        let isPrimary = primaryImageID == imageID
        let name = photoNames[imageID] ?? imageService.photoName(for: imageID)
        let capture = captureDates[imageID] ?? imageService.captureDate(for: imageID)
        let dateLabel = ImageAsset.displayCaptureDate(capture)

        return VStack(spacing: FaloSpacing.xSmall) {
            ZStack(alignment: .topTrailing) {
                ZStack {
                    RoundedRectangle(cornerRadius: FaloRadius.small, style: .continuous)
                        .fill(Color.primary.opacity(0.04))

                    if let thumb = thumbnails[imageID] {
                        Color.clear
                            .overlay {
                                thumb
                                    .resizable()
                                    .scaledToFill()
                            }
                    } else {
                        Image(systemName: "photo")
                            .font(.system(size: 14, weight: .regular))
                            .foregroundStyle(.tertiary)
                    }
                }
                .frame(width: Self.thumbnailWidth, height: Self.thumbnailHeight)
                .clipShape(RoundedRectangle(cornerRadius: FaloRadius.small, style: .continuous))
                .overlay {
                    RoundedRectangle(cornerRadius: FaloRadius.small, style: .continuous)
                        .strokeBorder(
                            isSelected ? Color.accentColor : Color.primary.opacity(0.08),
                            lineWidth: isSelected ? 2 : 1
                        )
                }

                if isPrimary {
                    Image(systemName: "star.fill")
                        .font(.system(size: 8, weight: .semibold))
                        .foregroundStyle(.yellow)
                        .padding(2)
                        .background(Circle().fill(Color.black.opacity(0.35)))
                        .offset(x: 3, y: -3)
                        .accessibilityLabel("Primary photo")
                }
            }

            Text(name)
                .font(FaloTypography.caption)
                .foregroundStyle(isSelected ? .primary : .secondary)
                .lineLimit(1)
                .truncationMode(.tail)
                .frame(width: Self.filmstripItemWidth)
        }
        .frame(width: Self.filmstripItemWidth)
        .contentShape(Rectangle())
        .onTapGesture(count: 2) {
            select(imageID)
            openViewer(for: imageID)
        }
        .onTapGesture(count: 1) {
            select(imageID)
        }
        .contextMenu {
            Button("Photo Information…") {
                openPhotoInformation(for: imageID)
            }
            if isEditing {
                Button("Set as Primary Photo") {
                    onSetPrimary(imageID)
                    select(imageID)
                }
                Divider()
                Button("Delete Photo…", role: .destructive) {
                    requestDeleteConfirmation(for: imageID)
                }
            } else {
                Button("Set as Primary Photo") {
                    onSetPrimary(imageID)
                    select(imageID)
                }
            }
        }
        .accessibilityLabel(isSelected ? "Selected photo, \(name), \(dateLabel)" : "Photo, \(name), \(dateLabel)")
        .accessibilityAddTraits(isSelected ? .isSelected : [])
        .help("\(name) — \(dateLabel)")
    }

    private var addImageButton: some View {
        Button(action: onAddImage) {
            HStack(spacing: FaloSpacing.small) {
                Image(systemName: "plus")
                    .font(.system(size: 13, weight: .semibold))
                Text("Add Photo")
                    .font(FaloTypography.body.weight(.medium))
            }
            .foregroundStyle(.secondary)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, FaloSpacing.small)
            .padding(.vertical, FaloSpacing.medium)
            .background {
                RoundedRectangle(cornerRadius: FaloRadius.small, style: .continuous)
                    .strokeBorder(style: StrokeStyle(lineWidth: 1, dash: [4, 3]))
                    .foregroundStyle(Color.primary.opacity(0.25))
            }
        }
        .buttonStyle(.plain)
        .help("Add Photo")
        .accessibilityLabel("Add Photo")
    }

    // MARK: - Main preview

    /// Portrait container (3:4). Layout size comes from the column width — never the photo pixels.
    private var mainPreview: some View {
        let shape = RoundedRectangle(cornerRadius: FaloRadius.hero, style: .continuous)
        return Color.clear
            .aspectRatio(Self.mainAspectRatio, contentMode: .fit)
            .frame(maxWidth: .infinity)
            .background(shape.fill(Color.primary.opacity(0.03)))
            .overlay {
                mainImageContent
                    .padding(FaloSpacing.small)
            }
            .clipped()
            .clipShape(shape)
            .overlay {
                shape.strokeBorder(Color.primary.opacity(0.06), lineWidth: 1)
            }
            .contentShape(shape)
            .onTapGesture(count: 2) {
                if let selectedImageID {
                    openViewer(for: selectedImageID)
                }
            }
            .contextMenu {
                if let selectedImageID {
                    Button("Photo Information…") {
                        openPhotoInformation(for: selectedImageID)
                    }
                    Button("Set as Primary Photo") {
                        onSetPrimary(selectedImageID)
                    }
                }
            }
            .accessibilityLabel("Main photo")
            .help("Double-click to view full size")
    }

    private var mainImageContent: some View {
        Color.clear
            .overlay {
                if selectedImageID == nil {
                    emptyPlaceholder
                } else if mainImage == nil {
                    ProgressView()
                        .controlSize(.regular)
                } else if let mainImage {
                    mainImage
                        .resizable()
                        .scaledToFill()
                }
            }
            .clipped()
    }

    private var emptyPlaceholder: some View {
        VStack(spacing: FaloSpacing.medium) {
            Image(systemName: "tree.fill")
                .font(.system(size: 44, weight: .regular))
                .symbolRenderingMode(.hierarchical)
                .foregroundStyle(.secondary)

            VStack(spacing: FaloSpacing.xSmall) {
                Text("No photos")
                    .font(FaloTypography.body.weight(.semibold))
                    .foregroundStyle(.primary)

                if isEditing {
                    Text("Add Photo to get started")
                        .font(FaloTypography.caption)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    // MARK: - Photo Information

    private var photoInformationSheet: some View {
        PhotoInformationSheet(
            photoName: $infoName,
            captureDate: $infoCaptureDate,
            isPrimary: infoPhotoID.map { $0 == primaryImageID } ?? false,
            onSetPrimary: {
                if let infoPhotoID {
                    onSetPrimary(infoPhotoID)
                    select(infoPhotoID)
                }
            },
            onDelete: {
                requestDeleteConfirmationFromPhotoInformation()
            },
            onDismiss: {
                dismissPhotoInformation(commitEdits: true)
            }
        )
    }

    private func openPhotoInformation(for imageID: UUID) {
        select(imageID)
        infoName = photoNames[imageID] ?? imageService.photoName(for: imageID)
        infoCaptureDate = captureDates[imageID] ?? imageService.captureDate(for: imageID)
        infoPhotoID = imageID
    }

    private func dismissPhotoInformation(commitEdits: Bool) {
        if commitEdits {
            commitInfoEditsIfNeeded()
        }
        infoPhotoID = nil
    }

    /// Shared delete entry: confirm immediately, then ``onDeletePhoto`` (context menu + sheet).
    private func requestDeleteConfirmation(for imageID: UUID) {
        deleteTargetID = imageID
    }

    /// Sheet Delete must dismiss first — a parent confirmationDialog cannot appear over the sheet.
    private func requestDeleteConfirmationFromPhotoInformation() {
        guard let imageID = infoPhotoID else { return }
        suppressInfoCommitOnDismiss = true
        dismissPhotoInformation(commitEdits: false)
        // Present the same confirmationDialog used by the context menu after the sheet closes.
        Task { @MainActor in
            suppressInfoCommitOnDismiss = false
            requestDeleteConfirmation(for: imageID)
        }
    }

    private func commitInfoEditsIfNeeded() {
        guard let infoPhotoID else { return }
        onUpdatePhotoMetadata(infoPhotoID, infoName, infoCaptureDate)
    }

    // MARK: - Actions

    private func select(_ imageID: UUID) {
        selectedImageID = imageID
        onSelectImage(imageID)
    }

    private func openViewer(for imageID: UUID) {
        guard !imageIDs.isEmpty else { return }
        let context = TreeImageViewerContext(
            treeID: treeID,
            imageIDs: imageIDs,
            selectedImageID: imageID
        )
        openWindow(id: TreeImageViewerContext.windowID, value: context)
    }

    // MARK: - Loading

    private func loadMainImage() async {
        guard let selectedImageID else {
            mainImage = nil
            return
        }
        do {
            let nsImage = try await imageService.loadDisplayNSImage(for: selectedImageID, context: .treeThumbnail)
            mainImage = Image(nsImage: nsImage)
        } catch {
            mainImage = nil
        }
    }

    private func loadThumbnails() async {
        for imageID in imageIDs {
            if thumbnails[imageID] != nil { continue }
            do {
                let nsImage = try await imageService.loadDisplayNSImage(for: imageID, context: .treeThumbnail)
                thumbnails[imageID] = Image(nsImage: nsImage)
            } catch {
                continue
            }
        }
        let valid = Set(imageIDs)
        thumbnails = thumbnails.filter { valid.contains($0.key) }
    }
}
