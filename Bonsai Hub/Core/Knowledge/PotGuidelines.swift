//
//  PotGuidelines.swift
//  Bonsai World
//
//  Knowledge → Bonsai Handbook → Pots & Containers.
//  The pot serves the tree, but the tree and pot create one composition.
//

import Foundation

struct PotKnowledgeCallout: Identifiable, Hashable, Sendable {
    var id: String
    var title: String
    var body: String
}

struct PotKnowledgeSection: Identifiable, Hashable, Sendable {
    var id: String
    var heading: String
    var paragraphs: [String]
    var bullets: [String]
    var callouts: [PotKnowledgeCallout]
}

struct PotKnowledgeLesson: Identifiable, Hashable, Sendable {
    var id: String
    var number: Int
    var title: String
    var summary: String
    var sections: [PotKnowledgeSection]
}

enum PotGuidelines {
    static let chapterTitle = "Pots & Containers"

    static let openingLine =
        "From training containers to refined bonsai pots — understanding function, proportion, character and the relationship between tree and container."

    static let disclaimer =
        "Species, size, trunk, nebari, style, development stage, visual weight and display intention change the answer. Traditional proportions are starting points — not targets."

    static let lessons: [PotKnowledgeLesson] = [
        overview,
        containerTypes,
        materials,
        shape,
        sizeAndDepth,
        visualWeight,
        drainage,
        treeAndCharacter,
        planting,
        speciesAndSeason,
        practice,
        troubleshooting,
        quickGuides
    ]

    static func lesson(id: String) -> PotKnowledgeLesson? {
        lessons.first { $0.id == id }
    }

    // MARK: - 01 Overview

    private static let overview = PotKnowledgeLesson(
        id: "overview",
        number: 1,
        title: "Overview",
        summary: "The container is part of the bonsai. The pot serves the tree, but the tree and pot create one composition.",
        sections: [
            PotKnowledgeSection(
                id: "introduction",
                heading: "Every bonsai lives in a container",
                paragraphs: [
                    "Not every container serves the same purpose. During development, the primary goal may be root development, trunk development, strong growth or recovery. During refinement, the container becomes increasingly important for root control, water management, visual balance and artistic expression.",
                    "The pot is part of the picture, not simply a container for the tree. A tree that is still being built does not need the same pot as a tree prepared for display. A training pot can be larger, cheaper, deeper, or plastic. A refined pot should support the tree both biologically and artistically.",
                    "Final pot selection depends on species, tree size, trunk character, root base, branch structure, style, development stage, visual weight, pot character and display intention. Traditional proportions and design principles are useful guidelines. They are not laws."
                ],
                bullets: [],
                callouts: [
                    PotKnowledgeCallout(
                        id: "part-of-bonsai",
                        title: "Bonsai World principle",
                        body: "The container is part of the bonsai."
                    ),
                    PotKnowledgeCallout(
                        id: "one-composition",
                        title: "Bonsai World principle",
                        body: "The pot serves the tree, but the tree and pot create one composition."
                    )
                ]
            )
        ]
    )

    // MARK: - 02 Container Types

    private static let containerTypes = PotKnowledgeLesson(
        id: "container-types",
        number: 2,
        title: "Container Types",
        summary: "Ask what this container is intended to achieve. Do not restrict development for the sake of premature refinement.",
        sections: [
            PotKnowledgeSection(
                id: "categories",
                heading: "Understanding container categories",
                paragraphs: [
                    "Nursery containers, growing containers, development boxes, training pots, mica pots, plastic containers, ceramic bonsai pots and exhibition pots all exist. These categories may overlap.",
                    "The important question is what this container is intended to achieve — not what it is called."
                ],
                bullets: [],
                callouts: []
            ),
            PotKnowledgeSection(
                id: "development",
                heading: "Development containers",
                paragraphs: [
                    "Development containers are selected primarily to support root growth, tree growth, recovery and practical cultivation. They may prioritise function over appearance. Nursery containers, training pots, grow boxes and large bonsai containers can all serve that work.",
                    "A tree should not necessarily be placed into a refined final pot too early. A refined pot is not automatically a sign of a refined bonsai."
                ],
                bullets: [],
                callouts: [
                    PotKnowledgeCallout(
                        id: "not-premature",
                        title: "Bonsai World principle",
                        body: "Do not restrict development for the sake of premature refinement."
                    )
                ]
            ),
            PotKnowledgeSection(
                id: "training",
                heading: "Training pots",
                paragraphs: [
                    "Training pots can provide greater root control, bonsai-oriented root development, practical cultivation and more manageable tree proportions.",
                    "They are useful when the tree is beyond early development but not yet ready for its final presentation container. That is a bridge — not a lesser pot, and not a finished composition."
                ],
                bullets: [],
                callouts: []
            ),
            PotKnowledgeSection(
                id: "final",
                heading: "Final bonsai pots",
                paragraphs: [
                    "When the container becomes part of the design, consider shape, depth, colour, texture, material and visual weight.",
                    "The final pot should support the tree's character. Not compete with it."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )

    // MARK: - 03 Materials

    private static let materials = PotKnowledgeLesson(
        id: "materials",
        number: 3,
        title: "Materials",
        summary: "Ceramic, mica, plastic and wood each have horticultural and practical roles. Glaze is character, not a species law.",
        sections: [
            PotKnowledgeSection(
                id: "ceramic",
                heading: "Ceramic",
                paragraphs: [
                    "Ceramic pots are the traditional artistic container: glazed and unglazed finishes, weight, long-term use and wide variation in character.",
                    "They are often the choice for display. They are not the only valid container for a living tree."
                ],
                bullets: [],
                callouts: []
            ),
            PotKnowledgeSection(
                id: "mica",
                heading: "Mica",
                paragraphs: [
                    "Mica pots are durable, practical and consistent in construction. They are widely used in training because they behave like a bonsai pot horticulturally without requiring an exhibition-quality ceramic."
                ],
                bullets: [],
                callouts: []
            ),
            PotKnowledgeSection(
                id: "plastic",
                heading: "Plastic",
                paragraphs: [
                    "Plastic is lightweight and practical. It is useful for development and suitable for some training situations. A plastic pot can be the right horticultural choice even when it is not the artistic choice."
            ],
            bullets: [],
                callouts: []
            ),
            PotKnowledgeSection(
                id: "wood",
                heading: "Wooden containers",
                paragraphs: [
                    "Wooden boxes and grow containers can support development, growing and root control. Durability and construction matter. Wood is a horticultural tool here, not automatically a display object."
            ],
            bullets: [],
                callouts: []
            ),
            PotKnowledgeSection(
                id: "glaze",
                heading: "Glazed versus unglazed",
                paragraphs: [
                    "Glazed pots may provide colour, visual contrast, seasonal expression and greater decorative presence. Unglazed pots may provide natural character, an earthy appearance, strong visual weight, and a traditional pairing with many conifers.",
                    "These are useful traditions and tendencies, not absolute laws. Do not reduce the decision to deciduous equals glazed, or conifer equals unglazed."
            ],
            bullets: [
                    "Conifers: often paired with unglazed pots in earth tones.",
                    "Deciduous trees: often work well with glazed pots.",
                    "Flowering and fruiting trees: glaze can be chosen to support the flowers or fruit rather than simply matching them."
                ],
                callouts: []
            )
        ]
    )

    // MARK: - 04 Shape

    private static let shape = PotKnowledgeLesson(
        id: "shape",
        number: 4,
        title: "Shape",
        summary: "The shape of the pot should support the character of the tree. Tendencies are not rules.",
        sections: [
            PotKnowledgeSection(
                id: "shapes",
                heading: "Understanding shape",
                paragraphs: [
                    "Oval, rectangle, square, round, drum, cascade, semi-cascade, irregular and custom artistic forms all exist. Shape influences visual stability, formality, movement and character.",
                "The long side of the pot generally establishes the viewing width of the composition."
                ],
                bullets: [],
                callouts: []
            ),
            PotKnowledgeSection(
                id: "rectangular",
                heading: "Rectangular pots",
                paragraphs: [
                    "Rectangular pots can communicate structure, strength, formality and stability. They may work particularly well with trees possessing strong trunks, formal structure or angular movement.",
                    "They often work well with trees with relatively little trunk movement or with a strong, substantial trunk. A deep rectangular pot can support a massive trunk and powerful tree, particularly when combined with a stronger rim and substantial feet. This is a tendency, not a rule."
                ],
                bullets: [],
                callouts: []
            ),
            PotKnowledgeSection(
                id: "oval",
                heading: "Oval pots",
                paragraphs: [
                    "Oval pots can create softer movement, elegance and a more natural composition. They may work well with deciduous trees, informal forms and trees with flowing movement.",
                    "Oval or round pots often suit trees with stronger movement and softer lines."
                ],
                bullets: [],
                callouts: []
            ),
            PotKnowledgeSection(
                id: "round",
                heading: "Round and round-cornered pots",
                paragraphs: [
                    "Round forms may influence visual flow, informality and tree movement. A round pot can create harmony or visual instability, depending on the tree. Consider balance carefully."
                ],
                bullets: [],
                callouts: []
            ),
            PotKnowledgeSection(
                id: "square",
                heading: "Square pots",
                paragraphs: [
                    "Square pots often communicate solidity, strength and structure. They may be appropriate for trees with strong visual mass, powerful trunks and bold character."
                ],
                bullets: [],
                callouts: []
            ),
            PotKnowledgeSection(
                id: "cascade",
                heading: "Cascade pots",
                paragraphs: [
                    "Cascade containers require appropriate depth, stability and visual balance. The container must support both the root system and the visual movement of the tree. Cascade generally needs a deeper pot."
                ],
                bullets: [],
                callouts: []
            ),
            PotKnowledgeSection(
                id: "style-shapes",
                heading: "Literati, forest and other pairings",
                paragraphs: [
                    "Literati often benefits from a small, quiet pot, frequently round. Forest or group planting often uses a large, shallow oval or a slab.",
                    "Avoid creating one fixed pot for every style. Teach the relationship, then look at the tree you have."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )

    // MARK: - 05 Size & Depth

    private static let sizeAndDepth = PotKnowledgeLesson(
        id: "size-depth",
        number: 5,
        title: "Size & Depth",
        summary: "Guidelines support judgement. They do not replace it. Do not choose depth based only on aesthetics.",
        sections: [
            PotKnowledgeSection(
                id: "size",
                heading: "Proportion without formula worship",
                paragraphs: [
                    "For many upright trees, a useful starting point is a pot width of about two thirds of the tree's height. For very short and wide trees, use about two thirds of the tree's spread instead.",
                    "These are starting proportions, not targets. No formula can replace artistic judgement. A visually appropriate pot may not follow a mathematical formula exactly. Consider tree height, trunk thickness, canopy width, root base, visual mass and tree style."
                ],
                bullets: [],
                callouts: [
                    PotKnowledgeCallout(
                        id: "not-formulas",
                        title: "Bonsai World principle",
                        body: "Guidelines support judgement. They do not replace it."
                    )
                ]
            ),
            PotKnowledgeSection(
                id: "too-large-small",
                heading: "Too large and too small",
                paragraphs: [
                    "A pot that is too large can make the tree look young and may retain too much moisture. A pot that is too small can restrict root development and make maintaining the tree more difficult."
                ],
                bullets: [],
                callouts: []
            ),
            PotKnowledgeSection(
                id: "depth",
                heading: "Function and proportion",
                paragraphs: [
                    "Depth influences root volume, water behaviour and visual balance. Pot depth is often related to trunk caliper for upright trees. Cascades generally need a deeper pot. Many good display trees use pots that are shallower than these guidelines.",
                    "A deep pot may support more root volume, change moisture behaviour and create different visual weight. A shallow pot may increase refinement, restrict root space and require more precise cultivation. Do not choose depth based only on aesthetics."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )

    // MARK: - 06 Visual Weight

    private static let visualWeight = PotKnowledgeLesson(
        id: "visual-weight",
        number: 6,
        title: "Visual Weight",
        summary: "Match visual weight, not only measurements. Two pots of identical dimensions can feel completely different.",
        sections: [
            PotKnowledgeSection(
                id: "weight",
                heading: "Why size is not everything",
                paragraphs: [
                    "The details of the pot contribute to the visual weight of the tree. Visual weight may be influenced by colour, depth, wall thickness, shape, texture and feet.",
                    "A heavy-looking pot may overpower a delicate tree. A visually light pot may fail to support a powerful tree. A powerful tree can carry a stronger rim and more substantial feet. A delicate tree generally benefits from a quieter pot with less visual weight."
                ],
                bullets: [],
                callouts: [
                    PotKnowledgeCallout(
                        id: "match-weight",
                        title: "Bonsai World principle",
                        body: "Match visual weight, not only measurements."
                    )
                ]
            ),
            PotKnowledgeSection(
                id: "colour",
                heading: "Colour as part of the composition",
                paragraphs: [
                    "Pot colour can relate to bark, foliage, flowers, fruit, seasonal colour and tree character. Colour should support the composition. Avoid a colour-matching formula.",
                    "Contrast can be useful. Harmony can also be useful. Quiet pots are generally easier to get right than highly decorative or strongly coloured pots."
                ],
                bullets: [],
                callouts: []
            ),
            PotKnowledgeSection(
                id: "texture",
                heading: "Surface character",
                paragraphs: [
                    "Texture may create age, roughness, elegance, natural appearance or formality. Consider how texture interacts with bark, deadwood and trunk movement."
                ],
                bullets: [],
                callouts: []
            ),
            PotKnowledgeSection(
                id: "feet",
                heading: "Pot feet",
                paragraphs: [
                    "Feet lift the pot visually and physically. They also influence water drainage and visual character. Foot size, shape and position are part of the complete design."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )

    // MARK: - 07 Drainage

    private static let drainage = PotKnowledgeLesson(
        id: "drainage",
        number: 7,
        title: "Drainage",
        summary: "Drainage holes, mesh and anchoring are horticultural function. They belong with Repotting, Soil & Substrate and Watering.",
        sections: [
            PotKnowledgeSection(
                id: "holes",
                heading: "Essential function",
                paragraphs: [
                    "Drainage holes allow water to leave the pot. They matter for water movement, root health, drainage mesh and wire anchoring.",
                    "Repotting covers pot preparation and securing. Soil & Substrate covers how the mix behaves in that volume. Watering covers how the pot dries."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )

    // MARK: - 08 Tree & Character

    private static let treeAndCharacter = PotKnowledgeLesson(
        id: "tree-character",
        number: 8,
        title: "Tree & Character",
        summary: "The pot should support the tree's visual story. Not create a competing story.",
        sections: [
            PotKnowledgeSection(
                id: "style",
                heading: "Pot design and tree style",
                paragraphs: [
                    "Pot selection may relate to formal upright, informal upright, slanting, cascade, semi-cascade, literati, broom, multi-trunk and forest. Avoid creating one fixed pot for every style. Teach relationships, then look at this tree."
                ],
                bullets: [],
                callouts: []
            ),
            PotKnowledgeSection(
                id: "strong-delicate",
                heading: "Strong and delicate trees",
                paragraphs: [
                    "Trees may visually communicate strong character — thick trunk, heavy bark, powerful nebari — or delicate character — fine branching, light trunk movement, elegant foliage.",
                    "Use terms such as powerful, delicate, strong, elegant, rugged and refined. Traditional bonsai terminology can still help, but do not reduce the decision only to masculine or feminine."
                ],
                bullets: [],
                callouts: []
            ),
            PotKnowledgeSection(
                id: "trunk",
                heading: "Trunk character",
                paragraphs: [
                    "Consider thickness, taper, movement, bark and age impression. A pot should reinforce the visual story. Not create a competing story."
                ],
                bullets: [],
                callouts: []
            ),
            PotKnowledgeSection(
                id: "nebari",
                heading: "Nebari and the pot",
                paragraphs: [
                    "The root base and pot relationship is the transition between tree and container. Consider root spread, surface roots, trunk flare and planting angle.",
                    "A strong nebari may require sufficient visual space. Do not visually compress an important root base unnecessarily."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )

    // MARK: - 09 Planting

    private static let planting = PotKnowledgeLesson(
        id: "planting",
        number: 9,
        title: "Planting",
        summary: "The pot and tree must agree. The goal is visual stability, not symmetry.",
        sections: [
            PotKnowledgeSection(
                id: "position",
                heading: "Where the tree sits in the pot",
                paragraphs: [
                    "Trees are not always planted exactly in the centre. The tree is normally placed slightly behind the centre line of the pot. It is also often positioned slightly to the left or right of centre rather than directly in the middle.",
                    "Leave more visual space in the direction of the tree's movement or its longer branch structure. A formal upright can sit closer to the centre, while still normally being positioned slightly toward the back.",
                    "The placement should create visual balance between the tree and the empty space around it. Design Guidelines in this Handbook cover composition on the tree."
                ],
                bullets: [],
                callouts: []
            ),
            PotKnowledgeSection(
                id: "angle",
                heading: "Planting angle",
                paragraphs: [
                    "Changing planting angle changes tree movement, root presentation and composition. The chosen pot must work with the final planting angle. Do not select the pot independently from the planting position."
                ],
                bullets: [],
                callouts: []
            ),
            PotKnowledgeSection(
                id: "balance",
                heading: "Creating one composition",
                paragraphs: [
                    "Balance the mass of the tree and the mass of the pot. The goal is not symmetry. The goal is visual stability. A tree may have asymmetrical movement while the total composition remains balanced."
                ],
                bullets: [],
                callouts: []
            ),
            PotKnowledgeSection(
                id: "compete",
                heading: "The pot should not compete",
                paragraphs: [
                    "A highly decorative pot may compete with dramatic bark, flowers, fruit, deadwood or complex branch structure. A simpler pot may sometimes be the stronger artistic choice. Simple does not automatically mean better.",
                    "The pot should support the tree rather than compete with its bark, flowers or fruit. The correct question is what strengthens this tree. The best pot is not necessarily the most beautiful pot on its own. It is the pot that makes the tree and the composition stronger."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )

    // MARK: - 10 Species & Season

    private static let speciesAndSeason = PotKnowledgeLesson(
        id: "species-season",
        number: 10,
        title: "Species & Season",
        summary: "Pot refinement should follow tree refinement. Seasonal display changes how colour and character are read.",
        sections: [
            PotKnowledgeSection(
                id: "deciduous",
                heading: "Deciduous trees",
                paragraphs: [
                    "Consider seasonal change, branch structure, foliage colour and fine ramification. Avoid universal glazed or unglazed rules."
                ],
                bullets: [],
                callouts: []
            ),
            PotKnowledgeSection(
                id: "conifers",
                heading: "Conifers",
                paragraphs: [
                    "Consider bark, strength, age, deadwood and foliage mass. Traditional pairings with unglazed earth tones remain useful tendencies. Artistic flexibility still belongs to the tree in front of you."
                ],
                bullets: [],
                callouts: []
            ),
            PotKnowledgeSection(
                id: "flowering",
                heading: "Flowering bonsai",
                paragraphs: [
                    "Flowering trees already possess strong visual colour. The pot should consider flower colour, seasonal display and visual competition."
                ],
                bullets: [],
                callouts: []
            ),
            PotKnowledgeSection(
                id: "fruiting",
                heading: "Fruiting bonsai",
                paragraphs: [
                    "Fruit can change colour balance, visual weight and seasonal composition. Pot selection should support the complete seasonal presentation."
                ],
                bullets: [],
                callouts: []
            ),
            PotKnowledgeSection(
                id: "seasonal",
                heading: "Seasonal pot selection",
                paragraphs: [
                    "Seasonal display may influence the perceived relationship between pot colour, foliage, flowers, fruit and bark. This is especially relevant for exhibition and formal display."
                ],
                bullets: [],
                callouts: []
            ),
            PotKnowledgeSection(
                id: "age",
                heading: "Matching age impression",
                paragraphs: [
                    "The perceived age of the tree may influence texture, surface, colour and pot style. A visually ancient tree may require different artistic support than a young, fresh-looking tree. Avoid rigid rules."
                ],
                bullets: [],
                callouts: []
            ),
            PotKnowledgeSection(
                id: "ready",
                heading: "When is a tree ready for a final pot?",
                paragraphs: [
                    "A tree may not be ready for its final pot if it still requires major trunk development, major branch development, strong recovery or large root development.",
                    "Moving from development to refinement may involve root reduction, smaller root volume, different substrate and increased watering precision. Repotting, Soil & Substrate and Watering sit beside that transition."
                ],
                bullets: [],
                callouts: [
                    PotKnowledgeCallout(
                        id: "follow-tree",
                        title: "Bonsai World principle",
                        body: "Pot refinement should follow tree refinement."
                    )
                ]
            )
        ]
    )

    // MARK: - 11 Practice

    private static let practice = PotKnowledgeLesson(
        id: "practice",
        number: 11,
        title: "Practice",
        summary: "The goal is not to find the correct pot. The goal is to find the strongest composition.",
        sections: [
            PotKnowledgeSection(
                id: "mistakes",
                heading: "Common beginner mistakes",
                paragraphs: [
                    "Choosing the pot before understanding the tree. Putting an undeveloped tree into a final pot too early. Following size formulas blindly. Ignoring visual weight.",
                    "Choosing a pot because it is beautiful by itself. Ignoring planting angle. Ignoring root development. Matching colour too literally. Choosing a decorative pot that competes with the tree. Treating the pot as an accessory instead of part of the composition."
                ],
                bullets: [],
                callouts: []
            ),
            PotKnowledgeSection(
                id: "advanced",
                heading: "The final artistic decision",
                paragraphs: [
                    "Advanced pot selection considers tree, pot, season and display. The same tree may work in several technically correct pots. The artistic decision is therefore often about character.",
                    "Ask what this pot says about the tree. Does it make the tree appear older, stronger, more elegant, more natural or more refined? Compare alternatives. Do not choose the first technically acceptable option."
                ],
                bullets: [],
                callouts: []
            ),
            PotKnowledgeSection(
                id: "framework",
                heading: "Practical pot selection framework",
                paragraphs: [
                    "Understand the horticultural need first, then the visual story, then compare."
            ],
            bullets: [
                    "Understand the tree's development stage.",
                    "Determine the horticultural requirements.",
                    "Evaluate trunk character.",
                    "Evaluate nebari.",
                    "Evaluate tree style and movement.",
                    "Determine planting angle.",
                    "Consider pot size and depth.",
                    "Consider visual weight.",
                    "Consider shape.",
                    "Consider colour and texture.",
                    "Evaluate the complete composition.",
                    "Compare alternatives."
                ],
                callouts: []
            ),
            PotKnowledgeSection(
                id: "paths",
                heading: "Beginner, intermediate and advanced",
                paragraphs: [
                    "Beginner — different container types; development versus refinement; basic size and depth; basic pot shapes.",
                    "Intermediate — visual weight; colour; character; planting position.",
                    "Advanced — artistic composition; seasonal display; character relationships; exhibition-level selection."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )

    // MARK: - 12 Troubleshooting

    private static let troubleshooting = PotKnowledgeLesson(
        id: "troubleshooting",
        number: 12,
        title: "Troubleshooting",
        summary: "A pot problem may be visual, horticultural, or both. Check before you swap.",
        sections: [
            PotKnowledgeSection(
                id: "heavy",
                heading: "The tree appears visually heavy",
                paragraphs: [
                    "Check pot depth, pot shape, pot colour and visual weight."
                ],
                bullets: [],
                callouts: []
            ),
            PotKnowledgeSection(
                id: "dominates",
                heading: "The pot visually dominates the tree",
                paragraphs: [
                    "Check decoration, colour, texture and size."
                ],
                bullets: [],
                callouts: []
            ),
            PotKnowledgeSection(
                id: "unstable",
                heading: "The tree appears unstable",
                paragraphs: [
                    "Check planting position, pot width, visual balance and tree movement."
                ],
                bullets: [],
                callouts: []
            ),
            PotKnowledgeSection(
                id: "dries",
                heading: "The tree dries too quickly after moving to a new pot",
                paragraphs: [
                    "Check pot size, pot depth, substrate and root volume."
                ],
                bullets: [],
                callouts: []
            ),
            PotKnowledgeSection(
                id: "wet",
                heading: "The tree remains wet too long",
                paragraphs: [
                    "Check pot depth, root volume, substrate and watering."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )

    // MARK: - 13 Quick Guides

    private static let quickGuides = PotKnowledgeLesson(
        id: "quick-guides",
        number: 13,
        title: "Quick Guides",
        summary: "The best pot does not ask to be admired first. It makes the bonsai stronger.",
        sections: [
            PotKnowledgeSection(
                id: "cards",
                heading: "Knowledge cards",
                paragraphs: [],
                bullets: [],
                callouts: [
                    PotKnowledgeCallout(
                        id: "card-part",
                        title: "The pot is part of the bonsai",
                        body: "The composition begins below the trunk."
                    ),
                    PotKnowledgeCallout(
                        id: "card-function",
                        title: "Function first",
                        body: "Do not sacrifice tree health for premature refinement."
                    ),
                    PotKnowledgeCallout(
                        id: "card-character",
                        title: "Match character",
                        body: "The pot should support the tree's visual story."
                    ),
                    PotKnowledgeCallout(
                        id: "card-weight",
                        title: "Visual weight matters",
                        body: "Two pots with identical dimensions may feel completely different."
                    ),
                    PotKnowledgeCallout(
                        id: "card-formulas",
                        title: "Do not worship formulas",
                        body: "Guidelines support judgement. They do not replace it."
                    ),
                    PotKnowledgeCallout(
                        id: "card-compare",
                        title: "Compare alternatives",
                        body: "The first acceptable pot may not be the strongest choice."
                    )
                ]
            ),
            PotKnowledgeSection(
                id: "connections",
                heading: "Connections to other Bonsai World knowledge",
                paragraphs: [
                    "Repotting — pot preparation, root work and anchoring.",
                    "Soil & Substrate — root environment and water behaviour.",
                    "Watering — pot volume and drying speed.",
                    "Tree development — development containers and growth strategy.",
                    "Design Guidelines — planting position, visual balance and composition.",
                    "Bonsai Forms, Styles & Silhouette — style relationship and whether the pot supports the silhouette.",
                    "Display & Presentation — tree, pot, stand and complete presentation."
                ],
                bullets: [],
                callouts: []
            ),
            PotKnowledgeSection(
                id: "matching-tool",
                heading: "Future: Pot Matching Tool",
                paragraphs: [
                    "A future tool could take species, tree height, trunk thickness, style, development stage, pot dimensions, shape and colour, then help evaluate proportion, visual weight and possible pot styles.",
                    "It should not claim that one pot is objectively correct. Use language such as strong match, possible match, worth comparing, or potential visual conflict. Photo-based comparison would be exploration — not automatic artistic judgement."
                ],
                bullets: [],
                callouts: []
            ),
            PotKnowledgeSection(
                id: "philosophy",
                heading: "Bonsai World philosophy",
                paragraphs: [
                    "A bonsai pot is not a frame placed around a finished tree. It is part of the finished tree. The roots grow within it. The tree rises from it. The eye reads the tree through it.",
                    "The best pot does not ask to be admired first. It makes the bonsai stronger. When tree and pot truly belong together, the viewer no longer sees two objects. They see one composition."
            ],
            bullets: [],
                callouts: []
            )
        ]
    )
}
