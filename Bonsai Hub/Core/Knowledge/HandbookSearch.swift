//
//  HandbookSearch.swift
//  Bonsai World
//
//  Knowledge → Bonsai Handbook — search across numbered lessons, ranked by relevance.
//

import Foundation

enum HandbookTopic: Hashable, Sendable {
    case designIntroduction
    case design(DesignGuidelineSection)
    case formsStyles(String)
    case artistry(String)
    case material(String)
    case pot(String)
    case airPruning(String)
    case soil(String)
    case fertilizing(String)
    case pruning(String)
    case wiring(String)
    case repotting(String)
    case watering(String)
    case display(String)
    case propagation(String)
    case airLayering(String)
    case tools(String)
    case deadwood(String)
    case advancedTechniques(String)
    case collectionManagement(String)
    case treeHealth(String)
    case seasonalCare(String)

    var chapter: BonsaiHandbookChapter {
        switch self {
        case .designIntroduction, .design: .designGuidelines
        case .formsStyles: .formsStyles
        case .artistry: .artistry
        case .material: .material
        case .pruning: .pruning
        case .wiring: .wiring
        case .repotting: .repotting
        case .watering: .watering
        case .pot: .potGuidelines
        case .airPruning: .airPruning
        case .display: .display
        case .soil: .soilGuides
        case .fertilizing: .fertilizing
        case .propagation: .propagation
        case .airLayering: .airLayering
        case .tools: .tools
        case .deadwood: .deadwood
        case .advancedTechniques: .advancedTechniques
        case .collectionManagement: .collectionManagement
        case .treeHealth: .treeHealth
        case .seasonalCare: .seasonalCare
        }
    }
}

struct HandbookSearchEntry: Identifiable, Hashable, Sendable {
    var id: String
    var topic: HandbookTopic
    var number: Int
    var title: String
    var headings: [String]
    var body: String

    var numberedTitle: String {
        String(format: "%02d — %@", number, title)
    }

    var chapterTitle: String {
        topic.chapter.title
    }
}

struct HandbookSearchHit: Identifiable, Hashable, Sendable {
    var entry: HandbookSearchEntry
    var score: Int

    var id: String { entry.id }
    var topic: HandbookTopic { entry.topic }
    var numberedTitle: String { entry.numberedTitle }
    var chapterTitle: String { entry.chapterTitle }
}

enum HandbookSearch {
    static func hits(matching query: String) -> [HandbookSearchHit] {
        let needle = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !needle.isEmpty else { return [] }

        return catalog.compactMap { entry -> HandbookSearchHit? in
            let score = score(entry, needle: needle)
            guard score > 0 else { return nil }
            return HandbookSearchHit(entry: entry, score: score)
        }
        .sorted { lhs, rhs in
            if lhs.score != rhs.score { return lhs.score > rhs.score }
            let chapterOrder = lhs.chapterTitle.localizedStandardCompare(rhs.chapterTitle)
            if chapterOrder != .orderedSame { return chapterOrder == .orderedAscending }
            return lhs.entry.number < rhs.entry.number
        }
    }

    static let catalog: [HandbookSearchEntry] = designEntries + formsStylesEntries + artistryEntries + materialEntries + pruningEntries + wiringEntries + repottingEntries + wateringEntries + potEntries + airPruningEntries + displayEntries + soilEntries + fertilizingEntries + propagationEntries + airLayeringEntries + toolsEntries + deadwoodEntries + advancedTechniquesEntries + collectionManagementEntries + treeHealthEntries + seasonalCareEntries

    // MARK: - Ranking

    static func score(_ entry: HandbookSearchEntry, needle: String) -> Int {
        var total = 0
        total += fieldScore(entry.title, needle: needle, weight: 100)
        total += fieldScore(entry.numberedTitle, needle: needle, weight: 20)
        for heading in entry.headings {
            total += fieldScore(heading, needle: needle, weight: 40)
        }
        total += occurrenceScore(entry.body, needle: needle, weight: 10, cap: 10)
        return total
    }

    private static func fieldScore(_ text: String, needle: String, weight: Int) -> Int {
        guard text.localizedStandardContains(needle) else { return 0 }
        var value = weight
        if hasWordBoundaryMatch(text, needle: needle) {
            value += weight / 2
        }
        return value
    }

    private static func occurrenceScore(_ text: String, needle: String, weight: Int, cap: Int) -> Int {
        min(occurrenceCount(text, needle: needle), cap) * weight
    }

    static func occurrenceCount(_ text: String, needle: String) -> Int {
        guard !needle.isEmpty else { return 0 }
        var count = 0
        var searchStart = text.startIndex
        while let range = text.range(
            of: needle,
            options: [.caseInsensitive, .diacriticInsensitive],
            range: searchStart..<text.endIndex
        ) {
            count += 1
            searchStart = range.upperBound
        }
        return count
    }

    private static func hasWordBoundaryMatch(_ text: String, needle: String) -> Bool {
        let words = text.split { !$0.isLetter && !$0.isNumber }
        return words.contains { word in
            let token = String(word)
            return token.compare(needle, options: [.caseInsensitive, .diacriticInsensitive]) == .orderedSame
                || token.lowercased().hasPrefix(needle.lowercased())
        }
    }

    // MARK: - Catalog

    private static var designEntries: [HandbookSearchEntry] {
        var entries: [HandbookSearchEntry] = [
            HandbookSearchEntry(
                id: "design-introduction",
                topic: .designIntroduction,
                number: 1,
                title: "Introduction",
                headings: [],
                body: DesignGuidelines.introduction.joined(separator: " ")
            )
        ]
        for (index, entry) in DesignGuidelines.entries.enumerated() {
            entries.append(
                HandbookSearchEntry(
                    id: "design-\(entry.section.rawValue)",
                    topic: .design(entry.section),
                    number: index + 2,
                    title: entry.section.title,
                    headings: [entry.excerpt],
                    body: (entry.paragraphs + [entry.onTheTree]).joined(separator: " ")
                )
            )
        }
        return entries
    }

    private static var formsStylesEntries: [HandbookSearchEntry] {
        FormsStylesKnowledge.lessons.map { lesson in
            HandbookSearchEntry(
                id: "forms-\(lesson.id)",
                topic: .formsStyles(lesson.id),
                number: lesson.number,
                title: lesson.title,
                headings: lesson.sections.map(\.heading) + lesson.sections.flatMap { $0.callouts.map(\.title) },
                body: formsStylesBody(lesson)
            )
        }
    }

    private static var artistryEntries: [HandbookSearchEntry] {
        ArtistryKnowledge.lessons.map { lesson in
            HandbookSearchEntry(
                id: "artistry-\(lesson.id)",
                topic: .artistry(lesson.id),
                number: lesson.number,
                title: lesson.title,
                headings: lesson.sections.map(\.heading) + lesson.sections.flatMap { $0.callouts.map(\.title) },
                body: artistryBody(lesson)
            )
        }
    }

    private static var materialEntries: [HandbookSearchEntry] {
        MaterialKnowledge.lessons.map { lesson in
            HandbookSearchEntry(
                id: "material-\(lesson.id)",
                topic: .material(lesson.id),
                number: lesson.number,
                title: lesson.title,
                headings: lesson.sections.map(\.heading) + lesson.sections.flatMap { $0.callouts.map(\.title) },
                body: materialBody(lesson)
            )
        }
    }

    private static var potEntries: [HandbookSearchEntry] {
        PotGuidelines.lessons.map { lesson in
            HandbookSearchEntry(
                id: "pot-\(lesson.id)",
                topic: .pot(lesson.id),
                number: lesson.number,
                title: lesson.title,
                headings: lesson.sections.map(\.heading) + lesson.sections.flatMap { $0.callouts.map(\.title) },
                body: potBody(lesson)
            )
        }
    }

    private static var airPruningEntries: [HandbookSearchEntry] {
        AirPruningKnowledge.lessons.map { lesson in
            HandbookSearchEntry(
                id: "air-pruning-\(lesson.id)",
                topic: .airPruning(lesson.id),
                number: lesson.number,
                title: lesson.title,
                headings: lesson.sections.map(\.heading) + lesson.sections.flatMap { $0.callouts.map(\.title) },
                body: airPruningBody(lesson)
            )
        }
    }

    private static var displayEntries: [HandbookSearchEntry] {
        DisplayKnowledge.lessons.map { lesson in
            HandbookSearchEntry(
                id: "display-\(lesson.id)",
                topic: .display(lesson.id),
                number: lesson.number,
                title: lesson.title,
                headings: lesson.sections.map(\.heading) + lesson.sections.flatMap { $0.callouts.map(\.title) },
                body: displayBody(lesson)
            )
        }
    }

    private static var pruningEntries: [HandbookSearchEntry] {
        PruningKnowledge.lessons.map { lesson in
            HandbookSearchEntry(
                id: "pruning-\(lesson.id)",
                topic: .pruning(lesson.id),
                number: lesson.number,
                title: lesson.title,
                headings: lesson.sections.map(\.heading) + lesson.sections.flatMap { $0.callouts.map(\.title) },
                body: pruningBody(lesson)
            )
        }
    }

    private static var wiringEntries: [HandbookSearchEntry] {
        WiringKnowledge.lessons.map { lesson in
            HandbookSearchEntry(
                id: "wiring-\(lesson.id)",
                topic: .wiring(lesson.id),
                number: lesson.number,
                title: lesson.title,
                headings: lesson.sections.map(\.heading) + lesson.sections.flatMap { $0.callouts.map(\.title) },
                body: wiringBody(lesson)
            )
        }
    }

    private static var repottingEntries: [HandbookSearchEntry] {
        RepottingKnowledge.lessons.map { lesson in
            HandbookSearchEntry(
                id: "repotting-\(lesson.id)",
                topic: .repotting(lesson.id),
                number: lesson.number,
                title: lesson.title,
                headings: lesson.sections.map(\.heading) + lesson.sections.flatMap { $0.callouts.map(\.title) },
                body: repottingBody(lesson)
            )
        }
    }

    private static var wateringEntries: [HandbookSearchEntry] {
        WateringKnowledge.lessons.map { lesson in
            HandbookSearchEntry(
                id: "watering-\(lesson.id)",
                topic: .watering(lesson.id),
                number: lesson.number,
                title: lesson.title,
                headings: lesson.sections.map(\.heading) + lesson.sections.flatMap { $0.callouts.map(\.title) },
                body: wateringBody(lesson)
            )
        }
    }

    private static var soilEntries: [HandbookSearchEntry] {
        SoilKnowledge.lessons.map { lesson in
            HandbookSearchEntry(
                id: "soil-\(lesson.id)",
                topic: .soil(lesson.id),
                number: lesson.number,
                title: lesson.title,
                headings: lesson.sections.map(\.heading) + lesson.sections.flatMap { $0.callouts.map(\.title) },
                body: soilBody(lesson)
            )
        }
    }

    private static var fertilizingEntries: [HandbookSearchEntry] {
        FertilizingKnowledge.lessons.map { lesson in
            HandbookSearchEntry(
                id: "fertilizing-\(lesson.id)",
                topic: .fertilizing(lesson.id),
                number: lesson.number,
                title: lesson.title,
                headings: lesson.sections.map(\.heading) + lesson.sections.flatMap { $0.callouts.map(\.title) },
                body: fertilizingBody(lesson)
            )
        }
    }

    private static var propagationEntries: [HandbookSearchEntry] {
        PropagationKnowledge.lessons.map { lesson in
            HandbookSearchEntry(
                id: "propagation-\(lesson.id)",
                topic: .propagation(lesson.id),
                number: lesson.number,
                title: lesson.title,
                headings: lesson.sections.map(\.heading) + lesson.sections.flatMap { $0.callouts.map(\.title) },
                body: propagationBody(lesson)
            )
        }
    }

    private static var airLayeringEntries: [HandbookSearchEntry] {
        AirLayeringKnowledge.lessons.map { lesson in
            HandbookSearchEntry(
                id: "air-\(lesson.id)",
                topic: .airLayering(lesson.id),
                number: lesson.number,
                title: lesson.title,
                headings: lesson.sections.map(\.heading) + lesson.sections.flatMap { $0.callouts.map(\.title) },
                body: airLayeringBody(lesson)
            )
        }
    }

    private static var toolsEntries: [HandbookSearchEntry] {
        ToolsKnowledge.lessons.map { lesson in
            HandbookSearchEntry(
                id: "tools-\(lesson.id)",
                topic: .tools(lesson.id),
                number: lesson.number,
                title: lesson.title,
                headings: lesson.sections.map(\.heading) + lesson.sections.flatMap { $0.callouts.map(\.title) },
                body: toolsBody(lesson)
            )
        }
    }

    private static var deadwoodEntries: [HandbookSearchEntry] {
        DeadwoodKnowledge.lessons.map { lesson in
            HandbookSearchEntry(
                id: "deadwood-\(lesson.id)",
                topic: .deadwood(lesson.id),
                number: lesson.number,
                title: lesson.title,
                headings: lesson.sections.map(\.heading) + lesson.sections.flatMap { $0.callouts.map(\.title) },
                body: deadwoodBody(lesson)
            )
        }
    }

    private static var advancedTechniquesEntries: [HandbookSearchEntry] {
        AdvancedTechniquesKnowledge.lessons.map { lesson in
            HandbookSearchEntry(
                id: "advanced-\(lesson.id)",
                topic: .advancedTechniques(lesson.id),
                number: lesson.number,
                title: lesson.title,
                headings: lesson.sections.map(\.heading) + lesson.sections.flatMap { $0.callouts.map(\.title) },
                body: advancedTechniquesBody(lesson)
            )
        }
    }

    private static var collectionManagementEntries: [HandbookSearchEntry] {
        CollectionManagementKnowledge.lessons.map { lesson in
            HandbookSearchEntry(
                id: "collection-\(lesson.id)",
                topic: .collectionManagement(lesson.id),
                number: lesson.number,
                title: lesson.title,
                headings: lesson.sections.map(\.heading) + lesson.sections.flatMap { $0.callouts.map(\.title) },
                body: collectionManagementBody(lesson)
            )
        }
    }

    private static var treeHealthEntries: [HandbookSearchEntry] {
        TreeHealthKnowledge.lessons.map { lesson in
            HandbookSearchEntry(
                id: "health-\(lesson.id)",
                topic: .treeHealth(lesson.id),
                number: lesson.number,
                title: lesson.title,
                headings: lesson.sections.map(\.heading) + lesson.sections.flatMap { $0.callouts.map(\.title) },
                body: treeHealthBody(lesson)
            )
        }
    }

    private static var seasonalCareEntries: [HandbookSearchEntry] {
        SeasonalCareKnowledge.lessons.map { lesson in
            HandbookSearchEntry(
                id: "seasonal-\(lesson.id)",
                topic: .seasonalCare(lesson.id),
                number: lesson.number,
                title: lesson.title,
                headings: lesson.sections.map(\.heading) + lesson.sections.flatMap { $0.callouts.map(\.title) },
                body: seasonalCareBody(lesson)
            )
        }
    }

    private static func pruningBody(_ lesson: PruningKnowledgeLesson) -> String {
        var parts = [lesson.summary]
        for section in lesson.sections {
            parts.append(contentsOf: section.paragraphs)
            parts.append(contentsOf: section.bullets)
            parts.append(contentsOf: section.callouts.map(\.body))
        }
        return parts.joined(separator: " ")
    }

    private static func wiringBody(_ lesson: WiringKnowledgeLesson) -> String {
        var parts = [lesson.summary]
        for section in lesson.sections {
            parts.append(contentsOf: section.paragraphs)
            parts.append(contentsOf: section.bullets)
            parts.append(contentsOf: section.callouts.map(\.body))
        }
        return parts.joined(separator: " ")
    }

    private static func repottingBody(_ lesson: RepottingKnowledgeLesson) -> String {
        var parts = [lesson.summary]
        for section in lesson.sections {
            parts.append(contentsOf: section.paragraphs)
            parts.append(contentsOf: section.bullets)
            parts.append(contentsOf: section.callouts.map(\.body))
        }
        return parts.joined(separator: " ")
    }

    private static func wateringBody(_ lesson: WateringKnowledgeLesson) -> String {
        var parts = [lesson.summary]
        for section in lesson.sections {
            parts.append(contentsOf: section.paragraphs)
            parts.append(contentsOf: section.bullets)
            parts.append(contentsOf: section.callouts.map(\.body))
        }
        return parts.joined(separator: " ")
    }

    private static func potBody(_ lesson: PotKnowledgeLesson) -> String {
        var parts = [lesson.summary]
        for section in lesson.sections {
            parts.append(contentsOf: section.paragraphs)
            parts.append(contentsOf: section.bullets)
            parts.append(contentsOf: section.callouts.map(\.body))
        }
        return parts.joined(separator: " ")
    }

    private static func airPruningBody(_ lesson: AirPruningKnowledgeLesson) -> String {
        var parts = [lesson.summary]
        for section in lesson.sections {
            parts.append(contentsOf: section.paragraphs)
            parts.append(contentsOf: section.bullets)
            parts.append(contentsOf: section.callouts.map(\.body))
        }
        return parts.joined(separator: " ")
    }

    private static func displayBody(_ lesson: DisplayKnowledgeLesson) -> String {
        var parts = [lesson.summary]
        for section in lesson.sections {
            parts.append(contentsOf: section.paragraphs)
            parts.append(contentsOf: section.bullets)
            parts.append(contentsOf: section.callouts.map(\.body))
        }
        return parts.joined(separator: " ")
    }

    private static func soilBody(_ lesson: SoilKnowledgeLesson) -> String {
        var parts = [lesson.summary]
        for section in lesson.sections {
            parts.append(contentsOf: section.paragraphs)
            parts.append(contentsOf: section.bullets)
            parts.append(contentsOf: section.callouts.map(\.body))
        }
        return parts.joined(separator: " ")
    }

    private static func fertilizingBody(_ lesson: FertilizingKnowledgeLesson) -> String {
        var parts = [lesson.summary]
        for section in lesson.sections {
            parts.append(contentsOf: section.paragraphs)
            parts.append(contentsOf: section.bullets)
            parts.append(contentsOf: section.callouts.map(\.body))
        }
        return parts.joined(separator: " ")
    }

    private static func propagationBody(_ lesson: PropagationLesson) -> String {
        var parts = [lesson.summary]
        for section in lesson.sections {
            parts.append(contentsOf: section.paragraphs)
            parts.append(contentsOf: section.bullets)
            parts.append(contentsOf: section.callouts.map(\.body))
        }
        return parts.joined(separator: " ")
    }

    private static func airLayeringBody(_ lesson: AirLayeringKnowledgeLesson) -> String {
        var parts = [lesson.summary]
        for section in lesson.sections {
            parts.append(contentsOf: section.paragraphs)
            parts.append(contentsOf: section.bullets)
            parts.append(contentsOf: section.callouts.map(\.body))
        }
        return parts.joined(separator: " ")
    }

    private static func toolsBody(_ lesson: ToolsKnowledgeLesson) -> String {
        var parts = [lesson.summary]
        for section in lesson.sections {
            parts.append(contentsOf: section.paragraphs)
            parts.append(contentsOf: section.bullets)
            parts.append(contentsOf: section.callouts.map(\.body))
        }
        return parts.joined(separator: " ")
    }

    private static func formsStylesBody(_ lesson: FormsStylesLesson) -> String {
        var parts = [lesson.summary]
        for section in lesson.sections {
            parts.append(contentsOf: section.paragraphs)
            parts.append(contentsOf: section.bullets)
            parts.append(contentsOf: section.callouts.map(\.body))
        }
        return parts.joined(separator: " ")
    }

    private static func artistryBody(_ lesson: ArtistryLesson) -> String {
        var parts = [lesson.summary]
        for section in lesson.sections {
            parts.append(contentsOf: section.paragraphs)
            parts.append(contentsOf: section.bullets)
            parts.append(contentsOf: section.callouts.map(\.body))
        }
        return parts.joined(separator: " ")
    }

    private static func materialBody(_ lesson: MaterialKnowledgeLesson) -> String {
        var parts = [lesson.summary]
        for section in lesson.sections {
            parts.append(contentsOf: section.paragraphs)
            parts.append(contentsOf: section.bullets)
            parts.append(contentsOf: section.callouts.map(\.body))
        }
        return parts.joined(separator: " ")
    }

    private static func deadwoodBody(_ lesson: DeadwoodLesson) -> String {
        var parts = [lesson.summary]
        for section in lesson.sections {
            parts.append(contentsOf: section.paragraphs)
            parts.append(contentsOf: section.bullets)
            parts.append(contentsOf: section.callouts.map(\.body))
        }
        return parts.joined(separator: " ")
    }

    private static func advancedTechniquesBody(_ lesson: AdvancedTechniquesLesson) -> String {
        var parts = [lesson.summary]
        for section in lesson.sections {
            parts.append(contentsOf: section.paragraphs)
            parts.append(contentsOf: section.bullets)
            parts.append(contentsOf: section.callouts.map(\.body))
        }
        return parts.joined(separator: " ")
    }

    private static func collectionManagementBody(_ lesson: CollectionManagementLesson) -> String {
        var parts = [lesson.summary]
        for section in lesson.sections {
            parts.append(contentsOf: section.paragraphs)
            parts.append(contentsOf: section.bullets)
            parts.append(contentsOf: section.callouts.map(\.body))
        }
        return parts.joined(separator: " ")
    }

    private static func treeHealthBody(_ lesson: TreeHealthLesson) -> String {
        var parts = [lesson.summary]
        for section in lesson.sections {
            parts.append(contentsOf: section.paragraphs)
            parts.append(contentsOf: section.bullets)
            parts.append(contentsOf: section.callouts.map(\.body))
        }
        return parts.joined(separator: " ")
    }

    private static func seasonalCareBody(_ lesson: SeasonalCareLesson) -> String {
        var parts = [lesson.summary]
        for section in lesson.sections {
            parts.append(contentsOf: section.paragraphs)
            parts.append(contentsOf: section.bullets)
            parts.append(contentsOf: section.callouts.map(\.body))
        }
        return parts.joined(separator: " ")
    }
}
