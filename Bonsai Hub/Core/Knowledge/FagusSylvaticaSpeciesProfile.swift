//
//  FagusSylvaticaSpeciesProfile.swift
//  Bonsai World
//
//  Species Profile — Fagus sylvatica (European Beech).
//  Independent botanical species in Fagaceae. Knowledge status: Reviewed.
//

import Foundation

enum FagusSylvaticaSpeciesProfile {
    /// Identity used by Botanical Library / ``SpeciesPreviewData``.
    static let botanicalLibraryName = "Fagus sylvatica"
    /// Scientific name for Species Profile display (binomial; no botanical authority).
    static let scientificName = "Fagus sylvatica"

    static var profile: SpeciesProfile {
        SpeciesProfile(
            speciesID: BotanicalKnowledgeIDs.fagusSylvatica,
            scientificName: scientificName,
            commonNames: ["European Beech"],
            family: "Fagaceae",
            plantType: "Deciduous broadleaf tree",
            originSummary: "Europe.",
            knowledgeStatus: .reviewed,
            traits: traits,
            foliageSizeLabel: "Foliage",
            foliageReductionLabel: "Leaf reduction",
            summaryLine: "Deciduous · Smooth grey bark · Excellent naturalistic character · Strong trunk development · Good ramification · Long-lived · Important European bonsai species",
            attentionHighlights: [
                "One of Europe's most important deciduous bonsai species",
                "Smooth grey bark is a defining visual characteristic",
                "Naturalistic styling is particularly suitable",
                "Moderate growth supports controlled long-term development",
                "Good back-budding depends on tree health and growing conditions",
                "Good to excellent ramification potential",
                "Do not force excessive foliage density",
                "Mature branch structure should remain visible",
                "Protect smooth bark during wiring",
                "Be careful with severe drying in shallow containers",
                "Strong outdoor conditions support healthy growth",
                "Avoid permanently saturated substrate",
                "Defoliation should not be presented as routine annual maintenance",
                "Winter dormancy is required",
                "Protect shallow roots during severe winter conditions",
                "Do not move indoors for routine winter care",
            ],
            sections: sections,
            principleNote: """
            Fagus sylvatica is one of Europe's most important deciduous forest trees and an excellent species for bonsai.

            It is particularly valued for smooth grey bark, powerful mature trunks, convincing age, elegant branch structure, naturalistic forms, strong seasonal character and long-term refinement potential.

            European Beech can produce highly convincing bonsai, particularly when the design respects the natural character of mature beech trees. The species should not be forced into excessive density or unnatural branch structure.

            Management depends on tree health, root condition, current vigour, development stage, branch strength, retained foliage, climate, seasonal conditions and recent work.

            The objective is: Healthy roots · Strong structure · Natural branch hierarchy · Balanced foliage · Mature character
            """,
            sourcesNote: """
            Profile content is synthesised from recognised botanical, horticultural and bonsai authorities into Bonsai World editorial language.

            Botanical taxonomy and distribution draw on recognised sources such as Royal Botanic Gardens, Kew and other botanical databases for accepted scientific name, family and native range.

            Horticultural and forest context may draw on recognised European botanical gardens, arboreta and forestry institutions.

            Bonsai-specific cultivation and refinement knowledge draws on established bonsai references and recognised professional practice for Fagus sylvatica.

            Verified botanical information, general horticultural cultivation and bonsai-specific practice are kept distinct. Do not copy source wording.
            """
        )
    }

    private static let traits = SpeciesProfileTraits(
        deciduous: true,
        growthStrength: "Moderate",
        growthSpeed: "Moderate",
        leafSize: "Deciduous · Broad leaves · Leaf size can be reduced through long-term bonsai development",
        foliageReduction: "Long-term ramification and cultivation dependent",
        ramificationPotential: "Good to Excellent",
        backBudding: "Good under healthy conditions and appropriate management",
        rootDevelopment: "Good",
        nebariPotential: "Good development potential",
        trunkDevelopment: "Moderate to Strong",
        barkDevelopment: "Smooth grey bark",
        wiring: "Good suitability",
        defoliation: "Possible selectively on strong and healthy trees when appropriate",
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
                    "Fagus sylvatica is an independent botanical species in the beech family (Fagaceae).",
                    "Primary Bonsai World display identity: Fagus sylvatica · European Beech.",
                    "Family: Fagaceae. Plant type: deciduous broadleaf tree.",
                    "Native range: Europe.",
                    "Maintain a clear distinction between Fagus sylvatica, Fagus crenata and other Fagus species.",
                    "Do not merge European Beech with Japanese Beech. They are separate species.",
                    "Horticultural selections and purple-leaved or cut-leaved cultivars may be mentioned where they affect cultivation, but they do not replace the primary species identity Fagus sylvatica.",
                    "Bonsai World hierarchy: Species → cultivar / horticultural selection → Individual Tree.",
                ]
            ),
            SpeciesProfileSection(
                id: "overview",
                title: "Species Overview",
                paragraphs: [
                    "Fagus sylvatica is native to much of Europe and is one of the dominant broadleaf forest trees across large parts of its natural range.",
                    "Mature trees are recognised for smooth grey bark, broad trunks, elegant branch structures, strong seasonal character and impressive visual age.",
                    "The species can be particularly effective as bonsai because mature material can communicate age through trunk and bark rather than relying only on extreme ramification.",
                    "European Beech is often strongest when styling emphasises trunk character, branch structure, mature bark, open spaces and natural crown development.",
                    "Important development principle: Grow where development is required. Control where refinement is required.",
                ],
                bullets: [
                    "Deciduous broadleaf tree",
                    "Native European species",
                    "Smooth grey bark",
                    "Moderate growth",
                    "Good ramification potential",
                    "Good back-budding under appropriate conditions",
                    "Strong naturalistic bonsai potential",
                    "Excellent mature character",
                    "Long-lived species",
                    "Requires outdoor cultivation",
                    "Requires winter dormancy",
                ]
            ),
            SpeciesProfileSection(
                id: "natural-growth",
                title: "Natural Growth and Vigour",
                paragraphs: [
                    "Fagus sylvatica generally develops at a moderate rate.",
                    "Growth strength depends on root health, light, substrate, fertilization, container size, climate, weather and development stage.",
                    "During structural development: allow selected leaders and branches to extend where trunk thickness is required, branch thickness is required, sacrifice growth is useful or structural development is needed.",
                    "Do not prematurely restrict all growth.",
                    "During refinement: manage shoot extension, branch division, foliage density and vigour distribution.",
                    "The objective is controlled development without sacrificing long-term health.",
                ]
            ),
            SpeciesProfileSection(
                id: "foliage",
                title: "Foliage",
                paragraphs: [
                    "Fagus sylvatica produces deciduous broad leaves.",
                    "Leaf size depends on genetics, tree vigour, fertilization, light, branch strength, development stage and pruning strategy.",
                    "Leaf reduction is primarily a long-term result of mature ramification, balanced growth, controlled pruning and appropriate cultivation.",
                    "Do not promise a fixed leaf size.",
                    "The objective is foliage proportionate to trunk size, branch structure, tree scale and overall design.",
                ]
            ),
            SpeciesProfileSection(
                id: "bark-trunk",
                title: "Bark and Trunk",
                paragraphs: [
                    "Smooth grey bark is one of the defining characteristics of Fagus sylvatica.",
                    "Healthy bark should be preserved. Avoid unnecessary damage to mature bark.",
                    "Trunk development should focus on taper, movement, proportion, mature character and the relationship between trunk and branches.",
                    "Mature beech can develop highly convincing visual age even without heavily textured bark.",
                    "Do not attempt to artificially create rough bark characteristics that do not belong to the species.",
                ]
            ),
            SpeciesProfileSection(
                id: "roots-nebari",
                title: "Roots and Nebari",
                paragraphs: [
                    "Healthy roots are fundamental to tree vigour, foliage quality, recovery, branch development and long-term refinement.",
                    "Root development objectives include balanced root mass, stable tree support, radial root development where possible, gradual root selection and healthy substrate structure.",
                    "Nebari development should be gradual.",
                    "Do not attempt to aggressively correct the entire root structure in one operation.",
                ]
            ),
            SpeciesProfileSection(
                id: "light",
                title: "Light",
                paragraphs: [
                    "Fagus sylvatica should be cultivated outdoors.",
                    "Strong but appropriate outdoor light supports healthy foliage, compact growth, branch development and overall vigour.",
                    "European Beech naturally tolerates a range of light conditions, but bonsai cultivation benefits from sufficient light for compact and healthy growth.",
                    "During periods of extreme heat, monitor leaf stress, water demand and shallow root conditions.",
                    "Local climate and environmental conditions must always be considered.",
                    "Do not recommend permanent indoor cultivation.",
                ]
            ),
            SpeciesProfileSection(
                id: "wind",
                title: "Wind",
                paragraphs: [
                    "Moderate air movement is generally beneficial.",
                    "Excessive wind can increase water demand, leaf desiccation, stress on shallow roots and stress on recently repotted trees.",
                    "Pay particular attention to shallow bonsai containers, exposed growing locations and periods of hot, dry wind.",
                ]
            ),
            SpeciesProfileSection(
                id: "watering",
                title: "Watering",
                paragraphs: [
                    "General principle: Water thoroughly when required · Maintain healthy root aeration · Avoid prolonged drought · Avoid permanently saturated substrate.",
                    "European Beech can be sensitive to severe drying, particularly in shallow bonsai containers.",
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
                    "Desired characteristics include good drainage, strong aeration, stable particle structure, sufficient moisture retention and healthy root development.",
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
                    "Avoid excessive fertilization where it produces unnecessarily large leaves, excessively long internodes or coarse growth.",
                    "Key principle: Feed the tree you are growing, not simply the species name.",
                ]
            ),
            SpeciesProfileSection(
                id: "pruning",
                title: "Pruning",
                paragraphs: [
                    "Fagus sylvatica responds well to thoughtful pruning.",
                    "Pruning can be used for structural development, branch selection, ramification and silhouette refinement.",
                    "During development: allow selected branches to extend where thickness is required.",
                    "During refinement: use controlled pruning to develop secondary branches, tertiary branches and balanced ramification.",
                    "Avoid repeatedly cutting weak areas in the same way as strong areas.",
                    "The objective is balanced vigour throughout the tree.",
                ]
            ),
            SpeciesProfileSection(
                id: "back-budding",
                title: "Back-budding",
                paragraphs: [
                    "Fagus sylvatica can produce useful back-buds.",
                    "Back-budding must never be treated as guaranteed. Response depends on tree health, branch vigour, light penetration, retained structure, pruning strategy and overall root health.",
                    "Useful back-budding can support branch replacement, improved branch structure, increased ramification and correction of overly long branches.",
                    "Do not remove important structural options before useful replacement growth is established.",
                ]
            ),
            SpeciesProfileSection(
                id: "ramification",
                title: "Ramification",
                paragraphs: [
                    "European Beech has good to excellent ramification potential.",
                    "Ramification is developed through healthy growth, controlled pruning, selective extension, branch selection and preservation of useful interior growth.",
                    "The objective is clear branch hierarchy with fine but natural ramification.",
                    "Do not pursue excessive density. Natural branch structure and negative space remain important design elements.",
                ]
            ),
            SpeciesProfileSection(
                id: "wiring",
                title: "Wiring",
                paragraphs: [
                    "Fagus sylvatica is suitable for wiring.",
                    "Wiring can be used to establish branch position, develop branch structure, refine secondary branches and improve natural branch movement.",
                    "Young branches are generally more flexible. Older branches become increasingly rigid and may be more prone to damage.",
                    "Monitor wire carefully. Avoid unnecessary damage to the smooth bark.",
                    "Before major bends, assess branch thickness, flexibility, age, health and structural importance.",
                ]
            ),
            SpeciesProfileSection(
                id: "deadwood-potential",
                title: "Deadwood Potential",
                paragraphs: [
                    "Deadwood is not normally the defining feature of European Beech bonsai.",
                    "Natural deadwood may occur and can sometimes support age, natural damage history, hollow trunks and old wounds.",
                    "European Beech does not generally lend itself to the same long-term exposed deadwood treatment associated with many conifers.",
                    "Do not add artificial jin or excessive exposed deadwood simply because deadwood techniques are available.",
                    "Where natural hollows or wounds exist: preserve the character of the material and assess long-term structural health.",
                ]
            ),
            SpeciesProfileSection(
                id: "defoliation",
                title: "Leaf Management",
                paragraphs: [
                    "Leaf management should primarily focus on proportion, light penetration, branch visibility and balanced vigour.",
                    "Defoliation or partial defoliation may be possible on strong and healthy trees where appropriate.",
                    "Do not present complete defoliation as routine annual maintenance.",
                    "Do not defoliate weak trees, recently repotted trees, recovering trees or trees under environmental stress.",
                    "Selective leaf reduction or partial defoliation may be more appropriate.",
                    "Detailed procedures belong in Bonsai World Seasonal Care and Advanced Refinement content.",
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
                ]
            ),
            SpeciesProfileSection(
                id: "trunk-development",
                title: "Trunk Development",
                paragraphs: [
                    "Fagus sylvatica has strong potential for long-term trunk development.",
                    "Where additional thickness is required: allow selected leaders to extend, use sacrifice growth where appropriate, provide sufficient root space and avoid premature refinement.",
                    "Once sufficient structural development has been achieved, shift focus toward taper, primary branches, secondary branching, ramification, bark preservation and overall refinement.",
                    "Grow where development is required. Control where refinement is required.",
                ]
            ),
            SpeciesProfileSection(
                id: "nebari-development",
                title: "Nebari Development",
                paragraphs: [
                    "Nebari should be developed gradually.",
                    "Potential approaches include early root selection, radial root positioning where possible, staged correction and appropriate development containers.",
                    "The objective is a stable and visually convincing base appropriate to the individual design.",
                    "Do not force identical nebari expectations onto every tree.",
                ]
            ),
            SpeciesProfileSection(
                id: "propagation",
                title: "Propagation",
                paragraphs: [
                    "Fagus sylvatica may be propagated through seed, air layering where appropriate and other specialist propagation methods.",
                    "Seed-grown material can be particularly useful for natural root development, trunk development and long-term structural design.",
                    "Detailed procedures belong in Bonsai World Propagation Knowledge Articles.",
                ]
            ),
            SpeciesProfileSection(
                id: "pests",
                title: "Pests and Problems",
                paragraphs: [
                    "Relevant risks may include aphids, scale insects, mites, leaf-feeding insects, fungal leaf diseases, powdery mildew, root problems caused by poor drainage and stress-related leaf scorch.",
                    "Do not provide generic treatment instructions.",
                    "Diagnosis and treatment belong in Care → Pest Management and Care → Disease & Problems.",
                ]
            ),
            SpeciesProfileSection(
                id: "seasonal",
                title: "Seasonal Profile",
                paragraphs: [
                    "Spring: monitor bud development, new leaf growth, water demand, overall vigour and pest activity. Spring is important for structural growth, branch development and evaluating vigour. Avoid treating all branches identically.",
                    "Summer: monitor water demand, leaf health, heat stress, pest activity, shoot extension and wire marks. European Beech can experience leaf stress during hot and dry conditions. Shallow bonsai containers require careful observation. Avoid unnecessary heavy work during periods of extreme environmental stress.",
                    "Autumn is important for evaluating branch structure, reviewing ramification, assessing tree health and preparing for winter. Foliage will develop seasonal colour before leaf fall. Monitor branch structure, wire condition and root environment. Seasonal timing depends on local climate.",
                    "Winter: Fagus sylvatica is an outdoor deciduous bonsai. Winter dormancy is required. The tree must not be moved indoors for routine winter care.",
                    "Although the species is hardy, bonsai roots in shallow containers are more exposed than roots growing in open ground.",
                    "Monitor prolonged severe freezing, freeze-thaw cycles, root exposure, excessive winter moisture and drying wind.",
                    "Winter protection must depend on local climate, minimum temperature, duration of freezing, container depth and root condition.",
                ]
            ),
            SpeciesProfileSection(
                id: "styles",
                title: "Bonsai Styles",
                paragraphs: [
                    "Fagus sylvatica is suitable for a range of bonsai styles.",
                    "Particularly suitable expressions include Informal Upright, Formal Upright, Slanting, naturalistic upright forms, Broom Style and Forest / Group Planting.",
                    "European Beech is particularly effective when styling emphasises mature trunk character, smooth bark, elegant branch structure, natural crown development and convincing visual age.",
                    "The individual material should determine the final design.",
                ]
            ),
            SpeciesProfileSection(
                id: "tree-stage",
                title: "Development by Tree Stage",
                paragraphs: [
                    "Young material: establish healthy roots, build vigour, develop trunk movement and begin root and nebari development.",
                    "Nursery material: evaluate trunk potential, identify useful branches, establish a design direction and preserve development growth where needed.",
                    "Pre-bonsai: develop trunk, establish primary branches, improve root structure and begin controlled branch development.",
                    "In training: develop secondary branches, build ramification, improve branch hierarchy and refine branch placement.",
                    "Refinement: maintain balanced vigour, control extension, improve ramification, maintain proportionate foliage and preserve natural branch structure.",
                    "Exhibition / mature refined tree: maintain health, preserve established design, maintain foliage quality, preserve mature bark and avoid unnecessary major intervention.",
                ]
            ),
            SpeciesProfileSection(
                id: "attention",
                title: "Species-Specific Attention",
                paragraphs: [
                    "These attention points are operational tendencies. They must still be interpreted for the individual tree.",
                ],
                bullets: [
                    "One of Europe's most important deciduous bonsai species",
                    "Smooth grey bark is a defining visual characteristic",
                    "Naturalistic styling is particularly suitable",
                    "Moderate growth supports controlled long-term development",
                    "Good back-budding depends on tree health and growing conditions",
                    "Good to excellent ramification potential",
                    "Do not force excessive foliage density",
                    "Mature branch structure should remain visible",
                    "Protect smooth bark during wiring",
                    "Be careful with severe drying in shallow containers",
                    "Strong outdoor conditions support healthy growth",
                    "Avoid permanently saturated substrate",
                    "Defoliation should not be presented as routine annual maintenance",
                    "Winter dormancy is required",
                    "Protect shallow roots during severe winter conditions",
                    "Do not move indoors for routine winter care",
                ]
            ),
        ]
    }
}
