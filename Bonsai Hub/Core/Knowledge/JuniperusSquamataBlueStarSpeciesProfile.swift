//
//  JuniperusSquamataBlueStarSpeciesProfile.swift
//  Bonsai World
//
//  Species Profile — Juniperus squamata 'Blue Star' (Blue Star Juniper).
//  Independent Bonsai World profile for a cultivar of Juniperus squamata.
//  Knowledge status: Reviewed (complete editorial content).
//

import Foundation

enum JuniperusSquamataBlueStarSpeciesProfile {
    static let parentSpeciesName = "Juniperus squamata"
    static let cultivarName = "Blue Star"
    /// Scientific name for Species Profile display.
    static let scientificName = "Juniperus squamata 'Blue Star'"

    static var profile: SpeciesProfile {
        SpeciesProfile(
            speciesID: BotanicalKnowledgeIDs.juniperusSquamata,
            cultivarID: BotanicalKnowledgeIDs.juniperusSquamataBlueStar,
            scientificName: scientificName,
            commonNames: ["Blue Star Juniper"],
            family: "Cupressaceae",
            plantType: "Evergreen conifer",
            originSummary: "Cultivated selection of Juniperus squamata, a species native across a broad mountainous region from Afghanistan and the Himalayas through parts of Pakistan, Nepal, Bhutan, northern India, Myanmar and China",
            knowledgeStatus: .reviewed,
            traits: traits,
            foliageSizeLabel: "Foliage",
            foliageReductionLabel: "Foliage management",
            summaryLine: "Evergreen · Compact growth · Blue-grey needle foliage · Slow growth · Suitable for small bonsai",
            attentionHighlights: [
                "Slow growth — allow sufficient time for structural development",
                "Compact foliage — avoid creating excessive density",
                "Blue-grey colour — maintain strong outdoor light and overall health",
                "Limited back-budding from bare wood — preserve foliage on branches intended to survive",
                "Slow trunk development — plan trunk and branch structure early",
                "Dense growth — monitor interior foliage and airflow",
                "Shallow pots — monitor drying and winter root exposure",
                "Slow recovery — avoid unnecessary aggressive root or foliage reduction",
            ],
            sections: sections,
            principleNote: """
            Blue Star Juniper is a compact, slow-growing cultivar. Its strengths and limitations are different from more vigorous junipers commonly used for rapid bonsai development.

            Its naturally dense growth, compact foliage and blue-grey colour can make it highly attractive for refined and smaller bonsai. However, slow growth means that trunk development, branch replacement and structural correction can require considerably more patience.

            The species profile provides guidance about the general tendencies of Juniperus squamata 'Blue Star'. Individual trees must still be managed according to their health, development stage, root condition, environment, climate and current growth.

            The species profile should support decisions. It should never replace observation of the individual tree.
            """,
            sourcesNote: """
            Profile content is synthesised from recognised botanical and horticultural authorities into Bonsai World editorial language.

            Botanical taxonomy and natural distribution for the parent species may draw on Royal Botanic Gardens, Kew (Plants of the World Online), World Flora Online and Flora of China. Horticultural cultivar context may draw on the Royal Horticultural Society. Bonsai-specific management draws on established bonsai horticultural references for general juniper cultivation, applied carefully to this slow, compact selection.

            Botanical taxonomy and natural distribution must be separated from cultivar-specific horticultural characteristics. Do not present general juniper care as though every detail is uniquely specific to Blue Star. Do not copy source wording.
            """
        )
    }

    private static let traits = SpeciesProfileTraits(
        deciduous: false,
        growthStrength: "Moderate",
        growthSpeed: "Slow",
        leafSize: "Small, naturally compact needle foliage",
        foliageReduction: "Preserve viable foliage — manage density carefully",
        ramificationPotential: "Moderate to High potential",
        backBudding: "Limited — do not rely on budding from bare wood",
        rootDevelopment: "Moderate",
        nebariPotential: "Moderate potential",
        trunkDevelopment: "Slow",
        barkDevelopment: "Character develops slowly with age",
        wiring: "Suitable — monitor carefully and protect brittle or stressed branches",
        defoliation: "Not suitable",
        airLayering: "Possible on suitable material — consider carefully",
        threadGrafting: "Not normally a primary technique",
        rootGrafting: "Where appropriate for structural correction",
        beginnerSuitability: "Moderate",
        bonsaiSuitability: "Good to Excellent",
        difficulty: "Intermediate",
        winterDormancyRequired: true,
        winterHardiness: "High — outdoor evergreen",
        rootFrostSensitivity: "Significant in shallow bonsai containers"
    )

    private static var sections: [SpeciesProfileSection] {
        [
            SpeciesProfileSection(
                id: "taxonomic-context",
                title: "Taxonomic Context",
                paragraphs: [
                    "Juniperus squamata 'Blue Star' is a cultivar / horticultural selection of Juniperus squamata.",
                    "Profile type: Cultivar / Horticultural Selection. It is not a separate botanical species and must not be described as Juniperus chinensis.",
                    "Parent species: Juniperus squamata, family Cupressaceae.",
                    "The botanical species Juniperus squamata is native across a broad mountainous region extending from Afghanistan and the Himalayas through parts of Pakistan, Nepal, Bhutan, northern India, Myanmar and China.",
                    "'Blue Star' is a cultivated selection and is not a naturally occurring separate species.",
                    "Bonsai World may publish an independent Species Profile for a distinct cultivar when growth character, foliage behaviour or bonsai management differ enough to justify separate guidance.",
                ]
            ),
            SpeciesProfileSection(
                id: "overview",
                title: "Species Overview",
                paragraphs: [
                    "Juniperus squamata 'Blue Star' is a compact evergreen juniper cultivar valued for its dense growth and distinctive blue-grey needle foliage.",
                    "Unlike many vigorous junipers used primarily for rapid trunk development, Blue Star naturally grows slowly and forms a compact, dense structure. This can be advantageous for smaller bonsai and refined compositions where coarse growth is undesirable.",
                    "Its foliage is needle-like rather than the mature scale foliage associated with many Chinese junipers. The foliage is generally stiff and pointed, contributing to a strong visual texture.",
                    "As bonsai material, Blue Star is particularly useful where the objective is compactness, colour and controlled refinement rather than rapid development of a large trunk.",
                    "Its slower growth should be considered both an advantage and a limitation.",
                ],
                bullets: [
                    "Naturally compact growth",
                    "Distinctive blue-grey foliage",
                    "Small foliage mass suitable for smaller bonsai",
                    "Dense branching potential",
                    "Evergreen character",
                    "Strong visual texture",
                    "Good potential for refined compact designs",
                    "Suitable for long-term container cultivation when root health is maintained",
                    "Slow trunk development",
                    "Slow replacement of lost branches",
                    "Limited recovery potential from completely bare branches",
                    "Structural mistakes may take longer to correct",
                    "Dense foliage can reduce interior light and airflow",
                    "Root health is critical in small containers",
                ]
            ),
            SpeciesProfileSection(
                id: "natural-growth",
                title: "Natural Growth",
                paragraphs: [
                    "The botanical species Juniperus squamata occurs naturally as a shrub, spreading plant or small tree depending on location and growing conditions.",
                    "Blue Star is a compact cultivated selection with a naturally dense and dwarf habit.",
                    "Growth is generally slow compared with many commonly used bonsai junipers. This has important consequences for bonsai development.",
                    "During development, the grower should not expect rapid increases in trunk diameter or aggressive extension growth. Strong development requires patience and sufficient growing conditions.",
                    "The objective should be to use healthy growth efficiently rather than repeatedly restricting the tree. Because growth is slow, unnecessary pruning can delay development significantly.",
                    "During refinement, the naturally compact habit can become an advantage, but dense foliage must still be managed carefully to maintain light penetration and airflow.",
                ]
            ),
            SpeciesProfileSection(
                id: "foliage",
                title: "Foliage",
                paragraphs: [
                    "Blue Star has distinctive needle-like foliage with a blue-grey to silvery-blue appearance. The foliage is naturally compact and dense.",
                    "This gives the cultivar a strong visual identity and can make it particularly attractive for bonsai compositions where foliage colour is an important design feature.",
                    "The foliage should not be treated as a static colour. Colour can vary according to light exposure, season, tree health, nutrition, temperature, water availability, stress, and the balance of new growth and mature foliage.",
                    "Healthy foliage should be maintained throughout the structure. Do not assume that a branch will reliably produce new growth from completely bare old wood.",
                    "When pruning junipers, foliage should therefore normally remain on branches that are intended to survive.",
                    "Dense foliage pads should be managed carefully. The objective is not simply to make the tree as dense as possible.",
                    "Good foliage management should maintain light penetration, air movement, interior foliage health, clear branch structure and balanced vigour.",
                ]
            ),
            SpeciesProfileSection(
                id: "flowers-seeds",
                title: "Flowers & Seeds",
                paragraphs: [
                    "Junipers reproduce through separate male and female reproductive structures.",
                    "Seed production is not normally important for bonsai development of Blue Star.",
                    "As a named cultivar, Blue Star should normally be propagated vegetatively when the objective is to preserve the characteristics associated with the cultivar.",
                    "Seed propagation does not reliably reproduce the cultivar.",
                    "Detailed reproductive propagation procedures should be maintained in Bonsai World Propagation Knowledge Articles rather than duplicated here.",
                ]
            ),
            SpeciesProfileSection(
                id: "bark-trunk",
                title: "Bark & Trunk",
                paragraphs: [
                    "Blue Star is primarily valued for its compact foliage and colour rather than for rapid trunk production.",
                    "Young material may have relatively fine stems and branches. The trunk can eventually develop character, but significant trunk thickening generally requires considerably more time than with vigorous juniper material.",
                    "Development strategy should therefore be realistic.",
                    "Useful approaches may include extended cultivation periods, larger development containers, controlled sacrifice growth where appropriate, allowing selected structural branches to extend, avoiding unnecessary repeated pruning, and returning to refinement only after sufficient structural development has been achieved.",
                    "The slow growth rate means that Blue Star is generally better suited to smaller bonsai sizes unless substantial development time is available.",
                ]
            ),
            SpeciesProfileSection(
                id: "roots-nebari",
                title: "Roots & Nebari",
                paragraphs: [
                    "Root development should be managed carefully from an early stage.",
                    "Blue Star can develop a usable root system for bonsai, but its slower growth means that root development should not be unnecessarily restricted.",
                    "The objective should be a healthy, stable and balanced root system. Nebari potential is moderate.",
                    "Good nebari should be developed gradually through early root selection, radial root positioning where possible, appropriate container development, avoiding repeated excessive root reduction, and maintaining strong root health between operations.",
                    "A slow-growing cultivar should not be treated as though it can rapidly replace lost roots. Root work should therefore remain proportionate to the health and strength of the individual tree.",
                ]
            ),
            SpeciesProfileSection(
                id: "light",
                title: "Light",
                paragraphs: [
                    "Blue Star generally performs best in strong outdoor light.",
                    "A sunny position supports compact growth, strong foliage colour, healthy growth and better interior foliage development.",
                    "The tree should remain outdoors. It is not an indoor bonsai.",
                    "Strong sun can generally be beneficial for a healthy, established tree, but the individual tree's condition must always be considered.",
                    "Recently repotted, weakened or otherwise stressed trees may require different management from strong, established trees.",
                    "Light requirements should always be interpreted together with temperature, wind, root condition, container size, water availability and recent work.",
                    "Species information is guidance, not a replacement for observing the individual tree.",
                ]
            ),
            SpeciesProfileSection(
                id: "wind",
                title: "Wind",
                paragraphs: [
                    "Blue Star is an outdoor juniper, but wind increases transpiration and can increase water demand.",
                    "Particular attention should be given to small containers, shallow pots, recently repotted trees, trees with reduced root systems, hot weather and strong drying winds.",
                    "Strong wind can also affect wired branches and dense foliage.",
                    "The objective is not necessarily to eliminate wind exposure, but to understand its effect on water demand and tree condition.",
                ]
            ),
            SpeciesProfileSection(
                id: "watering",
                title: "Watering",
                paragraphs: [
                    "Blue Star should not remain permanently wet.",
                    "General principle: moist when required, well drained, never managed by a fixed watering timetable.",
                    "Juniper roots require oxygen. A substrate that remains constantly saturated can increase the risk of root problems.",
                    "Watering frequency should depend on weather, temperature, wind, sun exposure, container size, substrate structure, root mass, tree health, development stage and seasonal activity.",
                    "Do not water according to the clock. Water according to the condition of the tree and substrate.",
                    "A healthy tree in a fast-draining substrate may require very different watering from a recently repotted tree in a larger container.",
                ]
            ),
            SpeciesProfileSection(
                id: "soil",
                title: "Soil",
                paragraphs: [
                    "Blue Star benefits from a stable, well-draining bonsai substrate with good aeration around the roots.",
                    "Important characteristics include good drainage, good aeration, stable particle structure, appropriate water retention and a healthy root environment.",
                    "The ideal substrate depends on local climate, rainfall, temperature, wind exposure, pot size, development stage, root condition and watering routine.",
                    "Bonsai World does not prescribe one universal soil recipe for this cultivar.",
                    "Because Blue Star is slow growing, maintaining long-term root health and substrate stability is particularly important.",
                ]
            ),
            SpeciesProfileSection(
                id: "fertilizing",
                title: "Fertilizing",
                paragraphs: [
                    "Blue Star should be fertilized according to the tree being developed rather than according to the assumption that all junipers require identical feeding.",
                    "A healthy tree in active development may benefit from stronger nutritional support than a refined tree where compact growth is preferred.",
                    "Fertilization should depend on tree health, development stage, current growth, season, root condition and recent work.",
                    "During development, nutrition can support root and structural growth. During refinement, fertilization should support health without unnecessarily encouraging coarse or unbalanced growth.",
                    "A weak or recently disturbed tree should not automatically receive stronger fertilizer simply because the species is capable of growth.",
                    "Feed the tree you are growing.",
                ]
            ),
            SpeciesProfileSection(
                id: "pruning",
                title: "Pruning",
                paragraphs: [
                    "Pruning should respect the limited ability of junipers to regenerate growth from completely bare wood.",
                    "Do not repeatedly cut branches back into foliage-free sections unless there is a clear understanding of the likely result.",
                    "Maintain foliage on branches that are intended to survive.",
                    "Because Blue Star grows slowly, unnecessary pruning can delay development.",
                    "During development: allow selected growth to extend where additional thickness or structural development is required.",
                    "During refinement: pruning can be used to maintain compactness, branch hierarchy, silhouette, light penetration, airflow and foliage pad structure.",
                    "Avoid treating the foliage like a hedge. The objective is not to shear the entire surface uniformly.",
                    "Individual shoot and foliage management should preserve healthy interior growth and clear branch structure.",
                ]
            ),
            SpeciesProfileSection(
                id: "back-budding",
                title: "Back-budding",
                paragraphs: [
                    "Back-budding potential should be considered limited and dependent on existing foliage and healthy growth.",
                    "Blue Star should not be managed with the assumption that bare old wood will reliably produce new shoots.",
                    "This is one of the most important structural principles for the cultivar.",
                    "Before removing a branch or major foliage section, consider whether replacement growth already exists.",
                    "Do not create irreversible bare sections through repeated aggressive pruning.",
                ]
            ),
            SpeciesProfileSection(
                id: "ramification",
                title: "Ramification",
                paragraphs: [
                    "Blue Star has good potential for dense compact branching, particularly when healthy and managed with patience.",
                    "The slow growth rate means that fine structure may develop gradually.",
                    "Ramification should be built through maintaining healthy foliage, preserving interior growth, selective pruning, controlled extension, wiring where appropriate, and avoiding unnecessary repeated removal of productive shoots.",
                    "The objective should be functional ramification with healthy interior growth rather than maximum foliage density.",
                ]
            ),
            SpeciesProfileSection(
                id: "wiring",
                title: "Wiring",
                paragraphs: [
                    "Blue Star can be wired successfully.",
                    "Because growth is relatively slow, branches may retain wire for longer than on very vigorous species, but this should never be assumed. Wire should still be monitored regularly.",
                    "Important considerations include branch flexibility, branch age, existing stress, deadwood, tight bends, wire pressure and seasonal growth.",
                    "Older branches may become less flexible and can break if bent aggressively. Use gradual movement where necessary.",
                    "Protect branches appropriately when stronger bends are required.",
                    "The objective is controlled positioning, not forcing a branch beyond its natural capacity.",
                ]
            ),
            SpeciesProfileSection(
                id: "defoliation",
                title: "Defoliation",
                paragraphs: [
                    "Defoliation is not a suitable routine technique for Blue Star.",
                    "Juniper foliage is essential to the health and energy production of the tree.",
                    "Foliage management should instead focus on selective thinning, removal of unwanted shoots, maintaining light penetration, preserving healthy interior foliage and balancing vigour.",
                    "Do not remove large amounts of healthy foliage simply to imitate techniques used on deciduous bonsai.",
                ]
            ),
            SpeciesProfileSection(
                id: "repotting",
                title: "Repotting",
                paragraphs: [
                    "Repotting frequency should depend on root development, pot size, substrate condition, tree health, development stage and climate.",
                    "A young development tree may require different root management from a mature refined bonsai.",
                    "Root work should be proportionate. Blue Star should not be treated as a fast-growing species capable of immediately replacing an aggressively reduced root system.",
                    "Repot when the root system and substrate indicate that work is appropriate.",
                    "Use species-specific seasonal timing as guidance, not as an automatic calendar rule.",
                ]
            ),
            SpeciesProfileSection(
                id: "trunk-development",
                title: "Trunk Development",
                paragraphs: [
                    "Trunk development is one of the principal limitations of Blue Star.",
                    "The cultivar's naturally slow and compact growth means that significant trunk thickening requires time.",
                    "During development: provide sufficient growing space, maintain strong root health, allow selected extension growth, avoid excessive repeated pruning, use sacrifice growth where appropriate, and maintain a clear long-term development plan.",
                    "Blue Star is generally more naturally suited to smaller bonsai than to rapid development of large bonsai.",
                    "A small, well-proportioned tree can often make better use of the cultivar's natural characteristics than an attempt to force rapid large-scale development.",
                ]
            ),
            SpeciesProfileSection(
                id: "nebari-development",
                title: "Nebari Development",
                paragraphs: [
                    "Nebari should be developed gradually.",
                    "Useful objectives include radial root distribution, a stable trunk base, surface root visibility and a proportionate transition from roots to trunk.",
                    "Because development is relatively slow, root corrections should be planned carefully.",
                    "The objective is not simply to create many roots. The objective is a balanced root structure that supports both health and visual stability.",
                ]
            ),
            SpeciesProfileSection(
                id: "grafting",
                title: "Grafting",
                paragraphs: [
                    "Grafting is not normally a primary technique for Blue Star bonsai.",
                    "Potential uses may include structural correction where appropriate, but grafting should not be treated as a routine requirement.",
                    "Detailed grafting procedures should be maintained separately in Bonsai World Propagation Knowledge Articles.",
                    "Any graft performed on an individual tree should be documented in Shaping History.",
                ]
            ),
            SpeciesProfileSection(
                id: "air-layering",
                title: "Air Layering",
                paragraphs: [
                    "Air layering may be possible on suitable material, but success depends heavily on tree health, timing, branch characteristics, technique and subsequent aftercare.",
                    "Because Blue Star is slow growing, air layering should be considered carefully and not treated as a universal shortcut for propagation or structural development.",
                    "Detailed procedures belong in Propagation Knowledge Articles.",
                ]
            ),
            SpeciesProfileSection(
                id: "propagation",
                title: "Propagation",
                paragraphs: [
                    "Blue Star should normally be propagated vegetatively when the objective is to preserve the characteristics of the named cultivar.",
                    "Suitable propagation methods may include cuttings.",
                    "Seed propagation should not be expected to reliably reproduce the Blue Star cultivar.",
                    "Detailed procedures should be maintained in Bonsai World Propagation Knowledge Articles and linked from this profile rather than duplicated here.",
                ]
            ),
            SpeciesProfileSection(
                id: "pests",
                title: "Pests & Problems",
                paragraphs: [
                    "Potential problems can include spider mites, scale insects, aphids, caterpillars, root problems associated with excessive moisture, Phytophthora and other root-related diseases, canker, fungal problems encouraged by poor airflow and unsuitable growing conditions, and interior foliage decline caused by excessive density and insufficient light.",
                    "Dense foliage should be monitored carefully. The goal is to maintain good airflow, light penetration, healthy interior foliage, appropriate watering and stable root conditions.",
                    "Diagnosis and treatment knowledge should be maintained separately in Care → Pest Management and linked here.",
                    "Prefer specific problem profiles rather than one undifferentiated list.",
                ]
            ),
            SpeciesProfileSection(
                id: "seasonal",
                title: "Seasonal Profile",
                paragraphs: [
                    "Spring: an important period for renewed activity. Monitor root activity, new growth, water demand, fertilization needs, wire condition and pest activity. Avoid assuming that all trees are equally strong simply because the season has changed. Recently repotted or weakened trees require individual management.",
                    "Summer: focus on water demand, heat, strong light, wind exposure, foliage health and pest monitoring. A compact bonsai in a shallow container can dry significantly faster during warm or windy conditions. Monitor substrate condition rather than following a fixed watering schedule.",
                    "Autumn: a transition period. Growth generally slows. Continue to monitor foliage health, water demand, root condition, wire and pest activity. Prepare the tree gradually for winter rather than making unnecessary late-season structural interventions.",
                    "Winter: Blue Star is an outdoor conifer and requires winter dormancy. The principal bonsai concern is often protection of the root system rather than simply the foliage.",
                    "Shallow containers expose roots to greater temperature variation than trees growing in the ground. Winter protection should depend on temperature, duration of freezing, wind, pot size, root condition, local climate and tree health.",
                    "Do not use one universal temperature threshold for every tree and every location.",
                ]
            ),
            SpeciesProfileSection(
                id: "styles",
                title: "Bonsai Styles",
                paragraphs: [
                    "Blue Star is particularly suitable for compact bonsai compositions.",
                    "Potential styles include informal upright, slanting, semi-cascade, cascade where suitable material exists, compact naturalistic forms and small group plantings.",
                    "The final style should be determined by the individual material. Do not force every Blue Star into the same design.",
                    "The natural compactness of the cultivar should be used as an advantage.",
                ]
            ),
            SpeciesProfileSection(
                id: "tree-stage",
                title: "Development by Tree Stage",
                paragraphs: [
                    "Cutting / young material: establish strong roots, build health, develop early trunk movement, select primary structure and avoid unnecessary restriction.",
                    "Nursery material: evaluate existing trunk and branch structure, improve root direction, identify design potential, preserve useful branches and begin long-term structural planning.",
                    "Pre-bonsai: establish trunk line, develop primary branches, improve root structure, build branch hierarchy and begin controlled ramification.",
                    "In training: refine branch placement, improve ramification, maintain foliage health, develop silhouette, use controlled wiring and continue trunk development only where still required.",
                    "Refinement: preserve compact growth, maintain interior foliage, improve branch structure, control density, maintain colour and health and avoid unnecessary coarse growth.",
                    "Exhibition / mature bonsai: maintain health, preserve established design, maintain foliage structure, avoid unnecessary major intervention and continue regular monitoring.",
                ]
            ),
            SpeciesProfileSection(
                id: "attention",
                title: "Cultivar-Specific Attention",
                paragraphs: [
                    "These attention points are tendencies Bonsai World can use operationally. They must still be interpreted for the individual tree.",
                ],
                bullets: [
                    "Slow growth — allow sufficient time for structural development",
                    "Compact foliage — avoid creating excessive density",
                    "Blue-grey colour — maintain strong outdoor light and overall health",
                    "Limited back-budding from bare wood — preserve foliage on branches intended to survive",
                    "Slow trunk development — plan trunk and branch structure early",
                    "Dense growth — monitor interior foliage and airflow",
                    "Shallow pots — monitor drying and winter root exposure",
                    "Slow recovery — avoid unnecessary aggressive root or foliage reduction",
                ]
            ),
        ]
    }
}
