//
//  WisteriaFloribundaSpeciesProfile.swift
//  Bonsai World
//
//  Species Profile — Wisteria floribunda (Japanese Wisteria).
//  Independent botanical species in Fabaceae. Knowledge status: Reviewed.
//  Separate from Wisteria sinensis, hybrids and named cultivars.
//

import Foundation

enum WisteriaFloribundaSpeciesProfile {
    /// Identity used by Botanical Library / ``SpeciesPreviewData``.
    static let botanicalLibraryName = "Wisteria floribunda"
    /// Scientific name for Species Profile display (binomial; no botanical authority).
    static let scientificName = "Wisteria floribunda"

    static var profile: SpeciesProfile {
        SpeciesProfile(
            speciesID: BotanicalKnowledgeIDs.wisteriaFloribunda,
            scientificName: scientificName,
            commonNames: ["Japanese Wisteria"],
            family: "Fabaceae",
            plantType: "Deciduous flowering woody climber",
            originSummary: "Japan.",
            knowledgeStatus: .reviewed,
            traits: traits,
            foliageSizeLabel: "Foliage",
            foliageReductionLabel: "Leaf reduction",
            summaryLine: "Deciduous · Vigorous growth · Woody climbing habit · Spectacular hanging flowers · Compound foliage · Powerful trunk potential · Long-term bonsai development · Excellent flowering bonsai potential",
            attentionHighlights: [
                "Wisteria floribunda is naturally a vigorous woody climber",
                "Do not treat it as a naturally compact tree",
                "Strong growth is required for major structural development",
                "Uncontrolled growth must be managed during refinement",
                "Flowering depends strongly on maturity and cultivation history",
                "Do not promise flowering after a specific number of years",
                "Cultivar identity can affect flower characteristics",
                "The tree should remain visually convincing outside the flowering season",
                "Heavy flowering can consume significant resources",
                "Good back-budding depends on tree health and branch condition",
                "Preserve useful interior growth",
                "Avoid repeated severe drought during active growth",
                "Avoid permanently saturated substrate",
                "Pruning timing can affect flowering",
                "Full defoliation is not routine management",
                "Older branches become increasingly rigid",
                "Monitor wire carefully due to strong seasonal growth",
                "Winter dormancy is required",
                "Shallow bonsai roots are more exposed than roots in open ground",
                "Do not move indoors for routine winter care",
            ],
            sections: sections,
            principleNote: """
            Wisteria floribunda is a powerful and vigorous species.

            Japanese Wisteria is a vigorous climbing woody plant and must not be managed like a naturally compact tree species.

            Do not continuously restrict all growth in an attempt to maintain immediate refinement.

            The strongest bonsai development depends on understanding the difference between growth for trunk development, growth for branch development, growth for flowering and growth for refinement.

            During development, selected shoots and leaders may need significant freedom to extend. During refinement, excessive growth must be controlled regularly.

            The objective is: Strong structure · Mature trunk · Controlled ramification · Sustainable flowering.

            The individual tree must always be assessed according to health, vigour, flowering maturity, cultivar, climate, root condition, development stage and recent work.
            """,
            sourcesNote: """
            Profile content is synthesised from recognised botanical, horticultural and bonsai authorities into Bonsai World editorial language.

            Botanical taxonomy and distribution draw on recognised sources such as Royal Botanic Gardens, Kew and other botanical databases for accepted scientific name, family and native range.

            Horticultural context may draw on recognised Japanese botanical institutions, botanical gardens, arboreta, established horticultural references for Wisteria and recognised horticultural societies.

            Bonsai-specific cultivation and refinement knowledge draws on established bonsai references and recognised professional practice for flowering bonsai, kept distinct from Wisteria sinensis, hybrids and named cultivars.

            Verified botanical information, general horticultural cultivation, cultivar variation and bonsai-specific practice are kept distinct. Do not copy source wording.
            """
        )
    }

    private static let traits = SpeciesProfileTraits(
        deciduous: true,
        growthStrength: "Very Strong",
        growthSpeed: "Fast",
        leafSize: "Deciduous · Compound leaves",
        foliageReduction: "Not routine management",
        ramificationPotential: "Good with correct management",
        backBudding: "Good under healthy conditions",
        rootDevelopment: "Strong",
        nebariPotential: "Excellent potential",
        trunkDevelopment: "Strong",
        barkDevelopment: "Excellent mature character",
        wiring: "Moderate",
        defoliation: "Not routine management",
        airLayering: "Where appropriate for the individual material",
        threadGrafting: "Where structural correction is required",
        rootGrafting: "Where appropriate",
        beginnerSuitability: "Moderate",
        bonsaiSuitability: "Excellent",
        difficulty: "Intermediate to Advanced",
        winterDormancyRequired: true,
        winterHardiness: "Outdoor deciduous — winter dormancy required",
        rootFrostSensitivity: "Moderate in shallow bonsai containers"
    )

    private static var sections: [SpeciesProfileSection] {
        [
            SpeciesProfileSection(
                id: "taxonomic-context",
                title: "Taxonomic Context",
                paragraphs: [
                    "Wisteria floribunda is an independent botanical species in the pea family (Fabaceae).",
                    "Primary Bonsai World display identity: Wisteria floribunda · Japanese Wisteria.",
                    "Family: Fabaceae. Plant type: deciduous flowering woody climber.",
                    "Native range: Japan.",
                    "Maintain a clear distinction between Wisteria floribunda, Wisteria sinensis, hybrids and horticultural material, and named Wisteria cultivars.",
                    "Do not confuse Wisteria floribunda with Wisteria sinensis.",
                    "Do not treat all Wisteria used for bonsai as identical.",
                    "Cultivars may differ significantly in flowering colour, raceme length, flowering timing and growth habit.",
                    "Bonsai World hierarchy: Species → cultivar / horticultural selection → Individual Tree.",
                ]
            ),
            SpeciesProfileSection(
                id: "overview",
                title: "Species Overview",
                paragraphs: [
                    "Wisteria floribunda is a deciduous woody climber native to Japan.",
                    "It is highly valued as bonsai because mature material can combine powerful trunks, aged bark, dramatic branch movement, long flower racemes, fine branch development and strong seasonal character.",
                    "Its flowers can create one of the most dramatic displays in flowering bonsai.",
                    "However, flowering should not be treated as the only objective.",
                    "The strongest Wisteria bonsai remain convincing through trunk quality, branch structure, proportion, mature bark and seasonal foliage.",
                    "The tree should remain visually convincing when not in flower.",
                ],
                bullets: [
                    "Deciduous woody climber",
                    "Native to Japan",
                    "Very vigorous growth",
                    "Spectacular hanging flower racemes",
                    "Compound foliage",
                    "Strong trunk development potential",
                    "Excellent mature bark potential",
                    "Strong root development",
                    "Good back-budding potential when healthy",
                    "Good ramification potential with correct management",
                    "Requires outdoor cultivation",
                    "Requires winter dormancy",
                ]
            ),
            SpeciesProfileSection(
                id: "cultivars",
                title: "Cultivars",
                paragraphs: [
                    "Wisteria floribunda includes numerous named horticultural cultivars.",
                    "Cultivars may differ in flower colour, flower form, raceme length, flowering timing, growth habit and vigour.",
                    "Cultivars frequently encountered in horticulture and bonsai may include examples such as Macrobotrys, Royal Purple, Honbeni and Alba.",
                    "These examples are not the only important cultivars, and they should not be assumed to behave identically in bonsai cultivation.",
                    "Cultivar identity can matter. This section explains that variation; individual cultivar profiles are not created here.",
                    "The primary profile remains Wisteria floribunda.",
                ]
            ),
            SpeciesProfileSection(
                id: "natural-growth",
                title: "Natural Growth and Vigour",
                paragraphs: [
                    "Wisteria floribunda can produce extremely strong seasonal growth.",
                    "Growth strength depends on root health, temperature, light, available root space, fertilization, watering and development stage.",
                    "During structural development: allow selected leaders and sacrifice growth to extend where trunk thickness is required, branch thickness is required or taper is being developed.",
                    "During refinement: control excessively long shoots, coarse extension, overcrowded growth and uncontrolled climbing behaviour.",
                    "Do not continuously restrict all growth.",
                    "The objective is: Maximum useful growth during development · Controlled growth during refinement.",
                ]
            ),
            SpeciesProfileSection(
                id: "foliage",
                title: "Foliage",
                paragraphs: [
                    "Wisteria produces compound leaves.",
                    "Leaf and leaflet size can become visually disproportionate when growth is excessively strong.",
                    "The objective is healthy foliage, controlled vigour, balanced ramification and visible branch structure.",
                    "Avoid excessive nitrogen-driven growth when the objective is refinement.",
                    "Do not expect foliage refinement to compensate for an undeveloped trunk.",
                ]
            ),
            SpeciesProfileSection(
                id: "flowering",
                title: "Flowering",
                paragraphs: [
                    "Flowering is one of the defining characteristics of Japanese Wisteria bonsai. Flowering potential is excellent.",
                    "Flower production depends on multiple factors including tree maturity, cultivar, pruning history, vigour, seasonal conditions and previous year's growth.",
                    "Do not promise flowering after a specific number of years.",
                    "Young material, seed-grown plants and strongly developing trees may require significant maturity before producing reliable flowering.",
                    "The objective is healthy mature structure, sustainable flowering and proportionate display.",
                ]
            ),
            SpeciesProfileSection(
                id: "flower-management",
                title: "Flower Management",
                paragraphs: [
                    "Heavy flowering can require substantial resources.",
                    "Evaluate flowering according to tree health, trunk and branch strength, development stage and recovery status.",
                    "During major structural development, flowering may not be the primary objective.",
                    "During refinement, flower management should support display quality, long-term tree health and future flowering potential.",
                    "Avoid presenting a single rigid pruning date.",
                    "Flowering and pruning timing depend on local climate, cultivar, seasonal development and individual tree condition.",
                ]
            ),
            SpeciesProfileSection(
                id: "fruit",
                title: "Fruit",
                paragraphs: [
                    "Wisteria floribunda can produce seed pods after successful flowering and pollination. Fruiting is possible, not automatic.",
                    "Fruit production can consume significant resources.",
                    "Evaluate pod retention according to tree health, development objectives and flowering objectives.",
                    "Do not retain heavy fruit loads automatically.",
                ]
            ),
            SpeciesProfileSection(
                id: "bark-trunk",
                title: "Bark and Trunk",
                paragraphs: [
                    "The trunk is one of the most important features of mature Wisteria bonsai. Mature bark character is excellent.",
                    "Older trees can develop powerful trunks, deeply aged bark, dramatic movement, broad bases and impressive taper.",
                    "Wisteria can develop a convincing impression of great age.",
                    "During development, focus on trunk thickness, taper, movement and branch hierarchy.",
                    "Do not move into premature refinement before sufficient structural development has been achieved.",
                ]
            ),
            SpeciesProfileSection(
                id: "roots-nebari",
                title: "Roots and Nebari",
                paragraphs: [
                    "Healthy roots support strong seasonal growth, flowering, recovery, ramification and long-term development.",
                    "Root development is strong. Objectives include balanced radial roots, a strong root system, stable tree support and gradual nebari development.",
                    "Wisteria can develop powerful nebari.",
                    "Root correction should be performed gradually. Do not attempt to completely redesign an established root system in one operation.",
                ]
            ),
            SpeciesProfileSection(
                id: "light",
                title: "Light",
                paragraphs: [
                    "Wisteria floribunda should be cultivated outdoors.",
                    "Adequate light supports healthy growth, flowering, compact development and overall vigour.",
                    "The exact amount of sunlight depends on local climate, temperature, tree condition and development stage.",
                    "Do not recommend permanent indoor cultivation.",
                ]
            ),
            SpeciesProfileSection(
                id: "wind",
                title: "Wind",
                paragraphs: [
                    "Moderate air movement is beneficial.",
                    "Strong wind can increase water demand, damage developing shoots, damage flowers and stress shallow containers.",
                    "Monitor trees during strong wind, flowering and hot weather.",
                ]
            ),
            SpeciesProfileSection(
                id: "watering",
                title: "Watering",
                paragraphs: [
                    "General principle: Maintain adequate moisture during active growth · Avoid severe drought · Maintain root aeration · Avoid permanent saturation.",
                    "Water demand can become moderate to high during strong seasonal growth.",
                    "Watering frequency depends on temperature, sunlight, wind, foliage mass, container size, substrate, root mass and development stage.",
                    "Do not water according to a fixed timetable.",
                    "Water according to substrate condition, weather and individual tree requirements.",
                ]
            ),
            SpeciesProfileSection(
                id: "soil",
                title: "Soil",
                paragraphs: [
                    "Do not prescribe one universal soil recipe.",
                    "Desired characteristics include good drainage, strong aeration, stable particle structure, sufficient moisture retention and support for vigorous roots.",
                    "The final soil mix depends on local climate, rainfall, watering habits, container depth, tree size, development stage and root condition.",
                    "Follow Bonsai World Soil Module principles.",
                    "Do not duplicate the complete Soil Module inside this profile.",
                ]
            ),
            SpeciesProfileSection(
                id: "fertilizing",
                title: "Fertilizing",
                paragraphs: [
                    "Wisteria can respond strongly to fertilization.",
                    "Nutrition should be managed according to tree health, development stage, flowering objectives and vigour.",
                    "During structural development: strong healthy trees may receive significant nutritional support where appropriate.",
                    "During refinement: avoid excessive fertilization that produces uncontrolled extension, coarse foliage or disproportionate internodes.",
                    "Key principle: Feed according to tree condition and development objective.",
                    "Do not imply that maximum fertilizer always produces the best bonsai.",
                ]
            ),
            SpeciesProfileSection(
                id: "pruning",
                title: "Pruning",
                paragraphs: [
                    "Pruning is essential for controlling Wisteria. Response is excellent but requires regular management.",
                    "Pruning can be used for structural development, branch selection, branch replacement, ramification and control of vigorous extension.",
                    "Timing is important because pruning can influence flowering.",
                    "Do not apply one universal pruning calendar.",
                    "During development: allow selected leaders and sacrifice branches to extend where required.",
                    "During refinement: control extension growth regularly while preserving useful branch structure.",
                    "The objective is: Strong structure · Controlled extension · Fine ramification · Sustainable flowering.",
                ]
            ),
            SpeciesProfileSection(
                id: "back-budding",
                title: "Back-budding",
                paragraphs: [
                    "Wisteria can produce useful new shoots following pruning. Back-budding is good under healthy conditions.",
                    "Response depends on tree health, vigour, light, branch age and pruning strategy.",
                    "Do not treat back-budding as guaranteed on every old branch.",
                    "Preserve useful interior growth whenever possible.",
                ]
            ),
            SpeciesProfileSection(
                id: "ramification",
                title: "Ramification",
                paragraphs: [
                    "Wisteria can develop refined branch structures, but strong growth requires active management. Ramification is good with correct management.",
                    "Ramification develops through repeated healthy growth cycles, controlled pruning, shoot selection, branch selection and balanced vigour.",
                    "Avoid allowing the entire canopy to become dominated by long extension shoots, excessively coarse growth or dense outer growth.",
                    "The objective is visible branch hierarchy, natural spacing and fine ramification.",
                ]
            ),
            SpeciesProfileSection(
                id: "wiring",
                title: "Wiring",
                paragraphs: [
                    "Young branches can generally be wired. Wiring response is moderate.",
                    "Wiring can be used to establish branch placement, improve movement, position young branches and refine secondary structure.",
                    "Older branches can become rigid.",
                    "Before major bends, assess branch thickness, flexibility, age, health and structural importance.",
                    "Monitor wire carefully due to vigorous seasonal thickening.",
                ]
            ),
            SpeciesProfileSection(
                id: "deadwood-potential",
                title: "Deadwood Potential",
                paragraphs: [
                    "Deadwood potential is limited. Deadwood is generally not a defining feature of Japanese Wisteria bonsai.",
                    "Natural scars and aged features may contribute to character.",
                    "Do not create artificial dramatic deadwood as a routine styling technique.",
                    "Any aged feature should appear natural, support the overall design and not compromise tree health.",
                ]
            ),
            SpeciesProfileSection(
                id: "defoliation",
                title: "Defoliation and Leaf Management",
                paragraphs: [
                    "Do not present complete defoliation as standard management. Full defoliation is not routine management for Wisteria floribunda.",
                    "Leaf management should primarily focus on vigour management, shoot selection, pruning, balanced fertilization and adequate light.",
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
                    "Timing must account for local climate, seasonal growth cycle, flowering cycle and individual tree condition.",
                ]
            ),
            SpeciesProfileSection(
                id: "trunk-development",
                title: "Trunk Development",
                paragraphs: [
                    "Wisteria can develop substantial trunk thickness over time.",
                    "Where additional thickness is required: allow selected leaders to extend, use sacrifice growth where appropriate, provide sufficient root space and avoid premature refinement.",
                    "Strong growth must be directed rather than simply suppressed.",
                    "Once sufficient structural development has been achieved, shift focus toward taper, branch hierarchy, ramification, flowering and mature character.",
                    "Grow strongly where development is required. Control strongly where refinement is required.",
                ]
            ),
            SpeciesProfileSection(
                id: "nebari-development",
                title: "Nebari Development",
                paragraphs: [
                    "Nebari should be developed gradually.",
                    "Potential approaches include early root selection, radial root planning, staged root correction, appropriate development containers and gradual improvement of surface roots.",
                    "The objective is a powerful and stable base appropriate to a mature Wisteria bonsai.",
                ]
            ),
            SpeciesProfileSection(
                id: "propagation",
                title: "Propagation",
                paragraphs: [
                    "Wisteria floribunda may be propagated through established horticultural methods including seed, cuttings, layering and grafting.",
                    "Seed-grown trees may require significant maturity before flowering reliably.",
                    "Named cultivars generally require vegetative propagation to preserve their specific characteristics.",
                    "Detailed procedures belong in Bonsai World Propagation Knowledge Articles.",
                ]
            ),
            SpeciesProfileSection(
                id: "pests",
                title: "Pests and Problems",
                paragraphs: [
                    "Relevant risks may include aphids, scale insects, spider mites, leaf-feeding insects, fungal problems, root problems caused by poor drainage, drought stress and frost damage to vulnerable spring growth.",
                    "Do not provide generic treatment instructions.",
                    "Diagnosis and treatment belong in Care → Pest Management and Care → Disease & Problems.",
                ]
            ),
            SpeciesProfileSection(
                id: "seasonal",
                title: "Seasonal Profile",
                paragraphs: [
                    "Spring: monitor bud development, flowering, watering demand, strong new shoot growth and pest activity. Spring management should balance flowering, structural requirements and overall tree health. Avoid unnecessary heavy work while the tree is under significant flowering demand.",
                    "Summer: monitor very strong extension growth, water demand, foliage health, pest activity and wire marks. Summer may require repeated management of vigorous shoots. Do not simply allow uncontrolled extension throughout the entire canopy. Maintain the distinction between sacrifice growth, useful development growth and unwanted extension.",
                    "Autumn is important for evaluating seasonal growth, reviewing branch structure, assessing overall vigour and preparing for winter. Avoid unnecessary late-season stimulation that creates vulnerable growth before winter. Seasonal timing depends on local climate.",
                    "Winter: Wisteria floribunda is a deciduous outdoor species. Natural winter dormancy is required.",
                    "Winter protection requirements depend on local minimum temperatures, duration of freezing, wind exposure, container depth, root protection and tree health.",
                    "Shallow bonsai roots are more exposed than roots in open ground.",
                    "Protect the root system when required while maintaining natural dormancy. Do not maintain permanently indoors.",
                ]
            ),
            SpeciesProfileSection(
                id: "styles",
                title: "Bonsai Styles",
                paragraphs: [
                    "Wisteria floribunda is particularly suitable for Informal Upright, Slanting, Cascading forms where material supports the design, Multi-trunk Style, Clump Style and Naturalistic Flowering Bonsai.",
                    "Japanese Wisteria is particularly effective when styling emphasises powerful trunk movement, mature bark, natural branch structure, hanging flowers and visible structure beneath the canopy.",
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
                    "In training: develop secondary branches, improve branch hierarchy, control vigorous extension and establish flowering potential.",
                    "Refinement: maintain balanced vigour, improve tertiary ramification, control shoot extension, preserve flowering potential and maintain visible branch structure.",
                    "Exhibition / mature refined tree: maintain health, preserve established structure, manage flowering, maintain ramification and avoid unnecessary major intervention.",
                ]
            ),
            SpeciesProfileSection(
                id: "attention",
                title: "Species-Specific Attention",
                paragraphs: [
                    "These attention points are operational tendencies. They must still be interpreted for the individual tree.",
                ],
                bullets: [
                    "Wisteria floribunda is naturally a vigorous woody climber",
                    "Do not treat it as a naturally compact tree",
                    "Strong growth is required for major structural development",
                    "Uncontrolled growth must be managed during refinement",
                    "Flowering depends strongly on maturity and cultivation history",
                    "Do not promise flowering after a specific number of years",
                    "Cultivar identity can affect flower characteristics",
                    "The tree should remain visually convincing outside the flowering season",
                    "Heavy flowering can consume significant resources",
                    "Good back-budding depends on tree health and branch condition",
                    "Preserve useful interior growth",
                    "Avoid repeated severe drought during active growth",
                    "Avoid permanently saturated substrate",
                    "Pruning timing can affect flowering",
                    "Full defoliation is not routine management",
                    "Older branches become increasingly rigid",
                    "Monitor wire carefully due to strong seasonal growth",
                    "Winter dormancy is required",
                    "Shallow bonsai roots are more exposed than roots in open ground",
                    "Do not move indoors for routine winter care",
                ]
            ),
        ]
    }
}
