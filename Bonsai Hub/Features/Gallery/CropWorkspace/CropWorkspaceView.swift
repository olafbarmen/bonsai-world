//
//  CropWorkspaceView.swift
//  Bonsai World
//
//  Focused non-destructive crop surface (Blueprint §5.5).
//  Original bytes never modified — only presentation metadata is saved.
//

import SwiftUI

struct CropWorkspaceView: View {
    let imageID: UUID

    @Environment(ImageService.self) private var imageService
    @Environment(\.dismissWindow) private var dismissWindow

    @State private var crops: [CropLivePreviewSurface: CGRect] = [:]
    @State private var aspectMode: CropAspectRatioMode
    @State private var zoomLevel: Double
    @State private var hasUnsavedChanges = false
    @State private var isComparingOriginal = false
    @State private var comingSoonTitle: String?
    @State private var selectedPreview: CropLivePreviewSurface = .galleryCard
    @State private var suppressDirty = false

    private let experienceLevel: CropWorkspaceExperienceLevel = .current

    init(imageID: UUID) {
        self.imageID = imageID
        _aspectMode = State(initialValue: .portrait)
        _zoomLevel = State(initialValue: 1.0)
    }

    var body: some View {
        NavigationSplitView {
            cropToolsSidebar
        } detail: {
            workspaceContent
        }
        .navigationSplitViewStyle(.balanced)
        .frame(minWidth: 980, minHeight: 640)
        .onChange(of: crops) { _, _ in
            if suppressDirty {
                suppressDirty = false
                hasUnsavedChanges = false
                return
            }
            markDirty()
        }
        .onExitCommand {
            cancel()
        }
        .onAppear {
            loadSavedMetadata()
        }
        .alert(
            "Coming Soon",
            isPresented: Binding(
                get: { comingSoonTitle != nil },
                set: { if !$0 { comingSoonTitle = nil } }
            )
        ) {
            Button("OK", role: .cancel) { comingSoonTitle = nil }
        } message: {
            Text(comingSoonTitle.map { "“\($0)” is not available yet." } ?? "")
        }
    }

    private func loadSavedMetadata() {
        let fallback = imageService.legacyPresentationMetadata(for: imageID)?.cropNormalizedRect.cgRect
            ?? CropGeometry.unitBounds
        var loaded: [CropLivePreviewSurface: CGRect] = [:]
        for surface in CropLivePreviewSurface.allCases {
            if let exact = imageService.exactPresentationMetadata(for: imageID, context: surface.context) {
                loaded[surface] = exact.cropNormalizedRect.cgRect
            } else {
                let normalized = CropGeometry.normalizedAspect(
                    visualAspect: surface.visualAspectRatio,
                    imageSize: imagePixelSize
                )
                loaded[surface] = CropGeometry.matchingAspect(fallback, aspectRatio: normalized)
            }
        }
        suppressDirty = true
        crops = loaded
        selectedPreview = .galleryCard
        aspectMode = CropLivePreviewSurface.galleryCard.aspectMode
        zoomLevel = imageService.legacyPresentationMetadata(for: imageID)?.zoomLevel
            ?? imageService.exactPresentationMetadata(for: imageID, context: .galleryCard)?.zoomLevel
            ?? 1.0
        hasUnsavedChanges = false
    }

    private var photoTitle: String {
        imageService.photoName(for: imageID)
    }

    @ViewBuilder
    private var workspaceContent: some View {
        if imageService.metadata(for: imageID) != nil {
            VStack(spacing: 0) {
                CropWorkspaceHeader(title: photoTitle)

                HStack(spacing: 0) {
                    CropWorkspaceCanvasView(
                        imageID: imageID,
                        cropRect: selectedCropBinding,
                        aspectMode: $aspectMode,
                        hidesCropOverlay: isComparingOriginal,
                        lockedNormalizedAspect: canvasLockedAspect
                    )
                    .frame(maxWidth: .infinity, maxHeight: .infinity)

                    CropWorkspacePreviewPanel(
                        imageID: imageID,
                        crops: $crops,
                        aspectMode: $aspectMode,
                        selectedPreview: $selectedPreview,
                        imageSize: imagePixelSize,
                        experienceLevel: experienceLevel
                    )
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .background(.windowBackground)
        } else {
            ContentUnavailableView(
                "Image Not Found",
                systemImage: "photo",
                description: Text("This image may have been removed from the library.")
            )
        }
    }

    private var cropToolsSidebar: some View {
        VStack(alignment: .leading, spacing: 0) {
            SidebarSectionHeader(
                title: "Crop Tools",
                topPadding: FaloSpacing.large
            )
            .padding(.horizontal, FaloSpacing.small)

            VStack(alignment: .leading, spacing: 0) {
                ForEach(CropWorkspaceToolsCatalog.actions(for: experienceLevel)) { definition in
                    QuickActionRow(definition: definition, onAction: performTool)
                    .padding(.horizontal, FaloSpacing.small)
                }
            }

            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(.windowBackground)
        .navigationSplitViewColumnWidth(
            min: 180,
            ideal: CropWorkspaceLayout.toolsSidebarWidth,
            max: 260
        )
    }

    private func performTool(_ definition: ActionDefinition) {
        switch definition.availability {
        case .comingSoon:
            comingSoonTitle = definition.title
        case .disabled:
            break
        case .available:
            switch definition.id {
            case CropWorkspaceToolsCatalog.saveCropID:
                saveCrop()
            case CropWorkspaceToolsCatalog.resetCropID:
                resetCrop()
            case CropWorkspaceToolsCatalog.compareOriginalID:
                isComparingOriginal.toggle()
            case CropWorkspaceToolsCatalog.cancelID:
                cancel()
            default:
                break
            }
        }
    }

    private func saveCrop() {
        let items = CropLivePreviewSurface.allCases.map { surface in
            ImagePresentationMetadata(
                sourceImageID: imageID,
                cropNormalizedRect: NormalizedCropRect(
                    crops[surface] ?? CropGeometry.unitBounds
                ),
                aspectRatioMode: surface.aspectMode,
                zoomLevel: zoomLevel,
                contextID: surface.context.rawValue
            )
        }
        imageService.savePresentationMetadata(items)
        hasUnsavedChanges = false
        closeWindow()
    }

    private func resetCrop() {
        var reset: [CropLivePreviewSurface: CGRect] = [:]
        for surface in CropLivePreviewSurface.allCases {
            let normalized = CropGeometry.normalizedAspect(
                visualAspect: surface.visualAspectRatio,
                imageSize: imagePixelSize
            )
            reset[surface] = CropGeometry.centeredCrop(aspectRatio: normalized)
        }
        suppressDirty = true
        crops = reset
        selectedPreview = .galleryCard
        aspectMode = CropLivePreviewSurface.galleryCard.aspectMode
        zoomLevel = 1.0
        isComparingOriginal = false
        imageService.resetPresentationMetadata(for: imageID)
        suppressDirty = true
        hasUnsavedChanges = false
    }

    private func cancel() {
        closeWindow()
    }

    private func closeWindow() {
        dismissWindow(id: CropWorkspaceWindowContext.windowID)
    }

    private func markDirty() {
        hasUnsavedChanges = true
    }

    private var selectedCropBinding: Binding<CGRect> {
        Binding(
            get: { crops[selectedPreview, default: CropGeometry.unitBounds] },
            set: { crops[selectedPreview] = $0 }
        )
    }

    private var imagePixelSize: CGSize {
        let asset = imageService.metadata(for: imageID)
        let width = CGFloat(asset?.width ?? 0)
        let height = CGFloat(asset?.height ?? 0)
        if width > 0, height > 0 {
            return CGSize(width: width, height: height)
        }
        return CGSize(width: 1, height: 1)
    }

    private var canvasLockedAspect: CGFloat {
        CropGeometry.normalizedAspect(
            visualAspect: selectedPreview.visualAspectRatio,
            imageSize: imagePixelSize
        )
    }
}

// MARK: - Header

private struct CropWorkspaceHeader: View {
    let title: String

    var body: some View {
        VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
            Text("Crop Photo")
                .font(.title2.weight(.semibold))
                .foregroundStyle(.primary)

            HStack(spacing: FaloSpacing.xSmall) {
                Text("Media")
                chevron
                Text("Images")
                chevron
                Text(title)
                    .foregroundStyle(FaloColors.textSecondary)
                    .lineLimit(1)
            }
            .font(FaloTypography.caption)
            .foregroundStyle(FaloColors.textSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, FaloSpacing.large)
        .padding(.vertical, FaloSpacing.medium)
        .background(.bar)
        .overlay(alignment: .bottom) {
            Rectangle()
                .fill(FaloColors.borderSubtle)
                .frame(height: 1)
        }
    }

    private var chevron: some View {
        Image(systemName: "chevron.right")
            .font(.caption2.weight(.semibold))
            .foregroundStyle(FaloColors.textSecondary)
    }
}
