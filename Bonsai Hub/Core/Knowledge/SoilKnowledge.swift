//
//  SoilKnowledge.swift
//  Bonsai World
//
//  Knowledge → Bonsai Handbook → Soil & Substrate.
//  Understand the function before choosing the ingredient.
//

import Foundation

struct SoilKnowledgeCallout: Identifiable, Hashable, Sendable {
    var id: String
    var title: String
    var body: String
}

struct SoilKnowledgeSection: Identifiable, Hashable, Sendable {
    var id: String
    var heading: String
    var paragraphs: [String]
    var bullets: [String]
    var callouts: [SoilKnowledgeCallout]
}

struct SoilKnowledgeLesson: Identifiable, Hashable, Sendable {
    var id: String
    var number: Int
    var title: String
    var summary: String
    var sections: [SoilKnowledgeSection]
}

enum SoilKnowledge {
    static let chapterTitle = "Soil & Substrate"

    static let openingLine =
        "Understanding the root environment — how particles, water and oxygen shape the health and development of a bonsai."

    static let disclaimer =
        "Species, roots, health, stage, pot, climate, watering, water quality and available materials change the answer. Treat this as decision support — not a recipe to copy."

    static let lessons: [SoilKnowledgeLesson] = [
        overview,
        drainageRetentionAir,
        particleSize,
        components,
        buildingAMix,
        developmentAndRefinement,
        speciesClimatePlace,
        potWateringCare,
        fertilizingAndRoots,
        structureOverTime,
        practice,
        troubleshooting,
        quickGuides
    ]

    static func lesson(id: String) -> SoilKnowledgeLesson? {
        lessons.first { $0.id == id }
    }

    // MARK: - 01 Overview

    private static let overview = SoilKnowledgeLesson(
        id: "overview",
        number: 1,
        title: "Overview",
        summary: "The soil is not there to hold the tree. It is there to create the environment in which the roots can live.",
        sections: [
            SoilKnowledgeSection(
                id: "introduction",
                heading: "An engineered root environment",
                paragraphs: [
                    "A bonsai may be visually defined by its trunk, branches and foliage. Much of the tree's future is determined below the surface.",
                    "The substrate influences water availability, oxygen around the roots, root development, nutrient availability, drainage, tree stability, growth strength, recovery and long-term health. Bonsai soil is not dirt in a pot. It is an engineered root environment.",
                    "A good substrate creates conditions where roots can receive water while also having access to air. What you put in the pot is only one part of that experience. Particle size, particle shape, organic content, pot volume, pot depth, watering, rainfall, wind, temperature and the tree's condition all interact.",
                    "Two growers can use similar materials and still see different drying behaviour because climate, pot and watering differ. When you evaluate a mix, ask what it is doing for water storage, drainage and air-filled pore space in this pot, in this place, for this tree — not whether it matches a famous formula."
                ],
                bullets: [],
                callouts: [
                    SoilKnowledgeCallout(
                        id: "hold-the-tree",
                        title: "Bonsai World principle",
                        body: "The soil is not there to hold the tree. It is there to create the environment in which the roots can live."
                    )
                ]
            ),
            SoilKnowledgeSection(
                id: "language",
                heading: "Soil or substrate?",
                paragraphs: [
                    "In bonsai, the growing medium is often more accurately described as a substrate because it may consist primarily of mineral or processed components rather than natural field soil.",
                    "Bonsai soil is still a useful and commonly understood term. This chapter uses soil and substrate together where that helps reading."
                ],
                bullets: [],
                callouts: []
            ),
            SoilKnowledgeSection(
                id: "functions",
                heading: "What the substrate needs to do",
                paragraphs: [
                    "A bonsai substrate must help provide water, oxygen, root support, nutrient retention, appropriate drainage and structural stability. These functions must exist together.",
                    "A substrate that holds water extremely well but has poor air space may create problems. A substrate that drains extremely quickly may require watering that the grower cannot sustain. The goal is balance for this tree — not maximum of any one property."
                ],
                bullets: [],
                callouts: [
                    SoilKnowledgeCallout(
                        id: "function-first",
                        title: "Bonsai World principle",
                        body: "Understand the function before choosing the ingredient."
                    )
                ]
            ),
            SoilKnowledgeSection(
                id: "oxygen",
                heading: "Water and oxygen",
                paragraphs: [
                    "Healthy roots require water and oxygen. The spaces between substrate particles are important. When the substrate becomes saturated, some air spaces are filled with water. As water drains and is used by the tree, air can return to those spaces.",
                    "Healthy substrate structure supports this cycle. Good drainage is not the goal by itself. A healthy root environment is the goal.",
                    "Ordinary garden soil usually behaves poorly in a small bonsai pot. Fine field soil packs, holds water in a way that leaves little air, and does not match the limited root volume of container bonsai. That is a function problem — not a brand-name problem."
                ],
                bullets: [],
                callouts: [
                    SoilKnowledgeCallout(
                        id: "drainage-not-the-goal",
                        title: "Bonsai World principle",
                        body: "Good drainage is not the goal by itself. A healthy root environment is the goal."
                    )
                ]
            )
        ]
    )

    // MARK: - 02 Drainage, Retention & Air

    private static let drainageRetentionAir = SoilKnowledgeLesson(
        id: "drainage-retention-air",
        number: 2,
        title: "Drainage, Retention & Air",
        summary: "Drainage is not the same as water retention. Roots need water. Roots also need air.",
        sections: [
            SoilKnowledgeSection(
                id: "drainage",
                heading: "Understanding water movement",
                paragraphs: [
                    "Drainage is how excess water leaves the pot. It is related to, but not the same as, aeration. Open drainage holes, particle packing and pot geometry affect how quickly surplus water exits.",
                    "Drainage does not simply mean that water disappears quickly. A substrate may drain while still retaining useful moisture. The goal is not maximum drainage in every case. The goal is an appropriate balance for the tree, pot and environment.",
                    "A mix that drains freely in a deep wooden box may behave differently in a shallow ceramic pot with fewer large pores at the base."
                ],
                bullets: [],
                callouts: [
                    SoilKnowledgeCallout(
                        id: "poor-drainage",
                        title: "Poor drainage",
                        body: "Can become problematic when combined with fine particles, high organic content and low evaporation. Monitor how long the pot stays wet after watering or rain."
                    )
                ]
            ),
            SoilKnowledgeSection(
                id: "retention",
                heading: "Holding water without suffocating roots",
                paragraphs: [
                    "Water retention describes how much water stays in the substrate after drainage. Available water is the portion roots can actually take up. Fine pores can hold water tightly; coarse pores drain more freely.",
                    "Drainage, evaporation, particle size, pot volume, pot depth, temperature, wind, humidity and rainfall all change how long moisture remains.",
                    "Too little water retention may create rapid drying. Too much may create persistent saturation. The goal is appropriate moisture for the individual tree.",
                    "A humid or wet climate does not automatically mean a bonsai cannot dry out. A small pot holds a limited total water reserve. Under wind, sun or dry weather, that reserve can empty surprisingly quickly even when the air feels damp."
                ],
                bullets: [],
                callouts: [
                    SoilKnowledgeCallout(
                        id: "wet-climate",
                        title: "Wet climate",
                        body: "Consider that cool, wet weather can keep substrate wet for longer — but monitor drying rate rather than assuming the tree is always safe from drought."
                    )
                ]
            ),
            SoilKnowledgeSection(
                id: "air",
                heading: "The invisible requirement",
                paragraphs: [
                    "After watering, some pores fill with water and some remain filled with air. As water is used or evaporates, air returns. If pores stay water-filled for too long, oxygen around roots can fall.",
                    "Watering more frequently does not compensate for a poor root environment. Compaction, breakdown of particles and high organic content can reduce air-filled pore space over time even if the mix looked open when first potted."
                ],
                bullets: [],
                callouts: [
                    SoilKnowledgeCallout(
                        id: "roots-need-air",
                        title: "Bonsai World principle",
                        body: "Roots need water. Roots also need air."
                    ),
                    SoilKnowledgeCallout(
                        id: "low-temperature",
                        title: "Low temperature",
                        body: "May increase the time substrate stays wet because evaporation is slower. Consider checking moisture rather than watering on a fixed calendar."
                    )
                ]
            )
        ]
    )

    // MARK: - 03 Particle Size

    private static let particleSize = SoilKnowledgeLesson(
        id: "particle-size",
        number: 3,
        title: "Particle Size",
        summary: "The same material behaves differently at different sizes. Uniformity helps the mix stay predictable.",
        sections: [
            SoilKnowledgeSection(
                id: "size-effects",
                heading: "Why size matters",
                paragraphs: [
                    "Particle size influences water retention, air space, drainage, root development and stability.",
                    "Smaller particles may retain more moisture and reduce air space if they are overly fine. Larger particles may increase air space, drain rapidly and provide less moisture retention.",
                    "There is no universally correct particle size. Size should relate to tree size, root size, pot size, development stage and species. This is a tendency, not a formula. The same size band behaves differently in akadama, pumice, bark or sand."
                ],
                bullets: [],
                callouts: [
                    SoilKnowledgeCallout(
                        id: "fine-particles",
                        title: "Very fine particles",
                        body: "May increase water retention and reduce air-filled pore space. Consider this together with pot size, climate and watering — not as a rule that fine always equals wrong."
                    )
                ]
            ),
            SoilKnowledgeSection(
                id: "uniformity",
                heading: "Why consistency matters",
                paragraphs: [
                    "A substrate containing highly inconsistent particle sizes may behave differently from a more uniform substrate. Very fine particles can move into spaces between larger particles. Over time this may influence air space, water movement and compaction.",
                    "Screening and grading substrate components can help create more predictable behaviour. That does not mean every particle must be perfectly identical.",
                    "Inventory soil lines in Bonsai World can store a custom min–max size range so you can filter later. That is a practical record, not a laboratory particle analysis."
                ],
                bullets: [],
                callouts: []
            ),
            SoilKnowledgeSection(
                id: "screening",
                heading: "Screening and preparing substrate",
                paragraphs: [
                    "Substrate may be screened, graded and prepared before repotting. Typical goals are removing excessive dust, separating particle sizes and improving consistency.",
                    "Excessive preparation is not mandatory for every situation. Prepare enough to understand what you are putting in the pot."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )

    // MARK: - 04 Components

    private static let components = SoilKnowledgeLesson(
        id: "components",
        number: 4,
        title: "Components",
        summary: "Choose ingredients based on what they do. Organic is not automatically bad. Mineral is not automatically perfect.",
        sections: [
            SoilKnowledgeSection(
                id: "organic-inorganic",
                heading: "Organic and mineral components",
                paragraphs: [
                    "Organic components may influence water retention, nutrient retention and biological activity. Mineral components may influence structure, air space, drainage and long-term stability.",
                    "Neither category is automatically superior. The correct balance depends on the tree and growing conditions. Ask how this material behaves in this pot, climate and watering pattern — not whether a label says organic.",
                    "Some organic materials stay open for a long time; others collapse. Climate and irrigation change that timeline."
                ],
                bullets: [],
                callouts: [
                    SoilKnowledgeCallout(
                        id: "high-organic",
                        title: "High organic content",
                        body: "Can become problematic when decomposition and prolonged moisture reduce air-filled pore space. Evaluate the actual substrate rather than following a blanket ban."
                    )
                ]
            ),
            SoilKnowledgeSection(
                id: "akadama",
                heading: "Akadama",
                paragraphs: [
                    "Akadama is widely used because it can hold useful moisture, allow air into the root environment, and encourage roots to work the particles. It also breaks down over time, which changes particle size, air space and water behaviour.",
                    "Performance varies with grade, particle size, climate, watering and freeze–thaw conditions. Akadama is one component. It is not a universal solution, and it is not mandatory for bonsai."
                ],
                bullets: [],
                callouts: []
            ),
            SoilKnowledgeSection(
                id: "pumice",
                heading: "Pumice",
                paragraphs: [
                    "Pumice is a porous mineral. Its internal structure can hold water while leaving air space around the particle. Roots often work its surface well.",
                    "Pumice can perform differently depending on particle size and local conditions. Porosity is the function to understand — not a single brand behaviour."
                ],
                bullets: [],
                callouts: []
            ),
            SoilKnowledgeSection(
                id: "lava",
                heading: "Lava rock",
                paragraphs: [
                    "Lava is often used for structural stability and long-term particle integrity. Surface texture can give roots something to hold.",
                    "Lava products differ according to source and processing. Do not assume all lava behaves identically."
                ],
                bullets: [],
                callouts: []
            ),
            SoilKnowledgeSection(
                id: "bark",
                heading: "Pine bark",
                paragraphs: [
                    "Pine bark is an organic component. It can influence water retention and nutrient interaction. It also breaks down over time.",
                    "Evaluate bark the same way as any other ingredient: what function does it provide in this mix, for this tree, in this climate?"
                ],
                bullets: [],
                callouts: []
            ),
            SoilKnowledgeSection(
                id: "leca",
                heading: "Expanded clay / LECA",
                paragraphs: [
                    "Expanded clay can contribute structure and air space. Use and limitation depend on particle size, tree type and the rest of the root environment.",
                    "Judge it by water behaviour and stability in the pot you are using — not by whether other growers include it."
                ],
                bullets: [],
                callouts: []
            ),
            SoilKnowledgeSection(
                id: "gravel",
                heading: "Gravel and other mineral components",
                paragraphs: [
                    "Evaluate gravel, sand and similar minerals by particle size, stability, water behaviour and chemical properties.",
                    "A list of ingredients is not a mandatory recipe. Teach yourself the function of each material, then build the mix around the tree."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )

    // MARK: - 05 Building a Mix

    private static let buildingAMix = SoilKnowledgeLesson(
        id: "building-a-mix",
        number: 5,
        title: "Building a Mix",
        summary: "Start with the tree. Then choose water retention, air space, drainage and structural stability.",
        sections: [
            SoilKnowledgeSection(
                id: "start-with-tree",
                heading: "Start with the tree",
                paragraphs: [
                    "Before choosing ingredients, ask what this tree needs. Consider species, root development, climate, pot and watering habits.",
                    "Then consider water retention, air space, drainage and structural stability. The mix should be built around the needs of the tree — not around a formula that worked for someone else."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )

    // MARK: - 06 Development & Refinement

    private static let developmentAndRefinement = SoilKnowledgeLesson(
        id: "development-refinement",
        number: 6,
        title: "Development & Refinement",
        summary: "The best soil for development may not be the best soil for refinement.",
        sections: [
            SoilKnowledgeSection(
                id: "development",
                heading: "Supporting growth",
                paragraphs: [
                    "Trees in development may require different substrate priorities. Possible goals include strong root growth, increased tree growth, water availability and nutrient availability.",
                    "A development substrate does not necessarily need to behave like the substrate of a highly refined bonsai."
                ],
                bullets: [],
                callouts: [
                    SoilKnowledgeCallout(
                        id: "dev-not-refine",
                        title: "Bonsai World principle",
                        body: "The best soil for development may not be the best soil for refinement."
                    )
                ]
            ),
            SoilKnowledgeSection(
                id: "refinement",
                heading: "Precision and root control",
                paragraphs: [
                    "Refined bonsai may require stable structure, predictable water behaviour, fine root maintenance and controlled growth.",
                    "Substrate decisions may become more precise because pots are smaller and root environments are more restricted. Precision is not the same as starving the roots of water or air."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )

    // MARK: - 07 Species, Climate & Place

    private static let speciesClimatePlace = SoilKnowledgeLesson(
        id: "species-climate-place",
        number: 7,
        title: "Species, Climate & Place",
        summary: "There is no perfect substrate outside of its environment. Climate is the pattern. Weather is today. Place changes the water budget.",
        sections: [
            SoilKnowledgeSection(
                id: "species",
                heading: "Different trees, different needs",
                paragraphs: [
                    "Substrate decisions should consider deciduous species, conifers, evergreen broadleaf trees and tropical species. Do not create overly broad rules based only on tree category.",
                    "Species Profiles should provide species-specific substrate guidance. Water according to the tree you have; mix according to the tree you have."
                ],
                bullets: [],
                callouts: []
            ),
            SoilKnowledgeSection(
                id: "climate-vs-weather",
                heading: "Climate is not the same as weather",
                paragraphs: [
                    "Climate includes typical temperature, rainfall, humidity, wind, sun, evaporation, growing season and winter. Weather is what is happening this week.",
                    "A substrate habit that works in a warm, dry climate will not automatically apply to a cool, wet one — and the reverse is also true.",
                    "Cool temperature plus high rainfall, high humidity and low evaporation may keep substrate wet for longer. Cool temperature plus dry weather, wind and a small pot can still dry the tree quickly. Simple climate slogans are unreliable."
                ],
                bullets: [],
                callouts: [
                    SoilKnowledgeCallout(
                        id: "no-perfect-outside",
                        title: "Bonsai World principle",
                        body: "There is no perfect substrate outside of its environment."
                    ),
                    SoilKnowledgeCallout(
                        id: "cool-wet",
                        title: "Wet climate",
                        body: "Consider longer wet periods in cool, high-rainfall, low-evaporation conditions. Still monitor drying during windy or dry spells."
                    )
                ]
            ),
            SoilKnowledgeSection(
                id: "place",
                heading: "Growing location",
                paragraphs: [
                    "The same substrate can behave differently on an open bench, under a roof or in a greenhouse. Outdoor benches may see rain, wind and sun. A greenhouse may have different temperature, humidity, reduced rainfall and different evaporation. Shelter under a roof changes rainfall more than it changes air temperature.",
                    "Locations in Bonsai World describe where the tree stands. That context belongs in the decision. This lesson is the principle, not an automatic recommendation."
                ],
                bullets: [],
                callouts: [
                    SoilKnowledgeCallout(
                        id: "wind",
                        title: "Wind exposure",
                        body: "May increase evaporation. Consider checking small pots more often during windy, dry weather."
                    )
                ]
            )
        ]
    )

    // MARK: - 08 Pot, Watering & Care

    private static let potWateringCare = SoilKnowledgeLesson(
        id: "pot-watering-care",
        number: 8,
        title: "Pot, Watering & Care",
        summary: "The container changes everything. The grower is part of the system. Substrate and watering are one conversation.",
        sections: [
            SoilKnowledgeSection(
                id: "volume",
                heading: "Small pots and water reserve",
                paragraphs: [
                    "A small pot has a smaller total water reserve. Substrate selection therefore has to consider both water availability and root aeration together.",
                    "Do not treat a small pot as a rule that automatically requires a more water-retentive mix. Small pots require careful consideration because the reserve is limited — drying and waterlogging are both possible depending on weather, watering and particle size.",
                    "Pot dimensions already live on the Pot record. Mix recipes should not duplicate width, depth or volume — they describe composition, not the container."
                ],
                bullets: [],
                callouts: [
                    SoilKnowledgeCallout(
                        id: "small-pot",
                        title: "Small pot",
                        body: "Consider water availability and aeration together. The limited reserve can empty quickly; it can also stay wet if drainage, climate and particles align that way."
                    )
                ]
            ),
            SoilKnowledgeSection(
                id: "depth",
                heading: "Depth is not the same as volume",
                paragraphs: [
                    "A shallow bonsai pot and a deeper training container can behave differently even with the same substrate. Geometry changes drainage paths, evaporation surface and how quickly the profile dries.",
                    "The same mix may behave differently depending on pot depth, root density and exposure."
                ],
                bullets: [],
                callouts: []
            ),
            SoilKnowledgeSection(
                id: "grower",
                heading: "The grower is part of the system",
                paragraphs: [
                    "Substrate should also relate to practical care. Consider how often the collection can be checked, whether automated watering is used, and whether the grower is away during the day.",
                    "A substrate should not only be theoretically ideal. It should also be manageable."
                ],
                bullets: [],
                callouts: []
            ),
            SoilKnowledgeSection(
                id: "watering-link",
                heading: "A connected system",
                paragraphs: [
                    "Substrate determines how water is stored. Watering determines when moisture is replaced. Neither should be understood separately.",
                    "The Watering chapter in this Handbook is the companion: observe the tree and the substrate together. Care → Watering is the practical watering surface in the programme."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )

    // MARK: - 09 Fertilizing & Roots

    private static let fertilizingAndRoots = SoilKnowledgeLesson(
        id: "fertilizing-roots",
        number: 9,
        title: "Fertilizing & Roots",
        summary: "Substrate influences nutrient retention and how roots develop. One ingredient does not automatically create better roots.",
        sections: [
            SoilKnowledgeSection(
                id: "fertilizer",
                heading: "Nutrients in the root environment",
                paragraphs: [
                    "Substrate influences nutrient retention, nutrient movement and root access. Organic components, particle surfaces and watering all change how fertilizer behaves.",
                    "This chapter does not duplicate feeding recommendations. Fertilizing in this Handbook explains the relationship. Fertilizer Guides remain the practical feeding surface."
                ],
                bullets: [],
                callouts: []
            ),
            SoilKnowledgeSection(
                id: "roots",
                heading: "Roots respond to their environment",
                paragraphs: [
                    "Substrate structure can influence fine root development, root distribution and root density. Avoid simplistic claims that one ingredient automatically creates better roots.",
                    "Root development depends on substrate, species, water, tree health and growth conditions together."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )

    // MARK: - 10 Structure Over Time

    private static let structureOverTime = SoilKnowledgeLesson(
        id: "structure-over-time",
        number: 10,
        title: "Structure Over Time",
        summary: "Soil age is not a calendar. The relevant question is how the substrate is behaving now.",
        sections: [
            SoilKnowledgeSection(
                id: "breakdown",
                heading: "Substrate changes over time",
                paragraphs: [
                    "Some materials break down. Over time this may change particle size, air space and water behaviour. Particle size distribution, pore structure, water retention and compaction can all shift.",
                    "Soil age is not only measured in months or years. Watch how the pot behaves over seasons rather than assuming the mix you used on day one is still the mix you have now. Replacement timing depends on material, climate, watering and root growth. This chapter does not prescribe a universal schedule."
                ],
                bullets: [],
                callouts: []
            ),
            SoilKnowledgeSection(
                id: "compaction",
                heading: "Loss of structure",
                paragraphs: [
                    "Compaction can influence water movement, oxygen availability and root health. Potential causes include fine particles, organic breakdown and root density.",
                    "Repotting is the chapter that covers when and how to renew the root environment. Compaction is information — not automatically an emergency, and not automatically ignorable."
                ],
                bullets: [],
                callouts: []
            ),
            SoilKnowledgeSection(
                id: "nursery-soil",
                heading: "Nursery soil",
                paragraphs: [
                    "Many nursery-grown trees arrive in organic nursery substrates. Those mixes are built for production: growth rate, watering logistics and cost at the nursery — not necessarily years in a small bonsai pot.",
                    "Nursery soil is not always bad. It can become problematic when its physical properties are poorly matched to the tree, container and growing environment.",
                    "In cool, wet climates, prolonged moisture in a fine organic mix can reduce oxygen around roots. Evaluate the actual substrate — drainage, compaction, smell, root colour — rather than following a rule to dump every nursery mix on arrival."
                ],
                bullets: [
                    "Water retention",
                    "Organic content",
                    "Decomposition",
                    "Compaction",
                    "Air-filled pore space",
                    "Drainage",
                    "Climate",
                    "Pot size",
                    "How roots have developed in that medium"
                ],
                callouts: []
            ),
            SoilKnowledgeSection(
                id: "reuse",
                heading: "Reusing bonsai substrate",
                paragraphs: [
                    "Reused substrate must be evaluated carefully. Consider structural condition, root remnants, disease concerns and particle breakdown.",
                    "Do not automatically recommend reuse. Do not automatically prohibit it. Evaluate the material and the health context."
                ],
                bullets: [],
                callouts: []
            ),
            SoilKnowledgeSection(
                id: "changing",
                heading: "Changing substrate",
                paragraphs: [
                    "Changing substrate can alter water behaviour, the root environment and care requirements. When changing substrate significantly, understand what changes.",
                    "Do not assume the tree can be cared for exactly as before."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )

    // MARK: - 11 Practice

    private static let practice = SoilKnowledgeLesson(
        id: "practice",
        number: 11,
        title: "Practice",
        summary: "The goal is not to copy a recipe. The goal is to understand the roots.",
        sections: [
            SoilKnowledgeSection(
                id: "mistakes",
                heading: "Common beginner mistakes",
                paragraphs: [
                    "Searching for one universal soil recipe. Copying another grower's mix without considering climate. Ignoring particle size. Ignoring soil breakdown.",
                    "Using substrate without adjusting watering. Assuming faster drainage always means healthier roots. Ignoring the needs of the development stage.",
                    "Using identical substrate for every tree. Ignoring pot size. Changing multiple variables without understanding the results."
                ],
                bullets: [],
                callouts: []
            ),
            SoilKnowledgeSection(
                id: "advanced",
                heading: "Designing the root environment",
                paragraphs: [
                    "Advanced growers do not ask only what mix you use. They ask what environment this tree needs.",
                    "They consider species, tree development, root system, pot, climate and watering system. The substrate becomes part of the tree's cultivation strategy."
                ],
                bullets: [],
                callouts: []
            ),
            SoilKnowledgeSection(
                id: "framework",
                heading: "Practical substrate decision framework",
                paragraphs: [
                    "Work through the tree, then the environment, then the materials. Observe after you mix. Adjust at a future repotting if necessary."
                ],
                bullets: [
                    "Identify the species.",
                    "Evaluate the tree's development stage.",
                    "Consider the current root system.",
                    "Consider pot size and depth.",
                    "Consider climate and growing location.",
                    "Consider watering frequency and collection management.",
                    "Define desired moisture behaviour.",
                    "Choose components based on function.",
                    "Choose particle sizes.",
                    "Observe how the tree and substrate behave.",
                    "Adjust during future repotting if necessary."
                ],
                callouts: []
            ),
            SoilKnowledgeSection(
                id: "paths",
                heading: "Beginner, intermediate and advanced",
                paragraphs: [
                    "Beginner — why ordinary soil often behaves poorly in bonsai pots; water and oxygen; basic substrate structure; why mixes differ.",
                    "Intermediate — component properties; particle size; climate adaptation; development versus refinement.",
                    "Advanced — individual tree substrate design; root-zone management; long-term structural stability; collection-wide substrate strategy."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )

    // MARK: - 12 Troubleshooting

    private static let troubleshooting = SoilKnowledgeLesson(
        id: "troubleshooting",
        number: 12,
        title: "Troubleshooting",
        summary: "A change in the pot is information. Do not assume substrate is the only cause.",
        sections: [
            SoilKnowledgeSection(
                id: "stays-wet",
                heading: "The substrate stays wet too long",
                paragraphs: [
                    "Check particle size, organic content, root health, pot size and climate."
                ],
                bullets: [],
                callouts: []
            ),
            SoilKnowledgeSection(
                id: "dries-fast",
                heading: "The substrate dries extremely quickly",
                paragraphs: [
                    "Check particle size, water retention, pot size, wind and root density."
                ],
                bullets: [],
                callouts: []
            ),
            SoilKnowledgeSection(
                id: "runoff",
                heading: "Water runs off the surface",
                paragraphs: [
                    "Check surface condition, soil dryness, root congestion and substrate structure. The Watering chapter covers penetration technique."
                ],
                bullets: [],
                callouts: []
            ),
            SoilKnowledgeSection(
                id: "growth",
                heading: "Growth has declined",
                paragraphs: [
                    "Do not assume substrate is the only cause. Evaluate roots, water, fertilizer, tree health and environment."
                ],
                bullets: [],
                callouts: []
            ),
            SoilKnowledgeSection(
                id: "changed",
                heading: "The substrate has changed significantly since repotting",
                paragraphs: [
                    "Check particle breakdown, root development and water behaviour. Consider whether future repotting is required."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )

    // MARK: - 13 Quick Guides

    private static let quickGuides = SoilKnowledgeLesson(
        id: "quick-guides",
        number: 13,
        title: "Quick Guides",
        summary: "There is no single perfect bonsai soil. There is only a substrate that works well for a particular tree, pot, environment and grower.",
        sections: [
            SoilKnowledgeSection(
                id: "cards",
                heading: "Knowledge cards",
                paragraphs: [],
                bullets: [],
                callouts: [
                    SoilKnowledgeCallout(
                        id: "card-function",
                        title: "Understand the function",
                        body: "Choose ingredients based on what they do."
                    ),
                    SoilKnowledgeCallout(
                        id: "card-air",
                        title: "Roots need air",
                        body: "Water is essential. Constant saturation is not."
                    ),
                    SoilKnowledgeCallout(
                        id: "card-size",
                        title: "Particle size matters",
                        body: "The same material behaves differently at different sizes."
                    ),
                    SoilKnowledgeCallout(
                        id: "card-climate",
                        title: "Climate changes everything",
                        body: "A successful mix in one climate may behave differently in another."
                    ),
                    SoilKnowledgeCallout(
                        id: "card-development",
                        title: "Development is different",
                        body: "The best substrate for growth may not be the best for refinement."
                    ),
                    SoilKnowledgeCallout(
                        id: "card-observe",
                        title: "Observe over time",
                        body: "Substrate changes as particles break down and roots develop."
                    )
                ]
            ),
            SoilKnowledgeSection(
                id: "connections",
                heading: "Connections to other Bonsai World knowledge",
                paragraphs: [
                    "Repotting — root work, soil replacement and pot preparation.",
                    "Watering — moisture, drying behaviour and water penetration.",
                    "Fertilizing — nutrient retention and root uptake. Use Fertilizer Guides for practical feeding recommendations.",
                    "Tree Health — root health, compaction and disease.",
                    "Species Profiles — species-specific substrate preferences.",
                    "Tree development — growth strategies and root development.",
                    "Inventory → Soil is the stock and mix record in the programme.",
                    "Tools & Equipment — sieves, scoops and soil tools.",
                    "Propagation — rooting media versus finished bonsai soil."
                ],
                bullets: [],
                callouts: []
            ),
            SoilKnowledgeSection(
                id: "visuals",
                heading: "Visual learning",
                paragraphs: [
                    "Future visual content should teach function, not merely ingredient recognition: different particle sizes, healthy substrate structure, compacted substrate, water movement, water retention comparison, root systems in different substrates, and development versus refinement examples."
                ],
                bullets: [],
                callouts: []
            ),
            SoilKnowledgeSection(
                id: "mix-builder",
                heading: "Future: Substrate Mix Builder",
                paragraphs: [
                    "A future tool could take species, development stage, climate, pot size, watering frequency and available materials, then suggest substrate characteristics — higher water retention, higher air space, increased structural stability — and explain why.",
                    "Recommendations should be a suggested starting point with possible adjustments. Monitor and adapt. Avoid presenting recommendations as absolute recipes."
                ],
                bullets: [],
                callouts: []
            ),
            SoilKnowledgeSection(
                id: "philosophy",
                heading: "Bonsai World philosophy",
                paragraphs: [
                    "There is no single perfect bonsai soil. There is only a substrate that works well for a particular tree, in a particular pot, in a particular environment, with a particular grower.",
                    "The goal is not to copy a recipe. The goal is to understand the roots. When you understand what the roots need, the choice of substrate becomes a decision. Not a guess."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )
}
