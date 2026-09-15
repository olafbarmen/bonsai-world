//
//  FertilizerGuidesTests.swift
//  Bonsai World
//

import Testing
@testable import Bonsai_Hub

struct FertilizerGuidesTests {

    @Test func openingAndBottomLineRemain() {
        #expect(FertilizerGuides.chapterTitle == "Fertilizing")
        #expect(FertilizerGuides.openingLine.contains("not simply the month on the calendar"))
        #expect(FertilizerGuides.bottomLine.contains("Development needs growth"))
    }

    @Test func glanceUsesThreeStagesAndStopsInWinter() {
        #expect(FertilizerGuides.glanceColumnHeaders == [
            "Development",
            "Establishment & Recovery",
            "Refinement"
        ])
        let winter = FertilizerGuides.glanceRows.first { $0.leading == "Winter" }
        #expect(winter?.cells == ["Stop", "Stop", "Stop"])
        let interval = FertilizerGuides.glanceRows.first { $0.leading == "Solid fertilizer interval" }
        #expect(interval?.cells == ["4–6 weeks", "4–6 weeks", "4–6 weeks"])
    }

    @Test func speciesGuideIsAStartingPoint() {
        #expect(FertilizerGuides.startingPointsNote.contains("starting points"))
        let pine = FertilizerGuides.speciesRows.first { $0.leading == "Pine – Single Flush" }
        #expect(pine?.cells.first == "Moderate–higher")
        #expect(pine?.cells.last == "Candles & needle length")
        let maple = FertilizerGuides.speciesRows.first { $0.leading == "Japanese Maple" }
        #expect(maple?.cells.first == "Higher")
    }

    @Test func inDepthKeepsTheCloserRead() {
        #expect(FertilizerGuides.inDepthTitle == "In depth")
        #expect(FertilizerGuides.inDepthStages.count == 3)
        #expect(FertilizerGuides.inDepthStartSigns.contains("Candles are extending"))
        #expect(FertilizerGuides.inDepthSpecies.contains { $0.title == "Pines" })
        #expect(FertilizerGuides.inDepthMistakes.count == 5)
    }

    @Test func copyContainsNoDecorativeEmoji() {
        var strings = [
            FertilizerGuides.openingLine,
            FertilizerGuides.lookAtTheTree,
            FertilizerGuides.startingPointsNote
        ]
        strings.append(contentsOf: FertilizerGuides.stageIntents.map(\.stage))
        strings.append(contentsOf: FertilizerGuides.stageIntents.map(\.action))
        strings.append(contentsOf: FertilizerGuides.glanceColumnHeaders)
        for row in FertilizerGuides.glanceRows {
            strings.append(row.leading)
            strings.append(contentsOf: row.cells)
        }
        for row in FertilizerGuides.whenToFeedRows {
            strings.append(row.leading)
            strings.append(contentsOf: row.cells)
        }
        for row in FertilizerGuides.speciesRows {
            strings.append(row.leading)
            strings.append(contentsOf: row.cells)
        }
        strings.append(contentsOf: FertilizerGuides.pineSingleFlush)
        strings.append(contentsOf: FertilizerGuides.pineDoubleFlush)
        for row in FertilizerGuides.choosingRows {
            strings.append(row.leading)
            strings.append(contentsOf: row.cells)
        }

        let rejected = ["🌱", "🌳", "✂️", "🌿", "🍃", "🍂", "❄️"]
        for string in strings {
            for mark in rejected {
                #expect(!string.contains(mark))
            }
        }
    }
}
