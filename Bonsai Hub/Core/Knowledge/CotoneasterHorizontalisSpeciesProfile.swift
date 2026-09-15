//
//  CotoneasterHorizontalisSpeciesProfile.swift
//  Bonsai World
//
//  Species Profile — Cotoneaster horizontalis (Rockspray Cotoneaster).
//  Independent botanical species in Rosaceae. Knowledge status: Reviewed.
//  Separate from other Cotoneaster species commonly used for bonsai.
//

import Foundation

enum CotoneasterHorizontalisSpeciesProfile {
    /// Identity used by Botanical Library / ``SpeciesPreviewData``.
    static let botanicalLibraryName = "Cotoneaster horizontalis"
    /// Scientific name for Species Profile display (binomial; no botanical authority).
    static let scientificName = "Cotoneaster horizontalis"

    static var profile: SpeciesProfile {
        SpeciesProfile(
            speciesID: BotanicalKnowledgeIDs.cotoneasterHorizontalis,
            scientificName: scientificName,
            commonNames: ["Rockspray Cotoneaster", "Wall Cotoneaster"],
            family: "Rosaceae",
            plantType: "Deciduous flowering and fruiting shrub",
            originSummary: "China.",
            knowledgeStatus: .reviewed,
            traits: traits,
            foliageSizeLabel: "Foliage",
            foliageReductionLabel: "Leaf reduction",
            summaryLine: "Deciduous · Small leaves · Fine branching potential · Distinctive herringbone branch structure · White to pale pink flowers · Red autumn fruit · Strong seasonal character · Excellent small bonsai potential",
            attentionHighlights: [
                "Cotoneaster horizontalis is naturally well suited to small-scale bonsai",
                "Small leaves and fine branching are major advantages",
                "Distinctive branch structure should be preserved where visually useful",
                "Do not move into refinement before sufficient trunk development",
                "Flowering and fruiting are seasonal features, not substitutes for structure",
                "Heavy fruit loads can consume resources",
                "Good back-budding depends on tree health and branch condition",
                "Preserve useful interior growth",
                "Avoid repeated severe drought",
                "Avoid permanently saturated substrate",
                "Full defoliation is not routine management",
                "Young branches are more suitable for wiring than older branches",
                "Monitor wire during active growth",
                "Winter dormancy is required",
                "Shallow bonsai roots are more exposed than roots in open ground",
                "Do not move indoors for routine winter care",
            ],
            sections: sections,
            principleNote: """
            Cotoneaster horizontalis is particularly valuable for bonsai because of its naturally small scale.

            Its strengths include small leaves, naturally fine branching, dense ramification potential, flowers, berries and strong autumn character.

            However, trunk development is generally slower than in highly vigorous species.

            Do not move into premature refinement before sufficient trunk and branch structure has been developed.

            The objective is: Natural structure · Fine ramification · Proportionate foliage · Sustainable flowering and fruiting.

            The individual tree must always be assessed according to health, vigour, fruit load, flowering, root condition, development stage, climate and recent work.
            """,
            sourcesNote: """
            Profile content is synthesised from recognised botanical, horticultural and bonsai authorities into Bonsai World editorial language.

            Botanical taxonomy and distribution draw on recognised sources such as Royal Botanic Gardens, Kew and other botanical databases for accepted scientific name, family and native range.

            Horticultural context may draw on recognised botanical gardens, arboreta, horticultural institutions and established horticultural references for Cotoneaster.

            Bonsai-specific cultivation and refinement knowledge draws on established bonsai references and recognised professional practice, kept distinct from other Cotoneaster species.

            Verified botanical information, general horticultural cultivation, ornamental characteristics and bonsai-specific practice are kept distinct. Do not copy source wording.
            """
        )
    }

    private static let traits = SpeciesProfileTraits(
        deciduous: true,
        growthStrength: "Moderate",
        growthSpeed: "Moderate",
        leafSize: "Deciduous · Small leaves",
        foliageReduction: "Not routine management",
        ramificationPotential: "Excellent",
        backBudding: "Good under healthy conditions",
        rootDevelopment: "Good",
        nebariPotential: "Good potential",
        trunkDevelopment: "Slow to Moderate",
        barkDevelopment: "Moderate mature character",
        wiring: "Good on young branches",
        defoliation: "Not routine management",
        airLayering: "Where appropriate for the individual material",
        threadGrafting: "Where structural correction is required",
        rootGrafting: "Where appropriate",
        beginnerSuitability: "Good",
        bonsaiSuitability: "Excellent",
        difficulty: "Beginner to Intermediate",
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
                    "Cotoneaster horizontalis is an independent botanical species in the rose family (Rosaceae).",
                    "Primary Bonsai World display identity: Cotoneaster horizontalis · Rockspray Cotoneaster.",
                    "Wall Cotoneaster may be used as supporting terminology. It does not replace Rockspray Cotoneaster as the primary common name.",
                    "Family: Rosaceae. Plant type: deciduous flowering and fruiting shrub.",
                    "Native range: China.",
                    "Do not confuse Cotoneaster horizontalis with other Cotoneaster species commonly used for bonsai.",
                    "Do not assume all Cotoneaster species have identical growth habits, leaf size or fruiting characteristics.",
                    "Bonsai World hierarchy: Species → cultivar / horticultural selection → Individual Tree.",
                ]
            ),
            SpeciesProfileSection(
                id: "overview",
                title: "Species Overview",
                paragraphs: [
                    "Cotoneaster horizontalis is a deciduous shrub native to China and widely cultivated as an ornamental plant.",
                    "It is recognised for its distinctive branch arrangement, often producing a characteristic layered or herringbone pattern.",
                    "For bonsai, it offers naturally small leaves, good ramification, compact visual scale, attractive spring flowers, decorative red fruit and strong autumn and winter interest.",
                    "It is particularly suitable for small and medium bonsai.",
                    "A mature tree should remain visually convincing through all seasons, not only when carrying fruit.",
                ],
                bullets: [
                    "Deciduous shrub",
                    "Native to China",
                    "Small leaves",
                    "Naturally fine branching potential",
                    "Distinctive branch pattern",
                    "White to pale pink flowers",
                    "Red autumn fruit",
                    "Good response to pruning",
                    "Good back-budding potential",
                    "Excellent ramification potential",
                    "Requires outdoor cultivation",
                    "Requires winter dormancy",
                ]
            ),
            SpeciesProfileSection(
                id: "cultivars",
                title: "Cultivars",
                paragraphs: [
                    "Cotoneaster horizontalis is primarily represented in bonsai by the botanical species itself, although horticultural selections may exist.",
                    "This Species Library profile remains focused on Cotoneaster horizontalis.",
                    "Named selections are not given separate profiles here unless a cultivar has a clearly established and distinct bonsai identity.",
                    "Where named selections are encountered, differences may include growth habit, vigour, branch density, overall size and ornamental characteristics.",
                    "The primary profile remains Cotoneaster horizontalis.",
                ]
            ),
            SpeciesProfileSection(
                id: "natural-growth",
                title: "Natural Growth and Vigour",
                paragraphs: [
                    "Cotoneaster horizontalis generally produces moderate seasonal growth.",
                    "Growth strength depends on root health, temperature, light, available root space, fertilization, watering and development stage.",
                    "During structural development: allow selected shoots to extend where trunk thickness is required, branch thickness is required or taper is being developed.",
                    "During refinement: control excessively long shoots, crowded branching, overlapping growth and loss of branch definition.",
                    "The objective is: Strong useful growth during development · Fine controlled growth during refinement.",
                ]
            ),
            SpeciesProfileSection(
                id: "foliage",
                title: "Foliage",
                paragraphs: [
                    "Cotoneaster horizontalis naturally produces relatively small leaves, making it highly suitable for bonsai.",
                    "Leaf quality and proportion depend on vigour, light, fertilization, pruning and development stage.",
                    "The objective is healthy foliage, fine branch visibility, a proportionate canopy and natural scale.",
                    "Avoid excessive fertilization where it produces unnecessarily coarse extension growth.",
                ]
            ),
            SpeciesProfileSection(
                id: "flowering",
                title: "Flowering",
                paragraphs: [
                    "Cotoneaster horizontalis produces small flowers, generally white to pale pink. Flowering potential is good.",
                    "Flowering should be viewed as part of the seasonal character of the tree.",
                    "The objective is healthy growth, mature branch structure and sustainable flowering and fruiting.",
                    "Do not sacrifice long-term branch development solely to maximise flowering.",
                    "Pruning decisions should consider the relationship between shoot growth, flower bud development and future fruit production.",
                    "Do not apply one universal pruning calendar.",
                ]
            ),
            SpeciesProfileSection(
                id: "fruit",
                title: "Fruit",
                paragraphs: [
                    "Red fruit is one of the defining ornamental features of Cotoneaster horizontalis. Fruiting potential is excellent.",
                    "Fruit display can add significant seasonal value.",
                    "Fruit production depends on factors including flowering success, pollination, tree health and seasonal conditions.",
                    "Heavy fruit production can consume resources.",
                    "Evaluate fruit retention according to tree health, development stage, strength and refinement objectives.",
                    "Do not automatically retain every fruit if the tree is weak or heavily stressed.",
                ]
            ),
            SpeciesProfileSection(
                id: "bark-trunk",
                title: "Bark and Trunk",
                paragraphs: [
                    "Cotoneaster horizontalis does not normally develop massive trunks rapidly. Mature bark character is moderate.",
                    "Mature character should instead be developed through trunk movement, taper, branch structure, fine ramification and natural proportions.",
                    "Older specimens can develop convincing mature character.",
                    "Do not attempt to artificially force age through unnecessary damage.",
                    "The objective is a convincing mature shrub or small tree represented at bonsai scale.",
                ]
            ),
            SpeciesProfileSection(
                id: "roots-nebari",
                title: "Roots and Nebari",
                paragraphs: [
                    "Healthy roots support seasonal growth, flowering, fruiting, recovery and ramification.",
                    "Root development is good. Objectives include balanced roots, stable radial development, healthy root density and gradual nebari improvement.",
                    "Root correction should be performed gradually.",
                    "Do not attempt to completely redesign an established root system in one operation.",
                ]
            ),
            SpeciesProfileSection(
                id: "light",
                title: "Light",
                paragraphs: [
                    "Cotoneaster horizontalis should be cultivated outdoors.",
                    "Adequate light supports healthy growth, flowering, fruiting, compact development and autumn colour.",
                    "The exact growing position depends on local climate, temperature, tree condition and development stage.",
                    "Do not recommend permanent indoor cultivation.",
                ]
            ),
            SpeciesProfileSection(
                id: "wind",
                title: "Wind",
                paragraphs: [
                    "Moderate air movement is beneficial.",
                    "Strong wind can increase water demand, damage tender growth, dry shallow bonsai containers rapidly and stress fruit-bearing branches.",
                    "Monitor trees during strong wind, hot weather and dry periods.",
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
                    "During refinement: avoid excessive fertilization that produces coarse extension growth, unnecessarily large foliage or reduced visual refinement.",
                    "Key principle: Feed according to tree condition and development objective.",
                    "Do not imply that maximum fertilization always produces the best bonsai.",
                ]
            ),
            SpeciesProfileSection(
                id: "pruning",
                title: "Pruning",
                paragraphs: [
                    "Cotoneaster horizontalis responds well to pruning.",
                    "Pruning can be used for structural development, branch selection, branch replacement, ramification and silhouette refinement.",
                    "Pruning timing must consider flowering, fruiting, seasonal growth and individual tree health.",
                    "Do not apply one universal pruning date.",
                    "During development: allow selected shoots to extend where thickness or taper is required.",
                    "During refinement: use controlled pruning and shoot selection to maintain fine ramification, branch visibility, natural structure and sustainable flowering and fruiting.",
                ]
            ),
            SpeciesProfileSection(
                id: "back-budding",
                title: "Back-budding",
                paragraphs: [
                    "Cotoneaster horizontalis generally responds well to pruning and can produce useful new growth. Back-budding is good under healthy conditions.",
                    "Response depends on tree health, vigour, light, branch age and pruning strategy.",
                    "Do not describe back-budding as guaranteed on every old branch.",
                    "Preserve useful interior growth whenever possible.",
                ]
            ),
            SpeciesProfileSection(
                id: "ramification",
                title: "Ramification",
                paragraphs: [
                    "Fine ramification is one of the strongest bonsai characteristics of Cotoneaster horizontalis. Ramification potential is excellent.",
                    "Ramification develops through repeated healthy growth cycles, controlled pruning, shoot selection, branch selection and balanced vigour.",
                    "Avoid allowing the outer canopy to become excessively dense.",
                    "The objective is fine branching, natural spacing, visible branch hierarchy and a proportionate canopy.",
                ]
            ),
            SpeciesProfileSection(
                id: "wiring",
                title: "Wiring",
                paragraphs: [
                    "Young branches can generally be wired. Wiring is good on young branches.",
                    "Wiring can be used to establish movement, improve branch placement, position young branches and develop secondary structure.",
                    "Older branches become progressively less flexible.",
                    "Before major bends, assess branch thickness, flexibility, age, health and structural importance.",
                    "Monitor wire carefully during active growth.",
                ]
            ),
            SpeciesProfileSection(
                id: "deadwood-potential",
                title: "Deadwood Potential",
                paragraphs: [
                    "Deadwood potential is limited. Deadwood is not normally a defining feature of Cotoneaster horizontalis bonsai.",
                    "Natural scars and aged features may occasionally contribute to character.",
                    "Do not create dramatic artificial deadwood as a routine styling technique.",
                    "Any feature should appear natural, support the design and not compromise tree health.",
                ]
            ),
            SpeciesProfileSection(
                id: "defoliation",
                title: "Defoliation and Leaf Management",
                paragraphs: [
                    "Do not present complete defoliation as standard management. Full defoliation is not routine management for Cotoneaster horizontalis.",
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
                    "Cotoneaster horizontalis can require patience for significant trunk development.",
                    "Where additional thickness is required: allow selected leaders to extend, use sacrifice growth where appropriate, provide sufficient root space and avoid premature refinement.",
                    "Once sufficient structural development has been achieved, shift focus toward taper, branch hierarchy, ramification, flowering, fruiting and mature proportions.",
                    "Do not permanently restrict a tree that still requires major structural development.",
                ]
            ),
            SpeciesProfileSection(
                id: "nebari-development",
                title: "Nebari Development",
                paragraphs: [
                    "Nebari should be developed gradually.",
                    "Potential approaches include early root selection, radial root planning, staged root correction, appropriate development containers and gradual improvement of surface roots.",
                    "The objective is a stable and visually convincing base appropriate to a mature Cotoneaster bonsai.",
                ]
            ),
            SpeciesProfileSection(
                id: "propagation",
                title: "Propagation",
                paragraphs: [
                    "Cotoneaster horizontalis may be propagated using established horticultural methods including seed, cuttings and layering.",
                    "Propagation method selection depends on the desired objective.",
                    "Seed-grown material may offer genetic variation. Vegetative propagation preserves the characteristics of the parent material.",
                    "Detailed procedures belong in Bonsai World Propagation Knowledge Articles.",
                ]
            ),
            SpeciesProfileSection(
                id: "pests",
                title: "Pests and Problems",
                paragraphs: [
                    "Relevant risks may include aphids, scale insects, spider mites, leaf-feeding insects, fungal leaf problems, root problems caused by poor drainage, drought stress and damage to flowers or fruit under unsuitable conditions.",
                    "Do not provide generic treatment instructions.",
                    "Diagnosis and treatment belong in Care → Pest Management and Care → Disease & Problems.",
                ]
            ),
            SpeciesProfileSection(
                id: "seasonal",
                title: "Seasonal Profile",
                paragraphs: [
                    "Spring: monitor bud development, flowering, watering demand, new shoot growth and pest activity. Spring is an important period for observing branch structure, flowering and development priorities. Avoid unnecessary heavy work while the tree is under significant stress.",
                    "Summer: monitor shoot extension, watering demand, foliage health, pest activity and wire marks. Summer growth should be managed according to whether shoots are intended for structural development, branch development or refinement. Do not suppress all vigorous growth where development is still required.",
                    "Autumn is important for fruit display, foliage colour, evaluating seasonal growth, reviewing branch structure, assessing overall vigour and preparing for winter. The fruiting display should not override the health requirements of the tree.",
                    "Winter: Cotoneaster horizontalis is a deciduous outdoor species. Natural winter dormancy is required.",
                    "Winter protection requirements depend on local minimum temperatures, duration of freezing, wind exposure, container depth, root protection and tree health.",
                    "Shallow bonsai roots are more exposed than roots in open ground.",
                    "Protect the root system when required while maintaining natural dormancy. Do not maintain permanently indoors.",
                ]
            ),
            SpeciesProfileSection(
                id: "styles",
                title: "Bonsai Styles",
                paragraphs: [
                    "Cotoneaster horizontalis is particularly suitable for Informal Upright, Slanting, Semi-Cascade, Cascade, Multi-trunk Style, Clump Style, Naturalistic Bonsai and Small Bonsai and Shohin.",
                    "Its naturally fine scale makes it particularly suitable for compact compositions.",
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
                    "In training: develop secondary branches, improve branch hierarchy, build ramification and establish flowering and fruiting potential.",
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
                    "Cotoneaster horizontalis is naturally well suited to small-scale bonsai",
                    "Small leaves and fine branching are major advantages",
                    "Distinctive branch structure should be preserved where visually useful",
                    "Do not move into refinement before sufficient trunk development",
                    "Flowering and fruiting are seasonal features, not substitutes for structure",
                    "Heavy fruit loads can consume resources",
                    "Good back-budding depends on tree health and branch condition",
                    "Preserve useful interior growth",
                    "Avoid repeated severe drought",
                    "Avoid permanently saturated substrate",
                    "Full defoliation is not routine management",
                    "Young branches are more suitable for wiring than older branches",
                    "Monitor wire during active growth",
                    "Winter dormancy is required",
                    "Shallow bonsai roots are more exposed than roots in open ground",
                    "Do not move indoors for routine winter care",
                ]
            ),
        ]
    }
}
