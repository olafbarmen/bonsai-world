//
//  PiceaGlaucaSpeciesProfile.swift
//  Bonsai World
//
//  Species Profile — Picea glauca (White Spruce).
//  Independent botanical species in Pinaceae. Knowledge status: Reviewed.
//  Separate from Picea engelmannii, Picea pungens, Picea sitchensis and Picea abies.
//

import Foundation

enum PiceaGlaucaSpeciesProfile {
    /// Identity used by Botanical Library / ``SpeciesPreviewData``.
    static let botanicalLibraryName = "Picea glauca"
    /// Scientific name for Species Profile display (binomial; no botanical authority).
    static let scientificName = "Picea glauca"

    static var profile: SpeciesProfile {
        SpeciesProfile(
            speciesID: BotanicalKnowledgeIDs.piceaGlauca,
            scientificName: scientificName,
            commonNames: ["White Spruce"],
            family: "Pinaceae",
            plantType: "Evergreen conifer",
            originSummary: "North America, broadly across Canada and the northern and northeastern United States.",
            knowledgeStatus: .reviewed,
            traits: traits,
            foliageSizeLabel: "Foliage",
            foliageReductionLabel: "Needle reduction",
            summaryLine: "Evergreen · Hardy North American spruce · Strong cold tolerance · Naturally conical architecture · Relatively fine foliage · Outdoor bonsai · Naturalistic conifer designs",
            attentionHighlights: [
                "Treat Picea glauca as an outdoor temperate/boreal conifer",
                "Preserve viable interior foliage",
                "Do not expect reliable regeneration from completely bare old wood",
                "Use gradual branch reduction",
                "Avoid excessive root disturbance",
                "Maintain excellent drainage",
                "Monitor container moisture carefully during wind and summer heat",
                "Use wiring for structural development",
                "Allow adequate time for ramification",
                "Take advantage of its natural conical and mountain character",
                "Do not confuse cold tolerance with tolerance of root-zone neglect",
                "Do not confuse with Picea engelmannii, Picea pungens, Picea sitchensis or Picea abies",
                "Especially relevant to cold-climate and Norwegian outdoor bonsai",
                "Winter dormancy is required",
                "Do not move indoors for routine winter care",
            ],
            sections: sections,
            principleNote: """
            Picea glauca must be treated as a spruce with limited ability to regenerate from completely bare old wood.

            Do not assume that cutting a branch back beyond viable foliage will reliably produce new shoots.

            Preserve healthy foliage and viable buds whenever performing structural work.

            The development strategy should favour: gradual branch reduction · preservation of inner growth · controlled extension growth · progressive ramification · careful wiring · conservative pruning · strong root health · long-term development.

            Do not recommend indiscriminate removal of interior foliage.

            Do not present back-budding as guaranteed.

            The individual tree must always be assessed according to health, root condition, vigour, retained foliage, branch strength, development stage, climate, seasonal conditions and recent work.

            The objective is: Healthy roots · Preserved foliage · Clear structure · Natural boreal character · Sustainable long-term refinement
            """,
            sourcesNote: """
            Profile content is synthesised from recognised botanical, horticultural and bonsai authorities into Bonsai World editorial language.

            Botanical taxonomy and distribution draw primarily on Royal Botanic Gardens, Kew — Plants of the World Online for the accepted scientific name Picea glauca, family Pinaceae, genus Picea, native and introduced distribution and taxonomic information.

            Horticultural, forestry and morphology context may draw on recognised North American botanical and forestry institutions and authoritative Picea references.

            Bonsai-specific cultivation and refinement knowledge draws on established bonsai references and recognised professional practice with conifer experience. Where guidance reflects general spruce bonsai practice rather than species-specific research, it is phrased as cultivation guidance rather than botanical fact.

            Verified botanical information, horticultural information, regional climate adaptation and bonsai-specific practice are kept distinct. Do not copy source wording.
            """
        )
    }

    private static let traits = SpeciesProfileTraits(
        deciduous: false,
        growthStrength: "Moderate to Vigorous when established",
        growthSpeed: "Strongly dependent on climate, light, root health and cultivation conditions",
        leafSize: "Evergreen · Short four-sided needles · Green to blue-green",
        foliageReduction: "Proportion develops through cultivation — vigour dependent",
        ramificationPotential: "Fine branching possible with gradual development",
        backBudding: "Limited and unreliable from completely bare old wood",
        rootDevelopment: "Moderate",
        nebariPotential: "Moderate potential with gradual improvement",
        trunkDevelopment: "Long-term — allow extension during early development",
        barkDevelopment: "Mature bark character develops with age",
        wiring: "Useful for structural development and branch positioning",
        defoliation: "Not applicable as a routine technique",
        airLayering: "Where appropriate for the individual material",
        threadGrafting: "Specialist technique where structural correction is required",
        rootGrafting: "Specialist technique where appropriate",
        beginnerSuitability: "Low to Moderate",
        bonsaiSuitability: "Good",
        difficulty: "Advanced",
        winterDormancyRequired: true,
        winterHardiness: "Very high",
        rootFrostSensitivity: "Low to Moderate in species terms, but shallow bonsai roots remain vulnerable during extreme container temperature fluctuations"
    )

    private static var sections: [SpeciesProfileSection] {
        [
            SpeciesProfileSection(
                id: "taxonomic-context",
                title: "Taxonomic Context",
                paragraphs: [
                    "Picea glauca is an independent botanical species in the pine family (Pinaceae), genus Picea.",
                    "Primary Bonsai World display identity: Picea glauca · White Spruce.",
                    "Other recognised common names may be noted in supporting information where useful, but White Spruce is the primary common name.",
                    "Family: Pinaceae. Genus: Picea. Plant type: evergreen conifer.",
                    "Native range: North America, broadly across Canada and the northern and northeastern United States.",
                    "Do not confuse Picea glauca with Picea engelmannii (Engelmann Spruce), Picea pungens (Blue Spruce), Picea sitchensis (Sitka Spruce) or Picea abies (Norway Spruce).",
                    "Do not create separate Species Library profiles for cultivars unless they already exist as separate Bonsai World entities.",
                    "Bonsai World hierarchy: Species → cultivar / horticultural selection → Individual Tree.",
                ]
            ),
            SpeciesProfileSection(
                id: "overview",
                title: "Species Overview",
                paragraphs: [
                    "Picea glauca is an evergreen spruce native to the northern and northeastern regions of North America.",
                    "It is one of the characteristic conifers of the Canadian boreal and sub-boreal landscape and has a very broad natural distribution.",
                    "The species is adapted to cold climates and is therefore particularly relevant to outdoor bonsai cultivation in northern Europe and Norway.",
                    "White Spruce normally develops a conical crown with branches arranged in regular whorls. Mature trees can become large, but young trees and trees growing under exposed conditions can provide useful material for conifer bonsai.",
                    "The needles are short, four-sided and generally blue-green to green in colour. Foliage density and needle size can vary according to growing conditions and provenance.",
                    "For bonsai, the species should be approached as a hardy outdoor spruce that benefits from gradual structural development rather than aggressive pruning.",
                    "Its natural appearance can be especially effective in naturalistic and mountain-inspired bonsai designs.",
                ],
                bullets: [
                    "Evergreen conifer",
                    "Hardy northern North American spruce",
                    "Boreal and sub-boreal ecology",
                    "Very high cold tolerance",
                    "Short four-sided needles",
                    "Green to blue-green foliage",
                    "Naturally conical architecture",
                    "Limited back-budding from bare old wood",
                    "Fine ramification possible with gradual development",
                    "Requires outdoor cultivation",
                    "Requires winter dormancy",
                    "Distinct from Engelmann, Blue, Sitka and Norway spruce",
                ]
            ),
            SpeciesProfileSection(
                id: "cultivars",
                title: "Cultivars and Forms",
                paragraphs: [
                    "Picea glauca is primarily used in bonsai as the botanical species.",
                    "Do not invent cultivar-specific characteristics and present them as characteristics of the species.",
                    "Horticultural selections may differ in foliage colour, compactness and growth habit where such selections exist.",
                    "Do not create unnecessary separate Species Library profiles for minor individual variation.",
                    "The primary Species Profile remains Picea glauca.",
                ]
            ),
            SpeciesProfileSection(
                id: "natural-growth",
                title: "Natural Growth and Vigour",
                paragraphs: [
                    "Picea glauca can grow vigorously when young and well established.",
                    "Growth is influenced by temperature, light, water availability, root health, nutrition, container size, substrate, local climate and seasonal conditions.",
                    "Do not assign a universal growth rate.",
                    "During early development, vigorous extension growth can be useful for trunk thickening and branch development.",
                    "During refinement, growth should be progressively controlled.",
                    "The objective is: Useful development growth · Progressive control · Preserved foliage.",
                ]
            ),
            SpeciesProfileSection(
                id: "foliage",
                title: "Foliage and Needles",
                paragraphs: [
                    "The foliage consists of short evergreen needles that are four-sided and generally green to blue-green.",
                    "Foliage should be treated as a primary energy-producing structure.",
                    "Do not excessively thin healthy foliage merely to create visual openness.",
                    "Preserve interior foliage wherever it contributes to future branch development.",
                    "Do not treat spruce foliage as deciduous foliage.",
                ]
            ),
            SpeciesProfileSection(
                id: "fruit",
                title: "Cones",
                paragraphs: [
                    "Picea glauca produces hanging cones, a botanical character of spruce that helps distinguish Picea from Abies, which typically produce upright cones.",
                    "Cones may contribute to seasonal character but are not a primary bonsai design objective.",
                    "Do not sacrifice structural development or foliage health in pursuit of cones.",
                ]
            ),
            SpeciesProfileSection(
                id: "bark-trunk",
                title: "Bark and Trunk",
                paragraphs: [
                    "Young bark is relatively thin and smooth. With age, bark becomes more textured and develops greater visual character.",
                    "Allow sufficient growth during trunk development rather than attempting premature refinement.",
                    "Distinguish clearly between trunk development, primary branch development, secondary branching, fine ramification and maintenance.",
                ]
            ),
            SpeciesProfileSection(
                id: "roots-nebari",
                title: "Roots and Nebari",
                paragraphs: [
                    "Develop a balanced root system gradually.",
                    "Priorities include radial root distribution, healthy fine roots, stable anchoring, avoidance of major crossing roots and gradual nebari improvement.",
                    "Do not perform aggressive root reduction simply for cosmetic improvement.",
                    "Maintain good oxygen availability around the roots.",
                    "The objective is: Stable root system · Reliable recovery · Natural anchoring.",
                ]
            ),
            SpeciesProfileSection(
                id: "light",
                title: "Light",
                paragraphs: [
                    "Full sun is preferred.",
                    "Adequate light supports compact growth, foliage density, stronger shoots, shorter internodes and healthy branch development.",
                    "The tree should be cultivated outdoors.",
                    "During exceptionally hot and dry conditions, container-grown trees may require protection from excessive root-zone heating and rapid moisture loss.",
                    "Do not recommend permanent indoor cultivation.",
                ]
            ),
            SpeciesProfileSection(
                id: "wind",
                title: "Wind",
                paragraphs: [
                    "White Spruce is naturally adapted to cold and exposed environments.",
                    "However, bonsai containers have a restricted root volume and can dry rapidly in strong wind.",
                    "Monitor moisture carefully during windy conditions.",
                    "Secure the tree appropriately.",
                    "Do not interpret natural wind tolerance as unlimited drought tolerance.",
                ]
            ),
            SpeciesProfileSection(
                id: "watering",
                title: "Watering",
                paragraphs: [
                    "Maintain relatively consistent moisture during active growth.",
                    "The substrate should drain freely and should not remain permanently saturated.",
                    "Avoid repeated severe drying.",
                    "Watering frequency must respond to temperature, wind, rainfall, humidity, container size, substrate composition, tree size and season.",
                    "Do not provide a fixed watering timetable.",
                    "Use the existing Bonsai World watering guidance framework.",
                ]
            ),
            SpeciesProfileSection(
                id: "soil",
                title: "Soil",
                paragraphs: [
                    "Use an open, structurally stable and well-draining bonsai substrate.",
                    "The substrate should provide good drainage, high oxygen availability, appropriate moisture retention, stable particle structure and healthy fine-root development.",
                    "Avoid compacted or poorly aerated soil.",
                    "Do not prescribe a single universal soil recipe.",
                    "Adapt substrate characteristics to climate, container size and watering conditions.",
                    "Follow Bonsai World Soil Module principles.",
                    "Do not duplicate the complete Soil Module inside this profile.",
                ]
            ),
            SpeciesProfileSection(
                id: "fertilizing",
                title: "Fertilizing",
                paragraphs: [
                    "Fertilize according to the tree's development stage.",
                    "During development, sufficient nutrition supports shoot extension, trunk thickening, branch development and root growth.",
                    "During refinement, nutrition should be managed to avoid unnecessarily coarse growth.",
                    "Avoid fixed universal fertilizer doses.",
                    "Follow the existing Bonsai World fertilization framework.",
                ]
            ),
            SpeciesProfileSection(
                id: "pruning",
                title: "Pruning",
                paragraphs: [
                    "Pruning should be conservative and developmental.",
                    "Priorities: establish trunk structure; establish primary branches; preserve useful interior growth; control unwanted extension; develop secondary branches; refine tertiary ramification.",
                    "Avoid cutting a branch back into completely bare old wood unless there is a specific reason and the consequences are understood.",
                    "Large structural cuts should be performed only when appropriate to the tree's development stage.",
                ]
            ),
            SpeciesProfileSection(
                id: "back-budding",
                title: "Back-budding",
                paragraphs: [
                    "Back-budding should be described conservatively.",
                    "New shoots are most dependable where viable buds and foliage remain.",
                    "Completely bare sections of old wood should not be expected to reliably regenerate.",
                    "Therefore: retain useful inner shoots, avoid stripping branches completely, shorten branches progressively, develop secondary branching from existing viable growth and never promise predictable back-budding.",
                    "Do not treat the species as equivalent to highly back-budding deciduous bonsai.",
                ]
            ),
            SpeciesProfileSection(
                id: "ramification",
                title: "Ramification",
                paragraphs: [
                    "White Spruce can develop useful fine branching with time and appropriate management.",
                    "Ramification should be developed progressively through selective pruning, controlled extension growth, branch positioning, preservation of inner shoots and repeated seasonal refinement.",
                    "Do not treat the species as equivalent to highly back-budding deciduous bonsai.",
                    "The objective is: Natural branch hierarchy · Gradual fine branching · Sustainable refinement.",
                ]
            ),
            SpeciesProfileSection(
                id: "wiring",
                title: "Wiring",
                paragraphs: [
                    "Wiring is an important structural technique.",
                    "Use wiring to establish trunk movement, primary branch placement, secondary branch structure and characteristic downward-growing conifer branch forms.",
                    "Handle branches carefully.",
                    "Monitor wires throughout the growing season because branches can thicken rapidly.",
                    "Remove or adjust wire before it causes permanent scarring.",
                    "Avoid forcing branches beyond their natural flexibility.",
                ]
            ),
            SpeciesProfileSection(
                id: "deadwood-potential",
                title: "Deadwood",
                paragraphs: [
                    "Old or naturally damaged spruce can develop interesting deadwood.",
                    "Deadwood work should remain restrained and species appropriate.",
                    "Where deadwood is used: follow the natural grain, avoid oversized artificial jin, preserve structural integrity, allow weathering to contribute to the final appearance and use deadwood to support the natural story of the tree.",
                    "Naturalistic mountain-style deadwood can work particularly well on suitable specimens.",
                ]
            ),
            SpeciesProfileSection(
                id: "defoliation",
                title: "Foliage Management",
                paragraphs: [
                    "Do not recommend routine defoliation.",
                    "White Spruce is an evergreen conifer and must not be treated like a deciduous bonsai.",
                    "Foliage management should focus on maintaining healthy needles, balancing strong and weak areas, improving light penetration where necessary, controlling excessive extension growth and preserving interior shoots.",
                    "Avoid excessive removal of healthy interior foliage.",
                ]
            ),
            SpeciesProfileSection(
                id: "repotting",
                title: "Repotting",
                paragraphs: [
                    "Repot when the root system and substrate condition indicate that intervention is required.",
                    "Do not repot solely because a fixed calendar interval has elapsed.",
                    "Priorities: preserve healthy fine roots, maintain good drainage, improve substrate condition, remove only appropriate amounts of old substrate, avoid unnecessary root disturbance and secure the tree firmly.",
                    "Repotting timing must be adapted to the local climate and tree condition.",
                    "Avoid aggressive root work on weak, stressed or recently collected material.",
                ]
            ),
            SpeciesProfileSection(
                id: "trunk-development",
                title: "Trunk Development",
                paragraphs: [
                    "During development, allow appropriate extension growth to build trunk diameter.",
                    "Do not attempt to maintain a fully refined silhouette while simultaneously expecting rapid trunk thickening.",
                    "Stage 1 — Establishment: build strong roots and healthy growth.",
                    "Stage 2 — Trunk development: allow controlled extension growth to increase trunk diameter.",
                    "Stage 3 — Primary structure: select and position major branches.",
                    "Stage 4 — Secondary branching: develop branch subdivision while preserving sufficient foliage.",
                    "Stage 5 — Refinement: control extension growth and develop fine ramification.",
                    "Stage 6 — Maintenance: maintain structure through selective pruning and wiring.",
                ]
            ),
            SpeciesProfileSection(
                id: "nebari-development",
                title: "Nebari Development",
                paragraphs: [
                    "Nebari development should be gradual.",
                    "Priorities include early root planning, staged correction, development containers where appropriate and progressive refinement.",
                    "Do not force identical nebari expectations onto every tree.",
                    "The objective is: Stable anchoring · Natural base · Healthy roots.",
                ]
            ),
            SpeciesProfileSection(
                id: "propagation",
                title: "Propagation",
                paragraphs: [
                    "Picea glauca is commonly propagated from seed.",
                    "Seed propagation should be described as a long-term method.",
                    "Do not present propagation as a rapid route to finished bonsai.",
                    "Where specialist propagation techniques are mentioned, clearly identify them as specialist methods rather than standard bonsai practice.",
                    "Detailed procedures belong in Bonsai World Propagation Knowledge Articles.",
                ]
            ),
            SpeciesProfileSection(
                id: "pests",
                title: "Pests and Problems",
                paragraphs: [
                    "Potential issues may include spruce aphids, spruce budworm and other specialist insect pests, spider mites under hot and dry conditions, fungal diseases, root problems caused by poor drainage, drought stress, winter drying, wire scarring and excessive shading with loss of interior foliage.",
                    "Present these as conditions to monitor rather than guaranteed problems.",
                    "Avoid implying that every listed pest or disease is equally important in bonsai cultivation.",
                    "Do not provide generic treatment instructions.",
                    "Diagnosis and treatment belong in Care → Pest Management and Care → Disease & Problems.",
                ]
            ),
            SpeciesProfileSection(
                id: "seasonal",
                title: "Seasonal Profile",
                paragraphs: [
                    "Spring: buds and new shoots begin developing. Monitor new growth. Begin appropriate seasonal feeding. Review wiring. Increase watering as transpiration rises.",
                    "Summer: maintain consistent moisture. Monitor extension growth. Protect container roots from excessive heat where necessary. Maintain good airflow. Avoid heavy structural intervention when the tree is stressed.",
                    "Autumn: new growth gradually hardens. Review branch structure. Complete appropriate wiring adjustments. Reduce fertilization according to the existing seasonal framework. Prepare for winter conditions.",
                    "Winter: maintain outdoor dormancy. Protect container roots against extreme temperature fluctuations. Monitor winter drying during prolonged cold, dry and windy periods. Avoid unnecessary root disturbance.",
                    "The species should remain an outdoor bonsai through winter.",
                ]
            ),
            SpeciesProfileSection(
                id: "styles",
                title: "Bonsai Styles",
                paragraphs: [
                    "Suitable styles may include Informal Upright, Upright, Slanting, naturalistic conifer, mountain-inspired forms and windswept-inspired forms where the individual tree supports the design.",
                    "Naturalistic designs should take advantage of the species' northern and boreal character.",
                    "Do not force a formal style onto material whose natural structure does not support it.",
                    "The individual material should determine the final design.",
                ]
            ),
            SpeciesProfileSection(
                id: "tree-stage",
                title: "Development by Tree Stage",
                paragraphs: [
                    "Young nursery material: focus on health, trunk movement, trunk thickening, root development and initial branch selection. Do not over-refine young material.",
                    "Pre-bonsai: focus on primary branch structure, trunk movement, wiring, branch positioning and controlled extension growth.",
                    "Established bonsai: focus on secondary branching, foliage balance, controlled shoot extension, selective pruning and maintenance wiring.",
                    "Mature refined bonsai: focus on fine ramification, silhouette refinement, preservation of inner foliage, mature bark and subtle seasonal refinement. Avoid unnecessary major interventions on mature trees.",
                ]
            ),
            SpeciesProfileSection(
                id: "attention",
                title: "Species-Specific Attention",
                paragraphs: [
                    "These attention points are operational tendencies. They must still be interpreted for the individual tree.",
                    "Picea glauca is especially relevant to cold-climate bonsai because of its broad natural distribution across northern North America and its strong adaptation to cold conditions.",
                ],
                bullets: [
                    "Treat it as an outdoor temperate/boreal conifer",
                    "Preserve viable interior foliage",
                    "Do not expect reliable regeneration from completely bare old wood",
                    "Use gradual branch reduction",
                    "Avoid excessive root disturbance",
                    "Maintain excellent drainage",
                    "Monitor container moisture carefully during wind and summer heat",
                    "Use wiring for structural development",
                    "Allow adequate time for ramification",
                    "Take advantage of its natural conical and mountain character",
                    "Do not confuse cold tolerance with tolerance of root-zone neglect",
                    "Especially relevant for Norwegian cold-climate outdoor bonsai",
                    "Do not confuse with Picea engelmannii, Picea pungens, Picea sitchensis or Picea abies",
                    "Winter dormancy is required",
                    "Do not move indoors for routine winter care",
                ]
            ),
        ]
    }
}
