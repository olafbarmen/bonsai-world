//
//  PruningKnowledge.swift
//  Bonsai World
//
//  Knowledge → Bonsai Handbook → Pruning.
//  Principles for directing future growth — not a fixed set of cutting rules.
//

import Foundation

struct PruningKnowledgeCallout: Identifiable, Hashable, Sendable {
    var id: String
    var title: String
    var body: String
}

struct PruningKnowledgeSection: Identifiable, Hashable, Sendable {
    var id: String
    var heading: String
    var paragraphs: [String]
    var bullets: [String]
    var callouts: [PruningKnowledgeCallout]
}

struct PruningKnowledgeLesson: Identifiable, Hashable, Sendable {
    var id: String
    var number: Int
    var title: String
    var summary: String
    var sections: [PruningKnowledgeSection]
}

enum PruningKnowledge {
    static let chapterTitle = "Pruning"

    static let openingLine =
        "Understanding how and why to prune bonsai — from the first structural cuts to advanced refinement and long-term tree development."

    static let disclaimer =
        "Species, health, stage, season, vigour and design goal change the answer. Treat this as decision support — not a calendar of cuts."

    static let lessons: [PruningKnowledgeLesson] = [
        overview,
        types,
        structural,
        development,
        refinement,
        directional,
        branchProblems,
        vigor,
        species,
        timing,
        wiringWounds,
        leafReduction,
        defoliation,
        coniferPineGrowth,
        practice,
        quickGuides
    ]

    static func lesson(id: String) -> PruningKnowledgeLesson? {
        lessons.first { $0.id == id }
    }

    // MARK: - 01 Overview

    private static let overview = PruningKnowledgeLesson(
        id: "overview",
        number: 1,
        title: "Overview",
        summary: "Pruning directs the future of the tree. Know why you are cutting, and what the tree will do next.",
        sections: [
            PruningKnowledgeSection(
                id: "introduction",
                heading: "Pruning bonsai",
                paragraphs: [
                    "Pruning is one of the most important tools in bonsai. Every significant cut changes the future of the tree.",
                    "A branch may be removed to improve design. A shoot may be shortened to create ramification. A sacrifice branch may be left untouched to develop the trunk. A weak branch may be protected rather than pruned.",
                    "The same branch may be essential today, unnecessary tomorrow, or valuable again later. For this reason, pruning should never be treated simply as removing what looks too long.",
                    "Pruning is the process of directing the future development of a tree."
                ],
                bullets: [],
                callouts: [
                    PruningKnowledgeCallout(
                        id: "next-principle",
                        title: "Bonsai World principle",
                        body: "Before making a cut, understand what the tree will do next."
                    )
                ]
            ),
            PruningKnowledgeSection(
                id: "purpose",
                heading: "What is pruning?",
                paragraphs: [
                    "Pruning can establish structure, improve design, select branches, create taper, build ramification, control size, improve proportion, direct growth, maintain refinement, improve light penetration, remove unwanted growth, and prepare a tree for future development.",
                    "It can also involve managing leaves, needles, buds, candles, shoot extension and energy distribution. Different techniques influence the tree in different ways. Some improve structure. Some control vigour. Some improve ramification. Some manage scale.",
                    "There is a difference between cutting a tree and directing a tree. The purpose of bonsai pruning is not simply to reduce growth. The purpose is to influence how future growth is distributed. The important question is not which technique should be used. It is what the tree is doing, and what we are trying to achieve."
                ],
                bullets: [],
                callouts: []
            ),
            PruningKnowledgeSection(
                id: "why",
                heading: "Know why you are cutting",
                paragraphs: [
                    "Before every significant cut, ask why. If there is no clear reason, do not cut yet."
                ],
                bullets: [
                    "The branch does not belong in the design",
                    "The branch is too thick",
                    "The branch damages taper",
                    "The branch competes with the trunk line",
                    "The branch is growing in an unsuitable direction",
                    "The shoot is too long",
                    "The tree needs more ramification",
                    "The branch is shading important interior growth",
                    "The branch has completed its purpose",
                    "The branch is unhealthy or damaged"
                ],
                callouts: [
                    PruningKnowledgeCallout(
                        id: "wait-principle",
                        title: "Bonsai World principle",
                        body: "Uncertainty is a reason to wait."
                    )
                ]
            ),
            PruningKnowledgeSection(
                id: "response",
                heading: "How trees respond",
                paragraphs: [
                    "Pruning changes how a tree distributes energy and growth. Apical dominance, strong and weak areas, growth redistribution, bud activation, back budding and shoot extension all play a part — and they do not behave identically across species.",
                    "Different species can respond very differently to heavy pruning, light pruning, cutting into old wood, cutting back to buds, and repeated pruning. The same cut can produce different results on different species."
                ],
                bullets: [],
                callouts: [
                    PruningKnowledgeCallout(
                        id: "species-cut",
                        title: "Key principle",
                        body: "The same cut can produce different results on different species."
                    )
                ]
            )
        ]
    )

    // MARK: - 02 Types

    private static let types = PruningKnowledgeLesson(
        id: "types",
        number: 2,
        title: "Types of Pruning",
        summary: "Structural, development, maintenance, refinement, directional work, shoot pruning, branch removal and correction are different jobs.",
        sections: [
            PruningKnowledgeSection(
                id: "structural-type",
                heading: "Structural pruning",
                paragraphs: [
                    "Large-scale decisions that establish the primary structure of the bonsai. These cuts are often the most consequential and the hardest to reverse."
                ],
                bullets: [],
                callouts: []
            ),
            PruningKnowledgeSection(
                id: "development-type",
                heading: "Development pruning",
                paragraphs: [
                    "Used to build trunk, primary and secondary branches, taper and movement. The tree is being constructed, not finished."
                ],
                bullets: [],
                callouts: []
            ),
            PruningKnowledgeSection(
                id: "maintenance-type",
                heading: "Maintenance pruning",
                paragraphs: [
                    "Used to maintain the existing shape and structure once that structure has been chosen."
                ],
                bullets: [],
                callouts: []
            ),
            PruningKnowledgeSection(
                id: "refinement-type",
                heading: "Refinement pruning",
                paragraphs: [
                    "Detailed pruning used to develop ramification, fine branch structure, silhouette and balance."
                ],
                bullets: [],
                callouts: []
            ),
            PruningKnowledgeSection(
                id: "directional-type",
                heading: "Directional pruning",
                paragraphs: [
                    "Used to redirect growth toward a desired bud, shoot or branch."
                ],
                bullets: [],
                callouts: []
            ),
            PruningKnowledgeSection(
                id: "shoot-type",
                heading: "Shoot pruning",
                paragraphs: [
                    "Shortening new growth to manage extension and structure."
                ],
                bullets: [],
                callouts: []
            ),
            PruningKnowledgeSection(
                id: "removal-type",
                heading: "Branch removal",
                paragraphs: [
                    "Complete removal of a branch. A different decision from shortening it."
                ],
                bullets: [],
                callouts: []
            ),
            PruningKnowledgeSection(
                id: "correction-type",
                heading: "Correction pruning",
                paragraphs: [
                    "Removing growth that creates structural or design problems — crossing branches, inward growth, unwanted vertical growth, competing leaders, bar branches or congested growth. Correction is still a decision, not an automatic list of faults."
                ],
                bullets: [],
                callouts: []
            ),
            PruningKnowledgeSection(
                id: "foliage-growth-type",
                heading: "Foliage and growth management",
                paragraphs: [
                    "Leaf reduction, defoliation and conifer or pine growth management are specialised pruning decisions. They are covered in their own lessons. They are not a routine stage every tree must pass through."
                ],
                bullets: [],
                callouts: [
                    PruningKnowledgeCallout(
                        id: "manage-growth",
                        title: "Bonsai World principle",
                        body: "Pruning techniques manage growth. They do not replace understanding the tree."
                    )
                ]
            )
        ]
    )

    // MARK: - 03 Structural

    private static let structural = PruningKnowledgeLesson(
        id: "structural",
        number: 3,
        title: "Structural Pruning",
        summary: "The big decisions. Evaluate the tree, then stage the work. Do not strip a developing tree to look finished.",
        sections: [
            PruningKnowledgeSection(
                id: "big-decisions",
                heading: "Making the big decisions",
                paragraphs: [
                    "Structural pruning is often the most important and potentially irreversible form of pruning. Evaluate trunk line, taper, nebari, primary branches, branch placement, thickness, movement and design direction before you commit.",
                    "Do not encourage a beginner to remove multiple major branches simply to make a tree look like a finished bonsai immediately. Patience and staged development are part of the work."
                ],
                bullets: [
                    "Does the branch damage the design?",
                    "Does the branch contribute to trunk development?",
                    "Could it be useful in the future?",
                    "Is there an alternative branch?",
                    "Would removing it improve the tree permanently?",
                    "Is the tree healthy enough for the work?",
                    "Is this the correct time for the species?"
                ],
                callouts: []
            )
        ]
    )

    // MARK: - 04 Development

    private static let development = PruningKnowledgeLesson(
        id: "development",
        number: 4,
        title: "Development Pruning",
        summary: "Building the tree often means allowing growth, including sacrifice wood and untidy extension, before you cut back.",
        sections: [
            PruningKnowledgeSection(
                id: "building",
                heading: "Pruning while building the tree",
                paragraphs: [
                    "Development pruning is different from refinement pruning. During development the goal may be strong growth, trunk thickening, branch thickening, building structure or creating taper.",
                    "Not all unwanted-looking growth should be removed immediately. Letting a branch extend may be necessary before cutting it back."
                ],
                bullets: [],
                callouts: []
            ),
            PruningKnowledgeSection(
                id: "sacrifice",
                heading: "Sacrifice branches",
                paragraphs: [
                    "A branch may temporarily exist for development purposes even if it will not be part of the final design. Its job may be thickening, healing, or feeding a section of trunk. Remove it when that job is done — not because it looks out of place today."
                ],
                bullets: [],
                callouts: []
            ),
            PruningKnowledgeSection(
                id: "cycles",
                heading: "Grow, extend, cut back",
                paragraphs: [
                    "Repeated cycles of grow, extend, cut back, select and grow again can be used to build structure. The tree is allowed to work, then edited."
                ],
                bullets: [],
                callouts: [
                    PruningKnowledgeCallout(
                        id: "untidy",
                        title: "Bonsai World principle",
                        body: "Development often requires allowing the tree to become untidy."
                    )
                ]
            ),
            PruningKnowledgeSection(
                id: "clip-and-grow",
                heading: "Clip and grow",
                paragraphs: [
                    "Clip and grow is a major bonsai development technique. Allow growth, let structure extend, cut back to a suitable point, select the next direction, and repeat. The cycle can create taper, movement, branch subdivision and natural changes in direction.",
                    "Wiring positions existing structure. Clip and grow builds structure through growth and cutback. They are not competing methods. Many bonsai use both."
                ],
                bullets: [],
                callouts: []
            ),
            PruningKnowledgeSection(
                id: "taper",
                heading: "Pruning for taper",
                paragraphs: [
                    "Repeated growth and cutback can create taper in trunks, primary branches, secondary branches and ramification. Strong growth produces extension and thickness. Cutback then sets a new leader or branch as a smaller continuation.",
                    "This principle is fundamental to bonsai structure."
                ],
                bullets: [],
                callouts: [
                    PruningKnowledgeCallout(
                        id: "taper-principle",
                        title: "Bonsai World principle",
                        body: "Let growth create thickness. Use pruning to create transition."
                    )
                ]
            )
        ]
    )

    // MARK: - 05 Refinement

    private static let refinement = PruningKnowledgeLesson(
        id: "refinement",
        number: 5,
        title: "Refinement Pruning",
        summary: "From branches to ramification. Observe shoot strength, position and species — do not apply one shortening rule to every tree.",
        sections: [
            PruningKnowledgeSection(
                id: "ramification",
                heading: "From branches to ramification",
                paragraphs: [
                    "Refinement pruning focuses on branch subdivision, fine ramification, controlled extension, silhouette, light distribution and interior growth.",
                    "Do not apply a generic rule such as cut everything back to two leaves. The correct approach depends on species, shoot strength, position, season and the desired branch structure.",
                    "Refinement requires observation rather than repetitive cutting."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )

    // MARK: - 06 Directional

    private static let directional = PruningKnowledgeLesson(
        id: "directional",
        number: 6,
        title: "Directional Pruning",
        summary: "Cut back to the bud or shoot that continues in the direction you want — and check that direction in three dimensions.",
        sections: [
            PruningKnowledgeSection(
                id: "change-direction",
                heading: "Using pruning to change direction",
                paragraphs: [
                    "Cut back to an outward-facing bud, a side shoot, or a branch moving in the desired direction. That choice can create movement, direction, branch taper and compact structure.",
                    "Incorrect direction is removed. The retained bud or shoot is the next line of the branch.",
                    "Direction must always be considered in three dimensions. A branch may look correctly directed from the front but move incorrectly when viewed from above or from the side."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )

    // MARK: - 07 Branch removal & problems

    private static let branchProblems = PruningKnowledgeLesson(
        id: "branch-problems",
        number: 7,
        title: "Branch Removal & Problems",
        summary: "Remove a branch for a reason that still holds as the tree develops. Common faults are evaluations, not automatic cuts.",
        sections: [
            PruningKnowledgeSection(
                id: "removal",
                heading: "Removing a branch correctly",
                paragraphs: [
                    "Cover why the branch should go, when removal is appropriate, whether an alternative exists, how to avoid unnecessary scars, cutting technique and wound management.",
                    "A branch should not be removed solely because it does not fit the tree's current image. Consider whether the tree is still developing."
                ],
                bullets: [
                    "Poor placement",
                    "Excessive thickness",
                    "Structural conflict",
                    "Inverse taper",
                    "Crossing",
                    "Unnatural design",
                    "Damage",
                    "Disease"
                ],
                callouts: []
            ),
            PruningKnowledgeSection(
                id: "bar",
                heading: "Bar branches",
                paragraphs: [
                    "Two branches emerging at approximately the same height from opposite sides can cause swelling, inverse taper and visual symmetry. Removal is not automatic. Evaluate species, position, tree stage and whether alternative branches exist."
                ],
                bullets: [],
                callouts: []
            ),
            PruningKnowledgeSection(
                id: "crossing",
                heading: "Crossing branches",
                paragraphs: [
                    "Crossing creates visual confusion and can produce rubbing, scars and congestion. The answer is still which line to keep for the future tree — not simply which branch is in the way today."
                ],
                bullets: [],
                callouts: []
            ),
            PruningKnowledgeSection(
                id: "inward",
                heading: "Inward growth",
                paragraphs: [
                    "Growth toward the trunk can create congestion, shade interior buds and confuse the silhouette. Interior structure still needs light. Clearing inward growth is a vigour and design decision, not only a tidy-up."
                ],
                bullets: [],
                callouts: []
            ),
            PruningKnowledgeSection(
                id: "upward",
                heading: "Straight upward growth",
                paragraphs: [
                    "Vertical growth may compete with the apex and create unwanted strength. It can also be useful — as a future leader, a sacrifice, or a way to lift a line. Judge the role, not only the angle."
                ],
                bullets: [],
                callouts: []
            ),
            PruningKnowledgeSection(
                id: "leaders",
                heading: "Duplicate leaders",
                paragraphs: [
                    "Competing leaders affect trunk hierarchy, taper and the reading of the tree. Choose the line that continues the design. The second leader is not automatically waste — it may thicken, then leave."
                ],
                bullets: [],
                callouts: []
            ),
            PruningKnowledgeSection(
                id: "congestion",
                heading: "Congestion",
                paragraphs: [
                    "Too many branches and shoots can reduce light, air movement, interior growth and visual clarity. Thinning is still selective. Remove what blocks the plan, not everything that looks busy."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )

    // MARK: - 08 Vigor

    private static let vigor = PruningKnowledgeLesson(
        id: "vigor",
        number: 8,
        title: "Vigor & Balance",
        summary: "Do not prune every part of the tree equally. Stage, apex strength and weak lower branches change the decision.",
        sections: [
            PruningKnowledgeSection(
                id: "unequal",
                heading: "Do not prune every part equally",
                paragraphs: [
                    "Different areas of the tree may have different strength — a strong apex, weak lower branches, strong exterior growth, weak interior growth. Pruning can sometimes be used to redistribute growth.",
                    "Weak areas should not always be treated the same as strong areas."
                ],
                bullets: [],
                callouts: [
                    PruningKnowledgeCallout(
                        id: "balance-tree",
                        title: "Bonsai World principle",
                        body: "Balance the tree, not the calendar."
                    )
                ]
            ),
            PruningKnowledgeSection(
                id: "apical",
                heading: "Apical dominance",
                paragraphs: [
                    "Dominant growing areas influence how growth is distributed. Apex strength, upper branch strength and weak lower branches vary by species. Pruning decisions may be used to manage that balance. There is no universal formula."
                ],
                bullets: [],
                callouts: []
            ),
            PruningKnowledgeSection(
                id: "young",
                heading: "Young material",
                paragraphs: [
                    "Priorities are structure, trunk development and branch selection. Avoid premature refinement."
                ],
                bullets: [],
                callouts: []
            ),
            PruningKnowledgeSection(
                id: "developing",
                heading: "Developing bonsai",
                paragraphs: [
                    "Priorities are building primary structure, taper, movement and branch development."
                ],
                bullets: [],
                callouts: []
            ),
            PruningKnowledgeSection(
                id: "refined-stage",
                heading: "Refined bonsai",
                paragraphs: [
                    "Priorities are ramification, silhouette, balance and controlled growth. Leaf reduction and selective foliage management may become relevant here. They still depend on health and species."
                ],
                bullets: [],
                callouts: []
            ),
            PruningKnowledgeSection(
                id: "highly-refined",
                heading: "Highly refined bonsai",
                paragraphs: [
                    "Priorities are fine structure, preservation, energy balance and avoiding unnecessary disruption."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )

    // MARK: - 09 Species

    private static let species = PruningKnowledgeLesson(
        id: "species",
        number: 9,
        title: "Species",
        summary: "Deciduous, conifer, evergreen broadleaf, tropical, flowering and fruiting trees do not share one pruning system.",
        sections: [
            PruningKnowledgeSection(
                id: "deciduous",
                heading: "Deciduous bonsai",
                paragraphs: [
                    "Bud position, internodes, back budding, seasonal growth and ramification all matter. Do not apply one deciduous pruning system to all deciduous species. Leaf Reduction and Defoliation belong with this group when the individual tree and Species Library support them. Species Profiles remain the place for timing and cultivar differences."
                ],
                bullets: [],
                callouts: []
            ),
            PruningKnowledgeSection(
                id: "conifers",
                heading: "Conifer pruning",
                paragraphs: [
                    "Conifers must not automatically be pruned like deciduous trees. Bud location, foliage type, species response, cutting into old wood and back-budding limitations all change the risk.",
                    "Pines, junipers, spruce, fir, larch and yew will need more specific guidance in Species Profiles where it exists. Conifer and Pine Growth Management in this chapter covers the principles. It does not transfer one pine species' method to another."
                ],
                bullets: [],
                callouts: [
                    PruningKnowledgeCallout(
                        id: "grow-again",
                        title: "Key principle",
                        body: "Know where your species can grow again before you remove existing foliage."
                    )
                ]
            ),
            PruningKnowledgeSection(
                id: "evergreen",
                heading: "Evergreen broadleaf bonsai",
                paragraphs: [
                    "Growth cycles, leaf position, budding characteristics and species differences matter. Link to the relevant Species Profile when that guidance exists."
                ],
                bullets: [],
                callouts: []
            ),
            PruningKnowledgeSection(
                id: "tropical",
                heading: "Tropical bonsai",
                paragraphs: [
                    "Tropical species may grow over longer periods, respond differently to pruning and require different seasonal thinking. Focus on active growth, species behaviour and tree health rather than temperate calendar rules."
                ],
                bullets: [],
                callouts: []
            ),
            PruningKnowledgeSection(
                id: "flowering",
                heading: "Flowering and fruiting bonsai",
                paragraphs: [
                    "Pruning may affect flower buds, fruit production and seasonal display. Before you cut, consider where flowers form, when buds develop, and whether you currently prioritise flowers or structural development.",
                    "Avoid generic advice across all flowering and fruiting species."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )

    // MARK: - 10 Timing

    private static let timing = PruningKnowledgeLesson(
        id: "timing",
        number: 10,
        title: "Timing",
        summary: "When to prune, when to wait, and how pruning combines with root work. There is no single bonsai pruning calendar.",
        sections: [
            PruningKnowledgeSection(
                id: "when",
                heading: "When to prune",
                paragraphs: [
                    "Timing depends on species, climate, tree health, the type of pruning and the desired response. Separate major structural pruning from routine shoot pruning, from refinement pruning, from species-specific work.",
                    "Do not create a single universal bonsai pruning calendar."
                ],
                bullets: [],
                callouts: []
            ),
            PruningKnowledgeSection(
                id: "when-not",
                heading: "When not to prune",
                paragraphs: [
                    "Delay when the tree is weak, recovering, or carrying a compromised root system; when environmental stress is severe; when seasonal timing is wrong for the species and the type of cut; or when there is no clear design decision."
                ],
                bullets: [],
                callouts: [
                    PruningKnowledgeCallout(
                        id: "do-nothing",
                        title: "Bonsai World principle",
                        body: "Sometimes the best pruning decision is to do nothing."
                    )
                ]
            ),
            PruningKnowledgeSection(
                id: "repotting",
                heading: "Pruning and repotting",
                paragraphs: [
                    "Significant root work and significant pruning can both affect the tree. The appropriate combination depends on species, tree strength, the amount of root work and the amount of pruning.",
                    "Avoid universal rules. Learn to evaluate total stress."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )

    // MARK: - 11 Wiring & wounds

    private static let wiringWounds = PruningKnowledgeLesson(
        id: "wiring-wounds",
        number: 11,
        title: "Wiring & Wounds",
        summary: "Pruning and wiring are two tools for one design. After the cut, species and wound size still decide how you treat the tree.",
        sections: [
            PruningKnowledgeSection(
                id: "wiring",
                heading: "Two tools, one design",
                paragraphs: [
                    "Pruning removes or redirects growth. Wiring positions existing structure. Both can be used together."
                ],
                bullets: [
                    "Can the desired change be achieved by pruning?",
                    "If no: can it be achieved by wiring?",
                    "If both are possible: which creates the best long-term structure?"
                ],
                callouts: []
            ),
            PruningKnowledgeSection(
                id: "wounds",
                heading: "After the cut",
                paragraphs: [
                    "Clean tools, appropriate cutting tools, cut placement, wound healing, species differences and callus development all matter. Do not imply that every cut should be treated identically. Different species and wound sizes require different consideration."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )

    // MARK: - 12 Leaf Reduction

    private static let leafReduction = PruningKnowledgeLesson(
        id: "leaf-reduction",
        number: 12,
        title: "Leaf Reduction",
        summary: "Small leaves are often the result of development. They are not simply created by cutting large leaves.",
        sections: [
            PruningKnowledgeSection(
                id: "what-reduction",
                heading: "What is leaf reduction?",
                paragraphs: [
                    "Leaf reduction is the process of developing smaller or more visually proportionate foliage over time. It is not always created by physically cutting leaves.",
                    "Smaller foliage often develops through the combined influence of tree maturity, ramification, root development, shoot management, light, vigour management and repeated refinement."
                ],
                bullets: [],
                callouts: [
                    PruningKnowledgeCallout(
                        id: "development-not-cut",
                        title: "Bonsai World principle",
                        body: "Small leaves are often the result of development. They are not simply created by cutting large leaves."
                    )
                ]
            ),
            PruningKnowledgeSection(
                id: "scale-vigour",
                heading: "Visual scale and vigour",
                paragraphs: [
                    "A bonsai is a reduced representation of a mature tree. Large leaves can sometimes hide branch structure, reduce visual scale and make a small tree appear less convincing. Large leaves are not automatically a problem. The relationship between leaf size, tree size, trunk size and overall composition is more important than the individual leaf alone.",
                    "Strong growth can often produce larger leaves, longer internodes and coarser extension. Controlled refinement can often encourage more compact growth, improved ramification and better visual scale. Reducing vigour too aggressively can weaken the tree. The goal is not the smallest possible leaf. The goal is healthy growth that supports the intended level of refinement.",
                    "Bonsai Forms, Styles & Silhouette covers foliage masses and pads. Fertilizing and Fertilizer Guides belong in vigour. Tree Health belongs when the tree is weak."
                ],
                bullets: [],
                callouts: [
                    PruningKnowledgeCallout(
                        id: "relationships",
                        title: "Bonsai World principle",
                        body: "Scale is created by relationships. Not by leaf size alone."
                    )
                ]
            ),
            PruningKnowledgeSection(
                id: "natural-then-selective",
                heading: "Development before intervention",
                paragraphs: [
                    "One of the strongest approaches to improved leaf scale is allowing the tree to develop appropriate branch structure. As ramification improves, the visual relationship between leaves, branches and the whole tree may improve naturally. This is often more sustainable than repeatedly forcing reduction through aggressive intervention.",
                    "In some situations, individual leaves may be selectively reduced or managed — to improve visual balance, reveal branch structure, improve light access or manage local density. Removing or reducing individual leaves should have a purpose. Avoid creating a mechanically trimmed appearance.",
                    "Before managing leaf size, ask whether the tree has sufficient ramification, whether the branch structure is already developed, whether large leaves are actually damaging the composition, and whether improved branch development would solve the problem more naturally."
                ],
                bullets: [],
                callouts: []
            ),
            PruningKnowledgeSection(
                id: "avoid-leaf",
                heading: "When to avoid aggressive leaf management",
                paragraphs: [
                    "Avoid unnecessary aggressive work when the tree is weak, recovering, or lacking sufficient energy; when root recovery is incomplete; or when major structural work was recently performed. Tree health always comes first. Species Library remains the place for species-specific timing."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )

    // MARK: - 13 Defoliation

    private static let defoliation = PruningKnowledgeLesson(
        id: "defoliation",
        number: 13,
        title: "Defoliation",
        summary: "Defoliation is a tool. It is not a stage every bonsai must pass through.",
        sections: [
            PruningKnowledgeSection(
                id: "what-defoliation",
                heading: "What is defoliation?",
                paragraphs: [
                    "Defoliation involves removing some or all of the foliage from a tree. It is a specialised pruning technique. It may be used to influence ramification, shoot development, light penetration, branch visibility, foliage balance and leaf scale over time.",
                    "Defoliation is not a routine requirement for bonsai."
                ],
                bullets: [],
                callouts: [
                    PruningKnowledgeCallout(
                        id: "not-a-stage",
                        title: "Bonsai World principle",
                        body: "Defoliation is a tool. It is not a stage every bonsai must pass through."
                    )
                ]
            ),
            PruningKnowledgeSection(
                id: "partial-complete",
                heading: "Partial and complete defoliation",
                paragraphs: [
                    "Partial defoliation removes foliage from selected areas. It may help reduce local density, improve light penetration, balance strong and weak areas and reveal important structure. Partial defoliation can often be more controlled than complete defoliation. The artist should know why this particular foliage is being removed.",
                    "Complete defoliation removes most or all foliage. This can create a significant demand on the tree. It should never be treated as a cosmetic shortcut. Before considering complete defoliation, evaluate tree health, species suitability, current vigour, development stage, recent work and recovery capacity."
                ],
                bullets: [],
                callouts: []
            ),
            PruningKnowledgeSection(
                id: "energy-structure",
                heading: "Energy, structure and light",
                paragraphs: [
                    "Leaves are part of the tree's energy-producing system. Removing foliage changes the balance between roots, stored energy and new growth. A visually attractive result immediately after defoliation does not necessarily mean the intervention was appropriate. Always consider the tree's ability to recover.",
                    "Defoliation may support refinement in suitable situations. It cannot replace branch development. A tree with poor structure will not become structurally refined simply because the leaves are removed.",
                    "Dense foliage may reduce light access to inner areas. Selective foliage management may help reveal branches, improve air movement and improve light access. Do not remove foliage simply to create empty spaces. Every removal should relate to tree health, branch development or design. Bonsai Forms, Styles & Silhouette: empty space is part of the design, not a hole made for its own sake."
                ],
                bullets: [],
                callouts: [
                    PruningKnowledgeCallout(
                        id: "reveal-not-create",
                        title: "Bonsai World principle",
                        body: "Defoliation can reveal structure. It cannot create structure that does not exist."
                    )
                ]
            ),
            PruningKnowledgeSection(
                id: "when-not-species",
                heading: "When not to defoliate, and species knowledge",
                paragraphs: [
                    "Avoid defoliation when the tree is weak, stressed or still recovering; when root work or major structural work was recently performed; when the species is unsuitable; or when there is no clear reason. Doing nothing may be the correct pruning decision.",
                    "Different species respond differently to foliage removal. This chapter provides the principle. Species Library provides species-specific guidance. Never assume a technique suitable for one deciduous species is suitable for another."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )

    // MARK: - 14 Conifer and Pine Growth Management

    private static let coniferPineGrowth = PruningKnowledgeLesson(
        id: "conifer-pine-growth",
        number: 14,
        title: "Conifer and Pine Growth Management",
        summary: "Do not manage energy blindly. First understand where the tree is investing it. Pine techniques are not universal.",
        sections: [
            PruningKnowledgeSection(
                id: "different-approach",
                heading: "Why conifers require a different approach",
                paragraphs: [
                    "Conifers do not respond to pruning in the same way as deciduous trees. Their growth may depend on species, bud behaviour, shoot development, needle or foliage retention and energy distribution.",
                    "Conifer pruning must be based on understanding how the particular tree grows."
                ],
                bullets: [],
                callouts: []
            ),
            PruningKnowledgeSection(
                id: "buds-shoots",
                heading: "Buds and shoots",
                paragraphs: [
                    "Buds often represent future branches, future shoots and future direction. Bud selection may influence branch density, direction, balance and future ramification. Before removing buds, ask what structure this bud might create. Removing future options too early can limit later development.",
                    "Shoot growth may be managed to influence length, density, direction and energy distribution. The correct approach depends heavily on the species. This chapter explains the principle of shoot management. Species Profiles explain the specific method."
                ],
                bullets: [],
                callouts: []
            ),
            PruningKnowledgeSection(
                id: "candles-needles",
                heading: "Candles and needles",
                paragraphs: [
                    "Some pine species produce distinct candle-like shoot extension. Managing this growth can influence extension, density, energy distribution and future structure.",
                    "Candle techniques are not universal. Different pine species may grow differently, respond differently and produce different growth patterns. Never apply a technique simply because it is described as a pine technique.",
                    "Needles contribute to the tree's energy system. Needle density can also influence light penetration, branch visibility and visual scale. Needle management should be treated as a controlled design and growth decision. Not automatic removal for appearance."
                ],
                bullets: [],
                callouts: []
            ),
            PruningKnowledgeSection(
                id: "energy-design",
                heading: "Energy, design and restraint",
                paragraphs: [
                    "Different parts of a conifer may grow with different levels of vigour. Growth management may sometimes help prevent one area dominating while another weakens. The first step is observation. Identify where growth is strongest, where it is weakest, and why.",
                    "A technique developed for one pine species may not produce the same response in another. The Handbook establishes the principle of growth management. Species Library answers how this species responds.",
                    "Bud, shoot, needle and branch all contribute to the future silhouette. Growth management should always consider where the tree is going — not only what should be removed today. Bonsai Forms, Styles & Silhouette belongs in that reading.",
                    "Avoid aggressive intervention when the tree is weak, growth is already reduced, recovery is incomplete, root health is uncertain, or major work was recently performed. A healthy growing tree often needs less intervention than an artist expects. Seasonal Care & Protection provides seasonal context. It is not a calendar of pine work."
                ],
                bullets: [],
                callouts: [
                    PruningKnowledgeCallout(
                        id: "energy-first",
                        title: "Bonsai World principle",
                        body: "Do not manage energy blindly. First understand where the tree is investing it."
                    )
                ]
            )
        ]
    )

    // MARK: - 15 Practice

    private static let practice = PruningKnowledgeLesson(
        id: "practice",
        number: 15,
        title: "Practice",
        summary: "Beginner mistakes, long-term design, how to read the tree, a decision framework, and what to learn at each level.",
        sections: [
            PruningKnowledgeSection(
                id: "mistakes",
                heading: "Common beginner mistakes",
                paragraphs: [
                    "Pruning simply because something looks long. Trying to make a developing tree look finished. Removing branches without considering future development. Applying the same pruning rule to every species.",
                    "Pruning weak and strong areas equally. Removing all vigorous growth. Making multiple major cuts without stopping to reassess. Cutting before having a future plan.",
                    "Trying to reduce leaf size before developing branch structure. Treating defoliation as an annual routine. Defoliating a weak tree. Using foliage removal to hide poor branch structure. Applying one species' technique to another species. Treating all pine species as though they grow identically. Removing buds without considering future design. Removing needles or foliage only to make the tree look cleaner. Trying to create refinement faster than the tree can develop. Ignoring the relationship between health, energy and pruning."
                ],
                bullets: [],
                callouts: []
            ),
            PruningKnowledgeSection(
                id: "advanced",
                heading: "Pruning as long-term design",
                paragraphs: [
                    "Advanced pruning decisions should consider the current design, the next design stage, the tree five years from now and the tree ten years from now.",
                    "A branch may be retained because of its future potential. A branch may be removed because it creates a problem that will become more difficult to correct later.",
                    "The advanced question is not whether this branch looks good today. The advanced question is what this branch will become."
                ],
                bullets: [],
                callouts: []
            ),
            PruningKnowledgeSection(
                id: "observe",
                heading: "Observation before action",
                paragraphs: [
                    "Before pruning, examine the tree from the front, left, right, back and above. Study trunk line, nebari, branch hierarchy, taper, movement, strong areas, weak areas and future possibilities.",
                    "Do not turn pruning into an automatic maintenance action."
                ],
                bullets: [
                    "Observe",
                    "Understand",
                    "Identify the goal",
                    "Select",
                    "Prune",
                    "Observe again"
                ],
                callouts: []
            ),
            PruningKnowledgeSection(
                id: "framework",
                heading: "A practical decision framework",
                paragraphs: [
                    "Work through the steps in order. Do not continue cutting automatically."
                ],
                bullets: [
                    "Step 1 — What is my goal? Development, structural correction, refinement or maintenance.",
                    "Step 2 — Is the tree healthy enough?",
                    "Step 3 — What species am I working with?",
                    "Step 4 — What will happen after this cut?",
                    "Step 5 — Is there a better branch, bud or shoot to retain?",
                    "Step 6 — Is this the correct time?",
                    "Step 7 — Make the cut.",
                    "Step 8 — Stop and reassess."
                ],
                callouts: []
            ),
            PruningKnowledgeSection(
                id: "foliage-framework",
                heading: "Before foliage or growth-management techniques",
                paragraphs: [
                    "Leaf reduction, defoliation and conifer growth management add a second set of questions. Walk them before using those techniques."
                ],
                bullets: [
                    "What is the tree's current health?",
                    "What stage of development is it in?",
                    "What problem am I trying to solve?",
                    "Does the tree actually need intervention?",
                    "Would improved branch development solve the problem more naturally?",
                    "Does the species support this technique?",
                    "Has the tree recently undergone other major work?",
                    "What will this decision mean for future development?"
                ],
                callouts: []
            ),
            PruningKnowledgeSection(
                id: "paths",
                heading: "Beginner, intermediate, advanced",
                paragraphs: [
                    "Beginner: why we prune, how to identify unwanted growth, basic branch selection, basic directional pruning, and the importance of waiting. Do not feel pressure to defoliate or reduce leaves.",
                    "Intermediate: structural pruning, development cycles, clip and grow, branch taper, ramification, and recognising when foliage management has a purpose.",
                    "Advanced: species-specific response, energy management, long-term structural planning, refinement balance, complex redesign decisions, and growth management that still starts with the individual tree."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )

    // MARK: - 16 Quick Guides

    private static let quickGuides = PruningKnowledgeLesson(
        id: "quick-guides",
        number: 16,
        title: "Quick Guides",
        summary: "Short cards, troubleshooting, links to other Bonsai World knowledge, and the principle that closes the chapter.",
        sections: [
            PruningKnowledgeSection(
                id: "cards",
                heading: "Quick knowledge cards",
                paragraphs: [],
                bullets: [],
                callouts: [
                    PruningKnowledgeCallout(
                        id: "card-before",
                        title: "Before you cut",
                        body: "Know what you want the tree to do next."
                    ),
                    PruningKnowledgeCallout(
                        id: "card-dev",
                        title: "Development vs refinement",
                        body: "A developing tree often needs growth. A refined tree often needs control."
                    ),
                    PruningKnowledgeCallout(
                        id: "card-future",
                        title: "The future branch",
                        body: "Do not judge every branch by what it looks like today."
                    ),
                    PruningKnowledgeCallout(
                        id: "card-direction",
                        title: "Pruning is direction",
                        body: "Every cut influences where the tree grows next."
                    ),
                    PruningKnowledgeCallout(
                        id: "card-species",
                        title: "Know your species",
                        body: "Never assume another species will respond to the same cut."
                    ),
                    PruningKnowledgeCallout(
                        id: "card-doubt",
                        title: "When in doubt",
                        body: "Wait, observe and reassess."
                    ),
                    PruningKnowledgeCallout(
                        id: "card-leaf",
                        title: "Leaf size is not everything",
                        body: "Scale comes from the relationship between the whole tree and its foliage."
                    ),
                    PruningKnowledgeCallout(
                        id: "card-defoliation",
                        title: "Defoliation is not routine",
                        body: "Use foliage removal because the tree and the design benefit from it."
                    ),
                    PruningKnowledgeCallout(
                        id: "card-structure-first",
                        title: "Structure comes first",
                        body: "Removing leaves cannot create branches that do not exist."
                    ),
                    PruningKnowledgeCallout(
                        id: "card-know-species",
                        title: "A technique is not universal",
                        body: "A technique is not universal because another bonsai artist uses it."
                    ),
                    PruningKnowledgeCallout(
                        id: "card-growth-purpose",
                        title: "Manage growth with purpose",
                        body: "Every bud, shoot and needle is part of the tree's future."
                    )
                ]
            ),
            PruningKnowledgeSection(
                id: "long-shoots",
                heading: "Very long shoots after pruning",
                paragraphs: [
                    "Do not assume the next step is to cut harder."
                ],
                bullets: [
                    "Species behaviour",
                    "Tree vigor",
                    "Pruning timing",
                    "Fertilizing",
                    "Light"
                ],
                callouts: []
            ),
            PruningKnowledgeSection(
                id: "weak-branch",
                heading: "A branch became weak after repeated pruning",
                paragraphs: [
                    "Repeated shortening can starve a line that already lacks light or position."
                ],
                bullets: [
                    "Light access",
                    "Branch position",
                    "Over-pruning",
                    "Species behaviour"
                ],
                callouts: []
            ),
            PruningKnowledgeSection(
                id: "no-growth",
                heading: "No new growth after cutting back",
                paragraphs: [
                    "The tree may not be able to replace what you removed."
                ],
                bullets: [
                    "Species ability to back bud",
                    "Bud availability",
                    "Cut location",
                    "Tree health"
                ],
                callouts: []
            ),
            PruningKnowledgeSection(
                id: "flat",
                heading: "The tree looks flat after pruning",
                paragraphs: [
                    "Over-removal often shows first as a loss of depth, not only a shorter outline."
                ],
                bullets: [
                    "Depth",
                    "Branch hierarchy",
                    "Three-dimensional structure",
                    "Over-removal"
                ],
                callouts: []
            ),
            PruningKnowledgeSection(
                id: "connections",
                heading: "Connections to other Bonsai World knowledge",
                paragraphs: [
                    "Design Guidelines — branch placement, taper, structure, tree development and composition.",
                    "Bonsai Forms, Styles & Silhouette — silhouette, pads and empty space after a cut.",
                    "Bonsai Artistry & the Bonsai Eye — whether a cut improves the whole tree.",
                    "Wiring — branch positioning, movement and structural decisions.",
                    "Repotting — root work, tree stress and development stages. Care covers that work in the programme.",
                    "Fertilizing — growth management, and development versus refinement. Use Fertilizer Guides for practical feeding recommendations.",
                    "Species Library — species-specific pruning, defoliation suitability, pine management and seasonal timing.",
                    "Tree Health — weak trees, stress and recovery. Do not prune a diagnosis away.",
                    "Tools & Equipment — scissors, cutters and saws.",
                    "Deadwood — whether a dead branch remains as jin or is removed.",
                    "Advanced Techniques — when major work is justified, sacrifice planning and recovery.",
                    "Seasonal Care & Protection — species and local conditions decide when a cut belongs."
                ],
                bullets: [],
                callouts: []
            ),
            PruningKnowledgeSection(
                id: "visuals",
                heading: "Visual learning",
                paragraphs: [
                    "Future visual content should teach decisions: before and after pruning, branch selection, directional pruning, clip and grow sequences, development versus refinement, strong versus weak areas, branch problems and three-dimensional observation.",
                    "Do not use images merely as decoration."
                ],
                bullets: [],
                callouts: []
            ),
            PruningKnowledgeSection(
                id: "philosophy",
                heading: "Bonsai World philosophy",
                paragraphs: [
                    "Pruning is not the art of removing branches. It is the art of deciding what the tree should become.",
                    "Advanced pruning is not about removing more. It is about understanding what each part of the tree contributes to future development. A leaf supports energy. A bud may become a branch. A shoot may determine direction. A needle may contribute to balance.",
                    "Before removing anything, ask what this part of the tree is doing now — and what it could become next. Every branch that remains has a purpose. Every branch that is removed changes the future."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )
}
