//
//  WateringKnowledgeTests.swift
//  Bonsai World
//

import Testing
@testable import Bonsai_Hub

struct WateringKnowledgeTests {
    @Test func thirteenNumberedLessons() {
        #expect(WateringKnowledge.chapterTitle == "Watering")
        #expect(WateringKnowledge.lessons.count == 13)
        #expect(WateringKnowledge.lessons.map(\.number) == Array(1...13))
        #expect(WateringKnowledge.lessons.map(\.title) == [
            "Overview",
            "When to Water",
            "How to Water",
            "Soil, Pot & Roots",
            "Tree Health",
            "Seasons",
            "Weather",
            "Water Quality",
            "Stage & Repotting",
            "Species",
            "Collection Practice",
            "Practice",
            "Quick Guides"
        ])
    }

    @Test func principlesAvoidFixedSchedules() {
        let blob = WateringKnowledge.lessons.flatMap { lesson in
            lesson.sections.flatMap { section in
                section.paragraphs + section.bullets + section.callouts.map(\.body)
            }
        }.joined(separator: " ")

        #expect(blob.contains("Do not water the calendar. Water the tree."))
        #expect(blob.contains("Healthy watering begins with a healthy root environment"))
        #expect(blob.contains("Symptoms must be understood before they are treated"))
        #expect(blob.contains("Do not turn watering twice into a universal rule"))
        #expect(!blob.contains("Water every day"))
        #expect(!blob.contains("Water twice a week"))
    }

    @Test func searchFindsWindInWeather() {
        let hits = HandbookSearch.hits(matching: "strong wind")
        #expect(!hits.isEmpty)
        #expect(hits.contains { $0.topic == .watering("weather") })
    }
}
