//
//  DeadwoodKnowledgeTests.swift
//  Bonsai World
//

import Testing
@testable import Bonsai_Hub

struct DeadwoodKnowledgeTests {
    @Test func thirteenNumberedLessons() {
        #expect(DeadwoodKnowledge.chapterTitle == "Deadwood")
        #expect(DeadwoodKnowledge.lessons.count == 13)
        #expect(DeadwoodKnowledge.lessons.map(\.number) == Array(1...13))
        #expect(DeadwoodKnowledge.lessons.map(\.title) == [
            "Overview",
            "Reading the Tree",
            "Jin",
            "Shari",
            "Uro",
            "Species & Health",
            "Design, Movement & Age",
            "Life, Death & Visual Language",
            "Carving, Texture & Scale",
            "Weathering & Preservation",
            "Display & When Not To",
            "Practice",
            "Quick Guides"
        ])
    }

    @Test func principlesWithoutCarvingManual() {
        let blob = DeadwoodKnowledge.lessons.flatMap { lesson in
            lesson.sections.flatMap { section in
                section.paragraphs + section.bullets + section.callouts.map(\.body)
            }
        }.joined(separator: " ")

        #expect(blob.contains("Deadwood should tell the story of the tree. It should not look like decoration added after the story was finished."))
        #expect(blob.contains("Deadwood is most convincing when it feels like a consequence of the tree's life."))
        #expect(blob.contains("The living tree comes before the deadwood design."))
        #expect(blob.contains("Carving should reveal character. Not demonstrate that carving was performed."))
        #expect(blob.contains("something happened to this tree"))
        #expect(blob.contains("Species Library"))
        #expect(blob.contains("Tree Health"))
        #expect(blob.contains("Design Guidelines"))
        #expect(blob.contains("Tools & Equipment"))
        #expect(!blob.localizedCaseInsensitiveContains("lime sulphur"))
        #expect(!blob.localizedCaseInsensitiveContains("lime sulfur"))
        #expect(!blob.localizedCaseInsensitiveContains("dremel"))
        #expect(!blob.localizedCaseInsensitiveContains("step-by-step"))
        #expect(!blob.localizedCaseInsensitiveContains("click"))
        #expect(!blob.localizedCaseInsensitiveContains("button"))
    }

    @Test func searchFindsDeadwoodStoryPrinciple() {
        let hits = HandbookSearch.hits(matching: "deadwood should tell the story of the tree")
        #expect(!hits.isEmpty)
        #expect(hits.contains { $0.topic == .deadwood("overview") })
    }
}
