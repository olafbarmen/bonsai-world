//
//  PhillyreaAngustifoliaSpeciesProfile.swift
//  Bonsai World
//
//  Species Profile — Phillyrea angustifolia (Narrow-leaved Mock Privet).
//  Independent botanical species in Oleaceae. Knowledge status: Reviewed.
//  Separate from Olea europaea, Ligustrum species and other Phillyrea species.
//

import Foundation

enum PhillyreaAngustifoliaSpeciesProfile {
    /// Identity used by Botanical Library / ``SpeciesPreviewData``.
    static let botanicalLibraryName = "Phillyrea angustifolia"
    /// Scientific name for Species Profile display (binomial; no botanical authority).
    static let scientificName = "Phillyrea angustifolia"

    static var profile: SpeciesProfile {
        SpeciesProfile(
            speciesID: BotanicalKnowledgeIDs.phillyreaAngustifolia,
            scientificName: scientificName,
            commonNames: ["Narrow-leaved Mock Privet", "Narrow-leaved Phillyrea"],
            family: "Oleaceae",
            plantType: "Evergreen Mediterranean broadleaf shrub or small tree",
            originSummary: "Mediterranean region.",
            knowledgeStatus: .reviewed,
            traits: traits,
            foliageSizeLabel: "Foliage",
            foliageReductionLabel: "Leaf reduction",
            summaryLine: "Evergreen · Naturally narrow leaves · Dense foliage · Strong Mediterranean character · Good ramification · Good response to pruning · Drought-adapted · Rugged mature appearance · Excellent potential for naturalistic bonsai",
            attentionHighlights: [
                "Phillyrea angustifolia is an evergreen Mediterranean species",
                "It belongs to Oleaceae but is not a true privet",
                "Naturally narrow leaves are one of its major bonsai strengths",
                "Good ramification develops through healthy repeated growth cycles",
                "Back-budding depends on tree health and vigour",
                "Preserve useful interior growth",
                "Dense foliage must not be allowed to weaken internal structure",
                "Do not confuse Mediterranean drought adaptation with tolerance for repeated severe drying in bonsai containers",
                "Complete defoliation is not routine management",
                "Young branches are more suitable for wiring than older rigid branches",
                "Monitor wire carefully",
                "Avoid permanently saturated roots",
                "Avoid prolonged severe freezing where roots are exposed",
                "Shallow bonsai roots are especially vulnerable during winter cold",
                "Do not move indoors for permanent cultivation",
            ],
            sections: sections,
            principleNote: """
            Phillyrea angustifolia is an evergreen Mediterranean species with strong potential for refined and naturalistic bonsai.

            Its greatest strengths include narrow evergreen foliage, dense ramification, Mediterranean character, natural trunk movement and good response to pruning.

            The species is particularly suitable for bonsai that aims to represent mature Mediterranean shrubs, small Mediterranean trees, rugged natural forms and compact evergreen broadleaf bonsai.

            The objective is: Natural structure · Compact foliage · Mature Mediterranean character · Healthy long-term growth.

            Do not force the tree into an artificial formal structure if the material naturally suggests a more rugged design.

            The individual tree must always be assessed according to climate, tree condition, vigour, development stage and winter temperatures.
            """,
            sourcesNote: """
            Profile content is synthesised from recognised botanical, horticultural and bonsai authorities into Bonsai World editorial language.

            Botanical taxonomy and distribution draw on recognised sources such as Royal Botanic Gardens, Kew and other botanical databases for accepted scientific name, family and native range.

            Horticultural context may draw on recognised Mediterranean botanical gardens and arboreta, horticultural institutions and authoritative Oleaceae horticultural references.

            Bonsai-specific cultivation and refinement knowledge draws on established bonsai references and recognised professional practice with Mediterranean species experience, kept distinct from Olea europaea, Ligustrum species and other Phillyrea species.

            Verified botanical information, Mediterranean horticultural information, regional climate adaptation and bonsai-specific practice are kept distinct. Do not copy source wording.
            """
        )
    }

    private static let traits = SpeciesProfileTraits(
        deciduous: false,
        growthStrength: "Moderate",
        growthSpeed: "Moderate",
        leafSize: "Evergreen · Naturally narrow leaves",
        foliageReduction: "Selective leaf management possible · Complete defoliation not routine",
        ramificationPotential: "Good to Excellent",
        backBudding: "Good under healthy conditions",
        rootDevelopment: "Good",
        nebariPotential: "Good potential",
        trunkDevelopment: "Moderate",
        barkDevelopment: "Good mature character",
        wiring: "Good",
        defoliation: "Selective leaf management possible · Complete defoliation not routine",
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
                    "Phillyrea angustifolia is an independent botanical species in the olive family (Oleaceae).",
                    "Primary Bonsai World display identity: Phillyrea angustifolia · Narrow-leaved Mock Privet.",
                    "Narrow-leaved Phillyrea may be used as supporting terminology. It does not replace Narrow-leaved Mock Privet as the primary common name.",
                    "Family: Oleaceae. Plant type: evergreen Mediterranean broadleaf shrub or small tree.",
                    "Native range: Mediterranean region.",
                    "Do not describe this species as a true privet.",
                    "Do not confuse common-name similarity with Ligustrum.",
                    "Do not confuse Phillyrea angustifolia with Olea europaea, Ligustrum species or other Phillyrea species.",
                    "Bonsai World hierarchy: Species → cultivar / horticultural selection → Individual Tree.",
                ]
            ),
            SpeciesProfileSection(
                id: "overview",
                title: "Species Overview",
                paragraphs: [
                    "Phillyrea angustifolia is an evergreen Mediterranean shrub or small tree belonging to the Oleaceae family.",
                    "It is valued for bonsai because of narrow leaves, evergreen foliage, dense branching potential, natural Mediterranean appearance, good response to controlled pruning and potential for aged and rugged character.",
                    "The foliage can provide good visual scale for small and medium bonsai.",
                    "Individual trees may vary according to genetics, growing conditions, vigour, age and pruning history.",
                    "The objective is not simply maximum foliage density.",
                    "The objective is healthy foliage supported by believable branch structure.",
                ],
                bullets: [
                    "Evergreen Mediterranean broadleaf species",
                    "Member of the Oleaceae family",
                    "Naturally narrow leaves",
                    "Moderate growth",
                    "Good to excellent ramification potential",
                    "Good back-budding under healthy conditions",
                    "Good response to pruning",
                    "Strong Mediterranean visual character",
                    "Suitable for compact and naturalistic bonsai",
                    "Outdoor cultivation required",
                    "Seasonal rest required",
                    "Drought-adapted in natural conditions",
                    "Shallow bonsai roots require protection during prolonged severe freezing",
                ]
            ),
            SpeciesProfileSection(
                id: "cultivars",
                title: "Cultivars and Forms",
                paragraphs: [
                    "Phillyrea angustifolia is primarily used in bonsai as the botanical species.",
                    "Individual trees may vary in leaf size, leaf width, growth vigour, branching density, trunk character and bark development.",
                    "Do not create unnecessary separate Species Library profiles for minor individual variation.",
                    "The primary Species Profile remains Phillyrea angustifolia.",
                    "Only create separate profiles where a distinct cultivar or form has a clear and established independent bonsai identity.",
                ]
            ),
            SpeciesProfileSection(
                id: "natural-growth",
                title: "Natural Growth and Vigour",
                paragraphs: [
                    "Phillyrea angustifolia generally develops at a moderate pace when healthy.",
                    "Growth strength depends on temperature, light, root health, root space, watering, fertilization and development stage.",
                    "During structural development: allow selected growth to extend where trunk thickness is required, branch thickness is required or taper is being developed.",
                    "During refinement: control excessively long shoots, coarse extension, unnecessary vertical growth and branch congestion.",
                    "The objective is: Useful extension during development · Controlled compact growth during refinement.",
                ]
            ),
            SpeciesProfileSection(
                id: "foliage",
                title: "Foliage",
                paragraphs: [
                    "The narrow evergreen foliage is one of the defining strengths of Phillyrea angustifolia.",
                    "Leaf size and appearance depend on individual genetics, vigour, fertilization, light, pruning and development stage.",
                    "The naturally narrow foliage can provide good visual proportions for bonsai.",
                    "However: do not rely on foliage alone to create refinement.",
                    "Maintain believable branch structure, useful interior growth, balanced foliage density and natural proportions.",
                    "The objective is healthy compact foliage supported by a convincing branch system.",
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
                    "Fruiting is of moderate ornamental importance for bonsai.",
                    "Fruit is not required for a convincing Phillyrea angustifolia bonsai.",
                    "Do not treat fruit production as a styling priority.",
                ]
            ),
            SpeciesProfileSection(
                id: "bark-trunk",
                title: "Bark and Trunk",
                paragraphs: [
                    "Mature Phillyrea angustifolia can develop attractive trunk character. Mature bark character is good.",
                    "Older material may show rugged bark, natural movement, twisting trunks, aged scars and irregular branch development.",
                    "Trunk character should be developed according to the individual material.",
                    "The species is particularly suitable for naturalistic Mediterranean styling.",
                    "Do not artificially exaggerate age.",
                    "The objective is natural maturity developed through structure, proportion and time.",
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
                    "The objective is a healthy and visually convincing base appropriate to a mature Mediterranean tree.",
                ]
            ),
            SpeciesProfileSection(
                id: "light",
                title: "Light",
                paragraphs: [
                    "Phillyrea angustifolia requires outdoor cultivation and benefits from strong light.",
                    "Adequate light supports healthy evergreen foliage, compact growth, ramification, branch development and overall vigour.",
                    "The exact growing position depends on local climate, seasonal temperatures, summer intensity, tree health and development stage.",
                    "Do not recommend permanent indoor cultivation.",
                ]
            ),
            SpeciesProfileSection(
                id: "wind",
                title: "Wind",
                paragraphs: [
                    "Moderate air movement is beneficial.",
                    "Strong wind may increase water demand, dry shallow containers, increase winter stress and damage exposed growth.",
                    "Monitor trees during prolonged wind, dry conditions, cold periods and rapid weather changes.",
                ]
            ),
            SpeciesProfileSection(
                id: "watering",
                title: "Watering",
                paragraphs: [
                    "General principle: Maintain healthy moisture levels · Avoid permanent saturation · Avoid repeated severe drought · Maintain root aeration.",
                    "Water demand is moderate to low when established, but dependent on bonsai container conditions.",
                    "Phillyrea angustifolia is adapted to relatively dry Mediterranean environments.",
                    "However: do not confuse this with tolerance for repeated severe drying in a shallow bonsai container.",
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
                    "During refinement: avoid excessive fertilization that produces coarse shoots, excessive extension or unnecessarily large or dense foliage.",
                    "Key principle: Feed according to tree condition and development objective.",
                    "Mediterranean drought adaptation should not be interpreted as a reason to underfeed a healthy bonsai.",
                ]
            ),
            SpeciesProfileSection(
                id: "pruning",
                title: "Pruning",
                paragraphs: [
                    "Phillyrea angustifolia responds well to controlled pruning when healthy. Pruning response is good to excellent.",
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
                    "Phillyrea angustifolia can produce useful new growth from existing branches and older structure. Back-budding is good under healthy conditions.",
                    "Response depends on tree health, vigour, light, branch condition, pruning strategy and root health.",
                    "Do not describe back-budding as guaranteed.",
                    "Preserve useful interior growth whenever possible.",
                    "Avoid repeatedly removing all foliage from important interior branch sections.",
                    "The objective is a healthy branch system capable of renewal and progressive refinement.",
                ]
            ),
            SpeciesProfileSection(
                id: "ramification",
                title: "Ramification",
                paragraphs: [
                    "Fine ramification can be developed through repeated healthy growth cycles, controlled pruning, shoot selection, branch selection and preservation of useful interior growth. Ramification potential is good to excellent.",
                    "Avoid creating dense outer foliage while allowing internal branches to weaken.",
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
                    "Deadwood may occur naturally and can contribute to a rugged Mediterranean appearance. Deadwood potential is moderate to good.",
                    "Potential features include old branch stubs, weathered scars, natural cavities and aged branch remnants.",
                    "Deadwood should support the natural appearance of the tree.",
                    "Avoid excessive artificial carving.",
                    "Any work should consider natural appearance, structural stability, tree health and long-term maintenance.",
                    "The objective is natural age rather than manufactured damage.",
                ]
            ),
            SpeciesProfileSection(
                id: "defoliation",
                title: "Defoliation and Leaf Management",
                paragraphs: [
                    "Selective leaf management is possible. Complete defoliation is not routine management.",
                    "Leaf management should primarily focus on shoot selection, pruning, balanced fertilization, adequate light and vigour management.",
                    "Selective removal of individual leaves may be appropriate for specific refinement objectives on healthy trees.",
                    "Do not present complete defoliation as standard maintenance.",
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
                    "Phillyrea angustifolia can develop strong natural trunk character.",
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
                    "The objective is a strong and visually convincing Mediterranean tree base.",
                ]
            ),
            SpeciesProfileSection(
                id: "propagation",
                title: "Propagation",
                paragraphs: [
                    "Phillyrea angustifolia may be propagated using established horticultural methods including seed, cuttings and layering.",
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
                    "Relevant risks may include scale insects, aphids, spider mites, fungal leaf problems, root problems caused by poor drainage, drought stress in shallow containers, winter stress and root damage during prolonged severe freezing.",
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
                    "Winter: Phillyrea angustifolia should receive appropriate outdoor seasonal conditions.",
                    "Do not describe Phillyrea angustifolia as universally frost hardy.",
                    "Winter management depends strongly on local minimum temperatures, duration of freezing, wind exposure, container depth, root protection and tree health.",
                    "Cold tolerance also depends on moisture conditions.",
                    "Shallow bonsai roots are significantly more exposed to cold than roots in open ground.",
                    "Protect the root system when required. Do not maintain permanently indoors as a substitute for appropriate seasonal cultivation.",
                ]
            ),
            SpeciesProfileSection(
                id: "styles",
                title: "Bonsai Styles",
                paragraphs: [
                    "Phillyrea angustifolia is particularly suitable for Informal Upright, Slanting, Multi-trunk Style, Clump Style, Naturalistic Bonsai and Mediterranean Naturalistic Style.",
                    "It is especially effective when styling emphasises narrow foliage, natural trunk movement, compact evergreen structure and aged Mediterranean character.",
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
                    "Phillyrea angustifolia is an evergreen Mediterranean species",
                    "It belongs to Oleaceae but is not a true privet",
                    "Naturally narrow leaves are one of its major bonsai strengths",
                    "Good ramification develops through healthy repeated growth cycles",
                    "Back-budding depends on tree health and vigour",
                    "Preserve useful interior growth",
                    "Dense foliage must not be allowed to weaken internal structure",
                    "Do not confuse Mediterranean drought adaptation with tolerance for repeated severe drying in bonsai containers",
                    "Complete defoliation is not routine management",
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
