//
//  AbiesNordmannianaSpeciesProfile.swift
//  Bonsai World
//
//  Species Profile — Abies nordmanniana (Nordmann Fir).
//  Independent botanical species in Pinaceae. Knowledge status: Reviewed.
//  Separate from Picea species. True firs (Abies) are not spruce (Picea).
//

import Foundation

enum AbiesNordmannianaSpeciesProfile {
    /// Identity used by Botanical Library / ``SpeciesPreviewData``.
    static let botanicalLibraryName = "Abies nordmanniana"
    /// Scientific name for Species Profile display (binomial; no botanical authority).
    static let scientificName = "Abies nordmanniana"

    static var profile: SpeciesProfile {
        SpeciesProfile(
            speciesID: BotanicalKnowledgeIDs.abiesNordmanniana,
            scientificName: scientificName,
            commonNames: ["Nordmann Fir", "Caucasian Fir"],
            family: "Pinaceae",
            plantType: "Evergreen conifer",
            originSummary: "The Caucasus Mountains and neighbouring regions around the eastern Black Sea.",
            knowledgeStatus: .reviewed,
            traits: traits,
            foliageSizeLabel: "Foliage",
            foliageReductionLabel: "Needle reduction",
            summaryLine: "Evergreen · Conifer · Mountain species · Dark green flat needles · Strong natural structure · Slow bonsai development · Mature forest character · Outdoor cultivation required",
            attentionHighlights: [
                "Abies nordmanniana is an evergreen fir from the Caucasus region",
                "Outdoor cultivation is required",
                "Winter dormancy is required",
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
            The primary operational rule is: Preserve healthy foliage and viable buds before major reduction.

            Do not assume that completely bare old wood will reliably regenerate useful replacement growth.

            Before removing branches or major sections: identify viable buds, identify retained foliage, identify replacement options and assess the health and vigour of the tree.

            Major work should be staged where necessary.

            Avoid combining multiple major stresses without a clear reason.

            The objective is: Healthy roots · Preserved foliage · Controlled vigour · Natural structure · Long-term development.

            The individual tree must always be assessed according to climate, tree condition, vigour, development stage and winter temperatures.
            """,
            sourcesNote: """
            Profile content is synthesised from recognised botanical, horticultural and bonsai authorities into Bonsai World editorial language.

            Botanical taxonomy and distribution draw on recognised sources such as Royal Botanic Gardens, Kew, Plants of the World Online, recognised Caucasus and European botanical institutions and recognised forestry institutions for accepted scientific name, family and native range.

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
        leafSize: "Evergreen · Flat needles",
        foliageReduction: "Not applicable",
        ramificationPotential: "Moderate",
        backBudding: "Limited to Moderate — strongest where viable buds and healthy foliage are retained",
        rootDevelopment: "Moderate",
        nebariPotential: "Moderate potential",
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
                    "Abies nordmanniana is an independent botanical species in the pine family (Pinaceae).",
                    "Primary Bonsai World display identity: Abies nordmanniana · Nordmann Fir.",
                    "Caucasian Fir may be listed as an alternative common name where useful. It does not replace Nordmann Fir as the preferred English common name.",
                    "Family: Pinaceae. Plant type: evergreen conifer.",
                    "Native range: The Caucasus Mountains and neighbouring regions around the eastern Black Sea.",
                    "Do not confuse Abies nordmanniana with Picea species. Do not confuse true firs in the genus Abies with spruce in the genus Picea.",
                    "Bonsai World hierarchy: Species → cultivar / horticultural selection → Individual Tree.",
                ]
            ),
            SpeciesProfileSection(
                id: "overview",
                title: "Species Overview",
                paragraphs: [
                    "Abies nordmanniana is a large evergreen fir native primarily to mountainous regions of the Caucasus and areas surrounding the eastern Black Sea.",
                    "It is known for dense dark green foliage, relatively broad flat needles, strong formal natural structure, long-lived mature trees and impressive mature forest character.",
                    "For bonsai, it should be considered a specialist conifer.",
                    "Its greatest potential lies in patient long-term development, mature naturalistic design, mountain and forest character, strong trunk proportions and refined evergreen branch structure.",
                    "It is not a fast bonsai species. Avoid forcing rapid refinement.",
                    "The objective is: Healthy roots · Preserved foliage · Controlled vigour · Natural structure · Long-term development.",
                ],
                bullets: [
                    "Evergreen conifer",
                    "Native to the Caucasus region",
                    "Strong association with mountain forests",
                    "Flat dark green needles",
                    "Slow to moderate growth",
                    "Moderate ramification potential",
                    "Limited to moderate back-budding",
                    "Mature trees develop strong forest character",
                    "Outdoor cultivation required",
                    "Winter dormancy required",
                    "Specialist species for patient bonsai development",
                ]
            ),
            SpeciesProfileSection(
                id: "cultivars",
                title: "Cultivars and Forms",
                paragraphs: [
                    "Abies nordmanniana is primarily used in bonsai as the botanical species.",
                    "Horticultural selections may differ in growth habit, needle density and compactness.",
                    "Do not create unnecessary separate Species Library profiles for minor individual variation.",
                    "The primary Species Profile remains Abies nordmanniana.",
                    "Only create separate profiles where a distinct cultivar or form has a clear and established independent bonsai identity.",
                ]
            ),
            SpeciesProfileSection(
                id: "natural-growth",
                title: "Natural Growth and Vigour",
                paragraphs: [
                    "Abies nordmanniana generally develops slowly to moderately.",
                    "Healthy growth depends on healthy roots, sufficient light, stable moisture, well-aerated substrate, balanced nutrition and avoidance of repeated unnecessary stress.",
                    "During development: allow useful growth to extend where required for trunk development, branch thickening, recovery or future branch structure.",
                    "Avoid restricting all growth prematurely.",
                    "The objective is: Stable vigour · Useful extension · Progressive development.",
                ]
            ),
            SpeciesProfileSection(
                id: "foliage",
                title: "Foliage",
                paragraphs: [
                    "Abies nordmanniana has dark green, flat evergreen needles.",
                    "Healthy foliage is essential for energy production, recovery, branch development and future refinement.",
                    "Do not strip branches bare, remove all useful foliage from sections intended to remain alive, or assume old bare wood will reliably produce new useful growth.",
                    "Foliage management should focus on shoot selection, selective reduction, preservation of useful interior growth and maintaining balanced vigour.",
                    "Avoid producing dense outer foliage while allowing the interior structure to weaken.",
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
                    "Abies nordmanniana produces upright cones.",
                    "Upright cones are a botanical character of true firs and help distinguish Abies from Picea, which typically produce hanging cones.",
                    "Cones may contribute to seasonal character but are not a primary bonsai design objective.",
                    "Do not sacrifice structural development or foliage health in pursuit of cones.",
                ]
            ),
            SpeciesProfileSection(
                id: "bark-trunk",
                title: "Bark and Trunk",
                paragraphs: [
                    "Mature Abies nordmanniana can develop strong trunk and bark character. Mature bark character is good.",
                    "Trunk development should focus on believable taper, natural proportions, structural strength and mature forest-tree character.",
                    "Trunk development is slow.",
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
                    "Abies nordmanniana should be cultivated outdoors.",
                    "Provide strong light while adapting placement to local climate, summer temperatures, humidity, tree health and development stage.",
                    "In unusually hot or dry conditions, monitor carefully for environmental stress.",
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
                    "Abies nordmanniana should not be treated as a drought-tolerant species.",
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
                    "Back-budding is limited to moderate and strongest where viable buds and healthy foliage are retained.",
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
                    "Useful methods include healthy growth cycles, selective shoot management, careful pruning and wiring where appropriate.",
                    "Avoid excessive repeated cutting, removing useful interior growth and forcing dense refinement before the branch structure is established.",
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
                    "Deadwood should generally be restrained. Deadwood potential is moderate.",
                    "Potential features include natural dead branches, weathered branch remnants and subtle jin where appropriate.",
                    "Avoid applying dramatic juniper-style carving.",
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
                    "Development should support taper, natural proportions, trunk strength and mature forest character.",
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
                    "Abies nordmanniana may be propagated through established horticultural methods where appropriate.",
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
                    "Summer: monitor watering demand, foliage health, heat stress, pest activity and wire marks. In hot or dry conditions, monitor carefully for environmental stress. Strong healthy growth may be required for recovery, branch development or structural development.",
                    "Autumn is important for assessing overall vigour, reviewing branch structure, evaluating foliage health and preparing for winter. Avoid unnecessary late-season stress. Local climate determines timing.",
                    "Winter: Abies nordmanniana requires outdoor winter dormancy.",
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
                    "Abies nordmanniana is particularly suitable for Formal Upright, Informal Upright, Slanting, Naturalistic Bonsai, Mountain-inspired Bonsai and Forest Bonsai.",
                    "It is especially effective when styling emphasises strong vertical structure, natural branch hierarchy, mature forest character and restrained natural asymmetry.",
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
                    "Abies nordmanniana is an evergreen fir from the Caucasus region",
                    "Outdoor cultivation is required",
                    "Winter dormancy is required",
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
