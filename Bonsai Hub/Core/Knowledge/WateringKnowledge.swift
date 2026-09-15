//
//  WateringKnowledge.swift
//  Bonsai World
//
//  Knowledge → Bonsai Handbook → Watering.
//  Observe the tree and substrate. Do not water the calendar.
//

import Foundation

struct WateringKnowledgeCallout: Identifiable, Hashable, Sendable {
    var id: String
    var title: String
    var body: String
}

struct WateringKnowledgeSection: Identifiable, Hashable, Sendable {
    var id: String
    var heading: String
    var paragraphs: [String]
    var bullets: [String]
    var callouts: [WateringKnowledgeCallout]
}

struct WateringKnowledgeLesson: Identifiable, Hashable, Sendable {
    var id: String
    var number: Int
    var title: String
    var summary: String
    var sections: [WateringKnowledgeSection]
}

enum WateringKnowledge {
    static let chapterTitle = "Watering"

    static let openingLine =
        "Understanding when, how and why bonsai need water — from basic daily care to advanced observation and collection management."

    static let disclaimer =
        "Species, soil, pot, roots, health, season, weather and climate change the answer. Treat this as decision support — not a timetable."

    static let lessons: [WateringKnowledgeLesson] = [
        overview,
        whenToWater,
        howToWater,
        soilPotRoots,
        treeHealth,
        seasons,
        weather,
        waterQuality,
        stageAndRepotting,
        species,
        collectionPractice,
        practice,
        quickGuides
    ]

    static func lesson(id: String) -> WateringKnowledgeLesson? {
        lessons.first { $0.id == id }
    }

    // MARK: - 01 Overview

    private static let overview = WateringKnowledgeLesson(
        id: "overview",
        number: 1,
        title: "Overview",
        summary: "Watering is a daily decision, not a timetable. Healthy watering begins with a healthy root environment.",
        sections: [
            WateringKnowledgeSection(
                id: "introduction",
                heading: "Watering bonsai",
                paragraphs: [
                    "Watering is one of the most important daily decisions in bonsai. Every tree depends on the person caring for it to understand changing water requirements.",
                    "The same tree may need very different watering depending on weather, season, soil, pot size, root development, growth activity and tree health. Watering should never be reduced to watering every day, or watering twice a week.",
                    "A bonsai artist learns to observe the tree and its growing environment."
                ],
                bullets: [],
                callouts: [
                    WateringKnowledgeCallout(
                        id: "not-calendar",
                        title: "Bonsai World principle",
                        body: "Do not water the calendar. Water the tree."
                    )
                ]
            ),
            WateringKnowledgeSection(
                id: "why",
                heading: "Why water matters",
                paragraphs: [
                    "Water is essential for root function, nutrient transport, growth, photosynthesis, cooling and overall tree health.",
                    "Bonsai live in relatively small containers. The root environment can change quickly. A large tree in the ground may have access to a much larger volume of soil and moisture. A bonsai depends on a limited root environment. Observation is essential."
                ],
                bullets: [],
                callouts: []
            ),
            WateringKnowledgeSection(
                id: "oxygen",
                heading: "Water and oxygen",
                paragraphs: [
                    "Healthy roots require both water and air. The goal is not permanently wet soil. The goal is an appropriate balance between moisture and oxygen.",
                    "Soil structure affects that balance. Soil & Substrate in this Handbook explains substrate as a system of water, air and particles."
                ],
                bullets: [],
                callouts: [
                    WateringKnowledgeCallout(
                        id: "root-environment",
                        title: "Bonsai World principle",
                        body: "Healthy watering begins with a healthy root environment."
                    )
                ]
            )
        ]
    )

    // MARK: - 02 When

    private static let whenToWater = WateringKnowledgeLesson(
        id: "when",
        number: 2,
        title: "When to Water",
        summary: "Surface dryness is not the whole story. Read the soil, the pot and the tree together.",
        sections: [
            WateringKnowledgeSection(
                id: "reading",
                heading: "Reading the soil and tree",
                paragraphs: [
                    "Watering decisions should be based on observation. Indicators can include surface soil appearance, moisture below the surface, pot weight, foliage condition and weather.",
                    "Surface dryness alone does not always reveal moisture deeper in the pot. Understand the full root environment.",
                    "Visual inspection, touch, a wooden chopstick or other moisture check, pot weight and experience with the specific substrate can all help. No single method is perfect for every tree."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )

    // MARK: - 03 How

    private static let howToWater = WateringKnowledgeLesson(
        id: "how",
        number: 3,
        title: "How to Water",
        summary: "Water so moisture reaches the roots. If water runs off, find out why — technique, soil or roots.",
        sections: [
            WateringKnowledgeSection(
                id: "thoroughly",
                heading: "Watering thoroughly",
                paragraphs: [
                    "Watering should generally ensure that moisture reaches the root system. Aim for even watering, penetration through the substrate, and no dry pockets in the root mass. Allow water to move through the pot.",
                    "Watering once may not be enough if the soil has become extremely dry, water runs off the surface, or the substrate is difficult to re-wet. Do not turn watering twice into a universal rule. Observe."
                ],
                bullets: [],
                callouts: []
            ),
            WateringKnowledgeSection(
                id: "penetration",
                heading: "When water does not reach the roots",
                paragraphs: [
                    "Water may run off or fail to penetrate because the substrate is very dry, the soil has broken down, roots are congested, or the surface is compacted.",
                    "That can reveal a soil problem, a root problem, or a watering-technique problem. Soil & Substrate, Repotting and Tree Health sit beside this chapter for those diagnoses."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )

    // MARK: - 04 Soil, pot, roots

    private static let soilPotRoots = WateringKnowledgeLesson(
        id: "soil-pot-roots",
        number: 4,
        title: "Soil, Pot & Roots",
        summary: "Do not water the species alone. Water the tree, the substrate, the pot and the current root system together.",
        sections: [
            WateringKnowledgeSection(
                id: "soil",
                heading: "Watering and soil",
                paragraphs: [
                    "Substrate characteristics influence water retention, drainage, air space and drying speed. Two trees of the same species may need very different watering if they grow in different substrates.",
                    "Soil & Substrate in this Handbook explains that system."
                ],
                bullets: [],
                callouts: [
                    WateringKnowledgeCallout(
                        id: "together",
                        title: "Bonsai World principle",
                        body: "Do not water the species alone. Water the tree and the substrate together."
                    )
                ]
            ),
            WateringKnowledgeSection(
                id: "pot",
                heading: "Watering and pot size",
                paragraphs: [
                    "Small pots, large pots, shallow pots and deep pots all influence moisture behaviour. Small and shallow bonsai pots may dry quickly and respond rapidly to weather. Larger containers may retain moisture longer.",
                    "Avoid universal assumptions. Substrate, climate and root density also matter."
                ],
                bullets: [],
                callouts: []
            ),
            WateringKnowledgeSection(
                id: "roots",
                heading: "Watering and root density",
                paragraphs: [
                    "A tree with a dense, active root system may use water differently from a recently repotted tree. Root density, fine-root development, growth activity and pot volume all play a part.",
                    "The same bonsai may require different watering before and after root development."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )

    // MARK: - 05 Health

    private static let treeHealth = WateringKnowledgeLesson(
        id: "tree-health",
        number: 5,
        title: "Tree Health",
        summary: "A weak tree is not automatically a thirsty tree. Understand the symptom before you add water.",
        sections: [
            WateringKnowledgeSection(
                id: "weak",
                heading: "A weak tree is not automatically thirsty",
                paragraphs: [
                    "Drooping leaves, yellowing and weak growth can have many causes. Do not assume that looking weak means the tree needs more water.",
                    "Possible causes include underwatering, excessive moisture, root problems, heat stress, disease, pests and nutrient issues. Tree Health belongs in that diagnosis."
                ],
                bullets: [],
                callouts: [
                    WateringKnowledgeCallout(
                        id: "symptoms",
                        title: "Bonsai World principle",
                        body: "Symptoms must be understood before they are treated."
                    )
                ]
            )
        ]
    )

    // MARK: - 06 Seasons

    private static let seasons = WateringKnowledgeLesson(
        id: "seasons",
        number: 6,
        title: "Seasons",
        summary: "Demand changes with growth and weather. Low activity in winter does not mean no water. The calendar is not the trigger.",
        sections: [
            WateringKnowledgeSection(
                id: "spring",
                heading: "Spring",
                paragraphs: [
                    "Water requirements may increase as temperatures rise, growth begins, roots become active and new foliage develops. Spring weather can change rapidly. Adjust according to actual conditions."
                ],
                bullets: [],
                callouts: []
            ),
            WateringKnowledgeSection(
                id: "summer",
                heading: "Summer",
                paragraphs: [
                    "Heat, sun, wind, active growth and small pots may increase demand. Some bonsai need increased monitoring.",
                    "Do not create a universal rule for how many times a day to water. The correct decision depends on conditions. Morning observation, afternoon heat, shade and wind exposure all matter."
                ],
                bullets: [],
                callouts: []
            ),
            WateringKnowledgeSection(
                id: "autumn",
                heading: "Autumn",
                paragraphs: [
                    "Temperatures may decrease, growth may slow and evaporation may reduce. Watering requirements may change. Some species may still remain active. Do not reduce watering based on the calendar alone."
                ],
                bullets: [],
                callouts: []
            ),
            WateringKnowledgeSection(
                id: "winter",
                heading: "Winter",
                paragraphs: [
                    "Low activity does not mean no water. Requirements depend on species, dormancy, temperature, storage conditions, wind and sun exposure.",
                    "Frozen soil changes water availability. Avoid simplistic instructions. Species Profiles and climate-specific guidance belong beside this chapter."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )

    // MARK: - 07 Weather

    private static let weather = WateringKnowledgeLesson(
        id: "weather",
        number: 7,
        title: "Weather",
        summary: "Rain is not always enough. Wind can dry a tree faster than heat. Check the substrate.",
        sections: [
            WateringKnowledgeSection(
                id: "rain",
                heading: "Rain",
                paragraphs: [
                    "Rainfall may not fully wet dense foliage, the root system or the entire pot. Heavy foliage can act as an umbrella. Continuous rain can create excessive moisture.",
                    "Check the substrate. Do not assume."
                ],
                bullets: [],
                callouts: []
            ),
            WateringKnowledgeSection(
                id: "sun",
                heading: "Sun",
                paragraphs: [
                    "Sun exposure influences evaporation, pot temperature and foliage water demand. Morning sun, strong afternoon sun, full sun and partial shade are different conditions. Species Profiles should carry more specific light guidance where it exists."
                ],
                bullets: [],
                callouts: []
            ),
            WateringKnowledgeSection(
                id: "wind",
                heading: "Wind",
                paragraphs: [
                    "Wind can significantly increase water loss. A bonsai may dry faster in moderate temperature and strong wind than in higher temperature and still air. Observe actual drying behaviour."
                ],
                bullets: [],
                callouts: []
            ),
            WateringKnowledgeSection(
                id: "humidity",
                heading: "Humidity",
                paragraphs: [
                    "Humidity influences water loss, drying speed and environmental stress. High humidity does not remove the need for proper watering. Roots still require appropriate moisture."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )

    // MARK: - 08 Water quality

    private static let waterQuality = WateringKnowledgeLesson(
        id: "water-quality",
        number: 8,
        title: "Water Quality",
        summary: "Tap water, rainwater, minerals and hardness differ by place. No source is universally superior.",
        sections: [
            WateringKnowledgeSection(
                id: "source",
                heading: "What water are you giving the tree?",
                paragraphs: [
                    "Tap water, rainwater, mineral content, hardness and local differences all matter. One water source is not universally superior.",
                    "Local water quality may become relevant depending on species, long-term soil chemistry and fertilizer practices."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )

    // MARK: - 09 Stage

    private static let stageAndRepotting = WateringKnowledgeLesson(
        id: "stage",
        number: 9,
        title: "Stage & Repotting",
        summary: "A recently repotted tree, a development tree and a refined tree do not share one watering habit.",
        sections: [
            WateringKnowledgeSection(
                id: "after-repot",
                heading: "Watering after repotting",
                paragraphs: [
                    "Repotting changes root structure, soil structure and water behaviour. A recently repotted tree may not behave exactly like it did before. Observe the new substrate and root environment.",
                    "The Repotting chapter covers recovery after root work."
                ],
                bullets: [],
                callouts: []
            ),
            WateringKnowledgeSection(
                id: "development",
                heading: "During development",
                paragraphs: [
                    "Developing bonsai may have larger root systems, grow in larger containers and use more water. Watering should support healthy growth. Do not use excessive watering as a method for forcing growth."
                ],
                bullets: [],
                callouts: []
            ),
            WateringKnowledgeSection(
                id: "refinement",
                heading: "During refinement",
                paragraphs: [
                    "Refined bonsai often live in smaller pots and more controlled root environments. That may require more frequent observation and more precise watering.",
                    "Refinement does not mean deliberately stressing the tree through lack of water."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )

    // MARK: - 10 Species

    private static let species = WateringKnowledgeLesson(
        id: "species",
        number: 10,
        title: "Species",
        summary: "Water according to the tree you have, not a generic category.",
        sections: [
            WateringKnowledgeSection(
                id: "deciduous",
                heading: "Deciduous bonsai",
                paragraphs: [
                    "Seasonal foliage, active growth, leaf surface and species differences all change demand. One deciduous watering habit does not fit every maple, beech or elm."
                ],
                bullets: [],
                callouts: []
            ),
            WateringKnowledgeSection(
                id: "conifers",
                heading: "Conifers",
                paragraphs: [
                    "Foliage type and root behaviour may create different watering patterns from deciduous trees. Species still differ within the conifer group."
                ],
                bullets: [],
                callouts: []
            ),
            WateringKnowledgeSection(
                id: "evergreen",
                heading: "Evergreen broadleaf bonsai",
                paragraphs: [
                    "Species-specific differences in leaf, root and seasonal activity still decide the work. Species Profiles should carry more specific guidance where it exists."
                ],
                bullets: [],
                callouts: []
            ),
            WateringKnowledgeSection(
                id: "tropical",
                heading: "Tropical bonsai",
                paragraphs: [
                    "Active growth, temperature, indoor or outdoor environment and humidity change both demand and drying. A temperate calendar is the wrong frame."
                ],
                bullets: [],
                callouts: [
                    WateringKnowledgeCallout(
                        id: "tree-you-have",
                        title: "Key principle",
                        body: "Water according to the tree you have, not a generic category."
                    )
                ]
            )
        ]
    )

    // MARK: - 11 Collection

    private static let collectionPractice = WateringKnowledgeLesson(
        id: "collection",
        number: 11,
        title: "Collection Practice",
        summary: "Automation and travel arrangements can deliver water. They cannot replace observation.",
        sections: [
            WateringKnowledgeSection(
                id: "automation",
                heading: "Automated watering systems",
                paragraphs: [
                    "Automated systems may improve consistency, support large collections, help during travel and reduce manual workload. Automation does not replace observation.",
                    "The system must be adjusted according to weather, season and collection needs. It can deliver water. It cannot automatically understand every tree."
                ],
                bullets: [],
                callouts: []
            ),
            WateringKnowledgeSection(
                id: "away",
                heading: "Watering while away",
                paragraphs: [
                    "Consider collection needs, automated systems, shade, wind exposure and reliable care arrangements. Preparation depends on duration, season, weather and the trees you have. There is no one-size-fits-all absence plan."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )

    // MARK: - 12 Practice

    private static let practice = WateringKnowledgeLesson(
        id: "practice",
        number: 12,
        title: "Practice",
        summary: "Beginner mistakes, individual-tree familiarity, a daily observation process, a decision framework, and what to learn at each level.",
        sections: [
            WateringKnowledgeSection(
                id: "mistakes",
                heading: "Common beginner mistakes",
                paragraphs: [
                    "Watering according to a fixed schedule. Watering because the surface looks dry without checking deeper moisture. Allowing water to run off without reaching the roots. Assuming rain always provides enough water. Assuming a weak tree needs more water.",
                    "Ignoring wind. Ignoring substrate. Changing watering habits according to the calendar instead of conditions. Using identical watering practices for every tree. Treating automated watering as a replacement for observation."
                ],
                bullets: [],
                callouts: []
            ),
            WateringKnowledgeSection(
                id: "advanced",
                heading: "Understanding individual trees",
                paragraphs: [
                    "Advanced watering is based on familiarity. An experienced artist learns how individual pots dry, how specific substrates behave, which trees use water quickly, and how weather changes the collection.",
                    "The goal is not a rigid system. The goal is observation, understanding and consistency."
                ],
                bullets: [],
                callouts: []
            ),
            WateringKnowledgeSection(
                id: "daily",
                heading: "The daily observation process",
                paragraphs: [
                    "Observe soil, pot weight, weather, sun exposure, wind and tree condition. Ask whether this tree needs water now, whether conditions will change significantly today, whether the tree is drying normally, and whether something has changed.",
                    "A sudden change in watering behaviour may provide important information about roots, soil, weather or tree health."
                ],
                bullets: [],
                callouts: []
            ),
            WateringKnowledgeSection(
                id: "framework",
                heading: "A practical decision framework",
                paragraphs: [
                    "Work through the steps in order. Continue to monitor after you water."
                ],
                bullets: [
                    "Step 1 — Check the substrate.",
                    "Step 2 — Check moisture below the surface where appropriate.",
                    "Step 3 — Consider weather.",
                    "Step 4 — Consider species.",
                    "Step 5 — Consider pot and soil.",
                    "Step 6 — Consider tree health and growth.",
                    "Step 7 — Water thoroughly if the tree requires water.",
                    "Step 8 — Observe how water behaves.",
                    "Step 9 — Continue to monitor."
                ],
                callouts: []
            ),
            WateringKnowledgeSection(
                id: "paths",
                heading: "Beginner, intermediate, advanced",
                paragraphs: [
                    "Beginner: why bonsai need water, how to check moisture, how to water thoroughly, and why fixed schedules are unreliable.",
                    "Intermediate: soil behaviour, weather, seasonal changes, pot size and root density.",
                    "Advanced: individual tree behaviour, collection management, microclimate, automated systems and predictive observation."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )

    // MARK: - 13 Quick Guides

    private static let quickGuides = WateringKnowledgeLesson(
        id: "quick-guides",
        number: 13,
        title: "Quick Guides",
        summary: "Short cards, troubleshooting, links to other Bonsai World knowledge, and the principle that closes the chapter.",
        sections: [
            WateringKnowledgeSection(
                id: "cards",
                heading: "Quick knowledge cards",
                paragraphs: [],
                bullets: [],
                callouts: [
                    WateringKnowledgeCallout(
                        id: "card-calendar",
                        title: "Do not water the calendar",
                        body: "Water when the tree and substrate require it."
                    ),
                    WateringKnowledgeCallout(
                        id: "card-surface",
                        title: "Check below the surface",
                        body: "Surface dryness does not always reveal root-zone moisture."
                    ),
                    WateringKnowledgeCallout(
                        id: "card-rain",
                        title: "Rain is not always enough",
                        body: "Check the substrate."
                    ),
                    WateringKnowledgeCallout(
                        id: "card-wind",
                        title: "Wind changes everything",
                        body: "Wind can dry a bonsai faster than temperature alone."
                    ),
                    WateringKnowledgeCallout(
                        id: "card-soil",
                        title: "Know your soil",
                        body: "The substrate controls much of the watering behaviour."
                    ),
                    WateringKnowledgeCallout(
                        id: "card-change",
                        title: "Observe changes",
                        body: "A sudden change in water use can be important information."
                    )
                ]
            ),
            WateringKnowledgeSection(
                id: "runs-through",
                heading: "Water runs directly through the pot",
                paragraphs: [
                    "The water is leaving without doing the work."
                ],
                bullets: [
                    "Substrate condition",
                    "Root structure",
                    "Whether the root ball is extremely dry"
                ],
                callouts: []
            ),
            WateringKnowledgeSection(
                id: "stays-wet",
                heading: "The soil remains wet for a very long time",
                paragraphs: [
                    "Moisture that will not leave is a system problem."
                ],
                bullets: [
                    "Soil structure",
                    "Drainage",
                    "Root health",
                    "Climate"
                ],
                callouts: []
            ),
            WateringKnowledgeSection(
                id: "dries-fast",
                heading: "The tree dries unusually quickly",
                paragraphs: [
                    "Faster drying is information, not automatically a request for more frequent watering on a timetable."
                ],
                bullets: [
                    "Weather",
                    "Wind",
                    "Root density",
                    "Pot size",
                    "Tree growth"
                ],
                callouts: []
            ),
            WateringKnowledgeSection(
                id: "drooping",
                heading: "Leaves are drooping",
                paragraphs: [
                    "Do not assume lack of water."
                ],
                bullets: [
                    "Soil moisture",
                    "Root health",
                    "Heat",
                    "Disease",
                    "Pests"
                ],
                callouts: []
            ),
            WateringKnowledgeSection(
                id: "sudden",
                heading: "Watering needs suddenly changed",
                paragraphs: [
                    "A change in water use can point to weather, growth, roots, soil or health."
                ],
                bullets: [
                    "Weather",
                    "Growth",
                    "Roots",
                    "Soil condition",
                    "Tree health"
                ],
                callouts: []
            ),
            WateringKnowledgeSection(
                id: "connections",
                heading: "Connections to other Bonsai World knowledge",
                paragraphs: [
                    "Soil & Substrate — water retention, drainage and air space.",
                    "Repotting — root systems, soil changes and recovery.",
                    "Fertilizing — nutrient transport and soil management. Use Fertilizer Guides for practical feeding recommendations.",
                    "Tree Health — symptoms, root problems, disease and pests. Care → Health is the practical surface.",
                    "Species Profiles — species-specific requirements, seasonal behaviour and environmental needs.",
                    "Care → Watering is the practical watering surface in the programme.",
                    "Tools & Equipment — watering cans, roses and automation.",
                    "Bonsai Collection Management — watering at collection scale, automation and absence.",
                    "Propagation — watering and moisture for young seedlings and cuttings.",
                    "Seasonal Care & Protection — changing demand, heat, frost and why not to water the clock."
                ],
                bullets: [],
                callouts: []
            ),
            WateringKnowledgeSection(
                id: "visuals",
                heading: "Visual learning",
                paragraphs: [
                    "Future visual content should teach observation: wet versus dry substrate, water penetration, surface moisture versus root-zone moisture, pot size, wind, watering under dense foliage and automated watering examples.",
                    "Do not use visuals merely as decoration."
                ],
                bullets: [],
                callouts: []
            ),
            WateringKnowledgeSection(
                id: "philosophy",
                heading: "Bonsai World philosophy",
                paragraphs: [
                    "Watering is not a routine measured by the clock. It is a conversation between the tree, its roots, its soil and its environment.",
                    "The more a bonsai artist observes, the less they need fixed rules.",
                    "A beginner asks how often they should water. An experienced bonsai artist asks what this tree needs today."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )
}
