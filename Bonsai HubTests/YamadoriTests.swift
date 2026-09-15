//
//  YamadoriTests.swift
//  Bonsai HubTests
//

import Foundation
import Testing
@testable import Bonsai_Hub

@MainActor
struct YamadoriIDServiceTests {
    @Test func formatsZeroPaddedCode() {
        #expect(YamadoriIDService.format(year: 2026, sequence: 1) == "YAM-2026-001")
        #expect(YamadoriIDService.format(year: 2026, sequence: 24) == "YAM-2026-024")
    }

    @Test func parsesValidCodes() {
        let parsed = YamadoriIDService.parse("YAM-2026-024")
        #expect(parsed?.year == 2026)
        #expect(parsed?.sequence == 24)
    }

    @Test func nextCodeIncrementsWithinYear() {
        let tripID = UUID()
        let existing = [
            YamadoriFind(yamadoriID: tripID, yamadoriCode: "YAM-2026-001"),
            YamadoriFind(yamadoriID: tripID, yamadoriCode: "YAM-2026-003"),
            YamadoriFind(yamadoriID: tripID, yamadoriCode: "YAM-2025-099"),
        ]
        #expect(YamadoriIDService.nextCode(year: 2026, existing: existing) == "YAM-2026-004")
    }
}

@MainActor
struct YamadoriLifecycleTests {
    private func makeTreeService() -> TreeService {
        TreeService(
            repository: PreviewTreeRepository(previewData: PreviewData()),
            collectionRepository: PreviewCollectionRepository(previewData: PreviewData())
        )
    }

    private func makeService(treeService: TreeService? = nil) -> YamadoriService {
        let trees = treeService ?? makeTreeService()
        return YamadoriService(repository: PreviewYamadoriRepository(), treeService: trees)
    }

    private func collectInputs() -> (locationID: UUID, acquisitionMethodID: UUID, treeStageID: UUID) {
        (UUID(), UUID(), UUID())
    }

    @Test func createStartsAsScoutAndAllocatesCode() throws {
        let service = makeService()
        let created = try service.createYamadori(fromDraft: NewYamadoriDraft(displayName: "Ridge Pine"))
        #expect(created.find.status == .scout)
        #expect(YamadoriIDService.parse(created.find.yamadoriCode) != nil)
        #expect(service.getAllYamadori().count == 1)
        #expect(service.getAllFinds().count == 1)
        #expect(created.find.yamadoriID == created.trip.id)
    }

    @Test func createAllowsMultipleFindsPerTrip() throws {
        let service = makeService()
        let created = try service.createYamadori(fromDraft: NewYamadoriDraft(displayName: "Ridge"))
        let second = try service.createFind(onYamadoriID: created.trip.id, displayName: "Second")
        #expect(service.finds(forYamadoriID: created.trip.id).count == 2)
        #expect(second.yamadoriID == created.trip.id)
        #expect(second.yamadoriCode != created.find.yamadoriCode)
    }

    @Test func markCollectedCreatesYamadoriTree() throws {
        let treeService = makeTreeService()
        let service = makeService(treeService: treeService)
        let treeCountBefore = treeService.getAllTrees().count
        let inputs = collectInputs()

        var draft = NewYamadoriDraft(displayName: "Cliff Juniper")
        draft.genusID = UUID()
        draft.speciesID = UUID()
        let created = try service.createYamadori(fromDraft: draft)
        _ = try service.setStatus(id: created.find.id, to: .planned)

        var collectDraft = YamadoriCollectDraft()
        collectDraft.locationID = inputs.locationID

        let result = try service.markCollected(
            id: created.find.id,
            draft: collectDraft,
            acquisitionMethodID: inputs.acquisitionMethodID,
            treeStageID: inputs.treeStageID,
            genusName: "Juniperus",
            speciesName: "communis",
            cultivarName: nil,
            validLocationIDs: [inputs.locationID]
        )

        #expect(treeService.getAllTrees().count == treeCountBefore + 1)
        #expect(result.find.status == .collected)
        #expect(result.find.linkedTreeID == result.tree.id)
        #expect(result.tree.bonsaiName == created.find.yamadoriCode)
        #expect(result.tree.yamadoriNursery)
        #expect(result.tree.sourceYamadoriID == created.find.id)
    }

    @Test func advanceStatusMovesScoutToPlannedOnly() throws {
        let service = makeService()
        let created = try service.createYamadori(fromDraft: NewYamadoriDraft())
        _ = try service.advanceStatus(id: created.find.id)
        #expect(service.getFind(id: created.find.id)?.status == .planned)
    }

    @Test func graduateToMyTreesUpdatesExistingTree() throws {
        let treeService = makeTreeService()
        let service = makeService(treeService: treeService)
        let inputs = collectInputs()

        let genusID = UUID()
        let speciesID = UUID()

        var draft = NewYamadoriDraft(displayName: "Established Find")
        draft.genusID = genusID
        draft.speciesID = speciesID
        let created = try service.createYamadori(fromDraft: draft)
        _ = try service.setStatus(id: created.find.id, to: .planned)

        var collectDraft = YamadoriCollectDraft()
        collectDraft.locationID = inputs.locationID
        let collected = try service.markCollected(
            id: created.find.id,
            draft: collectDraft,
            acquisitionMethodID: inputs.acquisitionMethodID,
            treeStageID: inputs.treeStageID,
            genusName: "Pinus",
            speciesName: "mugo",
            cultivarName: nil,
            validLocationIDs: [inputs.locationID]
        )
        let treeCountAfterCollect = treeService.getAllTrees().count

        var transfer = YamadoriTransferDraft()
        transfer.nickname = "Cliff"

        let tree = try service.transferToTree(
            id: created.find.id,
            draft: transfer,
            acquisitionMethodID: inputs.acquisitionMethodID,
            treeStageID: inputs.treeStageID,
            genusName: "Pinus",
            speciesName: "mugo",
            cultivarName: nil,
            validLocationIDs: [inputs.locationID]
        )

        #expect(treeService.getAllTrees().count == treeCountAfterCollect)
        #expect(tree.id == collected.tree.id)
        #expect(tree.sourceYamadoriID == created.find.id)
        #expect(!tree.yamadoriNursery)
        #expect(tree.bonsaiName != created.find.yamadoriCode)

        let find = try #require(service.getFind(id: created.find.id))
        #expect(find.status == .transferred)
        #expect(find.linkedTreeID == tree.id)
        #expect(find.yamadoriCode == created.find.yamadoriCode)
    }

    @Test func transferRejectedBeforeCollected() throws {
        let service = makeService()
        let created = try service.createYamadori(fromDraft: NewYamadoriDraft(
            genusID: UUID(),
            speciesID: UUID()
        ))
        var transfer = YamadoriTransferDraft()
        transfer.locationID = UUID()

        do {
            _ = try service.transferToTree(
                id: created.find.id,
                draft: transfer,
                acquisitionMethodID: UUID(),
                treeStageID: UUID(),
                genusName: "Pinus",
                speciesName: "mugo",
                cultivarName: nil,
                validLocationIDs: [transfer.locationID!]
            )
            Issue.record("Expected transfer to fail before Collected")
        } catch let error as YamadoriServiceError {
            guard case .notEstablishedForTransfer = error else {
                Issue.record("Unexpected YamadoriServiceError: \(error)")
                return
            }
        } catch {
            Issue.record("Unexpected error: \(error)")
        }
    }

    @Test func legacyMigrationPreservesFindUUID() throws {
        let findID = UUID()
        let json = """
        {"id":"\(findID.uuidString)","yamadoriCode":"YAM-2024-007","displayName":"Legacy Pine","status":"recovery","createdDate":771667200,"modifiedDate":771667200,"locationDescription":"","countryRegion":"","landOwnershipNotes":"","permissionNotes":"","siteKey":"","evaluationTrunk":"","evaluationNebari":"","evaluationMovement":"","evaluationTaper":"","evaluationBranches":"","evaluationHealth":"","evaluationAccessibility":"","evaluationDifficulty":"","evaluationOverall":"","collectionWindowNotes":"","preparationNotes":"","equipmentNotes":"","collectionPlanNotes":"","preCollectionChecklist":[],"collectionKitChecklist":[],"collectionObservations":"","rootNotes":"","transportNotes":"","initialPlacement":"","initialRecoveryNotes":"","recoveryLocationNotes":"","recoveryCareNotes":"","establishmentAssessment":"","transferNotes":"","imageIDs":[],"observations":[],"history":[],"notes":""}
        """.data(using: .utf8)!
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        let legacy = try decoder.decode(LegacyYamadoriRecord.self, from: json)
        let pair = legacy.migratedTripAndFind()
        #expect(pair.1.id == findID)
        #expect(pair.1.yamadoriCode == "YAM-2024-007")
    }
}
