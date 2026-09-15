//
//  CollectionManagementKnowledgeTests.swift
//  Bonsai World
//

import Testing
@testable import Bonsai_Hub

struct CollectionManagementKnowledgeTests {
    @Test func thirteenNumberedLessons() {
        #expect(CollectionManagementKnowledge.chapterTitle == "Bonsai Collection Management")
        #expect(CollectionManagementKnowledge.lessons.count == 13)
        #expect(CollectionManagementKnowledge.lessons.map(\.number) == Array(1...13))
        #expect(CollectionManagementKnowledge.lessons.map(\.title) == [
            "Overview",
            "Knowing What You Have",
            "Tree Profile & History",
            "From Memory to Information",
            "Tasks & Priorities",
            "Development Stages",
            "Collection Overview",
            "Seasonal Planning",
            "Collection Health",
            "Observation & Size",
            "Records, Photographs & Context",
            "Practice",
            "Quick Guides"
        ])
    }

    @Test func principlesWithoutSoftwareManual() {
        let blob = CollectionManagementKnowledge.lessons.flatMap { lesson in
            lesson.sections.flatMap { section in
                section.paragraphs + section.bullets + section.callouts.map(\.body)
            }
        }.joined(separator: " ")

        #expect(blob.contains("The collection must be organised. But the individual tree must never disappear."))
        #expect(blob.contains("A collection is not just a group of trees."))
        #expect(blob.contains("A reminder should encourage you to look. Not force you to act."))
        #expect(blob.contains("Today’s tree is the result of its previous years."))
        #expect(blob.contains("Bonsai World exists to help connect the tree, the knowledge, the history and the next step."))
        #expect(blob.contains("Species Library"))
        #expect(blob.contains("Tree Health"))
        #expect(blob.contains("Seasonal Care & Protection"))
        #expect(!blob.contains("Garden →"))
        #expect(!blob.contains("Dashboard"))
        #expect(!blob.contains("click"))
        #expect(!blob.localizedCaseInsensitiveContains("button"))
        #expect(!blob.contains("It is not built in this chapter."))
    }

    @Test func searchFindsIndividualMustNeverDisappear() {
        let hits = HandbookSearch.hits(matching: "the individual tree must never disappear")
        #expect(!hits.isEmpty)
        #expect(hits.contains { $0.topic == .collectionManagement("overview") })
    }
}
