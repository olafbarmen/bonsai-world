//
//  FormsStylesKnowledge.swift
//  Bonsai World
//
//  Knowledge → Bonsai Handbook → Bonsai Forms, Styles & Silhouette.
//  How to see structure. Named styles are frameworks, not categories to force.
//

import Foundation

struct FormsStylesCallout: Identifiable, Hashable, Sendable {
    var id: String
    var title: String
    var body: String
}

struct FormsStylesSection: Identifiable, Hashable, Sendable {
    var id: String
    var heading: String
    var paragraphs: [String]
    var bullets: [String]
    var callouts: [FormsStylesCallout]
}

struct FormsStylesLesson: Identifiable, Hashable, Sendable {
    var id: String
    var number: Int
    var title: String
    var summary: String
    var sections: [FormsStylesSection]
}

enum FormsStylesKnowledge {
    static let chapterTitle = "Bonsai Forms, Styles & Silhouette"

    static let openingLine =
        "Understanding how trunk, branches, foliage and empty space create a convincing bonsai."

    static let disclaimer =
        "This chapter teaches how to see the structure of a bonsai. Recognised styles can provide useful design frameworks. They are not a catalogue of names to force onto every tree. Styles provide a language for understanding bonsai. The tree itself should remain the starting point."

    static let lessons: [FormsStylesLesson] = [
        overview,
        triangleAndHierarchy,
        asymmetryAndMovement,
        silhouette,
        foliageMassesAndPads,
        depthAndLayering,
        negativeSpace,
        visualWeightAndCrown,
        uprightAndSlanting,
        cascadeAndLiterati,
        groupsAndMaterial,
        practice,
        quickGuides
    ]

    static func lesson(id: String) -> FormsStylesLesson? {
        lessons.first { $0.id == id }
    }

    // MARK: - 01 Overview

    private static let overview = FormsStylesLesson(
        id: "overview",
        number: 1,
        title: "Overview",
        summary: "Styles provide a language for understanding bonsai. The tree itself should remain the starting point.",
        sections: [
            FormsStylesSection(
                id: "composition",
                heading: "A visual composition",
                paragraphs: [
                    "A bonsai is not simply a tree made smaller. It is a visual composition. The viewer experiences the trunk, the roots, the branches, the foliage, the empty spaces and the overall silhouette. These elements must work together.",
                    "A tree may have excellent bark, beautiful branches and healthy foliage, and still lack a convincing overall form. Learning bonsai design therefore requires learning to see the whole tree."
                ],
                bullets: [],
                callouts: [
                    FormsStylesCallout(
                        id: "shape-together",
                        title: "Bonsai World principle",
                        body: "Do not only study the branches. Study the shape they create together."
                    ),
                    FormsStylesCallout(
                        id: "language",
                        title: "Bonsai World principle",
                        body: "Styles provide a language for understanding bonsai. The tree itself should remain the starting point."
                    )
                ]
            ),
            FormsStylesSection(
                id: "whole",
                heading: "From detail to composition",
                paragraphs: [
                    "Beginners often focus on individual features: a beautiful branch, a jin, a pad, a curve in the trunk. Bonsai design must also be evaluated from a distance.",
                    "Ask: what is the overall shape? Where does the eye travel? Where is the visual weight? Is the tree balanced? Does the silhouette communicate a clear character?",
                    "A strong bonsai should work as a whole composition, and as a collection of meaningful details. Bonsai Artistry & the Bonsai Eye trains that judgement. Design Guidelines remain a check, not a recipe."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )

    // MARK: - 02 Triangle, Base, Body & Apex

    private static let triangleAndHierarchy = FormsStylesLesson(
        id: "triangle-hierarchy",
        number: 2,
        title: "Triangle, Base, Body & Apex",
        summary: "Use the triangle to understand balance. Do not force the tree to become geometry.",
        sections: [
            FormsStylesSection(
                id: "triangle",
                heading: "A fundamental visual framework",
                paragraphs: [
                    "The triangular composition is one of the most recognisable visual frameworks in bonsai. It can create stability, direction, hierarchy and visual balance. The broad lower area may create visual weight. The narrowing upper area may guide the eye towards the apex.",
                    "Not every bonsai should look like a perfect geometric triangle. The triangle is a visual principle. Not a drawing to copy. Natural bonsai often contain irregularity, asymmetry, movement and variation."
                ],
                bullets: [],
                callouts: [
                    FormsStylesCallout(
                        id: "not-geometry",
                        title: "Bonsai World principle",
                        body: "Use the triangle to understand balance. Do not force the tree to become geometry."
                    )
                ]
            ),
            FormsStylesSection(
                id: "hierarchy",
                heading: "Base, body and apex",
                paragraphs: [
                    "A bonsai composition often develops through the base, the body and the apex. The base — roots and lower trunk — should normally communicate stability. The body — main trunk movement and branch structure — should communicate movement and development. The apex should provide resolution.",
                    "A weak apex may leave the composition feeling unfinished. An oversized apex may make the tree appear heavy. The apex should normally belong to the same visual language as the rest of the tree. Design Guidelines cover nebari, trunk, taper and apex as a check on the tree."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )

    // MARK: - 03 Asymmetry & Movement

    private static let asymmetryAndMovement = FormsStylesLesson(
        id: "asymmetry-movement",
        number: 3,
        title: "Asymmetry & Movement",
        summary: "Balance is not the same as equality. Movement should feel connected.",
        sections: [
            FormsStylesSection(
                id: "asymmetry",
                heading: "Why perfect balance often looks artificial",
                paragraphs: [
                    "Nature rarely creates perfect symmetry. Bonsai composition often benefits from unequal branch placement, different visual masses, irregular spacing and directional movement.",
                    "Balance does not require symmetry. A tree can be visually balanced while remaining structurally asymmetrical."
                ],
                bullets: [],
                callouts: [
                    FormsStylesCallout(
                        id: "not-equality",
                        title: "Bonsai World principle",
                        body: "Balance is not the same as equality."
                    )
                ]
            ),
            FormsStylesSection(
                id: "movement",
                heading: "Guiding the eye through the tree",
                paragraphs: [
                    "Movement may be created through trunk direction, curves, branch direction, foliage masses and deadwood. The eye should normally be able to travel through the tree.",
                    "Ask where the eye begins, where it moves, and where it finally rests. A composition without clear movement may appear static or confused. Movement should feel connected. Avoid adding individual curves or features that contradict the overall direction. Wiring sets living movement. Deadwood may support the same story."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )

    // MARK: - 04 Silhouette

    private static let silhouette = FormsStylesLesson(
        id: "silhouette",
        number: 4,
        title: "Silhouette",
        summary: "If the silhouette works, the tree can often be understood before the details are visible.",
        sections: [
            FormsStylesSection(
                id: "from-distance",
                heading: "The tree seen from a distance",
                paragraphs: [
                    "The silhouette is the outer shape created by the complete bonsai. It is one of the most important ways to evaluate the composition.",
                    "When viewing the silhouette, consider height, width, apex, lower visual weight, branch extension, irregularity and overall balance. A useful test is to imagine the tree as a dark shape. Would the overall character still be recognisable?"
                ],
                bullets: [],
                callouts: [
                    FormsStylesCallout(
                        id: "before-detail",
                        title: "Bonsai World principle",
                        body: "If the silhouette works, the tree can often be understood before the details are visible."
                    )
                ]
            )
        ]
    )

    // MARK: - 05 Foliage Masses & Pads

    private static let foliageMassesAndPads = FormsStylesLesson(
        id: "foliage-masses-pads",
        number: 5,
        title: "Foliage Masses & Pads",
        summary: "A pad should grow from the branch structure. It should not look attached to it.",
        sections: [
            FormsStylesSection(
                id: "masses",
                heading: "Seeing groups instead of individual leaves",
                paragraphs: [
                    "At a distance, the viewer does not always see individual leaves or needles. The eye sees mass, groups and shapes. These visible groups can be understood as foliage masses.",
                    "Foliage masses help create structure, depth, rhythm and balance. They should not simply become random collections of foliage. Each mass should contribute to the overall composition."
                ],
                bullets: [],
                callouts: []
            ),
            FormsStylesSection(
                id: "pads",
                heading: "Understanding pads",
                paragraphs: [
                    "A foliage pad is a visible foliage mass supported by branch structure. A pad is not a flat shape placed onto the tree. It is the visual result of branch development, ramification, controlled growth, direction and pruning.",
                    "Pads may help separate different areas of the tree visually. They can create layers, light and shadow, rhythm and depth. Pruning develops the structure that makes a pad possible."
                ],
                bullets: [],
                callouts: [
                    FormsStylesCallout(
                        id: "from-branch",
                        title: "Bonsai World principle",
                        body: "A pad should grow from the branch structure. It should not look attached to it."
                    )
                ]
            ),
            FormsStylesSection(
                id: "flat",
                heading: "Avoiding the flat pad",
                paragraphs: [
                    "A common styling mistake is creating perfectly flat foliage surfaces. This can make the tree appear artificial, two-dimensional and repetitive.",
                    "A convincing foliage mass often has front, middle and rear structure. It may also contain variation, open areas and different heights. The goal is not to create perfect green platforms. The goal is to create believable three-dimensional foliage structure."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )

    // MARK: - 06 Depth & Layering

    private static let depthAndLayering = FormsStylesLesson(
        id: "depth-layering",
        number: 6,
        title: "Depth & Layering",
        summary: "Do not build a beautiful picture. Build a tree.",
        sections: [
            FormsStylesSection(
                id: "depth",
                heading: "Bonsai is three-dimensional",
                paragraphs: [
                    "A bonsai must work from more than one angle. Branch structure should create front-to-back depth, not only left-to-right width.",
                    "Useful depth may be created through front branches, side branches, rear branches, overlapping foliage and different pad positions. A tree that looks convincing only from one flat front may lack structural depth."
                ],
                bullets: [],
                callouts: [
                    FormsStylesCallout(
                        id: "build-tree",
                        title: "Bonsai World principle",
                        body: "Do not build a beautiful picture. Build a tree."
                    )
                ]
            ),
            FormsStylesSection(
                id: "layering",
                heading: "Creating visual levels",
                paragraphs: [
                    "Branches and foliage masses may be arranged at different visual levels. This can help create depth, hierarchy, separation and rhythm.",
                    "Layering should not become mechanical. Avoid creating identical horizontal levels throughout the tree. Natural variation helps prevent the bonsai from appearing artificial."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )

    // MARK: - 07 Negative Space & Windows

    private static let negativeSpace = FormsStylesLesson(
        id: "negative-space",
        number: 7,
        title: "Negative Space",
        summary: "Empty space is part of the design. Openings should have visual purpose.",
        sections: [
            FormsStylesSection(
                id: "empty",
                heading: "The importance of empty space",
                paragraphs: [
                    "Negative space is the visual space between branches, foliage masses, trunk sections and the outer silhouette. Empty space helps the viewer understand the structure, see movement, recognise individual branches and avoid visual confusion.",
                    "A bonsai filled completely with foliage may become a green wall."
                ],
                bullets: [],
                callouts: [
                    FormsStylesCallout(
                        id: "empty-design",
                        title: "Bonsai World principle",
                        body: "Empty space is part of the design."
                    )
                ]
            ),
            FormsStylesSection(
                id: "windows",
                heading: "Allow the tree to breathe",
                paragraphs: [
                    "Open areas may reveal trunk movement, branch structure and depth. Open spaces should not become random holes. They should have visual purpose.",
                    "Ask what this opening reveals. Does it improve the composition? Or does it simply remove foliage?"
                ],
                bullets: [],
                callouts: []
            )
        ]
    )

    // MARK: - 08 Visual Weight, Crown & Apex

    private static let visualWeightAndCrown = FormsStylesLesson(
        id: "visual-weight-crown",
        number: 8,
        title: "Visual Weight, Crown & Apex",
        summary: "The crown must belong to the tree. The apex is the visual conclusion, not only the highest point.",
        sections: [
            FormsStylesSection(
                id: "weight",
                heading: "Where does the tree feel heavy?",
                paragraphs: [
                    "Visual weight is not always related to physical weight. A branch may feel visually heavy because of dense foliage, dark mass, strong direction or large size.",
                    "A composition should distribute visual weight intentionally. Consider the lower structure, major branches and the crown. One side may be heavier than the other without creating imbalance. The question is whether the composition still feels stable."
                ],
                bullets: [],
                callouts: []
            ),
            FormsStylesSection(
                id: "crown",
                heading: "The crown must belong to the tree",
                paragraphs: [
                    "A common mistake is creating a trunk, then a separate foliage structure above it. The crown should feel connected to the trunk's movement and character.",
                    "A powerful trunk may support a powerful crown. A delicate trunk may require a lighter visual structure. The foliage should help explain the tree beneath it."
                ],
                bullets: [],
                callouts: []
            ),
            FormsStylesSection(
                id: "apex",
                heading: "Resolving the composition",
                paragraphs: [
                    "The apex is more than the highest point. It is the visual conclusion of the tree. A convincing apex should relate to trunk movement, fit the silhouette, avoid excessive heaviness and remain believable.",
                    "The apex does not always need to be perfectly centred. Its position may contribute to movement, asymmetry and character. Design Guidelines: one apex, finishing in the direction set by the base."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )

    // MARK: - 09 Upright & Slanting

    private static let uprightAndSlanting = FormsStylesLesson(
        id: "upright-slanting",
        number: 9,
        title: "Upright & Slanting",
        summary: "Recognised styles describe direction and stability. They do not require the material to become a drawing.",
        sections: [
            FormsStylesSection(
                id: "formal",
                heading: "Formal upright",
                paragraphs: [
                    "The formal upright style is characterised by strong vertical trunk direction, clear taper, a stable base, balanced branch structure and a defined apex. The overall character often communicates order, strength and stability.",
                    "Avoid forcing naturally curved or irregular material into a formal upright style. The name is useful when the tree already offers that direction."
                ],
                bullets: [],
                callouts: []
            ),
            FormsStylesSection(
                id: "informal",
                heading: "Informal upright",
                paragraphs: [
                    "The informal upright style uses natural trunk movement, curves and changes in direction. The tree should remain visually balanced while avoiding rigid symmetry.",
                    "The style is often suitable for material with natural movement. The apex should still provide a convincing conclusion."
                ],
                bullets: [],
                callouts: []
            ),
            FormsStylesSection(
                id: "slanting",
                heading: "Slanting",
                paragraphs: [
                    "The trunk grows at a noticeable angle. The composition must still communicate stability. The roots and visual weight should support the direction of the tree.",
                    "A slant should appear intentional. Not accidental."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )

    // MARK: - 10 Cascade, Semi-Cascade & Literati

    private static let cascadeAndLiterati = FormsStylesLesson(
        id: "cascade-literati",
        number: 10,
        title: "Cascade, Semi-Cascade & Literati",
        summary: "Downward movement and restraint are compositions, not tricks. Removing branches alone does not create literati.",
        sections: [
            FormsStylesSection(
                id: "cascade",
                heading: "Cascade",
                paragraphs: [
                    "In cascade, the trunk moves downward below the level of the container. The style may suggest mountain exposure, damage or growth from difficult positions.",
                    "The downward movement should remain part of a complete composition. Cascade does not mean simply bending the tree downward. Design Guidelines: cascade follows the same branch logic as an upright, except the trunk moves down."
                ],
                bullets: [],
                callouts: []
            ),
            FormsStylesSection(
                id: "semi",
                heading: "Semi-cascade",
                paragraphs: [
                    "The trunk moves downward, but the composition remains less extreme than a full cascade. The style should maintain clear direction, visual balance and a believable relationship between the container and the tree.",
                    "Pots & Containers belong in that relationship. Display & Presentation asks whether the composed tree still reads as one idea."
                ],
                bullets: [],
                callouts: []
            ),
            FormsStylesSection(
                id: "literati",
                heading: "Literati",
                paragraphs: [
                    "Literati often emphasises trunk character, movement, space and simplicity. The foliage may be limited. The trunk becomes the primary visual element.",
                    "Literati requires restraint. Removing branches alone does not create a convincing literati bonsai. The remaining structure must still communicate intention."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )

    // MARK: - 11 Groups, Landscape & Material

    private static let groupsAndMaterial = FormsStylesLesson(
        id: "groups-material",
        number: 11,
        title: "Groups, Landscape & Material",
        summary: "The material often contains the beginning of the design. Named styles are useful frameworks, not mandatory categories.",
        sections: [
            FormsStylesSection(
                id: "broom",
                heading: "Broom",
                paragraphs: [
                    "The trunk rises relatively straight before dividing into a broad branching structure. The crown creates a rounded, balanced, branch-supported silhouette.",
                    "The style is particularly connected to species capable of fine ramification. The crown should not appear as a ball placed on top of a stick. Branch structure must support the visible form. Species Library belongs in that judgement."
                ],
                bullets: [],
                callouts: []
            ),
            FormsStylesSection(
                id: "multi-clump",
                heading: "Multi-trunk and clump",
                paragraphs: [
                    "In multi-trunk, more than one trunk contributes to the composition. The trunks should normally create hierarchy, relationship and a shared visual story. Avoid making all trunks equal, parallel or visually disconnected. One trunk may often act as the dominant structure.",
                    "In clump, multiple trunks emerge from a connected base. The composition should communicate one natural group, not several separate trees placed together. Trunk thickness, direction, spacing and height should create variation."
                ],
                bullets: [],
                callouts: []
            ),
            FormsStylesSection(
                id: "forest-raft",
                heading: "Forest, raft and root-over-rock",
                paragraphs: [
                    "In forest, multiple trees create a single landscape composition. The goal is not to display a collection of identical trees. The group should create depth, perspective, hierarchy and variation. Negative space is particularly important. The viewer should experience a forest, not a row of trees.",
                    "In raft, a horizontal or fallen structure creates multiple vertical trunks. The design should communicate a shared origin, natural development and relationship between the trunks. The original horizontal structure should contribute to the story.",
                    "In root-over-rock, the tree and rock must form one composition. The roots should appear to grip, follow and interact naturally with the rock. The rock should not appear as a decorative object placed underneath the tree. Both elements must support the same visual story."
                ],
                bullets: [],
                callouts: []
            ),
            FormsStylesSection(
                id: "material",
                heading: "Let the material suggest the direction",
                paragraphs: [
                    "Before selecting a recognised style, study trunk movement, root base, existing branches, natural damage and tree character. Do not begin with wanting a style, then force the tree to become it. Ask what direction this material suggests.",
                    "Not every bonsai must fit perfectly into a recognised style. Some trees are strongest when natural movement, existing character and individual structure guide the design. Styles should be understood as useful frameworks. Not mandatory categories. Bonsai Material & Sourcing trains evaluating that material before years of work."
                ],
                bullets: [],
                callouts: [
                    FormsStylesCallout(
                        id: "material-leads",
                        title: "Bonsai World principle",
                        body: "The material often contains the beginning of the design."
                    )
                ]
            )
        ]
    )

    // MARK: - 12 Practice

    private static let practice = FormsStylesLesson(
        id: "practice",
        number: 12,
        title: "Practice",
        summary: "Before major design decisions, ask what the tree is capable of becoming — not only what style it should become.",
        sections: [
            FormsStylesSection(
                id: "mistakes",
                heading: "Common design mistakes",
                paragraphs: [
                    "Forcing every bonsai into a perfect triangle. Creating perfectly symmetrical branches. Building flat foliage pads. Ignoring front-to-back depth. Filling every empty space with foliage.",
                    "Creating a crown unrelated to the trunk. Making the apex too heavy. Repeating identical branch layers. Forcing unsuitable material into a named style. Styling only for the chosen front and ignoring the three-dimensional tree."
                ],
                bullets: [],
                callouts: []
            ),
            FormsStylesSection(
                id: "framework",
                heading: "The form decision framework",
                paragraphs: [
                    "Before making major design decisions, walk these questions. The last two decide whether a named style is helping, or getting in the way."
                ],
                bullets: [
                    "What is the strongest feature of this tree?",
                    "What direction does the trunk suggest?",
                    "Where is the visual weight?",
                    "Does the silhouette have a clear character?",
                    "Is the tree visually balanced?",
                    "Is there sufficient depth?",
                    "Can the branch structure still be understood?",
                    "Does the foliage support the trunk?",
                    "Does a recognised style help the design?",
                    "Would a more natural form be stronger?"
                ],
                callouts: []
            ),
            FormsStylesSection(
                id: "paths",
                heading: "Beginner, intermediate and advanced",
                paragraphs: [
                    "Beginner — learn to recognise overall silhouette, basic triangular balance, the trunk and crown relationship, and basic negative space. Do not feel pressure to name a style.",
                    "Intermediate — develop foliage masses, pads, depth, layering and style recognition as language, not as a checklist to complete.",
                    "Advanced — individual interpretation, complex visual balance, naturalistic design, controlled asymmetry, and style adaptation without imitation."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )

    // MARK: - 13 Quick Guides

    private static let quickGuides = FormsStylesLesson(
        id: "quick-guides",
        number: 13,
        title: "Quick Guides",
        summary: "Do not ask only what style this tree should become. Ask what this tree is capable of becoming.",
        sections: [
            FormsStylesSection(
                id: "cards",
                heading: "Quick knowledge cards",
                paragraphs: [],
                bullets: [],
                callouts: [
                    FormsStylesCallout(
                        id: "card-whole",
                        title: "See the whole tree",
                        body: "Details matter. But the composition must work first."
                    ),
                    FormsStylesCallout(
                        id: "card-triangle",
                        title: "The triangle is a guide",
                        body: "Use visual frameworks. Do not force geometry."
                    ),
                    FormsStylesCallout(
                        id: "card-depth",
                        title: "Build depth",
                        body: "A bonsai is a tree. Not a flat image."
                    ),
                    FormsStylesCallout(
                        id: "card-pads",
                        title: "Pads need structure",
                        body: "A foliage pad should grow from the branch beneath it."
                    ),
                    FormsStylesCallout(
                        id: "card-space",
                        title: "Leave space",
                        body: "Empty space helps the tree become visible."
                    ),
                    FormsStylesCallout(
                        id: "card-material",
                        title: "Let material lead",
                        body: "The strongest design often begins with what the tree already offers."
                    )
                ]
            ),
            FormsStylesSection(
                id: "connections",
                heading: "Connections to other Bonsai World knowledge",
                paragraphs: [
                    "Bonsai Artistry & the Bonsai Eye — design judgement, individual interpretation and visual decisions.",
                    "Design Guidelines — trunk development, branch structure, apex and composition as a check.",
                    "Pruning — branch selection, foliage management, pad development, leaf reduction and defoliation as design decisions.",
                    "Wiring — branch positioning, structural direction and movement.",
                    "Deadwood — character, movement and visual storytelling.",
                    "Pots & Containers — style relationship and visual balance with the container.",
                    "Display & Presentation — whether the composed tree still reads as one idea.",
                    "Species Library — species suitability and natural growth characteristics.",
                    "Bonsai Material & Sourcing — what the material can become before a name is applied."
                ],
                bullets: [],
                callouts: []
            ),
            FormsStylesSection(
                id: "closing",
                heading: "Final Bonsai World principle",
                paragraphs: [
                    "A bonsai style is not created by applying a name to a tree. A convincing form develops when the material, the trunk, the branches, the foliage, the empty space and the silhouette begin to work together.",
                    "Styles can help us understand bonsai. But the tree must still be allowed to remain itself.",
                    "Do not ask only: what style should this tree become? Ask: what is this tree capable of becoming?"
                ],
                bullets: [],
                callouts: []
            )
        ]
    )
}
