//
//  AbiesKoreanaSpeciesProfile.swift
//  Bonsai World
//
//  Species Profile — Abies koreana (Korean Fir).
//  Independent botanical species in Pinaceae. Knowledge status: Reviewed.
//  Separate from Picea species. True firs (Abies) are not spruce (Picea).
//

import Foundation

enum AbiesKoreanaSpeciesProfile {
    /// Identity used by Botanical Library / ``SpeciesPreviewData``.
    static let botanicalLibraryName = "Abies koreana"
    /// Scientific name for Species Profile display (binomial; no botanical authority).
    static let scientificName = "Abies koreana"

    static var profile: SpeciesProfile {
        SpeciesProfile(
            speciesID: BotanicalKnowledgeIDs.abiesKoreana,
            scientificName: scientificName,
            commonNames: ["Korean Fir"],
            family: "Pinaceae",
            plantType: "Evergreen conifer",
            originSummary: "Mountainous regions of South Korea.",
            knowledgeStatus: .reviewed,
            traits: traits,
            foliageSizeLabel: "Foliage",
            foliageReductionLabel: "Needle reduction",
            summaryLine: "Evergreen · Conifer · Mountain species · Compact growth potential · Short needles · Ornamental cones · Slow to moderate growth · Suitable for refined bonsai · Outdoor cultivation required",
            attentionHighlights: [
                "Abies koreana is an evergreen fir native to South Korea",
                "Outdoor cultivation is required",
                "Winter dormancy is required",
                "It is not interchangeable with Picea species",
                "Healthy foliage and viable buds should be preserved before major reduction",
                "Do not strip branches bare",
                "Do not assume old bare wood will reliably regenerate",
                "Development is slow and requires patience",
                "Root work should be conservative",
                "Avoid combining major root work and major styling unnecessarily",
                "Do not use defoliation techniques",
                "Mature branches can become rigid and difficult to bend",
                "Avoid prolonged drought",
                "Avoid excessive heat stress",
                "Shallow roots require protection during prolonged severe freezing",
                "Winter desiccation can be a risk in exposed conditions",
            ],
            sections: sections,
            principleNote: """
            Abies koreana should be developed patiently.

            It is not a species for repeated aggressive intervention.

            The most important operational principle is: Preserve healthy foliage and viable buds before reducing structural growth.

            Do not assume that old bare wood will reliably produce replacement growth.

            Major work should be planned carefully, based on tree vigour and staged when necessary.

            The objective is: Healthy roots · Preserved foliage · Controlled vigour · Natural branch structure · Long-term refinement.

            The individual tree must always be assessed according to climate, tree condition, vigour, development stage and winter temperatures.
            """,
            sourcesNote: """
            Profile content is synthesised from recognised botanical, horticultural and bonsai authorities into Bonsai World editorial language.

            Botanical taxonomy and distribution draw on recognised sources such as Royal Botanic Gardens, Kew, Plants of the World Online and recognised Korean botanical institutions for accepted scientific name, family and native range.

            Horticultural context may draw on recognised horticultural institutions and authoritative Abies references.

            Bonsai-specific cultivation and refinement knowledge draws on established bonsai references and recognised professional practice with conifer experience, kept distinct from Picea species and from drought-tolerant juniper management.

            Verified botanical information, horticultural information, regional climate adaptation and bonsai-specific practice are kept distinct. Do not copy source wording.
            """
        )
    }

    private static let traits = SpeciesProfileTraits(
        deciduous: false,
        growthStrength: "Slow to Moderate",
        growthSpeed: "Slow to Moderate",
        leafSize: "Evergreen · Short flat needles",
        foliageReduction: "Not applicable",
        ramificationPotential: "Moderate",
        backBudding: "Limited to Moderate — dependent on retained healthy foliage and viable buds",
        rootDevelopment: "Moderate",
        nebariPotential: "Moderate to Good potential",
        trunkDevelopment: "Slow",
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
                    "Abies koreana is an independent botanical species in the pine family (Pinaceae).",
                    "Primary Bonsai World display identity: Abies koreana · Korean Fir.",
                    "Family: Pinaceae. Plant type: evergreen conifer.",
                    "Native range: Mountainous regions of South Korea.",
                    "Do not confuse Abies koreana with Picea species. Do not confuse true firs in the genus Abies with spruce in the genus Picea.",
                    "Bonsai World hierarchy: Species → cultivar / horticultural selection → Individual Tree.",
                ]
            ),
            SpeciesProfileSection(
                id: "overview",
                title: "Species Overview",
                paragraphs: [
                    "Abies koreana is an evergreen fir native to mountainous regions of South Korea.",
                    "Abies koreana is particularly relevant to Bonsai World because it is a distinctive Asian fir species, it has relatively compact foliage characteristics, mature material can develop refined proportions, it is well suited to specialist conifer bonsai and it provides a useful contrast to larger European fir species.",
                    "It should be presented as a specialist species requiring patient and careful cultivation.",
                    "It is valued horticulturally for compact foliage character, ornamental appearance, relatively refined proportions and distinctive upright cones.",
                    "For bonsai, it is best approached as a specialist conifer.",
                    "Development should prioritise stable health, healthy roots, trunk and branch structure, preservation of useful buds and gradual refinement. Avoid forcing rapid development.",
                ],
                bullets: [
                    "Evergreen conifer",
                    "Native to South Korea",
                    "Mountain species",
                    "Short, flat needles",
                    "Compact growth potential",
                    "Slow to moderate growth",
                    "Moderate ramification potential",
                    "Limited to moderate back-budding",
                    "Healthy foliage and viable buds are important for future development",
                    "Outdoor cultivation required",
                    "Winter dormancy required",
                    "Specialist conifer for patient bonsai development",
                ]
            ),
            SpeciesProfileSection(
                id: "cultivars",
                title: "Cultivars and Forms",
                paragraphs: [
                    "Abies koreana is the botanical baseline species for bonsai use.",
                    "Numerous horticultural selections exist and may differ in foliage colour, compactness and growth habit.",
                    "Cultivar-specific characteristics must not automatically be assigned to this species profile.",
                    "Do not create unnecessary separate Species Library profiles for minor individual variation.",
                    "The primary Species Profile remains Abies koreana.",
                    "Only create separate profiles where a distinct cultivar or form has a clear and established independent bonsai identity.",
                ]
            ),
            SpeciesProfileSection(
                id: "natural-growth",
                title: "Natural Growth and Vigour",
                paragraphs: [
                    "Abies koreana generally develops slowly to moderately.",
                    "Healthy growth depends on healthy roots, sufficient light, appropriate watering, well-aerated substrate, balanced nutrition and stable environmental conditions.",
                    "During development: allow useful growth to extend where required for trunk development, branch thickening, recovery or future structure.",
                    "Avoid continuously restricting useful growth.",
                    "The objective is: Stable vigour · Useful extension · Progressive development.",
                ]
            ),
            SpeciesProfileSection(
                id: "foliage",
                title: "Foliage",
                paragraphs: [
                    "Abies koreana has short evergreen needles. Foliage type is short flat needles.",
                    "Healthy foliage is essential for energy production, recovery, branch development and future refinement.",
                    "Do not strip branches bare, remove all useful foliage from sections intended to remain alive, or assume old bare wood will reliably regenerate.",
                    "Foliage management should focus on shoot selection, controlled reduction, preservation of healthy interior growth and maintaining balanced vigour.",
                    "The objective is: Healthy foliage · Clear structure · Sustainable refinement.",
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
                    "Abies koreana produces distinctive upright cones.",
                    "Upright cones are a botanical character of true firs and help distinguish Abies from Picea, which typically produce hanging cones.",
                    "Ornamental cones may contribute to seasonal character but are not a primary bonsai design objective.",
                    "Do not sacrifice structural development or foliage health in pursuit of cones.",
                ]
            ),
            SpeciesProfileSection(
                id: "bark-trunk",
                title: "Bark and Trunk",
                paragraphs: [
                    "Abies koreana develops trunk character gradually. Mature bark character is good.",
                    "Important objectives include believable taper, natural movement, appropriate proportions and mature bark development over time.",
                    "Trunk development is generally slow.",
                    "Where additional development is required: retain useful leaders, allow selected growth to extend, provide adequate root space and avoid premature confinement.",
                    "The objective is: Natural maturity · Strong proportions · Patient development.",
                ]
            ),
            SpeciesProfileSection(
                id: "roots-nebari",
                title: "Roots and Nebari",
                paragraphs: [
                    "Healthy roots are critical for stable development.",
                    "Root development is moderate. Nebari has moderate to good potential.",
                    "Root work should be conservative.",
                    "Avoid excessive root reduction, unnecessary disturbance, repeated repotting and combining major root work with major styling work.",
                    "The objective is: Stable root system · Reliable recovery · Long-term health.",
                ]
            ),
            SpeciesProfileSection(
                id: "light",
                title: "Light",
                paragraphs: [
                    "Abies koreana should be cultivated outdoors.",
                    "Provide strong light while adapting placement to local climate, summer temperatures, humidity, tree health and development stage.",
                    "In very hot conditions, monitor carefully for environmental stress.",
                    "Do not recommend permanent indoor cultivation.",
                ]
            ),
            SpeciesProfileSection(
                id: "wind",
                title: "Wind",
                paragraphs: [
                    "Moderate air movement is beneficial.",
                    "Strong drying winds can increase moisture loss, foliage stress and winter desiccation.",
                    "Monitor carefully during hot dry periods, exposed weather and severe winter conditions.",
                ]
            ),
            SpeciesProfileSection(
                id: "watering",
                title: "Watering",
                paragraphs: [
                    "General principle: Maintain consistent root moisture · Avoid prolonged drought · Avoid permanently saturated roots · Maintain healthy root aeration.",
                    "Water demand is moderate.",
                    "Abies koreana should not be treated as a drought-tolerant species.",
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
                    "Fertilization should support healthy foliage, root development, controlled structural growth and recovery.",
                    "Avoid excessive fertilization that produces unnecessarily coarse growth, imbalance or excessive vigour that is difficult to manage.",
                    "Key principle: Feed according to tree health and development objective.",
                ]
            ),
            SpeciesProfileSection(
                id: "pruning",
                title: "Pruning",
                paragraphs: [
                    "Pruning must be planned around retained buds, retained foliage, branch age, future structure and tree vigour. Pruning response is moderate to advanced.",
                    "Before removing major sections: identify future replacement growth, retain viable options and avoid unnecessary irreversible cuts.",
                    "The objective is: Controlled structure · Preserved growth options · Long-term refinement.",
                ]
            ),
            SpeciesProfileSection(
                id: "back-budding",
                title: "Back-budding",
                paragraphs: [
                    "Back-budding is limited to moderate and dependent on retained healthy foliage and viable buds.",
                    "Back-budding should not be treated as guaranteed.",
                    "Response depends on tree health, vigour, retained foliage, viable buds, branch age and light availability.",
                    "Before structural reduction: identify viable buds, retain useful foliage and maintain replacement options.",
                    "The objective is: Preserve future development before making irreversible cuts.",
                ]
            ),
            SpeciesProfileSection(
                id: "ramification",
                title: "Ramification",
                paragraphs: [
                    "Ramification should be developed gradually. Ramification potential is moderate.",
                    "Useful methods include controlled shoot selection, selective pruning, wiring where appropriate and repeated healthy growth cycles.",
                    "Avoid excessive repeated cutting, removing useful interior growth and forcing dense refinement before sufficient structure exists.",
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
                    "Deadwood should generally be restrained and species-appropriate. Deadwood potential is moderate.",
                    "Potential features include natural dead branches, weathered branch remnants and subtle jin where visually appropriate.",
                    "Avoid applying dramatic juniper-style carving without regard to the species.",
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
                    "Trunk development is slow and requires patience.",
                    "Where additional development is required: retain selected leaders, allow useful extension, provide sufficient root space and avoid premature confinement.",
                    "Development should support taper, natural proportions, trunk strength and believable mature character.",
                    "Once sufficient trunk development exists, shift focus toward primary branch structure, secondary branching, ramification and refinement.",
                ]
            ),
            SpeciesProfileSection(
                id: "nebari-development",
                title: "Nebari Development",
                paragraphs: [
                    "Nebari development should be gradual.",
                    "Potential approaches include early root planning, staged root correction, appropriate development containers and progressive refinement.",
                    "The objective is: Stable anchoring · Natural base · Healthy roots.",
                ]
            ),
            SpeciesProfileSection(
                id: "propagation",
                title: "Propagation",
                paragraphs: [
                    "Abies koreana may be propagated through established horticultural methods where appropriate.",
                    "Detailed procedures belong in Bonsai World Propagation Knowledge Articles.",
                ]
            ),
            SpeciesProfileSection(
                id: "pests",
                title: "Pests and Problems",
                paragraphs: [
                    "Relevant risks may include aphids and other sap-feeding insects, scale insects, mites, fungal foliage problems, root problems caused by poor aeration, drought stress, excessive heat stress, winter desiccation and stress caused by excessive root or foliage removal.",
                    "Do not provide generic treatment instructions.",
                    "Diagnosis and treatment belong in Care → Pest Management and Care → Disease & Problems.",
                ]
            ),
            SpeciesProfileSection(
                id: "seasonal",
                title: "Seasonal Profile",
                paragraphs: [
                    "Spring: monitor bud development, new growth, foliage health, watering demand and root health. Coordinate structural work with local climate, growth stage and individual tree vigour. Avoid unnecessary simultaneous major stresses.",
                    "Summer: monitor watering demand, foliage health, heat stress, pest activity and wire marks. In hot conditions, monitor carefully for environmental stress. Strong healthy growth may be required for recovery, branch development or structural development.",
                    "Autumn is important for assessing overall vigour, reviewing branch structure, evaluating foliage health and preparing for winter. Avoid unnecessary late-season stress. Local climate determines timing.",
                    "Winter: Abies koreana requires outdoor winter dormancy.",
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
                    "Abies koreana is particularly suitable for Formal Upright, Informal Upright, Slanting, Naturalistic Bonsai, Mountain-inspired Bonsai and Forest Bonsai.",
                    "It is especially effective when styling emphasises refined proportions, natural branch hierarchy, compact evergreen foliage and restrained mountain character.",
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
                    "Abies koreana is an evergreen fir native to South Korea",
                    "Outdoor cultivation is required",
                    "Winter dormancy is required",
                    "It is not interchangeable with Picea species",
                    "Healthy foliage and viable buds should be preserved before major reduction",
                    "Do not strip branches bare",
                    "Do not assume old bare wood will reliably regenerate",
                    "Development is slow and requires patience",
                    "Root work should be conservative",
                    "Avoid combining major root work and major styling unnecessarily",
                    "Do not use defoliation techniques",
                    "Mature branches can become rigid and difficult to bend",
                    "Avoid prolonged drought",
                    "Avoid excessive heat stress",
                    "Shallow roots require protection during prolonged severe freezing",
                    "Winter desiccation can be a risk in exposed conditions",
                ]
            ),
        ]
    }
}
