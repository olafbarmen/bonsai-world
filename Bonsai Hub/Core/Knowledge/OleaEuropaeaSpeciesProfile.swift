//
//  OleaEuropaeaSpeciesProfile.swift
//  Bonsai World
//
//  Species Profile — Olea europaea (Olive).
//  Independent botanical species in Oleaceae. Knowledge status: Reviewed.
//  Separate from Olea europaea var. sylvestris and named olive cultivars.
//

import Foundation

enum OleaEuropaeaSpeciesProfile {
    /// Identity used by Botanical Library / ``SpeciesPreviewData``.
    static let botanicalLibraryName = "Olea europaea"
    /// Scientific name for Species Profile display (binomial; no botanical authority).
    static let scientificName = "Olea europaea"

    static var profile: SpeciesProfile {
        SpeciesProfile(
            speciesID: BotanicalKnowledgeIDs.oleaEuropaea,
            scientificName: scientificName,
            commonNames: ["Olive", "European Olive", "Common Olive"],
            family: "Oleaceae",
            plantType: "Evergreen Mediterranean tree",
            originSummary: "Mediterranean region and adjoining parts of western Asia and Africa.",
            knowledgeStatus: .reviewed,
            traits: traits,
            foliageSizeLabel: "Foliage",
            foliageReductionLabel: "Leaf reduction",
            summaryLine: "Evergreen · Small narrow leaves · Strong mature bark character · Exceptional trunk potential · Strong response to pruning · Good back-budding potential · Long-lived · Drought tolerant when established · Excellent bonsai potential",
            attentionHighlights: [
                "Olea europaea is an evergreen Mediterranean species",
                "Strong light is essential for healthy development",
                "Landscape drought tolerance does not mean bonsai tolerate repeated severe drying",
                "Small containers require careful watering",
                "Back-budding depends on health and vigour",
                "Preserve useful interior growth",
                "Trunk character is one of the species' greatest strengths",
                "Natural hollows and deadwood can be important design features",
                "Do not create artificial damage unnecessarily",
                "Live vein structure must be respected",
                "Full defoliation is not routine management",
                "Young branches are more suitable for wiring than older rigid branches",
                "Monitor wire during active growth",
                "Avoid prolonged severe freezing",
                "Shallow bonsai roots are especially vulnerable to winter cold",
                "Do not move indoors for permanent cultivation",
            ],
            sections: sections,
            principleNote: """
            Olea europaea is one of the most distinctive and recognisable Mediterranean bonsai species.

            Its greatest strengths include aged trunk character, natural hollows, deadwood potential, small foliage, strong response to pruning and convincing ancient appearance.

            Olive bonsai should not be managed solely for rapid refinement.

            Many of the most convincing specimens are built through long-term development of trunk, taper, natural cavities, live veins, branch structure and fine ramification.

            The objective is: Ancient character · Healthy live structure · Natural deadwood · Fine ramification.

            The individual tree must always be assessed according to climate, cultivar, tree condition, vigour, development stage and winter temperatures.
            """,
            sourcesNote: """
            Profile content is synthesised from recognised botanical, horticultural and bonsai authorities into Bonsai World editorial language.

            Botanical taxonomy and distribution draw on recognised sources such as Royal Botanic Gardens, Kew and other botanical databases for accepted scientific name, family and native range.

            Horticultural context may draw on recognised Mediterranean botanical gardens and arboreta, horticultural institutions and established olive horticultural references.

            Bonsai-specific cultivation and refinement knowledge draws on established bonsai references and recognised professional practice for Olea europaea, kept distinct from Olea europaea var. sylvestris and named olive cultivars.

            Verified botanical information, general horticultural cultivation, cultivar variation, Mediterranean climate adaptation and bonsai-specific practice are kept distinct. Do not copy source wording.
            """
        )
    }

    private static let traits = SpeciesProfileTraits(
        deciduous: false,
        growthStrength: "Moderate to Strong",
        growthSpeed: "Slow to Moderate",
        leafSize: "Evergreen · Narrow leaves",
        foliageReduction: "Not routine management",
        ramificationPotential: "Excellent",
        backBudding: "Good to Excellent under healthy conditions",
        rootDevelopment: "Good",
        nebariPotential: "Excellent potential",
        trunkDevelopment: "Moderate",
        barkDevelopment: "Excellent mature character",
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
        rootFrostSensitivity: "High in prolonged freezing conditions, especially in shallow bonsai containers"
    )

    private static var sections: [SpeciesProfileSection] {
        [
            SpeciesProfileSection(
                id: "taxonomic-context",
                title: "Taxonomic Context",
                paragraphs: [
                    "Olea europaea is an independent botanical species in the olive family (Oleaceae).",
                    "Primary Bonsai World display identity: Olea europaea · Olive.",
                    "European Olive and Common Olive may be used as supporting terminology. They do not replace Olive as the primary common name.",
                    "Family: Oleaceae. Plant type: evergreen Mediterranean tree.",
                    "Native range: Mediterranean region and adjoining parts of western Asia and Africa.",
                    "Do not confuse the species with Olea europaea var. sylvestris or with horticultural cultivars.",
                    "Wild olive material should be handled separately where botanically and horticulturally appropriate.",
                    "Do not treat all cultivated Olive and Wild Olive material as identical.",
                    "Bonsai World hierarchy: Species → cultivar / horticultural selection → Individual Tree.",
                ]
            ),
            SpeciesProfileSection(
                id: "overview",
                title: "Species Overview",
                paragraphs: [
                    "Olea europaea is an evergreen tree strongly associated with Mediterranean landscapes and cultivation.",
                    "It is valued as bonsai because it can develop extraordinary mature character.",
                    "Important features include narrow evergreen leaves, rugged bark, aged trunk character, natural hollows and cavities, strong regenerative ability, good response to pruning and strong bonsai design potential.",
                    "Olive trees can appear ancient even when their actual age is relatively modest.",
                    "However, convincing maturity should be based on genuine structural development rather than artificial damage.",
                    "The objective is: Natural age · Structural credibility · Healthy growth · Sustainable refinement.",
                ],
                bullets: [
                    "Evergreen Mediterranean tree",
                    "Member of the Oleaceae family",
                    "Narrow leaves",
                    "Strong mature bark character",
                    "Excellent trunk potential",
                    "Good response to pruning",
                    "Good back-budding under healthy conditions",
                    "Strong ramification potential",
                    "Natural hollowing potential",
                    "Excellent deadwood potential",
                    "Long-lived",
                    "Requires outdoor cultivation",
                    "Seasonal rest required",
                    "Sensitive to prolonged hard freezing, especially in shallow containers",
                ]
            ),
            SpeciesProfileSection(
                id: "cultivars",
                title: "Cultivars",
                paragraphs: [
                    "Olea europaea has many cultivated varieties developed for fruit production, oil production, climate adaptation and growth habit.",
                    "Cultivars may differ in vigour, leaf size, leaf shape, internode length, growth habit, fruit characteristics and cold tolerance.",
                    "For Bonsai World, cultivar profiles should only be created when a cultivar has a clearly established and distinct bonsai identity.",
                    "The primary profile remains Olea europaea. This section does not list agricultural olive cultivars.",
                    "Olea europaea var. sylvestris / wild olive material should be handled separately where required by the Species Library taxonomy.",
                    "Do not treat all cultivated Olive and Wild Olive material as identical.",
                ]
            ),
            SpeciesProfileSection(
                id: "natural-growth",
                title: "Natural Growth and Vigour",
                paragraphs: [
                    "Olea europaea can respond strongly when healthy, actively growing, provided adequate warmth and light, and supported by a healthy root system.",
                    "Growth strength depends on temperature, light, root space, watering, fertilization and development stage.",
                    "During structural development: allow selected growth to extend where trunk thickness is required, branch thickness is required or taper is being developed.",
                    "During refinement: control excessively long shoots, coarse extension, unnecessary vertical growth and branch congestion.",
                    "The objective is: Strong growth during development · Controlled growth during refinement.",
                ]
            ),
            SpeciesProfileSection(
                id: "foliage",
                title: "Foliage",
                paragraphs: [
                    "Olive foliage consists of narrow evergreen leaves.",
                    "Leaf size and appearance are influenced by vigour, fertilization, light, pruning and development stage.",
                    "The objective is healthy foliage, compact proportions, visible branch structure and natural scale.",
                    "Avoid excessive fertilization where it produces unnecessarily coarse growth.",
                    "Do not use complete defoliation as routine management.",
                ]
            ),
            SpeciesProfileSection(
                id: "flowering",
                title: "Flowering",
                paragraphs: [
                    "Flowering potential is moderate.",
                    "Flowering should be viewed as part of the species' seasonal character rather than the sole design objective.",
                    "Flower production depends on cultivar, tree health, light, climate and development stage.",
                    "Do not sacrifice structural development solely to maximise flowering.",
                ]
            ),
            SpeciesProfileSection(
                id: "fruit",
                title: "Fruit",
                paragraphs: [
                    "Fruiting potential is moderate to excellent depending on cultivar and conditions.",
                    "Fruit production depends on flowering, pollination, cultivar, tree health and seasonal conditions.",
                    "Heavy fruit loads can consume resources and should be evaluated against tree health and development objectives.",
                    "Fruit is not required for a convincing olive bonsai.",
                ]
            ),
            SpeciesProfileSection(
                id: "bark-trunk",
                title: "Bark and Trunk",
                paragraphs: [
                    "The trunk is one of the defining features of Olea europaea bonsai. Mature bark character is excellent.",
                    "Important characteristics may include rugged bark, twisting movement, hollows, cavities, deadwood and strong live veins.",
                    "Do not attempt to create artificial age through random damage.",
                    "Development should respect tree health, sap flow, structural stability and natural appearance.",
                    "The objective is convincing ancient character supported by healthy living structure.",
                ]
            ),
            SpeciesProfileSection(
                id: "roots-nebari",
                title: "Roots and Nebari",
                paragraphs: [
                    "Healthy roots support vigour, recovery, back-budding, ramification and long-term health.",
                    "Root development is good. Objectives include stable radial roots, healthy root density, strong surface-root character and gradual nebari development.",
                    "Root correction should be gradual.",
                    "Do not completely redesign an established root system in one operation.",
                ]
            ),
            SpeciesProfileSection(
                id: "light",
                title: "Light",
                paragraphs: [
                    "Olea europaea requires strong outdoor light for healthy development.",
                    "Adequate light supports vigour, compact growth, foliage health, branch development and overall tree health.",
                    "The exact growing position depends on local climate, seasonal temperatures, tree health and development stage.",
                    "Do not recommend permanent indoor cultivation.",
                ]
            ),
            SpeciesProfileSection(
                id: "wind",
                title: "Wind",
                paragraphs: [
                    "Moderate air movement is beneficial.",
                    "Strong or cold wind can increase water demand, increase cold stress, dry shallow containers and damage vulnerable growth.",
                    "Monitor trees during cold periods, strong wind, rapid weather changes and dry conditions.",
                ]
            ),
            SpeciesProfileSection(
                id: "watering",
                title: "Watering",
                paragraphs: [
                    "General principle: Allow appropriate drying between waterings · Avoid repeated severe drought · Maintain root aeration · Avoid permanent saturation.",
                    "Water demand is low to moderate once established, depending on conditions.",
                    "Although established olive trees are drought tolerant, bonsai containers contain limited root volume.",
                    "Do not confuse drought tolerance in the landscape with tolerance for repeated severe drying in a shallow bonsai container.",
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
                    "Fertilization should support healthy growth, structural development, ramification and recovery after work.",
                    "During structural development: healthy trees may receive stronger nutritional support where appropriate.",
                    "During refinement: avoid excessive fertilization that produces coarse shoots, unnecessarily long internodes or excessive foliage mass.",
                    "Key principle: Feed according to tree condition and development objective.",
                    "Do not imply that drought tolerance means low nutritional requirements during active development.",
                ]
            ),
            SpeciesProfileSection(
                id: "pruning",
                title: "Pruning",
                paragraphs: [
                    "Olea europaea responds well to pruning.",
                    "Pruning can be used for structural development, branch selection, branch replacement, ramification and silhouette refinement.",
                    "During development: allow selected shoots to extend where thickness or taper is required.",
                    "During refinement: use controlled pruning and shoot selection to maintain fine ramification, visible structure, branch hierarchy and natural proportions.",
                    "Do not repeatedly shorten all growth uniformly.",
                    "The objective is: Purposeful growth · Controlled refinement · Healthy regenerative capacity.",
                ]
            ),
            SpeciesProfileSection(
                id: "back-budding",
                title: "Back-budding",
                paragraphs: [
                    "Olea europaea can produce useful new growth from older wood. Back-budding is good to excellent under healthy conditions.",
                    "Response depends on tree health, vigour, light, branch condition, pruning strategy and root health.",
                    "Do not describe back-budding as guaranteed under all circumstances.",
                    "Preserve useful interior growth.",
                    "Do not repeatedly weaken the tree through unnecessary heavy pruning.",
                ]
            ),
            SpeciesProfileSection(
                id: "ramification",
                title: "Ramification",
                paragraphs: [
                    "Fine ramification can be developed through repeated healthy growth cycles, controlled pruning, shoot selection, branch selection and balanced vigour. Ramification potential is excellent.",
                    "Olive trees can become visually congested if refinement is based only on repeated shortening.",
                    "Maintain branch hierarchy, visible structure, natural spacing and proportionate foliage pads.",
                    "The objective is: Fine ramification · Clear live structure · Natural canopy.",
                ]
            ),
            SpeciesProfileSection(
                id: "wiring",
                title: "Wiring",
                paragraphs: [
                    "Young and flexible branches can be wired effectively. Wiring response is good.",
                    "Wiring can be used to establish movement, improve branch placement, position secondary branches and develop branch structure.",
                    "Older branches may become increasingly rigid.",
                    "Before major bends, assess branch thickness, flexibility, age, health and structural importance.",
                    "Monitor wire carefully during active growth.",
                    "Do not force brittle or rigid branches into extreme bends.",
                ]
            ),
            SpeciesProfileSection(
                id: "deadwood-potential",
                title: "Deadwood and Hollowing",
                paragraphs: [
                    "Natural deadwood and hollowing can be important design features. Deadwood potential is excellent.",
                    "Potential characteristics include shari-like deadwood areas, natural cavities, trunk hollows, aged scars and live veins surrounding dead areas.",
                    "Do not describe aggressive carving as mandatory.",
                    "Deadwood development should support the natural design, respect the tree's live structure, preserve structural stability and avoid unnecessary weakening.",
                    "Natural features are generally preferable to excessive artificial carving.",
                ]
            ),
            SpeciesProfileSection(
                id: "defoliation",
                title: "Defoliation and Leaf Management",
                paragraphs: [
                    "Do not present complete defoliation as standard Olive management. Full defoliation is not routine management.",
                    "Leaf management should primarily focus on pruning, shoot selection, balanced fertilization, adequate light and vigour management.",
                    "Do not apply aggressive foliage removal to weak trees, stressed trees, recently repotted trees or trees recovering from major styling.",
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
                    "Olive bonsai often require patience for major trunk development.",
                    "Where additional thickness is required: allow selected leaders to extend, use sacrifice growth where appropriate, provide sufficient root space and avoid premature refinement.",
                    "Once sufficient trunk development has been achieved, shift focus toward taper, live vein structure, branch hierarchy, ramification and mature character.",
                    "Do not permanently restrict a tree that still requires structural development.",
                ]
            ),
            SpeciesProfileSection(
                id: "nebari-development",
                title: "Nebari Development",
                paragraphs: [
                    "Nebari should be developed gradually.",
                    "Potential approaches include early root selection, radial root planning, staged root correction, appropriate development containers and gradual exposure of useful surface roots.",
                    "The objective is a stable and visually convincing base appropriate to a mature Olive bonsai.",
                ]
            ),
            SpeciesProfileSection(
                id: "propagation",
                title: "Propagation",
                paragraphs: [
                    "Olea europaea may be propagated using established horticultural methods including seed, cuttings and layering.",
                    "Propagation method selection depends on the desired objective.",
                    "Seed-grown material may offer genetic variation. Vegetative propagation preserves the characteristics of the parent material.",
                    "Detailed procedures belong in Bonsai World Propagation Knowledge Articles.",
                ]
            ),
            SpeciesProfileSection(
                id: "pests",
                title: "Pests and Problems",
                paragraphs: [
                    "Relevant risks may include scale insects, aphids, spider mites, fungal leaf problems, root problems caused by poor drainage, stress caused by insufficient light, cold damage, root damage from prolonged freezing and drought stress in shallow containers.",
                    "Do not provide generic treatment instructions.",
                    "Diagnosis and treatment belong in Care → Pest Management and Care → Disease & Problems.",
                ]
            ),
            SpeciesProfileSection(
                id: "seasonal",
                title: "Seasonal Profile",
                paragraphs: [
                    "Spring: monitor new growth, watering demand, overall vigour, pest activity and recovery from winter. Spring is an important period for assessing structural priorities, branch development and root health. Major work should be coordinated with local climate and tree condition.",
                    "Summer: monitor watering demand, strong shoot growth, foliage health, pest activity and wire marks. Olive trees may grow strongly under favourable warm conditions. Summer growth should be managed according to whether shoots are intended for trunk development, branch development or refinement. Do not suppress all vigorous growth where development is still required.",
                    "Autumn is important for evaluating seasonal growth, reviewing branch structure, assessing tree health and preparing for cooler conditions. Growth activity and timing depend strongly on local climate. Do not apply one universal autumn schedule.",
                    "Winter: Olea europaea should receive appropriate outdoor conditions.",
                    "Do not describe Olea europaea as frost hardy in all climates.",
                    "Winter management depends strongly on local minimum temperatures, duration of freezing, wind exposure, container depth, root protection and tree health.",
                    "Cold tolerance also depends on cultivar, tree health and moisture conditions.",
                    "Shallow bonsai roots are significantly more exposed to cold than roots in open ground.",
                    "Protect the root system when required. Do not maintain permanently indoors as a substitute for appropriate seasonal cultivation.",
                ]
            ),
            SpeciesProfileSection(
                id: "styles",
                title: "Bonsai Styles",
                paragraphs: [
                    "Olea europaea is particularly suitable for Informal Upright, Slanting, Semi-Cascade, Multi-trunk Style, Clump Style, Naturalistic Bonsai and Ancient Tree Style.",
                    "It is especially effective when styling emphasises trunk age, movement, natural hollows, live veins and rugged structure.",
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
                    "In training: develop secondary branches, improve branch hierarchy, develop live structure and build ramification.",
                    "Refinement: maintain balanced vigour, improve tertiary ramification, control shoot extension, preserve visible branch structure and maintain mature trunk character.",
                    "Exhibition / mature refined tree: maintain health, preserve established structure, preserve natural deadwood, maintain balanced ramification and avoid unnecessary major intervention.",
                ]
            ),
            SpeciesProfileSection(
                id: "attention",
                title: "Species-Specific Attention",
                paragraphs: [
                    "These attention points are operational tendencies. They must still be interpreted for the individual tree.",
                ],
                bullets: [
                    "Olea europaea is an evergreen Mediterranean species",
                    "Strong light is essential for healthy development",
                    "Landscape drought tolerance does not mean bonsai tolerate repeated severe drying",
                    "Small containers require careful watering",
                    "Back-budding depends on health and vigour",
                    "Preserve useful interior growth",
                    "Trunk character is one of the species' greatest strengths",
                    "Natural hollows and deadwood can be important design features",
                    "Do not create artificial damage unnecessarily",
                    "Live vein structure must be respected",
                    "Full defoliation is not routine management",
                    "Young branches are more suitable for wiring than older rigid branches",
                    "Monitor wire during active growth",
                    "Avoid prolonged severe freezing",
                    "Shallow bonsai roots are especially vulnerable to winter cold",
                    "Do not move indoors for permanent cultivation",
                ]
            ),
        ]
    }
}
