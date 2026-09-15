//
//  UlmusParvifoliaSpeciesProfile.swift
//  Bonsai World
//
//  Species Profile — Ulmus parvifolia (Chinese Elm).
//  Independent botanical species in Ulmaceae. Knowledge status: Reviewed.
//

import Foundation

enum UlmusParvifoliaSpeciesProfile {
    /// Identity used by Botanical Library / ``SpeciesPreviewData``.
    static let botanicalLibraryName = "Ulmus parvifolia"
    /// Scientific name for Species Profile display (binomial; no botanical authority).
    static let scientificName = "Ulmus parvifolia"

    static var profile: SpeciesProfile {
        SpeciesProfile(
            speciesID: BotanicalKnowledgeIDs.ulmusParvifolia,
            scientificName: scientificName,
            commonNames: ["Chinese Elm"],
            family: "Ulmaceae",
            plantType: "Deciduous to semi-evergreen tree",
            originSummary: "East Asia, including China, Korea and Japan.",
            knowledgeStatus: .reviewed,
            traits: traits,
            foliageSizeLabel: "Foliage",
            foliageReductionLabel: "Leaf reduction",
            summaryLine: "Small leaves · Excellent ramification · Strong growth · Attractive mature bark · Excellent pruning response · Highly suitable for bonsai",
            attentionHighlights: [
                "One of the most versatile broadleaf bonsai species",
                "Naturally small leaves",
                "Excellent ramification potential",
                "Excellent back-budding under healthy conditions",
                "Strong response to pruning",
                "Mature bark is an important visual feature",
                "Excellent nebari development potential",
                "Seasonal leaf retention varies with climate",
                "Do not universally describe the species as evergreen",
                "Do not confuse the species with Zelkova serrata",
                "Strong outdoor light supports compact growth",
                "Avoid permanently wet substrate",
                "Vigorous growth can quickly create wire marks",
                "Defoliation is possible but should not be routine",
                "Protect shallow roots from damaging prolonged frost",
                "Do not treat permanent indoor cultivation as normal long-term care",
            ],
            sections: sections,
            principleNote: """
            Ulmus parvifolia is one of the most versatile and widely used bonsai species.

            It is particularly valued for naturally small leaves, excellent ramification, strong back-budding, attractive mature bark, strong root development, excellent response to pruning and adaptability to many bonsai styles.

            The species can be developed from seed, nursery stock, field-grown material, collected material where legally and ethically appropriate, and established pre-bonsai. It is suitable for both rapid development and long-term refinement.

            The individual tree must always be assessed according to health, root condition, vigour, development stage, climate, seasonal conditions and recent work.

            The objective is: Healthy roots · Strong structure · Fine ramification · Proportionate foliage · Sustainable long-term development
            """,
            sourcesNote: """
            Profile content is synthesised from recognised botanical, horticultural and bonsai authorities into Bonsai World editorial language.

            Botanical taxonomy and distribution draw on recognised sources such as Royal Botanic Gardens, Kew and other botanical databases for accepted scientific name, family and native range.

            Horticultural cultivation context may draw on recognised botanical gardens, arboreta and horticultural institutions.

            Bonsai-specific cultivation and refinement knowledge draws on established bonsai references and recognised professional practice for Ulmus parvifolia.

            Verified botanical information, general horticultural cultivation and bonsai-specific practice are kept distinct. Do not copy source wording.
            """
        )
    }

    private static let traits = SpeciesProfileTraits(
        deciduous: true,
        growthStrength: "Strong",
        growthSpeed: "Moderate to Fast",
        leafSize: "Small leaves · Deciduous to semi-evergreen depending on climate",
        foliageReduction: "Good potential — vigour and cultivation dependent",
        ramificationPotential: "Excellent",
        backBudding: "Excellent under healthy conditions",
        rootDevelopment: "Strong",
        nebariPotential: "Excellent development potential",
        trunkDevelopment: "Strong",
        barkDevelopment: "Attractive mottled, often exfoliating mature bark",
        wiring: "Excellent suitability",
        defoliation: "Possible only on healthy and vigorous trees when appropriate",
        airLayering: "Where appropriate for the individual material",
        threadGrafting: "Where structural correction is required",
        rootGrafting: "Where appropriate",
        beginnerSuitability: "Excellent",
        bonsaiSuitability: "Excellent",
        difficulty: "Beginner to Intermediate",
        winterDormancyRequired: true,
        winterHardiness: "Climate dependent, but outdoor seasonal conditions are important",
        rootFrostSensitivity: "Moderate to High depending on root exposure and local climate"
    )

    private static var sections: [SpeciesProfileSection] {
        [
            SpeciesProfileSection(
                id: "taxonomic-context",
                title: "Taxonomic Context",
                paragraphs: [
                    "Ulmus parvifolia is an independent botanical species in the elm family (Ulmaceae).",
                    "Primary Bonsai World display identity: Ulmus parvifolia · Chinese Elm.",
                    "Family: Ulmaceae. Plant type: deciduous to semi-evergreen tree. Leaf retention is not a single universal pattern.",
                    "Native range: East Asia, including China, Korea and Japan.",
                    "Maintain a clear distinction between Ulmus parvifolia, Ulmus minor and other Ulmus species.",
                    "Do not confuse Chinese Elm with Japanese Zelkova. Although the two are occasionally mixed in horticultural and bonsai naming, they belong to different genera.",
                    "Zelkova serrata remains a separate Species Library profile. Superficial similarity must not merge the two identities.",
                    "Horticultural selections and compact-leaf cultivars may be mentioned where they affect cultivation, but they do not replace the primary species identity Ulmus parvifolia.",
                    "Bonsai World hierarchy: Species → cultivar / horticultural selection → Individual Tree.",
                ]
            ),
            SpeciesProfileSection(
                id: "overview",
                title: "Species Overview",
                paragraphs: [
                    "Ulmus parvifolia is native to East Asia and has become one of the world's most popular deciduous and semi-evergreen bonsai species.",
                    "It is particularly suited to bonsai because it can develop naturally small leaves, dense ramification, strong branch structure, attractive mature bark, convincing nebari and excellent visual age.",
                    "Mature bark may range through grey, brown and reddish-brown. Older bark may become exfoliating, mottled and textured.",
                    "The species is highly adaptable, but its seasonal behaviour depends strongly on climate. Do not present one single leaf-retention pattern as universal.",
                    "Important development principle: Grow where development is required. Control where refinement is required.",
                ],
                bullets: [
                    "Broadleaf tree",
                    "Small leaves",
                    "Deciduous to semi-evergreen depending on climate",
                    "Strong growth",
                    "Excellent back-budding",
                    "Excellent ramification potential",
                    "Excellent response to pruning",
                    "Attractive mature bark",
                    "Strong root development",
                    "Excellent nebari potential",
                    "Highly adaptable bonsai species",
                    "Suitable for many bonsai styles",
                ]
            ),
            SpeciesProfileSection(
                id: "natural-growth",
                title: "Natural Growth and Vigour",
                paragraphs: [
                    "Ulmus parvifolia is generally a vigorous species under suitable growing conditions.",
                    "Growth strength depends on root health, light, temperature, fertilization, substrate, container size and development stage.",
                    "During structural development: allow selected growth to extend where trunk thickness is required, branch thickness is required, sacrifice growth is useful or structural vigour is needed.",
                    "Do not continuously prune all new growth simply to maintain a compact appearance.",
                    "During refinement: use controlled pruning to develop branch division, ramification, compact foliage masses and proportionate internodes.",
                    "The tree must have sufficient vigour before intensive refinement.",
                ]
            ),
            SpeciesProfileSection(
                id: "foliage",
                title: "Foliage",
                paragraphs: [
                    "Ulmus parvifolia is valued for its naturally small leaves.",
                    "Leaf size depends on genetics, vigour, fertilization, branch strength, light, development stage and pruning strategy.",
                    "The species is naturally well suited to proportionate foliage development.",
                    "Do not promise a fixed leaf size.",
                    "The objective is foliage proportionate to trunk size, branch structure and overall tree design.",
                    "In mild climates, foliage may persist longer. In colder climates, autumn colour and leaf drop may occur more consistently.",
                ]
            ),
            SpeciesProfileSection(
                id: "bark-trunk",
                title: "Bark and Trunk",
                paragraphs: [
                    "Mature Ulmus parvifolia can develop highly attractive bark.",
                    "Bark characteristics may include mottled colouring, grey tones, brown tones, reddish tones and an exfoliating texture.",
                    "Bark character becomes increasingly important as the tree matures.",
                    "Trunk development should focus on taper, movement, proportion, bark development and visual age.",
                    "Where additional thickness is required: allow selected growth to extend, use sacrifice branches where appropriate, provide sufficient growing space and avoid premature refinement.",
                ]
            ),
            SpeciesProfileSection(
                id: "roots-nebari",
                title: "Roots and Nebari",
                paragraphs: [
                    "Ulmus parvifolia has excellent potential for strong root development.",
                    "Healthy roots are fundamental to vigour, foliage quality, recovery, ramification and long-term refinement.",
                    "Nebari development can be an important feature of mature Chinese Elm bonsai.",
                    "Development objectives include radial root distribution where possible, strong visual stability, balanced root mass and gradual root selection.",
                    "Begin nebari development early where possible.",
                    "Do not attempt to correct the entire root structure aggressively in one operation.",
                ]
            ),
            SpeciesProfileSection(
                id: "light",
                title: "Light",
                paragraphs: [
                    "Ulmus parvifolia should receive strong outdoor light during the growing season.",
                    "Good light supports healthy foliage, compact growth, ramification, branch development and overall vigour.",
                    "The species should not be treated as a permanent indoor bonsai.",
                    "Indoor cultivation can reduce vigour, internode quality, foliage quality and long-term health.",
                    "Growing requirements must consider local climate, winter temperatures, frost risk and seasonal dormancy.",
                ]
            ),
            SpeciesProfileSection(
                id: "wind",
                title: "Wind",
                paragraphs: [
                    "Moderate air movement is generally beneficial.",
                    "Excessive wind can increase water demand, leaf desiccation and stress on recently repotted trees.",
                    "Pay particular attention to shallow containers, exposed locations, recently repotted trees and extreme weather conditions.",
                    "The growing position must always be assessed in relation to climate, season, container depth and tree health.",
                ]
            ),
            SpeciesProfileSection(
                id: "watering",
                title: "Watering",
                paragraphs: [
                    "General principle: Water thoroughly when required · Maintain healthy root aeration · Avoid prolonged drought · Avoid permanently saturated substrate.",
                    "Watering frequency depends on temperature, wind, sunlight, container size, substrate, root mass, foliage mass and development stage.",
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
                    "During development: healthy trees requiring stronger structural growth may receive increased nutritional support where appropriate.",
                    "During refinement: nutrition should support healthy foliage, compact growth, ramification and sustainable branch development.",
                    "Avoid excessive fertilization where it produces unnecessarily large leaves, excessively long internodes or coarse growth.",
                    "Key principle: Feed the tree you are growing, not simply the species name.",
                ]
            ),
            SpeciesProfileSection(
                id: "pruning",
                title: "Pruning",
                paragraphs: [
                    "Ulmus parvifolia responds extremely well to pruning.",
                    "Pruning can be used for structural development, branch selection, ramification, compact foliage development and silhouette refinement.",
                    "During development: allow selected branches to extend where thickness is required.",
                    "During refinement: use controlled pruning to develop secondary branches, tertiary branches and fine ramification.",
                    "Do not repeatedly prune weak areas in the same way as strong areas.",
                    "The objective is balanced vigour.",
                ]
            ),
            SpeciesProfileSection(
                id: "back-budding",
                title: "Back-budding",
                paragraphs: [
                    "Ulmus parvifolia has excellent potential for back-budding.",
                    "This characteristic is one of the reasons the species is highly suitable for bonsai.",
                    "Back-budding should never be described as guaranteed. Response depends on tree health, branch vigour, light, retained structure, pruning timing and overall root health.",
                    "Back-budding can support branch replacement, improved ramification, correction of long internodes and compact crown development.",
                    "Do not rely on back-budding as a substitute for proper structural planning.",
                ]
            ),
            SpeciesProfileSection(
                id: "ramification",
                title: "Ramification",
                paragraphs: [
                    "Ulmus parvifolia has excellent potential for fine ramification.",
                    "Ramification is developed through healthy growth, repeated controlled pruning, appropriate extension, selective branch development and preservation of useful interior growth.",
                    "The objective is clear branch hierarchy with dense but proportionate ramification.",
                    "Do not pursue maximum density at the expense of branch clarity, light penetration or overall tree health.",
                ]
            ),
            SpeciesProfileSection(
                id: "wiring",
                title: "Wiring",
                paragraphs: [
                    "Ulmus parvifolia is highly suitable for wiring.",
                    "Wiring can be used to establish trunk movement, position primary branches, develop secondary branches and refine branch placement.",
                    "Young branches are generally flexible. Older branches become increasingly rigid.",
                    "Monitor wire carefully because vigorous growth can cause wire marks.",
                    "Before major bends, assess branch thickness, flexibility, age, health and structural importance.",
                ]
            ),
            SpeciesProfileSection(
                id: "deadwood-potential",
                title: "Deadwood Potential",
                paragraphs: [
                    "Deadwood is possible but is generally not the defining feature of Ulmus parvifolia bonsai.",
                    "The species is often strongest when the design emphasises trunk movement, bark, nebari, branch structure and ramification.",
                    "Deadwood may be used where it naturally supports the story of the material.",
                    "Do not add artificial deadwood simply because it is technically possible.",
                ]
            ),
            SpeciesProfileSection(
                id: "defoliation",
                title: "Leaf Management",
                paragraphs: [
                    "Leaf size and density should primarily be managed through healthy root development, balanced fertilization, controlled pruning, appropriate light and long-term refinement.",
                    "Defoliation may be possible on strong and healthy trees where appropriate.",
                    "Do not present complete defoliation as routine annual maintenance.",
                    "Do not defoliate weak trees, recently repotted trees, recovering trees or trees under environmental stress.",
                    "Selective leaf reduction or partial defoliation may be more appropriate depending on the individual tree.",
                    "Detailed defoliation procedures belong in Bonsai World Seasonal Care and Advanced Refinement content.",
                ]
            ),
            SpeciesProfileSection(
                id: "repotting",
                title: "Repotting",
                paragraphs: [
                    "Repotting frequency depends on root development, substrate condition, drainage, container size, tree health and development stage.",
                    "Do not establish a rigid calendar rule.",
                    "Ulmus parvifolia generally develops strong roots, so root condition should be monitored carefully.",
                    "Avoid unnecessary aggressive root reduction, excessive removal of functioning roots, and combining major root work with multiple major stresses.",
                    "Preserve sufficient healthy roots.",
                ]
            ),
            SpeciesProfileSection(
                id: "trunk-development",
                title: "Trunk Development",
                paragraphs: [
                    "Ulmus parvifolia has strong trunk development potential.",
                    "Where additional thickness is required: allow selected leaders to extend, use sacrifice branches where appropriate, provide sufficient root space and avoid premature refinement.",
                    "Once sufficient trunk development has been achieved, shift focus toward taper, primary branches, secondary branches, ramification, bark development and nebari.",
                    "Grow where development is required. Control where refinement is required.",
                ]
            ),
            SpeciesProfileSection(
                id: "nebari-development",
                title: "Nebari Development",
                paragraphs: [
                    "Nebari can become a major visual strength of mature Chinese Elm bonsai.",
                    "Development objectives include radial root distribution, visible surface roots where appropriate, visual stability and a convincing connection between trunk and soil.",
                    "Begin nebari work early where possible rather than treating it as a late-stage correction.",
                    "Correct gradually. Do not reconstruct the entire root base in a single operation.",
                ]
            ),
            SpeciesProfileSection(
                id: "propagation",
                title: "Propagation",
                paragraphs: [
                    "Ulmus parvifolia may be propagated through seed, cuttings where appropriate, air layering and other specialist propagation techniques.",
                    "Different methods may be useful depending on the development objective.",
                    "Detailed procedures belong in Bonsai World Propagation Knowledge Articles.",
                ]
            ),
            SpeciesProfileSection(
                id: "pests",
                title: "Pests and Problems",
                paragraphs: [
                    "Relevant risks may include aphids, scale insects, spider mites, leaf-feeding insects, fungal leaf diseases, root problems caused by poor drainage and stress-related leaf drop.",
                    "Do not provide generic treatment instructions.",
                    "Diagnosis and treatment belong in Care → Pest Management and Care → Disease & Problems.",
                ]
            ),
            SpeciesProfileSection(
                id: "seasonal",
                title: "Seasonal Profile",
                paragraphs: [
                    "Spring: monitor bud development, new shoot growth, water demand, overall vigour and pest activity. Spring is important for structural growth, branch development and evaluating vigour. Strong growth may require selective control during refinement.",
                    "Summer: monitor water demand, leaf health, pest activity, shoot extension and wire marks. Strong summer growth can support rapid development and ramification. Avoid unnecessary heavy work during periods of extreme heat or drought stress.",
                    "Autumn: may include reduced growth, seasonal colour change and leaf drop depending on climate. Monitor branch structure, wire condition, tree health and winter preparation. Do not assume identical autumn behaviour in all climates.",
                    "Winter: behaviour depends significantly on local climate. Ulmus parvifolia should not automatically be treated as either fully evergreen or fully deciduous.",
                    "Protect shallow bonsai roots from damaging prolonged frost.",
                    "Do not move the tree into permanently warm indoor conditions simply to preserve foliage.",
                    "Winter protection should depend on local minimum temperatures, duration of freezing, root exposure, container depth and tree condition.",
                ]
            ),
            SpeciesProfileSection(
                id: "styles",
                title: "Bonsai Styles",
                paragraphs: [
                    "Ulmus parvifolia is suitable for a wide range of bonsai styles.",
                    "Particularly suitable styles include Informal Upright, Formal Upright, Slanting, Broom Style, Semi-Cascade, Cascade, Root-over-Rock and naturalistic upright forms.",
                    "The species is particularly effective in designs that emphasise fine ramification, mature bark, strong nebari and balanced branch structure.",
                    "The individual material should determine the final design.",
                ]
            ),
            SpeciesProfileSection(
                id: "tree-stage",
                title: "Development by Tree Stage",
                paragraphs: [
                    "Young material: establish healthy roots, build vigour, develop trunk movement and begin nebari development.",
                    "Nursery material: evaluate trunk potential, identify useful branches, establish a design direction and preserve growth where thickness is required.",
                    "Pre-bonsai: develop trunk, establish primary branches, improve root structure and begin controlled ramification.",
                    "In training: develop secondary branches, build ramification, improve branch hierarchy and refine branch placement.",
                    "Refinement: maintain balanced vigour, control shoot extension, improve ramification, maintain proportionate foliage and preserve branch clarity.",
                    "Exhibition / mature refined tree: maintain health, preserve established ramification, maintain foliage quality, preserve mature bark and avoid unnecessary major intervention.",
                ]
            ),
            SpeciesProfileSection(
                id: "attention",
                title: "Species-Specific Attention",
                paragraphs: [
                    "These attention points are operational tendencies. They must still be interpreted for the individual tree.",
                ],
                bullets: [
                    "One of the most versatile broadleaf bonsai species",
                    "Naturally small leaves",
                    "Excellent ramification potential",
                    "Excellent back-budding under healthy conditions",
                    "Strong response to pruning",
                    "Mature bark is an important visual feature",
                    "Excellent nebari development potential",
                    "Seasonal leaf retention varies with climate",
                    "Do not universally describe the species as evergreen",
                    "Do not confuse the species with Zelkova serrata",
                    "Strong outdoor light supports compact growth",
                    "Avoid permanently wet substrate",
                    "Vigorous growth can quickly create wire marks",
                    "Defoliation is possible but should not be routine",
                    "Protect shallow roots from damaging prolonged frost",
                    "Do not treat permanent indoor cultivation as normal long-term care",
                ]
            ),
        ]
    }
}
