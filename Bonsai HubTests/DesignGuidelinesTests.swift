//
//  DesignGuidelinesTests.swift
//  Bonsai World
//

import Testing
@testable import Bonsai_Hub

struct DesignGuidelinesTests {

    @Test func everySectionHasAnEntry() {
        let covered = Set(DesignGuidelines.entries.map(\.section))
        #expect(covered == Set(DesignGuidelineSection.allCases))
        #expect(DesignGuidelines.entries.count == DesignGuidelineSection.allCases.count)
    }

    @Test func entriesAreNonEmpty() {
        #expect(!DesignGuidelines.chapterTitle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        #expect(!DesignGuidelines.introduction.isEmpty)

        for entry in DesignGuidelines.entries {
            #expect(!entry.excerpt.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            #expect(!entry.paragraphs.isEmpty)
            #expect(!entry.onTheTree.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            #expect(!entry.section.title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
        }
    }

    @Test func everyShapingAreaMapsToAGuideline() {
        for area in ShapingAreaID.allCases {
            let section = DesignGuidelines.section(for: area)
            let excerpt = DesignGuidelines.excerpt(for: area)
            #expect(!excerpt.isEmpty)
            #expect(DesignGuidelines.entry(for: section).section == section)
        }
    }

    @Test func relatedAreasShareASection() {
        #expect(DesignGuidelines.section(for: .grafting) == .grafting)
        #expect(DesignGuidelines.section(for: .threadGrafting) == .grafting)
        #expect(DesignGuidelines.section(for: .deadwood) == .deadwood)
        #expect(DesignGuidelines.section(for: .shari) == .deadwood)
        #expect(DesignGuidelines.section(for: .jin) == .deadwood)
        #expect(DesignGuidelines.section(for: .wiring) == .wiring)
        #expect(DesignGuidelines.section(for: .bending) == .wiring)
    }
}
