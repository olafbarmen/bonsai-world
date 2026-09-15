//
//  JuniperusChinensisKishuSpeciesProfile.swift
//  Bonsai World
//
//  Species Profile — Juniperus chinensis 'Kishu' (Kishu Juniper).
//  Independent Bonsai World profile for a Japanese horticultural selection
//  associated with Juniperus chinensis. Separate from Itoigawa and Shimpaku.
//  Knowledge status: Reviewed (complete editorial content).
//

import Foundation

enum JuniperusChinensisKishuSpeciesProfile {
    static let parentSpeciesName = "Juniperus chinensis"
    static let cultivarName = "Kishu"
    /// Scientific name for Species Profile display.
    static let scientificName = "Juniperus chinensis 'Kishu'"

    static var profile: SpeciesProfile {
        SpeciesProfile(
            speciesID: BotanicalKnowledgeIDs.juniperusChinensis,
            cultivarID: BotanicalKnowledgeIDs.juniperusChinensisKishu,
            scientificName: scientificName,
            commonNames: ["Kishu Juniper"],
            family: "Cupressaceae",
            plantType: "Evergreen conifer",
            originSummary: "Japanese horticultural selection associated with Juniperus chinensis",
            knowledgeStatus: .reviewed,
            traits: traits,
            foliageSizeLabel: "Foliage",
            foliageReductionLabel: "Foliage management",
            summaryLine: "Evergreen · Fine scale foliage · Compact growth · Dense ramification · Excellent bonsai refinement potential",
            attentionHighlights: [
                "Fine compact foliage is a primary strength",
                "Excellent ramification potential",
                "Avoid premature refinement during structural development",
                "Dense foliage requires interior light and airflow management",
                "Preserve viable foliage on branches intended to survive",
                "Do not assume reliable growth from completely bare old wood",
                "Strong outdoor light supports foliage quality",
                "Avoid permanently wet substrate",
                "Use wiring carefully on fine branches",
                "Do not use deciduous defoliation techniques",
                "Protect shallow roots during severe winter conditions",
                "Do not move indoors for routine winter care",
            ],
            sections: sections,
            principleNote: """
            Kishu is highly valued as bonsai material because of its compact foliage, fine ramification potential and suitability for refined branch development.

            Its characteristics make it particularly useful for detailed bonsai work. However, compact foliage should not automatically be interpreted as a reason to constantly prune the tree. Premature refinement can weaken development.

            Dense foliage can also reduce interior light, reduce airflow, weaken interior shoots, hide branch structure and create long-term structural problems if not managed carefully.

            The objective is not maximum foliage density. The objective is healthy foliage, functional ramification, clear branch structure and long-term refinement.

            The Species Profile provides general guidance. The individual tree must always be assessed according to health, root condition, development stage, existing foliage, structural maturity, recent work, climate, weather, container size and current vigour.
            """,
            sourcesNote: """
            Profile content is synthesised from recognised botanical and horticultural authorities into Bonsai World editorial language.

            Parent-species context may draw on Royal Botanic Gardens, Kew and recognised botanical databases. Horticultural information about Kishu may draw on Japanese horticultural references where cultivar information can be verified, and on recognised horticultural institutions. Bonsai-specific cultivation draws on established bonsai references for Kishu characteristics.

            Separate verified botanical information about Juniperus chinensis, horticultural information about Kishu, and bonsai-specific cultivation knowledge. Do not merge Kishu with Itoigawa, Shimpaku, Blaauw or other named selections. Do not copy source wording.
            """
        )
    }

    private static let traits = SpeciesProfileTraits(
        deciduous: false,
        growthStrength: "Moderate",
        growthSpeed: "Moderate",
        leafSize: "Evergreen · Fine scale-like foliage · Compact and dense",
        foliageReduction: "Preserve viable foliage — manage density for light and airflow",
        ramificationPotential: "Excellent",
        backBudding: "Moderate — healthy foliage should be retained",
        rootDevelopment: "Good",
        nebariPotential: "Good development potential",
        trunkDevelopment: "Slow to Moderate",
        barkDevelopment: "Character develops with age; refinement often prioritised over rapid trunk",
        wiring: "Excellent suitability",
        defoliation: "Not suitable",
        airLayering: "Where appropriate for the individual material",
        threadGrafting: "May be relevant for structural correction",
        rootGrafting: "Where appropriate",
        beginnerSuitability: "Moderate",
        bonsaiSuitability: "Excellent",
        difficulty: "Intermediate to Advanced",
        winterDormancyRequired: true,
        winterHardiness: "High — outdoor evergreen",
        rootFrostSensitivity: "Moderate to Significant in shallow containers"
    )

    private static var sections: [SpeciesProfileSection] {
        [
            SpeciesProfileSection(
                id: "taxonomic-context",
                title: "Taxonomic Context",
                paragraphs: [
                    "Juniperus chinensis 'Kishu' is a compact Japanese horticultural selection associated with Juniperus chinensis.",
                    "Profile type: Cultivar / Horticultural Selection. It is not a separate botanical species.",
                    "Parent species: Juniperus chinensis, family Cupressaceae.",
                    "Primary Bonsai World display identity: Juniperus chinensis 'Kishu' · Kishu Juniper.",
                    "Kishu must remain a separate operational Species Profile from Itoigawa, Shimpaku, Blaauw and other Juniperus chinensis selections. Do not merge profiles because of related horticultural naming.",
                ]
            ),
            SpeciesProfileSection(
                id: "overview",
                title: "Species Overview",
                paragraphs: [
                    "Juniperus chinensis 'Kishu' is a compact Japanese juniper selection highly regarded for bonsai.",
                    "It is valued particularly for fine scale-like foliage, compact growth, dense ramification potential, suitability for detailed refinement, strong response to careful structural development and good suitability for wiring.",
                    "Kishu is often used where refined foliage structure and compact branching are important.",
                    "It should not be treated as a fast trunk-development cultivar. Its greatest strengths are normally realised when sufficient trunk and primary branch development already exists.",
                    "Do not prematurely refine a tree that still requires substantial structural development. Allow growth where development is required. Control growth where refinement is required.",
                ],
                bullets: [
                    "Evergreen conifer",
                    "Fine scale-like foliage",
                    "Compact growth habit",
                    "Excellent ramification potential",
                    "Highly suitable for refinement",
                    "Good structural wiring potential",
                    "Dense foliage requires interior management",
                    "Healthy foliage must remain on branches intended to survive",
                    "Requires strong outdoor light",
                    "Requires winter dormancy",
                    "Requires a well-drained root environment",
                ]
            ),
            SpeciesProfileSection(
                id: "natural-growth",
                title: "Natural Growth and Vigour",
                paragraphs: [
                    "Kishu generally develops compact and fine growth compared with coarse Juniperus chinensis material.",
                    "Growth strength depends on root development, container size, substrate, light, fertilization, temperature, water availability, climate and development stage.",
                    "During development: allow selected leaders and branches to extend where thickness is required. Do not continually prune every growing point merely to maintain a compact appearance.",
                    "During refinement: use controlled pruning to maintain branch hierarchy, compact proportions, healthy interior foliage, balanced vigour and sustainable ramification.",
                    "The compact character of Kishu should not encourage premature restriction. A tree requiring structural development needs sufficient growth.",
                ]
            ),
            SpeciesProfileSection(
                id: "foliage",
                title: "Foliage",
                paragraphs: [
                    "Kishu is valued for its fine, compact, scale-like evergreen foliage. The foliage is one of the defining characteristics of the selection.",
                    "Healthy foliage management should maintain light penetration, airflow, interior growth, branch visibility and future growing points.",
                    "Dense outer foliage must not permanently shade the interior.",
                    "Do not treat the foliage as a hedge. Do not shear the complete surface uniformly. Instead, manage growth selectively.",
                    "Maintain healthy foliage on branches intended to survive. Do not assume that completely bare old wood will reliably produce new growth.",
                ]
            ),
            SpeciesProfileSection(
                id: "bark-trunk",
                title: "Bark and Trunk",
                paragraphs: [
                    "Kishu is generally valued more for foliage refinement and compact branch development than for rapid trunk production.",
                    "Young material may require significant time before developing a convincing trunk.",
                    "Where substantial trunk development is required, use appropriate development strategies such as extended cultivation, larger development containers, selected sacrifice growth, allowing structural branches to extend and staged pruning.",
                    "Do not remove useful development growth prematurely.",
                    "Once sufficient trunk and primary branch development has been achieved, gradually shift toward refinement.",
                ]
            ),
            SpeciesProfileSection(
                id: "roots-nebari",
                title: "Roots and Nebari",
                paragraphs: [
                    "Good root health is essential for maintaining dense healthy foliage and sustainable ramification.",
                    "Root development objectives include balanced root mass, radial root distribution where possible, stable trunk support, gradual root selection and long-term substrate health.",
                    "Good nebari can be developed through early root selection, appropriate container development and long-term cultivation. Do not promise exceptional nebari automatically.",
                    "Avoid unnecessary aggressive root reduction.",
                ]
            ),
            SpeciesProfileSection(
                id: "light",
                title: "Light",
                paragraphs: [
                    "Kishu should generally be cultivated outdoors with strong light.",
                    "Healthy established trees benefit from substantial outdoor light. Strong light supports healthy foliage, compact growth, balanced vigour and interior development.",
                    "Light management must consider temperature, wind, root condition, recent repotting, water availability, container size and tree health.",
                    "Do not recommend indoor cultivation.",
                ]
            ),
            SpeciesProfileSection(
                id: "wind",
                title: "Wind",
                paragraphs: [
                    "Airflow is important because Kishu can develop dense foliage.",
                    "Benefits include improved airflow, faster drying of foliage and reduced stagnant conditions.",
                    "Wind can also increase transpiration, water demand and winter desiccation risk.",
                    "Pay particular attention to small bonsai, shallow containers, recently repotted trees and exposed growing positions.",
                    "Wind exposure must always be considered together with the tree's total growing environment.",
                ]
            ),
            SpeciesProfileSection(
                id: "watering",
                title: "Watering",
                paragraphs: [
                    "General principle: moist when required, well drained, never permanently saturated.",
                    "Watering frequency depends on weather, temperature, wind, sun exposure, container size, substrate structure, root mass, tree health, development stage and seasonal activity.",
                    "Do not water according to a fixed timetable. Water according to the condition of the substrate and the individual tree.",
                    "A shallow refined bonsai may dry considerably faster than landscape-grown material. At the same time, permanently saturated substrate can damage root health.",
                ]
            ),
            SpeciesProfileSection(
                id: "soil",
                title: "Soil",
                paragraphs: [
                    "Do not prescribe one universal soil recipe.",
                    "Desired characteristics include excellent drainage, good aeration, stable particle structure, appropriate moisture retention and long-term root health.",
                    "The final soil mix must depend on local climate, rainfall, watering habits, container depth, tree size, development stage and root condition.",
                    "Follow Bonsai World Soil Module principles. Do not duplicate the complete Soil Module inside this profile.",
                ]
            ),
            SpeciesProfileSection(
                id: "fertilizing",
                title: "Fertilizing",
                paragraphs: [
                    "Fertilization should support the current development objective.",
                    "During development, healthy trees requiring additional structural growth may receive stronger nutritional support where appropriate.",
                    "During refinement, nutrition should maintain health and controlled growth without unnecessarily producing coarse or unbalanced extension.",
                    "Fertilization depends on tree health, development stage, season, current growth, root condition and recent work.",
                    "Feed the tree you are growing, not simply the cultivar name.",
                ]
            ),
            SpeciesProfileSection(
                id: "pruning",
                title: "Pruning",
                paragraphs: [
                    "Kishu should be pruned selectively. Do not treat juniper pruning as equivalent to deciduous pruning.",
                    "Healthy foliage must remain on branches intended to survive.",
                    "During development: allow selected shoots and branches to extend where thickness is required.",
                    "During refinement: control excessive extension and maintain compact branch structure, branch hierarchy, interior foliage, light penetration and balanced vigour.",
                    "Avoid excessive removal of healthy interior foliage. Avoid allowing dense outer growth to permanently weaken the interior.",
                ]
            ),
            SpeciesProfileSection(
                id: "back-budding",
                title: "Back-budding",
                paragraphs: [
                    "New growth may occur under favourable conditions, but back-budding must never be treated as guaranteed.",
                    "Do not promise new growth from completely bare old wood.",
                    "Potential depends on tree health, retained foliage, branch condition, light, vigour, season and previous work.",
                    "Plan pruning around existing viable foliage.",
                ]
            ),
            SpeciesProfileSection(
                id: "ramification",
                title: "Ramification",
                paragraphs: [
                    "Kishu has excellent ramification potential. This is one of its most important bonsai characteristics.",
                    "Fine ramification should be developed through healthy growth, selective pruning, controlled extension, appropriate wiring, preservation of interior growth and balanced light distribution.",
                    "The goal is not maximum density. The goal is healthy, sustainable ramification.",
                ]
            ),
            SpeciesProfileSection(
                id: "wiring",
                title: "Wiring",
                paragraphs: [
                    "Kishu is highly suitable for wiring and detailed branch positioning.",
                    "Wiring may be used to establish branch structure, improve spacing, create movement, refine branch hierarchy and develop foliage pads.",
                    "Monitor wire carefully. Fine branches can mark easily.",
                    "Before applying strong bends, assess branch thickness, flexibility, age, health and existing stress.",
                    "Do not force branches beyond their natural capacity.",
                ]
            ),
            SpeciesProfileSection(
                id: "defoliation",
                title: "Defoliation",
                paragraphs: [
                    "Defoliation is not suitable as a deciduous-style technique.",
                    "Juniper foliage should not be managed through complete or routine defoliation.",
                    "Use selective pruning, shoot management, density control and removal of unwanted growth.",
                    "Preserve viable healthy foliage.",
                ]
            ),
            SpeciesProfileSection(
                id: "repotting",
                title: "Repotting",
                paragraphs: [
                    "Repotting frequency depends on root development, substrate condition, drainage, container size, tree health and development stage.",
                    "Do not establish a rigid calendar rule.",
                    "Avoid excessive root removal. Do not automatically combine major root work with multiple other major stresses.",
                    "Recovery must be based on the individual tree and growing conditions.",
                ]
            ),
            SpeciesProfileSection(
                id: "trunk-development",
                title: "Trunk Development",
                paragraphs: [
                    "Kishu's greatest bonsai strength is fine foliage refinement and compact ramification rather than rapid trunk production.",
                    "Where trunk development is still required: allow selected extension growth, use sacrifice branches where appropriate, provide sufficient root and growing space, and avoid premature refinement.",
                    "Once sufficient trunk development has been achieved, shift focus toward primary branch refinement, secondary branching, ramification and foliage structure.",
                    "Grow where development is required. Control where refinement is required.",
                ]
            ),
            SpeciesProfileSection(
                id: "nebari-development",
                title: "Nebari Development",
                paragraphs: [
                    "Nebari should be considered early.",
                    "Potential approaches include root selection, radial root positioning, development containers and gradual correction of unsuitable roots.",
                    "The objective is a stable and visually convincing root base.",
                ]
            ),
            SpeciesProfileSection(
                id: "grafting",
                title: "Grafting",
                paragraphs: [
                    "Grafting may be relevant in advanced Kishu bonsai work where a branch is missing, foliage distribution requires correction, a specific area requires additional growth or structural improvement is required.",
                    "Do not present grafting as routine care.",
                    "Detailed procedures belong in Bonsai World Propagation and Grafting Knowledge Articles.",
                ]
            ),
            SpeciesProfileSection(
                id: "propagation",
                title: "Propagation",
                paragraphs: [
                    "Kishu should be propagated vegetatively when the objective is to preserve its recognised horticultural characteristics.",
                    "Relevant methods may include cuttings and other appropriate vegetative propagation methods.",
                    "Seed propagation should not be expected to reproduce the Kishu selection reliably.",
                    "Detailed procedures belong in Bonsai World Propagation Knowledge Articles.",
                ]
            ),
            SpeciesProfileSection(
                id: "pests",
                title: "Pests and Problems",
                paragraphs: [
                    "Relevant risks include spider mites, scale insects, aphids, foliage-feeding pests, root problems caused by excessive moisture, root-related diseases, branch disease, environmental foliage browning, and interior foliage decline caused by excessive density and insufficient light.",
                    "Do not provide generic treatment instructions.",
                    "Diagnosis and treatment belong in Care → Pest Management and Care → Disease & Problems.",
                ]
            ),
            SpeciesProfileSection(
                id: "seasonal",
                title: "Seasonal Profile",
                paragraphs: [
                    "Spring: monitor new growth, water demand, structural development, wiring, wire marks and pest activity. Use seasonal timing as guidance rather than a rigid calendar.",
                    "Summer: monitor water demand, sunlight, wind exposure, foliage health, interior density, wire marks and pest activity. Strong growth may require selective control during refinement.",
                    "Autumn: review overall structure, foliage density, interior health, wire condition and winter preparation. Avoid unnecessary major stress.",
                    "Winter: Kishu remains an outdoor evergreen bonsai. Winter dormancy is required.",
                    "The principal concern for bonsai is often protection of the shallow root system during severe or prolonged freezing. Also monitor winter wind, desiccation, freeze-thaw cycles and excessive moisture in cold substrate.",
                    "Do not move the tree indoors for routine winter care. Winter protection must depend on local climate, minimum temperature, duration of freezing, wind, container depth and root condition.",
                ]
            ),
            SpeciesProfileSection(
                id: "styles",
                title: "Bonsai Styles",
                paragraphs: [
                    "Kishu can be suitable for several bonsai styles depending on the individual material.",
                    "Potential styles include Informal Upright, Slanting, Semi-Cascade, Cascade, Literati, Root-over-Rock and naturalistic forms.",
                    "Do not state that every tree is suitable for every style. The material must determine the final design.",
                ]
            ),
            SpeciesProfileSection(
                id: "tree-stage",
                title: "Development by Tree Stage",
                paragraphs: [
                    "Young material: establish healthy roots, build vigour, establish trunk direction and preserve structural options.",
                    "Nursery material: evaluate trunk potential, identify useful branches, establish a design direction and preserve future development options.",
                    "Pre-bonsai: establish trunk line, develop primary branches, develop root structure and begin controlled branch development.",
                    "In training: develop secondary branches, build ramification, improve foliage distribution and refine structure through wiring.",
                    "Refinement: maintain fine ramification, preserve interior foliage, control extension, maintain branch hierarchy and improve silhouette.",
                    "Exhibition / mature refined tree: maintain health, preserve established design, maintain foliage quality and avoid unnecessary major intervention.",
                ]
            ),
            SpeciesProfileSection(
                id: "attention",
                title: "Cultivar-Specific Attention",
                paragraphs: [
                    "These attention points are operational tendencies. They must still be interpreted for the individual tree.",
                ],
                bullets: [
                    "Fine compact foliage is a primary strength",
                    "Excellent ramification potential",
                    "Avoid premature refinement during structural development",
                    "Dense foliage requires interior light and airflow management",
                    "Preserve viable foliage on branches intended to survive",
                    "Do not assume reliable growth from completely bare old wood",
                    "Strong outdoor light supports foliage quality",
                    "Avoid permanently wet substrate",
                    "Use wiring carefully on fine branches",
                    "Do not use deciduous defoliation techniques",
                    "Protect shallow roots during severe winter conditions",
                    "Do not move indoors for routine winter care",
                ]
            ),
        ]
    }
}
