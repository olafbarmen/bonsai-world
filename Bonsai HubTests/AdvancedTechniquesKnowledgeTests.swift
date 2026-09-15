//
//  AdvancedTechniquesKnowledgeTests.swift
//  Bonsai World
//

import Testing
@testable import Bonsai_Hub

struct AdvancedTechniquesKnowledgeTests {
    @Test func thirteenNumberedLessons() {
        #expect(AdvancedTechniquesKnowledge.chapterTitle == "Advanced Techniques")
        #expect(AdvancedTechniquesKnowledge.lessons.count == 13)
        #expect(AdvancedTechniquesKnowledge.lessons.map(\.number) == Array(1...13))
        #expect(AdvancedTechniquesKnowledge.lessons.map(\.title) == [
            "Overview",
            "Readiness & Recovery",
            "Major Bending",
            "Sacrifice & Development Cycles",
            "Trunk Chops & Apex",
            "Grafting",
            "Hollowing",
            "Root Correction",
            "Combining & Sequencing",
            "Species & Climate",
            "When Not To Act",
            "Practice",
            "Quick Guides"
        ])
    }

    @Test func decisionLayerPointsToExistingChaptersWithoutProcedures() {
        let blob = AdvancedTechniquesKnowledge.lessons.flatMap { lesson in
            lesson.sections.flatMap { section in
                section.paragraphs + section.bullets + section.callouts.map(\.body)
            }
        }.joined(separator: " ")

        #expect(blob.contains("Advanced techniques are not shortcuts"))
        #expect(blob.contains("A healthy tree can recover from major work"))
        #expect(blob.contains("Temporary growth should have a permanent purpose"))
        #expect(blob.contains("Skill includes knowing when not to act"))
        #expect(blob.contains("Pruning — Development Pruning"))
        #expect(blob.contains("Wiring — Trunk & Heavy Bending"))
        #expect(blob.contains("This is a high-risk technique"))
        #expect(!blob.localizedCaseInsensitiveContains("step-by-step grafting"))
        #expect(!blob.localizedCaseInsensitiveContains("how to split a branch"))
    }

    @Test func searchFindsSacrificeExitStrategy() {
        let hits = HandbookSearch.hits(matching: "temporary growth should have a permanent purpose")
        #expect(!hits.isEmpty)
        #expect(hits.contains { $0.topic == .advancedTechniques("sacrifice") })
    }
}
