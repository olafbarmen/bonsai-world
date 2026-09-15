//
//  CarpinusCoreanaSpeciesProfile.swift
//  Bonsai World
//
//  Species Profile — Carpinus coreana (Korean Hornbeam).
//  Independent botanical species in Betulaceae. Knowledge status: Reviewed.
//  Separate from Carpinus betulus and other East Asian Carpinus species.
//

import Foundation

enum CarpinusCoreanaSpeciesProfile {
    /// Identity used by Botanical Library / ``SpeciesPreviewData``.
    static let botanicalLibraryName = "Carpinus coreana"
    /// Scientific name for Species Profile display (binomial; no botanical authority).
    static let scientificName = "Carpinus coreana"

    static var profile: SpeciesProfile {
        SpeciesProfile(
            speciesID: BotanicalKnowledgeIDs.carpinusCoreana,
            scientificName: scientificName,
            commonNames: ["Korean Hornbeam"],
            family: "Betulaceae",
            plantType: "Deciduous tree",
            originSummary: "Korea.",
            knowledgeStatus: .reviewed,
            traits: traits,
            foliageSizeLabel: "Foliage",
            foliageReductionLabel: "Leaf reduction",
            summaryLine: "Deciduous · Small leaves · Fine ramification potential · Compact proportions · Strong autumn character · Responsive to pruning · Excellent refinement potential · Requires winter dormancy",
            attentionHighlights: [
                "Carpinus coreana is particularly valued for naturally small foliage and fine ramification",
                "Requires winter dormancy",
                "Outdoor cultivation is required",
                "Do not prioritise fine refinement before trunk and branch structure are sufficiently developed",
                "Good back-budding should be qualified by health and branch condition",
                "Do not assume every old or bare branch will reliably regenerate",
                "Avoid repeated severe drying",
                "Avoid permanently saturated roots",
                "Fine ramification should be developed gradually",
                "Preserve useful interior growth",
                "Do not use complete defoliation as routine management",
                "Young branches are generally easier to position than older branches",
                "Avoid forcing rigid branches",
                "Do not artificially damage bark",
                "Shallow bonsai roots require protection during prolonged severe freezing",
            ],
            sections: sections,
            principleNote: """
            Carpinus coreana is particularly valued for refinement.

            Its strongest bonsai qualities include naturally small leaves, fine ramification, compact proportions, responsive pruning behaviour and strong potential for highly refined deciduous bonsai.

            However, refinement should not be prioritised before trunk development, taper, primary branch structure and root development.

            The objective is: Strong basic structure · Fine branch hierarchy · Progressive ramification · Compact proportions · Natural maturity.

            Avoid treating the species as though it were simply a smaller version of Carpinus betulus.

            The individual material and species-specific response should determine development decisions.

            The individual tree must always be assessed according to climate, tree condition, vigour, development stage and winter temperatures.
            """,
            sourcesNote: """
            Profile content is synthesised from recognised botanical, horticultural and bonsai authorities into Bonsai World editorial language.

            Botanical taxonomy and distribution draw on recognised sources such as Royal Botanic Gardens, Kew and other botanical databases for accepted scientific name, family and native range.

            Where botanical classification is discussed differently by different authorities, Bonsai World preserves the accepted species name used in the Botanical Library and avoids creating duplicate records.

            Horticultural context may draw on recognised Korean botanical institutions, horticultural institutions and authoritative Carpinus references.

            Bonsai-specific cultivation and refinement knowledge draws on established bonsai references and recognised professional practice with Carpinus experience, kept distinct from Carpinus betulus and other East Asian Carpinus species.

            Verified botanical information, horticultural information, regional climate adaptation and bonsai-specific practice are kept distinct. Do not copy source wording.
            """
        )
    }

    private static let traits = SpeciesProfileTraits(
        deciduous: true,
        growthStrength: "Moderate",
        growthSpeed: "Moderate",
        leafSize: "Deciduous · Small",
        foliageReduction: "Not routine management",
        ramificationPotential: "Excellent",
        backBudding: "Good",
        rootDevelopment: "Good",
        nebariPotential: "Good potential",
        trunkDevelopment: "Moderate",
        barkDevelopment: "Good mature character",
        wiring: "Moderate",
        defoliation: "Not routine management",
        airLayering: "Where appropriate for the individual material",
        threadGrafting: "Where structural correction is required",
        rootGrafting: "Where appropriate",
        beginnerSuitability: "Moderate",
        bonsaiSuitability: "Excellent",
        difficulty: "Intermediate to Advanced",
        winterDormancyRequired: true,
        winterHardiness: "Required",
        rootFrostSensitivity: "Moderate in shallow bonsai containers during prolonged severe freezing"
    )

    private static var sections: [SpeciesProfileSection] {
        [
            SpeciesProfileSection(
                id: "taxonomic-context",
                title: "Taxonomic Context",
                paragraphs: [
                    "Carpinus coreana is an independent botanical species in the birch family (Betulaceae).",
                    "Primary Bonsai World display identity: Carpinus coreana · Korean Hornbeam.",
                    "Family: Betulaceae. Plant type: deciduous tree.",
                    "Native range: Korea.",
                    "This profile must remain separate from Carpinus betulus.",
                    "Do not merge the profile with Japanese Hornbeam or other East Asian Carpinus species.",
                    "Where botanical classification is discussed differently by different authorities, preserve the accepted species name used in the Bonsai World Botanical Library and avoid creating duplicate records.",
                    "Bonsai World hierarchy: Species → cultivar / horticultural selection → Individual Tree.",
                ]
            ),
            SpeciesProfileSection(
                id: "overview",
                title: "Species Overview",
                paragraphs: [
                    "Carpinus coreana is a highly regarded deciduous species for bonsai.",
                    "Carpinus coreana is particularly relevant to Bonsai World because it offers naturally small foliage, excellent proportions for bonsai, strong ramification potential, compact and refined branch structure, an established reputation among advanced bonsai growers and particular suitability for refined deciduous bonsai.",
                    "Its naturally small foliage and fine branch development make it particularly suitable for shohin bonsai, smaller bonsai, medium refined bonsai and highly developed deciduous trees.",
                    "The species can produce convincing proportions because foliage is naturally small, branches can be refined and ramification can become dense without requiring artificially oversized foliage masses.",
                    "The best results usually come from long-term development.",
                    "The objective should be: Trunk quality first · Structure second · Ramification third · Fine refinement last.",
                ],
                bullets: [
                    "Deciduous",
                    "Korean species",
                    "Naturally small leaves",
                    "Excellent ramification potential",
                    "Good back-budding",
                    "Responsive to pruning",
                    "Suitable for smaller bonsai",
                    "Suitable for refined bonsai",
                    "Requires winter dormancy",
                    "Outdoor cultivation required",
                    "Strong autumn character",
                    "Long-term refinement potential",
                ]
            ),
            SpeciesProfileSection(
                id: "cultivars",
                title: "Cultivars and Forms",
                paragraphs: [
                    "Carpinus coreana is primarily used in bonsai as the botanical species.",
                    "Horticultural selections may differ in foliage density, growth habit and branch character.",
                    "Do not create unnecessary separate Species Library profiles for minor individual variation.",
                    "The primary Species Profile remains Carpinus coreana.",
                    "Only create separate profiles where a distinct cultivar or form has a clear and established independent bonsai identity.",
                ]
            ),
            SpeciesProfileSection(
                id: "natural-growth",
                title: "Natural Growth and Vigour",
                paragraphs: [
                    "Carpinus coreana has moderate growth and can respond well when roots are healthy, water is appropriately managed, light is sufficient, nutrition supports the current development objective and the tree has sufficient energy reserves.",
                    "During structural development: allow selected growth to extend where trunk thickness is required, taper is required or primary branches require development.",
                    "During refinement: control excessive shoot extension, unnecessary congestion, loss of interior structure and imbalance in branch vigour.",
                    "Do not suppress useful development growth prematurely.",
                    "The objective is: Healthy growth · Clear structure · Progressive refinement.",
                ]
            ),
            SpeciesProfileSection(
                id: "foliage",
                title: "Foliage",
                paragraphs: [
                    "Carpinus coreana has naturally small foliage, which is one of its most important advantages for bonsai.",
                    "Foliage management should focus on maintaining tree health, balanced vigour, shoot selection, branch development and compact proportions.",
                    "Leaf size and growth strength may still vary according to genetics, vigour, fertilization, growing conditions and development stage.",
                    "Do not rely on aggressive foliage reduction as the main method of refinement.",
                    "The primary objective is: Healthy foliage · Natural proportions · Fine structure.",
                ]
            ),
            SpeciesProfileSection(
                id: "flowering",
                title: "Flowering",
                paragraphs: [
                    "Flowering is not a primary bonsai feature.",
                    "Do not sacrifice structural development or ramification in pursuit of flowering.",
                ]
            ),
            SpeciesProfileSection(
                id: "fruit",
                title: "Fruit",
                paragraphs: [
                    "Fruit-bearing is not a primary bonsai feature.",
                    "Fruit is not required for a convincing Korean Hornbeam bonsai.",
                    "Do not treat fruit production as a styling priority.",
                ]
            ),
            SpeciesProfileSection(
                id: "bark-trunk",
                title: "Bark and Trunk",
                paragraphs: [
                    "Carpinus coreana can develop attractive mature trunk character. Mature bark character is good.",
                    "Trunk development should focus on sufficient thickness, believable taper, natural movement and appropriate proportions.",
                    "Do not artificially damage healthy bark to simulate age.",
                    "The objective is: Natural maturity · Strong proportions · Refined character.",
                ]
            ),
            SpeciesProfileSection(
                id: "roots-nebari",
                title: "Roots and Nebari",
                paragraphs: [
                    "Healthy roots support vigour, recovery, foliage health, branch development and long-term container cultivation.",
                    "Root development is good. Objectives include balanced roots, radial development, stable anchoring and gradual nebari improvement.",
                    "Root work should be staged.",
                    "Avoid unnecessary aggressive root reduction.",
                    "The objective is: Healthy roots · Stable development · Convincing nebari.",
                ]
            ),
            SpeciesProfileSection(
                id: "light",
                title: "Light",
                paragraphs: [
                    "Carpinus coreana should be cultivated outdoors with good access to light.",
                    "Adequate light supports healthy foliage, compact growth, branch development, ramification and balanced vigour.",
                    "The ideal position depends on local climate, summer temperatures, tree health and development stage.",
                    "Outdoor cultivation is required.",
                    "Do not recommend permanent indoor cultivation.",
                ]
            ),
            SpeciesProfileSection(
                id: "wind",
                title: "Wind",
                paragraphs: [
                    "Moderate air movement is beneficial.",
                    "Strong wind can increase water demand, dry foliage, dry shallow containers and increase winter exposure.",
                    "Monitor carefully during warm dry wind, prolonged dry periods and exposed winter conditions.",
                ]
            ),
            SpeciesProfileSection(
                id: "watering",
                title: "Watering",
                paragraphs: [
                    "General principle: Maintain reliable moisture · Avoid repeated severe drying · Avoid permanently saturated roots · Maintain healthy root aeration.",
                    "Water demand is moderate.",
                    "Water demand depends on temperature, sunlight, wind, foliage mass, container size, substrate and root mass.",
                    "Do not water according to a fixed timetable.",
                    "The objective is: Consistent healthy moisture · Healthy roots · Stable vigour.",
                ]
            ),
            SpeciesProfileSection(
                id: "soil",
                title: "Soil",
                paragraphs: [
                    "Do not prescribe one universal soil recipe.",
                    "Desired characteristics include good drainage, good aeration, sufficient moisture retention, stable particle structure and healthy root development.",
                    "The final substrate depends on local climate, rainfall, watering habits, container depth, tree size and development stage.",
                    "Follow Bonsai World Soil Module principles.",
                    "Do not duplicate the complete Soil Module inside this profile.",
                ]
            ),
            SpeciesProfileSection(
                id: "fertilizing",
                title: "Fertilizing",
                paragraphs: [
                    "Fertilization should support foliage health, trunk development, branch development, ramification and recovery.",
                    "During structural development: support healthy growth where thickness is required.",
                    "During refinement: avoid excessive feeding that produces overly long shoots, coarse growth, unnecessarily large foliage or excessively long internodes.",
                    "Key principle: Feed according to tree health and development objective.",
                ]
            ),
            SpeciesProfileSection(
                id: "pruning",
                title: "Pruning",
                paragraphs: [
                    "Pruning is one of the primary tools for developing Carpinus coreana. Pruning response is excellent.",
                    "Pruning can be used for structural development, branch selection, branch replacement, ramification and silhouette refinement.",
                    "During development: allow selected leaders and branches to extend where thickness or taper is required.",
                    "During refinement: use selective pruning and shoot management to maintain branch hierarchy, compact proportions, useful interior growth and balanced vigour.",
                    "Avoid repeated uniform trimming.",
                    "The objective is: Purposeful development · Fine ramification · Natural structure.",
                ]
            ),
            SpeciesProfileSection(
                id: "back-budding",
                title: "Back-budding",
                paragraphs: [
                    "Carpinus coreana can produce useful new growth when healthy. Back-budding is good.",
                    "Response depends on tree health, vigour, branch age, available buds, pruning timing and light.",
                    "Do not assume that completely bare old branches will always regenerate.",
                    "When pruning: preserve useful interior growth, retain potential replacement branches and avoid unnecessary removal of viable buds.",
                    "The objective is: Controlled renewal · Fine branch development · Preservation of future options.",
                ]
            ),
            SpeciesProfileSection(
                id: "ramification",
                title: "Ramification",
                paragraphs: [
                    "Ramification is one of the defining strengths of Carpinus coreana. Ramification potential is excellent.",
                    "Develop ramification through repeated healthy growth cycles, selective shoot pruning, branch selection, vigour balancing and preservation of useful interior growth.",
                    "Avoid uniform hedge-like trimming, dense outer foliage with empty interiors and repeated removal of fine inner branches.",
                    "The objective is: Fine branch hierarchy · Dense but believable ramification · Visible internal structure.",
                ]
            ),
            SpeciesProfileSection(
                id: "wiring",
                title: "Wiring",
                paragraphs: [
                    "Young branches are generally easier to position than older branches. Wiring response is moderate.",
                    "Wiring can be used for branch direction, structural placement and correction of young growth.",
                    "Before major bends assess branch thickness, flexibility, age, health and structural importance.",
                    "Monitor wire carefully.",
                    "Avoid forcing rigid branches.",
                    "Pruning and directional growth should be considered alongside wiring.",
                ]
            ),
            SpeciesProfileSection(
                id: "deadwood-potential",
                title: "Deadwood",
                paragraphs: [
                    "Deadwood is not normally a defining feature of refined Carpinus coreana bonsai. Deadwood potential is low.",
                    "Natural scars or old branch remnants may occasionally contribute to character.",
                    "Avoid dramatic artificial deadwood.",
                    "The objective is natural maturity rather than manufactured damage.",
                ]
            ),
            SpeciesProfileSection(
                id: "defoliation",
                title: "Foliage Management",
                paragraphs: [
                    "Complete defoliation is not routine management.",
                    "Foliage management should primarily focus on shoot selection, pruning, vigour balancing, appropriate fertilization and adequate light.",
                    "Do not present complete defoliation as routine maintenance.",
                    "Do not apply aggressive foliage work to weak trees, stressed trees, recently repotted trees or trees recovering from major structural work.",
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
                    "Repotting decisions should be based on root condition, substrate performance and tree health.",
                    "Timing must account for local climate, winter conditions, active growth cycle and individual tree condition.",
                ]
            ),
            SpeciesProfileSection(
                id: "trunk-development",
                title: "Trunk Development",
                paragraphs: [
                    "Carpinus coreana should be allowed sufficient growth while the trunk is still under development.",
                    "Where additional thickness is required: allow selected leaders to extend, provide sufficient root space, use development containers where appropriate and avoid premature refinement.",
                    "Leader development should support taper, trunk thickness, natural movement and believable proportions.",
                    "Once sufficient trunk development has been achieved, shift focus toward branch hierarchy, secondary branches, ramification and refined proportions.",
                    "Key principle: Do not permanently restrict a tree that still requires major structural development.",
                ]
            ),
            SpeciesProfileSection(
                id: "nebari-development",
                title: "Nebari Development",
                paragraphs: [
                    "Nebari should be developed gradually.",
                    "Potential approaches include early root selection, radial root planning, staged correction, suitable development containers and gradual refinement.",
                    "The objective is a stable and visually convincing base appropriate to a refined deciduous bonsai.",
                ]
            ),
            SpeciesProfileSection(
                id: "propagation",
                title: "Propagation",
                paragraphs: [
                    "Carpinus coreana may be propagated using established horticultural methods where appropriate.",
                    "Detailed procedures belong in Bonsai World Propagation Knowledge Articles.",
                ]
            ),
            SpeciesProfileSection(
                id: "pests",
                title: "Pests and Problems",
                paragraphs: [
                    "Relevant risks may include aphids, scale insects, leaf-feeding insects, fungal leaf problems, drought stress, root problems caused by poor substrate aeration, stress caused by repeated drying and root stress during prolonged severe freezing.",
                    "Do not provide generic treatment instructions.",
                    "Diagnosis and treatment belong in Care → Pest Management and Care → Disease & Problems.",
                ]
            ),
            SpeciesProfileSection(
                id: "seasonal",
                title: "Seasonal Profile",
                paragraphs: [
                    "Spring: monitor bud development, new growth, watering demand, vigour and structural priorities. Spring is important for evaluating branch development, ramification, root health and recovery from winter. Coordinate major work with local climate and individual tree condition.",
                    "Summer: monitor watering demand, foliage health, shoot extension, pest activity and wire marks. Strong growth should be managed according to whether shoots are required for trunk development, branch development or refinement. Do not suppress useful vigorous growth unnecessarily.",
                    "Autumn is important for evaluating foliage health, reviewing branch structure, assessing growth and preparing for dormancy. Seasonal colour may contribute to the visual character of refined trees. Local climate and tree condition determine timing. Do not apply one universal autumn schedule.",
                    "Winter: Carpinus coreana requires winter dormancy.",
                    "Winter management depends on local minimum temperatures, duration of freezing, wind exposure, container depth, root protection and tree health.",
                    "Shallow bonsai roots are more exposed to severe cold than roots growing in open ground.",
                    "Protect the root system when required. Do not maintain indoors as a substitute for winter dormancy.",
                ]
            ),
            SpeciesProfileSection(
                id: "styles",
                title: "Bonsai Styles",
                paragraphs: [
                    "Carpinus coreana is particularly suitable for Informal Upright, Formal Upright, Slanting, Multi-trunk, Clump Style, Naturalistic Bonsai and Forest Style.",
                    "It is especially effective when styling emphasises compact proportions, fine branching, natural trunk movement, visible structure and refined deciduous ramification.",
                    "The individual material should determine the final design.",
                ]
            ),
            SpeciesProfileSection(
                id: "tree-stage",
                title: "Development by Tree Stage",
                paragraphs: [
                    "Young material: establish healthy roots, develop trunk thickness, establish movement and begin structural development.",
                    "Nursery material: evaluate trunk potential, identify useful branches, establish design direction and begin structural correction.",
                    "Pre-bonsai: develop trunk, establish primary branches, improve root structure, build taper and build vigour.",
                    "In training: develop secondary branches, improve branch hierarchy, build ramification and preserve useful interior growth.",
                    "Refinement: maintain balanced vigour, improve branch structure, control excessive extension, build fine ramification and preserve visible internal structure.",
                    "Exhibition / mature refined tree: maintain health, preserve established structure, maintain balanced ramification, preserve mature proportions and avoid unnecessary major intervention.",
                ]
            ),
            SpeciesProfileSection(
                id: "attention",
                title: "Species-Specific Attention",
                paragraphs: [
                    "These attention points are operational tendencies. They must still be interpreted for the individual tree.",
                ],
                bullets: [
                    "Carpinus coreana is particularly valued for naturally small foliage and fine ramification",
                    "Requires winter dormancy",
                    "Outdoor cultivation is required",
                    "Do not prioritise fine refinement before trunk and branch structure are sufficiently developed",
                    "Good back-budding should be qualified by health and branch condition",
                    "Do not assume every old or bare branch will reliably regenerate",
                    "Avoid repeated severe drying",
                    "Avoid permanently saturated roots",
                    "Fine ramification should be developed gradually",
                    "Preserve useful interior growth",
                    "Do not use complete defoliation as routine management",
                    "Young branches are generally easier to position than older branches",
                    "Avoid forcing rigid branches",
                    "Do not artificially damage bark",
                    "Shallow bonsai roots require protection during prolonged severe freezing",
                ]
            ),
        ]
    }
}
