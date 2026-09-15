//
//  GinkgoBilobaSpeciesProfile.swift
//  Bonsai World
//
//  Species Profile — Ginkgo biloba (Ginkgo).
//  Independent botanical species in Ginkgoaceae. Knowledge status: Reviewed.
//  Deciduous gymnosperm. Species Library category: Non-flowering Deciduous Trees.
//  Do not place in Conifers. Do not describe as a flowering tree.
//

import Foundation

enum GinkgoBilobaSpeciesProfile {
    /// Identity used by Botanical Library / ``SpeciesPreviewData``.
    static let botanicalLibraryName = "Ginkgo biloba"
    /// Scientific name for Species Profile display (binomial; no botanical authority).
    static let scientificName = "Ginkgo biloba"

    static var profile: SpeciesProfile {
        SpeciesProfile(
            speciesID: BotanicalKnowledgeIDs.ginkgoBiloba,
            scientificName: scientificName,
            commonNames: ["Ginkgo", "Maidenhair Tree"],
            family: "Ginkgoaceae",
            plantType: "Deciduous gymnosperm",
            originSummary: "China.",
            knowledgeStatus: .reviewed,
            traits: traits,
            foliageSizeLabel: "Foliage",
            foliageReductionLabel: "Leaf reduction",
            summaryLine: "Deciduous · Ancient lineage · Unique fan-shaped foliage · Hardy · Slow to moderate development · Strong vertical growth habit · Distinctive autumn colour · Long-lived · Architectural bonsai potential",
            attentionHighlights: [
                "Ginkgo biloba is a gymnosperm, not a flowering tree",
                "It produces seeds rather than botanical fruit",
                "It is placed in Non-flowering Deciduous Trees for Bonsai World category purposes",
                "Do not classify it as a conifer",
                "Unique fan-shaped foliage is a defining visual characteristic",
                "Requires winter dormancy",
                "Outdoor cultivation is required",
                "Development is generally slower than many vigorous deciduous species",
                "Structural work should be deliberate and long-term",
                "Back-budding should be qualified by tree health, vigour and branch condition",
                "Do not assume old bare branches will reliably regenerate",
                "Avoid premature refinement",
                "Do not use complete defoliation as routine management",
                "Young branches are generally easier to position than older branches",
                "Avoid forcing rigid branches",
                "Mature bark character develops naturally with age",
                "Do not artificially damage bark",
                "Shallow bonsai roots require protection during prolonged severe freezing",
                "Respect the species' distinctive architectural growth character",
            ],
            sections: sections,
            principleNote: """
            Ginkgo biloba should not be treated as a generic deciduous broadleaf species.

            Its natural growth character is highly distinctive.

            Important characteristics include strong vertical tendencies, distinctive fan-shaped leaves, unusual branching character, long-term development potential, slow maturation compared with many vigorous deciduous species and strong architectural presence.

            The species is often most convincing when the bonsai design respects its naturally distinctive character.

            Avoid forcing Ginkgo into excessively dense foliage pads, highly artificial branching patterns or generic deciduous bonsai silhouettes.

            The objective is: Natural species character · Strong trunk · Clear structure · Controlled branching · Distinctive foliage presentation.

            The individual tree must always be assessed according to climate, tree condition, vigour, development stage and winter temperatures.
            """,
            sourcesNote: """
            Profile content is synthesised from recognised botanical, horticultural and bonsai authorities into Bonsai World editorial language.

            Botanical taxonomy and distribution draw on recognised sources such as Royal Botanic Gardens, Kew and other botanical databases for accepted scientific name, family and native range.

            Horticultural context may draw on recognised botanical and horticultural institutions and authoritative Ginkgo references.

            Bonsai-specific cultivation and refinement knowledge draws on established bonsai references and recognised professional practice with Ginkgo experience.

            Verified botanical information, horticultural information, regional climate adaptation and bonsai-specific practice are kept distinct. Do not copy source wording.
            """
        )
    }

    private static let traits = SpeciesProfileTraits(
        deciduous: true,
        growthStrength: "Moderate",
        growthSpeed: "Slow to Moderate",
        leafSize: "Deciduous · Medium",
        foliageReduction: "Not routine management",
        ramificationPotential: "Moderate",
        backBudding: "Moderate",
        rootDevelopment: "Moderate",
        nebariPotential: "Good potential with long-term development",
        trunkDevelopment: "Slow to Moderate",
        barkDevelopment: "Excellent mature character",
        wiring: "Moderate",
        defoliation: "Not routine management",
        airLayering: "Where appropriate for the individual material",
        threadGrafting: "Where structural correction is required",
        rootGrafting: "Where appropriate",
        beginnerSuitability: "Moderate",
        bonsaiSuitability: "Good",
        difficulty: "Intermediate",
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
                    "Ginkgo biloba is an independent botanical species in the family Ginkgoaceae.",
                    "Primary Bonsai World display identity: Ginkgo biloba · Ginkgo.",
                    "Maidenhair Tree may be used as supporting terminology. It does not replace Ginkgo as the preferred English common name.",
                    "Family: Ginkgoaceae. Plant type: deciduous gymnosperm.",
                    "Native range: China.",
                    "Ginkgo biloba is botanically a gymnosperm and does not produce flowers or true fruits.",
                    "Because it is a deciduous broad-leaved tree and the Bonsai World Species Library uses broad practical bonsai categories, it is placed in Non-flowering Deciduous Trees.",
                    "Do not place Ginkgo biloba in Conifers.",
                    "Do not describe it as a flowering tree.",
                    "Do not describe its seed structures as botanical fruit.",
                    "Ginkgo biloba should remain a separate profile and should not be grouped botanically with Acer, Ulmus, Fagus or other deciduous flowering trees.",
                    "Bonsai World hierarchy: Species → cultivar / horticultural selection → Individual Tree.",
                ]
            ),
            SpeciesProfileSection(
                id: "overview",
                title: "Species Overview",
                paragraphs: [
                    "Ginkgo biloba is the only living species in its botanical lineage and is often regarded as one of the most distinctive trees used in horticulture.",
                    "It is a deciduous gymnosperm rather than a flowering broadleaf tree.",
                    "Ginkgo biloba is particularly relevant to Bonsai World because it is one of the world's most distinctive tree species, widely cultivated internationally, well known in horticulture and bonsai, botanically unique, suitable for bonsai when its natural growth character is respected and capable of exceptional age and longevity.",
                    "The species is immediately recognisable because of its fan-shaped leaves, distinctive branching, strong autumn colour, unusual botanical history and exceptional longevity.",
                    "For bonsai, Ginkgo requires patience.",
                    "It is generally better suited to deliberate structural development, long-term trunk building, controlled branch development and designs that respect its natural architecture.",
                ],
                bullets: [
                    "Deciduous",
                    "Gymnosperm",
                    "Non-flowering",
                    "Produces seeds rather than botanical fruit",
                    "Ancient botanical lineage",
                    "Unique fan-shaped foliage",
                    "Strong autumn colour",
                    "Long-lived",
                    "Hardy",
                    "Requires winter dormancy",
                    "Outdoor cultivation required",
                    "Slow to moderate development",
                    "Moderate ramification",
                    "Moderate back-budding",
                    "Strong architectural character",
                ]
            ),
            SpeciesProfileSection(
                id: "cultivars",
                title: "Cultivars and Forms",
                paragraphs: [
                    "Ginkgo biloba is primarily used in bonsai as the botanical species.",
                    "Horticultural cultivars may differ in growth habit, foliage appearance and branching character.",
                    "Do not create unnecessary separate Species Library profiles for minor individual variation.",
                    "The primary Species Profile remains Ginkgo biloba.",
                    "Only create separate profiles where a distinct cultivar or form has a clear and established independent bonsai identity.",
                ]
            ),
            SpeciesProfileSection(
                id: "natural-growth",
                title: "Natural Growth and Vigour",
                paragraphs: [
                    "Ginkgo biloba generally develops more slowly than many vigorous deciduous bonsai species.",
                    "Growth should therefore be managed with patience.",
                    "During structural development: allow selected growth to extend where trunk thickness is required, taper is required or branches require development.",
                    "Do not prematurely restrict a tree that still requires major structural development.",
                    "During refinement: control excessive extension, coarse branch development, poorly positioned shoots and unnecessary congestion.",
                    "The objective is: Long-term structural development · Controlled refinement · Preservation of species character.",
                ]
            ),
            SpeciesProfileSection(
                id: "foliage",
                title: "Foliage",
                paragraphs: [
                    "Ginkgo biloba has distinctive fan-shaped leaves.",
                    "The foliage is one of the species' strongest visual characteristics.",
                    "Healthy foliage should be evenly distributed, supported by healthy roots, exposed to appropriate light and proportional to the tree's development stage.",
                    "Leaf size depends on genetics, vigour, fertilization, growing conditions, root restriction and development stage.",
                    "Do not rely on aggressive defoliation as routine management.",
                    "The objective is: Healthy foliage · Balanced proportions · Clear species identity.",
                ]
            ),
            SpeciesProfileSection(
                id: "flowering",
                title: "Flowering",
                paragraphs: [
                    "Flowering is not applicable — Ginkgo biloba is a gymnosperm.",
                    "Do not describe Ginkgo biloba as a flowering tree.",
                    "Do not treat flowering as a bonsai design objective for this species.",
                ]
            ),
            SpeciesProfileSection(
                id: "fruit",
                title: "Seeds",
                paragraphs: [
                    "Fruit-bearing is not applicable — Ginkgo biloba produces seeds, not botanical fruit.",
                    "Do not describe its seed structures as botanical fruit.",
                    "Seed production is not a primary bonsai design objective.",
                ]
            ),
            SpeciesProfileSection(
                id: "bark-trunk",
                title: "Bark and Trunk",
                paragraphs: [
                    "Mature Ginkgo biloba can develop strong and distinctive bark character. Mature bark character is excellent.",
                    "Trunk development should focus on sufficient thickness, believable taper, natural movement, appropriate proportions and long-term maturity.",
                    "Young Ginkgo may require significant time before convincing mature trunk character develops.",
                    "Do not artificially damage bark to simulate age.",
                    "The objective is: Natural maturity · Strong trunk presence · Long-term character.",
                ]
            ),
            SpeciesProfileSection(
                id: "roots-nebari",
                title: "Roots and Nebari",
                paragraphs: [
                    "Healthy roots support growth, recovery, foliage health, structural development and long-term container cultivation.",
                    "Root development is moderate. Objectives include balanced roots, gradual radial development, stable anchoring and progressive nebari improvement.",
                    "Nebari has good potential with long-term development.",
                    "Root work should be staged.",
                    "Avoid unnecessary aggressive root reduction.",
                    "The objective is: Healthy roots · Stable growth · Gradually improving nebari.",
                ]
            ),
            SpeciesProfileSection(
                id: "light",
                title: "Light",
                paragraphs: [
                    "Ginkgo biloba should be cultivated outdoors with good access to light.",
                    "Adequate light supports healthy foliage, strong growth, branch development, autumn colour and seasonal rhythm.",
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
                    "Strong wind can increase water demand, damage foliage, stress shallow-rooted bonsai and increase winter exposure.",
                    "Monitor trees during prolonged dry wind, exposed growing conditions and severe winter weather.",
                ]
            ),
            SpeciesProfileSection(
                id: "watering",
                title: "Watering",
                paragraphs: [
                    "General principle: Maintain reliable moisture · Avoid repeated severe drying · Avoid permanently stagnant conditions · Maintain healthy root aeration.",
                    "Water demand is moderate.",
                    "Water demand depends on temperature, sunlight, wind, foliage mass, container size, substrate and root mass.",
                    "Do not water according to a fixed timetable.",
                    "The objective is: Consistent healthy moisture · Healthy roots · Stable growth.",
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
                    "Fertilization should support healthy foliage, trunk development, branch development, recovery and long-term vigour.",
                    "During development: support healthy growth where structural development is required.",
                    "During refinement: avoid excessive feeding that produces unnecessarily coarse growth, excessive shoot extension or disproportionate foliage.",
                    "Key principle: Feed according to tree health and development objective.",
                ]
            ),
            SpeciesProfileSection(
                id: "pruning",
                title: "Pruning",
                paragraphs: [
                    "Pruning can be used for structural development, branch selection, branch replacement, shoot management and refinement. Pruning response is good with species-specific considerations.",
                    "Ginkgo should not be treated exactly like highly vigorous broadleaf species.",
                    "Structural decisions should consider the species' slower development, branch age, available buds, replacement options and long-term design.",
                    "Avoid unnecessary repeated heavy pruning.",
                    "The objective is: Deliberate structural development · Preservation of useful growth · Long-term refinement.",
                ]
            ),
            SpeciesProfileSection(
                id: "back-budding",
                title: "Back-budding",
                paragraphs: [
                    "Ginkgo biloba can produce useful new growth, but response depends on tree health, vigour, branch age, available buds, pruning strategy and light. Back-budding is moderate.",
                    "Do not assume that every old or bare branch will reliably produce new growth.",
                    "When making structural pruning decisions: preserve useful interior growth, retain suitable replacement shoots where possible and avoid unnecessary removal of viable structure.",
                    "The objective is: Gradual renewal · Controlled branch development · Preservation of useful options.",
                ]
            ),
            SpeciesProfileSection(
                id: "ramification",
                title: "Ramification",
                paragraphs: [
                    "Ramification should be developed gradually. Ramification potential is moderate.",
                    "Use healthy growth cycles, shoot selection, controlled pruning, branch selection and preservation of useful interior structure.",
                    "Avoid forcing dense generic foliage pads, uniform hedge-like trimming and excessive removal of useful shoots.",
                    "The objective is: Clear branch hierarchy · Natural structure · Species-appropriate ramification.",
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
                    "Pruning and directional growth should be considered alongside wiring as important structural tools.",
                ]
            ),
            SpeciesProfileSection(
                id: "deadwood-potential",
                title: "Deadwood",
                paragraphs: [
                    "Deadwood is not normally a defining feature of refined Ginkgo bonsai. Deadwood potential is low.",
                    "Avoid dramatic artificial deadwood unless strongly justified by the individual material.",
                    "The objective is natural maturity rather than manufactured damage.",
                ]
            ),
            SpeciesProfileSection(
                id: "defoliation",
                title: "Foliage Management",
                paragraphs: [
                    "Complete defoliation is not routine management.",
                    "Foliage management should primarily focus on shoot selection, pruning, vigour management, balanced fertilization and appropriate light.",
                    "Do not present complete defoliation as routine management.",
                    "Do not apply aggressive foliage work to weak trees, stressed trees, recently repotted trees or trees recovering from major work.",
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
                    "Ginkgo biloba generally requires patience for convincing trunk development.",
                    "Where additional thickness is required: allow selected leaders to extend, provide sufficient root space, use development containers where appropriate and avoid premature refinement.",
                    "Leader development should support taper, trunk thickness, natural movement and believable proportions.",
                    "Once sufficient trunk development has been achieved, shift focus toward branch hierarchy, ramification, mature bark and refined proportions.",
                    "Key principle: Long-term development is an important part of successful Ginkgo bonsai.",
                ]
            ),
            SpeciesProfileSection(
                id: "nebari-development",
                title: "Nebari Development",
                paragraphs: [
                    "Nebari should be developed gradually.",
                    "Potential approaches include early root selection, radial root planning, staged correction, suitable development containers and gradual refinement.",
                    "The objective is a stable and visually convincing base appropriate to the individual tree.",
                ]
            ),
            SpeciesProfileSection(
                id: "propagation",
                title: "Propagation",
                paragraphs: [
                    "Ginkgo biloba may be propagated using established horticultural methods including seed, selected vegetative propagation methods and grafting where appropriate for cultivated material.",
                    "Seed-grown material may offer genetic variation, early root planning and early trunk development opportunities.",
                    "Detailed procedures belong in Bonsai World Propagation Knowledge Articles.",
                ]
            ),
            SpeciesProfileSection(
                id: "pests",
                title: "Pests and Problems",
                paragraphs: [
                    "Relevant risks may include leaf-feeding insects, fungal leaf problems, root problems caused by poor substrate aeration, drought stress, stress caused by poor watering management and root stress during prolonged severe freezing.",
                    "Do not provide generic treatment instructions.",
                    "Diagnosis and treatment belong in Care → Pest Management and Care → Disease & Problems.",
                ]
            ),
            SpeciesProfileSection(
                id: "seasonal",
                title: "Seasonal Profile",
                paragraphs: [
                    "Spring: monitor bud development, new growth, watering demand, vigour and structural priorities. Spring is important for evaluating branch development, structural direction, root health and recovery from winter. Coordinate major work with local climate and individual tree condition.",
                    "Summer: monitor watering demand, foliage health, shoot extension, pest activity and wire marks. Manage growth according to whether shoots are required for trunk development, branch development or refinement. Do not suppress useful structural growth unnecessarily.",
                    "Autumn is one of the most visually important seasons for Ginkgo. The foliage develops its characteristic autumn colour before leaf fall. Monitor seasonal health, foliage condition, branch structure, overall growth and preparation for dormancy. Do not apply one universal autumn schedule.",
                    "Winter: Ginkgo biloba requires winter dormancy.",
                    "Winter management depends on local minimum temperatures, duration of freezing, wind exposure, container depth, root protection and tree health.",
                    "Shallow bonsai roots are more exposed to severe cold than roots growing in open ground.",
                    "Protect the root system when required. Do not maintain indoors as a substitute for winter dormancy.",
                ]
            ),
            SpeciesProfileSection(
                id: "styles",
                title: "Bonsai Styles",
                paragraphs: [
                    "Ginkgo biloba is particularly suitable for Informal Upright, Formal Upright, Slanting, Multi-trunk, Naturalistic Bonsai and Forest Style.",
                    "It is especially effective when styling emphasises vertical structure, clear trunk lines, architectural simplicity, natural branch placement and distinctive foliage.",
                    "The individual material should determine the final design.",
                ]
            ),
            SpeciesProfileSection(
                id: "tree-stage",
                title: "Development by Tree Stage",
                paragraphs: [
                    "Young material: establish healthy roots, develop trunk thickness, establish movement where appropriate and begin structural development.",
                    "Nursery material: evaluate trunk potential, identify useful branches, establish design direction and begin structural correction.",
                    "Pre-bonsai: develop trunk, establish primary branches, improve root structure, build taper and maintain vigour.",
                    "In training: develop secondary branches, improve branch hierarchy, build species-appropriate ramification and preserve useful interior growth.",
                    "Refinement: maintain balanced vigour, improve branch structure, control excessive extension, preserve distinctive species character and maintain visible structure.",
                    "Exhibition / mature refined tree: maintain health, preserve established structure, maintain balanced ramification, preserve mature trunk character and avoid unnecessary major intervention.",
                ]
            ),
            SpeciesProfileSection(
                id: "attention",
                title: "Species-Specific Attention",
                paragraphs: [
                    "These attention points are operational tendencies. They must still be interpreted for the individual tree.",
                ],
                bullets: [
                    "Ginkgo biloba is a gymnosperm, not a flowering tree",
                    "It produces seeds rather than botanical fruit",
                    "It is placed in Non-flowering Deciduous Trees for Bonsai World category purposes",
                    "Do not classify it as a conifer",
                    "Unique fan-shaped foliage is a defining visual characteristic",
                    "Requires winter dormancy",
                    "Outdoor cultivation is required",
                    "Development is generally slower than many vigorous deciduous species",
                    "Structural work should be deliberate and long-term",
                    "Back-budding should be qualified by tree health, vigour and branch condition",
                    "Do not assume old bare branches will reliably regenerate",
                    "Avoid premature refinement",
                    "Do not use complete defoliation as routine management",
                    "Young branches are generally easier to position than older branches",
                    "Avoid forcing rigid branches",
                    "Mature bark character develops naturally with age",
                    "Do not artificially damage bark",
                    "Shallow bonsai roots require protection during prolonged severe freezing",
                    "Respect the species' distinctive architectural growth character",
                ]
            ),
        ]
    }
}
