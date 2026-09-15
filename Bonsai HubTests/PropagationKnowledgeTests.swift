//
//  PropagationKnowledgeTests.swift
//  Bonsai World
//

import Testing
@testable import Bonsai_Hub

struct PropagationKnowledgeTests {
    @Test func thirteenNumberedLessons() {
        #expect(PropagationKnowledge.chapterTitle == "Propagation")
        #expect(PropagationKnowledge.lessons.count == 13)
        #expect(PropagationKnowledge.lessons.map(\.number) == Array(1...13))
        #expect(PropagationKnowledge.lessons.map(\.title) == [
            "Overview",
            "Main Methods",
            "Species",
            "Seeds & Quality",
            "Stratification & Germination",
            "Seedling Care & Development",
            "Seedling Selection",
            "Cuttings",
            "Cutting Types",
            "Material, Rooting & Aftercare",
            "Transition & Intention",
            "Practice",
            "Quick Guides"
        ])
    }

    @Test func methodsWithoutAirLayerOrGraftingRecipes() {
        let blob = PropagationKnowledge.lessons.flatMap { lesson in
            lesson.sections.flatMap { section in
                section.paragraphs + section.bullets + section.callouts.map(\.body)
            }
        }.joined(separator: " ")

        #expect(blob.contains("Propagation creates possibilities. Time creates bonsai."))
        #expect(blob.contains("Do not try to make a bonsai before you have grown a tree."))
        #expect(blob.contains("A rooting aid can support a good process. It cannot rescue a bad one."))
        #expect(blob.contains("Air Layering is a related method with its own chapter"))
        #expect(blob.contains("Advanced grafting belongs in Advanced Techniques"))
        #expect(blob.contains("Nursery → Seeds"))
        #expect(blob.contains("Seed Stratification"))
        #expect(!blob.localizedCaseInsensitiveContains("sow at 4°c for 90 days"))
        #expect(!blob.localizedCaseInsensitiveContains("iba 3000"))
        #expect(!blob.localizedCaseInsensitiveContains("how to complete a ring"))
        #expect(!blob.localizedCaseInsensitiveContains("step-by-step grafting"))
    }

    @Test func searchFindsTimeCreatesBonsai() {
        let hits = HandbookSearch.hits(matching: "time creates bonsai")
        #expect(!hits.isEmpty)
        #expect(hits.contains { $0.topic == .propagation("overview") })
    }
}
