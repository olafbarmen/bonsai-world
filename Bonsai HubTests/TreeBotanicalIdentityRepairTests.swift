//
//  TreeBotanicalIdentityRepairTests.swift
//  Bonsai World
//

import Foundation
import Testing
@testable import Bonsai_Hub

struct TreeBotanicalIdentityRepairTests {

    @Test func botanicalIDsAreStableByNameNotListIndex() {
        let buergerianum = ReferencePreviewSeed.id(list: 2, named: "Acer buergerianum")
        let chinensis = ReferencePreviewSeed.id(list: 2, named: "Juniperus chinensis")
        let alsoBuergerianum = ReferencePreviewSeed.id(list: 2, named: "  ACER BUERGERIANUM  ")

        #expect(buergerianum != chinensis)
        #expect(buergerianum == alsoBuergerianum)
        #expect(SpeciesPreviewData.id(named: "Acer buergerianum") == buergerianum)
        #expect(SpeciesPreviewData.id(named: "Juniperus chinensis") == chinensis)
    }

    @Test func uuidV5MatchesPython() {
        let actual = ReferencePreviewSeed.id(list: 2, named: "Acer buergerianum")
        let python = UUID(uuidString: "45c2e300-3af5-501b-ab63-c4b2de12a688")
        #expect(actual == python)
    }

    @Test func repairsAcerBuergerianumPointingAtChinensis() throws {
        let acer = Genus(id: UUID(), name: "Acer", sortOrder: 1)
        let juniperus = Genus(id: UUID(), name: "Juniperus", sortOrder: 2)
        let buergerianum = Species(
            id: UUID(),
            name: "Acer buergerianum",
            genusID: acer.id,
            sortOrder: 1
        )
        let chinensis = Species(
            id: UUID(),
            name: "Juniperus chinensis",
            genusID: juniperus.id,
            sortOrder: 2
        )
        let catalog = TreeBotanicalIdentityRepair.Catalog(
            genera: [acer, juniperus],
            species: [buergerianum, chinensis],
            cultivars: []
        )
        let tree = Tree(
            botanicalName: "Acer buergerianum",
            bonsaiName: "ACE-BUE-XXX-2026-007",
            genusID: acer.id,
            speciesID: chinensis.id,
            locationID: UUID()
        )

        let repaired = try #require(TreeBotanicalIdentityRepair.repaired(tree, catalog: catalog))
        #expect(repaired.genusID == acer.id)
        #expect(repaired.speciesID == buergerianum.id)
        #expect(repaired.botanicalName == "Acer buergerianum")
        #expect(repaired.cultivarID == nil)
    }

    @Test func fillsEmptyIdentityFromBotanicalName() throws {
        let acer = Genus(id: UUID(), name: "Acer", sortOrder: 1)
        let buergerianum = Species(
            id: UUID(),
            name: "Acer buergerianum",
            genusID: acer.id,
            sortOrder: 1
        )
        let catalog = TreeBotanicalIdentityRepair.Catalog(
            genera: [acer],
            species: [buergerianum],
            cultivars: []
        )
        let tree = Tree(
            botanicalName: "Acer buergerianum",
            bonsaiName: "ACE-BUE-XXX-2026-001",
            locationID: UUID()
        )

        let repaired = try #require(TreeBotanicalIdentityRepair.repaired(tree, catalog: catalog))
        #expect(repaired.genusID == acer.id)
        #expect(repaired.speciesID == buergerianum.id)
    }

    @Test func doesNotCrossMatchEpithetAcrossGenera() {
        let acer = Genus(id: UUID(), name: "Acer", sortOrder: 1)
        let juniperus = Genus(id: UUID(), name: "Juniperus", sortOrder: 2)
        let chinensis = Species(
            id: UUID(),
            name: "Juniperus chinensis",
            genusID: juniperus.id,
            sortOrder: 1
        )
        let catalog = TreeBotanicalIdentityRepair.Catalog(
            genera: [acer, juniperus],
            species: [chinensis],
            cultivars: []
        )
        let tree = Tree(
            botanicalName: "Acer buergerianum",
            bonsaiName: "ACE-BUE-XXX-2026-001",
            genusID: acer.id,
            speciesID: chinensis.id,
            locationID: UUID()
        )

        let repaired = TreeBotanicalIdentityRepair.repaired(tree, catalog: catalog)
        #expect(repaired?.speciesID == nil)
        #expect(repaired?.genusID == acer.id)
    }

    @Test func noChangeWhenIdentityAlreadyMatches() {
        let acer = Genus(id: UUID(), name: "Acer", sortOrder: 1)
        let buergerianum = Species(
            id: UUID(),
            name: "Acer buergerianum",
            genusID: acer.id,
            sortOrder: 1
        )
        let catalog = TreeBotanicalIdentityRepair.Catalog(
            genera: [acer],
            species: [buergerianum],
            cultivars: []
        )
        let tree = Tree(
            botanicalName: "Acer buergerianum",
            bonsaiName: "ACE-BUE-XXX-2026-001",
            genusID: acer.id,
            speciesID: buergerianum.id,
            locationID: UUID()
        )

        #expect(TreeBotanicalIdentityRepair.repaired(tree, catalog: catalog) == nil)
    }
}
