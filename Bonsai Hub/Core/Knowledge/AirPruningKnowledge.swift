//
//  AirPruningKnowledge.swift
//  Bonsai World
//
//  Knowledge → Bonsai Handbook → Air Pruning & Air Pots.
//  Technique chapter on root architecture in containers — not a product brochure.
//

import Foundation

struct AirPruningKnowledgeCallout: Identifiable, Hashable, Sendable {
    var id: String
    var title: String
    var body: String
}

struct AirPruningKnowledgeSection: Identifiable, Hashable, Sendable {
    var id: String
    var heading: String
    var paragraphs: [String]
    var bullets: [String]
    var callouts: [AirPruningKnowledgeCallout]
}

struct AirPruningKnowledgeLesson: Identifiable, Hashable, Sendable {
    var id: String
    var number: Int
    var title: String
    var summary: String
    var sections: [AirPruningKnowledgeSection]
}

enum AirPruningKnowledge {
    static let chapterTitle = "Air Pruning & Air Pots"

    static let openingLine =
        "Air pruning is a tool for influencing root architecture — not a substitute for good bonsai cultivation."

    static let disclaimer =
        "Species, climate, substrate and watering change outcomes. Distinguish horticultural physiology, bonsai practice, manufacturer claims and personal experience. Cross-check Soil & Substrate, Watering and Repotting."

    static let lessons: [AirPruningKnowledgeLesson] = [
        overview,
        rootPhysiology,
        construction,
        bonsaiBenefits,
        limitations,
        nebari,
        developmentStages,
        comparison,
        tiePot,
        speciesDifferences,
        substrateWatering,
        practicalUse,
        commonMistakes,
        myths,
        conclusion
    ]

    static func lesson(id: String) -> AirPruningKnowledgeLesson? {
        lessons.first { $0.id == id }
    }

    // MARK: - 01 Overview

    private static let overview = AirPruningKnowledgeLesson(
        id: "overview",
        number: 1,
        title: "Overview",
        summary: "What air pruning is, what an air pot is, and why the technique matters for bonsai root development.",
        sections: [
            AirPruningKnowledgeSection(
                id: "what-air-pruning",
                heading: "What is air pruning?",
                paragraphs: [
                    "Air pruning is a cultivation principle: when a growing root tip reaches an opening exposed to moving air and lower moisture, the tip often desiccates or stops elongating. Lateral roots behind that tip may then be stimulated, producing a more branched root system instead of a few long, circling roots.",
                    "The idea comes from container horticulture more broadly. In bonsai it is used to shape root architecture during development — especially where fine roots, reduced circling and better use of pot volume matter.",
                    "Related search terms include air pruning, air pot, Air-Pot, air-pruned roots, root architecture, root branching, nebari, root development, luftbeskjæring and luftbeskjærende potter."
                ],
                bullets: [],
                callouts: [
                    AirPruningKnowledgeCallout(
                        id: "principle",
                        title: "Bonsai World principle",
                        body: "Air pruning is a tool for influencing root architecture — not a substitute for good bonsai cultivation."
                    )
                ]
            ),
            AirPruningKnowledgeSection(
                id: "what-air-pot",
                heading: "What is an air pot?",
                paragraphs: [
                    "An air pot is any container designed so that roots regularly meet openings, textured walls or porous surfaces that encourage tip stoppage and branching. The name is used generically; it does not refer to a single patented product.",
                    "Commercial designs differ: conical wall cones with holes, mesh baskets, fabric bags, slotted cylinders and bonsai-specific systems. What they share is intentional air and drainage at the root–wall interface — not a sealed plastic wall."
                ],
                bullets: [],
                callouts: []
            ),
            AirPruningKnowledgeSection(
                id: "why-bonsai",
                heading: "Why it is relevant for bonsai",
                paragraphs: [
                    "Bonsai depends on a manageable, well-distributed root mass that supports health in a shallow container and, over years, a convincing nebari. Circling and downward-dominant roots waste space and complicate later work.",
                    "Air pruning is relevant because it can reduce the worst circling patterns during growth phases, increase fine-root density in the available volume, and sometimes ease the transition into a bonsai pot — when combined with substrate, watering and active root selection."
                ],
                bullets: [],
                callouts: []
            ),
            AirPruningKnowledgeSection(
                id: "vs-traditional",
                heading: "Difference from traditional plant pots",
                paragraphs: [
                    "A smooth-walled plastic nursery pot guides roots along the wall. Tips often continue around the circumference or down to the base, forming circling or matted layers.",
                    "An air-oriented container interrupts that path more often. Roots still need water, oxygen, nutrition and space — the pot only changes how tips behave at the boundary."
                ],
                bullets: [
                    "Traditional pot: continuous wall → more circling risk",
                    "Air-oriented pot: openings / texture → more tip stoppage and branching potential",
                    "Neither design replaces watering skill or root work at repotting"
                ],
                callouts: []
            )
        ]
    )

    // MARK: - 02 What happens to the roots?

    private static let rootPhysiology = AirPruningKnowledgeLesson(
        id: "root-physiology",
        number: 2,
        title: "What Happens to the Roots?",
        summary: "Simplified mechanism versus plant physiology: tip stoppage, lateral branching and fine-root systems.",
        sections: [
            AirPruningKnowledgeSection(
                id: "normal-pot",
                heading: "Roots in a conventional pot",
                paragraphs: [
                    "Roots elongate from tips that explore moist, oxygenated substrate. In a closed pot they often reach the wall and deflect along it, following moisture and gravity. Over time this can produce long continuous roots circling the container.",
                    "Circling roots occupy the outer ring of the root ball. Interior substrate may be under-used. At repotting, those long roots must often be shortened heavily."
                ],
                bullets: [],
                callouts: []
            ),
            AirPruningKnowledgeSection(
                id: "tip-at-edge",
                heading: "When a tip reaches an open edge",
                paragraphs: [
                    "At an opening, the tip may leave the moist substrate and enter drier air. Without continuous moisture around the tip, elongation commonly stops. The tip may desiccate.",
                    "This is a practical description used in nursery practice. The detailed physiology involves water potential, tip meristem activity and hormonal signalling that can favour branching behind a stopped tip. Outcomes vary with species, humidity, substrate and how open the wall is."
                ],
                bullets: [],
                callouts: [
                    AirPruningKnowledgeCallout(
                        id: "evidence-level",
                        title: "Evidence level",
                        body: "Container air pruning is well established as a horticultural practice. Exact hormonal pathways and species responses are not fully mapped for every bonsai taxon. Treat mechanism explanations as reasoned models, not universal laws."
                    )
                ]
            ),
            AirPruningKnowledgeSection(
                id: "lateral-branching",
                heading: "Lateral roots and branching",
                paragraphs: [
                    "When a primary tip stops, buds or laterals further back may become more active. Repeated tip stoppage around the pot wall can produce a denser network of shorter roots within the same volume.",
                    "A long continuous root explores far but branches sparsely. A finely branched system fills space with many absorbing surfaces — often preferable in bonsai containers, provided the tree stays hydrated and healthy."
                ],
                bullets: [
                    "Long continuous root: fewer tips, more circling risk, harder to redistribute",
                    "Finely branched system: more tips, better volume use, still needs selection for nebari"
                ],
                callouts: []
            ),
            AirPruningKnowledgeSection(
                id: "simplified-vs-real",
                heading: "Simplified story versus physiology",
                paragraphs: [
                    "Simplified story: root hits air → tip dies → laterals form → better roots.",
                    "More accurate: tips respond to moisture, oxygen, mechanical contact and species habit. Air openings increase the chance of tip stoppage. Branching is probable, not guaranteed. Drought at the wall can also kill fine roots wholesale if watering is neglected."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )

    // MARK: - 03 Construction

    private static let construction = AirPruningKnowledgeLesson(
        id: "construction",
        number: 3,
        title: "How Air Pots Are Built",
        summary: "Openings, air access, drainage, proportions — and why products differ.",
        sections: [
            AirPruningKnowledgeSection(
                id: "openings",
                heading: "Side openings and air access",
                paragraphs: [
                    "Most air-oriented designs place openings or porous surfaces on the vertical wall so elongating roots meet air. Some also open strongly at the base.",
                    "Air movement around the pot matters. A container jammed against a solid surface with no airflow behaves less like an air-pruning system."
                ],
                bullets: [],
                callouts: []
            ),
            AirPruningKnowledgeSection(
                id: "drainage",
                heading: "Drainage",
                paragraphs: [
                    "Open walls usually drain freely. Water exits quickly through holes and seams. That reduces waterlogging risk but raises drying risk — especially in wind and sun.",
                    "Drainage and air pruning are related but not identical. A colander drains; whether it air-prunes well depends on wall geometry and how roots meet openings."
                ],
                bullets: [],
                callouts: []
            ),
            AirPruningKnowledgeSection(
                id: "proportions",
                heading: "Depth and diameter",
                paragraphs: [
                    "Depth and diameter change root direction. Deep pots favour downward exploration before tips meet walls. Shallower, wider pots favour lateral exploration — often closer to bonsai nebari goals during development.",
                    "Oversized volume delays contact with the wall, so air pruning happens later. Undersized volume dries faster and may stall top growth."
                ],
                bullets: [],
                callouts: []
            ),
            AirPruningKnowledgeSection(
                id: "not-one-product",
                heading: "Not one product type",
                paragraphs: [
                    "\"Air pot\" is a category label. Conical perforated walls, mesh pots, fabric pots and bonsai-specific designs (including TIE POT) apply the same broad idea with different geometry, materials and handling.",
                    "Judge each design by openings, airflow, drainage, stability, substrate retention and how easily you can inspect and work roots — not by branding alone."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )

    // MARK: - 04 Benefits for bonsai

    private static let bonsaiBenefits = AirPruningKnowledgeLesson(
        id: "bonsai-benefits",
        number: 4,
        title: "Benefits for Bonsai",
        summary: "Plausible advantages — and what still depends on species, substrate and method.",
        sections: [
            AirPruningKnowledgeSection(
                id: "plausible",
                heading: "Plausible advantages",
                paragraphs: [
                    "When conditions are suitable, growers commonly observe more fine roots, fewer long circling roots, denser branching within the pot volume and a root ball that is easier to reduce into a bonsai pot.",
                    "These outcomes are consistent with the tip-stoppage model and with nursery use of air containers. They are not automatic for every tree."
                ],
                bullets: [
                    "More fine absorbing roots (often)",
                    "Reduced continuous circling (often)",
                    "Better use of available root volume (often)",
                    "Possibly milder root work at later repotting (situation-dependent)",
                    "Possibly a better starting field for nebari selection (not a guarantee)"
                ],
                callouts: []
            ),
            AirPruningKnowledgeSection(
                id: "depends",
                heading: "What the advantages depend on",
                paragraphs: [
                    "Species root habit, pot size relative to the tree, substrate particle size, watering precision, nutrition, season and how long the tree stays in the container all change results.",
                    "A stressed, droughted or waterlogged tree will not develop a \"better\" root system simply because the pot has holes."
                ],
                bullets: [],
                callouts: [
                    AirPruningKnowledgeCallout(
                        id: "do-not-overclaim",
                        title: "Do not overclaim",
                        body: "Air pruning can improve the odds of a branched root system. It does not guarantee nebari quality, faster growth or less work forever."
                    )
                ]
            )
        ]
    )

    // MARK: - 05 Limitations

    private static let limitations = AirPruningKnowledgeLesson(
        id: "limitations",
        number: 5,
        title: "Limitations and Drawbacks",
        summary: "Drying risk, watering demand, and what air pruning does not replace.",
        sections: [
            AirPruningKnowledgeSection(
                id: "drying",
                heading: "Increased drying risk",
                paragraphs: [
                    "Open walls lose moisture faster. Outer roots can dry while the core still feels damp if you water unevenly. Wind, sun and coarse substrate amplify this.",
                    "Precise watering is part of the method — not an optional extra."
                ],
                bullets: [],
                callouts: []
            ),
            AirPruningKnowledgeSection(
                id: "does-not-replace",
                heading: "What it does not replace",
                paragraphs: [
                    "Air pruning does not replace active root pruning and selection at repotting. It does not automatically create radial nebari. It does not fix poor substrate or irregular watering.",
                    "Larger pot volume is not automatically better. Delayed wall contact can postpone air pruning while increasing watering load."
                ],
                bullets: [
                    "Species response varies",
                    "Bad substrate reduces benefits",
                    "Wrong watering cancels benefits",
                    "Nebari still needs grower decisions"
                ],
                callouts: []
            )
        ]
    )

    // MARK: - 06 Nebari

    private static let nebari = AirPruningKnowledgeLesson(
        id: "nebari",
        number: 6,
        title: "Air Pruning and Nebari",
        summary: "Why branched roots help — and why the grower still steers direction and selection.",
        sections: [
            AirPruningKnowledgeSection(
                id: "good-nebari",
                heading: "What a good nebari needs",
                paragraphs: [
                    "A convincing nebari usually needs strong surface roots radiating outward, reasonable spacing, no dominant one-sided mass, and a trunk base that sits convincingly on the soil line.",
                    "That structure is built by growth, selection, pruning, planting angle, ground or flat development methods, and time — not by pot branding."
                ],
                bullets: [],
                callouts: []
            ),
            AirPruningKnowledgeSection(
                id: "how-helps",
                heading: "How air pruning can help",
                paragraphs: [
                    "A denser, less circling root field gives more candidates to keep when you select laterals. Horizontal exploration in a suitably proportioned pot can favour surface-oriented roots.",
                    "Helpful raw material is not finished nebari. Direction, planting height and deliberate removal of downward or crossing roots remain grower work."
                ],
                bullets: [],
                callouts: [
                    AirPruningKnowledgeCallout(
                        id: "alone",
                        title: "Air pruning alone",
                        body: "Air pruning alone cannot guarantee a good nebari. It can improve the field of roots you then manage."
                    )
                ]
            )
        ]
    )

    // MARK: - 07 Development stages

    private static let developmentStages = AirPruningKnowledgeLesson(
        id: "development-stages",
        number: 7,
        title: "Use Through Bonsai Development",
        summary: "When air pruning is especially useful — and when another method may be better.",
        sections: [
            AirPruningKnowledgeSection(
                id: "stages",
                heading: "By material stage",
                paragraphs: [
                    "Match the container to the job of that stage. Air pruning is most interesting when you want branched roots in a limited volume without years of circling."
                ],
                bullets: [
                    "Seedlings: useful for early branching; avoid chronic drought in small open pots",
                    "Cuttings: useful once roots are established; protect young tips from rapid drying",
                    "Young trees: strong candidate for development boxes with air openings",
                    "Trunk building: use when fine-root health must keep pace with strong top growth; ground or large solid boxes may still win for maximum trunk speed",
                    "Larger raw material: useful to reorganise a coarse nursery root ball before bonsai pots",
                    "Preparation for bonsai pot: useful as a transitional container if watering is reliable"
                ],
                callouts: []
            ),
            AirPruningKnowledgeSection(
                id: "when-other",
                heading: "When another method may be better",
                paragraphs: [
                    "In-ground or solid large boxes can produce faster trunk thickening with less drying risk. Finished display trees usually belong in bonsai pots, not development air containers.",
                    "If you cannot water open pots reliably, choose a more forgiving container and accept more root correction later."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )

    // MARK: - 08 Comparison

    private static let comparison = AirPruningKnowledgeLesson(
        id: "comparison",
        number: 8,
        title: "Air Pot vs Other Systems",
        summary: "Traditional pots, baskets, mesh, fabric, air pots, TIE POT and in-ground — no universal winner.",
        sections: [
            AirPruningKnowledgeSection(
                id: "table-intro",
                heading: "How to compare",
                paragraphs: [
                    "Compare systems by air access, branching tendency, circling risk, watering demand and bonsai suitability. Choose for the stage and your watering reliability — not for a single \"best\" brand."
                ],
                bullets: [],
                callouts: []
            ),
            AirPruningKnowledgeSection(
                id: "traditional",
                heading: "Traditional plastic pot",
                paragraphs: [
                    "Low wall air access. Circling risk high over time. Watering relatively forgiving. Cheap and common for nursery stock. Suitable for short holding; plan root correction at repotting."
                ],
                bullets: [
                    "Advantage: moisture buffer, availability",
                    "Drawback: circling and outer root mats"
                ],
                callouts: []
            ),
            AirPruningKnowledgeSection(
                id: "pond-basket",
                heading: "Pond basket",
                paragraphs: [
                    "High air and drainage through a mesh grid. Strong air-pruning potential. High drying risk. Substrate can wash out if particles are too fine. Popular for development when watering is frequent."
                ],
                bullets: [
                    "Advantage: aggressive tip stoppage, light weight",
                    "Drawback: rapid drying, particle loss"
                ],
                callouts: []
            ),
            AirPruningKnowledgeSection(
                id: "mesh-pot",
                heading: "Mesh pot",
                paragraphs: [
                    "Similar to pond baskets: high air, high drainage, high watering demand. Useful for fine-root development; less suitable as a neglect-tolerant container."
                ],
                bullets: [],
                callouts: []
            ),
            AirPruningKnowledgeSection(
                id: "fabric",
                heading: "Fabric pot / grow bag",
                paragraphs: [
                    "Fabric walls air-prune by drying tips in the cloth. Good branching potential. Fabric can retain salts and degrade. Handles and stability vary. Watering demand is usually higher than solid plastic."
                ],
                bullets: [],
                callouts: []
            ),
            AirPruningKnowledgeSection(
                id: "air-pot-generic",
                heading: "Air-Pot style perforated walls",
                paragraphs: [
                    "Conical or dimpled walls with holes aim roots into openings. Established in nursery production. Watering demand higher than solid pots. Geometry and size must match the tree."
                ],
                bullets: [],
                callouts: []
            ),
            AirPruningKnowledgeSection(
                id: "tie-pot-brief",
                heading: "TIE POT",
                paragraphs: [
                    "A bonsai-oriented example of air pruning with practical securing of the tree. See the dedicated lesson. It is one implementation — not the definition of air pruning."
                ],
                bullets: [],
                callouts: []
            ),
            AirPruningKnowledgeSection(
                id: "in-ground",
                heading: "In-ground growing",
                paragraphs: [
                    "Maximum growth potential and moisture buffer for many species. Roots explore freely; circling is not the main issue, but later excavation and root reduction can be severe. Excellent for trunk building; different problem set from containers."
                ],
                bullets: [
                    "Advantage: vigour, buffer",
                    "Drawback: later root reorganisation, less daily control"
                ],
                callouts: [
                    AirPruningKnowledgeCallout(
                        id: "no-winner",
                        title: "No universal winner",
                        body: "Use in-ground or solid boxes for maximum thickening when that is the goal. Use air-oriented containers when branched container roots are the goal and watering is under control."
                    )
                ]
            )
        ]
    )

    // MARK: - 09 TIE POT

    private static let tiePot = AirPruningKnowledgeLesson(
        id: "tie-pot",
        number: 9,
        title: "TIE POT and Jens Lindworsky",
        summary: "A bonsai-specific example of air pruning — separated into documented practice, manufacturer claims and grower experience.",
        sections: [
            AirPruningKnowledgeSection(
                id: "who",
                heading: "Context",
                paragraphs: [
                    "Jens Lindworsky is known in European bonsai circles in connection with practical development methods and the TIE POT system — a container approach intended to apply air-pruning ideas specifically to bonsai growing.",
                    "This lesson treats TIE POT as a relevant example. It does not make TIE POT synonymous with air pruning, and it does not replace independent evaluation of any product."
                ],
                bullets: [],
                callouts: []
            ),
            AirPruningKnowledgeSection(
                id: "principle-tie",
                heading: "Basic principle of TIE POT",
                paragraphs: [
                    "Like other air-oriented containers, TIE POT designs aim to expose elongating roots to openings so tips stop and branching increases, while supporting everyday bonsai handling.",
                    "A distinctive practical emphasis associated with the system is securing the tree firmly in the container during development, so watering and wind do not loosen a lightly rooted specimen."
                ],
                bullets: [],
                callouts: []
            ),
            AirPruningKnowledgeSection(
                id: "evidence-split",
                heading: "Documented, claimed and experiential",
                paragraphs: [
                    "Documented horticulture: air pruning as a container principle is established in nursery practice generally.",
                    "Manufacturer / system presentation: specific geometry, anchoring methods and performance claims for TIE POT should be read as product-associated information unless independently verified.",
                    "Practical experience: many bonsai growers report denser fine roots and manageable development in open or perforated containers when watering is precise. Individual results with any named product vary by species and climate."
                ],
                bullets: [],
                callouts: [
                    AirPruningKnowledgeCallout(
                        id: "not-synonym",
                        title: "Not a synonym",
                        body: "TIE POT is one bonsai-oriented application of air pruning. Pond baskets, mesh pots, fabric pots and other perforated containers apply related principles."
                    )
                ]
            ),
            AirPruningKnowledgeSection(
                id: "relevance",
                heading: "Relevance during development",
                paragraphs: [
                    "Systems that combine air access with secure anchoring can be useful while building roots and structure outdoors, especially where wind and frequent watering would otherwise destabilise the tree.",
                    "Evaluate fit for your watering routine, pot sizes and species — the same criteria you use for any development container."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )

    // MARK: - 10 Species

    private static let speciesDifferences = AirPruningKnowledgeLesson(
        id: "species-differences",
        number: 10,
        title: "Species Differences",
        summary: "Root habit varies — discuss Acer, Ulmus, Fagus, Carpinus, Quercus, Pinus and Juniperus without invented studies.",
        sections: [
            AirPruningKnowledgeSection(
                id: "general",
                heading: "Response varies",
                paragraphs: [
                    "Species differ in how aggressively roots circle, how fine their laterals are, and how they tolerate rapid drying at an open wall. The notes below are practice-oriented tendencies, not controlled trial results for each genus."
                ],
                bullets: [],
                callouts: [
                    AirPruningKnowledgeCallout(
                        id: "no-fake-studies",
                        title: "No fabricated research",
                        body: "Do not treat these notes as published species trials. Confirm behaviour on your own trees and climate."
                    )
                ]
            ),
            AirPruningKnowledgeSection(
                id: "acer",
                heading: "Acer",
                paragraphs: [
                    "Maples often produce fine, active roots and respond well to container development when moisture is steady. Air pruning can be interesting for ramified root fields. Precaution: open pots dry fast — maples dislike sudden drought."
                ],
                bullets: ["Potential benefit: high", "Watch: watering precision"],
                callouts: []
            ),
            AirPruningKnowledgeSection(
                id: "ulmus",
                heading: "Ulmus",
                paragraphs: [
                    "Elms are generally vigorous rooters. Air pruning can help manage circling during strong growth. Precaution: vigorous species still need selection; density alone is not nebari."
                ],
                bullets: ["Potential benefit: high", "Watch: still select roots"],
                callouts: []
            ),
            AirPruningKnowledgeSection(
                id: "fagus",
                heading: "Fagus",
                paragraphs: [
                    "Beech can be sensitive to root disturbance and uneven moisture. Air pruning may help branching but drying edges are a risk. Precaution: prefer stable moisture; avoid chronic outer-ball drought."
                ],
                bullets: ["Potential benefit: moderate", "Watch: moisture stability"],
                callouts: []
            ),
            AirPruningKnowledgeSection(
                id: "carpinus",
                heading: "Carpinus",
                paragraphs: [
                    "Hornbeam usually develops fibrous roots suitable for container work. Air-oriented pots are often a good fit during development when watering is reliable."
                ],
                bullets: ["Potential benefit: high", "Watch: wind drying"],
                callouts: []
            ),
            AirPruningKnowledgeSection(
                id: "quercus",
                heading: "Quercus",
                paragraphs: [
                    "Oaks often favour strong downward and coarse roots early on. Air pruning may encourage more laterals in containers, but expectations should stay modest. Precaution: do not expect maple-like fine mats quickly."
                ],
                bullets: ["Potential benefit: moderate / situational", "Watch: coarse habit, patience"],
                callouts: []
            ),
            AirPruningKnowledgeSection(
                id: "pinus",
                heading: "Pinus",
                paragraphs: [
                    "Pines have distinct mycorrhizal and watering needs. Some growers use open containers successfully; others prefer more buffered pots. Precaution: avoid both waterlogging and extreme edge drought; species and local practice matter."
                ],
                bullets: ["Potential benefit: situational", "Watch: mycorrhiza, watering rhythm"],
                callouts: []
            ),
            AirPruningKnowledgeSection(
                id: "juniperus",
                heading: "Juniperus",
                paragraphs: [
                    "Junipers often tolerate development boxes well. Air pruning can support fibrous roots, but many juniper programmes also rely on ground growing for trunk. Precaution: open pots in hot wind need close watch."
                ],
                bullets: ["Potential benefit: moderate to high in containers", "Watch: stage goals vs drying"],
                callouts: []
            )
        ]
    )

    // MARK: - 11 Substrate and watering

    private static let substrateWatering = AirPruningKnowledgeLesson(
        id: "substrate-watering",
        number: 11,
        title: "Substrate and Watering",
        summary: "How air pots interact with particle size, drainage, moisture, fertiliser and root activity.",
        sections: [
            AirPruningKnowledgeSection(
                id: "interaction",
                heading: "The interaction",
                paragraphs: [
                    "Open containers amplify substrate behaviour. Coarse mixes drain and dry faster. Fine mixes may hold water but can wash through large openings or stay wet in the core while edges dry.",
                    "Particle size, drainage, moisture retention, watering frequency, fertiliser delivery and root activity must be tuned together. See Soil & Substrate and Watering in this Handbook."
                ],
                bullets: [],
                callouts: []
            ),
            AirPruningKnowledgeSection(
                id: "why-more-attention",
                heading: "Why watering needs more attention",
                paragraphs: [
                    "More evaporative surface and faster drainage shrink the margin for error. Check moisture rather than following a fixed timetable. In heat, open pots may need more frequent watering than solid plastic of the same volume.",
                    "Fertiliser salts can concentrate as water evaporates from open walls — leach periodically according to your fertiliser framework."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )

    // MARK: - 12 Practical use

    private static let practicalUse = AirPruningKnowledgeLesson(
        id: "practical-use",
        number: 12,
        title: "Practical Use",
        summary: "Before planting, during growth and at repotting — a working checklist.",
        sections: [
            AirPruningKnowledgeSection(
                id: "before",
                heading: "Before planting",
                paragraphs: [
                    "Choose pot size for the near-term job: large enough for planned growth, small enough that roots meet walls within a useful period. Match substrate to openings so particles do not wash out excessively.",
                    "Anchor the tree firmly. Open pots catch wind; loose trees tear fine roots."
                ],
                bullets: [
                    "Size for stage, not prestige",
                    "Substrate that stays in the pot under watering",
                    "Secure tying or equivalent anchoring"
                ],
                callouts: []
            ),
            AirPruningKnowledgeSection(
                id: "during",
                heading: "During cultivation",
                paragraphs: [
                    "Water by need. Fertilize according to development stage. Inspect for edge drying and for roots emerging from openings. Emerging tips are a sign the system is working — not a crisis — but chronic white dry mats at the rim mean watering is behind."
                ],
                bullets: [],
                callouts: []
            ),
            AirPruningKnowledgeSection(
                id: "repotting",
                heading: "At repotting",
                paragraphs: [
                    "Examine the root ball for branching density, circling remnants, downward dominance and one-sided mass. Keep well-placed laterals; shorten or remove poorly placed roots according to Repotting guidance.",
                    "Correct bad structure deliberately. Avoid extreme root reduction on weakened trees or at the wrong season simply because the pot type is \"advanced\"."
                ],
                bullets: [
                    "Look for fine branching vs long runners",
                    "Select for radial surface roots when nebari is the goal",
                    "Do not confuse dense roots with finished nebari"
                ],
                callouts: []
            )
        ]
    )

    // MARK: - 13 Common mistakes

    private static let commonMistakes = AirPruningKnowledgeLesson(
        id: "common-mistakes",
        number: 13,
        title: "Common Mistakes",
        summary: "Sizing, substrate, watering, anchoring and false trust in the pot.",
        sections: [
            AirPruningKnowledgeSection(
                id: "list",
                heading: "Frequent errors",
                paragraphs: [
                    "Most failures come from treating the pot as a complete method rather than one part of cultivation."
                ],
                bullets: [
                    "Pot too small → chronic drought and stalled growth",
                    "Pot too large → delayed wall contact, heavy watering load",
                    "Substrate too coarse → extreme drying",
                    "Substrate too fine → wash-out or uneven wet core / dry edge",
                    "Watering too rarely → dead outer roots",
                    "Overwatering without oxygen thinking → still possible in poor mixes",
                    "No anchoring → wind rock and root tear",
                    "Believing air pruning alone builds nebari",
                    "No root selection at repotting",
                    "Heavy root cutting at the wrong time or on a weak tree"
                ],
                callouts: []
            )
        ]
    )

    // MARK: - 14 Myths

    private static let myths = AirPruningKnowledgeLesson(
        id: "myths",
        number: 14,
        title: "Myths and Misunderstandings",
        summary: "Common claims corrected with practical reality.",
        sections: [
            AirPruningKnowledgeSection(
                id: "myth-list",
                heading: "Claims versus reality",
                paragraphs: [],
                bullets: [],
                callouts: [
                    AirPruningKnowledgeCallout(
                        id: "m1",
                        title: "\"Air pots make roots perfect automatically.\"",
                        body: "They can improve branching odds. Perfection still depends on species, watering, substrate and selection."
                    ),
                    AirPruningKnowledgeCallout(
                        id: "m2",
                        title: "\"Air pruning means roots need no cutting.\"",
                        body: "False. You still prune and select at repotting."
                    ),
                    AirPruningKnowledgeCallout(
                        id: "m3",
                        title: "\"All species grow better in air pots.\"",
                        body: "False. Some benefit; some suffer from drying; stage goals differ."
                    ),
                    AirPruningKnowledgeCallout(
                        id: "m4",
                        title: "\"More air is always better.\"",
                        body: "False. Excess exposure without watering capacity kills fine roots."
                    ),
                    AirPruningKnowledgeCallout(
                        id: "m5",
                        title: "\"Air pots always mean faster growth.\"",
                        body: "Not reliably. Stress from drying can slow growth. In-ground often wins for trunk speed."
                    ),
                    AirPruningKnowledgeCallout(
                        id: "m6",
                        title: "\"Air pruning alone makes good nebari.\"",
                        body: "False. It may improve the root field you then manage."
                    )
                ]
            )
        ]
    )

    // MARK: - 15 Conclusion and sources

    private static let conclusion = AirPruningKnowledgeLesson(
        id: "conclusion",
        number: 15,
        title: "Practical Conclusion",
        summary: "When air pruning helps, when a normal pot is better, and what actually decides root quality.",
        sections: [
            AirPruningKnowledgeSection(
                id: "when-useful",
                heading: "When air pruning is especially useful",
                paragraphs: [
                    "Use it when you can water reliably and you want branched container roots during development, transition toward a bonsai pot, or reorganisation of a coarse nursery root system."
                ],
                bullets: [],
                callouts: []
            ),
            AirPruningKnowledgeSection(
                id: "when-normal",
                heading: "When a normal pot may be better",
                paragraphs: [
                    "Prefer more buffered containers when watering access is limited, when a species hates edge drought, or when maximum moisture stability matters more than early branching."
                ],
                bullets: [],
                callouts: []
            ),
            AirPruningKnowledgeSection(
                id: "priorities",
                heading: "What the grower should prioritise",
                paragraphs: [
                    "Prioritise tree health, honest watering, suitable substrate, timely repotting and active root direction — then choose a container that supports that programme."
                ],
                bullets: [],
                callouts: []
            ),
            AirPruningKnowledgeSection(
                id: "what-decides",
                heading: "What actually decides root quality",
                paragraphs: [
                    "Root quality comes from the combination of species, container, substrate, watering, nutrition, root pruning, active steering of root direction and correct timing of repotting.",
                    "Air pruning is one tool inside that combination."
                ],
                bullets: [],
                callouts: [
                    AirPruningKnowledgeCallout(
                        id: "closing-principle",
                        title: "Bonsai World principle",
                        body: "Air pruning is a tool for influencing root architecture — not a substitute for good bonsai cultivation."
                    )
                ]
            ),
            AirPruningKnowledgeSection(
                id: "sources",
                heading: "Sources and reading stance",
                paragraphs: [
                    "Container air pruning is discussed in nursery and horticultural literature on root architecture in pots (including work associated with perforated and fabric containers in commercial production). University and extension publications on container root circling and air root pruning provide general horticultural background.",
                    "Bonsai-specific application draws on established practice in development containers (pond baskets, mesh pots, perforated walls) and on grower experience. Product literature for named systems such as TIE POT should be read as manufacturer-associated information for that design.",
                    "This chapter synthesises those layers into Bonsai World editorial language. It does not reproduce proprietary manuals or claim unpublished trial data. Cross-check Soil & Substrate, Watering, Repotting and Pots & Containers."
                ],
                bullets: [
                    "Horticulture / physiology: container root circling and air root pruning as nursery techniques",
                    "Bonsai practice: development containers and root selection at repotting",
                    "Manufacturer sources: use for product geometry and handling claims; verify in your climate",
                    "Experience: record outcomes on your own trees"
                ],
                callouts: []
            )
        ]
    )
}
