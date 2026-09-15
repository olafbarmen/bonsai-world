//
//  SoilStockTests.swift
//  Bonsai HubTests
//

import Foundation
import Testing
@testable import Bonsai_Hub

struct SoilStockTests {
    @Test func estimatedVolumeIsBagsTimesSizePlusOpenBag() {
        let item = SoilStockItem(
            componentID: UUID(),
            bagSizeLiters: 14,
            bagCount: 6,
            openBagRemainingLiters: 0
        )
        #expect(item.estimatedVolumeLiters == 84)
    }

    @Test func stocktakeBecomesNewBaselineWithoutDeductingScoops() {
        let item = SoilStockItem(
            componentID: UUID(),
            bagSizeLiters: 14,
            bagCount: 6
        )
        let counted = item.applyingStocktake(actualVolumeLiters: 70)
        #expect(counted.lastActualVolumeLiters == 70)
        #expect(counted.estimatedVolumeLiters == 70)
        #expect(counted.stocktakes.count == 1)
        #expect(counted.stocktakes[0].differenceLiters == -14)
        #expect(counted.bagCount == 5)
        #expect(counted.openBagRemainingLiters == 0)
    }

    @Test func lowStockUsesTextNotOnlyQuantity() {
        let low = SoilStockItem(
            componentID: UUID(),
            bagSizeLiters: 20,
            bagCount: 1,
            minimumStockLiters: 40
        )
        #expect(low.isLowStock)
        #expect(low.stockStatusTitle == "Low")
        let ok = SoilStockItem(
            componentID: UUID(),
            bagSizeLiters: 14,
            bagCount: 6,
            minimumStockLiters: 28
        )
        #expect(!ok.isLowStock)
        #expect(ok.stockStatusTitle == "OK")
    }

    @Test func grainSizePresetsAreStructured() {
        var grain = SoilGrainSize(band: .from2to4mm)
        #expect(grain.displayTitle == "2–4 mm")
        #expect(grain.minimumMillimetres == 2)
        #expect(grain.maximumMillimetres == 4)
        grain.applyBand(.custom)
        grain.minimumMillimetres = 3
        grain.maximumMillimetres = 5
        #expect(grain.isValid)
        grain.maximumMillimetres = 1
        #expect(!grain.isValid)
    }
}

@MainActor
struct SoilStockServiceTests {
    @Test func mixCalculatorDoesNotChangeStock() throws {
        let componentID = UUID()
        let repo = PreviewSoilStockRepository(
            items: [
                SoilStockItem(componentID: componentID, bagSizeLiters: 14, bagCount: 3)
            ]
        )
        let service = SoilStockService(repository: repo)
        let before = service.availableVolumeLiters(forComponentID: componentID)
        #expect(before == 42)
        #expect(service.item(id: service.items[0].id)?.estimatedVolumeLiters == 42)
        #expect(before == service.availableVolumeLiters(forComponentID: componentID))
    }

    @Test func addItemRequiresCatalogTypeAndPositiveBagSize() {
        let service = SoilStockService(repository: PreviewSoilStockRepository())
        var draft = NewSoilStockDraft()
        draft.bagSizeLiters = 14
        draft.bagCount = 1
        #expect(throws: SoilStockValidationError.missingComponent) {
            try service.addItem(from: draft)
        }
        draft.componentID = UUID()
        draft.bagSizeLiters = 0
        #expect(throws: SoilStockValidationError.bagSizeMustBePositive) {
            try service.addItem(from: draft)
        }
    }
}

struct SoilKnowledgeTests {
    @Test func thirteenNumberedLessonsKeepNurserySoil() {
        #expect(SoilKnowledge.chapterTitle == "Soil & Substrate")
        #expect(SoilKnowledge.lessons.count == 13)
        #expect(SoilKnowledge.lessons.map(\.number) == Array(1...13))
        #expect(SoilKnowledge.lessons.map(\.title) == [
            "Overview",
            "Drainage, Retention & Air",
            "Particle Size",
            "Components",
            "Building a Mix",
            "Development & Refinement",
            "Species, Climate & Place",
            "Pot, Watering & Care",
            "Fertilizing & Roots",
            "Structure Over Time",
            "Practice",
            "Troubleshooting",
            "Quick Guides"
        ])
        #expect(SoilKnowledge.disclaimer.contains("not a recipe to copy"))
    }

    @Test func knowledgeDoesNotPrescribeAUniversalRecipe() {
        let blob = SoilKnowledge.lessons.flatMap { lesson in
            lesson.sections.flatMap { section in
                section.paragraphs + section.bullets + section.callouts.map(\.body)
            }
        }.joined(separator: " ")
        #expect(!blob.localizedCaseInsensitiveContains("Use 50% Akadama"))
        #expect(!blob.localizedCaseInsensitiveContains("small pot ="))
        #expect(blob.localizedCaseInsensitiveContains("limited total water reserve"))
        #expect(blob.localizedCaseInsensitiveContains("cool"))
        #expect(blob.localizedCaseInsensitiveContains("Nursery soil is not always bad"))
        #expect(blob.contains("Understand the function before choosing the ingredient"))
        #expect(blob.contains("The best soil for development may not be the best soil for refinement"))
        #expect(blob.contains("There is no perfect substrate outside of its environment"))
        #expect(!blob.localizedCaseInsensitiveContains("Use akadama, pumice and lava"))
    }

    @Test func searchFindsNurserySoilInStructureOverTime() {
        let hits = HandbookSearch.hits(matching: "nursery soil")
        #expect(!hits.isEmpty)
        #expect(hits.contains { $0.topic == .soil("structure-over-time") })
    }

    @Test func yamadoriIsAContextTagNotASpecies() {
        #expect(SoilMixContextTag.allCases.contains(.yamadori))
        #expect(SoilMixContextTag.yamadori.title == "Yamadori")
    }
}
