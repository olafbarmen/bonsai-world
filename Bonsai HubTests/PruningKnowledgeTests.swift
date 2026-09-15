//
//  PruningKnowledgeTests.swift
//  Bonsai World
//

import Testing
@testable import Bonsai_Hub

struct PruningKnowledgeTests {
    @Test func sixteenNumberedLessons() {
        #expect(PruningKnowledge.chapterTitle == "Pruning")
        #expect(PruningKnowledge.lessons.count == 16)
        #expect(PruningKnowledge.lessons.map(\.number) == Array(1...16))
        #expect(PruningKnowledge.lessons.map(\.title) == [
            "Overview",
            "Types of Pruning",
            "Structural Pruning",
            "Development Pruning",
            "Refinement Pruning",
            "Directional Pruning",
            "Branch Removal & Problems",
            "Vigor & Balance",
            "Species",
            "Timing",
            "Wiring & Wounds",
            "Leaf Reduction",
            "Defoliation",
            "Conifer and Pine Growth Management",
            "Practice",
            "Quick Guides"
        ])
    }

    @Test func principlesAvoidUniversalCalendarsAndTwoLeafRules() {
        let blob = PruningKnowledge.lessons.flatMap { lesson in
            lesson.sections.flatMap { section in
                section.paragraphs + section.bullets + section.callouts.map(\.body)
            }
        }.joined(separator: " ")

        #expect(blob.contains("Before making a cut, understand what the tree will do next"))
        #expect(blob.contains("Uncertainty is a reason to wait"))
        #expect(blob.contains("Development often requires allowing the tree to become untidy"))
        #expect(blob.contains("Know where your species can grow again"))
        #expect(blob.contains("Do not create a single universal bonsai pruning calendar"))
        #expect(blob.contains("cut everything back to two leaves"))
        #expect(blob.contains("Pruning techniques manage growth. They do not replace understanding the tree."))
        #expect(blob.contains("Small leaves are often the result of development. They are not simply created by cutting large leaves."))
        #expect(blob.contains("Defoliation is a tool. It is not a stage every bonsai must pass through."))
        #expect(blob.contains("Never apply a technique simply because it is described as a pine technique."))
        #expect(blob.contains("Species Library"))
        #expect(!blob.localizedCaseInsensitiveContains("japanese black pine technique"))
        #expect(!blob.contains("defoliate every"))
    }

    @Test func searchFindsClipAndGrowInDevelopment() {
        let hits = HandbookSearch.hits(matching: "clip and grow")
        #expect(!hits.isEmpty)
        #expect(hits[0].chapterTitle == "Pruning")
        #expect(hits[0].topic == .pruning("development"))
    }

    @Test func searchFindsDefoliationIsATool() {
        let hits = HandbookSearch.hits(matching: "defoliation is a tool")
        #expect(!hits.isEmpty)
        #expect(hits.contains { $0.topic == .pruning("defoliation") })
    }
}
