//
//  JuniperusProcumbensSpeciesProfile.swift
//  Bonsai World
//
//  Species Profile — Juniperus procumbens (Japanese Garden Juniper).
//  Independent botanical species in Cupressaceae. Knowledge status: Reviewed.
//  Separate from Juniperus procumbens 'Green Mound' and other cultivar profiles.
//

import Foundation

enum JuniperusProcumbensSpeciesProfile {
    /// Identity used by Botanical Library / ``SpeciesPreviewData``.
    static let botanicalLibraryName = "Juniperus procumbens"
    /// Scientific name for Species Profile display (binomial; no botanical authority).
    static let scientificName = "Juniperus procumbens"

    static var profile: SpeciesProfile {
        SpeciesProfile(
            speciesID: BotanicalKnowledgeIDs.juniperusProcumbens,
            scientificName: scientificName,
            commonNames: ["Japanese Garden Juniper", "Japanese Juniper"],
            family: "Cupressaceae",
            plantType: "Evergreen conifer",
            originSummary: "Japan.",
            knowledgeStatus: .reviewed,
            traits: traits,
            foliageSizeLabel: "Foliage",
            foliageReductionLabel: "Foliage reduction",
            summaryLine: "Evergreen · Conifer · Compact growth · Scale foliage · Strong ramification potential · Excellent for small bonsai · Responsive to wiring · Suitable for shohin and medium bonsai · Outdoor cultivation required",
            attentionHighlights: [
                "Juniperus procumbens is an evergreen conifer native to Japan",
                "Outdoor cultivation is required",
                "Winter dormancy is required",
                "The species profile is separate from Juniperus procumbens 'Green Mound'",
                "Cultivar characteristics must not automatically be applied to the species",
                "Healthy foliage must be retained where future growth is required",
                "Do not strip branches bare",
                "Do not assume old bare wood will reliably regenerate",
                "Preserve useful interior foliage",
                "Wiring is one of the primary development tools",
                "Avoid repeated severe drought",
                "Avoid permanently saturated roots",
                "Avoid combining major root work with major styling work unnecessarily",
                "Do not use defoliation techniques",
                "Shallow roots require protection during prolonged severe freezing",
                "Winter desiccation can be a significant risk in exposed conditions",
            ],
            sections: sections,
            principleNote: """
            Juniperus procumbens must be developed with respect for the basic limitation shared by many junipers: Do not remove all healthy foliage from a branch or section that must remain alive.

            Future development depends on retained healthy foliage and viable growth points.

            Do not treat Juniperus procumbens as a deciduous species capable of reliably rebuilding from completely bare old wood.

            The objective is: Healthy roots · Preserved interior foliage · Controlled branch structure · Compact foliage masses · Progressive refinement.

            The individual tree must always be assessed according to climate, tree condition, vigour, development stage and winter temperatures.
            """,
            sourcesNote: """
            Profile content is synthesised from recognised botanical, horticultural and bonsai authorities into Bonsai World editorial language.

            Botanical taxonomy and distribution draw on recognised sources such as Royal Botanic Gardens, Kew, Plants of the World Online and recognised Japanese botanical institutions for accepted scientific name, family and native range.

            Horticultural context may draw on recognised horticultural institutions and authoritative Juniperus references.

            Bonsai-specific cultivation and refinement knowledge draws on established bonsai references and recognised professional practice with Juniperus experience.

            This profile is the botanical and horticultural baseline for Juniperus procumbens. Cultivar profiles such as Juniperus procumbens 'Green Mound' remain separate where Bonsai World determines that they have their own established bonsai identity.

            Verified botanical information, horticultural information, regional climate adaptation and bonsai-specific practice are kept distinct. Do not copy source wording.
            """
        )
    }

    private static let traits = SpeciesProfileTraits(
        deciduous: false,
        growthStrength: "Moderate",
        growthSpeed: "Moderate",
        leafSize: "Evergreen · Primarily scale foliage",
        foliageReduction: "Not applicable",
        ramificationPotential: "Good",
        backBudding: "Limited to Moderate — dependent on retained healthy foliage",
        rootDevelopment: "Moderate",
        nebariPotential: "Good potential",
        trunkDevelopment: "Slow to Moderate",
        barkDevelopment: "Good mature character",
        wiring: "Excellent",
        defoliation: "Not applicable",
        airLayering: "Where appropriate for the individual material",
        threadGrafting: "Where structural correction is required",
        rootGrafting: "Where appropriate",
        beginnerSuitability: "Moderate",
        bonsaiSuitability: "Excellent",
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
                    "Juniperus procumbens is an independent botanical species in the cypress family (Cupressaceae).",
                    "Primary Bonsai World display identity: Juniperus procumbens · Japanese Garden Juniper.",
                    "Japanese Juniper may be listed as an alternative common name where useful. It does not replace Japanese Garden Juniper as the preferred English common name.",
                    "Family: Cupressaceae. Plant type: evergreen conifer.",
                    "Native range: Japan.",
                    "Do not confuse this species profile with the existing cultivar profile Juniperus procumbens 'Green Mound'.",
                    "The species profile must remain separate from cultivar profiles. Cultivar-specific characteristics must not automatically be assigned to the species.",
                    "Bonsai World hierarchy: Species → cultivar / horticultural selection → Individual Tree.",
                ]
            ),
            SpeciesProfileSection(
                id: "overview",
                title: "Species Overview",
                paragraphs: [
                    "Juniperus procumbens is a compact evergreen juniper from Japan.",
                    "Juniperus procumbens is particularly relevant to Bonsai World because it is an established bonsai species, it has naturally compact growth, it can develop dense foliage masses, it is well suited to smaller bonsai, it responds well to structural wiring and it is closely associated with commonly used bonsai cultivars.",
                    "It is widely relevant to bonsai because of naturally compact growth, suitability for smaller bonsai, good response to wiring, dense evergreen foliage and potential for refined branch structure.",
                    "The species is particularly useful for shohin bonsai, small bonsai, medium-sized bonsai and informal naturalistic designs.",
                    "The species profile is the botanical and horticultural baseline. Cultivars remain separate profiles where Bonsai World determines that they have their own established bonsai identity.",
                    "Development should be patient. Prioritise root health, trunk and branch structure, healthy foliage and preservation of interior growth. Do not rush refinement.",
                ],
                bullets: [
                    "Evergreen conifer",
                    "Native to Japan",
                    "Compact natural growth",
                    "Primarily scale foliage",
                    "Good ramification potential",
                    "Excellent wiring response",
                    "Suitable for smaller bonsai",
                    "Outdoor cultivation required",
                    "Winter dormancy required",
                    "Limited to moderate back-budding",
                    "Healthy foliage must be retained for future development",
                    "Good potential for deadwood where appropriate to the material",
                ]
            ),
            SpeciesProfileSection(
                id: "cultivars",
                title: "Cultivars and Forms",
                paragraphs: [
                    "Juniperus procumbens is the botanical baseline species for bonsai use.",
                    "Named cultivars such as Juniperus procumbens 'Green Mound' remain separate Species Library profiles where they have an established independent bonsai identity.",
                    "Cultivar-specific characteristics must not automatically be assigned to this species profile.",
                    "Do not create unnecessary separate Species Library profiles for minor individual variation.",
                    "The primary Species Profile remains Juniperus procumbens.",
                    "Only create separate profiles where a distinct cultivar or form has a clear and established independent bonsai identity.",
                ]
            ),
            SpeciesProfileSection(
                id: "natural-growth",
                title: "Natural Growth and Vigour",
                paragraphs: [
                    "Juniperus procumbens has moderate growth under good conditions.",
                    "Healthy growth depends on healthy roots, sufficient light, appropriate watering, well-aerated substrate and balanced nutrition.",
                    "During development: allow selected growth to extend where required for trunk development, branch thickening, foliage development or recovery.",
                    "Avoid repeatedly weakening the tree through excessive simultaneous work.",
                    "The objective is: Stable health · Useful growth · Progressive development.",
                ]
            ),
            SpeciesProfileSection(
                id: "foliage",
                title: "Foliage",
                paragraphs: [
                    "Juniperus procumbens develops compact evergreen foliage. Foliage type is primarily scale foliage.",
                    "Foliage is essential to future development.",
                    "Do not strip branches bare, remove all interior foliage, or assume bare old sections will reliably regenerate.",
                    "Foliage management should focus on selective shoot management, preservation of interior growth, balanced vigour and controlled density.",
                    "Avoid creating dense outer shells, empty interiors or overly uniform foliage pads.",
                    "The objective is: Healthy foliage · Visible structure · Controlled compactness.",
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
                    "Juniperus procumbens produces berry-like seed cones.",
                    "Seed cones may contribute to seasonal character but are not a primary bonsai design objective.",
                    "Do not sacrifice structural development or foliage health in pursuit of seed cones.",
                ]
            ),
            SpeciesProfileSection(
                id: "bark-trunk",
                title: "Bark and Trunk",
                paragraphs: [
                    "Juniperus procumbens can develop increasingly mature trunk character with age. Mature bark character is good.",
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
                    "Juniperus procumbens should be cultivated outdoors with strong access to light.",
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
                    "Pruning should focus on branch selection, shoot management, maintaining structure and maintaining compact proportions. Pruning response is moderate and requires preservation of useful foliage.",
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
                    "Back-budding must not be assumed on completely bare old wood.",
                    "Response depends on tree health, vigour, retained foliage, branch age, available buds and light.",
                    "When reducing branches: retain useful foliage, preserve interior shoots and maintain replacement options.",
                    "The objective is: Preserve future development before making irreversible cuts.",
                ]
            ),
            SpeciesProfileSection(
                id: "ramification",
                title: "Ramification",
                paragraphs: [
                    "Ramification potential is good.",
                    "Ramification can be developed through repeated healthy growth cycles, selective pruning, shoot selection, wiring and directional development.",
                    "Avoid repeated hedge-like trimming, removing all interior growth and maintaining only foliage at branch tips.",
                    "The objective is: Compact ramification · Healthy interior growth · Visible branch hierarchy.",
                ]
            ),
            SpeciesProfileSection(
                id: "wiring",
                title: "Wiring",
                paragraphs: [
                    "Wiring is one of the primary development tools for Juniperus procumbens. Wiring response is excellent.",
                    "It can be used for trunk movement, branch placement, foliage positioning and structural refinement.",
                    "Before major bends assess branch flexibility, branch thickness, wood age, health, living tissue and existing structural weaknesses.",
                    "Avoid forcing rigid material.",
                    "Monitor wire carefully.",
                    "The objective is: Natural movement · Safe positioning · Clear structure.",
                ]
            ),
            SpeciesProfileSection(
                id: "deadwood-potential",
                title: "Deadwood",
                paragraphs: [
                    "Deadwood can be used where appropriate to the material. Deadwood potential is good.",
                    "Potential features include jin, shari and natural dead branch remnants.",
                    "However, deadwood should follow believable natural logic, living tissue must be protected and excessive carving should be avoided.",
                    "The objective is: Natural character rather than artificial drama.",
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
                    "Juniperus procumbens develops trunk thickness gradually.",
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
                    "Juniperus procumbens may be propagated through established horticultural methods where appropriate.",
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
                    "Winter: Juniperus procumbens requires outdoor winter dormancy.",
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
                    "Juniperus procumbens is particularly suitable for Informal Upright, Slanting, Semi-cascade, Cascade, Root-over-rock, Naturalistic Bonsai and Shohin Bonsai.",
                    "It is especially effective when styling emphasises compact proportions, natural movement, layered foliage and visible branch structure.",
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
                    "Juniperus procumbens is an evergreen conifer native to Japan",
                    "Outdoor cultivation is required",
                    "Winter dormancy is required",
                    "The species profile is separate from Juniperus procumbens 'Green Mound'",
                    "Cultivar characteristics must not automatically be applied to the species",
                    "Healthy foliage must be retained where future growth is required",
                    "Do not strip branches bare",
                    "Do not assume old bare wood will reliably regenerate",
                    "Preserve useful interior foliage",
                    "Wiring is one of the primary development tools",
                    "Avoid repeated severe drought",
                    "Avoid permanently saturated roots",
                    "Avoid combining major root work with major styling work unnecessarily",
                    "Do not use defoliation techniques",
                    "Shallow roots require protection during prolonged severe freezing",
                    "Winter desiccation can be a significant risk in exposed conditions",
                ]
            ),
        ]
    }
}
