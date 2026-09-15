//
//  UlmusMinorSpeciesProfile.swift
//  Bonsai World
//
//  Species Profile — Ulmus minor (Field Elm).
//  Independent botanical species in Ulmaceae. Knowledge status: Reviewed.
//  Separate from Ulmus parvifolia and other Ulmus species.
//

import Foundation

enum UlmusMinorSpeciesProfile {
    /// Identity used by Botanical Library / ``SpeciesPreviewData``.
    static let botanicalLibraryName = "Ulmus minor"
    /// Scientific name for Species Profile display (binomial; no botanical authority).
    static let scientificName = "Ulmus minor"

    static var profile: SpeciesProfile {
        SpeciesProfile(
            speciesID: BotanicalKnowledgeIDs.ulmusMinor,
            scientificName: scientificName,
            commonNames: ["Field Elm", "European Field Elm"],
            family: "Ulmaceae",
            plantType: "Deciduous broadleaf tree",
            originSummary: "Europe, western Asia and parts of North Africa.",
            knowledgeStatus: .reviewed,
            traits: traits,
            foliageSizeLabel: "Foliage",
            foliageReductionLabel: "Leaf reduction",
            summaryLine: "Deciduous · Small leaves · Excellent ramification potential · Strong pruning response · Good back-budding potential · Fast growth when vigorous · Mature bark · Strong European bonsai character",
            attentionHighlights: [
                "Important European elm species for bonsai",
                "Do not confuse with Ulmus parvifolia",
                "Strong growth can support rapid development",
                "Excellent ramification potential",
                "Good to excellent back-budding potential under healthy conditions",
                "Excellent response to pruning",
                "Preserve useful interior growth",
                "Strong areas and weak areas should not always be pruned equally",
                "Leaf size and internode length depend strongly on vigour and development stage",
                "Advanced defoliation techniques are optional and only suitable for strong, healthy trees",
                "Mature bark is an important aesthetic characteristic",
                "Good potential for nebari development",
                "Water demand can increase significantly during active growth",
                "Avoid prolonged drought",
                "Avoid permanently saturated substrate",
                "Monitor wire carefully during strong growth",
                "Winter dormancy is required",
                "Shallow bonsai roots are more exposed than roots in open ground",
                "Serious elm diseases should be recognised as a species-relevant risk",
                "Do not move indoors for routine winter care",
            ],
            sections: sections,
            principleNote: """
            Ulmus minor is one of the most valuable European broadleaf species for bonsai.

            It is particularly valued for naturally small leaves, strong ramification potential, vigorous growth, good response to pruning, ability to develop convincing mature branch structure, attractive mature bark and excellent European naturalistic character.

            Field Elm is especially suitable for developing bonsai with broad spreading crowns, mature deciduous silhouettes, strong branch hierarchy, dense fine ramification, and aged bark and trunk character.

            The species responds well to development, but strong growth can create problems if not managed. Allow unrestricted growth where development is required. Prune selectively where refinement is required. Do not attempt to maintain every part of the tree at refinement level during the structural development phase.

            The individual tree must always be assessed according to health, vigour, root condition, development stage, branch strength, climate, seasonal conditions and recent work.

            The objective is: Healthy roots · Strong growth · Good branch structure · Fine ramification · Convincing mature character
            """,
            sourcesNote: """
            Profile content is synthesised from recognised botanical, horticultural and bonsai authorities into Bonsai World editorial language.

            Botanical taxonomy and distribution draw on recognised sources such as Royal Botanic Gardens, Kew and other botanical databases for accepted scientific name, family and native range.

            Horticultural and forest context may draw on recognised European botanical gardens, arboreta, forestry institutions and elm conservation and research institutions.

            Bonsai-specific cultivation and refinement knowledge draws on established bonsai references and recognised professional practice for Ulmus species, kept distinct from Ulmus parvifolia.

            Verified botanical information, general horticultural cultivation and bonsai-specific practice are kept distinct. Do not copy source wording.
            """
        )
    }

    private static let traits = SpeciesProfileTraits(
        deciduous: true,
        growthStrength: "Strong",
        growthSpeed: "Moderate to Fast",
        leafSize: "Deciduous · Small to medium leaves · Serrated margins",
        foliageReduction: "Possible as an advanced refinement technique on strong, healthy trees",
        ramificationPotential: "Excellent",
        backBudding: "Good to Excellent under healthy conditions",
        rootDevelopment: "Good",
        nebariPotential: "Good development potential",
        trunkDevelopment: "Moderate to Fast",
        barkDevelopment: "Mature bark develops strong character",
        wiring: "Good suitability",
        defoliation: "Possible as an advanced refinement technique on strong, healthy trees",
        airLayering: "Where appropriate for the individual material",
        threadGrafting: "Where structural correction is required",
        rootGrafting: "Where appropriate",
        beginnerSuitability: "Good",
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
                    "Ulmus minor is an independent botanical species in the elm family (Ulmaceae).",
                    "Primary Bonsai World display identity: Ulmus minor · Field Elm.",
                    "European Field Elm may be used as an alternative common name. It does not replace Field Elm as the primary common name.",
                    "Family: Ulmaceae. Plant type: deciduous broadleaf tree.",
                    "Native range: Europe, western Asia and parts of North Africa.",
                    "Maintain a clear distinction between Ulmus minor, Ulmus parvifolia, Ulmus glabra, Ulmus laevis, other Ulmus species, and horticultural hybrids and cultivars.",
                    "Do not treat Ulmus minor as interchangeable with Ulmus parvifolia. They are different species with different natural distributions, growth characteristics and bonsai identities.",
                    "Do not confuse Ulmus minor with commercially labelled Chinese Elm material.",
                    "Bonsai World hierarchy: Species → cultivar / horticultural selection → Individual Tree.",
                ]
            ),
            SpeciesProfileSection(
                id: "overview",
                title: "Species Overview",
                paragraphs: [
                    "Ulmus minor is a deciduous elm native across much of Europe and extending into western Asia and parts of North Africa.",
                    "The species is associated with a wide range of European landscapes and can develop into a large tree with spreading branches, strong trunk structure, mature bark, broad crowns and fine branch networks.",
                    "For bonsai, Field Elm is especially valuable because it combines relatively small foliage, vigorous growth, strong pruning response, good ramification potential and convincing mature proportions.",
                    "The species can be developed from seed, nursery material, field-grown material, collected material where legal and appropriate, and old landscape material where legally and ethically appropriate.",
                    "Field Elm is particularly suitable for bonsai that aim to express mature European deciduous trees, broad crowns, ancient hedgerow character, rugged natural trunks and dense winter silhouettes.",
                ],
                bullets: [
                    "Deciduous European broadleaf tree",
                    "Strong growth when healthy",
                    "Good trunk development potential",
                    "Small to medium serrated leaves",
                    "Excellent ramification potential",
                    "Good to excellent back-budding potential",
                    "Excellent response to pruning",
                    "Good nebari development potential",
                    "Mature bark develops strong character",
                    "Suitable for a wide range of deciduous bonsai styles",
                    "Requires outdoor cultivation",
                    "Requires winter dormancy",
                ]
            ),
            SpeciesProfileSection(
                id: "natural-growth",
                title: "Natural Growth and Vigour",
                paragraphs: [
                    "Ulmus minor can grow strongly under favourable conditions.",
                    "Growth strength depends on root health, light, available growing space, substrate, water availability, fertilization, climate and development stage.",
                    "During structural development: allow selected leaders and branches to extend where trunk thickness is required, branch thickness is required, taper is being developed or sacrifice growth is useful.",
                    "During refinement: control shoot length, internode development, branch density and vigour distribution.",
                    "Strong growth must be managed strategically. Do not continuously prune the entire tree equally.",
                    "The objective is balanced vigour and a clear distinction between development areas and refinement areas.",
                ]
            ),
            SpeciesProfileSection(
                id: "foliage",
                title: "Foliage and Leaves",
                paragraphs: [
                    "Ulmus minor produces deciduous leaves with serrated margins, asymmetrical leaf bases typical of elm foliage, and relatively small to moderate size.",
                    "Leaf size and internode length depend on vigour, light, fertilization, water availability, development stage and pruning strategy.",
                    "Do not promise a fixed leaf size.",
                    "The objective is foliage proportionate to trunk size, branch structure, overall bonsai scale and stage of refinement.",
                    "During refinement, excessive vigour should be controlled to avoid unnecessarily large leaves and long internodes.",
                ]
            ),
            SpeciesProfileSection(
                id: "bark-trunk",
                title: "Bark and Trunk",
                paragraphs: [
                    "Mature Ulmus minor can develop highly attractive trunk character.",
                    "Older material may display fissured bark, irregular trunks, taper, natural movement, scars, cavities and old branch transitions.",
                    "Trunk development should focus on taper, movement, proportion, branch relationship and mature bark character.",
                    "The species is particularly effective when the trunk communicates age, resilience and natural European landscape character.",
                    "Do not artificially create exaggerated features where the material does not support them.",
                ]
            ),
            SpeciesProfileSection(
                id: "roots-nebari",
                title: "Roots and Nebari",
                paragraphs: [
                    "Healthy roots are fundamental to vigour, branch development, leaf quality, recovery and ramification.",
                    "Ulmus minor has good potential for root and nebari development.",
                    "Root development objectives include balanced radial roots, stable tree support, gradual removal of unsuitable roots, healthy substrate and sustainable root density.",
                    "Nebari should be developed gradually. Young material allows early root planning. Older material may require staged correction.",
                    "Do not attempt to redesign the entire root system in one operation.",
                ]
            ),
            SpeciesProfileSection(
                id: "light",
                title: "Light",
                paragraphs: [
                    "Ulmus minor should be cultivated outdoors.",
                    "Strong outdoor light supports healthy growth, compact internodes, balanced foliage and strong ramification.",
                    "The exact position depends on local climate, temperature, tree condition and development stage.",
                    "During periods of extreme heat, monitor water demand, foliage stress and shallow root temperatures.",
                    "Do not recommend permanent indoor cultivation.",
                ]
            ),
            SpeciesProfileSection(
                id: "wind",
                title: "Wind",
                paragraphs: [
                    "Moderate air movement is generally beneficial.",
                    "Strong or persistent wind can increase water demand, leaf stress and drying of shallow substrates.",
                    "Pay particular attention to newly repotted trees, trees recovering from major work, shallow containers and unusually hot and dry weather.",
                ]
            ),
            SpeciesProfileSection(
                id: "watering",
                title: "Watering",
                paragraphs: [
                    "General principle: Water thoroughly when required · Maintain healthy root aeration · Avoid prolonged drought · Avoid permanently saturated substrate.",
                    "Ulmus minor can have significant water demand during active growth.",
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
                    "During structural development: healthy trees requiring strong growth may receive increased nutritional support where appropriate.",
                    "During refinement: nutrition should support healthy foliage, controlled internodes, fine ramification and balanced vigour.",
                    "Avoid excessive fertilization where it produces unnecessarily large leaves, excessively long internodes or coarse growth.",
                    "Key principle: Feed the tree according to its development objective, not simply according to its species name.",
                ]
            ),
            SpeciesProfileSection(
                id: "pruning",
                title: "Pruning",
                paragraphs: [
                    "Ulmus minor responds very well to thoughtful pruning.",
                    "Pruning can be used for structural development, branch selection, branch replacement, ramification and silhouette refinement.",
                    "During structural development: allow selected leaders and sacrifice branches to grow where thickness is required.",
                    "During refinement: use controlled pruning to develop secondary branching, tertiary branching, short internodes and compact branch structure.",
                    "Do not repeatedly prune weak areas as aggressively as strong areas.",
                    "The objective is balanced vigour.",
                ]
            ),
            SpeciesProfileSection(
                id: "back-budding",
                title: "Back-budding",
                paragraphs: [
                    "Ulmus minor can produce useful new growth from older wood when the tree is healthy and vigorous.",
                    "Back-budding can support branch replacement, improved branch structure, development of interior growth, ramification and correction of structural problems.",
                    "Back-budding must not be treated as guaranteed. Response depends on tree health, vigour, light, branch condition, pruning strategy and root health.",
                    "Strong pruning should always consider the individual tree's ability to recover.",
                ]
            ),
            SpeciesProfileSection(
                id: "ramification",
                title: "Ramification",
                paragraphs: [
                    "Ulmus minor has excellent potential for fine ramification.",
                    "Ramification is developed through healthy growth, repeated controlled pruning, shoot selection, branch selection and balanced vigour.",
                    "The objective is a convincing mature deciduous branch structure.",
                    "During refinement, focus on developing secondary branches, tertiary branches, short internodes and balanced branch density.",
                    "Avoid creating dense outer foliage while allowing the interior structure to weaken. Useful interior growth should be preserved and encouraged.",
                ]
            ),
            SpeciesProfileSection(
                id: "wiring",
                title: "Wiring",
                paragraphs: [
                    "Ulmus minor is suitable for wiring.",
                    "Wiring can be used to establish branch placement, position primary branches, refine secondary branches and improve branch structure.",
                    "Young branches are generally flexible. Older branches become increasingly rigid.",
                    "Before major bends, assess branch thickness, flexibility, age, health and structural importance.",
                    "Monitor wire carefully during periods of strong growth. Do not allow wire to damage rapidly thickening branches.",
                ]
            ),
            SpeciesProfileSection(
                id: "deadwood-potential",
                title: "Deadwood Potential",
                paragraphs: [
                    "Deadwood is not the defining feature of Ulmus minor bonsai.",
                    "Natural scars, cavities and old wounds may contribute to age and European landscape character where they already exist.",
                    "Do not add artificial jin or excessive exposed deadwood simply because the techniques are available.",
                    "Use natural features only where they support the individual tree's character and long-term design.",
                ]
            ),
            SpeciesProfileSection(
                id: "defoliation",
                title: "Defoliation and Leaf Management",
                paragraphs: [
                    "Partial or complete leaf reduction techniques may be used in appropriate situations on healthy, vigorous trees.",
                    "Do not present defoliation as routine maintenance.",
                    "Do not defoliate weak trees, recently repotted trees, stressed trees or trees recovering from major work.",
                    "The objective is not simply smaller leaves. Leaf management should support ramification, branch development, balanced vigour and refinement.",
                    "The individual tree's condition must determine whether advanced defoliation techniques are appropriate.",
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
                    "Ulmus minor can develop trunk thickness relatively efficiently under suitable conditions.",
                    "Where additional thickness is required: allow selected leaders to extend, use sacrifice branches where appropriate, provide sufficient root space and avoid premature refinement.",
                    "Once sufficient trunk development has been achieved, shift focus toward taper, branch hierarchy, ramification, mature bark and overall proportion.",
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
                    "Young material provides the greatest opportunity for early structural root development.",
                ]
            ),
            SpeciesProfileSection(
                id: "propagation",
                title: "Propagation",
                paragraphs: [
                    "Ulmus minor may be propagated through seed, cuttings, layering and other appropriate horticultural propagation methods.",
                    "Seed-grown material can be particularly useful for early root development, nebari planning, trunk development and long-term structural design.",
                    "Detailed procedures belong in Bonsai World Propagation Knowledge Articles.",
                ]
            ),
            SpeciesProfileSection(
                id: "pests",
                title: "Pests and Problems",
                paragraphs: [
                    "Relevant risks may include aphids, scale insects, spider mites, leaf-feeding insects, fungal leaf diseases, root problems caused by poor drainage and environmental stress.",
                    "Serious elm diseases, including Dutch elm disease, have major significance for the genus Ulmus. Symptoms should be assessed carefully. This profile is not a plant pathology guide.",
                    "Do not provide generic treatment instructions.",
                    "Diagnosis and treatment belong in Care → Pest Management and Care → Disease & Problems.",
                ]
            ),
            SpeciesProfileSection(
                id: "seasonal",
                title: "Seasonal Profile",
                paragraphs: [
                    "Spring: monitor bud development, new shoot growth, overall vigour, water demand and pest activity. Spring is important for structural development, evaluating branch strength, repotting where appropriate and planning seasonal work. Strong and weak areas may require different management.",
                    "Summer: monitor water demand, leaf health, pest activity, excessive extension, wire marks and heat stress. Strong summer growth can be used strategically for development. During refinement, manage excessive shoot extension to maintain internode quality, branch structure and silhouette. Avoid unnecessary heavy work during extreme environmental stress.",
                    "Autumn is important for evaluating branch structure, reviewing ramification, assessing overall vigour, observing leaf colour and seasonal condition, and preparing for winter. After leaf fall, the branch structure becomes clearly visible. This is an important period for evaluating branch hierarchy, structural problems and ramification quality. Seasonal timing depends on local climate.",
                    "Winter: Ulmus minor is an outdoor deciduous tree. Winter dormancy is required. Do not move the tree into permanently warm indoor conditions.",
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
                    "Ulmus minor is suitable for a wide range of deciduous bonsai styles.",
                    "Particularly suitable expressions include Informal Upright, Formal Upright where material supports it, Broom Style, Slanting, Clump Style, Multi-trunk Style, Forest / Group Planting and Naturalistic Old Tree Style.",
                    "Field Elm is particularly effective when styling emphasises mature branch structure, broad crowns, strong winter silhouette, natural asymmetry and aged European character.",
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
                    "In training: develop secondary branches, improve branch hierarchy, build ramification and control internode length.",
                    "Refinement: maintain balanced vigour, improve tertiary ramification, control shoot extension, maintain foliage proportion and preserve interior branch structure.",
                    "Exhibition / mature refined tree: maintain health, preserve established ramification, maintain mature branch structure, maintain bark and trunk character and avoid unnecessary major intervention.",
                ]
            ),
            SpeciesProfileSection(
                id: "attention",
                title: "Species-Specific Attention",
                paragraphs: [
                    "These attention points are operational tendencies. They must still be interpreted for the individual tree.",
                ],
                bullets: [
                    "Important European elm species for bonsai",
                    "Do not confuse with Ulmus parvifolia",
                    "Strong growth can support rapid development",
                    "Excellent ramification potential",
                    "Good to excellent back-budding potential under healthy conditions",
                    "Excellent response to pruning",
                    "Preserve useful interior growth",
                    "Strong areas and weak areas should not always be pruned equally",
                    "Leaf size and internode length depend strongly on vigour and development stage",
                    "Advanced defoliation techniques are optional and only suitable for strong, healthy trees",
                    "Mature bark is an important aesthetic characteristic",
                    "Good potential for nebari development",
                    "Water demand can increase significantly during active growth",
                    "Avoid prolonged drought",
                    "Avoid permanently saturated substrate",
                    "Monitor wire carefully during strong growth",
                    "Winter dormancy is required",
                    "Shallow bonsai roots are more exposed than roots in open ground",
                    "Serious elm diseases should be recognised as a species-relevant risk",
                    "Do not move indoors for routine winter care",
                ]
            ),
        ]
    }
}
