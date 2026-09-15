//
//  AbiesLasiocarpaSpeciesProfile.swift
//  Bonsai World
//
//  Species Profile — Abies lasiocarpa (Subalpine Fir).
//  Independent botanical species in Pinaceae. Knowledge status: Reviewed.
//  Separate from Picea species. True firs (Abies) are not spruce (Picea).
//

import Foundation

enum AbiesLasiocarpaSpeciesProfile {
    /// Identity used by Botanical Library / ``SpeciesPreviewData``.
    static let botanicalLibraryName = "Abies lasiocarpa"
    /// Scientific name for Species Profile display (binomial; no botanical authority).
    static let scientificName = "Abies lasiocarpa"

    static var profile: SpeciesProfile {
        SpeciesProfile(
            speciesID: BotanicalKnowledgeIDs.abiesLasiocarpa,
            scientificName: scientificName,
            commonNames: ["Subalpine Fir", "Rocky Mountain Fir"],
            family: "Pinaceae",
            plantType: "Evergreen conifer",
            originSummary: "Western North America, primarily in high-elevation mountain and subalpine forests.",
            knowledgeStatus: .reviewed,
            traits: traits,
            foliageSizeLabel: "Foliage",
            foliageReductionLabel: "Needle reduction",
            summaryLine: "Evergreen · Conifer · High-elevation mountain species · Blue-green to silvery foliage · Cold-adapted · Compact natural character · Slow to moderate growth · Outdoor cultivation required",
            attentionHighlights: [
                "Abies lasiocarpa is an evergreen fir native to western North America",
                "It is strongly associated with high-elevation and subalpine forests",
                "Cool mountain conditions are an important part of its natural ecology",
                "It should not be assumed to perform equally well in prolonged hot climates",
                "Heat stress can become a significant cultivation issue",
                "Healthy foliage and viable buds should be preserved before major reduction",
                "Do not strip branches bare",
                "Do not assume old bare wood will reliably regenerate",
                "Development requires patience",
                "Root work should be conservative",
                "Avoid combining major root work and major styling unnecessarily",
                "Do not use defoliation techniques",
                "Mature branches can become rigid and difficult to bend",
                "Avoid prolonged drought",
                "Strong drying winds can increase water stress",
                "Shallow roots remain vulnerable during prolonged severe freezing",
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

            The objective is: Preserve future development before making irreversible cuts.

            Development should prioritise: Healthy roots · Preserved foliage · Stable vigour · Cool-root conditions where required · Natural mountain character · Long-term development.

            The individual tree must always be assessed according to climate, tree condition, vigour, development stage and winter temperatures.
            """,
            sourcesNote: """
            Profile content is synthesised from recognised botanical, horticultural and bonsai authorities into Bonsai World editorial language.

            Botanical taxonomy and distribution draw on recognised sources such as Royal Botanic Gardens, Kew, Plants of the World Online, recognised North American botanical institutions and recognised forestry institutions for accepted scientific name, family and native range.

            Horticultural context may draw on recognised horticultural institutions and authoritative Abies references.

            Bonsai-specific cultivation and refinement knowledge draws on established bonsai references and recognised professional practice with conifer experience, kept distinct from Picea species and from drought-tolerant management assumptions. Heat and mountain-climate adaptation are treated as regional horticultural guidance, separate from verified botanical identity.

            Verified botanical information, horticultural information, regional climate adaptation and bonsai-specific practice are kept distinct. Do not copy source wording.
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
        rootFrostSensitivity: "Low to Moderate, but shallow bonsai roots remain vulnerable during prolonged severe freezing"
    )

    private static var sections: [SpeciesProfileSection] {
        [
            SpeciesProfileSection(
                id: "taxonomic-context",
                title: "Taxonomic Context",
                paragraphs: [
                    "Abies lasiocarpa is an independent botanical species in the pine family (Pinaceae).",
                    "Primary Bonsai World display identity: Abies lasiocarpa · Subalpine Fir.",
                    "Rocky Mountain Fir may be listed as an alternative common name where useful. It does not replace Subalpine Fir as the preferred English common name.",
                    "Family: Pinaceae. Plant type: evergreen conifer.",
                    "Native range: Western North America, primarily in high-elevation mountain and subalpine forests.",
                    "Do not confuse Abies lasiocarpa with Picea species. Do not confuse true firs in the genus Abies with spruce in the genus Picea.",
                    "Bonsai World hierarchy: Species → cultivar / horticultural selection → Individual Tree.",
                ]
            ),
            SpeciesProfileSection(
                id: "overview",
                title: "Species Overview",
                paragraphs: [
                    "Abies lasiocarpa is an evergreen fir native to western North America and strongly associated with high-elevation and subalpine forests.",
                    "It is particularly suited to environments with cold winters, significant winter dormancy, cool mountain conditions and relatively short growing seasons.",
                    "For bonsai, its natural mountain character can make it particularly attractive for naturalistic upright bonsai, mountain-inspired compositions, compact alpine and subalpine character, mature high-altitude tree designs and forest plantings.",
                    "The species should be developed patiently.",
                    "Its natural adaptation to cool mountain environments means that heat management may be especially important in warmer climates.",
                    "Development should prioritise: Healthy roots · Preserved foliage · Stable vigour · Cool-root conditions where required · Natural mountain character · Long-term development.",
                ],
                bullets: [
                    "Evergreen conifer",
                    "Native to western North America",
                    "Strongly associated with high-elevation and subalpine forests",
                    "Adapted to cold winter conditions",
                    "Flat evergreen needles",
                    "Often blue-green to silvery foliage character",
                    "Slow to moderate development",
                    "Moderate ramification potential",
                    "Limited to moderate back-budding",
                    "Strong mountain-tree character",
                    "Outdoor cultivation required",
                    "Winter dormancy required",
                    "Sensitive to prolonged heat stress compared with many lower-elevation conifers",
                ]
            ),
            SpeciesProfileSection(
                id: "cultivars",
                title: "Cultivars and Forms",
                paragraphs: [
                    "Abies lasiocarpa is primarily used in bonsai as the botanical species.",
                    "Horticultural selections may differ in growth habit, needle colour and compactness.",
                    "Do not create unnecessary separate Species Library profiles for minor individual variation.",
                    "The primary Species Profile remains Abies lasiocarpa.",
                    "Only create separate profiles where a distinct cultivar or form has a clear and established independent bonsai identity.",
                ]
            ),
            SpeciesProfileSection(
                id: "natural-growth",
                title: "Natural Growth and Vigour",
                paragraphs: [
                    "Abies lasiocarpa generally develops slowly to moderately.",
                    "Healthy growth depends on healthy roots, sufficient outdoor light, stable moisture, well-aerated substrate, balanced nutrition, suitable summer temperatures, avoidance of prolonged drought and avoidance of repeated unnecessary stress.",
                    "During development: allow useful growth to extend where required for trunk development, branch thickening, recovery or future structure.",
                    "Avoid restricting all useful growth prematurely.",
                    "The objective is: Stable vigour · Useful extension · Progressive development.",
                    "In warmer climates, environmental stress may reduce vigour even where watering is adequate.",
                ]
            ),
            SpeciesProfileSection(
                id: "foliage",
                title: "Foliage",
                paragraphs: [
                    "Abies lasiocarpa has flat evergreen needles.",
                    "Foliage may display green, blue-green or silvery green tones depending on individual genetics and growing conditions. Not every specimen shows identical colour.",
                    "Healthy foliage is essential for energy production, recovery, branch development and future refinement.",
                    "Do not strip branches bare, remove all useful foliage from sections intended to remain alive, or assume old bare wood will reliably regenerate useful replacement growth.",
                    "Foliage management should focus on shoot selection, selective reduction, preservation of useful interior growth and maintaining balanced vigour.",
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
                    "Abies lasiocarpa produces upright cones.",
                    "Upright cones are a botanical character of true firs and help distinguish Abies from Picea, which typically produce hanging cones.",
                    "Cones may contribute to seasonal character but are not a primary bonsai design objective.",
                    "Do not sacrifice structural development or foliage health in pursuit of cones.",
                ]
            ),
            SpeciesProfileSection(
                id: "bark-trunk",
                title: "Bark and Trunk",
                paragraphs: [
                    "Mature Abies lasiocarpa can develop attractive natural trunk character. Mature bark character is good.",
                    "Trunk development should focus on believable taper, natural proportions, compact mountain-tree character and structural strength.",
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
                    "In warmer climates, root-zone management can be particularly important because heat stress may affect overall vigour.",
                    "The objective is: Stable root system · Reliable recovery · Natural anchoring.",
                ]
            ),
            SpeciesProfileSection(
                id: "light",
                title: "Light",
                paragraphs: [
                    "Abies lasiocarpa should be cultivated outdoors.",
                    "Provide strong outdoor light while adapting placement to local climate, summer temperatures, humidity, tree health and development stage.",
                    "The species is naturally associated with cool mountain conditions.",
                    "Heat tolerance is low to moderate. In warm climates, prolonged intense heat can create stress.",
                    "Where local conditions require it, provide an environment that balances sufficient light, healthy foliage, reduced heat stress and stable root conditions.",
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
                    "High-elevation origin does not mean a shallow bonsai container is immune to drying stress.",
                ]
            ),
            SpeciesProfileSection(
                id: "watering",
                title: "Watering",
                paragraphs: [
                    "General principle: Maintain stable root moisture · Avoid prolonged drought · Avoid permanently saturated roots · Maintain healthy root aeration.",
                    "Water demand is moderate.",
                    "Abies lasiocarpa should not be treated as drought tolerant in bonsai cultivation.",
                    "Water demand depends on temperature, sunlight, wind, foliage mass, container size, substrate and root mass.",
                    "In warm conditions, environmental stress can increase even if moisture levels are maintained. Avoid assuming that additional water alone resolves heat stress.",
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
                    "In warm climates, root-zone temperature and moisture stability may be especially important.",
                    "Follow Bonsai World Soil Module principles.",
                    "Do not duplicate the complete Soil Module inside this profile.",
                ]
            ),
            SpeciesProfileSection(
                id: "fertilizing",
                title: "Fertilizing",
                paragraphs: [
                    "Fertilization should support healthy foliage, root development, useful structural growth and recovery.",
                    "Avoid excessive fertilization that produces unnecessarily coarse growth, imbalance or excessive growth on a stressed tree.",
                    "Do not attempt to compensate for environmental heat stress by simply increasing fertilization.",
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
                    "Deadwood may be particularly effective where it supports a believable mountain-tree narrative.",
                    "Avoid dramatic or artificial carving.",
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
                    "Do not aggressively reduce foliage on weak trees, heat-stressed trees, drought-stressed trees, recently repotted trees or trees recovering from major work.",
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
                    "Abies lasiocarpa may be propagated through established horticultural methods where appropriate.",
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
                    "Spring: monitor bud development, new growth, foliage health, watering demand and root health. Coordinate structural work with local climate, growth stage and individual tree vigour. Avoid unnecessary simultaneous major stresses.",
                    "Summer monitoring is particularly important. Monitor watering demand, foliage health, heat stress, drought stress, root-zone conditions, pest activity and wire marks.",
                    "In warm climates, prolonged high temperatures can become a significant stress factor. Avoid assuming that additional water alone resolves heat stress. Where necessary, adapt placement to reduce prolonged environmental stress while maintaining sufficient light.",
                    "Autumn is important for assessing overall vigour, reviewing branch structure, evaluating foliage health and preparing for winter. Avoid unnecessary late-season stress. Local climate determines timing.",
                    "Winter: Abies lasiocarpa requires outdoor winter dormancy.",
                    "The species is naturally associated with cold mountain environments. However, shallow bonsai roots remain more exposed than roots in open ground.",
                    "Winter management depends on local minimum temperatures, duration of freezing, wind exposure, container depth, root protection and tree health.",
                    "Protect when required. Pay particular attention to prolonged severe freezing, drying wind and winter desiccation.",
                    "Do not maintain indoors as a substitute for winter dormancy.",
                ]
            ),
            SpeciesProfileSection(
                id: "styles",
                title: "Bonsai Styles",
                paragraphs: [
                    "Abies lasiocarpa is particularly suitable for Informal Upright, Formal Upright, Slanting, Naturalistic Bonsai, Mountain-inspired Bonsai and Forest Bonsai.",
                    "It is especially effective when styling emphasises mountain-tree character, natural branch hierarchy, compact mature proportions and weathered natural asymmetry.",
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
                    "Abies lasiocarpa is an evergreen fir native to western North America",
                    "It is strongly associated with high-elevation and subalpine forests",
                    "Cool mountain conditions are an important part of its natural ecology",
                    "It should not be assumed to perform equally well in prolonged hot climates",
                    "Heat stress can become a significant cultivation issue",
                    "Healthy foliage and viable buds should be preserved before major reduction",
                    "Do not strip branches bare",
                    "Do not assume old bare wood will reliably regenerate",
                    "Development requires patience",
                    "Root work should be conservative",
                    "Avoid combining major root work and major styling unnecessarily",
                    "Do not use defoliation techniques",
                    "Mature branches can become rigid and difficult to bend",
                    "Avoid prolonged drought",
                    "Strong drying winds can increase water stress",
                    "Shallow roots remain vulnerable during prolonged severe freezing",
                    "Winter desiccation can be a risk in exposed conditions",
                    "Outdoor cultivation and winter dormancy are required",
                ]
            ),
        ]
    }
}
