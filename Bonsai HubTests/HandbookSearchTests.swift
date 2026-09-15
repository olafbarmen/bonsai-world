//
//  HandbookSearchTests.swift
//  Bonsai World
//

import Testing
@testable import Bonsai_Hub

struct HandbookSearchTests {
    @Test func emptyQueryReturnsNoHits() {
        #expect(HandbookSearch.hits(matching: "").isEmpty)
        #expect(HandbookSearch.hits(matching: "   ").isEmpty)
    }

    @Test func pelletsRanksFertilizerTypesFirst() {
        let hits = HandbookSearch.hits(matching: "pellets")
        #expect(!hits.isEmpty)
        let top = hits[0]
        #expect(top.chapterTitle == "Fertilizing")
        #expect(top.numberedTitle == "03 — Fertilizer Types")
        #expect(top.topic == .fertilizing("fertilizer-types"))
    }

    @Test func titleMatchRanksAboveBodyMatch() throws {
        let types = HandbookSearch.catalog.first { $0.id == "fertilizing-fertilizer-types" }
        let overview = HandbookSearch.catalog.first { $0.id == "fertilizing-overview" }
        let typesScore = HandbookSearch.score(try #require(types), needle: "Organic")
        let overviewScore = HandbookSearch.score(try #require(overview), needle: "Organic")
        #expect(typesScore > overviewScore)
    }

    @Test func unknownWordReturnsNoHits() {
        #expect(HandbookSearch.hits(matching: "xyzzy-not-in-handbook").isEmpty)
    }

    @Test func catalogCoversEveryHandbookChapter() {
        let chapters = Set(HandbookSearch.catalog.map(\.topic.chapter))
        #expect(chapters == Set(BonsaiHandbookChapter.allCases))
    }
}
