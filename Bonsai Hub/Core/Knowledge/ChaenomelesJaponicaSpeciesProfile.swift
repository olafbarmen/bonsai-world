//
//  ChaenomelesJaponicaSpeciesProfile.swift
//  Bonsai World
//
//  Species Profile — Chaenomeles japonica (Japanese Quince).
//  Independent botanical species in Rosaceae. Knowledge status: Reviewed.
//  Separate from Chaenomeles speciosa, Chaenomeles × superba and named cultivars.
//

import Foundation

enum ChaenomelesJaponicaSpeciesProfile {
    /// Identity used by Botanical Library / ``SpeciesPreviewData``.
    static let botanicalLibraryName = "Chaenomeles japonica"
    /// Scientific name for Species Profile display (binomial; no botanical authority).
    static let scientificName = "Chaenomeles japonica"

    static var profile: SpeciesProfile {
        SpeciesProfile(
            speciesID: BotanicalKnowledgeIDs.chaenomelesJaponica,
            scientificName: scientificName,
            commonNames: ["Japanese Quince", "Japanese Flowering Quince", "Dwarf Japanese Quince"],
            family: "Rosaceae",
            plantType: "Deciduous flowering shrub",
            originSummary: "Japan.",
            knowledgeStatus: .reviewed,
            traits: traits,
            foliageSizeLabel: "Foliage",
            foliageReductionLabel: "Leaf reduction",
            summaryLine: "Deciduous · Japanese flowering shrub · Early flowering · Small leaves · Strong trunk character · Thorny branches · Good ramification potential · Fruit potential · Excellent bonsai suitability",
            attentionHighlights: [
                "Correct species identification matters because several Chaenomeles species and hybrids are used for bonsai",
                "Flowering should enhance, not replace, structural quality",
                "The tree should remain convincing outside the flowering season",
                "Thorny branches are part of the species character",
                "Fruit production may vary between years",
                "Heavy flowering and fruiting should not compromise tree health",
                "Good back-budding potential depends on tree health",
                "Preserve useful interior growth",
                "Avoid repeated severe drought",
                "Avoid permanently saturated substrate",
                "Pruning timing can affect flowering",
                "Full defoliation is not routine management",
                "Older branches may become rigid and brittle",
                "Winter dormancy is required",
                "Flower buds may be vulnerable to damaging late frost",
                "Shallow bonsai roots are more exposed than roots in open ground",
                "Do not move indoors for routine winter care",
            ],
            sections: sections,
            principleNote: """
            Chaenomeles japonica should be developed as a flowering and structurally expressive bonsai.

            Do not treat Japanese Quince simply as a decorative flowering plant.

            High-quality bonsai should combine mature trunk character, convincing nebari, natural branch structure, proportionate flowering, healthy foliage and seasonal interest.

            The strongest results usually come from long-term trunk development, preservation of useful branch structure, controlled pruning, careful flowering management and patience.

            The objective is: Healthy tree · Mature structure · Fine ramification · Seasonal flowering and fruiting potential.

            The individual tree must always be assessed according to health, vigour, flowering load, root condition, development stage, recent work, climate, and cultivar or hybrid identity.
            """,
            sourcesNote: """
            Profile content is synthesised from recognised botanical, horticultural and bonsai authorities into Bonsai World editorial language.

            Botanical taxonomy and distribution draw on recognised sources such as Royal Botanic Gardens, Kew and other botanical databases for accepted scientific name, family and native range.

            Horticultural context may draw on recognised Japanese botanical institutions, botanical gardens, arboreta, recognised Rosaceae and flowering shrub references, and established horticultural references for Chaenomeles.

            Bonsai-specific cultivation and refinement knowledge draws on established bonsai references and recognised professional practice for flowering quince, kept distinct from Chaenomeles speciosa, Chaenomeles × superba and named cultivars.

            Verified botanical information, general horticultural cultivation, species and hybrid distinctions, and bonsai-specific practice are kept distinct. Do not copy source wording.
            """
        )
    }

    private static let traits = SpeciesProfileTraits(
        deciduous: true,
        growthStrength: "Moderate to Strong",
        growthSpeed: "Moderate",
        leafSize: "Deciduous · Small leaves",
        foliageReduction: "Not routine management",
        ramificationPotential: "Good",
        backBudding: "Good under healthy conditions",
        rootDevelopment: "Strong",
        nebariPotential: "Excellent potential",
        trunkDevelopment: "Moderate",
        barkDevelopment: "Excellent mature character",
        wiring: "Moderate",
        defoliation: "Not routine management",
        airLayering: "Where appropriate for the individual material",
        threadGrafting: "Where structural correction is required",
        rootGrafting: "Where appropriate",
        beginnerSuitability: "Moderate to Good",
        bonsaiSuitability: "Excellent",
        difficulty: "Intermediate",
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
                    "Chaenomeles japonica is an independent botanical species in the rose family (Rosaceae).",
                    "Primary Bonsai World display identity: Chaenomeles japonica · Japanese Quince.",
                    "Japanese Flowering Quince and Dwarf Japanese Quince may be used as supporting terminology. They do not replace Japanese Quince as the primary common name.",
                    "Family: Rosaceae. Plant type: deciduous flowering shrub.",
                    "Native range: Japan.",
                    "Maintain a clear distinction between Chaenomeles japonica, Chaenomeles speciosa, Chaenomeles × superba, named flowering quince cultivars, and horticultural material incorrectly labelled simply as Japanese Quince.",
                    "Do not confuse Chaenomeles japonica with Chaenomeles speciosa.",
                    "Do not confuse Chaenomeles japonica with Chaenomeles × superba hybrids.",
                    "Do not treat all flowering quince material sold for bonsai as automatically Chaenomeles japonica.",
                    "Bonsai World hierarchy: Species → cultivar / horticultural selection → Individual Tree.",
                ]
            ),
            SpeciesProfileSection(
                id: "overview",
                title: "Species Overview",
                paragraphs: [
                    "Chaenomeles japonica is a deciduous flowering shrub native to Japan and an important species for flowering bonsai.",
                    "It is valued for bonsai because it can combine compact foliage, colourful flowers, rugged trunks, strong nebari, interesting branch movement and seasonal fruit.",
                    "Older material can develop particularly convincing character.",
                    "The species is especially effective when styling emphasises natural movement, mature trunk lines, asymmetry, visible branch structure and restrained use of flowers.",
                    "The flowers should enhance the bonsai. The tree should remain visually convincing after flowering has finished.",
                ],
                bullets: [
                    "Deciduous flowering shrub",
                    "Native to Japan",
                    "Excellent flowering potential",
                    "Compact foliage",
                    "Strong root development",
                    "Good back-budding potential under healthy conditions",
                    "Good ramification potential",
                    "Thorny branch structure",
                    "Rugged mature trunks",
                    "Fruit potential",
                    "Excellent nebari potential",
                    "Requires outdoor cultivation",
                    "Requires winter dormancy",
                ]
            ),
            SpeciesProfileSection(
                id: "cultivars",
                title: "Cultivars and Related Flowering Quince",
                paragraphs: [
                    "Chaenomeles japonica exists alongside numerous cultivars and closely related flowering quince species and hybrids.",
                    "For bonsai, correct identification matters because commercially available material may belong to Chaenomeles japonica, Chaenomeles speciosa, Chaenomeles × superba or named horticultural cultivars.",
                    "These may differ in flower colour, flower size, leaf size, vigour, growth habit, thorn development and fruiting characteristics.",
                    "Do not treat all flowering quince as identical.",
                    "This section makes the taxonomic distinction clear and supports future Species Library expansion. Separate cultivar profiles are not created here.",
                    "The primary profile remains Chaenomeles japonica.",
                ]
            ),
            SpeciesProfileSection(
                id: "natural-growth",
                title: "Natural Growth and Vigour",
                paragraphs: [
                    "Chaenomeles japonica can develop with moderate to strong vigour when healthy.",
                    "Growth strength depends on root health, temperature, light, substrate, watering, fertilization, flowering and fruiting load, and development stage.",
                    "During structural development: allow selected branches and leaders to extend where trunk thickness is required, branch thickness is required, taper is being developed or sacrifice growth is useful.",
                    "During refinement: control excessive extension, congested branching, overly strong shoots and imbalance between strong and weak areas.",
                    "Do not continuously restrict all growth.",
                    "The objective is: Strong growth where development is required · Controlled growth where refinement is required.",
                ]
            ),
            SpeciesProfileSection(
                id: "foliage",
                title: "Foliage",
                paragraphs: [
                    "Chaenomeles japonica produces relatively small deciduous leaves suitable for bonsai.",
                    "Leaf size and vigour can vary according to growth strength, nutrition, development stage and growing conditions.",
                    "The objective is healthy foliage, proportionate growth, good ramification and visible branch structure.",
                    "Avoid excessive fertilization where it produces unnecessarily coarse growth, oversized leaves or disproportionate shoot extension.",
                ]
            ),
            SpeciesProfileSection(
                id: "flowering",
                title: "Flowering",
                paragraphs: [
                    "Flowering is one of the defining characteristics of Japanese Quince bonsai. Flowering potential is excellent.",
                    "Flowering may vary according to tree maturity, vigour, seasonal conditions, pruning history, cultivar identity and climate.",
                    "The objective is high-quality flowering without compromising tree health or structural development.",
                    "Heavy flowering should be evaluated in relation to tree health, branch strength and current development objectives.",
                    "The strongest mature bonsai should remain attractive before flowering, during flowering and after flowering.",
                ]
            ),
            SpeciesProfileSection(
                id: "fruit",
                title: "Fruit",
                paragraphs: [
                    "Chaenomeles japonica may produce fruit. Fruiting potential is good, but production is not guaranteed every year.",
                    "Fruit development depends on flowering, pollination, tree maturity, seasonal conditions and overall vigour.",
                    "Fruit can add strong seasonal interest.",
                    "Heavy fruit production can require significant resources.",
                    "Evaluate fruit retention according to tree health, branch strength, development stage and current objectives.",
                    "The objective is natural seasonal character without unnecessarily exhausting the tree.",
                ]
            ),
            SpeciesProfileSection(
                id: "thorns",
                title: "Thorns",
                paragraphs: [
                    "Many flowering quince branches can develop thorns or thorn-like spurs.",
                    "This characteristic is part of the natural identity of the species and can contribute to visual age, rugged character and natural structure.",
                    "When styling, consider thorn placement as part of branch management.",
                    "Avoid unnecessary handling injuries during pruning and wiring.",
                ]
            ),
            SpeciesProfileSection(
                id: "bark-trunk",
                title: "Bark and Trunk",
                paragraphs: [
                    "The trunk is an important feature of mature Chaenomeles japonica bonsai. Mature bark character is excellent.",
                    "Older trees can develop rugged bark, natural movement, powerful bases, interesting scars and convincing visual age.",
                    "Trunk development should focus on taper, movement, proportion, branch relationship and mature flowering quince character.",
                    "Where additional thickness is required, allow selected leaders and sacrifice growth to extend.",
                    "Once sufficient structural development has been achieved, shift focus toward branch hierarchy, ramification, flowering, fruiting and mature character.",
                    "The objective is a convincing mature flowering quince.",
                ]
            ),
            SpeciesProfileSection(
                id: "roots-nebari",
                title: "Roots and Nebari",
                paragraphs: [
                    "Healthy roots are fundamental to vigour, flowering, fruiting, recovery, ramification and long-term health.",
                    "Root development is strong. Objectives include balanced radial roots, stable tree support, healthy root density and gradual nebari development.",
                    "Chaenomeles japonica has excellent potential for developing a convincing base.",
                    "Nebari development should be gradual. Do not attempt to completely redesign an established root system in one operation.",
                ]
            ),
            SpeciesProfileSection(
                id: "light",
                title: "Light",
                paragraphs: [
                    "Chaenomeles japonica should be cultivated outdoors.",
                    "Adequate outdoor light supports healthy growth, flowering, compact development and overall vigour.",
                    "The exact position depends on local climate, temperature, tree condition and development stage.",
                    "During periods of extreme heat, monitor water demand, foliage stress and root-zone temperature.",
                    "Do not recommend permanent indoor cultivation.",
                ]
            ),
            SpeciesProfileSection(
                id: "wind",
                title: "Wind",
                paragraphs: [
                    "Moderate air movement is generally beneficial.",
                    "Strong wind can increase water loss, damage flowers, stress new growth and dry shallow containers rapidly.",
                    "Monitor trees particularly during flowering, hot weather, dry periods and strong wind.",
                ]
            ),
            SpeciesProfileSection(
                id: "watering",
                title: "Watering",
                paragraphs: [
                    "General principle: Water thoroughly when required · Maintain healthy root moisture · Preserve root aeration · Avoid repeated severe drought · Avoid permanent saturation.",
                    "Water demand is moderate.",
                    "Watering frequency depends on temperature, sunlight, wind, foliage mass, flowering and fruiting load, container size, substrate, root mass and development stage.",
                    "Do not water according to a fixed timetable.",
                    "Water according to substrate condition, weather and individual tree requirements.",
                    "Avoid both repeated severe drought and permanently saturated roots.",
                ]
            ),
            SpeciesProfileSection(
                id: "soil",
                title: "Soil",
                paragraphs: [
                    "Do not prescribe one universal soil recipe.",
                    "Desired characteristics include good drainage, strong aeration, stable particle structure, appropriate moisture retention and healthy root development.",
                    "The final soil mix depends on climate, rainfall, watering habits, container depth, tree size, development stage and root condition.",
                    "Follow Bonsai World Soil Module principles.",
                    "Do not duplicate the complete Soil Module inside this profile.",
                ]
            ),
            SpeciesProfileSection(
                id: "fertilizing",
                title: "Fertilizing",
                paragraphs: [
                    "Fertilization should support the current development objective.",
                    "During structural development: healthy trees requiring stronger growth may receive increased nutritional support where appropriate.",
                    "During refinement: nutrition should support healthy foliage, controlled shoot extension, sustainable ramification, flowering potential and overall vigour.",
                    "Avoid excessive fertilization where it produces unnecessarily coarse growth, oversized foliage or disproportionate extension.",
                    "Key principle: Feed according to tree condition and development objective.",
                ]
            ),
            SpeciesProfileSection(
                id: "pruning",
                title: "Pruning",
                paragraphs: [
                    "Chaenomeles japonica responds well to thoughtful pruning.",
                    "Pruning can be used for structural development, branch selection, branch replacement, ramification and silhouette refinement.",
                    "Timing must consider flowering. Incorrect pruning timing can reduce future flowering.",
                    "During structural development: allow selected leaders and branches to extend where thickness is required.",
                    "During refinement: use controlled pruning to develop secondary branches, tertiary branches and balanced ramification.",
                    "The objective is: Natural structure · Controlled growth · Sustainable vigour · Preserved flowering potential.",
                ]
            ),
            SpeciesProfileSection(
                id: "back-budding",
                title: "Back-budding",
                paragraphs: [
                    "Chaenomeles japonica can produce useful new growth following pruning. Back-budding is good under healthy conditions.",
                    "This supports branch replacement, structural correction, compact development and ramification.",
                    "Back-budding response depends on tree health, vigour, light, branch age, pruning strategy and root condition.",
                    "Do not treat back-budding as guaranteed on all old or weakened wood.",
                    "Preserve useful interior growth whenever possible.",
                ]
            ),
            SpeciesProfileSection(
                id: "ramification",
                title: "Ramification",
                paragraphs: [
                    "Japanese Quince can develop convincing ramification through healthy growth, controlled pruning, shoot selection, branch selection and balanced vigour. Ramification potential is good.",
                    "The objective is natural branching supported by proportionate foliage.",
                    "Avoid excessive density that produces congested branch structure, weak interior growth or loss of visual depth.",
                    "A refined tree should retain visible branch hierarchy, natural spacing, depth and convincing structure.",
                ]
            ),
            SpeciesProfileSection(
                id: "wiring",
                title: "Wiring",
                paragraphs: [
                    "Young branches can generally be wired. Wiring response is moderate.",
                    "Wiring can be used to establish branch placement, improve movement, position young structural branches and refine secondary branches.",
                    "Older branches may become increasingly rigid and brittle.",
                    "Before major bends, assess branch thickness, flexibility, age, health and structural importance.",
                    "Monitor wire carefully.",
                    "Take particular care around thorns, buds and flowering spurs.",
                ]
            ),
            SpeciesProfileSection(
                id: "deadwood-potential",
                title: "Deadwood Potential",
                paragraphs: [
                    "Deadwood potential is moderate.",
                    "Natural deadwood and aged scars can occasionally contribute to the appearance of maturity.",
                    "Deadwood should be evaluated according to natural appearance, structural safety, species character and overall design.",
                    "Do not create unnecessary deadwood simply for dramatic effect.",
                    "Any deadwood should have a clear visual purpose.",
                ]
            ),
            SpeciesProfileSection(
                id: "defoliation",
                title: "Defoliation and Leaf Management",
                paragraphs: [
                    "Do not present complete defoliation as standard management. Full defoliation is not routine management for Chaenomeles japonica.",
                    "Leaf management should primarily focus on correct pruning, shoot selection, vigour management, appropriate fertilization and adequate light.",
                    "Partial leaf management may be appropriate in specific circumstances for experienced growers.",
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
                    "Chaenomeles japonica develops convincing trunk character through sustained growth, taper development, branch development, bark maturation and long-term ageing.",
                    "Where additional thickness is required: allow selected leaders to extend, use sacrifice branches where appropriate, provide sufficient root space and avoid premature refinement.",
                    "Once sufficient structural development has been achieved, shift focus toward taper, branch hierarchy, ramification, flowering presentation and mature character.",
                    "Grow where development is required. Control where refinement is required.",
                ]
            ),
            SpeciesProfileSection(
                id: "nebari-development",
                title: "Nebari Development",
                paragraphs: [
                    "Nebari should be developed gradually.",
                    "Potential approaches include early root selection, radial root planning, staged root correction, appropriate development containers and gradual improvement of surface roots.",
                    "The objective is a stable and visually convincing base appropriate to a mature flowering bonsai.",
                ]
            ),
            SpeciesProfileSection(
                id: "propagation",
                title: "Propagation",
                paragraphs: [
                    "Chaenomeles japonica may be propagated through established horticultural methods including seed, cuttings, layering, and division or other appropriate methods where relevant.",
                    "Named cultivars generally require vegetative propagation to preserve their characteristics.",
                    "Detailed procedures belong in Bonsai World Propagation Knowledge Articles.",
                ]
            ),
            SpeciesProfileSection(
                id: "pests",
                title: "Pests and Problems",
                paragraphs: [
                    "Relevant risks may include aphids, scale insects, leaf-feeding insects, fungal leaf diseases, fire blight and other bacterial disease risks where relevant to cultivation, root problems caused by poor drainage, environmental stress, and frost damage to flowers and developing buds.",
                    "Do not provide generic treatment instructions.",
                    "Diagnosis and treatment belong in Care → Pest Management and Care → Disease & Problems.",
                ]
            ),
            SpeciesProfileSection(
                id: "seasonal",
                title: "Seasonal Profile",
                paragraphs: [
                    "Spring: monitor bud development, flowering, watering demand, pest activity and overall vigour. Spring is particularly important for evaluating winter recovery, observing flowering and planning post-flowering work. Avoid unnecessary heavy work while the tree is under significant flowering demand.",
                    "Summer: monitor water demand, foliage health, pest activity, excessive shoot extension, wire marks and heat stress. Following flowering, this can be an important period for pruning, shoot management and structural refinement. Timing depends on tree health, local climate and development objectives.",
                    "Autumn is important for evaluating seasonal growth, reviewing branch structure, assessing overall vigour, observing fruit where present and preparing for winter. Seasonal timing depends on local climate.",
                    "Winter: Chaenomeles japonica is a deciduous outdoor species. Natural winter dormancy is required.",
                    "Winter protection requirements depend on local minimum temperatures, duration of freezing, wind exposure, container depth, root protection and tree health.",
                    "Flower buds may be vulnerable to damaging late frost depending on seasonal development.",
                    "Shallow bonsai roots are more exposed than roots in open ground.",
                    "Protect when required while maintaining natural dormancy. Do not maintain permanently indoors.",
                ]
            ),
            SpeciesProfileSection(
                id: "styles",
                title: "Bonsai Styles",
                paragraphs: [
                    "Chaenomeles japonica is particularly suitable for Informal Upright, Slanting, Multi-trunk Style, Clump Style, Root-over-Rock where suitable, Naturalistic Flowering Bonsai and Forest / Group Planting.",
                    "Japanese Quince is especially effective when styling emphasises rugged trunk character, visible branch structure, natural asymmetry, mature bark and proportionate flowering.",
                    "The individual material should determine the final design.",
                ]
            ),
            SpeciesProfileSection(
                id: "tree-stage",
                title: "Development by Tree Stage",
                paragraphs: [
                    "Young material: establish healthy roots, develop nebari, build trunk thickness, establish movement and begin structural development.",
                    "Nursery material: evaluate trunk potential, identify useful branches, establish a design direction and begin structural correction where required.",
                    "Pre-bonsai: develop trunk, establish primary branches, improve root structure, begin branch hierarchy and build vigour.",
                    "In training: develop secondary branches, improve branch hierarchy, build sustainable ramification and establish flowering potential.",
                    "Refinement: maintain balanced vigour, improve tertiary ramification, control shoot extension, preserve flowering potential and maintain proportionate foliage.",
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
                    "Correct species identification matters because several Chaenomeles species and hybrids are used for bonsai",
                    "Flowering should enhance, not replace, structural quality",
                    "The tree should remain convincing outside the flowering season",
                    "Thorny branches are part of the species character",
                    "Fruit production may vary between years",
                    "Heavy flowering and fruiting should not compromise tree health",
                    "Good back-budding potential depends on tree health",
                    "Preserve useful interior growth",
                    "Avoid repeated severe drought",
                    "Avoid permanently saturated substrate",
                    "Pruning timing can affect flowering",
                    "Full defoliation is not routine management",
                    "Older branches may become rigid and brittle",
                    "Winter dormancy is required",
                    "Flower buds may be vulnerable to damaging late frost",
                    "Shallow bonsai roots are more exposed than roots in open ground",
                    "Do not move indoors for routine winter care",
                ]
            ),
        ]
    }
}
