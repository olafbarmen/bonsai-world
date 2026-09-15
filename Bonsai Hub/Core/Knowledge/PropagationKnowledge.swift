//
//  PropagationKnowledge.swift
//  Bonsai World
//
//  Knowledge → Bonsai Handbook → Propagation.
//  Seeds, seedlings and cuttings. Air Layering and grafting stay in their chapters.
//

import Foundation

struct PropagationCallout: Identifiable, Hashable, Sendable {
    var id: String
    var title: String
    var body: String
}

struct PropagationSection: Identifiable, Hashable, Sendable {
    var id: String
    var heading: String
    var paragraphs: [String]
    var bullets: [String]
    var callouts: [PropagationCallout]
}

struct PropagationLesson: Identifiable, Hashable, Sendable {
    var id: String
    var number: Int
    var title: String
    var summary: String
    var sections: [PropagationSection]
}

enum PropagationKnowledge {
    static let chapterTitle = "Propagation"

    static let openingLine =
        "Creating new bonsai material from seeds, seedlings and cuttings."

    static let disclaimer =
        "Species, seed lot, climate and material quality change outcomes. This chapter compares methods. It does not provide a universal germination or rooting recipe. Species Library, Seed Stratification, Nursery → Seeds and Nursery → Cuttings are the species-specific and practical surfaces."

    static let lessons: [PropagationLesson] = [
        overview,
        mainMethods,
        species,
        seedsAndQuality,
        stratificationAndGermination,
        seedlingCare,
        seedlingSelection,
        cuttings,
        cuttingTypes,
        rootingAndAftercare,
        transition,
        practice,
        quickGuides
    ]

    static func lesson(id: String) -> PropagationLesson? {
        lessons.first { $0.id == id }
    }

    // MARK: - 01 Overview

    private static let overview = PropagationLesson(
        id: "overview",
        number: 1,
        title: "Overview",
        summary: "Propagation creates possibilities. Time creates bonsai.",
        sections: [
            PropagationSection(
                id: "foundations",
                heading: "Creating your own starting material",
                paragraphs: [
                    "Propagation is one of the foundations of long-term bonsai development. It allows the artist to create new material, develop specific species, grow many trees at low cost, learn through experimentation, and influence development long before a tree becomes bonsai.",
                    "Propagated material may eventually become bonsai, pre-bonsai, training material or future projects. Not every propagated tree needs to become a finished bonsai.",
                    "Propagation is not a shortcut to finished bonsai. A seedling or cutting may require many years of development."
                ],
                bullets: [],
                callouts: [
                    PropagationCallout(
                        id: "possibilities",
                        title: "Bonsai World principle",
                        body: "Propagation does not only create more trees. It creates future possibilities."
                    ),
                    PropagationCallout(
                        id: "time",
                        title: "Bonsai World principle",
                        body: "Propagation creates possibilities. Time creates bonsai."
                    )
                ]
            )
        ]
    )

    // MARK: - 02 Main Methods

    private static let mainMethods = PropagationLesson(
        id: "main-methods",
        number: 2,
        title: "Main Methods",
        summary: "There is no universally best propagation method. The correct choice depends on species, material, goals and time.",
        sections: [
            PropagationSection(
                id: "three",
                heading: "Three main starting points",
                paragraphs: [
                    "This chapter focuses on seeds, seedlings and cuttings.",
                    "Seeds create trees from the beginning. Seedlings are young trees developed from an early stage. Cuttings create a new plant from part of an existing plant.",
                    "Air Layering is a related method with its own chapter in this Handbook. Advanced grafting belongs in Advanced Techniques. This chapter does not repeat those methods."
                ],
                bullets: [],
                callouts: []
            ),
            PropagationSection(
                id: "choice",
                heading: "Each method offers different advantages",
                paragraphs: [
                    "Seeds often give numbers, variation and early control. Cuttings often copy known material and start later than seed. Seedling work is the years after germination, when growth — not styling — is the job.",
                    "The correct choice depends on species, available material, bonsai goals, time and desired characteristics. Bonsai Material & Sourcing asks whether growing your own is the right starting point. This chapter asks which method fits that starting point."
                ],
                bullets: [],
                callouts: [
                    PropagationCallout(
                        id: "no-best",
                        title: "Bonsai World principle",
                        body: "There is no universally best propagation method."
                    )
                ]
            )
        ]
    )

    // MARK: - 03 Species

    private static let species = PropagationLesson(
        id: "species",
        number: 3,
        title: "Species",
        summary: "Learn the method. Then learn how the species responds to it.",
        sections: [
            PropagationSection(
                id: "response",
                heading: "Different species behave differently",
                paragraphs: [
                    "Propagation success depends heavily on species. Some species germinate easily. Some root easily from cuttings. Some require specific preparation. Some are difficult to propagate.",
                    "Do not treat timing or success rates as universal. Species Library is the species-specific surface. Seed Stratification covers dormancy for seed. Nursery → Seeds and Nursery → Cuttings record what you actually do."
                ],
                bullets: [],
                callouts: [
                    PropagationCallout(
                        id: "species-first",
                        title: "Bonsai World principle",
                        body: "Learn the method. Then learn how the species responds to it."
                    )
                ]
            )
        ]
    )

    // MARK: - 04 Seeds & Quality

    private static let seedsAndQuality = PropagationLesson(
        id: "seeds-quality",
        number: 4,
        title: "Seeds & Quality",
        summary: "Seed propagation is often about growing many possibilities, then selecting the most promising material.",
        sections: [
            PropagationSection(
                id: "seeds",
                heading: "Starting at the beginning",
                paragraphs: [
                    "Seeds can be valuable for bonsai: large numbers of trees, early development control, low starting cost and long-term projects.",
                    "Challenges include time, natural variation and long development periods. Seed propagation is often about growing many possibilities, then selecting the most promising material."
                ],
                bullets: [],
                callouts: []
            ),
            PropagationSection(
                id: "quality",
                heading: "Good material begins with good seed",
                paragraphs: [
                    "Seed quality may be affected by species, freshness, storage and collection conditions. This chapter does not guarantee viability.",
                    "Different species have different requirements. Species Library and Seed Stratification are the species-specific surfaces. Nursery → Seeds is the practical record."
                ],
                bullets: [],
                callouts: [
                    PropagationCallout(
                        id: "quality",
                        title: "Bonsai World principle",
                        body: "A weak beginning rarely creates a strong start."
                    )
                ]
            )
        ]
    )

    // MARK: - 05 Stratification & Germination

    private static let stratificationAndGermination = PropagationLesson(
        id: "stratification-germination",
        number: 5,
        title: "Stratification & Germination",
        summary: "Some seeds need a seasonal pause before they will germinate. There is no universal schedule.",
        sections: [
            PropagationSection(
                id: "stratification",
                heading: "Understanding seasonal dormancy",
                paragraphs: [
                    "Some seeds require a period that imitates natural seasonal conditions before they will germinate successfully. Dormancy exists to protect the seed until conditions are more favourable. Some species need a cold moist period. Others need little or none. Some need more than one cue.",
                    "There is no universal stratification schedule in this chapter. Seed Stratification in Knowledge is the dedicated guide. Species-specific ranges belong in Species Library and the stratification catalog — not in a single Handbook recipe."
                ],
                bullets: [],
                callouts: []
            ),
            PropagationSection(
                id: "germination",
                heading: "The beginning of a new tree",
                paragraphs: [
                    "Germination depends on appropriate moisture, suitable temperature, airflow and clean growing conditions. It is not a single formula. Success depends on species, seed condition and environment.",
                    "Avoid presenting germination as guaranteed once the seed is sown. Watch, keep conditions stable, and let the species respond."
                ],
                bullets: [],
                callouts: [
                    PropagationCallout(
                        id: "no-schedule",
                        title: "Bonsai World principle",
                        body: "Do not germinate the calendar. Germinate the seed you have, under the conditions that species needs."
                    )
                ]
            )
        ]
    )

    // MARK: - 06 Seedling Care & Development

    private static let seedlingCare = PropagationLesson(
        id: "seedling-care",
        number: 6,
        title: "Seedling Care & Development",
        summary: "Do not try to make a bonsai before you have grown a tree.",
        sections: [
            PropagationSection(
                id: "first-years",
                heading: "The first years matter",
                paragraphs: [
                    "Young seedlings require appropriate light, water, protection from extreme conditions and room to grow. The goal in early development is usually healthy growth — not immediate bonsai styling.",
                    "Watering in this Handbook covers young material and observation. Care → Watering is the practical surface. Extreme weather belongs with Seasonal Care & Protection in this Handbook, and with Care → Seasonal Care and Care → Winter Care."
                ],
                bullets: [],
                callouts: [
                    PropagationCallout(
                        id: "grow-first",
                        title: "Bonsai World principle",
                        body: "Do not try to make a bonsai before you have grown a tree."
                    )
                ]
            ),
            PropagationSection(
                id: "future-structure",
                heading: "Growing with future structure in mind",
                paragraphs: [
                    "Early development may eventually involve trunk development, root development and branch selection. Young trees still need growth. Avoid unnecessary early intervention.",
                    "Design Guidelines cover future structure. This lesson is the patience: first grow the tree. Then develop the bonsai."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )

    // MARK: - 07 Seedling Selection

    private static let seedlingSelection = PropagationLesson(
        id: "seedling-selection",
        number: 7,
        title: "Seedling Selection",
        summary: "Selecting material is part of propagation. Not every tree needs to continue.",
        sections: [
            PropagationSection(
                id: "select",
                heading: "Not every tree needs to continue",
                paragraphs: [
                    "When growing multiple seedlings, selection becomes important. Look for potential such as interesting trunk movement, root potential, vigour and overall character.",
                    "Bonsai Artistry & the Bonsai Eye trains looking. Bonsai Material & Sourcing trains evaluating structure. Bonsai Collection Management asks whether the collection can absorb what you keep. Growing too much material without a plan for selection is a propagation mistake."
                ],
                bullets: [],
                callouts: [
                    PropagationCallout(
                        id: "options",
                        title: "Bonsai World principle",
                        body: "Growing several trees allows selection."
                    )
                ]
            )
        ]
    )

    // MARK: - 08 Cuttings

    private static let cuttings = PropagationLesson(
        id: "cuttings",
        number: 8,
        title: "Cuttings",
        summary: "A cutting copies known material. Success depends on species, timing, quality and environment.",
        sections: [
            PropagationSection(
                id: "concept",
                heading: "Creating new trees from existing material",
                paragraphs: [
                    "A cutting is a portion of plant material used to develop a new plant. Potential advantages include reproducing known material, a faster starting point than seed, and useful access to desirable characteristics.",
                    "Success depends strongly on species, timing, material quality and environment. Nursery → Cuttings is the practical surface. This chapter asks which kind of cutting the species and the moment support — not how to strike every plant."
                ],
                bullets: [],
                callouts: [
                    PropagationCallout(
                        id: "before-taken",
                        title: "Bonsai World principle",
                        body: "Propagation begins before the cutting is taken."
                    )
                ]
            )
        ]
    )

    // MARK: - 09 Cutting Types

    private static let cuttingTypes = PropagationLesson(
        id: "cutting-types",
        number: 9,
        title: "Cutting Types",
        summary: "These categories describe the condition of the wood. They are not equally suitable for every species.",
        sections: [
            PropagationSection(
                id: "categories",
                heading: "Different material, different characteristics",
                paragraphs: [
                    "Softwood cuttings use young, soft growth — active, and in suitable species potentially quick to root, but also prone to drying and sensitive to the environment.",
                    "Semi-hardwood cuttings use growth that has begun to mature — often a balance between young tissue and more structure. Suitability still depends strongly on species.",
                    "Hardwood cuttings use more mature, hardened material. They may have greater structural strength and different rooting behaviour. Hardwood is not always easier or more difficult. Species response decides.",
                    "A heel cutting includes a small portion of older parent wood where the cutting was removed. It is a method, not a guarantee of better results.",
                    "Other approaches exist: leaf cuttings, root cuttings and species-specific methods. They are relevant when the species supports them and Species Library recommends them. They are not developed as major methods in this chapter."
                ],
                bullets: [],
                callouts: [
                    PropagationCallout(
                        id: "not-equal",
                        title: "Bonsai World principle",
                        body: "Cutting types name the wood you take. They do not name a universal recipe."
                    )
                ]
            )
        ]
    )

    // MARK: - 10 Material, Rooting & Aftercare

    private static let rootingAndAftercare = PropagationLesson(
        id: "rooting-aftercare",
        number: 10,
        title: "Material, Rooting & Aftercare",
        summary: "A rooting aid can support a good process. It cannot rescue a bad one.",
        sections: [
            PropagationSection(
                id: "parent",
                heading: "The parent material matters",
                paragraphs: [
                    "Before taking a cutting, consider overall health, strength, quality of the material, and signs of pests or disease. Weak or unhealthy material is not ideal propagation material.",
                    "Avoid introducing obvious pests, disease or severe stress into new projects. Tree Health covers inspection. Bonsai Material & Sourcing covers health before you choose a starting point."
                ],
                bullets: [],
                callouts: []
            ),
            PropagationSection(
                id: "conditions",
                heading: "Creating the right environment",
                paragraphs: [
                    "Rooting is affected by moisture, air around the rooting area, temperature, light and hygiene. There is no universal rooting recipe. Ideal conditions vary between species, climate and method."
                ],
                bullets: [],
                callouts: []
            ),
            PropagationSection(
                id: "medium",
                heading: "Supporting new roots",
                paragraphs: [
                    "A rooting medium should generally support moisture retention, air availability and root development. One substrate is not universally best. Propagation media and finished bonsai soil are not necessarily the same thing.",
                    "Soil & Substrate covers how particle size, water and air work. Inventory → Soil is the stock record. Do not assume a refined bonsai mix is the right striking mix."
                ],
                bullets: [],
                callouts: []
            ),
            PropagationSection(
                id: "aids",
                heading: "Helping, not replacing conditions",
                paragraphs: [
                    "Rooting aids may be used in propagation. They do not compensate for poor material, poor environmental conditions or incorrect timing. This chapter does not recommend products."
                ],
                bullets: [],
                callouts: [
                    PropagationCallout(
                        id: "aid",
                        title: "Bonsai World principle",
                        body: "A rooting aid can support a good process. It cannot rescue a bad one."
                    )
                ]
            ),
            PropagationSection(
                id: "aftercare",
                heading: "The cutting is not finished when it is planted",
                paragraphs: [
                    "Young material may require appropriate moisture, stable conditions, monitoring and patience. Avoid unnecessary disturbance while roots develop.",
                    "Visible growth can be encouraging. A cutting must still develop a functional root system. Do not disturb material unnecessarily to inspect roots. Allow development to demonstrate success over time."
                ],
                bullets: [],
                callouts: [
                    PropagationCallout(
                        id: "roots-first",
                        title: "Bonsai World principle",
                        body: "Roots first. Development second. Bonsai later."
                    )
                ]
            )
        ]
    )

    // MARK: - 11 Transition & Intention

    private static let transition = PropagationLesson(
        id: "transition",
        number: 11,
        title: "Transition & Intention",
        summary: "Once young material is established, the work changes from propagation to tree development.",
        sections: [
            PropagationSection(
                id: "from-to",
                heading: "From propagation to development",
                paragraphs: [
                    "Once young material is established, the focus gradually changes from propagation to tree development. The next priorities may include healthy growth, root development, trunk development and future structure.",
                    "Design Guidelines cover future bonsai potential. Bonsai Material & Sourcing covers evaluating what you now have. Repotting covers moving young trees when the root system is ready — not on curiosity. Garden → Trees is where a successful project becomes a tree in the collection."
                ],
                bullets: [],
                callouts: []
            ),
            PropagationSection(
                id: "intention",
                heading: "Grow with intention",
                paragraphs: [
                    "Propagation can support specific bonsai goals. Growing multiple seedlings may create selection opportunities. Taking cuttings may create future material.",
                    "Understand what you hope to develop. Also allow the material to reveal its own potential. Do not force a preconceived design onto a seedling that is still only growing."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )

    // MARK: - 12 Practice

    private static let practice = PropagationLesson(
        id: "practice",
        number: 12,
        title: "Practice",
        summary: "Successful propagation is not the same as successful bonsai development.",
        sections: [
            PropagationSection(
                id: "mistakes",
                heading: "Common propagation mistakes",
                paragraphs: [
                    "Trying to style material before it is strong enough. Assuming one method works equally well for every species. Using unhealthy parent material. Disturbing young roots unnecessarily. Changing conditions too frequently.",
                    "Expecting immediate bonsai material. Treating propagation as a guaranteed process. Growing too much material without a plan for selection. Ignoring species-specific requirements. Confusing successful propagation with successful bonsai development."
                ],
                bullets: [],
                callouts: []
            ),
            PropagationSection(
                id: "framework",
                heading: "Propagation decision framework",
                paragraphs: [
                    "Before choosing a propagation method, answer these questions. If you cannot, wait — or grow fewer plants."
                ],
                bullets: [
                    "What species am I working with?",
                    "What material is available?",
                    "What is my goal?",
                    "Do I want variation, multiple projects, or a copy of existing material?",
                    "How much time can I invest?",
                    "What will happen after propagation succeeds?",
                    "Do I have space to develop the resulting trees?"
                ],
                callouts: []
            ),
            PropagationSection(
                id: "paths",
                heading: "Beginner, intermediate and advanced",
                paragraphs: [
                    "Beginner — basic concepts, seeds, seedlings and simple cuttings. Nursery → Seeds and Nursery → Cuttings are the records. Learn what the species needs before collecting dozens of pots.",
                    "Intermediate — better species knowledge, material selection and more than one cutting type. Seed Stratification and Species Library become daily tools.",
                    "Advanced — species-specific propagation, material planning and long-term development from propagated stock. Air Layering and Advanced Techniques cover other ways to create or correct material."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )

    // MARK: - 13 Quick Guides

    private static let quickGuides = PropagationLesson(
        id: "quick-guides",
        number: 13,
        title: "Quick Guides",
        summary: "A seed, a seedling or a cutting may contain an exceptional future tree. Propagation only creates the opportunity.",
        sections: [
            PropagationSection(
                id: "cards",
                heading: "Quick knowledge cards",
                paragraphs: [],
                bullets: [],
                callouts: [
                    PropagationCallout(
                        id: "card-species",
                        title: "Start with the species",
                        body: "The method must suit the tree."
                    ),
                    PropagationCallout(
                        id: "card-health",
                        title: "Healthy material matters",
                        body: "A weak beginning rarely creates a strong start."
                    ),
                    PropagationCallout(
                        id: "card-rush",
                        title: "Do not rush development",
                        body: "First grow the tree. Then develop the bonsai."
                    ),
                    PropagationCallout(
                        id: "card-options",
                        title: "Propagation creates options",
                        body: "Growing several trees allows selection."
                    ),
                    PropagationCallout(
                        id: "card-time",
                        title: "Success takes time",
                        body: "Roots first. Development second. Bonsai later."
                    )
                ]
            ),
            PropagationSection(
                id: "connections",
                heading: "Connections to other Bonsai World knowledge",
                paragraphs: [
                    "Bonsai Material & Sourcing — whether growing your own is the right starting point.",
                    "Air Layering — the dedicated chapter for creating a new tree while it is still attached.",
                    "Advanced Techniques — grafting and advanced work that is not seed or cutting.",
                    "Seed Stratification — dormancy, storage and germination principles.",
                    "Species Library — how this species tends to propagate.",
                    "Nursery → Seeds and Nursery → Cuttings — the practical records in the programme.",
                    "Soil & Substrate — propagation media versus finished bonsai soil.",
                    "Watering — young material care. Care → Watering is the practical surface.",
                    "Repotting — transitioning young trees when roots are ready.",
                    "Design Guidelines — future structure once the tree is growing.",
                    "Bonsai Artistry & the Bonsai Eye — seeing potential in young material.",
                    "Tree Health — parent material and pests on new stock.",
                    "Bonsai Collection Management — space, selection and whether the collection can absorb the result.",
                    "Garden → Trees — when a project becomes a tree in the collection."
                ],
                bullets: [],
                callouts: []
            ),
            PropagationSection(
                id: "closing",
                heading: "Final Bonsai World principle",
                paragraphs: [
                    "Propagation teaches one of the most important lessons in bonsai. Potential is not the same as a finished result.",
                    "A seed, a seedling or a cutting may contain the beginning of an exceptional future tree. But propagation only creates the opportunity.",
                    "The bonsai is developed through observation, growth, selection, technique and time."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )
}
