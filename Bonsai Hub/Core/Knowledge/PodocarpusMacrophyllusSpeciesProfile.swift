//
//  PodocarpusMacrophyllusSpeciesProfile.swift
//  Bonsai World
//
//  Species Profile — Podocarpus macrophyllus (Buddhist Pine).
//  Independent botanical species in Podocarpaceae. Knowledge status: Reviewed.
//  Separate from Taxus species and true pines in the genus Pinus.
//

import Foundation

enum PodocarpusMacrophyllusSpeciesProfile {
    /// Identity used by Botanical Library / ``SpeciesPreviewData``.
    static let botanicalLibraryName = "Podocarpus macrophyllus"
    /// Scientific name for Species Profile display (binomial; no botanical authority).
    static let scientificName = "Podocarpus macrophyllus"

    static var profile: SpeciesProfile {
        SpeciesProfile(
            speciesID: BotanicalKnowledgeIDs.podocarpusMacrophyllus,
            scientificName: scientificName,
            commonNames: ["Buddhist Pine", "Japanese Yew", "Yew Podocarpus"],
            family: "Podocarpaceae",
            plantType: "Evergreen broadleaf-like conifer",
            originSummary: "East Asia.",
            knowledgeStatus: .reviewed,
            traits: traits,
            foliageSizeLabel: "Foliage",
            foliageReductionLabel: "Foliage management",
            summaryLine: "Evergreen · Long narrow foliage · Dense growth · Strong pruning response · Good ramification · Excellent bonsai potential · Attractive mature bark · Long-lived · Strong formal and naturalistic styling potential",
            attentionHighlights: [
                "Podocarpus macrophyllus is an evergreen conifer",
                "It is not a true pine",
                "It is not a true yew",
                "Strong pruning response is one of its major bonsai strengths",
                "Back-budding depends on tree health and vigour",
                "Preserve useful interior foliage",
                "Dense outer foliage must not be allowed to weaken internal structure",
                "Do not use deciduous defoliation techniques as routine management",
                "Young branches are more suitable for wiring than older rigid branches",
                "Monitor wire carefully",
                "Avoid permanently saturated roots",
                "Avoid repeated severe drying",
                "Cold tolerance depends strongly on local conditions",
                "Shallow bonsai roots are vulnerable during prolonged severe freezing",
                "Outdoor cultivation is preferred",
            ],
            sections: sections,
            principleNote: """
            Podocarpus macrophyllus is an evergreen conifer with a very different growth habit from Pinus and other common temperate bonsai conifers.

            Its greatest bonsai strengths include evergreen foliage, strong response to pruning, good back-budding, dense ramification and adaptability to bonsai cultivation.

            The species can be developed into formal bonsai, informal upright bonsai, naturalistic bonsai and refined evergreen bonsai.

            The objective is: Healthy foliage · Strong branch structure · Controlled ramification · Natural proportions.

            Do not treat the foliage as if it were pine needles.

            The individual tree must always be assessed according to climate, tree condition, vigour, development stage and winter temperatures.
            """,
            sourcesNote: """
            Profile content is synthesised from recognised botanical, horticultural and bonsai authorities into Bonsai World editorial language.

            Botanical taxonomy and distribution draw on recognised sources such as Royal Botanic Gardens, Kew and other botanical databases for accepted scientific name, family and native range.

            Horticultural context may draw on recognised botanical gardens and arboreta, horticultural institutions and authoritative Podocarpaceae references.

            Bonsai-specific cultivation and refinement knowledge draws on established bonsai references and recognised professional practice with Podocarpus experience, kept distinct from Taxus species and true pines in the genus Pinus.

            Verified botanical information, horticultural information, regional climate adaptation and bonsai-specific practice are kept distinct. Do not copy source wording.
            """
        )
    }

    private static let traits = SpeciesProfileTraits(
        deciduous: false,
        growthStrength: "Moderate",
        growthSpeed: "Moderate",
        leafSize: "Evergreen · Long narrow leaves",
        foliageReduction: "Not applicable as routine management",
        ramificationPotential: "Good",
        backBudding: "Good under healthy conditions",
        rootDevelopment: "Good",
        nebariPotential: "Good potential",
        trunkDevelopment: "Moderate",
        barkDevelopment: "Good mature character",
        wiring: "Good",
        defoliation: "Not applicable as routine management",
        airLayering: "Where appropriate for the individual material",
        threadGrafting: "Where structural correction is required",
        rootGrafting: "Where appropriate",
        beginnerSuitability: "Good",
        bonsaiSuitability: "Excellent",
        difficulty: "Beginner to Intermediate",
        winterDormancyRequired: false,
        winterHardiness: "Reduced seasonal growth rather than a strong temperate dormancy",
        rootFrostSensitivity: "Moderate to High in prolonged or severe freezing, especially in shallow bonsai containers"
    )

    private static var sections: [SpeciesProfileSection] {
        [
            SpeciesProfileSection(
                id: "taxonomic-context",
                title: "Taxonomic Context",
                paragraphs: [
                    "Podocarpus macrophyllus is an independent botanical species in the podocarp family (Podocarpaceae).",
                    "Primary Bonsai World display identity: Podocarpus macrophyllus · Buddhist Pine.",
                    "Japanese Yew and Yew Podocarpus may be used as supporting terminology. They do not replace Buddhist Pine as the primary common name.",
                    "Family: Podocarpaceae. Plant type: evergreen broadleaf-like conifer.",
                    "Native range: East Asia.",
                    "Do not describe Podocarpus macrophyllus as a true pine.",
                    "Do not describe it as a true yew.",
                    "Do not confuse it with Taxus species, despite the alternative common name Japanese Yew.",
                    "Do not confuse it with true pines in the genus Pinus.",
                    "Bonsai World hierarchy: Species → cultivar / horticultural selection → Individual Tree.",
                ]
            ),
            SpeciesProfileSection(
                id: "overview",
                title: "Species Overview",
                paragraphs: [
                    "Podocarpus macrophyllus is an evergreen conifer native to East Asia.",
                    "It belongs to the Podocarpaceae family.",
                    "The species is valued for bonsai because of evergreen foliage, narrow leaves, good pruning response, useful back-budding potential, dense branching, attractive mature trunks and adaptability to container cultivation.",
                    "It is often used for bonsai because it can tolerate repeated refinement when maintained in good health.",
                    "However: do not confuse tolerance for pruning with unlimited tolerance for repeated heavy work.",
                    "Healthy foliage and roots remain essential.",
                ],
                bullets: [
                    "Evergreen conifer",
                    "Member of Podocarpaceae",
                    "Not a true pine",
                    "Not a true yew",
                    "Long narrow foliage",
                    "Moderate growth",
                    "Good ramification potential",
                    "Good back-budding under healthy conditions",
                    "Strong response to controlled pruning",
                    "Attractive mature trunk character",
                    "Suitable for refined bonsai",
                    "Outdoor cultivation is preferred",
                    "Cold protection may be required in severe climates",
                    "Shallow bonsai roots are vulnerable to prolonged freezing",
                ]
            ),
            SpeciesProfileSection(
                id: "cultivars",
                title: "Cultivars and Forms",
                paragraphs: [
                    "Podocarpus macrophyllus has horticultural cultivars and selected forms.",
                    "These may differ in foliage size, foliage colour, growth habit, vigour and branching density.",
                    "The primary Species Profile remains Podocarpus macrophyllus.",
                    "Do not automatically create separate Species Library profiles for every nursery cultivar.",
                    "Only create separate profiles where a cultivar has a clear and established independent bonsai identity.",
                    "Do not confuse nursery marketing names with botanical species.",
                ]
            ),
            SpeciesProfileSection(
                id: "natural-growth",
                title: "Natural Growth and Vigour",
                paragraphs: [
                    "Podocarpus macrophyllus generally develops at a moderate pace when healthy.",
                    "Growth strength depends on temperature, light, root health, root space, watering, fertilization and development stage.",
                    "During structural development: allow selected shoots and leaders to extend where trunk thickness is required, branch thickness is required or taper is being developed.",
                    "During refinement: control excessively long extension, unnecessary vertical growth, branch congestion and weak interior structure.",
                    "The objective is: Useful extension during development · Controlled compact growth during refinement.",
                ]
            ),
            SpeciesProfileSection(
                id: "foliage",
                title: "Foliage",
                paragraphs: [
                    "The long narrow evergreen foliage is one of the defining characteristics of Podocarpus macrophyllus.",
                    "Healthy foliage should be evenly distributed, supported by healthy branches, proportional to the bonsai design and maintained through balanced vigour.",
                    "Leaf size and appearance depend on individual genetics, vigour, fertilization, light, pruning and development stage.",
                    "Do not treat the foliage as if it were pine needles.",
                    "Do not use defoliation techniques intended for deciduous broadleaf bonsai.",
                    "Leaf and foliage management should focus primarily on shoot selection, pruning, vigour management, balanced fertilization and adequate light.",
                ]
            ),
            SpeciesProfileSection(
                id: "flowering",
                title: "Flowering",
                paragraphs: [
                    "Flowering is not applicable as a primary ornamental bonsai characteristic.",
                    "Flowers should not be treated as a design objective.",
                    "Do not sacrifice structural development or ramification in pursuit of flowering.",
                ]
            ),
            SpeciesProfileSection(
                id: "fruit",
                title: "Fruit",
                paragraphs: [
                    "Fruiting is of moderate ornamental importance on mature female material.",
                    "Fruit is not required for a convincing Buddhist Pine bonsai.",
                    "Do not treat fruit production as a styling priority.",
                ]
            ),
            SpeciesProfileSection(
                id: "bark-trunk",
                title: "Bark and Trunk",
                paragraphs: [
                    "Mature Podocarpus macrophyllus can develop attractive trunk character. Mature bark character is good.",
                    "Older material may develop textured bark, aged trunk movement, natural scars and strong visual maturity.",
                    "Trunk development should be based on the individual material.",
                    "The objective is natural age and structure rather than artificial exaggeration.",
                ]
            ),
            SpeciesProfileSection(
                id: "roots-nebari",
                title: "Roots and Nebari",
                paragraphs: [
                    "Healthy roots support vigour, recovery, back-budding, ramification and long-term health.",
                    "Root development is good. Objectives include balanced roots, radial development, stable surface roots and gradual nebari improvement.",
                    "Root correction should be gradual.",
                    "Avoid unnecessary aggressive root reduction.",
                    "The objective is a strong and visually convincing base appropriate to the individual bonsai design.",
                ]
            ),
            SpeciesProfileSection(
                id: "light",
                title: "Light",
                paragraphs: [
                    "Podocarpus macrophyllus benefits from strong outdoor light.",
                    "Adequate light supports healthy evergreen foliage, compact growth, ramification, branch development and overall vigour.",
                    "The ideal position depends on local climate, seasonal temperatures, summer intensity, tree health and development stage.",
                    "Outdoor cultivation is preferred.",
                    "Do not present ordinary permanent indoor cultivation as the default.",
                ]
            ),
            SpeciesProfileSection(
                id: "wind",
                title: "Wind",
                paragraphs: [
                    "Moderate air movement is beneficial.",
                    "Strong wind may increase water demand, dry shallow containers, increase winter stress and damage exposed foliage.",
                    "Monitor trees during prolonged wind, dry conditions, cold periods and rapid weather changes.",
                ]
            ),
            SpeciesProfileSection(
                id: "watering",
                title: "Watering",
                paragraphs: [
                    "General principle: Maintain healthy moisture levels · Avoid permanent saturation · Avoid repeated severe drying · Maintain root aeration.",
                    "Water demand is moderate.",
                    "Podocarpus macrophyllus should not be treated as a permanently wet species or as a drought species that can repeatedly dry completely.",
                    "Watering frequency depends on temperature, sunlight, wind, container size, substrate, root mass, foliage mass and development stage.",
                    "Do not water according to a fixed timetable.",
                    "The objective is: Healthy roots · Appropriate moisture · Good aeration.",
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
                    "Fertilization should support healthy evergreen foliage, trunk development, branch development, ramification and recovery after work.",
                    "During structural development: healthy trees may receive stronger nutritional support where appropriate.",
                    "During refinement: avoid excessive fertilization that produces overly long extension, coarse growth or excessive foliage density.",
                    "Key principle: Feed according to tree condition and development objective.",
                ]
            ),
            SpeciesProfileSection(
                id: "pruning",
                title: "Pruning",
                paragraphs: [
                    "Podocarpus macrophyllus responds well to controlled pruning. Pruning response is excellent.",
                    "Pruning can be used for structural development, branch selection, branch replacement, ramification and silhouette refinement.",
                    "During development: allow selected shoots to extend where thickness or taper is required.",
                    "During refinement: use controlled pruning and shoot selection to maintain compact proportions, useful ramification, branch hierarchy and visible internal structure.",
                    "Do not repeatedly shorten all growth uniformly.",
                    "The objective is: Purposeful development · Controlled refinement · Healthy regenerative capacity.",
                ]
            ),
            SpeciesProfileSection(
                id: "back-budding",
                title: "Back-budding",
                paragraphs: [
                    "Podocarpus macrophyllus can produce useful new growth from existing branches when healthy. Back-budding is good under healthy conditions.",
                    "Response depends on tree health, vigour, branch condition, available foliage, light, pruning strategy and root health.",
                    "Do not assume that every bare branch will reliably produce new growth.",
                    "Preserve useful foliage where it supports branch health.",
                    "The objective is a healthy branch system capable of renewal and progressive refinement.",
                ]
            ),
            SpeciesProfileSection(
                id: "ramification",
                title: "Ramification",
                paragraphs: [
                    "Ramification can be developed through repeated healthy growth cycles, controlled pruning, shoot selection, branch selection and preservation of useful interior growth. Ramification potential is good.",
                    "Avoid creating dense outer foliage while internal branches weaken, repeated removal of all interior growth, and uniform trimming without branch selection.",
                    "Maintain branch hierarchy, natural spacing, useful interior growth and sufficient light penetration.",
                    "The objective is compact foliage supported by believable internal structure.",
                ]
            ),
            SpeciesProfileSection(
                id: "wiring",
                title: "Wiring",
                paragraphs: [
                    "Young and flexible branches can be wired. Wiring response is good.",
                    "Wiring can be used to establish movement, improve branch placement, position secondary branches and develop branch structure.",
                    "Older branches may become increasingly rigid.",
                    "Before major bends, assess branch thickness, flexibility, age, health and structural importance.",
                    "Monitor wire carefully.",
                    "Do not force rigid branches into extreme bends.",
                ]
            ),
            SpeciesProfileSection(
                id: "deadwood-potential",
                title: "Deadwood",
                paragraphs: [
                    "Deadwood may occasionally contribute to mature character. Deadwood potential is moderate.",
                    "However: deadwood should not automatically become a dominant design feature.",
                    "Use it where it reflects the individual material, supports natural structure, contributes to believable age and does not compromise tree health.",
                    "Avoid unnecessary artificial carving.",
                ]
            ),
            SpeciesProfileSection(
                id: "defoliation",
                title: "Foliage Management",
                paragraphs: [
                    "Foliage management is not applicable as routine defoliation.",
                    "Foliage management should primarily focus on shoot selection, controlled pruning, balanced fertilization, adequate light and vigour management.",
                    "Do not present complete defoliation as standard management.",
                    "Do not apply aggressive foliage removal to weak trees, stressed trees, recently repotted trees or trees recovering from major work.",
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
                    "Timing must account for local climate, active growth cycle, seasonal temperatures and individual tree condition.",
                ]
            ),
            SpeciesProfileSection(
                id: "trunk-development",
                title: "Trunk Development",
                paragraphs: [
                    "Podocarpus macrophyllus can develop substantial trunk character over time.",
                    "Where additional thickness is required: allow selected leaders to extend, provide sufficient root space, use development containers where appropriate and avoid premature refinement.",
                    "Once sufficient trunk development has been achieved, shift focus toward taper, branch hierarchy, ramification, mature bark character and compact proportions.",
                    "Key principle: Do not permanently restrict a tree that still requires major structural development.",
                ]
            ),
            SpeciesProfileSection(
                id: "nebari-development",
                title: "Nebari Development",
                paragraphs: [
                    "Nebari should be developed gradually.",
                    "Potential approaches include early root selection, radial root planning, staged root correction, appropriate development containers and gradual refinement of surface roots.",
                    "The objective is a stable and visually convincing base.",
                ]
            ),
            SpeciesProfileSection(
                id: "propagation",
                title: "Propagation",
                paragraphs: [
                    "Podocarpus macrophyllus may be propagated using established horticultural methods including seed, cuttings and layering.",
                    "Propagation method selection depends on the desired objective.",
                    "Vegetative propagation may preserve characteristics of selected material.",
                    "Seed-grown material may offer genetic variation, strong root development and opportunities for early structural planning.",
                    "Detailed procedures belong in Bonsai World Propagation Knowledge Articles.",
                ]
            ),
            SpeciesProfileSection(
                id: "pests",
                title: "Pests and Problems",
                paragraphs: [
                    "Relevant risks may include scale insects, spider mites, aphids, fungal problems, root problems caused by poor drainage, drought stress, winter stress and root damage during prolonged severe freezing.",
                    "Do not provide generic treatment instructions.",
                    "Diagnosis and treatment belong in Care → Pest Management and Care → Disease & Problems.",
                ]
            ),
            SpeciesProfileSection(
                id: "seasonal",
                title: "Seasonal Profile",
                paragraphs: [
                    "Spring: monitor new growth, watering demand, overall vigour, pest activity and branch development. Spring is important for assessing structural priorities, ramification, root health and recovery from winter. Major work should be coordinated with local climate and tree condition.",
                    "Summer: monitor watering demand, shoot growth, foliage health, pest activity and wire marks. Strong growth should be managed according to whether shoots are intended for structural development, branch development or refinement. Do not suppress all vigorous growth where development is still required.",
                    "Autumn is important for evaluating seasonal growth, reviewing branch structure, assessing overall health and preparing for cooler conditions. Growth activity depends strongly on local climate. Do not apply one universal autumn schedule.",
                    "Winter: Podocarpus macrophyllus should receive appropriate seasonal conditions.",
                    "Do not describe Podocarpus macrophyllus as universally hardy in cold climates.",
                    "Winter management depends strongly on local minimum temperatures, duration of freezing, wind exposure, container depth, root protection, moisture conditions and tree health.",
                    "In cold climates, winter protection may be necessary.",
                    "Shallow bonsai roots are significantly more exposed to cold than roots in open ground.",
                    "Protect the root system when required. Do not maintain permanently indoors simply as a substitute for appropriate seasonal cultivation.",
                ]
            ),
            SpeciesProfileSection(
                id: "styles",
                title: "Bonsai Styles",
                paragraphs: [
                    "Podocarpus macrophyllus is particularly suitable for Informal Upright, Formal Upright, Slanting, Multi-trunk Style, Clump Style and Naturalistic Bonsai.",
                    "It is especially effective when styling emphasises clean branch structure, evergreen foliage masses, natural trunk movement, compact proportions and mature character.",
                    "The individual material should determine the final design.",
                ]
            ),
            SpeciesProfileSection(
                id: "tree-stage",
                title: "Development by Tree Stage",
                paragraphs: [
                    "Young material: establish healthy roots, develop trunk thickness, establish movement and begin structural development.",
                    "Nursery material: evaluate trunk potential, identify useful branches, establish a design direction and begin structural correction.",
                    "Pre-bonsai: develop trunk, establish primary branches, improve root structure, build taper and build vigour.",
                    "In training: develop secondary branches, improve branch hierarchy, build ramification and preserve interior growth.",
                    "Refinement: maintain balanced vigour, improve tertiary ramification, control shoot extension, maintain compact proportions and preserve visible structure.",
                    "Exhibition / mature refined tree: maintain health, preserve established structure, maintain balanced ramification, preserve mature character and avoid unnecessary major intervention.",
                ]
            ),
            SpeciesProfileSection(
                id: "attention",
                title: "Species-Specific Attention",
                paragraphs: [
                    "These attention points are operational tendencies. They must still be interpreted for the individual tree.",
                ],
                bullets: [
                    "Podocarpus macrophyllus is an evergreen conifer",
                    "It is not a true pine",
                    "It is not a true yew",
                    "Strong pruning response is one of its major bonsai strengths",
                    "Back-budding depends on tree health and vigour",
                    "Preserve useful interior foliage",
                    "Dense outer foliage must not be allowed to weaken internal structure",
                    "Do not use deciduous defoliation techniques as routine management",
                    "Young branches are more suitable for wiring than older rigid branches",
                    "Monitor wire carefully",
                    "Avoid permanently saturated roots",
                    "Avoid repeated severe drying",
                    "Cold tolerance depends strongly on local conditions",
                    "Shallow bonsai roots are vulnerable during prolonged severe freezing",
                    "Outdoor cultivation is preferred",
                ]
            ),
        ]
    }
}
