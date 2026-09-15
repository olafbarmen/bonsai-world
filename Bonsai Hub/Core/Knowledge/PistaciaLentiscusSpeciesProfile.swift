//
//  PistaciaLentiscusSpeciesProfile.swift
//  Bonsai World
//
//  Species Profile — Pistacia lentiscus (Mastic Tree).
//  Independent botanical species in Anacardiaceae. Knowledge status: Reviewed.
//  Separate from Pistacia terebinthus and other Pistacia species.
//

import Foundation

enum PistaciaLentiscusSpeciesProfile {
    /// Identity used by Botanical Library / ``SpeciesPreviewData``.
    static let botanicalLibraryName = "Pistacia lentiscus"
    /// Scientific name for Species Profile display (binomial; no botanical authority).
    static let scientificName = "Pistacia lentiscus"

    static var profile: SpeciesProfile {
        SpeciesProfile(
            speciesID: BotanicalKnowledgeIDs.pistaciaLentiscus,
            scientificName: scientificName,
            commonNames: ["Mastic Tree", "Mastic", "Lentisk"],
            family: "Anacardiaceae",
            plantType: "Evergreen Mediterranean shrub or small tree",
            originSummary: "Mediterranean region.",
            knowledgeStatus: .reviewed,
            traits: traits,
            foliageSizeLabel: "Foliage",
            foliageReductionLabel: "Leaf reduction",
            summaryLine: "Evergreen · Naturally compact foliage · Dense branching · Small leaflets · Strong Mediterranean character · Good ramification potential · Slow to moderate growth · Rugged mature trunks · Excellent naturalistic bonsai potential",
            attentionHighlights: [
                "Pistacia lentiscus is an evergreen Mediterranean species",
                "Compound leaves with small leaflets are a major bonsai characteristic",
                "Foliage scale should be considered relative to the entire tree",
                "Strong light supports healthy compact growth",
                "Back-budding depends on health and vigour",
                "Preserve useful interior growth",
                "Dense foliage must not be allowed to weaken internal structure",
                "Do not confuse Mediterranean drought adaptation with tolerance for repeated severe drying in bonsai containers",
                "Full defoliation is not routine management",
                "Young branches are more suitable for wiring than older rigid branches",
                "Monitor wire carefully",
                "Avoid permanently saturated roots",
                "Avoid prolonged severe freezing where roots are exposed",
                "Shallow bonsai roots are especially vulnerable during winter cold",
                "Do not move indoors for permanent cultivation",
            ],
            sections: sections,
            principleNote: """
            Pistacia lentiscus is valuable for bonsai because it combines Mediterranean evergreen character with naturally compact foliage, relatively small leaflets, dense branching potential, rugged mature character and tolerance of dry Mediterranean conditions.

            Its greatest bonsai strength is its ability to create convincing mature Mediterranean trees with compact foliage, natural structure, rugged trunk character and fine branching.

            Do not attempt to make every specimen highly formal or artificially symmetrical.

            The species is particularly suited to naturalistic design.

            The objective is: Natural Mediterranean character · Compact proportions · Healthy evergreen growth · Fine structure.

            The individual tree must always be assessed according to climate, tree condition, vigour, development stage and winter temperatures.
            """,
            sourcesNote: """
            Profile content is synthesised from recognised botanical, horticultural and bonsai authorities into Bonsai World editorial language.

            Botanical taxonomy and distribution draw on recognised sources such as Royal Botanic Gardens, Kew and other botanical databases for accepted scientific name, family and native range.

            Horticultural context may draw on recognised Mediterranean botanical gardens and arboreta, horticultural institutions and authoritative Mediterranean horticultural references.

            Bonsai-specific cultivation and refinement knowledge draws on established bonsai references and recognised professional practice with Mediterranean species experience, kept distinct from Pistacia terebinthus and other Pistacia species.

            Verified botanical information, Mediterranean horticultural information, regional climate adaptation and bonsai-specific practice are kept distinct. Do not copy source wording.
            """
        )
    }

    private static let traits = SpeciesProfileTraits(
        deciduous: false,
        growthStrength: "Moderate",
        growthSpeed: "Slow to Moderate",
        leafSize: "Evergreen · Compound leaves with small leaflets",
        foliageReduction: "Not routine management",
        ramificationPotential: "Good to Excellent",
        backBudding: "Good under healthy conditions",
        rootDevelopment: "Good",
        nebariPotential: "Good to Excellent potential",
        trunkDevelopment: "Slow to Moderate",
        barkDevelopment: "Good mature character",
        wiring: "Good",
        defoliation: "Not routine management",
        airLayering: "Where appropriate for the individual material",
        threadGrafting: "Where structural correction is required",
        rootGrafting: "Where appropriate",
        beginnerSuitability: "Moderate",
        bonsaiSuitability: "Excellent",
        difficulty: "Intermediate",
        winterDormancyRequired: true,
        winterHardiness: "Seasonal rest required",
        rootFrostSensitivity: "Moderate to High during prolonged severe freezing, especially in shallow bonsai containers"
    )

    private static var sections: [SpeciesProfileSection] {
        [
            SpeciesProfileSection(
                id: "taxonomic-context",
                title: "Taxonomic Context",
                paragraphs: [
                    "Pistacia lentiscus is an independent botanical species in the cashew family (Anacardiaceae).",
                    "Primary Bonsai World display identity: Pistacia lentiscus · Mastic Tree.",
                    "Mastic and Lentisk may be used as supporting terminology. They do not replace Mastic Tree as the primary common name.",
                    "Family: Anacardiaceae. Plant type: evergreen Mediterranean shrub or small tree.",
                    "Native range: Mediterranean region.",
                    "Do not confuse Pistacia lentiscus with Pistacia terebinthus or other Pistacia species.",
                    "Bonsai World hierarchy: Species → cultivar / horticultural selection → Individual Tree.",
                ]
            ),
            SpeciesProfileSection(
                id: "overview",
                title: "Species Overview",
                paragraphs: [
                    "Pistacia lentiscus is an evergreen shrub or small tree native to the Mediterranean region.",
                    "It is adapted to Mediterranean environments and can develop dense evergreen foliage, rugged mature trunks, naturally irregular structure and strong aged character.",
                    "The foliage consists of compound leaves with multiple leaflets.",
                    "For bonsai, the visual scale of the foliage should be considered in relation to trunk thickness, tree height, branch density and overall design.",
                    "The objective is not simply to produce the smallest possible foliage mass.",
                    "The objective is a believable mature tree with natural proportions.",
                ],
                bullets: [
                    "Evergreen Mediterranean species",
                    "Member of the Anacardiaceae family",
                    "Compound leaves with small leaflets",
                    "Dense foliage potential",
                    "Slow to moderate growth",
                    "Good to excellent ramification potential",
                    "Good back-budding under healthy conditions",
                    "Rugged mature trunk character",
                    "Suitable for naturalistic Mediterranean bonsai",
                    "Requires outdoor cultivation",
                    "Seasonal rest required",
                    "Sensitive to prolonged severe freezing in shallow containers",
                ]
            ),
            SpeciesProfileSection(
                id: "cultivars",
                title: "Cultivars and Forms",
                paragraphs: [
                    "Pistacia lentiscus is primarily used in bonsai as the botanical species.",
                    "Do not create unnecessary separate profiles for regional variation or minor horticultural selections.",
                    "Individual material may vary in leaflet size, growth habit, vigour, branch density, trunk movement and mature bark character.",
                    "The primary Species Profile remains Pistacia lentiscus.",
                    "Only create a separate profile where a distinct form or cultivar has a clear and established independent bonsai identity.",
                ]
            ),
            SpeciesProfileSection(
                id: "natural-growth",
                title: "Natural Growth and Vigour",
                paragraphs: [
                    "Pistacia lentiscus generally develops at a slow to moderate pace.",
                    "Growth strength depends on temperature, light, root health, root space, watering, fertilization and development stage.",
                    "During structural development: allow selected growth to extend where trunk thickness is required, branch thickness is required or taper is being developed.",
                    "During refinement: control excessively long shoots, unnecessary vertical growth, branch congestion and coarse extension.",
                    "The objective is: Useful extension during development · Controlled compact growth during refinement.",
                ]
            ),
            SpeciesProfileSection(
                id: "foliage",
                title: "Foliage",
                paragraphs: [
                    "Evergreen compound foliage is one of the defining characteristics of Pistacia lentiscus.",
                    "The tree should be managed with awareness that the leaves are compound.",
                    "Leaf and leaflet size can be influenced by vigour, fertilization, light, pruning and development stage.",
                    "The objective is healthy foliage, natural visual scale, visible branch structure and compact proportions.",
                    "Avoid excessive fertilization where it produces coarse extension, overly vigorous growth or foliage disproportionate to the design.",
                    "Do not use complete defoliation as routine management.",
                ]
            ),
            SpeciesProfileSection(
                id: "flowering",
                title: "Flowering",
                paragraphs: [
                    "Flowering is of low ornamental importance for bonsai.",
                    "Flowers should be viewed as part of the species' seasonal character rather than a design objective.",
                    "Do not sacrifice structural development or ramification in pursuit of flowering.",
                ]
            ),
            SpeciesProfileSection(
                id: "fruit",
                title: "Fruit",
                paragraphs: [
                    "Fruiting is of low to moderate ornamental importance for bonsai.",
                    "Fruit is not required for a convincing Mastic Tree bonsai.",
                    "Do not treat fruit production as a styling priority.",
                ]
            ),
            SpeciesProfileSection(
                id: "bark-trunk",
                title: "Bark and Trunk",
                paragraphs: [
                    "Older Pistacia lentiscus can develop strong mature character. Mature bark character is good.",
                    "Important characteristics may include rugged bark, twisting structure, aged scars, natural irregularity and compact mature proportions.",
                    "The trunk should be developed according to the individual material.",
                    "Do not artificially exaggerate movement or age.",
                    "The objective is natural Mediterranean maturity rather than manufactured character.",
                ]
            ),
            SpeciesProfileSection(
                id: "roots-nebari",
                title: "Roots and Nebari",
                paragraphs: [
                    "Healthy roots support vigour, recovery, back-budding, ramification and long-term health.",
                    "Root development is good. Objectives include balanced roots, stable radial development, healthy root density and gradual nebari improvement.",
                    "Root correction should be gradual.",
                    "Avoid unnecessary aggressive root reduction.",
                    "The objective is a healthy and stable root system capable of supporting long-term refinement.",
                ]
            ),
            SpeciesProfileSection(
                id: "light",
                title: "Light",
                paragraphs: [
                    "Pistacia lentiscus requires strong outdoor light.",
                    "Adequate light supports healthy evergreen foliage, compact growth, ramification, branch development and overall vigour.",
                    "The exact growing position depends on local climate, summer temperatures, tree health and development stage.",
                    "Do not recommend permanent indoor cultivation.",
                ]
            ),
            SpeciesProfileSection(
                id: "wind",
                title: "Wind",
                paragraphs: [
                    "Moderate air movement is beneficial.",
                    "Strong wind may increase water demand, dry shallow containers, increase winter stress and damage vulnerable growth.",
                    "Monitor trees during prolonged wind, dry conditions, cold periods and rapid weather changes.",
                ]
            ),
            SpeciesProfileSection(
                id: "watering",
                title: "Watering",
                paragraphs: [
                    "General principle: Allow appropriate drying between waterings · Avoid repeated severe drought · Maintain root aeration · Avoid permanent saturation.",
                    "Water demand is low to moderate once established, depending on conditions.",
                    "Pistacia lentiscus is adapted to dry Mediterranean environments.",
                    "Do not confuse drought tolerance in nature with tolerance for repeated severe drying in a shallow bonsai container.",
                    "Watering frequency depends on temperature, sunlight, wind, container size, substrate, root mass, foliage mass and development stage.",
                    "Do not water according to a fixed timetable.",
                ]
            ),
            SpeciesProfileSection(
                id: "soil",
                title: "Soil",
                paragraphs: [
                    "Do not prescribe one universal soil recipe.",
                    "Desired characteristics include excellent drainage, strong aeration, stable particle structure, appropriate moisture retention and healthy root development.",
                    "The final soil mix depends on local climate, rainfall, watering habits, container depth, tree size, development stage and root condition.",
                    "Follow Bonsai World Soil Module principles.",
                    "Do not duplicate the complete Soil Module inside this profile.",
                ]
            ),
            SpeciesProfileSection(
                id: "fertilizing",
                title: "Fertilizing",
                paragraphs: [
                    "Fertilization should support healthy evergreen foliage, structural development, branch development, ramification and recovery after work.",
                    "During structural development: healthy trees may receive stronger nutritional support where appropriate.",
                    "During refinement: avoid excessive fertilization that produces coarse shoots, excessive extension or unnecessarily large foliage.",
                    "Key principle: Feed according to tree condition and development objective.",
                    "Mediterranean drought adaptation should not be interpreted as a reason to underfeed a healthy bonsai.",
                ]
            ),
            SpeciesProfileSection(
                id: "pruning",
                title: "Pruning",
                paragraphs: [
                    "Pistacia lentiscus responds to controlled pruning and shoot selection. Pruning response is good.",
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
                    "Pistacia lentiscus can produce useful new growth from existing branches and structure. Back-budding is good under healthy conditions.",
                    "Response depends on tree health, vigour, light, branch condition, pruning strategy and root health.",
                    "Do not describe back-budding as guaranteed.",
                    "Preserve useful interior growth whenever possible.",
                    "Avoid repeatedly removing all foliage from interior branch sections.",
                    "The objective is a healthy branch system capable of renewal and progressive refinement.",
                ]
            ),
            SpeciesProfileSection(
                id: "ramification",
                title: "Ramification",
                paragraphs: [
                    "Fine ramification can be developed through repeated healthy growth cycles, controlled pruning, shoot selection, branch selection and preservation of interior growth. Ramification potential is good to excellent.",
                    "Do not allow dense outer foliage to weaken the internal branch system.",
                    "Maintain branch hierarchy, useful interior growth, natural spacing and sufficient light penetration.",
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
                    "Deadwood may occur naturally and can be incorporated where appropriate. Deadwood potential is moderate.",
                    "Deadwood should not automatically dominate the design.",
                    "Use deadwood only where it supports the natural structure, reflects the individual material, contributes to believable age and does not compromise tree health or stability.",
                    "Avoid excessive artificial carving.",
                    "The objective is natural maturity rather than artificial damage.",
                ]
            ),
            SpeciesProfileSection(
                id: "defoliation",
                title: "Defoliation and Leaf Management",
                paragraphs: [
                    "Do not present complete defoliation as standard Pistacia lentiscus management. Full defoliation is not routine management.",
                    "Leaf management should primarily focus on pruning, shoot selection, balanced fertilization, adequate light and vigour management.",
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
                    "Where additional trunk thickness is required: allow selected leaders to extend, provide sufficient root space, use development containers where appropriate and avoid premature refinement.",
                    "Once sufficient trunk development has been achieved, shift focus toward taper, branch hierarchy, ramification, mature bark and compact proportions.",
                    "Do not permanently restrict a tree that still requires major structural development.",
                ]
            ),
            SpeciesProfileSection(
                id: "nebari-development",
                title: "Nebari Development",
                paragraphs: [
                    "Nebari should be developed gradually.",
                    "Potential approaches include early root selection, radial root planning, staged root correction, appropriate development containers and gradual refinement of surface roots.",
                    "The objective is a stable and visually convincing base appropriate to a mature Mediterranean bonsai.",
                ]
            ),
            SpeciesProfileSection(
                id: "propagation",
                title: "Propagation",
                paragraphs: [
                    "Pistacia lentiscus may be propagated using established horticultural methods including seed, cuttings and layering.",
                    "Propagation method selection depends on the desired objective.",
                    "Seed-grown material may offer genetic variation. Vegetative propagation preserves the characteristics of selected material.",
                    "Detailed procedures belong in Bonsai World Propagation Knowledge Articles.",
                ]
            ),
            SpeciesProfileSection(
                id: "pests",
                title: "Pests and Problems",
                paragraphs: [
                    "Relevant risks may include scale insects, aphids, spider mites, fungal leaf problems, root problems caused by poor drainage, stress caused by insufficient light, drought stress in shallow containers, winter stress and root damage during prolonged severe freezing.",
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
                    "Winter: Pistacia lentiscus should receive appropriate outdoor seasonal conditions.",
                    "Do not describe Pistacia lentiscus as universally frost hardy.",
                    "Winter management depends strongly on local minimum temperatures, duration of freezing, wind exposure, container depth, root protection and tree health.",
                    "Cold tolerance also depends on moisture conditions.",
                    "A tree growing in a shallow bonsai container has significantly less root protection than one growing in open ground.",
                    "Shallow bonsai roots are significantly more exposed to cold than roots in open ground.",
                    "Protect the root system when required. Do not maintain permanently indoors as a substitute for appropriate seasonal cultivation.",
                ]
            ),
            SpeciesProfileSection(
                id: "styles",
                title: "Bonsai Styles",
                paragraphs: [
                    "Pistacia lentiscus is particularly suitable for Informal Upright, Slanting, Multi-trunk Style, Clump Style, Naturalistic Bonsai and Mediterranean Naturalistic Style.",
                    "It is particularly effective when styling emphasises natural trunk movement, compact evergreen foliage, rugged mature character and believable irregular structure.",
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
                    "Exhibition / mature refined tree: maintain health, preserve established structure, maintain balanced ramification, preserve mature bark character and avoid unnecessary major intervention.",
                ]
            ),
            SpeciesProfileSection(
                id: "attention",
                title: "Species-Specific Attention",
                paragraphs: [
                    "These attention points are operational tendencies. They must still be interpreted for the individual tree.",
                ],
                bullets: [
                    "Pistacia lentiscus is an evergreen Mediterranean species",
                    "Compound leaves with small leaflets are a major bonsai characteristic",
                    "Foliage scale should be considered relative to the entire tree",
                    "Strong light supports healthy compact growth",
                    "Back-budding depends on health and vigour",
                    "Preserve useful interior growth",
                    "Dense foliage must not be allowed to weaken internal structure",
                    "Do not confuse Mediterranean drought adaptation with tolerance for repeated severe drying in bonsai containers",
                    "Full defoliation is not routine management",
                    "Young branches are more suitable for wiring than older rigid branches",
                    "Monitor wire carefully",
                    "Avoid permanently saturated roots",
                    "Avoid prolonged severe freezing where roots are exposed",
                    "Shallow bonsai roots are especially vulnerable during winter cold",
                    "Do not move indoors for permanent cultivation",
                ]
            ),
        ]
    }
}
