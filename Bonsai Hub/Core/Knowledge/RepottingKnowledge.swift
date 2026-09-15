//
//  RepottingKnowledge.swift
//  Bonsai World
//
//  Knowledge → Bonsai Handbook → Repotting.
//  Roots, soil and timing — not a fixed calendar of pot changes.
//

import Foundation

struct RepottingKnowledgeCallout: Identifiable, Hashable, Sendable {
    var id: String
    var title: String
    var body: String
}

struct RepottingKnowledgeSection: Identifiable, Hashable, Sendable {
    var id: String
    var heading: String
    var paragraphs: [String]
    var bullets: [String]
    var callouts: [RepottingKnowledgeCallout]
}

struct RepottingKnowledgeLesson: Identifiable, Hashable, Sendable {
    var id: String
    var number: Int
    var title: String
    var summary: String
    var sections: [RepottingKnowledgeSection]
    var opensFertilizerGuides: Bool

    init(
        id: String,
        number: Int,
        title: String,
        summary: String,
        opensFertilizerGuides: Bool = false,
        sections: [RepottingKnowledgeSection]
    ) {
        self.id = id
        self.number = number
        self.title = title
        self.summary = summary
        self.opensFertilizerGuides = opensFertilizerGuides
        self.sections = sections
    }
}

enum RepottingKnowledge {
    static let chapterTitle = "Repotting"

    static let openingLine =
        "Understanding roots, soil and timing — from the first repot to advanced root development and long-term bonsai refinement."

    static let disclaimer =
        "Species, health, roots, soil, pot, climate and the next development goal change the answer. Treat this as decision support — not a schedule of years between pots."

    static let lessons: [RepottingKnowledgeLesson] = [
        overview,
        rootSystem,
        whenToRepot,
        developmentAndRefinement,
        preparing,
        readingRoots,
        rootWork,
        soilAndPot,
        positioning,
        aftercare,
        species,
        practice,
        quickGuides
    ]

    static func lesson(id: String) -> RepottingKnowledgeLesson? {
        lessons.first { $0.id == id }
    }

    // MARK: - 01 Overview

    private static let overview = RepottingKnowledgeLesson(
        id: "overview",
        number: 1,
        title: "Overview",
        summary: "The visible bonsai is only part of the tree. Roots decide much of what is possible above the soil.",
        sections: [
            RepottingKnowledgeSection(
                id: "introduction",
                heading: "Repotting bonsai",
                paragraphs: [
                    "The visible bonsai is only part of the tree. Below the soil is a root system that determines much of what is possible above the soil.",
                    "Roots influence tree health, growth strength, branch development, ramification, leaf size, water management, nutrient uptake, stability and long-term refinement.",
                    "Repotting is not simply maintenance. It is one of the most important moments in the development of a bonsai. Years of visible structure can still be limited by poor root management."
                ],
                bullets: [],
                callouts: [
                    RepottingKnowledgeCallout(
                        id: "below",
                        title: "Bonsai World principle",
                        body: "To understand the future of the tree, look below the surface."
                    )
                ]
            ),
            RepottingKnowledgeSection(
                id: "what",
                heading: "What is repotting?",
                paragraphs: [
                    "Bonsai repotting may involve removing the tree from the pot, evaluating the root system, removing old or unsuitable soil, root pruning, root selection, soil replacement, pot replacement, repositioning, securing the tree and managing recovery.",
                    "Not every repot requires the same amount of root work. There is a major difference between minor root maintenance and major root development. The appropriate level of work depends on the tree."
                ],
                bullets: [],
                callouts: []
            ),
            RepottingKnowledgeSection(
                id: "why",
                heading: "Why do bonsai need repotting?",
                paragraphs: [
                    "Root development improves the structure and quality of the root system. Soil management replaces soil that has broken down, become compacted, or lost appropriate drainage and air space.",
                    "Root control keeps the system suitable for the pot and the tree. Tree development improves future growth. Nebari work develops a stronger and more natural surface root system. Refinement maintains a mature and highly refined bonsai."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )

    // MARK: - 02 Root system

    private static let rootSystem = RepottingKnowledgeLesson(
        id: "root-system",
        number: 2,
        title: "The Root System",
        summary: "A good bonsai root system is not simply small roots. Quality depends on stage, species and what those roots will do next.",
        sections: [
            RepottingKnowledgeSection(
                id: "working-with",
                heading: "Understanding what you are working with",
                paragraphs: [
                    "Fine feeder roots, larger structural roots, surface roots, long roots, circling roots, crossing roots and downward-growing roots are not the same job.",
                    "A good bonsai root system is not simply small roots. The ideal depends on development stage and species. A developing tree may require different root priorities from a refined bonsai."
                ],
                bullets: [],
                callouts: [
                    RepottingKnowledgeCallout(
                        id: "quality",
                        title: "Bonsai World principle",
                        body: "Root quality is not measured only by how much root mass is removed."
                    )
                ]
            ),
            RepottingKnowledgeSection(
                id: "health",
                heading: "Roots and tree health",
                paragraphs: [
                    "Roots support water uptake, nutrient uptake, growth, recovery and overall vigor. Possible signs of root problems include poor growth, declining vigor, water behaving unusually, soil remaining wet too long or drying unusually fast, root congestion and poor stability.",
                    "Do not diagnose every weak tree as having a root problem. Root evaluation must be part of a broader assessment of tree health."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )

    // MARK: - 03 When

    private static let whenToRepot = RepottingKnowledgeLesson(
        id: "when",
        number: 3,
        title: "When to Repot",
        summary: "Read the tree, the roots and the soil. Different trees have different cycles. Understand the growth cycle before disturbing roots.",
        sections: [
            RepottingKnowledgeSection(
                id: "reading",
                heading: "Reading the tree",
                paragraphs: [
                    "Bonsai should not automatically be repotted because it has been two years. Evaluate root development, soil condition, water behaviour, tree growth, pot size and development stage.",
                    "Evaluation may be needed when water does not penetrate properly, soil remains saturated too long, soil has significantly broken down, the root system has become congested, growth has declined without another obvious explanation, or the tree has outgrown the purpose of its current pot."
                ],
                bullets: [],
                callouts: [
                    RepottingKnowledgeCallout(
                        id: "not-calendar",
                        title: "Bonsai World principle",
                        body: "Repot according to the tree's condition, not a universal calendar."
                    )
                ]
            ),
            RepottingKnowledgeSection(
                id: "cycles",
                heading: "Different trees, different schedules",
                paragraphs: [
                    "Frequency depends on species, age, development stage, growth strength, soil, pot size and climate.",
                    "Young developing material often requires different root management from a mature bonsai. Mature trees may need more careful maintenance, less aggressive intervention and longer intervals. There is no universal schedule."
                ],
                bullets: [],
                callouts: []
            ),
            RepottingKnowledgeSection(
                id: "timing",
                heading: "When to perform root work",
                paragraphs: [
                    "Timing depends on species, climate, growth cycle, tree health and the type of root work. Separate major repotting from minor maintenance.",
                    "Species-specific timing should connect to Species Profiles. One seasonal rule is not correct for all bonsai."
                ],
                bullets: [],
                callouts: [
                    RepottingKnowledgeCallout(
                        id: "cycle",
                        title: "Key principle",
                        body: "Understand the growth cycle before disturbing the roots."
                    )
                ]
            )
        ]
    )

    // MARK: - 04 Development & refinement

    private static let developmentAndRefinement = RepottingKnowledgeLesson(
        id: "development-refinement",
        number: 4,
        title: "Development & Refinement",
        summary: "Building roots is not the same as maintaining a mature system. The goal is not always to make the root system smaller.",
        sections: [
            RepottingKnowledgeSection(
                id: "development",
                heading: "Roots during tree development",
                paragraphs: [
                    "Trees in development may need improved root structure, correction of unsuitable roots, encouragement of fine roots, preparation of future nebari, or a move toward a more suitable container.",
                    "Development may sometimes require allowing roots to grow strongly. Do not assume that maximum root reduction is always beneficial."
                ],
                bullets: [],
                callouts: [
                    RepottingKnowledgeCallout(
                        id: "not-smaller",
                        title: "Bonsai World principle",
                        body: "During development, the goal is not always to make the root system smaller."
                    )
                ]
            ),
            RepottingKnowledgeSection(
                id: "refinement",
                heading: "Maintaining a mature bonsai",
                paragraphs: [
                    "Refined bonsai require a different mindset. Priorities may include maintaining fine roots, preserving established structure, maintaining soil quality, protecting nebari and avoiding unnecessary stress.",
                    "Aggressive root changes may be less appropriate once the tree has reached a high level of refinement."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )

    // MARK: - 05 Preparing

    private static let preparing = RepottingKnowledgeLesson(
        id: "preparing",
        number: 5,
        title: "Preparing",
        summary: "Know the goal before the tree leaves the pot. Workspace, tools, soil, pot and wire are part of the decision, not afterthoughts.",
        sections: [
            RepottingKnowledgeSection(
                id: "before",
                heading: "Preparation before the tree leaves the pot",
                paragraphs: [
                    "Prepare the workspace, tools, soil, pot and wire. Plan the work. Know what you are trying to achieve before exposing the roots."
                ],
                bullets: [
                    "Soil replacement",
                    "Root maintenance",
                    "Root correction",
                    "Nebari development",
                    "Pot change",
                    "Tree repositioning"
                ],
                callouts: [
                    RepottingKnowledgeCallout(
                        id: "know-goal",
                        title: "Bonsai World principle",
                        body: "Know what you are trying to achieve before exposing the roots."
                    )
                ]
            )
        ]
    )

    // MARK: - 06 Reading roots

    private static let readingRoots = RepottingKnowledgeLesson(
        id: "reading-roots",
        number: 6,
        title: "Reading the Root System",
        summary: "Remove the tree carefully, then observe. Do not begin cutting simply because the roots are visible.",
        sections: [
            RepottingKnowledgeSection(
                id: "removal",
                heading: "Removing the tree from the pot",
                paragraphs: [
                    "Remove the tree safely. Release securing wires where necessary. Avoid unnecessary damage. Support the tree correctly.",
                    "Once removed, do not immediately begin cutting roots. First observe. Study root distribution, density, health, soil condition and structural roots. The first minutes after removal may provide valuable information about development."
                ],
                bullets: [],
                callouts: []
            ),
            RepottingKnowledgeSection(
                id: "observe",
                heading: "Observation before cutting",
                paragraphs: [
                    "Examine where roots originate, their thickness, direction, density, surface structure and fine-root distribution."
                ],
                bullets: [
                    "Which roots contribute to future development?",
                    "Which roots create problems?",
                    "Which roots can be reduced?",
                    "Which roots should be retained?",
                    "Are there gaps in the root system?",
                    "Is the root structure balanced around the trunk?"
                ],
                callouts: []
            )
        ]
    )

    // MARK: - 07 Root work

    private static let rootWork = RepottingKnowledgeLesson(
        id: "root-work",
        number: 7,
        title: "Root Work",
        summary: "Prune and select with purpose. Nebari can be developed over years. Do not try to solve every root problem in one session.",
        sections: [
            RepottingKnowledgeSection(
                id: "pruning",
                heading: "Root pruning",
                paragraphs: [
                    "Root pruning may maintain the tree in a container, improve structure, encourage fine roots, remove unsuitable roots or prepare the tree for a different pot.",
                    "It is not automatically a matter of removing as much root as possible. The amount of work depends on species, tree health, the current root system, development stage and seasonal timing."
                ],
                bullets: [],
                callouts: [
                    RepottingKnowledgeCallout(
                        id: "purpose",
                        title: "Bonsai World principle",
                        body: "Remove roots with purpose."
                    )
                ]
            ),
            RepottingKnowledgeSection(
                id: "selection",
                heading: "Root selection",
                paragraphs: [
                    "Selection may consider direction, thickness, position, surface structure and future nebari. Problems include crossing roots, roots growing against the desired design, excessively dominant roots, unbalanced distribution and roots that create visible inverse taper.",
                    "Advanced root work may take place gradually over several repots. Do not try to solve every root problem in one session."
                ],
                bullets: [],
                callouts: []
            ),
            RepottingKnowledgeSection(
                id: "nebari",
                heading: "Nebari development",
                paragraphs: [
                    "Surface roots matter for stability, age impression, visual balance and tree character. Consider radial distribution, thickness, taper, surface visibility and species differences.",
                    "Do not force every species toward exactly the same nebari appearance. Natural root character differs."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )

    // MARK: - 08 Soil & pot

    private static let soilAndPot = RepottingKnowledgeLesson(
        id: "soil-pot",
        number: 8,
        title: "Soil & Pot",
        summary: "How much old soil to remove, what growing environment to choose, and how the container should match the tree's current purpose.",
        sections: [
            RepottingKnowledgeSection(
                id: "old-soil",
                heading: "Removing old soil",
                paragraphs: [
                    "How much soil to remove depends on species, tree health, the root work required, soil condition and development stage. Work gradually. Protect fine roots. Avoid unnecessary damage.",
                    "Removing all old soil is not a universal bonsai rule. Different species and situations may require different approaches."
                ],
                bullets: [],
                callouts: []
            ),
            RepottingKnowledgeSection(
                id: "soil",
                heading: "Soil and repotting",
                paragraphs: [
                    "Soil selection depends on species, climate, watering habits, development stage and pot size. Repotting is an opportunity to improve the growing environment — with understanding.",
                    "Do not assume every bonsai needs the same substrate. Soil & Substrate in this Handbook explains substrate as a system."
                ],
                bullets: [],
                callouts: []
            ),
            RepottingKnowledgeSection(
                id: "pot",
                heading: "Pot preparation",
                paragraphs: [
                    "Check drainage holes, drainage protection, securing points, cleanliness and pot size. The pot should support the current purpose of the tree — development, transition, refinement or final presentation.",
                    "Pots & Containers in this Handbook cover proportion and the difference between a training pot and a display pot."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )

    // MARK: - 09 Positioning

    private static let positioning = RepottingKnowledgeLesson(
        id: "positioning",
        number: 9,
        title: "Positioning & Securing",
        summary: "Where the tree sits is part of the design. Stability during recovery is part of the root work.",
        sections: [
            RepottingKnowledgeSection(
                id: "sit",
                heading: "Where the tree sits matters",
                paragraphs: [
                    "Positioning includes front, angle, height, visual balance and root presentation. A tree may look different after a slight rotation, a small change in planting angle or a change in height.",
                    "Do not treat positioning as an afterthought. Repotting may be an important opportunity to improve the relationship between tree, nebari, pot and design."
                ],
                bullets: [],
                callouts: []
            ),
            RepottingKnowledgeSection(
                id: "secure",
                heading: "Securing the tree",
                paragraphs: [
                    "Movement in the pot can disturb roots, damage new root development and reduce stability. Use an appropriate securing method, avoid unnecessary pressure, and check stability.",
                    "The goal is to secure the tree without damaging it."
                ],
                bullets: [],
                callouts: []
            ),
            RepottingKnowledgeSection(
                id: "adding-soil",
                heading: "Adding soil",
                paragraphs: [
                    "Fill root spaces, avoid large air pockets and maintain appropriate soil structure. Work soil carefully around roots. Avoid excessive force.",
                    "Correct technique depends on root structure, soil type and tree type."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )

    // MARK: - 10 Aftercare

    private static let aftercare = RepottingKnowledgeLesson(
        id: "aftercare",
        number: 10,
        title: "Aftercare",
        summary: "Repotting is not finished when the tree returns to the pot. Water, rest, fertilizing, pruning and wiring all add to total stress.",
        opensFertilizerGuides: true,
        sections: [
            RepottingKnowledgeSection(
                id: "first-water",
                heading: "Watering after repotting",
                paragraphs: [
                    "Watering after repotting helps settle the soil and hydrate the root environment. Aftercare watering does not follow one universal formula.",
                    "Future watering depends on soil, climate, tree condition and recovery. Care → Watering is the practical watering surface in the programme."
                ],
                bullets: [],
                callouts: []
            ),
            RepottingKnowledgeSection(
                id: "recovery",
                heading: "Recovery after root work",
                paragraphs: [
                    "Aftercare should consider tree health, the amount of root work, species, climate and exposure. Protect from unnecessary stress, manage water, monitor recovery and avoid additional major work immediately.",
                    "There is no universal aftercare schedule."
                ],
                bullets: [],
                callouts: [
                    RepottingKnowledgeCallout(
                        id: "not-finished",
                        title: "Bonsai World principle",
                        body: "Repotting is not finished when the tree returns to the pot."
                    )
                ]
            ),
            RepottingKnowledgeSection(
                id: "fertilizing",
                heading: "Repotting and fertilizing",
                paragraphs: [
                    "Fertilizing after repotting depends on species, tree health, root work and growth response.",
                    "Use the existing Bonsai World Fertilizer Guide for practical feeding recommendations. This chapter does not replace those recommendations."
                ],
                bullets: [],
                callouts: []
            ),
            RepottingKnowledgeSection(
                id: "pruning",
                heading: "Repotting and pruning",
                paragraphs: [
                    "Major root work and major top pruning both affect the tree. The combination depends on species, tree strength, root work and growth condition.",
                    "Avoid universal rules. Evaluate total workload, tree health and species response together."
                ],
                bullets: [],
                callouts: []
            ),
            RepottingKnowledgeSection(
                id: "wiring",
                heading: "Repotting and wiring",
                paragraphs: [
                    "Significant styling, wiring and root work may all create stress. Consider whether work should be combined or staged over time. The answer depends on the individual tree."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )

    // MARK: - 11 Species

    private static let species = RepottingKnowledgeLesson(
        id: "species",
        number: 11,
        title: "Species",
        summary: "Repot the species you have, not a generic bonsai. Deciduous, conifer, evergreen broadleaf and tropical trees recover differently.",
        sections: [
            RepottingKnowledgeSection(
                id: "deciduous",
                heading: "Deciduous bonsai",
                paragraphs: [
                    "Fine roots, seasonal growth and root recovery all matter. Species still differ within the deciduous group."
                ],
                bullets: [],
                callouts: []
            ),
            RepottingKnowledgeSection(
                id: "conifers",
                heading: "Conifers",
                paragraphs: [
                    "Root work may require different consideration depending on species, root sensitivity and growth cycle. Do not copy a deciduous approach onto a pine or juniper."
                ],
                bullets: [],
                callouts: []
            ),
            RepottingKnowledgeSection(
                id: "evergreen",
                heading: "Evergreen broadleaf bonsai",
                paragraphs: [
                    "Species-specific differences in root recovery, soil preference and seasonal activity still decide the work. Species Profiles should carry more specific guidance where it exists."
                ],
                bullets: [],
                callouts: []
            ),
            RepottingKnowledgeSection(
                id: "tropical",
                heading: "Tropical bonsai",
                paragraphs: [
                    "Active growth and climate considerations change both timing and aftercare. A temperate calendar is not the right frame."
                ],
                bullets: [],
                callouts: [
                    RepottingKnowledgeCallout(
                        id: "species-you-have",
                        title: "Key principle",
                        body: "Repot the species you have, not a generic bonsai."
                    )
                ]
            )
        ]
    )

    // MARK: - 12 Practice

    private static let practice = RepottingKnowledgeLesson(
        id: "practice",
        number: 12,
        title: "Practice",
        summary: "Beginner mistakes, roots developed over years, a decision framework, and what to learn at each level.",
        sections: [
            RepottingKnowledgeSection(
                id: "mistakes",
                heading: "Common beginner mistakes",
                paragraphs: [
                    "Repotting according to a fixed calendar. Removing too many roots, or removing them without evaluating their future role. Using unsuitable soil. Failing to secure the tree.",
                    "Combining too much major work without considering total stress. Choosing a pot based only on appearance. Assuming every tree should have the same root structure. Ignoring soil condition. Treating aftercare as an afterthought."
                ],
                bullets: [],
                callouts: []
            ),
            RepottingKnowledgeSection(
                id: "advanced",
                heading: "Advanced root development",
                paragraphs: [
                    "Advanced root work considers future nebari, future pot selection, long-term trunk stability, root taper and surface root structure. Some decisions require years.",
                    "A root problem does not always need to be corrected immediately. Sometimes the correct strategy is observe, plan, develop and correct gradually."
                ],
                bullets: [],
                callouts: [
                    RepottingKnowledgeCallout(
                        id: "years",
                        title: "Bonsai World principle",
                        body: "Roots can be developed over years just like branches."
                    )
                ]
            ),
            RepottingKnowledgeSection(
                id: "future",
                heading: "Repotting for the future",
                paragraphs: [
                    "Before repotting, ask what this tree should become. Then consider whether the current root system, pot and soil support that future, what root work is necessary now, and what should wait."
                ],
                bullets: [],
                callouts: []
            ),
            RepottingKnowledgeSection(
                id: "observe-first",
                heading: "Observe before action",
                paragraphs: [
                    "Before repotting, evaluate tree health, growth, soil, water behaviour, pot size and development stage. After removing the tree, evaluate root distribution, health, structure and fine-root density.",
                    "Do not begin cutting simply because the tree is already out of the pot."
                ],
                bullets: [],
                callouts: []
            ),
            RepottingKnowledgeSection(
                id: "framework",
                heading: "A practical decision framework",
                paragraphs: [
                    "Work through the steps in order. Plan aftercare before you finish."
                ],
                bullets: [
                    "Step 1 — Why is the tree being repotted?",
                    "Step 2 — Is the timing appropriate for the species and tree?",
                    "Step 3 — Is the tree healthy enough?",
                    "Step 4 — What does the current root system reveal?",
                    "Step 5 — What root work is necessary?",
                    "Step 6 — What root work can wait?",
                    "Step 7 — Is the pot suitable?",
                    "Step 8 — Is the soil suitable?",
                    "Step 9 — Secure the tree correctly.",
                    "Step 10 — Plan aftercare before finishing."
                ],
                callouts: []
            ),
            RepottingKnowledgeSection(
                id: "paths",
                heading: "Beginner, intermediate, advanced",
                paragraphs: [
                    "Beginner: why bonsai are repotted, basic root awareness, soil preparation, pot preparation, tree securing and basic aftercare.",
                    "Intermediate: root selection, development versus refinement, nebari, soil adjustment and reading root systems.",
                    "Advanced: long-term root development, advanced nebari planning, root correction over multiple years, refined root maintenance and integrating root work with total tree development."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )

    // MARK: - 13 Quick Guides

    private static let quickGuides = RepottingKnowledgeLesson(
        id: "quick-guides",
        number: 13,
        title: "Quick Guides",
        summary: "Short cards, troubleshooting, links to other Bonsai World knowledge, and the principle that closes the chapter.",
        sections: [
            RepottingKnowledgeSection(
                id: "cards",
                heading: "Quick knowledge cards",
                paragraphs: [],
                bullets: [],
                callouts: [
                    RepottingKnowledgeCallout(
                        id: "card-below",
                        title: "Look below the surface",
                        body: "The root system is part of the bonsai design."
                    ),
                    RepottingKnowledgeCallout(
                        id: "card-purpose",
                        title: "Repot with purpose",
                        body: "Know why the tree is being repotted before removing it from the pot."
                    ),
                    RepottingKnowledgeCallout(
                        id: "card-calendar",
                        title: "Do not follow a fixed calendar",
                        body: "Read the tree, the roots and the soil."
                    ),
                    RepottingKnowledgeCallout(
                        id: "card-remove",
                        title: "Remove roots with purpose",
                        body: "More root removal is not automatically better."
                    ),
                    RepottingKnowledgeCallout(
                        id: "card-secure",
                        title: "Secure the tree",
                        body: "Roots cannot establish properly if the tree continues to move."
                    ),
                    RepottingKnowledgeCallout(
                        id: "card-years",
                        title: "Think long-term",
                        body: "Some root problems are solved over several years."
                    )
                ]
            ),
            RepottingKnowledgeSection(
                id: "wet",
                heading: "The soil remains wet for too long",
                paragraphs: [
                    "Water that will not leave is a system problem, not only a calendar problem."
                ],
                bullets: [
                    "Soil condition",
                    "Root health",
                    "Pot drainage",
                    "Environmental conditions"
                ],
                callouts: []
            ),
            RepottingKnowledgeSection(
                id: "unstable",
                heading: "The tree is unstable in the pot",
                paragraphs: [
                    "Movement after the repot disturbs new roots."
                ],
                bullets: [
                    "Securing method",
                    "Root support",
                    "Pot fit"
                ],
                callouts: []
            ),
            RepottingKnowledgeSection(
                id: "weak-growth",
                heading: "Growth is weak after repotting",
                paragraphs: [
                    "The tree may be answering the work, the timing, or the condition it was already in."
                ],
                bullets: [
                    "Amount of root work",
                    "Tree health before repotting",
                    "Timing",
                    "Species",
                    "Aftercare"
                ],
                callouts: []
            ),
            RepottingKnowledgeSection(
                id: "runoff",
                heading: "Water runs off without penetrating",
                paragraphs: [
                    "The surface may no longer accept water the way a fresh substrate would."
                ],
                bullets: [
                    "Soil structure",
                    "Soil breakdown",
                    "Root congestion"
                ],
                callouts: []
            ),
            RepottingKnowledgeSection(
                id: "poor-recovery",
                heading: "The tree recovered poorly",
                paragraphs: [
                    "Poor recovery is a diagnosis, not an instruction to work the roots harder next time."
                ],
                bullets: [
                    "Root work intensity",
                    "Timing",
                    "Species requirements",
                    "Tree condition before repotting",
                    "Environmental stress"
                ],
                callouts: []
            ),
            RepottingKnowledgeSection(
                id: "connections",
                heading: "Connections to other Bonsai World knowledge",
                paragraphs: [
                    "Soil & Substrate — soil selection, substrate structure and water management.",
                    "Pots & Containers — pot selection, proportion, and development versus refinement.",
                    "Fertilizing — recovery, growth and root development. Use Fertilizer Guides for practical recommendations.",
                    "Watering — post-repotting water management and soil moisture.",
                    "Pruning — total tree stress and development planning.",
                    "Design Guidelines — planting angle, nebari, visual balance and long-term development.",
                    "Species Profiles — species-specific timing, root sensitivity and soil preferences.",
                    "Tree Health — root health, stress and recovery.",
                    "Tools & Equipment — root tools, soil tools and sieves.",
                    "Advanced Techniques — root correction, grafting and sequencing with other major work.",
                    "Bonsai Collection Management — planning repotting so the season does not exceed available time.",
                    "Bonsai Material & Sourcing — yamadori recovery: avoid unnecessary root disturbance until the tree can support more change.",
                    "Propagation — transitioning young material when the root system is ready.",
                    "Seasonal Care & Protection — why “repot in March” is not a worldwide rule."
                ],
                bullets: [],
                callouts: []
            ),
            RepottingKnowledgeSection(
                id: "visuals",
                heading: "Visual learning",
                paragraphs: [
                    "Future visual content should explain decisions: healthy versus problematic roots, root selection, nebari development, before and after, pot preparation, securing, soil distribution, development roots versus refined roots, and positioning in the pot.",
                    "Do not use visuals merely as decoration."
                ],
                bullets: [],
                callouts: []
            ),
            RepottingKnowledgeSection(
                id: "philosophy",
                heading: "Bonsai World philosophy",
                paragraphs: [
                    "Repotting is not about putting a tree into a new pot. It is about understanding what is happening beneath the tree.",
                    "The roots support every future branch, every new leaf, every period of growth and every stage of refinement.",
                    "A bonsai artist who understands roots does not simply maintain a tree. They develop its future from the ground up."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )
}
