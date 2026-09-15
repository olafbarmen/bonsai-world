//
//  FertilizingKnowledgeTests.swift
//  Bonsai World
//

import Testing
@testable import Bonsai_Hub

struct FertilizingKnowledgeTests {
    @Test func nineNumberedLessonsKeepThePracticalGuide() {
        #expect(FertilizingKnowledge.chapterTitle == "Fertilizing")
        #expect(FertilizingKnowledge.lessons.count == 9)
        #expect(FertilizingKnowledge.lessons.map(\.number) == Array(1...9))
        #expect(FertilizingKnowledge.lessons.map(\.title) == [
            "Overview",
            "Practical Guide",
            "Fertilizer Types",
            "Bonsai Strategy",
            "Seasonal Feeding",
            "Tree Health",
            "Advanced",
            "Troubleshooting",
            "Quick Guides"
        ])

        let practical = FertilizingKnowledge.lesson(id: "practical-guide")
        #expect(practical?.opensFertilizerGuides == true)
        #expect(practical?.sections.contains { $0.heading == "Bonsai World Fertilizer Guide" } == true)
    }

    @Test func handbookChapterSitsBesideSoilAndDoesNotReplaceFertilizerGuides() {
        #expect(BonsaiHandbookChapter.allCases.map(\.title) == [
            "Design Guidelines",
            "Bonsai Forms, Styles & Silhouette",
            "Bonsai Artistry & the Bonsai Eye",
            "Bonsai Material & Sourcing",
            "Pruning",
            "Wiring",
            "Repotting",
            "Watering",
            "Pots & Containers",
            "Air Pruning & Air Pots",
            "Display & Presentation",
            "Soil & Substrate",
            "Fertilizing",
            "Propagation",
            "Air Layering",
            "Tools & Equipment",
            "Deadwood",
            "Advanced Techniques",
            "Bonsai Collection Management",
            "Tree Health",
            "Seasonal Care & Protection"
        ])
        #expect(FertilizerGuides.chapterTitle == "Fertilizing")
        #expect(FertilizerGuides.glanceColumnHeaders == [
            "Development",
            "Establishment & Recovery",
            "Refinement"
        ])
    }

    @Test func principlesAvoidUniversalRecipesAndPointToTheExistingGuide() {
        let blob = FertilizingKnowledge.lessons.flatMap { lesson in
            lesson.sections.flatMap { section in
                section.paragraphs + section.bullets + section.callouts.map(\.body)
            }
        }.joined(separator: " ")

        #expect(blob.contains("Do not fertilize according to the calendar alone"))
        #expect(blob.contains("Fertilizer supports healthy growth"))
        #expect(blob.contains("Open the existing Bonsai World Fertilizer Guide"))
        #expect(blob.contains("Diagnose before correcting"))
        #expect(!blob.contains("4–6 weeks"))
        #expect(!blob.contains("Stop well before dormancy"))
    }
}
