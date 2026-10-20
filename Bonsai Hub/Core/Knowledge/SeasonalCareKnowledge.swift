//
//  SeasonalCareKnowledge.swift
//  Bonsai World
//
//  Knowledge → Bonsai Handbook → Seasonal Care & Protection.
//  The calendar is a guide. The tree and the conditions determine the moment.
//  How-to for watering, feeding, repotting and pruning lives in those chapters.
//

import Foundation

struct SeasonalCareCallout: Identifiable, Hashable, Sendable {
    var id: String
    var title: String
    var body: String
}

struct SeasonalCareSection: Identifiable, Hashable, Sendable {
    var id: String
    var heading: String
    var paragraphs: [String]
    var bullets: [String]
    var callouts: [SeasonalCareCallout]
}

struct SeasonalCareLesson: Identifiable, Hashable, Sendable {
    var id: String
    var number: Int
    var title: String
    var summary: String
    var sections: [SeasonalCareSection]
}

enum SeasonalCareKnowledge {
    static let chapterTitle = "Seasonal Care & Protection"

    static let openingLine =
        "Understanding the annual rhythm of bonsai and protecting trees through changing conditions."

    static let disclaimer =
        "This chapter does not provide a universal calendar. Timing depends on species, climate, local weather, growing conditions, tree health and development stage. Care Calendar places a temperate year onto the default Garden's hemisphere and season. Care → Seasonal Care and Care → Winter Care are the practical surfaces. Species Library remains species-specific."

    static let lessons: [SeasonalCareLesson] = [
        overview,
        climate,
        spring,
        summer,
        autumn,
        winterPreparation,
        winterWaterAndFrost,
        weatherEvents,
        placementAndRecovery,
        collectionPlanning,
        datesAreNotNature,
        practice,
        quickGuides
    ]

    static func lesson(id: String) -> SeasonalCareLesson? {
        lessons.first { $0.id == id }
    }

    // MARK: - 01 Overview

    private static let overview = SeasonalCareLesson(
        id: "overview",
        number: 1,
        title: "Overview",
        summary: "Do not ask only what needs to be done. Ask what the tree is doing now.",
        sections: [
            SeasonalCareSection(
                id: "rhythm",
                heading: "Bonsai care changes throughout the year",
                paragraphs: [
                    "A tree that requires active monitoring in summer may require very little intervention during winter. The same action may be appropriate in one season and harmful in another.",
                    "Understanding the seasonal rhythm of the tree helps the artist make better decisions about watering, fertilizing, repotting, pruning, wiring, protection and development.",
                    "The calendar is a guide. The tree and the conditions determine the right moment."
                ],
                bullets: [],
                callouts: [
                    SeasonalCareCallout(
                        id: "what-now",
                        title: "Bonsai World principle",
                        body: "Do not ask only what needs to be done. Ask what the tree is doing now."
                    ),
                    SeasonalCareCallout(
                        id: "calendar-guide",
                        title: "Bonsai World principle",
                        body: "The calendar is a guide. The tree and the conditions determine the right moment."
                    )
                ]
            ),
            SeasonalCareSection(
                id: "year",
                heading: "The tree changes throughout the year",
                paragraphs: [
                    "Depending on species and climate, phases may include dormancy, early growth, active growth, growth slowing and seasonal preparation. Not every species follows exactly the same pattern.",
                    "Evergreen and deciduous species may behave differently. Local climate can significantly affect timing. Species Library describes seasonal behaviour. This chapter teaches how to read the year — not which month to act."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )

    // MARK: - 02 Climate

    private static let climate = SeasonalCareLesson(
        id: "climate",
        number: 2,
        title: "Climate",
        summary: "Advice such as “repot in March” may be useful in one climate and completely wrong in another.",
        sections: [
            SeasonalCareSection(
                id: "no-universal",
                heading: "There is no universal bonsai calendar",
                paragraphs: [
                    "Advice such as “repot in March” may be useful in one climate and completely wrong in another. The user should understand local temperatures, frost risk, growing season and weather patterns. Combine species knowledge with local observation.",
                    "A task reminder in Tasks should encourage inspection, not automatic action. Care → Seasonal Care is the programme surface for the current season’s work. It is not a worldwide date list."
                ],
                bullets: [],
                callouts: [
                    SeasonalCareCallout(
                        id: "local",
                        title: "Bonsai World principle",
                        body: "Learn the species. Then learn your climate."
                    )
                ]
            )
        ]
    )

    // MARK: - 03 Spring

    private static let spring = SeasonalCareLesson(
        id: "spring",
        number: 3,
        title: "Spring",
        summary: "Spring is often busy. Timing still belongs to the tree, the species and the local conditions.",
        sections: [
            SeasonalCareSection(
                id: "growth",
                heading: "The beginning of active growth",
                paragraphs: [
                    "Possible activities include repotting suitable trees, monitoring new growth, beginning fertilizing according to species and condition, early pest inspection and structural planning. Do not create one universal spring schedule.",
                    "Repotting, Fertilizing, Pruning and Wiring in this Handbook hold the why. Care → Repotting and Care → Fertilizing are the practical surfaces when the tree is actually ready."
                ],
                bullets: [],
                callouts: []
            ),
            SeasonalCareSection(
                id: "spring-water",
                heading: "Changing water demand",
                paragraphs: [
                    "As growth increases, water demand may change. Watering should respond to increased foliage, rising temperatures, root activity and weather. Avoid automatically increasing water. Observe the tree and substrate.",
                    "Watering in this Handbook covers observation. Care → Watering is the practical surface."
                ],
                bullets: [],
                callouts: []
            ),
            SeasonalCareSection(
                id: "spring-health",
                heading: "New growth reveals information",
                paragraphs: [
                    "Spring growth can reveal vigour, pest activity and problems from winter. Observe bud development, new foliage, unusual damage and weak areas.",
                    "Tree Health covers investigation before treatment. Care → Health lists trees that already need attention."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )

    // MARK: - 04 Summer

    private static let summer = SeasonalCareLesson(
        id: "summer",
        number: 4,
        title: "Summer",
        summary: "Water the tree and the conditions. Not the clock.",
        sections: [
            SeasonalCareSection(
                id: "active",
                heading: "The season of active care",
                paragraphs: [
                    "Summer may create the highest daily demand. Possible priorities include watering, heat protection, pest monitoring, fertilizing where appropriate and growth management.",
                    "Extreme heat can affect bonsai differently from trees in the ground. Small containers can change temperature and moisture rapidly."
                ],
                bullets: [],
                callouts: []
            ),
            SeasonalCareSection(
                id: "summer-water",
                heading: "Water demand can change quickly",
                paragraphs: [
                    "Water requirements may be affected by temperature, wind, sun, tree size, pot size and substrate. A tree may require different watering from one day to the next."
                ],
                bullets: [],
                callouts: [
                    SeasonalCareCallout(
                        id: "not-clock",
                        title: "Bonsai World principle",
                        body: "Water the tree and the conditions. Not the clock."
                    )
                ]
            ),
            SeasonalCareSection(
                id: "heat",
                heading: "Heat protection",
                paragraphs: [
                    "During extreme heat, bonsai may require protection: adjusting position, temporary shade where appropriate, monitoring water demand and protecting vulnerable material.",
                    "Shade requirements vary by species, tree health and development stage. Care → Placement records where the tree stands. Do not assume every tree wants the same shade cloth."
                ],
                bullets: [],
                callouts: []
            ),
            SeasonalCareSection(
                id: "pests",
                heading: "Summer pest monitoring",
                paragraphs: [
                    "Warm periods may increase pest activity. Regular inspection should focus on new growth, leaf undersides and branch junctions. Tree Health covers recognition. Care → Health is the practical surface."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )

    // MARK: - 05 Autumn

    private static let autumn = SeasonalCareLesson(
        id: "autumn",
        number: 5,
        title: "Autumn",
        summary: "Growth may slow, change colour or prepare for dormancy. Use the visibility, not a date.",
        sections: [
            SeasonalCareSection(
                id: "transition",
                heading: "The transition season",
                paragraphs: [
                    "Depending on species and climate, growth may slow, change colour or prepare for dormancy. Possible priorities include monitoring seasonal changes, adjusting fertilizing according to the programme, reviewing wiring and preparing for colder conditions.",
                    "Fertilizer Guides and Fertilizing cover feeding when the tree can still use it. Wiring covers inspection so wire is not left through thickening autumn wood."
                ],
                bullets: [],
                callouts: []
            ),
            SeasonalCareSection(
                id: "assessment",
                heading: "Reviewing the year",
                paragraphs: [
                    "Autumn can be a useful time to observe structural development, branch visibility and overall health. For deciduous trees, leaf drop may reveal structure, trunk and branching. That can inform future planning.",
                    "Bonsai Artistry & the Bonsai Eye trains looking at structure. Design Guidelines cover what that structure should serve. Do not prune a diagnosis away — Tree Health first if the tree looks unwell."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )

    // MARK: - 06 Winter Preparation

    private static let winterPreparation = SeasonalCareLesson(
        id: "winter-preparation",
        number: 6,
        title: "Winter Preparation",
        summary: "Protection begins before extreme conditions. Not every bonsai needs a greenhouse.",
        sections: [
            SeasonalCareSection(
                id: "before",
                heading: "Protection begins before extreme conditions",
                paragraphs: [
                    "Winter preparation may include species hardiness, pot exposure, wind, frost and root protection. Different trees require different levels of protection.",
                    "Do not assume that all bonsai need a greenhouse, indoor storage or complete frost protection. Care → Winter Care is the practical surface. Species Library remains species-specific."
                ],
                bullets: [],
                callouts: [
                    SeasonalCareCallout(
                        id: "not-all",
                        title: "Bonsai World principle",
                        body: "Do not assume every bonsai needs the same winter house."
                    )
                ]
            ),
            SeasonalCareSection(
                id: "dormancy",
                heading: "Dormancy is part of development",
                paragraphs: [
                    "Many outdoor bonsai require seasonal dormancy. Dormancy should not automatically be treated as a problem. Care may become less intensive, but observation remains important."
                ],
                bullets: [],
                callouts: [
                    SeasonalCareCallout(
                        id: "rest",
                        title: "Bonsai World principle",
                        body: "Dormancy is not failure. Rest is part of the annual cycle."
                    )
                ]
            )
        ]
    )

    // MARK: - 07 Winter Watering & Frost

    private static let winterWaterAndFrost = SeasonalCareLesson(
        id: "winter-water-frost",
        number: 7,
        title: "Winter Watering & Frost",
        summary: "Less growth does not mean no water. Roots in containers experience cold differently from roots in the ground.",
        sections: [
            SeasonalCareSection(
                id: "winter-water",
                heading: "Less growth does not mean no water",
                paragraphs: [
                    "Dormant trees may still require water. The substrate should not be ignored simply because the tree is not actively growing. Needs depend on temperature, weather, protection and substrate.",
                    "Avoid a fixed winter watering schedule. Watering in this Handbook covers observation in all seasons. Care → Watering remains the practical surface."
                ],
                bullets: [],
                callouts: []
            ),
            SeasonalCareSection(
                id: "frost",
                heading: "Protecting the root system",
                paragraphs: [
                    "Roots in bonsai containers may be more exposed to extreme cold than roots growing in the ground. Consider pot exposure, wind, duration of cold, species tolerance and tree health.",
                    "Protection should be based on risk, not fear of every cold night."
                ],
                bullets: [],
                callouts: [
                    SeasonalCareCallout(
                        id: "roots",
                        title: "Bonsai World principle",
                        body: "Roots in containers experience the environment differently."
                    )
                ]
            )
        ]
    )

    // MARK: - 08 Weather Events

    private static let weatherEvents = SeasonalCareLesson(
        id: "weather-events",
        number: 8,
        title: "Weather Events",
        summary: "The goal is reasonable preparation, not constant anxiety.",
        sections: [
            SeasonalCareSection(
                id: "wind",
                heading: "Wind can affect bonsai year-round",
                paragraphs: [
                    "Strong wind may increase water loss, damage branches, move or topple trees and increase winter stress. Collection placement should consider wind exposure. Garden → Locations records where trees stand."
                ],
                bullets: [],
                callouts: []
            ),
            SeasonalCareSection(
                id: "rain",
                heading: "Watering from the sky",
                paragraphs: [
                    "Heavy or prolonged rain may affect soil moisture, root conditions and fertilizer behaviour. Good drainage is important. Do not assume rain automatically creates a problem.",
                    "Soil & Substrate covers drainage and air. Watering covers when rain is not the same as a thorough watering."
                ],
                bullets: [],
                callouts: []
            ),
            SeasonalCareSection(
                id: "events",
                heading: "When conditions change quickly",
                paragraphs: [
                    "Monitor major events such as heatwaves, frost, storms, strong wind and prolonged rain. The goal is not constant anxiety. It is reasonable preparation.",
                    "Bonsai Collection Management covers collection-wide action. Tasks can remind you to inspect. Neither should replace looking at the benches."
                ],
                bullets: [],
                callouts: [
                    SeasonalCareCallout(
                        id: "prepare",
                        title: "Bonsai World principle",
                        body: "Prepare, don’t panic. Good preparation reduces unnecessary emergency decisions."
                    )
                ]
            )
        ]
    )

    // MARK: - 09 Placement & Recovery

    private static let placementAndRecovery = SeasonalCareLesson(
        id: "placement-recovery",
        number: 9,
        title: "Placement & Recovery",
        summary: "Most traditional bonsai species are outdoor trees. Sudden moves can create stress.",
        sections: [
            SeasonalCareSection(
                id: "moving",
                heading: "Position can be part of care",
                paragraphs: [
                    "Some trees may be moved seasonally for light, protection, heat management or winter conditions. Avoid unnecessary movement. Sudden environmental changes may create stress.",
                    "Care → Placement is the practical surface. Garden → Locations holds the place."
                ],
                bullets: [],
                callouts: []
            ),
            SeasonalCareSection(
                id: "indoor-outdoor",
                heading: "Species determines placement",
                paragraphs: [
                    "Most traditional bonsai species are outdoor trees. Indoor environments may not provide the seasonal conditions required by many species. Tropical and subtropical species may have different requirements.",
                    "Placement decisions must begin with species knowledge. Species Library first. Then the bench."
                ],
                bullets: [],
                callouts: []
            ),
            SeasonalCareSection(
                id: "recovery",
                heading: "Protecting recovery trees",
                paragraphs: [
                    "Trees recovering from repotting, heavy pruning, major styling or air layering may require additional consideration. Recovery needs depend on the work performed, the species and the environment.",
                    "Advanced Techniques, Repotting, Pruning and Air Layering cover the work. Tree Health covers monitoring recovery. Do not stack a heatwave, a move and more work on the same week without a reason."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )

    // MARK: - 10 Collection Planning

    private static let collectionPlanning = SeasonalCareLesson(
        id: "collection-planning",
        number: 10,
        title: "Collection Planning",
        summary: "A large collection should not rely only on memory. Plan the season. Then inspect before you act.",
        sections: [
            SeasonalCareSection(
                id: "workload",
                heading: "Understanding busy periods",
                paragraphs: [
                    "Different seasons create different workloads. This helps the artist plan, prioritise and avoid becoming overwhelmed. A large collection should not rely only on memory.",
                    "Tasks groups work as Overdue, Today, This Week and beyond. Use them as inspection prompts."
                ],
                bullets: [],
                callouts: []
            ),
            SeasonalCareSection(
                id: "whole",
                heading: "See the whole collection",
                paragraphs: [
                    "Consider which trees may require attention this season: repotting candidates, development work, recovery, protection and monitoring.",
                    "Bonsai Collection Management covers seasonal systems and whether the collection can absorb the work. Dashboard shows collection counts. Care → Seasonal Care is the current-season surface."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )

    // MARK: - 11 Dates Are Not Nature

    private static let datesAreNotNature = SeasonalCareLesson(
        id: "dates-are-not-nature",
        number: 11,
        title: "Dates Are Not Nature",
        summary: "Calendars can be useful reminders. Weather changes. Trees develop differently.",
        sections: [
            SeasonalCareSection(
                id: "reminders",
                heading: "Dates are not nature",
                paragraphs: [
                    "Calendars can be useful reminders. Weather changes. Seasons vary. Trees develop differently. A task reminder should encourage inspection, not automatic action.",
                    "Do not complete every planned task regardless of tree condition. The tree that is not ready this week may be ready after the weather you actually get."
                ],
                bullets: [],
                callouts: [
                    SeasonalCareCallout(
                        id: "reminders",
                        title: "Bonsai World principle",
                        body: "Calendar dates are reminders. Tree behaviour provides the information."
                    )
                ]
            )
        ]
    )

    // MARK: - 12 Practice

    private static let practice = SeasonalCareLesson(
        id: "practice",
        number: 12,
        title: "Practice",
        summary: "Today’s care may not be tomorrow’s care. Follow the tree.",
        sections: [
            SeasonalCareSection(
                id: "mistakes",
                heading: "Common seasonal care mistakes",
                paragraphs: [
                    "Following calendar dates without observing the tree. Treating all species the same. Ignoring local climate. Moving trees unnecessarily. Stopping all observation during winter.",
                    "Assuming all cold is dangerous. Ignoring heat stress. Watering according to routine rather than conditions. Failing to prepare before extreme weather. Trying to complete every planned task regardless of tree condition."
                ],
                bullets: [],
                callouts: []
            ),
            SeasonalCareSection(
                id: "framework",
                heading: "The seasonal decision framework",
                paragraphs: [
                    "Before performing seasonal work, ask these questions. If you cannot answer them, wait."
                ],
                bullets: [
                    "What season is the tree experiencing?",
                    "What is the species doing now?",
                    "What are the local conditions?",
                    "Is the tree healthy?",
                    "Is this the correct time for this work?",
                    "What weather is expected next?",
                    "Does the tree need intervention, or does it simply need to be observed?"
                ],
                callouts: []
            ),
            SeasonalCareSection(
                id: "paths",
                heading: "Beginner, intermediate and advanced",
                paragraphs: [
                    "Beginner — the basic annual rhythm, seasonal observation and protection fundamentals. Learn what dormancy looks like before treating it as a problem.",
                    "Intermediate — species differences, seasonal planning and environmental adjustment. Care → Seasonal Care, Winter Care and Placement become daily tools.",
                    "Advanced — local climate knowledge, collection-wide planning and species-specific seasonal strategies. Species Library and Bonsai Collection Management carry the scale."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )

    // MARK: - 13 Quick Guides

    private static let quickGuides = SeasonalCareLesson(
        id: "quick-guides",
        number: 13,
        title: "Quick Guides",
        summary: "The best bonsai calendar is knowledge, observation, planning and attention — not a list of fixed dates.",
        sections: [
            SeasonalCareSection(
                id: "cards",
                heading: "Quick knowledge cards",
                paragraphs: [],
                bullets: [],
                callouts: [
                    SeasonalCareCallout(
                        id: "card-follow",
                        title: "Follow the tree",
                        body: "Calendar dates are reminders. Tree behaviour provides the information."
                    ),
                    SeasonalCareCallout(
                        id: "card-weather",
                        title: "Weather changes everything",
                        body: "Today’s care may not be tomorrow’s care."
                    ),
                    SeasonalCareCallout(
                        id: "card-roots",
                        title: "Protect the roots",
                        body: "Roots in containers experience the environment differently."
                    ),
                    SeasonalCareCallout(
                        id: "card-dormancy",
                        title: "Dormancy is not failure",
                        body: "Rest is part of the annual cycle."
                    ),
                    SeasonalCareCallout(
                        id: "card-prepare",
                        title: "Prepare, don’t panic",
                        body: "Good preparation reduces unnecessary emergency decisions."
                    )
                ]
            ),
            SeasonalCareSection(
                id: "connections",
                heading: "Connections to other Bonsai World knowledge",
                paragraphs: [
                    "Watering — changing seasonal demand, heat and winter watering. Care → Watering is the practical surface.",
                    "Fertilizing — seasonal feeding. Use Fertilizer Guides for practical recommendations. Care → Fertilizing is the programme surface.",
                    "Repotting — seasonal timing for the individual tree. Care → Repotting is the seasonal surface.",
                    "Pruning — species and seasonal work, not a date. Leaf reduction, defoliation and pine growth management still start with the tree, not the calendar.",
                    "Wiring — inspection as growth changes through the year.",
                    "Tree Health — weather stress and seasonal monitoring. Care → Health is the practical surface.",
                    "Bonsai Collection Management — seasonal workload and collection planning.",
                    "Species Library — species-specific timing and protection.",
                    "Care → Seasonal Care and Care → Winter Care — the programme surfaces for this chapter.",
                    "Care → Placement — moving trees for light, heat or protection.",
                    "Garden → Locations — where the tree actually stands.",
                    "Tasks — reminders to inspect, not automatic work.",
                    "Soil & Substrate — drainage in rain and winter moisture.",
                    "Advanced Techniques — recovery trees need extra consideration.",
                    "Air Layering and Propagation — young and newly separated material in changing weather."
                ],
                bullets: [],
                callouts: []
            ),
            SeasonalCareSection(
                id: "closing",
                heading: "Final Bonsai World principle",
                paragraphs: [
                    "A bonsai does not live according to a calendar. It responds to light, temperature, water, season and its own biology.",
                    "The purpose of seasonal care is not to create a perfect schedule. It is to help the artist understand what the tree needs now.",
                    "The best bonsai calendar is not a list of fixed dates. It is a combination of knowledge, observation, planning and attention."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )
}
