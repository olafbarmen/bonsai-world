//
//  PyracanthaCoccineaSpeciesProfile.swift
//  Bonsai World
//
//  Species Profile — Pyracantha coccinea (Scarlet Firethorn).
//  Independent botanical species in Rosaceae. Knowledge status: Reviewed.
//  Separate from other Pyracantha species and horticultural hybrids.
//

import Foundation

enum PyracanthaCoccineaSpeciesProfile {
    /// Identity used by Botanical Library / ``SpeciesPreviewData``.
    static let botanicalLibraryName = "Pyracantha coccinea"
    /// Scientific name for Species Profile display (binomial; no botanical authority).
    static let scientificName = "Pyracantha coccinea"

    static var profile: SpeciesProfile {
        SpeciesProfile(
            speciesID: BotanicalKnowledgeIDs.pyracanthaCoccinea,
            scientificName: scientificName,
            commonNames: ["Scarlet Firethorn", "Firethorn"],
            family: "Rosaceae",
            plantType: "Evergreen to semi-evergreen thorny shrub",
            originSummary: "Southern Europe and parts of western Asia.",
            knowledgeStatus: .reviewed,
            traits: traits,
            foliageSizeLabel: "Foliage",
            foliageReductionLabel: "Leaf reduction",
            summaryLine: "Evergreen to semi-evergreen · Thorny branches · Small leaves · White flowers · Bright orange to red fruit · Strong ramification potential · Vigorous growth · Excellent flowering and fruiting bonsai potential",
            attentionHighlights: [
                "Pyracantha coccinea is a thorny species and handling requires care",
                "Do not assume all Firethorn in cultivation is Pyracantha coccinea",
                "Cultivar identity can influence fruit colour and growth habit",
                "Evergreen or semi-evergreen behaviour depends on climate",
                "Flowers and fruit are important seasonal features but should not replace structural development",
                "Heavy fruit loads can consume resources",
                "Good back-budding depends on tree health and branch condition",
                "Preserve useful interior growth",
                "Avoid repeated severe drought",
                "Avoid permanently saturated substrate",
                "Full defoliation is not routine management",
                "Young branches are more suitable for wiring than older branches",
                "Thorns should be considered during all styling work",
                "Monitor wire during active growth",
                "Seasonal rest is required in temperate cultivation",
                "Shallow bonsai roots are more exposed than roots in open ground",
                "Do not move indoors for routine winter care",
            ],
            sections: sections,
            principleNote: """
            Pyracantha coccinea is particularly valuable as bonsai because it can combine small foliage, strong branching, flowers, colourful fruit, thorny character and convincing mature structure.

            The tree must be managed as both a structural bonsai and a flowering and fruiting bonsai.

            Do not sacrifice all branch structure in pursuit of maximum flowers or fruit.

            The strongest bonsai development depends on balancing vegetative growth, branch development, ramification, flowering, fruiting and long-term tree health.

            The objective is: Strong structure · Fine ramification · Sustainable flowering · Controlled fruiting.

            The individual tree must always be assessed according to health, vigour, cultivar, climate, fruit load, flowering, root condition, development stage and recent work.
            """,
            sourcesNote: """
            Profile content is synthesised from recognised botanical, horticultural and bonsai authorities into Bonsai World editorial language.

            Botanical taxonomy and distribution draw on recognised sources such as Royal Botanic Gardens, Kew and other botanical databases for accepted scientific name, family and native range.

            Horticultural context may draw on recognised botanical gardens, arboreta, horticultural institutions and established horticultural references for Pyracantha.

            Bonsai-specific cultivation and refinement knowledge draws on established bonsai references and recognised professional practice, kept distinct from other Pyracantha species and horticultural hybrids.

            Verified botanical information, general horticultural cultivation, cultivar variation, evergreen and semi-evergreen behaviour, and bonsai-specific practice are kept distinct. Do not copy source wording.
            """
        )
    }

    private static let traits = SpeciesProfileTraits(
        deciduous: false,
        growthStrength: "Strong",
        growthSpeed: "Moderate to Fast",
        leafSize: "Evergreen to semi-evergreen depending on climate",
        foliageReduction: "Not routine management",
        ramificationPotential: "Excellent",
        backBudding: "Good under healthy conditions",
        rootDevelopment: "Strong",
        nebariPotential: "Good potential",
        trunkDevelopment: "Moderate to Strong",
        barkDevelopment: "Good mature character",
        wiring: "Good on young branches",
        defoliation: "Not routine management",
        airLayering: "Where appropriate for the individual material",
        threadGrafting: "Where structural correction is required",
        rootGrafting: "Where appropriate",
        beginnerSuitability: "Moderate",
        bonsaiSuitability: "Excellent",
        difficulty: "Intermediate",
        winterDormancyRequired: true,
        winterHardiness: "Seasonal rest required in temperate climates",
        rootFrostSensitivity: "Moderate in shallow bonsai containers"
    )

    private static var sections: [SpeciesProfileSection] {
        [
            SpeciesProfileSection(
                id: "taxonomic-context",
                title: "Taxonomic Context",
                paragraphs: [
                    "Pyracantha coccinea is an independent botanical species in the rose family (Rosaceae).",
                    "Primary Bonsai World display identity: Pyracantha coccinea · Scarlet Firethorn.",
                    "Firethorn may be used as supporting terminology. It does not replace Scarlet Firethorn as the primary common name.",
                    "Family: Rosaceae. Plant type: evergreen to semi-evergreen thorny shrub.",
                    "Native range: southern Europe and parts of western Asia.",
                    "Do not confuse Pyracantha coccinea with other Pyracantha species or horticultural hybrids.",
                    "Do not assume all Firethorn sold in nurseries is Pyracantha coccinea.",
                    "Bonsai World hierarchy: Species → cultivar / horticultural selection → Individual Tree.",
                ]
            ),
            SpeciesProfileSection(
                id: "overview",
                title: "Species Overview",
                paragraphs: [
                    "Pyracantha coccinea is a thorny woody shrub belonging to the Rosaceae family.",
                    "It is valued in bonsai for its strong ornamental character throughout the year.",
                    "Important features include relatively small leaves, dense branching potential, spring and early summer flowering, colourful berries, thorny branches and good response to pruning.",
                    "The species can create convincing bonsai at relatively small scales.",
                    "A mature tree should remain visually convincing before flowering, after flowering, while carrying fruit and during winter structure.",
                    "Flowers and berries should enhance the bonsai rather than compensate for weak structure.",
                ],
                bullets: [
                    "Thorny woody shrub",
                    "Member of the Rosaceae family",
                    "Evergreen to semi-evergreen depending on climate",
                    "Small leaves",
                    "White flowers",
                    "Bright orange to red fruit",
                    "Good ramification potential",
                    "Strong response to pruning",
                    "Good back-budding potential",
                    "Strong ornamental seasonal character",
                    "Requires outdoor cultivation",
                    "Seasonal rest required",
                ]
            ),
            SpeciesProfileSection(
                id: "cultivars",
                title: "Cultivars",
                paragraphs: [
                    "Pyracantha is widely represented in horticulture by named cultivars and selections.",
                    "Cultivars may differ in growth habit, vigour, fruit colour, fruit abundance, leaf characteristics and mature size.",
                    "Examples encountered in horticulture may include selections such as Orange Glow, Red Column and Soleil d'Or.",
                    "These examples are not the only important cultivars, and they should not be assumed to belong to Pyracantha coccinea.",
                    "Cultivar and species identity can matter. Individual cultivar profiles are not created here.",
                    "The primary profile remains Pyracantha coccinea.",
                ]
            ),
            SpeciesProfileSection(
                id: "natural-growth",
                title: "Natural Growth and Vigour",
                paragraphs: [
                    "Pyracantha coccinea can produce strong seasonal growth.",
                    "Growth strength depends on root health, temperature, light, available root space, fertilization, watering and development stage.",
                    "During structural development: allow selected shoots and leaders to extend where trunk thickness is required, branch thickness is required or taper is being developed.",
                    "During refinement: control excessively long shoots, coarse extension, dense outer growth and branch congestion.",
                    "The objective is: Strong useful growth during development · Controlled growth during refinement.",
                ]
            ),
            SpeciesProfileSection(
                id: "thorns",
                title: "Thorns",
                paragraphs: [
                    "Thorns are an important species characteristic.",
                    "They should be considered during wiring, pruning, repotting, routine handling and display design.",
                    "Do not recommend unnecessary removal of all thorns.",
                    "Some thorn structure may contribute to the natural character of the bonsai.",
                    "Where thorns interfere with branch development, wiring, handling or design, they may be selectively managed.",
                    "Safety and tree handling should be considered during all work.",
                ]
            ),
            SpeciesProfileSection(
                id: "foliage",
                title: "Foliage",
                paragraphs: [
                    "Pyracantha coccinea generally produces foliage well suited to bonsai scale.",
                    "Do not describe the species as uniformly evergreen under all climates. Leaf retention may vary according to climate, winter temperatures, exposure and individual tree condition.",
                    "The objective is healthy foliage, balanced vigour, fine branch visibility and natural proportions.",
                    "Avoid excessive fertilization where it produces coarse growth, excessively long internodes or unnecessary loss of visual refinement.",
                ]
            ),
            SpeciesProfileSection(
                id: "flowering",
                title: "Flowering",
                paragraphs: [
                    "Pyracantha coccinea produces clusters of small white flowers. Flowering potential is excellent.",
                    "Flowering is an important part of the annual development cycle.",
                    "Flower production should be managed in relation to branch development, pruning, vigour, fruiting objectives and overall tree health.",
                    "Do not apply one universal pruning calendar.",
                    "The objective is healthy structure, sustainable flowering and future fruit potential.",
                ]
            ),
            SpeciesProfileSection(
                id: "fruit",
                title: "Fruit",
                paragraphs: [
                    "Colourful berries are one of the defining ornamental features of Pyracantha coccinea. Fruiting potential is excellent.",
                    "Fruit display can create significant seasonal interest.",
                    "Fruit production depends on factors including flowering success, pollination, tree health, weather and seasonal conditions.",
                    "Heavy fruit production can consume substantial resources.",
                    "Evaluate fruit retention according to tree health, development stage, branch strength, root condition and refinement objectives.",
                    "Do not automatically retain every fruit.",
                    "The objective is a visually balanced fruit display, a healthy tree and sustainable future growth.",
                ]
            ),
            SpeciesProfileSection(
                id: "bark-trunk",
                title: "Bark and Trunk",
                paragraphs: [
                    "Pyracantha coccinea can develop convincing mature trunks over time. Mature bark character is good.",
                    "Maturity should be developed through trunk thickness, taper, movement, branch structure and natural bark development.",
                    "Do not attempt to artificially force age through unnecessary damage.",
                    "The objective is a convincing mature thorny shrub or small tree represented at bonsai scale.",
                ]
            ),
            SpeciesProfileSection(
                id: "roots-nebari",
                title: "Roots and Nebari",
                paragraphs: [
                    "Healthy roots support seasonal growth, flowering, fruiting, recovery and ramification.",
                    "Root development is strong. Objectives include balanced root development, healthy root density, stable support and gradual nebari improvement.",
                    "Root correction should be performed gradually.",
                    "Do not attempt to completely redesign an established root system in one operation.",
                ]
            ),
            SpeciesProfileSection(
                id: "light",
                title: "Light",
                paragraphs: [
                    "Pyracantha coccinea should be cultivated outdoors.",
                    "Adequate light supports healthy growth, flowering, fruiting, compact development and balanced vigour.",
                    "The exact growing position depends on local climate, temperature, tree condition and development stage.",
                    "Do not recommend permanent indoor cultivation.",
                ]
            ),
            SpeciesProfileSection(
                id: "wind",
                title: "Wind",
                paragraphs: [
                    "Moderate air movement is beneficial.",
                    "Strong wind can increase water demand, damage tender growth, stress fruit-bearing branches and dry shallow bonsai containers rapidly.",
                    "Monitor trees during strong wind, fruiting periods, hot weather and dry periods.",
                ]
            ),
            SpeciesProfileSection(
                id: "watering",
                title: "Watering",
                paragraphs: [
                    "General principle: Maintain adequate moisture · Avoid repeated severe drought · Maintain root aeration · Avoid permanent saturation.",
                    "Water demand is moderate.",
                    "Watering frequency depends on temperature, sunlight, wind, foliage mass, fruit load, container size, substrate, root mass and development stage.",
                    "Do not water according to a fixed timetable.",
                    "Water according to substrate condition, weather and individual tree requirements.",
                    "Avoid both repeated severe drought and permanently saturated substrate.",
                ]
            ),
            SpeciesProfileSection(
                id: "soil",
                title: "Soil",
                paragraphs: [
                    "Do not prescribe one universal soil recipe.",
                    "Desired characteristics include good drainage, strong aeration, stable particle structure, sufficient moisture retention and support for healthy root development.",
                    "The final soil mix depends on local climate, rainfall, watering habits, container depth, tree size, development stage and root condition.",
                    "Follow Bonsai World Soil Module principles.",
                    "Do not duplicate the complete Soil Module inside this profile.",
                ]
            ),
            SpeciesProfileSection(
                id: "fertilizing",
                title: "Fertilizing",
                paragraphs: [
                    "Fertilization should support tree health, structural development, ramification, flowering and fruiting.",
                    "During structural development: healthy trees may receive stronger nutritional support where appropriate.",
                    "During refinement: avoid excessive fertilization that produces coarse extension growth, excessive internode length or unnecessary loss of visual refinement.",
                    "Key principle: Feed according to tree condition and development objective.",
                    "Do not imply that maximum fertilization always produces the best bonsai.",
                ]
            ),
            SpeciesProfileSection(
                id: "pruning",
                title: "Pruning",
                paragraphs: [
                    "Pyracantha coccinea responds well to pruning.",
                    "Pruning can be used for structural development, branch selection, branch replacement, ramification and silhouette refinement.",
                    "Pruning timing must consider flowering, fruiting, seasonal growth and individual tree health.",
                    "Do not apply one universal pruning date.",
                    "During development: allow selected shoots to extend where thickness or taper is required.",
                    "During refinement: use controlled pruning and shoot selection to maintain fine ramification, branch visibility, natural structure, flowering potential and fruiting potential.",
                    "The objective is: Strong structure · Fine ramification · Sustainable flowering · Controlled fruit display.",
                ]
            ),
            SpeciesProfileSection(
                id: "back-budding",
                title: "Back-budding",
                paragraphs: [
                    "Pyracantha coccinea generally responds well to pruning and can produce useful new growth. Back-budding is good under healthy conditions.",
                    "Response depends on tree health, vigour, light, branch age, pruning strategy and root condition.",
                    "Do not describe back-budding as guaranteed on every old branch.",
                    "Preserve useful interior growth whenever possible.",
                ]
            ),
            SpeciesProfileSection(
                id: "ramification",
                title: "Ramification",
                paragraphs: [
                    "Fine ramification is one of the major bonsai strengths of Pyracantha coccinea. Ramification potential is excellent.",
                    "Ramification develops through repeated healthy growth cycles, controlled pruning, shoot selection, branch selection and balanced vigour.",
                    "Avoid allowing the canopy to become dominated by dense outer growth, long extension shoots, excessive crossing branches or congested branching.",
                    "The objective is fine branching, visible structure, natural branch hierarchy and a proportionate canopy.",
                ]
            ),
            SpeciesProfileSection(
                id: "wiring",
                title: "Wiring",
                paragraphs: [
                    "Young branches can generally be wired. Wiring is good on young branches.",
                    "Wiring can be used to establish movement, improve branch placement, position young branches and develop secondary structure.",
                    "Older branches become progressively less flexible.",
                    "Thorns must be considered during wiring and handling.",
                    "Before major bends, assess branch thickness, flexibility, age, health and structural importance.",
                    "Monitor wire carefully during active growth.",
                ]
            ),
            SpeciesProfileSection(
                id: "deadwood-potential",
                title: "Deadwood Potential",
                paragraphs: [
                    "Deadwood potential is limited. Deadwood is not normally a defining feature of Pyracantha bonsai.",
                    "Natural scars and aged features may occasionally contribute to character.",
                    "Do not create dramatic artificial deadwood as a routine styling technique.",
                    "Any feature should appear natural, support the design and not compromise tree health.",
                ]
            ),
            SpeciesProfileSection(
                id: "defoliation",
                title: "Defoliation and Leaf Management",
                paragraphs: [
                    "Do not present complete defoliation as standard management. Full defoliation is not routine management for Pyracantha coccinea.",
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
                    "Timing must account for local climate, seasonal growth cycle, flowering and fruiting cycle, and individual tree condition.",
                ]
            ),
            SpeciesProfileSection(
                id: "trunk-development",
                title: "Trunk Development",
                paragraphs: [
                    "Pyracantha coccinea can develop convincing trunk thickness when strong growth is allowed where required.",
                    "Where additional thickness is required: allow selected leaders to extend, use sacrifice growth where appropriate, provide sufficient root space and avoid premature refinement.",
                    "Once sufficient structural development has been achieved, shift focus toward taper, branch hierarchy, ramification, flowering, fruiting and mature proportions.",
                    "Grow strongly where development is required. Control strongly where refinement is required.",
                ]
            ),
            SpeciesProfileSection(
                id: "nebari-development",
                title: "Nebari Development",
                paragraphs: [
                    "Nebari should be developed gradually.",
                    "Potential approaches include early root selection, radial root planning, staged root correction, appropriate development containers and gradual improvement of surface roots.",
                    "The objective is a stable and visually convincing base appropriate to a mature Pyracantha bonsai.",
                ]
            ),
            SpeciesProfileSection(
                id: "propagation",
                title: "Propagation",
                paragraphs: [
                    "Pyracantha coccinea may be propagated using established horticultural methods including seed, cuttings and layering.",
                    "Seed-grown material may offer genetic variation. Vegetative propagation preserves the characteristics of the parent material.",
                    "Detailed procedures belong in Bonsai World Propagation Knowledge Articles.",
                ]
            ),
            SpeciesProfileSection(
                id: "pests",
                title: "Pests and Problems",
                paragraphs: [
                    "Relevant risks may include aphids, scale insects, spider mites, leaf-feeding insects, fungal leaf problems, bacterial disease where applicable, root problems caused by poor drainage, drought stress and damage caused by excessive fruit load on weak branches.",
                    "Do not provide generic treatment instructions.",
                    "Diagnosis and treatment belong in Care → Pest Management and Care → Disease & Problems.",
                ]
            ),
            SpeciesProfileSection(
                id: "seasonal",
                title: "Seasonal Profile",
                paragraphs: [
                    "Spring: monitor bud development, flowering, watering demand, new shoot growth and pest activity. Spring is important for balancing flowering, structural growth and future fruit production. Avoid unnecessary heavy work while the tree is under significant stress.",
                    "Summer: monitor shoot extension, watering demand, foliage health, pest activity and wire marks. Summer growth should be managed according to whether shoots are intended for structural development, branch development or refinement. Do not suppress all vigorous growth where development is still required.",
                    "Autumn is particularly important for fruit display, evaluating seasonal growth, reviewing branch structure, assessing overall vigour and preparing for winter. The fruit display should not override the health requirements of the tree.",
                    "Winter: Pyracantha coccinea should remain outdoors. Its foliage behaviour may vary according to climate and winter conditions.",
                    "Winter management depends on local minimum temperatures, duration of freezing, wind exposure, container depth, root protection and tree health.",
                    "Shallow bonsai roots are more exposed than roots in open ground.",
                    "Protect the root system when required while allowing appropriate seasonal rest. Do not maintain permanently indoors.",
                ]
            ),
            SpeciesProfileSection(
                id: "styles",
                title: "Bonsai Styles",
                paragraphs: [
                    "Pyracantha coccinea is particularly suitable for Informal Upright, Slanting, Semi-Cascade, Cascade, Multi-trunk Style, Clump Style, Naturalistic Bonsai and Small Bonsai and Shohin.",
                    "It is especially effective when styling emphasises mature thorny character, visible branch structure, fine ramification, flowers and seasonal fruit.",
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
                    "In training: develop secondary branches, improve branch hierarchy, build ramification and establish sustainable flowering and fruiting potential.",
                    "Refinement: maintain balanced vigour, improve tertiary ramification, control shoot extension, preserve flowering and fruiting potential and maintain visible branch structure.",
                    "Exhibition / mature refined tree: maintain health, preserve established structure, manage flowering and fruiting, maintain balanced ramification and avoid unnecessary major intervention.",
                ]
            ),
            SpeciesProfileSection(
                id: "attention",
                title: "Species-Specific Attention",
                paragraphs: [
                    "These attention points are operational tendencies. They must still be interpreted for the individual tree.",
                ],
                bullets: [
                    "Pyracantha coccinea is a thorny species and handling requires care",
                    "Do not assume all Firethorn in cultivation is Pyracantha coccinea",
                    "Cultivar identity can influence fruit colour and growth habit",
                    "Evergreen or semi-evergreen behaviour depends on climate",
                    "Flowers and fruit are important seasonal features but should not replace structural development",
                    "Heavy fruit loads can consume resources",
                    "Good back-budding depends on tree health and branch condition",
                    "Preserve useful interior growth",
                    "Avoid repeated severe drought",
                    "Avoid permanently saturated substrate",
                    "Full defoliation is not routine management",
                    "Young branches are more suitable for wiring than older branches",
                    "Thorns should be considered during all styling work",
                    "Monitor wire during active growth",
                    "Seasonal rest is required in temperate cultivation",
                    "Shallow bonsai roots are more exposed than roots in open ground",
                    "Do not move indoors for routine winter care",
                ]
            ),
        ]
    }
}
