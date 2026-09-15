//
//  QuercusRoburSpeciesProfile.swift
//  Bonsai World
//
//  Species Profile — Quercus robur (English Oak).
//  Independent botanical species in Fagaceae. Knowledge status: Reviewed.
//  Separate from Quercus petraea and other Quercus species.
//

import Foundation

enum QuercusRoburSpeciesProfile {
    /// Identity used by Botanical Library / ``SpeciesPreviewData``.
    static let botanicalLibraryName = "Quercus robur"
    /// Scientific name for Species Profile display (binomial; no botanical authority).
    static let scientificName = "Quercus robur"

    static var profile: SpeciesProfile {
        SpeciesProfile(
            speciesID: BotanicalKnowledgeIDs.quercusRobur,
            scientificName: scientificName,
            commonNames: ["English Oak", "Pedunculate Oak"],
            family: "Fagaceae",
            plantType: "Deciduous broadleaf tree",
            originSummary: "Europe and western Asia.",
            knowledgeStatus: .reviewed,
            traits: traits,
            foliageSizeLabel: "Foliage",
            foliageReductionLabel: "Leaf reduction",
            summaryLine: "Deciduous · Strong trunk character · Excellent mature tree appearance · Large leaf potential · Good back-budding under suitable conditions · Strong structural development · Rugged bark · Long-lived · Excellent naturalistic bonsai potential",
            attentionHighlights: [
                "One of Europe's defining oak species",
                "Excellent potential for mature naturalistic bonsai",
                "Leaf size must be considered when selecting final bonsai scale",
                "Often particularly convincing as medium or large bonsai",
                "Strong trunk development potential",
                "Excellent mature bark character",
                "Good back-budding under healthy conditions",
                "Back-budding is not guaranteed",
                "Strong growth should be used strategically for development",
                "Do not prune every part of the tree equally",
                "Preserve useful interior growth",
                "Do not force artificial foliage-pad styling that hides oak character",
                "Good potential for nebari development",
                "Avoid prolonged drought",
                "Avoid permanently saturated substrate",
                "Young branches are more suitable for wiring",
                "Older branches may become rigid and difficult to bend",
                "Advanced defoliation is optional, not routine",
                "Winter dormancy is required",
                "Shallow bonsai roots are more exposed than roots in open ground",
                "Do not move indoors for routine winter care",
            ],
            sections: sections,
            principleNote: """
            Quercus robur is one of Europe's defining broadleaf trees and has exceptional potential for bonsai.

            Its greatest strength is not necessarily immediate refinement. Its greatest strength is its ability to develop powerful trunks, convincing bark, broad branch structures, ancient character, natural taper, strong nebari and rugged silhouettes.

            English Oak is particularly effective when the bonsai design communicates age, strength, weather exposure, permanence and natural European landscape character.

            Leaf size can be a challenge for small bonsai. Therefore, the species is often especially convincing in medium bonsai, large bonsai, naturalistic designs and powerful old-tree compositions.

            Do not force Quercus robur into proportions that are unsuitable for the material.

            The individual tree must always be assessed according to health, vigour, root condition, leaf size, development stage, trunk size, branch strength, climate, seasonal conditions and recent work.

            The objective is: Healthy roots · Powerful structure · Good branch hierarchy · Convincing proportions · Mature oak character
            """,
            sourcesNote: """
            Profile content is synthesised from recognised botanical, horticultural and bonsai authorities into Bonsai World editorial language.

            Botanical taxonomy and distribution draw on recognised sources such as Royal Botanic Gardens, Kew and other botanical databases for accepted scientific name, family and native range.

            Horticultural and forest context may draw on recognised European botanical gardens, arboreta, forestry institutions and established oak research and conservation organisations.

            Bonsai-specific cultivation and refinement knowledge draws on established bonsai references and recognised professional practice for Quercus species, kept distinct from Quercus petraea and other oaks.

            Verified botanical information, general horticultural cultivation and bonsai-specific practice are kept distinct. Do not copy source wording.
            """
        )
    }

    private static let traits = SpeciesProfileTraits(
        deciduous: true,
        growthStrength: "Moderate to Strong",
        growthSpeed: "Moderate",
        leafSize: "Deciduous · Lobed leaves",
        foliageReduction: "Possible only as an advanced technique on strong, healthy trees and not required for routine management",
        ramificationPotential: "Good",
        backBudding: "Good under healthy conditions and correct pruning management",
        rootDevelopment: "Good",
        nebariPotential: "Excellent potential over time",
        trunkDevelopment: "Strong",
        barkDevelopment: "Rugged mature bark",
        wiring: "Good when branches are young",
        defoliation: "Possible only as an advanced technique on strong, healthy trees and not required for routine management",
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
                    "Quercus robur is an independent botanical species in the beech family (Fagaceae).",
                    "Primary Bonsai World display identity: Quercus robur · English Oak.",
                    "Pedunculate Oak may be used as an alternative common name. It does not replace English Oak as the primary common name.",
                    "European oak may be used as supporting descriptive terminology for landscape character. It does not replace the species identity Quercus robur.",
                    "Family: Fagaceae. Plant type: deciduous broadleaf tree.",
                    "Native range: Europe and western Asia.",
                    "Maintain a clear distinction between Quercus robur, Quercus petraea, Quercus ilex, Quercus suber, other Quercus species, and naturally occurring hybrids.",
                    "Quercus robur and Quercus petraea may occur in overlapping natural ranges and can hybridise. Do not treat them as interchangeable.",
                    "Bonsai World hierarchy: Species → cultivar / horticultural selection → Individual Tree.",
                ]
            ),
            SpeciesProfileSection(
                id: "overview",
                title: "Species Overview",
                paragraphs: [
                    "Quercus robur is a large deciduous tree native across much of Europe and extending into western Asia.",
                    "It is one of the most recognisable trees in the European landscape.",
                    "Mature trees can develop massive trunks, deeply textured bark, broad crowns, powerful primary branches, extensive root systems and great longevity.",
                    "These characteristics make English Oak highly suitable for bonsai.",
                    "The species is particularly valuable for bonsai artists seeking to create convincing miniature representations of ancient European oaks, open-grown landscape trees, parkland trees, woodland-edge trees and weathered old trees.",
                    "The strongest bonsai results usually come from respecting the naturally powerful character of the species.",
                    "Do not attempt to make every Quercus robur into a delicate or highly compact miniature. The design should reflect the tree.",
                ],
                bullets: [
                    "Deciduous European broadleaf tree",
                    "Iconic oak species",
                    "Strong trunk development potential",
                    "Excellent mature bark character",
                    "Good branch development potential",
                    "Good back-budding under healthy conditions",
                    "Moderate to strong growth",
                    "Lobed deciduous leaves",
                    "Leaf size requires careful scale consideration",
                    "Excellent naturalistic old-tree potential",
                    "Strong nebari development potential",
                    "Long-lived species",
                    "Requires outdoor cultivation",
                    "Requires winter dormancy",
                ]
            ),
            SpeciesProfileSection(
                id: "natural-growth",
                title: "Natural Growth and Vigour",
                paragraphs: [
                    "Quercus robur generally grows with moderate to strong vigour under favourable conditions.",
                    "Growth strength depends on root health, light, available growing space, substrate, water availability, fertilization, climate and development stage.",
                    "During structural development: allow selected growth to extend where trunk thickness is required, branch thickness is required, taper is being developed or sacrifice growth is useful.",
                    "Oak development often requires patience. Major trunk and branch character should not be rushed through constant pruning.",
                    "During refinement: control shoot extension, internode length, branch density and vigour distribution.",
                    "The objective is: Strong structure first · Refinement later.",
                ]
            ),
            SpeciesProfileSection(
                id: "foliage",
                title: "Foliage and Leaves",
                paragraphs: [
                    "Quercus robur produces distinctive deciduous leaves with characteristic lobes.",
                    "Leaf size varies depending on vigour, tree age, fertilization, water availability, pruning and development stage.",
                    "Leaf size can limit the suitability of Quercus robur for very small bonsai.",
                    "Do not promise that leaf reduction will make the species suitable for every bonsai size.",
                    "The objective is foliage proportionate to the tree's trunk, branch structure and overall design.",
                    "Medium and larger bonsai often provide the most convincing proportions.",
                ]
            ),
            SpeciesProfileSection(
                id: "bark-trunk",
                title: "Bark and Trunk",
                paragraphs: [
                    "Mature bark and trunk character are among the greatest strengths of Quercus robur.",
                    "Older trees can develop deeply textured bark, powerful trunks, strong taper, natural hollows, scars, cavities and weathered surfaces.",
                    "Trunk development should focus on taper, proportion, branch relationship, mature bark development and natural movement.",
                    "The objective is convincing age.",
                    "Artificial exaggeration should be avoided where it conflicts with the character of the material.",
                ]
            ),
            SpeciesProfileSection(
                id: "roots-nebari",
                title: "Roots and Nebari",
                paragraphs: [
                    "Quercus robur has excellent long-term potential for nebari development.",
                    "Healthy roots are fundamental to vigour, trunk development, branch development, recovery and long-term health.",
                    "Root development objectives include balanced radial roots, stable tree support, gradual removal of unsuitable roots, healthy substrate and sustainable root density.",
                    "Nebari development should be gradual. Young material offers the best opportunity for early root planning. Older material may require staged correction over multiple repotting cycles.",
                    "Do not attempt to completely redesign an old root system in one operation.",
                ]
            ),
            SpeciesProfileSection(
                id: "light",
                title: "Light",
                paragraphs: [
                    "Quercus robur should be cultivated outdoors.",
                    "Strong outdoor light supports healthy foliage, strong growth, compact development, trunk development and branch vigour.",
                    "The exact position depends on local climate, temperature, tree condition and development stage.",
                    "During extreme summer conditions, monitor water demand, leaf stress and root-zone temperature.",
                    "Do not recommend permanent indoor cultivation.",
                ]
            ),
            SpeciesProfileSection(
                id: "wind",
                title: "Wind",
                paragraphs: [
                    "Moderate air movement is generally beneficial.",
                    "Strong and persistent wind can increase water demand, leaf stress and drying of shallow bonsai containers.",
                    "Pay particular attention to recently repotted trees, trees recovering from major work, shallow containers and unusually hot and dry weather.",
                ]
            ),
            SpeciesProfileSection(
                id: "watering",
                title: "Watering",
                paragraphs: [
                    "General principle: Water thoroughly when required · Maintain healthy root aeration · Avoid prolonged drought · Avoid permanently saturated substrate.",
                    "Quercus robur can require significant water during active growth.",
                    "Watering frequency depends on temperature, sunlight, wind, foliage mass, container size, substrate, root mass and development stage.",
                    "Do not water according to a fixed timetable.",
                    "Water according to substrate condition, weather and the individual tree.",
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
                    "During structural development: healthy trees requiring strong growth may receive increased nutritional support where appropriate.",
                    "During refinement: nutrition should support healthy foliage, controlled shoot extension, branch development and sustainable ramification.",
                    "Avoid excessive fertilization where it produces unnecessarily large leaves, excessively coarse growth or disproportionate shoot extension.",
                    "Key principle: Feed the tree according to its development objective.",
                ]
            ),
            SpeciesProfileSection(
                id: "pruning",
                title: "Pruning",
                paragraphs: [
                    "Quercus robur responds well to thoughtful pruning.",
                    "Pruning can be used for structural development, branch selection, branch replacement, ramification and silhouette refinement.",
                    "During structural development: allow selected leaders and sacrifice branches to grow where thickness is required.",
                    "During refinement: use controlled pruning to develop secondary branching, tertiary branching and balanced branch density.",
                    "Do not repeatedly prune weak areas as aggressively as strong areas.",
                    "The objective is balanced vigour.",
                ]
            ),
            SpeciesProfileSection(
                id: "back-budding",
                title: "Back-budding",
                paragraphs: [
                    "Quercus robur can produce useful new growth from older branches and wood.",
                    "This can support branch replacement, structural correction, improved branch distribution and ramification development.",
                    "Back-budding must not be treated as guaranteed. Response depends on tree health, vigour, branch age, light, pruning strategy and root condition.",
                    "Avoid removing branches or growth without considering where replacement growth is expected to develop.",
                    "The objective is to preserve future options.",
                ]
            ),
            SpeciesProfileSection(
                id: "ramification",
                title: "Ramification",
                paragraphs: [
                    "Quercus robur has good potential for ramification.",
                    "Ramification develops through healthy growth, controlled pruning, shoot selection, branch selection and balanced vigour.",
                    "The objective is not maximum density. The objective is a convincing mature oak branch structure.",
                    "Oak bonsai should retain clear branch hierarchy, appropriate branch strength, visible structural movement and natural spacing.",
                    "Avoid creating foliage pads that remove the natural identity of the species.",
                ]
            ),
            SpeciesProfileSection(
                id: "wiring",
                title: "Wiring",
                paragraphs: [
                    "Quercus robur is suitable for wiring, particularly while branches are young.",
                    "Wiring can be used to establish primary branch placement, position secondary branches, improve branch movement and refine branch structure.",
                    "Older oak branches become rigid. Do not force major bends in brittle or mature branches.",
                    "Before major bends, assess branch thickness, flexibility, age, health and structural importance.",
                    "Monitor wire carefully during periods of strong growth.",
                ]
            ),
            SpeciesProfileSection(
                id: "deadwood-potential",
                title: "Deadwood Potential",
                paragraphs: [
                    "Deadwood is not the defining styling language of Quercus robur bonsai.",
                    "Natural hollows, scars, cavities and weathered surfaces may contribute to age and European landscape character where they already exist.",
                    "Do not add artificial jin or excessive exposed deadwood simply because the techniques are available.",
                    "Use natural features only where they support the individual tree's character and long-term design.",
                ]
            ),
            SpeciesProfileSection(
                id: "defoliation",
                title: "Defoliation and Leaf Management",
                paragraphs: [
                    "Partial or complete leaf reduction techniques may be used in specific refinement situations.",
                    "Do not present defoliation as routine maintenance.",
                    "Do not defoliate weak trees, recently repotted trees, stressed trees or trees recovering from major work.",
                    "Leaf reduction techniques should not be used simply because the species has large leaves.",
                    "The objective is: Healthy growth · Improved refinement · Appropriate scale.",
                    "The individual tree's condition must determine whether advanced techniques are appropriate.",
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
                    "Quercus robur has strong long-term trunk development potential.",
                    "Where additional thickness is required: allow selected leaders to extend, use sacrifice branches where appropriate, provide sufficient root space and avoid premature refinement.",
                    "Oak trunk development rewards patience.",
                    "Once sufficient structural development has been achieved, shift focus toward taper, branch hierarchy, ramification, bark development and overall proportion.",
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
                    "Strong nebari is particularly important for expressing the visual weight and maturity associated with old oaks.",
                ]
            ),
            SpeciesProfileSection(
                id: "propagation",
                title: "Propagation",
                paragraphs: [
                    "Quercus robur may be propagated through seed, layering in appropriate situations and other specialist horticultural propagation methods.",
                    "Seed-grown material is particularly valuable for early root planning, nebari development, trunk development and long-term structural design.",
                    "Acorns should be sourced responsibly.",
                    "Detailed procedures belong in Bonsai World Propagation Knowledge Articles.",
                ]
            ),
            SpeciesProfileSection(
                id: "pests",
                title: "Pests and Problems",
                paragraphs: [
                    "Relevant risks may include aphids, scale insects, leaf-feeding insects, powdery mildew, fungal leaf diseases, root problems caused by poor drainage and environmental stress.",
                    "Do not provide generic treatment instructions.",
                    "Diagnosis and treatment belong in Care → Pest Management and Care → Disease & Problems.",
                ]
            ),
            SpeciesProfileSection(
                id: "seasonal",
                title: "Seasonal Profile",
                paragraphs: [
                    "Spring: monitor bud development, new shoot growth, overall vigour, water demand and pest activity. Spring is important for evaluating branch strength, structural development, seasonal planning and root work where appropriate. Strong and weak areas may require different management.",
                    "Summer: monitor water demand, leaf health, pest activity, excessive shoot extension, wire marks and heat stress. Strong growth can be used strategically for development. During refinement, manage excessive extension to maintain branch structure, proportion and ramification. Avoid unnecessary heavy work during extreme heat or drought stress.",
                    "Autumn is important for evaluating branch structure, reviewing overall vigour, assessing ramification and preparing for winter. As leaves begin to fall, the branch structure becomes increasingly visible. This is an important period for evaluating branch hierarchy, silhouette, structural development and future design decisions. Seasonal timing depends on local climate.",
                    "Winter: Quercus robur is an outdoor deciduous tree. Winter dormancy is required. Do not move the tree into permanently warm indoor conditions.",
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
                    "Quercus robur is particularly suitable for naturalistic and mature tree styles.",
                    "Particularly suitable expressions include Informal Upright, Formal Upright where material supports it, Slanting, Clump Style, Multi-trunk Style, Forest / Group Planting and Naturalistic Old Tree Style.",
                    "English Oak is especially effective when styling emphasises powerful trunk bases, broad crowns, strong primary branches, natural asymmetry, mature bark and convincing age.",
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
                    "In training: develop secondary branches, improve branch hierarchy, build sustainable ramification and manage foliage proportion.",
                    "Refinement: maintain balanced vigour, improve tertiary ramification, control shoot extension, maintain foliage proportion and preserve clear oak branch structure.",
                    "Exhibition / mature refined tree: maintain health, preserve established structure, maintain mature bark, maintain branch hierarchy and avoid unnecessary major intervention.",
                ]
            ),
            SpeciesProfileSection(
                id: "attention",
                title: "Species-Specific Attention",
                paragraphs: [
                    "These attention points are operational tendencies. They must still be interpreted for the individual tree.",
                ],
                bullets: [
                    "One of Europe's defining oak species",
                    "Excellent potential for mature naturalistic bonsai",
                    "Leaf size must be considered when selecting final bonsai scale",
                    "Often particularly convincing as medium or large bonsai",
                    "Strong trunk development potential",
                    "Excellent mature bark character",
                    "Good back-budding under healthy conditions",
                    "Back-budding is not guaranteed",
                    "Strong growth should be used strategically for development",
                    "Do not prune every part of the tree equally",
                    "Preserve useful interior growth",
                    "Do not force artificial foliage-pad styling that hides oak character",
                    "Good potential for nebari development",
                    "Avoid prolonged drought",
                    "Avoid permanently saturated substrate",
                    "Young branches are more suitable for wiring",
                    "Older branches may become rigid and difficult to bend",
                    "Advanced defoliation is optional, not routine",
                    "Winter dormancy is required",
                    "Shallow bonsai roots are more exposed than roots in open ground",
                    "Do not move indoors for routine winter care",
                ]
            ),
        ]
    }
}
