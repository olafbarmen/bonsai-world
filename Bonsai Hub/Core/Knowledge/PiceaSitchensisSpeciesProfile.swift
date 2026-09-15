//
//  PiceaSitchensisSpeciesProfile.swift
//  Bonsai World
//
//  Species Profile — Picea sitchensis (Sitka Spruce).
//  Independent botanical species in Pinaceae. Knowledge status: Reviewed.
//  Separate from Picea glauca, Picea engelmannii, Picea pungens, Picea omorika and Picea abies.
//

import Foundation

enum PiceaSitchensisSpeciesProfile {
    /// Identity used by Botanical Library / ``SpeciesPreviewData``.
    static let botanicalLibraryName = "Picea sitchensis"
    /// Scientific name for Species Profile display (binomial; no botanical authority).
    static let scientificName = "Picea sitchensis"

    static var profile: SpeciesProfile {
        SpeciesProfile(
            speciesID: BotanicalKnowledgeIDs.piceaSitchensis,
            scientificName: scientificName,
            commonNames: ["Sitka Spruce"],
            family: "Pinaceae",
            plantType: "Evergreen conifer",
            originSummary: "Coastal western North America, from Alaska through British Columbia and along the Pacific coast of the northwestern United States.",
            knowledgeStatus: .reviewed,
            traits: traits,
            foliageSizeLabel: "Foliage",
            foliageReductionLabel: "Needle reduction",
            summaryLine: "Evergreen · Fast and vigorous coastal spruce · Naturally large dimensions · High cold tolerance · Rugged coastal character · Large naturalistic bonsai potential",
            attentionHighlights: [
                "Respect its naturally large dimensions",
                "Use vigorous growth to advantage during trunk development",
                "Control extension growth progressively during refinement",
                "Preserve viable interior foliage",
                "Do not expect reliable regeneration from completely bare old wood",
                "Avoid excessive foliage stripping",
                "Maintain excellent substrate drainage and aeration",
                "Monitor container moisture carefully during wind",
                "Use wiring for structural development",
                "Monitor wire frequently during periods of rapid growth",
                "Allow sufficient space and time for branch development",
                "Consider larger bonsai formats where appropriate",
                "Use coastal, rugged or windswept character when supported by the specimen",
                "Do not confuse moisture tolerance with stagnant bonsai soil",
                "Do not confuse with Picea glauca, Picea engelmannii, Picea pungens, Picea omorika or Picea abies",
                "Winter dormancy is required",
                "Do not move indoors for routine winter care",
            ],
            sections: sections,
            principleNote: """
            Picea sitchensis is a vigorous spruce with substantial growth potential.

            The main bonsai challenge is therefore not simply encouraging growth, but controlling it while preserving sufficient foliage and branch health.

            At the same time, it must be treated as a spruce with limited ability to regenerate from completely bare old wood.

            Do not assume that cutting a branch back beyond viable foliage will reliably produce new shoots.

            The development strategy should favour: controlled extension growth · progressive branch reduction · preservation of useful inner shoots · strong structural planning · careful wiring · appropriate root management · gradual refinement.

            Do not repeatedly allow uncontrolled extension growth and then rely on severe pruning to correct the structure.

            The individual tree must always be assessed according to health, root condition, vigour, retained foliage, branch strength, development stage, climate, seasonal conditions and recent work.

            The objective is: Controlled vigour · Preserved foliage · Convincing scale · Coastal naturalistic character · Sustainable long-term refinement
            """,
            sourcesNote: """
            Profile content is synthesised from recognised botanical, horticultural and bonsai authorities into Bonsai World editorial language.

            Botanical taxonomy and distribution draw primarily on Royal Botanic Gardens, Kew — Plants of the World Online for the accepted scientific name Picea sitchensis, family Pinaceae, genus Picea, native distribution and taxonomic information.

            Horticultural, forestry and morphology context may draw on recognised North American botanical and forestry institutions and authoritative Picea references for exceptional natural size and coastal ecology.

            Bonsai-specific cultivation and refinement knowledge draws on established bonsai references and recognised professional practice with conifer experience. Where guidance reflects general spruce bonsai practice rather than species-specific research, it is phrased as cultivation guidance rather than botanical fact.

            Verified botanical information, horticultural information, regional climate adaptation and bonsai-specific practice are kept distinct. Do not copy source wording.
            """
        )
    }

    private static let traits = SpeciesProfileTraits(
        deciduous: false,
        growthStrength: "Fast and vigorous under favourable conditions",
        growthSpeed: "Fast — vigour must be controlled during refinement",
        leafSize: "Evergreen · Stiff, sharply pointed needles · Green to blue-green",
        foliageReduction: "Proportion develops through cultivation — consider final tree scale",
        ramificationPotential: "Possible with gradual development, but vigour must be controlled",
        backBudding: "Limited and unreliable from completely bare old wood",
        rootDevelopment: "Can be vigorous when conditions are favourable",
        nebariPotential: "Moderate potential with gradual improvement",
        trunkDevelopment: "Strong — substantial trunk potential with controlled vigour",
        barkDevelopment: "Deeply fissured mature character with age",
        wiring: "Useful for structural development — monitor carefully during vigorous growth",
        defoliation: "Not applicable as a routine technique",
        airLayering: "Where appropriate for the individual material",
        threadGrafting: "Specialist technique where structural correction is required",
        rootGrafting: "Specialist technique where appropriate",
        beginnerSuitability: "Low",
        bonsaiSuitability: "Good for larger formats",
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
                    "Picea sitchensis is an independent botanical species in the pine family (Pinaceae), genus Picea.",
                    "Primary Bonsai World display identity: Picea sitchensis · Sitka Spruce.",
                    "Family: Pinaceae. Genus: Picea. Plant type: evergreen conifer.",
                    "Native range: coastal western North America, from Alaska through British Columbia and along the Pacific coast of the northwestern United States.",
                    "Do not confuse Picea sitchensis with Picea glauca (White Spruce), Picea engelmannii (Engelmann Spruce), Picea pungens (Blue Spruce), Picea omorika (Serbian Spruce) or Picea abies (Norway Spruce).",
                    "Do not use a cultivar name as the species name.",
                    "Bonsai World hierarchy: Species → cultivar / horticultural selection → Individual Tree.",
                ]
            ),
            SpeciesProfileSection(
                id: "overview",
                title: "Species Overview",
                paragraphs: [
                    "Picea sitchensis is an evergreen conifer native to the moist Pacific coastal region of western North America.",
                    "Its natural range extends from Alaska through British Columbia and south along the Pacific coast of Washington, Oregon and northern California.",
                    "It is strongly associated with cool, humid coastal environments and is one of the world's largest spruce species.",
                    "The species can grow extremely rapidly under favourable conditions and can reach enormous dimensions in nature.",
                    "Important distinction for bonsai: Picea sitchensis is not naturally a small tree. Its bonsai potential therefore depends strongly on choosing suitable material and controlling vigour through cultivation and staged development.",
                    "The species develops a strong central leader and a broadening conical crown. In exposed coastal environments it can develop highly characterful forms influenced by wind, salt exposure and difficult growing conditions.",
                    "Needles are relatively stiff and sharply pointed.",
                    "The combination of strong growth, large natural size, coastal character, cold tolerance, substantial trunk potential and rugged natural forms makes Sitka Spruce interesting for larger, naturalistic bonsai. It should not be treated as a naturally compact spruce.",
                ],
                bullets: [
                    "Evergreen conifer",
                    "Pacific coastal western North American native",
                    "One of the world's largest spruce species",
                    "Fast and vigorous under favourable conditions",
                    "Not naturally a small tree",
                    "Stiff, sharply pointed needles",
                    "Limited back-budding from bare old wood",
                    "Ramification possible with controlled vigour",
                    "High cold tolerance",
                    "Especially suitable for medium-to-large bonsai",
                    "Requires outdoor cultivation",
                    "Requires winter dormancy",
                    "Distinct from White, Engelmann, Blue, Serbian and Norway spruce",
                ]
            ),
            SpeciesProfileSection(
                id: "cultivars",
                title: "Cultivars and Forms",
                paragraphs: [
                    "Picea sitchensis is primarily used in bonsai as the botanical species.",
                    "Do not invent cultivar-specific characteristics and present them as characteristics of the species.",
                    "Do not use a cultivar name as the species name.",
                    "Do not create unnecessary separate Species Library profiles for minor individual variation.",
                    "The primary Species Profile remains Picea sitchensis.",
                ]
            ),
            SpeciesProfileSection(
                id: "natural-growth",
                title: "Natural Growth and Vigour",
                paragraphs: [
                    "Picea sitchensis is a fast-growing and vigorous spruce under favourable conditions.",
                    "Growth is influenced by temperature, light, water availability, humidity, nutrition, root health, container size, substrate and seasonal conditions.",
                    "Its vigour can be an advantage during trunk development. However, vigorous extension growth can quickly make branches coarse and difficult to refine.",
                    "Early development: allow appropriate vigour for trunk and primary branch development.",
                    "Refinement: gradually reduce extension growth and concentrate on ramification.",
                    "Do not provide a universal annual growth rate.",
                    "The objective is: Useful development vigour · Progressive control · Sustainable refinement.",
                ]
            ),
            SpeciesProfileSection(
                id: "foliage",
                title: "Foliage and Needles",
                paragraphs: [
                    "Needles are evergreen, stiff and sharply pointed.",
                    "Foliage colour is generally green to blue-green.",
                    "The needles are significantly more substantial than those of many refined bonsai spruce selections.",
                    "Foliage should therefore be considered when selecting the appropriate final tree size.",
                    "Do not assume that a very small bonsai will automatically achieve proportionate foliage.",
                    "Preserve healthy inner foliage wherever it supports future branch development.",
                    "Do not treat spruce foliage as deciduous foliage.",
                ]
            ),
            SpeciesProfileSection(
                id: "fruit",
                title: "Cones",
                paragraphs: [
                    "Picea sitchensis produces hanging cones, a botanical character of spruce that helps distinguish Picea from Abies, which typically produce upright cones.",
                    "Cones may contribute to seasonal character but are not a primary bonsai design objective.",
                    "Do not sacrifice structural development or foliage health in pursuit of cones.",
                ]
            ),
            SpeciesProfileSection(
                id: "bark-trunk",
                title: "Bark and Trunk",
                paragraphs: [
                    "Young bark is relatively smooth and grey. With age, the bark becomes more deeply fissured and develops strong mature character.",
                    "The species can develop a substantial trunk rapidly compared with many slower-growing spruce species. This can be advantageous during development.",
                    "Allow appropriate growth to build trunk diameter and taper, but avoid allowing branches to become permanently oversized for the intended bonsai design.",
                    "Distinguish clearly between trunk development, primary structure, vigour control, secondary branching, refinement and maintenance.",
                ]
            ),
            SpeciesProfileSection(
                id: "roots-nebari",
                title: "Roots and Nebari",
                paragraphs: [
                    "Develop a balanced root system gradually.",
                    "Priorities include healthy fine roots, radial distribution, stable anchoring, gradual nebari development and avoidance of major crossing roots.",
                    "Because the species is vigorous, root development can also be vigorous when conditions are favourable.",
                    "Do not allow vigour to justify unnecessarily aggressive root reduction.",
                    "Maintain strong aeration in the root zone.",
                    "The objective is: Stable root system · Reliable recovery · Well-aerated substrate · Natural anchoring.",
                ]
            ),
            SpeciesProfileSection(
                id: "light",
                title: "Light",
                paragraphs: [
                    "Full sun is preferred for healthy development.",
                    "Adequate light supports compact growth, strong shoots, foliage density, branch development and balanced growth.",
                    "The species naturally occurs in open coastal environments as well as forest conditions.",
                    "For bonsai, sufficient light is particularly important because strong growth combined with insufficient light can result in weak, elongated shoots.",
                    "Cultivate outdoors.",
                    "Do not recommend permanent indoor cultivation.",
                ]
            ),
            SpeciesProfileSection(
                id: "wind",
                title: "Wind",
                paragraphs: [
                    "Wind is an important part of the natural ecology of Sitka Spruce.",
                    "The species can develop distinctive forms under strong coastal exposure.",
                    "However, container-grown bonsai have a restricted root system and can dry quickly in strong wind.",
                    "Strong wind can also create mechanical stress on branches and the container.",
                    "Secure the tree appropriately. Monitor moisture closely during prolonged windy conditions.",
                    "Natural wind exposure should not be interpreted as unlimited drought tolerance.",
                ]
            ),
            SpeciesProfileSection(
                id: "watering",
                title: "Watering",
                paragraphs: [
                    "Maintain consistent moisture during active growth.",
                    "Sitka Spruce naturally occurs in moist coastal environments, but bonsai cultivation still requires an open and aerated root environment.",
                    "Avoid prolonged stagnant saturation, repeated severe drying and uncontrolled moisture fluctuations.",
                    "Watering must respond to temperature, wind, humidity, rainfall, container size, substrate composition, tree size and season.",
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
                    "Do not use compacted soil.",
                    "Natural tolerance of moist coastal environments does not mean that bonsai roots should remain in stagnant, oxygen-poor substrate.",
                    "Do not prescribe one universal soil recipe.",
                    "Adapt the substrate to climate, container size and watering conditions.",
                    "Follow Bonsai World Soil Module principles.",
                    "Do not duplicate the complete Soil Module inside this profile.",
                ]
            ),
            SpeciesProfileSection(
                id: "fertilizing",
                title: "Fertilizing",
                paragraphs: [
                    "Fertilize according to development stage and tree condition.",
                    "During development, adequate nutrition can support rapid shoot development, trunk thickening, branch development and root growth.",
                    "Because the species is naturally vigorous, excessive fertilization can produce unnecessarily coarse growth.",
                    "During refinement, nutrition should be managed more carefully.",
                    "Do not attempt to suppress or accelerate growth through extreme fertilizer regimes.",
                    "Avoid fixed universal fertilizer doses.",
                    "Follow the existing Bonsai World fertilization framework.",
                ]
            ),
            SpeciesProfileSection(
                id: "pruning",
                title: "Pruning",
                paragraphs: [
                    "Pruning should be strategic and conservative despite the species' high vigour.",
                    "Priorities: establish trunk structure; establish primary branches; control excessive extension; preserve useful interior growth; develop secondary branches; refine ramification.",
                    "Do not rely on severe pruning as the primary method of controlling an overly vigorous tree.",
                    "Avoid cutting important branches into completely bare old wood.",
                    "Large structural cuts should be planned carefully and performed only when appropriate to the development stage.",
                ]
            ),
            SpeciesProfileSection(
                id: "back-budding",
                title: "Back-budding",
                paragraphs: [
                    "Back-budding should be described conservatively.",
                    "Picea sitchensis should not be expected to reliably regenerate from completely bare old wood.",
                    "New growth is most dependable where viable buds and foliage remain.",
                    "Therefore: retain useful interior shoots, preserve foliage near important branch junctions, shorten branches progressively, avoid stripping branches completely and develop secondary branches from existing viable growth.",
                    "Never promise predictable back-budding.",
                ]
            ),
            SpeciesProfileSection(
                id: "ramification",
                title: "Ramification",
                paragraphs: [
                    "Fine ramification can be developed, but controlling vigour is essential.",
                    "If extension growth is allowed to become excessive, branches can quickly become coarse.",
                    "Ramification should therefore focus on controlled shoot extension, selective pruning, branch positioning, preservation of interior shoots, progressive subdivision and maintaining balanced vigour.",
                    "Do not attempt to refine the entire tree simultaneously.",
                    "Work progressively from primary structure toward secondary and tertiary branching.",
                ]
            ),
            SpeciesProfileSection(
                id: "wiring",
                title: "Wiring",
                paragraphs: [
                    "Wiring is an important structural technique.",
                    "Use wiring to establish trunk movement, primary branch placement, secondary branch structure, downward-growing branch character and naturalistic branch hierarchy.",
                    "Because growth can be vigorous, wires must be monitored carefully.",
                    "Branches can thicken rapidly during active growth.",
                    "Remove or adjust wire before permanent scarring develops.",
                    "Use gradual movement rather than forcing mature branches beyond their natural flexibility.",
                ]
            ),
            SpeciesProfileSection(
                id: "deadwood-potential",
                title: "Deadwood",
                paragraphs: [
                    "Sitka Spruce can develop impressive natural deadwood where trees have experienced wind damage, branch loss, storm damage, exposure or natural ageing.",
                    "Naturalistic deadwood can therefore be particularly appropriate.",
                    "When creating deadwood: follow the natural grain, keep proportions appropriate, preserve structural strength, avoid excessive carving and allow weathering to contribute to the final appearance.",
                    "Coastal and storm-exposed character can support convincing naturalistic designs.",
                ]
            ),
            SpeciesProfileSection(
                id: "defoliation",
                title: "Foliage Management",
                paragraphs: [
                    "Do not recommend routine defoliation.",
                    "Picea sitchensis is an evergreen conifer.",
                    "Foliage management should focus on maintaining healthy needles, controlling excessive extension growth, preserving interior foliage, improving light distribution and balancing strong and weak areas.",
                    "Avoid excessive removal of interior foliage.",
                    "Because the species is vigorous, the temptation may be to remove large amounts of foliage simply to control growth. Indiscriminate foliage stripping is discouraged.",
                ]
            ),
            SpeciesProfileSection(
                id: "repotting",
                title: "Repotting",
                paragraphs: [
                    "Repot when the root system and substrate condition indicate that intervention is necessary.",
                    "Do not repot solely according to a fixed calendar interval.",
                    "Priorities: preserve healthy fine roots, maintain drainage, maintain oxygen availability, remove only appropriate amounts of old substrate, avoid unnecessary root disturbance and secure the tree firmly.",
                    "Because Sitka Spruce can be vigorous, root growth may be substantial. This does not justify aggressive root pruning.",
                    "Repotting timing should be adapted to local climate and physiological condition.",
                ]
            ),
            SpeciesProfileSection(
                id: "trunk-development",
                title: "Trunk Development",
                paragraphs: [
                    "Picea sitchensis can provide strong trunk development when allowed sufficient growth.",
                    "Its vigorous growth can be used to advantage during early development.",
                    "Do not keep a young development tree artificially compact when substantial trunk development is still required.",
                    "Stage 1 — Establishment: build a strong root system and healthy growth.",
                    "Stage 2 — Trunk development: allow controlled vigorous growth to build trunk diameter and taper.",
                    "Stage 3 — Primary structure: select and position major branches.",
                    "Stage 4 — Vigour control: begin controlling excessive extension growth while preserving sufficient foliage.",
                    "Stage 5 — Secondary branching: develop branch subdivision progressively.",
                    "Stage 6 — Refinement: control shoot extension and develop finer ramification.",
                    "Stage 7 — Maintenance: maintain the established structure through selective pruning and wiring.",
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
                    "Picea sitchensis is commonly propagated from seed in forestry and horticultural contexts.",
                    "Seed propagation should be described as a long-term method.",
                    "Do not present seed propagation as a rapid route to finished bonsai.",
                    "Where specialist propagation methods are mentioned, clearly identify them as specialist techniques rather than standard bonsai practice.",
                    "Detailed procedures belong in Bonsai World Propagation Knowledge Articles.",
                ]
            ),
            SpeciesProfileSection(
                id: "pests",
                title: "Pests and Problems",
                paragraphs: [
                    "Potential problems include spruce aphids, spruce-associated insect pests, spider mites during hot and dry conditions, fungal diseases, root problems caused by poorly aerated substrate, drought stress, winter drying, wire scarring, excessive extension growth, overly coarse branch development and loss of interior foliage through excessive shading.",
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
                    "Spring: buds and new shoots begin developing. Monitor rapid extension growth. Begin appropriate seasonal feeding. Review wiring. Increase watering as growth and transpiration increase. Preserve useful interior shoots.",
                    "Summer: maintain consistent moisture. Monitor strong extension growth closely. Control unwanted coarse growth. Protect the root zone from excessive heat where necessary. Maintain good airflow. Avoid heavy structural work during periods of environmental stress.",
                    "Autumn: new growth gradually hardens. Review branch structure. Complete appropriate wiring adjustments. Adjust feeding according to the existing Bonsai World seasonal framework. Prepare the tree for winter.",
                    "Winter: maintain outdoor dormancy. Protect container roots from extreme temperature fluctuations. Monitor winter drying during cold, dry and windy conditions. Avoid unnecessary root disturbance.",
                    "The species should remain outdoors through winter.",
                ]
            ),
            SpeciesProfileSection(
                id: "styles",
                title: "Bonsai Styles",
                paragraphs: [
                    "Suitable styles may include Informal Upright, Upright, Slanting, naturalistic conifer, coastal or windswept forms, rugged mountain-inspired forms and larger bonsai designs.",
                    "Windswept forms can be particularly convincing where the specimen already shows appropriate natural movement.",
                    "Because the species naturally becomes very large, it is especially suitable for medium-to-large bonsai where foliage and trunk proportions can remain convincing.",
                    "Do not force the species into an extremely small bonsai if the foliage and branch proportions become visually inappropriate.",
                    "The individual material should determine the final design.",
                ]
            ),
            SpeciesProfileSection(
                id: "tree-stage",
                title: "Development by Tree Stage",
                paragraphs: [
                    "Young nursery material: focus on health, trunk movement, rapid but controlled trunk development, root development and initial branch selection. Do not over-refine young material.",
                    "Pre-bonsai: focus on trunk taper, primary branch structure, wiring, branch positioning and controlling excessive extension growth.",
                    "Established bonsai: focus on secondary branching, foliage balance, controlled extension, selective pruning and maintenance wiring.",
                    "Mature refined bonsai: focus on fine ramification, silhouette refinement, preservation of interior foliage, mature bark, naturalistic branch hierarchy and subtle seasonal refinement. Avoid unnecessary major interventions on mature trees.",
                ]
            ),
            SpeciesProfileSection(
                id: "attention",
                title: "Species-Specific Attention",
                paragraphs: [
                    "These attention points are operational tendencies. They must still be interpreted for the individual tree.",
                    "Picea sitchensis should be presented as a vigorous coastal spruce with significant natural size.",
                    "Its natural association with the cool, wet Pacific coast makes it especially interesting for growers in similarly cool maritime climates. However, natural moisture tolerance must never be interpreted as permission to keep bonsai roots in stagnant soil.",
                ],
                bullets: [
                    "Respect its naturally large dimensions",
                    "Use vigorous growth to advantage during trunk development",
                    "Control extension growth progressively during refinement",
                    "Preserve viable interior foliage",
                    "Do not expect reliable regeneration from completely bare old wood",
                    "Avoid excessive foliage stripping",
                    "Maintain excellent substrate drainage and aeration",
                    "Monitor container moisture carefully during wind",
                    "Use wiring for structural development",
                    "Monitor wire frequently during periods of rapid growth",
                    "Allow sufficient space and time for branch development",
                    "Consider larger bonsai formats where appropriate",
                    "Use coastal, rugged or windswept character when supported by the specimen",
                    "Do not confuse moisture tolerance with stagnant bonsai soil",
                    "Do not confuse with Picea glauca, Picea engelmannii, Picea pungens, Picea omorika or Picea abies",
                    "Winter dormancy is required",
                    "Do not move indoors for routine winter care",
                ]
            ),
        ]
    }
}
