//
//  ToolsKnowledgeTests.swift
//  Bonsai World
//

import Testing
@testable import Bonsai_Hub

struct ToolsKnowledgeTests {
    @Test func thirteenNumberedLessons() {
        #expect(ToolsKnowledge.chapterTitle == "Tools & Equipment")
        #expect(ToolsKnowledge.lessons.count == 13)
        #expect(ToolsKnowledge.lessons.map(\.number) == Array(1...13))
        #expect(ToolsKnowledge.lessons.map(\.title) == [
            "Overview",
            "Cutting Tools",
            "Branch Cutters",
            "Wire Tools",
            "Root & Soil Tools",
            "Saws",
            "Deadwood & Carving",
            "Watering Equipment",
            "Quality & Fit",
            "Care & Safety",
            "Building a Kit",
            "Practice",
            "Quick Guides"
        ])
    }

    @Test func principlesPutFunctionBeforeBrand() {
        let blob = ToolsKnowledge.lessons.flatMap { lesson in
            lesson.sections.flatMap { section in
                section.paragraphs + section.bullets + section.callouts.map(\.body)
            }
        }.joined(separator: " ")

        #expect(blob.contains("Buy tools for the work you do, not for the image of the artist you want to be"))
        #expect(blob.contains("Do not use bonsai scissors to cut wire"))
        #expect(blob.contains("A simple tool can be the correct tool"))
        #expect(blob.contains("The faster the tool removes material, the more important control becomes"))
        #expect(blob.contains("Do not present expensive Japanese tools as automatically superior"))
        #expect(blob.contains("Automation can deliver water. Only observation can understand the tree"))
        #expect(!blob.localizedCaseInsensitiveContains("must buy Japanese"))
    }

    @Test func searchFindsWireCuttersInWireTools() {
        let hits = HandbookSearch.hits(matching: "do not use bonsai scissors to cut wire")
        #expect(!hits.isEmpty)
        #expect(hits.contains { $0.topic == .tools("wire") })
    }
}
