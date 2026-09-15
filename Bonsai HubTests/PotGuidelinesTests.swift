//
//  PotGuidelinesTests.swift
//  Bonsai World
//

import Testing
@testable import Bonsai_Hub

struct PotGuidelinesTests {
    @Test func thirteenNumberedLessons() {
        #expect(PotGuidelines.chapterTitle == "Pots & Containers")
        #expect(PotGuidelines.lessons.count == 13)
        #expect(PotGuidelines.lessons.map(\.number) == Array(1...13))
        #expect(PotGuidelines.lessons.map(\.title) == [
            "Overview",
            "Container Types",
            "Materials",
            "Shape",
            "Size & Depth",
            "Visual Weight",
            "Drainage",
            "Tree & Character",
            "Planting",
            "Species & Season",
            "Practice",
            "Troubleshooting",
            "Quick Guides"
        ])
    }

    @Test func keepsExistingGuidelinesWithoutFormulaWorship() {
        let blob = PotGuidelines.lessons.flatMap { lesson in
            lesson.sections.flatMap { section in
                section.paragraphs + section.bullets + section.callouts.map(\.body)
            }
        }.joined(separator: " ")

        #expect(blob.contains("two thirds of the tree's height"))
        #expect(blob.contains("slightly behind the centre line"))
        #expect(blob.contains("The long side of the pot generally establishes the viewing width"))
        #expect(blob.contains("The best pot is not necessarily the most beautiful pot on its own"))
        #expect(blob.localizedCaseInsensitiveContains("literati"))
        #expect(blob.contains("Do not restrict development for the sake of premature refinement"))
        #expect(blob.contains("Pot refinement should follow tree refinement"))
        #expect(blob.contains("Match visual weight, not only measurements"))
        #expect(!blob.localizedCaseInsensitiveContains("must always be exactly"))
        #expect(!blob.contains("Deciduous = glazed"))
        #expect(!blob.contains("Conifer = unglazed"))
    }

    @Test func searchFindsTwoThirdsInSizeAndDepth() {
        let hits = HandbookSearch.hits(matching: "two thirds")
        #expect(!hits.isEmpty)
        #expect(hits.contains { $0.topic == .pot("size-depth") })
    }
}
