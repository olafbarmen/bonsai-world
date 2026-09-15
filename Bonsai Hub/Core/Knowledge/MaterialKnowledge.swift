//
//  MaterialKnowledge.swift
//  Bonsai World
//
//  Knowledge → Bonsai Handbook → Bonsai Material & Sourcing.
//  Buy the future you can see. Source responsibly. Develop patiently.
//

import Foundation

struct MaterialKnowledgeCallout: Identifiable, Hashable, Sendable {
    var id: String
    var title: String
    var body: String
}

struct MaterialKnowledgeSection: Identifiable, Hashable, Sendable {
    var id: String
    var heading: String
    var paragraphs: [String]
    var bullets: [String]
    var callouts: [MaterialKnowledgeCallout]
}

struct MaterialKnowledgeLesson: Identifiable, Hashable, Sendable {
    var id: String
    var number: Int
    var title: String
    var summary: String
    var sections: [MaterialKnowledgeSection]
}

enum MaterialKnowledge {
    static let chapterTitle = "Bonsai Material & Sourcing"

    static let openingLine =
        "Finding, evaluating and selecting material — from seed and cutting to yamadori and finished bonsai."

    static let disclaimer =
        "The cheapest material is not always the best value. The most expensive material is not always the best bonsai. Source legally and ethically. Never collect from public land, protected land, private property without permission, or protected habitats."

    static let lessons: [MaterialKnowledgeLesson] = [
        overview,
        evaluatingStructure,
        health,
        nurseryStock,
        preBonsai,
        growingYourOwn,
        airLayersAndGarden,
        yamadoriAndEthics,
        yamadoriRecovery,
        readingRecovery,
        yamadoriEarlyDevelopment,
        buyingAndValue,
        timeAndPlanning,
        learningAndAdvanced,
        practice,
        quickGuides
    ]

    static func lesson(id: String) -> MaterialKnowledgeLesson? {
        lessons.first { $0.id == id }
    }

    // MARK: - 01 Overview

    private static let overview = MaterialKnowledgeLesson(
        id: "overview",
        number: 1,
        title: "Overview",
        summary: "Buy the future you can see. Choose the starting point that matches your vision, your skill and your patience.",
        sections: [
            MaterialKnowledgeSection(
                id: "introduction",
                heading: "Every bonsai begins as material",
                paragraphs: [
                    "Material can begin as a seed, a cutting, a young seedling, nursery stock, a garden tree, an air layer, collected material, pre-bonsai, or an already developed bonsai. Each starting point offers advantages, limitations and different timelines.",
                    "The important question is not what is the best material. The better question is what material is best for this project.",
                    "Look beyond current foliage, temporary styling, nursery appearance, price and pot. Evaluate trunk, nebari, taper, movement, branch potential, root system, health, species suitability, development potential and time required. A cheap tree is not the same as good bonsai material."
                ],
                bullets: [],
                callouts: [
                    MaterialKnowledgeCallout(
                        id: "buy-future",
                        title: "Bonsai World principle",
                        body: "Buy the future you can see."
                    ),
                    MaterialKnowledgeCallout(
                        id: "match-patience",
                        title: "Bonsai World principle",
                        body: "Choose the starting point that matches your vision, your skill and your patience."
                    )
                ]
            )
        ]
    )

    // MARK: - 02 Evaluating Structure

    private static let evaluatingStructure = MaterialKnowledgeLesson(
        id: "structure",
        number: 2,
        title: "Evaluating Structure",
        summary: "Foliage can often be pruned, developed or replaced. A poor trunk may require decades to improve.",
        sections: [
            MaterialKnowledgeSection(
                id: "potential",
                heading: "What makes good bonsai material?",
                paragraphs: [
                    "Bonsai potential is rarely determined by current styling. Evaluate trunk base, nebari, taper, trunk movement, trunk character, branch potential, internode length, leaf or needle characteristics, root potential and tree health.",
                    "Foliage can often be pruned, developed or replaced. A poor trunk may require decades to improve. Design Guidelines in this Handbook cover how that structure becomes a composition."
                ],
                bullets: [],
                callouts: []
            ),
            MaterialKnowledgeSection(
                id: "trunk",
                heading: "The importance of the trunk",
                paragraphs: [
                    "The trunk is often one of the most important long-term features. Evaluate thickness, taper, movement, bark, character and proportion.",
                    "Imagine the future tree. Not only the current tree."
                ],
                bullets: [],
                callouts: []
            ),
            MaterialKnowledgeSection(
                id: "nebari",
                heading: "Nebari",
                paragraphs: [
                    "The root base is the beginning of the visual structure. Evaluate root spread, root distribution, trunk flare, surface roots and root defects.",
                    "Do not reject all material with imperfect nebari. Nebari may improve, be developed or be partially corrected. Some problems are easier to correct than others."
                ],
                bullets: [],
                callouts: []
            ),
            MaterialKnowledgeSection(
                id: "taper",
                heading: "Taper",
                paragraphs: [
                    "Taper contributes to age, perspective and tree proportion. Evaluate base thickness, trunk reduction, sudden inverse taper and natural transitions.",
                    "Taper can sometimes be developed through sacrifice branches, trunk chops and regrowth. Those processes require time."
                ],
                bullets: [],
                callouts: []
            ),
            MaterialKnowledgeSection(
                id: "movement",
                heading: "Trunk movement",
                paragraphs: [
                    "Natural movement may provide character, direction and design possibilities. Evaluate movement from multiple angles.",
                    "Do not assume movement visible from one side is useful from the final front."
                ],
                bullets: [],
                callouts: []
            ),
            MaterialKnowledgeSection(
                id: "branches",
                heading: "Branch potential",
                paragraphs: [
                    "Look beyond existing branches. Evaluate branch position, thickness, internode spacing, bud availability and back budding potential.",
                    "Branches may often be developed, replaced or removed. A missing branch is not always a reason to reject excellent material."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )

    // MARK: - 03 Health

    private static let health = MaterialKnowledgeLesson(
        id: "health",
        number: 3,
        title: "Health",
        summary: "Never buy potential without checking health. A visually attractive tree may still have underlying problems.",
        sections: [
            MaterialKnowledgeSection(
                id: "inspect",
                heading: "Tree health before purchase",
                paragraphs: [
                    "Evaluate foliage condition, growth, root condition where visible, pests, disease symptoms and bark condition.",
                    "A visually attractive tree may still have underlying health problems. Potential is worthless if the tree cannot recover."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )

    // MARK: - 04 Nursery Stock

    private static let nurseryStock = MaterialKnowledgeLesson(
        id: "nursery",
        number: 4,
        title: "Nursery Stock",
        summary: "Do not buy the foliage. Buy the structure beneath it. Never assume the first available tree is the best tree.",
        sections: [
            MaterialKnowledgeSection(
                id: "finding",
                heading: "Finding bonsai potential in ordinary trees",
                paragraphs: [
                    "Nursery stock can be affordable, available, excellent for learning and highly variable. Ignore temporary nursery shape. Search for trunk, nebari, taper and branch potential."
                ],
                bullets: [],
                callouts: [
                    MaterialKnowledgeCallout(
                        id: "not-foliage",
                        title: "Bonsai World principle",
                        body: "Do not buy the foliage. Buy the structure beneath it."
                    )
                ]
            ),
            MaterialKnowledgeSection(
                id: "inspection",
                heading: "A practical inspection process",
                paragraphs: [
                    "Work through the tree, then imagine the future, then compare. Never assume the first available tree is the best tree."
                ],
                bullets: [
                    "Look at the base.",
                    "Evaluate trunk thickness.",
                    "Look for taper.",
                    "Inspect movement.",
                    "Search for branch potential.",
                    "Evaluate health.",
                    "Imagine possible future designs.",
                    "Compare multiple trees."
                ],
                callouts: []
            )
        ]
    )

    // MARK: - 05 Pre-Bonsai

    private static let preBonsai = MaterialKnowledgeLesson(
        id: "pre-bonsai",
        number: 5,
        title: "Pre-Bonsai",
        summary: "Evaluate actual structure. Not simply the label Pre-Bonsai.",
        sections: [
            MaterialKnowledgeSection(
                id: "journey",
                heading: "Material already on the journey",
                paragraphs: [
                    "Pre-bonsai may offer existing trunk development, early branch structure, bonsai-oriented roots and reduced development time. Quality varies dramatically.",
                    "Evaluate actual structure. Not simply the label."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )

    // MARK: - 06 Growing Your Own

    private static let growingYourOwn = MaterialKnowledgeLesson(
        id: "growing",
        number: 6,
        title: "Seeds & Cuttings",
        summary: "Seeds and cuttings give control and learning. They are not necessarily the fastest route to a mature bonsai.",
        sections: [
            MaterialKnowledgeSection(
                id: "seedlings",
                heading: "Seedlings",
                paragraphs: [
                    "Advantages include low cost, complete control, learning and large numbers. Limitations include time and long development periods.",
                    "Seeds and seedlings are excellent for learning, breeding projects and long-term development. They are not necessarily the fastest route to a mature bonsai."
                ],
                bullets: [],
                callouts: []
            ),
            MaterialKnowledgeSection(
                id: "seeds",
                heading: "Growing from seed",
                paragraphs: [
                    "Seed collection, storage, stratification, germination and early development are species-specific. Propagation in this Handbook covers the methods. Seed Stratification in Knowledge covers dormancy. Nursery → Seeds is the practical surface in the programme."
                ],
                bullets: [],
                callouts: []
            ),
            MaterialKnowledgeSection(
                id: "cuttings",
                heading: "Cuttings",
                paragraphs: [
                    "Cuttings can offer genetic continuity, known characteristics and potential for root development. Categories include softwood, semi-hardwood, hardwood, heel cuttings, and root cuttings where appropriate.",
                    "Propagation in this Handbook covers how those cutting types differ. Nursery → Cuttings is the practical surface. This chapter asks whether a cutting is the right starting point for the project — not how to strike every species."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )

    // MARK: - 07 Air Layers & Garden Material

    private static let airLayersAndGarden = MaterialKnowledgeLesson(
        id: "air-garden",
        number: 7,
        title: "Air Layers & Garden Material",
        summary: "Air layers can skip years of trunk development. Garden material needs permission and honest recovery judgement.",
        sections: [
            MaterialKnowledgeSection(
                id: "air-layers",
                heading: "Creating a new tree from existing material",
                paragraphs: [
                    "Air layering can create excellent bonsai material: mature bark, existing trunk thickness, existing movement and a faster starting point. Air layers can sometimes skip years of trunk development.",
                    "Air Layering in this Handbook covers the work. This chapter asks whether an air layer is the right material for the project."
                ],
                bullets: [],
                callouts: []
            ),
            MaterialKnowledgeSection(
                id: "garden",
                heading: "Hidden bonsai potential",
                paragraphs: [
                    "Old hedges, garden shrubs and mature ornamental trees may contain excellent material. Evaluate trunk structure, root recovery potential, species response and existing health.",
                    "Always obtain permission."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )

    // MARK: - 08 Yamadori & Ethics

    private static let yamadoriAndEthics = MaterialKnowledgeLesson(
        id: "yamadori",
        number: 8,
        title: "Yamadori & Ethics",
        summary: "Yamadori is not automatically superior. Source responsibly. Develop patiently.",
        sections: [
            MaterialKnowledgeSection(
                id: "collected",
                heading: "Understanding collected trees",
                paragraphs: [
                    "Collected material may provide natural age, bark, movement and environmental character. Collection and recovery require advanced knowledge.",
                    "Legal permission, timing, species suitability, root preservation and recovery planning all matter. This chapter does not provide a universal collection procedure. Species and conditions vary significantly."
                ],
                bullets: [],
                callouts: []
            ),
            MaterialKnowledgeSection(
                id: "yamadori",
                heading: "Naturally developed material",
                paragraphs: [
                    "Yamadori is naturally developed material. Natural environment, age, character and unique movement can be remarkable.",
                    "Yamadori is not automatically superior. Poor yamadori may have weak roots, poor recovery potential and limited design possibilities. A healthy, well-developed nursery tree may sometimes be the better bonsai project.",
                    "Yamadori in the programme is the record for trips, finds and recovery — not a licence to collect. After a tree is already in the collection, Yamadori Recovery, Reading Recovery & Time, and Early Development & Character in this chapter cover the next priorities. They do not explain how to collect."
                ],
                bullets: [],
                callouts: []
            ),
            MaterialKnowledgeSection(
                id: "ethical",
                heading: "Respect the environment",
                paragraphs: [
                    "Never collect material where it damages natural habitats, protected environments or rare populations. Never collect without legal permission, and private landowner permission where required.",
                    "Never collect from public land, protected land, private property without permission, or protected habitats."
                ],
                bullets: [],
                callouts: [
                    MaterialKnowledgeCallout(
                        id: "not-destroy",
                        title: "Bonsai World principle",
                        body: "A bonsai should not be created by destroying the environment it came from."
                    )
                ]
            ),
            MaterialKnowledgeSection(
                id: "legal",
                heading: "Know the rules",
                paragraphs: [
                    "Laws vary by country, region, land ownership, species and protected status. Users must verify local regulations.",
                    "Do not assume that wild material is free to collect simply because it grows naturally."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )

    // MARK: - 09 Yamadori Recovery

    private static let yamadoriRecovery = MaterialKnowledgeLesson(
        id: "yamadori-recovery",
        number: 9,
        title: "Yamadori Recovery",
        summary: "After collection, the first design decision is usually patience. Survival and recovery come before styling.",
        sections: [
            MaterialKnowledgeSection(
                id: "recovery-phase",
                heading: "The period after collection is a recovery phase",
                paragraphs: [
                    "Yamadori can offer age, natural movement, weathered bark, character, natural deadwood and unique trunk development. A collected tree is not immediately ready to become a refined bonsai. Collection is a major biological transition.",
                    "The tree may have lost roots, environmental stability, established water relationships and parts of its natural support system. The period after collection is not primarily a styling phase. It is a recovery phase. This chapter does not provide collection methods, calendars or a recovery environment that fits every species."
                ],
                bullets: [],
                callouts: [
                    MaterialKnowledgeCallout(
                        id: "patience-first",
                        title: "Bonsai World principle",
                        body: "After collection, the first design decision is usually patience."
                    ),
                    MaterialKnowledgeCallout(
                        id: "ready-to-grow",
                        title: "Bonsai World principle",
                        body: "Do not ask what the tree can become before asking whether the tree is ready to grow."
                    )
                ]
            ),
            MaterialKnowledgeSection(
                id: "survival",
                heading: "The first priority: survival",
                paragraphs: [
                    "After collection, the first goal is survival. The second is recovery. Only later should the focus become development and styling.",
                    "The temptation to immediately wire, prune, carve, repot again or display the tree must be balanced against the tree's biological condition. A collected tree may already contain all the character needed. The artist's first responsibility is to preserve the living tree."
                ],
                bullets: [],
                callouts: []
            ),
            MaterialKnowledgeSection(
                id: "roots-stability",
                heading: "Root loss and stability",
                paragraphs: [
                    "A collected tree may have lost a significant part of its original root system. The remaining roots must support water uptake, recovery, new growth and future root development. Visible foliage does not always indicate that the root system has fully recovered. A tree may survive for a period using stored resources. Early growth alone should not automatically be interpreted as complete recovery.",
                    "A recovering tree benefits from a stable environment. Avoid unnecessary repositioning, root disturbance, structural work and repeated repotting. The tree should be allowed to establish a new relationship between roots, soil, water and environment. Repotting in this Handbook belongs later, when the tree can support more change."
                ],
                bullets: [],
                callouts: [
                    MaterialKnowledgeCallout(
                        id: "not-adapt-repeatedly",
                        title: "Bonsai World principle",
                        body: "Recovery is difficult when the tree is repeatedly asked to adapt."
                    )
                ]
            ),
            MaterialKnowledgeSection(
                id: "water-environment",
                heading: "Water, light, wind and protection",
                paragraphs: [
                    "Water requirements may change during recovery. They depend on species, root condition, soil structure, temperature, wind, light and growth activity. Avoid assuming that collected material should always receive more water, or less water. Ask how quickly the growing medium is changing, how active the tree is, and how the environment is influencing moisture. Watering in this Handbook belongs in that observation.",
                    "A recovering tree may require protection from extreme heat, drying wind, severe weather and excessive environmental change. Protection should not automatically mean creating an unnatural environment. The correct recovery environment depends on species, climate, collection condition and root condition. Species Library remains essential.",
                    "Light supports the tree. Environmental stress may also increase under demanding conditions. The question is not simply sun or shade. It is what level of environmental demand this tree can currently support. Observe foliage condition, growth, water demand and stress. Do not use a universal light rule for all collected material.",
                    "Wind can increase water loss, environmental stress, movement of the tree and drying of the growing medium. Avoid treating every collected tree as though it requires permanent shelter. The goal is appropriate protection, not permanent isolation from normal conditions. Seasonal Care & Protection provides climate context. It is not a recovery calendar."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )

    // MARK: - 10 Reading Recovery & Time

    private static let readingRecovery = MaterialKnowledgeLesson(
        id: "reading-recovery",
        number: 10,
        title: "Reading Recovery & Time",
        summary: "The tree determines the recovery timeline. The calendar does not. A tree does not become ready because the artist becomes impatient.",
        sections: [
            MaterialKnowledgeSection(
                id: "not-too-early",
                heading: "Do not style too early",
                paragraphs: [
                    "One of the most common mistakes with yamadori is styling too soon. The tree may look old, powerful and ready. Visual potential does not equal biological readiness.",
                    "Major styling may include heavy pruning, wiring, bending, carving and deadwood work. Each intervention can add additional demand. Tree Health covers stress and observation. Deadwood covers whether existing character should be left alone."
                ],
                bullets: [],
                callouts: [
                    MaterialKnowledgeCallout(
                        id: "not-impatience",
                        title: "Bonsai World principle",
                        body: "A tree does not become ready because the artist becomes impatient."
                    )
                ]
            ),
            MaterialKnowledgeSection(
                id: "pattern",
                heading: "Early growth is not always full recovery",
                paragraphs: [
                    "New growth is encouraging. A single flush of growth does not necessarily mean the tree has fully established. Look for consistent growth, continued strength, stable foliage, ongoing development over time and signs of an improving root relationship.",
                    "Recovery should be evaluated as a pattern. Not a single event. Observe shoot development, foliage quality, bud activity, consistency of growth and response over time. Do not evaluate vigour only by how fast the tree grows. Strong recovery may also appear as stable, consistent, predictable growth."
                ],
                bullets: [],
                callouts: []
            ),
            MaterialKnowledgeSection(
                id: "timeline",
                heading: "The tree determines the timeline",
                paragraphs: [
                    "There is no universal timeline for yamadori recovery. The process depends on species, age, collection condition, root loss, climate and environment. Avoid comparing one tree's recovery directly to another.",
                    "Development may begin when the tree demonstrates sufficient and consistent strength. Before major work, consider whether growth is consistent, whether the tree has remained stable, whether it appears capable of recovering from additional work, and whether enough time has passed to observe a reliable pattern. The question is not how long the tree has been collected. The question is how ready the tree is now."
                ],
                bullets: [],
                callouts: [
                    MaterialKnowledgeCallout(
                        id: "not-calendar",
                        title: "Bonsai World principle",
                        body: "The tree determines the recovery timeline. The calendar does not."
                    )
                ]
            )
        ]
    )

    // MARK: - 11 Early Development & Character

    private static let yamadoriEarlyDevelopment = MaterialKnowledgeLesson(
        id: "yamadori-early-development",
        number: 11,
        title: "Early Development & Character",
        summary: "The first styling creates direction. It does not need to create the finished tree. Preserve what made the material interesting.",
        sections: [
            MaterialKnowledgeSection(
                id: "direction",
                heading: "From survival to direction",
                paragraphs: [
                    "Once recovery is sufficiently established, development may begin gradually. Early development may involve observing future structure, identifying important branches, understanding trunk character, considering the future front and planning long-term development.",
                    "Do not assume that the first styling must solve the final design. Yamadori often benefits from long-term planning and gradual refinement. Design Guidelines and Bonsai Forms, Styles & Silhouette belong in that planning. They do not require a finished silhouette in the first year."
                ],
                bullets: [],
                callouts: [
                    MaterialKnowledgeCallout(
                        id: "direction-not-finished",
                        title: "Bonsai World principle",
                        body: "The first styling creates direction. It does not need to create the finished tree."
                    )
                ]
            ),
            MaterialKnowledgeSection(
                id: "preserve",
                heading: "Preserve future options and original character",
                paragraphs: [
                    "During early development, the artist may be tempted to remove extra branches, shoots and unwanted growth. Some growth may later become useful. Before removing major structure, ask whether this feature has a future purpose — for design, recovery, branch development or future alternatives. Once mature material is removed, it may take years to replace.",
                    "Yamadori often has natural features that cannot easily be recreated: natural movement, bark, deadwood, taper and irregularity. Ask what makes this material special. Avoid removing the very features that made the tree interesting to begin with.",
                    "Natural deadwood may already support the tree's story, reveal age and explain movement. Existing deadwood should be evaluated before new features are created. Avoid automatically removing, cleaning excessively or reshaping the natural history of the tree. Deadwood in this Handbook covers that judgement."
                ],
                bullets: [],
                callouts: [
                    MaterialKnowledgeCallout(
                        id: "understand-before-improve",
                        title: "Bonsai World principle",
                        body: "Do not improve the yamadori until you understand what should be preserved."
                    )
                ]
            ),
            MaterialKnowledgeSection(
                id: "transition",
                heading: "Roots, phases and the next decision",
                paragraphs: [
                    "Future bonsai work depends on a functional root system: development, repotting, refinement and container choice. The visible tree and the hidden root system develop together.",
                    "Recovery focuses on keeping the tree alive and stable. Development focuses on building future structure. Refinement focuses on improving detail and presentation. These phases may overlap. They should not be confused. A tree can be alive yet not ready for development. Developing yet not ready for refinement. Bonsai Collection Management belongs in recording what happened, what was observed and what should wait."
                ],
                bullets: [],
                callouts: [
                    MaterialKnowledgeCallout(
                        id: "support-itself",
                        title: "Bonsai World principle",
                        body: "Every future design decision rests on the tree's ability to support itself."
                    )
                ]
            )
        ]
    )

    // MARK: - 12 Buying & Value

    private static let buyingAndValue = MaterialKnowledgeLesson(
        id: "buying",
        number: 12,
        title: "Buying & Value",
        summary: "Price is not the same as value. Look at the tree beneath the presentation.",
        sections: [
            MaterialKnowledgeSection(
                id: "imported",
                heading: "Imported material",
                paragraphs: [
                    "Buying trees across borders may involve plant health, import regulations, quarantine requirements, documentation and pests.",
                    "Check current local regulations. This chapter does not make legal claims that vary by country."
                ],
                bullets: [],
                callouts: []
            ),
            MaterialKnowledgeSection(
                id: "finished",
                heading: "Buying finished bonsai",
                paragraphs: [
                    "Purchasing an advanced bonsai can provide a mature trunk, developed ramification, established design and reduced development time. Evaluate health, root condition, design quality and long-term maintenance requirements.",
                    "Do not judge value based only on age claims, pot, price or seller reputation."
                ],
                bullets: [],
                callouts: []
            ),
            MaterialKnowledgeSection(
                id: "value",
                heading: "Price is not the same as value",
                paragraphs: [
                    "Value may depend on species, trunk quality, nebari, age characteristics, branch development, health, rarity, provenance and artist involvement.",
                    "A higher price does not automatically mean better material for the user's goals."
                ],
                bullets: [],
                callouts: []
            ),
            MaterialKnowledgeSection(
                id: "skill",
                heading: "Buying for your skill level",
                paragraphs: [
                    "A beginner may be better served by forgiving material. An advanced tree may require precise care.",
                    "Buying a highly refined bonsai without understanding its needs can create stress for the owner and risk for the tree."
                ],
                bullets: [],
                callouts: []
            ),
            MaterialKnowledgeSection(
                id: "red-flags",
                heading: "Red flags when buying",
                paragraphs: [
                    "A red flag does not always make a tree worthless. The buyer should understand the problem before paying."
                ],
                bullets: [
                    "Severe inverse taper",
                    "Poor trunk base",
                    "Serious root defects",
                    "Weak health",
                    "Pest infestation",
                    "Suspiciously artificial styling",
                    "Major hidden scars",
                    "Poor graft unions where relevant"
                ],
                callouts: []
            ),
            MaterialKnowledgeSection(
                id: "presentation",
                heading: "Look beyond presentation",
                paragraphs: [
                    "Sellers may improve presentation through foliage arrangement, moss, temporary wiring and pot choice. Evaluate the tree beneath the presentation.",
                    "Do not assume presentation is deceptive. Simply look deeper."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )

    // MARK: - 13 Time & Planning

    private static let timeAndPlanning = MaterialKnowledgeLesson(
        id: "time",
        number: 13,
        title: "Time & Planning",
        summary: "Price can be paid once. Development time is paid every season.",
        sections: [
            MaterialKnowledgeSection(
                id: "years",
                heading: "How many years are you buying?",
                paragraphs: [
                    "Ask what must still be developed: trunk, taper, primary branches, secondary branches, ramification, roots. The true cost of material includes time."
                ],
                bullets: [],
                callouts: [
                    MaterialKnowledgeCallout(
                        id: "time-cost",
                        title: "Bonsai World principle",
                        body: "Price can be paid once. Development time is paid every season."
                    )
                ]
            ),
            MaterialKnowledgeSection(
                id: "planning",
                heading: "Know what you want to build",
                paragraphs: [
                    "Before buying material, consider desired style, desired tree size, species characteristics, available space and available time.",
                    "Do not buy material simply because it might become something."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )

    // MARK: - 14 Learning & Advanced

    private static let learningAndAdvanced = MaterialKnowledgeLesson(
        id: "learning-advanced",
        number: 14,
        title: "Learning & Advanced Material",
        summary: "Cheap does not mean useless. Exceptional material saves years. It does not eliminate the need for skill.",
        sections: [
            MaterialKnowledgeSection(
                id: "learning",
                heading: "Material for learning",
                paragraphs: [
                    "Inexpensive material is valuable for learning pruning, wiring, repotting and development. A tree does not need to become an exhibition bonsai to be a successful learning project."
                ],
                bullets: [],
                callouts: []
            ),
            MaterialKnowledgeSection(
                id: "advanced",
                heading: "Material for advanced development",
                paragraphs: [
                    "Advanced artists may prioritise exceptional trunks, strong nebari, mature bark and unique movement. Advanced material can save years. It does not eliminate the need for skill."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )

    // MARK: - 15 Practice

    private static let practice = MaterialKnowledgeLesson(
        id: "practice",
        number: 15,
        title: "Practice",
        summary: "The best material is often recognised before it looks like bonsai. Do not buy until you know why.",
        sections: [
            MaterialKnowledgeSection(
                id: "mistakes",
                heading: "Common beginner mistakes",
                paragraphs: [
                    "Buying foliage instead of trunk. Choosing the first tree available. Ignoring nebari. Buying unhealthy material because the price is low. Buying material without a development plan.",
                    "Believing pre-bonsai automatically means quality. Underestimating development time. Buying advanced trees beyond current care ability. Collecting material illegally. Ignoring species suitability for the local climate.",
                    "Styling immediately after collection. Assuming new growth means complete recovery. Repeatedly disturbing the root environment. Applying a universal watering formula. Comparing recovery timelines between different trees. Performing several major interventions before recovery is established. Removing future design options too early. Trying to create a finished bonsai during the first development stage. Confusing patience with inaction — observation is active work."
                ],
                bullets: [],
                callouts: []
            ),
            MaterialKnowledgeSection(
                id: "advanced-seeing",
                heading: "Seeing the tree that does not exist yet",
                paragraphs: [
                    "Advanced artists evaluate current structure, potential structure and future structure. They may see a future apex, trunk line or branch inside material that currently appears unremarkable.",
                    "This skill develops through experience, observation and comparison."
                ],
                bullets: [],
                callouts: [
                    MaterialKnowledgeCallout(
                        id: "before-it-looks",
                        title: "Bonsai World principle",
                        body: "The best material is often recognised before it looks like bonsai."
                    )
                ]
            ),
            MaterialKnowledgeSection(
                id: "framework",
                heading: "Practical material evaluation framework",
                paragraphs: [
                    "Check health first. Imagine at least two possible future designs. Do not buy until you know why."
                ],
                bullets: [
                    "Check health.",
                    "Expose and evaluate the trunk base where possible.",
                    "Study the trunk.",
                    "Evaluate taper.",
                    "Evaluate movement.",
                    "Inspect branch potential.",
                    "Consider root potential.",
                    "Imagine at least two possible future designs.",
                    "Estimate development time.",
                    "Compare value against your goals.",
                    "Do not buy until you know why."
                ],
                callouts: []
            ),
            MaterialKnowledgeSection(
                id: "recovery-framework",
                heading: "Yamadori recovery decision framework",
                paragraphs: [
                    "Before a major decision on collected material, walk these questions. If the work could wait and still be done with more information, waiting may be the stronger decision."
                ],
                bullets: [
                    "What is the tree's current biological priority?",
                    "Is the root system sufficiently established?",
                    "Is growth consistent over time?",
                    "Would this work improve recovery, or simply satisfy impatience?",
                    "What additional stress will this intervention create?",
                    "Does this species respond in a predictable way?",
                    "What important natural character must be preserved?",
                    "Could this decision be made later with more information?"
                ],
                callouts: []
            ),
            MaterialKnowledgeSection(
                id: "paths",
                heading: "Beginner, intermediate and advanced",
                paragraphs: [
                    "Beginner — nursery stock; young material; learning projects; basic evaluation. For collected material: prioritise survival, avoid unnecessary work, observe recovery, and understand that time is part of the process.",
                    "Intermediate — pre-bonsai; better trunk selection; air layers; project planning; recovery assessment, environmental judgement, early structural planning and recognition of biological readiness.",
                    "Advanced — exceptional material; yamadori; advanced pre-bonsai; long-term artistic projects; long-term yamadori planning, preservation of natural character, and integration of roots, trunk, deadwood and design."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )

    // MARK: - 16 Quick Guides

    private static let quickGuides = MaterialKnowledgeLesson(
        id: "quick-guides",
        number: 16,
        title: "Quick Guides",
        summary: "Recognising potential is often the first act of creation.",
        sections: [
            MaterialKnowledgeSection(
                id: "cards",
                heading: "Knowledge cards",
                paragraphs: [],
                bullets: [],
                callouts: [
                    MaterialKnowledgeCallout(
                        id: "card-future",
                        title: "Buy the future",
                        body: "Evaluate what the tree can become."
                    ),
                    MaterialKnowledgeCallout(
                        id: "card-trunk",
                        title: "The trunk matters",
                        body: "Foliage can change quickly. Trunk development takes time."
                    ),
                    MaterialKnowledgeCallout(
                        id: "card-base",
                        title: "Check the base",
                        body: "Look beneath the surface before judging the tree."
                    ),
                    MaterialKnowledgeCallout(
                        id: "card-health",
                        title: "Health first",
                        body: "Potential is worthless if the tree cannot recover."
                    ),
                    MaterialKnowledgeCallout(
                        id: "card-time",
                        title: "Time has value",
                        body: "Years of development are part of the true cost."
                    ),
                    MaterialKnowledgeCallout(
                        id: "card-survival",
                        title: "Survival first",
                        body: "A collected tree is not ready simply because it looks interesting."
                    ),
                    MaterialKnowledgeCallout(
                        id: "card-pattern",
                        title: "Do not read one signal",
                        body: "Recovery is a pattern over time."
                    ),
                    MaterialKnowledgeCallout(
                        id: "card-stable",
                        title: "Keep the environment stable",
                        body: "Do not ask a recovering tree to adapt repeatedly."
                    ),
                    MaterialKnowledgeCallout(
                        id: "card-wait",
                        title: "Do not style impatience",
                        body: "Wait until the tree is ready."
                    ),
                    MaterialKnowledgeCallout(
                        id: "card-preserve",
                        title: "Preserve the reason",
                        body: "The features that made the yamadori special may be the features most worth protecting."
                    )
                ]
            ),
            MaterialKnowledgeSection(
                id: "connections",
                heading: "Connections to other Bonsai World knowledge",
                paragraphs: [
                    "Propagation — seeds, seedlings and cuttings as starting material. Nursery → Seeds and Nursery → Cuttings are the practical surfaces.",
                    "Air Layering — creating a new tree from existing material.",
                    "Seed Stratification — seed storage, treatment and germination.",
                    "Nursery — Seeds and Cuttings as practical surfaces in the programme.",
                    "Yamadori — trips, finds and recovery records. Recovery lessons in this chapter cover the living tree after it is already collected.",
                    "Deadwood — natural character, existing scars and whether history should be preserved rather than improved.",
                    "Design Guidelines — evaluating trunk and branch potential.",
                    "Bonsai Forms, Styles & Silhouette — what direction the material suggests before a named style is applied.",
                    "Bonsai Artistry & the Bonsai Eye — recognising a convincing tree in the material you have.",
                    "Repotting — root development after acquisition.",
                    "Species Library — species-specific recovery behaviour, growth characteristics and environmental requirements.",
                    "Tree Health — material inspection before purchase.",
                    "Bonsai Collection Management — intake, quarantine and whether the collection can absorb another tree."
                ],
                bullets: [],
                callouts: []
            ),
            MaterialKnowledgeSection(
                id: "evaluator",
                heading: "Future: Material Evaluator",
                paragraphs: [
                    "A future tool could let the user document species, source, trunk diameter, height, nebari and current development stage, then guide potential evaluation with questions: where is the strongest trunk line, which branches are useful, what is the likely future height, how many years of development remain.",
                    "The goal is helping the user learn to evaluate. Not automatically rating trees."
                ],
                bullets: [],
                callouts: []
            ),
            MaterialKnowledgeSection(
                id: "philosophy",
                heading: "Bonsai World philosophy",
                paragraphs: [
                    "A bonsai project begins long before the first wire is applied. It begins when you choose what is worth developing. For yamadori, the future bonsai also begins with what happens after collection. The first responsibility is not to reveal everything. It is to protect what is alive.",
                    "Observe the tree. Allow recovery. Preserve its character. Then begin development. The strongest first styling decision is sometimes the decision not to style yet. The experienced artist does not only see the tree that exists today. They see the trunk that can become visible, the branches that can be grown, the roots that can be developed, and the years that will pass."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )
}
