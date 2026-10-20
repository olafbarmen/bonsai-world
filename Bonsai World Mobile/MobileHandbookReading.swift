//
//  MobileHandbookReading.swift
//  Bonsai World
//
//  Reads the Mac handbook lessons into one phone model.
//

import Foundation

struct MobileHandbookCallout: Identifiable, Hashable {
    var id: String
    var title: String
    var body: String
}

struct MobileHandbookSection: Identifiable, Hashable {
    var id: String
    var heading: String
    var paragraphs: [String]
    var bullets: [String]
    var callouts: [MobileHandbookCallout]
}

struct MobileHandbookLesson: Identifiable, Hashable {
    var id: String
    var number: Int
    var title: String
    var summary: String
    var sections: [MobileHandbookSection]

    var numberedTitle: String {
        String(format: "%02d — %@", number, title)
    }
}

protocol MobileReadableCallout {
    var id: String { get }
    var title: String { get }
    var body: String { get }
}

protocol MobileReadableSection {
    associatedtype Callout: MobileReadableCallout
    var id: String { get }
    var heading: String { get }
    var paragraphs: [String] { get }
    var bullets: [String] { get }
    var callouts: [Callout] { get }
}

protocol MobileReadableLesson {
    associatedtype Section: MobileReadableSection
    var id: String { get }
    var number: Int { get }
    var title: String { get }
    var summary: String { get }
    var sections: [Section] { get }
}

extension WiringKnowledgeCallout: MobileReadableCallout {}
extension WiringKnowledgeSection: MobileReadableSection {}
extension WiringKnowledgeLesson: MobileReadableLesson {}
extension FertilizingKnowledgeCallout: MobileReadableCallout {}
extension FertilizingKnowledgeSection: MobileReadableSection {}
extension FertilizingKnowledgeLesson: MobileReadableLesson {}
extension WateringKnowledgeCallout: MobileReadableCallout {}
extension WateringKnowledgeSection: MobileReadableSection {}
extension WateringKnowledgeLesson: MobileReadableLesson {}
extension DisplayKnowledgeCallout: MobileReadableCallout {}
extension DisplayKnowledgeSection: MobileReadableSection {}
extension DisplayKnowledgeLesson: MobileReadableLesson {}
extension RepottingKnowledgeCallout: MobileReadableCallout {}
extension RepottingKnowledgeSection: MobileReadableSection {}
extension RepottingKnowledgeLesson: MobileReadableLesson {}
extension PruningKnowledgeCallout: MobileReadableCallout {}
extension PruningKnowledgeSection: MobileReadableSection {}
extension PruningKnowledgeLesson: MobileReadableLesson {}
extension AirPruningKnowledgeCallout: MobileReadableCallout {}
extension AirPruningKnowledgeSection: MobileReadableSection {}
extension AirPruningKnowledgeLesson: MobileReadableLesson {}
extension AirLayeringKnowledgeCallout: MobileReadableCallout {}
extension AirLayeringKnowledgeSection: MobileReadableSection {}
extension AirLayeringKnowledgeLesson: MobileReadableLesson {}
extension TreeHealthCallout: MobileReadableCallout {}
extension TreeHealthSection: MobileReadableSection {}
extension TreeHealthLesson: MobileReadableLesson {}
extension ArtistryCallout: MobileReadableCallout {}
extension ArtistrySection: MobileReadableSection {}
extension ArtistryLesson: MobileReadableLesson {}
extension DeadwoodCallout: MobileReadableCallout {}
extension DeadwoodSection: MobileReadableSection {}
extension DeadwoodLesson: MobileReadableLesson {}
extension SeasonalCareCallout: MobileReadableCallout {}
extension SeasonalCareSection: MobileReadableSection {}
extension SeasonalCareLesson: MobileReadableLesson {}
extension PotKnowledgeCallout: MobileReadableCallout {}
extension PotKnowledgeSection: MobileReadableSection {}
extension PotKnowledgeLesson: MobileReadableLesson {}
extension CollectionManagementCallout: MobileReadableCallout {}
extension CollectionManagementSection: MobileReadableSection {}
extension CollectionManagementLesson: MobileReadableLesson {}
extension PropagationCallout: MobileReadableCallout {}
extension PropagationSection: MobileReadableSection {}
extension PropagationLesson: MobileReadableLesson {}
extension AdvancedTechniquesCallout: MobileReadableCallout {}
extension AdvancedTechniquesSection: MobileReadableSection {}
extension AdvancedTechniquesLesson: MobileReadableLesson {}
extension SoilKnowledgeCallout: MobileReadableCallout {}
extension SoilKnowledgeSection: MobileReadableSection {}
extension SoilKnowledgeLesson: MobileReadableLesson {}
extension ToolsKnowledgeCallout: MobileReadableCallout {}
extension ToolsKnowledgeSection: MobileReadableSection {}
extension ToolsKnowledgeLesson: MobileReadableLesson {}
extension FormsStylesCallout: MobileReadableCallout {}
extension FormsStylesSection: MobileReadableSection {}
extension FormsStylesLesson: MobileReadableLesson {}
extension MaterialKnowledgeCallout: MobileReadableCallout {}
extension MaterialKnowledgeSection: MobileReadableSection {}
extension MaterialKnowledgeLesson: MobileReadableLesson {}

enum MobileHandbookCatalog {
    static func lessons(for chapter: BonsaiHandbookChapter) -> [MobileHandbookLesson] {
        switch chapter {
        case .designGuidelines:
            designLessons
        case .formsStyles:
            map(FormsStylesKnowledge.lessons)
        case .artistry:
            map(ArtistryKnowledge.lessons)
        case .material:
            map(MaterialKnowledge.lessons)
        case .pruning:
            map(PruningKnowledge.lessons)
        case .wiring:
            map(WiringKnowledge.lessons)
        case .repotting:
            map(RepottingKnowledge.lessons)
        case .watering:
            map(WateringKnowledge.lessons)
        case .potGuidelines:
            map(PotGuidelines.lessons)
        case .airPruning:
            map(AirPruningKnowledge.lessons)
        case .display:
            map(DisplayKnowledge.lessons)
        case .soilGuides:
            map(SoilKnowledge.lessons)
        case .fertilizing:
            map(FertilizingKnowledge.lessons)
        case .propagation:
            map(PropagationKnowledge.lessons)
        case .airLayering:
            map(AirLayeringKnowledge.lessons)
        case .tools:
            map(ToolsKnowledge.lessons)
        case .deadwood:
            map(DeadwoodKnowledge.lessons)
        case .advancedTechniques:
            map(AdvancedTechniquesKnowledge.lessons)
        case .collectionManagement:
            map(CollectionManagementKnowledge.lessons)
        case .treeHealth:
            map(TreeHealthKnowledge.lessons)
        case .seasonalCare:
            map(SeasonalCareKnowledge.lessons)
        }
    }

    static func lesson(chapter: BonsaiHandbookChapter, id: String) -> MobileHandbookLesson? {
        lessons(for: chapter).first { $0.id == id }
    }

    static func lessonID(for topic: HandbookTopic) -> String {
        switch topic {
        case .designIntroduction:
            "introduction"
        case .design(let section):
            section.rawValue
        case .formsStyles(let id),
             .artistry(let id),
             .material(let id),
             .pot(let id),
             .airPruning(let id),
             .soil(let id),
             .fertilizing(let id),
             .pruning(let id),
             .wiring(let id),
             .repotting(let id),
             .watering(let id),
             .display(let id),
             .propagation(let id),
             .airLayering(let id),
             .tools(let id),
             .deadwood(let id),
             .advancedTechniques(let id),
             .collectionManagement(let id),
             .treeHealth(let id),
             .seasonalCare(let id):
            id
        }
    }

    private static var designLessons: [MobileHandbookLesson] {
        var lessons = [
            MobileHandbookLesson(
                id: "introduction",
                number: 1,
                title: "Introduction",
                summary: "Guidelines, not laws — a check, not a recipe.",
                sections: [
                    MobileHandbookSection(
                        id: "introduction",
                        heading: "Introduction",
                        paragraphs: DesignGuidelines.introduction,
                        bullets: [],
                        callouts: []
                    )
                ]
            )
        ]
        lessons += DesignGuidelines.entries.enumerated().map { index, entry in
            MobileHandbookLesson(
                id: entry.section.rawValue,
                number: index + 2,
                title: entry.section.title,
                summary: entry.excerpt,
                sections: [
                    MobileHandbookSection(
                        id: "body",
                        heading: entry.section.title,
                        paragraphs: entry.paragraphs,
                        bullets: [],
                        callouts: [
                            MobileHandbookCallout(
                                id: "on-the-tree",
                                title: "On the tree",
                                body: entry.onTheTree
                            )
                        ]
                    )
                ]
            )
        }
        return lessons
    }

    private static func map<L: MobileReadableLesson>(_ lessons: [L]) -> [MobileHandbookLesson] {
        lessons.map { lesson in
            MobileHandbookLesson(
                id: lesson.id,
                number: lesson.number,
                title: lesson.title,
                summary: lesson.summary,
                sections: lesson.sections.map { section in
                    MobileHandbookSection(
                        id: section.id,
                        heading: section.heading,
                        paragraphs: section.paragraphs,
                        bullets: section.bullets,
                        callouts: section.callouts.map { callout in
                            MobileHandbookCallout(
                                id: callout.id,
                                title: callout.title,
                                body: callout.body
                            )
                        }
                    )
                }
            )
        }
    }
}
