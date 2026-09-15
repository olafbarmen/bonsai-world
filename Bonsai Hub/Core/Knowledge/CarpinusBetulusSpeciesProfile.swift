//
//  CarpinusBetulusSpeciesProfile.swift
//  Bonsai World
//
//  Species Profile — Carpinus betulus (European Hornbeam).
//  Independent botanical species in Betulaceae. Knowledge status: Reviewed.
//

import Foundation

enum CarpinusBetulusSpeciesProfile {
    /// Identity used by Botanical Library / ``SpeciesPreviewData``.
    static let botanicalLibraryName = "Carpinus betulus"
    /// Scientific name for Species Profile display (binomial; no botanical authority).
    static let scientificName = "Carpinus betulus"

    static var profile: SpeciesProfile {
        SpeciesProfile(
            speciesID: BotanicalKnowledgeIDs.carpinusBetulus,
            scientificName: scientificName,
            commonNames: ["European Hornbeam"],
            family: "Betulaceae",
            plantType: "Deciduous broadleaf tree",
            originSummary: "Europe and parts of western Asia.",
            knowledgeStatus: .reviewed,
            traits: traits,
            foliageSizeLabel: "Foliage",
            foliageReductionLabel: "Leaf reduction",
            summaryLine: "Deciduous · Strong ramification · Excellent pruning response · Small to medium leaves · Attractive fluted trunk character · Strong naturalistic bonsai potential",
            attentionHighlights: [
                "One of the most important European deciduous bonsai species",
                "Excellent ramification potential",
                "Good to excellent back-budding under healthy conditions",
                "Strong response to pruning",
                "Naturally proportionate foliage",
                "Mature trunk character can become an important visual feature",
                "Do not confuse with Fagus sylvatica",
                "Strong outdoor light supports healthy and compact growth",
                "Avoid prolonged drought in shallow containers",
                "Avoid permanently saturated substrate",
                "Vigorous growth can create wire marks",
                "Defoliation should not be presented as routine annual maintenance",
                "Winter dormancy is required",
                "Protect shallow roots during prolonged severe frost",
                "Do not move indoors for routine winter care",
            ],
            sections: sections,
            principleNote: """
            Carpinus betulus is one of the most important European deciduous species for bonsai.

            It is particularly valued for excellent ramification, strong response to pruning, naturally proportionate foliage, convincing mature branch structure, attractive trunk character and adaptability to many naturalistic bonsai forms.

            European Hornbeam is particularly suitable for the development of trees with dense branch structures, mature crowns, natural woodland character and convincing deciduous silhouettes.

            The individual tree must always be assessed according to health, root condition, vigour, development stage, branch strength, light exposure, climate, seasonal conditions and recent work.

            The objective is: Healthy roots · Strong structure · Fine ramification · Balanced foliage · Natural mature character
            """,
            sourcesNote: """
            Profile content is synthesised from recognised botanical, horticultural and bonsai authorities into Bonsai World editorial language.

            Botanical taxonomy and distribution draw on recognised sources such as Royal Botanic Gardens, Kew and other botanical databases for accepted scientific name, family and native range.

            Horticultural and forest context may draw on recognised European botanical gardens, arboreta and forestry institutions.

            Bonsai-specific cultivation and refinement knowledge draws on established bonsai references and recognised professional practice for Carpinus betulus.

            Verified botanical information, general horticultural cultivation and bonsai-specific practice are kept distinct. Do not copy source wording.
            """
        )
    }

    private static let traits = SpeciesProfileTraits(
        deciduous: true,
        growthStrength: "Moderate to Strong",
        growthSpeed: "Moderate",
        leafSize: "Deciduous · Relatively small leaves · Serrated margins",
        foliageReduction: "Good potential — ramification and cultivation dependent",
        ramificationPotential: "Excellent",
        backBudding: "Good to Excellent under healthy conditions",
        rootDevelopment: "Good",
        nebariPotential: "Good development potential",
        trunkDevelopment: "Moderate to Strong",
        barkDevelopment: "Attractive mature trunk character, often fluted",
        wiring: "Good suitability",
        defoliation: "Possible selectively on strong and healthy trees when appropriate",
        airLayering: "Where appropriate for the individual material",
        threadGrafting: "Where structural correction is required",
        rootGrafting: "Where appropriate",
        beginnerSuitability: "Good",
        bonsaiSuitability: "Excellent",
        difficulty: "Beginner to Intermediate",
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
                    "Carpinus betulus is an independent botanical species in the birch family (Betulaceae).",
                    "Primary Bonsai World display identity: Carpinus betulus · European Hornbeam.",
                    "Family: Betulaceae. Plant type: deciduous broadleaf tree.",
                    "Native range: Europe and parts of western Asia.",
                    "Maintain a clear distinction between Carpinus betulus, Carpinus japonica and other Carpinus species.",
                    "Do not confuse European Hornbeam with European Beech. Although the two can sometimes be mixed because of broadly similar leaves and deciduous European woodland character, they are botanically distinct and belong to different families.",
                    "Fagus sylvatica remains a separate Species Library profile in Fagaceae.",
                    "Horticultural selections may be mentioned where they affect cultivation, but they do not replace the primary species identity Carpinus betulus.",
                    "Bonsai World hierarchy: Species → cultivar / horticultural selection → Individual Tree.",
                ]
            ),
            SpeciesProfileSection(
                id: "overview",
                title: "Species Overview",
                paragraphs: [
                    "Carpinus betulus is native across much of Europe and extends into parts of western Asia.",
                    "It is a highly useful bonsai species because it combines reliable growth, strong response to pruning, good back-budding potential, excellent ramification, manageable foliage and convincing mature structure.",
                    "Mature trees may develop distinctive trunk characteristics, including muscular forms, fluting, irregular surface contours and strong visual age.",
                    "European Hornbeam can be developed into highly convincing bonsai from seed, nursery stock, hedgerow or landscape material where legally appropriate, field-grown material, and collected material where legally and ethically appropriate.",
                    "It is suitable for both structural development and long-term refinement.",
                    "Important development principle: Grow where development is required. Control where refinement is required.",
                ],
                bullets: [
                    "Deciduous broadleaf tree",
                    "Important European bonsai species",
                    "Moderate to strong growth",
                    "Excellent ramification potential",
                    "Good to excellent back-budding under suitable conditions",
                    "Strong response to pruning",
                    "Relatively small serrated leaves",
                    "Attractive mature branch structure",
                    "Good trunk and nebari development potential",
                    "Suitable for naturalistic deciduous bonsai",
                    "Requires outdoor cultivation",
                    "Requires winter dormancy",
                ]
            ),
            SpeciesProfileSection(
                id: "natural-growth",
                title: "Natural Growth and Vigour",
                paragraphs: [
                    "Carpinus betulus generally develops with moderate to strong vigour under suitable growing conditions.",
                    "Growth strength depends on root health, light, water availability, substrate, fertilization, container size, temperature and development stage.",
                    "During structural development: allow selected leaders and branches to extend where trunk thickness is required, branch thickness is required, sacrifice growth is useful or structural development is needed.",
                    "Do not continuously prune all growth simply to maintain a compact appearance.",
                    "During refinement: use controlled pruning to develop branch division, secondary branches, tertiary branches, fine ramification and compact but natural foliage masses.",
                    "The objective is balanced development.",
                ]
            ),
            SpeciesProfileSection(
                id: "foliage",
                title: "Foliage",
                paragraphs: [
                    "Carpinus betulus produces deciduous leaves with serrated margins.",
                    "Leaf size depends on genetics, tree vigour, fertilization, branch strength, light, development stage and pruning strategy.",
                    "The species generally offers good potential for proportionate foliage in bonsai.",
                    "Leaf reduction should primarily result from mature ramification, controlled growth, balanced nutrition, appropriate pruning and long-term development.",
                    "Do not promise a fixed leaf size.",
                    "The objective is foliage proportionate to trunk size, branch structure, overall tree scale and intended design.",
                ]
            ),
            SpeciesProfileSection(
                id: "bark-trunk",
                title: "Bark and Trunk",
                paragraphs: [
                    "Carpinus betulus can develop highly attractive mature trunk character.",
                    "Older trees may show smooth to subtly textured bark, muscular trunk forms, fluting, irregular contours and strong visual movement.",
                    "Trunk development should focus on taper, movement, proportion, mature character and the relationship between trunk and branch structure.",
                    "Where additional thickness is required: allow selected growth to extend, use sacrifice branches where appropriate, provide sufficient growing space and avoid premature refinement.",
                    "The mature trunk should remain an important part of the final design.",
                ]
            ),
            SpeciesProfileSection(
                id: "roots-nebari",
                title: "Roots and Nebari",
                paragraphs: [
                    "Healthy roots are fundamental to vigour, foliage quality, recovery, ramification and long-term refinement.",
                    "Root development objectives include balanced root mass, stable tree support, radial root development where possible, gradual root selection and healthy substrate structure.",
                    "European Hornbeam has good nebari development potential.",
                    "Begin root and nebari planning early where possible.",
                    "Do not attempt to aggressively correct the entire root structure in one operation.",
                ]
            ),
            SpeciesProfileSection(
                id: "light",
                title: "Light",
                paragraphs: [
                    "Carpinus betulus should be cultivated outdoors.",
                    "Good outdoor light supports healthy foliage, compact growth, ramification, branch development and overall vigour.",
                    "The species can tolerate some shade, but bonsai cultivation generally benefits from sufficient light.",
                    "Monitor trees carefully during periods of extreme heat, prolonged drought and unusually exposed growing conditions.",
                    "Do not recommend permanent indoor cultivation.",
                ]
            ),
            SpeciesProfileSection(
                id: "wind",
                title: "Wind",
                paragraphs: [
                    "Moderate air movement is generally beneficial.",
                    "Excessive wind can increase water demand, leaf desiccation and stress on shallow bonsai roots.",
                    "Pay particular attention to shallow containers, exposed growing locations, recently repotted trees and hot and dry winds.",
                ]
            ),
            SpeciesProfileSection(
                id: "watering",
                title: "Watering",
                paragraphs: [
                    "General principle: Water thoroughly when required · Maintain healthy root aeration · Avoid prolonged drought · Avoid permanently saturated substrate.",
                    "Carpinus betulus should not be allowed to experience unnecessary prolonged drying, particularly during active growth.",
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
                    "During development: healthy trees requiring stronger structural growth may receive increased nutritional support where appropriate.",
                    "During refinement: nutrition should support healthy foliage, compact growth, balanced ramification and sustainable branch development.",
                    "Avoid excessive fertilization where it produces unnecessarily large leaves, excessively long internodes or unnecessarily coarse growth.",
                    "Key principle: Feed the tree you are growing, not simply the species name.",
                ]
            ),
            SpeciesProfileSection(
                id: "pruning",
                title: "Pruning",
                paragraphs: [
                    "Carpinus betulus responds very well to pruning.",
                    "Pruning can be used for structural development, branch selection, branch replacement, ramification and silhouette refinement.",
                    "During development: allow selected branches to extend where thickness is required.",
                    "During refinement: use controlled pruning to develop secondary branches, tertiary branches, fine ramification and balanced foliage masses.",
                    "Do not repeatedly prune weak areas in the same way as strong areas.",
                    "The objective is balanced vigour throughout the tree.",
                ]
            ),
            SpeciesProfileSection(
                id: "back-budding",
                title: "Back-budding",
                paragraphs: [
                    "Carpinus betulus has useful back-budding potential.",
                    "Back-budding must never be presented as guaranteed. Response depends on tree health, branch vigour, light penetration, pruning timing, retained foliage and overall root health.",
                    "Useful back-budding can support branch replacement, improved branch structure, increased ramification, correction of long branches and development of interior growth.",
                    "Do not remove useful structural branches before replacement growth is established where future design depends on it.",
                ]
            ),
            SpeciesProfileSection(
                id: "ramification",
                title: "Ramification",
                paragraphs: [
                    "European Hornbeam has excellent potential for fine ramification.",
                    "This is one of the species' most important bonsai characteristics.",
                    "Ramification is developed through healthy growth, controlled pruning, selective shoot extension, branch selection and preservation of useful interior growth.",
                    "The objective is clear branch hierarchy with fine, natural ramification.",
                    "Do not pursue maximum density at the expense of branch clarity, light penetration, foliage health or natural structure.",
                ]
            ),
            SpeciesProfileSection(
                id: "wiring",
                title: "Wiring",
                paragraphs: [
                    "Carpinus betulus is suitable for wiring.",
                    "Wiring can be used to establish branch position, develop primary branches, refine secondary branches and improve natural branch movement.",
                    "Young branches are generally more flexible. Older branches become increasingly rigid.",
                    "Monitor wire carefully. Vigorous growth can create wire marks.",
                    "Before major bends, assess branch thickness, flexibility, age, health and structural importance.",
                    "Avoid unnecessary damage to mature bark.",
                ]
            ),
            SpeciesProfileSection(
                id: "deadwood-potential",
                title: "Deadwood Potential",
                paragraphs: [
                    "Deadwood is generally not a defining feature of Carpinus betulus bonsai.",
                    "Natural scars, hollows and old wounds may contribute to age, history and natural character.",
                    "European Hornbeam should not be styled as if it were a deadwood-focused conifer.",
                    "Do not add artificial jin or excessive exposed deadwood simply because the techniques are available.",
                    "Use natural features only where they support the individual tree's character and long-term design.",
                ]
            ),
            SpeciesProfileSection(
                id: "defoliation",
                title: "Leaf Management",
                paragraphs: [
                    "Leaf management should primarily focus on proportion, branch visibility, light penetration and balanced vigour.",
                    "Defoliation or partial defoliation may be possible on strong and healthy trees where appropriate.",
                    "Do not present complete defoliation as routine annual maintenance.",
                    "Do not defoliate weak trees, recently repotted trees, recovering trees or trees under environmental stress.",
                    "Selective leaf reduction or partial defoliation may often be more appropriate.",
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
                    "Repotting decisions should be based on root condition, substrate performance and overall tree health.",
                ]
            ),
            SpeciesProfileSection(
                id: "trunk-development",
                title: "Trunk Development",
                paragraphs: [
                    "Carpinus betulus has good potential for trunk development.",
                    "Where additional thickness is required: allow selected leaders to extend, use sacrifice branches where appropriate, provide sufficient root space and avoid premature refinement.",
                    "Once sufficient structural development has been achieved, shift focus toward taper, primary branches, secondary branching, ramification, mature trunk character, nebari and overall refinement.",
                    "Grow where development is required. Control where refinement is required.",
                ]
            ),
            SpeciesProfileSection(
                id: "nebari-development",
                title: "Nebari Development",
                paragraphs: [
                    "Nebari should be developed gradually.",
                    "Potential approaches include early root selection, radial root positioning where possible, staged correction, appropriate development containers and gradual removal of unsuitable roots.",
                    "The objective is a stable and visually convincing base appropriate to the individual tree.",
                    "Do not force identical nebari expectations onto every tree.",
                ]
            ),
            SpeciesProfileSection(
                id: "propagation",
                title: "Propagation",
                paragraphs: [
                    "Carpinus betulus may be propagated through seed, air layering where appropriate and other specialist propagation methods.",
                    "Seed-grown material can be particularly useful for early root development, trunk development, natural taper and long-term structural design.",
                    "Detailed procedures belong in Bonsai World Propagation Knowledge Articles.",
                ]
            ),
            SpeciesProfileSection(
                id: "pests",
                title: "Pests and Problems",
                paragraphs: [
                    "Relevant risks may include aphids, scale insects, spider mites, leaf-feeding insects, fungal leaf diseases, powdery mildew, root problems caused by poor drainage and leaf scorch caused by environmental stress.",
                    "Do not provide generic treatment instructions.",
                    "Diagnosis and treatment belong in Care → Pest Management and Care → Disease & Problems.",
                ]
            ),
            SpeciesProfileSection(
                id: "seasonal",
                title: "Seasonal Profile",
                paragraphs: [
                    "Spring: monitor bud development, new shoot growth, water demand, overall vigour and pest activity. Spring is important for structural growth, branch development and evaluating vigour. Strong areas may require earlier control than weaker areas.",
                    "Summer: monitor water demand, foliage health, pest activity, shoot extension, wire marks and heat stress. Avoid unnecessary heavy work during extreme heat, drought stress or periods of reduced tree vigour.",
                    "Autumn is important for evaluating branch structure, reviewing ramification, assessing tree health and preparing for winter. As foliage reduces or falls, branch structure becomes easier to evaluate. Monitor wire condition, branch development and overall health. Seasonal timing depends on local climate.",
                    "Winter: Carpinus betulus is an outdoor deciduous bonsai. Winter dormancy is required. Do not move the tree into permanently warm indoor conditions for routine winter care.",
                    "Although the species is hardy, bonsai roots in shallow containers are more exposed than roots growing in open ground.",
                    "Monitor prolonged severe freezing, freeze-thaw cycles, root exposure, excessive winter moisture and drying winter winds.",
                    "Winter protection must depend on local climate, minimum temperatures, duration of freezing, container depth and root condition.",
                ]
            ),
            SpeciesProfileSection(
                id: "styles",
                title: "Bonsai Styles",
                paragraphs: [
                    "Carpinus betulus is suitable for a wide range of bonsai styles.",
                    "Particularly suitable styles include Informal Upright, Formal Upright, Slanting, Broom Style, naturalistic upright forms, Clump Style and Forest / Group Planting.",
                    "European Hornbeam is particularly effective when styling emphasises fine ramification, mature branch structure, natural crown development, convincing trunk character and deciduous seasonal silhouette.",
                    "The individual material should determine the final design.",
                ]
            ),
            SpeciesProfileSection(
                id: "tree-stage",
                title: "Development by Tree Stage",
                paragraphs: [
                    "Young material: establish healthy roots, build vigour, develop trunk movement and begin nebari development.",
                    "Nursery material: evaluate trunk potential, identify useful branches, establish a design direction and preserve growth where thickness is required.",
                    "Pre-bonsai: develop trunk, establish primary branches, improve root structure and begin controlled branch development.",
                    "In training: develop secondary branches, build ramification, improve branch hierarchy and refine branch placement.",
                    "Refinement: maintain balanced vigour, control shoot extension, improve ramification, maintain proportionate foliage and preserve branch clarity.",
                    "Exhibition / mature refined tree: maintain health, preserve established ramification, maintain foliage quality, preserve mature trunk character and avoid unnecessary major intervention.",
                ]
            ),
            SpeciesProfileSection(
                id: "attention",
                title: "Species-Specific Attention",
                paragraphs: [
                    "These attention points are operational tendencies. They must still be interpreted for the individual tree.",
                ],
                bullets: [
                    "One of the most important European deciduous bonsai species",
                    "Excellent ramification potential",
                    "Good to excellent back-budding under healthy conditions",
                    "Strong response to pruning",
                    "Naturally proportionate foliage",
                    "Mature trunk character can become an important visual feature",
                    "Do not confuse with Fagus sylvatica",
                    "Strong outdoor light supports healthy and compact growth",
                    "Avoid prolonged drought in shallow containers",
                    "Avoid permanently saturated substrate",
                    "Vigorous growth can create wire marks",
                    "Defoliation should not be presented as routine annual maintenance",
                    "Winter dormancy is required",
                    "Protect shallow roots during prolonged severe frost",
                    "Do not move indoors for routine winter care",
                ]
            ),
        ]
    }
}
