//
//  JuniperusChinensisStrictaSpeciesProfile.swift
//  Bonsai World
//
//  Species Profile — Juniperus chinensis 'Stricta' (Chinese Juniper 'Stricta').
//  Independent Bonsai World profile for a cultivar / horticultural selection of
//  Juniperus chinensis. Knowledge status: Reviewed (complete editorial content).
//

import Foundation

enum JuniperusChinensisStrictaSpeciesProfile {
    static let parentSpeciesName = "Juniperus chinensis"
    static let cultivarName = "Stricta"
    /// Scientific name for Species Profile display.
    static let scientificName = "Juniperus chinensis 'Stricta'"

    static var profile: SpeciesProfile {
        SpeciesProfile(
            speciesID: BotanicalKnowledgeIDs.juniperusChinensis,
            cultivarID: BotanicalKnowledgeIDs.juniperusChinensisStricta,
            scientificName: scientificName,
            commonNames: ["Chinese Juniper 'Stricta'"],
            family: "Cupressaceae",
            plantType: "Evergreen conifer",
            originSummary: "Cultivated selection of a species native to East Asia",
            knowledgeStatus: .reviewed,
            traits: traits,
            foliageSizeLabel: "Foliage",
            foliageReductionLabel: "Foliage management",
            summaryLine: "Evergreen · Upright growth · Dense foliage · Excellent structural potential",
            attentionHighlights: [
                "Preserve healthy foliage on branches intended to remain viable",
                "Do not assume reliable budding from completely bare old wood",
                "Avoid permanently wet substrate",
                "Monitor water demand closely in shallow containers",
                "Strong light is beneficial, but recent work and tree health must be considered",
                "Watch wire carefully on actively thickening branches",
                "Use extension growth strategically during development",
                "Do not use deciduous defoliation techniques",
                "Protect shallow root systems during severe winter conditions",
                "Do not move the tree indoors as routine winter care",
            ],
            sections: sections,
            principleNote: """
            Juniperus chinensis 'Stricta' is an evergreen conifer whose bonsai management must be based on the individual tree rather than a fixed calendar.

            The species profile provides tendencies and guidance.

            It does not automatically determine what should be done to every individual tree.

            Tree health, root condition, foliage density, development stage, climate, recent work and current growth must always influence management decisions.

            A healthy development-stage tree can tolerate and benefit from different work than a refined tree, recently repotted tree, recovering tree or weak tree.
            """,
            sourcesNote: """
            Profile content is synthesised from recognised botanical and horticultural authorities into Bonsai World editorial language.

            Botanical and horticultural verification may draw on Royal Botanic Gardens, Kew (Plants of the World Online) for the parent species Juniperus chinensis; Royal Horticultural Society and Flora of China for horticultural and distribution context; and established bonsai educational sources for bonsai-specific management.

            Do not treat this profile as copied reference wording. Parent species relationships and cultivar identity remain horticultural facts; operational decisions remain tree-specific.
            """
        )
    }

    private static let traits = SpeciesProfileTraits(
        deciduous: false,
        growthStrength: "Moderate to Strong",
        growthSpeed: "Moderate",
        leafSize: "Evergreen, dense, compact potential",
        foliageReduction: "Preserve viable foliage — do not strip bare",
        ramificationPotential: "Good",
        backBudding: "Moderate — foliage must be retained",
        rootDevelopment: "Strong",
        nebariPotential: "Good development potential",
        trunkDevelopment: "Moderate",
        barkDevelopment: "Increasing character with age and development",
        wiring: "Suitable — monitor closely",
        defoliation: "Not suitable as a deciduous-style technique",
        airLayering: "Where appropriate for the individual material",
        threadGrafting: "May be relevant for structural correction",
        rootGrafting: "Where appropriate",
        beginnerSuitability: "High",
        bonsaiSuitability: "Excellent",
        difficulty: "Beginner to Advanced",
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
                    "Juniperus chinensis 'Stricta' is a cultivar / horticultural selection associated with Juniperus chinensis.",
                    "Profile type: Cultivar / Horticultural Selection. It is not a separate botanical species.",
                    "Parent species: Juniperus chinensis (Chinese Juniper), family Cupressaceae.",
                    "Bonsai World may publish an independent Species Profile for a distinct cultivar when growth character, foliage behaviour or bonsai management differ enough to justify separate guidance.",
                    "The cultivar itself is a cultivated horticultural selection. The parent species is native to a broad region of East Asia. Do not treat the cultivar as having a separate natural wild range.",
                ]
            ),
            SpeciesProfileSection(
                id: "overview",
                title: "Species Overview",
                paragraphs: [
                    "Juniperus chinensis 'Stricta' is an upright, narrow-growing horticultural selection of Chinese Juniper.",
                    "It is valued in bonsai for its evergreen foliage, strong architectural character and usefulness as nursery material that can be developed into formal or informal upright compositions when the individual tree supports that design.",
                    "The selection offers potential for structural wiring, gradual development of mature trunk character and compact refinement when cultivated with balanced light, drainage and foliage-preserving pruning.",
                    "Its natural upright garden habit does not mean every tree should become a formal upright bonsai. The material should always influence the final design.",
                    "Strong light and a well-drained root environment are important. Permanently wet root conditions should be avoided.",
                ],
                bullets: [
                    "Evergreen conifer",
                    "Upright and columnar growth tendency",
                    "Dense foliage",
                    "Moderate to strong vigour when healthy",
                    "Good structural wiring potential",
                    "Useful nursery material for bonsai development",
                    "Foliage must be retained during branch development",
                    "Strong preference for a well-drained root environment",
                    "Requires winter dormancy",
                    "Bonsai roots require greater winter protection than landscape plants",
                ]
            ),
            SpeciesProfileSection(
                id: "natural-growth",
                title: "Natural Growth and Vigour",
                paragraphs: [
                    "'Stricta' generally develops with a distinctly upright growth tendency.",
                    "Vigour is moderate to strong depending on health, root development, container size, substrate, fertilization, light, temperature, climate and development stage.",
                    "During development: allow selected areas to extend when trunk or branch thickness is required. Use growth strategically.",
                    "During refinement: control extension more carefully. Maintain foliage density and branch structure.",
                    "Avoid allowing the apex to permanently dominate the rest of the tree.",
                ]
            ),
            SpeciesProfileSection(
                id: "foliage",
                title: "Foliage",
                paragraphs: [
                    "Juniperus chinensis produces evergreen foliage. Depending on age and growth condition, junipers may show more juvenile needle-like foliage and more mature scale-like foliage.",
                    "Juvenile foliage is not a disease. Stress, pruning, strong intervention and growing conditions may influence foliage expression.",
                    "For bonsai management, dense healthy foliage is important.",
                    "Avoid stripping branches completely bare when those branches are intended to survive. Pruning should preserve viable foliage and future growing points.",
                    "Compact foliage development depends on balanced cultivation rather than one isolated technique.",
                ]
            ),
            SpeciesProfileSection(
                id: "bark-trunk",
                title: "Bark and Trunk",
                paragraphs: [
                    "Young material may initially appear relatively smooth and horticulturally uniform. With age and development, trunk and bark character become increasingly important.",
                    "The upright nature of 'Stricta' makes it particularly suitable for upright compositions, trunk-focused development, formal upright interpretations, informal upright interpretations where the material allows movement, slender and elegant compositions, and group compositions where appropriate.",
                    "Do not force all 'Stricta' material into one style.",
                    "Develop where thickness is required. Control where refinement is required.",
                ]
            ),
            SpeciesProfileSection(
                id: "roots-nebari",
                title: "Roots and Nebari",
                paragraphs: [
                    "Root development is important from the earliest stages.",
                    "Consider radial root development, avoiding severe root congestion, container selection, substrate structure, root health and gradual root development.",
                    "Good nebari can be developed through early root management and appropriate cultivation. Do not promise exceptional nebari automatically.",
                    "A healthy root system is essential for foliage density, vigour and recovery.",
                ]
            ),
            SpeciesProfileSection(
                id: "light",
                title: "Light",
                paragraphs: [
                    "Juniperus chinensis 'Stricta' should generally be grown outdoors with strong light.",
                    "Healthy trees benefit from substantial light exposure. Full sun can be highly beneficial when the tree is healthy and properly acclimated.",
                    "Light must always be interpreted together with temperature, wind, root condition, recent repotting, container size, water availability and foliage condition.",
                    "A recently repotted, weak or stressed tree should not automatically be treated like a fully established, vigorous tree.",
                ]
            ),
            SpeciesProfileSection(
                id: "wind",
                title: "Wind",
                paragraphs: [
                    "Wind can be both beneficial and demanding.",
                    "Benefits may include improved air movement, faster drying of foliage after rain and reduced stagnant conditions.",
                    "Risks include increased water demand, rootball drying, stress in shallow containers, winter desiccation and stress after recent repotting.",
                    "Strong wind and strong light together can significantly increase monitoring requirements.",
                ]
            ),
            SpeciesProfileSection(
                id: "watering",
                title: "Watering",
                paragraphs: [
                    "Juniperus chinensis 'Stricta' requires a balanced approach to watering.",
                    "General principle: moist but well-drained substrate. Do not maintain the root environment permanently saturated.",
                    "Watering frequency must depend on weather, temperature, wind, container size, substrate particle size, root mass, tree health, development stage and seasonal activity.",
                    "Do not water according to a fixed timetable. Water according to the condition of the tree and substrate.",
                    "Prolonged excessive moisture and poor drainage are significant risks.",
                    "A juniper should not be treated as drought-proof simply because established garden plants can tolerate periods of drought. A bonsai in a shallow container has very different water dynamics.",
                ]
            ),
            SpeciesProfileSection(
                id: "soil",
                title: "Soil",
                paragraphs: [
                    "Do not prescribe one universal soil recipe.",
                    "Desired substrate characteristics include excellent drainage, strong aeration, stable particle structure, sufficient moisture retention and a healthy root environment.",
                    "The final mix must depend on local climate, rainfall, watering habits, container depth, development stage and tree vigour.",
                    "Use Bonsai World soil principles rather than hard-coded universal recipes. Substrate guidance must remain consistent with the Bonsai World Soil Module.",
                ]
            ),
            SpeciesProfileSection(
                id: "fertilizing",
                title: "Fertilizing",
                paragraphs: [
                    "Fertilization should support the tree currently being grown.",
                    "During development, a healthy tree may receive stronger nutritional support where increased growth is desirable.",
                    "During refinement, nutrition should be managed more carefully to avoid unnecessary coarse growth while maintaining tree health.",
                    "Fertilization must depend on tree health, development stage, season, current growth, recent repotting and root condition.",
                    "Do not fertilize a weak or severely stressed tree simply because the species is capable of strong growth.",
                    "Feed the tree you are growing, not simply the cultivar name.",
                ]
            ),
            SpeciesProfileSection(
                id: "pruning",
                title: "Pruning",
                paragraphs: [
                    "Junipers do not behave like deciduous trees. Do not assume that a completely bare branch will reliably regenerate.",
                    "Healthy foliage should remain on branches that are intended to stay alive.",
                    "Development pruning: allow selected shoots to extend where thickness is required. Use extension growth to develop trunk thickness, primary branches and selected structural branches.",
                    "Refinement pruning: control excessive extension, maintain foliage pads and branch hierarchy, and reduce congestion gradually. Avoid removing excessive foliage from a weak tree.",
                    "Pruning should maintain branch viability, foliage distribution, light penetration, branch hierarchy and long-term design options.",
                    "Do not describe aggressive stripping or indiscriminate foliage removal as routine maintenance.",
                ]
            ),
            SpeciesProfileSection(
                id: "back-budding",
                title: "Back-budding",
                paragraphs: [
                    "Juniperus chinensis 'Stricta' can develop new growth under favourable conditions, but back-budding should not be treated as guaranteed.",
                    "Do not promise new buds from completely bare old wood.",
                    "Back-budding potential depends on tree health, foliage retained, branch condition, light, vigour, season and previous work.",
                    "Use foliage-preserving pruning strategies.",
                ]
            ),
            SpeciesProfileSection(
                id: "ramification",
                title: "Ramification",
                paragraphs: [
                    "Ramification potential is good rather than automatically excellent.",
                    "Fine branch development requires repeated controlled growth, selective pruning, healthy foliage, correct light distribution and careful branch selection.",
                    "The main challenge is maintaining density without allowing interior weakening, excessive shading, long bare sections or uncontrolled outer growth.",
                ]
            ),
            SpeciesProfileSection(
                id: "wiring",
                title: "Wiring",
                paragraphs: [
                    "Juniperus chinensis 'Stricta' is suitable for wiring. Its naturally upright structure makes structural wiring particularly relevant.",
                    "Wiring can be used to establish trunk movement where material allows, position primary branches, establish branch hierarchy, create more natural spacing and prevent an overly uniform nursery appearance.",
                    "Monitor wire carefully. Growing branches can thicken and wire marks may become permanent.",
                    "Do not automatically recommend heavy bending. Assess branch thickness, branch flexibility, age, health and intended movement.",
                    "Wiring follow-up should be treated as an important management task.",
                ]
            ),
            SpeciesProfileSection(
                id: "defoliation",
                title: "Defoliation",
                paragraphs: [
                    "Defoliation is not suitable as a deciduous-style technique.",
                    "Junipers must not be treated using deciduous defoliation principles.",
                    "Foliage work should instead focus on selective pruning, shoot control, density management and removal of unhealthy or unwanted growth where appropriate.",
                    "Never present full defoliation as a standard refinement technique for this profile.",
                ]
            ),
            SpeciesProfileSection(
                id: "repotting",
                title: "Repotting",
                paragraphs: [
                    "Repotting frequency should depend on root development, substrate condition, drainage, container size, tree health and development stage.",
                    "Do not establish a fixed calendar rule.",
                    "A young development tree may require different root management from an old refined tree.",
                    "Avoid excessive root removal. Major root reduction should not automatically be combined with multiple other major stresses.",
                    "Repotting should be followed by appropriate recovery management based on the individual tree and conditions.",
                ]
            ),
            SpeciesProfileSection(
                id: "trunk-development",
                title: "Trunk Development",
                paragraphs: [
                    "'Stricta' can be useful for developing elegant upright trunks.",
                    "During development, use selected extension growth and structural planning to increase thickness. Possible approaches may include allowing selected leaders to extend, sacrifice growth where appropriate, controlled container development, gradual trunk selection and staged structural pruning.",
                    "Avoid presenting any one method as mandatory.",
                    "Once sufficient trunk development has been achieved, shift focus toward branch structure, ramification, foliage density, silhouette and refinement.",
                    "Grow where development is required. Control where refinement is required.",
                ]
            ),
            SpeciesProfileSection(
                id: "nebari-development",
                title: "Nebari Development",
                paragraphs: [
                    "Nebari should be considered early.",
                    "Potential approaches include root selection, radial root positioning, appropriate container development and gradual correction of crossing or dominant roots.",
                    "The objective is a stable and visually convincing root base — not simply a large quantity of roots.",
                ]
            ),
            SpeciesProfileSection(
                id: "grafting",
                title: "Grafting",
                paragraphs: [
                    "Grafting may be relevant where a branch is missing, foliage distribution needs correction or a specific structural improvement is required.",
                    "Do not present grafting as routine care.",
                    "Detailed procedures belong in Bonsai World Propagation and Grafting Knowledge Articles.",
                    "The Species Profile explains relevance; it does not duplicate complete procedural instructions.",
                ]
            ),
            SpeciesProfileSection(
                id: "propagation",
                title: "Propagation",
                paragraphs: [
                    "Juniperus chinensis 'Stricta' is a named horticultural selection.",
                    "Propagation intended to reproduce the characteristics of the cultivar should normally preserve the selected genotype through vegetative propagation rather than relying on seed.",
                    "Relevant methods may include cuttings and other appropriate vegetative techniques.",
                    "Do not suggest that seedlings will automatically reproduce 'Stricta' characteristics.",
                    "Detailed propagation procedures belong in Bonsai World Propagation Knowledge Articles.",
                ]
            ),
            SpeciesProfileSection(
                id: "pests",
                title: "Pests and Problems",
                paragraphs: [
                    "Potential problems may include aphids, scale insects, mites, caterpillars or other foliage-feeding pests, root problems associated with excessive moisture, Phytophthora and other root-related disease risks, canker and other branch or stem problems, and foliage browning caused by environmental stress.",
                    "Do not present a single generic treatment list.",
                    "Diagnosis and treatment must be handled in Care → Pest Management and Problems.",
                    "This Species Profile identifies tendencies and risks and should link to dedicated knowledge as that system develops.",
                ]
            ),
            SpeciesProfileSection(
                id: "seasonal",
                title: "Seasonal Profile",
                paragraphs: [
                    "Spring: increasing activity. Monitor new growth, water demand, structural decisions, pruning requirements, wiring follow-up and pest activity. Use species-specific timing as guidance rather than a rigid universal calendar.",
                    "Summer: active growth. Monitor water demand, strong sunlight, wind exposure, foliage health, wire marks and pest activity. Maintain healthy foliage while controlling excessive extension where refinement requires it.",
                    "Autumn: growth gradually slows. Review overall structure, foliage density, wire condition and health before winter. Avoid unnecessary major stress as the tree prepares for winter.",
                    "Winter: Juniperus chinensis 'Stricta' remains an outdoor evergreen bonsai. Winter dormancy and seasonal conditions remain important.",
                    "The major bonsai concern is protecting the root system from severe and prolonged freezing, especially in shallow containers. Also monitor winter wind, desiccation, repeated freeze-thaw conditions and excessive moisture in cold substrate.",
                    "Do not move the tree indoors for normal winter cultivation. Winter protection must depend on minimum temperatures, duration of freezing, wind, container depth, root condition and local climate.",
                ]
            ),
            SpeciesProfileSection(
                id: "styles",
                title: "Bonsai Styles",
                paragraphs: [
                    "Juniperus chinensis 'Stricta' has a naturally upright character.",
                    "Particularly suitable styles may include Formal Upright, Informal Upright, Literati where the material supports the design, Slanting where trunk movement and material allow, and Group Planting.",
                    "Do not state that every tree is suitable for every style. The material must determine the final design.",
                    "Avoid forcing naturally suitable material into an unsuitable design simply to fit a style category.",
                ]
            ),
            SpeciesProfileSection(
                id: "tree-stage",
                title: "Development by Tree Stage",
                paragraphs: [
                    "Seedling / young material: establish healthy roots, build vigour, begin structural direction and establish trunk potential.",
                    "Cutting / young nursery material: establish roots, build health, begin trunk and branch selection and avoid premature refinement.",
                    "Nursery stock: identify trunk potential, identify usable primary branches, evaluate possible front and begin structural planning.",
                    "Pre-bonsai: establish trunk line, establish primary branches, develop root base and begin controlled structural refinement.",
                    "In training: branch development, foliage distribution, ramification, wiring, pruning and refinement of structural hierarchy.",
                    "Refinement: compact foliage structure, branch hierarchy, silhouette, controlled extension and careful foliage management.",
                    "Exhibition / mature refined tree: maintain health, preserve refined structure, avoid unnecessary major intervention and maintain presentation quality.",
                ]
            ),
            SpeciesProfileSection(
                id: "attention",
                title: "Species-Specific Attention",
                paragraphs: [
                    "These attention points are operational tendencies. They must still be interpreted for the individual tree.",
                ],
                bullets: [
                    "Preserve healthy foliage on branches intended to remain viable",
                    "Do not assume reliable budding from completely bare old wood",
                    "Avoid permanently wet substrate",
                    "Monitor water demand closely in shallow containers",
                    "Strong light is beneficial, but recent work and tree health must be considered",
                    "Watch wire carefully on actively thickening branches",
                    "Use extension growth strategically during development",
                    "Do not use deciduous defoliation techniques",
                    "Protect shallow root systems during severe winter conditions",
                    "Do not move the tree indoors as routine winter care",
                ]
            ),
        ]
    }
}
