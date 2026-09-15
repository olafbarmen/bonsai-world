//
//  MalusSylvestrisSpeciesProfile.swift
//  Bonsai World
//
//  Species Profile — Malus sylvestris (European Crab Apple).
//  Independent botanical species in Rosaceae. Knowledge status: Reviewed.
//  Separate from Malus domestica, ornamental Malus cultivars and hybrids.
//

import Foundation

enum MalusSylvestrisSpeciesProfile {
    /// Identity used by Botanical Library / ``SpeciesPreviewData``.
    static let botanicalLibraryName = "Malus sylvestris"
    /// Scientific name for Species Profile display (binomial; no botanical authority).
    static let scientificName = "Malus sylvestris"

    static var profile: SpeciesProfile {
        SpeciesProfile(
            speciesID: BotanicalKnowledgeIDs.malusSylvestris,
            scientificName: scientificName,
            commonNames: ["European Crab Apple", "Wild Apple"],
            family: "Rosaceae",
            plantType: "Deciduous flowering and fruiting broadleaf tree",
            originSummary: "Europe.",
            knowledgeStatus: .reviewed,
            traits: traits,
            foliageSizeLabel: "Foliage",
            foliageReductionLabel: "Leaf reduction",
            summaryLine: "Deciduous · Spring flowers · Small apple-like fruit · Strong seasonal interest · Mature bark · Good ramification potential · Excellent flowering bonsai potential · Outdoor cultivation required",
            attentionHighlights: [
                "Strong seasonal interest is a major bonsai advantage",
                "Flowering and fruiting require consideration during pruning",
                "Do not sacrifice long-term structure for one season of flowers",
                "Fruit can place significant demands on a small bonsai",
                "Selective fruit reduction may be appropriate",
                "Naturally irregular branching can be a design advantage",
                "Mature bark contributes strongly to character",
                "Moderate to good back-budding potential under healthy conditions",
                "Back-budding is not guaranteed",
                "Preserve useful interior growth",
                "Avoid prolonged drought",
                "Avoid permanently saturated substrate",
                "Older branches can become increasingly rigid",
                "Defoliation is not recommended as routine management",
                "Winter dormancy is required",
                "Shallow bonsai roots are more exposed than roots in open ground",
                "Do not move indoors for routine winter care",
            ],
            sections: sections,
            principleNote: """
            Malus sylvestris is valued for bonsai because it provides strong seasonal variation.

            The species can offer spring flowers, summer foliage, developing fruit, autumn colour and winter branch structure.

            A strong Malus bonsai should be developed with attention to both structural quality and reproductive character. Do not manage the tree exclusively for flowers and fruit at the expense of long-term structure.

            The best long-term results come from balancing trunk development, branch structure, ramification, flowering, fruiting and tree health.

            The individual tree must always be assessed according to health, vigour, root condition, maturity, development stage, flowering objectives, fruiting objectives, climate, seasonal conditions and recent work.
            """,
            sourcesNote: """
            Profile content is synthesised from recognised botanical, horticultural and bonsai authorities into Bonsai World editorial language.

            Botanical taxonomy and distribution draw on recognised sources such as Royal Botanic Gardens, Kew and other botanical databases for accepted scientific name, family and native range.

            Horticultural and landscape context may draw on recognised European botanical gardens, arboreta, forestry and native tree organisations, and recognised Rosaceae and Malus research resources.

            Bonsai-specific cultivation and refinement knowledge draws on established bonsai references and recognised professional practice for Malus species, kept distinct from Malus domestica, ornamental cultivars and horticultural crabapple material.

            Verified botanical information, general horticultural cultivation and bonsai-specific practice are kept distinct. Do not copy source wording.
            """
        )
    }

    private static let traits = SpeciesProfileTraits(
        deciduous: true,
        growthStrength: "Moderate to Strong",
        growthSpeed: "Moderate",
        leafSize: "Deciduous",
        foliageReduction: "Not recommended as routine management",
        ramificationPotential: "Good",
        backBudding: "Moderate to Good under healthy conditions",
        rootDevelopment: "Good",
        nebariPotential: "Good potential",
        trunkDevelopment: "Moderate",
        barkDevelopment: "Good mature character",
        wiring: "Moderate",
        defoliation: "Not recommended as routine management",
        airLayering: "Where appropriate for the individual material",
        threadGrafting: "Where structural correction is required",
        rootGrafting: "Where appropriate",
        beginnerSuitability: "Moderate",
        bonsaiSuitability: "Excellent",
        difficulty: "Intermediate",
        winterDormancyRequired: true,
        winterHardiness: "Outdoor deciduous — winter dormancy required",
        rootFrostSensitivity: "Moderate in shallow bonsai containers"
    )

    private static var sections: [SpeciesProfileSection] {
        [
            SpeciesProfileSection(
                id: "taxonomic-context",
                title: "Taxonomic Context",
                paragraphs: [
                    "Malus sylvestris is an independent botanical species in the rose family (Rosaceae).",
                    "Primary Bonsai World display identity: Malus sylvestris · European Crab Apple.",
                    "Wild apple and crab apple may be used as supporting terminology. Neither replaces European Crab Apple as the primary common name.",
                    "The name crab apple is widely used in horticulture for a broad range of Malus species and cultivars. This profile describes Malus sylvestris specifically.",
                    "Do not imply that all crabapple bonsai material is Malus sylvestris.",
                    "Family: Rosaceae. Plant type: deciduous flowering and fruiting broadleaf tree.",
                    "Native range: Europe.",
                    "Maintain a clear distinction between Malus sylvestris, Malus domestica, ornamental Malus species, named Malus cultivars and horticultural hybrids.",
                    "Do not confuse Malus sylvestris with Malus domestica or ornamental Malus hybrids.",
                    "Bonsai World hierarchy: Species → cultivar / horticultural selection → Individual Tree.",
                ]
            ),
            SpeciesProfileSection(
                id: "overview",
                title: "Species Overview",
                paragraphs: [
                    "Malus sylvestris is a deciduous European tree in the Rosaceae family.",
                    "It is known for spring flowers, small apple-like fruit, naturally irregular branching, mature bark and strong seasonal changes.",
                    "European Crab Apple can be particularly effective for bonsai because the species provides visual interest throughout much of the year.",
                    "The strongest bonsai results usually come from allowing the tree to retain its identity as a naturally growing fruit tree.",
                    "Avoid developing the tree into an artificial generic deciduous silhouette.",
                    "The structure should communicate maturity, natural branching, seasonal character, flowering potential and fruiting potential.",
                ],
                bullets: [
                    "Deciduous European flowering and fruiting tree",
                    "White to pale pink spring flowers",
                    "Small apple-like fruit",
                    "Strong seasonal character",
                    "Good bonsai ramification potential",
                    "Moderate to good back-budding under healthy conditions",
                    "Good root development",
                    "Good nebari potential",
                    "Mature bark can provide strong character",
                    "Requires outdoor cultivation",
                    "Requires winter dormancy",
                ]
            ),
            SpeciesProfileSection(
                id: "natural-growth",
                title: "Natural Growth and Vigour",
                paragraphs: [
                    "Malus sylvestris generally has moderate to strong growth depending on conditions.",
                    "Growth strength depends on root health, light, available growing space, substrate, water availability, fertilization, climate and development stage.",
                    "During structural development: allow selected leaders and branches to extend where trunk thickness is required, branch thickness is required, taper is being developed or sacrifice growth is useful.",
                    "During refinement: control shoot extension, branch density, vigour distribution and ramification development.",
                    "Do not continuously restrict all growth.",
                    "The objective is: Strong growth where development is required · Controlled growth where refinement is required.",
                ]
            ),
            SpeciesProfileSection(
                id: "foliage",
                title: "Foliage and Leaves",
                paragraphs: [
                    "Malus sylvestris produces deciduous foliage.",
                    "Leaf size and vigour depend on fertilization, water availability, light, root development and growth strength.",
                    "The objective is foliage proportionate to trunk size, branch structure and overall bonsai design.",
                    "Avoid excessive fertilization where it produces unnecessarily large foliage, excessively coarse shoots or disproportionate internodes.",
                ]
            ),
            SpeciesProfileSection(
                id: "flowering",
                title: "Flowering",
                paragraphs: [
                    "European Crab Apple produces flowers during spring. Flower colour is typically white to pale pink.",
                    "Flowering depends on tree maturity, health, light, seasonal conditions, bud development and pruning history.",
                    "Where flowering is a priority, pruning must be planned with awareness of future flower buds.",
                    "Do not indiscriminately remove short shoots and developing buds.",
                    "The objective is to balance structural development, ramification and flowering potential.",
                    "Do not guarantee identical flowering performance every year.",
                ]
            ),
            SpeciesProfileSection(
                id: "fruit",
                title: "Fruit",
                paragraphs: [
                    "Successful flowering and pollination may lead to the development of small apple-like fruit.",
                    "Fruit production depends on successful flowering, pollination, weather, tree health and seasonal conditions.",
                    "Do not guarantee fruit production every year.",
                    "Fruit can place significant demands on a small bonsai.",
                    "Where a tree carries a heavy crop, evaluate whether the number of fruits is appropriate for tree health, branch strength and overall development.",
                    "Selective fruit reduction may be appropriate when required.",
                    "The objective is seasonal display without unnecessarily exhausting the tree.",
                ]
            ),
            SpeciesProfileSection(
                id: "bark-trunk",
                title: "Bark and Trunk",
                paragraphs: [
                    "Mature Malus sylvestris can develop attractive bark and irregular trunk character.",
                    "Trunk development should focus on taper, movement, proportion, branch relationship and mature character.",
                    "Where additional thickness is required, allow selected leaders and sacrifice growth to extend.",
                    "Once sufficient structural development has been achieved, shift focus toward branch hierarchy, ramification, flowering and fruiting potential, and mature bark character.",
                    "The objective is a convincing mature fruit tree.",
                ]
            ),
            SpeciesProfileSection(
                id: "roots-nebari",
                title: "Roots and Nebari",
                paragraphs: [
                    "Healthy roots are fundamental to vigour, flowering, fruit development, recovery and branch development.",
                    "Root development objectives include balanced radial roots, stable tree support, healthy root density and gradual root selection.",
                    "Nebari development should be gradual. Young material offers the greatest opportunity for early root planning. Older material may require staged improvement.",
                    "Do not attempt to completely redesign an established root system in one operation.",
                ]
            ),
            SpeciesProfileSection(
                id: "light",
                title: "Light",
                paragraphs: [
                    "Malus sylvestris should be cultivated outdoors.",
                    "Strong outdoor light supports healthy growth, flowering, fruit development, compact ramification and overall vigour.",
                    "The exact position depends on local climate, temperature, tree condition and development stage.",
                    "During periods of extreme heat, monitor water demand, leaf stress and root-zone temperature.",
                    "Do not recommend permanent indoor cultivation.",
                ]
            ),
            SpeciesProfileSection(
                id: "wind",
                title: "Wind",
                paragraphs: [
                    "Moderate air movement is generally beneficial.",
                    "Strong wind can increase water demand, damage flowers, affect developing fruit and increase drying in shallow containers.",
                    "Pay particular attention during flowering, early fruit development, extreme heat and unusually dry conditions.",
                ]
            ),
            SpeciesProfileSection(
                id: "watering",
                title: "Watering",
                paragraphs: [
                    "General principle: Water thoroughly when required · Maintain healthy root aeration · Avoid prolonged drought · Avoid permanently saturated substrate.",
                    "Watering frequency depends on temperature, sunlight, wind, foliage mass, container size, substrate, root mass and development stage.",
                    "Do not water according to a fixed timetable.",
                    "Water according to substrate condition, weather and the individual tree.",
                    "Adequate water management is particularly important during active growth, flowering, fruit development and extreme summer conditions.",
                    "Avoid both repeated severe drought and permanently saturated roots.",
                ]
            ),
            SpeciesProfileSection(
                id: "soil",
                title: "Soil",
                paragraphs: [
                    "Do not prescribe one universal soil recipe.",
                    "Desired characteristics include good drainage, strong aeration, stable particle structure, appropriate moisture retention and healthy root development.",
                    "The final soil mix depends on local climate, rainfall, watering habits, container depth, tree size, development stage and root condition.",
                    "Follow Bonsai World Soil Module principles.",
                    "Do not duplicate the complete Soil Module inside this profile.",
                ]
            ),
            SpeciesProfileSection(
                id: "fertilizing",
                title: "Fertilizing",
                paragraphs: [
                    "Fertilization should support the current development objective.",
                    "During structural development: healthy trees requiring stronger growth may receive increased nutritional support where appropriate.",
                    "During refinement: nutrition should support healthy foliage, controlled shoot extension, sustainable ramification, and flowering and fruiting capacity.",
                    "Avoid excessive fertilization where it produces unnecessarily coarse growth, disproportionate foliage or excessive vegetative growth.",
                    "Key principle: Feed according to tree condition and development objective.",
                ]
            ),
            SpeciesProfileSection(
                id: "pruning",
                title: "Pruning",
                paragraphs: [
                    "Malus sylvestris responds well to thoughtful pruning.",
                    "Pruning can be used for structural development, branch selection, branch replacement, ramification and silhouette refinement.",
                    "Where flowering and fruiting are priorities, consider bud and shoot development before pruning.",
                    "During structural development: allow selected leaders and branches to extend where thickness is required.",
                    "During refinement: use controlled pruning to develop secondary branches, tertiary branches and balanced ramification.",
                    "Do not remove useful interior growth unnecessarily.",
                    "The objective is: Natural structure · Controlled growth · Sustainable flowering and fruiting potential.",
                ]
            ),
            SpeciesProfileSection(
                id: "back-budding",
                title: "Back-budding",
                paragraphs: [
                    "Malus sylvestris can produce useful new growth following pruning.",
                    "This can support branch development, replacement growth, structural correction and ramification.",
                    "Back-budding must not be treated as guaranteed. Response depends on tree health, vigour, branch age, light, pruning strategy and root condition.",
                    "Preserve useful interior growth whenever possible.",
                ]
            ),
            SpeciesProfileSection(
                id: "ramification",
                title: "Ramification",
                paragraphs: [
                    "Malus sylvestris has good potential for developing convincing ramification.",
                    "Ramification develops through healthy growth, controlled pruning, shoot selection, branch selection and balanced vigour.",
                    "The objective is natural deciduous branch structure.",
                    "Avoid excessive density that produces congested branching, weak interior growth or artificial foliage masses.",
                    "A refined Malus should retain visible branch hierarchy, natural spacing, clear structure and proportionate ramification.",
                ]
            ),
            SpeciesProfileSection(
                id: "wiring",
                title: "Wiring",
                paragraphs: [
                    "Malus sylvestris can be wired, particularly when branches are young.",
                    "Wiring can be used to establish branch placement, improve movement, position young structural branches and refine secondary branches.",
                    "Older branches may become increasingly rigid.",
                    "Before major bends, assess branch thickness, flexibility, age, health and structural importance.",
                    "Monitor wire carefully during active growth.",
                ]
            ),
            SpeciesProfileSection(
                id: "deadwood-potential",
                title: "Deadwood Potential",
                paragraphs: [
                    "Deadwood is not the defining styling language of Malus sylvestris bonsai.",
                    "Natural scars and weathered surfaces may contribute to age and orchard or landscape character where they already exist.",
                    "Do not add artificial jin or excessive exposed deadwood simply because the techniques are available.",
                    "Use natural features only where they support the individual tree's character and long-term design.",
                ]
            ),
            SpeciesProfileSection(
                id: "defoliation",
                title: "Defoliation and Leaf Management",
                paragraphs: [
                    "Do not present full defoliation as standard management for Malus sylvestris.",
                    "Leaf management should primarily focus on correct pruning, vigour management, ramification and appropriate fertilization.",
                    "Partial leaf management may be appropriate in specific circumstances for experienced growers.",
                    "Do not apply aggressive leaf removal to weak trees, stressed trees, recently repotted trees, trees recovering from major work, or trees carrying significant flower or fruit loads.",
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
                    "Repotting decisions should be based on root condition, substrate performance and overall tree health.",
                ]
            ),
            SpeciesProfileSection(
                id: "trunk-development",
                title: "Trunk Development",
                paragraphs: [
                    "Malus sylvestris develops trunk character through growth, taper development, bark maturation, branch development and natural ageing.",
                    "Where additional thickness is required: allow selected leaders to extend, use sacrifice branches where appropriate, provide sufficient root space and avoid premature refinement.",
                    "Once sufficient structural development has been achieved, shift focus toward taper, branch hierarchy, ramification, flowering potential and fruiting potential.",
                    "Grow where development is required. Control where refinement is required.",
                ]
            ),
            SpeciesProfileSection(
                id: "nebari-development",
                title: "Nebari Development",
                paragraphs: [
                    "Nebari should be developed gradually.",
                    "Potential approaches include early root selection, radial root planning, staged root correction, appropriate development containers and gradual improvement of surface roots.",
                    "The objective is a stable and visually convincing base appropriate to the individual tree.",
                    "A strong base can significantly enhance the impression of a mature European fruit tree.",
                ]
            ),
            SpeciesProfileSection(
                id: "propagation",
                title: "Propagation",
                paragraphs: [
                    "Malus sylvestris may be propagated through seed, grafting where appropriate for specific horticultural objectives, layering in suitable situations and other established horticultural methods.",
                    "Seed-grown material can be particularly useful for early root development, nebari planning, trunk development and long-term structural design.",
                    "Detailed procedures belong in Bonsai World Propagation Knowledge Articles.",
                ]
            ),
            SpeciesProfileSection(
                id: "pests",
                title: "Pests and Problems",
                paragraphs: [
                    "Relevant risks may include aphids, scale insects, spider mites, leaf-feeding insects, fungal leaf diseases, powdery mildew, apple scab and related leaf or fruit diseases, root problems caused by poor drainage and environmental stress.",
                    "Do not provide generic treatment instructions.",
                    "Diagnosis and treatment belong in Care → Pest Management and Care → Disease & Problems.",
                ]
            ),
            SpeciesProfileSection(
                id: "seasonal",
                title: "Seasonal Profile",
                paragraphs: [
                    "Spring: monitor bud development, flowering, new shoot growth, overall vigour, water demand and pest activity. Spring is particularly important for observing flowering, protecting flowers where appropriate, evaluating vigour and planning seasonal work. Avoid unnecessary pruning that removes developing flower potential.",
                    "Summer: monitor water demand, leaf health, pest activity, excessive shoot extension, wire marks, developing fruit and heat stress. During refinement, manage excessive extension while preserving useful growth. Avoid unnecessary heavy work during extreme heat or drought stress.",
                    "Autumn is important for observing fruit development, evaluating overall vigour, reviewing branch structure and preparing for winter. As leaves fall, branch structure becomes increasingly visible. This is an important period for evaluating branch hierarchy, silhouette, structural development and future design decisions. Fruit may contribute significantly to seasonal display. Seasonal timing depends on local climate.",
                    "Winter: Malus sylvestris is an outdoor deciduous tree. Winter dormancy is required. Do not move the tree into permanently warm indoor conditions.",
                    "Bonsai roots in shallow containers are more exposed than roots growing in open ground.",
                    "Monitor prolonged severe freezing, freeze-thaw cycles, root exposure and excessive winter moisture.",
                    "Winter protection depends on local climate, minimum temperatures, duration of freezing, container depth and root condition.",
                    "Protect the root system when required while maintaining natural dormancy.",
                ]
            ),
            SpeciesProfileSection(
                id: "styles",
                title: "Bonsai Styles",
                paragraphs: [
                    "Malus sylvestris is particularly suitable for naturalistic flowering and fruiting bonsai styles.",
                    "Particularly suitable expressions include Informal Upright, Slanting, Multi-trunk Style, Clump Style, Naturalistic Old Tree Style and Forest / Group Planting.",
                    "European Crab Apple is especially effective when styling emphasises natural branching, seasonal flowers, proportionate fruit, visible winter structure, mature bark and natural asymmetry.",
                    "The individual material should determine the final design.",
                ]
            ),
            SpeciesProfileSection(
                id: "tree-stage",
                title: "Development by Tree Stage",
                paragraphs: [
                    "Young material: establish healthy roots, develop nebari, build trunk thickness, establish movement and begin structural development.",
                    "Nursery material: evaluate trunk potential, identify useful branches, establish a design direction and begin structural correction where required.",
                    "Pre-bonsai: develop trunk, establish primary branches, improve root structure, begin branch hierarchy and build vigour.",
                    "In training: develop secondary branches, improve branch hierarchy, build sustainable ramification, and begin balancing structural development with flowering potential.",
                    "Refinement: maintain balanced vigour, improve tertiary ramification, control shoot extension, preserve flowering potential and manage fruit load where necessary.",
                    "Exhibition / mature refined tree: maintain health, preserve established structure, maintain mature bark, maintain balanced ramification, preserve flowering and fruiting potential and avoid unnecessary major intervention.",
                ]
            ),
            SpeciesProfileSection(
                id: "attention",
                title: "Species-Specific Attention",
                paragraphs: [
                    "These attention points are operational tendencies. They must still be interpreted for the individual tree.",
                ],
                bullets: [
                    "Strong seasonal interest is a major bonsai advantage",
                    "Flowering and fruiting require consideration during pruning",
                    "Do not sacrifice long-term structure for one season of flowers",
                    "Fruit can place significant demands on a small bonsai",
                    "Selective fruit reduction may be appropriate",
                    "Naturally irregular branching can be a design advantage",
                    "Mature bark contributes strongly to character",
                    "Moderate to good back-budding potential under healthy conditions",
                    "Back-budding is not guaranteed",
                    "Preserve useful interior growth",
                    "Avoid prolonged drought",
                    "Avoid permanently saturated substrate",
                    "Older branches can become increasingly rigid",
                    "Defoliation is not recommended as routine management",
                    "Winter dormancy is required",
                    "Shallow bonsai roots are more exposed than roots in open ground",
                    "Do not move indoors for routine winter care",
                ]
            ),
        ]
    }
}
