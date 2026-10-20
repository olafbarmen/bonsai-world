//
//  SpeciesCareCalendarTests.swift
//  Bonsai Hub
//

import Foundation
import Testing
@testable import Bonsai_Hub

struct SpeciesCareCalendarTests {
    private let calendar: Calendar = {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(secondsFromGMT: 0)!
        return calendar
    }()

    @Test func temperatePineOpensAWeekBeforeLateSpring() {
        let window = requireWindow(.pineCandlePinch, .northern, .temperate, 2026)
        #expect(window.alert == day(2026, 4, 24))
        #expect(window.close == day(2026, 6, 30))
    }

    @Test func temperateMapleOpensAWeekBeforeSpring() {
        let window = requireWindow(.mapleShootPinch, .northern, .temperate, 2026)
        #expect(window.alert == day(2026, 3, 25))
        #expect(window.close == day(2026, 6, 30))
    }

    @Test func coldPineWaitsUntilJune() {
        let window = requireWindow(.pineCandlePinch, .northern, .cold, 2026)
        #expect(window.alert == day(2026, 5, 25))
        #expect(window.close == day(2026, 7, 31))
    }

    @Test func mildPineComesForwardToApril() {
        let window = requireWindow(.pineCandlePinch, .northern, .mild, 2026)
        #expect(window.alert == day(2026, 3, 25))
        #expect(window.close == day(2026, 5, 31))
    }

    @Test func southernTemperatePineIsNovember() {
        let window = requireWindow(.pineCandlePinch, .southern, .temperate, 2026)
        #expect(window.alert == day(2026, 10, 25))
        #expect(window.close == day(2026, 12, 31))
    }

    @Test func tropicalHasNoWindow() {
        let window = SpeciesCareCalendar.window(
            job: .pineCandlePinch,
            hemisphere: .northern,
            season: .tropical,
            year: 2026,
            calendar: calendar
        )
        #expect(window == nil)
    }

    @Test func speciesLinkDecidesTheJob() {
        #expect(SpeciesCareJob.job(speciesID: BotanicalKnowledgeIDs.pinusSylvestris, botanicalName: "") == .pineCandlePinch)
        #expect(SpeciesCareJob.job(speciesID: BotanicalKnowledgeIDs.pinusMugo, botanicalName: "") == .pineCandlePinch)
        #expect(SpeciesCareJob.job(speciesID: BotanicalKnowledgeIDs.pinusParviflora, botanicalName: "") == .pineCandlePinch)
        #expect(SpeciesCareJob.job(speciesID: BotanicalKnowledgeIDs.pinusThunbergii, botanicalName: "Pinus sylvestris") == nil)
        #expect(SpeciesCareJob.job(speciesID: BotanicalKnowledgeIDs.acerPalmatum, botanicalName: "") == .mapleShootPinch)
        #expect(SpeciesCareJob.job(speciesID: BotanicalKnowledgeIDs.acerBuergerianum, botanicalName: "Acer palmatum") == nil)
        #expect(SpeciesCareJob.job(speciesID: nil, botanicalName: "Pinus sylvestris 'Watereri'") == .pineCandlePinch)
        #expect(SpeciesCareJob.job(speciesID: nil, botanicalName: "Acer palmatum") == .mapleShootPinch)
        #expect(SpeciesCareJob.job(speciesID: nil, botanicalName: "Pinus") == nil)
        #expect(SpeciesCareJob.job(speciesID: nil, botanicalName: "Pinus thunbergii") == nil)
        #expect(SpeciesCareJob.job(speciesID: BotanicalKnowledgeIDs.juniperusChinensis, botanicalName: "") == .juniperRunnerCut)
        #expect(SpeciesCareJob.job(speciesID: nil, cultivarID: BotanicalKnowledgeIDs.juniperusChinensisItoigawa, botanicalName: "") == .juniperRunnerCut)
        #expect(SpeciesCareJob.job(speciesID: nil, botanicalName: "Juniperus chinensis 'Shimpaku'") == .juniperRunnerCut)
    }

    @Test func temperateJuniperRunsFromSpringThroughLateSummer() {
        let window = requireWindow(.juniperRunnerCut, .northern, .temperate, 2026)
        #expect(window.alert == day(2026, 3, 25))
        #expect(window.close == day(2026, 8, 31))
    }

    @Test func southernJuniperCrossesTheYear() {
        let window = requireWindow(.juniperRunnerCut, .southern, .temperate, 2026)
        #expect(window.alert == day(2026, 9, 24))
        #expect(window.close == day(2027, 2, 28))
        let january = SpeciesCareCalendar.activeWindow(
            job: .juniperRunnerCut,
            on: day(2026, 1, 15),
            hemisphere: .southern,
            season: .temperate,
            calendar: calendar
        )
        #expect(january?.alert == day(2025, 9, 24))
        #expect(january?.close == day(2026, 2, 28))
    }

    @Test func alertDayCreatesATaskDueThatDay() {
        let window = requireWindow(.pineCandlePinch, .northern, .temperate, 2026)
        let action = SpeciesCareCalendar.action(
            now: day(2026, 4, 24),
            window: window,
            pendingDue: nil,
            covered: false,
            calendar: calendar
        )
        #expect(action == .create(due: day(2026, 4, 24)))
    }

    @Test func aDayBeforeTheAlertDoesNothing() {
        let window = requireWindow(.pineCandlePinch, .northern, .temperate, 2026)
        let action = SpeciesCareCalendar.action(
            now: day(2026, 4, 23),
            window: window,
            pendingDue: nil,
            covered: false,
            calendar: calendar
        )
        #expect(action == .none)
    }

    @Test func afterTheWindowAPendingTaskIsRetired() {
        let window = requireWindow(.pineCandlePinch, .northern, .temperate, 2026)
        let action = SpeciesCareCalendar.action(
            now: day(2026, 7, 1),
            window: window,
            pendingDue: day(2026, 5, 1),
            covered: true,
            calendar: calendar
        )
        #expect(action == .retire)
    }

    @Test func aPostponePastTheWindowIsKept() {
        let window = requireWindow(.pineCandlePinch, .northern, .temperate, 2026)
        let action = SpeciesCareCalendar.action(
            now: day(2026, 7, 1),
            window: window,
            pendingDue: day(2026, 7, 12),
            covered: true,
            calendar: calendar
        )
        #expect(action == .none)
    }

    @Test func postponeAddsDaysOrWeeksFromTheLaterDate() {
        let early = TaskPostpone.date(
            from: day(2026, 5, 1),
            now: day(2026, 4, 24),
            count: 3,
            unit: .weeks,
            calendar: calendar
        )
        #expect(early == day(2026, 5, 22))

        let overdue = TaskPostpone.date(
            from: day(2026, 4, 1),
            now: day(2026, 4, 24),
            count: 2,
            unit: .days,
            calendar: calendar
        )
        #expect(overdue == day(2026, 4, 26))

        let clamped = TaskPostpone.date(
            from: day(2026, 5, 1),
            now: day(2026, 4, 1),
            count: 9,
            unit: .days,
            calendar: calendar
        )
        #expect(clamped == day(2026, 5, 8))
    }

    private func requireWindow(
        _ job: SpeciesCareJob,
        _ hemisphere: GardenHemisphere,
        _ season: GardenSeason,
        _ year: Int
    ) -> SpeciesCareWindow {
        let value = SpeciesCareCalendar.window(
            job: job,
            hemisphere: hemisphere,
            season: season,
            year: year,
            calendar: calendar
        )
        precondition(value != nil)
        return value!
    }

    private func day(_ year: Int, _ month: Int, _ day: Int) -> Date {
        calendar.date(from: DateComponents(year: year, month: month, day: day))!
    }
}
