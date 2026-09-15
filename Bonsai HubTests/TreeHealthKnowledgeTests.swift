//
//  TreeHealthKnowledgeTests.swift
//  Bonsai World
//

import Testing
@testable import Bonsai_Hub

struct TreeHealthKnowledgeTests {
    @Test func thirteenNumberedLessons() {
        #expect(TreeHealthKnowledge.chapterTitle == "Tree Health")
        #expect(TreeHealthKnowledge.lessons.count == 13)
        #expect(TreeHealthKnowledge.lessons.map(\.number) == Array(1...13))
        #expect(TreeHealthKnowledge.lessons.map(\.title) == [
            "Overview",
            "Early Warning Signs",
            "Diagnostic Framework",
            "Water-Related Problems",
            "Root Health",
            "Environmental Stress",
            "Nutrient-Related Problems",
            "Pests",
            "Diseases & Visible Symptoms",
            "Stress After Work",
            "Prevention, Quarantine & Response",
            "Practice",
            "Quick Guides"
        ])
    }

    @Test func observationBeforeTreatmentWithoutPathologyManual() {
        let blob = TreeHealthKnowledge.lessons.flatMap { lesson in
            lesson.sections.flatMap { section in
                section.paragraphs + section.bullets + section.callouts.map(\.body)
            }
        }.joined(separator: " ")

        #expect(blob.contains("Do not treat a symptom before trying to understand the cause."))
        #expect(blob.contains("Yellow leaves do not automatically mean nutrient deficiency."))
        #expect(blob.contains("Do not disturb the roots to satisfy curiosity."))
        #expect(blob.contains("Care → Health"))
        #expect(blob.contains("Thriving, Stable, Needs Attention and Recovering"))
        #expect(blob.contains("This chapter does not prescribe treatments."))
        #expect(!blob.localizedCaseInsensitiveContains("imidacloprid"))
        #expect(!blob.localizedCaseInsensitiveContains("spray every"))
        #expect(!blob.localizedCaseInsensitiveContains("botrytis cinerea"))
        #expect(!blob.localizedCaseInsensitiveContains("ml per litre"))
    }

    @Test func searchFindsDoNotTreatASymptom() {
        let hits = HandbookSearch.hits(matching: "do not treat a symptom before trying to understand the cause")
        #expect(!hits.isEmpty)
        #expect(hits.contains { $0.topic == .treeHealth("overview") })
    }
}
