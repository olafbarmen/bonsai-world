//
//  FormsStylesKnowledgeTests.swift
//  Bonsai World
//

import Testing
@testable import Bonsai_Hub

struct FormsStylesKnowledgeTests {
    @Test func thirteenNumberedLessons() {
        #expect(FormsStylesKnowledge.chapterTitle == "Bonsai Forms, Styles & Silhouette")
        #expect(FormsStylesKnowledge.lessons.count == 13)
        #expect(FormsStylesKnowledge.lessons.map(\.number) == Array(1...13))
        #expect(FormsStylesKnowledge.lessons.map(\.title) == [
            "Overview",
            "Triangle, Base, Body & Apex",
            "Asymmetry & Movement",
            "Silhouette",
            "Foliage Masses & Pads",
            "Depth & Layering",
            "Negative Space",
            "Visual Weight, Crown & Apex",
            "Upright & Slanting",
            "Cascade, Semi-Cascade & Literati",
            "Groups, Landscape & Material",
            "Practice",
            "Quick Guides"
        ])
    }

    @Test func principlesWithoutStyleCatalogue() {
        let blob = FormsStylesKnowledge.lessons.flatMap { lesson in
            lesson.sections.flatMap { section in
                section.paragraphs + section.bullets + section.callouts.map(\.body)
            }
        }.joined(separator: " ")

        #expect(blob.contains("Styles provide a language for understanding bonsai. The tree itself should remain the starting point."))
        #expect(blob.contains("Do not only study the branches. Study the shape they create together."))
        #expect(blob.contains("Use the triangle to understand balance. Do not force the tree to become geometry."))
        #expect(blob.contains("Do not build a beautiful picture. Build a tree."))
        #expect(blob.contains("what is this tree capable of becoming?"))
        #expect(blob.contains("Bonsai Artistry & the Bonsai Eye"))
        #expect(blob.contains("Design Guidelines"))
        #expect(blob.contains("Deadwood"))
        #expect(blob.contains("Pots & Containers"))
        #expect(blob.contains("Display & Presentation"))
        #expect(!blob.localizedCaseInsensitiveContains("chokkan"))
        #expect(!blob.localizedCaseInsensitiveContains("moyogi"))
        #expect(!blob.localizedCaseInsensitiveContains("click"))
        #expect(!blob.localizedCaseInsensitiveContains("button"))
    }

    @Test func searchFindsStylesProvideALanguage() {
        let hits = HandbookSearch.hits(matching: "styles provide a language for understanding bonsai")
        #expect(!hits.isEmpty)
        #expect(hits.contains { $0.topic == .formsStyles("overview") })
    }
}
