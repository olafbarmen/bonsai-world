//
//  CollectionManagementKnowledge.swift
//  Bonsai World
//
//  Knowledge → Bonsai Handbook → Bonsai Collection Management.
//  Principles for organising a growing collection. Not a software manual.
//

import Foundation

struct CollectionManagementCallout: Identifiable, Hashable, Sendable {
    var id: String
    var title: String
    var body: String
}

struct CollectionManagementSection: Identifiable, Hashable, Sendable {
    var id: String
    var heading: String
    var paragraphs: [String]
    var bullets: [String]
    var callouts: [CollectionManagementCallout]
}

struct CollectionManagementLesson: Identifiable, Hashable, Sendable {
    var id: String
    var number: Int
    var title: String
    var summary: String
    var sections: [CollectionManagementSection]
}

enum CollectionManagementKnowledge {
    static let chapterTitle = "Bonsai Collection Management"

    static let openingLine =
        "Understanding your trees, their history and what needs to happen next."

    static let disclaimer =
        "This chapter explains bonsai principles for managing a collection. It is not a product manual. Bonsai World is a practical system that can support these principles by connecting each tree with knowledge, history and the next step. A record is useful only when it helps you understand a tree later."

    static let lessons: [CollectionManagementLesson] = [
        overview,
        knowingWhatYouHave,
        profileAndHistory,
        fromMemoryToInformation,
        tasksAndPriorities,
        developmentStages,
        collectionOverview,
        seasonalPlanning,
        collectionHealth,
        observationAndSize,
        recordsPhotographsAndContext,
        practice,
        quickGuides
    ]

    static func lesson(id: String) -> CollectionManagementLesson? {
        lessons.first { $0.id == id }
    }

    // MARK: - 01 Overview

    private static let overview = CollectionManagementLesson(
        id: "overview",
        number: 1,
        title: "Overview",
        summary: "The collection must be organised. But the individual tree must never disappear.",
        sections: [
            CollectionManagementSection(
                id: "beyond-memory",
                heading: "When memory is no longer enough",
                paragraphs: [
                    "A small bonsai collection can often be managed through memory. You remember which tree was repotted, which was wired, which needs attention. As the collection grows, this becomes increasingly difficult.",
                    "Different trees may have different species, ages, soil, development stages, health conditions and histories. The challenge is no longer only how to care for this tree. It becomes how to understand and manage the entire collection without losing track of the individual trees."
                ],
                bullets: [],
                callouts: [
                    CollectionManagementCallout(
                        id: "never-disappear",
                        title: "Bonsai World principle",
                        body: "The collection must be organised. But the individual tree must never disappear."
                    ),
                    CollectionManagementCallout(
                        id: "individuals",
                        title: "Bonsai World principle",
                        body: "A collection is not just a group of trees. It is a group of individual trees, each with its own history, condition, needs and future."
                    )
                ]
            ),
            CollectionManagementSection(
                id: "individual",
                heading: "One collection, many different needs",
                paragraphs: [
                    "A bonsai collection should not be treated as one uniform group. Each tree may differ in species, age, origin, development stage, health, root condition, soil, recent work and future goals.",
                    "Two trees standing next to each other may require completely different care. One may be recovering from repotting. Another may be ready for development. Another may simply need to grow. Good collection management begins by recognising that every tree has its own context."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )

    // MARK: - 02 Knowing What You Have

    private static let knowingWhatYouHave = CollectionManagementLesson(
        id: "knowing-what-you-have",
        number: 2,
        title: "Knowing What You Have",
        summary: "The goal is not administration. It is being able to answer what this tree is, and what you know about it.",
        sections: [
            CollectionManagementSection(
                id: "foundation",
                heading: "The foundation of a managed collection",
                paragraphs: [
                    "Every tree should be identifiable. Useful information may include a name or identifier, species, origin, acquisition information, approximate age where known, and current development stage.",
                    "The goal is not administration for its own sake. The goal is being able to answer: what tree is this? Where did it come from? What do I know about it? What has happened to it?"
                ],
                bullets: [],
                callouts: []
            )
        ]
    )

    // MARK: - 03 Tree Profile & History

    private static let profileAndHistory = CollectionManagementLesson(
        id: "profile-history",
        number: 3,
        title: "Tree Profile & History",
        summary: "Today’s tree is the result of its previous years. Record useful history, not paperwork.",
        sections: [
            CollectionManagementSection(
                id: "profile",
                heading: "One place for the tree’s story",
                paragraphs: [
                    "Each bonsai benefits from having an individual record. A useful tree profile may bring together identity, species, history, current condition, development direction and what needs attention next.",
                    "The purpose is not to create paperwork. It is to create continuity. Bonsai World exists to help connect the tree, the knowledge, the history and the next step."
                ],
                bullets: [],
                callouts: []
            ),
            CollectionManagementSection(
                id: "history",
                heading: "Memory becomes less reliable over time",
                paragraphs: [
                    "A bonsai may remain in a collection for decades. Over time, important information can be forgotten: when it was repotted, what soil was used, when it was heavily pruned, when wire was applied, when a health problem occurred, how the tree responded.",
                    "A history allows the artist to understand the present in the context of the past."
                ],
                bullets: [],
                callouts: [
                    CollectionManagementCallout(
                        id: "previous-years",
                        title: "Bonsai World principle",
                        body: "Today’s tree is the result of its previous years."
                    )
                ]
            ),
            CollectionManagementSection(
                id: "worth-remembering",
                heading: "What is worth remembering?",
                paragraphs: [
                    "Not every observation needs to become a permanent record. Focus on meaningful events: repotting, major pruning, wiring, styling, fertilizing changes, health problems, air layering and important development decisions.",
                    "The goal is useful history. Not unnecessary administration."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )

    // MARK: - 04 From Memory to Information

    private static let fromMemoryToInformation = CollectionManagementLesson(
        id: "memory-to-information",
        number: 4,
        title: "From Memory to Information",
        summary: "Without a system, the artist spends increasing time trying to remember. Organisation should make information visible.",
        sections: [
            CollectionManagementSection(
                id: "growing-problem",
                heading: "The growing collection problem",
                paragraphs: [
                    "As the number of trees increases, questions become harder to answer. Which trees have not been repotted recently? Which are currently recovering? Which still have wire that needs inspection? Which require health monitoring? Which projects should happen this season?",
                    "Without a system, the artist may spend increasing amounts of time trying to remember. A structured collection system can turn memory problems into visible information. Better organisation helps the artist spend less time remembering and more time working with trees."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )

    // MARK: - 05 Tasks & Priorities

    private static let tasksAndPriorities = CollectionManagementLesson(
        id: "tasks-priorities",
        number: 5,
        title: "Tasks & Priorities",
        summary: "A reminder should encourage you to look. Not force you to act. The tree has the final decision.",
        sections: [
            CollectionManagementSection(
                id: "tasks",
                heading: "Knowing what needs attention",
                paragraphs: [
                    "A bonsai collection creates ongoing work: inspect wire, monitor health, review development, prepare for repotting, check seasonal protection, follow up after major work.",
                    "The goal is not to create a rigid schedule for every tree. Tasks should support observation and priorities."
                ],
                bullets: [],
                callouts: [
                    CollectionManagementCallout(
                        id: "look",
                        title: "Bonsai World principle",
                        body: "A reminder should encourage you to look. Not force you to act."
                    )
                ]
            ),
            CollectionManagementSection(
                id: "judgement",
                heading: "The tree has the final decision",
                paragraphs: [
                    "A planned task may not always be appropriate. A planned pruning session may need to wait if the tree is weak. A repotting plan may need to change because seasonal development is different than expected.",
                    "Collection management should support planning. It should never replace judgement."
                ],
                bullets: [],
                callouts: [
                    CollectionManagementCallout(
                        id: "plan-observe",
                        title: "Bonsai World principle",
                        body: "Plan the work. Then observe the tree."
                    )
                ]
            ),
            CollectionManagementSection(
                id: "priorities",
                heading: "Not everything needs to be done today",
                paragraphs: [
                    "A collection can create more potential work than the artist has time to perform. Prioritisation helps separate urgent work that requires attention soon, important work that should be planned, monitoring that requires observation, and optional work that is useful but not currently necessary.",
                    "This helps prevent the collection from becoming overwhelming."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )

    // MARK: - 06 Development Stages

    private static let developmentStages = CollectionManagementLesson(
        id: "development-stages",
        number: 6,
        title: "Development Stages",
        summary: "A common mistake is treating every tree as though it needs refinement.",
        sections: [
            CollectionManagementSection(
                id: "goals",
                heading: "Different trees have different goals",
                paragraphs: [
                    "A collection may contain trees in very different stages. Early development may focus on growth. Structural development may focus on creating future structure. Refinement may focus on improving detail. Recovery focuses on restoring strength. Maintenance focuses on preserving an established tree.",
                    "Understanding development stages helps prevent one common mistake: treating every tree as though it needs refinement. Design Guidelines cover long-term structure. This lesson is the collection habit: match the work to the stage."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )

    // MARK: - 07 Collection Overview

    private static let collectionOverview = CollectionManagementLesson(
        id: "collection-overview",
        number: 7,
        title: "Collection Overview",
        summary: "Individual records are essential. The artist must also be able to step back.",
        sections: [
            CollectionManagementSection(
                id: "step-back",
                heading: "See the whole collection",
                paragraphs: [
                    "Individual tree records are essential. But the artist must also be able to step back. A collection overview can help answer what is happening across all trees.",
                    "Possible views include trees requiring attention, trees in recovery, trees under development, trees ready for refinement and trees being monitored. The goal is to combine the individual tree with the larger collection."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )

    // MARK: - 08 Seasonal Planning

    private static let seasonalPlanning = CollectionManagementLesson(
        id: "seasonal-planning",
        number: 8,
        title: "Seasonal Planning",
        summary: "Plan the collection’s workload before the busiest periods arrive. Then observe before you act.",
        sections: [
            CollectionManagementSection(
                id: "beyond-one",
                heading: "Think beyond one tree",
                paragraphs: [
                    "Seasonal work can become difficult when many trees require attention. A useful seasonal overview may help identify potential repotting candidates, trees requiring protection, trees needing wire inspection, trees entering active development and trees requiring health monitoring.",
                    "This allows the artist to plan workload before the busiest periods arrive. Seasonal Care & Protection covers the year, climate and why dates are not nature. A reminder still encourages inspection, not automatic action."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )

    // MARK: - 09 Collection Health

    private static let collectionHealth = CollectionManagementLesson(
        id: "collection-health",
        number: 9,
        title: "Collection Health",
        summary: "Health is not only an individual problem. One affected tree may have implications for others.",
        sections: [
            CollectionManagementSection(
                id: "overview-health",
                heading: "Health is not only an individual problem",
                paragraphs: [
                    "A collection should make it possible to identify trees that are healthy, being monitored, in treatment, in recovery, or temporarily separated in quarantine. This creates a useful overview without replacing individual diagnosis.",
                    "Tree Health covers observation, cause and when to act. Quarantine is a period of separation and watching — not a substitute for understanding the tree."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )

    // MARK: - 10 Observation & Size

    private static let observationAndSize = CollectionManagementLesson(
        id: "observation-size",
        number: 10,
        title: "Observation & Size",
        summary: "A good collection is not defined by how many trees it contains. It is defined by how well the trees are understood.",
        sections: [
            CollectionManagementSection(
                id: "look",
                heading: "Look at the whole collection regularly",
                paragraphs: [
                    "Collection management is not only about records. The trees still need to be observed. A useful collection inspection may consider general vigour, water requirements, pests, seasonal changes and environmental stress.",
                    "The system should support observation. It should never replace it."
                ],
                bullets: [],
                callouts: []
            ),
            CollectionManagementSection(
                id: "growing",
                heading: "Growth creates new challenges",
                paragraphs: [
                    "A larger collection requires more than more shelves. It requires more time, more attention and more planning. The artist should occasionally ask: do I have enough time for these trees? Do I have enough space? Can I provide appropriate care? Am I developing too many projects simultaneously?",
                    "The goal is not to own the most trees. The goal is to maintain a collection that can be cared for properly."
                ],
                bullets: [],
                callouts: []
            ),
            CollectionManagementSection(
                id: "quality",
                heading: "A collection should remain manageable",
                paragraphs: [
                    "A large collection is not automatically better. Too many trees may reduce attention per tree, development quality, health monitoring and enjoyment. A healthy collection size depends on available time, experience, space and goals."
                ],
                bullets: [],
                callouts: [
                    CollectionManagementCallout(
                        id: "understood",
                        title: "Bonsai World principle",
                        body: "A good collection is not defined by how many trees it contains. It is defined by how well the trees are understood."
                    )
                ]
            )
        ]
    )

    // MARK: - 11 Records, Photographs & Context

    private static let recordsPhotographsAndContext = CollectionManagementLesson(
        id: "records-photographs-context",
        number: 11,
        title: "Records, Photographs & Context",
        summary: "Information is more useful when it tells part of the tree’s story. Record what matters.",
        sections: [
            CollectionManagementSection(
                id: "development",
                heading: "The tree changes slowly",
                paragraphs: [
                    "Bonsai development can be difficult to see when the artist looks at the tree every day. Records and photographs can help reveal trunk development, branch development, ramification, design changes and recovery. This allows the artist to look beyond today’s appearance."
                ],
                bullets: [],
                callouts: []
            ),
            CollectionManagementSection(
                id: "photographs",
                heading: "Seeing time",
                paragraphs: [
                    "Photographs can become one of the most useful parts of a tree’s history. Useful records may include acquisition, major styling, seasonal development, and before and after important work.",
                    "The purpose is not taking photographs constantly. It is capturing meaningful change."
                ],
                bullets: [],
                callouts: []
            ),
            CollectionManagementSection(
                id: "species",
                heading: "The same care does not fit every tree",
                paragraphs: [
                    "Collection management should connect every tree to appropriate species knowledge: seasonal behaviour, watering tendencies, repotting considerations, fertilizing considerations and climate tolerance.",
                    "The collection becomes more manageable when information is connected to the individual tree. Species Library is that knowledge."
                ],
                bullets: [],
                callouts: []
            ),
            CollectionManagementSection(
                id: "context",
                heading: "Information becomes more useful when connected",
                paragraphs: [
                    "A date alone may not explain much. “Repotted in April” becomes more useful when connected to species, soil used, tree condition, root work and recovery. Collection management should preserve context."
                ],
                bullets: [],
                callouts: [
                    CollectionManagementCallout(
                        id: "story",
                        title: "Bonsai World principle",
                        body: "Information is more useful when it tells part of the tree’s story."
                    )
                ]
            ),
            CollectionManagementSection(
                id: "overload",
                heading: "Record what matters",
                paragraphs: [
                    "A good system should not require the artist to document every small action. Avoid recording information simply because it can be recorded.",
                    "Ask: will this help me understand the tree later? Will this help future decisions? Will this help identify a pattern? If not, it may not need to be recorded."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )

    // MARK: - 12 Practice

    private static let practice = CollectionManagementLesson(
        id: "practice",
        number: 12,
        title: "Practice",
        summary: "The purpose is not more administration. It is more understanding.",
        sections: [
            CollectionManagementSection(
                id: "mistakes",
                heading: "Common collection management mistakes",
                paragraphs: [
                    "Relying entirely on memory. Treating all trees as one group. Recording too little important information. Recording everything until the system becomes difficult to use. Creating tasks without considering tree condition.",
                    "Ignoring recovery periods. Losing track of previous work. Allowing the collection to grow beyond available time. Managing records instead of observing trees. Using organisation as a replacement for bonsai knowledge."
                ],
                bullets: [],
                callouts: []
            ),
            CollectionManagementSection(
                id: "approach",
                heading: "Knowledge connected to the tree",
                paragraphs: [
                    "The purpose of a modern collection system is not simply to store information. It is to connect the tree with species knowledge, with its history, with current tasks, with its development, and the collection with seasonal planning.",
                    "The result should be less time trying to remember, and more time understanding."
                ],
                bullets: [],
                callouts: []
            ),
            CollectionManagementSection(
                id: "framework",
                heading: "A simple collection management framework",
                paragraphs: [
                    "Every tree should be understood through five questions."
                ],
                bullets: [
                    "What is this tree? Identity and species.",
                    "Where has it been? History and development.",
                    "How is it now? Current condition and health.",
                    "What does it need next? Tasks and priorities.",
                    "Where is it going? Future development."
                ],
                callouts: []
            ),
            CollectionManagementSection(
                id: "paths",
                heading: "Beginner, intermediate and advanced",
                paragraphs: [
                    "Beginner — identify each tree, record important work, understand basic history. Continuity starts with a name and a few events that matter.",
                    "Intermediate — task planning, seasonal collection awareness and development tracking. Plan, then observe.",
                    "Advanced — larger collections, multiple development stages, long-term tree histories and collection-wide priorities. The individual tree still must not disappear."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )

    // MARK: - 13 Quick Guides

    private static let quickGuides = CollectionManagementLesson(
        id: "quick-guides",
        number: 13,
        title: "Quick Guides",
        summary: "Less time asking what you did. More time asking what the tree needs next.",
        sections: [
            CollectionManagementSection(
                id: "cards",
                heading: "Quick knowledge cards",
                paragraphs: [],
                bullets: [],
                callouts: [
                    CollectionManagementCallout(
                        id: "card-story",
                        title: "Every tree has a story",
                        body: "History provides context."
                    ),
                    CollectionManagementCallout(
                        id: "card-plan",
                        title: "Plan, then observe",
                        body: "A task is a reminder. The tree determines whether action is appropriate."
                    ),
                    CollectionManagementCallout(
                        id: "card-system",
                        title: "The collection is a system",
                        body: "Individual trees and collection-wide priorities must work together."
                    ),
                    CollectionManagementCallout(
                        id: "card-record",
                        title: "Record what matters",
                        body: "Good information is useful information."
                    ),
                    CollectionManagementCallout(
                        id: "card-space",
                        title: "Make space for attention",
                        body: "A collection should remain manageable."
                    )
                ]
            ),
            CollectionManagementSection(
                id: "connections",
                heading: "Connections to other Bonsai World knowledge",
                paragraphs: [
                    "Species Library — species-specific knowledge connected to the individual tree.",
                    "Tree Health — health monitoring, quarantine and recovery.",
                    "Seasonal Care & Protection — seasonal planning and protection.",
                    "Repotting — historical records and planning.",
                    "Pruning — development history.",
                    "Wiring — wire inspection and development tracking.",
                    "Fertilizing — feeding history and seasonal planning.",
                    "Air Layering — project tracking and follow-up.",
                    "Propagation — young material still in the collection.",
                    "Design Guidelines — future development direction.",
                    "Bonsai Material & Sourcing — origin, whether another tree belongs, and yamadori recovery history after collection.",
                ],
                bullets: [],
                callouts: []
            ),
            CollectionManagementSection(
                id: "closing",
                heading: "Final Bonsai World principle",
                paragraphs: [
                    "The purpose of collection management is not to create more administration. It is to create more understanding.",
                    "A bonsai collection can grow for decades. Trees change. Projects develop. History accumulates. Memory becomes less reliable. A good system helps the artist remember what matters.",
                    "So less time is spent asking what you did to this tree. And more time can be spent asking what this tree needs next.",
                    "Bonsai World exists to help connect the tree, the knowledge, the history and the next step."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )
}
