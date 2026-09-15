//
//  AirLayeringKnowledge.swift
//  Bonsai World
//
//  Knowledge → Bonsai Handbook → Air Layering.
//  Original Bonsai World editorial — principles for Nursery Air Layers and Species Profiles.
//

import Foundation

struct AirLayeringKnowledgeCallout: Identifiable, Hashable, Sendable {
    var id: String
    var title: String
    var body: String
}

struct AirLayeringKnowledgeSection: Identifiable, Hashable, Sendable {
    var id: String
    var heading: String
    var paragraphs: [String]
    var bullets: [String]
    var callouts: [AirLayeringKnowledgeCallout]
}

struct AirLayeringKnowledgeLesson: Identifiable, Hashable, Sendable {
    var id: String
    var number: Int
    var title: String
    var summary: String
    var sections: [AirLayeringKnowledgeSection]
}

enum AirLayeringKnowledge {
    static let chapterTitle = "Air Layering"

    static let openingLine =
        "Air layering is not simply propagation. It is a method for deciding where a tree should begin."

    static let disclaimer =
        "Species, climate and tree condition change outcomes. Treat this as decision support — then record what you do in Nursery Air Layers so your own experience becomes Species Knowledge."

    static let lessons: [AirLayeringKnowledgeLesson] = [
        overview,
        planning,
        technique,
        rootingSetup,
        monitoring,
        separation,
        aftercare,
        troubleshooting,
        advancedApplications,
        speciesAndChecklist
    ]

    static func lesson(id: String) -> AirLayeringKnowledgeLesson? {
        lessons.first { $0.id == id }
    }

    // MARK: - 01 Overview

    private static let overview = AirLayeringKnowledgeLesson(
        id: "overview",
        number: 1,
        title: "Overview",
        summary: "What air layering is, why it is powerful in bonsai, and the Bonsai World principle behind it.",
        sections: [
            AirLayeringKnowledgeSection(
                id: "what",
                heading: "What is air layering?",
                paragraphs: [
                    "Air layering encourages a new root system while the branch or trunk section remains attached to the mother plant. Unlike a cutting, the section keeps receiving water and support from the existing tree while roots develop.",
                    "Seeds, seedlings and cuttings are covered in Propagation in this Handbook. This chapter is the dedicated air-layering method.",
                    "When a sufficiently strong root system has formed, the section can be separated and become an independent tree."
                ],
                bullets: [
                    "Create a new bonsai from mature material",
                    "Shorten an overly tall trunk",
                    "Remove an unattractive lower section",
                    "Correct inverse taper",
                    "Create a new root base or improve nebari",
                    "Remove a graft union",
                    "Recover a valuable upper section",
                    "Propagate branches that already have taper and character"
                ],
                callouts: [
                    AirLayeringKnowledgeCallout(
                        id: "principle",
                        title: "Bonsai World principle",
                        body: "Air layering is not simply propagation. It is a method for deciding where a tree should begin."
                    )
                ]
            ),
            AirLayeringKnowledgeSection(
                id: "how",
                heading: "How it works",
                paragraphs: [
                    "Water and minerals move upward through the xylem. Sugars and other products of photosynthesis move downward beneath the bark. Air layering interrupts that downward transport while the upper section stays connected to the existing water supply — so roots can form above the interruption.",
                    "The rooting environment must provide moisture, oxygen, darkness or controlled light, stable temperatures, protection from drying, and minimal disturbance."
                ],
                bullets: [],
                callouts: []
            ),
            AirLayeringKnowledgeSection(
                id: "why-bonsai",
                heading: "Why it is powerful in bonsai",
                paragraphs: [
                    "A cutting often begins as thin material, then needs years of development. An air layer can begin as a mature branch or trunk section with new roots — preserving thickness, taper, movement, bark, branch structure and character.",
                    "The greatest advantage is that you choose where the new root system begins. That makes air layering uniquely useful for correcting trunk and nebari problems."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )

    // MARK: - 02 Planning

    private static let planning = AirLayeringKnowledgeLesson(
        id: "planning",
        number: 2,
        title: "Planning",
        summary: "Choose the future tree first — then the layer point, timing and health checks.",
        sections: [
            AirLayeringKnowledgeSection(
                id: "choose",
                heading: "Choosing the right air layer",
                paragraphs: [
                    "Before making a cut, answer: what will the new tree look like? Do not choose the point only because roots can form there. Choose where the new tree should begin.",
                    "Evaluate trunk movement, taper, branch placement, nebari potential and trunk defects. Air layering is often ideal for removing inverse taper, swelling, graft unions, straight sections, uninteresting lower trunks or poor nebari."
                ],
                bullets: [],
                callouts: []
            ),
            AirLayeringKnowledgeSection(
                id: "position",
                heading: "Choosing the position",
                paragraphs: [
                    "Select the exact position from the future planting angle — not only from looking at the tree upright. Imagine the future front, planting angle, root plane and visual base. Then select where new roots should emerge.",
                    "A technically successful air layer can still produce a poor bonsai if the layer was placed at the wrong point."
                ],
                bullets: [],
                callouts: [
                    AirLayeringKnowledgeCallout(
                        id: "angle",
                        title: "Bonsai World concept",
                        body: "Do not select the air layer position only by looking at the tree upright."
                    )
                ]
            ),
            AirLayeringKnowledgeSection(
                id: "diameter",
                heading: "Trunk diameter and material",
                paragraphs: [
                    "There is no universal minimum or maximum diameter. Thicker material preserves more maturity but may take longer to root and needs a strong radial root system. A thin branch may root easily but offer little advantage over a cutting."
                ],
                bullets: [],
                callouts: []
            ),
            AirLayeringKnowledgeSection(
                id: "timing",
                heading: "Timing",
                paragraphs: [
                    "Timing depends on species, climate, tree health, growth cycle and method. The best question is not simply “spring” — it is when this species can produce roots while maintaining the upper section.",
                    "Species Profiles should eventually record recommended windows and typical rooting duration. Nursery Air Layers feed that experience."
                ],
                bullets: [],
                callouts: []
            ),
            AirLayeringKnowledgeSection(
                id: "health",
                heading: "Tree health before air layering",
                paragraphs: [
                    "Never air layer a tree that is already struggling. Check vigor, foliage, roots, recent repotting or pruning, disease, pests, drought stress and recovery from major work.",
                    "An air layer needs enough energy to support both the existing tree and a new root system. Avoid stacking major stresses immediately before or during the process."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )

    // MARK: - 03 Technique

    private static let technique = AirLayeringKnowledgeLesson(
        id: "technique",
        number: 3,
        title: "Technique",
        summary: "Complete ring, tourniquet, partial ring, wedge/notch — and how to create a reliable interruption.",
        sections: [
            AirLayeringKnowledgeSection(
                id: "complete-ring",
                heading: "Complete Ring (Girdle)",
                paragraphs: [
                    "Bark and the relevant conductive tissue are removed completely around the trunk or branch. This is the default method for many deciduous trees and vigorous material when a clear interruption is required.",
                    "Advantages: clear physiological interruption and a predictable root zone. Risks: incomplete removal may allow bridging; overly aggressive work may stress difficult species."
                ],
                bullets: [],
                callouts: [
                    AirLayeringKnowledgeCallout(
                        id: "default",
                        title: "Default in Bonsai World",
                        body: "Complete Ring is the standard Method on Nursery Air Layer projects."
                    )
                ]
            ),
            AirLayeringKnowledgeSection(
                id: "tourniquet",
                heading: "Tourniquet",
                paragraphs: [
                    "A wire or constricting material is applied tightly so growth progressively restricts downward flow. Useful for some slower or sensitive species when full bark removal feels too aggressive.",
                    "Control is less immediate; rooting may be slower and timing less predictable."
                ],
                bullets: [],
                callouts: []
            ),
            AirLayeringKnowledgeSection(
                id: "partial-wedge",
                heading: "Partial Ring and Wedge / Notch",
                paragraphs: [
                    "Partial ring wounds only part of the circumference — specialised and species-dependent. Use only when there is a specific reason to preserve part of the conductive connection. It is not a beginner default.",
                    "Wedge or notch methods maintain a wound to encourage rooting in selected situations. Treat them as advanced techniques."
                ],
                bullets: [],
                callouts: []
            ),
            AirLayeringKnowledgeSection(
                id: "creating-ring",
                heading: "Creating the ring",
                paragraphs: [
                    "Mark the future root line. Make two cuts around the trunk. Remove the bark between them and any tissue that could reconnect transport. Confirm the ring is complete, then prepare the rooting environment immediately.",
                    "Incomplete removal followed by bridging is one of the most common causes of failure. Ring width is often related to diameter in practice, but treat the right width as species- and material-dependent — record millimetres on the Nursery project."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )

    // MARK: - 04 Rooting setup

    private static let rootingSetup = AirLayeringKnowledgeLesson(
        id: "rooting-setup",
        number: 4,
        title: "Rooting setup",
        summary: "Hormone, medium, wrap system and moisture — Method, Medium and Wrap stay separate.",
        sections: [
            AirLayeringKnowledgeSection(
                id: "hormone",
                heading: "Rooting hormone",
                paragraphs: [
                    "Hormone may encourage root formation, but it is not universally required. It does not compensate for poor timing, poor technique or an unhealthy tree.",
                    "Record none, rooting hormone, product, active ingredient and concentration when known — that becomes species-specific data over time."
                ],
                bullets: [],
                callouts: [
                    AirLayeringKnowledgeCallout(
                        id: "aid",
                        title: "Bonsai World principle",
                        body: "Rooting hormone is an aid, not the foundation of the technique."
                    )
                ]
            ),
            AirLayeringKnowledgeSection(
                id: "medium",
                heading: "Rooting medium",
                paragraphs: [
                    "The medium must balance moisture retention, oxygen, root penetration and stability. Long-fiber sphagnum is the classic choice. Sphagnum mixes and granular media are options for specialised systems. Custom media are for experimental or species-specific setups."
                ],
                bullets: [],
                callouts: []
            ),
            AirLayeringKnowledgeSection(
                id: "moisture",
                heading: "Moisture",
                paragraphs: [
                    "The medium should stay evenly moist — not dry, not saturated, not dripping, not compacted into an airless mass. Too dry slows or kills new roots; too wet reduces oxygen and risks decay. Stability is the goal."
                ],
                bullets: [],
                callouts: []
            ),
            AirLayeringKnowledgeSection(
                id: "wrap",
                heading: "Wrap systems",
                paragraphs: [
                    "The wrap holds medium, retains moisture, protects the rooting zone, controls light and may allow inspection. Plastic film is simple. Plastic plus foil adds light protection. Foil alone or an air-layer pot are other systems.",
                    "Keep Medium and Wrap as separate fields: for example sphagnum inside, plastic + foil outside."
                ],
                bullets: [],
                callouts: []
            ),
            AirLayeringKnowledgeSection(
                id: "nebari-design",
                heading: "Designing the root system",
                paragraphs: [
                    "The goal is not merely to produce roots — it is to produce a future nebari. Aim for radial distribution close to the desired root plane, without roots dominating only one side. Poor distribution means separation should wait or be reconsidered."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )

    // MARK: - 05 Monitoring

    private static let monitoring = AirLayeringKnowledgeLesson(
        id: "monitoring",
        number: 5,
        title: "Monitoring",
        summary: "Root development stages, wrap checks and when not to disturb the layer.",
        sections: [
            AirLayeringKnowledgeSection(
                id: "disturb",
                heading: "Monitoring the air layer",
                paragraphs: [
                    "Do not disturb the air layer unnecessarily. Every inspection carries risk. Check moisture, root development, callus and wrap integrity — damage, water loss, loose seals, animal damage or excessive movement."
                ],
                bullets: [],
                callouts: []
            ),
            AirLayeringKnowledgeSection(
                id: "stages",
                heading: "Root development stages",
                paragraphs: [
                    "Use clear stages instead of asking only whether it has rooted: No Roots; Callus Only; Early Roots; Developing Roots; Root Mass Established; Ready to Separate.",
                    "Callus is progress, but callus alone does not mean the layer is ready. These stages match Nursery Air Layer root development on the project and wrap checks."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )

    // MARK: - 06 Separation

    private static let separation = AirLayeringKnowledgeLesson(
        id: "separation",
        number: 6,
        title: "Separation",
        summary: "When the root system can support the tree — then cut, protect roots and pot with stability.",
        sections: [
            AirLayeringKnowledgeSection(
                id: "ready",
                heading: "When is it ready?",
                paragraphs: [
                    "The most common mistake is separating too early. Visible roots do not automatically mean ready. Ask whether this root system can support everything above it.",
                    "Consider number, distribution, thickness, activity, coverage around the trunk, species, canopy size and time left in the growing season. A dense, active root mass matters more than the first appearance of roots."
                ],
                bullets: [],
                callouts: []
            ),
            AirLayeringKnowledgeSection(
                id: "cut",
                heading: "Separation",
                paragraphs: [
                    "Prepare pot, substrate, securing materials and tools. Decide foliage reduction and recovery placement. Support the layer, cut below the new roots, protect roots from drying, avoid unnecessary handling and transfer immediately."
                ],
                bullets: [],
                callouts: []
            ),
            AirLayeringKnowledgeSection(
                id: "roots",
                heading: "Root handling and potting",
                paragraphs: [
                    "New roots are fragile. Do not automatically comb, wash, strip all moss or force roots into position. Preserve functioning roots first; improve structure later.",
                    "The new tree needs stability, even moisture, drainage and root protection. Secure it — movement damages new roots. The first container is often a practical training pot, not the final bonsai pot."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )

    // MARK: - 07 Aftercare

    private static let aftercare = AirLayeringKnowledgeLesson(
        id: "aftercare",
        number: 7,
        title: "Aftercare",
        summary: "First weeks and first year: survival, recovery and root strength before styling.",
        sections: [
            AirLayeringKnowledgeSection(
                id: "first-weeks",
                heading: "Aftercare priorities",
                paragraphs: [
                    "After separation the tree moves from an established root system to a new, limited one. Priorities are stability, appropriate moisture, protection from wind, heat, drying and frost, and recovery — not heavy styling."
                ],
                bullets: [],
                callouts: []
            ),
            AirLayeringKnowledgeSection(
                id: "first-year",
                heading: "First-year development",
                paragraphs: [
                    "Focus on survival → recovery → root development → strength. Avoid unnecessary heavy pruning, major wiring, root work, frequent repotting or structural redesign until the new root system proves reliable."
                ],
                bullets: [],
                callouts: []
            ),
            AirLayeringKnowledgeSection(
                id: "winter",
                heading: "Winter care",
                paragraphs: [
                    "A newly separated air layer may have a smaller root system and less resilience. Record winter location, protection, watering strategy and temperature exposure — useful later in Species Profiles and on the Nursery Winter Care fields."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )

    // MARK: - 08 Troubleshooting

    private static let troubleshooting = AirLayeringKnowledgeLesson(
        id: "troubleshooting",
        number: 8,
        title: "Troubleshooting",
        summary: "No roots, bridging, uneven roots, drying, rot and a weakening upper section.",
        sections: [
            AirLayeringKnowledgeSection(
                id: "problems",
                heading: "Common problems",
                paragraphs: [
                    "No roots: wrong timing, weak tree, species difficulty, incomplete interruption, poor moisture or excessive disturbance.",
                    "Bridging: insufficient ring width, incomplete removal, or healing tissue reconnecting the interruption.",
                    "Roots on one side only: uneven moisture, temperature or exposure — critical for future nebari.",
                    "Dry moss: poor sealing, heat, wind or weak monitoring. Rot: saturated medium, poor aeration, long-term wetness.",
                    "Weak upper section: premature separation, excessive canopy stress, insufficient roots or environmental stress."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )

    // MARK: - 09 Advanced

    private static let advancedApplications = AirLayeringKnowledgeLesson(
        id: "advanced",
        number: 9,
        title: "Advanced bonsai applications",
        summary: "Design uses of air layering — nebari, trunk reduction, recovering material and multi-year layers.",
        sections: [
            AirLayeringKnowledgeSection(
                id: "design",
                heading: "Air layering as bonsai design",
                paragraphs: [
                    "Remove bad trunk sections above reverse taper, grafts, swelling or straight wood. Create better movement by choosing a new base where direction and taper improve. Improve nebari by placing the layer at the ideal future root line.",
                    "Recover valuable branches with mature bark, movement and ramification. Multi-year layers, large diameters, conifers, radial root strategies and multiple layers on one tree are advanced topics — plan mother-tree energy carefully."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )

    // MARK: - 10 Species + checklist

    private static let speciesAndChecklist = AirLayeringKnowledgeLesson(
        id: "species-checklist",
        number: 10,
        title: "Species knowledge & checklist",
        summary: "How Species Profiles and Nursery records should speak — plus a practical checklist.",
        sections: [
            AirLayeringKnowledgeSection(
                id: "species",
                heading: "Species differences",
                paragraphs: [
                    "Success varies dramatically between species. Avoid saying “air layering works.” Prefer: based on this species and recorded experience, this is how air layering tends to perform.",
                    "Species Profiles should eventually show suitability, timing, method, duration, medium, rooting aid and recorded success rate — fed by Nursery Air Layers in your library."
                ],
                bullets: [],
                callouts: []
            ),
            AirLayeringKnowledgeSection(
                id: "checklist",
                heading: "Bonsai World checklist",
                paragraphs: [
                    "Before starting: healthy tree, species suitability, timing, future front and planting angle, root line, trunk design, tools, medium and wrap ready.",
                    "During setup: method complete, aid applied if used, medium evenly moist, root zone covered, wrap sealed, project documented in Nursery.",
                    "Monitoring: moisture, wrap integrity, root development and notes on wrap checks.",
                    "Separation: evaluate root mass, prepare recovery pot, secure the tree, minimise root disturbance, set recovery conditions.",
                    "Bonsai Material & Sourcing in this Handbook covers whether an air layer is the right starting point for the project."
                ],
                bullets: [],
                callouts: [
                    AirLayeringKnowledgeCallout(
                        id: "philosophy",
                        title: "Bonsai World philosophy",
                        body: "An air layer is a decision about the future of a tree. The cut itself is only the beginning. Success comes from choosing the right tree, the right point, the right season and the right moment to separate. The goal is not simply to make roots — it is to create the best possible beginning for the next tree."
                    )
                ]
            )
        ]
    )
}
