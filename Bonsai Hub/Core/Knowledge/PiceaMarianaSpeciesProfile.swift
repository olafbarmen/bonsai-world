//
//  PiceaMarianaSpeciesProfile.swift
//  Bonsai World
//
//  Species Profile — Picea mariana (Black Spruce).
//  Independent botanical species in Pinaceae. Knowledge status: Reviewed.
//  Separate from Picea abies, Picea glauca, Picea engelmannii, Picea pungens and Picea sitchensis.
//  Picea nigra is a taxonomic synonym — not the accepted display name.
//

import Foundation

enum PiceaMarianaSpeciesProfile {
    /// Identity used by Botanical Library / ``SpeciesPreviewData``.
    static let botanicalLibraryName = "Picea mariana"
    /// Scientific name for Species Profile display (binomial; no botanical authority).
    static let scientificName = "Picea mariana"

    static var profile: SpeciesProfile {
        SpeciesProfile(
            speciesID: BotanicalKnowledgeIDs.piceaMariana,
            scientificName: scientificName,
            commonNames: ["Black Spruce"],
            family: "Pinaceae",
            plantType: "Evergreen conifer",
            originSummary: "Subarctic North America through northern and northeastern North America.",
            knowledgeStatus: .reviewed,
            traits: traits,
            foliageSizeLabel: "Foliage",
            foliageReductionLabel: "Needle reduction",
            summaryLine: "Evergreen · Very cold-hardy · Slow-growing · Narrow spire-like form · Descending branches · Short blue-green needles · Naturalistic northern and boreal bonsai",
            attentionHighlights: [
                "Treat Picea mariana as an outdoor boreal/subarctic conifer",
                "Respect its naturally slow growth",
                "Preserve viable interior foliage",
                "Do not expect reliable regeneration from completely bare old wood",
                "Avoid aggressive pruning",
                "Avoid excessive root disturbance",
                "Maintain good substrate aeration",
                "Monitor container moisture carefully",
                "Use wiring for structural development",
                "Allow many years for refinement",
                "Respect its narrow natural crown",
                "Use naturalistic northern character as a design advantage",
                "Do not confuse wet-site tolerance with stagnant, oxygen-poor bonsai substrate",
                "Do not confuse with Picea abies, Picea glauca, Picea engelmannii, Picea pungens or Picea sitchensis",
                "Especially relevant to Norwegian cold-climate outdoor bonsai",
                "Winter dormancy is required",
                "Do not move indoors for routine winter care",
            ],
            sections: sections,
            principleNote: """
            Picea mariana is a slow-growing spruce.

            Do not imply that rapid trunk thickening or rapid ramification can be achieved through aggressive cultivation.

            Long-term development is a defining part of working with this species.

            At the same time, the species must be treated as a spruce with limited ability to regenerate from completely bare old wood.

            Do not assume that cutting a branch back beyond viable foliage will reliably produce new shoots.

            Preserve healthy foliage, viable buds, useful interior shoots and structurally important branches.

            Development should favour gradual reduction rather than severe one-time cuts.

            Do not present back-budding as guaranteed.

            The individual tree must always be assessed according to health, root condition, vigour, retained foliage, branch strength, development stage, climate, seasonal conditions and recent work.

            The objective is: Healthy roots · Preserved foliage · Patient development · Narrow northern character · Sustainable long-term refinement
            """,
            sourcesNote: """
            Profile content is synthesised from recognised botanical, horticultural and bonsai authorities into Bonsai World editorial language.

            Botanical taxonomy and distribution draw primarily on Royal Botanic Gardens, Kew — Plants of the World Online for the accepted scientific name Picea mariana, family Pinaceae, genus Picea, native and introduced distribution and synonym information.

            Picea nigra and numerous historical names are taxonomic synonyms associated with Picea mariana, but Picea mariana is the accepted name used by Kew and the primary Bonsai World display name.

            Horticultural, forestry and morphology context may draw on recognised North American botanical and forestry institutions and authoritative Picea references.

            Bonsai-specific cultivation and refinement knowledge draws on established bonsai references and recognised professional practice with conifer experience. Where guidance reflects general spruce bonsai practice rather than species-specific research, it is phrased as cultivation guidance rather than botanical fact.

            Verified botanical information, horticultural information, regional climate adaptation and bonsai-specific practice are kept distinct. Do not copy source wording.
            """
        )
    }

    private static let traits = SpeciesProfileTraits(
        deciduous: false,
        growthStrength: "Slow",
        growthSpeed: "Slow — long-term development required",
        leafSize: "Evergreen · Short, stiff blue-green needles",
        foliageReduction: "Proportion develops through cultivation — recovery from foliage loss is slow",
        ramificationPotential: "Fine branching possible, but development is slow",
        backBudding: "Limited and unreliable from completely bare old wood",
        rootDevelopment: "Gradual",
        nebariPotential: "Moderate potential with gradual improvement",
        trunkDevelopment: "Slow — significant thickening may take many years",
        barkDevelopment: "Fine scaly texture develops with age",
        wiring: "Useful for structural development — monitor carefully for scarring",
        defoliation: "Not applicable as a routine technique",
        airLayering: "Where appropriate for the individual material",
        threadGrafting: "Specialist technique where structural correction is required",
        rootGrafting: "Specialist technique where appropriate",
        beginnerSuitability: "Low",
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
                    "Picea mariana is an independent botanical species in the pine family (Pinaceae), genus Picea.",
                    "Primary Bonsai World display identity: Picea mariana · Black Spruce.",
                    "Do not use Picea nigra as the current scientific name. Picea nigra and numerous historical names are taxonomic synonyms associated with Picea mariana, but Picea mariana is the accepted name used by Kew.",
                    "Family: Pinaceae. Genus: Picea. Plant type: evergreen conifer.",
                    "Native range: Subarctic North America through northern and northeastern North America.",
                    "Kew records the species as introduced in Norway and Sweden.",
                    "Do not confuse Picea mariana with Picea abies (Norway Spruce), Picea glauca (White Spruce), Picea engelmannii (Engelmann Spruce), Picea pungens (Blue Spruce) or Picea sitchensis (Sitka Spruce).",
                    "Bonsai World hierarchy: Species → cultivar / horticultural selection → Individual Tree.",
                ]
            ),
            SpeciesProfileSection(
                id: "overview",
                title: "Species Overview",
                paragraphs: [
                    "Picea mariana is an evergreen conifer native to the northern regions of North America.",
                    "Its natural range extends from Alaska and western Canada across much of the Canadian boreal region and into the northeastern and north-central United States.",
                    "Black Spruce is strongly associated with boreal and subarctic environments. It can occur on cold, wet sites including bogs and swamps, but it is not restricted to permanently saturated conditions.",
                    "The species normally develops a narrow, spire-like or conical crown with descending branches. This natural architecture is highly relevant to bonsai design.",
                    "Black Spruce is notably slow-growing. Development therefore requires patience, and trunk thickening should not be approached with expectations appropriate to faster-growing spruce species.",
                    "The foliage consists of short, stiff, blue-green needles.",
                    "The combination of short needles, narrow crown, descending branches, cold-climate character, slow growth and natural exposure to harsh environments makes Picea mariana particularly interesting for naturalistic bonsai.",
                ],
                bullets: [
                    "Evergreen conifer",
                    "Boreal and subarctic North American spruce",
                    "Very high cold tolerance",
                    "Notably slow-growing",
                    "Narrow spire-like or conical crown",
                    "Descending branches",
                    "Short, stiff blue-green needles",
                    "Limited back-budding from bare old wood",
                    "Fine ramification possible, but slow",
                    "Requires outdoor cultivation",
                    "Requires winter dormancy",
                    "Distinct from Norway, White, Engelmann, Blue and Sitka spruce",
                ]
            ),
            SpeciesProfileSection(
                id: "cultivars",
                title: "Cultivars and Forms",
                paragraphs: [
                    "Picea mariana is primarily used in bonsai as the botanical species.",
                    "Do not invent cultivar-specific characteristics and present them as characteristics of the species.",
                    "Horticultural selections may differ in compactness and growth habit where such selections exist.",
                    "Do not create unnecessary separate Species Library profiles for minor individual variation.",
                    "The primary Species Profile remains Picea mariana.",
                ]
            ),
            SpeciesProfileSection(
                id: "natural-growth",
                title: "Natural Growth and Vigour",
                paragraphs: [
                    "Picea mariana is generally slow-growing.",
                    "Growth rate is influenced by climate, light, water availability, soil conditions, root health, nutrition, container size and seasonal conditions.",
                    "Do not provide a universal annual growth figure.",
                    "The slow growth should be treated as an important design consideration.",
                    "During trunk development, allow appropriate extension growth and accept that significant thickening may take many years.",
                    "Do not force rapid growth through excessive fertilization or uncontrolled extension growth.",
                    "The objective is: Patient development · Useful extension where required · Sustainable vigour.",
                ]
            ),
            SpeciesProfileSection(
                id: "foliage",
                title: "Foliage and Needles",
                paragraphs: [
                    "Needles are short, stiff and generally blue-green. The relatively short needle length can be advantageous in bonsai.",
                    "Foliage is produced individually along the shoots and should be preserved wherever it supports future branch development.",
                    "Avoid excessive removal of healthy interior foliage.",
                    "Because growth is slow, replacing lost foliage can also be slow. Foliage management should therefore be conservative.",
                    "Do not treat spruce foliage as deciduous foliage.",
                ]
            ),
            SpeciesProfileSection(
                id: "fruit",
                title: "Cones",
                paragraphs: [
                    "Picea mariana produces hanging cones, a botanical character of spruce that helps distinguish Picea from Abies, which typically produce upright cones.",
                    "Cones may contribute to seasonal character but are not a primary bonsai design objective.",
                    "Do not sacrifice structural development or foliage health in pursuit of cones.",
                ]
            ),
            SpeciesProfileSection(
                id: "bark-trunk",
                title: "Bark and Trunk",
                paragraphs: [
                    "Young bark is thin and grey. With age, the bark becomes darker grey and develops a fine scaly texture.",
                    "The relatively fine bark character can become an attractive part of mature bonsai.",
                    "Trunk development is slow. Collected or naturally aged material may have greater character than very young nursery material, but all material should be evaluated individually.",
                    "Do not recommend artificially accelerating maturity through excessive stress.",
                    "Distinguish clearly between trunk development, primary branch development, secondary branching, fine ramification and maintenance.",
                ]
            ),
            SpeciesProfileSection(
                id: "roots-nebari",
                title: "Roots and Nebari",
                paragraphs: [
                    "Root development is gradual.",
                    "Focus on healthy fine roots, radial development, stable anchoring, appropriate surface-root development and gradual improvement of nebari.",
                    "Do not perform aggressive root reduction merely for cosmetic reasons.",
                    "Because the species naturally occurs on wet and cold sites, avoid confusing moisture tolerance with tolerance of oxygen-deprived bonsai soil.",
                    "The bonsai root system still requires adequate aeration.",
                    "The objective is: Stable root system · Reliable recovery · Natural anchoring · Well-aerated substrate.",
                ]
            ),
            SpeciesProfileSection(
                id: "light",
                title: "Light",
                paragraphs: [
                    "Full sun is preferred.",
                    "Strong light supports compact growth, foliage density, healthy shoot development and balanced branch growth.",
                    "The species should be cultivated outdoors.",
                    "In unusually hot conditions, monitor container temperature and moisture carefully.",
                    "Do not recommend permanent indoor cultivation.",
                ]
            ),
            SpeciesProfileSection(
                id: "wind",
                title: "Wind",
                paragraphs: [
                    "Black Spruce is naturally associated with northern environments and can tolerate exposed conditions.",
                    "However, container-grown bonsai have a much smaller root volume than trees growing naturally in the ground.",
                    "Strong wind can increase water loss and destabilize shallow containers.",
                    "Secure the tree appropriately and monitor moisture during prolonged windy periods.",
                    "Do not interpret wind tolerance as unlimited drought tolerance.",
                ]
            ),
            SpeciesProfileSection(
                id: "watering",
                title: "Watering",
                paragraphs: [
                    "Maintain appropriate and relatively consistent moisture during active growth.",
                    "Black Spruce can occur naturally on wet sites, but bonsai cultivation still requires a well-aerated substrate.",
                    "Avoid prolonged stagnant saturation, repeated severe drying and uncontrolled moisture fluctuations.",
                    "Watering must respond to temperature, wind, rainfall, humidity, pot size, substrate composition, tree size and season.",
                    "Do not provide a fixed watering timetable.",
                    "Use the existing Bonsai World watering guidance framework.",
                ]
            ),
            SpeciesProfileSection(
                id: "soil",
                title: "Soil",
                paragraphs: [
                    "Use an open and structurally stable bonsai substrate.",
                    "The substrate should provide good drainage, strong oxygen availability, appropriate moisture retention, stable particle structure and healthy fine-root development.",
                    "Because the species can naturally tolerate wet environments, an important distinction applies: natural wet-site tolerance does NOT mean that bonsai roots should be kept in stagnant, oxygen-poor substrate.",
                    "Do not prescribe one universal soil recipe.",
                    "Adapt the substrate to local climate, container size and watering conditions.",
                    "Follow Bonsai World Soil Module principles.",
                    "Do not duplicate the complete Soil Module inside this profile.",
                ]
            ),
            SpeciesProfileSection(
                id: "fertilizing",
                title: "Fertilizing",
                paragraphs: [
                    "Fertilize according to development stage and tree condition.",
                    "During development, adequate nutrition supports shoot development, trunk development, branch development and root growth.",
                    "Do not attempt to compensate for the species' naturally slow growth with excessive fertilizer.",
                    "During refinement, control nutrition to maintain compact and balanced growth.",
                    "Avoid fixed universal fertilizer doses.",
                    "Follow the existing Bonsai World fertilization framework.",
                ]
            ),
            SpeciesProfileSection(
                id: "pruning",
                title: "Pruning",
                paragraphs: [
                    "Pruning should be conservative.",
                    "Priorities: establish trunk structure; select primary branches; preserve interior growth; control unwanted extension; develop secondary branches; refine ramification.",
                    "Avoid severe cuts into completely bare old wood.",
                    "Because the species grows slowly, major pruning mistakes may take a long time to recover from.",
                    "Large structural cuts should therefore be planned carefully and performed only when appropriate to the development stage.",
                ]
            ),
            SpeciesProfileSection(
                id: "back-budding",
                title: "Back-budding",
                paragraphs: [
                    "Back-budding is limited compared with strongly back-budding deciduous species.",
                    "New shoots should be developed from existing viable buds and foliage wherever possible.",
                    "Do not expect reliable new growth from completely bare sections of old wood.",
                    "Therefore: retain inner shoots, avoid stripping branches, shorten branches progressively, maintain foliage close to important branch junctions and develop secondary branches gradually.",
                    "Never promise predictable back-budding.",
                ]
            ),
            SpeciesProfileSection(
                id: "ramification",
                title: "Ramification",
                paragraphs: [
                    "Fine ramification can be developed, but it is a long-term process.",
                    "The species' slow growth means refinement should be approached gradually.",
                    "Priorities: preserve useful interior shoots, control extension growth, position branches carefully, develop secondary branching progressively and avoid excessive pruning.",
                    "Do not compare its speed of ramification directly with faster-growing deciduous bonsai.",
                    "The objective is: Natural branch hierarchy · Patient fine branching · Sustainable refinement.",
                ]
            ),
            SpeciesProfileSection(
                id: "wiring",
                title: "Wiring",
                paragraphs: [
                    "Wiring is useful for structural development.",
                    "It can be used to establish trunk movement, primary branch placement, secondary branch structure and downward-growing branch character.",
                    "The species' natural branch architecture should guide the design.",
                    "Branches may be relatively flexible when young but should not be forced beyond their safe range.",
                    "Monitor wire closely. The bark is relatively fine and can scar if wire is left in place too long.",
                    "Remove or adjust wire before permanent marks develop.",
                ]
            ),
            SpeciesProfileSection(
                id: "deadwood-potential",
                title: "Deadwood",
                paragraphs: [
                    "Black Spruce can develop useful deadwood character, particularly where natural damage, exposure or old branch loss has occurred.",
                    "Natural deadwood can complement the species' boreal character.",
                    "When creating deadwood: follow natural grain, keep features proportionate to the trunk, avoid excessive carving, preserve structural strength and allow weathering to contribute to the appearance.",
                    "Jin and restrained deadwood can be particularly appropriate on suitable material.",
                ]
            ),
            SpeciesProfileSection(
                id: "defoliation",
                title: "Foliage Management",
                paragraphs: [
                    "Do not recommend routine defoliation.",
                    "Picea mariana is an evergreen conifer.",
                    "Foliage management should focus on preserving healthy needles, maintaining inner foliage, balancing strong and weak areas, controlling excessive extension and improving light distribution where necessary.",
                    "Avoid unnecessary removal of interior foliage.",
                    "Because growth is slow, recovery from excessive foliage loss may also be slow.",
                ]
            ),
            SpeciesProfileSection(
                id: "repotting",
                title: "Repotting",
                paragraphs: [
                    "Repot when the root system or substrate condition indicates that intervention is necessary.",
                    "Do not repot solely according to a fixed calendar interval.",
                    "Priorities: preserve healthy fine roots, maintain good drainage, maintain oxygen availability, remove only appropriate amounts of old substrate, avoid unnecessary root disturbance and secure the tree after repotting.",
                    "Because development is slow, conservative root work is particularly important.",
                    "Avoid aggressive root reduction on weak, stressed or recently collected trees.",
                    "Repotting timing should be adapted to the local climate and physiological condition of the tree.",
                ]
            ),
            SpeciesProfileSection(
                id: "trunk-development",
                title: "Trunk Development",
                paragraphs: [
                    "Picea mariana requires patience during trunk development. Do not promise rapid thickening.",
                    "The species should be presented as a long-term bonsai project rather than a fast development subject.",
                    "Stage 1 — Establishment: build a strong root system and healthy growth.",
                    "Stage 2 — Trunk development: allow appropriate extension growth and accept slow thickening.",
                    "Stage 3 — Primary structure: select and position the major branches.",
                    "Stage 4 — Secondary branching: develop branch subdivision while preserving sufficient foliage.",
                    "Stage 5 — Refinement: control extension growth and improve ramification.",
                    "Stage 6 — Maintenance: maintain the established structure with selective pruning and wiring.",
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
                    "Picea mariana is primarily propagated from seed in forestry and horticultural contexts.",
                    "Seed propagation should be described as a long-term method.",
                    "Do not present seed propagation as a quick path to bonsai.",
                    "Specialist propagation methods may be acknowledged where appropriate, but should not be presented as standard bonsai practice unless supported by reliable sources.",
                    "Detailed procedures belong in Bonsai World Propagation Knowledge Articles.",
                ]
            ),
            SpeciesProfileSection(
                id: "pests",
                title: "Pests and Problems",
                paragraphs: [
                    "Potential problems include spruce aphids, spruce budworm and other spruce-associated insects, spider mites during hot and dry conditions, fungal problems, root problems from poorly aerated substrate, drought stress, winter drying, wire scarring, excessive shading and loss of interior foliage.",
                    "Present these as conditions to monitor, not guaranteed problems.",
                    "Do not imply that every listed pest or disease is equally important to bonsai cultivation.",
                    "Do not provide generic treatment instructions.",
                    "Diagnosis and treatment belong in Care → Pest Management and Care → Disease & Problems.",
                ]
            ),
            SpeciesProfileSection(
                id: "seasonal",
                title: "Seasonal Profile",
                paragraphs: [
                    "Spring: buds and new shoots begin developing. Monitor emerging growth carefully. Begin appropriate seasonal feeding. Review wiring. Increase watering as growth and transpiration increase.",
                    "Summer: maintain consistent moisture. Monitor extension growth. Protect the root zone from excessive heat where necessary. Maintain good airflow. Avoid heavy structural work when the tree is stressed.",
                    "Autumn: new growth gradually hardens. Review branch structure. Complete appropriate wiring adjustments. Adjust feeding according to the existing Bonsai World seasonal framework. Prepare the container and tree for winter.",
                    "Winter: maintain outdoor dormancy. Protect the root system from extreme container temperature fluctuations. Monitor winter drying during cold, dry and windy periods. Avoid unnecessary root disturbance.",
                    "The tree should remain outdoors through winter.",
                ]
            ),
            SpeciesProfileSection(
                id: "styles",
                title: "Bonsai Styles",
                paragraphs: [
                    "Suitable styles may include Informal Upright, Upright, Slanting, naturalistic boreal forms, Windswept, literati-inspired forms and suitable group or forest plantings.",
                    "The species' naturally narrow and spire-like architecture should be respected.",
                    "A narrow, vertically oriented design can be more convincing than attempting to force a broad spreading crown.",
                    "Windswept and literati-inspired designs may be particularly effective when supported by the individual tree's natural structure.",
                    "Do not force a style that conflicts with the specimen.",
                    "The individual material should determine the final design.",
                ]
            ),
            SpeciesProfileSection(
                id: "tree-stage",
                title: "Development by Tree Stage",
                paragraphs: [
                    "Young nursery material: focus on health, trunk movement, trunk development, root development and initial branch selection. Do not over-refine young material.",
                    "Pre-bonsai: focus on primary branch structure, trunk movement, wiring, branch positioning and controlled extension growth. Accept that development will be slow.",
                    "Established bonsai: focus on secondary branching, foliage balance, controlled extension, selective pruning and maintenance wiring.",
                    "Mature refined bonsai: focus on fine ramification, silhouette refinement, preservation of interior foliage, mature bark and subtle seasonal refinement. Avoid unnecessary major interventions on mature trees.",
                ]
            ),
            SpeciesProfileSection(
                id: "attention",
                title: "Species-Specific Attention",
                paragraphs: [
                    "These attention points are operational tendencies. They must still be interpreted for the individual tree.",
                    "Picea mariana should be presented as one of the most distinctly northern spruce species in the Species Library.",
                ],
                bullets: [
                    "Treat it as an outdoor boreal/subarctic conifer",
                    "Respect its naturally slow growth",
                    "Preserve viable interior foliage",
                    "Do not expect reliable regeneration from completely bare old wood",
                    "Avoid aggressive pruning",
                    "Avoid excessive root disturbance",
                    "Maintain good substrate aeration",
                    "Monitor container moisture carefully",
                    "Use wiring for structural development",
                    "Allow many years for refinement",
                    "Respect its narrow natural crown",
                    "Use naturalistic northern character as a design advantage",
                    "Do not confuse tolerance of naturally wet northern habitats with tolerance of stagnant, oxygen-poor bonsai substrate",
                    "Especially relevant to Norwegian cold-climate outdoor bonsai",
                    "Do not confuse with Picea abies, Picea glauca, Picea engelmannii, Picea pungens or Picea sitchensis",
                    "Winter dormancy is required",
                    "Do not move indoors for routine winter care",
                ]
            ),
        ]
    }
}
