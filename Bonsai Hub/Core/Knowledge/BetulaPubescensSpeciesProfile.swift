//
//  BetulaPubescensSpeciesProfile.swift
//  Bonsai World
//
//  Species Profile — Betula pubescens (Downy Birch).
//  Independent botanical species in Betulaceae. Knowledge status: Reviewed.
//  Separate from Betula pendula and other Betula species.
//

import Foundation

enum BetulaPubescensSpeciesProfile {
    /// Identity used by Botanical Library / ``SpeciesPreviewData``.
    static let botanicalLibraryName = "Betula pubescens"
    /// Scientific name for Species Profile display (binomial; no botanical authority).
    static let scientificName = "Betula pubescens"

    static var profile: SpeciesProfile {
        SpeciesProfile(
            speciesID: BotanicalKnowledgeIDs.betulaPubescens,
            scientificName: scientificName,
            commonNames: ["Downy Birch", "European Downy Birch", "White Birch"],
            family: "Betulaceae",
            plantType: "Deciduous tree",
            originSummary: "Northern and temperate Europe and Asia.",
            knowledgeStatus: .reviewed,
            traits: traits,
            foliageSizeLabel: "Foliage",
            foliageReductionLabel: "Leaf reduction",
            summaryLine: "Deciduous · Nordic species · Moisture-tolerant · Fine branching potential · Strong seasonal character · Naturalistic bonsai potential · Hardy · Suitable for northern climates",
            attentionHighlights: [
                "Betula pubescens is a separate species from Betula pendula",
                "Highly relevant to Northern Europe and Norway",
                "Naturally associated with cooler and relatively moist environments",
                "Requires winter dormancy",
                "Outdoor cultivation is required",
                "May have significant water demand during active growth",
                "Avoid repeated severe drying",
                "Moisture tolerance does not mean tolerance of permanently stagnant roots",
                "Fine ramification should be developed gradually",
                "Preserve useful interior growth",
                "Mature bark character develops naturally with age",
                "Do not artificially damage bark",
                "Do not use complete defoliation as routine management",
                "Young branches are generally more suitable for wiring than older branches",
                "Avoid forcing rigid branches",
                "Shallow bonsai roots require protection during prolonged severe freezing",
                "Naturalistic styling is particularly suitable",
            ],
            sections: sections,
            principleNote: """
            Betula pubescens should be developed with respect for its natural northern character.

            The species is particularly associated with cooler climates, northern landscapes, moist soils, open woodland and natural and informal tree forms.

            Its strongest bonsai characteristics include seasonal foliage, naturalistic branch structure, suitability for Nordic bonsai, a hardy growth habit and gradual mature trunk character.

            Avoid forcing Betula pubescens into excessively dense or artificial silhouettes.

            The objective is: Natural structure · Healthy vigour · Fine branching · Seasonal character · Convincing northern landscape identity.

            The individual tree must always be assessed according to climate, tree condition, vigour, development stage and winter temperatures.
            """,
            sourcesNote: """
            Profile content is synthesised from recognised botanical, horticultural and bonsai authorities into Bonsai World editorial language.

            Botanical taxonomy and distribution draw on recognised sources such as Royal Botanic Gardens, Kew and other botanical databases for accepted scientific name, family and native range.

            Horticultural context may draw on recognised Nordic and European botanical institutions, forestry and horticultural institutions and authoritative Betula references.

            Bonsai-specific cultivation and refinement knowledge draws on established bonsai references and recognised professional practice with Betula experience, kept distinct from Betula pendula and other Betula species.

            Verified botanical information, horticultural information, regional climate adaptation and bonsai-specific practice are kept distinct. Do not copy source wording.
            """
        )
    }

    private static let traits = SpeciesProfileTraits(
        deciduous: true,
        growthStrength: "Moderate to Strong",
        growthSpeed: "Moderate to Fast",
        leafSize: "Deciduous · Small to Medium",
        foliageReduction: "Not routine management",
        ramificationPotential: "Good",
        backBudding: "Moderate to Good",
        rootDevelopment: "Good",
        nebariPotential: "Moderate to Good potential",
        trunkDevelopment: "Moderate to Fast",
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
                    "Betula pubescens is an independent botanical species in the birch family (Betulaceae).",
                    "Primary Bonsai World display identity: Betula pubescens · Downy Birch.",
                    "European Downy Birch and White Birch may be used as supporting terminology. They do not replace Downy Birch as the primary common name.",
                    "Family: Betulaceae. Plant type: deciduous tree.",
                    "Native range: Northern and temperate Europe and Asia.",
                    "Do not confuse Betula pubescens with Betula pendula.",
                    "Do not merge Betula pendula and Betula pubescens into one generic Birch profile. Each species retains its own botanical identity and bonsai guidance.",
                    "Bonsai World hierarchy: Species → cultivar / horticultural selection → Individual Tree.",
                ]
            ),
            SpeciesProfileSection(
                id: "overview",
                title: "Species Overview",
                paragraphs: [
                    "Betula pubescens is one of the most important birch species across Northern Europe.",
                    "It is particularly relevant to Scandinavian and Nordic landscapes.",
                    "Betula pubescens is particularly relevant to Bonsai World because it is widespread in Northern Europe, highly relevant to Norway, naturally associated with cooler and wetter environments, suitable for naturalistic bonsai and valuable for Nordic species coverage.",
                    "Compared with Betula pendula, Betula pubescens is generally associated with cooler conditions, wetter soils, a more northern distribution and a different natural growth character.",
                    "The two species must remain separate in the Species Library.",
                ],
                bullets: [
                    "Deciduous",
                    "Nordic and Northern European relevance",
                    "Hardy",
                    "Requires winter dormancy",
                    "Outdoor cultivation required",
                    "Moderate to strong growth",
                    "Good branching potential",
                    "Moderate to good back-budding",
                    "Suitable for naturalistic bonsai",
                    "Tolerant of relatively moist growing conditions",
                    "Requires healthy, aerated roots",
                    "Strong seasonal character",
                ]
            ),
            SpeciesProfileSection(
                id: "cultivars",
                title: "Cultivars and Forms",
                paragraphs: [
                    "Betula pubescens is primarily used in bonsai as the botanical species.",
                    "Horticultural cultivars may differ in bark character, growth habit, branch density and foliage appearance.",
                    "Do not create unnecessary separate Species Library profiles for minor individual variation.",
                    "The primary Species Profile remains Betula pubescens.",
                    "Only create separate profiles where a distinct cultivar or form has a clear and established independent bonsai identity.",
                ]
            ),
            SpeciesProfileSection(
                id: "natural-growth",
                title: "Natural Growth and Vigour",
                paragraphs: [
                    "Betula pubescens can grow strongly when roots are healthy, moisture is consistently available, growing conditions are favourable and root space is sufficient.",
                    "During structural development: allow selected growth to extend where trunk thickness is required, taper is required or branches require development.",
                    "During refinement: control excessive extension, coarse branch development, congestion and loss of internal structure.",
                    "Do not suppress useful vigorous growth prematurely.",
                    "The objective is: Strong development when needed · Controlled refinement when the structure is established.",
                ]
            ),
            SpeciesProfileSection(
                id: "foliage",
                title: "Foliage",
                paragraphs: [
                    "Healthy foliage should be evenly distributed, supported by healthy roots, proportional to branch structure and exposed to appropriate light.",
                    "Leaf size and growth strength depend on vigour, fertilization, water availability, light, root restriction and development stage.",
                    "Do not rely on aggressive defoliation as routine management.",
                    "Foliage management should primarily focus on shoot selection, pruning, vigour management, balanced fertilization and appropriate light.",
                    "The objective is: Healthy foliage · Controlled proportions · Useful branch development.",
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
                title: "Fruit",
                paragraphs: [
                    "Fruiting is not a primary bonsai feature.",
                    "Fruit is not required for a convincing Downy Birch bonsai.",
                    "Do not treat fruit production as a styling priority.",
                ]
            ),
            SpeciesProfileSection(
                id: "bark-trunk",
                title: "Bark and Trunk",
                paragraphs: [
                    "Mature Betula pubescens can develop attractive trunk and bark character. Mature bark character is good.",
                    "Mature development may include increasingly pale bark, textural changes with age, stronger visual contrast near the trunk base and natural northern landscape character.",
                    "Young material may require significant development before mature bark character becomes prominent.",
                    "Do not artificially damage the bark to simulate age.",
                    "The objective is: Natural maturity · Healthy bark · Convincing trunk proportions.",
                ]
            ),
            SpeciesProfileSection(
                id: "roots-nebari",
                title: "Roots and Nebari",
                paragraphs: [
                    "Healthy roots support strong growth, foliage health, recovery, branch development and long-term cultivation.",
                    "Betula pubescens tolerates relatively moist conditions in its natural environment.",
                    "However, bonsai roots still require oxygen, drainage and healthy substrate structure.",
                    "Do not interpret moisture tolerance as tolerance of permanently stagnant or oxygen-poor roots.",
                    "Root development is good. Objectives include balanced roots, gradual radial development, stable anchoring and improving surface roots.",
                    "The objective is: Healthy roots · Stable growth · Gradually improving nebari.",
                ]
            ),
            SpeciesProfileSection(
                id: "light",
                title: "Light",
                paragraphs: [
                    "Betula pubescens should be cultivated outdoors with good access to light.",
                    "Adequate light supports healthy foliage, compact growth, branch development and a strong seasonal rhythm.",
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
                    "Strong wind can increase water demand, dry shallow containers, stress foliage and increase winter exposure.",
                    "Monitor trees carefully during warm wind, prolonged dry conditions and exposed winter weather.",
                ]
            ),
            SpeciesProfileSection(
                id: "watering",
                title: "Watering",
                paragraphs: [
                    "General principle: Maintain reliable moisture · Avoid repeated severe drying · Avoid permanently stagnant conditions · Maintain healthy root aeration.",
                    "Water demand is moderate to high during active growth.",
                    "Betula pubescens may have significant water demand during active growth.",
                    "Watering frequency depends on temperature, sunlight, wind, foliage mass, container size, substrate and root mass.",
                    "Do not water according to a fixed timetable.",
                    "The objective is consistent healthy moisture without oxygen-starved roots.",
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
                    "Fertilization should support healthy foliage, trunk development, branch development, ramification and recovery.",
                    "During development: support healthy vigorous growth where structural development is required.",
                    "During refinement: avoid excessive feeding that produces unnecessarily long shoots, coarse growth or excessive internode length.",
                    "Key principle: Feed according to tree health and development objective.",
                ]
            ),
            SpeciesProfileSection(
                id: "pruning",
                title: "Pruning",
                paragraphs: [
                    "Pruning can be used for structural development, branch selection, branch replacement, ramification and silhouette refinement. Pruning response is good.",
                    "During development: allow selected leaders and branches to extend where thickness is required.",
                    "During refinement: use controlled pruning and shoot selection to maintain branch hierarchy, useful internal growth, natural proportions and visible structure.",
                    "Avoid repeated uniform trimming.",
                    "The objective is: Purposeful development · Natural branch structure · Controlled refinement.",
                ]
            ),
            SpeciesProfileSection(
                id: "back-budding",
                title: "Back-budding",
                paragraphs: [
                    "Betula pubescens can produce useful new growth, but response depends on tree health, vigour, branch age, available buds, light and pruning strategy. Back-budding is moderate to good.",
                    "Do not assume that all old or bare branches will reliably produce new growth.",
                    "When considering major structural pruning: preserve useful interior growth, retain possible replacement branches and avoid unnecessary removal of viable buds.",
                    "The objective is gradual structural development without unnecessary loss of useful material.",
                ]
            ),
            SpeciesProfileSection(
                id: "ramification",
                title: "Ramification",
                paragraphs: [
                    "Develop ramification gradually through repeated healthy growth cycles, shoot selection, controlled pruning, branch selection and preservation of useful interior growth. Ramification potential is good.",
                    "Avoid uniform hedge-like trimming, excessive outer density, weak internal structure and repeated removal of useful interior growth.",
                    "The objective is: Natural branch hierarchy · Fine ramification · Visible structure.",
                ]
            ),
            SpeciesProfileSection(
                id: "wiring",
                title: "Wiring",
                paragraphs: [
                    "Young branches are generally easier to position than older branches. Wiring response is moderate.",
                    "Wiring can be used for branch direction, structural placement and correcting young growth.",
                    "Before major bends assess branch thickness, flexibility, age, health and structural importance.",
                    "Monitor wire carefully.",
                    "Avoid forcing rigid branches.",
                    "Pruning and directional growth should be considered alongside wiring as primary structural tools.",
                ]
            ),
            SpeciesProfileSection(
                id: "deadwood-potential",
                title: "Deadwood",
                paragraphs: [
                    "Deadwood is not normally a defining feature of refined Betula pubescens bonsai. Deadwood potential is low.",
                    "Natural scars and branch remnants may occasionally contribute to character.",
                    "Avoid dramatic artificial deadwood unless strongly justified by the individual material.",
                    "The objective is natural maturity rather than manufactured damage.",
                ]
            ),
            SpeciesProfileSection(
                id: "defoliation",
                title: "Foliage Management",
                paragraphs: [
                    "Complete defoliation is not routine management.",
                    "Foliage management should primarily focus on shoot selection, pruning, vigour management, balanced fertilization and adequate light.",
                    "Do not present complete defoliation as routine maintenance.",
                    "Do not apply aggressive foliage work to weak trees, stressed trees, recently repotted trees or trees recovering from major work.",
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
                    "Betula pubescens can develop effectively when allowed sufficient growth and root space.",
                    "Where additional thickness is required: allow selected leaders to extend, provide sufficient root space, use development containers where appropriate and avoid premature refinement.",
                    "Leader development should support taper, trunk thickness, natural movement and believable proportions.",
                    "Once sufficient development has been achieved, shift focus toward branch hierarchy, ramification, mature bark character and refined proportions.",
                ]
            ),
            SpeciesProfileSection(
                id: "nebari-development",
                title: "Nebari Development",
                paragraphs: [
                    "Nebari should be developed gradually.",
                    "Potential approaches include early root selection, radial root planning, staged correction, suitable development containers and gradual refinement.",
                    "The objective is a stable and visually convincing base appropriate to the species.",
                ]
            ),
            SpeciesProfileSection(
                id: "propagation",
                title: "Propagation",
                paragraphs: [
                    "Betula pubescens may be propagated using established horticultural methods including seed and selected vegetative methods where appropriate.",
                    "Seed-grown material offers genetic variation, early trunk development opportunities and early root planning.",
                    "Detailed procedures belong in Bonsai World Propagation Knowledge Articles.",
                ]
            ),
            SpeciesProfileSection(
                id: "pests",
                title: "Pests and Problems",
                paragraphs: [
                    "Relevant risks may include aphids, leaf-feeding insects, fungal leaf problems, root problems caused by poor substrate aeration, drought stress, excessive heat and water stress and root stress during prolonged severe freezing.",
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
                    "Winter: Betula pubescens requires winter dormancy.",
                    "Winter management depends on local minimum temperatures, duration of freezing, wind exposure, container depth, root protection and tree health.",
                    "Shallow bonsai roots are more exposed to severe cold than roots growing in open ground.",
                    "Protect the root system when required. Do not maintain indoors as a substitute for winter dormancy.",
                ]
            ),
            SpeciesProfileSection(
                id: "styles",
                title: "Bonsai Styles",
                paragraphs: [
                    "Betula pubescens is particularly suitable for Informal Upright, Slanting, Multi-trunk, Clump Style, Naturalistic Bonsai and Forest Style.",
                    "It is especially effective when styling emphasises natural movement, visible trunk lines, open branch structure, northern landscape character and mature proportions.",
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
                    "Betula pubescens is a separate species from Betula pendula",
                    "Highly relevant to Northern Europe and Norway",
                    "Naturally associated with cooler and relatively moist environments",
                    "Requires winter dormancy",
                    "Outdoor cultivation is required",
                    "May have significant water demand during active growth",
                    "Avoid repeated severe drying",
                    "Moisture tolerance does not mean tolerance of permanently stagnant roots",
                    "Fine ramification should be developed gradually",
                    "Preserve useful interior growth",
                    "Mature bark character develops naturally with age",
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
