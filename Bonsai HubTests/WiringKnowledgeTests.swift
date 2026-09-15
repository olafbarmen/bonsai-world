//
//  WiringKnowledgeTests.swift
//  Bonsai World
//

import Testing
@testable import Bonsai_Hub

struct WiringKnowledgeTests {
    @Test func twelveNumberedLessons() {
        #expect(WiringKnowledge.chapterTitle == "Wiring")
        #expect(WiringKnowledge.lessons.count == 12)
        #expect(WiringKnowledge.lessons.map(\.number) == Array(1...12))
        #expect(WiringKnowledge.lessons.map(\.title) == [
            "Overview",
            "Types of Wire",
            "Wire Thickness & Length",
            "Anchoring",
            "Applying Wire",
            "Positioning & Movement",
            "Trunk & Heavy Bending",
            "Species",
            "Timing & Removal",
            "Wiring and Pruning",
            "Practice",
            "Quick Guides"
        ])
    }

    @Test func principlesAvoidUniversalCalendarsAndForcing() {
        let blob = WiringKnowledge.lessons.flatMap { lesson in
            lesson.sections.flatMap { section in
                section.paragraphs + section.bullets + section.callouts.map(\.body)
            }
        }.joined(separator: " ")

        #expect(blob.contains("Wire is temporary. The movement it creates may become permanent"))
        #expect(blob.contains("Do not wire a branch simply because wire is available"))
        #expect(blob.contains("Do not create one universal wiring calendar"))
        #expect(blob.contains("Watch the tree, not the calendar"))
        #expect(blob.contains("Avoid unwinding wire from a branch"))
    }

    @Test func searchFindsGuyWiresInHeavyBending() {
        let hits = HandbookSearch.hits(matching: "guy wires")
        #expect(!hits.isEmpty)
        #expect(hits[0].chapterTitle == "Wiring")
        #expect(hits[0].topic == .wiring("trunk-heavy"))
    }
}
