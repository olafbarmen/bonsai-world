//
//  JuniperusChinensisItoigawaSpeciesProfile.swift
//  Bonsai World
//
//  Species Profile — Juniperus chinensis 'Itoigawa' (Itoigawa Juniper).
//  Independent Bonsai World profile for a Japanese horticultural selection
//  associated with Juniperus chinensis. Separate from Kishu and Shimpaku.
//  Knowledge status: Reviewed (complete editorial content).
//

import Foundation

enum JuniperusChinensisItoigawaSpeciesProfile {
    static let parentSpeciesName = "Juniperus chinensis"
    static let cultivarName = "Itoigawa"
    /// Scientific name for Species Profile display.
    static let scientificName = "Juniperus chinensis 'Itoigawa'"

    static var profile: SpeciesProfile {
        SpeciesProfile(
            speciesID: BotanicalKnowledgeIDs.juniperusChinensis,
            cultivarID: BotanicalKnowledgeIDs.juniperusChinensisItoigawa,
            scientificName: scientificName,
            commonNames: ["Itoigawa Juniper"],
            family: "Cupressaceae",
            plantType: "Evergreen conifer",
            originSummary: "Japanese horticultural selection associated with Juniperus chinensis",
            knowledgeStatus: .reviewed,
            traits: traits,
            foliageSizeLabel: "Foliage",
            foliageReductionLabel: "Foliage management",
            summaryLine: "Evergreen · Fine scale foliage · Dense ramification · Compact growth · Excellent refinement potential",
            attentionHighlights: [
                "Fine foliage is a primary strength",
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
            Itoigawa is one of the most highly regarded juniper selections for refined bonsai because of its naturally fine foliage, compact growth and strong ramification potential.

            Its qualities make it particularly suitable for advanced refinement. However, the same compact characteristics can create challenges.

            Dense foliage can reduce interior light, weaken internal growth, reduce airflow, hide branch structure and make poor pruning decisions difficult to correct.

            The objective should therefore never be maximum foliage density. The objective is healthy foliage, functional ramification, clear branch structure and long-term design stability.

            The Species Profile provides general guidance. The individual tree must always be assessed according to health, root condition, development stage, existing foliage, structural maturity, recent work, climate, weather, container size and current vigour.
            """,
            sourcesNote: """
            Profile content is synthesised from recognised botanical and horticultural authorities into Bonsai World editorial language.

            Parent-species context may draw on Royal Botanic Gardens, Kew and recognised botanical databases. Horticultural information about Itoigawa may draw on Japanese horticultural references where cultivar information can be verified, and on recognised horticultural institutions. Bonsai-specific cultivation draws on established bonsai references for Itoigawa characteristics.

            Separate verified botanical information about Juniperus chinensis, horticultural information about Itoigawa, and bonsai-specific cultivation knowledge. Do not merge Itoigawa with Kishu, Shimpaku or other named selections. Do not copy source wording.
            """
        )
    }

    private static let traits = SpeciesProfileTraits(
        deciduous: false,
        growthStrength: "Moderate",
        growthSpeed: "Moderate",
        leafSize: "Evergreen · Fine scale-like foliage · Dense and compact",
        foliageReduction: "Preserve viable foliage — manage density for light and airflow",
        ramificationPotential: "Excellent",
        backBudding: "Moderate — existing healthy foliage should be preserved",
        rootDevelopment: "Good",
        nebariPotential: "Good development potential",
        trunkDevelopment: "Slow to Moderate",
        barkDevelopment: "Character develops with age; refinement often prioritised over rapid trunk",
        wiring: "Excellent suitability",
        defoliation: "Not suitable",
        airLayering: "Where appropriate for the individual material",
        threadGrafting: "May be particularly relevant for structural correction",
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
                    "Juniperus chinensis 'Itoigawa' is a Japanese horticultural selection associated with Juniperus chinensis and Shimpaku-type junipers.",
                    "Profile type: Cultivar / Horticultural Selection. It is not a separate botanical species.",
                    "Parent species: Juniperus chinensis, family Cupressaceae.",
                    "Primary Bonsai World display identity: Juniperus chinensis 'Itoigawa' · Itoigawa Juniper.",
                    "Itoigawa must remain a separate operational Species Profile from Kishu, Shimpaku, Blaauw, San Jose and other Juniperus chinensis selections. Do not merge profiles because of related horticultural naming.",
                ]
            ),
            SpeciesProfileSection(
                id: "overview",
                title: "Species Overview",
                paragraphs: [
                    "Juniperus chinensis 'Itoigawa' is a highly valued Japanese juniper selection particularly associated with refined bonsai.",
                    "It is recognised for very fine scale-like foliage, compact foliage structure, dense ramification potential, strong response to careful refinement and excellent suitability for detailed bonsai work.",
                    "Itoigawa is often particularly suitable for refined bonsai where foliage quality and branch ramification are central design features.",
                    "It should not automatically be treated as a fast trunk-development cultivar. Its greatest strengths are generally seen after sufficient structural development has already been achieved.",
                    "Do not prematurely refine a tree that still requires substantial trunk or primary branch development. Allow growth where development is required. Control growth where refinement is required.",
                ],
                bullets: [
                    "Evergreen conifer",
                    "Fine scale-like foliage",
                    "Naturally compact foliage mass",
                    "Excellent ramification potential",
                    "Highly suitable for refinement",
                    "Good wiring suitability",
                    "Dense growth requires careful interior management",
                    "Healthy foliage must be preserved on branches intended to survive",
                    "Requires strong outdoor light",
                    "Requires winter dormancy",
                    "Requires a well-drained root environment",
                ]
            ),
            SpeciesProfileSection(
                id: "natural-growth",
                title: "Natural Growth and Vigour",
                paragraphs: [
                    "Itoigawa generally develops compact and relatively fine growth compared with more vigorous and coarse Juniperus chinensis material.",
                    "Growth strength depends on root development, container size, substrate, light, fertilization, temperature, water availability, climate and development stage.",
                    "During development: allow selected leaders and branches to extend where thickness is required. Do not continuously prune all growth merely to preserve compact foliage.",
                    "During refinement: use controlled pruning to maintain branch hierarchy, compact proportions, healthy interior foliage and balanced vigour.",
                    "The refinement potential of Itoigawa should not encourage premature restriction. A tree still in structural development needs growth.",
                ]
            ),
            SpeciesProfileSection(
                id: "foliage",
                title: "Foliage",
                paragraphs: [
                    "Itoigawa is particularly valued for its fine, dense, scale-like evergreen foliage. The foliage is one of the defining characteristics of the selection.",
                    "Healthy foliage management should maintain light penetration, airflow, interior growth, branch visibility and future growing points.",
                    "Dense foliage must not be allowed to permanently shade the interior.",
                    "Do not treat the foliage as a hedge. Do not shear the entire surface uniformly. Instead, manage growth selectively.",
                    "Maintain foliage on branches intended to survive. Do not assume that completely bare old wood will reliably produce new growth.",
                ]
            ),
            SpeciesProfileSection(
                id: "bark-trunk",
                title: "Bark and Trunk",
                paragraphs: [
                    "Itoigawa is often selected primarily for foliage refinement rather than rapid trunk development.",
                    "Young material may require considerable time before developing a convincing trunk.",
                    "Where substantial trunk development is required, use appropriate development strategies such as extended cultivation, larger development containers, selected sacrifice growth, allowing structural branches to extend and staged pruning.",
                    "Do not remove useful development growth prematurely.",
                    "Once sufficient trunk and primary branch development has been achieved, gradually shift toward refinement.",
                ]
            ),
            SpeciesProfileSection(
                id: "roots-nebari",
                title: "Roots and Nebari",
                paragraphs: [
                    "Good root health is essential for maintaining dense healthy foliage.",
                    "Root development objectives include balanced root mass, radial root distribution where possible, stable trunk support, gradual root selection and long-term substrate health.",
                    "Good nebari can be developed through early root selection, appropriate container development and long-term cultivation. Do not promise exceptional nebari automatically.",
                    "Avoid unnecessary aggressive root reduction.",
                ]
            ),
            SpeciesProfileSection(
                id: "light",
                title: "Light",
                paragraphs: [
                    "Itoigawa should generally be cultivated outdoors with strong light.",
                    "Healthy established trees benefit from substantial outdoor light. Strong light supports healthy foliage, compact growth, balanced vigour and interior development.",
                    "Light management must consider temperature, wind, root condition, recent repotting, water availability, container size and tree health.",
                    "Do not recommend indoor cultivation.",
                ]
            ),
            SpeciesProfileSection(
                id: "wind",
                title: "Wind",
                paragraphs: [
                    "Airflow is particularly important because Itoigawa can develop very dense foliage.",
                    "Benefits include improved airflow, faster drying of foliage and reduced stagnant conditions.",
                    "Wind can also increase transpiration, water demand and winter desiccation risk.",
                    "Pay particular attention to small and shallow containers.",
                ]
            ),
            SpeciesProfileSection(
                id: "watering",
                title: "Watering",
                paragraphs: [
                    "General principle: moist when required, well drained, never permanently saturated.",
                    "Watering frequency depends on weather, temperature, wind, sun exposure, container size, substrate structure, root mass, tree health and development stage.",
                    "Do not water according to a fixed timetable.",
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
                    "Follow Bonsai World Soil Module principles.",
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
                    "Itoigawa should be pruned selectively. Do not treat juniper pruning as equivalent to deciduous pruning.",
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
                    "Itoigawa has excellent ramification potential. This is one of its most important bonsai characteristics.",
                    "Fine ramification should be developed through healthy growth, selective pruning, controlled extension, appropriate wiring, preservation of interior growth and balanced light distribution.",
                    "The goal is not maximum density. The goal is healthy, sustainable ramification.",
                ]
            ),
            SpeciesProfileSection(
                id: "wiring",
                title: "Wiring",
                paragraphs: [
                    "Itoigawa is highly suitable for wiring and detailed branch positioning.",
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
                    "Itoigawa's greatest bonsai strength is fine foliage refinement rather than rapid trunk production.",
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
                    "Grafting may be particularly relevant in advanced Itoigawa bonsai work where a branch is missing, foliage distribution requires correction, a specific area needs additional growth or structural improvement is required.",
                    "Do not present grafting as routine care.",
                    "Detailed procedures belong in Bonsai World Propagation and Grafting Knowledge Articles.",
                ]
            ),
            SpeciesProfileSection(
                id: "propagation",
                title: "Propagation",
                paragraphs: [
                    "Itoigawa should be propagated vegetatively when the objective is to preserve its recognised horticultural characteristics.",
                    "Relevant methods may include cuttings and other appropriate vegetative propagation methods.",
                    "Seed propagation should not be expected to reproduce the Itoigawa selection reliably.",
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
                    "Winter: Itoigawa remains an outdoor evergreen bonsai. Winter dormancy is required.",
                    "The principal concern for bonsai is often protection of the shallow root system during severe or prolonged freezing. Also monitor winter wind, desiccation, freeze-thaw cycles and excessive moisture in cold substrate.",
                    "Do not move the tree indoors for routine winter care. Winter protection must depend on local climate, minimum temperature, duration of freezing, wind, container depth and root condition.",
                ]
            ),
            SpeciesProfileSection(
                id: "styles",
                title: "Bonsai Styles",
                paragraphs: [
                    "Itoigawa can be suitable for many bonsai styles depending on the individual material.",
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
                    "Fine foliage is a primary strength",
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
