//
//  AbiesGrandisSpeciesProfile.swift
//  Bonsai World
//
//  Species Profile — Abies grandis (Grand Fir).
//  Independent botanical species in Pinaceae. Knowledge status: Reviewed.
//  Separate from Picea species. True firs (Abies) are not spruce (Picea).
//

import Foundation

enum AbiesGrandisSpeciesProfile {
    /// Identity used by Botanical Library / ``SpeciesPreviewData``.
    static let botanicalLibraryName = "Abies grandis"
    /// Scientific name for Species Profile display (binomial; no botanical authority).
    static let scientificName = "Abies grandis"

    static var profile: SpeciesProfile {
        SpeciesProfile(
            speciesID: BotanicalKnowledgeIDs.abiesGrandis,
            scientificName: scientificName,
            commonNames: ["Grand Fir", "Giant Fir", "Lowland White Fir"],
            family: "Pinaceae",
            plantType: "Evergreen conifer",
            originSummary: "Western North America, particularly the Pacific Northwest and inland northwestern mountain and forest regions.",
            knowledgeStatus: .reviewed,
            traits: traits,
            foliageSizeLabel: "Foliage",
            foliageReductionLabel: "Needle reduction",
            summaryLine: "Evergreen · Conifer · Western North American forest species · Flat aromatic needles · Strong vertical growth · Potentially vigorous · Large forest tree · Outdoor cultivation required",
            attentionHighlights: [
                "Abies grandis is an evergreen fir native to western North America",
                "It is strongly associated with Pacific Northwest and western forest environments",
                "It is naturally a large forest tree",
                "Bonsai development requires careful management of scale and proportion",
                "Healthy foliage and viable buds should be preserved before major reduction",
                "Do not strip branches bare",
                "Do not assume old bare wood will reliably regenerate",
                "The species can develop relatively strongly when healthy",
                "Manage vigour rather than simply suppressing all growth",
                "Root work should be conservative",
                "Avoid combining major root work and major styling unnecessarily",
                "Do not use defoliation techniques",
                "Mature branches can become rigid and difficult to bend",
                "Avoid prolonged drought",
                "Vigorous trees with substantial foliage can have high water demand",
                "Strong drying winds can increase water stress",
                "Shallow roots require protection during prolonged severe freezing",
                "Winter desiccation can be a risk in exposed conditions",
                "Outdoor cultivation and winter dormancy are required",
            ],
            sections: sections,
            principleNote: """
            The primary operational rule is: Preserve healthy foliage and viable buds before major reduction.

            Do not assume that completely bare old wood will reliably regenerate useful replacement growth.

            Before removing branches or major sections: identify viable buds, identify retained foliage, identify replacement options and assess tree vigour.

            Major work should be staged where necessary.

            Avoid combining multiple major stresses without a clear reason.

            The objective is: Healthy roots · Controlled vigour · Preserved foliage · Natural proportions · Long-term development.

            Because the species can naturally become a very large tree, material selection and scale management are particularly important.

            The individual tree must always be assessed according to climate, tree condition, vigour, development stage and winter temperatures.
            """,
            sourcesNote: """
            Profile content is synthesised from recognised botanical, horticultural and bonsai authorities into Bonsai World editorial language.

            Botanical taxonomy and distribution draw on recognised sources such as Royal Botanic Gardens, Kew, Plants of the World Online, recognised North American botanical institutions and recognised forestry institutions for accepted scientific name, family and native range.

            Horticultural context may draw on recognised horticultural institutions and authoritative Abies references.

            Bonsai-specific cultivation and refinement knowledge draws on established bonsai references and recognised professional practice with conifer experience, kept distinct from Picea species and from drought-tolerant management assumptions.

            Verified botanical information, horticultural information, regional climate adaptation and bonsai-specific practice are kept distinct. Do not copy source wording.
            """
        )
    }

    private static let traits = SpeciesProfileTraits(
        deciduous: false,
        growthStrength: "Moderate to Strong",
        growthSpeed: "Moderate to Fast when vigorous",
        leafSize: "Evergreen · Flat needles",
        foliageReduction: "Not applicable",
        ramificationPotential: "Moderate",
        backBudding: "Limited to Moderate — dependent on retained healthy foliage and viable buds",
        rootDevelopment: "Moderate to Strong",
        nebariPotential: "Moderate potential",
        trunkDevelopment: "Moderate to Strong",
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
                    "Abies grandis is an independent botanical species in the pine family (Pinaceae).",
                    "Primary Bonsai World display identity: Abies grandis · Grand Fir.",
                    "Giant Fir and Lowland White Fir may be listed as alternative common names where useful. They do not replace Grand Fir as the preferred English common name.",
                    "Family: Pinaceae. Plant type: evergreen conifer.",
                    "Native range: Western North America, particularly the Pacific Northwest and inland northwestern mountain and forest regions.",
                    "Do not confuse Abies grandis with Picea species. Do not confuse true firs in the genus Abies with spruce in the genus Picea.",
                    "Bonsai World hierarchy: Species → cultivar / horticultural selection → Individual Tree.",
                ]
            ),
            SpeciesProfileSection(
                id: "overview",
                title: "Species Overview",
                paragraphs: [
                    "Abies grandis is an evergreen fir native to western North America.",
                    "It is a naturally large forest tree associated particularly with Pacific Northwest forests, moist western forest environments, mountain and inland forest regions and large mixed conifer forests.",
                    "For bonsai, its natural tendency toward strong vertical growth and potentially vigorous development must be balanced against the need to build believable proportions and controlled branch structure.",
                    "Its strongest potential lies in naturalistic upright bonsai, large conifer bonsai, forest-tree character, mountain and coastal forest-inspired compositions and forest plantings.",
                    "Development should prioritise: Healthy roots · Controlled vigour · Preserved foliage · Natural proportions · Long-term development.",
                    "Because the species can naturally become a very large tree, material selection and scale management are particularly important.",
                ],
                bullets: [
                    "Evergreen conifer",
                    "Native to western North America",
                    "Important Pacific Northwest forest species",
                    "Naturally large forest tree",
                    "Flat evergreen needles",
                    "Potentially vigorous growth",
                    "Moderate ramification potential",
                    "Limited to moderate back-budding",
                    "Strong vertical growth character",
                    "Outdoor cultivation required",
                    "Winter dormancy required",
                    "Requires patient scale and structure management as bonsai",
                ]
            ),
            SpeciesProfileSection(
                id: "cultivars",
                title: "Cultivars and Forms",
                paragraphs: [
                    "Abies grandis is primarily used in bonsai as the botanical species.",
                    "Horticultural selections may differ in growth habit, needle density and compactness.",
                    "Do not create unnecessary separate Species Library profiles for minor individual variation.",
                    "The primary Species Profile remains Abies grandis.",
                    "Only create separate profiles where a distinct cultivar or form has a clear and established independent bonsai identity.",
                ]
            ),
            SpeciesProfileSection(
                id: "natural-growth",
                title: "Natural Growth and Vigour",
                paragraphs: [
                    "Abies grandis can develop relatively strongly when healthy and growing conditions are favourable.",
                    "Healthy growth depends on healthy roots, sufficient outdoor light, stable moisture, well-aerated substrate, balanced nutrition, sufficient root space during development, avoidance of prolonged drought and avoidance of repeated unnecessary stress.",
                    "During development: allow useful growth to extend where required for trunk development, branch thickening, recovery or future structure.",
                    "Because the species may develop strong extension growth, manage vigour rather than simply suppressing all growth.",
                    "The objective is: Stable vigour · Controlled extension · Progressive development.",
                ]
            ),
            SpeciesProfileSection(
                id: "foliage",
                title: "Foliage",
                paragraphs: [
                    "Abies grandis has flat evergreen needles. Flat aromatic needles contribute to its western forest character.",
                    "Healthy foliage is essential for energy production, recovery, branch development and future refinement.",
                    "Do not strip branches bare, remove all useful foliage from sections intended to remain alive, or assume old bare wood will reliably regenerate useful replacement growth.",
                    "Foliage management should focus on shoot selection, selective reduction, preservation of useful interior growth and balancing stronger and weaker areas.",
                    "Avoid producing dense outer foliage while weakening the interior structure.",
                    "The objective is: Healthy foliage · Useful interior growth · Balanced vigour · Sustainable refinement.",
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
                    "Abies grandis produces upright cones.",
                    "Upright cones are a botanical character of true firs and help distinguish Abies from Picea, which typically produce hanging cones.",
                    "Cones may contribute to seasonal character but are not a primary bonsai design objective.",
                    "Do not sacrifice structural development or foliage health in pursuit of cones.",
                ]
            ),
            SpeciesProfileSection(
                id: "bark-trunk",
                title: "Bark and Trunk",
                paragraphs: [
                    "Mature Abies grandis can develop strong natural trunk character. Mature bark character is good.",
                    "Its natural scale means trunk development and proportion must be considered carefully.",
                    "Trunk development should focus on believable taper, natural proportions, convincing scale, strong vertical structure and mature forest-tree character.",
                    "Where additional development is required: retain useful leaders, allow selected growth to extend, provide sufficient root space and avoid premature confinement.",
                    "The objective is: Natural maturity · Convincing scale · Strong proportions.",
                ]
            ),
            SpeciesProfileSection(
                id: "roots-nebari",
                title: "Roots and Nebari",
                paragraphs: [
                    "Healthy roots are essential for stable development.",
                    "Root development is moderate to strong. Nebari has moderate potential.",
                    "Root work should be conservative.",
                    "Avoid excessive root reduction, unnecessary disturbance, repeated repotting and combining major root work with major styling work.",
                    "During early development, sufficient root space may be important for developing trunk and branch strength.",
                    "Nebari development should be gradual.",
                    "The objective is: Stable root system · Reliable recovery · Natural anchoring.",
                ]
            ),
            SpeciesProfileSection(
                id: "light",
                title: "Light",
                paragraphs: [
                    "Abies grandis should be cultivated outdoors.",
                    "Provide strong outdoor light while adapting placement to local climate, summer temperatures, humidity, tree health and development stage.",
                    "The species is naturally associated with regions that can provide substantial moisture.",
                    "Do not assume that a naturally vigorous forest species is tolerant of repeated drying in a shallow bonsai container.",
                    "Do not recommend permanent indoor cultivation.",
                ]
            ),
            SpeciesProfileSection(
                id: "wind",
                title: "Wind",
                paragraphs: [
                    "Moderate air movement is beneficial.",
                    "Strong drying winds can increase foliage moisture loss, watering demand, drought stress and winter desiccation.",
                    "Monitor exposed trees carefully.",
                ]
            ),
            SpeciesProfileSection(
                id: "watering",
                title: "Watering",
                paragraphs: [
                    "General principle: Maintain stable root moisture · Avoid prolonged drought · Avoid permanently saturated roots · Maintain healthy root aeration.",
                    "Water demand is moderate to high.",
                    "Abies grandis should not be treated as a drought-tolerant bonsai species.",
                    "Vigorous trees with substantial foliage can have significantly increased water demand.",
                    "Water demand depends on temperature, sunlight, wind, foliage mass, container size, substrate, root mass and current growth vigour.",
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
                    "Because the species can develop strongly under favourable conditions, avoid feeding solely to maximise growth.",
                    "Fertilization should match the current objective: development, recovery, maintenance or refinement.",
                    "Avoid excessive fertilization that produces unnecessarily coarse growth, imbalance or excessive vigour that is difficult to manage.",
                    "Key principle: Feed according to tree health and development objective.",
                ]
            ),
            SpeciesProfileSection(
                id: "pruning",
                title: "Pruning",
                paragraphs: [
                    "Pruning should be planned around retained foliage, viable buds, branch age, future structure and tree vigour. Pruning response is moderate to advanced.",
                    "Strong growth should be managed selectively.",
                    "Before major reduction: identify future replacement growth, retain viable options and avoid unnecessary irreversible cuts.",
                    "The objective is: Controlled structure · Balanced vigour · Preserved growth options.",
                ]
            ),
            SpeciesProfileSection(
                id: "back-budding",
                title: "Back-budding",
                paragraphs: [
                    "Back-budding is limited to moderate and dependent on retained healthy foliage and viable buds.",
                    "Back-budding should not be treated as guaranteed.",
                    "Response depends on tree health, vigour, retained foliage, viable buds, branch age and light availability.",
                    "Before structural pruning: identify viable buds, preserve useful foliage and maintain replacement options.",
                    "The objective is: Preserve future development before making irreversible cuts.",
                ]
            ),
            SpeciesProfileSection(
                id: "ramification",
                title: "Ramification",
                paragraphs: [
                    "Ramification should be developed gradually. Ramification potential is moderate.",
                    "Useful methods include healthy growth cycles, controlled shoot selection, selective pruning and careful wiring.",
                    "Because stronger growth may develop in vigorous areas, balance should be maintained between stronger branches, weaker branches, upper and lower sections and outer and interior growth.",
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
                    "Avoid excessive carving or dramatic deadwood that does not match the natural character of a mature fir.",
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
                    "Abies grandis can be useful for trunk development when given appropriate space and allowed useful extension.",
                    "Where additional development is required: retain selected leaders, allow useful extension, provide sufficient root space and avoid premature confinement.",
                    "Development should support taper, natural proportions, trunk strength, convincing scale and mature forest character.",
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
                    "Abies grandis may be propagated through established horticultural methods where appropriate.",
                    "Detailed procedures belong in Bonsai World Propagation Knowledge Articles.",
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
                    "Spring: monitor bud development, new growth, foliage health, watering demand and root health. Vigorous growth should be evaluated in relation to the current development objective. Coordinate structural work with local climate, growth stage and individual tree vigour. Avoid unnecessary simultaneous major stresses.",
                    "Summer: monitor watering demand, foliage health, drought stress, heat stress, pest activity and wire marks. Trees with strong foliage mass can experience high water demand during warm conditions. Monitor carefully during prolonged heat, dry weather and strong wind.",
                    "Autumn is important for assessing overall vigour, reviewing branch structure, evaluating foliage health and preparing for winter. Avoid unnecessary late-season stress. Local climate determines timing.",
                    "Winter: Abies grandis requires outdoor winter dormancy.",
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
                    "Abies grandis is particularly suitable for Formal Upright, Informal Upright, Slanting, Naturalistic Bonsai, Mountain-inspired Bonsai and Forest Bonsai.",
                    "It is especially effective when styling emphasises strong vertical structure, mature forest-tree proportions, natural branch hierarchy and restrained natural asymmetry.",
                    "Because the species is naturally a large tree, the final design should maintain convincing proportions.",
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
                    "In training: establish branch structure, develop secondary branching, maintain healthy interior growth, improve proportions and balance stronger and weaker areas.",
                    "Refinement: maintain foliage health, improve branch structure, refine branch hierarchy, preserve useful growth, control excessive vigour and avoid excessive intervention.",
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
                    "Abies grandis is an evergreen fir native to western North America",
                    "It is strongly associated with Pacific Northwest and western forest environments",
                    "It is naturally a large forest tree",
                    "Bonsai development requires careful management of scale and proportion",
                    "Healthy foliage and viable buds should be preserved before major reduction",
                    "Do not strip branches bare",
                    "Do not assume old bare wood will reliably regenerate",
                    "The species can develop relatively strongly when healthy",
                    "Manage vigour rather than simply suppressing all growth",
                    "Root work should be conservative",
                    "Avoid combining major root work and major styling unnecessarily",
                    "Do not use defoliation techniques",
                    "Mature branches can become rigid and difficult to bend",
                    "Avoid prolonged drought",
                    "Vigorous trees with substantial foliage can have high water demand",
                    "Strong drying winds can increase water stress",
                    "Shallow roots require protection during prolonged severe freezing",
                    "Winter desiccation can be a risk in exposed conditions",
                    "Outdoor cultivation and winter dormancy are required",
                ]
            ),
        ]
    }
}
