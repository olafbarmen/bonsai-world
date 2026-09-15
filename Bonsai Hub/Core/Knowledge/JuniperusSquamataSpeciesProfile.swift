//
//  JuniperusSquamataSpeciesProfile.swift
//  Bonsai World
//
//  Species Profile — Juniperus squamata (Flaky Juniper).
//  Independent botanical species in Cupressaceae. Knowledge status: Reviewed.
//  Separate from Juniperus squamata 'Blue Star' and other cultivar profiles.
//

import Foundation

enum JuniperusSquamataSpeciesProfile {
    /// Identity used by Botanical Library / ``SpeciesPreviewData``.
    static let botanicalLibraryName = "Juniperus squamata"
    /// Scientific name for Species Profile display (binomial; no botanical authority).
    static let scientificName = "Juniperus squamata"

    static var profile: SpeciesProfile {
        SpeciesProfile(
            speciesID: BotanicalKnowledgeIDs.juniperusSquamata,
            scientificName: scientificName,
            commonNames: ["Flaky Juniper", "Himalayan Juniper"],
            family: "Cupressaceae",
            plantType: "Evergreen conifer",
            originSummary: "The Himalayan region and mountainous areas of central and eastern Asia.",
            knowledgeStatus: .reviewed,
            traits: traits,
            foliageSizeLabel: "Foliage",
            foliageReductionLabel: "Foliage reduction",
            summaryLine: "Evergreen · Conifer · Needle-like juvenile foliage · Compact growth · Mountain species · Rugged natural character · Suitable for smaller bonsai · Good deadwood potential · Outdoor cultivation required",
            attentionHighlights: [
                "Juniperus squamata is an evergreen conifer associated with mountainous regions of Asia",
                "Outdoor cultivation is required",
                "Winter dormancy is required",
                "The species profile is separate from Juniperus squamata 'Blue Star'",
                "Cultivar characteristics must not automatically be applied to the species",
                "Healthy foliage must be retained where future growth is required",
                "Do not strip branches bare",
                "Do not assume old bare wood will reliably regenerate",
                "Preserve useful interior foliage",
                "Avoid repeated severe drought",
                "Avoid permanently saturated roots",
                "Wiring is an important development tool",
                "Avoid combining major root work with major styling work unnecessarily",
                "Do not use defoliation techniques",
                "Shallow roots require protection during prolonged severe freezing",
                "Winter desiccation can be a significant risk in exposed conditions",
            ],
            sections: sections,
            principleNote: """
            Juniperus squamata must be developed with respect for its dependence on retained healthy foliage.

            The primary operational rule is: Do not remove all healthy foliage from branches or sections that must remain alive.

            The species should not be treated as a deciduous tree capable of reliably rebuilding from completely bare old wood.

            Its strongest bonsai characteristics include compact proportions, dense needle-like foliage, rugged natural character, mountain-style aesthetics, mature bark and potential for natural deadwood.

            The objective is: Healthy roots · Preserved foliage · Natural structure · Compact proportions · Gradual refinement.

            The individual tree must always be assessed according to climate, tree condition, vigour, development stage and winter temperatures.
            """,
            sourcesNote: """
            Profile content is synthesised from recognised botanical, horticultural and bonsai authorities into Bonsai World editorial language.

            Botanical taxonomy and distribution draw on recognised sources such as Royal Botanic Gardens, Kew, Plants of the World Online and recognised Asian botanical institutions for accepted scientific name, family and native range.

            Horticultural context may draw on recognised horticultural institutions and authoritative Juniperus references.

            Bonsai-specific cultivation and refinement knowledge draws on established bonsai references and recognised professional practice with Juniperus experience.

            This profile is the botanical and horticultural baseline for Juniperus squamata. Cultivar profiles such as Juniperus squamata 'Blue Star' remain separate where they have their own established bonsai identity.

            Verified botanical information, horticultural information, regional climate adaptation and bonsai-specific practice are kept distinct. Do not copy source wording.
            """
        )
    }

    private static let traits = SpeciesProfileTraits(
        deciduous: false,
        growthStrength: "Slow to Moderate",
        growthSpeed: "Slow to Moderate",
        leafSize: "Evergreen · Needle-like foliage",
        foliageReduction: "Not applicable",
        ramificationPotential: "Good",
        backBudding: "Limited to Moderate — dependent on retained healthy foliage",
        rootDevelopment: "Moderate",
        nebariPotential: "Good potential",
        trunkDevelopment: "Slow",
        barkDevelopment: "Good mature character",
        wiring: "Good",
        defoliation: "Not applicable",
        airLayering: "Where appropriate for the individual material",
        threadGrafting: "Where structural correction is required",
        rootGrafting: "Where appropriate",
        beginnerSuitability: "Moderate",
        bonsaiSuitability: "Good to Excellent",
        difficulty: "Intermediate",
        winterDormancyRequired: true,
        winterHardiness: "Required",
        rootFrostSensitivity: "Moderate in shallow containers during prolonged severe freezing"
    )

    private static var sections: [SpeciesProfileSection] {
        [
            SpeciesProfileSection(
                id: "taxonomic-context",
                title: "Taxonomic Context",
                paragraphs: [
                    "Juniperus squamata is an independent botanical species in the cypress family (Cupressaceae).",
                    "Primary Bonsai World display identity: Juniperus squamata · Flaky Juniper.",
                    "Himalayan Juniper may be listed as an alternative common name where useful. It does not replace Flaky Juniper as the preferred English common name.",
                    "Family: Cupressaceae. Plant type: evergreen conifer.",
                    "Native range: The Himalayan region and mountainous areas of central and eastern Asia.",
                    "Do not confuse the species profile with the existing cultivar profile Juniperus squamata 'Blue Star'.",
                    "The species profile must remain separate from cultivar profiles. Cultivar-specific characteristics must not automatically be assigned to the species.",
                    "Bonsai World hierarchy: Species → cultivar / horticultural selection → Individual Tree.",
                ]
            ),
            SpeciesProfileSection(
                id: "overview",
                title: "Species Overview",
                paragraphs: [
                    "Juniperus squamata is an evergreen juniper associated with mountainous regions of Asia, including the Himalayan region.",
                    "Juniperus squamata is particularly relevant to Bonsai World because it is the species behind several important ornamental and bonsai cultivars, it has distinctive dense needle-like foliage, it is naturally associated with mountainous environments, it can produce rugged and compact bonsai material and it provides the botanical baseline for cultivar profiles such as 'Blue Star'.",
                    "It is valued for bonsai because of distinctive needle-like foliage, compact growth potential, rugged character, suitability for smaller trees and natural compatibility with mountain-inspired designs.",
                    "It is also botanically important because numerous ornamental cultivars are derived from the species.",
                    "For Bonsai World: the species profile represents Juniperus squamata itself. Cultivars such as Juniperus squamata 'Blue Star' remain separate where they have their own established bonsai identity.",
                    "The species profile must remain botanically distinct from all cultivars.",
                ],
                bullets: [
                    "Evergreen conifer",
                    "Native to mountainous regions of Asia",
                    "Needle-like foliage",
                    "Compact growth potential",
                    "Slow to moderate growth",
                    "Good ramification potential",
                    "Limited to moderate back-budding",
                    "Healthy foliage must be retained",
                    "Outdoor cultivation required",
                    "Winter dormancy required",
                    "Good naturalistic character",
                    "Suitable for smaller bonsai",
                    "Good deadwood potential",
                ]
            ),
            SpeciesProfileSection(
                id: "cultivars",
                title: "Cultivars and Forms",
                paragraphs: [
                    "Juniperus squamata is the botanical baseline species for bonsai use.",
                    "Named cultivars such as Juniperus squamata 'Blue Star' remain separate Species Library profiles where they have an established independent bonsai identity.",
                    "Cultivar-specific characteristics must not automatically be assigned to this species profile.",
                    "Do not create unnecessary separate Species Library profiles for minor individual variation.",
                    "The primary Species Profile remains Juniperus squamata.",
                    "Only create separate profiles where a distinct cultivar or form has a clear and established independent bonsai identity.",
                ]
            ),
            SpeciesProfileSection(
                id: "natural-growth",
                title: "Natural Growth and Vigour",
                paragraphs: [
                    "Juniperus squamata generally develops slowly to moderately.",
                    "Healthy growth depends on healthy roots, sufficient light, appropriate watering, well-aerated substrate and balanced nutrition.",
                    "During development: allow selected growth to extend where required for trunk development, branch thickening, foliage development or recovery.",
                    "Avoid repeatedly weakening the tree through unnecessary simultaneous work.",
                    "The objective is: Stable health · Useful growth · Progressive development.",
                ]
            ),
            SpeciesProfileSection(
                id: "foliage",
                title: "Foliage",
                paragraphs: [
                    "Juniperus squamata has distinctive needle-like foliage.",
                    "Foliage is essential to the tree's future development.",
                    "Do not strip branches bare, remove all useful interior foliage, or assume bare old sections will reliably regenerate.",
                    "Foliage management should focus on selective shoot management, preservation of useful interior growth, balanced vigour and controlled foliage density.",
                    "Avoid dense outer shells, empty branch interiors and excessive uniform trimming.",
                    "The objective is: Healthy foliage · Useful interior growth · Controlled compactness.",
                ]
            ),
            SpeciesProfileSection(
                id: "flowering",
                title: "Flowering",
                paragraphs: [
                    "Flowering is not applicable as a bonsai feature.",
                    "Do not treat flowering as a styling priority.",
                ]
            ),
            SpeciesProfileSection(
                id: "fruit",
                title: "Seed Cones",
                paragraphs: [
                    "Juniperus squamata produces berry-like seed cones.",
                    "Seed cones may contribute to seasonal character but are not a primary bonsai design objective.",
                    "Do not sacrifice structural development or foliage health in pursuit of seed cones.",
                ]
            ),
            SpeciesProfileSection(
                id: "bark-trunk",
                title: "Bark and Trunk",
                paragraphs: [
                    "Juniperus squamata can develop increasingly mature trunk character over time. Mature bark character is good.",
                    "Trunk development should focus on believable taper, natural movement, appropriate proportions and preservation of healthy living tissue.",
                    "Avoid unnecessary artificial damage.",
                    "The objective is: Natural maturity · Compact proportions · Strong character.",
                ]
            ),
            SpeciesProfileSection(
                id: "roots-nebari",
                title: "Roots and Nebari",
                paragraphs: [
                    "Healthy roots support foliage health, vigour, recovery and long-term container cultivation.",
                    "Root development is moderate. Nebari has good potential.",
                    "Root work should be conservative and progressive.",
                    "Avoid excessive root removal, repeated unnecessary repotting and combining major root work with major styling work.",
                    "The objective is: Healthy roots · Stable recovery · Progressive nebari development.",
                ]
            ),
            SpeciesProfileSection(
                id: "light",
                title: "Light",
                paragraphs: [
                    "Juniperus squamata should be cultivated outdoors with strong access to light.",
                    "Adequate light supports healthy foliage, compact growth, ramification and vigour.",
                    "The ideal position depends on local climate, summer temperatures, tree health and development stage.",
                    "Outdoor cultivation is required.",
                    "Do not recommend permanent indoor cultivation.",
                ]
            ),
            SpeciesProfileSection(
                id: "wind",
                title: "Wind",
                paragraphs: [
                    "Moderate air movement is beneficial.",
                    "Strong drying wind can increase water demand, desiccate foliage, stress shallow root systems and increase winter exposure.",
                    "Monitor carefully during exposed periods.",
                ]
            ),
            SpeciesProfileSection(
                id: "watering",
                title: "Watering",
                paragraphs: [
                    "General principle: Water thoroughly when required · Avoid prolonged severe drought · Avoid permanently saturated roots · Maintain healthy root aeration.",
                    "Water demand is moderate.",
                    "Water demand depends on temperature, sunlight, wind, foliage mass, container size, substrate and root mass.",
                    "Do not water according to a fixed timetable.",
                    "The objective is: Stable root moisture · Healthy roots · Consistent vigour.",
                ]
            ),
            SpeciesProfileSection(
                id: "soil",
                title: "Soil",
                paragraphs: [
                    "Do not prescribe one universal soil recipe.",
                    "Desired characteristics include excellent drainage, good aeration, stable particle structure, sufficient moisture retention and healthy root development.",
                    "The final substrate depends on local climate, rainfall, watering habits, container depth, tree size and development stage.",
                    "Follow Bonsai World Soil Module principles.",
                    "Do not duplicate the complete Soil Module inside this profile.",
                ]
            ),
            SpeciesProfileSection(
                id: "fertilizing",
                title: "Fertilizing",
                paragraphs: [
                    "Fertilization should support foliage health, root development, branch development and recovery.",
                    "During development: support healthy useful growth.",
                    "During refinement: avoid excessive feeding that produces unnecessarily coarse extension, overly vigorous imbalance or loss of compact structure.",
                    "Key principle: Feed according to tree health and development objective.",
                ]
            ),
            SpeciesProfileSection(
                id: "pruning",
                title: "Pruning",
                paragraphs: [
                    "Pruning should focus on branch selection, shoot management, maintaining structure and maintaining compact proportions. Pruning response is moderate and requires careful foliage retention.",
                    "Before removing major sections: assess retained foliage, identify replacement options and preserve useful interior growth.",
                    "Avoid irreversible cuts where no viable future growth remains.",
                    "The objective is: Controlled development · Preserved foliage · Long-term options.",
                ]
            ),
            SpeciesProfileSection(
                id: "back-budding",
                title: "Back-budding",
                paragraphs: [
                    "Back-budding is limited to moderate and dependent on retained healthy foliage.",
                    "Back-budding should not be assumed on completely bare old wood.",
                    "Response depends on tree health, vigour, retained foliage, branch age, available growth points and light.",
                    "When reducing branches: retain useful foliage, preserve interior growth and maintain replacement options.",
                    "The objective is: Preserve future development before making irreversible cuts.",
                ]
            ),
            SpeciesProfileSection(
                id: "ramification",
                title: "Ramification",
                paragraphs: [
                    "Ramification potential is good.",
                    "Ramification can be developed through healthy growth cycles, selective pruning, shoot selection, wiring and directional development.",
                    "Avoid repeated hedge-like trimming, removing useful interior foliage and maintaining foliage only at branch tips.",
                    "The objective is: Compact ramification · Healthy interiors · Clear branch hierarchy.",
                ]
            ),
            SpeciesProfileSection(
                id: "wiring",
                title: "Wiring",
                paragraphs: [
                    "Wiring is an important development tool for Juniperus squamata. Wiring response is good.",
                    "It can be used for trunk movement, branch placement, foliage positioning and structural refinement.",
                    "Before major bends assess branch flexibility, branch thickness, wood age, health and living tissue.",
                    "Avoid forcing rigid material.",
                    "Monitor wire carefully.",
                    "The objective is: Natural movement · Safe positioning · Clear structure.",
                ]
            ),
            SpeciesProfileSection(
                id: "deadwood-potential",
                title: "Deadwood",
                paragraphs: [
                    "Deadwood can be incorporated where appropriate to the material. Deadwood potential is good.",
                    "Potential features include jin, shari and natural dead branch remnants.",
                    "However, deadwood should follow believable natural logic, living tissue must be protected, excessive carving should be avoided and major deadwood work should not compromise tree health.",
                    "The objective is: Natural mountain character rather than artificial drama.",
                ]
            ),
            SpeciesProfileSection(
                id: "defoliation",
                title: "Foliage Management",
                paragraphs: [
                    "Defoliation is not applicable.",
                    "Do not present foliage stripping as a refinement technique.",
                    "Foliage management should focus on selective shoot management, controlled pruning, vigour balancing and preservation of interior foliage.",
                    "Do not aggressively remove foliage from weak trees, stressed trees, recently repotted trees or trees recovering from major styling work.",
                ]
            ),
            SpeciesProfileSection(
                id: "repotting",
                title: "Repotting",
                paragraphs: [
                    "Repotting frequency depends on root development, substrate condition, drainage, container size, tree health and development stage.",
                    "Do not establish a rigid calendar rule.",
                    "Root work should generally be conservative.",
                    "Avoid excessive root removal, removing too much functioning root mass and combining major root work with major styling work.",
                    "Timing must account for local climate, winter conditions, growth cycle and individual tree health.",
                ]
            ),
            SpeciesProfileSection(
                id: "trunk-development",
                title: "Trunk Development",
                paragraphs: [
                    "Juniperus squamata develops trunk thickness gradually.",
                    "Where additional development is required: retain selected leaders, allow useful branches to extend, provide sufficient root space and avoid premature confinement.",
                    "Development should support taper, natural movement, trunk strength and believable proportions.",
                    "Once sufficient trunk development exists, shift focus toward branch structure, ramification, foliage masses and refinement.",
                    "Key principle: Do not permanently restrict a tree that still requires structural development.",
                ]
            ),
            SpeciesProfileSection(
                id: "nebari-development",
                title: "Nebari Development",
                paragraphs: [
                    "Nebari development should be gradual.",
                    "Potential approaches include early root planning, staged correction, development containers where appropriate and progressive refinement.",
                    "The objective is: Stable anchoring · Natural base · Healthy roots.",
                ]
            ),
            SpeciesProfileSection(
                id: "propagation",
                title: "Propagation",
                paragraphs: [
                    "Juniperus squamata may be propagated through established horticultural methods where appropriate.",
                    "Detailed procedures belong in Bonsai World Propagation Knowledge Articles.",
                ]
            ),
            SpeciesProfileSection(
                id: "pests",
                title: "Pests and Problems",
                paragraphs: [
                    "Relevant risks may include scale insects, spider mites, foliage pests, fungal problems, root problems caused by poor substrate aeration, drought stress, winter desiccation and stress caused by excessive pruning or foliage removal.",
                    "Do not provide generic treatment instructions.",
                    "Diagnosis and treatment belong in Care → Pest Management and Care → Disease & Problems.",
                ]
            ),
            SpeciesProfileSection(
                id: "seasonal",
                title: "Seasonal Profile",
                paragraphs: [
                    "Spring: monitor foliage health, vigour, new growth, watering demand and root health. Coordinate major work with local climate and individual tree condition. Avoid unnecessary simultaneous major stresses.",
                    "Summer: monitor watering demand, foliage health, pest activity, spider mites and wire marks. Strong growth may be required for recovery, branch development or foliage development. Avoid unnecessary repeated foliage reduction.",
                    "Autumn is important for reviewing foliage health, assessing branch structure, evaluating development progress and preparing for winter. Avoid unnecessary late-season stress. Local climate determines timing.",
                    "Winter: Juniperus squamata requires outdoor winter dormancy.",
                    "Winter management depends on local minimum temperatures, duration of freezing, wind exposure, container depth, root protection, foliage exposure and tree health.",
                    "Shallow bonsai roots are more exposed than roots in open ground. Protect when required.",
                    "Pay particular attention to winter desiccation, drying wind and prolonged severe freezing.",
                    "Do not maintain indoors as a substitute for winter dormancy.",
                ]
            ),
            SpeciesProfileSection(
                id: "styles",
                title: "Bonsai Styles",
                paragraphs: [
                    "Juniperus squamata is particularly suitable for Informal Upright, Slanting, Semi-cascade, Cascade, Naturalistic Bonsai, Mountain-inspired Bonsai and Shohin Bonsai.",
                    "It is especially effective when styling emphasises compact proportions, rugged natural movement, dense but structured foliage, natural asymmetry and mountain character.",
                    "The individual material should determine the final design.",
                ]
            ),
            SpeciesProfileSection(
                id: "tree-stage",
                title: "Development by Tree Stage",
                paragraphs: [
                    "Young material: establish healthy roots, develop trunk movement, build useful foliage and preserve future branch options.",
                    "Nursery material: evaluate trunk potential, identify useful branches, establish design direction and begin structural development.",
                    "Pre-bonsai: develop trunk, establish primary branches, build foliage mass and preserve healthy roots.",
                    "In training: establish branch structure, build ramification, preserve interior foliage and develop compact proportions.",
                    "Refinement: maintain foliage health, improve structure, refine foliage masses, preserve interior growth and maintain natural branch hierarchy.",
                    "Exhibition / mature refined tree: maintain health, preserve established structure, maintain compact proportions, preserve interior growth and avoid unnecessary major intervention.",
                ]
            ),
            SpeciesProfileSection(
                id: "attention",
                title: "Species-Specific Attention",
                paragraphs: [
                    "These attention points are operational tendencies. They must still be interpreted for the individual tree.",
                ],
                bullets: [
                    "Juniperus squamata is an evergreen conifer associated with mountainous regions of Asia",
                    "Outdoor cultivation is required",
                    "Winter dormancy is required",
                    "The species profile is separate from Juniperus squamata 'Blue Star'",
                    "Cultivar characteristics must not automatically be applied to the species",
                    "Healthy foliage must be retained where future growth is required",
                    "Do not strip branches bare",
                    "Do not assume old bare wood will reliably regenerate",
                    "Preserve useful interior foliage",
                    "Avoid repeated severe drought",
                    "Avoid permanently saturated roots",
                    "Wiring is an important development tool",
                    "Avoid combining major root work with major styling work unnecessarily",
                    "Do not use defoliation techniques",
                    "Shallow roots require protection during prolonged severe freezing",
                    "Winter desiccation can be a significant risk in exposed conditions",
                ]
            ),
        ]
    }
}
