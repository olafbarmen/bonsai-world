//
//  GalleryPreviewSheet.swift
//  Bonsai World
//
//  Read-only larger preview — foundation for Prepare, metadata edit, and compare.
//

import AppKit
import SwiftUI

struct GalleryPreviewSheet: View {
    let entry: GalleryEntry
    let showsFeaturedBadge: Bool

    @Environment(ImageService.self) private var imageService
    @Environment(\.dismiss) private var dismiss

    @State private var displayImage: Image?
    @State private var isLoading = true

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: FaloSpacing.xLarge) {
                    previewImage
                    metadataSection
                }
                .padding(FaloSpacing.xLarge)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .faloScrollSurface()
            .background(.windowBackground)
            .navigationTitle(entry.photoName)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") {
                        dismiss()
                    }
                    .keyboardShortcut(.cancelAction)
                }
            }
        }
        .frame(minWidth: 560, minHeight: 480)
        .task(id: "\(entry.id.uuidString)-\(imageService.presentationRevision)") {
            await loadImage()
        }
    }

    private var previewImage: some View {
        Group {
            if let displayImage {
                displayImage
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                    .clipShape(RoundedRectangle(cornerRadius: FaloRadius.hero, style: .continuous))
            } else if isLoading {
                RoundedRectangle(cornerRadius: FaloRadius.hero, style: .continuous)
                    .fill(Color.primary.opacity(0.04))
                    .aspectRatio(GalleryLayout.imageAspectRatio, contentMode: .fit)
                    .overlay {
                        ProgressView()
                            .controlSize(.regular)
                    }
            } else {
                ContentUnavailableView(
                    "Image Unavailable",
                    systemImage: "photo",
                    description: Text("The image could not be loaded.")
                )
            }
        }
        .frame(maxWidth: .infinity)
    }

    private var metadataSection: some View {
        VStack(alignment: .leading, spacing: FaloSpacing.medium) {
            if entry.hasTreeContext, let treeName = entry.treeDisplayName {
                metadataRow(label: "Tree", value: treeName)
            }
            metadataRow(
                label: "Capture Date",
                value: ImageAsset.displayCaptureDate(entry.captureDate)
            )
            if entry.isPrimary || (showsFeaturedBadge && entry.isFeatured) {
                let roles = [
                    entry.isPrimary ? "Primary" : nil,
                    (showsFeaturedBadge && entry.isFeatured) ? "Featured" : nil
                ].compactMap { $0 }
                metadataRow(label: "Roles", value: roles.joined(separator: " · "))
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func metadataRow(label: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
            Text(label.uppercased())
                .font(FaloCardTypography.sectionTitle)
                .foregroundStyle(FaloColors.textSecondary)
                .tracking(FaloCardTypography.sectionTitleTracking)
            Text(value)
                .font(FaloCardTypography.fieldValue)
                .foregroundStyle(.primary)
        }
    }

    private func loadImage() async {
        isLoading = true
        displayImage = nil
        defer { isLoading = false }
        do {
            let nsImage = try await imageService.loadDisplayNSImage(for: entry.id)
            displayImage = Image(nsImage: nsImage)
        } catch {
            displayImage = nil
        }
    }
}
