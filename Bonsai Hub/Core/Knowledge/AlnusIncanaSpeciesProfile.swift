//
//  AlnusIncanaSpeciesProfile.swift
//  Bonsai World
//
//  Species Profile — Alnus incana (Grey Alder).
//  Independent botanical species in Betulaceae. Knowledge status: Reviewed.
//  Separate from Alnus glutinosa and other Alnus species.
//

import Foundation

enum AlnusIncanaSpeciesProfile {
    /// Identity used by Botanical Library / ``SpeciesPreviewData``.
    static let botanicalLibraryName = "Alnus incana"
    /// Scientific name for Species Profile display (binomial; no botanical authority).
    static let scientificName = "Alnus incana"

    static var profile: SpeciesProfile {
        SpeciesProfile(
            speciesID: BotanicalKnowledgeIDs.alnusIncana,
            scientificName: scientificName,
            commonNames: ["Grey Alder", "Gray Alder"],
            family: "Betulaceae",
            plantType: "Deciduous tree",
            originSummary: "Europe, northern and central Asia, and parts of North America depending on recognised subspecies and regional classification.",
            knowledgeStatus: .reviewed,
            traits: traits,
            foliageSizeLabel: "Foliage",
            foliageReductionLabel: "Leaf reduction",
            summaryLine: "Deciduous · Hardy · Nordic relevance · Fast-growing · Moisture-tolerant · Good naturalistic potential · Fine branching with refinement · Requires winter dormancy · Suitable for outdoor bonsai",
            attentionHighlights: [
                "Alnus incana is particularly relevant to Nordic and northern European bonsai",
                "Requires winter dormancy",
                "Outdoor cultivation is required",
                "Strong growth should be used strategically during development",
                "Do not refine prematurely",
                "Moderate to good back-budding depends on health and branch condition",
                "Do not assume every old or bare branch will reliably regenerate",
                "Avoid repeated severe drying",
                "Maintain sufficient moisture during active growth",
                "Avoid permanently stagnant roots",
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
            Alnus incana should be developed with respect for its naturally vigorous and landscape-oriented character.

            The species is particularly suitable for bonsai where the design emphasises natural trunk development, visible seasonal character, believable branch structure and a mature northern landscape appearance.

            Avoid forcing the species into an excessively formal or artificially dense silhouette before the trunk and branch structure justify refinement.

            The objective is: Healthy vigour · Strong trunk development · Natural branching · Progressive ramification · Believable northern character.

            The individual tree must always be assessed according to climate, tree condition, vigour, development stage and winter temperatures.
            """,
            sourcesNote: """
            Profile content is synthesised from recognised botanical, horticultural and bonsai authorities into Bonsai World editorial language.

            Botanical taxonomy and distribution draw on recognised sources such as Royal Botanic Gardens, Kew and other botanical databases for accepted scientific name, family and native range.

            Horticultural context may draw on recognised Nordic and European botanical institutions, forestry institutions and authoritative Alnus references.

            Bonsai-specific cultivation and refinement knowledge draws on established bonsai references and recognised professional practice with Alnus experience, kept distinct from Alnus glutinosa and other Alnus species.

            Verified botanical information, horticultural information, regional climate adaptation and bonsai-specific practice are kept distinct. Do not copy source wording.
            """
        )
    }

    private static let traits = SpeciesProfileTraits(
        deciduous: true,
        growthStrength: "Strong",
        growthSpeed: "Fast",
        leafSize: "Deciduous · Medium",
        foliageReduction: "Not routine management",
        ramificationPotential: "Good with refinement",
        backBudding: "Moderate to Good",
        rootDevelopment: "Strong",
        nebariPotential: "Good potential",
        trunkDevelopment: "Fast when allowed to grow freely",
        barkDevelopment: "Good mature character",
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
                    "Alnus incana is an independent botanical species in the birch family (Betulaceae).",
                    "Primary Bonsai World display identity: Alnus incana · Grey Alder.",
                    "Gray Alder may be listed as an alternative spelling. It does not replace Grey Alder as the preferred English common name.",
                    "Family: Betulaceae. Plant type: deciduous tree.",
                    "Native range: Europe, northern and central Asia, and parts of North America depending on recognised subspecies and regional classification.",
                    "Do not confuse Alnus incana with Alnus glutinosa.",
                    "Do not merge Alnus incana and Alnus glutinosa into one generic Alder profile. Each species retains its own botanical identity and bonsai guidance.",
                    "Bonsai World hierarchy: Species → cultivar / horticultural selection → Individual Tree.",
                ]
            ),
            SpeciesProfileSection(
                id: "overview",
                title: "Species Overview",
                paragraphs: [
                    "Alnus incana is a hardy deciduous alder with broad relevance across northern and central regions.",
                    "Alnus incana is particularly relevant to Bonsai World because it is naturally relevant across large parts of northern Europe, familiar in Nordic landscapes, adapted to relatively cool climates, suitable for naturalistic and landscape-inspired bonsai and useful for growers interested in locally relevant species.",
                    "The species is associated with cool climates, riverbanks and moist landscapes, open woodland and northern European environments.",
                    "For bonsai, its main value lies in vigorous growth, useful trunk development, strong root growth, naturalistic styling potential and seasonal character.",
                    "It should generally be developed first for trunk, taper, root structure and primary branches before refinement becomes the main objective.",
                ],
                bullets: [
                    "Deciduous",
                    "Hardy",
                    "Nordic relevance",
                    "Fast-growing",
                    "Requires winter dormancy",
                    "Outdoor cultivation required",
                    "Good trunk development potential",
                    "Moderate to good back-budding",
                    "Good ramification potential with refinement",
                    "Strong root development",
                    "Naturalistic bonsai suitability",
                    "Moisture demand increases during active growth",
                    "Produces characteristic woody alder cones",
                ]
            ),
            SpeciesProfileSection(
                id: "cultivars",
                title: "Cultivars and Forms",
                paragraphs: [
                    "Alnus incana is primarily used in bonsai as the botanical species.",
                    "Horticultural cultivars and recognised subspecies may differ in foliage appearance, growth habit and regional adaptation.",
                    "Do not create unnecessary separate Species Library profiles for minor individual variation.",
                    "The primary Species Profile remains Alnus incana.",
                    "Only create separate profiles where a distinct cultivar or form has a clear and established independent bonsai identity.",
                ]
            ),
            SpeciesProfileSection(
                id: "natural-growth",
                title: "Natural Growth and Vigour",
                paragraphs: [
                    "Alnus incana can grow strongly when roots are healthy, sufficient moisture is available, light is adequate, temperatures support active growth and root space is available.",
                    "During structural development: allow selected growth to extend where trunk thickness is required, taper is required or primary branches require development.",
                    "During refinement: control excessively long shoots, coarse extension, unnecessary congestion and imbalance between strong and weak areas.",
                    "Do not suppress useful vigorous growth prematurely.",
                    "The objective is: Strong development when required · Controlled growth during refinement.",
                ]
            ),
            SpeciesProfileSection(
                id: "foliage",
                title: "Foliage",
                paragraphs: [
                    "Alnus incana has deciduous foliage with a character distinct from Alnus glutinosa.",
                    "Foliage management should focus on healthy growth, shoot selection, branch development, balanced vigour and maintaining appropriate proportions.",
                    "Leaf size and shoot strength may vary according to vigour, fertilization, growing conditions and development stage.",
                    "Do not rely on aggressive defoliation as routine management.",
                    "The objective is: Healthy foliage · Balanced vigour · Natural proportions.",
                ]
            ),
            SpeciesProfileSection(
                id: "flowering",
                title: "Flowering",
                paragraphs: [
                    "Flowering is not a primary bonsai feature.",
                    "Catkins should be viewed as part of the species' seasonal character rather than a design objective.",
                    "Do not sacrifice structural development or ramification in pursuit of flowering.",
                ]
            ),
            SpeciesProfileSection(
                id: "fruit",
                title: "Cones",
                paragraphs: [
                    "Alnus incana produces characteristic alder cones.",
                    "Woody alder cones may contribute to seasonal and species character but are not a primary bonsai design objective.",
                    "Do not sacrifice structural development or ramification in pursuit of cone production.",
                ]
            ),
            SpeciesProfileSection(
                id: "bark-trunk",
                title: "Bark and Trunk",
                paragraphs: [
                    "Alnus incana can develop increasingly mature trunk character over time. Mature bark character is good.",
                    "Trunk development should focus on sufficient thickness, believable taper, natural movement and appropriate proportions.",
                    "The trunk should be allowed to develop before excessive refinement.",
                    "Do not artificially damage healthy bark to simulate age.",
                    "The objective is: Natural maturity · Strong proportions · Believable character.",
                ]
            ),
            SpeciesProfileSection(
                id: "roots-nebari",
                title: "Roots and Nebari",
                paragraphs: [
                    "Alnus incana can develop strong roots under favourable conditions.",
                    "Healthy roots support foliage health, strong growth, recovery, trunk development and long-term container cultivation.",
                    "Root development is strong. Objectives include balanced roots, stable anchoring, gradual radial development and progressive nebari improvement.",
                    "Avoid unnecessary aggressive root reduction.",
                    "The objective is: Healthy roots · Stable growth · Gradual nebari development.",
                ]
            ),
            SpeciesProfileSection(
                id: "light",
                title: "Light",
                paragraphs: [
                    "Alnus incana should be cultivated outdoors with good access to light.",
                    "Adequate light supports healthy foliage, compact growth, branch development and balanced vigour.",
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
                    "Strong or drying wind can increase water demand, stress foliage, dry shallow containers and increase winter exposure.",
                    "Monitor carefully during warm dry wind, prolonged dry periods and exposed winter conditions.",
                ]
            ),
            SpeciesProfileSection(
                id: "watering",
                title: "Watering",
                paragraphs: [
                    "General principle: Maintain reliable moisture · Avoid repeated severe drying · Avoid permanently stagnant conditions · Maintain healthy root aeration.",
                    "Water demand is moderate to high during active growth.",
                    "Alnus incana may require significant water during active growth.",
                    "Water demand depends on temperature, sunlight, wind, foliage mass, container size, substrate and root mass.",
                    "Although alder species are often associated with moist environments, bonsai roots should not be maintained in permanently stagnant substrate.",
                    "Do not water according to a fixed timetable.",
                    "The objective is: Reliable moisture · Healthy roots · Stable vigour.",
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
                    "During refinement: avoid excessive feeding that produces overly long shoots, coarse extension, unnecessarily large foliage or imbalance in vigour.",
                    "Key principle: Feed according to tree health and development objective.",
                ]
            ),
            SpeciesProfileSection(
                id: "pruning",
                title: "Pruning",
                paragraphs: [
                    "Pruning can be used for structural development, branch selection, branch replacement, ramification and silhouette refinement. Pruning response is good with species-specific considerations.",
                    "During development: allow selected leaders and branches to extend where thickness or taper is required.",
                    "During refinement: use controlled pruning and shoot selection to maintain branch hierarchy, useful internal growth, natural proportions and balanced vigour.",
                    "Avoid repeated uniform trimming.",
                    "The objective is: Purposeful development · Natural branching · Controlled refinement.",
                ]
            ),
            SpeciesProfileSection(
                id: "back-budding",
                title: "Back-budding",
                paragraphs: [
                    "Alnus incana can produce useful new growth, but response depends on tree health, vigour, branch age, available buds, pruning timing and light penetration. Back-budding is moderate to good.",
                    "Do not assume that completely bare old branches will reliably regenerate.",
                    "When pruning: preserve useful interior growth, retain potential replacement shoots and avoid unnecessary removal of viable branches.",
                    "The objective is: Controlled renewal · Preservation of useful structure · Progressive refinement.",
                ]
            ),
            SpeciesProfileSection(
                id: "ramification",
                title: "Ramification",
                paragraphs: [
                    "Ramification should be developed through repeated healthy growth cycles, shoot selection, controlled pruning, branch selection and preservation of useful interior growth. Ramification potential is good with refinement.",
                    "Avoid repeated uniform trimming, dense outer growth with weak interiors and removing all useful inner shoots.",
                    "The objective is: Natural branch hierarchy · Progressive ramification · Balanced vigour.",
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
                    "Pruning and directional growth should be considered alongside wiring.",
                ]
            ),
            SpeciesProfileSection(
                id: "deadwood-potential",
                title: "Deadwood",
                paragraphs: [
                    "Natural dead branches or old branch remnants can occasionally contribute to believable character. Deadwood potential is moderate in naturalistic material.",
                    "However, deadwood should be justified by the individual tree, excessive artificial carving should be avoided and natural trunk development should remain the priority.",
                    "The objective is: Natural age · Believable history · Species-appropriate character.",
                ]
            ),
            SpeciesProfileSection(
                id: "defoliation",
                title: "Foliage Management",
                paragraphs: [
                    "Complete defoliation is not routine management.",
                    "Foliage management should primarily focus on shoot selection, pruning, vigour management, balanced fertilization and adequate light.",
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
                    "Alnus incana can develop trunk thickness quickly when allowed sufficient growth.",
                    "Where additional thickness is required: allow selected leaders to extend, provide sufficient root space, use development containers where appropriate and avoid premature refinement.",
                    "Leader development should support taper, trunk thickness, natural movement and believable proportions.",
                    "Once sufficient trunk development has been achieved, shift focus toward branch hierarchy, ramification, mature bark and refined proportions.",
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
                    "Alnus incana may be propagated using established horticultural methods including seed and selected vegetative propagation methods where appropriate.",
                    "Seed-grown material may offer genetic variation, early root planning and natural trunk development opportunities.",
                    "Detailed procedures belong in Bonsai World Propagation Knowledge Articles.",
                ]
            ),
            SpeciesProfileSection(
                id: "pests",
                title: "Pests and Problems",
                paragraphs: [
                    "Relevant risks may include aphids, leaf-feeding insects, fungal leaf problems, drought stress, root problems caused by poor substrate aeration, stress caused by repeated drying and root stress during prolonged severe freezing.",
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
                    "Autumn is important for evaluating foliage health, reviewing branch structure, assessing growth and preparing for dormancy. Local climate and tree condition determine timing. Do not apply one universal autumn schedule.",
                    "Winter: Alnus incana requires winter dormancy.",
                    "Winter management depends on local minimum temperatures, duration of freezing, wind exposure, container depth, root protection and tree health.",
                    "Shallow bonsai roots are more exposed to severe cold than roots growing in open ground.",
                    "Protect the root system when required. Do not maintain indoors as a substitute for winter dormancy.",
                ]
            ),
            SpeciesProfileSection(
                id: "styles",
                title: "Bonsai Styles",
                paragraphs: [
                    "Alnus incana is particularly suitable for Informal Upright, Slanting, Multi-trunk, Clump Style, Naturalistic Bonsai and Forest Style.",
                    "It is especially effective when styling emphasises natural trunk movement, landscape character, visible branch structure, balanced foliage and northern European character.",
                    "The individual material should determine the final design.",
                ]
            ),
            SpeciesProfileSection(
                id: "tree-stage",
                title: "Development by Tree Stage",
                paragraphs: [
                    "Young material: establish healthy roots, develop trunk thickness, establish natural movement and begin structural development.",
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
                    "Alnus incana is particularly relevant to Nordic and northern European bonsai",
                    "Requires winter dormancy",
                    "Outdoor cultivation is required",
                    "Strong growth should be used strategically during development",
                    "Do not refine prematurely",
                    "Moderate to good back-budding depends on health and branch condition",
                    "Do not assume every old or bare branch will reliably regenerate",
                    "Avoid repeated severe drying",
                    "Maintain sufficient moisture during active growth",
                    "Avoid permanently stagnant roots",
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
