//
//  AbiesBorisiiRegisSpeciesProfile.swift
//  Bonsai World
//
//  Species Profile — Abies × borisii-regis (King Boris Fir).
//  Naturally occurring hybrid taxon in Pinaceae. Knowledge status: Reviewed.
//  Associated primarily with Abies alba and Abies cephalonica.
//  The multiplication sign × is part of the botanical name and must be preserved.
//

import Foundation

enum AbiesBorisiiRegisSpeciesProfile {
    /// Identity used by Botanical Library / ``SpeciesPreviewData``.
    static let botanicalLibraryName = "Abies × borisii-regis"
    /// Scientific name for Species Profile display (binomial with hybrid sign; no botanical authority).
    static let scientificName = "Abies × borisii-regis"

    static var profile: SpeciesProfile {
        SpeciesProfile(
            speciesID: BotanicalKnowledgeIDs.abiesBorisiiRegis,
            scientificName: scientificName,
            commonNames: ["King Boris Fir", "Boris Fir", "Bulgarian Fir"],
            synonyms: [
                "Abies borisii-regis",
                "Abies x borisii-regis",
            ],
            family: "Pinaceae",
            plantType: "Evergreen conifer · Natural hybrid taxon",
            originSummary: "The southern Balkan Peninsula, particularly mountainous regions associated with Greece, Bulgaria and neighbouring areas.",
            knowledgeStatus: .reviewed,
            traits: traits,
            foliageSizeLabel: "Foliage",
            foliageReductionLabel: "Needle reduction",
            summaryLine: "Evergreen · Conifer · Balkan mountain tree · Natural hybrid taxon · Flat needles · Strong upright structure · Slow bonsai development · Natural forest character · Outdoor cultivation required",
            attentionHighlights: [
                "Abies × borisii-regis is a naturally occurring hybrid taxon associated with the southern Balkan region",
                "The multiplication sign × must be preserved in the scientific name",
                "Do not describe it as an artificial horticultural hybrid",
                "Individual trees may show variation associated with their hybrid origin",
                "Outdoor cultivation is required",
                "Winter dormancy is required",
                "Healthy foliage and viable buds should be preserved before major reduction",
                "Do not strip branches bare",
                "Do not assume old bare wood will reliably regenerate",
                "Development requires patience",
                "Root work should be conservative",
                "Avoid combining major root work and major styling unnecessarily",
                "Do not use defoliation techniques",
                "Mature branches can become rigid and difficult to bend",
                "Avoid prolonged drought",
                "Monitor carefully during unusually hot and dry conditions",
                "Shallow roots require protection during prolonged severe freezing",
                "Winter desiccation can be a risk in exposed conditions",
            ],
            sections: sections,
            principleNote: """
            The primary operational rule is: Preserve healthy foliage and viable buds before major reduction.

            Do not assume that completely bare old wood will reliably regenerate useful replacement growth.

            Before removing branches or major sections: identify viable buds, identify retained foliage, identify replacement options and assess tree health and vigour.

            Major work should be staged where necessary.

            Avoid combining multiple major stresses without a clear reason.

            Because individual trees may show variation associated with this taxon's hybrid origin, observe the individual material rather than relying on an overly rigid universal rule.

            The objective is: Healthy roots · Preserved foliage · Stable vigour · Natural structure · Long-term development.

            The individual tree must always be assessed according to climate, tree condition, vigour, development stage and winter temperatures.
            """,
            sourcesNote: """
            Profile content is synthesised from recognised botanical, horticultural and bonsai authorities into Bonsai World editorial language.

            Botanical taxonomy and distribution draw on recognised sources such as Royal Botanic Gardens, Kew, Plants of the World Online, recognised Balkan botanical institutions and recognised forestry institutions for accepted scientific name, hybrid status and native range.

            Taxonomic information is kept distinct from horticultural and bonsai practice. Origin and classification have been discussed in botanical literature; Bonsai World presents the taxon carefully without oversimplifying disputed points as absolute fact.

            Horticultural context may draw on recognised horticultural institutions and authoritative Abies references.

            Bonsai-specific cultivation and refinement knowledge draws on established bonsai references and recognised professional practice with conifer experience, kept distinct from Abies alba, Abies cephalonica and artificial horticultural hybrids.

            Verified botanical information, taxonomic information, horticultural information, regional climate adaptation and bonsai-specific practice are kept distinct. Do not copy source wording.
            """
        )
    }

    private static let traits = SpeciesProfileTraits(
        deciduous: false,
        growthStrength: "Slow to Moderate",
        growthSpeed: "Slow to Moderate",
        leafSize: "Evergreen · Flat needles",
        foliageReduction: "Not applicable",
        ramificationPotential: "Moderate",
        backBudding: "Limited to Moderate — strongest where healthy foliage and viable buds are retained",
        rootDevelopment: "Moderate",
        nebariPotential: "Moderate potential",
        trunkDevelopment: "Slow to Moderate",
        barkDevelopment: "Good mature character",
        wiring: "Moderate",
        defoliation: "Not applicable",
        airLayering: "Where appropriate for the individual material",
        threadGrafting: "Where structural correction is required",
        rootGrafting: "Where appropriate",
        beginnerSuitability: "Low",
        bonsaiSuitability: "Good",
        difficulty: "Advanced",
        winterDormancyRequired: true,
        winterHardiness: "Required",
        rootFrostSensitivity: "Moderate in shallow containers during prolonged severe freezing"
    )

    private static var sections: [SpeciesProfileSection] {
        [
            SpeciesProfileSection(
                id: "taxonomic-context",
                title: "Taxonomic Context",
                paragraphs: [
                    "Abies × borisii-regis is an evergreen fir taxon in the pine family (Pinaceae).",
                    "Primary Bonsai World display identity: Abies × borisii-regis · King Boris Fir.",
                    "Boris Fir and Bulgarian Fir may be listed as alternative common names where useful. They do not replace King Boris Fir as the preferred English common name.",
                    "The multiplication sign × is part of the botanical name and must be preserved. Do not replace × with x, X, a hyphen or a space.",
                    "Family: Pinaceae. Plant type: evergreen conifer · natural hybrid taxon.",
                    "It is commonly treated as a naturally occurring hybrid complex associated primarily with Abies alba and Abies cephalonica.",
                    "Do not describe it as an artificial horticultural hybrid.",
                    "Do not oversimplify its taxonomy. Botanical classification and origin have been discussed in botanical literature; present classification carefully and avoid presenting disputed points as absolute fact.",
                    "Native range: The southern Balkan Peninsula, particularly mountainous regions associated with Greece, Bulgaria and neighbouring areas.",
                    "Do not confuse Abies × borisii-regis with Picea species. Do not confuse true firs in the genus Abies with spruce in the genus Picea.",
                    "Bonsai World hierarchy: Species / Natural Hybrid Taxon → cultivar / horticultural selection → Individual Tree.",
                ]
            ),
            SpeciesProfileSection(
                id: "overview",
                title: "Species Overview",
                paragraphs: [
                    "Abies × borisii-regis is an evergreen fir associated with the mountainous forests of the southern Balkan Peninsula.",
                    "It is commonly regarded as a naturally occurring hybrid taxon with characteristics associated with Abies alba and Abies cephalonica.",
                    "Its appearance and growth characteristics may show variation because of its complex natural origin.",
                    "For Bonsai World, it should be presented primarily as a specialist evergreen fir suitable for patient long-term development.",
                    "Its strongest bonsai potential lies in naturalistic upright forms, mountain-inspired bonsai, mature forest-tree character, strong vertical compositions and forest plantings where suitable material is available.",
                    "Development should prioritise: Healthy roots · Preserved foliage · Stable vigour · Natural structure · Long-term development.",
                ],
                bullets: [
                    "Evergreen conifer",
                    "Balkan mountain origin",
                    "Natural hybrid taxon",
                    "Taxonomic relationship with Abies alba and Abies cephalonica",
                    "Flat evergreen needles",
                    "Strong upright growth character",
                    "Slow to moderate development",
                    "Moderate ramification potential",
                    "Limited to moderate back-budding",
                    "Mature forest-tree character",
                    "Outdoor cultivation required",
                    "Winter dormancy required",
                    "Specialist conifer requiring patient development",
                ]
            ),
            SpeciesProfileSection(
                id: "cultivars",
                title: "Cultivars and Forms",
                paragraphs: [
                    "Abies × borisii-regis is primarily used in bonsai as the botanical hybrid taxon.",
                    "Individual trees may vary because of the taxon's complex natural origin.",
                    "Do not create unnecessary separate Species Library profiles for minor individual variation.",
                    "The primary Species Profile remains Abies × borisii-regis.",
                    "Only create separate profiles where a distinct cultivar or form has a clear and established independent bonsai identity.",
                ]
            ),
            SpeciesProfileSection(
                id: "natural-growth",
                title: "Natural Growth and Vigour",
                paragraphs: [
                    "Abies × borisii-regis should be developed according to the health and vigour of the individual tree.",
                    "Healthy growth depends on healthy roots, sufficient outdoor light, stable moisture, well-aerated substrate, balanced nutrition, avoidance of prolonged drought and avoidance of repeated unnecessary stress.",
                    "During development: allow useful growth to extend where required for trunk development, branch thickening, recovery or future branch structure.",
                    "Avoid prematurely restricting all useful growth.",
                    "The objective is: Stable vigour · Useful extension · Progressive development.",
                ]
            ),
            SpeciesProfileSection(
                id: "foliage",
                title: "Foliage",
                paragraphs: [
                    "Abies × borisii-regis has flat evergreen needles.",
                    "Healthy evergreen foliage is essential for energy production, recovery, branch development and future refinement.",
                    "Do not strip branches bare, remove all useful foliage from sections intended to remain alive, or assume old bare wood will reliably regenerate useful replacement growth.",
                    "Foliage management should focus on shoot selection, selective reduction, preservation of useful interior growth and maintaining balanced vigour.",
                    "Avoid creating dense outer foliage while allowing interior structure to weaken.",
                    "The objective is: Healthy foliage · Useful interior growth · Sustainable refinement.",
                ]
            ),
            SpeciesProfileSection(
                id: "flowering",
                title: "Flowering",
                paragraphs: [
                    "Flowering is not applicable as a primary bonsai feature.",
                    "Do not treat flowering as a styling priority.",
                ]
            ),
            SpeciesProfileSection(
                id: "fruit",
                title: "Cones",
                paragraphs: [
                    "Abies × borisii-regis produces upright cones.",
                    "Upright cones are a botanical character of true firs and help distinguish Abies from Picea, which typically produce hanging cones.",
                    "Cones may contribute to seasonal character but are not a primary bonsai design objective.",
                    "Do not sacrifice structural development or foliage health in pursuit of cones.",
                ]
            ),
            SpeciesProfileSection(
                id: "bark-trunk",
                title: "Bark and Trunk",
                paragraphs: [
                    "Mature material can develop strong natural trunk character. Mature bark character is good.",
                    "Trunk development should focus on believable taper, natural proportions, structural strength and mature mountain-tree character.",
                    "Where additional development is required: retain useful leaders, allow selected growth to extend, provide sufficient root space and avoid premature confinement.",
                    "The objective is: Natural maturity · Strong proportions · Long-term development.",
                ]
            ),
            SpeciesProfileSection(
                id: "roots-nebari",
                title: "Roots and Nebari",
                paragraphs: [
                    "Healthy roots are essential for stable development.",
                    "Root development is moderate. Nebari has moderate potential.",
                    "Root work should be conservative.",
                    "Avoid excessive root reduction, unnecessary disturbance, repeated repotting and combining major root work with major styling work.",
                    "Nebari development should be gradual.",
                    "The objective is: Stable root system · Reliable recovery · Natural anchoring.",
                ]
            ),
            SpeciesProfileSection(
                id: "light",
                title: "Light",
                paragraphs: [
                    "Abies × borisii-regis should be cultivated outdoors.",
                    "Provide strong outdoor light while adapting placement to local climate, summer temperatures, humidity, tree health and development stage.",
                    "Do not recommend permanent indoor cultivation.",
                ]
            ),
            SpeciesProfileSection(
                id: "wind",
                title: "Wind",
                paragraphs: [
                    "Moderate air movement is beneficial.",
                    "Strong drying winds can increase foliage moisture loss, water demand and winter desiccation.",
                    "Monitor exposed trees carefully.",
                ]
            ),
            SpeciesProfileSection(
                id: "watering",
                title: "Watering",
                paragraphs: [
                    "General principle: Maintain stable root moisture · Avoid prolonged drought · Avoid permanently saturated roots · Maintain healthy root aeration.",
                    "Water demand is moderate.",
                    "Do not present the species as drought tolerant simply because it originates from southern Europe.",
                    "Water demand depends on temperature, sunlight, wind, foliage mass, container size, substrate and root mass.",
                    "Do not water according to a fixed timetable.",
                    "The objective is: Stable moisture · Healthy roots · Consistent vigour.",
                ]
            ),
            SpeciesProfileSection(
                id: "soil",
                title: "Soil",
                paragraphs: [
                    "Do not prescribe one universal soil recipe.",
                    "Desired characteristics include good drainage, strong aeration, sufficient moisture retention, stable particle structure and healthy root development.",
                    "The final substrate depends on local climate, rainfall, watering habits, container depth, tree size and development stage.",
                    "Follow Bonsai World Soil Module principles.",
                    "Do not duplicate the complete Soil Module inside this profile.",
                ]
            ),
            SpeciesProfileSection(
                id: "fertilizing",
                title: "Fertilizing",
                paragraphs: [
                    "Fertilization should support healthy foliage, root development, useful structural growth and recovery.",
                    "Avoid excessive fertilization that produces unnecessarily coarse growth, imbalance or excessive vigour that is difficult to manage.",
                    "Key principle: Feed according to tree health and development objective.",
                ]
            ),
            SpeciesProfileSection(
                id: "pruning",
                title: "Pruning",
                paragraphs: [
                    "Pruning should be planned around retained foliage, viable buds, branch age, future structure and tree vigour. Pruning response is moderate to advanced.",
                    "Before major reduction: identify future replacement growth, retain viable options and avoid unnecessary irreversible cuts.",
                    "The objective is: Controlled structure · Preserved growth options · Long-term development.",
                ]
            ),
            SpeciesProfileSection(
                id: "back-budding",
                title: "Back-budding",
                paragraphs: [
                    "Back-budding is limited to moderate and strongest where healthy foliage and viable buds are retained.",
                    "Back-budding should not be treated as guaranteed.",
                    "Response depends on individual tree vigour, retained foliage, viable buds, branch age, light availability and overall root health.",
                    "Before structural pruning: identify viable buds, preserve useful foliage and maintain replacement options.",
                    "The objective is: Preserve future development before making irreversible cuts.",
                ]
            ),
            SpeciesProfileSection(
                id: "ramification",
                title: "Ramification",
                paragraphs: [
                    "Ramification should be developed gradually. Ramification potential is moderate.",
                    "Useful methods include healthy growth cycles, selective shoot management, careful pruning and wiring where appropriate.",
                    "Avoid excessive repeated cutting, removing useful interior growth and forcing dense refinement before sufficient branch structure exists.",
                    "The objective is: Natural branch hierarchy · Balanced vigour · Sustainable ramification.",
                ]
            ),
            SpeciesProfileSection(
                id: "wiring",
                title: "Wiring",
                paragraphs: [
                    "Wiring can be used for branch positioning, structural development and directional refinement. Wiring response is moderate.",
                    "Before wiring assess branch flexibility, branch age, wood stiffness, bark sensitivity and tree health.",
                    "Avoid forcing mature rigid branches.",
                    "Monitor wire carefully.",
                    "The objective is: Natural branch placement · Safe development · Preserved bark.",
                ]
            ),
            SpeciesProfileSection(
                id: "deadwood-potential",
                title: "Deadwood",
                paragraphs: [
                    "Deadwood should generally be restrained and naturalistic. Deadwood potential is moderate.",
                    "Potential features include naturally occurring dead branches, weathered branch remnants and subtle jin where appropriate.",
                    "Avoid dramatic carving that does not match the natural character of a mature fir.",
                    "The objective is: Natural realism · Species-appropriate character · Preserved health.",
                ]
            ),
            SpeciesProfileSection(
                id: "defoliation",
                title: "Foliage Management",
                paragraphs: [
                    "Defoliation is not applicable.",
                    "Do not present defoliation as a technique.",
                    "Foliage management should focus on shoot selection, selective reduction, maintaining vigour balance and preserving useful interior growth.",
                    "Do not aggressively reduce foliage on weak trees, stressed trees, recently repotted trees or trees recovering from major work.",
                ]
            ),
            SpeciesProfileSection(
                id: "repotting",
                title: "Repotting",
                paragraphs: [
                    "Repotting frequency depends on root development, substrate condition, drainage, container size, tree health and development stage.",
                    "Do not establish a rigid calendar rule.",
                    "Root work should be conservative.",
                    "Avoid excessive root removal, removing too much functioning root mass and combining major root work with major styling work.",
                    "Timing must account for local climate, winter conditions, growth cycle and individual tree health.",
                ]
            ),
            SpeciesProfileSection(
                id: "trunk-development",
                title: "Trunk Development",
                paragraphs: [
                    "Trunk development requires patience.",
                    "Where additional development is required: retain selected leaders, allow useful extension, provide sufficient root space and avoid premature confinement.",
                    "Development should support taper, natural proportions, trunk strength and mature mountain-tree character.",
                    "Once sufficient trunk development exists, shift focus toward primary branch structure, secondary branching, ramification and refinement.",
                ]
            ),
            SpeciesProfileSection(
                id: "nebari-development",
                title: "Nebari Development",
                paragraphs: [
                    "Nebari development should be gradual.",
                    "Potential approaches include early root planning, staged correction, development containers where appropriate and progressive refinement.",
                    "The objective is: Stable anchoring · Natural base · Healthy roots.",
                ]
            ),
            SpeciesProfileSection(
                id: "propagation",
                title: "Propagation",
                paragraphs: [
                    "Abies × borisii-regis may be propagated through established horticultural methods where appropriate.",
                    "Detailed procedures belong in Bonsai World Propagation Knowledge Articles.",
                    "Do not provide an unnecessarily detailed propagation manual in this Species Profile.",
                ]
            ),
            SpeciesProfileSection(
                id: "pests",
                title: "Pests and Problems",
                paragraphs: [
                    "Relevant risks may include aphids and other sap-feeding insects, scale insects, mites, fungal foliage problems, root problems caused by poor aeration, drought stress, heat stress, winter desiccation and stress caused by excessive root or foliage removal.",
                    "Do not provide generic treatment instructions.",
                    "Diagnosis and treatment belong in Care → Pest Management and Care → Disease & Problems.",
                ]
            ),
            SpeciesProfileSection(
                id: "seasonal",
                title: "Seasonal Profile",
                paragraphs: [
                    "Spring: monitor bud development, new growth, foliage health, watering demand and root health. Coordinate structural work with local climate, growth stage and individual tree vigour. Avoid unnecessary simultaneous major stresses.",
                    "Summer: monitor watering demand, foliage health, heat stress, drought stress, pest activity and wire marks. In unusually hot or dry conditions, monitor carefully for environmental stress.",
                    "Autumn is important for assessing overall vigour, reviewing branch structure, evaluating foliage health and preparing for winter. Avoid unnecessary late-season stress. Local climate determines timing.",
                    "Winter: Abies × borisii-regis requires outdoor winter dormancy.",
                    "Winter management depends on local minimum temperatures, duration of freezing, wind exposure, container depth, root protection and tree health.",
                    "Shallow bonsai roots are more exposed than roots in open ground. Protect when required.",
                    "Pay particular attention to prolonged severe freezing, drying wind and winter desiccation.",
                    "Do not maintain indoors as a substitute for winter dormancy.",
                ]
            ),
            SpeciesProfileSection(
                id: "styles",
                title: "Bonsai Styles",
                paragraphs: [
                    "Abies × borisii-regis is particularly suitable for Formal Upright, Informal Upright, Slanting, Naturalistic Bonsai, Mountain-inspired Bonsai and Forest Bonsai.",
                    "It is especially effective when styling emphasises strong vertical structure, natural branch hierarchy, mature mountain-tree proportions and restrained asymmetry.",
                    "The individual material should determine the final design.",
                ]
            ),
            SpeciesProfileSection(
                id: "tree-stage",
                title: "Development by Tree Stage",
                paragraphs: [
                    "Young material: establish healthy roots, develop trunk and taper, build useful branches and preserve future options.",
                    "Nursery material: evaluate trunk potential, identify useful branches, establish long-term design direction and avoid premature refinement.",
                    "Pre-bonsai: develop trunk, establish primary branches, build useful foliage and preserve healthy roots.",
                    "In training: establish branch structure, develop secondary branching, maintain healthy interior growth and improve proportions.",
                    "Refinement: maintain foliage health, improve branch structure, refine branch hierarchy, preserve useful growth and avoid excessive intervention.",
                    "Exhibition / mature refined tree: maintain health, preserve established structure, protect mature bark, maintain branch hierarchy and avoid unnecessary major intervention.",
                ]
            ),
            SpeciesProfileSection(
                id: "attention",
                title: "Species-Specific Attention",
                paragraphs: [
                    "These attention points are operational tendencies. They must still be interpreted for the individual tree.",
                ],
                bullets: [
                    "Abies × borisii-regis is a naturally occurring hybrid taxon associated with the southern Balkan region",
                    "The multiplication sign × must be preserved in the scientific name",
                    "Do not describe it as an artificial horticultural hybrid",
                    "Individual trees may show variation associated with their hybrid origin",
                    "Outdoor cultivation is required",
                    "Winter dormancy is required",
                    "Healthy foliage and viable buds should be preserved before major reduction",
                    "Do not strip branches bare",
                    "Do not assume old bare wood will reliably regenerate",
                    "Development requires patience",
                    "Root work should be conservative",
                    "Avoid combining major root work and major styling unnecessarily",
                    "Do not use defoliation techniques",
                    "Mature branches can become rigid and difficult to bend",
                    "Avoid prolonged drought",
                    "Monitor carefully during unusually hot and dry conditions",
                    "Shallow roots require protection during prolonged severe freezing",
                    "Winter desiccation can be a risk in exposed conditions",
                ]
            ),
        ]
    }
}
