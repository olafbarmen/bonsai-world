//
//  ForsythiaIntermediaSpeciesProfile.swift
//  Bonsai World
//
//  Species Profile — Forsythia × intermedia (Forsythia).
//  Horticultural hybrid in Oleaceae (Forsythia suspensa × Forsythia viridissima).
//  Knowledge status: Reviewed.
//

import Foundation

enum ForsythiaIntermediaSpeciesProfile {
    /// Identity used by Botanical Library / ``SpeciesPreviewData``.
    static let botanicalLibraryName = "Forsythia × intermedia"
    /// Scientific name for Species Profile display (hybrid formula; no botanical authority).
    static let scientificName = "Forsythia × intermedia"

    static var profile: SpeciesProfile {
        SpeciesProfile(
            speciesID: BotanicalKnowledgeIDs.forsythiaIntermedia,
            scientificName: scientificName,
            commonNames: ["Forsythia", "Border Forsythia", "Hybrid Forsythia"],
            synonyms: [
                "Forsythia x intermedia",
            ],
            family: "Oleaceae",
            plantType: "Deciduous flowering shrub · Hybrid",
            originSummary: "Horticultural hybrid of East Asian parent species.",
            knowledgeStatus: .reviewed,
            traits: traits,
            foliageSizeLabel: "Foliage",
            foliageReductionLabel: "Leaf reduction",
            summaryLine: "Deciduous · Early spring flowering · Bright yellow flowers · Vigorous growth · Flexible young shoots · Strong response to pruning · Fast development · Good flowering bonsai potential",
            attentionHighlights: [
                "Forsythia × intermedia is a hybrid taxon",
                "Do not describe it as a naturally occurring independent species",
                "Cultivar identity can influence vigour and flowering",
                "Flowers generally appear before the foliage",
                "Flowering potential depends strongly on pruning history",
                "Indiscriminate pruning can reduce future flowering",
                "Strong growth can be used effectively for development",
                "Do not suppress all growth while trunk development is required",
                "Good back-budding depends on tree health and branch condition",
                "Preserve useful interior growth",
                "Avoid repeated severe drought",
                "Avoid permanently saturated substrate",
                "Full defoliation is not routine management",
                "Young shoots are more suitable for wiring than older branches",
                "Monitor wire during periods of strong growth",
                "Winter dormancy is required",
                "Flower buds may be vulnerable to damaging frost",
                "Shallow bonsai roots are more exposed than roots in open ground",
                "Do not move indoors for routine winter care",
            ],
            sections: sections,
            principleNote: """
            Forsythia × intermedia is naturally a vigorous flowering shrub.

            Do not attempt to maintain constant refinement while the tree still requires trunk development, branch development, taper or structural correction.

            Strong growth should be used deliberately.

            The best bonsai results come from balancing structural growth, pruning, flowering potential and ramification.

            The objective is: Healthy tree · Mature structure · Natural branch development · Seasonal flowering.

            The individual tree must always be assessed according to health, vigour, flowering condition, cultivar characteristics, root condition, development stage, local climate and recent work.
            """,
            sourcesNote: """
            Profile content is synthesised from recognised botanical, horticultural and bonsai authorities into Bonsai World editorial language.

            Taxonomic identity and hybrid parentage draw on recognised sources such as Royal Botanic Gardens, Kew and other botanical databases for accepted scientific name, family and hybrid origin.

            Horticultural context may draw on recognised botanical gardens, arboreta, horticultural institutions and established horticultural references for Forsythia.

            Bonsai-specific cultivation and refinement knowledge draws on established flowering-bonsai practice, kept distinct from Forsythia suspensa, Forsythia viridissima and named cultivars.

            Verified taxonomic information, hybrid origin, general horticultural cultivation, cultivar variation and bonsai-specific practice are kept distinct. Do not copy source wording.
            """
        )
    }

    private static let traits = SpeciesProfileTraits(
        deciduous: true,
        growthStrength: "Strong",
        growthSpeed: "Fast",
        leafSize: "Deciduous",
        foliageReduction: "Not routine management",
        ramificationPotential: "Good",
        backBudding: "Good under healthy conditions",
        rootDevelopment: "Strong",
        nebariPotential: "Good potential",
        trunkDevelopment: "Moderate to Strong",
        barkDevelopment: "Moderate mature character",
        wiring: "Good on young shoots",
        defoliation: "Not routine management",
        airLayering: "Where appropriate for the individual material",
        threadGrafting: "Where structural correction is required",
        rootGrafting: "Where appropriate",
        beginnerSuitability: "Good",
        bonsaiSuitability: "Good to Excellent",
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
                    "Forsythia × intermedia is a horticulturally important hybrid taxon in the olive family (Oleaceae). It is not a naturally occurring independent botanical species.",
                    "Primary Bonsai World display identity: Forsythia × intermedia · Forsythia.",
                    "Border Forsythia and Hybrid Forsythia may be used as supporting terminology. They do not replace Forsythia as the primary common name.",
                    "Family: Oleaceae. Plant type: deciduous flowering shrub · Hybrid.",
                    "Origin: horticultural hybrid of East Asian parent species.",
                    "It is the widely cultivated hybrid between Forsythia suspensa and Forsythia viridissima.",
                    "Maintain a clear distinction between Forsythia × intermedia, Forsythia suspensa, Forsythia viridissima and named Forsythia cultivars.",
                    "Do not imply that all Forsythia sold in nurseries is necessarily Forsythia × intermedia.",
                    "Cultivars may differ in vigour, flower production, growth habit and overall size.",
                    "Bonsai World hierarchy: Species / hybrid taxon → cultivar / horticultural selection → Individual Tree.",
                ]
            ),
            SpeciesProfileSection(
                id: "overview",
                title: "Species Overview",
                paragraphs: [
                    "Forsythia × intermedia is one of the best-known ornamental flowering shrubs in temperate horticulture.",
                    "It is especially recognised for its abundant yellow flowers, which typically appear before the leaves in spring.",
                    "For bonsai, it offers vigorous growth, rapid development, flexible young shoots, strong response to pruning, reliable flowering potential and the ability to create convincing deciduous shrub forms.",
                    "The hybrid is particularly suitable for growers who wish to develop flowering bonsai, multi-trunk compositions, clump forms and naturalistic shrub-style bonsai.",
                    "The flowers should enhance the bonsai. The tree must remain visually convincing after flowering has finished.",
                ],
                bullets: [
                    "Deciduous flowering shrub",
                    "Horticultural hybrid",
                    "Member of the Oleaceae family",
                    "Strong growth",
                    "Early spring flowering",
                    "Bright yellow flowers",
                    "Flowers generally appear before foliage",
                    "Good back-budding potential",
                    "Good response to pruning",
                    "Flexible young shoots",
                    "Rapid development potential",
                    "Requires outdoor cultivation",
                    "Requires winter dormancy",
                ]
            ),
            SpeciesProfileSection(
                id: "cultivars",
                title: "Cultivars",
                paragraphs: [
                    "Forsythia × intermedia is widely represented in horticulture by named cultivars.",
                    "Cultivars may differ in overall vigour, mature size, growth habit, branch habit, flower abundance, flower size and flowering timing.",
                    "Examples commonly encountered in horticulture include Lynwood, Spectabilis, Goldzauber and Spring Glory.",
                    "These examples are not the only important cultivars, and they are not equally suitable for bonsai.",
                    "Cultivar identity can influence bonsai development. Individual cultivar profiles are not created here.",
                    "The primary profile remains Forsythia × intermedia.",
                ]
            ),
            SpeciesProfileSection(
                id: "natural-growth",
                title: "Natural Growth and Vigour",
                paragraphs: [
                    "Forsythia × intermedia can produce strong seasonal growth.",
                    "Growth strength depends on root health, temperature, light, fertilization, watering, available root space and development stage.",
                    "During structural development: allow selected shoots and leaders to extend where trunk thickness is required, branch thickness is required or taper is being developed.",
                    "During refinement: control excessively long shoots, coarse extension, congested branching and loss of interior growth.",
                    "Do not continuously restrict all growth.",
                    "The objective is: Strong growth where development is required · Controlled growth where refinement is required.",
                ]
            ),
            SpeciesProfileSection(
                id: "foliage",
                title: "Foliage",
                paragraphs: [
                    "Forsythia × intermedia is deciduous.",
                    "Foliage should support branch visibility, balanced growth, natural seasonal development and healthy ramification.",
                    "The objective is healthy foliage, balanced vigour, a proportionate canopy and visible branch structure.",
                    "Avoid excessive fertilization where it produces unnecessarily coarse growth, excessive shoot extension or disproportionate foliage.",
                ]
            ),
            SpeciesProfileSection(
                id: "flowering",
                title: "Flowering",
                paragraphs: [
                    "Flowering is one of the defining characteristics of Forsythia bonsai. Flowering potential is excellent.",
                    "Flowers generally appear on wood formed during the previous growing season, typically before the leaves in early spring.",
                    "Pruning timing can therefore directly influence the following year's flowering display.",
                    "Do not apply a universal pruning calendar.",
                    "Management must reflect the relationship between shoot development, pruning, bud formation and flowering.",
                    "The objective is healthy growth, mature branch structure and sustainable flowering.",
                ]
            ),
            SpeciesProfileSection(
                id: "flower-management",
                title: "Flower Management",
                paragraphs: [
                    "Flowering should be managed according to tree health, development stage, flowering strength, branch structure and current objectives.",
                    "During major structural development, maximum flowering may not be the primary objective.",
                    "During refinement, the goal is to preserve sufficient flowering wood while maintaining branch structure, ramification, proportion and tree health.",
                    "Do not remove all useful flowering potential through indiscriminate pruning.",
                ]
            ),
            SpeciesProfileSection(
                id: "fruit",
                title: "Fruit",
                paragraphs: [
                    "Fruiting is not a primary bonsai feature of Forsythia × intermedia.",
                    "Seasonal interest is driven by early spring flowers, foliage and deciduous branch structure rather than fruit display.",
                ]
            ),
            SpeciesProfileSection(
                id: "bark-trunk",
                title: "Bark and Trunk",
                paragraphs: [
                    "Forsythia does not generally develop the deeply rugged bark character associated with some traditional bonsai species. Mature bark character is moderate.",
                    "Maturity should therefore be developed through trunk thickness, taper, movement, branch structure and natural proportions.",
                    "Older material can nevertheless develop convincing character.",
                    "Do not attempt to force artificial age through unnecessary damage.",
                    "The objective is a mature flowering shrub represented as a convincing bonsai.",
                ]
            ),
            SpeciesProfileSection(
                id: "roots-nebari",
                title: "Roots and Nebari",
                paragraphs: [
                    "Healthy roots support strong seasonal growth, flowering, recovery, ramification and long-term development.",
                    "Root development is strong. Objectives include healthy root density, balanced radial roots, stable support and gradual nebari development.",
                    "Nebari potential is good. Nebari development should be gradual.",
                    "Do not attempt to completely redesign an established root system in one operation.",
                ]
            ),
            SpeciesProfileSection(
                id: "light",
                title: "Light",
                paragraphs: [
                    "Forsythia × intermedia should be cultivated outdoors.",
                    "Adequate light supports healthy growth, flowering, compact development, bud formation and overall vigour.",
                    "The exact growing position depends on local climate, temperature, tree condition and development stage.",
                    "Do not recommend permanent indoor cultivation.",
                ]
            ),
            SpeciesProfileSection(
                id: "wind",
                title: "Wind",
                paragraphs: [
                    "Moderate air movement is beneficial.",
                    "Strong wind can increase water loss, damage flowers, damage tender new shoots and dry shallow bonsai containers rapidly.",
                    "Monitor trees during flowering, strong spring winds, hot weather and dry periods.",
                ]
            ),
            SpeciesProfileSection(
                id: "watering",
                title: "Watering",
                paragraphs: [
                    "General principle: Maintain adequate moisture · Avoid repeated severe drought · Maintain root aeration · Avoid permanent saturation.",
                    "Water demand is moderate.",
                    "Watering frequency depends on temperature, sunlight, wind, foliage mass, container size, substrate, root mass and development stage.",
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
                    "Desired characteristics include good drainage, strong aeration, stable particle structure, sufficient moisture retention and support for healthy root growth.",
                    "The final soil mix depends on local climate, rainfall, watering habits, container depth, tree size, development stage and root condition.",
                    "Follow Bonsai World Soil Module principles.",
                    "Do not duplicate the complete Soil Module inside this profile.",
                ]
            ),
            SpeciesProfileSection(
                id: "fertilizing",
                title: "Fertilizing",
                paragraphs: [
                    "Fertilization should support tree health, development stage, flowering objectives and sustainable ramification.",
                    "During structural development: healthy trees requiring stronger growth may receive increased nutritional support where appropriate.",
                    "During refinement: avoid excessive fertilization that produces overly coarse growth, excessive internode length or disproportionate extension.",
                    "Key principle: Feed according to tree condition and development objective.",
                ]
            ),
            SpeciesProfileSection(
                id: "pruning",
                title: "Pruning",
                paragraphs: [
                    "Forsythia × intermedia responds strongly to pruning.",
                    "Pruning can be used for structural development, branch selection, branch replacement, ramification and silhouette refinement.",
                    "Pruning must consider the flowering cycle. Because flowering is related to growth formed during the previous season, poorly timed pruning can significantly reduce the following spring's flowers.",
                    "Do not present one universal pruning date.",
                    "During structural development: allow selected branches and leaders to extend where thickness is required.",
                    "During refinement: use controlled pruning and shoot selection to balance ramification, branch structure and flowering potential.",
                    "The objective is: Natural structure · Controlled vigour · Sustainable flowering.",
                ]
            ),
            SpeciesProfileSection(
                id: "back-budding",
                title: "Back-budding",
                paragraphs: [
                    "Forsythia × intermedia generally responds well to pruning and can produce useful new growth. Back-budding is good under healthy conditions.",
                    "Back-budding response depends on tree health, vigour, light, branch age, pruning strategy and root condition.",
                    "Do not treat back-budding as guaranteed on all old wood.",
                    "Preserve useful interior growth whenever possible.",
                ]
            ),
            SpeciesProfileSection(
                id: "ramification",
                title: "Ramification",
                paragraphs: [
                    "Ramification potential is good.",
                    "Ramification develops through repeated healthy growth cycles, pruning, shoot selection, branch selection and balanced vigour.",
                    "Because Forsythia can produce vigorous extension growth, refinement requires regular observation.",
                    "Avoid allowing long internodes, excessive outer growth or branch congestion.",
                    "The objective is natural branch hierarchy, visible structure and sustainable ramification.",
                ]
            ),
            SpeciesProfileSection(
                id: "wiring",
                title: "Wiring",
                paragraphs: [
                    "Young Forsythia shoots can generally be wired. Wiring is good on young shoots.",
                    "Wiring can be used to establish movement, position young branches, improve branch placement and develop secondary structure.",
                    "Young branches are relatively flexible. Older branches may become less flexible.",
                    "Before major bends, assess branch thickness, flexibility, age, health and structural importance.",
                    "Monitor wire carefully during periods of strong growth.",
                ]
            ),
            SpeciesProfileSection(
                id: "deadwood-potential",
                title: "Deadwood Potential",
                paragraphs: [
                    "Deadwood potential is limited. Deadwood is not a defining feature of Forsythia bonsai.",
                    "Natural scars or aged features may occasionally contribute to character.",
                    "Do not create dramatic artificial deadwood as a routine styling technique.",
                    "Any aged feature should appear natural, support the design and not compromise the tree.",
                ]
            ),
            SpeciesProfileSection(
                id: "defoliation",
                title: "Defoliation and Leaf Management",
                paragraphs: [
                    "Do not present complete defoliation as standard management. Full defoliation is not routine management for Forsythia × intermedia.",
                    "Leaf management should primarily focus on pruning, shoot selection, vigour management, appropriate fertilization and adequate light.",
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
                    "Forsythia × intermedia can develop trunk thickness relatively efficiently when strong growth is allowed.",
                    "Where additional thickness is required: allow selected leaders to extend, use sacrifice growth where appropriate, provide sufficient root space and avoid premature refinement.",
                    "Once sufficient structural development has been achieved, shift focus toward taper, branch hierarchy, ramification, flowering and mature proportions.",
                    "Grow where development is required. Control where refinement is required.",
                ]
            ),
            SpeciesProfileSection(
                id: "nebari-development",
                title: "Nebari Development",
                paragraphs: [
                    "Nebari should be developed gradually.",
                    "Potential approaches include early root selection, radial root planning, staged root correction, appropriate development containers and gradual improvement of surface roots.",
                    "The objective is a stable and visually convincing base appropriate to a mature flowering shrub bonsai.",
                ]
            ),
            SpeciesProfileSection(
                id: "propagation",
                title: "Propagation",
                paragraphs: [
                    "Forsythia × intermedia is a hybrid. Vegetative propagation is commonly used to preserve the characteristics of individual cultivars.",
                    "Established propagation methods may include cuttings, layering, and division or other horticulturally appropriate methods.",
                    "Seed propagation does not necessarily preserve the characteristics of a hybrid or named cultivar.",
                    "Detailed procedures belong in Bonsai World Propagation Knowledge Articles.",
                ]
            ),
            SpeciesProfileSection(
                id: "pests",
                title: "Pests and Problems",
                paragraphs: [
                    "Relevant risks may include aphids, scale insects, spider mites, leaf-feeding insects, fungal leaf problems, root problems caused by poor drainage, drought stress and frost damage to developing flowers or buds.",
                    "Do not provide generic treatment instructions.",
                    "Diagnosis and treatment belong in Care → Pest Management and Care → Disease & Problems.",
                ]
            ),
            SpeciesProfileSection(
                id: "seasonal",
                title: "Seasonal Profile",
                paragraphs: [
                    "Spring: monitor bud development, flowering, watering demand, pest activity and overall vigour. Spring flowering is a defining seasonal feature. Avoid unnecessary heavy work while the tree is under significant flowering demand. Observe branch structure while the tree is still relatively open.",
                    "Summer: monitor strong extension growth, watering demand, foliage health, pest activity and wire marks. Summer growth should be managed according to whether branches are being used for development, sacrifice growth or refinement. Do not suppress all vigorous growth if structural development is still required.",
                    "Autumn is important for evaluating seasonal growth, reviewing branch structure, assessing overall vigour, preparing for winter and preserving appropriate growth for future flowering. Avoid unnecessary late-season pruning that removes useful flowering potential. Seasonal timing depends on local climate.",
                    "Winter: Forsythia × intermedia is a deciduous outdoor plant. Natural winter dormancy is required.",
                    "Winter protection requirements depend on local minimum temperatures, duration of freezing, wind exposure, container depth, root protection and tree health.",
                    "Flower buds can be vulnerable to severe or damaging late-winter and spring frost depending on local conditions.",
                    "Shallow bonsai roots are more exposed than roots in open ground.",
                    "Protect when required while maintaining natural dormancy. Do not maintain permanently indoors.",
                ]
            ),
            SpeciesProfileSection(
                id: "styles",
                title: "Bonsai Styles",
                paragraphs: [
                    "Forsythia × intermedia is particularly suitable for Informal Upright, Slanting, Multi-trunk Style, Clump Style, Naturalistic Flowering Bonsai and Forest / Group Planting.",
                    "Forsythia is especially effective when styling emphasises natural shrub character, visible branch structure, natural asymmetry, seasonal flowering and mature proportions.",
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
                    "In training: develop secondary branches, improve branch hierarchy, develop ramification and establish sustainable flowering potential.",
                    "Refinement: maintain balanced vigour, improve tertiary ramification, control shoot extension, preserve flowering potential and maintain visible branch structure.",
                    "Exhibition / mature refined tree: maintain health, preserve established structure, manage flowering, maintain balanced ramification and avoid unnecessary major intervention.",
                ]
            ),
            SpeciesProfileSection(
                id: "attention",
                title: "Species-Specific Attention",
                paragraphs: [
                    "These attention points are operational tendencies. They must still be interpreted for the individual tree.",
                ],
                bullets: [
                    "Forsythia × intermedia is a hybrid taxon",
                    "Do not describe it as a naturally occurring independent species",
                    "Cultivar identity can influence vigour and flowering",
                    "Flowers generally appear before the foliage",
                    "Flowering potential depends strongly on pruning history",
                    "Indiscriminate pruning can reduce future flowering",
                    "Strong growth can be used effectively for development",
                    "Do not suppress all growth while trunk development is required",
                    "Good back-budding depends on tree health and branch condition",
                    "Preserve useful interior growth",
                    "Avoid repeated severe drought",
                    "Avoid permanently saturated substrate",
                    "Full defoliation is not routine management",
                    "Young shoots are more suitable for wiring than older branches",
                    "Monitor wire during periods of strong growth",
                    "Winter dormancy is required",
                    "Flower buds may be vulnerable to damaging frost",
                    "Shallow bonsai roots are more exposed than roots in open ground",
                    "Do not move indoors for routine winter care",
                ]
            ),
        ]
    }
}
