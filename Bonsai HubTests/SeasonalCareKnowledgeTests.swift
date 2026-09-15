//
//  SeasonalCareKnowledgeTests.swift
//  Bonsai World
//

import Testing
@testable import Bonsai_Hub

struct SeasonalCareKnowledgeTests {
    @Test func thirteenNumberedLessons() {
        #expect(SeasonalCareKnowledge.chapterTitle == "Seasonal Care & Protection")
        #expect(SeasonalCareKnowledge.lessons.count == 13)
        #expect(SeasonalCareKnowledge.lessons.map(\.number) == Array(1...13))
        #expect(SeasonalCareKnowledge.lessons.map(\.title) == [
            "Overview",
            "Climate",
            "Spring",
            "Summer",
            "Autumn",
            "Winter Preparation",
            "Winter Watering & Frost",
            "Weather Events",
            "Placement & Recovery",
            "Collection Planning",
            "Dates Are Not Nature",
            "Practice",
            "Quick Guides"
        ])
    }

    @Test func calendarIsAGuideWithoutFixedDates() {
        let blob = SeasonalCareKnowledge.lessons.flatMap { lesson in
            lesson.sections.flatMap { section in
                section.paragraphs + section.bullets + section.callouts.map(\.body)
            }
        }.joined(separator: " ")

        #expect(blob.contains("The calendar is a guide. The tree and the conditions determine the right moment."))
        #expect(blob.contains("Water the tree and the conditions. Not the clock."))
        #expect(blob.contains("Dormancy is not failure"))
        #expect(blob.contains("Care → Seasonal Care"))
        #expect(blob.contains("Care → Winter Care"))
        #expect(blob.contains("repot in March"))
        #expect(!blob.contains("Repot all trees in March"))
        #expect(!blob.contains("Water every morning at 08:00"))
        #expect(!blob.contains("Fertilize in week 12"))
    }

    @Test func searchFindsCalendarIsAGuide() {
        let hits = HandbookSearch.hits(matching: "the calendar is a guide")
        #expect(!hits.isEmpty)
        #expect(hits.contains { $0.topic == .seasonalCare("overview") })
    }
}
