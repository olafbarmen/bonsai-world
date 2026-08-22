//
//  TreePhotoManagerSection.swift
//  Bonsai World
//
//  Tree Detail photo manager — Lightroom / Photos style:
//  primary preview (column 0) + filmstrip (columns 1–2) on the Tree Detail card grid.
//  Filmstrip rows: thumbnail + Photo Name + Capture Date.
//

import AppKit
import SwiftUI

struct TreePhotoManagerSection: View {
    /// Locked photo-card height (filmstrip column).
    static let defaultFixedHeight: CGFloat = 320

    /// Landscape Primary Image container (wider than tall).
    private static let mainAspectRatio: CGFloat = 16.0 / 9.0
    private static let thumbnailSize: CGFloat = 44

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

    var body: some View {
        TreeDetailPhotoGrid {
            mainPreview
        } gallery: {
            filmstrip
        }
        .frame(height: Self.defaultFixedHeight)
        .task(id: imageIDs) {
            await loadThumbnails()
        }
        .task(id: selectedImageID) {
            await loadMainImage()
        }
        .sheet(isPresented: Binding(
            get: { infoPhotoID != nil },
            set: { if !$0 { commitInfoEditsIfNeeded(); infoPhotoID = nil } }
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
                infoPhotoID = nil
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
            ScrollView(.vertical, showsIndicators: true) {
                LazyVStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
                    ForEach(imageIDs, id: \.self) { imageID in
                        filmstripItem(imageID)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .topLeading)
                .padding(.vertical, FaloSpacing.xSmall)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .faloScrollSurface()

            if isEditing {
                addImageButton
                    .padding(.horizontal, FaloSpacing.small)
                    .padding(.vertical, FaloSpacing.small)
            }
        }
        .padding(.horizontal, FaloSpacing.small)
        .padding(.top, FaloSpacing.small)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
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

        return HStack(spacing: FaloSpacing.medium) {
            ZStack(alignment: .topTrailing) {
                ZStack {
                    RoundedRectangle(cornerRadius: FaloRadius.small, style: .continuous)
                        .fill(Color.primary.opacity(0.04))

                    if let thumb = thumbnails[imageID] {
                        thumb
                            .resizable()
                            .scaledToFill()
                    } else {
                        Image(systemName: "photo")
                            .font(.system(size: 14, weight: .regular))
                            .foregroundStyle(.tertiary)
                    }
                }
                .frame(width: Self.thumbnailSize, height: Self.thumbnailSize)
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

            VStack(alignment: .leading, spacing: 2) {
                Text(name)
                    .font(FaloTypography.body.weight(.medium))
                    .foregroundStyle(isSelected ? .primary : .primary)
                    .lineLimit(1)
                    .truncationMode(.tail)

                Text(dateLabel)
                    .font(FaloTypography.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            Button {
                openPhotoInformation(for: imageID)
            } label: {
                Image(systemName: "info.circle")
                    .font(.system(size: 14, weight: .regular))
                    .foregroundStyle(.secondary)
            }
            .buttonStyle(.plain)
            .help("Photo Information")
            .accessibilityLabel("Photo Information")
        }
        .padding(.horizontal, FaloSpacing.small)
        .padding(.vertical, FaloSpacing.xSmall)
        .background {
            RoundedRectangle(cornerRadius: FaloRadius.small, style: .continuous)
                .fill(isSelected ? Color.accentColor.opacity(0.12) : Color.clear)
        }
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
                    deleteTargetID = imageID
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

    /// Landscape container (16:9). Image uses Aspect Fit inside — never cropped or stretched.
    private var mainPreview: some View {
        ZStack {
            RoundedRectangle(cornerRadius: FaloRadius.hero, style: .continuous)
                .fill(Color.primary.opacity(0.03))

            mainImageContent
                .padding(FaloSpacing.small)
        }
        .aspectRatio(Self.mainAspectRatio, contentMode: .fit)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .clipShape(RoundedRectangle(cornerRadius: FaloRadius.hero, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: FaloRadius.hero, style: .continuous)
                .strokeBorder(Color.primary.opacity(0.06), lineWidth: 1)
        }
        .contentShape(Rectangle())
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
        ZStack {
            if selectedImageID == nil {
                emptyPlaceholder
            } else if mainImage == nil {
                ProgressView()
                    .controlSize(.regular)
            } else if let mainImage {
                mainImage
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
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
                if let infoPhotoID {
                    deleteTargetID = infoPhotoID
                }
            },
            onDismiss: {
                commitInfoEditsIfNeeded()
                infoPhotoID = nil
            }
        )
    }

    private func openPhotoInformation(for imageID: UUID) {
        select(imageID)
        infoName = photoNames[imageID] ?? imageService.photoName(for: imageID)
        infoCaptureDate = captureDates[imageID] ?? imageService.captureDate(for: imageID)
        infoPhotoID = imageID
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
            let data = try await imageService.loadOriginalData(for: selectedImageID)
            guard let nsImage = NSImage(data: data) else {
                mainImage = nil
                return
            }
            mainImage = Image(nsImage: nsImage)
        } catch {
            mainImage = nil
        }
    }

    private func loadThumbnails() async {
        for imageID in imageIDs {
            if thumbnails[imageID] != nil { continue }
            do {
                let data = try await imageService.loadOriginalData(for: imageID)
                if let nsImage = NSImage(data: data) {
                    thumbnails[imageID] = Image(nsImage: nsImage)
                }
            } catch {
                continue
            }
        }
        let valid = Set(imageIDs)
        thumbnails = thumbnails.filter { valid.contains($0.key) }
    }
}
