//
//  LibraryImportDuplicateNameTests.swift
//  Bonsai HubTests
//
//  Preview must match Apply for bonsaiName uniqueness on Excel Tree import.
//

import Foundation
import Testing
@testable import Bonsai_Hub

@MainActor
struct LibraryImportDuplicateNameTests {

    private let genusName = "Pinus"
    private let speciesName = "Pinus mugo"
    private let locationName = "Hage"

    private func makeTreeService() -> TreeService {
        let previewData = PreviewData()
        previewData.trees = []
        return TreeService(
            repository: PreviewTreeRepository(previewData: previewData),
            collectionRepository: PreviewCollectionRepository(previewData: previewData)
        )
    }

    private func reference() -> ReferenceDataService {
        ReferenceDataService(previewData: ReferencePreviewData())
    }

    private func createRow(
        treeID: String = "",
        bonsaiName: String,
        botanicalName: String = "Pinus mugo",
        nickname: String = ""
    ) -> [String] {
        [
            treeID,
            bonsaiName,
            botanicalName,
            nickname,
            genusName,
            speciesName,
            "", // Cultivar
            "", "", "", "", "", // Style…In Care
            locationName,
        ]
    }

    private func writeWorkbook(rows: [[String]]) throws -> URL {
        let headers = [
            "Tree ID",
            "Bonsai Name",
            "Botanical Name",
            "Nickname",
            "Genus",
            "Species",
            "Cultivar",
            "Style",
            "Size Class",
            "Tree Stage",
            "Health",
            "In Care",
            "Location",
        ]
        let url = FileManager.default.temporaryDirectory
            .appendingPathComponent("bonsai-import-dup-\(UUID().uuidString).xlsx")
        try MinimalXLSXWriter.write(
            sheets: [MinimalXLSXWriter.Sheet(name: "Trees", rows: [headers] + rows)],
            to: url
        )
        return url
    }

    private func seedTree(
        _ treeService: TreeService,
        reference: ReferenceDataService,
        bonsaiName: String
    ) throws -> Tree {
        let genusID = try #require(reference.genus.first { $0.name == genusName }?.id)
        let speciesID = try #require(reference.species.first { $0.name == speciesName }?.id)
        let locationID = try #require(reference.locations.first { $0.name == locationName }?.id)
        return try treeService.createTree(
            Tree(
                botanicalName: speciesName,
                bonsaiName: bonsaiName,
                genusID: genusID,
                speciesID: speciesID,
                locationID: locationID
            )
        )
    }

    @Test func caseA_validCreatePreviewAndApply() throws {
        let treeService = makeTreeService()
        let reference = reference()
        let url = try writeWorkbook(rows: [
            createRow(bonsaiName: "PIN-MUG-IMP-2026-001"),
        ])
        defer { try? FileManager.default.removeItem(at: url) }

        let preview = try LibraryImportService.previewExcelImport(
            from: url,
            trees: treeService.trees,
            collections: treeService.collections,
            referenceData: reference
        )
        #expect(preview.treesToCreate == 1)
        #expect(preview.treesToUpdate == 0)
        #expect(preview.treesSkipped == 0)
        #expect(preview.issues.isEmpty)

        let work = WorkService(referenceData: reference)
        let result = try LibraryImportService.applyExcelImport(
            from: url,
            treeService: treeService,
            workService: work,
            referenceData: reference
        )
        #expect(result.treesToCreate == 1)
        #expect(treeService.trees.count == 1)
        #expect(treeService.trees.first?.bonsaiName == "PIN-MUG-IMP-2026-001")
    }

    @Test func caseB_validUpdateByTreeID() throws {
        let treeService = makeTreeService()
        let reference = reference()
        let existing = try seedTree(treeService, reference: reference, bonsaiName: "PIN-MUG-IMP-2026-010")
        let url = try writeWorkbook(rows: [
            createRow(
                treeID: existing.id.uuidString,
                bonsaiName: existing.bonsaiName,
                nickname: "Updated Nickname"
            ),
        ])
        defer { try? FileManager.default.removeItem(at: url) }

        let preview = try LibraryImportService.previewExcelImport(
            from: url,
            trees: treeService.trees,
            collections: treeService.collections,
            referenceData: reference
        )
        #expect(preview.treesToUpdate == 1)
        #expect(preview.treesToCreate == 0)
        #expect(preview.treesSkipped == 0)

        let work = WorkService(referenceData: reference)
        let result = try LibraryImportService.applyExcelImport(
            from: url,
            treeService: treeService,
            workService: work,
            referenceData: reference
        )
        #expect(result.treesToUpdate == 1)
        #expect(treeService.trees.count == 1)
        #expect(treeService.getTree(id: existing.id)?.nickname == "Updated Nickname")
        #expect(treeService.getTree(id: existing.id)?.bonsaiName == "PIN-MUG-IMP-2026-010")
    }

    @Test func caseC_existingNameConflictNotCountedAsCreate() throws {
        let treeService = makeTreeService()
        let reference = reference()
        let existing = try seedTree(treeService, reference: reference, bonsaiName: "PIN-MUG-IMP-2026-020")
        let url = try writeWorkbook(rows: [
            createRow(bonsaiName: "PIN-MUG-IMP-2026-020"),
        ])
        defer { try? FileManager.default.removeItem(at: url) }

        let preview = try LibraryImportService.previewExcelImport(
            from: url,
            trees: treeService.trees,
            collections: treeService.collections,
            referenceData: reference
        )
        #expect(preview.treesToCreate == 0)
        #expect(preview.treesToUpdate == 0)
        #expect(preview.treesSkipped == 1)
        #expect(preview.issues.contains { $0.message.contains("already used") })

        let work = WorkService(referenceData: reference)
        let result = try LibraryImportService.applyExcelImport(
            from: url,
            treeService: treeService,
            workService: work,
            referenceData: reference
        )
        #expect(result.treesToCreate == 0)
        #expect(result.treesSkipped == 1)
        #expect(treeService.trees.count == 1)
        #expect(treeService.getTree(id: existing.id)?.bonsaiName == "PIN-MUG-IMP-2026-020")
    }

    @Test func caseD_duplicateWithinImport_firstCreateRestSkipped() throws {
        let treeService = makeTreeService()
        let reference = reference()
        let url = try writeWorkbook(rows: [
            createRow(bonsaiName: "PIN-MUG-IMP-2026-030"),
            createRow(bonsaiName: "pin-mug-imp-2026-030"),
        ])
        defer { try? FileManager.default.removeItem(at: url) }

        let preview = try LibraryImportService.previewExcelImport(
            from: url,
            trees: treeService.trees,
            collections: treeService.collections,
            referenceData: reference
        )
        #expect(preview.treesToCreate == 1)
        #expect(preview.treesSkipped == 1)
        #expect(preview.issues.count == 1)

        let work = WorkService(referenceData: reference)
        let result = try LibraryImportService.applyExcelImport(
            from: url,
            treeService: treeService,
            workService: work,
            referenceData: reference
        )
        #expect(result.treesToCreate == 1)
        #expect(result.treesSkipped == 1)
        #expect(treeService.trees.count == 1)
    }

    @Test func caseE_mixedImportCountsAndApply() throws {
        let treeService = makeTreeService()
        let reference = reference()
        let existing = try seedTree(treeService, reference: reference, bonsaiName: "PIN-MUG-IMP-2026-040")
        _ = try seedTree(treeService, reference: reference, bonsaiName: "PIN-MUG-IMP-2026-041")

        let url = try writeWorkbook(rows: [
            createRow(bonsaiName: "PIN-MUG-IMP-2026-050"), // create
            createRow(
                treeID: existing.id.uuidString,
                bonsaiName: existing.bonsaiName,
                nickname: "Mixed Update"
            ), // update
            createRow(bonsaiName: "PIN-MUG-IMP-2026-041"), // conflict with existing
            createRow(bonsaiName: "PIN-MUG-IMP-2026-050"), // batch duplicate
        ])
        defer { try? FileManager.default.removeItem(at: url) }

        let preview = try LibraryImportService.previewExcelImport(
            from: url,
            trees: treeService.trees,
            collections: treeService.collections,
            referenceData: reference
        )
        #expect(preview.treesToCreate == 1)
        #expect(preview.treesToUpdate == 1)
        #expect(preview.treesSkipped == 2)
        #expect(preview.issues.count == 2)

        let beforeCount = treeService.trees.count
        let work = WorkService(referenceData: reference)
        let result = try LibraryImportService.applyExcelImport(
            from: url,
            treeService: treeService,
            workService: work,
            referenceData: reference
        )
        #expect(result.treesToCreate == 1)
        #expect(result.treesToUpdate == 1)
        #expect(result.treesSkipped == 2)
        #expect(treeService.trees.count == beforeCount + 1)
        #expect(treeService.getTree(id: existing.id)?.nickname == "Mixed Update")
        #expect(Set(treeService.trees.map(\.bonsaiName)).count == treeService.trees.count)
    }
}
