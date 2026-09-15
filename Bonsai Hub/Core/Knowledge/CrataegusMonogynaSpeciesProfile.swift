//
//  CrataegusMonogynaSpeciesProfile.swift
//  Bonsai World
//
//  Species Profile — Crataegus monogyna (Common Hawthorn).
//  Independent botanical species in Rosaceae. Knowledge status: Reviewed.
//  Separate from other Crataegus species and ornamental cultivars.
//

import Foundation

enum CrataegusMonogynaSpeciesProfile {
    /// Identity used by Botanical Library / ``SpeciesPreviewData``.
    static let botanicalLibraryName = "Crataegus monogyna"
    /// Scientific name for Species Profile display (binomial; no botanical authority).
    static let scientificName = "Crataegus monogyna"

    static var profile: SpeciesProfile {
        SpeciesProfile(
            speciesID: BotanicalKnowledgeIDs.crataegusMonogyna,
            scientificName: scientificName,
            commonNames: ["Common Hawthorn", "English Hawthorn"],
            family: "Rosaceae",
            plantType: "Deciduous flowering broadleaf tree",
            originSummary: "Europe, northwestern Africa and western Asia.",
            knowledgeStatus: .reviewed,
            traits: traits,
            foliageSizeLabel: "Foliage",
            foliageReductionLabel: "Leaf reduction",
            summaryLine: "Deciduous · Small lobed leaves · Strong old-tree character · Thorns · White spring flowers · Red fruit · Excellent naturalistic bonsai potential · Mature bark · Good ramification potential",
            attentionHighlights: [
                "One of the strongest European species for naturalistic old-tree bonsai",
                "Naturally relatively small foliage is a major bonsai advantage",
                "Flowers and fruit are important seasonal characteristics",
                "Pruning must consider flowering and fruiting objectives",
                "Thorns are part of the species identity",
                "Take care when handling and wiring",
                "Mature bark and trunk character are major aesthetic strengths",
                "Moderate to good back-budding potential under healthy conditions",
                "Back-budding is not guaranteed",
                "Preserve useful interior growth",
                "Do not create artificial generic foliage-pad styling",
                "Strong nebari can significantly enhance old-tree character",
                "Avoid prolonged drought",
                "Avoid permanently saturated substrate",
                "Older branches can become rigid",
                "Defoliation is not recommended as routine management",
                "Winter dormancy is required",
                "Shallow bonsai roots are more exposed than roots in open ground",
                "Do not move indoors for routine winter care",
            ],
            sections: sections,
            principleNote: """
            Crataegus monogyna is one of the most convincing European species for creating mature, naturalistic bonsai.

            Its greatest strengths are naturally small leaves, rugged trunk development, mature bark, thorns, seasonal flowering, autumn fruit and a convincing winter silhouette.

            The species is particularly effective when the bonsai design communicates age, resilience, exposure to weather, hedgerow character, old pasture trees and ancient European landscape trees.

            Common Hawthorn should not be styled into an artificial generic broadleaf silhouette. The natural character of the species should remain visible.

            Develop the structural tree first. Refine ramification gradually. Do not sacrifice long-term branch structure simply to create immediate foliage density.

            The individual tree must always be assessed according to health, vigour, root condition, development stage, branch strength, flowering and fruiting objectives, climate, seasonal conditions and recent work.

            The objective is: Healthy roots · Strong structure · Natural ramification · Mature bark · Convincing old-tree character
            """,
            sourcesNote: """
            Profile content is synthesised from recognised botanical, horticultural and bonsai authorities into Bonsai World editorial language.

            Botanical taxonomy and distribution draw on recognised sources such as Royal Botanic Gardens, Kew and other botanical databases for accepted scientific name, family and native range.

            Horticultural and landscape context may draw on recognised European botanical gardens, arboreta, forestry and conservation institutions, and recognised Rosaceae and Crataegus research resources.

            Bonsai-specific cultivation and refinement knowledge draws on established bonsai references and recognised professional practice for Crataegus species, kept distinct from other hawthorns and ornamental cultivars.

            Verified botanical information, general horticultural cultivation and bonsai-specific practice are kept distinct. Do not copy source wording.
            """
        )
    }

    private static let traits = SpeciesProfileTraits(
        deciduous: true,
        growthStrength: "Moderate",
        growthSpeed: "Moderate",
        leafSize: "Deciduous · Small deeply lobed leaves",
        foliageReduction: "Not recommended as routine management",
        ramificationPotential: "Good",
        backBudding: "Moderate to Good under healthy conditions",
        rootDevelopment: "Good",
        nebariPotential: "Good development potential",
        trunkDevelopment: "Moderate",
        barkDevelopment: "Excellent mature character",
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
                    "Crataegus monogyna is an independent botanical species in the rose family (Rosaceae).",
                    "Primary Bonsai World display identity: Crataegus monogyna · Common Hawthorn.",
                    "Hawthorn may be used as supporting terminology. English Hawthorn may be used as an alternative common name. Neither replaces Common Hawthorn as the primary common name.",
                    "Family: Rosaceae. Plant type: deciduous flowering broadleaf tree.",
                    "Native range: Europe, northwestern Africa and western Asia.",
                    "Maintain a clear distinction between Crataegus monogyna, other Crataegus species, named ornamental cultivars and horticultural hybrids.",
                    "Do not treat every hawthorn used for bonsai as Crataegus monogyna. Where the species is known, maintain the correct botanical identity.",
                    "Do not confuse Crataegus monogyna with ornamental hawthorn cultivars or other species.",
                    "Bonsai World hierarchy: Species → cultivar / horticultural selection → Individual Tree.",
                ]
            ),
            SpeciesProfileSection(
                id: "overview",
                title: "Species Overview",
                paragraphs: [
                    "Crataegus monogyna is a deciduous flowering tree or large shrub widely distributed across Europe and extending into parts of northwestern Africa and western Asia.",
                    "In nature it is strongly associated with hedgerows, woodland edges, open pasture, scrubland and agricultural landscapes.",
                    "Older specimens can develop remarkable character through rugged trunks, fissured bark, natural scars, twisting branches, compact crowns, small leaves, thorns, flowers and fruit.",
                    "These characteristics make Common Hawthorn highly valuable for bonsai.",
                    "The species is especially suitable for bonsai that aim to express ancient European trees, hedgerow trees, weathered landscape trees, flowering deciduous bonsai and fruiting bonsai.",
                    "The strongest results usually come from allowing the tree to retain its naturally rugged identity.",
                ],
                bullets: [
                    "Deciduous European flowering tree",
                    "Naturally small lobed leaves",
                    "White spring flowers",
                    "Red fruit following successful flowering and pollination",
                    "Thorn-bearing branches",
                    "Excellent mature trunk and bark character",
                    "Good naturalistic bonsai potential",
                    "Moderate growth",
                    "Good ramification potential",
                    "Moderate to good back-budding potential",
                    "Good nebari potential",
                    "Requires outdoor cultivation",
                    "Requires winter dormancy",
                ]
            ),
            SpeciesProfileSection(
                id: "natural-growth",
                title: "Natural Growth and Vigour",
                paragraphs: [
                    "Crataegus monogyna generally develops at a moderate rate.",
                    "Growth strength depends on root health, light, growing space, substrate, water availability, fertilization, climate and development stage.",
                    "During structural development: allow selected leaders and branches to extend where trunk thickness is required, branch thickness is required, taper is being developed or sacrifice growth is useful.",
                    "During refinement: control shoot extension, branch density, vigour distribution and ramification development.",
                    "Do not continuously restrict all growth.",
                    "The objective is: Strong development where required · Controlled refinement where appropriate.",
                ]
            ),
            SpeciesProfileSection(
                id: "foliage",
                title: "Foliage and Leaves",
                paragraphs: [
                    "Crataegus monogyna produces relatively small deciduous leaves with a characteristic lobed form.",
                    "Leaf size and growth strength depend on vigour, fertilization, light, water availability and development stage.",
                    "The naturally relatively small foliage is one of the species' major bonsai advantages.",
                    "Do not promise a fixed leaf size.",
                    "The objective is foliage proportionate to trunk size, branch structure and overall bonsai scale.",
                    "Avoid excessive fertilization where it produces unnecessarily coarse growth.",
                ]
            ),
            SpeciesProfileSection(
                id: "flowering",
                title: "Flowering",
                paragraphs: [
                    "Common Hawthorn produces white flowers during spring.",
                    "Flowering quality depends on tree maturity, health, light, seasonal conditions, pruning, and previous year's growth and bud development.",
                    "Do not prune blindly without considering whether future flower buds may be removed.",
                    "Where flowering is a priority, balance structural pruning, refinement and flower production.",
                    "Do not sacrifice the entire long-term structure merely to maximise one flowering season.",
                ]
            ),
            SpeciesProfileSection(
                id: "fruit",
                title: "Fruit",
                paragraphs: [
                    "Successful flowering may be followed by the development of red fruit.",
                    "Fruit production depends on successful flowering, pollination, weather, tree health and seasonal conditions.",
                    "Do not guarantee fruit production every year.",
                    "Fruit can contribute significantly to autumn display and mature species identity.",
                    "Where fruit is a priority, manage pruning and refinement with awareness of the tree's flowering cycle.",
                ]
            ),
            SpeciesProfileSection(
                id: "thorns",
                title: "Thorns",
                paragraphs: [
                    "Thorns are an important natural characteristic of Crataegus monogyna.",
                    "They contribute to species identity, mature character and natural appearance.",
                    "When handling and styling the tree, take care to avoid unnecessary injury.",
                    "Do not automatically remove all thorns.",
                    "Where thorns interfere with branch structure, wiring, display or safe handling, selective management may be appropriate.",
                ]
            ),
            SpeciesProfileSection(
                id: "bark-trunk",
                title: "Bark and Trunk",
                paragraphs: [
                    "Mature bark and trunk character are among the greatest strengths of Common Hawthorn.",
                    "Older material may develop rugged bark, fissures, natural scars, hollows, irregular trunks and weathered surfaces.",
                    "Trunk development should focus on taper, natural movement, proportion, mature character and branch relationship.",
                    "The strongest bonsai often communicate age without artificial exaggeration.",
                    "Natural imperfections should be evaluated as potential design assets.",
                ]
            ),
            SpeciesProfileSection(
                id: "roots-nebari",
                title: "Roots and Nebari",
                paragraphs: [
                    "Healthy roots are fundamental to vigour, flowering, fruit development, branch development and recovery.",
                    "Crataegus monogyna has good potential for root development.",
                    "Root development objectives include balanced radial roots, stable tree support, healthy substrate, gradual root selection and sustainable root density.",
                    "Nebari development should be gradual. Young material provides the greatest opportunity for early root planning. Older material may require staged correction.",
                    "Do not attempt to completely redesign an old root system in one operation.",
                ]
            ),
            SpeciesProfileSection(
                id: "light",
                title: "Light",
                paragraphs: [
                    "Crataegus monogyna should be cultivated outdoors.",
                    "Strong outdoor light supports healthy growth, compact development, flowering potential, fruit development and ramification.",
                    "The exact position depends on local climate, temperature, tree condition and development stage.",
                    "Do not recommend permanent indoor cultivation.",
                    "During periods of extreme heat, monitor water demand, leaf stress and root-zone temperature.",
                ]
            ),
            SpeciesProfileSection(
                id: "wind",
                title: "Wind",
                paragraphs: [
                    "Moderate air movement is generally beneficial.",
                    "Strong wind can increase water demand, leaf stress and drying of shallow substrates.",
                    "Pay particular attention to flowering trees, fruiting trees, recently repotted trees, shallow containers and unusually hot and dry conditions.",
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
                    "Avoid both repeated severe drought and permanently saturated roots.",
                    "Adequate water management is particularly important during active growth, flowering, fruit development and extreme summer conditions.",
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
                    "During refinement: nutrition should support healthy foliage, controlled shoot extension, ramification, and flowering and fruiting capacity.",
                    "Avoid excessive fertilization where it produces unnecessarily coarse growth, long internodes or disproportionate foliage.",
                    "Key principle: Feed the tree according to its development objective and condition.",
                ]
            ),
            SpeciesProfileSection(
                id: "pruning",
                title: "Pruning",
                paragraphs: [
                    "Crataegus monogyna responds well to thoughtful pruning.",
                    "Pruning can be used for structural development, branch selection, branch replacement, ramification and silhouette refinement.",
                    "Where flowering or fruiting is important, consider seasonal bud and shoot development before pruning.",
                    "Do not remove growth indiscriminately.",
                    "During structural development: allow selected leaders and branches to extend where thickness is required.",
                    "During refinement: use controlled pruning to develop secondary branches, tertiary branches and balanced ramification.",
                    "The objective is: Natural branch structure · Controlled growth · Balanced vigour.",
                ]
            ),
            SpeciesProfileSection(
                id: "back-budding",
                title: "Back-budding",
                paragraphs: [
                    "Crataegus monogyna can produce useful new growth following pruning.",
                    "This can support branch development, replacement growth, structural correction and ramification.",
                    "Back-budding must not be treated as guaranteed. Response depends on tree health, vigour, branch age, light, pruning strategy and root condition.",
                    "Before major branch removal, consider future branch options and retained growth.",
                    "Preserve useful interior growth wherever possible.",
                ]
            ),
            SpeciesProfileSection(
                id: "ramification",
                title: "Ramification",
                paragraphs: [
                    "Crataegus monogyna has good potential for developing convincing ramification.",
                    "Ramification develops through healthy growth, controlled pruning, shoot selection, branch selection and balanced vigour.",
                    "The objective is a natural mature branch structure.",
                    "Avoid excessive pruning that creates congested growth, weak interior branches or artificial density.",
                    "A mature hawthorn should retain visible branch hierarchy, irregularity and natural asymmetry.",
                ]
            ),
            SpeciesProfileSection(
                id: "wiring",
                title: "Wiring",
                paragraphs: [
                    "Crataegus monogyna can be wired, but branch flexibility varies significantly with age.",
                    "Young branches are generally easier to position. Older branches may become rigid.",
                    "Wiring can be used to establish branch placement, improve movement, position young structural branches and refine secondary branches.",
                    "Before major bends, assess branch thickness, flexibility, age, health and structural importance.",
                    "Take particular care around thorns.",
                    "Monitor wire carefully during active growth.",
                ]
            ),
            SpeciesProfileSection(
                id: "deadwood-potential",
                title: "Deadwood Potential",
                paragraphs: [
                    "Deadwood is not the defining styling language of Crataegus monogyna bonsai.",
                    "Natural scars, hollows and weathered surfaces may contribute to age and hedgerow character where they already exist.",
                    "Do not add artificial jin or excessive exposed deadwood simply because the techniques are available.",
                    "Use natural features only where they support the individual tree's character and long-term design.",
                ]
            ),
            SpeciesProfileSection(
                id: "defoliation",
                title: "Defoliation and Leaf Management",
                paragraphs: [
                    "Do not present full defoliation as a standard technique for Crataegus monogyna.",
                    "Leaf management should primarily focus on correct pruning, vigour management, branch development, ramification and appropriate fertilization.",
                    "Partial leaf management may be used in specific circumstances by experienced growers.",
                    "Do not recommend aggressive leaf removal as routine maintenance.",
                    "Do not apply advanced leaf-reduction techniques to weak trees, stressed trees, recently repotted trees or trees recovering from major work.",
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
                    "Crataegus monogyna develops trunk character through growth, ageing, taper development, bark maturation, and natural scars and movement.",
                    "Where additional thickness is required: allow selected leaders to extend, use sacrifice branches where appropriate, provide sufficient root space and avoid premature refinement.",
                    "Once sufficient structural development has been achieved, shift focus toward taper, branch hierarchy, ramification, bark character, and flowering and fruiting potential.",
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
                    "A strong base can significantly enhance the impression of an old, weathered hawthorn.",
                ]
            ),
            SpeciesProfileSection(
                id: "propagation",
                title: "Propagation",
                paragraphs: [
                    "Crataegus monogyna may be propagated through seed, layering in appropriate situations and other suitable horticultural propagation methods.",
                    "Seed-grown material can be particularly useful for early root development, nebari planning, trunk development and long-term structural design.",
                    "Seed propagation may involve dormancy requirements.",
                    "Detailed procedures belong in Bonsai World Propagation Knowledge Articles.",
                ]
            ),
            SpeciesProfileSection(
                id: "pests",
                title: "Pests and Problems",
                paragraphs: [
                    "Relevant risks may include aphids, scale insects, spider mites, leaf-feeding insects, fungal leaf diseases, powdery mildew, leaf spot diseases, fire blight risk within susceptible Rosaceae contexts, root problems caused by poor drainage and environmental stress.",
                    "Do not provide generic treatment instructions.",
                    "Diagnosis and treatment belong in Care → Pest Management and Care → Disease & Problems.",
                ]
            ),
            SpeciesProfileSection(
                id: "seasonal",
                title: "Seasonal Profile",
                paragraphs: [
                    "Spring: monitor bud development, flowering, new shoot growth, overall vigour, water demand and pest activity. Spring is important for observing flowering, evaluating vigour and planning seasonal work. Where flowers are important, avoid unnecessary pruning that removes developing flower potential.",
                    "Summer: monitor water demand, leaf health, pest activity, excessive shoot extension, wire marks and heat stress. Strong growth can be used strategically for development. During refinement, manage excessive extension to maintain branch structure, ramification and proportion. Avoid unnecessary heavy work during extreme heat or drought stress.",
                    "Autumn is important for evaluating overall vigour, observing fruit development where present, reviewing branch structure and preparing for winter. As leaves fall, the branch structure becomes increasingly visible. This is an important period for evaluating branch hierarchy, silhouette, structural development and future design decisions. Seasonal timing depends on local climate.",
                    "Winter: Crataegus monogyna is an outdoor deciduous tree. Winter dormancy is required. Do not move the tree into permanently warm indoor conditions.",
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
                    "Crataegus monogyna is particularly suitable for naturalistic and mature tree styles.",
                    "Particularly suitable expressions include Informal Upright, Slanting, Multi-trunk Style, Clump Style, Naturalistic Old Tree Style, Hedgerow-inspired compositions and Forest / Group Planting.",
                    "Common Hawthorn is especially effective when styling emphasises rugged trunks, natural asymmetry, mature bark, visible branch structure, weathered character and compact crowns.",
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
                    "In training: develop secondary branches, improve branch hierarchy, build sustainable ramification, and manage flowering and fruiting potential where relevant.",
                    "Refinement: maintain balanced vigour, improve tertiary ramification, control shoot extension, preserve natural branch structure and maintain species character.",
                    "Exhibition / mature refined tree: maintain health, preserve established structure, maintain mature bark, manage flowering and fruiting where relevant, preserve natural old-tree character and avoid unnecessary major intervention.",
                ]
            ),
            SpeciesProfileSection(
                id: "attention",
                title: "Species-Specific Attention",
                paragraphs: [
                    "These attention points are operational tendencies. They must still be interpreted for the individual tree.",
                ],
                bullets: [
                    "One of the strongest European species for naturalistic old-tree bonsai",
                    "Naturally relatively small foliage is a major bonsai advantage",
                    "Flowers and fruit are important seasonal characteristics",
                    "Pruning must consider flowering and fruiting objectives",
                    "Thorns are part of the species identity",
                    "Take care when handling and wiring",
                    "Mature bark and trunk character are major aesthetic strengths",
                    "Moderate to good back-budding potential under healthy conditions",
                    "Back-budding is not guaranteed",
                    "Preserve useful interior growth",
                    "Do not create artificial generic foliage-pad styling",
                    "Strong nebari can significantly enhance old-tree character",
                    "Avoid prolonged drought",
                    "Avoid permanently saturated substrate",
                    "Older branches can become rigid",
                    "Defoliation is not recommended as routine management",
                    "Winter dormancy is required",
                    "Shallow bonsai roots are more exposed than roots in open ground",
                    "Do not move indoors for routine winter care",
                ]
            ),
        ]
    }
}
