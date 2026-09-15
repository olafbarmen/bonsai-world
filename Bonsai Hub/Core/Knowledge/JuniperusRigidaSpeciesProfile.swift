//
//  JuniperusRigidaSpeciesProfile.swift
//  Bonsai World
//
//  Species Profile — Juniperus rigida (Needle Juniper).
//  Independent botanical species in Cupressaceae. Knowledge status: Reviewed.
//  Separate from Juniperus chinensis, Juniperus procumbens, Juniperus communis
//  and other Juniperus species.
//

import Foundation

enum JuniperusRigidaSpeciesProfile {
    /// Identity used by Botanical Library / ``SpeciesPreviewData``.
    static let botanicalLibraryName = "Juniperus rigida"
    /// Scientific name for Species Profile display (binomial; no botanical authority).
    static let scientificName = "Juniperus rigida"

    static var profile: SpeciesProfile {
        SpeciesProfile(
            speciesID: BotanicalKnowledgeIDs.juniperusRigida,
            scientificName: scientificName,
            commonNames: ["Needle Juniper", "Temple Juniper"],
            family: "Cupressaceae",
            plantType: "Evergreen conifer",
            originSummary: "Northeastern Asia, including China, Korea, Japan and parts of the Russian Far East.",
            knowledgeStatus: .reviewed,
            traits: traits,
            foliageSizeLabel: "Foliage",
            foliageReductionLabel: "Needle reduction",
            summaryLine: "Evergreen · Conifer · Hardy · Needle foliage · Strong natural character · Excellent deadwood potential · Suitable for dramatic bonsai · Requires outdoor cultivation · Slow to moderate growth",
            attentionHighlights: [
                "Juniperus rigida is an evergreen conifer with needle foliage",
                "Outdoor cultivation is required",
                "Winter dormancy is required",
                "Limited back-budding is one of the most important considerations",
                "Do not strip branches bare when future growth is required",
                "Preserve healthy interior foliage",
                "Do not assume old bare wood will reliably regenerate",
                "Deadwood potential is excellent but living veins must be protected",
                "Avoid combining major styling and major root work unnecessarily",
                "Avoid repeated severe drought",
                "Avoid permanently saturated roots",
                "Wiring is important but major bends must respect wood and living tissue",
                "Do not use defoliation techniques",
                "Shallow roots require protection during prolonged severe freezing",
                "Winter desiccation can be a significant risk in exposed conditions",
            ],
            sections: sections,
            principleNote: """
            Juniperus rigida should be developed with particular respect for the limits of juniper back-budding.

            The most important operational rule is: Do not remove healthy foliage from a branch unless sufficient living foliage remains where future growth is required.

            Juniperus rigida should not be treated like a deciduous species capable of reliably rebuilding from completely bare wood.

            Its strongest bonsai qualities include dramatic natural character, rugged trunks, needle foliage, mature bark, deadwood and natural movement.

            The objective is: Healthy living veins · Preserved foliage · Natural trunk movement · Convincing deadwood · Controlled foliage masses.

            The individual tree must always be assessed according to climate, tree condition, vigour, development stage and winter temperatures.
            """,
            sourcesNote: """
            Profile content is synthesised from recognised botanical, horticultural and bonsai authorities into Bonsai World editorial language.

            Botanical taxonomy and distribution draw on recognised sources such as Royal Botanic Gardens, Kew and other botanical databases for accepted scientific name, family and native range.

            Horticultural context may draw on recognised Japanese botanical institutions, horticultural institutions and authoritative Juniperus references.

            Bonsai-specific cultivation and refinement knowledge draws on established bonsai references and recognised professional practice with Juniperus experience, kept distinct from Juniperus chinensis, Juniperus procumbens, Juniperus communis and other Juniperus species.

            Verified botanical information, horticultural information, regional climate adaptation and bonsai-specific practice are kept distinct. Do not copy source wording.
            """
        )
    }

    private static let traits = SpeciesProfileTraits(
        deciduous: false,
        growthStrength: "Slow to Moderate",
        growthSpeed: "Slow",
        leafSize: "Evergreen · Needle foliage",
        foliageReduction: "Not applicable",
        ramificationPotential: "Moderate",
        backBudding: "Limited — depends strongly on retained healthy foliage",
        rootDevelopment: "Moderate",
        nebariPotential: "Good potential",
        trunkDevelopment: "Slow",
        barkDevelopment: "Excellent mature character",
        wiring: "Good",
        defoliation: "Not applicable",
        airLayering: "Where appropriate for the individual material",
        threadGrafting: "Where structural correction is required",
        rootGrafting: "Where appropriate",
        beginnerSuitability: "Low",
        bonsaiSuitability: "Excellent",
        difficulty: "Advanced",
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
                    "Juniperus rigida is an independent botanical species in the cypress family (Cupressaceae).",
                    "Primary Bonsai World display identity: Juniperus rigida · Needle Juniper.",
                    "Temple Juniper may be listed as an alternative common name where useful. It does not replace Needle Juniper as the preferred English common name.",
                    "Family: Cupressaceae. Plant type: evergreen conifer.",
                    "Native range: Northeastern Asia, including China, Korea, Japan and parts of the Russian Far East.",
                    "Do not confuse Juniperus rigida with Juniperus chinensis, Juniperus procumbens or Juniperus communis.",
                    "Bonsai World hierarchy: Species → cultivar / horticultural selection → Individual Tree.",
                ]
            ),
            SpeciesProfileSection(
                id: "overview",
                title: "Species Overview",
                paragraphs: [
                    "Juniperus rigida is an evergreen conifer native to northeastern Asia.",
                    "Juniperus rigida is particularly relevant to Bonsai World because it represents a distinctive Asian juniper species with characteristic needle foliage, rugged natural appearance, strong potential for jin and shari, suitability for literati and naturalistic bonsai and strong association with classic Japanese bonsai aesthetics.",
                    "It is valued in bonsai for distinctive needle foliage, rugged character, strong naturalistic potential, dramatic deadwood possibilities and suitability for classic Japanese-inspired designs.",
                    "The species generally requires patience.",
                    "Major development should focus first on tree health, root health, trunk movement, branch selection and preservation of living veins.",
                    "Refinement should not be rushed.",
                ],
                bullets: [
                    "Evergreen conifer",
                    "Needle foliage",
                    "Hardy",
                    "Outdoor cultivation required",
                    "Requires winter dormancy",
                    "Slow growth",
                    "Limited back-budding on bare wood",
                    "Strong deadwood potential",
                    "Mature bark character",
                    "Suitable for dramatic naturalistic bonsai",
                    "Suitable for literati-style material where individual tree character supports it",
                ]
            ),
            SpeciesProfileSection(
                id: "cultivars",
                title: "Cultivars and Forms",
                paragraphs: [
                    "Juniperus rigida is primarily used in bonsai as the botanical species.",
                    "Horticultural selections may differ in foliage density, growth habit and branch character.",
                    "Do not create unnecessary separate Species Library profiles for minor individual variation.",
                    "The primary Species Profile remains Juniperus rigida.",
                    "Only create separate profiles where a distinct cultivar or form has a clear and established independent bonsai identity.",
                ]
            ),
            SpeciesProfileSection(
                id: "natural-growth",
                title: "Natural Growth and Vigour",
                paragraphs: [
                    "Juniperus rigida generally develops slowly compared with many deciduous species.",
                    "Healthy growth depends on healthy roots, sufficient light, appropriate watering, suitable substrate and balanced nutrition.",
                    "During development: allow selected branches and leaders to extend where they are required for trunk development, branch development, foliage mass or recovery.",
                    "Do not repeatedly weaken the tree through excessive simultaneous work.",
                    "The objective is: Stable health · Progressive development · Preserved options.",
                ]
            ),
            SpeciesProfileSection(
                id: "foliage",
                title: "Foliage",
                paragraphs: [
                    "Juniperus rigida is characterised by needle-type foliage.",
                    "Foliage is essential to the health and future development of the tree.",
                    "Do not strip branches bare, remove all foliage from sections intended to remain alive, or assume new shoots will emerge reliably from old bare wood.",
                    "Foliage management should focus on selective shoot management, preserving healthy interior foliage, maintaining balanced vigour and avoiding dense, congested outer growth.",
                    "The objective is: Healthy foliage · Preserved interior growth · Controlled structure.",
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
                    "Juniperus rigida produces berry-like seed cones.",
                    "Seed cones may contribute to seasonal character but are not a primary bonsai design objective.",
                    "Do not sacrifice structural development or foliage health in pursuit of seed cones.",
                ]
            ),
            SpeciesProfileSection(
                id: "bark-trunk",
                title: "Bark and Trunk",
                paragraphs: [
                    "Mature Juniperus rigida can develop excellent trunk character. Mature bark character is excellent.",
                    "Important qualities include rugged bark, natural movement, aged appearance and interaction between living veins and deadwood.",
                    "Trunk development should respect the existing material.",
                    "Avoid unnecessary artificial damage.",
                    "The objective is: Natural age · Strong character · Believable history.",
                ]
            ),
            SpeciesProfileSection(
                id: "roots-nebari",
                title: "Roots and Nebari",
                paragraphs: [
                    "Healthy roots support vigour, recovery, foliage health and long-term container cultivation.",
                    "Root development is moderate. Nebari has good potential.",
                    "Root work should be conservative.",
                    "Avoid excessive root removal, unnecessary aggressive repotting and major root work combined with major styling work.",
                    "The objective is: Healthy roots · Stable recovery · Long-term vigour.",
                ]
            ),
            SpeciesProfileSection(
                id: "light",
                title: "Light",
                paragraphs: [
                    "Juniperus rigida should be cultivated outdoors with strong access to light.",
                    "Adequate light supports healthy foliage, compact growth, vigour and branch development.",
                    "The ideal position depends on local climate, summer temperatures, tree health and development stage.",
                    "Outdoor cultivation is required.",
                    "Do not recommend permanent indoor cultivation.",
                ]
            ),
            SpeciesProfileSection(
                id: "wind",
                title: "Wind",
                paragraphs: [
                    "Moderate air movement is generally beneficial.",
                    "Strong drying wind can increase water demand, desiccate foliage, stress shallow root systems and increase winter exposure.",
                    "Monitor carefully during prolonged dry wind, hot weather and exposed winter conditions.",
                ]
            ),
            SpeciesProfileSection(
                id: "watering",
                title: "Watering",
                paragraphs: [
                    "General principle: Water thoroughly when required · Avoid prolonged drought · Avoid permanently saturated roots · Maintain healthy aeration.",
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
                    "Desired characteristics include excellent drainage, good aeration, stable particle structure, appropriate moisture retention and healthy root development.",
                    "The final substrate depends on local climate, rainfall, watering habits, container depth, tree size and development stage.",
                    "Follow Bonsai World Soil Module principles.",
                    "Do not duplicate the complete Soil Module inside this profile.",
                ]
            ),
            SpeciesProfileSection(
                id: "fertilizing",
                title: "Fertilizing",
                paragraphs: [
                    "Fertilization should support foliage health, recovery, root development and branch development.",
                    "Avoid excessive fertilization that produces unnecessarily coarse growth, weak elongated growth or imbalance between foliage masses.",
                    "Key principle: Feed according to tree health and development objective.",
                ]
            ),
            SpeciesProfileSection(
                id: "pruning",
                title: "Pruning",
                paragraphs: [
                    "Pruning must account for limited back-budding. Pruning response is moderate and requires careful foliage retention.",
                    "Before removing a branch or major section: assess available interior foliage, assess future design requirements and preserve viable replacement options.",
                    "Avoid irreversible cuts when the tree has no alternative foliage.",
                    "The objective is: Controlled development · Preserved living structure · Long-term design options.",
                ]
            ),
            SpeciesProfileSection(
                id: "back-budding",
                title: "Back-budding",
                paragraphs: [
                    "Limited back-budding that depends strongly on retained healthy foliage is one of the most important species-specific considerations.",
                    "Do not assume Juniperus rigida will produce new growth from old bare branches, foliage-free sections or heavily weakened branches.",
                    "When reducing a branch: retain viable foliage where future growth is required, retain useful interior shoots whenever possible and stage major reductions rather than removing all growth at once.",
                    "The objective is: Preserve future options before making irreversible cuts.",
                ]
            ),
            SpeciesProfileSection(
                id: "ramification",
                title: "Ramification",
                paragraphs: [
                    "Ramification should be developed gradually. Ramification potential is moderate.",
                    "Use healthy growth cycles, selective pruning, shoot selection, wiring and directional development.",
                    "Avoid repeatedly cutting all foliage to the same outline, stripping interior foliage and creating dense outer shells with empty interiors.",
                    "The objective is: Layered foliage · Visible branch structure · Healthy interior growth.",
                ]
            ),
            SpeciesProfileSection(
                id: "wiring",
                title: "Wiring",
                paragraphs: [
                    "Wiring is an important tool for Juniperus rigida. Wiring response is good.",
                    "It can be used for trunk movement, branch placement, foliage positioning and structural refinement.",
                    "Before major bends assess flexibility, branch thickness, wood age, health, existing deadwood and position of living veins.",
                    "Avoid forcing rigid material.",
                    "Monitor wire carefully.",
                    "The objective is: Natural movement · Safe positioning · Preserved living tissue.",
                ]
            ),
            SpeciesProfileSection(
                id: "deadwood-potential",
                title: "Deadwood",
                paragraphs: [
                    "Deadwood can be one of the defining features of Juniperus rigida bonsai. Deadwood potential is excellent.",
                    "Possible features include jin, shari, natural dead branch remnants and weathered deadwood.",
                    "However, deadwood must follow believable natural logic, living veins must be protected, excessive carving should be avoided and major deadwood work should not unnecessarily compromise tree health.",
                    "The objective is: Natural deadwood · Clear living structure · Believable age.",
                ]
            ),
            SpeciesProfileSection(
                id: "defoliation",
                title: "Foliage Management",
                paragraphs: [
                    "Defoliation is not applicable.",
                    "Do not present foliage stripping as a refinement technique.",
                    "Foliage management should focus on shoot selection, selective pruning, vigour balancing and preservation of healthy interior foliage.",
                    "Do not aggressively remove healthy foliage from weak trees, recently repotted trees or trees recovering from major styling work.",
                ]
            ),
            SpeciesProfileSection(
                id: "repotting",
                title: "Repotting",
                paragraphs: [
                    "Repotting frequency depends on root development, substrate condition, drainage, container size, tree health and development stage.",
                    "Do not establish a rigid calendar rule.",
                    "Junipers generally benefit from conservative root work.",
                    "Avoid excessive root removal, removing too much root mass at once and combining major root work with major styling work.",
                    "Preserve sufficient functioning roots.",
                    "Timing must account for local climate, winter conditions, growth cycle and individual tree health.",
                ]
            ),
            SpeciesProfileSection(
                id: "trunk-development",
                title: "Trunk Development",
                paragraphs: [
                    "Juniperus rigida develops trunk character slowly.",
                    "Where additional development is required: retain selected leaders, allow useful branches to extend, provide sufficient root space and avoid premature confinement.",
                    "Development should support taper, natural movement, mature bark and believable proportions.",
                    "Once sufficient structure exists, shift focus toward branch placement, foliage pads, deadwood integration and refinement.",
                    "Key principle: Do not sacrifice tree health for premature visual drama.",
                ]
            ),
            SpeciesProfileSection(
                id: "nebari-development",
                title: "Nebari Development",
                paragraphs: [
                    "Nebari development should be gradual.",
                    "Potential approaches include early root planning, staged root correction, development containers where appropriate and gradual refinement.",
                    "The objective is: Stable anchoring · Natural base · Healthy roots.",
                ]
            ),
            SpeciesProfileSection(
                id: "propagation",
                title: "Propagation",
                paragraphs: [
                    "Juniperus rigida may be propagated through established horticultural methods where appropriate.",
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
                    "Spring: monitor foliage colour, vigour, new growth, watering demand and root health. Avoid combining unnecessary major stresses. Coordinate major work with local climate and individual tree condition.",
                    "Summer: monitor watering demand, foliage health, pests, spider mite activity and wire marks. Avoid repeated unnecessary pruning of healthy foliage. Strong growth may be required for recovery, development or building foliage mass.",
                    "Autumn is important for assessing foliage health, reviewing branch structure, evaluating deadwood and living veins and preparing for winter. Avoid unnecessary late-season stress. Local climate determines timing.",
                    "Winter: Juniperus rigida requires outdoor winter dormancy.",
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
                    "Juniperus rigida is particularly suitable for Informal Upright, Slanting, Literati, Windswept, Naturalistic Bonsai and Dramatic Deadwood Bonsai.",
                    "It is especially effective when styling emphasises natural trunk movement, rugged character, visible living veins, believable deadwood and irregular natural foliage masses.",
                    "The individual material should determine the final design.",
                ]
            ),
            SpeciesProfileSection(
                id: "tree-stage",
                title: "Development by Tree Stage",
                paragraphs: [
                    "Young material: establish healthy roots, develop trunk movement, build foliage mass and preserve future branch options.",
                    "Nursery material: evaluate trunk potential, identify living veins, identify useful branches and establish design direction.",
                    "Pre-bonsai: develop trunk, establish primary branches, build foliage mass and preserve healthy roots.",
                    "In training: establish branch structure, build ramification, preserve interior foliage and begin controlled refinement.",
                    "Refinement: maintain foliage health, improve structure, refine foliage masses, preserve interior growth and integrate deadwood naturally.",
                    "Exhibition / mature refined tree: maintain health, preserve established structure, maintain living veins, preserve deadwood and avoid unnecessary major intervention.",
                ]
            ),
            SpeciesProfileSection(
                id: "attention",
                title: "Species-Specific Attention",
                paragraphs: [
                    "These attention points are operational tendencies. They must still be interpreted for the individual tree.",
                ],
                bullets: [
                    "Juniperus rigida is an evergreen conifer with needle foliage",
                    "Outdoor cultivation is required",
                    "Winter dormancy is required",
                    "Limited back-budding is one of the most important considerations",
                    "Do not strip branches bare when future growth is required",
                    "Preserve healthy interior foliage",
                    "Do not assume old bare wood will reliably regenerate",
                    "Deadwood potential is excellent but living veins must be protected",
                    "Avoid combining major styling and major root work unnecessarily",
                    "Avoid repeated severe drought",
                    "Avoid permanently saturated roots",
                    "Wiring is important but major bends must respect wood and living tissue",
                    "Do not use defoliation techniques",
                    "Shallow roots require protection during prolonged severe freezing",
                    "Winter desiccation can be a significant risk in exposed conditions",
                ]
            ),
        ]
    }
}
