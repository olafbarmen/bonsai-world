//
//  JuniperusCommunisSpeciesProfile.swift
//  Bonsai World
//
//  Species Profile — Juniperus communis (Common Juniper).
//  Independent botanical species in Cupressaceae. Knowledge status: Reviewed.
//  Separate from Juniperus chinensis and other Juniperus species.
//

import Foundation

enum JuniperusCommunisSpeciesProfile {
    /// Identity used by Botanical Library / ``SpeciesPreviewData``.
    static let botanicalLibraryName = "Juniperus communis"
    /// Scientific name for Species Profile display (binomial; no botanical authority).
    static let scientificName = "Juniperus communis"

    static var profile: SpeciesProfile {
        SpeciesProfile(
            speciesID: BotanicalKnowledgeIDs.juniperusCommunis,
            scientificName: scientificName,
            commonNames: ["Common Juniper"],
            family: "Cupressaceae",
            plantType: "Evergreen conifer",
            originSummary: "Widespread across the Northern Hemisphere, including Europe, Asia and North America.",
            knowledgeStatus: .reviewed,
            traits: traits,
            foliageSizeLabel: "Foliage",
            foliageReductionLabel: "Needle reduction",
            summaryLine: "Evergreen · Needle foliage · Cold-hardy · Naturalistic character · Strong yamadori potential · Excellent deadwood potential · Distinctive native European and Nordic bonsai species",
            attentionHighlights: [
                "Important native European and Nordic juniper species",
                "Needle foliage gives the species a distinct character from scale-foliage Chinese Junipers",
                "Slow growth requires patience",
                "Excellent naturalistic and yamadori potential",
                "Excellent deadwood potential",
                "Do not assume reliable back-budding from bare old wood",
                "Preserve useful interior foliage",
                "Pruning decisions must consider future foliage availability",
                "Old collected material requires conservative root management",
                "Strong outdoor light supports healthy growth",
                "Avoid prolonged drought in shallow containers",
                "Avoid permanently saturated substrate",
                "Excellent suitability for wiring",
                "Assess flexibility carefully before major bends",
                "Do not use broadleaf defoliation techniques",
                "Winter dormancy is required",
                "Highly cold-hardy species does not mean shallow bonsai roots are immune to prolonged severe frost",
                "Do not move indoors for routine winter care",
            ],
            sections: sections,
            principleNote: """
            Juniperus communis is one of the most important native juniper species for European and Nordic bonsai.

            It is particularly valued for naturally rugged character, needle foliage, strong association with mountain and northern landscapes, weathered trunks, natural deadwood, dramatic yamadori potential and exceptional cold hardiness.

            Common Juniper is particularly effective when the design respects its natural growth character. This species should not be treated as a generic substitute for Juniperus chinensis.

            Do not assume reliable back-budding from completely bare old wood. Preserve useful foliage and growth where future development may depend on it.

            The individual tree must always be assessed according to health, root condition, vigour, retained foliage, branch strength, development stage, climate, seasonal conditions and recent work.

            The objective is: Healthy roots · Strong foliage · Natural structure · Preserved interior growth · Convincing aged character
            """,
            sourcesNote: """
            Profile content is synthesised from recognised botanical, horticultural and bonsai authorities into Bonsai World editorial language.

            Botanical taxonomy and distribution draw on recognised sources such as Royal Botanic Gardens, Kew and other botanical databases for accepted scientific name, family and native range.

            Horticultural, forestry and landscape context may draw on recognised European and Nordic botanical, forestry and environmental institutions, botanical gardens and arboreta.

            Bonsai-specific cultivation and refinement knowledge draws on established bonsai references and recognised professional practice for Juniperus communis, kept distinct from techniques belonging primarily to other juniper species.

            Verified botanical information, general horticultural cultivation and bonsai-specific practice are kept distinct. Do not copy source wording.
            """
        )
    }

    private static let traits = SpeciesProfileTraits(
        deciduous: false,
        growthStrength: "Slow to Moderate",
        growthSpeed: "Slow",
        leafSize: "Evergreen · Needle foliage · Sharp pointed needles",
        foliageReduction: "Proportion develops through cultivation — vigour dependent",
        ramificationPotential: "Moderate to Good",
        backBudding: "Limited · Do not rely on budding from bare old wood",
        rootDevelopment: "Moderate",
        nebariPotential: "Variable",
        trunkDevelopment: "Slow",
        barkDevelopment: "Weathered bark with natural age and deadwood character",
        wiring: "Excellent suitability",
        defoliation: "Not applicable as a routine technique",
        airLayering: "Where appropriate for the individual material",
        threadGrafting: "Where structural correction is required",
        rootGrafting: "Where appropriate",
        beginnerSuitability: "Moderate to Low",
        bonsaiSuitability: "Excellent",
        difficulty: "Intermediate to Advanced",
        winterDormancyRequired: true,
        winterHardiness: "Outdoor evergreen — winter dormancy required",
        rootFrostSensitivity: "Low to Moderate, but shallow bonsai roots require protection during prolonged severe frost"
    )

    private static var sections: [SpeciesProfileSection] {
        [
            SpeciesProfileSection(
                id: "taxonomic-context",
                title: "Taxonomic Context",
                paragraphs: [
                    "Juniperus communis is an independent botanical species in the cypress family (Cupressaceae).",
                    "Primary Bonsai World display identity: Juniperus communis · Common Juniper.",
                    "Family: Cupressaceae. Plant type: evergreen conifer.",
                    "Native range: widespread across the Northern Hemisphere, including Europe, Asia and North America.",
                    "Maintain a clear distinction between Juniperus communis, Juniperus chinensis, Juniperus sabina, Juniperus procumbens, Juniperus rigida and other Juniperus species.",
                    "Do not merge Common Juniper with Chinese Juniper cultivars. Do not treat all junipers as having identical growth behaviour.",
                    "Needle foliage is a defining distinction from many scale-foliage Chinese Juniper selections used in bonsai.",
                    "Horticultural forms may be mentioned where they affect cultivation, but they do not replace the primary species identity Juniperus communis.",
                    "Bonsai World hierarchy: Species → cultivar / horticultural selection → Individual Tree.",
                ]
            ),
            SpeciesProfileSection(
                id: "overview",
                title: "Species Overview",
                paragraphs: [
                    "Juniperus communis has one of the widest natural distributions of any woody plant species in the Northern Hemisphere.",
                    "It is particularly important in European and Nordic landscapes, where it may grow in open woodland, heathland, rocky terrain, mountain environments, exposed coastal areas and northern landscapes.",
                    "Natural specimens can develop extraordinary character through harsh weather, snow pressure, wind exposure, drought, competition and age.",
                    "For bonsai, Common Juniper is especially valuable when material already possesses natural features such as trunk movement, twisted grain, compact growth, deadwood, aged bark and asymmetrical branch placement.",
                    "The species is particularly suited to naturalistic bonsai, yamadori-style designs, mountain-inspired compositions and rugged old-tree expressions.",
                    "Important development principle: Grow where development is required. Control where refinement is required. Do not remove useful foliage before replacement growth is secure.",
                ],
                bullets: [
                    "Evergreen conifer",
                    "Native across much of the Northern Hemisphere",
                    "Important European and Nordic bonsai species",
                    "Needle foliage",
                    "Slow growth",
                    "Strong cold hardiness",
                    "Excellent naturalistic character",
                    "Excellent deadwood potential",
                    "Valuable yamadori potential",
                    "Do not rely on back-budding from bare old wood",
                    "Requires outdoor cultivation",
                    "Requires winter dormancy",
                ]
            ),
            SpeciesProfileSection(
                id: "natural-growth",
                title: "Natural Growth and Vigour",
                paragraphs: [
                    "Juniperus communis generally grows slowly.",
                    "Growth strength depends on root health, light, climate, water availability, substrate, fertilization, container size and development stage.",
                    "The species should not be forced into excessively rapid development.",
                    "During structural development: allow selected branches and leaders to extend where branch thickness is required, trunk development is required, sacrifice growth is useful or structural development is needed.",
                    "During refinement: manage growth through selective shoot development, branch selection, careful pruning and preservation of useful interior foliage.",
                    "The objective is controlled, sustainable development.",
                ]
            ),
            SpeciesProfileSection(
                id: "foliage",
                title: "Foliage and Needles",
                paragraphs: [
                    "Juniperus communis produces persistent needle foliage.",
                    "The needles are typically narrow, pointed, sharp and arranged in characteristic whorls.",
                    "This needle foliage gives the species a distinct character from the scale foliage of many Chinese Juniper bonsai selections.",
                    "Needle size and density depend on genetics, tree vigour, light, branch strength, fertilization and development stage.",
                    "Do not promise a fixed needle size.",
                    "The objective is foliage proportionate to trunk size, branch structure, overall tree scale and intended design.",
                    "Avoid excessive fertilization where it produces unnecessarily coarse or elongated growth.",
                ]
            ),
            SpeciesProfileSection(
                id: "bark-trunk",
                title: "Bark and Trunk",
                paragraphs: [
                    "Mature Common Juniper can develop highly distinctive trunk character.",
                    "Natural material may display twisted trunks, weathered bark, compressed growth, irregular movement, old scars, deadwood and dramatic live veins.",
                    "The strongest bonsai often begin with material that already has a convincing natural story.",
                    "Trunk development should focus on preserving natural movement, improving proportion, developing branch structure, maintaining visual age and integrating live tissue and deadwood.",
                    "Do not artificially force dramatic movement where the natural material does not support it.",
                ]
            ),
            SpeciesProfileSection(
                id: "roots-nebari",
                title: "Roots and Nebari",
                paragraphs: [
                    "Healthy roots are fundamental to vigour, foliage health, recovery, branch development and long-term refinement.",
                    "Juniperus communis may have root systems that require patience and careful planning, particularly in old collected material.",
                    "Root development objectives include balanced root mass, stable support, gradual root selection, healthy substrate structure and sustainable root density.",
                    "Do not attempt aggressive root correction in one operation. Old material may require staged work over several growing seasons.",
                ]
            ),
            SpeciesProfileSection(
                id: "light",
                title: "Light",
                paragraphs: [
                    "Juniperus communis should be cultivated outdoors.",
                    "Good outdoor light supports healthy foliage, compact growth, branch development and overall vigour.",
                    "The species is naturally adapted to exposed environments.",
                    "Do not assume that a bonsai in a shallow container can tolerate unlimited environmental stress.",
                    "Monitor heat, drought, wind and root-zone drying.",
                    "Do not recommend permanent indoor cultivation.",
                ]
            ),
            SpeciesProfileSection(
                id: "wind",
                title: "Wind",
                paragraphs: [
                    "Common Juniper is naturally associated with exposed environments.",
                    "However, bonsai cultivation in a shallow container changes the environmental conditions experienced by the roots.",
                    "Moderate air movement is generally beneficial.",
                    "Excessive wind can increase water demand, foliage desiccation and root-zone drying.",
                    "Pay particular attention to shallow containers, recently repotted trees, recently collected material and periods of unusually hot and dry wind.",
                ]
            ),
            SpeciesProfileSection(
                id: "watering",
                title: "Watering",
                paragraphs: [
                    "General principle: Water thoroughly when required · Maintain healthy root aeration · Avoid prolonged drought · Avoid permanently saturated substrate.",
                    "Juniperus communis is often tolerant of relatively dry environments in nature, but this must not be confused with tolerance for repeated drought in a shallow bonsai container.",
                    "Watering frequency depends on temperature, wind, sunlight, container size, substrate, foliage mass, root mass and development stage.",
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
                    "Pruning must respect the growth behaviour of Juniperus communis.",
                    "Pruning can be used for structural development, branch selection, shoot control, ramification and silhouette refinement.",
                    "Do not remove foliage from a branch without considering where future growth will come from.",
                    "Before major branch reduction, assess retained foliage, interior growth, branch vigour, tree health and future design requirements.",
                    "During development: allow selected branches and leaders to extend where thickness is required.",
                    "During refinement: use controlled shoot selection and pruning. Avoid repeatedly weakening already weak areas.",
                    "The objective is balanced vigour.",
                ]
            ),
            SpeciesProfileSection(
                id: "back-budding",
                title: "Back-budding",
                paragraphs: [
                    "This is one of the most important operational principles for Juniperus communis.",
                    "Do not remove all foliage from a branch and expect reliable replacement growth from bare wood.",
                    "Future growth depends heavily on retained healthy foliage, branch vigour, light, tree health and pruning strategy.",
                    "Useful interior foliage is strategically important.",
                    "Before reducing a branch, confirm that useful foliage or growth remains in the area required for future development.",
                    "Do not remove structural options before replacement growth is established.",
                ]
            ),
            SpeciesProfileSection(
                id: "ramification",
                title: "Ramification",
                paragraphs: [
                    "Juniperus communis has moderate to good ramification potential.",
                    "Ramification develops through healthy growth, shoot selection, controlled pruning, preservation of interior foliage and balanced vigour.",
                    "The objective is natural, clearly structured conifer ramification.",
                    "Do not pursue excessive density. Excessive foliage density can reduce light penetration, interior growth, branch clarity and long-term design options.",
                    "Preserve useful interior foliage whenever possible.",
                ]
            ),
            SpeciesProfileSection(
                id: "wiring",
                title: "Wiring",
                paragraphs: [
                    "Juniperus communis is highly suitable for wiring.",
                    "Wiring can be used to establish trunk movement, position primary branches, develop secondary branches, create natural asymmetry and refine branch placement.",
                    "Young branches are generally more flexible. Older branches can become rigid and brittle.",
                    "Before major bends, assess branch thickness, flexibility, age, health and structural importance.",
                    "Monitor wire carefully.",
                    "Where major movement is required: use appropriate bending techniques and support rather than forcing rigid material.",
                    "The objective is natural movement consistent with the character of the tree.",
                ]
            ),
            SpeciesProfileSection(
                id: "deadwood-potential",
                title: "Deadwood Potential",
                paragraphs: [
                    "Deadwood is one of the defining characteristics of mature Juniperus communis bonsai.",
                    "Natural deadwood may include jin, shari, broken branches, weathered trunk sections and naturally exposed deadwood.",
                    "Deadwood should support the history of the tree, environmental exposure, age, movement and natural survival character.",
                    "The objective is natural deadwood rather than decorative deadwood.",
                    "Always assess live vein structure, tree health, structural stability, future water movement and long-term preservation.",
                    "Do not remove important living tissue without understanding its role in the individual tree.",
                ]
            ),
            SpeciesProfileSection(
                id: "defoliation",
                title: "Foliage Management",
                paragraphs: [
                    "Foliage management should focus on light penetration, preservation of interior growth, balanced vigour, branch visibility and natural foliage structure.",
                    "Do not use routine stripping or excessive foliage removal as a substitute for correct pruning strategy.",
                    "Do not use broadleaf defoliation techniques on Juniperus communis.",
                    "Avoid unnecessary removal of healthy foliage.",
                    "The objective is healthy foliage, useful interior growth, good light penetration and natural conifer structure.",
                ]
            ),
            SpeciesProfileSection(
                id: "repotting",
                title: "Repotting",
                paragraphs: [
                    "Repotting frequency depends on root development, substrate condition, drainage, container size, tree health and development stage.",
                    "Do not establish a rigid calendar rule.",
                    "Avoid unnecessary aggressive root reduction, excessive removal of functioning roots, and combining major root work with multiple major stresses.",
                    "Preserve sufficient healthy roots. Collected or old material may require especially conservative root management.",
                    "Repotting decisions should be based on root condition, substrate performance and overall tree health.",
                ]
            ),
            SpeciesProfileSection(
                id: "trunk-development",
                title: "Trunk Development",
                paragraphs: [
                    "Juniperus communis develops trunk thickness slowly.",
                    "Where additional development is required: allow selected growth to extend, preserve sacrifice branches where appropriate, provide sufficient root space and avoid premature refinement.",
                    "Many high-quality specimens are valued primarily for existing natural trunk character. In these cases, development should focus on branch structure, foliage distribution, refinement and preservation of aged character.",
                    "Do not sacrifice natural age simply to pursue unnecessary additional trunk thickness.",
                    "Grow where development is required. Control where refinement is required.",
                ]
            ),
            SpeciesProfileSection(
                id: "nebari-development",
                title: "Nebari Development",
                paragraphs: [
                    "Nebari development should be gradual.",
                    "Potential approaches include early root planning in young material, staged root selection, appropriate development containers and gradual correction over time.",
                    "Old collected material may have irregular surface roots.",
                    "The objective is a stable and visually convincing base appropriate to the individual tree.",
                    "Do not force identical nebari expectations onto every naturalistic specimen.",
                ]
            ),
            SpeciesProfileSection(
                id: "propagation",
                title: "Propagation",
                paragraphs: [
                    "Juniperus communis may be propagated through seed, cuttings where appropriate and specialist propagation techniques.",
                    "Seed-grown material can be particularly useful for natural root development, early trunk design and long-term structural development.",
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
                    "Spring: monitor new growth, overall vigour, water demand, root recovery and pest activity. Spring is important for evaluating vigour, structural development and planning seasonal work. Strong and weak areas may require different management.",
                    "Summer: monitor water demand, foliage health, pest activity, heat stress, wire marks and interior foliage condition. Avoid unnecessary heavy work during extreme heat, drought stress or periods of reduced vigour. Pay particular attention to shallow containers.",
                    "Autumn is important for evaluating branch structure, reviewing foliage distribution, assessing overall health and preparing for winter. Monitor wire condition, foliage health and root environment. Seasonal timing depends on local climate.",
                    "Winter: Juniperus communis is an outdoor evergreen conifer. Winter dormancy is required. Do not move the tree into permanently warm indoor conditions.",
                    "Common Juniper is highly cold-hardy in nature, but bonsai roots in shallow containers are more exposed than roots growing in open ground.",
                    "Monitor prolonged severe freezing, freeze-thaw cycles, root exposure, excessive winter moisture and drying winter winds.",
                    "Winter protection must depend on local climate, minimum temperatures, duration of freezing, container depth and root condition.",
                    "Protect the root system when required while maintaining natural dormancy.",
                ]
            ),
            SpeciesProfileSection(
                id: "styles",
                title: "Bonsai Styles",
                paragraphs: [
                    "Juniperus communis is particularly suitable for naturalistic and rugged bonsai styles.",
                    "Particularly suitable expressions include Informal Upright, Slanting, Semi-Cascade, Cascade, Naturalistic Mountain Style, Literati where material supports it, and driftwood-inspired naturalistic forms.",
                    "Common Juniper is particularly effective when styling emphasises natural trunk movement, asymmetry, weather exposure, rugged age, natural deadwood and northern landscape character.",
                    "The individual material should determine the final design.",
                    "Do not force every specimen into the same stereotypical juniper style.",
                ]
            ),
            SpeciesProfileSection(
                id: "tree-stage",
                title: "Development by Tree Stage",
                paragraphs: [
                    "Young material: establish healthy roots, build vigour, develop trunk movement and begin structural development.",
                    "Nursery material: evaluate trunk potential, identify useful branches, establish a design direction and preserve useful foliage.",
                    "Pre-bonsai: develop trunk where required, establish primary branches, improve root structure, preserve interior growth and begin controlled branch development.",
                    "In training: develop secondary branches, improve branch hierarchy, preserve useful interior foliage and build sustainable ramification.",
                    "Refinement: maintain balanced vigour, control shoot extension, preserve interior growth, refine branch placement and maintain natural foliage structure.",
                    "Exhibition / mature refined tree: maintain health, preserve established structure, maintain foliage quality, preserve aged trunk character, preserve natural deadwood and avoid unnecessary major intervention.",
                ]
            ),
            SpeciesProfileSection(
                id: "attention",
                title: "Species-Specific Attention",
                paragraphs: [
                    "These attention points are operational tendencies. They must still be interpreted for the individual tree.",
                ],
                bullets: [
                    "Important native European and Nordic juniper species",
                    "Needle foliage gives the species a distinct character from scale-foliage Chinese Junipers",
                    "Slow growth requires patience",
                    "Excellent naturalistic and yamadori potential",
                    "Excellent deadwood potential",
                    "Do not assume reliable back-budding from bare old wood",
                    "Preserve useful interior foliage",
                    "Pruning decisions must consider future foliage availability",
                    "Old collected material requires conservative root management",
                    "Strong outdoor light supports healthy growth",
                    "Avoid prolonged drought in shallow containers",
                    "Avoid permanently saturated substrate",
                    "Excellent suitability for wiring",
                    "Assess flexibility carefully before major bends",
                    "Do not use broadleaf defoliation techniques",
                    "Winter dormancy is required",
                    "Highly cold-hardy species does not mean shallow bonsai roots are immune to prolonged severe frost",
                    "Do not move indoors for routine winter care",
                ]
            ),
        ]
    }
}
