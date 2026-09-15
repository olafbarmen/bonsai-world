//
//  PiceaPungensSpeciesProfile.swift
//  Bonsai World
//
//  Species Profile — Picea pungens (Blue Spruce).
//  Independent botanical species in Pinaceae. Knowledge status: Reviewed.
//  Separate from Picea glauca, Picea engelmannii, Picea omorika, Picea abies and Picea sitchensis.
//  Do not treat blue-foliaged cultivars as separate species.
//

import Foundation

enum PiceaPungensSpeciesProfile {
    /// Identity used by Botanical Library / ``SpeciesPreviewData``.
    static let botanicalLibraryName = "Picea pungens"
    /// Scientific name for Species Profile display (binomial; no botanical authority).
    static let scientificName = "Picea pungens"

    static var profile: SpeciesProfile {
        SpeciesProfile(
            speciesID: BotanicalKnowledgeIDs.piceaPungens,
            scientificName: scientificName,
            commonNames: ["Blue Spruce"],
            family: "Pinaceae",
            plantType: "Evergreen conifer",
            originSummary: "Rocky Mountains of the western United States.",
            knowledgeStatus: .reviewed,
            traits: traits,
            foliageSizeLabel: "Foliage",
            foliageReductionLabel: "Needle reduction",
            summaryLine: "Evergreen · Blue-grey to blue-green needles · Strong conical architecture · Cold-climate character · Outdoor bonsai · Naturalistic conifer designs",
            attentionHighlights: [
                "Treat Picea pungens as an outdoor temperate conifer",
                "Preserve viable interior foliage",
                "Do not expect reliable regeneration from completely bare old wood",
                "Use gradual branch reduction",
                "Respect its stiff needle character",
                "Recognise that foliage colour varies among individuals",
                "Do not assume every specimen is intensely blue",
                "Maintain excellent substrate drainage and aeration",
                "Use full sun where conditions permit",
                "Use wiring for structural development",
                "Allow sufficient time for ramification",
                "Take advantage of its strong conical architecture",
                "Do not confuse with Picea glauca, Picea engelmannii, Picea omorika, Picea abies or Picea sitchensis",
                "Especially relevant to northern European cold-climate outdoor bonsai",
                "Winter dormancy is required",
                "Do not move indoors for routine winter care",
            ],
            sections: sections,
            principleNote: """
            Picea pungens must be treated as a spruce with limited ability to regenerate from completely bare old wood.

            Do not assume that cutting a branch back beyond viable foliage will reliably produce new shoots.

            Preserve healthy foliage, viable buds, useful interior shoots and structurally important branches.

            Development should favour gradual branch reduction and controlled extension growth.

            Do not recommend indiscriminate removal of interior foliage.

            Do not present back-budding as guaranteed.

            Do not transfer characteristics of strongly blue cultivars to the species as a whole.

            The individual tree must always be assessed according to health, root condition, vigour, retained foliage, branch strength, development stage, climate, seasonal conditions and recent work.

            The objective is: Healthy roots · Preserved foliage · Clear structure · Accurate foliage character · Sustainable long-term refinement
            """,
            sourcesNote: """
            Profile content is synthesised from recognised botanical, horticultural and bonsai authorities into Bonsai World editorial language.

            Botanical taxonomy and distribution draw primarily on Royal Botanic Gardens, Kew — Plants of the World Online for the accepted scientific name Picea pungens, family Pinaceae, genus Picea, native distribution and taxonomic information.

            Horticultural, forestry and morphology context may draw on recognised North American botanical and forestry institutions and authoritative Picea references for foliage characteristics and growth habit.

            Bonsai-specific cultivation and refinement knowledge draws on established bonsai references and recognised professional practice with conifer experience. Where guidance reflects general spruce bonsai practice rather than species-specific research, it is phrased as cultivation guidance rather than botanical fact.

            Verified botanical information, horticultural information, regional climate adaptation and bonsai-specific practice are kept distinct. Do not copy source wording.
            """
        )
    }

    private static let traits = SpeciesProfileTraits(
        deciduous: false,
        growthStrength: "Moderate; can be vigorous when young and well established",
        growthSpeed: "Moderate — strongly climate and site dependent",
        leafSize: "Evergreen · Stiff, pointed needles · Green to blue-green/glaucous",
        foliageReduction: "Proportion develops through cultivation — vigour dependent",
        ramificationPotential: "Fine branching possible with gradual development",
        backBudding: "Limited and unreliable from completely bare old wood",
        rootDevelopment: "Moderate",
        nebariPotential: "Moderate potential with gradual improvement",
        trunkDevelopment: "Long-term — allow extension during early development",
        barkDevelopment: "Greater texture and character with age",
        wiring: "Useful for structural development and branch positioning",
        defoliation: "Not applicable as a routine technique",
        airLayering: "Where appropriate for the individual material",
        threadGrafting: "Specialist technique where structural correction is required",
        rootGrafting: "Specialist technique where appropriate",
        beginnerSuitability: "Low to Moderate",
        bonsaiSuitability: "Good",
        difficulty: "Advanced",
        winterDormancyRequired: true,
        winterHardiness: "High",
        rootFrostSensitivity: "Low to Moderate in species terms, but shallow bonsai roots remain vulnerable during extreme container temperature fluctuations"
    )

    private static var sections: [SpeciesProfileSection] {
        [
            SpeciesProfileSection(
                id: "taxonomic-context",
                title: "Taxonomic Context",
                paragraphs: [
                    "Picea pungens is an independent botanical species in the pine family (Pinaceae), genus Picea.",
                    "Primary Bonsai World display identity: Picea pungens · Blue Spruce.",
                    "Family: Pinaceae. Genus: Picea. Plant type: evergreen conifer.",
                    "Native range: Rocky Mountains of the western United States.",
                    "Do not confuse Picea pungens with Picea glauca (White Spruce), Picea engelmannii (Engelmann Spruce), Picea omorika (Serbian Spruce), Picea abies (Norway Spruce) or Picea sitchensis (Sitka Spruce).",
                    "Do not automatically treat well-known blue-foliaged cultivars as separate species.",
                    "Bonsai World hierarchy: Species → cultivar / horticultural selection → Individual Tree.",
                ]
            ),
            SpeciesProfileSection(
                id: "overview",
                title: "Species Overview",
                paragraphs: [
                    "Picea pungens is an evergreen conifer native to the Rocky Mountains of the western United States.",
                    "It is widely cultivated outside its natural range and is particularly well known horticulturally for its blue-grey to blue-green foliage.",
                    "The species develops a strong conical crown and a substantial central leader. Young trees often have a very regular, symmetrical appearance.",
                    "For bonsai, this natural architecture can be developed into formal or informal upright designs, but individual specimens should be allowed to dictate the final style.",
                    "The needles are stiff, sharply pointed and typically blue-green to glaucous. The intensity of the blue colour can vary considerably according to genetic origin and growing conditions.",
                    "Important distinction: the species itself can have blue-grey foliage, but not every Picea pungens has the same degree of blue colour. Do not transfer characteristics of strongly blue cultivars to the species as a whole.",
                    "Picea pungens is a cold-climate outdoor conifer and should be treated accordingly in Bonsai World.",
                ],
                bullets: [
                    "Evergreen conifer",
                    "Rocky Mountain native range",
                    "Strong conical architecture",
                    "Stiff, sharply pointed needles",
                    "Foliage colour varies from green through blue-green to glaucous blue-grey",
                    "Not every specimen is intensely blue",
                    "Limited back-budding from bare old wood",
                    "Fine ramification possible with gradual development",
                    "High cold tolerance",
                    "Requires outdoor cultivation",
                    "Requires winter dormancy",
                    "Distinct from White, Engelmann, Serbian, Norway and Sitka spruce",
                ]
            ),
            SpeciesProfileSection(
                id: "cultivars",
                title: "Cultivars and Forms",
                paragraphs: [
                    "Picea pungens is primarily used in bonsai as the botanical species.",
                    "Do not invent cultivar-specific characteristics and present them as characteristics of the species.",
                    "Well-known blue-foliaged cultivars may differ in colour intensity and compactness, but they do not replace the species profile.",
                    "Do not create unnecessary separate Species Library profiles for minor individual variation.",
                    "The primary Species Profile remains Picea pungens.",
                ]
            ),
            SpeciesProfileSection(
                id: "natural-growth",
                title: "Natural Growth and Vigour",
                paragraphs: [
                    "Picea pungens has moderate growth potential and can be vigorous when young and well established.",
                    "Growth depends on climate, light, water, nutrition, root health, container size, substrate and seasonal conditions.",
                    "Do not provide a universal annual growth rate.",
                    "During early development, allow appropriate extension growth for trunk thickening and primary branch development.",
                    "During refinement, progressively control extension growth.",
                    "The objective is: Useful development growth · Progressive control · Preserved foliage.",
                ]
            ),
            SpeciesProfileSection(
                id: "foliage",
                title: "Foliage and Needles",
                paragraphs: [
                    "Needles are stiff, pointed and evergreen.",
                    "Colour ranges from green through blue-green to distinctly glaucous blue-grey.",
                    "Foliage colour is influenced by genetics as well as environmental and cultural conditions.",
                    "Do not describe every Picea pungens as intensely blue.",
                    "The stiff needle character gives the species a strong visual identity but also means foliage should be handled carefully during pruning and wiring.",
                    "Do not treat spruce foliage as deciduous foliage.",
                ]
            ),
            SpeciesProfileSection(
                id: "fruit",
                title: "Cones",
                paragraphs: [
                    "Picea pungens produces hanging cones, a botanical character of spruce that helps distinguish Picea from Abies, which typically produce upright cones.",
                    "Cones may contribute to seasonal character but are not a primary bonsai design objective.",
                    "Do not sacrifice structural development or foliage health in pursuit of cones.",
                ]
            ),
            SpeciesProfileSection(
                id: "bark-trunk",
                title: "Bark and Trunk",
                paragraphs: [
                    "Young bark is relatively smooth and grey-brown. With age, the bark becomes more textured and develops greater character.",
                    "The species naturally develops a strong central trunk and conical crown.",
                    "During bonsai development, allow sufficient extension growth to establish trunk diameter and taper.",
                    "Do not prematurely maintain a finished silhouette while expecting rapid trunk development.",
                    "Distinguish clearly between trunk development, primary branch development, secondary branching, fine ramification and maintenance.",
                ]
            ),
            SpeciesProfileSection(
                id: "roots-nebari",
                title: "Roots and Nebari",
                paragraphs: [
                    "Develop a balanced radial root system gradually.",
                    "Priorities include healthy fine roots, radial distribution, stable anchoring, gradual nebari development and avoidance of major crossing roots.",
                    "Do not perform aggressive root reduction solely for cosmetic reasons.",
                    "Maintain good drainage and root-zone oxygen availability.",
                    "The objective is: Stable root system · Reliable recovery · Natural anchoring.",
                ]
            ),
            SpeciesProfileSection(
                id: "light",
                title: "Light",
                paragraphs: [
                    "Full sun is preferred.",
                    "Strong light supports compact growth, foliage density, healthy shoots, stronger branch development and better expression of blue-grey foliage.",
                    "The species should be cultivated outdoors.",
                    "During unusually hot and dry conditions, monitor the container and root-zone temperature carefully.",
                    "Do not recommend permanent indoor cultivation.",
                ]
            ),
            SpeciesProfileSection(
                id: "wind",
                title: "Wind",
                paragraphs: [
                    "The species is naturally adapted to exposed mountainous conditions.",
                    "Nevertheless, bonsai containers have limited root volume and can dry rapidly in strong wind.",
                    "Secure the tree appropriately.",
                    "Monitor moisture during prolonged windy periods.",
                    "Do not interpret natural wind tolerance as unlimited drought tolerance.",
                ]
            ),
            SpeciesProfileSection(
                id: "watering",
                title: "Watering",
                paragraphs: [
                    "Maintain consistent moisture during active growth.",
                    "The substrate must drain freely and remain sufficiently aerated.",
                    "Avoid prolonged stagnant saturation, repeated severe drying and uncontrolled moisture fluctuations.",
                    "Watering must respond to temperature, wind, rainfall, humidity, container size, substrate composition, tree size and season.",
                    "Do not provide a fixed watering timetable.",
                    "Use the existing Bonsai World watering guidance framework.",
                ]
            ),
            SpeciesProfileSection(
                id: "soil",
                title: "Soil",
                paragraphs: [
                    "Use an open, structurally stable and well-draining bonsai substrate.",
                    "The substrate should provide good drainage, strong oxygen availability, appropriate moisture retention, stable particle structure and healthy fine-root development.",
                    "Avoid compacted soil.",
                    "Do not prescribe one universal soil recipe.",
                    "Adapt substrate characteristics to local climate, container size and watering regime.",
                    "Follow Bonsai World Soil Module principles.",
                    "Do not duplicate the complete Soil Module inside this profile.",
                ]
            ),
            SpeciesProfileSection(
                id: "fertilizing",
                title: "Fertilizing",
                paragraphs: [
                    "Fertilize according to development stage and tree condition.",
                    "During development, adequate nutrition supports shoot growth, trunk thickening, branch development and root growth.",
                    "During refinement, control nutrition to avoid unnecessarily coarse extension growth.",
                    "Do not attempt to force intense blue foliage through excessive fertilization.",
                    "Avoid fixed universal fertilizer doses.",
                    "Follow the existing Bonsai World fertilization framework.",
                ]
            ),
            SpeciesProfileSection(
                id: "pruning",
                title: "Pruning",
                paragraphs: [
                    "Pruning should be conservative and developmental.",
                    "Priorities: establish trunk structure; establish primary branches; preserve useful interior growth; control unwanted extension; develop secondary branching; refine ramification.",
                    "Avoid severe cuts into completely bare old wood.",
                    "Because recovery can be slow where viable buds are absent, structural reductions should be planned carefully.",
                    "Large cuts should only be made when appropriate to the development stage.",
                ]
            ),
            SpeciesProfileSection(
                id: "back-budding",
                title: "Back-budding",
                paragraphs: [
                    "Back-budding should be described conservatively.",
                    "Picea pungens should not be expected to reliably regenerate from completely bare old wood.",
                    "New growth is most dependable where viable buds and foliage remain.",
                    "Therefore: retain useful interior shoots, preserve foliage near important branch junctions, shorten branches progressively, avoid stripping branches completely and develop secondary branching from existing viable growth.",
                    "Never promise predictable back-budding.",
                ]
            ),
            SpeciesProfileSection(
                id: "ramification",
                title: "Ramification",
                paragraphs: [
                    "Fine ramification can be developed gradually.",
                    "The development process should focus on controlled extension growth, selective pruning, branch positioning, preservation of inner shoots and progressive branch subdivision.",
                    "Do not attempt to create excessive ramification through aggressive pruning.",
                    "The species should retain sufficient foliage to maintain branch health.",
                    "The objective is: Natural branch hierarchy · Gradual fine branching · Sustainable refinement.",
                ]
            ),
            SpeciesProfileSection(
                id: "wiring",
                title: "Wiring",
                paragraphs: [
                    "Wiring is an important structural technique.",
                    "Use wiring to establish trunk movement, primary branch placement, secondary branch structure, downward branch character and natural conifer branch hierarchy.",
                    "Young branches should be handled carefully because spruce branches can be damaged or broken by excessive force.",
                    "Monitor wire regularly during active growth.",
                    "Remove or adjust wire before it causes permanent scarring.",
                ]
            ),
            SpeciesProfileSection(
                id: "deadwood-potential",
                title: "Deadwood",
                paragraphs: [
                    "Deadwood may be appropriate where supported by the tree's natural character.",
                    "Use restraint.",
                    "Suitable deadwood should follow the natural grain, remain proportionate to the trunk, preserve structural strength, reflect natural damage or ageing and avoid exaggerated carving.",
                    "Naturalistic deadwood can work well on mature conifer bonsai.",
                ]
            ),
            SpeciesProfileSection(
                id: "defoliation",
                title: "Foliage Management",
                paragraphs: [
                    "Do not recommend routine defoliation.",
                    "Picea pungens is an evergreen conifer.",
                    "Foliage management should focus on preserving healthy needles, maintaining interior foliage, balancing strong and weak areas, controlling excessive extension and improving light distribution where necessary.",
                    "Avoid excessive removal of healthy inner foliage.",
                    "Do not treat the species like a deciduous bonsai.",
                ]
            ),
            SpeciesProfileSection(
                id: "repotting",
                title: "Repotting",
                paragraphs: [
                    "Repot when the root system or substrate condition indicates that intervention is necessary.",
                    "Do not repot solely because a fixed calendar interval has elapsed.",
                    "Priorities: preserve healthy fine roots, maintain good drainage, maintain oxygen availability, remove only appropriate amounts of old substrate, avoid unnecessary root disturbance and secure the tree firmly.",
                    "Repotting timing must be adapted to local climate and tree condition.",
                    "Avoid aggressive root work on weak, stressed or recently collected trees.",
                ]
            ),
            SpeciesProfileSection(
                id: "trunk-development",
                title: "Trunk Development",
                paragraphs: [
                    "During development, allow appropriate extension growth to build trunk diameter and taper.",
                    "Do not attempt to maintain a finished silhouette while simultaneously expecting rapid trunk thickening.",
                    "Stage 1 — Establishment: build a healthy root system and strong growth.",
                    "Stage 2 — Trunk development: allow controlled extension growth to increase trunk diameter and establish taper.",
                    "Stage 3 — Primary structure: select and position major branches.",
                    "Stage 4 — Secondary branching: develop branch subdivision while preserving sufficient foliage.",
                    "Stage 5 — Refinement: control extension growth and improve ramification.",
                    "Stage 6 — Maintenance: maintain the established structure through selective pruning and wiring.",
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
                    "Picea pungens is commonly propagated from seed in forestry and horticulture.",
                    "Seed propagation should be described as a long-term method.",
                    "Do not present seed propagation as a quick route to finished bonsai.",
                    "Specialist propagation techniques may be mentioned where supported by reliable sources, but should not be presented as standard bonsai practice.",
                    "Detailed procedures belong in Bonsai World Propagation Knowledge Articles.",
                ]
            ),
            SpeciesProfileSection(
                id: "pests",
                title: "Pests and Problems",
                paragraphs: [
                    "Potential problems include spruce aphids, spruce budworm and other spruce-associated insects, spider mites under hot and dry conditions, fungal diseases, root problems caused by poor drainage, drought stress, winter drying, wire scarring, excessive shading and loss of interior foliage.",
                    "Present these as conditions to monitor rather than guaranteed problems.",
                    "Do not imply that every listed pest or disease is equally important.",
                    "Do not provide generic treatment instructions.",
                    "Diagnosis and treatment belong in Care → Pest Management and Care → Disease & Problems.",
                ]
            ),
            SpeciesProfileSection(
                id: "seasonal",
                title: "Seasonal Profile",
                paragraphs: [
                    "Spring: buds and new shoots begin developing. Monitor new growth carefully. Begin appropriate seasonal feeding. Review wiring. Increase watering as growth increases. Preserve useful interior shoots.",
                    "Summer: maintain consistent moisture. Monitor extension growth. Protect container roots from excessive heat where necessary. Maintain good airflow. Avoid heavy structural work during periods of heat or drought stress.",
                    "Autumn: new growth gradually hardens. Review branch structure. Complete appropriate wiring adjustments. Adjust feeding according to the existing Bonsai World seasonal framework. Prepare for winter.",
                    "Winter: maintain outdoor dormancy. Protect container roots from extreme temperature fluctuations. Monitor winter drying during cold, dry and windy periods. Avoid unnecessary root disturbance.",
                    "The species should remain outdoors through winter.",
                ]
            ),
            SpeciesProfileSection(
                id: "styles",
                title: "Bonsai Styles",
                paragraphs: [
                    "Suitable styles may include Formal Upright, Informal Upright, Upright, Slanting, naturalistic conifer, mountain-inspired forms and windswept forms where supported by the specimen.",
                    "Formal upright can be appropriate because of the species' naturally strong central leader and symmetrical architecture.",
                    "However, individual trees should determine the final design.",
                    "Do not force a perfectly symmetrical form where the material has stronger natural movement or character.",
                ]
            ),
            SpeciesProfileSection(
                id: "tree-stage",
                title: "Development by Tree Stage",
                paragraphs: [
                    "Young nursery material: focus on health, trunk movement, trunk thickening, root development and initial branch selection. Do not over-refine young material.",
                    "Pre-bonsai: focus on trunk taper, primary branch structure, wiring, branch positioning and controlled extension growth.",
                    "Established bonsai: focus on secondary branching, foliage balance, controlled extension, selective pruning and maintenance wiring.",
                    "Mature refined bonsai: focus on fine ramification, silhouette refinement, preservation of interior foliage, mature bark and subtle seasonal refinement. Avoid unnecessary major interventions on mature trees.",
                ]
            ),
            SpeciesProfileSection(
                id: "attention",
                title: "Species-Specific Attention",
                paragraphs: [
                    "These attention points are operational tendencies. They must still be interpreted for the individual tree.",
                    "Picea pungens should be presented as a distinctive blue-foliaged spruce rather than simply as a generic Picea.",
                ],
                bullets: [
                    "Treat it as an outdoor temperate conifer",
                    "Preserve viable interior foliage",
                    "Do not expect reliable regeneration from completely bare old wood",
                    "Use gradual branch reduction",
                    "Respect its stiff needle character",
                    "Recognise that foliage colour varies among individuals",
                    "Do not assume every specimen is intensely blue",
                    "Maintain excellent substrate drainage and aeration",
                    "Use full sun where conditions permit",
                    "Use wiring for structural development",
                    "Allow sufficient time for ramification",
                    "Take advantage of its strong conical architecture",
                    "Especially relevant to northern European cold-climate outdoor bonsai",
                    "Do not confuse with Picea glauca, Picea engelmannii, Picea omorika, Picea abies or Picea sitchensis",
                    "Winter dormancy is required",
                    "Do not move indoors for routine winter care",
                ]
            ),
        ]
    }
}
