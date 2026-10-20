//
//  CareCalendarKnowledgeTests.swift
//  Bonsai Hub
//

import Foundation
import Testing
@testable import Bonsai_Hub

struct CareCalendarKnowledgeTests {
    @Test func temperateNorthernAprilIsSpring() {
        let entries = CareCalendarKnowledge.entries(hemisphere: .northern, season: .temperate)
        let april = entries[3]
        #expect(april.title == "April")
        #expect(april.chapters.map(\.phase) == ["Spring"])
        #expect(april.continues == false)
    }

    @Test func southernJanuaryIsHighSummer() {
        let entries = CareCalendarKnowledge.entries(hemisphere: .southern, season: .temperate)
        let january = entries[0]
        #expect(january.chapters.map(\.phase) == ["High summer"])
    }

    @Test func southernJulyIsMidwinter() {
        #expect(CareCalendarKnowledge.northernEquivalent(localMonth: 7, hemisphere: .southern) == 1)
        let entries = CareCalendarKnowledge.entries(hemisphere: .southern, season: .temperate)
        #expect(entries[6].chapters.map(\.phase) == ["Midwinter"])
    }

    @Test func coldNorthernAprilReadsEarlySpring() {
        let entries = CareCalendarKnowledge.entries(hemisphere: .northern, season: .cold)
        #expect(entries[3].chapters.map(\.phase) == ["Early spring"])
        #expect(entries[2].continues == true)
        #expect(entries[2].subtitle == "Still Late winter")
    }

    @Test func mildNorthernFebruaryReadsEarlySpring() {
        let entries = CareCalendarKnowledge.entries(hemisphere: .northern, season: .mild)
        #expect(entries[1].chapters.map(\.phase) == ["Early spring"])
    }

    @Test func tropicalDropsTheDormancyYear() {
        let entries = CareCalendarKnowledge.entries(hemisphere: .southern, season: .tropical)
        #expect(entries.map(\.title) == [
            "Growing strongly",
            "Hot or dry pause",
            "New flush",
            "Cool nights"
        ])
    }

    @Test func unsetGardenShowsTemperateNorth() {
        let line = CareCalendarKnowledge.contextLine(gardenName: nil, hemisphere: nil, season: nil)
        #expect(line.contains("northern temperate"))
        let entries = CareCalendarKnowledge.entries(hemisphere: nil, season: nil)
        #expect(entries[0].chapters.map(\.phase) == ["Midwinter"])
    }

    @Test func octoberTwentiethReadsAutumn() {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        let date = calendar.date(from: DateComponents(year: 2026, month: 10, day: 20))!
        let entry = CareCalendarKnowledge.entry(
            on: date,
            hemisphere: .northern,
            season: .temperate,
            calendar: calendar
        )
        #expect(entry?.subtitle == "Autumn")
        #expect(entry?.chapters.first?.tasks.map(\.title).count == 7)
        #expect(
            CareCalendarKnowledge.entry(
                on: date,
                hemisphere: .northern,
                season: .tropical,
                calendar: calendar
            ) == nil
        )
    }

    @Test func temperateOctoberOpensWithTheSevenTaskLines() {
        let entries = CareCalendarKnowledge.entries(hemisphere: .northern, season: .temperate)
        let october = entries[9]
        #expect(october.chapters.map(\.phase) == ["Autumn"])
        #expect(october.chapters[0].tasks.map(\.title) == [
            "All trees",
            "Deciduous",
            "Pine",
            "Juniper",
            "Flowering",
            "Indoor",
            "Fertilizing"
        ])
        #expect(october.chapters[0].tasks[6].line.contains("None for deciduous"))
    }
}
