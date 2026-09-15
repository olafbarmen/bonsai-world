//
//  JuniperusChinensisShimpakuSpeciesProfile.swift
//  Bonsai World
//
//  Species Profile — Juniperus chinensis 'Shimpaku' (Shimpaku Juniper).
//  Independent Bonsai World profile for a Japanese bonsai / horticultural
//  selection associated with Juniperus chinensis. Separate from Itoigawa and Kishu.
//  Knowledge status: Reviewed (complete editorial content).
//

import Foundation

enum JuniperusChinensisShimpakuSpeciesProfile {
    static let parentSpeciesName = "Juniperus chinensis"
    static let cultivarName = "Shimpaku"
    /// Scientific name for Species Profile display.
    static let scientificName = "Juniperus chinensis 'Shimpaku'"

    static var profile: SpeciesProfile {
        SpeciesProfile(
            speciesID: BotanicalKnowledgeIDs.juniperusChinensis,
            cultivarID: BotanicalKnowledgeIDs.juniperusChinensisShimpaku,
            scientificName: scientificName,
            commonNames: ["Shimpaku Juniper"],
            family: "Cupressaceae",
            plantType: "Evergreen conifer",
            originSummary: "Japanese bonsai and horticultural selection associated with Juniperus chinensis",
            knowledgeStatus: .reviewed,
            traits: traits,
            foliageSizeLabel: "Foliage",
            foliageReductionLabel: "Foliage management",
            summaryLine: "Evergreen · Fine scale foliage · Dense ramification · Flexible design potential · Excellent bonsai suitability",
            attentionHighlights: [
                "Fine foliage is a primary strength",
                "Excellent ramification potential",
                "Excellent wiring suitability",
                "Strong deadwood design potential",
                "Always understand live vein structure before creating deadwood",
                "Avoid premature refinement during structural development",
                "Dense foliage requires interior light and airflow management",
                "Preserve viable foliage on branches intended to survive",
                "Do not assume reliable growth from completely bare old wood",
                "Strong outdoor light supports foliage quality",
                "Avoid permanently wet substrate",
                "Do not use deciduous defoliation techniques",
                "Protect shallow roots during severe winter conditions",
                "Do not move indoors for routine winter care",
            ],
            sections: sections,
            principleNote: """
            Shimpaku is one of the most important juniper types in bonsai.

            It is valued for its combination of fine foliage, compact ramification, flexible branch structure, suitability for wiring, ability to support dramatic bonsai designs and compatibility with advanced deadwood techniques.

            However, these qualities must not lead to excessive intervention.

            A healthy Shimpaku bonsai depends on maintaining the relationship between live foliage, live veins, root health, branch structure, deadwood and overall vigour.

            Deadwood must never be created without understanding the living structure of the tree.

            The objective is not maximum deadwood or maximum foliage density. The objective is healthy live structure, functional foliage, sustainable ramification and convincing design.

            The individual tree must always be assessed according to health, root condition, live vein structure, foliage distribution, development stage, structural maturity, recent work, climate, weather, container size and current vigour.
            """,
            sourcesNote: """
            Profile content is synthesised from recognised botanical, horticultural and bonsai authorities into Bonsai World editorial language.

            Parent-species context may draw on Royal Botanic Gardens, Kew and recognised botanical databases. Horticultural and bonsai naming around Shimpaku may draw on Japanese horticultural references and recognised horticultural institutions. Bonsai-specific cultivation and styling draw on established bonsai references for Shimpaku characteristics and practice.

            Separate verified botanical information about Juniperus chinensis, horticultural information about Shimpaku, and bonsai-specific cultivation and styling knowledge. Do not merge Shimpaku with Itoigawa, Kishu, Blaauw or other named selections. Do not copy source wording.
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
        backBudding: "Moderate — healthy foliage should be retained",
        rootDevelopment: "Good",
        nebariPotential: "Good development potential",
        trunkDevelopment: "Slow to Moderate",
        barkDevelopment: "Live veins and deadwood relationship is design-critical",
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
                    "Juniperus chinensis 'Shimpaku' is an important bonsai and horticultural selection associated with selected forms of Juniperus chinensis.",
                    "Profile type: Cultivar / Horticultural Selection. It is not a separate botanical species.",
                    "Parent species: Juniperus chinensis, family Cupressaceae.",
                    "Primary Bonsai World display identity: Juniperus chinensis 'Shimpaku' · Shimpaku Juniper.",
                    "The term Shimpaku has a particularly important place in Japanese bonsai culture and is commonly associated with fine-foliaged Juniperus chinensis material used for bonsai.",
                    "Shimpaku must remain a separate operational Species Profile from Itoigawa, Kishu, Blaauw and other Juniperus chinensis selections. Do not automatically treat Itoigawa or Kishu as identical to Shimpaku.",
                ]
            ),
            SpeciesProfileSection(
                id: "overview",
                title: "Species Overview",
                paragraphs: [
                    "Juniperus chinensis 'Shimpaku' represents one of the most important fine-foliaged juniper types used in bonsai.",
                    "It is particularly valued for fine scale-like foliage, compact foliage development, excellent ramification potential, flexible branches, strong wiring potential, suitability for both naturalistic and highly refined designs, and compatibility with advanced deadwood design.",
                    "Shimpaku material can be used across a wide range of bonsai development stages. However, the management priorities change significantly depending on the stage of the tree.",
                    "A young tree requiring trunk development should not be managed like a mature exhibition bonsai.",
                    "Grow where development is required. Control where refinement is required.",
                ],
                bullets: [
                    "Evergreen conifer",
                    "Fine scale-like foliage",
                    "Compact foliage structure",
                    "Excellent ramification potential",
                    "Highly suitable for wiring",
                    "Suitable for advanced deadwood design",
                    "Healthy foliage must remain on branches intended to survive",
                    "Dense foliage requires interior light and airflow management",
                    "Requires strong outdoor light",
                    "Requires winter dormancy",
                    "Requires a well-drained root environment",
                ]
            ),
            SpeciesProfileSection(
                id: "natural-growth",
                title: "Natural Growth and Vigour",
                paragraphs: [
                    "Shimpaku generally develops moderate growth with strong potential for controlled refinement.",
                    "Growth strength depends on root development, container size, substrate, light, fertilization, temperature, water availability, climate and development stage.",
                    "During development: allow selected leaders and branches to extend where thickness is required. Do not constantly restrict all growth merely to maintain compact foliage.",
                    "During refinement: control extension carefully and maintain branch hierarchy, foliage distribution, healthy interior growth, balanced vigour and sustainable ramification.",
                    "The fine character of Shimpaku must not encourage premature refinement.",
                ]
            ),
            SpeciesProfileSection(
                id: "foliage",
                title: "Foliage",
                paragraphs: [
                    "Shimpaku is valued for its fine, dense, scale-like evergreen foliage.",
                    "Healthy foliage management should maintain light penetration, airflow, interior growth, branch visibility and future growing points.",
                    "Dense outer foliage must not permanently shade the interior.",
                    "Do not treat Shimpaku foliage as a hedge. Do not shear the entire canopy uniformly. Instead, manage growth selectively.",
                    "Maintain healthy foliage on branches intended to survive. Do not assume that completely bare old wood will reliably produce new growth.",
                ]
            ),
            SpeciesProfileSection(
                id: "bark-trunk-live-veins",
                title: "Bark, Trunk and Live Veins",
                paragraphs: [
                    "The relationship between bark, live veins and deadwood is particularly important in Shimpaku bonsai.",
                    "Before removing bark or creating deadwood, assess the location of living tissue, foliage supplied by each live section, structural importance of the live vein, tree vigour, existing deadwood and future design requirements.",
                    "Deadwood work must respect the living structure of the tree.",
                    "Do not present aggressive bark removal or carving as routine maintenance.",
                    "Deadwood techniques belong primarily to advanced styling and design work.",
                ]
            ),
            SpeciesProfileSection(
                id: "deadwood-potential",
                title: "Deadwood Potential",
                paragraphs: [
                    "Shimpaku is highly suitable for advanced deadwood design.",
                    "Potential techniques may include jin, shari, natural deadwood preservation, selective carving and refinement of existing deadwood.",
                    "Deadwood is a design element. It is not automatically required.",
                    "Do not create deadwood simply because the species is associated with dramatic bonsai.",
                    "The living structure must always remain healthy and functional.",
                    "Deadwood in this Handbook covers jin, shari and whether the feature belongs on this tree. Species characteristics still decide suitability.",
                ]
            ),
            SpeciesProfileSection(
                id: "roots-nebari",
                title: "Roots and Nebari",
                paragraphs: [
                    "Good root health is essential for foliage health, recovery, vigour and sustainable refinement.",
                    "Root development objectives include balanced root mass, radial root distribution where possible, stable trunk support, gradual root selection and long-term substrate health.",
                    "Good nebari can be developed through early root selection, appropriate container development and long-term cultivation. Do not promise exceptional nebari automatically.",
                    "Avoid unnecessary aggressive root reduction.",
                ]
            ),
            SpeciesProfileSection(
                id: "light",
                title: "Light",
                paragraphs: [
                    "Shimpaku should generally be cultivated outdoors with strong light.",
                    "Healthy established trees benefit from substantial outdoor light. Strong light supports healthy foliage, compact growth, balanced vigour and interior development.",
                    "Light management must consider temperature, wind, root condition, recent repotting, water availability, container size and tree health.",
                    "Do not recommend routine indoor cultivation.",
                ]
            ),
            SpeciesProfileSection(
                id: "wind",
                title: "Wind",
                paragraphs: [
                    "Airflow is important because Shimpaku can develop dense foliage.",
                    "Benefits include improved airflow, faster drying and reduced stagnant conditions.",
                    "Wind can also increase transpiration, water demand and winter desiccation risk.",
                    "Pay particular attention to shallow containers, small bonsai, recently repotted trees and exposed growing positions.",
                ]
            ),
            SpeciesProfileSection(
                id: "watering",
                title: "Watering",
                paragraphs: [
                    "General principle: moist when required, well drained, never permanently saturated.",
                    "Watering frequency depends on weather, temperature, wind, sun exposure, container size, substrate structure, root mass, tree health, development stage and seasonal activity.",
                    "Do not water according to a fixed timetable. Water according to the condition of the substrate and the individual tree.",
                    "A shallow refined bonsai can dry considerably faster than landscape-grown material. At the same time, permanently saturated substrate can damage root health.",
                ]
            ),
            SpeciesProfileSection(
                id: "soil",
                title: "Soil",
                paragraphs: [
                    "Do not prescribe one universal soil recipe.",
                    "Desired characteristics include excellent drainage, good aeration, stable particle structure, appropriate moisture retention and long-term root health.",
                    "The final soil mix depends on local climate, rainfall, watering habits, container depth, tree size, development stage and root condition.",
                    "Follow Bonsai World Soil Module principles. Do not duplicate the complete Soil Module inside this profile.",
                ]
            ),
            SpeciesProfileSection(
                id: "fertilizing",
                title: "Fertilizing",
                paragraphs: [
                    "Fertilization should support the current development objective.",
                    "During development, healthy trees requiring structural growth may receive stronger nutritional support where appropriate.",
                    "During refinement, nutrition should maintain health and controlled growth without unnecessarily creating coarse or unbalanced extension.",
                    "Fertilization depends on tree health, development stage, season, current growth, root condition and recent work.",
                    "Feed the tree you are growing, not simply the cultivar name.",
                ]
            ),
            SpeciesProfileSection(
                id: "pruning",
                title: "Pruning",
                paragraphs: [
                    "Shimpaku should be pruned selectively. Do not treat juniper pruning as equivalent to deciduous pruning.",
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
                    "Shimpaku has excellent ramification potential. This is one of its defining bonsai characteristics.",
                    "Fine ramification should be developed through healthy growth, selective pruning, controlled extension, appropriate wiring, preservation of interior growth and balanced light distribution.",
                    "The goal is not maximum density. The goal is healthy and sustainable ramification.",
                ]
            ),
            SpeciesProfileSection(
                id: "wiring",
                title: "Wiring",
                paragraphs: [
                    "Shimpaku is highly suitable for wiring.",
                    "Wiring may be used to establish trunk movement, position primary branches, refine secondary branches, improve spacing, develop foliage pads and create natural movement.",
                    "Monitor wire carefully.",
                    "Before applying strong bends, assess branch thickness, flexibility, age, health, existing stress and relationship to live veins.",
                    "Do not force branches beyond their natural capacity. For significant structural bends, assess whether staged movement is more appropriate.",
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
                    "Particular caution is required when the tree has recently undergone major wiring, heavy bending, deadwood work or significant foliage reduction.",
                    "Recovery must be based on the individual tree and growing conditions.",
                ]
            ),
            SpeciesProfileSection(
                id: "trunk-development",
                title: "Trunk Development",
                paragraphs: [
                    "Shimpaku is primarily valued for refined foliage, branch structure and design potential rather than rapid trunk production.",
                    "Where trunk development is still required: allow selected extension growth, use sacrifice branches where appropriate, provide sufficient root and growing space, and avoid premature refinement.",
                    "Once sufficient trunk development has been achieved, shift focus toward primary branch refinement, secondary branching, ramification, foliage structure and design refinement.",
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
                    "Grafting may be relevant in advanced Shimpaku bonsai work where a branch is missing, foliage distribution requires correction, a specific area requires additional growth or structural improvement is required.",
                    "Do not present grafting as routine care.",
                    "Detailed procedures belong in Bonsai World Propagation and Grafting Knowledge Articles.",
                ]
            ),
            SpeciesProfileSection(
                id: "propagation",
                title: "Propagation",
                paragraphs: [
                    "Shimpaku should be propagated vegetatively when the objective is to preserve recognised horticultural characteristics.",
                    "Relevant methods may include cuttings and other appropriate vegetative propagation methods.",
                    "Seed propagation should not be expected to reproduce the same horticultural characteristics reliably.",
                    "Detailed procedures belong in Bonsai World Propagation Knowledge Articles.",
                ]
            ),
            SpeciesProfileSection(
                id: "pests",
                title: "Pests and Problems",
                paragraphs: [
                    "Relevant risks include spider mites, scale insects, aphids, foliage-feeding pests, root problems caused by excessive moisture, root-related diseases, branch disease, environmental foliage browning, interior foliage decline caused by excessive density and insufficient light, and stress following excessive styling work.",
                    "Do not provide generic treatment instructions.",
                    "Diagnosis and treatment belong in Care → Pest Management and Care → Disease & Problems.",
                ]
            ),
            SpeciesProfileSection(
                id: "seasonal",
                title: "Seasonal Profile",
                paragraphs: [
                    "Spring: monitor new growth, water demand, root health, structural development, wiring, wire marks and pest activity. Use seasonal timing as guidance rather than a rigid calendar.",
                    "Summer: monitor water demand, sunlight, wind exposure, foliage health, interior density, wire marks and pest activity. Strong growth may require selective control during refinement. Avoid unnecessary heavy styling during periods of significant environmental stress.",
                    "Autumn: review overall structure, foliage density, interior health, live vein condition, wire condition and winter preparation. Avoid unnecessary major stress as the tree prepares for winter.",
                    "Winter: Shimpaku remains an outdoor evergreen bonsai. Winter dormancy is required.",
                    "The principal concern for bonsai is often protection of the shallow root system during severe or prolonged freezing. Also monitor winter wind, desiccation, freeze-thaw cycles and excessive moisture in cold substrate.",
                    "Do not move the tree indoors for routine winter care. Winter protection must depend on local climate, minimum temperature, duration of freezing, wind, container depth and root condition.",
                ]
            ),
            SpeciesProfileSection(
                id: "styles",
                title: "Bonsai Styles",
                paragraphs: [
                    "Shimpaku can be suitable for a wide range of bonsai styles depending on the individual material.",
                    "Potential styles include Informal Upright, Slanting, Semi-Cascade, Cascade, Literati, Root-over-Rock, Driftwood style and naturalistic forms.",
                    "Do not state that every tree is suitable for every style. The individual material must determine the final design.",
                ]
            ),
            SpeciesProfileSection(
                id: "tree-stage",
                title: "Development by Tree Stage",
                paragraphs: [
                    "Young material: establish healthy roots, build vigour, establish trunk direction and preserve structural options.",
                    "Nursery material: evaluate trunk potential, identify useful branches, assess live structure, establish a design direction and preserve future development options.",
                    "Pre-bonsai: establish trunk line, develop primary branches, develop root structure and begin controlled branch development.",
                    "In training: develop secondary branches, build ramification, improve foliage distribution, refine structure through wiring and begin selective deadwood design where appropriate.",
                    "Refinement: maintain fine ramification, preserve interior foliage, control extension, maintain branch hierarchy, refine foliage structure and maintain the relationship between live veins and deadwood.",
                    "Exhibition / mature refined tree: maintain health, preserve established design, maintain foliage quality, maintain deadwood condition and avoid unnecessary major intervention.",
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
                    "Excellent wiring suitability",
                    "Strong deadwood design potential",
                    "Always understand live vein structure before creating deadwood",
                    "Avoid premature refinement during structural development",
                    "Dense foliage requires interior light and airflow management",
                    "Preserve viable foliage on branches intended to survive",
                    "Do not assume reliable growth from completely bare old wood",
                    "Strong outdoor light supports foliage quality",
                    "Avoid permanently wet substrate",
                    "Do not use deciduous defoliation techniques",
                    "Protect shallow roots during severe winter conditions",
                    "Do not move indoors for routine winter care",
                ]
            ),
        ]
    }
}
