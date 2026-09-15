//
//  JuniperusSabinaSpeciesProfile.swift
//  Bonsai World
//
//  Species Profile — Juniperus sabina (Savin Juniper).
//  Independent botanical species in Cupressaceae. Knowledge status: Reviewed.
//  Separate from Juniperus chinensis, Juniperus rigida, Juniperus procumbens
//  and other Juniperus species.
//

import Foundation

enum JuniperusSabinaSpeciesProfile {
    /// Identity used by Botanical Library / ``SpeciesPreviewData``.
    static let botanicalLibraryName = "Juniperus sabina"
    /// Scientific name for Species Profile display (binomial; no botanical authority).
    static let scientificName = "Juniperus sabina"

    static var profile: SpeciesProfile {
        SpeciesProfile(
            speciesID: BotanicalKnowledgeIDs.juniperusSabina,
            scientificName: scientificName,
            commonNames: ["Savin Juniper", "Savin"],
            family: "Cupressaceae",
            plantType: "Evergreen conifer",
            originSummary: "Europe, western and central Asia, extending across mountainous and continental regions.",
            knowledgeStatus: .reviewed,
            traits: traits,
            foliageSizeLabel: "Foliage",
            foliageReductionLabel: "Foliage reduction",
            summaryLine: "Evergreen · Conifer · Hardy · Scale and juvenile foliage · Low-growing natural habit · Strong deadwood potential · Naturalistic character · Suitable for dramatic bonsai · Requires outdoor cultivation",
            attentionHighlights: [
                "Juniperus sabina is an evergreen conifer",
                "Outdoor cultivation is required",
                "Winter dormancy is required",
                "Healthy foliage must be preserved where future growth is required",
                "Do not strip branches bare",
                "Do not assume old bare wood will reliably regenerate",
                "Preserve useful interior foliage",
                "Deadwood potential is excellent but living tissue must be protected",
                "Avoid combining major styling and major root work unnecessarily",
                "Avoid repeated severe drought",
                "Avoid permanently saturated roots",
                "Wiring is important but major bends must respect branch flexibility and living tissue",
                "Do not use defoliation techniques",
                "Shallow roots require protection during prolonged severe freezing",
                "Winter desiccation can be a significant risk in exposed conditions",
            ],
            sections: sections,
            principleNote: """
            Juniperus sabina must be developed with respect for its dependence on healthy living foliage.

            The most important operational rule is: Do not remove healthy foliage from a branch or section unless sufficient living foliage remains where future growth is required.

            Juniperus sabina should not be treated like a deciduous tree that can reliably rebuild from old bare wood.

            Its strongest bonsai qualities include rugged natural movement, mature bark, dramatic deadwood, irregular living veins and compact evergreen foliage masses.

            The objective is: Healthy roots · Preserved living foliage · Natural trunk movement · Convincing deadwood · Balanced foliage masses.

            The individual tree must always be assessed according to climate, tree condition, vigour, development stage and winter temperatures.
            """,
            sourcesNote: """
            Profile content is synthesised from recognised botanical, horticultural and bonsai authorities into Bonsai World editorial language.

            Botanical taxonomy and distribution draw on recognised sources such as Royal Botanic Gardens, Kew, Plants of the World Online and recognised European botanical institutions for accepted scientific name, family and native range.

            Horticultural context may draw on recognised horticultural institutions and authoritative Juniperus references.

            Bonsai-specific cultivation and refinement knowledge draws on established bonsai references and recognised professional practice with Juniperus experience, kept distinct from Juniperus chinensis, Juniperus rigida, Juniperus procumbens and other Juniperus species.

            Verified botanical information, horticultural information, regional climate adaptation and bonsai-specific practice are kept distinct. Do not copy source wording.
            """
        )
    }

    private static let traits = SpeciesProfileTraits(
        deciduous: false,
        growthStrength: "Moderate",
        growthSpeed: "Slow to Moderate",
        leafSize: "Evergreen · Scale foliage with potential juvenile foliage",
        foliageReduction: "Not applicable",
        ramificationPotential: "Good",
        backBudding: "Limited to Moderate — strongly dependent on retained healthy foliage",
        rootDevelopment: "Moderate",
        nebariPotential: "Good potential",
        trunkDevelopment: "Slow to Moderate",
        barkDevelopment: "Excellent mature character",
        wiring: "Good",
        defoliation: "Not applicable",
        airLayering: "Where appropriate for the individual material",
        threadGrafting: "Where structural correction is required",
        rootGrafting: "Where appropriate",
        beginnerSuitability: "Moderate",
        bonsaiSuitability: "Excellent",
        difficulty: "Intermediate to Advanced",
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
                    "Juniperus sabina is an independent botanical species in the cypress family (Cupressaceae).",
                    "Primary Bonsai World display identity: Juniperus sabina · Savin Juniper.",
                    "Savin may be listed as an alternative common name where useful. It does not replace Savin Juniper as the preferred English common name.",
                    "Family: Cupressaceae. Plant type: evergreen conifer.",
                    "Native range: Europe, western and central Asia, extending across mountainous and continental regions.",
                    "Do not confuse Juniperus sabina with Juniperus chinensis, Juniperus rigida or Juniperus procumbens.",
                    "Bonsai World hierarchy: Species → cultivar / horticultural selection → Individual Tree.",
                ]
            ),
            SpeciesProfileSection(
                id: "overview",
                title: "Species Overview",
                paragraphs: [
                    "Juniperus sabina is an evergreen juniper with a broad natural distribution across Europe and Asia.",
                    "It is especially associated with dry or well-drained environments, mountainous landscapes, continental climates and rugged natural forms.",
                    "Juniperus sabina is particularly relevant to Bonsai World because it offers strong natural character, rugged growth habit, excellent potential for deadwood, suitability for naturalistic bonsai, suitability for dramatic yamadori-style material and strong adaptation to continental and mountainous climates.",
                    "For bonsai, the species is valued for natural movement, aged appearance, deadwood potential and adaptability to naturalistic designs.",
                    "Development should prioritise tree health, root stability, trunk character, branch selection and preservation of living foliage.",
                    "Refinement should be gradual.",
                ],
                bullets: [
                    "Evergreen conifer",
                    "Hardy",
                    "Outdoor cultivation required",
                    "Requires winter dormancy",
                    "Scale foliage",
                    "May produce juvenile foliage depending on growth and stress",
                    "Limited to moderate back-budding",
                    "Strong dependence on retained foliage",
                    "Excellent deadwood potential",
                    "Strong naturalistic character",
                    "Suitable for rugged and natural designs",
                    "Slow to moderate growth",
                ]
            ),
            SpeciesProfileSection(
                id: "cultivars",
                title: "Cultivars and Forms",
                paragraphs: [
                    "Juniperus sabina is primarily used in bonsai as the botanical species.",
                    "Horticultural selections may differ in foliage density, growth habit and branch character.",
                    "Cultivars must not be merged into this species profile unless Bonsai World has explicitly created a separate cultivar profile.",
                    "Do not create unnecessary separate Species Library profiles for minor individual variation.",
                    "The primary Species Profile remains Juniperus sabina.",
                    "Only create separate profiles where a distinct cultivar or form has a clear and established independent bonsai identity.",
                ]
            ),
            SpeciesProfileSection(
                id: "natural-growth",
                title: "Natural Growth and Vigour",
                paragraphs: [
                    "Juniperus sabina generally develops at a moderate pace.",
                    "Healthy growth depends on healthy roots, adequate light, appropriate watering, well-aerated substrate and balanced nutrition.",
                    "During development: allow selected branches and leaders to extend where they are required for trunk development, branch thickening, foliage development or recovery.",
                    "Avoid repeated unnecessary stress.",
                    "Do not combine multiple major operations unless the tree is exceptionally healthy and the work is clearly justified.",
                    "The objective is: Stable health · Progressive development · Preservation of future options.",
                ]
            ),
            SpeciesProfileSection(
                id: "foliage",
                title: "Foliage",
                paragraphs: [
                    "Juniperus sabina may display scale foliage and, depending on growth conditions and vigour, juvenile foliage.",
                    "Foliage is essential to future development.",
                    "Do not strip branches bare, remove all foliage from sections intended to remain alive, or assume new growth will reliably emerge from old bare wood.",
                    "Foliage management should focus on selective shoot management, preservation of useful interior foliage, maintaining balanced vigour and avoiding dense outer foliage shells.",
                    "The objective is: Healthy foliage · Useful interior growth · Controlled structure.",
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
                    "Juniperus sabina produces berry-like seed cones.",
                    "Seed cones may contribute to seasonal character but are not a primary bonsai design objective.",
                    "Do not sacrifice structural development or foliage health in pursuit of seed cones.",
                ]
            ),
            SpeciesProfileSection(
                id: "bark-trunk",
                title: "Bark and Trunk",
                paragraphs: [
                    "Juniperus sabina can develop excellent mature character. Mature bark character is excellent.",
                    "Important qualities include rugged bark, natural movement, aged appearance and interaction between living tissue and deadwood.",
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
                    "Avoid excessive root removal, unnecessary aggressive repotting and combining major root work with major styling work.",
                    "The objective is: Healthy roots · Stable recovery · Long-term vigour.",
                ]
            ),
            SpeciesProfileSection(
                id: "light",
                title: "Light",
                paragraphs: [
                    "Juniperus sabina should be cultivated outdoors with strong access to light.",
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
                    "Moderate air movement is beneficial.",
                    "Strong drying wind can increase water demand, desiccate foliage, stress shallow root systems and increase winter exposure.",
                    "Monitor carefully during prolonged dry wind, hot weather and exposed winter conditions.",
                ]
            ),
            SpeciesProfileSection(
                id: "watering",
                title: "Watering",
                paragraphs: [
                    "General principle: Water thoroughly when required · Avoid prolonged severe drought · Avoid permanently saturated roots · Maintain healthy root aeration.",
                    "Water demand is low to moderate once established, depending on conditions.",
                    "Juniperus sabina is generally more tolerant of dry conditions than many broadleaf deciduous species, but bonsai cultivation in shallow containers changes water requirements significantly.",
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
                    "Pruning must account for the species' limited ability to reliably regenerate from bare old wood. Pruning response is moderate and requires careful foliage retention.",
                    "Before removing a major branch, a large foliage mass or a structural section, assess retained foliage, replacement options, interior growth and future design requirements.",
                    "Avoid irreversible cuts where no viable replacement exists.",
                    "The objective is: Controlled development · Preserved living structure · Long-term design options.",
                ]
            ),
            SpeciesProfileSection(
                id: "back-budding",
                title: "Back-budding",
                paragraphs: [
                    "Back-budding is limited to moderate and strongly dependent on retained healthy foliage.",
                    "Back-budding should not be assumed.",
                    "Response depends on tree health, vigour, retained foliage, branch condition and light.",
                    "When reducing branches: retain viable foliage, preserve useful interior shoots, avoid removing all future growth options and stage major reductions where necessary.",
                    "The objective is: Preserve future growth before making irreversible cuts.",
                ]
            ),
            SpeciesProfileSection(
                id: "ramification",
                title: "Ramification",
                paragraphs: [
                    "Ramification should be developed gradually. Ramification potential is good.",
                    "Develop through healthy growth cycles, selective shoot management, pruning, wiring and directional development.",
                    "Avoid repeatedly trimming all foliage to the same outline, stripping useful interior growth and creating a dense outer shell with empty interiors.",
                    "The objective is: Layered foliage · Visible structure · Healthy interior growth.",
                ]
            ),
            SpeciesProfileSection(
                id: "wiring",
                title: "Wiring",
                paragraphs: [
                    "Wiring is an important structural tool. Wiring response is good.",
                    "It can be used for trunk movement, branch placement, foliage positioning and structural refinement.",
                    "Before major bends assess flexibility, branch thickness, wood age, health, existing deadwood and living tissue.",
                    "Avoid forcing rigid material.",
                    "Monitor wire carefully.",
                    "The objective is: Natural movement · Safe positioning · Preserved living tissue.",
                ]
            ),
            SpeciesProfileSection(
                id: "deadwood-potential",
                title: "Deadwood",
                paragraphs: [
                    "Deadwood can be one of the defining characteristics of Juniperus sabina bonsai. Deadwood potential is excellent.",
                    "Possible features include jin, shari, natural dead branches and weathered trunk sections.",
                    "However, deadwood should follow believable natural logic, living tissue must be protected, excessive carving should be avoided and major deadwood work should not compromise tree health.",
                    "The objective is: Natural deadwood · Clear living structure · Believable age.",
                ]
            ),
            SpeciesProfileSection(
                id: "defoliation",
                title: "Foliage Management",
                paragraphs: [
                    "Defoliation is not applicable.",
                    "Do not present foliage stripping as a refinement technique.",
                    "Foliage management should focus on selective shoot management, controlled pruning, vigour balancing and preservation of useful interior foliage.",
                    "Do not aggressively remove healthy foliage from weak trees, stressed trees, recently repotted trees or trees recovering from major styling work.",
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
                    "Preserve sufficient healthy roots.",
                    "Timing must account for local climate, winter conditions, growth cycle and individual tree health.",
                ]
            ),
            SpeciesProfileSection(
                id: "trunk-development",
                title: "Trunk Development",
                paragraphs: [
                    "Juniperus sabina develops mature trunk character gradually.",
                    "Where additional development is required: retain selected leaders, allow useful branches to extend, provide sufficient root space and avoid premature confinement.",
                    "Development should support taper, natural movement, mature bark and believable proportions.",
                    "Once sufficient structure exists, shift focus toward branch placement, foliage development, deadwood integration and refinement.",
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
                    "Juniperus sabina may be propagated through established horticultural methods where appropriate.",
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
                    "Summer: monitor watering demand, foliage health, pest activity, spider mites and wire marks. Avoid repeated unnecessary pruning of healthy foliage. Strong growth may be required for recovery, development or building foliage mass.",
                    "Autumn is important for assessing foliage health, reviewing branch structure, evaluating deadwood and living tissue and preparing for winter. Avoid unnecessary late-season stress. Local climate determines timing.",
                    "Winter: Juniperus sabina requires outdoor winter dormancy.",
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
                    "Juniperus sabina is particularly suitable for Informal Upright, Slanting, Semi-cascade, Cascade, Naturalistic Bonsai, Windswept and Dramatic Deadwood Bonsai.",
                    "It is especially effective when styling emphasises rugged natural movement, irregular living lines, believable deadwood, compact foliage masses and natural asymmetry.",
                    "The individual material should determine the final design.",
                ]
            ),
            SpeciesProfileSection(
                id: "tree-stage",
                title: "Development by Tree Stage",
                paragraphs: [
                    "Young material: establish healthy roots, develop trunk movement, build foliage mass and preserve future branch options.",
                    "Nursery material: evaluate trunk potential, identify living structure, identify useful branches and establish design direction.",
                    "Pre-bonsai: develop trunk, establish primary branches, build foliage mass and preserve healthy roots.",
                    "In training: establish branch structure, build ramification, preserve interior foliage and begin controlled refinement.",
                    "Refinement: maintain foliage health, improve structure, refine foliage masses, preserve interior growth and integrate deadwood naturally.",
                    "Exhibition / mature refined tree: maintain health, preserve established structure, preserve living tissue, preserve deadwood and avoid unnecessary major intervention.",
                ]
            ),
            SpeciesProfileSection(
                id: "attention",
                title: "Species-Specific Attention",
                paragraphs: [
                    "These attention points are operational tendencies. They must still be interpreted for the individual tree.",
                ],
                bullets: [
                    "Juniperus sabina is an evergreen conifer",
                    "Outdoor cultivation is required",
                    "Winter dormancy is required",
                    "Healthy foliage must be preserved where future growth is required",
                    "Do not strip branches bare",
                    "Do not assume old bare wood will reliably regenerate",
                    "Preserve useful interior foliage",
                    "Deadwood potential is excellent but living tissue must be protected",
                    "Avoid combining major styling and major root work unnecessarily",
                    "Avoid repeated severe drought",
                    "Avoid permanently saturated roots",
                    "Wiring is important but major bends must respect branch flexibility and living tissue",
                    "Do not use defoliation techniques",
                    "Shallow roots require protection during prolonged severe freezing",
                    "Winter desiccation can be a significant risk in exposed conditions",
                ]
            ),
        ]
    }
}
