//
//  PotIdentityPhotosSection.swift
//  Bonsai World
//
//  Pot Detail Identity — primary preview + compact filmstrip (Tree pattern, smaller).
//

import AppKit
import SwiftUI

struct PotIdentityPhotosSection: View {
    private static let mainAspectRatio: CGFloat = 5.0 / 6.0
    private static let previewMaxHeight: CGFloat = 168
    private static let thumbnailWidth: CGFloat = 36
    private static let thumbnailHeight: CGFloat = 48
    private static let filmstripItemWidth: CGFloat = 48
    private static let filmstripMaxHeight: CGFloat = 88

    let imageIDs: [UUID]
    let primaryImageID: UUID?
    @Binding var selectedImageID: UUID?
    var onAddImage: () -> Void
    var onDropImageFiles: (([ImageDropSource]) -> Void)? = nil
    var onSetPrimary: (UUID) -> Void
    var onRemove: (UUID) -> Void

    @Environment(ImageService.self) private var imageService
    @Environment(AppState.self) private var appState

    @State private var mainImage: Image?
    @State private var thumbnails: [UUID: Image] = [:]
    @State private var isDropTargeted = false

    var body: some View {
        let _ = imageService.presentationRevision
        VStack(alignment: .leading, spacing: FaloSpacing.small) {
            mainPreview
            filmstrip
        }
        .onChange(of: imageIDs, initial: true) { _, ids in
            reconcileSelection(with: ids)
            Task {
                await loadThumbnails()
                await loadMainImage()
            }
        }
        .onChange(of: selectedImageID) { _, _ in
            Task { await loadMainImage() }
        }
        .onChange(of: imageService.presentationRevision) { _, _ in
            thumbnails = [:]
            Task {
                await loadThumbnails()
                await loadMainImage()
            }
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel("Pot photos")
        .background {
            if isDropTargeted {
                RoundedRectangle(cornerRadius: FaloRadius.medium, style: .continuous)
                    .fill(BonsaiWorldColors.accentSubtle.opacity(0.45))
            }
        }
        .overlay {
            if isDropTargeted {
                RoundedRectangle(cornerRadius: FaloRadius.medium, style: .continuous)
                    .strokeBorder(BonsaiWorldColors.accent, style: StrokeStyle(lineWidth: 2, dash: [6, 4]))
            }
        }
        .bonsaiImageFileDrop(
            isEnabled: onDropImageFiles != nil,
            isTargeted: $isDropTargeted
        ) { sources in
            onDropImageFiles?(sources)
        }
    }

    // MARK: - Main preview

    private var mainPreview: some View {
        let shape = RoundedRectangle(cornerRadius: FaloRadius.medium, style: .continuous)
        return Color.clear
            .aspectRatio(Self.mainAspectRatio, contentMode: .fit)
            .frame(maxWidth: 140, maxHeight: Self.previewMaxHeight, alignment: .leading)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(shape.fill(Color.primary.opacity(0.03)))
            .overlay {
                mainImageContent
                    .padding(FaloSpacing.xSmall)
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
                    Button("Set as Primary") { onSetPrimary(selectedImageID) }
                    Button("Remove", role: .destructive) { onRemove(selectedImageID) }
                }
                Button("Add Photo", action: onAddImage)
            }
            .accessibilityLabel("Main pot photo")
            .help("Double-click to view full size")
    }

    private var mainImageContent: some View {
        Color.clear
            .overlay {
                if selectedImageID == nil {
                    emptyPlaceholder
                } else if let mainImage {
                    mainImage
                        .resizable()
                        .scaledToFill()
                } else {
                    ProgressView()
                        .controlSize(.small)
                }
            }
            .clipped()
    }

    private var emptyPlaceholder: some View {
        VStack(spacing: FaloSpacing.xSmall) {
            Image(systemName: "shippingbox")
                .font(.system(size: 28, weight: .regular))
                .symbolRenderingMode(.hierarchical)
                .foregroundStyle(.secondary)
            Text("No photos")
                .font(FaloTypography.caption)
                .foregroundStyle(.secondary)
            Button("Add Photo", action: onAddImage)
                .buttonStyle(.borderless)
                .font(FaloTypography.caption)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    // MARK: - Filmstrip

    private var filmstrip: some View {
        VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
            ScrollView(.horizontal, showsIndicators: true) {
                HStack(alignment: .center, spacing: FaloSpacing.xSmall) {
                    ForEach(imageIDs, id: \.self) { imageID in
                        filmstripItem(imageID)
                    }
                    addTile
                }
                .padding(.vertical, 2)
            }
            .frame(maxHeight: Self.filmstripMaxHeight)
        }
    }

    private func filmstripItem(_ imageID: UUID) -> some View {
        let isSelected = selectedImageID == imageID
        let isPrimary = primaryImageID == imageID

        return ZStack(alignment: .topTrailing) {
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
                        .font(.system(size: 11, weight: .regular))
                        .foregroundStyle(.tertiary)
                }
            }
            .frame(width: Self.thumbnailWidth, height: Self.thumbnailHeight)
            .clipShape(RoundedRectangle(cornerRadius: FaloRadius.small, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: FaloRadius.small, style: .continuous)
                    .strokeBorder(
                        isSelected ? BonsaiWorldColors.accent : BonsaiWorldColors.border,
                        lineWidth: isSelected ? 2 : 1
                    )
            }

            if isPrimary {
                Image(systemName: "star.fill")
                    .font(.system(size: 7, weight: .semibold))
                    .foregroundStyle(BonsaiWorldColors.accent)
                    .padding(2)
                    .background(Circle().fill(Color.black.opacity(0.35)))
                    .offset(x: 2, y: -2)
                    .accessibilityLabel("Primary photo")
            }
        }
        .frame(width: Self.filmstripItemWidth)
        .contentShape(Rectangle())
        .onTapGesture(count: 2) {
            selectedImageID = imageID
            openViewer(for: imageID)
        }
        .onTapGesture(count: 1) {
            selectedImageID = imageID
        }
        .contextMenu {
            Button("Set as Primary") {
                onSetPrimary(imageID)
                selectedImageID = imageID
            }
            Button("Remove", role: .destructive) { onRemove(imageID) }
        }
    }

    private var addTile: some View {
        Button(action: onAddImage) {
            RoundedRectangle(cornerRadius: FaloRadius.small, style: .continuous)
                .strokeBorder(style: StrokeStyle(lineWidth: 1, dash: [3, 2]))
                .foregroundStyle(Color.primary.opacity(0.25))
                .frame(width: Self.thumbnailWidth, height: Self.thumbnailHeight)
                .overlay {
                    Image(systemName: "plus")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(.secondary)
                }
        }
        .buttonStyle(.plain)
        .help("Add Photo")
        .accessibilityLabel("Add Photo")
    }

    // MARK: - Loading

    private func reconcileSelection(with ids: [UUID]) {
        if let selectedImageID, ids.contains(selectedImageID) { return }
        selectedImageID = primaryImageID.flatMap { ids.contains($0) ? $0 : nil } ?? ids.first
    }

    private func loadMainImage() async {
        guard let selectedImageID else {
            mainImage = nil
            return
        }
        do {
            let nsImage = try await imageService.loadDisplayNSImage(
                for: selectedImageID,
                context: .treeThumbnail,
                maxPixelSize: 512
            )
            mainImage = Image(nsImage: nsImage)
        } catch {
            mainImage = nil
        }
    }

    private func loadThumbnails() async {
        let valid = Set(imageIDs)
        for imageID in imageIDs {
            if thumbnails[imageID] != nil { continue }
            do {
                let nsImage = try await imageService.loadDisplayNSImage(
                    for: imageID,
                    context: .treeThumbnail,
                    maxPixelSize: 128
                )
                thumbnails[imageID] = Image(nsImage: nsImage)
            } catch {
                continue
            }
        }
        thumbnails = thumbnails.filter { valid.contains($0.key) }
    }

    private func openViewer(for imageID: UUID) {
        appState.openImageInPlace(imageID: imageID)
    }
}
