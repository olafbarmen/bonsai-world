//
//  RhododendronIndicumSpeciesProfile.swift
//  Bonsai World
//
//  Species Profile — Rhododendron indicum (Satsuki Azalea).
//  Independent botanical species in Ericaceae. Knowledge status: Reviewed.
//  Separate from named Satsuki cultivars, other azaleas and other Rhododendron species.
//

import Foundation

enum RhododendronIndicumSpeciesProfile {
    /// Identity used by Botanical Library / ``SpeciesPreviewData``.
    static let botanicalLibraryName = "Rhododendron indicum"
    /// Scientific name for Species Profile display (binomial; no botanical authority).
    static let scientificName = "Rhododendron indicum"

    static var profile: SpeciesProfile {
        SpeciesProfile(
            speciesID: BotanicalKnowledgeIDs.rhododendronIndicum,
            scientificName: scientificName,
            commonNames: ["Satsuki Azalea", "Japanese Azalea"],
            family: "Ericaceae",
            plantType: "Evergreen to semi-evergreen flowering shrub",
            originSummary: "Japan.",
            knowledgeStatus: .reviewed,
            traits: traits,
            foliageSizeLabel: "Foliage",
            foliageReductionLabel: "Leaf reduction",
            summaryLine: "Japanese flowering shrub · Satsuki bonsai tradition · Evergreen to semi-evergreen foliage depending on cultivar and climate · Fine branching potential · Spectacular flowering · Acid-loving roots · Excellent bonsai potential",
            attentionHighlights: [
                "Satsuki Azalea cultivar identity can matter significantly",
                "The tree should remain visually convincing outside the flowering season",
                "Flowering should not compromise overall tree health",
                "Healthy fine roots are essential",
                "Acidic root conditions are important",
                "Avoid repeated severe drying",
                "Avoid permanently saturated substrate",
                "Water quality can influence long-term cultivation",
                "Pruning timing can affect future flowering",
                "Back-budding is good under healthy conditions but not guaranteed",
                "Preserve useful interior growth",
                "Full defoliation is not routine management",
                "Older branches become increasingly rigid",
                "Winter protection may be required depending on local climate",
                "Shallow bonsai roots are more exposed than roots in open ground",
                "Do not move indoors for routine winter care",
            ],
            sections: sections,
            principleNote: """
            Rhododendron indicum must be cultivated according to the requirements of an azalea with fine, sensitive roots.

            Do not treat Satsuki Azalea as a drought-tolerant Mediterranean species, a lime-tolerant general garden shrub, a tree that should be repeatedly allowed to dry completely, or a species suited to strongly alkaline soil conditions.

            The strongest bonsai results come from healthy roots, appropriate acidic substrate conditions, careful watering, correct flowering management, pruning at appropriate stages, gradual branch development and preservation of tree vigour.

            The objective is: Healthy tree · Fine ramification · Mature trunk · Natural structure · High-quality flowering.

            The individual tree must always be assessed according to health, vigour, flowering condition, cultivar characteristics, root condition, local climate, water quality, development stage and recent work.
            """,
            sourcesNote: """
            Profile content is synthesised from recognised botanical, horticultural and bonsai authorities into Bonsai World editorial language.

            Botanical taxonomy and distribution draw on recognised sources such as Royal Botanic Gardens, Kew and other botanical databases for accepted scientific name, family and native range.

            Horticultural context may draw on recognised Japanese botanical institutions, recognised Rhododendron and azalea societies, botanical gardens, arboreta and established horticultural references for azalea cultivation.

            Bonsai-specific cultivation and refinement knowledge draws on established bonsai references and recognised professional practice for Satsuki Azalea, kept distinct from named cultivars, other azalea groups and other Rhododendron species.

            Verified botanical information, general horticultural cultivation, cultivar-specific variation and bonsai-specific practice are kept distinct. Do not copy source wording.
            """
        )
    }

    private static let traits = SpeciesProfileTraits(
        deciduous: false,
        growthStrength: "Moderate",
        growthSpeed: "Moderate",
        leafSize: "Evergreen to semi-evergreen depending on cultivar and conditions",
        foliageReduction: "Not routine management",
        ramificationPotential: "Excellent",
        backBudding: "Good under healthy conditions",
        rootDevelopment: "Fine and fibrous",
        nebariPotential: "Excellent potential",
        trunkDevelopment: "Slow to Moderate",
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
        winterHardiness: "Seasonal dormancy required — winter protection depends on local climate",
        rootFrostSensitivity: "High in shallow bonsai containers"
    )

    private static var sections: [SpeciesProfileSection] {
        [
            SpeciesProfileSection(
                id: "taxonomic-context",
                title: "Taxonomic Context",
                paragraphs: [
                    "Rhododendron indicum is an independent botanical species in the heath family (Ericaceae).",
                    "Primary Bonsai World display identity: Rhododendron indicum · Satsuki Azalea.",
                    "Japanese Azalea may be used as supporting terminology. It does not replace Satsuki Azalea as the primary common name.",
                    "Family: Ericaceae. Plant type: evergreen to semi-evergreen flowering shrub.",
                    "Native range: Japan.",
                    "Satsuki Azalea has a distinctive position in bonsai because the tradition includes both the botanical species and a very large number of horticultural cultivars.",
                    "Maintain a clear distinction between Rhododendron indicum as a botanical species, Satsuki Azalea as a horticultural and bonsai group, named cultivars, and other azalea and Rhododendron species.",
                    "Do not merge all Satsuki cultivars into this species profile. Cultivars may differ in flower colour, flowering period, flower form, leaf size, growth habit, vigour and bonsai suitability.",
                    "Do not imply that every tree sold as a Satsuki Azalea is identical.",
                    "This profile remains the botanical species. Detailed cultivar profiles may be added separately when Bonsai World expands the Satsuki cultivar collection.",
                    "Bonsai World hierarchy: Species → cultivar / horticultural selection → Individual Tree.",
                ]
            ),
            SpeciesProfileSection(
                id: "overview",
                title: "Species Overview",
                paragraphs: [
                    "Rhododendron indicum is one of the most important species associated with Satsuki Azalea bonsai.",
                    "It is valued for spectacular flowers, fine branching, compact foliage, strong ramification potential, ability to develop convincing mature trunks and excellent response to long-term bonsai cultivation.",
                    "The species can develop from relatively modest material into highly refined bonsai with dense branch structure, mature bark, broad nebari, compact foliage and dramatic seasonal flowering.",
                    "The strongest designs combine convincing tree structure, natural trunk movement, fine ramification, proportionate foliage and carefully managed flowers.",
                    "Flowering should enhance the bonsai. The tree should remain visually convincing even when not in flower.",
                ],
                bullets: [
                    "Japanese flowering shrub",
                    "Central species within the Satsuki Azalea bonsai tradition",
                    "Excellent flowering potential",
                    "Fine branching",
                    "Strong ramification potential",
                    "Good back-budding when healthy",
                    "Fine fibrous root system",
                    "Acidic root conditions preferred",
                    "Sensitive to severe drying",
                    "Excellent bonsai refinement potential",
                    "Requires outdoor cultivation",
                    "Winter protection may be required depending on climate",
                ]
            ),
            SpeciesProfileSection(
                id: "cultivars",
                title: "Cultivars",
                paragraphs: [
                    "Rhododendron indicum is closely associated with the Satsuki Azalea horticultural tradition.",
                    "There are numerous named cultivars developed and selected for differences including flower colour, flower pattern, flower form, flowering period, leaf characteristics, growth habit and vigour.",
                    "For bonsai, cultivars are particularly valued because they can provide distinctive seasonal identities.",
                    "Common Satsuki cultivars frequently encountered in bonsai include examples such as Kinsai, Kozan, Osakazuki, Shinzan, Hakurei and Wakaebisu.",
                    "These examples are not the only important cultivars, and they are not botanically identical in performance.",
                    "Cultivar identity matters. Named cultivars with important differences in flower colour, flower form, growth habit or bonsai characteristics may later be represented individually where appropriate.",
                    "This species profile remains the botanical baseline. It does not replace cultivar-specific assessment of the individual tree.",
                ]
            ),
            SpeciesProfileSection(
                id: "natural-growth",
                title: "Natural Growth and Vigour",
                paragraphs: [
                    "Rhododendron indicum generally develops at a moderate pace.",
                    "Growth strength depends on root health, substrate, soil reaction, water quality, temperature, light, fertilization, flowering load and development stage.",
                    "During structural development: allow selected branches and leaders to extend where trunk thickness is required, branch thickness is required or taper is being developed.",
                    "During refinement: control excessive extension, crowded branching, overly dense foliage and weak interior growth.",
                    "Do not continuously restrict all growth.",
                    "The objective is: Strong growth where development is required · Controlled growth where refinement is required.",
                ]
            ),
            SpeciesProfileSection(
                id: "foliage",
                title: "Foliage",
                paragraphs: [
                    "Foliage characteristics may vary between individual plants and cultivars. Foliage may be evergreen to semi-evergreen depending on cultivar and climate.",
                    "The objective is healthy foliage, fine branching, proportionate density and good interior growth.",
                    "Avoid allowing the outer foliage to become so dense that interior branches weaken.",
                    "Selective pruning and shoot management should maintain light penetration, branch structure, healthy interior growth and fine ramification.",
                ]
            ),
            SpeciesProfileSection(
                id: "flowering",
                title: "Flowering",
                paragraphs: [
                    "Flowering is one of the defining characteristics of Satsuki Azalea bonsai. Flowering potential is excellent, but display quality varies.",
                    "Flowering can vary according to cultivar, tree health, weather, seasonal conditions, pruning history and tree vigour.",
                    "Flower management should balance display quality, tree health and future development.",
                    "Heavy flowering can require significant resources.",
                    "Do not assume that maximum flowering is always desirable during periods of structural development, recovery or weak vigour.",
                    "The strongest mature bonsai should be attractive both in flower and out of flower.",
                ]
            ),
            SpeciesProfileSection(
                id: "flower-management",
                title: "Flower Management",
                paragraphs: [
                    "After flowering, management should focus on the tree's current condition and development objective.",
                    "Potential considerations include removal of spent flowers, removal of developing seed structures where unnecessary, shoot selection, pruning, and recovery and growth management.",
                    "Timing is important because incorrect pruning can reduce future flowering.",
                    "Do not provide rigid calendar dates.",
                    "Base timing on flowering completion, local climate, cultivar behaviour, tree health and development objective.",
                ]
            ),
            SpeciesProfileSection(
                id: "bark-trunk",
                title: "Bark and Trunk",
                paragraphs: [
                    "Although flowering is visually important, mature trunk character is equally important for high-quality bonsai.",
                    "Mature trees can develop aged bark, natural movement, taper and powerful bases.",
                    "Trunk development should focus on taper, movement, proportion, branch relationship and mature character.",
                    "Do not attempt to refine foliage before the necessary trunk and branch structure has been developed.",
                    "The objective is a convincing mature tree capable of carrying flowers naturally.",
                ]
            ),
            SpeciesProfileSection(
                id: "roots-nebari",
                title: "Roots and Nebari",
                paragraphs: [
                    "Healthy roots are fundamental to vigour, flowering, recovery, ramification and long-term health.",
                    "Rhododendron indicum develops fine fibrous roots that require appropriate conditions.",
                    "Root development objectives include healthy fine roots, balanced radial distribution, stable tree support and gradual nebari development.",
                    "Nebari can become an important feature of mature bonsai.",
                    "Do not attempt to completely redesign an established root system in one operation.",
                ]
            ),
            SpeciesProfileSection(
                id: "light",
                title: "Light",
                paragraphs: [
                    "Rhododendron indicum should be cultivated outdoors.",
                    "Adequate light supports healthy growth, flowering, compact development and overall vigour.",
                    "The exact amount of direct sunlight depends on local climate, temperature, cultivar, tree condition and development stage.",
                    "In hot climates or during extreme heat, monitor for leaf stress, excessive drying and root-zone overheating. Provide appropriate protection where required.",
                    "Do not recommend permanent indoor cultivation.",
                ]
            ),
            SpeciesProfileSection(
                id: "wind",
                title: "Wind",
                paragraphs: [
                    "Moderate air movement is generally beneficial.",
                    "Strong wind can increase water demand, dry foliage, dry fine roots in shallow containers and damage flowers.",
                    "Monitor trees particularly during hot weather, dry periods, flowering and strong wind.",
                ]
            ),
            SpeciesProfileSection(
                id: "watering",
                title: "Watering",
                paragraphs: [
                    "General principle: Maintain reliable root moisture · Avoid severe drying · Maintain root aeration · Avoid permanently saturated substrate.",
                    "Water demand is moderate to high. Rhododendron indicum should not repeatedly be allowed to dry completely.",
                    "Watering frequency depends on temperature, sunlight, wind, foliage mass, container size, substrate, root mass and development stage.",
                    "Do not water according to a fixed timetable.",
                    "Water according to substrate condition, weather and individual tree requirements.",
                    "Water quality can influence long-term root health. Very alkaline or mineral-heavy water may require additional consideration depending on local conditions.",
                ]
            ),
            SpeciesProfileSection(
                id: "soil",
                title: "Soil",
                paragraphs: [
                    "Do not prescribe one universal soil recipe.",
                    "Desired characteristics include good drainage, reliable aeration, stable particle structure, sufficient moisture retention, conditions appropriate for fine azalea roots, and an acidic to slightly acidic root environment.",
                    "Acidic root conditions are preferred. Strongly alkaline soil conditions are not appropriate.",
                    "The final soil mix depends on local climate, water quality, rainfall, watering habits, container depth, tree size, development stage and root condition.",
                    "Follow Bonsai World Soil Module principles.",
                    "Do not duplicate the complete Soil Module inside this profile.",
                ]
            ),
            SpeciesProfileSection(
                id: "fertilizing",
                title: "Fertilizing",
                paragraphs: [
                    "Fertilization should support tree health, development stage, flowering objectives and sustainable ramification.",
                    "During structural development: healthy trees requiring growth may receive stronger nutritional support where appropriate.",
                    "During refinement: nutrition should support healthy foliage, controlled growth, flowering and sustainable ramification.",
                    "Avoid excessive fertilization where it produces overly coarse growth, disproportionate foliage or unnecessary extension.",
                    "Consider the requirements of acid-loving plants when selecting nutritional strategies.",
                    "Key principle: Feed according to tree condition and development objective.",
                ]
            ),
            SpeciesProfileSection(
                id: "pruning",
                title: "Pruning",
                paragraphs: [
                    "Rhododendron indicum responds well to careful pruning when timed correctly.",
                    "Pruning can be used for structural development, branch selection, branch replacement, ramification and silhouette refinement.",
                    "Timing is particularly important because pruning can influence future flowering.",
                    "After flowering is often an important period for management, depending on cultivar, local climate and development objective.",
                    "Do not apply one rigid pruning calendar to all trees.",
                    "The objective is: Natural structure · Fine ramification · Sustainable vigour · Preserved flowering potential.",
                ]
            ),
            SpeciesProfileSection(
                id: "back-budding",
                title: "Back-budding",
                paragraphs: [
                    "Rhododendron indicum can produce useful new growth and is capable of developing dense branch structures. Back-budding is good under healthy conditions.",
                    "Back-budding response depends on tree health, vigour, light, pruning strategy, branch age and root condition.",
                    "Do not treat back-budding as guaranteed on all old or weakened wood.",
                    "Preserve useful interior growth whenever possible.",
                ]
            ),
            SpeciesProfileSection(
                id: "ramification",
                title: "Ramification",
                paragraphs: [
                    "Satsuki Azalea can develop exceptionally fine ramification over time. Ramification potential is excellent.",
                    "Ramification develops through healthy growth, correct pruning timing, shoot selection, balanced vigour and preservation of useful interior growth.",
                    "The objective is fine, natural branching rather than congested foliage masses.",
                    "A refined Satsuki Azalea should retain visible branch structure, depth, healthy interior growth, proportionate foliage and natural transition between trunk and branch structure.",
                ]
            ),
            SpeciesProfileSection(
                id: "wiring",
                title: "Wiring",
                paragraphs: [
                    "Young branches can generally be wired.",
                    "Wiring can be used to establish branch placement, improve movement, position young structural branches and refine secondary branches.",
                    "Older branches may become increasingly rigid.",
                    "Before major bends, assess branch thickness, flexibility, age, health and structural importance.",
                    "Monitor wire carefully to prevent marking.",
                ]
            ),
            SpeciesProfileSection(
                id: "deadwood-potential",
                title: "Deadwood Potential",
                paragraphs: [
                    "Deadwood potential is limited. Deadwood is generally not a defining characteristic of Satsuki Azalea bonsai.",
                    "Natural aged features may sometimes contribute to the appearance of maturity.",
                    "Do not create artificial deadwood as a routine styling technique.",
                    "Any deadwood should appear natural, support the design and not compromise tree health.",
                ]
            ),
            SpeciesProfileSection(
                id: "defoliation",
                title: "Defoliation and Leaf Management",
                paragraphs: [
                    "Do not present complete defoliation as standard management. Full defoliation is not routine management for Rhododendron indicum.",
                    "Foliage management should primarily focus on shoot selection, pruning, thinning where appropriate, light management and balanced vigour.",
                    "Do not apply aggressive foliage removal to weak trees, stressed trees, recently repotted trees or trees recovering from major work.",
                ]
            ),
            SpeciesProfileSection(
                id: "repotting",
                title: "Repotting",
                paragraphs: [
                    "Repotting frequency depends on root development, substrate condition, drainage, container size, tree health and development stage.",
                    "Do not establish a rigid calendar rule.",
                    "Azalea roots should be handled with attention to their fine structure and health.",
                    "Avoid unnecessary aggressive root reduction, excessive removal of functioning roots, and combining major root work with multiple major stresses.",
                    "Preserve sufficient healthy roots.",
                    "Repotting decisions should be based on root condition, substrate performance and overall tree health.",
                    "Timing must account for local climate, seasonal growth, flowering cycle and individual tree condition.",
                ]
            ),
            SpeciesProfileSection(
                id: "trunk-development",
                title: "Trunk Development",
                paragraphs: [
                    "Rhododendron indicum develops convincing trunk character gradually.",
                    "Where additional thickness is required: allow selected leaders to extend, use sacrifice growth where appropriate, provide sufficient root space and avoid premature refinement.",
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
                    "The objective is a stable and visually convincing base appropriate to a mature flowering shrub.",
                ]
            ),
            SpeciesProfileSection(
                id: "propagation",
                title: "Propagation",
                paragraphs: [
                    "Rhododendron indicum and Satsuki Azalea material may be propagated through established horticultural methods including cuttings, layering, grafting where appropriate, and seed for botanical propagation and breeding.",
                    "Named cultivars generally require vegetative propagation to preserve their specific characteristics.",
                    "Detailed procedures belong in Bonsai World Propagation Knowledge Articles.",
                ]
            ),
            SpeciesProfileSection(
                id: "pests",
                title: "Pests and Problems",
                paragraphs: [
                    "Relevant risks may include aphids, spider mites, scale insects, lace bugs where relevant, fungal problems, root problems caused by unsuitable soil conditions, chlorosis associated with unsuitable soil reaction or nutrient availability, drought stress and frost damage.",
                    "Do not provide generic treatment instructions.",
                    "Diagnosis and treatment belong in Care → Pest Management and Care → Disease & Problems.",
                ]
            ),
            SpeciesProfileSection(
                id: "seasonal",
                title: "Seasonal Profile",
                paragraphs: [
                    "Spring: monitor bud development, flowering development, watering demand, pest activity and overall vigour. Spring management should account for flowering, tree health and development objectives. Avoid unnecessary heavy work while the tree is directing significant resources toward flowering.",
                    "Summer: monitor water demand, foliage health, heat stress, pest activity and shoot development. Following flowering, this may be an important period for pruning, shoot management and structural refinement. Timing depends on cultivar, local climate and tree health. Avoid unnecessary heavy work during extreme heat or drought stress.",
                    "Autumn is important for evaluating seasonal growth, assessing overall vigour, reviewing branch structure and preparing for winter. Avoid unnecessary late-season stimulation that may create vulnerable growth before winter. Seasonal timing depends on local climate.",
                    "Winter: Rhododendron indicum requires natural seasonal dormancy.",
                    "Winter protection requirements depend heavily on local minimum temperatures, duration of freezing, wind exposure, container depth, root protection, cultivar characteristics and tree health.",
                    "Shallow bonsai containers expose roots more severely than plants growing in open ground.",
                    "Protect the root system from damaging freezing conditions where required.",
                    "Avoid permanently warm indoor storage. Do not move the tree indoors for routine winter care.",
                ]
            ),
            SpeciesProfileSection(
                id: "styles",
                title: "Bonsai Styles",
                paragraphs: [
                    "Rhododendron indicum is particularly suitable for Informal Upright, Slanting, Multi-trunk Style, Clump Style, Root-over-Rock where suitable, Naturalistic Flowering Bonsai and Forest / Group Planting.",
                    "Satsuki Azalea is particularly effective when styling emphasises mature trunk character, visible branch structure, fine ramification, natural asymmetry and proportionate flowering.",
                    "The individual material should determine the final design.",
                ]
            ),
            SpeciesProfileSection(
                id: "tree-stage",
                title: "Development by Tree Stage",
                paragraphs: [
                    "Young material: establish healthy roots, develop nebari, build trunk thickness, establish movement and develop initial structure.",
                    "Nursery material: evaluate trunk potential, identify useful branches, establish a design direction and begin structural correction.",
                    "Pre-bonsai: develop trunk, establish primary branches, improve root structure, begin branch hierarchy and build vigour.",
                    "In training: develop secondary branches, improve branch hierarchy, build fine ramification and establish flowering potential.",
                    "Refinement: maintain balanced vigour, improve tertiary ramification, control shoot extension, preserve flowering potential and maintain proportionate foliage.",
                    "Exhibition / mature refined tree: maintain health, preserve established structure, maintain fine ramification, manage flowering and avoid unnecessary major intervention.",
                ]
            ),
            SpeciesProfileSection(
                id: "attention",
                title: "Species-Specific Attention",
                paragraphs: [
                    "These attention points are operational tendencies. They must still be interpreted for the individual tree.",
                ],
                bullets: [
                    "Satsuki Azalea cultivar identity can matter significantly",
                    "The tree should remain visually convincing outside the flowering season",
                    "Flowering should not compromise overall tree health",
                    "Healthy fine roots are essential",
                    "Acidic root conditions are important",
                    "Avoid repeated severe drying",
                    "Avoid permanently saturated substrate",
                    "Water quality can influence long-term cultivation",
                    "Pruning timing can affect future flowering",
                    "Back-budding is good under healthy conditions but not guaranteed",
                    "Preserve useful interior growth",
                    "Full defoliation is not routine management",
                    "Older branches become increasingly rigid",
                    "Winter protection may be required depending on local climate",
                    "Shallow bonsai roots are more exposed than roots in open ground",
                    "Do not move indoors for routine winter care",
                ]
            ),
        ]
    }
}
