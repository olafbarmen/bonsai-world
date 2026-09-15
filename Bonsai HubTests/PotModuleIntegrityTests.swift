//
//  PotModuleIntegrityTests.swift
//  Bonsai HubTests
//
//  Engineering verification: Tree ↔ Pot sync, Maker independence, PotType,
//  seed identity stability, and Pot JSON backward compatibility.
//

import Foundation
import Testing
@testable import Bonsai_Hub

@MainActor
struct PotTreeRelationshipTests {

    private func makeTreeService() -> TreeService {
        let previewData = PreviewData()
        return TreeService(
            repository: PreviewTreeRepository(previewData: previewData),
            collectionRepository: PreviewCollectionRepository(previewData: previewData)
        )
    }

    private func makePotService(treeService: TreeService, pots: [Pot] = []) -> PotService {
        PotService(repository: PreviewPotRepository(pots: pots), treeService: treeService)
    }

    private func makeTree(
        _ treeService: TreeService,
        bonsaiName: String
    ) throws -> Tree {
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

    @Test func assignUpdatesBothSidesAndHistory() throws {
        let treeService = makeTreeService()
        let potService = makePotService(treeService: treeService)
        let tree = try makeTree(treeService, bonsaiName: "PIN-MUG-XXX-2026-001")
        let pot = try potService.createPot(Pot(name: "Round Tokoname"))

        try potService.assignPot(pot.id, toTreeID: tree.id)

        let linked = try #require(potService.getPot(id: pot.id))
        let refreshedTree = try #require(treeService.getTree(id: tree.id))
        #expect(linked.status == .inUse)
        #expect(linked.linkedTreeID == tree.id)
        #expect(refreshedTree.currentPotID == pot.id)
        #expect(linked.history.contains { $0.kind == .linkedToTree && $0.relatedTreeID == tree.id })
    }

    @Test func unassignClearsBothSidesAndReturnsAvailable() throws {
        let treeService = makeTreeService()
        let potService = makePotService(treeService: treeService)
        let tree = try makeTree(treeService, bonsaiName: "PIN-MUG-XXX-2026-002")
        let pot = try potService.createPot(Pot(name: "Oval"))

        try potService.assignPot(pot.id, toTreeID: tree.id)
        try potService.unassignCurrentPot(fromTreeID: tree.id)

        let unlinked = try #require(potService.getPot(id: pot.id))
        let refreshedTree = try #require(treeService.getTree(id: tree.id))
        #expect(unlinked.status == .available)
        #expect(unlinked.linkedTreeID == nil)
        #expect(refreshedTree.currentPotID == nil)
        #expect(unlinked.history.contains { $0.kind == .unlinkedFromTree && $0.relatedTreeID == tree.id })
        #expect(unlinked.history.contains { $0.kind == .linkedToTree })
    }

    @Test func replacingPotClearsOldRelationship() throws {
        let treeService = makeTreeService()
        let potService = makePotService(treeService: treeService)
        let tree = try makeTree(treeService, bonsaiName: "PIN-MUG-XXX-2026-003")
        let oldPot = try potService.createPot(Pot(name: "Old"))
        let newPot = try potService.createPot(Pot(name: "New"))

        try potService.assignPot(oldPot.id, toTreeID: tree.id)
        try potService.assignPot(newPot.id, toTreeID: tree.id)

        let old = try #require(potService.getPot(id: oldPot.id))
        let new = try #require(potService.getPot(id: newPot.id))
        let refreshedTree = try #require(treeService.getTree(id: tree.id))
        #expect(old.linkedTreeID == nil)
        #expect(old.status == .available)
        #expect(new.linkedTreeID == tree.id)
        #expect(new.status == .inUse)
        #expect(refreshedTree.currentPotID == newPot.id)
        #expect(old.history.contains { $0.kind == .unlinkedFromTree && $0.relatedTreeID == tree.id })
    }

    @Test func onePotCannotRemainCurrentOnTwoTrees() throws {
        let treeService = makeTreeService()
        let potService = makePotService(treeService: treeService)
        let treeA = try makeTree(treeService, bonsaiName: "PIN-MUG-XXX-2026-004")
        let treeB = try makeTree(treeService, bonsaiName: "PIN-MUG-XXX-2026-005")
        let pot = try potService.createPot(Pot(name: "Shared"))

        try potService.assignPot(pot.id, toTreeID: treeA.id)
        // Directly force Available while still linked — the integrity bug returnToAvailable used to allow.
        var broken = try #require(potService.getPot(id: pot.id))
        broken.status = .available
        _ = try potService.updatePot(broken)

        try potService.assignPot(pot.id, toTreeID: treeB.id)

        let refreshed = try #require(potService.getPot(id: pot.id))
        let a = try #require(treeService.getTree(id: treeA.id))
        let b = try #require(treeService.getTree(id: treeB.id))
        #expect(refreshed.linkedTreeID == treeB.id)
        #expect(b.currentPotID == pot.id)
        #expect(a.currentPotID == nil)
        #expect(potService.pots.filter { $0.linkedTreeID == treeA.id }.isEmpty)
    }

    @Test func returnToAvailableClearsLingeringTreeLink() throws {
        let treeService = makeTreeService()
        let potService = makePotService(treeService: treeService)
        let tree = try makeTree(treeService, bonsaiName: "PIN-MUG-XXX-2026-006")
        let pot = try potService.createPot(Pot(name: "In Use"))

        try potService.assignPot(pot.id, toTreeID: tree.id)
        try potService.returnToAvailable(potID: pot.id)

        let refreshed = try #require(potService.getPot(id: pot.id))
        let refreshedTree = try #require(treeService.getTree(id: tree.id))
        #expect(refreshed.status == .available)
        #expect(refreshed.linkedTreeID == nil)
        #expect(refreshedTree.currentPotID == nil)
    }

    @Test func soldUnassignsAndKeepsHistory() throws {
        let treeService = makeTreeService()
        let potService = makePotService(treeService: treeService)
        let tree = try makeTree(treeService, bonsaiName: "PIN-MUG-XXX-2026-007")
        let pot = try potService.createPot(Pot(name: "Sale"))

        try potService.assignPot(pot.id, toTreeID: tree.id)
        try potService.markSold(potID: pot.id, date: .now, price: 100, buyerName: "Buyer", notes: "")

        let sold = try #require(potService.getPot(id: pot.id))
        #expect(sold.status == .sold)
        #expect(sold.linkedTreeID == nil)
        #expect(treeService.getTree(id: tree.id)?.currentPotID == nil)
        #expect(sold.history.contains { $0.kind == .linkedToTree })
        #expect(sold.history.contains { $0.kind == .unlinkedFromTree })
        #expect(sold.history.contains { $0.kind == .sold })
    }
}

@MainActor
struct PotMakerIndependenceTests {

    @Test func makerWithNilBrandEncodesAndDecodes() throws {
        let maker = PotMaker(name: "Independent Potter", brandID: nil, country: "Japan")
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let data = try encoder.encode(maker)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let decoded = try decoder.decode(PotMaker.self, from: data)
        #expect(decoded.brandID == nil)
        #expect(decoded.name == "Independent Potter")
    }

    @Test func makerWithBrandStillWorks() throws {
        let brandID = UUID()
        let maker = PotMaker(name: "Brand Potter", brandID: brandID)
        #expect(maker.brandID == brandID)
    }

    @Test func seedIncludesIndependentMakers() {
        let independents = PotBrandPreviewData.makers.filter { $0.brandID == nil }
        #expect(independents.isEmpty == false)
        #expect(independents.allSatisfy { $0.isSystemSeed })
    }

    @Test func selectableMakersIncludeIndependentsWhenBrandChosen() {
        let store = ReferencePreviewData()
        store.potBrands = PotBrandPreviewData.all
        store.potMakers = PotBrandPreviewData.makers
        let reference = ReferenceDataService(previewData: store)
        guard let brand = reference.potBrands.first else {
            Issue.record("Expected seed brands")
            return
        }
        let selectable = reference.potMakersSelectable(forBrandID: brand.id)
        #expect(selectable.contains { $0.brandID == nil })
        #expect(selectable.contains { $0.brandID == brand.id })
    }
}

@MainActor
struct PotTypeAndPersistenceTests {

    @Test func potStoresPotTypeIDWithoutHardcodedName() throws {
        let typeID = UUID()
        let pot = Pot(name: "Typed", potTypeID: typeID)
        #expect(pot.potTypeID == typeID)

        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let data = try encoder.encode(pot)
        let json = String(data: data, encoding: .utf8) ?? ""
        #expect(json.contains("potTypeID"))
        #expect(!json.contains("Training Pot"))
    }

    @Test func potPersistsWithoutBrandMakerOrDating() throws {
        let pot = Pot(name: "Minimal", datingConfidence: .unknown)
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let data = try encoder.encode(pot)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let decoded = try decoder.decode(Pot.self, from: data)
        #expect(decoded.brandID == nil)
        #expect(decoded.makerID == nil)
        #expect(decoded.madeYear == nil)
        #expect(decoded.datingConfidence == .unknown)
    }

    @Test func potPersistsStampImageIDsOnly() throws {
        let stampID = UUID()
        let pot = Pot(name: "Stamped", stampImageIDs: [stampID])
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let data = try encoder.encode(pot)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let decoded = try decoder.decode(Pot.self, from: data)
        #expect(decoded.stampImageIDs == [stampID])
    }

    @Test func legacyPotJSONWithoutNewFieldsStillDecodes() throws {
        let id = UUID()
        let json = """
        {
          "id": "\(id.uuidString)",
          "name": "Legacy Pot",
          "status": "available",
          "material": "",
          "glaze": "",
          "shape": "",
          "condition": "",
          "purchaseSellerName": "",
          "purchaseNotes": "",
          "saleBuyerName": "",
          "saleNotes": "",
          "brokenReason": "",
          "brokenNotes": "",
          "retiredNotes": "",
          "notes": "",
          "imageIDs": [],
          "history": [],
          "createdDate": "2026-01-01T00:00:00Z",
          "modifiedDate": "2026-01-01T00:00:00Z"
        }
        """
        let data = try #require(json.data(using: .utf8))
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let pot = try decoder.decode(Pot.self, from: data)
        #expect(pot.id == id)
        #expect(pot.stampImageIDs.isEmpty)
        #expect(pot.datingConfidence == .unknown)
        #expect(pot.generationPeriod.isEmpty)
        #expect(pot.brandID == nil)
    }

    @Test func historyWithoutRelatedTreeIDStillDecodes() throws {
        let id = UUID()
        let json = """
        {
          "id": "\(id.uuidString)",
          "kind": "linkedToTree",
          "date": "2026-04-01T00:00:00Z",
          "note": "Old entry"
        }
        """
        let data = try #require(json.data(using: .utf8))
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let entry = try decoder.decode(PotHistoryEntry.self, from: data)
        #expect(entry.relatedTreeID == nil)
        #expect(entry.note == "Old entry")
    }

    @Test func missingPotTypeReferenceDoesNotCrashLookup() {
        let store = ReferencePreviewData()
        let reference = ReferenceDataService(previewData: store)
        #expect(reference.potType(id: UUID()) == nil)
    }
}

@MainActor
struct PotSeedIdentityTests {

    @Test func seedIDsAreStableAcrossCalls() {
        let brandA = PotBrandPreviewData.brandID(named: "Yamaaki")
        let brandB = PotBrandPreviewData.brandID(named: "Yamaaki")
        #expect(brandA == brandB)

        let makerA = PotBrandPreviewData.makerID(named: "Independent", brand: nil)
        let makerB = PotBrandPreviewData.makerID(named: "Independent", brand: nil)
        #expect(makerA == makerB)
    }

    @Test func seedVersionIsOneAndSystemFlagsSet() {
        #expect(PotBrandPreviewData.seedVersion == 1)
        #expect(PotBrandPreviewData.all.allSatisfy { $0.isSystemSeed })
        #expect(PotBrandPreviewData.makers.allSatisfy { $0.isSystemSeed })
    }

    @Test func seedCatalogHasUniqueIDs() {
        let brandIDs = PotBrandPreviewData.all.map(\.id)
        let makerIDs = PotBrandPreviewData.makers.map(\.id)
        #expect(Set(brandIDs).count == brandIDs.count)
        #expect(Set(makerIDs).count == makerIDs.count)
    }

    @Test func migrationSkipsWhenSeedVersionCurrent() throws {
        let temp = FileManager.default.temporaryDirectory
            .appendingPathComponent("bonsai-pot-seed-test-\(UUID().uuidString)", isDirectory: true)
        try FileManager.default.createDirectory(at: temp, withIntermediateDirectories: true)
        defer { try? FileManager.default.removeItem(at: temp) }

        let provider = LocalStorageProvider(
            rootURL: temp,
            libraryLocation: LibraryLocationConfiguration(kind: .customFolder, bookmarkData: Data())
        )
        let storage = StorageService(provider: provider)
        try storage.ensureLibraryFolderStructure()

        let previewStore = ReferencePreviewData()
        previewStore.potBrands = PotBrandPreviewData.all
        previewStore.potMakers = PotBrandPreviewData.makers
        let previewRepo = PreviewPotBrandRepository(store: previewStore)
        let libraryRepo = LibraryPotBrandRepository(storage: storage)

        let userBrand = PotBrand(name: "My Custom Brand", isSystemSeed: false)
        let userMaker = PotMaker(name: "My Independent Maker", brandID: nil, isSystemSeed: false)

        let first = PotBrandMigrationService.migrateIfNeeded(
            storage: storage,
            libraryReady: true,
            previewRepository: previewRepo,
            libraryRepository: libraryRepo
        )
        guard case .migrated = first else {
            Issue.record("Expected first migration, got \(first)")
            return
        }

        var brands = libraryRepo.getAllBrands()
        var makers = libraryRepo.getAllMakers()
        brands.append(userBrand)
        makers.append(userMaker)
        try libraryRepo.replaceCatalog(
            brands: brands,
            makers: makers,
            seedVersion: PotBrandPreviewData.seedVersion
        )

        let second = PotBrandMigrationService.migrateIfNeeded(
            storage: storage,
            libraryReady: true,
            previewRepository: previewRepo,
            libraryRepository: libraryRepo
        )
        #expect(second == .notRequired)

        let persistedBrands = libraryRepo.getAllBrands()
        let persistedMakers = libraryRepo.getAllMakers()
        #expect(persistedBrands.contains { $0.id == userBrand.id && $0.name == "My Custom Brand" })
        #expect(persistedMakers.contains { $0.id == userMaker.id && $0.brandID == nil })
        #expect(libraryRepo.getSeedVersion() == PotBrandPreviewData.seedVersion)

        // System seed IDs unchanged after user merge.
        for seed in PotBrandPreviewData.all {
            #expect(persistedBrands.contains { $0.id == seed.id })
        }
    }
}
