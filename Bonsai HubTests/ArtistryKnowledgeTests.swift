//
//  ArtistryKnowledgeTests.swift
//  Bonsai World
//

import Testing
@testable import Bonsai_Hub

struct ArtistryKnowledgeTests {
    @Test func thirteenNumberedLessons() {
        #expect(ArtistryKnowledge.chapterTitle == "Bonsai Artistry & the Bonsai Eye")
        #expect(ArtistryKnowledge.lessons.count == 13)
        #expect(ArtistryKnowledge.lessons.map(\.number) == Array(1...13))
        #expect(ArtistryKnowledge.lessons.map(\.title) == [
            "Overview",
            "See the Tree, Not the Technique",
            "Proportion",
            "The Trunk",
            "Primary Structure",
            "Balance & Asymmetry",
            "Movement & Negative Space",
            "Simplicity & Character",
            "Naturalism & Design",
            "Developing the Eye",
            "Evaluating Your Tree",
            "Practice",
            "Quick Guides"
        ])
    }

    @Test func trainsTheEyeWithoutAcademicTheory() {
        let blob = ArtistryKnowledge.lessons.flatMap { lesson in
            lesson.sections.flatMap { section in
                section.paragraphs + section.bullets + section.callouts.map(\.body)
            }
        }.joined(separator: " ")

        #expect(blob.contains("Before you can improve a tree, you must learn to see the tree."))
        #expect(blob.contains("Technique creates possibilities. The eye decides which possibility is best."))
        #expect(blob.contains("Complexity is easy. Clarity is difficult."))
        #expect(blob.contains("Not every problem should be solved with a tool."))
        #expect(blob.contains("Design Guidelines — style, structure, front, trunk, branches and design principles."))
        #expect(blob.contains("Would doing nothing improve the result?"))
        #expect(blob.localizedCaseInsensitiveContains("wabi-sabi"))
        #expect(!blob.localizedCaseInsensitiveContains("tokonoma as a philosophical"))
        #expect(!blob.localizedCaseInsensitiveContains("academic art theory"))
        #expect(!blob.localizedCaseInsensitiveContains("historical period"))
    }

    @Test func searchFindsTheEyeDecides() {
        let hits = HandbookSearch.hits(matching: "the eye decides which possibility is best")
        #expect(!hits.isEmpty)
        #expect(hits.contains { $0.topic == .artistry("overview") })
    }
}
