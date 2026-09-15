//
//  DisplayKnowledge.swift
//  Bonsai World
//
//  Knowledge → Bonsai Handbook → Display & Presentation.
//  A display is one visual experience, not a collection of beautiful objects.
//

import Foundation

struct DisplayKnowledgeCallout: Identifiable, Hashable, Sendable {
    var id: String
    var title: String
    var body: String
}

struct DisplayKnowledgeSection: Identifiable, Hashable, Sendable {
    var id: String
    var heading: String
    var paragraphs: [String]
    var bullets: [String]
    var callouts: [DisplayKnowledgeCallout]
}

struct DisplayKnowledgeLesson: Identifiable, Hashable, Sendable {
    var id: String
    var number: Int
    var title: String
    var summary: String
    var sections: [DisplayKnowledgeSection]
}

enum DisplayKnowledge {
    static let chapterTitle = "Display & Presentation"

    static let openingLine =
        "The art of presenting bonsai — from a single tree on a bench to a complete seasonal composition."

    static let disclaimer =
        "Traditional principles are guidelines and visual relationships, not a formula to copy. Species, tree character, personal expression, contemporary presentation and cultural context all belong in the decision."

    static let lessons: [DisplayKnowledgeLesson] = [
        overview,
        viewingTheTree,
        spaceAndHierarchy,
        potAndStand,
        traditionalDisplay,
        supportingElements,
        season,
        exhibition,
        lightAndPhotography,
        places,
        practice,
        troubleshooting,
        quickGuides
    ]

    static func lesson(id: String) -> DisplayKnowledgeLesson? {
        lessons.first { $0.id == id }
    }

    // MARK: - 01 Overview

    private static let overview = DisplayKnowledgeLesson(
        id: "overview",
        number: 1,
        title: "Overview",
        summary: "A bonsai display is not a collection of beautiful objects. It is one visual experience.",
        sections: [
            DisplayKnowledgeSection(
                id: "introduction",
                heading: "More than putting a tree on a table",
                paragraphs: [
                    "A bonsai can be cultivated successfully for many years. Presentation is the moment when the artistic decisions become visible. The viewer experiences the tree, the pot, the space around it, the direction of movement, the season and the supporting elements.",
                    "A good display does not simply show a bonsai. It helps the viewer understand it. Display involves selection, placement, viewing direction, height, space, supporting elements and environment.",
                    "A display can range from a single bonsai presented simply to a complete formal composition. The same tree may require different presentation depending on exhibition, home display, photography, garden viewing, competition or educational presentation."
                ],
                bullets: [],
                callouts: [
                    DisplayKnowledgeCallout(
                        id: "one-experience",
                        title: "Bonsai World principle",
                        body: "A bonsai display is not a collection of beautiful objects. It is one visual experience."
                    ),
                    DisplayKnowledgeCallout(
                        id: "reveals-art",
                        title: "Bonsai World principle",
                        body: "Presentation does not add art to a bonsai. It reveals the art already within it."
                    )
                ]
            ),
            DisplayKnowledgeSection(
                id: "single",
                heading: "The single tree display",
                paragraphs: [
                    "A single bonsai can be a complete display. Consider front, viewing height, background, stand, lighting and negative space. The purpose is to allow the tree to be understood clearly."
                ],
                bullets: [],
                callouts: [
                    DisplayKnowledgeCallout(
                        id: "not-complicated",
                        title: "Bonsai World principle",
                        body: "If the tree is strong enough, the display does not need to become complicated."
                    )
                ]
            )
        ]
    )

    // MARK: - 02 Viewing the Tree

    private static let viewingTheTree = DisplayKnowledgeLesson(
        id: "viewing",
        number: 2,
        title: "Viewing the Tree",
        summary: "Height, front and movement decide how the tree is understood. Evaluate from a realistic viewing position.",
        sections: [
            DisplayKnowledgeSection(
                id: "height",
                heading: "Viewing height",
                paragraphs: [
                    "Display height affects perceived power, trunk movement, branch structure, nebari and overall composition. A tree displayed too high or too low may be experienced differently from its intended viewing angle.",
                    "Evaluate the tree from a realistic viewing position — not only from a convenient camera height or from above the bench."
                ],
                bullets: [],
                callouts: []
            ),
            DisplayKnowledgeSection(
                id: "front",
                heading: "Selecting the front",
                paragraphs: [
                    "The front is not necessarily the side with the most branches. The best front should be evaluated through nebari, trunk movement, taper, branch structure, depth, visual balance and negative space.",
                    "The display front may evolve as the tree develops. Design Guidelines in this Handbook cover how the tree itself is composed."
                ],
                bullets: [],
                callouts: []
            ),
            DisplayKnowledgeSection(
                id: "movement",
                heading: "Direction and movement",
                paragraphs: [
                    "Bonsai often create directional movement. The display should consider lean, branch direction, apex movement and visual flow.",
                    "A tree should generally have visual space in the direction where the composition moves. That is a tendency of balance and intention — not an absolute rule."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )

    // MARK: - 03 Space & Hierarchy

    private static let spaceAndHierarchy = DisplayKnowledgeLesson(
        id: "space-hierarchy",
        number: 3,
        title: "Space & Hierarchy",
        summary: "Empty space is part of the composition. Secondary elements should support the bonsai, not compete with it.",
        sections: [
            DisplayKnowledgeSection(
                id: "space",
                heading: "Negative space",
                paragraphs: [
                    "Empty space is not unused space. Negative space allows the viewer to read the silhouette, understand movement and experience balance.",
                    "Too many objects can weaken a display."
                ],
                bullets: [],
                callouts: [
                    DisplayKnowledgeCallout(
                        id: "space-is-part",
                        title: "Bonsai World principle",
                        body: "Space is part of the composition."
                    )
                ]
            ),
            DisplayKnowledgeSection(
                id: "hierarchy",
                heading: "What should the viewer see first?",
                paragraphs: [
                    "Every successful display should have a clear hierarchy. The primary subject is normally the bonsai. Secondary elements should support. They should not compete.",
                    "Consider primary, secondary, supporting and background. If the viewer cannot tell what matters first, the display is not finished."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )

    // MARK: - 04 Pot, Stand & Character

    private static let potAndStand = DisplayKnowledgeLesson(
        id: "pot-stand",
        number: 4,
        title: "Pot, Stand & Character",
        summary: "Tree and pot are already one object. The stand should speak the same visual language.",
        sections: [
            DisplayKnowledgeSection(
                id: "pot",
                heading: "The role of the pot",
                paragraphs: [
                    "The pot is already part of the bonsai composition. When the tree enters a display, tree and pot should be understood together.",
                    "Pots & Containers in this Handbook covers horticultural function, proportion, visual weight and character. This chapter asks how that pair is presented."
                ],
                bullets: [],
                callouts: []
            ),
            DisplayKnowledgeSection(
                id: "stands",
                heading: "Display stands",
                paragraphs: [
                    "Stands can define presentation height, create separation, add visual character and support the pot. A stand should support the bonsai visually. Not compete with it."
                ],
                bullets: [],
                callouts: []
            ),
            DisplayKnowledgeSection(
                id: "stand-types",
                heading: "Types of bonsai stands",
                paragraphs: [
                    "Formal stands, simple slab stands, root stands, contemporary stands and custom-made stands each create a different visual relationship. Choose the relationship, not a catalogue category."
                ],
                bullets: [],
                callouts: []
            ),
            DisplayKnowledgeSection(
                id: "stand-height",
                heading: "Stand height",
                paragraphs: [
                    "Stand height can influence presence, formality and viewing experience. A very heavy or tall stand may dominate a delicate tree. A very light stand may fail to support a powerful composition."
                ],
                bullets: [],
                callouts: []
            ),
            DisplayKnowledgeSection(
                id: "stand-character",
                heading: "Matching the tree",
                paragraphs: [
                    "Consider whether the tree reads as strong, elegant, rugged, refined, ancient or delicate. The stand should contribute to the same visual story."
                ],
                bullets: [],
                callouts: [
                    DisplayKnowledgeCallout(
                        id: "same-language",
                        title: "Bonsai World principle",
                        body: "Every element should speak the same visual language."
                    )
                ]
            )
        ]
    )

    // MARK: - 05 Traditional Display

    private static let traditionalDisplay = DisplayKnowledgeLesson(
        id: "traditional",
        number: 5,
        title: "Traditional Display",
        summary: "Tokonoma and three-point display teach relationships. They are not a formula every display must copy.",
        sections: [
            DisplayKnowledgeSection(
                id: "tokonoma",
                heading: "Tokonoma principles",
                paragraphs: [
                    "The traditional Japanese tokonoma is an important influence on formal bonsai presentation. The lesson is not that you must recreate a traditional Japanese environment.",
                    "Focus on simplicity, hierarchy, season, space, balance and respect for the subject. Avoid reducing tokonoma display to a rigid formula."
                ],
                bullets: [],
                callouts: []
            ),
            DisplayKnowledgeSection(
                id: "three-point",
                heading: "Three-point display",
                paragraphs: [
                    "The traditional concept combines bonsai, scroll and accent. The lesson is balanced relationships — not that every display must contain all three."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )

    // MARK: - 06 Supporting Elements

    private static let supportingElements = DisplayKnowledgeLesson(
        id: "supporting",
        number: 6,
        title: "Supporting Elements",
        summary: "Accents, kusamono, shitakusa and viewing stones can support the story. They must not overcrowd it.",
        sections: [
            DisplayKnowledgeSection(
                id: "accent",
                heading: "Accent plants",
                paragraphs: [
                    "Accent plants can contribute season, environment, scale, contrast and narrative. The accent should not compete with the main bonsai."
                ],
                bullets: [],
                callouts: []
            ),
            DisplayKnowledgeSection(
                id: "kusamono",
                heading: "Kusamono",
                paragraphs: [
                    "Kusamono is a broader artistic category: plants presented as their own composition. Seasonal expression, natural combinations, container selection and independent artistic value all belong.",
                    "Kusamono can exist independently, or as part of a bonsai display. Independent artistic value does not make it the primary subject when it sits beside a bonsai."
                ],
                bullets: [],
                callouts: []
            ),
            DisplayKnowledgeSection(
                id: "shitakusa",
                heading: "Shitakusa",
                paragraphs: [
                    "Shitakusa is supporting plant material in a traditional bonsai display. Consider scale, season and supporting role.",
                    "Terminology is less important than visual understanding. If the plant reads as the main event, it is no longer supporting."
                ],
                bullets: [],
                callouts: []
            ),
            DisplayKnowledgeSection(
                id: "suiseki",
                heading: "Suiseki and viewing stones",
                paragraphs: [
                    "Viewing stones can suggest landscape, scale, mood and supporting narrative. Do not overcrowd the display. Imagination needs space."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )

    // MARK: - 07 Season

    private static let season = DisplayKnowledgeLesson(
        id: "season",
        number: 7,
        title: "Season",
        summary: "The same tree does not tell the same story all year. Display the tree's current moment.",
        sections: [
            DisplayKnowledgeSection(
                id: "year",
                heading: "The bonsai changes through the year",
                paragraphs: [
                    "Spring may emphasise buds, new growth and fresh colour. Summer may emphasise full foliage, strength and growth. Autumn may emphasise colour, fruit and seasonal transition. Winter may emphasise branch structure, bark, silhouette and dormancy.",
                    "The display should understand the tree's current moment."
                ],
                bullets: [],
                callouts: []
            ),
            DisplayKnowledgeSection(
                id: "flowering",
                heading: "Flowering bonsai",
                paragraphs: [
                    "Flowering bonsai already possess a strong visual event. Supporting elements should be considered carefully. The goal is often restraint."
                ],
                bullets: [],
                callouts: []
            ),
            DisplayKnowledgeSection(
                id: "fruiting",
                heading: "Fruiting bonsai",
                paragraphs: [
                    "Fruit influences colour, balance and seasonal identity. The display should allow the fruit to remain part of the tree's story — not a separate decoration."
                ],
                bullets: [],
                callouts: []
            ),
            DisplayKnowledgeSection(
                id: "winter",
                heading: "Winter display",
                paragraphs: [
                    "Deciduous bonsai may be particularly powerful in winter, when structure becomes visible. The display can emphasise trunk, branching, ramification, bark and age.",
                    "This may require different supporting elements than summer display."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )

    // MARK: - 08 Exhibition & Preparation

    private static let exhibition = DisplayKnowledgeLesson(
        id: "exhibition",
        number: 8,
        title: "Exhibition & Preparation",
        summary: "Exhibition preparation should not damage the health of the tree to improve short-term appearance.",
        sections: [
            DisplayKnowledgeSection(
                id: "exhibition",
                heading: "Preparing a tree for formal viewing",
                paragraphs: [
                    "Consider tree condition, pot cleanliness, surface presentation, moss, weed control, branch organisation and display front.",
                    "Exhibition preparation should not involve damaging the health of the tree simply to improve short-term appearance."
                ],
                bullets: [],
                callouts: []
            ),
            DisplayKnowledgeSection(
                id: "moss",
                heading: "Moss in presentation",
                paragraphs: [
                    "Moss can influence visual age, surface unity and presentation. Moss is not automatically beneficial everywhere. Consider tree health, root environment and moisture.",
                    "Tree Health, Soil & Substrate and Watering sit beside that judgement."
                ],
                bullets: [],
                callouts: []
            ),
            DisplayKnowledgeSection(
                id: "cleaning",
                heading: "Cleaning and preparation",
                paragraphs: [
                    "Pot cleanliness, dead leaves, weeds, visible debris and unwanted wire are small details. They influence professional presentation."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )

    // MARK: - 09 Light, Background & Photography

    private static let lightAndPhotography = DisplayKnowledgeLesson(
        id: "light-photography",
        number: 9,
        title: "Light & Photography",
        summary: "Lighting and background help the viewer see the tree. Photographs should represent the bonsai honestly.",
        sections: [
            DisplayKnowledgeSection(
                id: "lighting",
                heading: "Seeing the tree clearly",
                paragraphs: [
                    "Lighting influences trunk texture, depth, foliage, shadow and photography. Expensive equipment is not required.",
                    "Teach the principles: clear, directional where appropriate, not distracting."
                ],
                bullets: [],
                callouts: []
            ),
            DisplayKnowledgeSection(
                id: "background",
                heading: "Backgrounds",
                paragraphs: [
                    "Backgrounds can help the viewer see silhouette, branch structure and pot. A distracting background can weaken the entire presentation. Consider colour, texture and contrast."
                ],
                bullets: [],
                callouts: []
            ),
            DisplayKnowledgeSection(
                id: "photography",
                heading: "Bonsai photography",
                paragraphs: [
                    "When presenting the tree digitally, consider camera and viewing height, background, lighting, front selection and perspective.",
                    "Photographs should represent the bonsai honestly. Avoid excessive editing that changes tree proportions, colour or structure. Future connection: Bonsai World Tree Gallery."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )

    // MARK: - 10 Places

    private static let places = DisplayKnowledgeLesson(
        id: "places",
        number: 10,
        title: "Places",
        summary: "Home, garden and contemporary spaces still rest on hierarchy, balance, space and respect for the tree.",
        sections: [
            DisplayKnowledgeSection(
                id: "home",
                heading: "Home display",
                paragraphs: [
                    "Home display may balance art and practical cultivation. A bonsai may be moved temporarily for display.",
                    "Do not encourage unsuitable long-term placement purely for appearance. Tree health remains primary."
                ],
                bullets: [],
                callouts: []
            ),
            DisplayKnowledgeSection(
                id: "outdoor",
                heading: "Outdoor display",
                paragraphs: [
                    "Garden and collection presentation consider viewing path, height, background, weather and practical care. Outdoor display may be more integrated with garden design."
                ],
                bullets: [],
                callouts: []
            ),
            DisplayKnowledgeSection(
                id: "modern",
                heading: "Modern bonsai display",
                paragraphs: [
                    "Modern presentation may explore contemporary materials, minimalist environments, gallery presentation and architectural spaces.",
                    "The same core principles remain: hierarchy, balance, space and respect for the tree."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )

    // MARK: - 11 Practice

    private static let practice = DisplayKnowledgeLesson(
        id: "practice",
        number: 11,
        title: "Practice",
        summary: "Ask what the display is trying to communicate. Then remove everything that does not serve that answer.",
        sections: [
            DisplayKnowledgeSection(
                id: "mistakes",
                heading: "Common beginner mistakes",
                paragraphs: [
                    "Adding too many objects. Allowing the stand to compete with the tree. Ignoring the viewing angle. Using an accent larger or visually stronger than the bonsai. Ignoring negative space.",
                    "Treating every display as a decoration. Using unhealthy presentation practices. Ignoring season. Using a distracting background. Trying to copy a formal display without understanding why it works."
                ],
                bullets: [],
                callouts: []
            ),
            DisplayKnowledgeSection(
                id: "advanced",
                heading: "The display as a visual story",
                paragraphs: [
                    "Advanced display considers tree, pot, stand, space, season and supporting elements. Every object influences the others. The goal is unity.",
                    "Ask what this display is trying to communicate. Strength? Age? Season? Landscape? Elegance? Silence? The answer should guide the composition."
                ],
                bullets: [],
                callouts: []
            ),
            DisplayKnowledgeSection(
                id: "framework",
                heading: "Practical display framework",
                paragraphs: [
                    "Select, then subtract. View the complete composition from the intended viewing position."
                ],
                bullets: [
                    "Select the tree.",
                    "Determine the strongest viewing front.",
                    "Understand tree movement.",
                    "Consider the season.",
                    "Select an appropriate stand.",
                    "Evaluate background and space.",
                    "Add supporting elements only when necessary.",
                    "Check visual hierarchy.",
                    "Remove unnecessary elements.",
                    "View the complete composition from the intended viewing position."
                ],
                callouts: []
            ),
            DisplayKnowledgeSection(
                id: "paths",
                heading: "Beginner, intermediate and advanced",
                paragraphs: [
                    "Beginner — clean presentation; correct viewing height; background; simple stands.",
                    "Intermediate — accent plants; visual hierarchy; seasonal display; tree movement.",
                    "Advanced — formal exhibition display; complete compositions; narrative; contemporary artistic presentation."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )

    // MARK: - 12 Troubleshooting

    private static let troubleshooting = DisplayKnowledgeLesson(
        id: "troubleshooting",
        number: 12,
        title: "Troubleshooting",
        summary: "When a display feels crowded, the solution may be subtraction. Do not add decoration automatically.",
        sections: [
            DisplayKnowledgeSection(
                id: "crowded",
                heading: "The display feels crowded",
                paragraphs: [
                    "Check the number of elements, negative space and visual hierarchy. Remove unnecessary objects."
                ],
                bullets: [],
                callouts: []
            ),
            DisplayKnowledgeSection(
                id: "accent-dominates",
                heading: "The accent dominates the bonsai",
                paragraphs: [
                    "Check size, colour, position and visual weight."
                ],
                bullets: [],
                callouts: []
            ),
            DisplayKnowledgeSection(
                id: "unstable",
                heading: "The tree appears visually unstable",
                paragraphs: [
                    "Check stand, viewing angle, direction of movement and position."
                ],
                bullets: [],
                callouts: []
            ),
            DisplayKnowledgeSection(
                id: "flat-photo",
                heading: "The photograph looks flat",
                paragraphs: [
                    "Check lighting, background, camera height and perspective."
                ],
                bullets: [],
                callouts: []
            ),
            DisplayKnowledgeSection(
                id: "lifeless",
                heading: "Technically correct but lifeless",
                paragraphs: [
                    "Check season, character, space and natural relationships. Do not add decoration automatically. Reconsider the entire composition."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )

    // MARK: - 13 Quick Guides

    private static let quickGuides = DisplayKnowledgeLesson(
        id: "quick-guides",
        number: 13,
        title: "Quick Guides",
        summary: "The display does not tell the viewer what to see. It creates the space for the viewer to see the tree.",
        sections: [
            DisplayKnowledgeSection(
                id: "cards",
                heading: "Knowledge cards",
                paragraphs: [],
                bullets: [],
                callouts: [
                    DisplayKnowledgeCallout(
                        id: "card-first",
                        title: "The tree comes first",
                        body: "The display exists to reveal the bonsai."
                    ),
                    DisplayKnowledgeCallout(
                        id: "card-space",
                        title: "Space is part of the display",
                        body: "Do not fill every empty area."
                    ),
                    DisplayKnowledgeCallout(
                        id: "card-support",
                        title: "Support, do not compete",
                        body: "Secondary elements should strengthen the main tree."
                    ),
                    DisplayKnowledgeCallout(
                        id: "card-season",
                        title: "Consider the season",
                        body: "The same tree does not tell the same story all year."
                    ),
                    DisplayKnowledgeCallout(
                        id: "card-remove",
                        title: "Remove before adding",
                        body: "When a display feels crowded, the solution may be subtraction."
                    )
                ]
            ),
            DisplayKnowledgeSection(
                id: "connections",
                heading: "Connections to other Bonsai World knowledge",
                paragraphs: [
                    "Pots & Containers — tree and pot composition.",
                    "Design Guidelines — front, movement and balance.",
                    "Bonsai Forms, Styles & Silhouette — silhouette, visual weight and whether the composed tree still has one idea.",
                    "Deadwood — whether a dramatic feature should decide the front, or whether the whole tree still comes first.",
                    "Bonsai Artistry & the Bonsai Eye — whether the composed tree still looks convincing.",
                    "Tree development — refinement and presentation readiness.",
                    "Pruning — silhouette and branch presentation.",
                    "Species Profiles — seasonal appearance, flowers, fruit and autumn colour.",
                    "Bonsai Collection Management — exhibition trees as a collection purpose, not every tree."
                ],
                bullets: [],
                callouts: []
            ),
            DisplayKnowledgeSection(
                id: "planner",
                heading: "Future: Display Planner",
                paragraphs: [
                    "A future tool could let the user select tree, pot, stand, accent and season, then help evaluate relative scale, visual hierarchy and directional movement.",
                    "It should provide suggestions. It should not claim objective artistic truth. Display comparison — different stands, accents, backgrounds and viewing positions — would be artistic exploration."
                ],
                bullets: [],
                callouts: []
            ),
            DisplayKnowledgeSection(
                id: "philosophy",
                heading: "Bonsai World philosophy",
                paragraphs: [
                    "A bonsai display succeeds when nothing feels accidental. The tree has its place. The pot supports the tree. The stand supports the composition. The accent supports the season. The space allows the viewer to breathe.",
                    "When every unnecessary element is removed, what remains is not decoration. It is attention. The display does not tell the viewer what to see. It creates the space for the viewer to see the tree."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )
}
