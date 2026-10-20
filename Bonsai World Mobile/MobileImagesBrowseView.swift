//
//  MobileImagesBrowseView.swift
//  Bonsai World
//
//  Field → Images — browse the ImageAsset catalog (Mac Media → Images).
//

import SwiftUI

struct MobileImagesBrowseView: View {
    @Environment(DemoLibrary.self) private var library
    @Environment(\.openMobileTree) private var openMobileTree

    @State private var viewerPages: [MobilePhotoPage] = []
    @State private var viewerStartIndex = 0
    @State private var isViewerPresented = false

    private var assets: [ImageAsset] {
        library.orderedImageAssets
    }

    private let columns = [
        GridItem(.adaptive(minimum: 104, maximum: 160), spacing: FaloSpacing.small)
    ]

    var body: some View {
        Group {
            if assets.isEmpty {
                ContentUnavailableView(
                    "No Images",
                    systemImage: "photo.on.rectangle.angled",
                    description: Text("Photos you add to Trees, Seeds, and Yamadori Finds appear here.")
                )
            } else {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: FaloSpacing.small) {
                        ForEach(assets) { asset in
                            imageTile(asset)
                        }
                    }
                    .padding(.horizontal, FaloSpacing.medium)
                    .padding(.vertical, FaloSpacing.small)
                }
            }
        }
        .background(BonsaiWorldColors.canvas)
        .navigationTitle("Images")
        .navigationBarTitleDisplayMode(.large)
        .fullScreenCover(isPresented: $isViewerPresented) {
            MobilePhotoViewer(pages: viewerPages, startIndex: viewerStartIndex)
        }
    }

    private func imageTile(_ asset: ImageAsset) -> some View {
        let tree = library.tree(forImageID: asset.id)
        return Button {
            openViewer(startingAt: asset.id)
        } label: {
            VStack(alignment: .leading, spacing: FaloSpacing.xSmall) {
                MobileAssetImage(imageID: asset.id, style: .grid)
                    .aspectRatio(1, contentMode: .fit)
                Text(asset.photoName)
                    .font(FaloTypography.caption)
                    .foregroundStyle(BonsaiWorldColors.textPrimary)
                    .lineLimit(1)
                if let tree {
                    Text(MobileTreePresentation.title(for: tree))
                        .font(FaloTypography.caption)
                        .foregroundStyle(BonsaiWorldColors.textSecondary)
                        .lineLimit(1)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .contextMenu {
            if let tree {
                Button("Open Tree") {
                    openMobileTree(tree.id)
                }
            }
        }
        .accessibilityLabel(accessibilityLabel(for: asset, tree: tree))
        .accessibilityHint("Opens photo viewer")
    }

    private func openViewer(startingAt imageID: UUID) {
        let pages: [MobilePhotoPage] = assets.compactMap { asset in
            guard let data = library.jpegData(for: asset.id) else { return nil }
            return MobilePhotoPage(id: asset.id, data: data)
        }
        guard !pages.isEmpty else { return }
        viewerPages = pages
        viewerStartIndex = pages.firstIndex(where: { $0.id == imageID }) ?? 0
        isViewerPresented = true
    }

    private func accessibilityLabel(for asset: ImageAsset, tree: Tree?) -> String {
        if let tree {
            return "\(asset.photoName), \(MobileTreePresentation.title(for: tree))"
        }
        return asset.photoName
    }
}

#Preview {
    NavigationStack {
        MobileImagesBrowseView()
    }
    .environment(DemoLibrary.preview)
}
