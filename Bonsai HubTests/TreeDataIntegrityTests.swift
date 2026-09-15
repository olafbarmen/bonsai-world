//
//  TreeDataIntegrityTests.swift
//  Bonsai HubTests
//
//  Photo SSOT + measurement history integrity.
//

import Foundation
import Testing
@testable import Bonsai_Hub

@MainActor
struct TreeDataIntegrityTests {

    private func makeTempStorage() throws -> (StorageService, URL) {
        let temp = FileManager.default.temporaryDirectory
            .appendingPathComponent("bonsai-data-integrity-\(UUID().uuidString)", isDirectory: true)
        try FileManager.default.createDirectory(at: temp, withIntermediateDirectories: true)
        let provider = LocalStorageProvider(
            rootURL: temp,
            libraryLocation: LibraryLocationConfiguration(kind: .customFolder, bookmarkData: Data())
        )
        let storage = StorageService(provider: provider)
        try storage.ensureLibraryFolderStructure()
        return (storage, temp)
    }

    private func makeTreeService(
        previewData: PreviewData,
        photoIndex: TreePhotoIndexStore
    ) -> TreeService {
        TreeService(
            repository: PreviewTreeRepository(previewData: previewData),
            collectionRepository: PreviewCollectionRepository(previewData: previewData),
            photoIndex: photoIndex
        )
    }

    @Test func indexDoesNotOverwriteTreePhotosThatAlreadyExist() throws {
        let (storage, temp) = try makeTempStorage()
        defer { try? FileManager.default.removeItem(at: temp) }

        let photoIndex = TreePhotoIndexStore(storage: storage)
        let previewData = PreviewData()
        let treeService = makeTreeService(previewData: previewData, photoIndex: photoIndex)

        var tree = try treeService.createTree(
            Tree(
                botanicalName: "Pinus mugo",
                bonsaiName: "PIN-MUG-INT-2026-001",
                genusID: UUID(),
                speciesID: UUID(),
                locationID: UUID()
            )
        )
        let treePhoto = UUID()
        let staleIndexPhoto = UUID()
        tree.primaryImageID = treePhoto
        tree.imageIDs = [treePhoto]
        tree = try treeService.updateTree(tree)

        // Stale index claims a different photo — Tree must win on next service init.
        photoIndex.saveBinding(treeID: tree.id, primaryImageID: staleIndexPhoto, imageIDs: [staleIndexPhoto])

        let reloaded = makeTreeService(previewData: previewData, photoIndex: photoIndex)
        let loaded = try #require(reloaded.getTree(id: tree.id))
        #expect(loaded.primaryImageID == treePhoto)
        #expect(loaded.imageIDs == [treePhoto])
        #expect(photoIndex.binding(for: tree.id)?.primaryImageID == treePhoto)
    }

    @Test func emptyTreeReceivesPhotosFromIndexOnceThenIndexMirrorsTree() throws {
        let (storage, temp) = try makeTempStorage()
        defer { try? FileManager.default.removeItem(at: temp) }

        let photoIndex = TreePhotoIndexStore(storage: storage)
        #expect(photoIndex.treeIsPhotoSourceOfTruth == false)

        let previewData = PreviewData()
        let treeID = UUID()
        let legacyPhoto = UUID()
        let seed = Tree(
            id: treeID,
            botanicalName: "Pinus mugo",
            bonsaiName: "PIN-MUG-INT-2026-002",
            genusID: UUID(),
            speciesID: UUID(),
            locationID: UUID()
        )
        previewData.trees = [seed]
        photoIndex.saveBinding(treeID: treeID, primaryImageID: legacyPhoto, imageIDs: [legacyPhoto])

        let treeService = makeTreeService(previewData: previewData, photoIndex: photoIndex)
        let loaded = try #require(treeService.getTree(id: treeID))
        #expect(loaded.primaryImageID == legacyPhoto)
        #expect(loaded.imageIDs == [legacyPhoto])
        #expect(photoIndex.treeIsPhotoSourceOfTruth)
        #expect(photoIndex.binding(for: treeID)?.primaryImageID == legacyPhoto)
    }

    @Test func deletedPhotosAreNotRevivedByStaleIndex() throws {
        let (storage, temp) = try makeTempStorage()
        defer { try? FileManager.default.removeItem(at: temp) }

        let photoIndex = TreePhotoIndexStore(storage: storage)
        let previewData = PreviewData()
        let treeService = makeTreeService(previewData: previewData, photoIndex: photoIndex)

        var tree = try treeService.createTree(
            Tree(
                botanicalName: "Pinus mugo",
                bonsaiName: "PIN-MUG-INT-2026-003",
                genusID: UUID(),
                speciesID: UUID(),
                locationID: UUID()
            )
        )
        let imageID = UUID()
        tree.primaryImageID = imageID
        tree.imageIDs = [imageID]
        tree = try treeService.updateTree(tree)

        tree.primaryImageID = nil
        tree.imageIDs = []
        tree = try treeService.updateTree(tree)

        // After first TreeService init, migration is locked (Tree is SSOT).
        #expect(photoIndex.treeIsPhotoSourceOfTruth)

        // Corrupt index as if an old cache still held the deleted membership.
        photoIndex.saveBinding(treeID: tree.id, primaryImageID: imageID, imageIDs: [imageID])

        let reloaded = makeTreeService(previewData: previewData, photoIndex: photoIndex)
        let loaded = try #require(reloaded.getTree(id: tree.id))
        #expect(loaded.primaryImageID == nil)
        #expect(loaded.imageIDs.isEmpty)
        #expect(photoIndex.binding(for: tree.id)?.imageIDs.isEmpty == true)
    }

    @Test func restoredUnlockedIndexCannotRefillOnceSSOTFileLocks() throws {
        let (storage, temp) = try makeTempStorage()
        defer { try? FileManager.default.removeItem(at: temp) }

        let photoIndex = TreePhotoIndexStore(storage: storage)
        let previewData = PreviewData()
        let treeService = makeTreeService(previewData: previewData, photoIndex: photoIndex)

        var tree = try treeService.createTree(
            Tree(
                botanicalName: "Pinus mugo",
                bonsaiName: "PIN-MUG-INT-2026-004",
                genusID: UUID(),
                speciesID: UUID(),
                locationID: UUID()
            )
        )
        let imageID = UUID()
        tree.primaryImageID = imageID
        tree.imageIDs = [imageID]
        tree = try treeService.updateTree(tree)
        tree.primaryImageID = nil
        tree.imageIDs = []
        tree = try treeService.updateTree(tree)
        #expect(photoIndex.treeIsPhotoSourceOfTruth)

        // Simulate restoring an old unlocked TreePhotoIndex.json while the SSOT lock file remains.
        let stalePhoto = UUID()
        let corruptIndex = TreePhotoIndex(
            bindings: [
                TreePhotoBinding(treeID: tree.id, primaryImageID: stalePhoto, imageIDs: [stalePhoto])
            ],
            treeIsPhotoSourceOfTruth: false
        )
        let encoder = JSONEncoder()
        try storage.savePackageFile(
            relativePath: LibraryPackageLayout.treePhotoIndexFileName,
            data: try encoder.encode(corruptIndex)
        )

        let reloadedIndex = TreePhotoIndexStore(storage: storage)
        #expect(reloadedIndex.treeIsPhotoSourceOfTruth)

        let reloaded = makeTreeService(previewData: previewData, photoIndex: reloadedIndex)
        let loaded = try #require(reloaded.getTree(id: tree.id))
        #expect(loaded.primaryImageID == nil)
        #expect(loaded.imageIDs.isEmpty)
        #expect(reloadedIndex.binding(for: tree.id)?.imageIDs.isEmpty == true)
    }

    @Test func applyDetailDraftDoesNotWriteMeasurementDimensions() throws {
        let previewData = PreviewData()
        let treeService = TreeService(
            repository: PreviewTreeRepository(previewData: previewData),
            collectionRepository: PreviewCollectionRepository(previewData: previewData)
        )
        var tree = try treeService.createTree(
            Tree(
                botanicalName: "Pinus mugo",
                bonsaiName: "PIN-MUG-INT-2026-010",
                genusID: UUID(),
                speciesID: UUID(),
                locationID: UUID(),
                heightMillimetres: 100,
                crownWidthMillimetres: 80,
                nebariWidthMillimetres: 40,
                trunkDiameterMillimetres: 20
            )
        )
        var draft = TreeDetailDraft.capture(from: tree, collectionIDs: [])
        draft.heightMillimetres = 999
        draft.crownWidthMillimetres = 888
        draft.nebariWidthMillimetres = 777
        draft.trunkDiameterMillimetres = 666
        draft.nickname = "Edited"

        try treeService.applyDetailDraft(id: tree.id, draft: draft)
        tree = try #require(treeService.getTree(id: tree.id))
        #expect(tree.nickname == "Edited")
        #expect(tree.heightMillimetres == 100)
        #expect(tree.crownWidthMillimetres == 80)
        #expect(tree.nebariWidthMillimetres == 40)
        #expect(tree.trunkDiameterMillimetres == 20)
    }

    @Test func reconcileAlignsTreeDimsToLatestMeasurement() throws {
        let (storage, temp) = try makeTempStorage()
        defer { try? FileManager.default.removeItem(at: temp) }

        let history = TreeMeasurementHistoryStore(storage: storage)
        let previewData = PreviewData()
        let treeService = TreeService(
            repository: PreviewTreeRepository(previewData: previewData),
            collectionRepository: PreviewCollectionRepository(previewData: previewData)
        )
        var tree = try treeService.createTree(
            Tree(
                botanicalName: "Pinus mugo",
                bonsaiName: "PIN-MUG-INT-2026-011",
                genusID: UUID(),
                speciesID: UUID(),
                locationID: UUID(),
                heightMillimetres: 100
            )
        )
        history.append(
            TreeMeasurementRecord(treeID: tree.id, heightMillimetres: 150, crownWidthMillimetres: 90)
        )
        treeService.reconcileMeasurementDimensions(using: history)
        tree = try #require(treeService.getTree(id: tree.id))
        #expect(tree.heightMillimetres == 150)
        #expect(tree.crownWidthMillimetres == 90)
    }
}
