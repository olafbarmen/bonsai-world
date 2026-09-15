//
//  AcerGinnalaSpeciesProfile.swift
//  Bonsai World
//
//  Species Profile — Acer ginnala (Amur Maple).
//  Independent botanical species in Sapindaceae. Knowledge status: Reviewed.
//  Separate from Acer palmatum, Acer campestre, Acer tataricum and other Acer species.
//

import Foundation

enum AcerGinnalaSpeciesProfile {
    /// Identity used by Botanical Library / ``SpeciesPreviewData``.
    static let botanicalLibraryName = "Acer ginnala"
    /// Scientific name for Species Profile display (binomial; no botanical authority).
    static let scientificName = "Acer ginnala"

    static var profile: SpeciesProfile {
        SpeciesProfile(
            speciesID: BotanicalKnowledgeIDs.acerGinnala,
            scientificName: scientificName,
            commonNames: ["Amur Maple", "Siberian Maple"],
            family: "Sapindaceae",
            plantType: "Deciduous tree",
            originSummary: "Northeastern Asia, including parts of China, Mongolia, Korea and the Russian Far East.",
            knowledgeStatus: .reviewed,
            traits: traits,
            foliageSizeLabel: "Foliage",
            foliageReductionLabel: "Leaf reduction",
            summaryLine: "Deciduous · Hardy · Small leaves · Strong autumn colour · Good ramification potential · Responsive to pruning · Suitable for smaller bonsai · Suitable for northern climates · Requires winter dormancy",
            attentionHighlights: [
                "Acer ginnala is a deciduous maple",
                "It has naturally relatively small foliage",
                "Strong autumn colour is a defining feature",
                "Requires winter dormancy",
                "Outdoor cultivation is required",
                "Suitable for northern climates",
                "Good back-budding should be qualified by tree health and branch condition",
                "Do not assume every old or bare branch will reliably regenerate",
                "Avoid repeated severe drying",
                "Avoid permanently saturated roots",
                "Fine ramification should be developed gradually",
                "Preserve useful interior growth",
                "Do not use complete defoliation as routine management",
                "Young branches are generally easier to position than older branches",
                "Avoid forcing rigid branches",
                "Do not artificially damage bark",
                "Shallow bonsai roots require protection during prolonged severe freezing",
            ],
            sections: sections,
            principleNote: """
            Acer ginnala should be developed as a naturally refined deciduous bonsai.

            Its principal advantages include relatively small leaves, good ramification potential, strong autumn colour, responsive growth and good suitability for compact bonsai proportions.

            The species can be refined successfully without forcing excessive artificial density.

            The objective is: Natural trunk · Clear branch hierarchy · Fine ramification · Balanced foliage · Strong seasonal character.

            Avoid treating Acer ginnala exactly like Acer palmatum, Acer buergerianum or Acer campestre.

            Species-specific growth and response should remain the basis for development decisions.

            The individual tree must always be assessed according to climate, tree condition, vigour, development stage and winter temperatures.
            """,
            sourcesNote: """
            Profile content is synthesised from recognised botanical, horticultural and bonsai authorities into Bonsai World editorial language.

            Botanical taxonomy and distribution draw on recognised sources such as Royal Botanic Gardens, Kew and other botanical databases for accepted scientific name, family and native range.

            Where botanical sources discuss Acer ginnala in relation to Acer tataricum, Bonsai World preserves the accepted name used by the Botanical Library and does not create duplicate species records.

            Horticultural context may draw on recognised botanical and horticultural institutions and authoritative Acer references.

            Bonsai-specific cultivation and refinement knowledge draws on established bonsai references and recognised professional practice with Acer experience, kept distinct from Acer palmatum, Acer campestre, Acer tataricum and other Acer species.

            Verified botanical information, horticultural information, regional climate adaptation and bonsai-specific practice are kept distinct. Do not copy source wording.
            """
        )
    }

    private static let traits = SpeciesProfileTraits(
        deciduous: true,
        growthStrength: "Moderate to Strong",
        growthSpeed: "Moderate",
        leafSize: "Deciduous · Small",
        foliageReduction: "Not routine management",
        ramificationPotential: "Good",
        backBudding: "Good",
        rootDevelopment: "Good",
        nebariPotential: "Good potential",
        trunkDevelopment: "Moderate",
        barkDevelopment: "Good mature character",
        wiring: "Moderate",
        defoliation: "Not routine management",
        airLayering: "Where appropriate for the individual material",
        threadGrafting: "Where structural correction is required",
        rootGrafting: "Where appropriate",
        beginnerSuitability: "Good",
        bonsaiSuitability: "Very Good",
        difficulty: "Beginner to Intermediate",
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
                    "Acer ginnala is an independent botanical species in the soapberry family (Sapindaceae).",
                    "Primary Bonsai World display identity: Acer ginnala · Amur Maple.",
                    "Siberian Maple may be used as supporting terminology. It does not replace Amur Maple as the preferred English common name.",
                    "Family: Sapindaceae. Plant type: deciduous tree.",
                    "Native range: Northeastern Asia, including parts of China, Mongolia, Korea and the Russian Far East.",
                    "Do not confuse Acer ginnala with Acer palmatum, Acer campestre or Acer tataricum.",
                    "Where botanical sources discuss Acer ginnala in relation to Acer tataricum, preserve the accepted name used by the Bonsai World Botanical Library and avoid creating duplicate species records.",
                    "Bonsai World hierarchy: Species → cultivar / horticultural selection → Individual Tree.",
                ]
            ),
            SpeciesProfileSection(
                id: "overview",
                title: "Species Overview",
                paragraphs: [
                    "Acer ginnala is a deciduous maple native to northeastern Asia.",
                    "Acer ginnala is particularly relevant to Bonsai World because it offers naturally relatively small foliage, strong autumn colour, good bonsai proportions, suitability for smaller and medium-sized bonsai, strong northern and continental climate relevance and good potential for ramification.",
                    "It is particularly valued for bonsai because it combines relatively small leaves, manageable proportions, good autumn colour, useful ramification potential and hardiness.",
                    "The species can be suitable for smaller bonsai, medium bonsai, naturalistic deciduous designs and refined deciduous bonsai.",
                    "Its small foliage can help achieve convincing proportions earlier than with many larger-leaved deciduous species.",
                    "Long-term development should still prioritise trunk quality, taper, branch hierarchy and healthy roots.",
                    "Do not prioritise foliage refinement before the basic structure is sufficiently developed.",
                ],
                bullets: [
                    "Deciduous",
                    "Hardy",
                    "Northeastern Asian species",
                    "Relatively small leaves",
                    "Strong autumn colour",
                    "Good pruning response",
                    "Good back-budding potential",
                    "Good ramification potential",
                    "Suitable for smaller bonsai",
                    "Requires winter dormancy",
                    "Outdoor cultivation required",
                    "Suitable for northern climates",
                ]
            ),
            SpeciesProfileSection(
                id: "cultivars",
                title: "Cultivars and Forms",
                paragraphs: [
                    "Acer ginnala is primarily used in bonsai as the botanical species.",
                    "Horticultural cultivars may differ in foliage colour, growth habit and branch density.",
                    "Do not create unnecessary separate Species Library profiles for minor individual variation.",
                    "The primary Species Profile remains Acer ginnala.",
                    "Only create separate profiles where a distinct cultivar or form has a clear and established independent bonsai identity.",
                ]
            ),
            SpeciesProfileSection(
                id: "natural-growth",
                title: "Natural Growth and Vigour",
                paragraphs: [
                    "Acer ginnala can grow steadily and respond well when roots are healthy, water is appropriately managed, light is sufficient, nutrition supports growth and root space is available.",
                    "During structural development: allow selected growth to extend where trunk thickness is required, taper is required or primary branches require development.",
                    "During refinement: control excessive extension, coarse shoots, unnecessary congestion and loss of interior branch structure.",
                    "Do not suppress useful structural growth too early.",
                    "The objective is: Healthy development · Strong structure · Progressive refinement.",
                ]
            ),
            SpeciesProfileSection(
                id: "foliage",
                title: "Foliage",
                paragraphs: [
                    "Acer ginnala has relatively small, distinctive leaves.",
                    "Foliage is one of the species' important advantages for bonsai.",
                    "Healthy foliage depends on strong roots, appropriate light, balanced watering, appropriate fertilization and stable vigour.",
                    "Leaf size may vary according to genetics, tree vigour, fertilization, growing conditions, root restriction and development stage.",
                    "Do not rely on aggressive defoliation as routine management.",
                    "The primary objective is: Healthy foliage · Natural proportions · Controlled growth.",
                ]
            ),
            SpeciesProfileSection(
                id: "flowering",
                title: "Flowering",
                paragraphs: [
                    "Flowering is not a primary bonsai feature.",
                    "Do not sacrifice structural development or ramification in pursuit of flowering.",
                ]
            ),
            SpeciesProfileSection(
                id: "fruit",
                title: "Fruit",
                paragraphs: [
                    "Fruit-bearing is not a primary bonsai feature.",
                    "Samaras are not required for a convincing Amur Maple bonsai.",
                    "Do not treat fruit production as a styling priority.",
                ]
            ),
            SpeciesProfileSection(
                id: "bark-trunk",
                title: "Bark and Trunk",
                paragraphs: [
                    "Acer ginnala can develop attractive mature trunk character over time. Mature bark character is good.",
                    "Trunk development should focus on sufficient thickness, believable taper, natural movement and appropriate proportions.",
                    "Do not artificially damage bark to simulate maturity.",
                    "The objective is: Natural development · Strong trunk · Believable age.",
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
                    "Acer ginnala should be cultivated outdoors with good access to light.",
                    "Adequate light supports healthy foliage, compact growth, branch development, ramification and autumn colour.",
                    "The ideal position depends on local climate, summer temperatures, tree health and development stage.",
                    "In hot or exposed conditions, excessive stress should be avoided.",
                    "Outdoor cultivation is required.",
                    "Do not recommend permanent indoor cultivation.",
                ]
            ),
            SpeciesProfileSection(
                id: "wind",
                title: "Wind",
                paragraphs: [
                    "Moderate air movement is beneficial.",
                    "Strong wind can increase water demand, dry foliage, dry shallow containers and increase winter exposure.",
                    "Monitor during warm dry wind, prolonged dry periods and exposed winter conditions.",
                ]
            ),
            SpeciesProfileSection(
                id: "watering",
                title: "Watering",
                paragraphs: [
                    "General principle: Maintain reliable moisture · Avoid repeated severe drying · Avoid permanent saturation · Maintain healthy root aeration.",
                    "Water demand is moderate.",
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
                    "During refinement: avoid excessive feeding that produces overly long shoots, coarse growth, unnecessarily large foliage or excessively long internodes.",
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
                    "Acer ginnala can respond well to pruning and may produce useful new growth from existing structure. Back-budding is good.",
                    "Response depends on tree health, vigour, branch age, pruning timing, light and root health.",
                    "Do not assume that every old or bare branch will reliably produce new growth.",
                    "When making structural changes: preserve useful interior growth, retain suitable replacement branches and avoid unnecessary removal of viable buds.",
                    "The objective is: Controlled renewal · Improved branch structure · Preservation of useful options.",
                ]
            ),
            SpeciesProfileSection(
                id: "ramification",
                title: "Ramification",
                paragraphs: [
                    "Ramification should be developed through repeated healthy growth cycles, shoot selection, controlled pruning, branch selection and preservation of useful interior growth. Ramification potential is good.",
                    "Avoid uniform hedge-like trimming, dense outer foliage with weak interior branches and repeated removal of useful inner growth.",
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
                    "Deadwood is not normally a defining feature of refined Acer ginnala bonsai. Deadwood potential is low.",
                    "Natural scars or old branch remnants may occasionally contribute to character.",
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
                    "Acer ginnala has good potential for developing convincing trunks, but sufficient development time remains important.",
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
                    "The objective is a stable and visually convincing base appropriate to a mature deciduous bonsai.",
                ]
            ),
            SpeciesProfileSection(
                id: "propagation",
                title: "Propagation",
                paragraphs: [
                    "Acer ginnala may be propagated using established horticultural methods including seed, layering and selected vegetative propagation methods where appropriate.",
                    "Seed-grown material may offer genetic variation, early root planning and natural trunk development opportunities.",
                    "Detailed procedures belong in Bonsai World Propagation Knowledge Articles.",
                ]
            ),
            SpeciesProfileSection(
                id: "pests",
                title: "Pests and Problems",
                paragraphs: [
                    "Relevant risks may include aphids, scale insects, leaf-feeding insects, fungal leaf problems, drought stress, leaf scorch under unsuitable conditions, root problems caused by poor substrate aeration and root stress during prolonged severe freezing.",
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
                    "Autumn is an important season for Acer ginnala because of its characteristic seasonal foliage colour. Monitor foliage health, seasonal development, branch structure, overall vigour and preparation for dormancy. Local climate and tree condition determine timing. Do not apply one universal autumn schedule.",
                    "Winter: Acer ginnala requires winter dormancy.",
                    "Winter management depends on local minimum temperatures, duration of freezing, wind exposure, container depth, root protection and tree health.",
                    "Shallow bonsai roots are more exposed to severe cold than roots growing in open ground.",
                    "Protect the root system when required. Do not maintain indoors as a substitute for winter dormancy.",
                ]
            ),
            SpeciesProfileSection(
                id: "styles",
                title: "Bonsai Styles",
                paragraphs: [
                    "Acer ginnala is particularly suitable for Informal Upright, Formal Upright, Slanting, Multi-trunk, Clump Style, Naturalistic Bonsai and Forest Style.",
                    "It is especially effective when styling emphasises natural trunk movement, fine branching, balanced proportions, visible structure and strong seasonal foliage character.",
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
                    "Acer ginnala is a deciduous maple",
                    "It has naturally relatively small foliage",
                    "Strong autumn colour is a defining feature",
                    "Requires winter dormancy",
                    "Outdoor cultivation is required",
                    "Suitable for northern climates",
                    "Good back-budding should be qualified by tree health and branch condition",
                    "Do not assume every old or bare branch will reliably regenerate",
                    "Avoid repeated severe drying",
                    "Avoid permanently saturated roots",
                    "Fine ramification should be developed gradually",
                    "Preserve useful interior growth",
                    "Do not use complete defoliation as routine management",
                    "Young branches are generally easier to position than older branches",
                    "Avoid forcing rigid branches",
                    "Do not artificially damage bark",
                    "Shallow bonsai roots require protection during prolonged severe freezing",
                ]
            ),
        ]
    }
}
