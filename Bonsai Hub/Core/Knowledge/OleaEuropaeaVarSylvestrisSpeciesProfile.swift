//
//  OleaEuropaeaVarSylvestrisSpeciesProfile.swift
//  Bonsai World
//
//  Species Profile — Olea europaea var. sylvestris (Wild Olive).
//  Practical Species Library representation of Wild Olive material in Oleaceae.
//  Knowledge status: Reviewed. Separate from cultivated Olea europaea.
//

import Foundation

enum OleaEuropaeaVarSylvestrisSpeciesProfile {
    /// Identity used by Botanical Library / ``SpeciesPreviewData``.
    static let botanicalLibraryName = "Olea europaea var. sylvestris"
    /// Scientific name for Species Profile display (no botanical authority).
    static let scientificName = "Olea europaea var. sylvestris"

    static var profile: SpeciesProfile {
        SpeciesProfile(
            speciesID: BotanicalKnowledgeIDs.oleaEuropaeaVarSylvestris,
            scientificName: scientificName,
            commonNames: ["Wild Olive", "Wild Olive Tree", "Oleaster"],
            family: "Oleaceae",
            plantType: "Evergreen Mediterranean tree",
            originSummary: "Mediterranean region.",
            knowledgeStatus: .reviewed,
            traits: traits,
            foliageSizeLabel: "Foliage",
            foliageReductionLabel: "Leaf reduction",
            summaryLine: "Evergreen · Naturally small leaves · Dense branching potential · Rugged trunk character · Strong natural deadwood potential · Excellent back-budding · Compact visual scale · Exceptional ancient bonsai potential",
            attentionHighlights: [
                "Wild Olive material may vary significantly in botanical origin and growth characteristics",
                "Bonsai World uses Olea europaea var. sylvestris as the practical profile for Wild Olive material",
                "Naturally small foliage is a major bonsai advantage",
                "Strong back-budding depends on health and vigour",
                "Preserve useful interior growth",
                "Exceptional trunk character should be respected rather than artificially exaggerated",
                "Natural hollows and deadwood may be major design features",
                "Live vein structure must be protected",
                "Landscape drought tolerance does not mean shallow bonsai tolerate repeated severe drying",
                "Full defoliation is not routine management",
                "Young branches are more suitable for wiring than older rigid branches",
                "Monitor wire during active growth",
                "Avoid prolonged severe freezing",
                "Shallow bonsai roots are especially vulnerable to winter cold",
                "Do not move indoors for permanent cultivation",
            ],
            sections: sections,
            principleNote: """
            Wild Olive is one of the most desirable Mediterranean materials for bonsai because it can combine naturally small foliage, compact growth, strong back-budding, rugged trunk character, hollows, deadwood and exceptional aged appearance.

            The most important distinction from cultivated Olive material is not simply the name.

            Individual Wild Olive material may offer particularly valuable bonsai characteristics including naturally compact proportions, small foliage, dense branching potential, rugged collected material and strong ancient visual character.

            However, individual trees vary significantly.

            Do not claim that every Wild Olive automatically has better bonsai characteristics than every cultivated Olea europaea.

            The objective is: Ancient character · Compact proportions · Healthy live structure · Fine ramification.

            The individual tree must always be assessed according to climate, taxonomy, individual material, tree condition, vigour, development stage and winter temperatures.
            """,
            sourcesNote: """
            Profile content is synthesised from recognised botanical, horticultural and bonsai authorities into Bonsai World editorial language.

            Botanical taxonomy and distribution draw on recognised sources such as Royal Botanic Gardens, Kew and other botanical databases for accepted scientific name, family and native range, while recognising that classification of wild olive populations can vary between sources.

            Horticultural context may draw on recognised Mediterranean botanical gardens and arboreta, horticultural institutions and authoritative olive research and horticultural references.

            Bonsai-specific cultivation and refinement knowledge draws on established bonsai references and recognised professional practice with Mediterranean species experience, kept distinct from cultivated Olea europaea and named agricultural olive cultivars.

            Verified botanical taxonomy, horticultural trade terminology, Wild Olive material characteristics, Mediterranean climate adaptation and bonsai-specific practice are kept distinct. Do not copy source wording.
            """
        )
    }

    private static let traits = SpeciesProfileTraits(
        deciduous: false,
        growthStrength: "Moderate",
        growthSpeed: "Slow to Moderate",
        leafSize: "Evergreen · Naturally small narrow leaves",
        foliageReduction: "Not routine management",
        ramificationPotential: "Excellent",
        backBudding: "Excellent under healthy conditions",
        rootDevelopment: "Good",
        nebariPotential: "Excellent potential",
        trunkDevelopment: "Slow to Moderate",
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
                    "This profile represents Wild Olive material commonly encountered and traded for bonsai, associated with Olea europaea var. sylvestris.",
                    "Primary Bonsai World display identity: Olea europaea var. sylvestris · Wild Olive.",
                    "Wild Olive Tree and Oleaster may be used as supporting terminology. They do not replace Wild Olive as the primary common name.",
                    "Family: Oleaceae. Plant type: evergreen Mediterranean tree.",
                    "Native range: Mediterranean region.",
                    "This profile is distinct from the cultivated Olive profile for Olea europaea.",
                    "Do not treat all cultivated Olive and Wild Olive material as identical.",
                    "In Bonsai World architecture this is an independent Species Library entry for a taxonomic variety, not a named horticultural cultivar.",
                    "Bonsai World hierarchy: Species / taxonomic variety → horticultural selection → Individual Tree.",
                ]
            ),
            SpeciesProfileSection(
                id: "taxonomy-naming",
                title: "Taxonomy and Naming",
                paragraphs: [
                    "The name Olea europaea var. sylvestris is widely encountered in horticulture and bonsai when describing Wild Olive material.",
                    "However, the classification and naming of wild olive populations can vary between botanical literature, horticultural trade, nursery practice and regional usage.",
                    "Bonsai World therefore uses this profile as the practical Species Library representation of Wild Olive material.",
                    "Do not assume that every tree sold as Wild Olive has identical botanical origin.",
                    "Do not present Olea europaea var. sylvestris as if the name is applied uniformly without taxonomic discussion.",
                    "The purpose of this section is practical clarity for Bonsai World users, not a long taxonomic essay.",
                ]
            ),
            SpeciesProfileSection(
                id: "overview",
                title: "Species Overview",
                paragraphs: [
                    "Wild Olive refers to naturally occurring or wild-type Mediterranean olive material commonly associated with Olea europaea.",
                    "In bonsai cultivation, Wild Olive is particularly valued for its potential to develop or already possess rugged trunks, natural hollows, deadwood, small foliage, compact growth and strong branching.",
                    "Old material can create a convincing ancient appearance.",
                    "However, the visual quality of the bonsai should remain dependent on trunk structure, live vein placement, root health, branch development, ramification and overall tree health.",
                    "Do not rely solely on collected or aged trunk material.",
                    "The objective is exceptional trunk character supported by believable living structure.",
                ],
                bullets: [
                    "Evergreen Mediterranean tree",
                    "Member of the Oleaceae family",
                    "Naturally small narrow leaves",
                    "Dense branching potential",
                    "Rugged trunk character",
                    "Excellent back-budding under healthy conditions",
                    "Excellent ramification potential",
                    "Natural hollowing potential",
                    "Excellent deadwood potential",
                    "Compact visual scale",
                    "Exceptional ancient bonsai potential",
                    "Requires outdoor cultivation",
                    "Seasonal rest required",
                    "Sensitive to prolonged hard freezing, especially in shallow containers",
                    "Individual trees vary significantly",
                ]
            ),
            SpeciesProfileSection(
                id: "cultivars",
                title: "Cultivars and Wild Material",
                paragraphs: [
                    "Wild Olive bonsai material is generally valued as naturally occurring or wild-type material rather than as named agricultural cultivars.",
                    "This section does not list commercial olive cultivars developed primarily for oil production, fruit production or agriculture.",
                    "Individual material can vary significantly in leaf size, trunk character, vigour, branch density, bark development and growth habit.",
                    "The primary focus of this profile remains Wild Olive material used for bonsai.",
                    "Do not claim that all Wild Olive material has identical characteristics.",
                ]
            ),
            SpeciesProfileSection(
                id: "natural-growth",
                title: "Natural Growth and Vigour",
                paragraphs: [
                    "Wild Olive generally develops at a moderate pace.",
                    "Growth strength depends on temperature, light, root health, available root space, watering, fertilization and development stage.",
                    "During structural development: allow selected growth to extend where trunk thickness is required, branch thickness is required or taper is being developed.",
                    "During refinement: control excessively long shoots, unnecessary vertical growth, branch congestion and coarse extension.",
                    "The objective is: Strong useful growth during development · Controlled compact growth during refinement.",
                ]
            ),
            SpeciesProfileSection(
                id: "foliage",
                title: "Foliage",
                paragraphs: [
                    "Naturally compact foliage is one of the major attractions of Wild Olive material.",
                    "Leaves are generally narrow and evergreen.",
                    "Leaf size and quality depend on vigour, fertilization, light, pruning and development stage.",
                    "The objective is healthy foliage, natural scale, visible branch structure and compact proportions.",
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
                    "Flower production depends on individual material, tree health, light, climate and development stage.",
                    "Do not sacrifice structural development solely to maximise flowering.",
                ]
            ),
            SpeciesProfileSection(
                id: "fruit",
                title: "Fruit",
                paragraphs: [
                    "Fruiting potential is moderate.",
                    "Fruit production depends on flowering, pollination, individual material, tree health and seasonal conditions.",
                    "Heavy fruit loads can consume resources and should be evaluated against tree health and development objectives.",
                    "Fruit is not required for a convincing Wild Olive bonsai.",
                ]
            ),
            SpeciesProfileSection(
                id: "bark-trunk",
                title: "Bark and Trunk",
                paragraphs: [
                    "The trunk is one of the defining features of Wild Olive bonsai. Mature bark character is excellent.",
                    "Important characteristics may include rugged bark, twisting movement, hollows, cavities, aged scars, deadwood and strong live veins.",
                    "Do not assume every specimen should have dramatic hollowing or deadwood.",
                    "The existing material should guide the design.",
                    "Do not attempt to create artificial age through random damage.",
                    "The objective is natural ancient character supported by healthy living structure.",
                ]
            ),
            SpeciesProfileSection(
                id: "roots-nebari",
                title: "Roots and Nebari",
                paragraphs: [
                    "Healthy roots support vigour, recovery, back-budding, ramification and long-term health.",
                    "Root development is good. Objectives include balanced roots, stable radial development, strong surface-root character and gradual nebari improvement.",
                    "Root correction should be gradual.",
                    "Do not completely redesign an established root system in one operation.",
                ]
            ),
            SpeciesProfileSection(
                id: "light",
                title: "Light",
                paragraphs: [
                    "Wild Olive requires strong outdoor light.",
                    "Adequate light supports healthy growth, compact foliage, ramification, branch development and overall vigour.",
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
                    "Monitor trees during cold periods, strong wind, dry conditions and rapid weather changes.",
                ]
            ),
            SpeciesProfileSection(
                id: "watering",
                title: "Watering",
                paragraphs: [
                    "General principle: Allow appropriate drying between waterings · Avoid repeated severe drought · Maintain root aeration · Avoid permanent saturation.",
                    "Water demand is low to moderate once established, depending on conditions.",
                    "Wild Olive material is adapted to Mediterranean conditions, but bonsai containers contain limited root volume.",
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
                    "Fertilization should support healthy growth, structural development, ramification and recovery after work.",
                    "During structural development: healthy trees may receive stronger nutritional support where appropriate.",
                    "During refinement: avoid excessive fertilization that produces coarse shoots, long internodes or excessive foliage mass.",
                    "Key principle: Feed according to tree condition and development objective.",
                    "Do not assume that Wild Olive requires minimal fertilization simply because it is adapted to dry Mediterranean environments.",
                ]
            ),
            SpeciesProfileSection(
                id: "pruning",
                title: "Pruning",
                paragraphs: [
                    "Wild Olive responds well to pruning. Pruning response is excellent.",
                    "Pruning can be used for structural development, branch selection, branch replacement, ramification and silhouette refinement.",
                    "During development: allow selected shoots to extend where thickness or taper is required.",
                    "During refinement: use controlled pruning and shoot selection to maintain fine ramification, compact proportions, branch hierarchy and visible structure.",
                    "Do not repeatedly shorten all growth uniformly.",
                    "The objective is: Purposeful development · Controlled refinement · Healthy regenerative capacity.",
                ]
            ),
            SpeciesProfileSection(
                id: "back-budding",
                title: "Back-budding",
                paragraphs: [
                    "Wild Olive is valued for its potential to produce useful new growth from existing wood. Back-budding is excellent under healthy conditions.",
                    "Response depends on tree health, vigour, light, branch condition, pruning strategy and root health.",
                    "Do not describe back-budding as guaranteed under all conditions.",
                    "Old or weak material may respond differently.",
                    "Preserve useful interior growth whenever possible.",
                ]
            ),
            SpeciesProfileSection(
                id: "ramification",
                title: "Ramification",
                paragraphs: [
                    "Fine ramification can be developed through repeated healthy growth cycles, controlled pruning, shoot selection, branch selection and balanced vigour. Ramification potential is excellent.",
                    "Do not allow dense foliage to completely hide the internal structure.",
                    "Maintain branch hierarchy, natural spacing, visible structure and proportionate foliage mass.",
                    "The objective is: Fine ramification · Compact canopy · Visible living structure.",
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
                    "Monitor wire carefully during active growth.",
                    "Do not force rigid branches into extreme bends.",
                ]
            ),
            SpeciesProfileSection(
                id: "deadwood-potential",
                title: "Deadwood and Hollowing",
                paragraphs: [
                    "Natural deadwood and hollowing may be major design features. Deadwood potential is excellent.",
                    "Potential characteristics include aged cavities, trunk hollows, deadwood areas, natural scars and strong live veins surrounding old dead areas.",
                    "Do not describe aggressive carving as mandatory.",
                    "Deadwood development should support the natural design, respect live structure, preserve structural stability and avoid unnecessary weakening.",
                    "Natural features should be preserved whenever possible.",
                    "Artificial carving should only support the existing story of the tree.",
                ]
            ),
            SpeciesProfileSection(
                id: "defoliation",
                title: "Defoliation and Leaf Management",
                paragraphs: [
                    "Do not present complete defoliation as standard Wild Olive management. Full defoliation is not routine management.",
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
                    "Wild Olive bonsai often benefit from patience.",
                    "Where additional thickness is required: allow selected leaders to extend, use sacrifice growth where appropriate, provide sufficient root space and avoid premature refinement.",
                    "Collected or naturally aged material may already possess sufficient trunk character.",
                    "In those cases, development should focus on branch structure, live veins, ramification, root health and proportionate foliage.",
                    "Do not force additional trunk development where the material already possesses sufficient mature character.",
                ]
            ),
            SpeciesProfileSection(
                id: "nebari-development",
                title: "Nebari Development",
                paragraphs: [
                    "Nebari should be developed gradually.",
                    "Potential approaches include early root selection, radial root planning, staged root correction, appropriate development containers and gradual exposure of useful surface roots.",
                    "The objective is a stable and visually convincing base appropriate to a mature Wild Olive bonsai.",
                ]
            ),
            SpeciesProfileSection(
                id: "propagation",
                title: "Propagation",
                paragraphs: [
                    "Wild Olive material may be propagated using established horticultural methods including seed, cuttings and layering.",
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
                    "Spring: monitor new growth, watering demand, overall vigour, pest activity and recovery from winter. Spring is important for assessing branch development, structural priorities and root health. Major work should be coordinated with local climate and tree condition.",
                    "Summer: monitor watering demand, shoot growth, foliage health, pest activity and wire marks. Wild Olive may grow strongly under favourable warm conditions. Summer growth should be managed according to whether shoots are intended for structural development, branch development or refinement. Do not suppress all vigorous growth where development is still required.",
                    "Autumn is important for evaluating seasonal growth, reviewing branch structure, assessing overall tree health and preparing for cooler conditions. Growth activity depends strongly on local climate. Do not apply one universal autumn schedule.",
                    "Winter: Wild Olive should receive appropriate outdoor conditions.",
                    "Do not describe Wild Olive as universally frost hardy.",
                    "Winter management depends strongly on local minimum temperatures, duration of freezing, wind exposure, container depth, root protection and tree health.",
                    "Cold tolerance also depends on local climate, tree health and moisture conditions.",
                    "Shallow bonsai roots are significantly more exposed to cold than roots in open ground.",
                    "Protect the root system when required. Do not maintain permanently indoors as a substitute for appropriate seasonal cultivation.",
                ]
            ),
            SpeciesProfileSection(
                id: "styles",
                title: "Bonsai Styles",
                paragraphs: [
                    "Wild Olive is particularly suitable for Informal Upright, Slanting, Semi-Cascade, Multi-trunk Style, Clump Style, Naturalistic Bonsai and Ancient Tree Style.",
                    "It is especially effective when styling emphasises ancient trunk character, natural hollows, live veins, rugged movement and compact foliage.",
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
                    "Collected or mature material: establish recovery, protect existing live structure, assess root health, identify usable branches and avoid premature heavy refinement.",
                    "In training: develop secondary branches, improve branch hierarchy, build ramification and strengthen living structure.",
                    "Refinement: maintain balanced vigour, improve tertiary ramification, control shoot extension, preserve visible branch structure and maintain compact proportions.",
                    "Exhibition / mature refined tree: maintain health, preserve established structure, preserve natural deadwood, maintain live veins, maintain balanced ramification and avoid unnecessary major intervention.",
                ]
            ),
            SpeciesProfileSection(
                id: "attention",
                title: "Species-Specific Attention",
                paragraphs: [
                    "These attention points are operational tendencies. They must still be interpreted for the individual tree.",
                ],
                bullets: [
                    "Wild Olive material may vary significantly in botanical origin and growth characteristics",
                    "Bonsai World uses Olea europaea var. sylvestris as the practical profile for Wild Olive material",
                    "Naturally small foliage is a major bonsai advantage",
                    "Strong back-budding depends on health and vigour",
                    "Preserve useful interior growth",
                    "Exceptional trunk character should be respected rather than artificially exaggerated",
                    "Natural hollows and deadwood may be major design features",
                    "Live vein structure must be protected",
                    "Landscape drought tolerance does not mean shallow bonsai tolerate repeated severe drying",
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
