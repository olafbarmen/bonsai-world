//
//  CropWorkspacePreviewPanel.swift
//  Bonsai World
//
//  Live presentation previews and aspect ratio controls.
//  Each frame has its own crop. Drag pans that frame only.
//

import SwiftUI

struct CropWorkspacePreviewPanel: View {
    let imageID: UUID
    @Binding var crops: [CropLivePreviewSurface: CGRect]
    @Binding var aspectMode: CropAspectRatioMode
    @Binding var selectedPreview: CropLivePreviewSurface
    let imageSize: CGSize
    let experienceLevel: CropWorkspaceExperienceLevel

    var body: some View {
        ScrollView(.vertical, showsIndicators: true) {
            VStack(alignment: .leading, spacing: FaloSpacing.xLarge) {
                if experienceLevel.showsAspectRatios {
                    aspectRatioSection
                }

                livePreviewSection

                if experienceLevel.showsAICropPlaceholder {
                    expertSection(title: "AI Suggestions") {
                        mutedText("AI crop suggestions not available yet")
                    }
                }
            }
            .padding(FaloSpacing.large)
        }
        .frame(width: CropWorkspaceLayout.previewPanelWidth)
        .background(.background)
        .overlay(alignment: .leading) {
            Rectangle()
                .fill(FaloColors.borderSubtle)
                .frame(width: 1)
        }
    }

    private var aspectRatioSection: some View {
        VStack(alignment: .leading, spacing: FaloSpacing.small) {
            sectionTitle("Aspect Ratio")

            ForEach(CropAspectRatioMode.menuOptions(for: experienceLevel), id: \.self) { mode in
                aspectRatioRow(mode)
            }
        }
    }

    private func aspectRatioRow(_ mode: CropAspectRatioMode) -> some View {
        Button {
            applyAspectMode(mode)
        } label: {
            HStack {
                Text(mode.title)
                    .font(FaloTypography.body)
                    .foregroundStyle(.primary)
                Spacer(minLength: 0)
                if aspectMode == mode {
                    Image(systemName: "checkmark")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(Color.accentColor)
                }
            }
            .padding(.vertical, FaloSpacing.xSmall)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .disabled(!mode.isSelectable)
        .opacity(mode.isSelectable ? 1 : 0.45)
        .help(mode.isSelectable ? mode.title : "Coming soon")
    }

    private var livePreviewSection: some View {
        VStack(alignment: .leading, spacing: FaloSpacing.medium) {
            sectionTitle("Live Preview")

            Text("Each frame has its own crop. Drag to pan that frame.")
                .font(FaloTypography.caption)
                .foregroundStyle(FaloColors.textSecondary)

            ForEach(CropLivePreviewSurface.allCases) { surface in
                previewTile(surface)
            }
        }
    }

    private func previewTile(_ surface: CropLivePreviewSurface) -> some View {
        VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
            Text(surface.title)
                .font(FaloTypography.caption.weight(.medium))
                .foregroundStyle(
                    selectedPreview == surface ? Color.accentColor : FaloColors.textSecondary
                )

            CroppedImagePreviewLoader(
                imageID: imageID,
                cropRect: cropBinding(for: surface),
                frameSize: surface.frameSize,
                cornerRadius: surface.cornerRadius,
                isActive: selectedPreview == surface,
                onActivate: { activate(surface) }
            )
        }
    }

    private func cropBinding(for surface: CropLivePreviewSurface) -> Binding<CGRect> {
        Binding(
            get: { crops[surface, default: CropGeometry.unitBounds] },
            set: { crops[surface] = $0 }
        )
    }

    @discardableResult
    private func activate(_ surface: CropLivePreviewSurface) -> CGRect {
        selectedPreview = surface
        aspectMode = surface.aspectMode
        return crops[surface, default: CropGeometry.unitBounds]
    }

    private func applyAspectMode(_ mode: CropAspectRatioMode) {
        if let surface = CropLivePreviewSurface.matching(aspectMode: mode) {
            _ = activate(surface)
            return
        }

        aspectMode = mode
        if let ratio = mode.fixedAspectRatio {
            crops[selectedPreview] = CropGeometry.matchingAspect(
                crops[selectedPreview, default: CropGeometry.unitBounds],
                aspectRatio: ratio
            )
        } else if mode == .original {
            let normalized = CropGeometry.normalizedAspect(
                visualAspect: selectedPreview.visualAspectRatio,
                imageSize: imageSize
            )
            crops[selectedPreview] = CropGeometry.centeredCrop(aspectRatio: normalized)
        }
    }

    @ViewBuilder
    private func expertSection(title: String, @ViewBuilder content: () -> some View) -> some View {
        VStack(alignment: .leading, spacing: FaloSpacing.small) {
            sectionTitle(title)
            content()
        }
    }

    private func sectionTitle(_ title: String) -> some View {
        Text(title)
            .font(FaloCardTypography.sectionTitle)
            .foregroundStyle(.secondary)
            .textCase(.uppercase)
            .tracking(FaloCardTypography.sectionTitleTracking)
    }

    private func mutedText(_ text: String) -> some View {
        Text(text)
            .font(FaloTypography.body)
            .foregroundStyle(FaloColors.textSecondary)
    }
}

enum CropWorkspaceLayout {
    static let toolsSidebarWidth: CGFloat = 220
    static let previewPanelWidth: CGFloat = 260

    static let treeThumbnailPreviewSize = GalleryLayout.portraitSize(width: 72)
    static let galleryCardPreviewSize = GalleryLayout.portraitSize(width: 105)
    static let dashboardPreviewSize = GalleryLayout.portraitSize(width: 96)
    static let collectionCardPreviewSize = GalleryLayout.portraitSize(width: 90)
}

/// Destination frames in Crop Workspace Live Preview. Each surface stores its own crop.
enum CropLivePreviewSurface: String, CaseIterable, Identifiable, Hashable {
    case treeThumbnail
    case galleryCard
    case dashboard
    case collectionCard

    var id: String { rawValue }

    var title: String {
        switch self {
        case .treeThumbnail: "Tree Thumbnail"
        case .galleryCard: "Gallery Card"
        case .dashboard: "Dashboard"
        case .collectionCard: "Collection Card"
        }
    }

    var frameSize: CGSize {
        switch self {
        case .treeThumbnail: CropWorkspaceLayout.treeThumbnailPreviewSize
        case .galleryCard: CropWorkspaceLayout.galleryCardPreviewSize
        case .dashboard: CropWorkspaceLayout.dashboardPreviewSize
        case .collectionCard: CropWorkspaceLayout.collectionCardPreviewSize
        }
    }

    var cornerRadius: CGFloat {
        self == .dashboard ? FaloRadius.medium : FaloRadius.small
    }

    var visualAspectRatio: CGFloat {
        frameSize.width / max(frameSize.height, 1)
    }

    var aspectMode: CropAspectRatioMode {
        .portrait
    }

    var context: ImagePresentationContext {
        ImagePresentationContext(rawValue: rawValue) ?? .galleryCard
    }

    static func matching(aspectMode: CropAspectRatioMode) -> CropLivePreviewSurface? {
        switch aspectMode {
        case .portrait: .galleryCard
        default: nil
        }
    }
}
