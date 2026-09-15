//
//  AdvancedTechniquesKnowledge.swift
//  Bonsai World
//
//  Knowledge → Bonsai Handbook → Advanced Techniques.
//  Decision layer for major work. How-to lives in Pruning, Wiring, Repotting and Design.
//

import Foundation

struct AdvancedTechniquesCallout: Identifiable, Hashable, Sendable {
    var id: String
    var title: String
    var body: String
}

struct AdvancedTechniquesSection: Identifiable, Hashable, Sendable {
    var id: String
    var heading: String
    var paragraphs: [String]
    var bullets: [String]
    var callouts: [AdvancedTechniquesCallout]
}

struct AdvancedTechniquesLesson: Identifiable, Hashable, Sendable {
    var id: String
    var number: Int
    var title: String
    var summary: String
    var sections: [AdvancedTechniquesSection]
}

enum AdvancedTechniquesKnowledge {
    static let chapterTitle = "Advanced Techniques"

    static let openingLine =
        "Structural development, correction and refinement for experienced bonsai artists."

    static let disclaimer =
        "Advanced techniques are not shortcuts. They depend on species, tree health, root strength, season, climate, previous work, material age and recovery capacity. Beginners may read to understand. Practice requires experience. Do not experiment unnecessarily on valuable trees."

    static let lessons: [AdvancedTechniquesLesson] = [
        overview,
        readinessAndRecovery,
        majorBending,
        sacrificeAndCycles,
        trunkChopsAndApex,
        grafting,
        hollowing,
        rootCorrection,
        combiningAndSequencing,
        speciesAndClimate,
        whenNotToAct,
        practice,
        quickGuides
    ]

    static func lesson(id: String) -> AdvancedTechniquesLesson? {
        lessons.first { $0.id == id }
    }

    // MARK: - 01 Overview

    private static let overview = AdvancedTechniquesLesson(
        id: "overview",
        number: 1,
        title: "Overview",
        summary: "Advanced techniques are not shortcuts. They are tools for solving specific problems and creating specific possibilities.",
        sections: [
            AdvancedTechniquesSection(
                id: "introduction",
                heading: "When basic work is not enough",
                paragraphs: [
                    "Basic bonsai techniques allow the artist to prune, wire, repot, maintain and develop. Those techniques live in Pruning, Wiring and Repotting in this Handbook. Advanced techniques become relevant when basic techniques alone cannot efficiently achieve the desired result.",
                    "They may involve major bending, structural cutting, grafting, root correction, trunk development, branch replacement or wood manipulation. Many share one characteristic: they can create irreversible changes. Planning becomes more important.",
                    "Advanced does not necessarily mean expensive, complex or visually dramatic. A technique becomes advanced when it requires a high level of understanding of tree biology, structural consequences, recovery, timing and long-term development. The artist should understand not only how, but why."
                ],
                bullets: [],
                callouts: [
                    AdvancedTechniquesCallout(
                        id: "not-shortcuts",
                        title: "Bonsai World principle",
                        body: "Advanced techniques are not shortcuts. They are tools for solving specific problems and creating specific possibilities."
                    ),
                    AdvancedTechniquesCallout(
                        id: "first-cut",
                        title: "Bonsai World principle",
                        body: "The more difficult a technique is to reverse, the more important the decision before the first cut."
                    )
                ]
            ),
            AdvancedTechniquesSection(
                id: "knowledge-practice",
                heading: "Knowledge, practice and experience",
                paragraphs: [
                    "Beginners should be able to read this chapter and understand the concepts. That is knowledge. Performing the work is practice. Judging whether the tree, the season and the design justify it is experience.",
                    "Do not encourage unnecessary experimentation on valuable trees."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )

    // MARK: - 02 Readiness & Recovery

    private static let readinessAndRecovery = AdvancedTechniquesLesson(
        id: "readiness",
        number: 2,
        title: "Readiness & Recovery",
        summary: "A healthy tree can recover from major work. A weakened tree may not. The work does not end when the tool stops.",
        sections: [
            AdvancedTechniquesSection(
                id: "before",
                heading: "Assessing tree readiness",
                paragraphs: [
                    "Before major work, evaluate overall health, growth strength, root health, recent repotting, recent pruning, recent styling, disease or pest pressure and seasonal condition.",
                    "Do not stack major stress events without considering recovery."
                ],
                bullets: [],
                callouts: [
                    AdvancedTechniquesCallout(
                        id: "healthy-recover",
                        title: "Bonsai World principle",
                        body: "A healthy tree can recover from major work. A weakened tree may not."
                    )
                ]
            ),
            AdvancedTechniquesSection(
                id: "recovery",
                heading: "Recovery is part of the technique",
                paragraphs: [
                    "Advanced techniques include the intervention and the recovery plan. Recovery planning may include appropriate placement, watering adjustments, protection where appropriate, reduced additional stress, monitoring and allowing sufficient growth.",
                    "A successful operation followed by poor recovery management is not a complete success. Watering and Tree Health sit beside that plan."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )

    // MARK: - 03 Major Bending

    private static let majorBending = AdvancedTechniquesLesson(
        id: "bending",
        number: 3,
        title: "Major Bending",
        summary: "Wiring covers how to apply force. This lesson asks whether force is justified. Splitting is high-risk, not a shortcut around a stiff branch.",
        sections: [
            AdvancedTechniquesSection(
                id: "branch",
                heading: "Major branch bending",
                paragraphs: [
                    "Major bends may be used to improve branch position, compress a design, create movement or change visual balance. Consider branch flexibility, wood type, branch age, existing defects and direction of force.",
                    "Major bending should be planned before force is applied. Wiring — Trunk & Heavy Bending covers heavy bending, guy wires and raffia as technique. Tools & Equipment covers raffia as equipment. This chapter asks whether the bend serves a future design that basic wiring cannot reach."
                ],
                bullets: [],
                callouts: []
            ),
            AdvancedTechniquesSection(
                id: "trunk",
                heading: "Trunk bending",
                paragraphs: [
                    "Trunk bending can create movement, improve proportion and change style possibilities. Risks include cracking, structural failure and damage to living tissue.",
                    "Not every trunk should be bent. Sometimes the better design is already present."
                ],
                bullets: [],
                callouts: []
            ),
            AdvancedTechniquesSection(
                id: "wrapping",
                heading: "Raffia and protective wrapping",
                paragraphs: [
                    "Raffia may support bark, help contain wood fibres and reduce uncontrolled splitting during major bends. Other wrapping systems may be combined where appropriate.",
                    "The goal is not maximum wrapping. The goal is appropriate structural support. These methods are not automatically necessary for normal branch wiring."
                ],
                bullets: [],
                callouts: []
            ),
            AdvancedTechniquesSection(
                id: "splitting",
                heading: "Splitting",
                paragraphs: [
                    "Splitting may be used conceptually to increase flexibility, change branch position or manipulate rigid material.",
                    "This is a high-risk technique. It should not be used simply because a branch is difficult to bend."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )

    // MARK: - 04 Sacrifice & Cycles

    private static let sacrificeAndCycles = AdvancedTechniquesLesson(
        id: "sacrifice",
        number: 4,
        title: "Sacrifice & Development Cycles",
        summary: "Temporary growth should have a permanent purpose. Taper is often grown, not carved. Pruning already covers clip and grow.",
        sections: [
            AdvancedTechniquesSection(
                id: "sacrifice",
                heading: "Sacrifice branches",
                paragraphs: [
                    "Sacrifice branches are one of the most important advanced development techniques. They may develop trunk thickness, taper, local swelling or branch thickness.",
                    "A sacrifice branch is grown for a purpose. It is not simply uncontrolled growth. Pruning — Development Pruning covers allowing untidy extension and removing the branch when the job is done. This chapter adds the exit strategy."
                ],
                bullets: [],
                callouts: []
            ),
            AdvancedTechniquesSection(
                id: "planning",
                heading: "Growth with an exit strategy",
                paragraphs: [
                    "Before allowing a sacrifice branch to grow, consider what area needs development, how much thickening is required, where swelling will occur, when the branch will be removed, and what scar may remain."
                ],
                bullets: [],
                callouts: [
                    AdvancedTechniquesCallout(
                        id: "permanent-purpose",
                        title: "Bonsai World principle",
                        body: "Temporary growth should have a permanent purpose."
                    )
                ]
            ),
            AdvancedTechniquesSection(
                id: "cycles",
                heading: "Grow, cut, repeat",
                paragraphs: [
                    "A major bonsai development pattern is grow, develop thickness, cut back, select new structure, repeat. Advanced development often requires cycles, not one-time transformations.",
                    "Pruning covers clip and grow as the pruning method. Design Guidelines cover the taper and apex the cycles should serve. This chapter asks whether the current cycle is still the right one."
                ],
                bullets: [],
                callouts: []
            ),
            AdvancedTechniquesSection(
                id: "taper",
                heading: "Creating taper",
                paragraphs: [
                    "Taper is often developed through growth, sacrifice branches, trunk development cycles and trunk reduction. Taper is often grown. Not carved."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )

    // MARK: - 05 Trunk Chops & Apex

    private static let trunkChopsAndApex = AdvancedTechniquesLesson(
        id: "trunk-chops",
        number: 5,
        title: "Trunk Chops & Apex",
        summary: "Do not treat trunk chopping as universally suitable. A new apex should be developed gradually, not as an instant visual solution.",
        sections: [
            AdvancedTechniquesSection(
                id: "chops",
                heading: "Changing the scale of the tree",
                paragraphs: [
                    "Trunk chops may be used to create taper, reduce height, build a new apex or change design direction. Consider timing, species response, bud availability, scar development and recovery.",
                    "Pruning covers heavy structural reduction. This chapter asks whether the chop is the least aggressive way to a better future tree. Do not treat trunk chopping as universally suitable."
                ],
                bullets: [],
                callouts: []
            ),
            AdvancedTechniquesSection(
                id: "apex",
                heading: "Building a new apex",
                paragraphs: [
                    "A new apex may be developed through existing branches, new shoots and directional growth. The new apex should be developed gradually.",
                    "Avoid instant visual solutions that ignore long-term taper. Design Guidelines cover one apex and how it is read from the front."
                ],
                bullets: [],
                callouts: []
            ),
            AdvancedTechniquesSection(
                id: "replacement",
                heading: "Branch replacement",
                paragraphs: [
                    "A poor branch is not always corrected by more wire. Sometimes the better solution is replacement: growing a new branch, developing a shoot, or grafting.",
                    "Time may produce a better result than force."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )

    // MARK: - 06 Grafting

    private static let grafting = AdvancedTechniquesLesson(
        id: "grafting",
        number: 6,
        title: "Grafting",
        summary: "The graft must become part of the tree. The goal is not merely attachment. Design Guidelines ask that the join disappear.",
        sections: [
            AdvancedTechniquesSection(
                id: "approach",
                heading: "Approach grafting",
                paragraphs: [
                    "Approach grafting adds structure through a living connection. Potential uses include adding branches, improving structure and creating root corrections.",
                    "The technique depends on living tissue connection, compatibility and healing. This chapter does not provide a universal grafting procedure."
                ],
                bullets: [],
                callouts: []
            ),
            AdvancedTechniquesSection(
                id: "thread",
                heading: "Thread grafting",
                paragraphs: [
                    "Thread grafting can place a branch through the trunk to add branches in precise locations and improve branch structure. Consider planning, branch selection, healing and aftercare.",
                    "This is advanced precision work — not a shortcut around missing buds."
                ],
                bullets: [],
                callouts: []
            ),
            AdvancedTechniquesSection(
                id: "root-graft",
                heading: "Root grafting",
                paragraphs: [
                    "Root grafting may correct missing roots, uneven nebari or visual imbalance. Long-term integration, species suitability and patience matter more than the day of attachment."
                ],
                bullets: [],
                callouts: []
            ),
            AdvancedTechniquesSection(
                id: "branch-graft",
                heading: "Branch grafting",
                paragraphs: [
                    "Grafting may be preferable to waiting for a suitable bud when placement control matters. Potential advantages include greater placement control and faster structural correction in suitable material.",
                    "The graft must become part of the tree. Design Guidelines: a graft should disappear, or sit low in the nebari. A visible graft collar is a design problem, not only a technical one."
                ],
                bullets: [],
                callouts: []
            ),
            AdvancedTechniquesSection(
                id: "species-graft",
                heading: "Species-specific grafting",
                paragraphs: [
                    "Different species may support different grafting approaches. Do not present one method as universal. Species Profiles belong in that judgement."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )

    // MARK: - 07 Hollowing

    private static let hollowing = AdvancedTechniquesLesson(
        id: "hollowing",
        number: 7,
        title: "Hollowing",
        summary: "The goal is believable structure, not maximum removal. Tools cover carving equipment. Design covers deadwood as character.",
        sections: [
            AdvancedTechniquesSection(
                id: "removing",
                heading: "Removing internal wood",
                paragraphs: [
                    "Hollowing may be used to create age, create movement, reduce visual heaviness or support advanced design concepts. Consider structural consequences, water management and wood preservation.",
                    "Tools & Equipment — Deadwood & Carving covers the instruments and why power is not a shortcut to artistic quality. Deadwood covers jin, shari, uro and whether the feature belongs. Design Guidelines cover jin and shari as visible character. This chapter asks whether removal serves the tree."
                ],
                bullets: [],
                callouts: []
            ),
            AdvancedTechniquesSection(
                id: "trunk-hollow",
                heading: "Trunk hollowing",
                paragraphs: [
                    "Hollowing may create visual age, naturalistic decay and increased trunk interest. Excessive hollowing can weaken the tree.",
                    "The goal is believable structure. Not maximum removal."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )

    // MARK: - 08 Root Correction

    private static let rootCorrection = AdvancedTechniquesLesson(
        id: "roots",
        number: 8,
        title: "Root Correction",
        summary: "Never pursue visual nebari improvement without considering tree survival. Repotting covers gradual root work over several seasons.",
        sections: [
            AdvancedTechniquesSection(
                id: "nebari",
                heading: "Improving future nebari",
                paragraphs: [
                    "Advanced approaches may involve root selection, root redirection, root grafting and layering techniques where appropriate.",
                    "Root work can strongly affect recovery. Never pursue visual improvement without considering tree survival. Repotting already teaches that advanced root work may take several repots. Do not try to solve every root problem in one session."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )

    // MARK: - 09 Combining & Sequencing

    private static let combiningAndSequencing = AdvancedTechniquesLesson(
        id: "sequencing",
        number: 9,
        title: "Combining & Sequencing",
        summary: "More techniques at once does not equal better work. The tree is allowed to change the plan.",
        sections: [
            AdvancedTechniquesSection(
                id: "combining",
                heading: "Managing multiple interventions",
                paragraphs: [
                    "Advanced work may combine pruning, wiring, grafting, carving and repotting. More techniques at once does not equal better work.",
                    "Teach stress management, recovery planning and priorities."
                ],
                bullets: [],
                callouts: []
            ),
            AdvancedTechniquesSection(
                id: "order",
                heading: "What should happen first?",
                paragraphs: [
                    "Think about structural decisions, root work, major bends and heavy pruning. Some work should be separated over time. The order depends on species, tree health and project goals."
                ],
                bullets: [],
                callouts: []
            ),
            AdvancedTechniquesSection(
                id: "design-change",
                heading: "When the original plan is wrong",
                paragraphs: [
                    "Advanced artists may change the design direction. Possible reasons include a new trunk line discovered, a better front identified, branch structure that changed, or a tree that aged differently than expected."
                ],
                bullets: [],
                callouts: [
                    AdvancedTechniquesCallout(
                        id: "tree-changes-plan",
                        title: "Bonsai World principle",
                        body: "The tree is allowed to change the plan."
                    )
                ]
            )
        ]
    )

    // MARK: - 10 Species & Climate

    private static let speciesAndClimate = AdvancedTechniquesLesson(
        id: "species-climate",
        number: 10,
        title: "Species & Climate",
        summary: "Never assume universal response. Technique does not exist outside conditions.",
        sections: [
            AdvancedTechniquesSection(
                id: "species",
                heading: "Never assume universal response",
                paragraphs: [
                    "Different species vary in back budding, healing, flexibility, root recovery and grafting response. Advanced technique must always be interpreted through species knowledge.",
                    "Species Profiles belong in that judgement. Pruning and Wiring already refuse one method for every species. This chapter refuses one advanced technique for every tree."
                ],
                bullets: [],
                callouts: []
            ),
            AdvancedTechniquesSection(
                id: "climate",
                heading: "Technique does not exist outside conditions",
                paragraphs: [
                    "Timing and recovery depend on climate, temperature, growing season and local environment. Avoid presenting one calendar as universal."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )

    // MARK: - 11 When Not To Act

    private static let whenNotToAct = AdvancedTechniquesLesson(
        id: "when-not",
        number: 11,
        title: "When Not To Act",
        summary: "Skill includes knowing when not to act. The most advanced decision may be to wait.",
        sections: [
            AdvancedTechniquesSection(
                id: "avoid",
                heading: "When not to use an advanced technique",
                paragraphs: [
                    "Avoid intervention when tree health is uncertain, recovery capacity is low, design goals are unclear, the problem may improve naturally, or a less aggressive technique exists."
                ],
                bullets: [],
                callouts: [
                    AdvancedTechniquesCallout(
                        id: "not-to-act",
                        title: "Bonsai World principle",
                        body: "Skill includes knowing when not to act."
                    )
                ]
            ),
            AdvancedTechniquesSection(
                id: "failure",
                heading: "Learning from unsuccessful work",
                paragraphs: [
                    "Evaluate failures through timing, tree health, technique choice, force, recovery and species response. Do not simply conclude that the technique failed. Ask why."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )

    // MARK: - 12 Practice

    private static let practice = AdvancedTechniquesLesson(
        id: "practice",
        number: 12,
        title: "Practice",
        summary: "Ask what problem you are solving. Then ask whether you are improving the tree — or simply doing work.",
        sections: [
            AdvancedTechniquesSection(
                id: "mistakes",
                heading: "Common advanced technique mistakes",
                paragraphs: [
                    "Using major techniques to create unnecessary drama. Working on weak trees. Combining too much stress at once. Forcing bends beyond the material. Removing too much wood.",
                    "Ignoring recovery planning. Copying techniques without understanding species response. Making irreversible changes without a design plan. Treating advanced tools as proof of advanced skill. Confusing dramatic intervention with artistic improvement."
                ],
                bullets: [],
                callouts: []
            ),
            AdvancedTechniquesSection(
                id: "framework",
                heading: "Advanced decision framework",
                paragraphs: [
                    "Before performing major work, answer these questions. If you cannot, wait."
                ],
                bullets: [
                    "What problem am I solving?",
                    "Is this technique necessary?",
                    "Is there a less aggressive alternative?",
                    "Is the tree healthy enough?",
                    "Is the timing appropriate?",
                    "What happens if this fails?",
                    "What is the recovery plan?",
                    "Will this improve the tree in ten years?",
                    "Am I improving the tree — or simply doing work?"
                ],
                callouts: []
            ),
            AdvancedTechniquesSection(
                id: "paths",
                heading: "Beginner, intermediate, advanced and professional",
                paragraphs: [
                    "Beginner — understand what advanced techniques exist, why they are used, and why patience matters. This is knowledge, not a licence to practise on valuable trees.",
                    "Intermediate — sacrifice branches, development cycles, moderate structural work and planning. Pruning and Wiring are the practice surfaces.",
                    "Advanced — major bends, grafting, structural correction and complex sequencing.",
                    "Professional — material-specific decisions, precision, long-term design and recovery management."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )

    // MARK: - 13 Quick Guides

    private static let quickGuides = AdvancedTechniquesLesson(
        id: "quick-guides",
        number: 13,
        title: "Quick Guides",
        summary: "The most experienced artist is not the one who can perform the greatest number of techniques. It is the one who knows when to let the tree grow.",
        sections: [
            AdvancedTechniquesSection(
                id: "cards",
                heading: "Knowledge cards",
                paragraphs: [],
                bullets: [],
                callouts: [
                    AdvancedTechniquesCallout(
                        id: "card-controlled",
                        title: "Advanced means controlled",
                        body: "More difficult work requires better decisions."
                    ),
                    AdvancedTechniquesCallout(
                        id: "card-recovery",
                        title: "Plan recovery first",
                        body: "The operation is only half of the technique."
                    ),
                    AdvancedTechniquesCallout(
                        id: "card-grow",
                        title: "Grow for a purpose",
                        body: "Sacrifice growth should solve a future problem."
                    ),
                    AdvancedTechniquesCallout(
                        id: "card-irreversible",
                        title: "Irreversible means important",
                        body: "Think longer before permanent change."
                    ),
                    AdvancedTechniquesCallout(
                        id: "card-wait",
                        title: "Waiting is a technique",
                        body: "Sometimes the correct intervention is no intervention."
                    )
                ]
            ),
            AdvancedTechniquesSection(
                id: "connections",
                heading: "Connections to other Bonsai World knowledge",
                paragraphs: [
                    "Pruning — development pruning, sacrifice branches, clip and grow, heavy pruning and taper.",
                    "Wiring — trunk and heavy bending, guy wires and raffia.",
                    "Repotting — root selection, nebari and gradual root correction.",
                    "Deadwood — jin, shari, uro and whether carving should happen. Design Guidelines — taper, apex, grafting as a visual join, and deadwood as character.",
                    "Bonsai Artistry & the Bonsai Eye — which possibility technique has created, including waiting.",
                    "Air Layering — creating new structure from living tissue.",
                    "Propagation — seeds, seedlings and cuttings; grafting stays in this chapter.",
                    "Tools & Equipment — carving, rotary and power tools; raffia as equipment.",
                    "Bonsai Material & Sourcing — whether the material justifies major work.",
                    "Species Profiles — species-specific response.",
                    "Tree Health — recovery and stress management.",
                    "Bonsai Collection Management — grouping recovery trees and not stacking collection-wide work."
                ],
                bullets: [],
                callouts: []
            ),
            AdvancedTechniquesSection(
                id: "planner",
                heading: "Future: Advanced Project Planner",
                paragraphs: [
                    "A future tool could let the user document tree, species, current health, planned intervention and previous major work, then structure before work, during work, recovery and the next development phase.",
                    "It should not encourage unnecessary intervention. It should ask what problem you are solving before recommending what technique to use."
                ],
                bullets: [],
                callouts: []
            ),
            AdvancedTechniquesSection(
                id: "philosophy",
                heading: "Bonsai World philosophy",
                paragraphs: [
                    "Advanced bonsai techniques are not defined by how dramatic they appear. They are defined by how well they serve the tree. A major bend is successful only when it improves the future design. A graft is successful only when it becomes part of the tree. A trunk chop is successful only when it creates a better future structure.",
                    "The most experienced artist is not the one who can perform the greatest number of techniques. It is the one who understands which technique is necessary, which is possible, which is too risky — and when the best decision is simply to let the tree grow."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )
}
