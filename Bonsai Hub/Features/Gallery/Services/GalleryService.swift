//
//  GalleryService.swift
//  Bonsai World
//
//  Library-wide Gallery browse — resolves ImageAsset records with Tree context.
//  Gallery owns browse/filter logic; ImageService owns metadata and pixels.
//

import Foundation
import Observation

@Observable
@MainActor
final class GalleryService {
    private let imageService: ImageService
    private let treeService: TreeService

    init(imageService: ImageService, treeService: TreeService) {
        self.imageService = imageService
        self.treeService = treeService
    }

    /// Entries for the active browse filter, sorted for display.
    func entries(filter: GalleryBrowseFilter) -> [GalleryEntry] {
        let treeContext = buildTreeContextIndex()
        let all = imageService.allAssets().map { asset in
            makeEntry(asset: asset, treeContext: treeContext)
        }

        let filtered: [GalleryEntry]
        switch filter {
        case .all:
            filtered = all
        case .primary:
            filtered = all.filter(\.isPrimary)
        case .latest:
            filtered = all
        case .featured:
            filtered = all.filter(\.isFeatured)
        case .unattached:
            filtered = all.filter { !$0.hasTreeContext }
        case .byTree, .byCollection, .bySpecies, .byLocation, .byPot, .byTool, .byYamadori, .beforeAfter:
            // Reserved filters — return empty until scoped browse ships.
            filtered = []
        }

        return sort(filtered, for: filter)
    }

    func entry(for imageID: UUID) -> GalleryEntry? {
        guard let asset = imageService.metadata(for: imageID) else { return nil }
        return makeEntry(asset: asset, treeContext: buildTreeContextIndex())
    }

    /// Other images attached to the same library object — Image Workspace filmstrip.
    /// Never sorted by capture date, collection, location, or similarity.
    func relatedEntries(for entry: GalleryEntry) -> [GalleryEntry] {
        guard let attachment = entry.objectAttachment else { return [] }

        switch attachment.kind {
        case .tree:
            return relatedEntriesForTree(treeID: attachment.objectID, excludingImageID: entry.id)
        case .pot, .tool:
            // Reserved — return images for the same Pot / Tool when attachment ships.
            return []
        }
    }

    // MARK: - Private

    private func relatedEntriesForTree(treeID: UUID, excludingImageID: UUID) -> [GalleryEntry] {
        guard let tree = treeService.getTree(id: treeID) else { return [] }
        let treeContext = buildTreeContextIndex()
        return tree.imageIDs
            .filter { $0 != excludingImageID }
            .compactMap { imageID in
                guard let asset = imageService.metadata(for: imageID) else { return nil }
                return makeEntry(asset: asset, treeContext: treeContext)
            }
    }

    private struct TreeContext {
        var treeID: UUID
        var displayName: String
        var isPrimary: Bool
    }

    private func buildTreeContextIndex() -> [UUID: TreeContext] {
        var index: [UUID: TreeContext] = [:]
        for tree in treeService.trees {
            let displayName = Self.treeDisplayName(tree)
            if let primaryID = tree.primaryImageID {
                index[primaryID] = TreeContext(
                    treeID: tree.id,
                    displayName: displayName,
                    isPrimary: true
                )
            }
            for imageID in tree.imageIDs where index[imageID] == nil {
                index[imageID] = TreeContext(
                    treeID: tree.id,
                    displayName: displayName,
                    isPrimary: false
                )
            }
        }
        return index
    }

    private func makeEntry(
        asset: ImageAsset,
        treeContext: [UUID: TreeContext]
    ) -> GalleryEntry {
        let context = treeContext[asset.id]
        let isPrimary = context?.isPrimary == true || asset.isPrimary
        return GalleryEntry(
            asset: asset,
            treeID: context?.treeID,
            treeDisplayName: context?.displayName,
            isPrimary: isPrimary,
            isFeatured: asset.isFeatured
        )
    }

    private func sort(_ entries: [GalleryEntry], for filter: GalleryBrowseFilter) -> [GalleryEntry] {
        switch filter {
        case .all:
            return entries.sorted { lhs, rhs in
                lhs.captureDate > rhs.captureDate
            }
        case .primary:
            return entries.sorted { lhs, rhs in
                let left = lhs.treeDisplayName ?? lhs.photoName
                let right = rhs.treeDisplayName ?? rhs.photoName
                return left.localizedCaseInsensitiveCompare(right) == .orderedAscending
            }
        case .latest:
            return entries.sorted { lhs, rhs in
                if lhs.captureDate != rhs.captureDate {
                    return lhs.captureDate > rhs.captureDate
                }
                return lhs.photoName.localizedCaseInsensitiveCompare(rhs.photoName) == .orderedAscending
            }
        case .featured, .unattached, .byTree, .byCollection, .bySpecies, .byLocation,
             .byPot, .byTool, .byYamadori, .beforeAfter:
            return entries.sorted { lhs, rhs in
                lhs.captureDate > rhs.captureDate
            }
        }
    }

    private static func treeDisplayName(_ tree: Tree) -> String {
        let nickname = tree.nickname.trimmingCharacters(in: .whitespacesAndNewlines)
        if !nickname.isEmpty { return nickname }
        let botanical = tree.botanicalName.trimmingCharacters(in: .whitespacesAndNewlines)
        return botanical.isEmpty ? "Untitled Tree" : botanical
    }
}
