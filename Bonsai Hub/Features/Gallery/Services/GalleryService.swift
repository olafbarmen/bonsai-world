//
//  GalleryService.swift
//  Bonsai World
//
//  Library-wide Gallery browse — resolves ImageAsset records with Tree / inventory context.
//  Gallery owns browse/filter logic; ImageService owns metadata and pixels.
//

import Foundation
import Observation

@Observable
@MainActor
final class GalleryService {
    private let imageService: ImageService
    private let treeService: TreeService
    private let yamadoriService: YamadoriService
    private let potService: PotService?
    private let soilStockService: SoilStockService?
    private let inventoryStockService: InventoryStockService?
    private let userProfile: UserProfileStore?

    init(
        imageService: ImageService,
        treeService: TreeService,
        yamadoriService: YamadoriService,
        potService: PotService? = nil,
        soilStockService: SoilStockService? = nil,
        inventoryStockService: InventoryStockService? = nil,
        userProfile: UserProfileStore? = nil
    ) {
        self.imageService = imageService
        self.treeService = treeService
        self.yamadoriService = yamadoriService
        self.potService = potService
        self.soilStockService = soilStockService
        self.inventoryStockService = inventoryStockService
        self.userProfile = userProfile
    }

    /// Entries for the active browse filter, sorted for display.
    func entries(filter: GalleryBrowseFilter) -> [GalleryEntry] {
        let treeContext = buildTreeContextIndex()
        let libraryAttachments = buildLibraryAttachmentIndex()
        let all = imageService.allAssets().map { asset in
            makeEntry(asset: asset, treeContext: treeContext, libraryAttachments: libraryAttachments)
        }

        let referenceIDs = treeService.referenceImageIDs()
        let treePhotos = all.filter { !referenceIDs.contains($0.id) }

        let filtered: [GalleryEntry]
        switch filter {
        case .all:
            filtered = treePhotos
        case .primary:
            filtered = treePhotos.filter(\.isPrimary)
        case .latest:
            filtered = treePhotos
        case .referenceImages:
            filtered = all.filter { referenceIDs.contains($0.id) }
        case .uncollectedFindings:
            let imageIDs = uncollectedFindingImageIDs()
            filtered = all.filter { imageIDs.contains($0.id) }
        case .yamadoriTrees:
            let imageIDs = yamadoriTreeImageIDs()
            filtered = treePhotos.filter { imageIDs.contains($0.id) }
        case .pots:
            let imageIDs = potImageIDs()
            filtered = all.filter { imageIDs.contains($0.id) }
        case .profilePhoto:
            let imageIDs = profilePhotoImageIDs()
            filtered = all.filter { imageIDs.contains($0.id) }
        case .wire:
            let imageIDs = inventoryStockImageIDs(kind: .wire)
            filtered = all.filter { imageIDs.contains($0.id) }
        case .tools:
            let imageIDs = inventoryStockImageIDs(kind: .tool)
            filtered = all.filter { imageIDs.contains($0.id) }
        case .chemicals:
            let imageIDs = inventoryStockImageIDs(kind: .chemical)
            filtered = all.filter { imageIDs.contains($0.id) }
        case .consumables:
            let imageIDs = inventoryStockImageIDs(kind: .consumable)
            filtered = all.filter { imageIDs.contains($0.id) }
        case .fertilizers:
            let imageIDs = inventoryStockImageIDs(kind: .fertilizer)
            filtered = all.filter { imageIDs.contains($0.id) }
        case .soil:
            let imageIDs = soilStockImageIDs()
            filtered = all.filter { imageIDs.contains($0.id) }
        case .featured:
            filtered = all.filter(\.isFeatured)
        case .unattached:
            filtered = all.filter { !$0.hasTreeContext }
        case .byTree, .byCollection, .bySpecies, .byLocation, .byYamadori, .beforeAfter:
            // Reserved filters — return empty until scoped browse ships.
            filtered = []
        }

        return sort(filtered, for: filter)
    }

    func entry(for imageID: UUID) -> GalleryEntry? {
        guard let asset = imageService.metadata(for: imageID) else { return nil }
        return makeEntry(
            asset: asset,
            treeContext: buildTreeContextIndex(),
            libraryAttachments: buildLibraryAttachmentIndex()
        )
    }

    /// Other images attached to the same library object — Image Workspace filmstrip.
    /// Never sorted by capture date, collection, location, or similarity.
    func relatedEntries(for entry: GalleryEntry) -> [GalleryEntry] {
        guard let attachment = entry.objectAttachment else { return [] }

        switch attachment.kind {
        case .tree:
            return relatedEntriesForTree(treeID: attachment.objectID, excludingImageID: entry.id)
        case .pot:
            return relatedEntriesForPot(potID: attachment.objectID, excludingImageID: entry.id)
        case .soil:
            return relatedEntriesForSoil(itemID: attachment.objectID, excludingImageID: entry.id)
        case .wire, .tool, .chemical, .consumable, .fertilizer:
            return relatedEntriesForInventoryStock(
                itemID: attachment.objectID,
                excludingImageID: entry.id
            )
        }
    }

    // MARK: - Private

    private func uncollectedFindingImageIDs() -> Set<UUID> {
        var ids = Set<UUID>()
        for find in yamadoriService.finds where find.status.isUncollected {
            ids.formUnion(find.imageIDs)
            if let primary = find.primaryImageID {
                ids.insert(primary)
            }
        }
        return ids
    }

    private func yamadoriTreeImageIDs() -> Set<UUID> {
        var ids = Set<UUID>()
        for tree in treeService.trees where tree.yamadoriNursery {
            ids.formUnion(tree.imageIDs)
            if let primary = tree.primaryImageID {
                ids.insert(primary)
            }
        }
        return ids
    }

    private func potImageIDs() -> Set<UUID> {
        guard let potService else { return [] }
        var ids = Set<UUID>()
        for pot in potService.pots {
            ids.formUnion(pot.imageIDs)
            ids.formUnion(pot.stampImageIDs)
            if let primary = pot.primaryImageID {
                ids.insert(primary)
            }
        }
        return ids
    }

    private func profilePhotoImageIDs() -> Set<UUID> {
        guard let id = userProfile?.profileImageID else { return [] }
        return [id]
    }

    private func soilStockImageIDs() -> Set<UUID> {
        guard let soilStockService else { return [] }
        var ids = Set<UUID>()
        for item in soilStockService.items {
            ids.formUnion(item.imageIDs)
            if let primary = item.primaryImageID {
                ids.insert(primary)
            }
        }
        return ids
    }

    private func inventoryStockImageIDs(kind: InventoryStockKind) -> Set<UUID> {
        guard let inventoryStockService else { return [] }
        var ids = Set<UUID>()
        for item in inventoryStockService.items(for: kind) {
            ids.formUnion(item.imageIDs)
            if let primary = item.primaryImageID {
                ids.insert(primary)
            }
        }
        return ids
    }

    private func relatedEntriesForTree(treeID: UUID, excludingImageID: UUID) -> [GalleryEntry] {
        guard let tree = treeService.getTree(id: treeID) else { return [] }
        return relatedEntries(fromOrderedImageIDs: tree.imageIDs, excludingImageID: excludingImageID)
    }

    private func relatedEntriesForPot(potID: UUID, excludingImageID: UUID) -> [GalleryEntry] {
        guard let pot = potService?.getPot(id: potID) else { return [] }
        var ordered = pot.imageIDs
        for stampID in pot.stampImageIDs where !ordered.contains(stampID) {
            ordered.append(stampID)
        }
        return relatedEntries(fromOrderedImageIDs: ordered, excludingImageID: excludingImageID)
    }

    private func relatedEntriesForSoil(itemID: UUID, excludingImageID: UUID) -> [GalleryEntry] {
        guard let item = soilStockService?.item(id: itemID) else { return [] }
        return relatedEntries(fromOrderedImageIDs: item.imageIDs, excludingImageID: excludingImageID)
    }

    private func relatedEntriesForInventoryStock(
        itemID: UUID,
        excludingImageID: UUID
    ) -> [GalleryEntry] {
        guard let item = inventoryStockService?.item(id: itemID) else { return [] }
        return relatedEntries(fromOrderedImageIDs: item.imageIDs, excludingImageID: excludingImageID)
    }

    private func relatedEntries(
        fromOrderedImageIDs imageIDs: [UUID],
        excludingImageID: UUID
    ) -> [GalleryEntry] {
        let treeContext = buildTreeContextIndex()
        let libraryAttachments = buildLibraryAttachmentIndex()
        return imageIDs
            .filter { $0 != excludingImageID }
            .compactMap { imageID in
                guard let asset = imageService.metadata(for: imageID) else { return nil }
                return makeEntry(
                    asset: asset,
                    treeContext: treeContext,
                    libraryAttachments: libraryAttachments
                )
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

    /// Image ID → Pot / Soil / Inventory stock attachment (tree ownership wins in ``makeEntry``).
    private func buildLibraryAttachmentIndex() -> [UUID: ImageObjectAttachment] {
        var index: [UUID: ImageObjectAttachment] = [:]

        if let potService {
            for pot in potService.pots {
                let attachment = ImageObjectAttachment(kind: .pot, objectID: pot.id)
                register(imageIDs: pot.imageIDs, primary: pot.primaryImageID, attachment: attachment, into: &index)
                for stampID in pot.stampImageIDs where index[stampID] == nil {
                    index[stampID] = attachment
                }
            }
        }

        if let soilStockService {
            for item in soilStockService.items {
                let attachment = ImageObjectAttachment(kind: .soil, objectID: item.id)
                register(
                    imageIDs: item.imageIDs,
                    primary: item.primaryImageID,
                    attachment: attachment,
                    into: &index
                )
            }
        }

        if let inventoryStockService {
            for item in inventoryStockService.items {
                guard let kind = ImageObjectKind(inventoryKind: item.kind) else { continue }
                let attachment = ImageObjectAttachment(kind: kind, objectID: item.id)
                register(
                    imageIDs: item.imageIDs,
                    primary: item.primaryImageID,
                    attachment: attachment,
                    into: &index
                )
            }
        }

        return index
    }

    private func register(
        imageIDs: [UUID],
        primary: UUID?,
        attachment: ImageObjectAttachment,
        into index: inout [UUID: ImageObjectAttachment]
    ) {
        if let primary {
            index[primary] = attachment
        }
        for imageID in imageIDs where index[imageID] == nil {
            index[imageID] = attachment
        }
    }

    private func makeEntry(
        asset: ImageAsset,
        treeContext: [UUID: TreeContext],
        libraryAttachments: [UUID: ImageObjectAttachment]
    ) -> GalleryEntry {
        let context = treeContext[asset.id]
        let isPrimary = context?.isPrimary == true || asset.isPrimary
        let libraryAttachment = context == nil ? libraryAttachments[asset.id] : nil
        return GalleryEntry(
            asset: asset,
            treeID: context?.treeID,
            treeDisplayName: context?.displayName,
            libraryObjectAttachment: libraryAttachment,
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
        case .featured, .unattached, .referenceImages, .uncollectedFindings, .yamadoriTrees,
             .pots, .profilePhoto, .wire, .tools, .chemicals, .consumables, .fertilizers, .soil,
             .byTree, .byCollection, .bySpecies, .byLocation, .byYamadori, .beforeAfter:
            return entries.sorted { lhs, rhs in
                lhs.captureDate > rhs.captureDate
            }
        }
    }

    /// Unlinks the image from Trees / Yamadori / Pot / stock / profile, then deletes catalog + bytes.
    func deleteLibraryImage(id: UUID) async throws {
        for tree in treeService.trees where tree.imageIDs.contains(id) || tree.primaryImageID == id {
            try? treeService.removeImage(treeID: tree.id, imageID: id)
        }

        for find in yamadoriService.finds where find.imageIDs.contains(id) || find.primaryImageID == id {
            try? yamadoriService.removeImage(findID: find.id, imageID: id)
        }

        if let potService {
            for pot in potService.pots {
                if pot.imageIDs.contains(id) || pot.primaryImageID == id {
                    try? potService.removeImage(potID: pot.id, imageID: id)
                }
                if pot.stampImageIDs.contains(id) {
                    try? potService.removeStampImage(potID: pot.id, imageID: id)
                }
            }
        }

        if let soilStockService {
            for item in soilStockService.items where item.imageIDs.contains(id) || item.primaryImageID == id {
                try? soilStockService.removeImage(itemID: item.id, imageID: id)
            }
        }

        if let inventoryStockService {
            for item in inventoryStockService.items where item.imageIDs.contains(id) || item.primaryImageID == id {
                try? inventoryStockService.removeImage(itemID: item.id, imageID: id)
            }
        }

        if userProfile?.profileImageID == id {
            userProfile?.profileImageID = nil
        }

        try await imageService.deletePhoto(id: id)
    }

    private static func treeDisplayName(_ tree: Tree) -> String {
        let nickname = tree.nickname.trimmingCharacters(in: .whitespacesAndNewlines)
        if !nickname.isEmpty { return nickname }
        let botanical = tree.botanicalName.trimmingCharacters(in: .whitespacesAndNewlines)
        return botanical.isEmpty ? "Untitled Tree" : botanical
    }
}
