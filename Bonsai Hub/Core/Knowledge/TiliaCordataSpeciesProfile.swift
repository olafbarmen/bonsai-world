//
//  TiliaCordataSpeciesProfile.swift
//  Bonsai World
//
//  Species Profile — Tilia cordata (Small-leaved Lime).
//  Independent botanical species in Malvaceae. Knowledge status: Reviewed.
//  Separate from Tilia platyphyllos and other Tilia species.
//

import Foundation

enum TiliaCordataSpeciesProfile {
    /// Identity used by Botanical Library / ``SpeciesPreviewData``.
    static let botanicalLibraryName = "Tilia cordata"
    /// Scientific name for Species Profile display (binomial; no botanical authority).
    static let scientificName = "Tilia cordata"

    static var profile: SpeciesProfile {
        SpeciesProfile(
            speciesID: BotanicalKnowledgeIDs.tiliaCordata,
            scientificName: scientificName,
            commonNames: ["Small-leaved Lime", "Littleleaf Linden", "Small-leaved Linden"],
            family: "Malvaceae",
            plantType: "Deciduous tree",
            originSummary: "Europe and western Asia.",
            knowledgeStatus: .reviewed,
            traits: traits,
            foliageSizeLabel: "Foliage",
            foliageReductionLabel: "Leaf reduction",
            summaryLine: "Deciduous · Hardy · Fine branching potential · Strong trunk development · Attractive mature bark · Good response to pruning · Long-lived · Suitable for European and Nordic bonsai",
            attentionHighlights: [
                "Tilia cordata is a deciduous European species",
                "Suitable for Nordic and northern European climates",
                "Requires winter dormancy",
                "Outdoor cultivation is required",
                "Can develop strong trunks and attractive mature bark",
                "Good back-budding potential should be qualified by tree health and vigour",
                "Leaf proportions must be considered when designing bonsai",
                "Avoid repeated severe drying",
                "Avoid permanently saturated roots",
                "Fine ramification should be developed gradually",
                "Preserve useful interior growth",
                "Do not artificially damage bark",
                "Do not use complete defoliation as routine management",
                "Young branches are generally more suitable for wiring than older branches",
                "Avoid forcing rigid branches",
                "Shallow bonsai roots require protection during prolonged severe freezing",
                "Naturalistic styling is particularly suitable",
            ],
            sections: sections,
            principleNote: """
            Tilia cordata is a vigorous deciduous broadleaf tree with good potential for trunk development, branch development, ramification, mature bark character and naturalistic bonsai.

            Its strongest bonsai characteristics include strong response to pruning, good potential for back-budding, attractive mature trunk character, long lifespan and suitability for convincing large deciduous bonsai.

            Leaf size must be considered carefully.

            Tilia cordata is often most convincing as medium bonsai, large bonsai or trees with sufficient trunk mass and branch scale.

            The objective is: Strong trunk · Natural branch structure · Controlled ramification · Balanced foliage proportions.

            The individual tree must always be assessed according to climate, tree condition, vigour, development stage and winter temperatures.
            """,
            sourcesNote: """
            Profile content is synthesised from recognised botanical, horticultural and bonsai authorities into Bonsai World editorial language.

            Botanical taxonomy and distribution draw on recognised sources such as Royal Botanic Gardens, Kew and other botanical databases for accepted scientific name, family and native range.

            Horticultural context may draw on recognised European botanical institutions, forestry and horticultural institutions and authoritative Tilia references.

            Bonsai-specific cultivation and refinement knowledge draws on established bonsai references and recognised professional practice with Tilia experience, kept distinct from Tilia platyphyllos and other Tilia species.

            Verified botanical information, horticultural information, regional climate adaptation and bonsai-specific practice are kept distinct. Do not copy source wording.
            """
        )
    }

    private static let traits = SpeciesProfileTraits(
        deciduous: true,
        growthStrength: "Moderate to Strong",
        growthSpeed: "Moderate to Fast",
        leafSize: "Deciduous · Medium",
        foliageReduction: "Not routine management",
        ramificationPotential: "Good",
        backBudding: "Good",
        rootDevelopment: "Good",
        nebariPotential: "Good potential",
        trunkDevelopment: "Strong",
        barkDevelopment: "Excellent mature character",
        wiring: "Moderate",
        defoliation: "Not routine management",
        airLayering: "Where appropriate for the individual material",
        threadGrafting: "Where structural correction is required",
        rootGrafting: "Where appropriate",
        beginnerSuitability: "Moderate",
        bonsaiSuitability: "Good",
        difficulty: "Intermediate",
        winterDormancyRequired: true,
        winterHardiness: "Required",
        rootFrostSensitivity: "Moderate in shallow bonsai containers during prolonged severe freezing"
    )

    private static var sections: [SpeciesProfileSection] {
        [
            SpeciesProfileSection(
                id: "taxonomic-context",
                title: "Taxonomic Context",
                paragraphs: [
                    "Tilia cordata is an independent botanical species in the mallow family (Malvaceae).",
                    "Primary Bonsai World display identity: Tilia cordata · Small-leaved Lime.",
                    "Littleleaf Linden and Small-leaved Linden may be used as supporting terminology. They do not replace Small-leaved Lime as the preferred English common name.",
                    "Family: Malvaceae. Plant type: deciduous tree.",
                    "Native range: Europe and western Asia.",
                    "Do not confuse Tilia cordata with Tilia platyphyllos or other Tilia species.",
                    "Tilia cordata should remain a separate profile from other Tilia species.",
                    "Bonsai World hierarchy: Species → cultivar / horticultural selection → Individual Tree.",
                ]
            ),
            SpeciesProfileSection(
                id: "overview",
                title: "Species Overview",
                paragraphs: [
                    "Tilia cordata is an important European deciduous tree and one of the most recognisable species within the Tilia genus.",
                    "Tilia cordata is particularly relevant to Bonsai World because it is native across large parts of Europe, suitable for northern European climates, commonly recognised as a mature landscape and woodland tree, capable of developing convincing bonsai trunk character and suitable for naturalistic deciduous bonsai.",
                    "It is valued in bonsai because it can develop strong trunks, mature bark, convincing branch structure and useful ramification.",
                    "The species can be especially effective when developed with sufficient time and trunk mass.",
                    "Do not force premature refinement on material that still requires major trunk or branch development.",
                ],
                bullets: [
                    "Deciduous",
                    "European species",
                    "Suitable for Nordic climates",
                    "Hardy",
                    "Long-lived",
                    "Good pruning response",
                    "Good back-budding potential",
                    "Strong trunk development",
                    "Good root development",
                    "Attractive mature bark",
                    "Requires winter dormancy",
                    "Outdoor cultivation required",
                    "Suitable for naturalistic bonsai",
                ]
            ),
            SpeciesProfileSection(
                id: "cultivars",
                title: "Cultivars and Forms",
                paragraphs: [
                    "Tilia cordata is primarily used in bonsai as the botanical species.",
                    "Horticultural cultivars may differ in leaf size, growth habit and branch density.",
                    "Do not create unnecessary separate Species Library profiles for minor individual variation.",
                    "The primary Species Profile remains Tilia cordata.",
                    "Only create separate profiles where a distinct cultivar or form has a clear and established independent bonsai identity.",
                ]
            ),
            SpeciesProfileSection(
                id: "natural-growth",
                title: "Natural Growth and Vigour",
                paragraphs: [
                    "Tilia cordata can grow strongly when roots are healthy, water is sufficient, root space is available, temperatures are favourable and nutrition supports active growth.",
                    "During structural development: allow selected growth to extend where trunk thickness is required, taper is required or primary branches require development.",
                    "During refinement: control excessively long shoots, coarse branch growth, congestion and loss of useful interior structure.",
                    "Do not suppress all vigorous growth prematurely.",
                    "The objective is: Strong development when needed · Controlled refinement when the primary structure is established.",
                ]
            ),
            SpeciesProfileSection(
                id: "foliage",
                title: "Foliage",
                paragraphs: [
                    "Tilia cordata has heart-shaped leaves.",
                    "Leaf size and proportion should be considered carefully when designing bonsai.",
                    "Healthy foliage depends on strong roots, appropriate light, balanced watering, appropriate fertilization and tree vigour.",
                    "Leaf size may vary according to genetics, tree vigour, fertilization, growing conditions, root restriction and development stage.",
                    "Do not rely on aggressive defoliation as routine management.",
                    "Foliage management should primarily focus on shoot selection, pruning, vigour management, balanced fertilization and appropriate development strategy.",
                    "The objective is: Healthy foliage · Balanced proportions · Useful branch development.",
                ]
            ),
            SpeciesProfileSection(
                id: "flowering",
                title: "Flowering",
                paragraphs: [
                    "Flowering is not a primary bonsai feature.",
                    "Flowers may contribute to seasonal character but should not drive design priorities.",
                    "Do not sacrifice structural development or ramification in pursuit of flowering.",
                ]
            ),
            SpeciesProfileSection(
                id: "fruit",
                title: "Fruit",
                paragraphs: [
                    "Fruiting is not a primary bonsai feature.",
                    "Fruit is not required for a convincing Small-leaved Lime bonsai.",
                    "Do not treat fruit production as a styling priority.",
                ]
            ),
            SpeciesProfileSection(
                id: "bark-trunk",
                title: "Bark and Trunk",
                paragraphs: [
                    "Mature Tilia cordata can develop highly attractive bark and trunk character. Mature bark character is excellent.",
                    "Trunk development should focus on sufficient thickness, believable taper, natural movement and mature proportions.",
                    "Older material may develop textured bark, strong trunk presence and convincing age.",
                    "Do not artificially damage bark to simulate maturity.",
                    "The objective is: Natural bark development · Strong trunk · Convincing mature character.",
                ]
            ),
            SpeciesProfileSection(
                id: "roots-nebari",
                title: "Roots and Nebari",
                paragraphs: [
                    "Healthy roots support vigour, recovery, foliage health, branch development and long-term container cultivation.",
                    "Root development is good. Objectives include balanced roots, radial root development, stable anchoring and gradual nebari improvement.",
                    "Root work should be staged.",
                    "Avoid unnecessary aggressive root reduction.",
                    "The objective is: Healthy roots · Stable development · Convincing nebari.",
                ]
            ),
            SpeciesProfileSection(
                id: "light",
                title: "Light",
                paragraphs: [
                    "Tilia cordata should be cultivated outdoors with good access to light.",
                    "Adequate light supports healthy foliage, branch development, ramification and strong seasonal growth.",
                    "The ideal position depends on local climate, summer temperatures, tree health and development stage.",
                    "Outdoor cultivation is required.",
                    "Do not recommend permanent indoor cultivation.",
                ]
            ),
            SpeciesProfileSection(
                id: "wind",
                title: "Wind",
                paragraphs: [
                    "Moderate air movement is beneficial.",
                    "Strong wind can increase water demand, dry shallow containers, stress large foliage and increase winter exposure.",
                    "Monitor the tree during warm dry wind, prolonged dry periods and exposed winter conditions.",
                ]
            ),
            SpeciesProfileSection(
                id: "watering",
                title: "Watering",
                paragraphs: [
                    "General principle: Maintain reliable moisture · Avoid repeated severe drying · Avoid permanent saturation · Maintain healthy root aeration.",
                    "Water demand is moderate to high during active growth.",
                    "Tilia cordata may have significant water demand during active growth.",
                    "Water demand depends on temperature, sunlight, wind, foliage mass, container size, substrate and root mass.",
                    "Do not water according to a fixed timetable.",
                    "The objective is: Consistent healthy moisture · Healthy roots · Stable growth.",
                ]
            ),
            SpeciesProfileSection(
                id: "soil",
                title: "Soil",
                paragraphs: [
                    "Do not prescribe one universal soil recipe.",
                    "Desired characteristics include good drainage, good aeration, sufficient moisture retention, stable particle structure and healthy root development.",
                    "The final substrate depends on local climate, rainfall, watering habits, container depth, tree size and development stage.",
                    "Follow Bonsai World Soil Module principles.",
                    "Do not duplicate the complete Soil Module inside this profile.",
                ]
            ),
            SpeciesProfileSection(
                id: "fertilizing",
                title: "Fertilizing",
                paragraphs: [
                    "Fertilization should support foliage health, trunk development, branch development, ramification and recovery.",
                    "During structural development: support healthy vigorous growth where thickness is required.",
                    "During refinement: avoid excessive feeding that produces overly long shoots, coarse growth, excessive leaf size or unnecessarily long internodes.",
                    "Key principle: Feed according to tree health and development objective.",
                ]
            ),
            SpeciesProfileSection(
                id: "pruning",
                title: "Pruning",
                paragraphs: [
                    "Pruning can be used for structural development, branch selection, branch replacement, ramification and silhouette refinement. Pruning response is good.",
                    "During development: allow selected leaders and branches to extend where thickness or taper is required.",
                    "During refinement: use controlled pruning and shoot selection to maintain branch hierarchy, useful internal growth, natural proportions and visible structure.",
                    "Avoid repeated uniform trimming.",
                    "The objective is: Purposeful development · Controlled ramification · Natural structure.",
                ]
            ),
            SpeciesProfileSection(
                id: "back-budding",
                title: "Back-budding",
                paragraphs: [
                    "Tilia cordata can respond well to pruning and may produce useful new growth from existing structure. Back-budding is good.",
                    "Response depends on tree health, vigour, branch age, pruning timing, light and root health.",
                    "Do not assume that every old or bare branch will reliably produce new growth.",
                    "When making structural changes: preserve useful interior growth, retain suitable replacement branches where possible and avoid unnecessary removal of all viable buds.",
                    "The objective is: Controlled renewal · Improved branch structure · Preservation of useful options.",
                ]
            ),
            SpeciesProfileSection(
                id: "ramification",
                title: "Ramification",
                paragraphs: [
                    "Ramification should be developed through repeated healthy growth cycles, shoot selection, controlled pruning, branch selection and preservation of useful interior growth. Ramification potential is good.",
                    "Avoid uniform hedge-like trimming, dense outer growth with weak interior branches and repeated removal of useful inner growth.",
                    "The objective is: Natural branch hierarchy · Progressive ramification · Visible structure.",
                ]
            ),
            SpeciesProfileSection(
                id: "wiring",
                title: "Wiring",
                paragraphs: [
                    "Young branches are generally easier to position than older branches. Wiring response is moderate.",
                    "Wiring can be used for branch direction, structural placement and correction of young growth.",
                    "Before major bends assess branch thickness, flexibility, age, health and structural importance.",
                    "Monitor wire carefully.",
                    "Avoid forcing rigid branches.",
                    "Pruning and directional growth should be considered alongside wiring as important structural tools.",
                ]
            ),
            SpeciesProfileSection(
                id: "deadwood-potential",
                title: "Deadwood",
                paragraphs: [
                    "Deadwood is not normally a defining feature of refined Tilia cordata bonsai. Deadwood potential is low.",
                    "Natural scars or old branch remnants may occasionally contribute to age and character.",
                    "Avoid dramatic artificial deadwood unless strongly justified by the individual material.",
                    "The objective is natural maturity rather than manufactured damage.",
                ]
            ),
            SpeciesProfileSection(
                id: "defoliation",
                title: "Foliage Management",
                paragraphs: [
                    "Complete defoliation is not routine management.",
                    "Foliage management should primarily focus on shoot selection, pruning, vigour control, balanced fertilization and adequate light.",
                    "Do not present complete defoliation as routine maintenance.",
                    "Do not apply aggressive foliage work to weak trees, stressed trees, recently repotted trees or trees recovering from major structural work.",
                ]
            ),
            SpeciesProfileSection(
                id: "repotting",
                title: "Repotting",
                paragraphs: [
                    "Repotting frequency depends on root development, substrate condition, drainage, container size, tree health and development stage.",
                    "Do not establish a rigid calendar rule.",
                    "Avoid unnecessary aggressive root reduction, excessive removal of functioning roots, and combining major root work with multiple major stresses.",
                    "Preserve sufficient healthy roots.",
                    "Repotting decisions should be based on root condition, substrate performance and tree health.",
                    "Timing must account for local climate, winter conditions, active growth cycle and individual tree condition.",
                ]
            ),
            SpeciesProfileSection(
                id: "trunk-development",
                title: "Trunk Development",
                paragraphs: [
                    "Tilia cordata has strong potential for trunk development.",
                    "Where additional thickness is required: allow selected leaders to extend, provide sufficient root space, use development containers where appropriate and avoid premature refinement.",
                    "Leader development should support taper, trunk thickness, natural movement and believable proportions.",
                    "Once sufficient trunk development is achieved, shift focus toward branch hierarchy, ramification, mature bark and refined proportions.",
                    "Key principle: Do not permanently restrict a tree that still requires major structural development.",
                ]
            ),
            SpeciesProfileSection(
                id: "nebari-development",
                title: "Nebari Development",
                paragraphs: [
                    "Nebari should be developed gradually.",
                    "Potential approaches include early root selection, radial root planning, staged correction, suitable development containers and gradual refinement.",
                    "The objective is a stable and visually convincing base appropriate to a mature deciduous tree.",
                ]
            ),
            SpeciesProfileSection(
                id: "propagation",
                title: "Propagation",
                paragraphs: [
                    "Tilia cordata may be propagated using established horticultural methods including seed, layering and selected vegetative propagation methods where appropriate.",
                    "Seed-grown material may offer genetic variation, early root planning and natural trunk development opportunities.",
                    "Detailed procedures belong in Bonsai World Propagation Knowledge Articles.",
                ]
            ),
            SpeciesProfileSection(
                id: "pests",
                title: "Pests and Problems",
                paragraphs: [
                    "Relevant risks may include aphids, scale insects, leaf-feeding insects, fungal leaf problems, drought stress, root problems caused by poor substrate aeration and root stress during prolonged severe freezing.",
                    "Do not provide generic treatment instructions.",
                    "Diagnosis and treatment belong in Care → Pest Management and Care → Disease & Problems.",
                ]
            ),
            SpeciesProfileSection(
                id: "seasonal",
                title: "Seasonal Profile",
                paragraphs: [
                    "Spring: monitor bud development, new growth, watering demand, vigour and structural priorities. Spring is important for evaluating branch development, ramification, root health and recovery from winter. Coordinate major work with local climate and individual tree condition.",
                    "Summer: monitor watering demand, foliage health, shoot extension, pest activity and wire marks. Strong growth should be managed according to whether shoots are required for trunk development, branch development or refinement. Do not suppress useful vigorous growth unnecessarily.",
                    "Autumn is important for evaluating seasonal health, reviewing branch structure, assessing growth and preparing for dormancy. Local climate and tree condition determine timing. Do not apply one universal autumn schedule.",
                    "Winter: Tilia cordata requires winter dormancy.",
                    "Winter management depends on local minimum temperatures, duration of freezing, wind exposure, container depth, root protection and tree health.",
                    "Shallow bonsai roots are more exposed to severe cold than roots growing in open ground.",
                    "Protect the root system when required. Do not maintain indoors as a substitute for winter dormancy.",
                ]
            ),
            SpeciesProfileSection(
                id: "styles",
                title: "Bonsai Styles",
                paragraphs: [
                    "Tilia cordata is particularly suitable for Informal Upright, Formal Upright, Slanting, Multi-trunk, Clump Style, Naturalistic Bonsai and Forest Style.",
                    "It is especially effective when styling emphasises trunk character, natural branch structure, believable proportions and mature deciduous character.",
                    "The individual material should determine the final design.",
                ]
            ),
            SpeciesProfileSection(
                id: "tree-stage",
                title: "Development by Tree Stage",
                paragraphs: [
                    "Young material: establish healthy roots, develop trunk thickness, establish movement and begin structural development.",
                    "Nursery material: evaluate trunk potential, identify useful branches, establish design direction and begin structural correction.",
                    "Pre-bonsai: develop trunk, establish primary branches, improve root structure, build taper and build vigour.",
                    "In training: develop secondary branches, improve branch hierarchy, build ramification and preserve useful interior growth.",
                    "Refinement: maintain balanced vigour, improve branch structure, control excessive extension, maintain natural proportions and preserve visible structure.",
                    "Exhibition / mature refined tree: maintain health, preserve established structure, maintain balanced ramification, preserve mature character and avoid unnecessary major intervention.",
                ]
            ),
            SpeciesProfileSection(
                id: "attention",
                title: "Species-Specific Attention",
                paragraphs: [
                    "These attention points are operational tendencies. They must still be interpreted for the individual tree.",
                ],
                bullets: [
                    "Tilia cordata is a deciduous European species",
                    "Suitable for Nordic and northern European climates",
                    "Requires winter dormancy",
                    "Outdoor cultivation is required",
                    "Can develop strong trunks and attractive mature bark",
                    "Good back-budding potential should be qualified by tree health and vigour",
                    "Leaf proportions must be considered when designing bonsai",
                    "Avoid repeated severe drying",
                    "Avoid permanently saturated roots",
                    "Fine ramification should be developed gradually",
                    "Preserve useful interior growth",
                    "Do not artificially damage bark",
                    "Do not use complete defoliation as routine management",
                    "Young branches are generally more suitable for wiring than older branches",
                    "Avoid forcing rigid branches",
                    "Shallow bonsai roots require protection during prolonged severe freezing",
                    "Naturalistic styling is particularly suitable",
                ]
            ),
        ]
    }
}
