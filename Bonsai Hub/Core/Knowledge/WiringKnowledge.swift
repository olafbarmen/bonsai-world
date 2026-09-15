//
//  WiringKnowledge.swift
//  Bonsai World
//
//  Knowledge → Bonsai Handbook → Wiring.
//  Wire is a design tool. Decisions follow species, wood, health and the next stage.
//

import Foundation

struct WiringKnowledgeCallout: Identifiable, Hashable, Sendable {
    var id: String
    var title: String
    var body: String
}

struct WiringKnowledgeSection: Identifiable, Hashable, Sendable {
    var id: String
    var heading: String
    var paragraphs: [String]
    var bullets: [String]
    var callouts: [WiringKnowledgeCallout]
}

struct WiringKnowledgeLesson: Identifiable, Hashable, Sendable {
    var id: String
    var number: Int
    var title: String
    var summary: String
    var sections: [WiringKnowledgeSection]
}

enum WiringKnowledge {
    static let chapterTitle = "Wiring"

    static let openingLine =
        "Understanding how wire can guide the future of a bonsai — from basic branch positioning to advanced structural styling."

    static let disclaimer =
        "Species, wood, health, stage, season and design goal change the answer. Treat this as decision support — not a formula for putting wire on every branch."

    static let lessons: [WiringKnowledgeLesson] = [
        overview,
        typesOfWire,
        thicknessAndLength,
        anchoring,
        applying,
        positioning,
        trunkAndHeavy,
        species,
        timing,
        wiringAndPruning,
        practice,
        quickGuides
    ]

    static func lesson(id: String) -> WiringKnowledgeLesson? {
        lessons.first { $0.id == id }
    }

    // MARK: - 01 Overview

    private static let overview = WiringKnowledgeLesson(
        id: "overview",
        number: 1,
        title: "Overview",
        summary: "Wire is temporary. The movement it creates may become permanent. Know why a branch should move before you attach anything.",
        sections: [
            WiringKnowledgeSection(
                id: "introduction",
                heading: "Wiring bonsai",
                paragraphs: [
                    "Wiring is one of the defining techniques of bonsai. Pruning removes growth. Wiring gives existing growth a new direction.",
                    "A branch may be shortened with pruning. Wiring can change direction, create movement, open space, create depth, lower or raise a branch, rotate it, position foliage and establish future structure.",
                    "Wiring is not simply a mechanical technique. It is a design tool. The wire itself is temporary. The movement created by the wire can influence the tree for years."
                ],
                bullets: [],
                callouts: [
                    WiringKnowledgeCallout(
                        id: "temporary",
                        title: "Bonsai World principle",
                        body: "Wire is temporary. The movement it creates may become permanent."
                    )
                ]
            ),
            WiringKnowledgeSection(
                id: "what",
                heading: "What is bonsai wiring?",
                paragraphs: [
                    "Bonsai wire is used to temporarily hold trunks, branches, shoots and leaders in a new position while the tree gradually adapts.",
                    "There is a difference between positioning and forcing. Wire should guide a branch into a new position. It should not be treated as a tool for forcing every branch into an extreme position.",
                    "Good wiring begins with understanding the natural possibilities of the material."
                ],
                bullets: [],
                callouts: []
            ),
            WiringKnowledgeSection(
                id: "why",
                heading: "Why wire a bonsai?",
                paragraphs: [
                    "Wiring may create movement, change direction, improve branch placement, open the tree, create depth, establish a branch structure, improve silhouette, create asymmetry, position a future leader, develop a more natural appearance or correct previous growth.",
                    "Not every design problem should automatically be solved with wire. Sometimes the better solution is pruning, growing a new branch, selecting another branch, or allowing the tree to develop further."
                ],
                bullets: [],
                callouts: [
                    WiringKnowledgeCallout(
                        id: "available",
                        title: "Bonsai World principle",
                        body: "Do not wire a branch simply because wire is available."
                    )
                ]
            ),
            WiringKnowledgeSection(
                id: "before",
                heading: "Before you wire",
                paragraphs: [
                    "Examine the trunk line, the branch structure, the front, the intended design, branch thickness, branch flexibility and the health of the tree. Do not begin wiring before having a general idea of the desired result."
                ],
                bullets: [
                    "What needs to move?",
                    "Why does it need to move?",
                    "Where should it move?",
                    "How far does it need to move?",
                    "Can pruning solve the problem instead?",
                    "Could the branch break?",
                    "Does this branch need to be wired now?"
                ],
                callouts: [
                    WiringKnowledgeCallout(
                        id: "where-going",
                        title: "Bonsai World principle",
                        body: "Know where the branch is going before you attach the wire."
                    )
                ]
            )
        ]
    )

    // MARK: - 02 Types

    private static let typesOfWire = WiringKnowledgeLesson(
        id: "types",
        number: 2,
        title: "Types of Wire",
        summary: "Aluminium and copper have different working characters. Choice follows species, branch strength, desired movement and experience — not a rigid split.",
        sections: [
            WiringKnowledgeSection(
                id: "aluminium",
                heading: "Aluminium wire",
                paragraphs: [
                    "Aluminium is commonly used for many deciduous and broadleaf species. It is soft and easy to work with, available in different diameters, and suitable for a wide range of bonsai applications."
                ],
                bullets: [],
                callouts: []
            ),
            WiringKnowledgeSection(
                id: "copper",
                heading: "Copper wire",
                paragraphs: [
                    "Copper is often stronger for its diameter and commonly used for conifers. It can be more demanding to apply and often requires preparation and experience.",
                    "Wire choice should consider species, branch strength, desired movement and the artist's experience. Aluminium and copper are not rigidly exclusive to specific groups."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )

    // MARK: - 03 Thickness & length

    private static let thicknessAndLength = WiringKnowledgeLesson(
        id: "thickness-length",
        number: 3,
        title: "Wire Thickness & Length",
        summary: "The wire must control the branch without excessive force. Prepare enough length to anchor, follow the line and finish — then apply.",
        sections: [
            WiringKnowledgeSection(
                id: "thickness",
                heading: "Selecting the correct wire thickness",
                paragraphs: [
                    "Wire must be strong enough to hold the branch in its intended position. It should not be unnecessarily thick.",
                    "The correct wire depends on branch diameter, flexibility, wood density, species, length of branch and the degree of movement required. There is no single fixed percentage rule that is universal.",
                    "Experienced artists test the relationship between wire, branch and movement. The key question is whether this wire can control the branch without excessive force."
                ],
                bullets: [],
                callouts: []
            ),
            WiringKnowledgeSection(
                id: "length",
                heading: "Wire length",
                paragraphs: [
                    "Prepare enough length to anchor correctly, follow the branch and reach the intended endpoint. Avoid excessive waste. Avoid wire that is too short and forces a compromised application.",
                    "Prepare, apply, observe — rather than apply quickly and correct later."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )

    // MARK: - 04 Anchoring

    private static let anchoring = WiringKnowledgeLesson(
        id: "anchoring",
        number: 4,
        title: "Anchoring",
        summary: "The wire needs stability before the branch can move. Anchoring must not create unnecessary pressure or damage.",
        sections: [
            WiringKnowledgeSection(
                id: "why-anchor",
                heading: "Why anchoring matters",
                paragraphs: [
                    "Wire must have sufficient stability before a branch can be moved. Potential anchor points may include the trunk, another branch, or a suitable structural point.",
                    "Anchoring decisions depend on tree structure, branch position, wire thickness and intended movement. Anchoring must not create unnecessary pressure or damage. There is no single universal method."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )

    // MARK: - 05 Applying

    private static let applying = WiringKnowledgeLesson(
        id: "applying",
        number: 5,
        title: "Applying Wire",
        summary: "Single and double wiring, angle, and working from a stable base toward the tip. One oversized wire cannot control a complex structure.",
        sections: [
            WiringKnowledgeSection(
                id: "single",
                heading: "Single wiring",
                paragraphs: [
                    "When wiring one branch, attend to the anchor, wire direction, spiral angle, consistent contact and branch support.",
                    "The wire should follow the branch structure without loose sections, excessive gaps, unnecessary overlapping, or pressure points."
                ],
                bullets: [],
                callouts: []
            ),
            WiringKnowledgeSection(
                id: "double",
                heading: "Double wiring",
                paragraphs: [
                    "Two branches may be wired with one piece of wire where that is appropriate. Consider suitable branch selection, structural balance, anchoring through the trunk area and efficient wire use.",
                    "Double wiring is useful in some situations. Two individual wires may provide better control in others."
                ],
                bullets: [],
                callouts: []
            ),
            WiringKnowledgeSection(
                id: "angle",
                heading: "Wire angle",
                paragraphs: [
                    "The wire should create sufficient mechanical support while allowing the branch to bend. One exact angle is not mandatory.",
                    "Too open gives insufficient control. Too tight adds unnecessary material and pressure. Consistent wrapping gives controlled support."
                ],
                bullets: [],
                callouts: []
            ),
            WiringKnowledgeSection(
                id: "base-to-tip",
                heading: "From the base to the tip",
                paragraphs: [
                    "Wiring usually follows the branch from a stable base toward smaller growth. That gives structural control, respects taper, and allows changing wire thickness as the branch thins.",
                    "Complex branches may require more than one wire. Do not attempt to control an entire complex structure with one oversized wire."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )

    // MARK: - 06 Positioning

    private static let positioning = WiringKnowledgeLesson(
        id: "positioning",
        number: 6,
        title: "Positioning & Movement",
        summary: "Applying wire is only preparation. Position with intention, in three dimensions, and only where movement has a reason.",
        sections: [
            WiringKnowledgeSection(
                id: "bending",
                heading: "Bending a branch",
                paragraphs: [
                    "Applying wire is only the preparation. The next step is positioning.",
                    "Before bending, support the branch, understand the desired movement, consider the strongest and weakest points, and avoid sudden uncontrolled force. Movement should often be built gradually."
                ],
                bullets: [],
                callouts: [
                    WiringKnowledgeCallout(
                        id: "intention",
                        title: "Bonsai World principle",
                        body: "Position the branch with intention, not force."
                    )
                ]
            ),
            WiringKnowledgeSection(
                id: "movement",
                heading: "Creating movement",
                paragraphs: [
                    "Movement should relate to trunk movement, branch hierarchy, species character, tree age and design style. Gentle movement, direction changes and natural irregularity matter more than repetitive patterns.",
                    "Not every branch requires multiple curves. A straight section may be appropriate. A gentle change may be more convincing than dramatic movement."
                ],
                bullets: [],
                callouts: [
                    WiringKnowledgeCallout(
                        id: "reason",
                        title: "Bonsai World principle",
                        body: "Movement should have a reason."
                    )
                ]
            ),
            WiringKnowledgeSection(
                id: "three-d",
                heading: "Wiring in three dimensions",
                paragraphs: [
                    "A bonsai is a three-dimensional object. A branch can move up, down, left, right, forward and backward. Good positioning considers the front view, the side view and the top view.",
                    "A branch that looks correct from the front may block depth, cross another branch, move directly toward the viewer or create congestion.",
                    "Wire, position, step back, view from multiple angles, then adjust."
                ],
                bullets: [],
                callouts: []
            ),
            WiringKnowledgeSection(
                id: "more-than-down",
                heading: "Branch positioning",
                paragraphs: [
                    "Bonsai wiring is often incorrectly simplified to wiring the branch down. Branches may instead need to move sideways, forward or backward, rotate, rise slightly, or take a new direction.",
                    "Positioning can create depth, space, hierarchy and balance."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )

    // MARK: - 07 Trunk & heavy

    private static let trunkAndHeavy = WiringKnowledgeLesson(
        id: "trunk-heavy",
        number: 7,
        title: "Trunk & Heavy Bending",
        summary: "Early trunk movement, advanced bends, guy wires and protection. Respect the limits of the wood — especially as a beginner.",
        sections: [
            WiringKnowledgeSection(
                id: "trunk",
                heading: "Wiring the trunk",
                paragraphs: [
                    "Young and flexible material can often be wired to establish trunk movement. Consider material flexibility, future taper, natural movement and development stage.",
                    "Trunk wiring may be particularly important during early development. Avoid unnecessary dramatic curves. Movement should relate to species, tree style and natural character."
                ],
                bullets: [],
                callouts: []
            ),
            WiringKnowledgeSection(
                id: "heavy",
                heading: "Heavy bending",
                paragraphs: [
                    "Heavy bending is an advanced technique. Assess flexibility, identify weak points, move gradually, support vulnerable areas and respect species-specific limitations.",
                    "Raffia protection, additional support, guy wires and leveraging methods belong here as future technique — not as beginner routine. Do not attempt aggressive bends without understanding the risks."
                ],
                bullets: [],
                callouts: [
                    WiringKnowledgeCallout(
                        id: "limits",
                        title: "Bonsai World principle",
                        body: "Every major bend must respect the limits of the wood."
                    )
                ]
            ),
            WiringKnowledgeSection(
                id: "guy",
                heading: "Guy wires",
                paragraphs: [
                    "Guy wires can pull a branch downward, create directional movement, move thicker branches or make gradual adjustments. Advantages include less wire on the branch and strong directional control.",
                    "Secure the anchor points, protect bark, and inspect regularly."
                ],
                bullets: [],
                callouts: []
            ),
            WiringKnowledgeSection(
                id: "raffia",
                heading: "Raffia and branch protection",
                paragraphs: [
                    "Protective techniques can support vulnerable areas and reduce risk during significant bends. Species differ. Advanced experience is required.",
                    "These methods are not automatically necessary for normal branch wiring."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )

    // MARK: - 08 Species

    private static let species = WiringKnowledgeLesson(
        id: "species",
        number: 8,
        title: "Species",
        summary: "Wire according to how the species grows. Deciduous, conifer, tropical and evergreen broadleaf trees do not share one method.",
        sections: [
            WiringKnowledgeSection(
                id: "deciduous",
                heading: "Deciduous trees",
                paragraphs: [
                    "Consider branch flexibility, bud protection, seasonal timing and the risk of wire scars. Species still differ within the deciduous group."
                ],
                bullets: [],
                callouts: []
            ),
            WiringKnowledgeSection(
                id: "conifers",
                heading: "Conifers",
                paragraphs: [
                    "Conifers often need stronger wire. Copper is commonly used. Dense foliage and species differences change both application and inspection."
                ],
                bullets: [],
                callouts: []
            ),
            WiringKnowledgeSection(
                id: "tropical",
                heading: "Tropical bonsai",
                paragraphs: [
                    "Active growth and rapid thickening mean more frequent inspection. A wire schedule copied from a temperate deciduous tree will not fit."
                ],
                bullets: [],
                callouts: []
            ),
            WiringKnowledgeSection(
                id: "evergreen",
                heading: "Evergreen broadleaf bonsai",
                paragraphs: [
                    "Species-specific differences in bark, flexibility and growth speed still decide the work. Species Profiles should carry more specific guidance where it exists."
                ],
                bullets: [],
                callouts: [
                    WiringKnowledgeCallout(
                        id: "how-grows",
                        title: "Key principle",
                        body: "Wire according to how the species grows, not according to a universal method."
                    )
                ]
            )
        ]
    )

    // MARK: - 09 Timing

    private static let timing = WiringKnowledgeLesson(
        id: "timing",
        number: 9,
        title: "Timing & Removal",
        summary: "When to wire, when not to, how scars form, and how to take wire off. Watch the tree, not a fixed number of months.",
        sections: [
            WiringKnowledgeSection(
                id: "when",
                heading: "When to wire",
                paragraphs: [
                    "Timing depends on species, climate, growth activity, bark sensitivity and branch flexibility. Different trees may be wired successfully at different times.",
                    "Separate major structural wiring from refinement wiring, from young shoots, from mature branches. Do not create one universal wiring calendar."
                ],
                bullets: [],
                callouts: []
            ),
            WiringKnowledgeSection(
                id: "when-not",
                heading: "When not to wire",
                paragraphs: [
                    "Delay when the tree is weak or recovering, when environmental stress is severe, when a branch is too brittle or actively unsuitable for movement, or when there is no clear design purpose."
                ],
                bullets: [],
                callouts: [
                    WiringKnowledgeCallout(
                        id: "not-every",
                        title: "Bonsai World principle",
                        body: "Not every branch needs to be wired."
                    )
                ]
            ),
            WiringKnowledgeSection(
                id: "scars",
                heading: "Wire scars",
                paragraphs: [
                    "Wire can begin to mark bark when the branch expands. Species, growth speed, bark thickness and whether the wood is young or mature all change how quickly that happens.",
                    "Wire must be inspected regularly. It should not be removed according to a fixed calendar. Remove according to tree growth, wire pressure and branch response."
                ],
                bullets: [],
                callouts: []
            ),
            WiringKnowledgeSection(
                id: "when-remove",
                heading: "When to remove wire",
                paragraphs: [
                    "Removal depends on whether the branch has set, on growth, on wire pressure and on species. Do not assume a number of months. Different branches can set at different speeds."
                ],
                bullets: [],
                callouts: [
                    WiringKnowledgeCallout(
                        id: "watch-tree",
                        title: "Bonsai World principle",
                        body: "Watch the tree, not the calendar."
                    )
                ]
            ),
            WiringKnowledgeSection(
                id: "how-remove",
                heading: "How to remove wire",
                paragraphs: [
                    "Bonsai wire should normally be removed by cutting it into sections. Avoid unwinding wire from a branch. Unwinding can damage buds, damage bark and break small branches.",
                    "Use appropriate cutters. Remove carefully."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )

    // MARK: - 10 Wiring and pruning

    private static let wiringAndPruning = WiringKnowledgeLesson(
        id: "wiring-pruning",
        number: 10,
        title: "Wiring and Pruning",
        summary: "Pruning decides what remains. Wiring decides where it goes. Early movement and later refinement are different jobs.",
        sections: [
            WiringKnowledgeSection(
                id: "two-decisions",
                heading: "Two different decisions",
                paragraphs: [
                    "Pruning determines what remains. Wiring determines where it goes. The sequence is not automatic in every situation. It depends on the work and the design goal."
                ],
                bullets: [
                    "Does this branch belong? No → remove or replace.",
                    "Yes — does it need a new position? No → leave it.",
                    "Yes → consider wiring."
                ],
                callouts: []
            ),
            WiringKnowledgeSection(
                id: "development",
                heading: "Wiring and development",
                paragraphs: [
                    "Wiring can establish future structure early. A small movement made in a young branch may prevent the need for major bending later.",
                    "Early wiring, growth, selection and pruning form a long-term development process."
                ],
                bullets: [],
                callouts: []
            ),
            WiringKnowledgeSection(
                id: "refinement",
                heading: "Wiring and refinement",
                paragraphs: [
                    "Refined bonsai may require small adjustments, fine branch positioning, careful spacing and foliage pad organisation.",
                    "Advanced wiring should become increasingly subtle. The viewer should see the tree, not the technique used to create it."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )

    // MARK: - 11 Practice

    private static let practice = WiringKnowledgeLesson(
        id: "practice",
        number: 11,
        title: "Practice",
        summary: "Beginner mistakes, wiring with a future plan, reading the tree, a decision framework, and what to learn at each level.",
        sections: [
            WiringKnowledgeSection(
                id: "mistakes",
                heading: "Common beginner mistakes",
                paragraphs: [
                    "Wiring without a design plan. Using wire that is too thin, or unnecessarily thick. Wiring too loosely. Creating identical curves on every branch. Bending too aggressively.",
                    "Leaving wire on too long. Removing wire by unwinding it. Wiring every branch. Styling only from the front."
                ],
                bullets: [],
                callouts: []
            ),
            WiringKnowledgeSection(
                id: "advanced",
                heading: "Wire with a future plan",
                paragraphs: [
                    "Advanced wiring considers current position, future thickening, future pruning, future branch development and the long-term silhouette.",
                    "A branch does not necessarily need to sit exactly where it will remain forever. Sometimes it should be positioned to develop strength, create future movement, or prepare for later refinement.",
                    "The advanced question is not where this branch should be today. The advanced question is where this branch needs to be for the tree's next stage."
                ],
                bullets: [],
                callouts: []
            ),
            WiringKnowledgeSection(
                id: "reading",
                heading: "Reading the tree before wiring",
                paragraphs: [
                    "Observe natural movement, strong and weak lines, existing bends, branch origins, negative space, depth, the front and alternative fronts.",
                    "Ask what already works, what needs correction, what should be emphasised, and what should remain untouched."
                ],
                bullets: [],
                callouts: [
                    WiringKnowledgeCallout(
                        id: "not-change",
                        title: "Bonsai World principle",
                        body: "Good wiring often begins by deciding what not to change."
                    )
                ]
            ),
            WiringKnowledgeSection(
                id: "framework",
                heading: "A practical decision framework",
                paragraphs: [
                    "Work through the steps in order. Positioning is gradual. Inspection continues after the wire is on."
                ],
                bullets: [
                    "Step 1 — What is the design goal?",
                    "Step 2 — Does this branch need to move?",
                    "Step 3 — Can pruning solve the problem instead?",
                    "Step 4 — Is the branch healthy and flexible enough?",
                    "Step 5 — Select appropriate wire.",
                    "Step 6 — Plan the anchor.",
                    "Step 7 — Apply the wire.",
                    "Step 8 — Position gradually.",
                    "Step 9 — Check from multiple angles.",
                    "Step 10 — Monitor the wire regularly."
                ],
                callouts: []
            ),
            WiringKnowledgeSection(
                id: "paths",
                heading: "Beginner, intermediate, advanced",
                paragraphs: [
                    "Beginner: why wire is used, aluminium and copper, basic wire selection, basic single wiring, safe branch positioning and wire removal.",
                    "Intermediate: double wiring, directional movement, three-dimensional positioning, clip and grow combined with wiring, and branch hierarchy.",
                    "Advanced: heavy bending, guy wires, complex structural movement, species-specific response, refinement wiring and long-term design positioning."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )

    // MARK: - 12 Quick Guides

    private static let quickGuides = WiringKnowledgeLesson(
        id: "quick-guides",
        number: 12,
        title: "Quick Guides",
        summary: "Short cards, troubleshooting, links to other Bonsai World knowledge, and the principle that closes the chapter.",
        sections: [
            WiringKnowledgeSection(
                id: "cards",
                heading: "Quick knowledge cards",
                paragraphs: [],
                bullets: [],
                callouts: [
                    WiringKnowledgeCallout(
                        id: "card-purpose",
                        title: "Wire with purpose",
                        body: "Every wired branch should have a reason to move."
                    ),
                    WiringKnowledgeCallout(
                        id: "card-temporary",
                        title: "Wire is temporary",
                        body: "The movement created by wire can shape the tree for years."
                    ),
                    WiringKnowledgeCallout(
                        id: "card-right",
                        title: "Choose the right wire",
                        body: "Strong enough to control. Light enough to work naturally."
                    ),
                    WiringKnowledgeCallout(
                        id: "card-3d",
                        title: "Think in three dimensions",
                        body: "A bonsai is not designed from the front alone."
                    ),
                    WiringKnowledgeCallout(
                        id: "card-force",
                        title: "Do not force",
                        body: "Respect the limits of the branch."
                    ),
                    WiringKnowledgeCallout(
                        id: "card-scars",
                        title: "Watch for scars",
                        body: "Wire removal depends on growth, not the calendar."
                    )
                ]
            ),
            WiringKnowledgeSection(
                id: "returns",
                heading: "The branch returns to its previous position",
                paragraphs: [
                    "The hold was not enough, or the wood has not set."
                ],
                bullets: [
                    "Wire strength",
                    "Branch thickness",
                    "Branch flexibility",
                    "Time required to set"
                ],
                callouts: []
            ),
            WiringKnowledgeSection(
                id: "cutting-in",
                heading: "The wire is cutting into the bark",
                paragraphs: [
                    "Assess immediate removal. Future checks should be more frequent."
                ],
                bullets: [],
                callouts: []
            ),
            WiringKnowledgeSection(
                id: "broke",
                heading: "The branch broke while bending",
                paragraphs: [
                    "The movement exceeded what the wood could accept."
                ],
                bullets: [
                    "Degree of movement",
                    "Branch flexibility",
                    "Species",
                    "Bend technique",
                    "Timing"
                ],
                callouts: []
            ),
            WiringKnowledgeSection(
                id: "artificial",
                heading: "The tree looks artificial after wiring",
                paragraphs: [
                    "The technique is showing. Recheck whether the movement still relates to the trunk."
                ],
                bullets: [
                    "Repetitive curves",
                    "Excessive movement",
                    "Branch symmetry",
                    "Natural relationship to trunk"
                ],
                callouts: []
            ),
            WiringKnowledgeSection(
                id: "front-only",
                heading: "Correct from the front, wrong from other angles",
                paragraphs: [
                    "The tree was styled as a picture, not as an object."
                ],
                bullets: [
                    "Depth",
                    "Branch overlap",
                    "Forward and backward movement",
                    "Three-dimensional positioning"
                ],
                callouts: []
            ),
            WiringKnowledgeSection(
                id: "connections",
                heading: "Connections to other Bonsai World knowledge",
                paragraphs: [
                    "Design Guidelines — branch placement, movement, composition, depth and tree development.",
                    "Bonsai Forms, Styles & Silhouette — whether movement still serves the whole silhouette.",
                    "Bonsai Artistry & the Bonsai Eye — whether movement supports the tree or distracts from it.",
                    "Pruning — branch selection, direction and structural decisions.",
                    "Tree development in Design Guidelines — early structure and long-term branch development.",
                    "Species Profiles — species-specific flexibility, wire type, timing and bark sensitivity.",
                    "Tree Health — stress, recovery, and when to avoid major work.",
                    "Tools & Equipment — wire cutters, pliers and raffia.",
                    "Deadwood — whether wiring should follow a story already in the wood, not only living movement.",
                    "Advanced Techniques — when major bends, raffia and splitting are justified.",
                    "Bonsai Collection Management — wiring dates and inspection so wire is not forgotten.",
                    "Seasonal Care & Protection — inspect wire as growth changes through the year."
                ],
                bullets: [],
                callouts: []
            ),
            WiringKnowledgeSection(
                id: "visuals",
                heading: "Visual learning",
                paragraphs: [
                    "Future visual content should teach decisions and technique: wire thickness comparisons, correct and incorrect application, single and double wiring, before and after positioning, three-dimensional views, natural versus repetitive movement, wire scar progression and guy wire examples.",
                    "Do not use visuals merely as decoration."
                ],
                bullets: [],
                callouts: []
            ),
            WiringKnowledgeSection(
                id: "philosophy",
                heading: "Bonsai World philosophy",
                paragraphs: [
                    "Wiring is not about making branches bend. It is about giving the tree direction. The wire is only a temporary tool.",
                    "The real work is understanding where the branch is, where it can go, and where it should be allowed to become part of the future tree.",
                    "The best wiring is not recognised by the wire itself. It is recognised years later, when the movement feels as though the tree created it naturally."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )
}
