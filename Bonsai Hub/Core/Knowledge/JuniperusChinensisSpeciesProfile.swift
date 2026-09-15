//
//  JuniperusChinensisSpeciesProfile.swift
//  Bonsai World
//
//  Species Profile — Juniperus chinensis (Chinese Juniper).
//  Baseline botanical species in Cupressaceae. Knowledge status: Reviewed.
//  Cultivar profiles (Itoigawa, Kishu, Blaauw and others) remain separate.
//

import Foundation

enum JuniperusChinensisSpeciesProfile {
    /// Identity used by Botanical Library / ``SpeciesPreviewData``.
    static let botanicalLibraryName = "Juniperus chinensis"
    /// Scientific name for Species Profile display (binomial; no botanical authority).
    static let scientificName = "Juniperus chinensis"

    static var profile: SpeciesProfile {
        SpeciesProfile(
            speciesID: BotanicalKnowledgeIDs.juniperusChinensis,
            scientificName: scientificName,
            commonNames: ["Chinese Juniper"],
            family: "Cupressaceae",
            plantType: "Evergreen conifer",
            originSummary: "East Asia, including China and neighbouring parts of northeastern Asia.",
            knowledgeStatus: .reviewed,
            traits: traits,
            foliageSizeLabel: "Foliage",
            foliageReductionLabel: "Foliage management",
            summaryLine: "Evergreen · Scale and juvenile foliage · Strong bonsai suitability · Excellent deadwood potential · Excellent wiring response · Dense ramification potential · Long-lived · Important international bonsai species",
            attentionHighlights: [
                "One of the world's most important bonsai juniper species",
                "This profile represents the baseline botanical species",
                "Cultivars and named forms may have separate Bonsai World profiles",
                "Mature growth commonly displays scale foliage",
                "Juvenile needle foliage may occur",
                "Good to excellent ramification potential",
                "Excellent wiring suitability",
                "Excellent deadwood potential",
                "Do not assume reliable back-budding from completely bare old wood",
                "Preserve useful interior foliage",
                "Pruning decisions must consider future foliage availability",
                "Strong outdoor light supports healthy development",
                "Avoid prolonged drought in shallow containers",
                "Avoid permanently saturated substrate",
                "Assess flexibility carefully before major bends",
                "Do not use broadleaf defoliation techniques",
                "Winter dormancy is required",
                "Shallow bonsai roots are more exposed than roots in open ground",
                "Do not move indoors for routine winter care",
            ],
            sections: sections,
            principleNote: """
            Juniperus chinensis is one of the most important species in international bonsai.

            It is particularly valued for dense evergreen foliage, scale foliage in mature growth, strong styling potential, excellent response to wiring, mature trunk character, deadwood and long-term refinement potential.

            Chinese Juniper has become one of the defining species groups in modern bonsai. The species profile must not assume that every tree sold as a Chinese Juniper has identical characteristics.

            Commercial and bonsai material may involve the botanical species, selected cultivars, named horticultural forms, and material with differing foliage characteristics.

            For Bonsai World, this profile represents the baseline species. Distinct cultivars remain separate profiles.

            Preserve useful foliage. Do not assume reliable back-budding from completely bare old wood.

            The individual tree must always be assessed according to health, vigour, root condition, retained foliage, branch strength, cultivar or horticultural form where known, development stage, climate, seasonal conditions and recent work.
            """,
            sourcesNote: """
            Profile content is synthesised from recognised botanical, horticultural and bonsai authorities into Bonsai World editorial language.

            Botanical taxonomy and distribution draw on recognised sources such as Royal Botanic Gardens, Kew and other botanical databases for accepted scientific name, family and native range.

            Horticultural context may draw on recognised East Asian botanical institutions, botanical gardens, arboreta and conifer collections.

            Bonsai-specific cultivation and refinement knowledge draws on established bonsai references and recognised professional practice for Juniperus chinensis, kept distinct from cultivar-specific profiles.

            Verified botanical information, general horticultural cultivation and bonsai-specific practice are kept distinct. Do not copy source wording.
            """
        )
    }

    private static let traits = SpeciesProfileTraits(
        deciduous: false,
        growthStrength: "Moderate",
        growthSpeed: "Moderate",
        leafSize: "Evergreen · Scale foliage and juvenile needle foliage",
        foliageReduction: "Density managed through cultivation — vigour and identity dependent",
        ramificationPotential: "Good to Excellent",
        backBudding: "Moderate to Good under healthy conditions, but do not rely on budding from completely bare old wood",
        rootDevelopment: "Moderate to Good",
        nebariPotential: "Good development potential",
        trunkDevelopment: "Moderate",
        barkDevelopment: "Aged bark with live veins and deadwood character",
        wiring: "Excellent suitability",
        defoliation: "Not applicable as a routine technique",
        airLayering: "Where appropriate for the individual material",
        threadGrafting: "Where structural correction is required",
        rootGrafting: "Where appropriate",
        beginnerSuitability: "Moderate",
        bonsaiSuitability: "Excellent",
        difficulty: "Intermediate",
        winterDormancyRequired: true,
        winterHardiness: "Outdoor evergreen — winter dormancy required",
        rootFrostSensitivity: "Moderate in shallow bonsai containers"
    )

    private static var sections: [SpeciesProfileSection] {
        [
            SpeciesProfileSection(
                id: "taxonomic-context",
                title: "Taxonomic Context",
                paragraphs: [
                    "Juniperus chinensis is an independent botanical species in the cypress family (Cupressaceae).",
                    "Primary Bonsai World display identity: Juniperus chinensis · Chinese Juniper.",
                    "Family: Cupressaceae. Plant type: evergreen conifer.",
                    "Native range: East Asia, including China and neighbouring parts of northeastern Asia.",
                    "This is the baseline species profile. Maintain a clear distinction between the botanical species Juniperus chinensis and recognised cultivars and named horticultural forms.",
                    "Distinct cultivars with a separate bonsai identity remain separate Species Library profiles. Examples include Juniperus chinensis 'Itoigawa', Juniperus chinensis 'Kishu' and Juniperus chinensis 'Blaauw'.",
                    "Do not assume that all Chinese Juniper bonsai material behaves identically. Cultivar-specific characteristics belong in their respective profiles.",
                    "Maintain a clear distinction between Juniperus chinensis, Juniperus communis, Juniperus sabina, Juniperus procumbens, Juniperus rigida and other Juniperus species.",
                    "Bonsai World hierarchy: Species → cultivar / horticultural selection → Individual Tree.",
                ]
            ),
            SpeciesProfileSection(
                id: "overview",
                title: "Species Overview",
                paragraphs: [
                    "Juniperus chinensis is an evergreen conifer native to East Asia and has become one of the most important species groups used in bonsai worldwide.",
                    "The species and its cultivated forms are valued for their ability to develop dense foliage, intricate branch structures, aged trunks, dramatic movement, deadwood and refined silhouettes.",
                    "Mature material can be styled into highly refined bonsai because of the relationship between evergreen foliage, flexible younger branches, strong older branches, deadwood and living veins.",
                    "Chinese Juniper is especially important for formal bonsai, highly refined bonsai, naturalistic bonsai and dramatic deadwood designs.",
                    "The strongest results come from respecting the individual material rather than applying a generic juniper formula.",
                ],
                bullets: [
                    "Evergreen conifer",
                    "Major international bonsai species",
                    "Scale foliage in mature growth",
                    "Juvenile needle foliage may also occur",
                    "Moderate growth",
                    "Good to excellent ramification potential",
                    "Excellent wiring suitability",
                    "Excellent deadwood potential",
                    "Strong mature trunk character",
                    "Do not rely on back-budding from completely bare old wood",
                    "Requires outdoor cultivation",
                    "Requires winter dormancy",
                ]
            ),
            SpeciesProfileSection(
                id: "natural-growth",
                title: "Natural Growth and Vigour",
                paragraphs: [
                    "Juniperus chinensis generally grows at a moderate rate.",
                    "Growth strength depends on root health, light, climate, water availability, substrate, fertilization, container size, foliage mass and development stage.",
                    "During structural development: allow selected leaders and branches to extend where trunk thickness is required, branch thickness is required, sacrifice growth is useful or structural development is needed.",
                    "During refinement: manage shoot extension, foliage density, branch selection and vigour distribution.",
                    "Avoid continuously restricting every growing area.",
                    "The objective is strong roots, healthy foliage, useful interior growth and controlled ramification.",
                ]
            ),
            SpeciesProfileSection(
                id: "foliage",
                title: "Foliage",
                paragraphs: [
                    "Juniperus chinensis can display different foliage types.",
                    "Mature foliage commonly develops as scale foliage. Juvenile growth may appear as needle-like foliage.",
                    "The occurrence of juvenile foliage can be influenced by age, vigour, pruning, stress, genetics and cultivar characteristics.",
                    "Do not automatically describe juvenile foliage as a disease or defect.",
                    "Do not promise that all Chinese Junipers will develop identical foliage.",
                    "The objective is healthy foliage appropriate to the individual tree and its horticultural identity.",
                ]
            ),
            SpeciesProfileSection(
                id: "bark-trunk",
                title: "Bark and Trunk",
                paragraphs: [
                    "Mature Chinese Juniper can develop strong bonsai character through aged bark, twisting, taper, irregular movement, live veins and deadwood.",
                    "Trunk development should focus on taper, movement, proportion, branch relationship and mature character.",
                    "Do not force artificial movement where the material does not support it.",
                    "The strongest designs usually preserve or enhance the natural characteristics already present.",
                ]
            ),
            SpeciesProfileSection(
                id: "roots-nebari",
                title: "Roots and Nebari",
                paragraphs: [
                    "Healthy roots are fundamental to vigour, foliage health, recovery, branch development and long-term refinement.",
                    "Root development objectives include balanced root mass, stable tree support, gradual root selection, healthy substrate and sustainable root density.",
                    "Nebari development should be gradual.",
                    "Do not attempt to completely redesign an old root system in one operation. Root work should be planned over multiple stages where necessary.",
                ]
            ),
            SpeciesProfileSection(
                id: "light",
                title: "Light",
                paragraphs: [
                    "Juniperus chinensis should be cultivated outdoors.",
                    "Strong outdoor light supports healthy foliage, compact growth, interior development and overall vigour.",
                    "The exact position depends on local climate, temperature, tree condition and development stage.",
                    "Do not recommend permanent indoor cultivation.",
                    "Good light does not eliminate the need to monitor heat stress, drought, root-zone temperature and wind exposure.",
                ]
            ),
            SpeciesProfileSection(
                id: "wind",
                title: "Wind",
                paragraphs: [
                    "Moderate air movement is generally beneficial.",
                    "Excessive wind can increase water demand, foliage desiccation and drying of shallow root systems.",
                    "Pay particular attention to shallow containers, recently repotted trees, trees recovering from major work and extreme hot and dry conditions.",
                ]
            ),
            SpeciesProfileSection(
                id: "watering",
                title: "Watering",
                paragraphs: [
                    "General principle: Water thoroughly when required · Maintain healthy root aeration · Avoid prolonged drought · Avoid permanently saturated substrate.",
                    "Watering frequency depends on temperature, wind, sunlight, foliage mass, container size, substrate, root mass and development stage.",
                    "Do not water according to a fixed timetable.",
                    "Water according to substrate condition, weather and the individual tree.",
                    "Avoid both prolonged drought and permanently saturated roots.",
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
                    "During development: healthy trees requiring structural growth may receive increased nutritional support where appropriate.",
                    "During refinement: nutrition should support healthy foliage, controlled extension, sustainable ramification and balanced vigour.",
                    "Avoid excessive fertilization where it produces unnecessarily coarse growth, excessive extension or foliage disproportionate to the design.",
                    "Key principle: Feed the tree you are growing, not simply the species name.",
                ]
            ),
            SpeciesProfileSection(
                id: "pruning",
                title: "Pruning",
                paragraphs: [
                    "Pruning must respect juniper growth behaviour.",
                    "Pruning can be used for structural development, branch selection, ramification and silhouette refinement.",
                    "Do not remove foliage without considering where future growth will come from.",
                    "Before major reduction, assess retained foliage, interior growth, branch vigour, tree health and future design requirements.",
                    "During development: allow selected growth to extend where thickness is required.",
                    "During refinement: use controlled shoot selection and pruning to maintain structure. Avoid repeatedly weakening already weak areas.",
                    "The objective is balanced vigour.",
                ]
            ),
            SpeciesProfileSection(
                id: "back-budding",
                title: "Back-budding",
                paragraphs: [
                    "This is an important operational principle.",
                    "Chinese Juniper may produce useful interior growth when healthy and well managed.",
                    "Do not remove all foliage from an area and assume reliable replacement from bare old wood.",
                    "Future development depends on retained foliage, branch vigour, light, overall health and pruning strategy.",
                    "Preserve useful interior foliage wherever possible.",
                    "Before reducing a branch, confirm that useful foliage remains in the area required for future development.",
                ]
            ),
            SpeciesProfileSection(
                id: "ramification",
                title: "Ramification",
                paragraphs: [
                    "Juniperus chinensis has good to excellent ramification potential.",
                    "Ramification develops through healthy growth, controlled pruning, shoot selection, preservation of useful interior foliage and balanced vigour.",
                    "The objective is dense but clearly structured foliage.",
                    "Avoid excessive density. Excessive foliage can reduce light penetration, interior growth, branch visibility and long-term ramification quality.",
                    "Interior foliage should be preserved strategically.",
                ]
            ),
            SpeciesProfileSection(
                id: "wiring",
                title: "Wiring",
                paragraphs: [
                    "Juniperus chinensis is highly suitable for wiring.",
                    "Wiring can be used to establish trunk movement, position primary branches, develop secondary branches, create natural asymmetry and refine branch placement.",
                    "Young growth is generally more flexible. Older branches may become rigid.",
                    "Before major bends, assess branch thickness, flexibility, age, health and structural importance.",
                    "Monitor wire carefully.",
                    "Where major movement is required: use appropriate bending techniques and support rather than forcing rigid material.",
                    "The objective is convincing natural movement.",
                ]
            ),
            SpeciesProfileSection(
                id: "deadwood-potential",
                title: "Deadwood Potential",
                paragraphs: [
                    "Deadwood is one of the major bonsai characteristics of Juniperus chinensis.",
                    "Deadwood may include jin, shari, hollow sections, dead branches and weathered trunk areas.",
                    "Deadwood should support trunk movement, age, survival, environmental history and the relationship between living and dead tissue.",
                    "The objective is natural character rather than decorative carving.",
                    "Always assess live vein structure, water movement, tree health, structural stability and long-term preservation.",
                    "Do not remove important living tissue without understanding its function.",
                ]
            ),
            SpeciesProfileSection(
                id: "defoliation",
                title: "Foliage Management",
                paragraphs: [
                    "Foliage management should focus on light penetration, preservation of interior growth, branch visibility, balanced vigour and natural foliage structure.",
                    "Do not use excessive stripping or foliage removal as a substitute for correct pruning.",
                    "Do not use broadleaf defoliation techniques on Juniperus chinensis.",
                    "Avoid unnecessary removal of healthy foliage.",
                    "The objective is healthy foliage, useful interior growth, balanced density and clear branch structure.",
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
                    "Juniperus chinensis develops trunk thickness at a moderate rate under suitable conditions.",
                    "Where additional thickness is required: allow selected growth to extend, use sacrifice branches where appropriate, provide sufficient root space and avoid premature refinement.",
                    "Once sufficient structural development has been achieved, shift focus toward taper, branch hierarchy, ramification, mature bark, deadwood and overall character.",
                    "Grow where development is required. Control where refinement is required.",
                ]
            ),
            SpeciesProfileSection(
                id: "nebari-development",
                title: "Nebari Development",
                paragraphs: [
                    "Nebari should be developed gradually.",
                    "Potential approaches include early root planning, staged root selection, appropriate development containers and gradual improvement of surface roots.",
                    "The objective is a stable and visually convincing base appropriate to the individual tree.",
                    "Do not force identical nebari expectations onto every specimen.",
                ]
            ),
            SpeciesProfileSection(
                id: "propagation",
                title: "Propagation",
                paragraphs: [
                    "Juniperus chinensis may be propagated through seed, cuttings, layering in appropriate situations and specialist propagation techniques.",
                    "Seed-grown material can be useful for early root development, long-term trunk development and structural design.",
                    "Cuttings are particularly important for preserving selected horticultural characteristics and producing genetically identical material.",
                    "Detailed procedures belong in Bonsai World Propagation Knowledge Articles.",
                ]
            ),
            SpeciesProfileSection(
                id: "pests",
                title: "Pests and Problems",
                paragraphs: [
                    "Relevant risks may include spider mites, scale insects, aphids, fungal diseases, root problems caused by poor drainage, foliage browning caused by environmental stress, winter desiccation and stress following excessive root disturbance.",
                    "Do not provide generic treatment instructions.",
                    "Diagnosis and treatment belong in Care → Pest Management and Care → Disease & Problems.",
                ]
            ),
            SpeciesProfileSection(
                id: "seasonal",
                title: "Seasonal Profile",
                paragraphs: [
                    "Spring: monitor new growth, overall vigour, water demand, root recovery and pest activity. Spring is important for evaluating vigour, structural development and seasonal planning. Strong and weak areas may require different management.",
                    "Summer: monitor water demand, foliage health, pest activity, heat stress, wire marks and interior foliage condition. Avoid unnecessary heavy work during extreme heat, drought stress or periods of reduced vigour. Pay particular attention to shallow containers.",
                    "Autumn is important for evaluating branch structure, reviewing foliage density, assessing overall health and preparing for winter. Monitor wire condition, foliage health and root environment. Seasonal timing depends on local climate.",
                    "Winter: Juniperus chinensis is an outdoor evergreen conifer. Winter dormancy is required. Do not move the tree into permanently warm indoor conditions.",
                    "Bonsai roots in shallow containers are more exposed than roots growing in open ground.",
                    "Monitor prolonged severe freezing, freeze-thaw cycles, root exposure, excessive winter moisture and drying winter winds.",
                    "Winter protection depends on local climate, minimum temperatures, duration of freezing, container depth and root condition.",
                    "Protect the root system when required while maintaining natural dormancy.",
                ]
            ),
            SpeciesProfileSection(
                id: "styles",
                title: "Bonsai Styles",
                paragraphs: [
                    "Juniperus chinensis is suitable for a wide range of bonsai styles.",
                    "Particularly suitable expressions include Informal Upright, Formal Upright where material supports it, Slanting, Semi-Cascade, Cascade, Literati, Naturalistic Old Tree Style, driftwood-inspired naturalistic designs, Clump Style and Forest / Group Planting.",
                    "Chinese Juniper is particularly effective when styling emphasises trunk movement, asymmetry, mature foliage, live veins, aged bark and natural deadwood.",
                    "The individual material should determine the final design.",
                ]
            ),
            SpeciesProfileSection(
                id: "tree-stage",
                title: "Development by Tree Stage",
                paragraphs: [
                    "Young material: establish healthy roots, build vigour, develop trunk movement and begin structural development.",
                    "Nursery material: evaluate trunk potential, identify useful branches, establish a design direction and preserve useful foliage.",
                    "Pre-bonsai: develop trunk, establish primary branches, improve root structure, preserve interior growth and begin controlled branch development.",
                    "In training: develop secondary branches, improve branch hierarchy, preserve useful interior foliage and build sustainable ramification.",
                    "Refinement: maintain balanced vigour, control shoot extension, preserve interior growth, refine branch placement and maintain foliage quality.",
                    "Exhibition / mature refined tree: maintain health, preserve established structure, maintain foliage quality, preserve mature trunk character, maintain natural deadwood and avoid unnecessary major intervention.",
                ]
            ),
            SpeciesProfileSection(
                id: "attention",
                title: "Species-Specific Attention",
                paragraphs: [
                    "These attention points are operational tendencies. They must still be interpreted for the individual tree.",
                ],
                bullets: [
                    "One of the world's most important bonsai juniper species",
                    "This profile represents the baseline botanical species",
                    "Cultivars and named forms may have separate Bonsai World profiles",
                    "Mature growth commonly displays scale foliage",
                    "Juvenile needle foliage may occur",
                    "Good to excellent ramification potential",
                    "Excellent wiring suitability",
                    "Excellent deadwood potential",
                    "Do not assume reliable back-budding from completely bare old wood",
                    "Preserve useful interior foliage",
                    "Pruning decisions must consider future foliage availability",
                    "Strong outdoor light supports healthy development",
                    "Avoid prolonged drought in shallow containers",
                    "Avoid permanently saturated substrate",
                    "Assess flexibility carefully before major bends",
                    "Do not use broadleaf defoliation techniques",
                    "Winter dormancy is required",
                    "Shallow bonsai roots are more exposed than roots in open ground",
                    "Do not move indoors for routine winter care",
                ]
            ),
        ]
    }
}
