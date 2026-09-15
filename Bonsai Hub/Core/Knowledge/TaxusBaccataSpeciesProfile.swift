//
//  TaxusBaccataSpeciesProfile.swift
//  Bonsai World
//
//  Species Profile — Taxus baccata (European Yew).
//  Independent botanical species in Taxaceae. Knowledge status: Reviewed.
//

import Foundation

enum TaxusBaccataSpeciesProfile {
    /// Identity used by Botanical Library / ``SpeciesPreviewData``.
    static let botanicalLibraryName = "Taxus baccata"
    /// Scientific name for Species Profile display (binomial; no botanical authority).
    static let scientificName = "Taxus baccata"

    static var profile: SpeciesProfile {
        SpeciesProfile(
            speciesID: BotanicalKnowledgeIDs.taxusBaccata,
            scientificName: scientificName,
            commonNames: ["European Yew"],
            family: "Taxaceae",
            plantType: "Evergreen conifer",
            originSummary: "Europe, North Africa and parts of western Asia.",
            knowledgeStatus: .reviewed,
            traits: traits,
            foliageSizeLabel: "Foliage",
            foliageReductionLabel: "Needle reduction",
            summaryLine: "Evergreen · Shade tolerant · Exceptional back-budding potential · Dense foliage · Excellent trunk character · Strong deadwood potential · Long-lived · Important European bonsai species",
            attentionHighlights: [
                "One of the most important European conifer species for bonsai",
                "Exceptional back-budding potential is a major species characteristic",
                "Back-budding is not guaranteed and depends on tree health and conditions",
                "Excellent ramification potential",
                "Excellent mature trunk and old-tree character",
                "Excellent deadwood potential",
                "Preserve useful interior growth",
                "Strong pruning response supports structural redevelopment",
                "Shade tolerance does not mean permanent low-light cultivation",
                "Strong outdoor conditions remain essential",
                "Avoid prolonged drought",
                "Avoid permanently saturated substrate",
                "Excellent suitability for wiring",
                "Monitor wire carefully during active growth",
                "Routine broadleaf defoliation techniques are not applicable",
                "Winter dormancy is required",
                "Protect shallow roots during prolonged severe frost",
                "Do not move indoors for routine winter care",
                "Toxicity must be handled responsibly where relevant",
            ],
            sections: sections,
            principleNote: """
            Taxus baccata is one of the most valuable European species for bonsai.

            It is particularly valued for exceptional back-budding ability, ability to regenerate from old wood, dense evergreen foliage, strong mature trunk character, long life, excellent response to pruning, powerful deadwood potential and suitability for ancient-looking bonsai.

            European Yew can produce highly convincing bonsai from nursery material, hedgerow material where legally appropriate, landscape material where appropriate, old field-grown material, and collected material where legally and ethically appropriate.

            The species is particularly valuable because old or neglected material can often contain substantial design potential. Strong recovery potential must not be treated as permission for unnecessary stress.

            The individual tree must always be assessed according to health, root condition, vigour, age, retained foliage, development stage, climate, seasonal conditions and recent work.

            The objective is: Healthy roots · Strong foliage · Mature trunk character · Sustainable ramification · Natural long-term refinement
            """,
            sourcesNote: """
            Profile content is synthesised from recognised botanical, horticultural and bonsai authorities into Bonsai World editorial language.

            Botanical taxonomy and distribution draw on recognised sources such as Royal Botanic Gardens, Kew and other botanical databases for accepted scientific name, family and native range.

            Horticultural and forestry context may draw on recognised European botanical gardens, arboreta, forestry institutions and conifer collections.

            Bonsai-specific cultivation and refinement knowledge draws on established bonsai references and recognised professional practice for Taxus baccata.

            Verified botanical information, general horticultural cultivation and bonsai-specific practice are kept distinct. Do not copy source wording.
            """
        )
    }

    private static let traits = SpeciesProfileTraits(
        deciduous: false,
        growthStrength: "Moderate",
        growthSpeed: "Slow to Moderate",
        leafSize: "Evergreen · Flat needles · Dense foliage",
        foliageReduction: "Dense masses from cultivation — vigour dependent",
        ramificationPotential: "Excellent",
        backBudding: "Excellent under healthy conditions",
        rootDevelopment: "Moderate to Good",
        nebariPotential: "Good development potential",
        trunkDevelopment: "Slow to Moderate",
        barkDevelopment: "Weathered bark with hollows and ancient character",
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
                    "Taxus baccata is an independent botanical species in the yew family (Taxaceae).",
                    "Primary Bonsai World display identity: Taxus baccata · European Yew.",
                    "Family: Taxaceae. Plant type: evergreen conifer.",
                    "Native range: Europe, North Africa and parts of western Asia.",
                    "Maintain a clear distinction between Taxus baccata, Taxus cuspidata, Taxus × media and other Taxus species.",
                    "Do not merge European Yew with Japanese Yew, hybrid yews or named ornamental cultivars. Cultivated forms and named varieties must not replace the species profile.",
                    "Horticultural selections may be mentioned where they affect cultivation, but they do not replace the primary species identity Taxus baccata.",
                    "Bonsai World hierarchy: Species → cultivar / horticultural selection → Individual Tree.",
                ]
            ),
            SpeciesProfileSection(
                id: "overview",
                title: "Species Overview",
                paragraphs: [
                    "Taxus baccata is a long-lived evergreen conifer native across much of Europe and extending into parts of North Africa and western Asia.",
                    "Mature trees are recognised for dark green needles, dense evergreen foliage, massive trunks, twisted and irregular forms, ancient character, weathered bark, hollows and natural deadwood.",
                    "European Yew is especially important for bonsai because of its ability to tolerate pruning, produce new growth from old wood under suitable conditions, rebuild branch structure, develop dense ramification and maintain convincing foliage on old trunks.",
                    "The species is particularly effective when styling emphasises age, trunk character, natural asymmetry, hollows, deadwood, living veins and dense but controlled foliage.",
                    "Important development principle: Grow where development is required. Control where refinement is required. Preserve healthy foliage and roots throughout the process.",
                ],
                bullets: [
                    "Evergreen conifer",
                    "Long-lived European species",
                    "Flat, dark green needles",
                    "Slow to moderate growth",
                    "Excellent back-budding potential",
                    "Excellent ramification potential",
                    "Strong response to pruning",
                    "Excellent mature trunk character",
                    "Excellent deadwood potential",
                    "Suitable for dramatic naturalistic bonsai",
                    "Requires outdoor cultivation",
                    "Requires winter dormancy",
                ]
            ),
            SpeciesProfileSection(
                id: "natural-growth",
                title: "Natural Growth and Vigour",
                paragraphs: [
                    "Taxus baccata generally grows at a slow to moderate rate.",
                    "Growth strength depends on root health, light, available growing space, substrate, fertilization, temperature, tree age and development stage.",
                    "During structural development: allow selected leaders and branches to extend where trunk thickness is required, branch thickness is required, sacrifice growth is useful or structural development is needed.",
                    "Do not continuously restrict all growth.",
                    "During refinement: manage shoot extension, branch selection, foliage density and vigour distribution.",
                    "The objective is controlled growth while preserving strong, healthy interior structure.",
                ]
            ),
            SpeciesProfileSection(
                id: "foliage",
                title: "Foliage and Needles",
                paragraphs: [
                    "Taxus baccata produces flat evergreen needles.",
                    "The foliage can develop into dense and convincing bonsai masses when managed correctly.",
                    "Foliage density depends on genetics, tree vigour, light, pruning, branch strength, fertilization and development stage.",
                    "Do not promise a fixed needle size.",
                    "The objective is healthy foliage proportionate to the trunk, branch structure and overall tree scale.",
                    "Avoid excessive fertilization where it produces unnecessarily coarse extension.",
                ]
            ),
            SpeciesProfileSection(
                id: "bark-trunk",
                title: "Bark and Trunk",
                paragraphs: [
                    "Mature Taxus baccata can develop extraordinary trunk character.",
                    "Old material may display massive bases, twisted trunks, hollows, cavities, irregular bark, deadwood and living veins.",
                    "This makes European Yew especially suitable for bonsai that communicate great age, survival, weather exposure, natural damage and environmental hardship.",
                    "Trunk development should focus on taper, movement, proportion, natural character and the relationship between live tissue and deadwood.",
                    "Do not artificially create extreme features where the material does not support them.",
                ]
            ),
            SpeciesProfileSection(
                id: "roots-nebari",
                title: "Roots and Nebari",
                paragraphs: [
                    "Healthy roots are fundamental to vigour, foliage quality, recovery, back-budding and long-term refinement.",
                    "Root development objectives include balanced root mass, stable tree support, gradual root selection, healthy substrate structure and sustainable root density.",
                    "Nebari development should be gradual. Older material may have complex root systems requiring staged work.",
                    "Do not attempt to aggressively correct the entire root structure in one operation.",
                ]
            ),
            SpeciesProfileSection(
                id: "light",
                title: "Light",
                paragraphs: [
                    "Taxus baccata should be cultivated outdoors.",
                    "The species is naturally tolerant of lower light conditions compared with many conifers.",
                    "Bonsai cultivation still requires sufficient light for healthy foliage, compact growth, balanced vigour and interior branch development.",
                    "Do not interpret shade tolerance as a recommendation for permanent dark growing conditions or indoor cultivation.",
                    "The optimal position depends on local climate, temperature, tree condition and development stage.",
                    "Do not recommend permanent indoor cultivation.",
                ]
            ),
            SpeciesProfileSection(
                id: "wind",
                title: "Wind",
                paragraphs: [
                    "Moderate air movement is generally beneficial.",
                    "Excessive wind can increase water demand, foliage desiccation and stress on shallow roots.",
                    "Pay particular attention to shallow containers, exposed locations, recently repotted trees and trees recovering from major work.",
                ]
            ),
            SpeciesProfileSection(
                id: "watering",
                title: "Watering",
                paragraphs: [
                    "General principle: Water thoroughly when required · Maintain healthy root aeration · Avoid prolonged drought · Avoid permanently saturated substrate.",
                    "Taxus baccata should not be exposed to unnecessary prolonged drought, particularly in shallow containers.",
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
                    "During refinement: nutrition should support healthy foliage, controlled extension, balanced ramification and sustainable branch development.",
                    "Avoid excessive fertilization where it produces unnecessarily coarse growth, excessive extension or foliage masses disproportionate to the design.",
                    "Key principle: Feed the tree you are growing, not simply the species name.",
                ]
            ),
            SpeciesProfileSection(
                id: "pruning",
                title: "Pruning",
                paragraphs: [
                    "Taxus baccata responds well to thoughtful pruning.",
                    "Pruning can be used for structural development, branch replacement, ramification, silhouette refinement, recovery and redesign.",
                    "The species' back-budding potential provides substantial flexibility. Do not repeatedly prune weak areas in the same way as strong areas.",
                    "During development: allow selected branches and leaders to extend where thickness is required.",
                    "During refinement: use controlled pruning to develop secondary branches, tertiary branches, balanced foliage masses and useful interior growth.",
                    "The objective is balanced vigour.",
                ]
            ),
            SpeciesProfileSection(
                id: "back-budding",
                title: "Back-budding",
                paragraphs: [
                    "Taxus baccata is particularly valued for its strong ability to produce new growth from older wood.",
                    "Back-budding must never be described as guaranteed. Response depends on tree health, vigour, light, branch condition, age of the material, pruning strategy and root health.",
                    "This characteristic can support branch replacement, major structural redesign, recovery of neglected material, development of interior growth and improved ramification.",
                    "Despite this ability: do not remove all strategic foliage without considering the health and recovery capacity of the individual tree.",
                ]
            ),
            SpeciesProfileSection(
                id: "ramification",
                title: "Ramification",
                paragraphs: [
                    "European Yew has excellent potential for dense ramification.",
                    "Ramification is developed through healthy growth, controlled pruning, shoot selection, preservation of useful interior growth and balanced vigour.",
                    "The objective is dense but natural evergreen branch structure.",
                    "Avoid excessive density where it causes poor light penetration, weak interior growth, foliage dieback or unclear branch structure.",
                    "Interior growth should be actively protected where useful for future refinement.",
                ]
            ),
            SpeciesProfileSection(
                id: "wiring",
                title: "Wiring",
                paragraphs: [
                    "Taxus baccata is highly suitable for wiring.",
                    "Wiring can be used to establish trunk movement, position primary branches, refine secondary branches, create natural asymmetry and improve branch structure.",
                    "Young branches are generally flexible. Older branches may become rigid.",
                    "Before major bends, assess branch thickness, flexibility, age, health and structural importance.",
                    "Monitor wire carefully. Do not force rigid material beyond its safe limits.",
                    "Where major movement is required: use appropriate bending techniques and support where necessary.",
                ]
            ),
            SpeciesProfileSection(
                id: "deadwood-potential",
                title: "Deadwood Potential",
                paragraphs: [
                    "Deadwood is an important characteristic of mature Taxus baccata bonsai.",
                    "Natural deadwood may include jin, shari, hollows, cavities, dead trunk sections and weathered scars.",
                    "Deadwood should support natural age, trunk history, movement, living vein structure and overall design.",
                    "The objective is natural character rather than decorative deadwood.",
                    "When working with old material, always consider structural stability, live tissue, water movement within the tree, long-term preservation and the relationship between living and dead sections.",
                    "Do not remove important living tissue without understanding its role in the individual tree.",
                ]
            ),
            SpeciesProfileSection(
                id: "defoliation",
                title: "Foliage Management",
                paragraphs: [
                    "Foliage management should focus on branch visibility, light penetration, preservation of interior growth, balanced vigour and proportion.",
                    "Do not present needle stripping or foliage removal as a routine substitute for proper pruning.",
                    "Do not use routine broadleaf defoliation techniques on Taxus baccata.",
                    "Avoid unnecessary removal of healthy foliage.",
                    "The objective is healthy foliage, good light penetration, strong interior growth and natural branch structure.",
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
                    "Taxus baccata develops trunk thickness slowly to moderately.",
                    "Where additional thickness is required: allow selected leaders to extend, use sacrifice branches where appropriate, provide sufficient root space and avoid premature refinement.",
                    "Once sufficient structural development has been achieved, shift focus toward taper, primary branches, branch placement, ramification, mature bark, natural deadwood and overall character.",
                    "Grow where development is required. Control where refinement is required.",
                ]
            ),
            SpeciesProfileSection(
                id: "nebari-development",
                title: "Nebari Development",
                paragraphs: [
                    "Nebari should be developed gradually.",
                    "Potential approaches include early root selection, staged correction, appropriate development containers and gradual improvement of surface roots.",
                    "Older material may require long-term root planning.",
                    "The objective is a stable and visually convincing base appropriate to the individual tree.",
                    "Do not force identical nebari expectations onto every tree.",
                ]
            ),
            SpeciesProfileSection(
                id: "propagation",
                title: "Propagation",
                paragraphs: [
                    "Taxus baccata may be propagated through seed, cuttings, layering in appropriate situations and specialist propagation methods.",
                    "Propagation strategy depends on the desired objective.",
                    "Seed-grown material can be useful for early root development, trunk development and long-term structural design.",
                    "Cuttings can be useful for preserving selected characteristics and producing genetically identical material.",
                    "Detailed procedures belong in Bonsai World Propagation Knowledge Articles.",
                ]
            ),
            SpeciesProfileSection(
                id: "pests",
                title: "Pests and Problems",
                paragraphs: [
                    "Relevant risks may include scale insects, aphids, spider mites, fungal diseases, root problems caused by poor drainage, foliage browning caused by environmental stress, and winter or wind desiccation.",
                    "Taxus baccata is toxic. All parts of the tree contain toxic compounds and material should be handled responsibly, particularly around children and animals.",
                    "Do not provide medical treatment instructions.",
                    "Diagnosis and treatment belong in Care → Pest Management and Care → Disease & Problems.",
                ]
            ),
            SpeciesProfileSection(
                id: "seasonal",
                title: "Seasonal Profile",
                paragraphs: [
                    "Spring: monitor new growth, bud development, water demand, overall vigour and pest activity. Spring is important for structural growth, branch development and evaluating vigour. Strong areas may require different management from weaker areas.",
                    "Summer: monitor water demand, foliage health, pest activity, shoot extension, wire marks and heat stress. Ensure that dense foliage does not prevent adequate light and air movement where interior growth is required. Avoid unnecessary heavy work during extreme environmental stress.",
                    "Autumn is important for evaluating branch structure, reviewing ramification, assessing overall vigour and preparing for winter. Monitor wire condition, foliage health and root environment. Seasonal timing depends on local climate.",
                    "Winter: Taxus baccata is an outdoor evergreen conifer. Winter dormancy is required. Do not move the tree into permanently warm indoor conditions.",
                    "Although European Yew is a hardy species, bonsai roots in shallow containers are more exposed than roots growing in open ground.",
                    "Monitor prolonged severe freezing, freeze-thaw cycles, root exposure, excessive winter moisture and drying winter winds.",
                    "Winter protection must depend on local climate, minimum temperatures, duration of freezing, container depth and root condition.",
                    "Protect the root system when required while maintaining natural dormancy.",
                ]
            ),
            SpeciesProfileSection(
                id: "styles",
                title: "Bonsai Styles",
                paragraphs: [
                    "Taxus baccata is suitable for a wide range of bonsai styles.",
                    "Particularly suitable expressions include Informal Upright, Slanting, Semi-Cascade, Cascade, Naturalistic Old Tree Style, driftwood-inspired naturalistic designs, Literati where material supports it, Clump Style and Forest / Group Planting.",
                    "European Yew is particularly effective when styling emphasises age, trunk character, hollows, natural asymmetry, living veins, mature foliage and weathered survival character.",
                    "The individual material should determine the final design.",
                ]
            ),
            SpeciesProfileSection(
                id: "tree-stage",
                title: "Development by Tree Stage",
                paragraphs: [
                    "Young material: establish healthy roots, build vigour, develop trunk movement and begin structural development.",
                    "Nursery material: evaluate trunk potential, identify useful branches, establish a design direction and preserve useful foliage and growth.",
                    "Pre-bonsai: develop trunk, establish primary branches, improve root structure and begin controlled branch development.",
                    "In training: develop secondary branches, build ramification, improve branch hierarchy and preserve useful interior growth.",
                    "Refinement: maintain balanced vigour, control shoot extension, improve ramification, preserve natural foliage structure and maintain trunk character.",
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
                    "One of the most important European conifer species for bonsai",
                    "Exceptional back-budding potential is a major species characteristic",
                    "Back-budding is not guaranteed and depends on tree health and conditions",
                    "Excellent ramification potential",
                    "Excellent mature trunk and old-tree character",
                    "Excellent deadwood potential",
                    "Preserve useful interior growth",
                    "Strong pruning response supports structural redevelopment",
                    "Shade tolerance does not mean permanent low-light cultivation",
                    "Strong outdoor conditions remain essential",
                    "Avoid prolonged drought",
                    "Avoid permanently saturated substrate",
                    "Excellent suitability for wiring",
                    "Monitor wire carefully during active growth",
                    "Routine broadleaf defoliation techniques are not applicable",
                    "Winter dormancy is required",
                    "Protect shallow roots during prolonged severe frost",
                    "Do not move indoors for routine winter care",
                    "Toxicity must be handled responsibly where relevant",
                ]
            ),
        ]
    }
}
