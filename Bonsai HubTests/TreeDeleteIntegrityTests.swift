//
//  TreeDeleteIntegrityTests.swift
//  Bonsai HubTests
//
//  Verifies Tree delete cascade / unlink / preserve policy without touching
//  the grower's real library.
//

import Foundation
import Testing
@testable import Bonsai_Hub

@MainActor
struct TreeDeleteIntegrityTests {

    private func makeTreeService(photoIndex: TreePhotoIndexStore? = nil) -> TreeService {
        let previewData = PreviewData()
        return TreeService(
            repository: PreviewTreeRepository(previewData: previewData),
            collectionRepository: PreviewCollectionRepository(previewData: previewData),
            photoIndex: photoIndex
        )
    }

    private func makeTree(_ treeService: TreeService, bonsaiName: String) throws -> Tree {
        try treeService.createTree(
            Tree(
                botanicalName: "Pinus mugo",
                bonsaiName: bonsaiName,
                genusID: UUID(),
                speciesID: UUID(),
                locationID: UUID()
            )
        )
    }

    private func makeTempStorage() throws -> (StorageService, URL) {
        let temp = FileManager.default.temporaryDirectory
            .appendingPathComponent("bonsai-tree-delete-\(UUID().uuidString)", isDirectory: true)
        try FileManager.default.createDirectory(at: temp, withIntermediateDirectories: true)
        let provider = LocalStorageProvider(
            rootURL: temp,
            libraryLocation: LibraryLocationConfiguration(kind: .customFolder, bookmarkData: Data())
        )
        let storage = StorageService(provider: provider)
        try storage.ensureLibraryFolderStructure()
        return (storage, temp)
    }

    @Test func photoIndexRemoveBindingDropsOnlyThatTree() {
        var index = TreePhotoIndex(bindings: [
            TreePhotoBinding(treeID: UUID(), primaryImageID: UUID(), imageIDs: [UUID()]),
            TreePhotoBinding(treeID: UUID(), primaryImageID: nil, imageIDs: []),
        ])
        let keep = index.bindings[1].treeID
        let remove = index.bindings[0].treeID
        index.removeBinding(treeID: remove)
        #expect(index.binding(for: remove) == nil)
        #expect(index.binding(for: keep) != nil)
    }

    @Test func deleteTreeCleansCollectionsPhotoIndexMeasurementsAndPot() throws {
        let (storage, temp) = try makeTempStorage()
        defer { try? FileManager.default.removeItem(at: temp) }

        let photoIndex = TreePhotoIndexStore(storage: storage)
        let measurements = TreeMeasurementHistoryStore(storage: storage)
        let treeService = makeTreeService(photoIndex: photoIndex)
        let potService = PotService(repository: PreviewPotRepository(), treeService: treeService)

        let tree = try makeTree(treeService, bonsaiName: "PIN-MUG-DEL-2026-001")
        let other = try makeTree(treeService, bonsaiName: "PIN-MUG-DEL-2026-002")
        let collection = treeService.addCollection(name: "Delete Integrity Manual")
        try treeService.addTreesToCollection(treeIDs: [tree.id, other.id], collectionID: collection.id)

        let imageID = UUID()
        photoIndex.saveBinding(treeID: tree.id, primaryImageID: imageID, imageIDs: [imageID])
        measurements.append(
            TreeMeasurementRecord(treeID: tree.id, heightMillimetres: 120)
        )
        measurements.append(
            TreeMeasurementRecord(treeID: other.id, heightMillimetres: 90)
        )

        let pot = try potService.createPot(Pot(name: "Keep Me"))
        try potService.assignPot(pot.id, toTreeID: tree.id)

        try? potService.unassignCurrentPot(fromTreeID: tree.id)
        measurements.removeAll(for: tree.id)
        try treeService.deleteTree(id: tree.id)

        #expect(treeService.getTree(id: tree.id) == nil)
        #expect(treeService.getTree(id: other.id) != nil)

        let refreshedCollection = try #require(treeService.collection(id: collection.id))
        #expect(!refreshedCollection.treeIDs.contains(tree.id))
        #expect(refreshedCollection.treeIDs.contains(other.id))

        #expect(photoIndex.binding(for: tree.id) == nil)
        #expect(measurements.records(for: tree.id).isEmpty)
        #expect(measurements.records(for: other.id).count == 1)

        let keptPot = try #require(potService.getPot(id: pot.id))
        #expect(keptPot.linkedTreeID == nil)
        #expect(keptPot.status == .available)
    }

    @Test func unlinkDeletedTreePreservesCompletedTasksAndWork() throws {
        let treeService = makeTreeService()
        let reference = ReferenceDataService(previewData: ReferencePreviewData())
        let workService = WorkService(referenceData: reference)
        let botanical = BotanicalService(store: ReferencePreviewData())
        let taskService = TaskService(
            referenceData: reference,
            workService: workService,
            treeService: treeService,
            botanicalService: botanical
        )

        let tree = try makeTree(treeService, bonsaiName: "PIN-MUG-DEL-2026-010")
        let keep = try makeTree(treeService, bonsaiName: "PIN-MUG-DEL-2026-011")
        let workTypeID = try #require(reference.workTypes.first?.id)

        let pendingOnly = try taskService.createTask(
            title: "Water delete-target",
            workTypeID: workTypeID,
            treeIDs: [tree.id],
            dueDate: .now.addingTimeInterval(86_400)
        )
        let pendingShared = try taskService.createTask(
            title: "Water both",
            workTypeID: workTypeID,
            treeIDs: [tree.id, keep.id],
            dueDate: .now.addingTimeInterval(86_400)
        )
        var completed = try taskService.createTask(
            title: "Historical water",
            workTypeID: workTypeID,
            treeIDs: [tree.id],
            dueDate: .now.addingTimeInterval(-86_400)
        )
        completed = try taskService.completeTask(completed, resultingWorkRecordID: nil)

        let work = try workService.registerWork(
            workTypeID: workTypeID,
            treeIDs: [tree.id],
            notes: "Keep this history"
        )

        _ = try taskService.createSchedule(
            title: "Explicit trees schedule",
            workTypeID: workTypeID,
            target: .trees([tree.id, keep.id]),
            recurrence: CareRecurrenceRule(unit: .week, interval: 1)
        )
        _ = try taskService.createSchedule(
            title: "Only deleted tree",
            workTypeID: workTypeID,
            target: .trees([tree.id]),
            recurrence: CareRecurrenceRule(unit: .week, interval: 1)
        )

        taskService.unlinkDeletedTree(tree.id)
        try treeService.deleteTree(id: tree.id)

        #expect(taskService.tasks.contains { $0.id == pendingOnly.id } == false)
        let shared = try #require(taskService.tasks.first { $0.id == pendingShared.id })
        #expect(shared.treeIDs == [keep.id])
        #expect(shared.status == .pending)

        let keptCompleted = try #require(taskService.tasks.first { $0.id == completed.id })
        #expect(keptCompleted.status == .completed)
        #expect(keptCompleted.treeIDs.contains(tree.id))

        #expect(workService.history(for: tree.id).contains { $0.id == work.id })

        #expect(taskService.schedules.contains { $0.title == "Only deleted tree" } == false)
        let remaining = try #require(taskService.schedules.first { $0.title == "Explicit trees schedule" })
        guard case .trees(let ids) = remaining.target else {
            Issue.record("Expected .trees target")
            return
        }
        #expect(ids == Set([keep.id]))
        #expect(!ids.contains(tree.id))
    }

    @Test func clearLinkedTreeReferenceKeepsFind() throws {
        let treeService = makeTreeService()
        let yamadori = YamadoriService(
            repository: PreviewYamadoriRepository(),
            treeService: treeService
        )
        let tree = try makeTree(treeService, bonsaiName: "PIN-MUG-DEL-2026-020")
        let trip = try yamadori.createYamadori(fromDraft: NewYamadoriDraft(displayName: "Link Clear"))
        var find = try yamadori.createFind(onYamadoriID: trip.id, displayName: "Link Clear")
        find.linkedTreeID = tree.id
        _ = try yamadori.updateFind(find)

        yamadori.clearLinkedTreeReference(treeID: tree.id)
        try treeService.deleteTree(id: tree.id)

        let refreshed = try #require(yamadori.getFind(id: find.id))
        #expect(refreshed.linkedTreeID == nil)
        #expect(yamadori.getFind(id: find.id) != nil)
    }
}
