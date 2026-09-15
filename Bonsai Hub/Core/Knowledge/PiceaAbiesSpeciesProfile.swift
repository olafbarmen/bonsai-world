//
//  PiceaAbiesSpeciesProfile.swift
//  Bonsai World
//
//  Species Profile — Picea abies (Norway Spruce).
//  Independent botanical species in Pinaceae. Knowledge status: Reviewed.
//

import Foundation

enum PiceaAbiesSpeciesProfile {
    /// Identity used by Botanical Library / ``SpeciesPreviewData``.
    static let botanicalLibraryName = "Picea abies"
    /// Scientific name for Species Profile display (binomial; no botanical authority).
    static let scientificName = "Picea abies"

    static var profile: SpeciesProfile {
        SpeciesProfile(
            speciesID: BotanicalKnowledgeIDs.piceaAbies,
            scientificName: scientificName,
            commonNames: ["Norway Spruce"],
            family: "Pinaceae",
            plantType: "Evergreen conifer",
            originSummary: "Northern, Central and Eastern Europe.",
            knowledgeStatus: .reviewed,
            traits: traits,
            foliageSizeLabel: "Foliage",
            foliageReductionLabel: "Needle reduction",
            summaryLine: "Evergreen · Fine needles · Strong conifer character · Excellent deadwood potential · Good naturalistic styling potential · Cold-hardy · Important European bonsai species",
            attentionHighlights: [
                "One of Europe's most important conifer species for bonsai",
                "Naturally short needles support convincing bonsai proportions",
                "Excellent naturalistic styling potential",
                "Excellent deadwood potential",
                "Do not assume reliable back-budding from bare old wood",
                "Preserve useful interior foliage",
                "Pruning decisions must consider future bud and foliage availability",
                "Strong outdoor light supports healthy growth",
                "Avoid prolonged drought",
                "Avoid permanently saturated substrate",
                "Excellent suitability for wiring",
                "Monitor wire carefully during active growth",
                "Do not use routine broadleaf defoliation techniques",
                "Winter dormancy is required",
                "Protect shallow roots during prolonged severe frost",
                "Do not move indoors for routine winter care",
            ],
            sections: sections,
            principleNote: """
            Picea abies is one of Europe's most important conifer species and is highly suitable for bonsai.

            It is particularly valued for naturally small needles, strong conifer character, mature bark, excellent deadwood potential, naturalistic styling, dramatic trunk movement and mountain and forest tree character.

            The species is particularly effective when developed with respect for its natural growth habit. Picea abies should not be managed as though it responds like a broadleaf species.

            Do not assume reliable back-budding from bare old wood. Maintain useful foliage and growth where future development may depend on it.

            The individual tree must always be assessed according to health, root condition, vigour, retained foliage, branch strength, development stage, climate, seasonal conditions and recent work.

            The objective is: Healthy roots · Strong foliage · Clear structure · Natural conifer character · Sustainable long-term refinement
            """,
            sourcesNote: """
            Profile content is synthesised from recognised botanical, horticultural and bonsai authorities into Bonsai World editorial language.

            Botanical taxonomy and distribution draw on recognised sources such as Royal Botanic Gardens, Kew and other botanical databases for accepted scientific name, family and native range.

            Horticultural and forestry context may draw on recognised European forestry institutions, botanical gardens, arboreta and conifer collections.

            Bonsai-specific cultivation and refinement knowledge draws on established bonsai references and recognised professional practice for Picea abies.

            Verified botanical information, general horticultural cultivation and bonsai-specific practice are kept distinct. Do not copy source wording.
            """
        )
    }

    private static let traits = SpeciesProfileTraits(
        deciduous: false,
        growthStrength: "Moderate to Strong",
        growthSpeed: "Moderate",
        leafSize: "Evergreen · Short needles · Dense conifer foliage",
        foliageReduction: "Proportion develops through cultivation — vigour dependent",
        ramificationPotential: "Good",
        backBudding: "Limited to Moderate depending on healthy foliage and retained growth",
        rootDevelopment: "Good",
        nebariPotential: "Good development potential",
        trunkDevelopment: "Moderate to Strong",
        barkDevelopment: "Mature bark with strong conifer character",
        wiring: "Excellent suitability",
        defoliation: "Not applicable as a routine technique",
        airLayering: "Where appropriate for the individual material",
        threadGrafting: "May be relevant for structural correction",
        rootGrafting: "Where appropriate",
        beginnerSuitability: "Moderate",
        bonsaiSuitability: "Excellent",
        difficulty: "Intermediate",
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
                    "Picea abies is an independent botanical species in the pine family (Pinaceae).",
                    "Primary Bonsai World display identity: Picea abies · Norway Spruce.",
                    "Family: Pinaceae. Plant type: evergreen conifer.",
                    "Native range: northern, central and eastern Europe.",
                    "Maintain a clear distinction between Picea abies, Picea glauca, Picea pungens and other Picea species.",
                    "Do not merge Norway Spruce with White Spruce or other spruce species. Different Picea species have different growth patterns and management requirements.",
                    "Horticultural selections and dwarf cultivars may be mentioned where they affect cultivation, but they do not replace the primary species identity Picea abies.",
                    "Bonsai World hierarchy: Species → cultivar / horticultural selection → Individual Tree.",
                ]
            ),
            SpeciesProfileSection(
                id: "overview",
                title: "Species Overview",
                paragraphs: [
                    "Picea abies is native across large parts of northern, central and eastern Europe and is one of the dominant conifer species in many European forests.",
                    "It is highly recognisable for dense evergreen foliage, relatively short needles, conical growth, mature bark, strong structural branches and dramatic old-age forms in harsh environments.",
                    "For bonsai, Norway Spruce can be particularly effective when developed from nursery stock, collected material where legally and ethically appropriate, field-grown material, and yamadori where legally and ethically appropriate.",
                    "The species is especially suited to trees that emphasise natural trunk movement, age, rugged character, deadwood, asymmetry and natural branch placement.",
                    "Important development principle: Grow where development is required. Control where refinement is required. Do not remove useful foliage before replacement growth is secure.",
                ],
                bullets: [
                    "Evergreen conifer",
                    "Important European conifer species",
                    "Naturally short needles",
                    "Moderate growth",
                    "Good ramification potential",
                    "Back-budding should not be assumed from bare old wood",
                    "Excellent wiring potential",
                    "Excellent natural deadwood potential",
                    "Strong naturalistic bonsai character",
                    "Suitable for yamadori-style development",
                    "Requires outdoor cultivation",
                    "Requires winter dormancy",
                ]
            ),
            SpeciesProfileSection(
                id: "natural-growth",
                title: "Natural Growth and Vigour",
                paragraphs: [
                    "Picea abies generally develops with moderate to strong vigour under suitable growing conditions.",
                    "Growth strength depends on root health, light, temperature, water availability, substrate, fertilization, container size and development stage.",
                    "During structural development: allow selected leaders and branches to extend where trunk thickness is required, branch thickness is required, sacrifice growth is useful or structural development is needed.",
                    "Do not continuously restrict all growth simply to maintain a compact appearance.",
                    "During refinement: manage growth through shoot selection, selective pruning, branch positioning and careful management of vigour.",
                    "The objective is controlled growth while preserving useful foliage.",
                ]
            ),
            SpeciesProfileSection(
                id: "foliage",
                title: "Foliage and Needles",
                paragraphs: [
                    "Picea abies produces short evergreen needles.",
                    "Needle size and density depend on genetics, tree vigour, fertilization, light, branch strength and development stage.",
                    "The species is naturally suitable for bonsai because of its relatively fine foliage.",
                    "Do not promise a fixed needle size.",
                    "The objective is foliage proportionate to trunk size, branch structure, overall tree scale and intended design.",
                    "Avoid excessive fertilization where it produces unnecessarily coarse or overly vigorous growth.",
                ]
            ),
            SpeciesProfileSection(
                id: "bark-trunk",
                title: "Bark and Trunk",
                paragraphs: [
                    "Mature Picea abies can develop strong trunk and bark character.",
                    "Trunk development should focus on taper, movement, proportion, mature bark and the relationship between trunk and branches.",
                    "Norway Spruce is particularly effective when natural material already contains movement, age, scars, deadwood and weathered character.",
                    "Where additional thickness is required: allow selected leaders to extend, use sacrifice growth where appropriate, provide sufficient growing space and avoid premature refinement.",
                    "Do not artificially force every tree into an extreme conifer design. The individual material should determine the final expression.",
                ]
            ),
            SpeciesProfileSection(
                id: "roots-nebari",
                title: "Roots and Nebari",
                paragraphs: [
                    "Healthy roots are fundamental to vigour, foliage health, recovery, branch development and long-term refinement.",
                    "Root development objectives include balanced root mass, stable tree support, gradual root selection, healthy substrate structure and appropriate root density.",
                    "Nebari development should be approached gradually.",
                    "Do not attempt to aggressively correct the entire root structure in one operation.",
                ]
            ),
            SpeciesProfileSection(
                id: "light",
                title: "Light",
                paragraphs: [
                    "Picea abies should be cultivated outdoors.",
                    "Strong outdoor light supports healthy foliage, compact growth, bud development, branch development and overall vigour.",
                    "Local climate must always be considered.",
                    "In unusually hot climates, monitor heat stress, water demand, root-zone temperature and foliage condition.",
                    "Do not recommend permanent indoor cultivation.",
                ]
            ),
            SpeciesProfileSection(
                id: "wind",
                title: "Wind",
                paragraphs: [
                    "Moderate air movement is generally beneficial.",
                    "Excessive wind can increase water demand, foliage desiccation, root-zone drying and stress on recently repotted trees.",
                    "Pay particular attention to shallow containers, exposed locations, newly collected material, recently repotted trees and periods of hot and dry wind.",
                ]
            ),
            SpeciesProfileSection(
                id: "watering",
                title: "Watering",
                paragraphs: [
                    "General principle: Water thoroughly when required · Maintain healthy root aeration · Avoid prolonged drought · Avoid permanently saturated substrate.",
                    "Picea abies should not be allowed to experience unnecessary prolonged drying.",
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
                    "The final soil mix depends on local climate, rainfall, watering habits, container depth, tree size and development stage.",
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
                    "During refinement: nutrition should support healthy foliage, controlled extension, bud development and balanced ramification.",
                    "Avoid excessive fertilization where it produces unnecessarily coarse growth, excessive extension or foliage disproportionate to the design.",
                    "Key principle: Feed the tree you are growing, not simply the species name.",
                ]
            ),
            SpeciesProfileSection(
                id: "pruning",
                title: "Pruning",
                paragraphs: [
                    "Pruning must respect the growth behaviour of Picea abies.",
                    "Pruning can be used for structural development, branch selection, shoot control, ramification and silhouette refinement.",
                    "Do not remove foliage from a branch without considering where future growth will come from.",
                    "Before major reduction, assess retained foliage, interior growth, bud availability, branch health and future design requirements.",
                    "During development: allow selected branches and leaders to extend where thickness is required.",
                    "During refinement: use controlled shoot and branch management. Avoid repeatedly weakening already weak areas.",
                    "The objective is balanced vigour.",
                ]
            ),
            SpeciesProfileSection(
                id: "back-budding",
                title: "Back-budding",
                paragraphs: [
                    "This is an important management principle for Picea abies.",
                    "The species should not be treated like a species that reliably produces replacement buds from completely bare old wood.",
                    "Bud and shoot development depends on retained foliage, branch health, light, vigour, age of the branch and pruning strategy.",
                    "Useful interior growth should be preserved whenever possible.",
                    "Do not remove foliage from a branch unless the future development of that branch remains secure.",
                    "Before reducing a branch, confirm that useful growth exists in the area required for future development.",
                ]
            ),
            SpeciesProfileSection(
                id: "ramification",
                title: "Ramification",
                paragraphs: [
                    "Picea abies has good potential for ramification when healthy growth is managed carefully.",
                    "Ramification is developed through controlled shoot development, selective pruning, branch selection, preservation of interior foliage and balanced vigour.",
                    "The objective is clear branch hierarchy with natural conifer ramification.",
                    "Do not pursue excessive density at the expense of light penetration, interior foliage, branch health or natural structure.",
                    "Interior growth is valuable for future refinement.",
                ]
            ),
            SpeciesProfileSection(
                id: "wiring",
                title: "Wiring",
                paragraphs: [
                    "Picea abies is highly suitable for wiring.",
                    "Wiring can be used to establish trunk movement, position primary branches, develop secondary branches, create natural asymmetry and refine branch placement.",
                    "Young material is generally flexible. Older branches may become rigid.",
                    "Before major bends, assess branch thickness, flexibility, age, health and structural importance.",
                    "Monitor wire carefully. Do not allow wire to create unnecessary damage.",
                    "Where major movement is required: use appropriate support and bending techniques rather than forcing brittle material.",
                ]
            ),
            SpeciesProfileSection(
                id: "deadwood-potential",
                title: "Deadwood Potential",
                paragraphs: [
                    "Deadwood is an important feature of Picea abies bonsai.",
                    "Natural deadwood may include jin, shari, broken branches, weathered scars and naturally aged trunk sections.",
                    "Deadwood should support the natural history of the tree, trunk movement, age and environmental character.",
                    "Do not add excessive deadwood simply because the species can support it.",
                    "The objective is natural character rather than decorative deadwood.",
                    "Deadwood must be evaluated in relation to live vein structure, branch health, trunk stability and long-term preservation.",
                ]
            ),
            SpeciesProfileSection(
                id: "defoliation",
                title: "Needle Management",
                paragraphs: [
                    "Do not present needle removal as a routine replacement for proper pruning strategy.",
                    "Do not use routine broadleaf defoliation techniques on Picea abies.",
                    "Needle density should primarily be managed through balanced growth, selective shoot control, appropriate pruning, good light and preservation of interior foliage.",
                    "Do not remove large amounts of healthy foliage without a clear structural reason.",
                    "The objective is healthy foliage, good light penetration, useful interior growth and natural conifer structure.",
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
                    "Picea abies has strong long-term trunk development potential.",
                    "Where additional thickness is required: allow selected leaders to extend, use sacrifice branches where appropriate, provide sufficient root space and avoid premature refinement.",
                    "Once sufficient structural development has been achieved, shift focus toward taper, primary branches, branch placement, ramification, trunk character and deadwood where naturally appropriate.",
                    "Grow where development is required. Control where refinement is required.",
                ]
            ),
            SpeciesProfileSection(
                id: "nebari-development",
                title: "Nebari Development",
                paragraphs: [
                    "Nebari should be developed gradually.",
                    "Potential approaches include early root selection, radial root positioning where possible, staged correction and appropriate development containers.",
                    "The objective is a stable and visually convincing base appropriate to the individual tree.",
                    "Do not force identical nebari expectations onto every tree.",
                ]
            ),
            SpeciesProfileSection(
                id: "propagation",
                title: "Propagation",
                paragraphs: [
                    "Picea abies may be propagated through seed, grafting in specialist contexts and other professional propagation techniques.",
                    "Seed-grown material can be useful for natural root development, early trunk design and long-term structural development.",
                    "Detailed procedures belong in Bonsai World Propagation Knowledge Articles.",
                ]
            ),
            SpeciesProfileSection(
                id: "pests",
                title: "Pests and Problems",
                paragraphs: [
                    "Relevant risks may include aphids, spider mites, scale insects, spruce-specific sucking insects, fungal needle diseases, root problems caused by poor drainage, stress-related needle browning and environmental desiccation.",
                    "Do not provide generic treatment instructions.",
                    "Diagnosis and treatment belong in Care → Pest Management and Care → Disease & Problems.",
                ]
            ),
            SpeciesProfileSection(
                id: "seasonal",
                title: "Seasonal Profile",
                paragraphs: [
                    "Spring: monitor bud development, new shoot growth, overall vigour, water demand and pest activity. Spring is important for structural growth, shoot development and evaluating vigour. Avoid treating all areas of the tree identically. Strong areas may require different management from weak areas.",
                    "Summer: monitor water demand, foliage health, pest activity, shoot development, wire marks and heat stress. Avoid unnecessary heavy work during extreme heat, drought stress or periods of reduced vigour. Maintain careful observation of shallow containers.",
                    "Autumn is important for evaluating branch structure, reviewing ramification, assessing overall vigour and preparing for winter. Monitor wire condition, foliage health and root environment. Seasonal timing depends on local climate.",
                    "Winter: Picea abies is an outdoor conifer requiring natural winter dormancy. Do not move the tree into permanently warm indoor conditions.",
                    "Although the species is naturally cold-hardy, bonsai roots in shallow containers are more exposed than roots growing in open ground.",
                    "Monitor prolonged severe freezing, freeze-thaw cycles, root exposure, excessive winter moisture and drying winter winds.",
                    "Winter protection must depend on local climate, minimum temperatures, duration of freezing, container depth and root condition.",
                    "Protect the root system when required while maintaining appropriate winter dormancy.",
                ]
            ),
            SpeciesProfileSection(
                id: "styles",
                title: "Bonsai Styles",
                paragraphs: [
                    "Picea abies is suitable for a range of bonsai styles.",
                    "Particularly suitable expressions include Informal Upright, Formal Upright, Slanting, Semi-Cascade, Cascade, Naturalistic Mountain Style, Literati where material supports it, and Forest / Group Planting.",
                    "Norway Spruce is particularly effective when styling emphasises natural trunk movement, asymmetry, rugged age, weathered character, natural deadwood and mountain or northern forest character.",
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
                    "In training: develop secondary branches, build ramification, preserve useful interior foliage and improve branch hierarchy.",
                    "Refinement: maintain balanced vigour, control shoot extension, improve ramification, preserve interior growth and maintain natural conifer structure.",
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
                    "One of Europe's most important conifer species for bonsai",
                    "Naturally short needles support convincing bonsai proportions",
                    "Excellent naturalistic styling potential",
                    "Excellent deadwood potential",
                    "Do not assume reliable back-budding from bare old wood",
                    "Preserve useful interior foliage",
                    "Pruning decisions must consider future bud and foliage availability",
                    "Strong outdoor light supports healthy growth",
                    "Avoid prolonged drought",
                    "Avoid permanently saturated substrate",
                    "Excellent suitability for wiring",
                    "Monitor wire carefully during active growth",
                    "Do not use routine broadleaf defoliation techniques",
                    "Winter dormancy is required",
                    "Protect shallow roots during prolonged severe frost",
                    "Do not move indoors for routine winter care",
                ]
            ),
        ]
    }
}
