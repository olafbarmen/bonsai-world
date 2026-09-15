//
//  ArtistryKnowledge.swift
//  Bonsai World
//
//  Knowledge → Bonsai Handbook → Bonsai Artistry & the Bonsai Eye.
//  How to see and evaluate. Structural checklists live in Design Guidelines.
//

import Foundation

struct ArtistryCallout: Identifiable, Hashable, Sendable {
    var id: String
    var title: String
    var body: String
}

struct ArtistrySection: Identifiable, Hashable, Sendable {
    var id: String
    var heading: String
    var paragraphs: [String]
    var bullets: [String]
    var callouts: [ArtistryCallout]
}

struct ArtistryLesson: Identifiable, Hashable, Sendable {
    var id: String
    var number: Int
    var title: String
    var summary: String
    var sections: [ArtistrySection]
}

enum ArtistryKnowledge {
    static let chapterTitle = "Bonsai Artistry & the Bonsai Eye"

    static let openingLine =
        "Learning to see, evaluate and improve bonsai design."

    static let disclaimer =
        "This chapter trains the eye. Design Guidelines remain the structural checklist. Pruning, Wiring and Advanced Techniques remain the hands. Species, material and stage still decide what is possible. There is no universal look."

    static let lessons: [ArtistryLesson] = [
        overview,
        seeTheTree,
        proportion,
        trunk,
        primaryStructure,
        balanceAndAsymmetry,
        movementAndSpace,
        simplicityAndCharacter,
        naturalismAndDesign,
        developingTheEye,
        evaluating,
        practice,
        quickGuides
    ]

    static func lesson(id: String) -> ArtistryLesson? {
        lessons.first { $0.id == id }
    }

    // MARK: - 01 Overview

    private static let overview = ArtistryLesson(
        id: "overview",
        number: 1,
        title: "Overview",
        summary: "Before you can improve a tree, you must learn to see the tree.",
        sections: [
            ArtistrySection(
                id: "see",
                heading: "Learning to see",
                paragraphs: [
                    "Learning bonsai techniques is relatively straightforward. Learning to see is more difficult.",
                    "Two artists may understand pruning, wiring and repotting equally well, yet create very different bonsai. The difference is often the ability to recognise potential, balance, character, proportion and what the tree needs.",
                    "A bonsai artist gradually develops an eye for what works, what does not work, and what could work better. The goal is to move from “I like it” to “I understand why it works.”"
                ],
                bullets: [],
                callouts: [
                    ArtistryCallout(
                        id: "see-first",
                        title: "Bonsai World principle",
                        body: "Before you can improve a tree, you must learn to see the tree."
                    )
                ]
            ),
            ArtistrySection(
                id: "convincing",
                heading: "What makes a bonsai convincing?",
                paragraphs: [
                    "A convincing bonsai usually creates the impression of a real tree — not a small plant that has been decorated.",
                    "Important elements include proportion, trunk, branch structure, scale, balance and character. No single element makes a bonsai successful. The overall relationship between the elements matters.",
                    "The central question is always: what makes this look like a convincing tree?"
                ],
                bullets: [],
                callouts: [
                    ArtistryCallout(
                        id: "eye-decides",
                        title: "Bonsai World principle",
                        body: "Technique creates possibilities. The eye decides which possibility is best."
                    )
                ]
            )
        ]
    )

    // MARK: - 02 See the Tree, Not the Technique

    private static let seeTheTree = ArtistryLesson(
        id: "see-the-tree",
        number: 2,
        title: "See the Tree, Not the Technique",
        summary: "The question is not whether a branch was bent well. It is whether that branch improves the tree.",
        sections: [
            ArtistrySection(
                id: "whole",
                heading: "See the tree, not the technique",
                paragraphs: [
                    "Beginners often see wire, pruning cuts and individual branches. More experienced artists see the whole tree.",
                    "A well-wired branch that weakens the silhouette is still a weak decision. A quiet, almost straight branch that supports the trunk may be the correct one.",
                    "Pruning and Wiring in this Handbook teach what the hands can do. This chapter asks whether the result belongs on this tree."
                ],
                bullets: [],
                callouts: [
                    ArtistryCallout(
                        id: "whole-tree",
                        title: "Bonsai World principle",
                        body: "Individual techniques only matter if they improve the whole."
                    )
                ]
            )
        ]
    )

    // MARK: - 03 Proportion

    private static let proportion = ArtistryLesson(
        id: "proportion",
        number: 3,
        title: "Proportion",
        summary: "Proportion is not always a mathematical rule. The goal is visual credibility.",
        sections: [
            ArtistrySection(
                id: "questions",
                heading: "Does it feel believable?",
                paragraphs: [
                    "Ask practical questions. Does the trunk feel strong enough? Does the crown feel too large? Do the branches feel too heavy? Does the pot support the tree?",
                    "Proportion is not always about mathematical rules. Design Guidelines give useful checks for taper, branch thickness and silhouette. Use them as a check. Then look again: does the tree still feel like a tree?",
                    "Pots & Containers covers how the pot supports the composition. Display & Presentation covers the final view. Proportion starts on the tree itself."
                ],
                bullets: [],
                callouts: [
                    ArtistryCallout(
                        id: "credibility",
                        title: "Bonsai World principle",
                        body: "The goal of proportion is visual credibility."
                    )
                ]
            )
        ]
    )

    // MARK: - 04 The Trunk

    private static let trunk = ArtistryLesson(
        id: "trunk",
        number: 4,
        title: "The Trunk",
        summary: "Study the trunk before becoming distracted by foliage.",
        sections: [
            ArtistrySection(
                id: "character",
                heading: "The importance of the trunk",
                paragraphs: [
                    "The trunk often establishes character, age, direction and strength. Foliage changes quickly. Structure takes time.",
                    "Study the trunk before becoming distracted by foliage. If the trunk is not convincing, extra wiring in the crown will not save the tree.",
                    "Design Guidelines cover trunk, taper, movement and nebari as a checklist. Bonsai Material & Sourcing covers whether the trunk is worth years of work. This lesson is the habit: look at the stem first."
                ],
                bullets: [],
                callouts: [
                    ArtistryCallout(
                        id: "trunk-first",
                        title: "Bonsai World principle",
                        body: "Foliage changes quickly. Structure takes time."
                    )
                ]
            )
        ]
    )

    // MARK: - 05 Primary Structure

    private static let primaryStructure = ArtistryLesson(
        id: "primary-structure",
        number: 5,
        title: "Primary Structure",
        summary: "A bonsai should generally remain convincing even when fine ramification is removed.",
        sections: [
            ArtistrySection(
                id: "bones",
                heading: "Trunk line, major branches and apex",
                paragraphs: [
                    "Primary structure is the trunk line, the major branches and the apex. Fine ramification, flowers and a good pot can hide a weak skeleton for a season. They cannot replace it.",
                    "A bonsai should generally remain convincing even when fine ramification is removed. If the tree collapses into a stick with decoration, the underlying structure is not doing the work.",
                    "Design Guidelines cover primary branches, apex and ramification in order. Pruning is how structure is chosen over time. Do not refine a tree whose primary structure is still undecided."
                ],
                bullets: [],
                callouts: [
                    ArtistryCallout(
                        id: "bones",
                        title: "Bonsai World principle",
                        body: "The underlying structure matters more than the last millimetre of ramification."
                    )
                ]
            )
        ]
    )

    // MARK: - 06 Balance & Asymmetry

    private static let balanceAndAsymmetry = ArtistryLesson(
        id: "balance-asymmetry",
        number: 6,
        title: "Balance & Asymmetry",
        summary: "A tree can be asymmetrical and still feel stable, natural and complete.",
        sections: [
            ArtistrySection(
                id: "balance",
                heading: "Balance is not symmetry",
                paragraphs: [
                    "Visual balance does not mean symmetry. A tree can be asymmetrical and still feel stable, natural and balanced.",
                    "Ask whether the mass, movement and empty space hold together. A heavy first branch can be balanced by trunk movement, by the crown, or by the way the nebari sits — not only by a matching branch on the other side."
                ],
                bullets: [],
                callouts: [
                    ArtistryCallout(
                        id: "not-symmetry",
                        title: "Bonsai World principle",
                        body: "A tree can be uneven and still feel complete."
                    )
                ]
            ),
            ArtistrySection(
                id: "asymmetry",
                heading: "Useful asymmetry",
                paragraphs: [
                    "Natural trees are rarely perfectly symmetrical. Useful asymmetry may create interest, movement and character.",
                    "Random imbalance is not the same as artistic asymmetry. If the tree feels as if it might fall over, or if one side is simply neglected, that is not design. It is an unresolved problem."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )

    // MARK: - 07 Movement & Negative Space

    private static let movementAndSpace = ArtistryLesson(
        id: "movement-space",
        number: 7,
        title: "Movement & Negative Space",
        summary: "Movement should support the tree. Empty space should let the eye travel.",
        sections: [
            ArtistrySection(
                id: "movement",
                heading: "Where does the eye travel?",
                paragraphs: [
                    "Trunk and branches can create direction, flow and energy. Ask where the eye travels. Does the tree feel static, dynamic or unstable?",
                    "Movement should support the tree, not distract from it. Wiring can place a branch. It cannot decide whether that movement belongs. Design Guidelines cover trunk movement. Wiring covers how movement is set."
                ],
                bullets: [],
                callouts: []
            ),
            ArtistrySection(
                id: "negative-space",
                heading: "Negative space",
                paragraphs: [
                    "Empty spaces between branches can help create depth, clarity and structure. Avoid turning the canopy into a solid green shape.",
                    "Negative space is simply the air the eye can pass through. Design Guidelines already warn that continuous pads without space become a bush. This lesson is the habit: if you cannot see through the tree, you cannot read the tree."
                ],
                bullets: [],
                callouts: [
                    ArtistryCallout(
                        id: "air",
                        title: "Bonsai World principle",
                        body: "If the eye cannot pass through the canopy, the tree reads as a shape, not as a tree."
                    )
                ]
            )
        ]
    )

    // MARK: - 08 Simplicity & Character

    private static let simplicityAndCharacter = ArtistryLesson(
        id: "simplicity-character",
        number: 8,
        title: "Simplicity & Character",
        summary: "Complexity is easy. Clarity is difficult. Character should come from the tree.",
        sections: [
            ArtistrySection(
                id: "simplicity",
                heading: "Simplicity",
                paragraphs: [
                    "Bonsai often improves when unnecessary elements are removed. Ask: does this branch have a purpose? Does this feature improve the tree?",
                    "Every removal changes the future. Remove with purpose. Do not prune because the scissors are in your hand."
                ],
                bullets: [],
                callouts: [
                    ArtistryCallout(
                        id: "clarity",
                        title: "Bonsai World principle",
                        body: "Complexity is easy. Clarity is difficult."
                    )
                ]
            ),
            ArtistrySection(
                id: "character",
                heading: "Character",
                paragraphs: [
                    "Trees can communicate age, strength, fragility, movement and survival. Character should come from the tree — not from forcing dramatic features.",
                    "Ideas such as wabi-sabi — finding value in age, wear and incompleteness — can help you keep what the tree already is. They are not a recipe for adding scars, deadwood or tilt."
                ],
                bullets: [],
                callouts: []
            ),
            ArtistrySection(
                id: "styling-trap",
                heading: "Avoiding the styling-everything trap",
                paragraphs: [
                    "Not every branch must be dramatically bent, wired into movement, or made visually interesting. Too much activity can reduce clarity.",
                    "Sometimes a straight branch is correct. Sometimes a quiet area is necessary. Advanced Techniques warns against dramatic intervention for its own sake. The same warning applies to everyday styling."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )

    // MARK: - 09 Naturalism & Design

    private static let naturalismAndDesign = ArtistryLesson(
        id: "naturalism",
        number: 9,
        title: "Naturalism & Design",
        summary: "A convincing bonsai balances natural inspiration with artistic organisation.",
        sections: [
            ArtistrySection(
                id: "interpret",
                heading: "The artist interprets nature",
                paragraphs: [
                    "Bonsai is not an exact miniature copy of a natural tree. The artist interprets nature.",
                    "A convincing bonsai balances natural inspiration with artistic organisation. Copy every twist from a hillside oak and the pot may still look chaotic. Organise every pad into a diagram and the tree may look made, not grown.",
                    "Design Guidelines are strongest on classical trees and weaker on yamadori and bunjin when the material already has character. The eye decides when a guideline should yield."
                ],
                bullets: [],
                callouts: [
                    ArtistryCallout(
                        id: "interpret",
                        title: "Bonsai World principle",
                        body: "The artist organises what nature suggests. Neither chaos nor a diagram is the aim."
                    )
                ]
            )
        ]
    )

    // MARK: - 10 Developing the Eye

    private static let developingTheEye = ArtistryLesson(
        id: "developing-the-eye",
        number: 10,
        title: "Developing the Eye",
        summary: "Look at many trees. Study why they work. Do not copy without understanding the material.",
        sections: [
            ArtistrySection(
                id: "habits",
                heading: "Practical ways to develop judgement",
                paragraphs: [
                    "Look at many trees. Compare designs. Study the same tree over time. Photograph your own trees. Look at trees without focusing on details.",
                    "Ask: what is the strongest part of this tree? What is the weakest? Where does my eye go first? Where should it go?"
                ],
                bullets: [],
                callouts: [
                    ArtistryCallout(
                        id: "do-less",
                        title: "Bonsai World principle",
                        body: "Better observation often creates better decisions."
                    )
                ]
            ),
            ArtistrySection(
                id: "great-bonsai",
                heading: "Learning from great bonsai",
                paragraphs: [
                    "Study high-quality bonsai. Do not copy individual trees. Instead study why they work. Look for structure, proportion, simplicity, balance and character.",
                    "Copying another bonsai onto different material is a common design mistake. Bonsai Material & Sourcing is about the potential you actually have."
                ],
                bullets: [],
                callouts: []
            ),
            ArtistrySection(
                id: "nature",
                heading: "Learning from nature",
                paragraphs: [
                    "Natural trees are one of the best design teachers. Observe how trunks change, how branches respond to light, how age changes structure, and how trees respond to hardship.",
                    "The goal is not copying every detail. The goal is understanding natural patterns."
                ],
                bullets: [],
                callouts: []
            ),
            ArtistrySection(
                id: "photography",
                heading: "Photography as a design tool",
                paragraphs: [
                    "Photographs can reveal design problems. A photograph removes the physical presence of the tree and the ability to walk around it. That can make balance, branch and proportion problems easier to see.",
                    "Review the tree through photographs before major work. Media → Images is the photographic surface. Consistent views over time help more than a single flattering picture."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )

    // MARK: - 11 Evaluating Your Tree

    private static let evaluating = ArtistryLesson(
        id: "evaluating",
        number: 11,
        title: "Evaluating Your Tree",
        summary: "Look at the whole tree. Do not immediately ask what to remove. Sometimes the answer is nothing.",
        sections: [
            ArtistrySection(
                id: "process",
                heading: "A simple evaluation process",
                paragraphs: [
                    "Look at the whole tree. Ignore the pot and presentation for a moment. Study the trunk. Study the main branch structure. Ask what the strongest feature is. Ask what weakens the design. Ask what should happen next.",
                    "Do not immediately ask what you should remove. Sometimes the correct answer is nothing."
                ],
                bullets: [
                    "Look at the whole tree.",
                    "Ignore the pot and presentation.",
                    "Study the trunk.",
                    "Study the main branch structure.",
                    "Ask what the strongest feature is.",
                    "Ask what weakens the design.",
                    "Ask what should happen next."
                ],
                callouts: [
                    ArtistryCallout(
                        id: "nothing",
                        title: "Bonsai World principle",
                        body: "Not every problem should be solved with a tool."
                    )
                ]
            ),
            ArtistrySection(
                id: "front",
                heading: "Choosing a front",
                paragraphs: [
                    "The best front should help reveal trunk, nebari, movement and depth. The front is not necessarily the side with the most branches.",
                    "Design Guidelines: choose the front first; everything else is read from that view. This lesson adds the test: from this side, does it look like a convincing tree?"
                ],
                bullets: [],
                callouts: []
            ),
            ArtistrySection(
                id: "not-ready",
                heading: "Knowing when the design is not ready",
                paragraphs: [
                    "A tree may be healthy, well styled and interesting — and still not ready. Sometimes development requires growth, time, better branches or better ramification.",
                    "Working because you feel the tree needs something done is a design mistake. Garden → Trees holds the record. Time is still part of the design."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )

    // MARK: - 12 Practice

    private static let practice = ArtistryLesson(
        id: "practice",
        number: 12,
        title: "Practice",
        summary: "Would doing nothing improve the result? Ask that before you pick up a tool.",
        sections: [
            ArtistrySection(
                id: "mistakes",
                heading: "Common design mistakes",
                paragraphs: [
                    "Trying to make every branch interesting. Ignoring the trunk. Creating too much symmetry. Removing important structure too quickly. Overcomplicating the design.",
                    "Copying another bonsai without understanding the material. Focusing on details before primary structure. Working because you feel the tree needs something done. Forcing the tree into a preconceived design. Failing to allow the tree to develop."
                ],
                bullets: [],
                callouts: []
            ),
            ArtistrySection(
                id: "framework",
                heading: "A simple bonsai artistry framework",
                paragraphs: [
                    "When evaluating a bonsai, ask these questions. If you cannot answer them, wait."
                ],
                bullets: [
                    "What do I notice first?",
                    "Is the trunk convincing?",
                    "Does the structure support the trunk?",
                    "Does the tree have clear direction?",
                    "Is anything unnecessary?",
                    "Is anything missing?",
                    "Does the tree feel balanced?",
                    "Does it feel believable?",
                    "What is the next development priority?",
                    "Would doing nothing improve the result?"
                ],
                callouts: []
            ),
            ArtistrySection(
                id: "paths",
                heading: "Beginner, intermediate and advanced",
                paragraphs: [
                    "Beginner — learn how to look at the whole tree. Name the trunk, the main branches and where the eye goes first. Like is a start. Why is the skill.",
                    "Intermediate — evaluate structure and design critically. Compare your tree with Design Guidelines, then decide which guideline the material should follow.",
                    "Advanced — refine artistic judgement. Decide which possibility technique has created, including the possibility of waiting."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )

    // MARK: - 13 Quick Guides

    private static let quickGuides = ArtistryLesson(
        id: "quick-guides",
        number: 13,
        title: "Quick Guides",
        summary: "The goal is not to perform more techniques. It is to make better decisions.",
        sections: [
            ArtistrySection(
                id: "cards",
                heading: "Quick knowledge cards",
                paragraphs: [],
                bullets: [],
                callouts: [
                    ArtistryCallout(
                        id: "card-whole",
                        title: "See the whole tree",
                        body: "Individual techniques only matter if they improve the whole."
                    ),
                    ArtistryCallout(
                        id: "card-trunk",
                        title: "The trunk comes first",
                        body: "Foliage changes quickly. Structure takes time."
                    ),
                    ArtistryCallout(
                        id: "card-balance",
                        title: "Balance is not symmetry",
                        body: "A tree can be uneven and still feel complete."
                    ),
                    ArtistryCallout(
                        id: "card-remove",
                        title: "Remove with purpose",
                        body: "Every removal changes the future."
                    ),
                    ArtistryCallout(
                        id: "card-less",
                        title: "Do less, see more",
                        body: "Better observation often creates better decisions."
                    )
                ]
            ),
            ArtistrySection(
                id: "connections",
                heading: "Connections to other Bonsai World knowledge",
                paragraphs: [
                    "Design Guidelines — style, structure, front, trunk, branches and design principles.",
                    "Bonsai Forms, Styles & Silhouette — silhouette, pads, depth and whether a named style helps.",
                    "Tree development in Design Guidelines — long-term improvement of structure and ramification.",
                    "Pruning — structural decisions and what to keep.",
                    "Wiring — movement and branch positioning.",
                    "Bonsai Material & Sourcing — recognising potential in the trunk and material you have.",
                    "Display & Presentation — final visual evaluation of the composed tree.",
                    "Deadwood — whether character already on the tree is stronger than added deadwood.",
                    "Advanced Techniques — when major work is justified, and when waiting is the technique.",
                    "Pots & Containers — whether the pot supports proportion.",
                    "Media → Images — photographs as a design tool.",
                    "Garden → Trees — the tree you are actually evaluating."
                ],
                bullets: [],
                callouts: []
            ),
            ArtistrySection(
                id: "closing",
                heading: "Final Bonsai World principle",
                paragraphs: [
                    "The bonsai artist develops in two directions. One direction is technical: learning what the hands can do. The other is visual: learning what the eye can see.",
                    "Over time, the goal is not to perform more techniques. It is to make better decisions. And better decisions begin with learning to see the tree before trying to change it."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )
}
