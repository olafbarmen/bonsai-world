//
//  MobilePersistenceTests.swift
//  Bonsai WorldTests
//
//  Local iOS library: save → destroy in-memory state → fresh store → load.
//

import Foundation
import Testing
@testable import Bonsai_World

struct MobilePersistenceTests {
    private static let mapleID = UUID(uuidString: "B2000000-0000-4000-8000-000000000001")!

    private func makeTempStore() throws -> (MobileLibraryStore, URL) {
        let temp = FileManager.default.temporaryDirectory
            .appendingPathComponent("bonsai-ios-persist-\(UUID().uuidString)", isDirectory: true)
        try FileManager.default.createDirectory(at: temp, withIntermediateDirectories: true)
        return (MobileLibraryStore(rootURL: temp), temp)
    }

    @Test func firstLaunchSeedsTreesAndReloadKeepsIdentity() throws {
        let (store, temp) = try makeTempStore()
        defer { try? FileManager.default.removeItem(at: temp) }

        let first = DemoLibrary(store: store)
        #expect(first.lastLoadError == nil)
        #expect(first.trees.map(\.id) == DemoLibrary.sampleTrees.map(\.id))
        #expect(first.locations.map(\.id) == CanonicalLocationID.seedLocations.map(\.id))
        let maple = try #require(first.tree(id: Self.mapleID))
        #expect(maple.nickname == "Terrace Maple")
        #expect(maple.locationID == CanonicalLocationID.altan)
        #expect(first.location(id: CanonicalLocationID.altan)?.name == "Altan")
        #expect(first.garden(id: CanonicalLocationID.defaultGardenID)?.name == "My Garden")
        #expect(first.garden(id: CanonicalLocationID.defaultGardenID)?.isDefault == true)
        #expect(Set(first.locations(inGarden: CanonicalLocationID.defaultGardenID).map(\.id)) == Set(first.locations.map(\.id)))

        let second = DemoLibrary(store: store)
        #expect(second.lastLoadError == nil)
        #expect(second.trees.map(\.id) == first.trees.map(\.id))
        #expect(second.location(id: CanonicalLocationID.altan)?.name == "Altan")
        #expect(second.tree(id: Self.mapleID)?.nickname == "Terrace Maple")
        #expect(second.workRecords.map(\.id) == first.workRecords.map(\.id))
    }

    @Test func treeChangeSurvivesRestart() throws {
        let (store, temp) = try makeTempStore()
        defer { try? FileManager.default.removeItem(at: temp) }

        let first = DemoLibrary(store: store)
        var maple = try #require(first.tree(id: Self.mapleID))
        maple.nickname = "Field Maple"
        maple.notes = "Grower note — do not translate."
        first.replaceTree(maple)
        #expect(first.lastSaveError == nil)

        let second = DemoLibrary(store: store)
        let reloaded = try #require(second.tree(id: Self.mapleID))
        #expect(reloaded.id == Self.mapleID)
        #expect(reloaded.nickname == "Field Maple")
        #expect(reloaded.notes == "Grower note — do not translate.")
        #expect(reloaded.bonsaiName == "ACE-PAL-2020-001")
    }

    @Test func workRecordSurvivesRestart() throws {
        let (store, temp) = try makeTempStore()
        defer { try? FileManager.default.removeItem(at: temp) }

        let first = DemoLibrary(store: store)
        first.addWork(
            treeID: Self.mapleID,
            workTypeID: CanonicalWorkTypeID.repotting,
            performedAt: Date(timeIntervalSince1970: 1_700_000_000),
            notes: "Field repot."
        )
        #expect(first.lastSaveError == nil)
        let saved = try #require(first.workRecords.first { $0.notes == "Field repot." })

        let second = DemoLibrary(store: store)
        let reloaded = try #require(second.workRecords.first { $0.id == saved.id })
        #expect(reloaded.workTypeID == CanonicalWorkTypeID.repotting)
        #expect(reloaded.treeIDs == [Self.mapleID])
        #expect(reloaded.notes == "Field repot.")
        #expect(reloaded.performedAt == saved.performedAt)
    }

    @Test func photoSurvivesRestart() throws {
        let (store, temp) = try makeTempStore()
        defer { try? FileManager.default.removeItem(at: temp) }

        let jpeg = Data("fake-jpeg-original".utf8)
        let first = DemoLibrary(store: store)
        let asset = try #require(
            first.addPhoto(
                to: Self.mapleID,
                jpegData: jpeg,
                width: 8,
                height: 6,
                fileName: "field.jpg"
            )
        )
        #expect(first.lastSaveError == nil)
        #expect(first.tree(id: Self.mapleID)?.imageIDs == [asset.id])
        #expect(first.tree(id: Self.mapleID)?.primaryImageID == asset.id)

        let second = DemoLibrary(store: store)
        #expect(second.tree(id: Self.mapleID)?.imageIDs == [asset.id])
        #expect(second.tree(id: Self.mapleID)?.primaryImageID == asset.id)
        #expect(second.asset(id: asset.id)?.id == asset.id)
        #expect(second.asset(id: asset.id)?.relativePath == ImageAsset.originalsRelativePath(id: asset.id))
        #expect(second.jpegData(for: asset.id) == jpeg)
    }

    @Test func restartSimulationSaveDestroyReload() throws {
        let (store, temp) = try makeTempStore()
        defer { try? FileManager.default.removeItem(at: temp) }

        let jpeg = Data([0xFF, 0xD8, 0xFF, 0xD9])
        let first = DemoLibrary(store: store)
        var maple = try #require(first.tree(id: Self.mapleID))
        maple.nickname = "Restart Maple"
        first.replaceTree(maple)
        first.addWork(
            treeID: Self.mapleID,
            workTypeID: CanonicalWorkTypeID.watering,
            notes: "After restart."
        )
        let work = try #require(first.workRecords.first { $0.notes == "After restart." })
        let asset = try #require(
            first.addPhoto(to: Self.mapleID, jpegData: jpeg, width: 1, height: 1, fileName: "restart.jpg")
        )

        let treeIDs = first.trees.map(\.id)
        let workIDs = first.workRecords.map(\.id)

        let second = DemoLibrary(store: store)
        #expect(second.lastLoadError == nil)
        #expect(second.trees.map(\.id) == treeIDs)
        #expect(second.workRecords.map(\.id) == workIDs)
        #expect(second.tree(id: Self.mapleID)?.nickname == "Restart Maple")
        #expect(second.workRecords.contains { $0.id == work.id && $0.treeIDs == [Self.mapleID] })
        #expect(second.jpegData(for: asset.id) == jpeg)
        #expect(second.tree(id: Self.mapleID)?.imageIDs.contains(asset.id) == true)
    }

    @Test func emptyPersistedTreesDoesNotReseedDemo() throws {
        let (store, temp) = try makeTempStore()
        defer { try? FileManager.default.removeItem(at: temp) }

        _ = DemoLibrary(store: store)
        try store.saveTrees([])
        try store.saveWork([])

        let reloaded = DemoLibrary(store: store)
        #expect(reloaded.lastLoadError == nil)
        #expect(reloaded.trees.isEmpty)
        #expect(reloaded.workRecords.isEmpty)
    }

    @Test func corruptTreesFileDoesNotReseedDemo() throws {
        let (store, temp) = try makeTempStore()
        defer { try? FileManager.default.removeItem(at: temp) }

        try store.ensureFolderStructure()
        let treesURL = store.url(for: MobileLibraryPackageLayout.treesFileName)
        let corrupt = Data("{not-valid-json".utf8)
        try corrupt.write(to: treesURL, options: .atomic)

        let library = DemoLibrary(store: store)
        #expect(library.lastLoadError != nil)
        #expect(library.trees.isEmpty)
        #expect(try Data(contentsOf: treesURL) == corrupt)
        #expect(DemoLibrary(store: store).tree(id: Self.mapleID) == nil)
    }

    @Test func updateTreePersistsEditableFieldsAndLeavesIdentityUntouched() throws {
        let (store, temp) = try makeTempStore()
        defer { try? FileManager.default.removeItem(at: temp) }

        let first = DemoLibrary(store: store)
        let original = try #require(first.tree(id: Self.mapleID))
        let originalBonsaiName = original.bonsaiName
        let originalBotanical = original.botanicalName
        let originalHealth = original.healthStatus
        let originalImageIDs = original.imageIDs
        let originalPrimary = original.primaryImageID
        let workIDs = first.workRecords.map(\.id)
        let newLocation = CanonicalLocationID.id(n: 1)

        first.updateTree(
            id: Self.mapleID,
            nickname: "Field Maple",
            locationID: newLocation,
            soilMixID: original.soilMixID,
            notes: "Grower note — do not translate.",
            healthStatus: original.healthStatus
        )
        #expect(first.lastSaveError == nil)
        #expect(first.tree(id: Self.mapleID)?.id == Self.mapleID)

        let second = DemoLibrary(store: store)
        let reloaded = try #require(second.tree(id: Self.mapleID))
        #expect(reloaded.id == Self.mapleID)
        #expect(reloaded.nickname == "Field Maple")
        #expect(reloaded.locationID == newLocation)
        #expect(reloaded.notes == "Grower note — do not translate.")
        #expect(reloaded.bonsaiName == originalBonsaiName)
        #expect(reloaded.botanicalName == originalBotanical)
        #expect(reloaded.healthStatus == originalHealth)
        #expect(reloaded.imageIDs == originalImageIDs)
        #expect(reloaded.primaryImageID == originalPrimary)
        #expect(second.workRecords.map(\.id) == workIDs)
    }

    @Test func collectionPersistsMembershipAndLeavesTreesUntouched() throws {
        let (store, temp) = try makeTempStore()
        defer { try? FileManager.default.removeItem(at: temp) }

        let first = DemoLibrary(store: store)
        let treeIDs = first.trees.map(\.id)
        let collectionID = UUID(uuidString: "B4000000-0000-4000-8000-000000000001")!
        let juniperID = UUID(uuidString: "B2000000-0000-4000-8000-000000000002")!
        first.replaceCollection(
            Collection(
                id: collectionID,
                name: "Altan group",
                description: "Grower name — do not translate.",
                treeIDs: [Self.mapleID, juniperID]
            )
        )
        #expect(first.lastSaveError == nil)

        let second = DemoLibrary(store: store)
        let reloaded = try #require(second.collection(id: collectionID))
        #expect(reloaded.id == collectionID)
        #expect(reloaded.name == "Altan group")
        #expect(reloaded.description == "Grower name — do not translate.")
        #expect(reloaded.treeIDs == [Self.mapleID, juniperID])
        #expect(second.trees(in: reloaded).map(\.id) == [Self.mapleID, juniperID])
        #expect(second.trees.map(\.id) == treeIDs)
        #expect(second.tree(id: Self.mapleID)?.bonsaiName == "ACE-PAL-2020-001")
    }

    @Test func createEditAndMembershipSurviveRestart() throws {
        let (store, temp) = try makeTempStore()
        defer { try? FileManager.default.removeItem(at: temp) }

        let first = DemoLibrary(store: store)
        #expect(first.addCollection(name: "   ", description: "ignored") == nil)
        #expect(first.collections.isEmpty)

        let created = try #require(first.addCollection(
            name: "  Altan group  ",
            description: "  Grower name — do not translate.  "
        ))
        #expect(first.lastSaveError == nil)
        #expect(created.type == .manual)
        #expect(created.treeIDs.isEmpty)
        #expect(created.name == "Altan group")
        #expect(created.description == "Grower name — do not translate.")

        first.updateCollection(id: created.id, name: "   ", description: "should not apply")
        #expect(first.collection(id: created.id)?.name == "Altan group")

        first.updateCollection(
            id: created.id,
            name: "Altan evening",
            description: "Updated grower note."
        )
        first.addTree(Self.mapleID, to: created.id)
        first.addTree(Self.mapleID, to: created.id)
        #expect(first.lastSaveError == nil)
        let treeIDs = first.trees.map(\.id)

        let second = DemoLibrary(store: store)
        let reloaded = try #require(second.collection(id: created.id))
        #expect(reloaded.id == created.id)
        #expect(reloaded.name == "Altan evening")
        #expect(reloaded.description == "Updated grower note.")
        #expect(reloaded.type == .manual)
        #expect(reloaded.treeIDs == [Self.mapleID])
        #expect(second.trees.map(\.id) == treeIDs)

        second.removeTree(Self.mapleID, from: created.id)
        #expect(second.lastSaveError == nil)

        let third = DemoLibrary(store: store)
        let afterRemove = try #require(third.collection(id: created.id))
        #expect(afterRemove.treeIDs.isEmpty)
        #expect(third.trees.map(\.id) == treeIDs)
        #expect(third.tree(id: Self.mapleID)?.bonsaiName == "ACE-PAL-2020-001")
    }

    @Test func treesAtLocationFollowPersistedLocationID() throws {
        let (store, temp) = try makeTempStore()
        defer { try? FileManager.default.removeItem(at: temp) }

        let first = DemoLibrary(store: store)
        #expect(CanonicalLocationID.catalog.count == 15)
        #expect(Set(first.trees(at: CanonicalLocationID.altan).map(\.id)) == Set(first.trees.map(\.id)))
        #expect(first.trees(at: CanonicalLocationID.id(n: 1)).isEmpty)

        let original = try #require(first.tree(id: Self.mapleID))
        first.updateTree(
            id: Self.mapleID,
            nickname: original.nickname,
            locationID: CanonicalLocationID.id(n: 1),
            soilMixID: original.soilMixID,
            notes: original.notes,
            healthStatus: original.healthStatus
        )
        #expect(first.lastSaveError == nil)

        let second = DemoLibrary(store: store)
        #expect(second.trees(at: CanonicalLocationID.id(n: 1)).map(\.id) == [Self.mapleID])
        #expect(second.trees(at: CanonicalLocationID.altan).map(\.id).contains(Self.mapleID) == false)
        #expect(second.tree(id: Self.mapleID)?.bonsaiName == "ACE-PAL-2020-001")
    }

    @Test func deleteCollectionLeavesTreesAndSurvivesRestart() throws {
        let (store, temp) = try makeTempStore()
        defer { try? FileManager.default.removeItem(at: temp) }

        let first = DemoLibrary(store: store)
        let created = try #require(first.addCollection(name: "Altan group"))
        first.addTree(Self.mapleID, to: created.id)
        let treeIDs = first.trees.map(\.id)
        let mapleName = first.tree(id: Self.mapleID)?.bonsaiName

        first.deleteCollection(id: created.id)
        #expect(first.lastSaveError == nil)
        #expect(first.collection(id: created.id) == nil)
        #expect(first.trees.map(\.id) == treeIDs)

        let smart = Collection(name: "Smart placeholder", type: .smart)
        first.replaceCollection(smart)
        first.deleteCollection(id: smart.id)
        #expect(first.collection(id: smart.id)?.type == .smart)

        let second = DemoLibrary(store: store)
        #expect(second.collection(id: created.id) == nil)
        #expect(second.collection(id: smart.id)?.type == .smart)
        #expect(second.trees.map(\.id) == treeIDs)
        #expect(second.tree(id: Self.mapleID)?.bonsaiName == mapleName)
    }

    @Test func createAndEditLocationSurviveRestart() throws {
        let (store, temp) = try makeTempStore()
        defer { try? FileManager.default.removeItem(at: temp) }

        let first = DemoLibrary(store: store)
        #expect(first.addLocation(name: "   ") == nil)
        #expect(first.locations.count == 15)

        let altan = try #require(first.location(id: CanonicalLocationID.altan))
        first.updateLocation(
            id: altan.id,
            name: "  Altan terrace  ",
            description: "  Grower description — do not translate.  ",
            notes: "  Grower note — do not translate.  ",
            gardenID: CanonicalLocationID.defaultGardenID,
            locationTypeID: CanonicalLocationID.locationTypeID(n: 5)
        )
        #expect(first.lastSaveError == nil)
        #expect(first.location(id: CanonicalLocationID.altan)?.gardenID == CanonicalLocationID.defaultGardenID)
        #expect(first.location(id: CanonicalLocationID.altan)?.locationTypeID == CanonicalLocationID.locationTypeID(n: 5))

        let created = try #require(first.addLocation(
            name: "  New bench  ",
            description: "Field description.",
            notes: "Field notes.",
            gardenID: CanonicalLocationID.defaultGardenID,
            locationTypeID: CanonicalLocationID.locationTypeID(n: 1)
        ))
        #expect(created.gardenID == CanonicalLocationID.defaultGardenID)
        #expect(created.locationTypeID == CanonicalLocationID.locationTypeID(n: 1))
        let treeIDs = first.trees.map(\.id)

        let second = DemoLibrary(store: store)
        let reloadedAltan = try #require(second.location(id: CanonicalLocationID.altan))
        #expect(reloadedAltan.name == "Altan terrace")
        #expect(reloadedAltan.locationDescription == "Grower description — do not translate.")
        #expect(reloadedAltan.notes == "Grower note — do not translate.")
        #expect(reloadedAltan.gardenID == CanonicalLocationID.defaultGardenID)
        #expect(reloadedAltan.locationTypeID == CanonicalLocationID.locationTypeID(n: 5))

        let reloadedNew = try #require(second.location(id: created.id))
        #expect(reloadedNew.name == "New bench")
        #expect(reloadedNew.locationDescription == "Field description.")
        #expect(reloadedNew.notes == "Field notes.")
        #expect(reloadedNew.gardenID == CanonicalLocationID.defaultGardenID)
        #expect(reloadedNew.locationTypeID == CanonicalLocationID.locationTypeID(n: 1))
        #expect(reloadedNew.id == created.id)
        #expect(second.trees.map(\.id) == treeIDs)
        #expect(second.tree(id: Self.mapleID)?.locationID == CanonicalLocationID.altan)
    }

    @Test func deleteLocationLeavesTreesAndSurvivesRestart() throws {
        let (store, temp) = try makeTempStore()
        defer { try? FileManager.default.removeItem(at: temp) }

        let first = DemoLibrary(store: store)
        let created = try #require(first.addLocation(name: "Temp bench"))
        let original = try #require(first.tree(id: Self.mapleID))
        first.updateTree(
            id: Self.mapleID,
            nickname: original.nickname,
            locationID: created.id,
            soilMixID: original.soilMixID,
            notes: original.notes,
            healthStatus: original.healthStatus
        )
        let treeIDs = first.trees.map(\.id)
        let mapleLocation = created.id

        first.deleteLocation(id: created.id)
        #expect(first.lastSaveError == nil)
        #expect(first.location(id: created.id) == nil)
        #expect(first.trees.map(\.id) == treeIDs)
        #expect(first.tree(id: Self.mapleID)?.locationID == mapleLocation)
        #expect(first.locationName(for: mapleLocation) == nil)

        let second = DemoLibrary(store: store)
        #expect(second.location(id: created.id) == nil)
        #expect(second.trees.map(\.id) == treeIDs)
        #expect(second.tree(id: Self.mapleID)?.locationID == mapleLocation)
        #expect(second.tree(id: Self.mapleID)?.bonsaiName == "ACE-PAL-2020-001")
    }

    @Test func createAndEditGardenSurviveRestart() throws {
        let (store, temp) = try makeTempStore()
        defer { try? FileManager.default.removeItem(at: temp) }

        let first = DemoLibrary(store: store)
        #expect(first.addGarden(name: "   ") == nil)
        #expect(first.gardens.count == 1)

        let seed = try #require(first.garden(id: CanonicalLocationID.defaultGardenID))
        first.updateGarden(id: seed.id, name: "  Home garden  ", isDefault: true)
        #expect(first.lastSaveError == nil)

        let created = try #require(first.addGarden(name: "  Greenhouse plot  ", isDefault: true))
        #expect(created.isDefault)
        #expect(first.garden(id: seed.id)?.isDefault == false)
        let treeIDs = first.trees.map(\.id)

        let second = DemoLibrary(store: store)
        let reloadedHome = try #require(second.garden(id: CanonicalLocationID.defaultGardenID))
        #expect(reloadedHome.name == "Home garden")
        #expect(reloadedHome.isDefault == false)

        let reloadedNew = try #require(second.garden(id: created.id))
        #expect(reloadedNew.name == "Greenhouse plot")
        #expect(reloadedNew.isDefault)
        #expect(second.defaultGarden?.id == created.id)
        #expect(second.trees.map(\.id) == treeIDs)
        #expect(second.location(id: CanonicalLocationID.altan)?.gardenID == CanonicalLocationID.defaultGardenID)
    }

    @Test func deleteGardenLeavesLocationsAndSurvivesRestart() throws {
        let (store, temp) = try makeTempStore()
        defer { try? FileManager.default.removeItem(at: temp) }

        let first = DemoLibrary(store: store)
        let seedID = CanonicalLocationID.defaultGardenID
        first.deleteGarden(id: seedID)
        #expect(first.gardens.count == 1)
        #expect(first.garden(id: seedID) != nil)

        let created = try #require(first.addGarden(name: "Side plot", isDefault: false))
        let location = try #require(
            first.addLocation(name: "Bench A", gardenID: created.id)
        )
        #expect(location.gardenID == created.id)
        let treeIDs = first.trees.map(\.id)

        first.deleteGarden(id: created.id)
        #expect(first.lastSaveError == nil)
        #expect(first.garden(id: created.id) == nil)
        #expect(first.gardens.count == 1)
        #expect(first.garden(id: seedID)?.isDefault == true)
        #expect(first.location(id: location.id)?.gardenID == created.id)
        #expect(first.trees.map(\.id) == treeIDs)

        let second = DemoLibrary(store: store)
        #expect(second.garden(id: created.id) == nil)
        #expect(second.garden(id: seedID)?.isDefault == true)
        #expect(second.location(id: location.id)?.name == "Bench A")
        #expect(second.location(id: location.id)?.gardenID == created.id)
        #expect(second.trees.map(\.id) == treeIDs)
    }

    @Test func tasksSeedAndCompleteSurviveRestart() throws {
        let (store, temp) = try makeTempStore()
        defer { try? FileManager.default.removeItem(at: temp) }

        let first = DemoLibrary(store: store)
        #expect(!first.pendingTasks(due: .today).isEmpty || !first.pendingTasks(due: .overdue).isEmpty)

        let watering = try #require(
            first.pendingTasks(due: .today).first { $0.isInstant }
        )
        let workCount = first.workRecords.count
        let record = try #require(first.completeTaskInstantly(id: watering.task.id))
        #expect(first.lastSaveError == nil)
        #expect(record.scheduleID == watering.task.id)
        #expect(first.workRecords.count == workCount + 1)
        #expect(first.task(id: watering.task.id)?.status == .completed)
        #expect(first.pendingTasks(due: .today).allSatisfy { $0.task.id != watering.task.id })

        let formItem = try #require(
            (first.pendingTasks(due: .overdue) + first.pendingTasks(due: .today))
                .first { !$0.isInstant }
        )
        let formRecord = first.addWork(
            treeID: formItem.treeID,
            workTypeID: formItem.task.workTypeID,
            notes: "Done in field.",
            scheduleID: formItem.task.id
        )
        first.completeTask(id: formItem.task.id, resultingWorkRecordID: formRecord.id)
        #expect(first.task(id: formItem.task.id)?.status == .completed)

        let second = DemoLibrary(store: store)
        #expect(second.task(id: watering.task.id)?.status == .completed)
        #expect(second.task(id: formItem.task.id)?.status == .completed)
        #expect(second.workRecords.contains { $0.id == record.id })
        #expect(second.workRecords.contains { $0.id == formRecord.id && $0.notes == "Done in field." })
    }

    @Test func createTaskSurvivesRestart() throws {
        let (store, temp) = try makeTempStore()
        defer { try? FileManager.default.removeItem(at: temp) }

        let first = DemoLibrary(store: store)
        #expect(first.addTask(
            title: "   ",
            workTypeID: CanonicalWorkTypeID.wiring,
            treeID: Self.mapleID,
            dueDate: Calendar.current.startOfDay(for: .now),
            notes: "  Field wire check  "
        ) != nil)

        let created = try #require(
            first.careTasks.last { $0.workTypeID == CanonicalWorkTypeID.wiring && $0.treeIDs == [Self.mapleID] }
        )
        #expect(created.title == "Wiring")
        #expect(created.notes == "Field wire check")
        #expect(first.lastSaveError == nil)
        #expect(first.pendingTasks(due: .today).contains { $0.task.id == created.id })

        let second = DemoLibrary(store: store)
        let reloaded = try #require(second.task(id: created.id))
        #expect(reloaded.title == "Wiring")
        #expect(reloaded.workTypeID == CanonicalWorkTypeID.wiring)
        #expect(reloaded.treeIDs == [Self.mapleID])
        #expect(reloaded.notes == "Field wire check")
        #expect(reloaded.status == .pending)
    }

    @Test func createYamadoriAndFindPinSurviveRestart() throws {
        let (store, temp) = try makeTempStore()
        defer { try? FileManager.default.removeItem(at: temp) }

        let first = DemoLibrary(store: store)
        #expect(first.addYamadori(displayName: "   ") == nil)

        let created = try #require(first.addYamadori(displayName: "  Ridge walk  ", notes: "  First sighting  "))
        #expect(created.find.status == .scout)
        #expect(created.find.yamadoriCode.hasPrefix("YAM-"))
        #expect(created.trip.displayName == "Ridge walk")
        #expect(created.find.notes == "First sighting")
        #expect(first.lastSaveError == nil)

        first.updateYamadoriFind(
            id: created.find.id,
            displayName: "Ridge maple",
            status: .planned,
            notes: "Pin set in field",
            latitude: 60.3913,
            longitude: 5.3221
        )
        #expect(first.lastSaveError == nil)

        let second = DemoLibrary(store: store)
        let trip = try #require(second.yamadoriTrip(id: created.trip.id))
        let find = try #require(second.yamadoriFind(id: created.find.id))
        #expect(trip.displayName == "Ridge walk")
        #expect(find.displayName == "Ridge maple")
        #expect(find.status == .planned)
        #expect(find.notes == "Pin set in field")
        #expect(find.latitude == 60.3913)
        #expect(find.longitude == 5.3221)
        #expect(find.yamadoriCode == created.find.yamadoriCode)
        #expect(second.finds(forYamadoriID: trip.id).map(\.id) == [find.id])
    }

    @Test func addFindEditTripAndMarkCollectedSurviveRestart() throws {
        let (store, temp) = try makeTempStore()
        defer { try? FileManager.default.removeItem(at: temp) }

        let first = DemoLibrary(store: store)
        let created = try #require(first.addYamadori(displayName: "Valley trip"))
        first.updateYamadoriTrip(id: created.trip.id, displayName: "  Valley day  ", tripDate: Date(timeIntervalSince1970: 1_700_000_000))
        first.updateYamadoriTrip(id: created.trip.id, displayName: "   ", tripDate: .now)
        // empty name rejected — name unchanged
        #expect(first.yamadoriTrip(id: created.trip.id)?.displayName == "Valley day")

        let secondFind = try #require(first.addFind(onYamadoriID: created.trip.id, displayName: "  Side stump  "))
        #expect(secondFind.status == .scout)
        #expect(secondFind.yamadoriCode != created.find.yamadoriCode)
        #expect(first.finds(forYamadoriID: created.trip.id).count == 2)

        // Scout cannot collect
        #expect(first.markYamadoriCollected(
            findID: secondFind.id,
            botanicalName: "Pinus sylvestris",
            locationID: CanonicalLocationID.altan
        ) == nil)

        first.updateYamadoriFind(
            id: secondFind.id,
            displayName: "Side stump",
            status: .planned,
            notes: "",
            latitude: nil,
            longitude: nil
        )
        let tree = try #require(first.markYamadoriCollected(
            findID: secondFind.id,
            botanicalName: "  Pinus sylvestris  ",
            locationID: CanonicalLocationID.altan,
            collectionNotes: "  Cool morning  ",
            copyImages: true
        ))
        #expect(first.lastSaveError == nil)
        #expect(tree.yamadoriNursery == true)
        #expect(tree.bonsaiName == secondFind.yamadoriCode)
        #expect(tree.botanicalName == "Pinus sylvestris")
        #expect(tree.locationID == CanonicalLocationID.altan)
        #expect(tree.sourceYamadoriID == secondFind.id)
        #expect(tree.acquisitionNotes.contains("Cool morning"))
        #expect(first.myTrees.contains { $0.id == tree.id } == false)
        #expect(first.yamadoriFind(id: secondFind.id)?.status == .collected)
        #expect(first.yamadoriFind(id: secondFind.id)?.linkedTreeID == tree.id)

        let second = DemoLibrary(store: store)
        #expect(second.yamadoriTrip(id: created.trip.id)?.displayName == "Valley day")
        #expect(second.yamadoriTrip(id: created.trip.id)?.tripDate == Date(timeIntervalSince1970: 1_700_000_000))
        #expect(second.finds(forYamadoriID: created.trip.id).count == 2)
        let reloadedFind = try #require(second.yamadoriFind(id: secondFind.id))
        #expect(reloadedFind.status == .collected)
        #expect(reloadedFind.linkedTreeID == tree.id)
        let reloadedTree = try #require(second.tree(id: tree.id))
        #expect(reloadedTree.yamadoriNursery == true)
        #expect(reloadedTree.botanicalName == "Pinus sylvestris")
        #expect(reloadedTree.bonsaiName == secondFind.yamadoriCode)
        #expect(second.yamadoriNurseryTrees.map(\.id) == [tree.id])

        first.updateYamadoriTripSite(id: created.trip.id, latitude: 61.0, longitude: 8.5)
        #expect(first.yamadoriTrip(id: created.trip.id)?.latitude == 61.0)

        let moved = try #require(first.moveYamadoriToMyTrees(
            findID: secondFind.id,
            bonsaiName: "  PIN-SYL-2024-001  ",
            nickname: "  Valley pine  ",
            locationID: nil,
            transferNotes: "  Ready for bench  ",
            copyImages: true
        ))
        #expect(first.lastSaveError == nil)
        #expect(moved.yamadoriNursery == false)
        #expect(moved.bonsaiName == "PIN-SYL-2024-001")
        #expect(moved.nickname == "Valley pine")
        #expect(moved.acquisitionNotes.contains("Ready for bench"))
        #expect(first.yamadoriFind(id: secondFind.id)?.status == .transferred)
        #expect(first.yamadoriNurseryTrees.isEmpty)
        #expect(first.myTrees.contains { $0.id == moved.id })

        // Scout/empty bonsai rejected
        #expect(first.moveYamadoriToMyTrees(findID: secondFind.id, bonsaiName: "Again") == nil)

        let third = DemoLibrary(store: store)
        #expect(third.yamadoriTrip(id: created.trip.id)?.latitude == 61.0)
        #expect(third.yamadoriTrip(id: created.trip.id)?.longitude == 8.5)
        let graduated = try #require(third.tree(id: moved.id))
        #expect(graduated.yamadoriNursery == false)
        #expect(graduated.bonsaiName == "PIN-SYL-2024-001")
        #expect(graduated.nickname == "Valley pine")
        #expect(third.yamadoriFind(id: secondFind.id)?.status == .transferred)
        #expect(third.myTrees.contains { $0.id == graduated.id })
        #expect(third.yamadoriNurseryTrees.isEmpty)
    }

    @Test func observationAbandonArchiveAndGardenAddressSurviveRestart() throws {
        let (store, temp) = try makeTempStore()
        defer { try? FileManager.default.removeItem(at: temp) }

        let first = DemoLibrary(store: store)
        let created = try #require(first.addYamadori(displayName: "Cliff"))
        let observation = try #require(
            first.addYamadoriObservation(
                findID: created.find.id,
                text: "  Strong nebari  ",
                date: Date(timeIntervalSince1970: 1_700_100_000)
            )
        )
        #expect(observation.text == "Strong nebari")
        #expect(first.addYamadoriObservation(findID: created.find.id, text: "   ") == nil)

        #expect(first.setYamadoriFindStatus(findID: created.find.id, to: .archived) == nil)
        let abandoned = try #require(first.setYamadoriFindStatus(findID: created.find.id, to: .abandoned))
        #expect(abandoned.status == .abandoned)
        #expect(first.setYamadoriFindStatus(findID: created.find.id, to: .planned) == nil)
        let archived = try #require(first.setYamadoriFindStatus(findID: created.find.id, to: .archived))
        #expect(archived.status == .archived)

        let garden = try #require(first.addGarden(
            name:  "  Riverside  ",
            isDefault: false,
            address: "  12 Bank St  ",
            postalCode: "  5000  ",
            city: "  Bergen  ",
            country: "  Norway  "
        ))
        #expect(garden.address == "12 Bank St")
        first.updateGarden(
            id: garden.id,
            name: "Riverside plot",
            isDefault: false,
            address: "14 Bank St",
            postalCode: "5001",
            city: "Bergen",
            country: "Norway"
        )

        let second = DemoLibrary(store: store)
        let find = try #require(second.yamadoriFind(id: created.find.id))
        #expect(find.status == .archived)
        #expect(find.observations.count == 1)
        #expect(find.observations[0].text == "Strong nebari")
        let reloadedGarden = try #require(second.garden(id: garden.id))
        #expect(reloadedGarden.name == "Riverside plot")
        #expect(reloadedGarden.address == "14 Bank St")
        #expect(reloadedGarden.postalCode == "5001")
        #expect(reloadedGarden.city == "Bergen")
        #expect(reloadedGarden.country == "Norway")
        #expect(second.formerYamadoriFindings.map(\.id) == [created.find.id])
    }

    @Test func seedBatchSpeciesEstimateAndTransferredSurviveRestart() throws {
        let (store, temp) = try makeTempStore()
        defer { try? FileManager.default.removeItem(at: temp) }

        let first = DemoLibrary(store: store)
        #expect(first.addSeedBatch(name: "   ", species: "Acer") == nil)
        let batch = try #require(first.addSeedBatch(name: "  Acer palmatum  ", species: "  Japanese maple  "))
        #expect(batch.stage == .planned)
        #expect(batch.botanicalName == "Acer palmatum")
        #expect(batch.commonName == "Japanese maple")
        #expect(batch.batchCode.contains("202"))
        first.updateSeedBatch(
            id: batch.id,
            name: "Acer palmatum",
            species: "Japanese maple",
            stage: .stratifying,
            notes: "Fridge",
            soilMixID: nil
        )
        #expect(first.lastSaveError == nil)

        let yam = try #require(first.addYamadori(displayName: "Ridge"))
        first.updateYamadoriFind(
            id: yam.find.id,
            displayName: "Ridge maple",
            status: .planned,
            notes: "",
            latitude: nil,
            longitude: nil,
            speciesEstimate: "  Acer campestre  "
        )
        let tree = try #require(first.markYamadoriCollected(
            findID: yam.find.id,
            botanicalName: first.yamadoriFind(id: yam.find.id)?.speciesEstimate ?? "Acer campestre",
            locationID: CanonicalLocationID.altan
        ))
        let moved = try #require(first.moveYamadoriToMyTrees(
            findID: yam.find.id,
            bonsaiName: "ACE-CAM-2026-001"
        ))
        #expect(moved.yamadoriNursery == false)
        #expect(first.transferredYamadoriTrees.map(\.id) == [moved.id])
        #expect(tree.id == moved.id)

        let second = DemoLibrary(store: store)
        let reloadedBatch = try #require(second.seedBatch(id: batch.id))
        #expect(reloadedBatch.stage == .stratifying)
        #expect(reloadedBatch.notes == "Fridge")
        #expect(second.yamadoriFind(id: yam.find.id)?.speciesEstimate == "Acer campestre")
        #expect(second.yamadoriFind(id: yam.find.id)?.status == .transferred)
        #expect(second.transferredYamadoriTrees.map(\.id) == [moved.id])
    }

    @Test func soilMixAndAdvanceSeedStageSurviveRestart() throws {
        let (store, temp) = try makeTempStore()
        defer { try? FileManager.default.removeItem(at: temp) }

        let first = DemoLibrary(store: store)
        #expect(first.addSoilMix(name: "   ") == nil)
        let parts = [
            SoilMixPart(componentName: "Akadama", percentage: 50),
            SoilMixPart(componentName: "Pumice", percentage: 25),
            SoilMixPart(componentName: "Lava", percentage: 25)
        ]
        let mix = try #require(first.addSoilMix(name: "  Akadama blend  ", notes: "  Field  ", parts: parts))
        #expect(mix.name == "Akadama blend")
        #expect(mix.totalPercentage == 100)
        first.updateSoilMix(id: mix.id, name: "Akadama blend", notes: "Field mix", parts: parts)
        #expect(first.lastSaveError == nil)

        let batch = try #require(first.addSeedBatch(name: "Pinus", species: "sylvestris"))
        #expect(batch.stage == .planned)
        #expect(first.advanceSeedBatchStage(id: batch.id) == .stratifying)
        #expect(first.seedBatch(id: batch.id)?.stage == .stratifying)

        first.updateSeedBatch(
            id: batch.id,
            name: "Pinus",
            species: "sylvestris",
            stage: .stratifying,
            notes: "Cold",
            soilMixID: mix.id
        )
        #expect(first.seedBatch(id: batch.id)?.soilMixID == mix.id)
        #expect(first.activeSeedBatchCount == 1)

        var maple = try #require(first.tree(id: Self.mapleID))
        maple.soilMixID = mix.id
        first.replaceTree(maple)

        let item = try #require(first.addInventoryItem(
            name: "Copper wire",
            kind: .wire,
            quantity: 3,
            minimumQuantity: 5
        ))
        #expect(item.quantitySummary.contains("3"))
        #expect(first.isInventoryLowStock(item))
        first.adjustInventoryQuantity(id: item.id, by: 1)
        #expect(first.inventoryItem(id: item.id)?.quantity == 4)
        first.adjustInventoryQuantity(id: item.id, by: -10)
        #expect(first.inventoryItem(id: item.id)?.quantity == 0)

        let loc = try #require(first.addLocation(
            name: "Bench East",
            geographicPosition: GeographicPosition(latitude: 59.9, longitude: 10.7)
        ))
        #expect(loc.latitude == 59.9)

        let jpeg = Data("seed-photo".utf8)
        let photo = try #require(
            first.addPhoto(
                toSeedBatch: batch.id,
                jpegData: jpeg,
                width: 4,
                height: 4,
                fileName: "seed.jpg"
            )
        )
        #expect(first.seedBatch(id: batch.id)?.primaryImageID == photo.id)
        let jpeg2 = Data("seed-photo-2".utf8)
        let photo2 = try #require(
            first.addPhoto(
                toSeedBatch: batch.id,
                jpegData: jpeg2,
                width: 4,
                height: 4,
                fileName: "seed2.jpg"
            )
        )
        first.setPrimaryImage(seedBatchID: batch.id, imageID: photo2.id)

        let repot = first.addWork(
            treeID: Self.mapleID,
            workTypeID: CanonicalWorkTypeID.repotting,
            notes: "Spring repot",
            soilMixID: mix.id,
            applySoilMix: true
        )
        #expect(repot.soilMixID == mix.id)
        #expect(first.tree(id: Self.mapleID)?.soilMixID == mix.id)
        #expect(first.activeSeedBatchCount == 1)
        #expect(first.lastRepotDate(for: Self.mapleID) == repot.performedAt)
        #expect(first.trees(usingSoilMix: mix.id).map(\.id) == [Self.mapleID])
        #expect(first.seedBatches(usingSoilMix: mix.id).map(\.id) == [batch.id])

        let exportURL = try first.prepareLibraryExportPackage()
        #expect(exportURL.pathExtension.lowercased() == "zip")
        #expect(FileManager.default.fileExists(atPath: exportURL.path))

        let (importStore, importTemp) = try makeTempStore()
        defer { try? FileManager.default.removeItem(at: importTemp) }
        let importer = DemoLibrary(store: importStore)
        try importer.importLibraryPackage(from: exportURL)
        #expect(importer.tree(id: Self.mapleID)?.nickname == "Terrace Maple")
        #expect(importer.soilMix(id: mix.id)?.name == "Akadama blend")
        try? FileManager.default.removeItem(at: exportURL)

        first.removePhoto(fromSeedBatch: batch.id, imageID: photo.id)
        #expect(first.seedBatch(id: batch.id)?.imageIDs == [photo2.id])
        #expect(first.seedBatch(id: batch.id)?.primaryImageID == photo2.id)

        first.deleteSoilMix(id: mix.id)
        #expect(first.soilMix(id: mix.id) == nil)
        #expect(first.tree(id: Self.mapleID)?.soilMixID == nil)
        #expect(first.seedBatch(id: batch.id)?.soilMixID == nil)

        let second = DemoLibrary(store: store)
        #expect(second.soilMix(id: mix.id) == nil)
        #expect(second.seedBatch(id: batch.id)?.stage == .stratifying)
        #expect(second.seedBatch(id: batch.id)?.imageIDs == [photo2.id])
        #expect(second.seedBatch(id: batch.id)?.primaryImageID == photo2.id)
        #expect(second.seedBatch(id: batch.id)?.soilMixID == nil)
        #expect(second.tree(id: Self.mapleID)?.soilMixID == nil)
        #expect(second.inventoryItem(id: item.id)?.minimumQuantity == 5)
        #expect(second.inventoryItem(id: item.id)?.quantity == 0)
        #expect(second.location(id: loc.id)?.longitude == 10.7)
        #expect(second.work(for: Self.mapleID).first { $0.id == repot.id }?.soilMixID == mix.id)

        second.deleteInventoryItem(id: item.id)
        #expect(second.inventoryItem(id: item.id) == nil)
        let third = DemoLibrary(store: store)
        #expect(third.inventoryItem(id: item.id) == nil)

        third.deleteSeedBatch(id: batch.id)
        #expect(third.seedBatch(id: batch.id) == nil)
        let fourth = DemoLibrary(store: store)
        #expect(fourth.seedBatch(id: batch.id) == nil)
    }

    @Test func createTreeSurvivesRestart() throws {
        let (store, temp) = try makeTempStore()
        defer { try? FileManager.default.removeItem(at: temp) }

        let first = DemoLibrary(store: store)
        let preview = try #require(first.previewNextBonsaiName(botanicalName: "Acer palmatum"))
        let tree = try #require(first.createTree(
            botanicalName: "Acer palmatum",
            nickname: "Field Maple",
            locationID: CanonicalLocationID.altan
        ))
        #expect(tree.botanicalName == "Acer palmatum")
        #expect(tree.nickname == "Field Maple")
        #expect(tree.locationID == CanonicalLocationID.altan)
        #expect(tree.bonsaiName.hasPrefix("ACE-PAL-"))
        #expect(tree.bonsaiName == preview)
        #expect(first.myTrees.contains { $0.id == tree.id })

        let second = DemoLibrary(store: store)
        let reloaded = try #require(second.tree(id: tree.id))
        #expect(reloaded.nickname == "Field Maple")
        #expect(reloaded.bonsaiName == tree.bonsaiName)
        #expect(reloaded.locationID == CanonicalLocationID.altan)
    }

    @Test func deleteTreeRemovesWorkTasksPhotosAndSurvivesRestart() throws {
        let (store, temp) = try makeTempStore()
        defer { try? FileManager.default.removeItem(at: temp) }

        let first = DemoLibrary(store: store)
        let tree = try #require(first.createTree(
            botanicalName: "Pinus densiflora",
            nickname: "Delete Me",
            locationID: CanonicalLocationID.altan
        ))
        first.addWork(
            treeID: tree.id,
            workTypeID: CanonicalWorkTypeID.watering,
            performedAt: Date(timeIntervalSince1970: 1_700_000_100),
            notes: "Delete with tree."
        )
        let task = try #require(first.addTask(
            title: "Water delete-me",
            workTypeID: CanonicalWorkTypeID.watering,
            treeID: tree.id,
            dueDate: .now
        ))
        let collection = try #require(first.addCollection(name: "Delete membership"))
        first.addTree(tree.id, to: collection.id)
        #expect(first.work(for: tree.id).isEmpty == false)
        #expect(first.careTasks.contains { $0.id == task.id })
        #expect(first.collection(id: collection.id)?.treeIDs.contains(tree.id) == true)

        first.deleteTree(id: tree.id)
        #expect(first.tree(id: tree.id) == nil)
        #expect(first.work(for: tree.id).isEmpty)
        #expect(first.careTasks.contains { $0.id == task.id } == false)
        #expect(first.collections.allSatisfy { !$0.treeIDs.contains(tree.id) })
        #expect(first.lastSaveError == nil)

        let second = DemoLibrary(store: store)
        #expect(second.tree(id: tree.id) == nil)
        #expect(second.workRecords.contains { $0.treeIDs.contains(tree.id) } == false)
        #expect(second.careTasks.contains { $0.treeIDs.contains(tree.id) } == false)
        #expect(second.collections.allSatisfy { !$0.treeIDs.contains(tree.id) })
    }

    @Test func resetLibraryToDemoWipesAndReseeds() throws {
        let (store, temp) = try makeTempStore()
        defer { try? FileManager.default.removeItem(at: temp) }

        let first = DemoLibrary(store: store)
        let custom = try #require(first.addInventoryItem(
            name: "Custom wire",
            kind: .wire,
            quantity: 1,
            minimumQuantity: 2
        ))
        _ = try #require(first.addSeedBatch(name: "Pinus", species: "sylvestris"))
        #expect(first.inventoryItem(id: custom.id) != nil)
        #expect(first.seedBatches.isEmpty == false)

        first.resetLibraryToDemo()
        #expect(first.lastLoadError == nil)
        #expect(first.trees.map(\.id) == DemoLibrary.sampleTrees.map(\.id))
        #expect(first.seedBatches.isEmpty)
        #expect(first.soilMixes.isEmpty)
        #expect(first.inventoryStock.isEmpty)
        #expect(first.inventoryItem(id: custom.id) == nil)
        #expect(first.activeSeedBatchCount == 0)
        #expect(first.tree(id: Self.mapleID)?.nickname == "Terrace Maple")

        let second = DemoLibrary(store: store)
        #expect(second.lastLoadError == nil)
        #expect(second.trees.map(\.id) == DemoLibrary.sampleTrees.map(\.id))
        #expect(second.seedBatches.isEmpty)
        #expect(second.inventoryStock.isEmpty)
        #expect(second.inventoryItem(id: custom.id) == nil)
    }

    @Test func clearAllPhotosRemovesImagesAndKeepsTrees() throws {
        let (store, temp) = try makeTempStore()
        defer { try? FileManager.default.removeItem(at: temp) }

        let first = DemoLibrary(store: store)
        let jpeg = Data("clear-photos".utf8)
        let photo = try #require(
            first.addPhoto(
                to: Self.mapleID,
                jpegData: jpeg,
                width: 4,
                height: 4,
                fileName: "maple.jpg"
            )
        )
        #expect(first.tree(id: Self.mapleID)?.imageIDs == [photo.id])

        first.clearAllPhotos()
        #expect(first.tree(id: Self.mapleID)?.imageIDs.isEmpty == true)
        #expect(first.tree(id: Self.mapleID)?.primaryImageID == nil)
        #expect(first.tree(id: Self.mapleID)?.nickname == "Terrace Maple")

        let second = DemoLibrary(store: store)
        #expect(second.tree(id: Self.mapleID)?.imageIDs.isEmpty == true)
        #expect(second.tree(id: Self.mapleID)?.nickname == "Terrace Maple")
    }
}
