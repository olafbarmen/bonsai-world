//
//  AbiesAlbaSpeciesProfile.swift
//  Bonsai World
//
//  Species Profile — Abies alba (European Silver Fir).
//  Independent botanical species in Pinaceae. Knowledge status: Reviewed.
//  Separate from Picea species. True firs (Abies) are not spruce (Picea).
//

import Foundation

enum AbiesAlbaSpeciesProfile {
    /// Identity used by Botanical Library / ``SpeciesPreviewData``.
    static let botanicalLibraryName = "Abies alba"
    /// Scientific name for Species Profile display (binomial; no botanical authority).
    static let scientificName = "Abies alba"

    static var profile: SpeciesProfile {
        SpeciesProfile(
            speciesID: BotanicalKnowledgeIDs.abiesAlba,
            scientificName: scientificName,
            commonNames: ["European Silver Fir", "Silver Fir", "Common Silver Fir"],
            family: "Pinaceae",
            plantType: "Evergreen conifer",
            originSummary: "Central and southern Europe, particularly mountainous regions.",
            knowledgeStatus: .reviewed,
            traits: traits,
            foliageSizeLabel: "Foliage",
            foliageReductionLabel: "Needle reduction",
            summaryLine: "Evergreen · Conifer · Hardy · Mountain species · Soft flat needles · Strong vertical growth · Slow bonsai refinement · Mature bark character · Suitable for naturalistic and mountain-style bonsai · Outdoor cultivation required",
            attentionHighlights: [
                "Abies alba is an evergreen European fir",
                "Outdoor cultivation is required",
                "Winter dormancy is required",
                "It is not interchangeable with Picea species",
                "It is not a drought-tolerant juniper",
                "Healthy foliage and viable buds should be preserved before major reduction",
                "Do not strip branches bare",
                "Do not assume old bare wood will reliably regenerate",
                "Development is generally slow and requires patience",
                "Root work should be conservative",
                "Avoid combining major root work and major styling unnecessarily",
                "Do not use defoliation techniques",
                "Mature branches can become rigid and difficult to bend",
                "Avoid excessive heat and drought stress",
                "Shallow roots require protection during prolonged severe freezing",
                "Winter desiccation can be a risk in exposed conditions",
            ],
            sections: sections,
            principleNote: """
            Abies alba should be developed conservatively.

            It is not a species for repeated aggressive bonsai intervention.

            The most important operational principle is: Preserve healthy foliage and viable buds before reducing structural growth.

            Future development should not depend on the assumption that bare old wood will reliably produce replacement growth.

            Major work should be planned carefully and staged when necessary.

            The objective is: Healthy roots · Preserved foliage · Controlled vigour · Natural branch structure · Long-term development.

            The individual tree must always be assessed according to climate, tree condition, vigour, development stage and winter temperatures.
            """,
            sourcesNote: """
            Profile content is synthesised from recognised botanical, horticultural and bonsai authorities into Bonsai World editorial language.

            Botanical taxonomy and distribution draw on recognised sources such as Royal Botanic Gardens, Kew, Plants of the World Online, recognised European botanical institutions and recognised forestry institutions for accepted scientific name, family and native range.

            Horticultural context may draw on recognised horticultural institutions and authoritative Abies references.

            Bonsai-specific cultivation and refinement knowledge draws on established bonsai references and recognised professional practice with conifer experience, kept distinct from Picea species and from drought-tolerant juniper management.

            Verified botanical information, horticultural information, regional climate adaptation and bonsai-specific practice are kept distinct. Do not copy source wording.
            """
        )
    }

    private static let traits = SpeciesProfileTraits(
        deciduous: false,
        growthStrength: "Moderate",
        growthSpeed: "Slow to Moderate",
        leafSize: "Evergreen · Flat needles",
        foliageReduction: "Not applicable",
        ramificationPotential: "Moderate",
        backBudding: "Limited to Moderate — strongest where healthy foliage and viable buds are retained",
        rootDevelopment: "Moderate",
        nebariPotential: "Moderate to Good potential",
        trunkDevelopment: "Slow",
        barkDevelopment: "Excellent on mature material",
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
                    "Abies alba is an independent botanical species in the pine family (Pinaceae).",
                    "Primary Bonsai World display identity: Abies alba · European Silver Fir.",
                    "Silver Fir and Common Silver Fir may be listed as alternative common names where useful. They do not replace European Silver Fir as the preferred English common name.",
                    "Family: Pinaceae. Plant type: evergreen conifer.",
                    "Native range: Central and southern Europe, particularly mountainous regions.",
                    "Do not confuse Abies alba with Picea species. Do not confuse true firs in the genus Abies with spruce in the genus Picea.",
                    "Bonsai World hierarchy: Species → cultivar / horticultural selection → Individual Tree.",
                ]
            ),
            SpeciesProfileSection(
                id: "overview",
                title: "Species Overview",
                paragraphs: [
                    "Abies alba is a large evergreen fir native to mountainous regions of Europe.",
                    "Abies alba is particularly relevant to Bonsai World because it is one of Europe's most important native fir species, it is relevant to mountain and forest bonsai traditions, mature material can develop impressive natural character, it offers a different foliage and branch character from spruce and pine and it is of particular interest to European and Nordic bonsai enthusiasts.",
                    "Abies alba should be presented as a specialist but important European conifer rather than a fast or easy bonsai species.",
                    "In bonsai, it is valued primarily for its distinctly European mountain character, soft flat needles, mature bark, formal and naturalistic branch structure and suitability for mountain and forest-inspired compositions.",
                    "It is generally slower and more specialised in bonsai cultivation than many commonly used junipers or pines.",
                    "Development should prioritise long-term health, root stability, branch selection, preservation of useful buds and foliage and gradual structural refinement. Avoid forcing rapid results.",
                ],
                bullets: [
                    "Evergreen conifer",
                    "Native to Europe",
                    "Strong association with mountainous regions",
                    "Flat needles",
                    "Needles arranged distinctly along the shoot",
                    "Mature bark can develop strong character",
                    "Slow to moderate growth",
                    "Moderate ramification potential",
                    "Back-budding is limited and dependent on retained healthy growth",
                    "Outdoor cultivation required",
                    "Winter dormancy required",
                    "Specialist species for patient bonsai development",
                ]
            ),
            SpeciesProfileSection(
                id: "cultivars",
                title: "Cultivars and Forms",
                paragraphs: [
                    "Abies alba is primarily used in bonsai as the botanical species.",
                    "Horticultural selections may differ in growth habit, needle character and compactness.",
                    "Do not create unnecessary separate Species Library profiles for minor individual variation.",
                    "The primary Species Profile remains Abies alba.",
                    "Only create separate profiles where a distinct cultivar or form has a clear and established independent bonsai identity.",
                ]
            ),
            SpeciesProfileSection(
                id: "natural-growth",
                title: "Natural Growth and Vigour",
                paragraphs: [
                    "Abies alba generally requires stable conditions and patient development.",
                    "Healthy growth depends on healthy roots, appropriate light, sufficient moisture, well-aerated substrate, balanced nutrition and protection from unnecessary repeated stress.",
                    "During development: allow useful extension where required for trunk development, branch thickening, recovery or future structure.",
                    "Avoid continuously restricting growth when the tree still requires development.",
                    "The objective is: Stable vigour · Useful extension · Progressive structure.",
                ]
            ),
            SpeciesProfileSection(
                id: "foliage",
                title: "Foliage",
                paragraphs: [
                    "Abies alba has flat evergreen needles.",
                    "Healthy foliage is essential for energy production, recovery, branch development and future refinement.",
                    "Do not strip branches bare, remove all useful foliage from sections intended to remain alive, or assume old bare wood will reliably regenerate.",
                    "Foliage management should focus on shoot selection, controlled reduction, preservation of healthy interior growth and maintaining balanced vigour.",
                    "Avoid creating an overly dense outer foliage shell with weak interiors.",
                    "The objective is: Healthy foliage · Clear branch structure · Sustainable development.",
                ]
            ),
            SpeciesProfileSection(
                id: "flowering",
                title: "Flowering",
                paragraphs: [
                    "Flowering is not applicable as a bonsai feature.",
                    "Do not treat flowering as a styling priority.",
                ]
            ),
            SpeciesProfileSection(
                id: "fruit",
                title: "Cones",
                paragraphs: [
                    "Abies alba produces upright cones.",
                    "Upright cones are a botanical character of true firs and help distinguish Abies from Picea, which typically produce hanging cones.",
                    "Cones may contribute to seasonal character but are not a primary bonsai design objective.",
                    "Do not sacrifice structural development or foliage health in pursuit of cones.",
                ]
            ),
            SpeciesProfileSection(
                id: "bark-trunk",
                title: "Bark and Trunk",
                paragraphs: [
                    "Mature Abies alba can develop strong trunk and bark character. Mature bark character is excellent on mature material.",
                    "Important qualities include vertical strength, mature texture, forest-tree proportions and natural taper.",
                    "Trunk development is slow.",
                    "Where development is still required: retain useful leaders, allow selected growth to extend, provide adequate root space and avoid premature confinement.",
                    "The objective is: Natural maturity · Strong taper · Believable proportions.",
                ]
            ),
            SpeciesProfileSection(
                id: "roots-nebari",
                title: "Roots and Nebari",
                paragraphs: [
                    "Healthy roots are critical for stable Abies development.",
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
                    "Abies alba should be cultivated outdoors.",
                    "Provide strong light while recognising that environmental conditions vary.",
                    "Light requirements depend on local climate, summer temperatures, humidity, tree health and development stage.",
                    "In very hot conditions, environmental stress may require protection from excessive heat.",
                    "Do not recommend permanent indoor cultivation.",
                ]
            ),
            SpeciesProfileSection(
                id: "wind",
                title: "Wind",
                paragraphs: [
                    "Moderate air movement is beneficial.",
                    "However, exposed conditions can increase moisture loss, foliage stress and winter desiccation.",
                    "Monitor trees carefully in exposed gardens, dry winds and severe winter conditions.",
                ]
            ),
            SpeciesProfileSection(
                id: "watering",
                title: "Watering",
                paragraphs: [
                    "General principle: Maintain consistent root moisture · Avoid prolonged drought · Avoid permanently saturated roots · Maintain healthy root aeration.",
                    "Water demand is moderate to high depending on temperature and conditions.",
                    "Abies alba should not be treated as a drought-tolerant juniper.",
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
                    "Avoid excessive fertilization that produces overly coarse growth, imbalance or unnecessary stress through excessive vigour.",
                    "Key principle: Feed according to tree health and development objective.",
                ]
            ),
            SpeciesProfileSection(
                id: "pruning",
                title: "Pruning",
                paragraphs: [
                    "Pruning must be planned around retained buds, retained foliage, branch age, future structure and tree vigour. Pruning response is moderate to advanced; timing and retained growth are important.",
                    "Before removing major sections: identify future replacement growth, retain viable options and avoid unnecessary irreversible cuts.",
                    "The objective is: Controlled structure · Preserved growth options · Long-term development.",
                ]
            ),
            SpeciesProfileSection(
                id: "back-budding",
                title: "Back-budding",
                paragraphs: [
                    "Back-budding is limited to moderate and strongest where healthy foliage and viable buds are retained.",
                    "Back-budding should not be treated as guaranteed.",
                    "Response depends on tree health, vigour, retained foliage, retained buds, branch age and light availability.",
                    "Before structural reduction: identify viable buds, retain useful foliage and maintain replacement options.",
                    "The objective is: Preserve future growth before making irreversible cuts.",
                ]
            ),
            SpeciesProfileSection(
                id: "ramification",
                title: "Ramification",
                paragraphs: [
                    "Ramification should be developed gradually. Ramification potential is moderate.",
                    "Useful methods include controlled shoot selection, selective pruning, wiring where appropriate and repeated healthy growth cycles.",
                    "Avoid excessive repeated cutting, removing useful interior growth and forcing refinement before sufficient branch structure exists.",
                    "The objective is: Natural branch hierarchy · Balanced vigour · Sustainable ramification.",
                ]
            ),
            SpeciesProfileSection(
                id: "wiring",
                title: "Wiring",
                paragraphs: [
                    "Wiring can be used for branch positioning, structural development and directional refinement. Wiring response is moderate.",
                    "Before wiring, assess branch flexibility, branch age, wood stiffness, bark sensitivity and tree health.",
                    "Avoid forcing mature rigid branches.",
                    "Monitor wire carefully.",
                    "The objective is: Natural branch placement · Safe development · Preserved bark.",
                ]
            ),
            SpeciesProfileSection(
                id: "deadwood-potential",
                title: "Deadwood",
                paragraphs: [
                    "Deadwood should generally be used conservatively. Deadwood potential is moderate.",
                    "Potential features include natural dead branches, weathered branch remnants and restrained jin where botanically and visually appropriate.",
                    "Avoid applying dramatic juniper-style deadwood indiscriminately.",
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
                    "Trunk development in Abies alba is slow and requires patience.",
                    "Where additional development is required: retain selected leaders, allow useful extension, provide sufficient root space and avoid premature confinement.",
                    "Development should support taper, natural proportions, mature bark and believable forest-tree character.",
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
                    "Abies alba may be propagated through established horticultural methods where appropriate.",
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
                    "Summer: monitor watering demand, foliage health, heat stress, pest activity and wire marks. In hot or dry conditions, monitor carefully for environmental stress. Strong growth may be required for recovery, branch development or structural development.",
                    "Autumn is important for assessing overall vigour, reviewing branch structure, evaluating foliage health and preparing for winter. Avoid unnecessary late-season stress. Local climate determines timing.",
                    "Winter: Abies alba requires outdoor winter dormancy.",
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
                    "Abies alba is particularly suitable for Formal Upright, Informal Upright, Slanting, Naturalistic Bonsai, Mountain-inspired Bonsai and Forest Bonsai.",
                    "It is especially effective when styling emphasises strong vertical structure, natural branch hierarchy, mature forest character and restrained natural asymmetry.",
                    "The individual material should determine the final design.",
                ]
            ),
            SpeciesProfileSection(
                id: "tree-stage",
                title: "Development by Tree Stage",
                paragraphs: [
                    "Young material: establish healthy roots, develop trunk movement and taper where appropriate, build useful branches and preserve future options.",
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
                    "Abies alba is an evergreen European fir",
                    "Outdoor cultivation is required",
                    "Winter dormancy is required",
                    "It is not interchangeable with Picea species",
                    "It is not a drought-tolerant juniper",
                    "Healthy foliage and viable buds should be preserved before major reduction",
                    "Do not strip branches bare",
                    "Do not assume old bare wood will reliably regenerate",
                    "Development is generally slow and requires patience",
                    "Root work should be conservative",
                    "Avoid combining major root work and major styling unnecessarily",
                    "Do not use defoliation techniques",
                    "Mature branches can become rigid and difficult to bend",
                    "Avoid excessive heat and drought stress",
                    "Shallow roots require protection during prolonged severe freezing",
                    "Winter desiccation can be a risk in exposed conditions",
                ]
            ),
        ]
    }
}
