//
//  FertilizingKnowledge.swift
//  Bonsai World
//
//  Knowledge → Bonsai Handbook → Fertilizing.
//  Principles around feeding. Practical recommendations stay in Fertilizer Guides.
//

import Foundation

struct FertilizingKnowledgeCallout: Identifiable, Hashable, Sendable {
    var id: String
    var title: String
    var body: String
}

struct FertilizingKnowledgeSection: Identifiable, Hashable, Sendable {
    var id: String
    var heading: String
    var paragraphs: [String]
    var bullets: [String]
    var callouts: [FertilizingKnowledgeCallout]
}

struct FertilizingKnowledgeLesson: Identifiable, Hashable, Sendable {
    var id: String
    var number: Int
    var title: String
    var summary: String
    var sections: [FertilizingKnowledgeSection]
    var opensFertilizerGuides: Bool

    init(
        id: String,
        number: Int,
        title: String,
        summary: String,
        opensFertilizerGuides: Bool = false,
        sections: [FertilizingKnowledgeSection]
    ) {
        self.id = id
        self.number = number
        self.title = title
        self.summary = summary
        self.opensFertilizerGuides = opensFertilizerGuides
        self.sections = sections
    }
}

enum FertilizingKnowledge {
    static let chapterTitle = "Fertilizing"

    static let openingLine =
        "A complete guide to feeding bonsai trees — understanding nutrients, choosing fertilizer, seasonal feeding and adapting your approach to species, development and tree health."

    static let disclaimer =
        "Species, climate, substrate and tree condition change the answer. Treat this as decision support — then use Fertilizer Guides for the practical recommendations already established in Bonsai World."

    static let lessons: [FertilizingKnowledgeLesson] = [
        overview,
        practicalGuide,
        fertilizerTypes,
        bonsaiStrategy,
        seasonalFeeding,
        treeHealth,
        advanced,
        troubleshooting,
        quickGuides
    ]

    static func lesson(id: String) -> FertilizingKnowledgeLesson? {
        lessons.first { $0.id == id }
    }

    // MARK: - 01 Overview

    private static let overview = FertilizingKnowledgeLesson(
        id: "overview",
        number: 1,
        title: "Overview",
        summary: "What fertilizer is, how NPK and other nutrients work, and why feeding follows the tree — not only the calendar.",
        opensFertilizerGuides: false,
        sections: [
            FertilizingKnowledgeSection(
                id: "introduction",
                heading: "Fertilizing bonsai",
                paragraphs: [
                    "Fertilizing a bonsai is not about making a tree grow as much as possible. It is about supplying the right nutrition at the right time to support the current goal for that tree.",
                    "A bonsai in development may need strong growth. A refined bonsai may need controlled growth. A recovering tree may need time before fertilization. A tree approaching winter may require a different strategy than one beginning active growth.",
                    "The same fertilizer can therefore be used in very different ways depending on the tree, the season and the grower's objective."
                ],
                bullets: [],
                callouts: [
                    FertilizingKnowledgeCallout(
                        id: "calendar-principle",
                        title: "Bonsai World principle",
                        body: "Do not fertilize according to the calendar alone. Fertilize according to the tree's condition, growth cycle and current goal."
                    )
                ]
            ),
            FertilizingKnowledgeSection(
                id: "what-is-fertilizer",
                heading: "What is fertilizer?",
                paragraphs: [
                    "Fertilizer supplies essential nutrients required for growth, metabolism and long-term tree health. It is one part of cultivation — not a substitute for the rest.",
                    "Feeding the tree is not the same as watering it. Water moves nutrients to the roots and keeps the tree alive; fertilizer is the nutrient supply. Improving the substrate changes how water, air and nutrients behave in the pot. Correcting a deficiency is a diagnosis and a targeted response — not automatically a higher dose."
                ],
                bullets: [
                    "Fertilizer cannot compensate for poor light",
                    "Fertilizer cannot compensate for incorrect watering",
                    "Fertilizer cannot compensate for poor drainage",
                    "Fertilizer cannot compensate for damaged roots",
                    "Fertilizer cannot compensate for disease or pest problems",
                    "Fertilizer cannot compensate for incorrect seasonal care"
                ],
                callouts: [
                    FertilizingKnowledgeCallout(
                        id: "cultivation-principle",
                        title: "Key principle",
                        body: "Fertilizer supports healthy growth. It does not replace good cultivation."
                    )
                ]
            ),
            FertilizingKnowledgeSection(
                id: "npk",
                heading: "Understanding NPK",
                paragraphs: [
                    "Nitrogen (N) supports vegetative growth. Phosphorus (P) supports root development and other essential plant processes. Potassium (K) supports overall plant function, resilience and physiological processes.",
                    "NPK ratios are useful descriptions of a product. They should not be treated as a universal bonsai formula. A balanced fertilizer uses equal or similar proportions. A higher-nitrogen fertilizer places more emphasis on vegetative growth. A lower-nitrogen fertilizer can be useful when strong vegetative growth is not the objective.",
                    "Plant nutrition is more complex than treating phosphorus as a root button or potassium as a flower button. All essential nutrients work together."
                ],
                bullets: [],
                callouts: []
            ),
            FertilizingKnowledgeSection(
                id: "beyond-npk",
                heading: "Secondary and micronutrients",
                paragraphs: [
                    "Calcium, magnesium and sulfur matter alongside NPK. Micronutrients such as iron, manganese, zinc, copper, boron and molybdenum are needed in smaller amounts, but a tree can still suffer when they are missing or unavailable.",
                    "A bonsai can experience nutrient problems even when NPK fertilizer is being applied. Incorrect substrate pH, nutrient lockout, root problems, poor watering, excess salt accumulation or missing micronutrients can all produce that picture."
                ],
                bullets: [],
                callouts: [
                    FertilizingKnowledgeCallout(
                        id: "more-not-solution",
                        title: "Bonsai World principle",
                        body: "More fertilizer is not always the solution to a nutrient problem."
                    )
                ]
            )
        ]
    )

    // MARK: - 02 Practical Guide

    private static let practicalGuide = FertilizingKnowledgeLesson(
        id: "practical-guide",
        number: 2,
        title: "Practical Guide",
        summary: "Use the existing Bonsai World Fertilizer Guide for practical feeding recommendations.",
        opensFertilizerGuides: true,
        sections: [
            FertilizingKnowledgeSection(
                id: "existing-guide",
                heading: "Bonsai World Fertilizer Guide",
                paragraphs: [
                    "This Handbook chapter explains the principles. Fertilizer Guides is the practical application layer already in the programme — a working guide that gives concrete recommendations from the approach established in Bonsai World.",
                    "Read here to understand the decision. Open Fertilizer Guides to apply it. Do not treat this chapter as a second schedule or a replacement for those recommendations."
                ],
                bullets: [
                    "Understand the principles in this chapter",
                    "Choose the correct approach for this tree",
                    "Open the existing Bonsai World Fertilizer Guide",
                    "Apply the practical seasonal recommendations there"
                ],
                callouts: [
                    FertilizingKnowledgeCallout(
                        id: "practical-guide-callout",
                        title: "Practical Guide",
                        body: "Use the Bonsai World Fertilizer Guide for practical feeding recommendations based on the approach already established in your bonsai program."
                    )
                ]
            )
        ]
    )

    // MARK: - 03 Fertilizer Types

    private static let fertilizerTypes = FertilizingKnowledgeLesson(
        id: "fertilizer-types",
        number: 3,
        title: "Fertilizer Types",
        summary: "Organic, mineral and mixed approaches — and how liquid, solid and slow-release products behave.",
        opensFertilizerGuides: false,
        sections: [
            FertilizingKnowledgeSection(
                id: "organic",
                heading: "Organic fertilizer",
                paragraphs: [
                    "Organic fertilizers often release nutrients more slowly and may depend partly on biological activity. They are commonly used as a continuous feeding approach and are available in solid and liquid forms."
                ],
                bullets: [
                    "Advantage: can provide steady nutrition",
                    "Advantage: often convenient for long-term feeding",
                    "Advantage: widely used in bonsai cultivation",
                    "Consideration: release rate can vary",
                    "Consideration: some products may attract insects or animals",
                    "Consideration: performance depends on environment and substrate"
                ],
                callouts: []
            ),
            FertilizingKnowledgeSection(
                id: "mineral",
                heading: "Mineral / synthetic fertilizer",
                paragraphs: [
                    "Mineral fertilizers provide nutrients in mineral forms. They are often predictable and measurable, and are available in liquid and solid forms."
                ],
                bullets: [
                    "Advantage: precise application",
                    "Advantage: easy adjustment of feeding strength",
                    "Advantage: fast response where appropriate",
                    "Consideration: easy to overapply",
                    "Consideration: salt accumulation can become a problem",
                    "Consideration: requires careful dosing"
                ],
                callouts: []
            ),
            FertilizingKnowledgeSection(
                id: "combined",
                heading: "Organic-mineral approach",
                paragraphs: [
                    "Many bonsai growers combine a continuous baseline of nutrition with seasonal adjustment, and add liquid feeding when needed. The mix is a system, not a brand loyalty."
                ],
                bullets: [],
                callouts: [
                    FertilizingKnowledgeCallout(
                        id: "no-single-best",
                        title: "Bonsai World principle",
                        body: "There is no single best fertilizer. The best system is the one that can be applied consistently and adjusted to the tree."
                    )
                ]
            ),
            FertilizingKnowledgeSection(
                id: "liquid",
                heading: "Liquid fertilizer",
                paragraphs: [
                    "Liquid fertilizer is easy to apply and easy to adjust in concentration. It is useful for controlled feeding. It also requires regular application and can be flushed from the substrate more quickly than a solid programme."
                ],
                bullets: [],
                callouts: []
            ),
            FertilizingKnowledgeSection(
                id: "solid",
                heading: "Solid fertilizer",
                paragraphs: [
                    "Pellets, cakes and other solid products provide long-lasting nutrition and are convenient for continuous feeding. Release rate can vary. Placement matters. The same product can behave differently in different climates."
                ],
                bullets: [],
                callouts: []
            ),
            FertilizingKnowledgeSection(
                id: "slow-release",
                heading: "Slow-release fertilizer",
                paragraphs: [
                    "Controlled or slow-release products feed over time rather than in a single application. Temperature can influence release. Formulations vary. Do not assume all slow-release fertilizers behave identically."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )

    // MARK: - 04 Bonsai Strategy

    private static let bonsaiStrategy = FertilizingKnowledgeLesson(
        id: "bonsai-strategy",
        number: 4,
        title: "Bonsai Strategy",
        summary: "Feed for the tree you are growing — development, refinement, recovery or a specific goal.",
        opensFertilizerGuides: false,
        sections: [
            FertilizingKnowledgeSection(
                id: "development",
                heading: "Development trees",
                paragraphs: [
                    "The goal is often strong growth, thickening, branch development, root development or recovery after a building phase. When the tree is healthy and actively developing, the feeding strategy may support stronger growth.",
                    "Open Fertilizer Guides for the practical strength and seasonal starting points already used in the programme."
                ],
                bullets: [],
                callouts: []
            ),
            FertilizingKnowledgeSection(
                id: "refinement",
                heading: "Refinement trees",
                paragraphs: [
                    "The goal may be controlled growth, shorter internodes, fine ramification and maintaining design. Less fertilizer is not the only refinement strategy.",
                    "Controlled growth also depends on light, pruning, species characteristics, watering, root volume and timing. Starving a refined tree is not the same as refining it."
                ],
                bullets: [],
                callouts: [
                    FertilizingKnowledgeCallout(
                        id: "refinement-nutrition",
                        title: "Bonsai World principle",
                        body: "A refined bonsai still needs nutrition."
                    )
                ]
            ),
            FertilizingKnowledgeSection(
                id: "show-ready",
                heading: "Show-ready or highly refined trees",
                paragraphs: [
                    "Feeding strategy may be adjusted to avoid unwanted excessive growth, while still maintaining tree health. The tree is not finished with nutrition because the design is finished."
                ],
                bullets: [],
                callouts: []
            ),
            FertilizingKnowledgeSection(
                id: "goals",
                heading: "Goal-based feeding",
                paragraphs: [
                    "Feeding for trunk development is not the same as feeding for ramification, recovery, maintenance, flowering or fruiting. Name the current goal before choosing a strategy."
                ],
                bullets: [
                    "Tree goal",
                    "Tree health",
                    "Species",
                    "Season / growth stage",
                    "Fertilizer strategy"
                ],
                callouts: []
            )
        ]
    )

    // MARK: - 05 Seasonal Feeding

    private static let seasonalFeeding = FertilizingKnowledgeLesson(
        id: "seasonal-feeding",
        number: 5,
        title: "Seasonal Feeding",
        summary: "Season matters, but species, climate, growth stage and root activity decide when feeding is appropriate.",
        opensFertilizerGuides: false,
        sections: [
            FertilizingKnowledgeSection(
                id: "spring",
                heading: "Spring",
                paragraphs: [
                    "Feeding in spring should relate to species, climate, stage of growth and root activity. There is no universal rule such as fertilize immediately when spring begins.",
                    "Fertilizer Guides uses tree signals — not the month alone — as the practical trigger.",
                    "Seasonal Care & Protection in this Handbook covers why the year changes feeding. It does not replace this lesson or Fertilizer Guides with a month."
                ],
                bullets: [],
                callouts: []
            ),
            FertilizingKnowledgeSection(
                id: "summer",
                heading: "Summer",
                paragraphs: [
                    "Healthy, actively growing trees may continue receiving nutrition. Heat, drought and root stress can change how a tree should be managed. Do not fertilize simply because the calendar says it is time."
                ],
                bullets: [],
                callouts: []
            ),
            FertilizingKnowledgeSection(
                id: "autumn",
                heading: "Autumn",
                paragraphs: [
                    "Seasonal feeding strategies vary by species and climate. Focus on preparing for dormancy where relevant, maintaining tree health, and avoiding unnecessary forcing of unsuitable growth."
                ],
                bullets: [],
                callouts: []
            ),
            FertilizingKnowledgeSection(
                id: "winter",
                heading: "Winter",
                paragraphs: [
                    "The correct winter approach depends heavily on species, dormancy, storage conditions and climate. There is no universal winter fertilizing rule. Fertilizer Guides already records the practical winter action used in the programme."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )

    // MARK: - 06 Tree Health

    private static let treeHealth = FertilizingKnowledgeLesson(
        id: "tree-health",
        number: 6,
        title: "Tree Health",
        summary: "Roots, substrate, watering and the tree's current condition decide whether fertilizer can help.",
        opensFertilizerGuides: false,
        sections: [
            FertilizingKnowledgeSection(
                id: "healthy",
                heading: "Healthy and actively growing",
                paragraphs: [
                    "This is usually the most appropriate condition for normal fertilization. The tree can use what you supply."
                ],
                bullets: [],
                callouts: []
            ),
            FertilizingKnowledgeSection(
                id: "weak",
                heading: "Weak or stressed trees",
                paragraphs: [
                    "A weak tree is not automatically a hungry tree. First identify possible causes: watering problems, root problems, disease, pests, lack of light, or seasonal dormancy. Diagnosis comes before increasing fertilizer."
                ],
                bullets: [],
                callouts: []
            ),
            FertilizingKnowledgeSection(
                id: "repotted",
                heading: "Recently repotted trees",
                paragraphs: [
                    "Fertilizing after repotting depends on the amount of root work, species, tree vigor, substrate and recovery. Avoid a rigid universal number of days or weeks."
                ],
                bullets: [],
                callouts: []
            ),
            FertilizingKnowledgeSection(
                id: "collected",
                heading: "Recently collected trees",
                paragraphs: [
                    "Recovery and root establishment take priority. Pushing growth with fertilizer before the tree can take it up does not speed collection recovery."
                ],
                bullets: [],
                callouts: []
            ),
            FertilizingKnowledgeSection(
                id: "pruned",
                heading: "Recently pruned or styled trees",
                paragraphs: [
                    "Consider the tree's overall stress level before increasing feeding. Styling and heavy pruning are work. Nutrition should support recovery, not add another demand."
                ],
                bullets: [],
                callouts: []
            ),
            FertilizingKnowledgeSection(
                id: "roots",
                heading: "The root system comes first",
                paragraphs: [
                    "Nutrient uptake depends on a functioning root system. Root health, oxygen in the substrate, moisture balance, temperature and substrate structure all affect whether fertilizer can be used."
                ],
                bullets: [],
                callouts: [
                    FertilizingKnowledgeCallout(
                        id: "poor-roots",
                        title: "Key principle",
                        body: "A tree with poor roots may not benefit from more fertilizer."
                    )
                ]
            ),
            FertilizingKnowledgeSection(
                id: "substrate",
                heading: "Why bonsai substrate changes fertilizing",
                paragraphs: [
                    "Bonsai substrate is often free draining, fast drying and low in natural nutrient reserves. Fertilizing is therefore often an active and regular part of bonsai cultivation.",
                    "Requirements still depend on substrate composition, particle size, watering frequency, climate, pot size and tree growth."
                ],
                bullets: [],
                callouts: []
            ),
            FertilizingKnowledgeSection(
                id: "watering",
                heading: "Watering and fertilizer",
                paragraphs: [
                    "Nutrients must be available to roots. Excessive watering can contribute to nutrient loss. Insufficient watering can reduce nutrient uptake. Fertilizer concentration interacts with water availability.",
                    "Do not fertilize a severely dry or stressed tree without first considering its condition."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )

    // MARK: - 07 Advanced

    private static let advanced = FertilizingKnowledgeLesson(
        id: "advanced",
        number: 7,
        title: "Advanced",
        summary: "Overfertilization, salts, deficiencies, and how species groups change the feeding question.",
        opensFertilizerGuides: false,
        sections: [
            FertilizingKnowledgeSection(
                id: "overfertilization",
                heading: "When more becomes too much",
                paragraphs: [
                    "Possible consequences include root damage, salt accumulation, excessively coarse growth, weak internodes and reduced refinement quality.",
                    "Possible warning signs include leaf edge damage, sudden stress after feeding, white mineral deposits and poor root health. These symptoms are not exclusive to fertilizer problems. Diagnosis should also consider watering, root health, disease, pests and environmental conditions."
                ],
                bullets: [],
                callouts: []
            ),
            FertilizingKnowledgeSection(
                id: "salts",
                heading: "Understanding fertilizer salts",
                paragraphs: [
                    "Mineral fertilizer can contribute to dissolved salts in the substrate. Concentration, frequency, water quality, substrate and evaporation all play a part.",
                    "Accumulated salts are often managed through normal appropriate watering. Aggressive flushing is not a universal requirement."
                ],
                bullets: [],
                callouts: []
            ),
            FertilizingKnowledgeSection(
                id: "deficiencies",
                heading: "Recognising possible deficiencies",
                paragraphs: [
                    "Yellowing or weak growth does not automatically mean add fertilizer. Possible causes include nitrogen deficiency, iron availability problems, magnesium deficiency, root problems, incorrect pH, overwatering, underwatering and seasonal change."
                ],
                bullets: [],
                callouts: [
                    FertilizingKnowledgeCallout(
                        id: "diagnose-first",
                        title: "Bonsai World principle",
                        body: "Diagnose before correcting."
                    )
                ]
            ),
            FertilizingKnowledgeSection(
                id: "species",
                heading: "Species matter",
                paragraphs: [
                    "Do not display generic recommendations as if they apply equally to all species. Fast-growing deciduous trees, conifers, tropical bonsai, flowering bonsai and fruiting bonsai do not share one feeding logic.",
                    "Species Profiles should eventually be able to show fertilizing characteristics — heavy, moderate, light or species-specific feeder — along with recommended feeding period, fertilizer type, growth response and special considerations. Until then, use this chapter for principles and Fertilizer Guides for the practical species groups already in the programme."
                ],
                bullets: [],
                callouts: []
            ),
            FertilizingKnowledgeSection(
                id: "flowering",
                heading: "Flowering and fruiting bonsai",
                paragraphs: [
                    "Fertilizing flowering and fruiting bonsai requires consideration of growth stage, flowering cycle, fruit production and tree energy reserves.",
                    "Avoid simplistic rules such as use phosphorus for flowers. Flowering and fruiting are influenced by species biology, light, seasonal cycles, pruning and overall nutrition."
                ],
                bullets: [],
                callouts: []
            ),
            FertilizingKnowledgeSection(
                id: "conifers",
                heading: "Conifer considerations",
                paragraphs: [
                    "Conifers should not automatically be managed using the same feeding logic as fast-growing deciduous species. Consider growth cycles, species, needle or foliage development, climate, and whether the tree is in development or refinement.",
                    "Species Profiles and Fertilizer Guides provide more specific guidance where available."
                ],
                bullets: [],
                callouts: []
            ),
            FertilizingKnowledgeSection(
                id: "tropical",
                heading: "Tropical and indoor-grown bonsai",
                paragraphs: [
                    "Fertilizing schedules may differ because growth may continue outside the traditional temperate growing season. Consider temperature, light, active growth and indoor conditions.",
                    "Feed according to active growth and tree condition rather than a generic calendar."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )

    // MARK: - 08 Troubleshooting

    private static let troubleshooting = FertilizingKnowledgeLesson(
        id: "troubleshooting",
        number: 8,
        title: "Troubleshooting",
        summary: "Weak growth, yellow leaves, excessive extension and damage after feeding — what to check first.",
        opensFertilizerGuides: false,
        sections: [
            FertilizingKnowledgeSection(
                id: "weak-growth",
                heading: "Weak growth",
                paragraphs: [
                    "Do not start by adding fertilizer. Check the conditions that actually produce growth."
                ],
                bullets: [
                    "Light",
                    "Watering",
                    "Roots",
                    "Season",
                    "Pests",
                    "Disease",
                    "Nutrition"
                ],
                callouts: []
            ),
            FertilizingKnowledgeSection(
                id: "yellow-leaves",
                heading: "Yellow leaves",
                paragraphs: [
                    "Yellowing has several causes. Nutrition is only one of them. Tree Health in this Handbook covers investigating colour change before adding fertilizer."
                ],
                bullets: [
                    "Seasonal change",
                    "Nitrogen",
                    "Iron availability",
                    "Root health",
                    "Watering",
                    "pH"
                ],
                callouts: []
            ),
            FertilizingKnowledgeSection(
                id: "long-internodes",
                heading: "Excessively long internodes",
                paragraphs: [
                    "Coarse extension is often a combination of feeding, light and species habit — not fertilizer alone."
                ],
                bullets: [
                    "Fertilizer level",
                    "Light",
                    "Species growth characteristics",
                    "Pruning timing"
                ],
                callouts: []
            ),
            FertilizingKnowledgeSection(
                id: "root-damage",
                heading: "Root damage after fertilizing",
                paragraphs: [
                    "If the tree declined after feeding, look at how the fertilizer was applied as well as the tree's condition at the time."
                ],
                bullets: [
                    "Concentration",
                    "Frequency",
                    "Product type",
                    "Substrate condition",
                    "Tree moisture level"
                ],
                callouts: []
            )
        ]
    )

    // MARK: - 09 Quick Guides

    private static let quickGuides = FertilizingKnowledgeLesson(
        id: "quick-guides",
        number: 9,
        title: "Quick Guides",
        summary: "A decision framework, a checklist, common mistakes and short cards to keep beside the tree.",
        opensFertilizerGuides: false,
        sections: [
            FertilizingKnowledgeSection(
                id: "framework",
                heading: "A simple decision framework",
                paragraphs: [
                    "Work through the steps in order. The last practical step is the existing Fertilizer Guide — not a new schedule invented here."
                ],
                bullets: [
                    "Step 1 — Is the tree healthy? Yes: continue. No: diagnose before increasing fertilizer.",
                    "Step 2 — Is the tree actively growing? Yes: consider normal feeding. No: consider species, season and condition.",
                    "Step 3 — What is the current goal? Development, refinement, recovery or maintenance.",
                    "Step 4 — Open the existing Bonsai World Fertilizer Guide.",
                    "Step 5 — Apply the practical recommendation already established in the programme.",
                    "Step 6 — Observe the tree.",
                    "Step 7 — Adjust future feeding based on response."
                ],
                callouts: []
            ),
            FertilizingKnowledgeSection(
                id: "checklist-before",
                heading: "Before fertilizing",
                paragraphs: [],
                bullets: [
                    "Tree is healthy",
                    "Root system appears functional",
                    "Tree is not severely dry",
                    "Species considered",
                    "Current growth stage considered",
                    "Bonsai goal considered",
                    "Existing Bonsai World Fertilizer Guide checked"
                ],
                callouts: []
            ),
            FertilizingKnowledgeSection(
                id: "checklist-after",
                heading: "After fertilizing",
                paragraphs: [],
                bullets: [
                    "Tree response observed",
                    "Watering continues normally",
                    "Growth recorded where relevant",
                    "Problems investigated before adding more fertilizer"
                ],
                callouts: []
            ),
            FertilizingKnowledgeSection(
                id: "mistakes",
                heading: "Common mistakes",
                paragraphs: [
                    "Feeding a weak tree heavily to make it stronger skips diagnosis. Using the same fertilizer schedule for every tree ignores species, stage and health. Changing fertilizer constantly makes observation harder — consistency is valuable.",
                    "Assuming more fertilizer means faster bonsai development confuses vigour with progress. Stopping all feeding because a tree is refined treats starvation as design. Ignoring substrate and root health asks fertilizer to work where roots cannot. Following the calendar instead of observing the tree is the mistake this chapter exists to prevent."
                ],
                bullets: [],
                callouts: []
            ),
            FertilizingKnowledgeSection(
                id: "cards",
                heading: "Quick knowledge cards",
                paragraphs: [],
                bullets: [],
                callouts: [
                    FertilizingKnowledgeCallout(
                        id: "card-calendar",
                        title: "Feed the tree, not the calendar",
                        body: "Season matters, but the tree's health and active growth matter more."
                    ),
                    FertilizingKnowledgeCallout(
                        id: "card-more",
                        title: "More is not better",
                        body: "Overfertilization can damage roots and create undesirable growth."
                    ),
                    FertilizingKnowledgeCallout(
                        id: "card-roots",
                        title: "Healthy roots first",
                        body: "Nutrition is only useful when the root system can absorb it."
                    ),
                    FertilizingKnowledgeCallout(
                        id: "card-refinement",
                        title: "Refinement still requires nutrition",
                        body: "Controlled growth does not mean starvation."
                    ),
                    FertilizingKnowledgeCallout(
                        id: "card-diagnose",
                        title: "Diagnose before adding fertilizer",
                        body: "Yellow leaves and weak growth can have many causes."
                    ),
                    FertilizingKnowledgeCallout(
                        id: "card-guide",
                        title: "Use the existing Fertilizer Guide",
                        body: "For practical Bonsai World recommendations, continue to use the existing Fertilizer Guide already available in the Knowledge system."
                    )
                ]
            ),
            FertilizingKnowledgeSection(
                id: "philosophy",
                heading: "Bonsai World philosophy",
                paragraphs: [
                    "Fertilizing bonsai is not about forcing growth. It is about supporting the tree at the stage it is currently in.",
                    "A young tree and a refined tree may require different strategies. A healthy tree and a recovering tree may require different decisions. The same species may need a different approach depending on season and climate.",
                    "The best fertilizer program is not the most complicated one. It is a consistent system based on healthy roots, active growth, observation and a clear goal for the future of the tree."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )
}
