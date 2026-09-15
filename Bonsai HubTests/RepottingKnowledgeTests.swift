//
//  RepottingKnowledgeTests.swift
//  Bonsai World
//

import Testing
@testable import Bonsai_Hub

struct RepottingKnowledgeTests {
    @Test func thirteenNumberedLessons() {
        #expect(RepottingKnowledge.chapterTitle == "Repotting")
        #expect(RepottingKnowledge.lessons.count == 13)
        #expect(RepottingKnowledge.lessons.map(\.number) == Array(1...13))
        #expect(RepottingKnowledge.lessons.map(\.title) == [
            "Overview",
            "The Root System",
            "When to Repot",
            "Development & Refinement",
            "Preparing",
            "Reading the Root System",
            "Root Work",
            "Soil & Pot",
            "Positioning & Securing",
            "Aftercare",
            "Species",
            "Practice",
            "Quick Guides"
        ])
        #expect(RepottingKnowledge.lesson(id: "aftercare")?.opensFertilizerGuides == true)
    }

    @Test func principlesAvoidUniversalCalendarsAndPointToFertilizerGuides() {
        let blob = RepottingKnowledge.lessons.flatMap { lesson in
            lesson.sections.flatMap { section in
                section.paragraphs + section.bullets + section.callouts.map(\.body)
            }
        }.joined(separator: " ")

        #expect(blob.contains("To understand the future of the tree, look below the surface"))
        #expect(blob.contains("Repot according to the tree's condition, not a universal calendar"))
        #expect(blob.contains("Remove roots with purpose"))
        #expect(blob.contains("Use the existing Bonsai World Fertilizer Guide"))
        #expect(!blob.contains("4–6 weeks"))
    }

    @Test func searchFindsNebariInRootWork() {
        let hits = HandbookSearch.hits(matching: "nebari")
        #expect(!hits.isEmpty)
        let rootWork = hits.first { $0.topic == .repotting("root-work") }
        #expect(rootWork != nil)
    }
}
