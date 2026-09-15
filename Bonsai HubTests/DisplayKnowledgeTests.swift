//
//  DisplayKnowledgeTests.swift
//  Bonsai World
//

import Testing
@testable import Bonsai_Hub

struct DisplayKnowledgeTests {
    @Test func thirteenNumberedLessons() {
        #expect(DisplayKnowledge.chapterTitle == "Display & Presentation")
        #expect(DisplayKnowledge.lessons.count == 13)
        #expect(DisplayKnowledge.lessons.map(\.number) == Array(1...13))
        #expect(DisplayKnowledge.lessons.map(\.title) == [
            "Overview",
            "Viewing the Tree",
            "Space & Hierarchy",
            "Pot, Stand & Character",
            "Traditional Display",
            "Supporting Elements",
            "Season",
            "Exhibition & Preparation",
            "Light & Photography",
            "Places",
            "Practice",
            "Troubleshooting",
            "Quick Guides"
        ])
    }

    @Test func principlesAvoidRigidDisplayFormulas() {
        let blob = DisplayKnowledge.lessons.flatMap { lesson in
            lesson.sections.flatMap { section in
                section.paragraphs + section.bullets + section.callouts.map(\.body)
            }
        }.joined(separator: " ")

        #expect(blob.contains("A bonsai display is not a collection of beautiful objects"))
        #expect(blob.contains("If the tree is strong enough, the display does not need to become complicated"))
        #expect(blob.contains("Space is part of the composition"))
        #expect(blob.contains("Every element should speak the same visual language"))
        #expect(blob.contains("not that every display must contain all three"))
        #expect(blob.localizedCaseInsensitiveContains("kusamono"))
        #expect(blob.localizedCaseInsensitiveContains("tokonoma"))
        #expect(!blob.localizedCaseInsensitiveContains("must always include a scroll"))
    }

    @Test func searchFindsKusamonoInSupportingElements() {
        let hits = HandbookSearch.hits(matching: "kusamono")
        #expect(!hits.isEmpty)
        #expect(hits.contains { $0.topic == .display("supporting") })
    }
}
