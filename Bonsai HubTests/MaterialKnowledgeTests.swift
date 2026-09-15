//
//  MaterialKnowledgeTests.swift
//  Bonsai World
//

import Testing
@testable import Bonsai_Hub

struct MaterialKnowledgeTests {
    @Test func sixteenNumberedLessons() {
        #expect(MaterialKnowledge.chapterTitle == "Bonsai Material & Sourcing")
        #expect(MaterialKnowledge.lessons.count == 16)
        #expect(MaterialKnowledge.lessons.map(\.number) == Array(1...16))
        #expect(MaterialKnowledge.lessons.map(\.title) == [
            "Overview",
            "Evaluating Structure",
            "Health",
            "Nursery Stock",
            "Pre-Bonsai",
            "Seeds & Cuttings",
            "Air Layers & Garden Material",
            "Yamadori & Ethics",
            "Yamadori Recovery",
            "Reading Recovery & Time",
            "Early Development & Character",
            "Buying & Value",
            "Time & Planning",
            "Learning & Advanced Material",
            "Practice",
            "Quick Guides"
        ])
    }

    @Test func principlesBuyTheFutureAndSourceResponsibly() {
        let blob = MaterialKnowledge.lessons.flatMap { lesson in
            lesson.sections.flatMap { section in
                section.paragraphs + section.bullets + section.callouts.map(\.body)
            }
        }.joined(separator: " ")

        #expect(blob.contains("Buy the future you can see"))
        #expect(blob.contains("Do not buy the foliage. Buy the structure beneath it"))
        #expect(blob.contains("A bonsai should not be created by destroying the environment it came from"))
        #expect(blob.contains("Yamadori is not automatically superior"))
        #expect(blob.contains("This chapter does not provide a universal collection procedure"))
        #expect(blob.contains("Never collect from public land"))
        #expect(blob.contains("After collection, the first design decision is usually patience."))
        #expect(blob.contains("The tree determines the recovery timeline. The calendar does not."))
        #expect(blob.contains("A tree does not become ready because the artist becomes impatient."))
        #expect(!blob.localizedCaseInsensitiveContains("how to collect from public land"))
        #expect(!blob.localizedCaseInsensitiveContains("step-by-step collection"))
        #expect(!blob.localizedCaseInsensitiveContains("wait 12 months"))
        #expect(!blob.localizedCaseInsensitiveContains("wait two years"))
    }

    @Test func searchFindsYamadoriInEthics() {
        let hits = HandbookSearch.hits(matching: "yamadori is not automatically superior")
        #expect(!hits.isEmpty)
        #expect(hits.contains { $0.topic == .material("yamadori") })
    }

    @Test func searchFindsPatienceAfterCollection() {
        let hits = HandbookSearch.hits(matching: "after collection, the first design decision is usually patience")
        #expect(!hits.isEmpty)
        #expect(hits.contains { $0.topic == .material("yamadori-recovery") })
    }
}
