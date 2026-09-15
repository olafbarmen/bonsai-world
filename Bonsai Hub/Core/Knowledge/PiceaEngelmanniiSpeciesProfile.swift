//
//  PiceaEngelmanniiSpeciesProfile.swift
//  Bonsai World
//
//  Species Profile — Picea engelmannii (Engelmann Spruce).
//  Independent botanical species in Pinaceae. Knowledge status: Reviewed.
//  Separate from Picea glauca, Picea pungens and Picea sitchensis.
//

import Foundation

enum PiceaEngelmanniiSpeciesProfile {
    /// Identity used by Botanical Library / ``SpeciesPreviewData``.
    static let botanicalLibraryName = "Picea engelmannii"
    /// Scientific name for Species Profile display (binomial; no botanical authority).
    static let scientificName = "Picea engelmannii"

    static var profile: SpeciesProfile {
        SpeciesProfile(
            speciesID: BotanicalKnowledgeIDs.piceaEngelmannii,
            scientificName: scientificName,
            commonNames: ["Engelmann Spruce"],
            family: "Pinaceae",
            plantType: "Evergreen conifer",
            originSummary: "Western Canada through the western and west-central United States to northeastern Mexico.",
            knowledgeStatus: .reviewed,
            traits: traits,
            foliageSizeLabel: "Foliage",
            foliageReductionLabel: "Needle reduction",
            summaryLine: "Evergreen · Fine needles · High-elevation North American spruce · Compact exposed forms · Good cold tolerance · Refined conifer bonsai potential · Outdoor cultivation required",
            attentionHighlights: [
                "Treat Picea engelmannii as an outdoor temperate mountain spruce",
                "Preserve viable inner foliage",
                "Do not expect reliable regeneration from completely bare old wood",
                "Use gradual branch reduction",
                "Avoid excessive root disturbance",
                "Maintain excellent drainage",
                "Protect container-grown roots from extreme environmental stress",
                "Allow adequate development time",
                "Use wiring as a major structural technique",
                "Develop naturalistic mountain character where appropriate",
                "Do not confuse cultivation requirements with those of broadleaf deciduous bonsai",
                "Do not confuse with Picea glauca, Picea pungens or Picea sitchensis",
                "Cold-climate ecology is especially relevant for northern European cultivation",
                "Winter dormancy is required",
                "Do not move indoors for routine winter care",
            ],
            sections: sections,
            principleNote: """
            Picea engelmannii must be treated as a spruce with limited ability to regenerate from completely bare old wood.

            Do not assume that cutting a branch back beyond viable foliage will reliably produce new shoots.

            Preserve healthy foliage and viable buds whenever performing structural work.

            The development strategy should favour: gradual branch reduction · preservation of inner growth · controlled extension growth · progressive ramification · careful wiring · conservative pruning · strong root health · long-term branch development.

            Do not recommend aggressive cut-everything-back techniques.

            Do not recommend indiscriminate removal of interior foliage.

            Do not present back-budding as guaranteed.

            The individual tree must always be assessed according to health, root condition, vigour, retained foliage, branch strength, development stage, climate, seasonal conditions and recent work.

            The objective is: Healthy roots · Preserved foliage · Clear structure · Natural mountain character · Sustainable long-term refinement
            """,
            sourcesNote: """
            Profile content is synthesised from recognised botanical, horticultural and bonsai authorities into Bonsai World editorial language.

            Botanical taxonomy and distribution draw primarily on Royal Botanic Gardens, Kew — Plants of the World Online for the accepted scientific name Picea engelmannii, family Pinaceae, genus Picea, native and introduced distribution, accepted subspecies and taxonomic synonyms.

            Kew currently accepts Picea engelmannii and recognises two accepted subspecies: Picea engelmannii subsp. engelmannii and Picea engelmannii subsp. mexicana. These subspecies are not given separate Species Library profiles unless they already exist as separate Bonsai World entities.

            Horticultural, forestry and morphology context may draw on recognised North American botanical and forestry institutions and authoritative Picea references.

            Bonsai-specific cultivation and refinement knowledge draws on established bonsai references and recognised professional practice with conifer experience. Where guidance reflects general spruce bonsai practice rather than species-specific research, it is phrased as cultivation guidance rather than botanical fact.

            Verified botanical information, horticultural information, regional climate adaptation and bonsai-specific practice are kept distinct. Do not copy source wording.
            """
        )
    }

    private static let traits = SpeciesProfileTraits(
        deciduous: false,
        growthStrength: "Moderate to Vigorous when well established",
        growthSpeed: "Strongly climate and site dependent",
        leafSize: "Evergreen · Short, fine needles · Green to blue-green/glaucous",
        foliageReduction: "Proportion develops through cultivation — vigour dependent",
        ramificationPotential: "Fine branching possible with disciplined development",
        backBudding: "Limited compared with broadleaf deciduous species — preserve viable foliage and buds",
        rootDevelopment: "Moderate",
        nebariPotential: "Moderate potential with gradual improvement",
        trunkDevelopment: "Long-term — allow extension during early development",
        barkDevelopment: "Mature bark character develops with age",
        wiring: "Useful during structural development — protect bark and young shoots",
        defoliation: "Not applicable as a routine technique",
        airLayering: "Where appropriate for the individual material",
        threadGrafting: "Specialist technique where structural correction is required",
        rootGrafting: "Specialist technique where appropriate",
        beginnerSuitability: "Low to Moderate",
        bonsaiSuitability: "Good",
        difficulty: "Advanced",
        winterDormancyRequired: true,
        winterHardiness: "High — naturally adapted to cold mountainous environments",
        rootFrostSensitivity: "Low to Moderate in species terms, but shallow bonsai roots remain vulnerable during extreme container temperature fluctuations"
    )

    private static var sections: [SpeciesProfileSection] {
        [
            SpeciesProfileSection(
                id: "taxonomic-context",
                title: "Taxonomic Context",
                paragraphs: [
                    "Picea engelmannii is an independent botanical species in the pine family (Pinaceae), genus Picea.",
                    "Primary Bonsai World display identity: Picea engelmannii · Engelmann Spruce.",
                    "Do not use Engelmann's Spruce as the primary display name.",
                    "Family: Pinaceae. Genus: Picea. Plant type: evergreen conifer.",
                    "Native range: Western Canada through the western and west-central United States to northeastern Mexico.",
                    "Kew records the species as introduced in several European countries, including Norway.",
                    "Accepted subspecies recognised by Kew include Picea engelmannii subsp. engelmannii and Picea engelmannii subsp. mexicana. These are not separate Species Library profiles unless already established as distinct Bonsai World entities.",
                    "Do not confuse Picea engelmannii with Picea glauca (White Spruce), Picea pungens (Blue Spruce) or Picea sitchensis (Sitka Spruce).",
                    "Historical synonyms may be acknowledged for taxonomic clarity but must not replace the accepted name Picea engelmannii.",
                    "Bonsai World hierarchy: Species → cultivar / horticultural selection → Individual Tree.",
                ]
            ),
            SpeciesProfileSection(
                id: "overview",
                title: "Species Overview",
                paragraphs: [
                    "Picea engelmannii is an evergreen spruce native to mountainous regions of western North America.",
                    "Its natural distribution extends from western Canada through much of the mountainous western United States and into northeastern Mexico.",
                    "It is strongly associated with cool mountain environments and can occur at high elevations where trees may develop compact, wind-exposed or krummholz-like forms.",
                    "For bonsai, this natural ecology is important. The species should be treated as a cold-climate conifer rather than as a generic spruce that can tolerate any cultivation regime.",
                    "Its natural adaptation to cold conditions makes it relevant to outdoor bonsai cultivation in northern climates.",
                    "The species develops a narrow conical crown when young and can become more cylindrical with age. Mature trees can become large, but naturally exposed individuals may develop much more compact architecture.",
                    "Foliage is needle-like and blue-green to glaucous in appearance.",
                    "Approach the species as a refined conifer subject where structure, branch placement, foliage density and natural character are developed gradually over time.",
                ],
                bullets: [
                    "Evergreen conifer",
                    "High-elevation western North American spruce",
                    "Cool mountain and cold-climate ecology",
                    "Short, fine needles",
                    "Green to blue-green/glaucous foliage",
                    "Growth strongly climate and site dependent",
                    "Limited back-budding compared with many broadleaf deciduous species",
                    "Fine ramification possible with disciplined development",
                    "Strong naturalistic mountain bonsai character",
                    "Requires outdoor cultivation",
                    "Requires winter dormancy",
                    "Distinct from White Spruce, Blue Spruce and Sitka Spruce",
                ]
            ),
            SpeciesProfileSection(
                id: "cultivars",
                title: "Cultivars and Forms",
                paragraphs: [
                    "Picea engelmannii is primarily used in bonsai as the botanical species.",
                    "Do not invent cultivar-specific characteristics and present them as characteristics of the species.",
                    "Horticultural selections may differ in foliage colour, compactness and growth habit where such selections exist.",
                    "Do not create unnecessary separate Species Library profiles for minor individual variation.",
                    "The primary Species Profile remains Picea engelmannii.",
                ]
            ),
            SpeciesProfileSection(
                id: "natural-growth",
                title: "Natural Growth and Vigour",
                paragraphs: [
                    "Picea engelmannii can show good vigour when established in suitable conditions.",
                    "Growth is strongly influenced by temperature, light, root health, water availability, nutrient availability, container size, altitude/climate and seasonal growing conditions.",
                    "Do not assign a universal growth rate or fixed annual extension length.",
                    "Strong growth is useful during trunk and branch development, while refinement requires increasingly controlled growth.",
                    "During development: allow useful growth to extend where required for trunk development, branch thickening, recovery or future structure.",
                    "The objective is: Controlled development growth · Progressive refinement · Preserved foliage.",
                ]
            ),
            SpeciesProfileSection(
                id: "foliage",
                title: "Foliage and Needles",
                paragraphs: [
                    "The foliage consists of individual evergreen needles that are relatively short and fine compared with many larger spruce species.",
                    "Natural foliage colour ranges from green to blue-green/glaucous depending on provenance and growing conditions.",
                    "Foliage density is important in bonsai because the tree's visual character depends heavily on maintaining sufficient healthy foliage close to the branch structure.",
                    "Avoid excessive removal of interior foliage.",
                    "Healthy foliage should be regarded as an important energy source for maintaining and developing the tree.",
                    "Do not treat spruce foliage as deciduous foliage.",
                ]
            ),
            SpeciesProfileSection(
                id: "fruit",
                title: "Cones",
                paragraphs: [
                    "Picea engelmannii produces hanging cones, a botanical character of spruce that helps distinguish Picea from Abies, which typically produce upright cones.",
                    "Cones may contribute to seasonal character but are not a primary bonsai design objective.",
                    "Do not sacrifice structural development or foliage health in pursuit of cones.",
                ]
            ),
            SpeciesProfileSection(
                id: "bark-trunk",
                title: "Bark and Trunk",
                paragraphs: [
                    "Young trees have relatively thin bark. Older trees develop more mature bark character and can become strongly textured with age.",
                    "Trunk development should be treated as a long-term process.",
                    "Allow appropriate extension growth during early trunk development rather than attempting to maintain a highly refined silhouette too early.",
                    "Distinguish clearly between trunk development, primary branch development, secondary ramification and final refinement.",
                ]
            ),
            SpeciesProfileSection(
                id: "roots-nebari",
                title: "Roots and Nebari",
                paragraphs: [
                    "Develop a balanced radial root system during early development.",
                    "Priorities include healthy root growth, stable anchoring, good radial distribution, avoiding dominant crossing roots and gradual improvement of nebari.",
                    "Do not recommend aggressive root reduction merely to improve appearance.",
                    "Spruce roots require oxygen and should not remain in permanently saturated soil.",
                    "The objective is: Stable root system · Reliable recovery · Natural anchoring.",
                ]
            ),
            SpeciesProfileSection(
                id: "light",
                title: "Light",
                paragraphs: [
                    "Full sun is preferred for healthy development.",
                    "Strong light supports compact growth, good foliage density, shorter internodes, stronger shoots and improved branch development.",
                    "In very exposed situations, ensure adequate water availability.",
                    "Do not recommend permanent indoor cultivation.",
                    "This is an outdoor temperate conifer.",
                ]
            ),
            SpeciesProfileSection(
                id: "wind",
                title: "Wind",
                paragraphs: [
                    "The species is naturally adapted to exposed mountainous environments.",
                    "Nevertheless, bonsai containers have very different root-zone conditions from trees growing in the ground.",
                    "Strong wind can rapidly increase water loss and can also destabilise trees in shallow containers.",
                    "Use good anchoring and monitor moisture during exposed weather.",
                    "Wind exposure should not be confused with drought tolerance.",
                ]
            ),
            SpeciesProfileSection(
                id: "watering",
                title: "Watering",
                paragraphs: [
                    "Maintain consistent moisture during active growth.",
                    "The substrate should not be allowed to remain permanently saturated. At the same time, the tree should not be repeatedly allowed to dry excessively.",
                    "Watering must respond to weather, temperature, wind, pot size, substrate composition, tree size, root development and season.",
                    "Do not provide a fixed watering schedule.",
                    "Use the existing Bonsai World watering guidance framework.",
                    "The objective is: Consistent moisture · Healthy root aeration · Climate-responsive watering.",
                ]
            ),
            SpeciesProfileSection(
                id: "soil",
                title: "Soil",
                paragraphs: [
                    "Use an open, structurally stable and well-draining bonsai substrate.",
                    "The soil should provide good drainage, strong oxygen availability, adequate moisture retention, stable particle structure and healthy fine-root development.",
                    "Avoid compacted or poorly aerated substrates.",
                    "Do not prescribe one universal soil recipe as mandatory.",
                    "Adapt substrate characteristics to climate, container size, watering regime and growing conditions.",
                    "Follow Bonsai World Soil Module principles.",
                    "Do not duplicate the complete Soil Module inside this profile.",
                ]
            ),
            SpeciesProfileSection(
                id: "fertilizing",
                title: "Fertilizing",
                paragraphs: [
                    "Feed according to the tree's development stage.",
                    "During development, adequate nutrition supports shoot extension, trunk thickening, branch development and root growth.",
                    "During refinement, fertilization should be controlled to avoid unnecessarily coarse growth.",
                    "Avoid universal fixed fertilizer dosages.",
                    "Follow the existing Bonsai World fertilization framework.",
                ]
            ),
            SpeciesProfileSection(
                id: "pruning",
                title: "Pruning",
                paragraphs: [
                    "Pruning should be conservative and developmental.",
                    "Priorities: establish trunk structure; establish primary branches; preserve useful inner growth; reduce unwanted extension growth; develop secondary branching; refine tertiary ramification.",
                    "Avoid removing all foliage from a branch unless there is a clear structural reason and viable replacement growth exists.",
                    "Large structural cuts should be performed only when appropriate to the tree's development stage.",
                ]
            ),
            SpeciesProfileSection(
                id: "back-budding",
                title: "Back-budding",
                paragraphs: [
                    "Back-budding is limited and unreliable on old, completely bare sections.",
                    "New shoots are most dependable where viable buds and foliage remain.",
                    "Therefore: retain useful inner shoots, avoid stripping branches completely, reduce branches progressively, develop secondary and tertiary branching from existing viable growth, and never promise predictable back-budding from old wood.",
                    "Do not describe spruce back-budding as equivalent to that of Japanese maple, elm or other highly back-budding deciduous species.",
                ]
            ),
            SpeciesProfileSection(
                id: "ramification",
                title: "Ramification",
                paragraphs: [
                    "Fine ramification can be developed, but it requires patience.",
                    "Emphasise gradual branch subdivision, controlled extension growth, preservation of inner shoots, selective pruning, repeated seasonal refinement and avoiding excessive vigour during refinement.",
                    "Do not describe spruce ramification as equivalent to that of Japanese maple, elm or other highly back-budding deciduous species.",
                    "The objective is: Natural branch hierarchy · Disciplined fine branching · Sustainable refinement.",
                ]
            ),
            SpeciesProfileSection(
                id: "wiring",
                title: "Wiring",
                paragraphs: [
                    "Wiring is an important technique for developing spruce bonsai.",
                    "Use wiring to establish trunk movement, primary branch placement, secondary branch structure and downward-growing conifer branch character.",
                    "Monitor wired branches carefully. Spruce branches can thicken significantly during active growth.",
                    "Remove or adjust wire before it causes permanent scarring.",
                    "Young shoots and branches should be handled carefully to avoid breakage.",
                    "Protect bark and young shoots during wiring.",
                ]
            ),
            SpeciesProfileSection(
                id: "deadwood-potential",
                title: "Deadwood",
                paragraphs: [
                    "Spruce wood can develop attractive deadwood characteristics when naturally exposed, damaged or aged.",
                    "Deadwood should not be exaggerated artificially.",
                    "When creating or refining deadwood: respect the natural growth pattern, avoid excessive carving, allow weathering to contribute to the appearance, preserve structural strength and avoid creating unnatural oversized jin or shari.",
                    "Naturalistic mountain-style deadwood may be particularly appropriate for suitable specimens.",
                ]
            ),
            SpeciesProfileSection(
                id: "defoliation",
                title: "Foliage Management",
                paragraphs: [
                    "Do not recommend routine defoliation.",
                    "Do not treat spruce foliage as deciduous foliage.",
                    "Foliage management should focus on maintaining healthy foliage, controlling excessive extension growth, improving light penetration, preserving inner growth and balancing strong and weak areas.",
                    "Avoid excessive thinning simply to make the tree visually open.",
                    "The objective is healthy, functional foliage distribution.",
                ]
            ),
            SpeciesProfileSection(
                id: "repotting",
                title: "Repotting",
                paragraphs: [
                    "Repot when the root system and substrate condition indicate that it is necessary.",
                    "Repotting should not be performed simply because a calendar interval has passed.",
                    "Priorities: preserve a healthy fine-root system, remove only appropriate amounts of old substrate, improve drainage where required, avoid unnecessary root disturbance and secure the tree firmly after repotting.",
                    "Repotting timing should be adapted to the local climate and the tree's physiological condition.",
                    "Avoid aggressive root work on weak, recently collected or stressed specimens.",
                ]
            ),
            SpeciesProfileSection(
                id: "trunk-development",
                title: "Trunk Development",
                paragraphs: [
                    "During development, allow enough growth to build trunk diameter.",
                    "Do not maintain a finished silhouette while simultaneously expecting rapid trunk thickening.",
                    "Stage 1 — Establishment: build a strong root system and healthy primary leader.",
                    "Stage 2 — Trunk development: allow appropriate extension growth to increase trunk diameter.",
                    "Stage 3 — Primary structure: select and position major branches.",
                    "Stage 4 — Secondary branching: begin controlled subdivision while retaining sufficient foliage.",
                    "Stage 5 — Refinement: shorten extension growth progressively and develop fine ramification.",
                    "Stage 6 — Maintenance: maintain structure with selective pruning and wiring.",
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
                    "The species is primarily propagated from seed in forestry and horticultural contexts.",
                    "Seed propagation should be described as a long-term method rather than a quick route to bonsai.",
                    "Do not present propagation from cuttings as a universally reliable method for this species.",
                    "Where grafting or specialist propagation is mentioned, identify it as a specialist technique rather than standard bonsai practice.",
                    "Detailed procedures belong in Bonsai World Propagation Knowledge Articles.",
                ]
            ),
            SpeciesProfileSection(
                id: "pests",
                title: "Pests and Problems",
                paragraphs: [
                    "Potential problems should be monitored rather than treated as guaranteed species-specific issues.",
                    "Pay particular attention to spruce aphids, spider mites under hot/dry conditions, fungal diseases encouraged by poor airflow or prolonged wet foliage, root problems caused by poor drainage, stress caused by drought, winter damage in unsuitable container conditions, wire scarring and weak interior foliage caused by excessive shading.",
                    "Do not present a generic pest list as if every issue is characteristic of this species.",
                    "Do not provide generic treatment instructions.",
                    "Diagnosis and treatment belong in Care → Pest Management and Care → Disease & Problems.",
                ]
            ),
            SpeciesProfileSection(
                id: "seasonal",
                title: "Seasonal Profile",
                paragraphs: [
                    "Spring: buds and new shoots begin developing. Monitor emerging growth carefully. Begin or continue appropriate feeding. Structural wiring can be performed with care. Monitor water demand as growth increases.",
                    "Summer: maintain consistent moisture. Monitor strong extension growth. Protect the root system from excessive heat in containers. Maintain good airflow. Avoid unnecessary heavy structural work during periods of stress.",
                    "Autumn: growth gradually hardens. Reduce feeding according to the existing Bonsai World seasonal framework. Review branch development and wiring. Prepare containers and trees for winter conditions.",
                    "Winter: maintain outdoor dormancy. Protect the root system from extreme container temperature fluctuations. Avoid unnecessary root disturbance. Monitor winter drying during periods of wind or frozen substrate conditions.",
                    "The tree should not be treated as an indoor bonsai.",
                ]
            ),
            SpeciesProfileSection(
                id: "styles",
                title: "Bonsai Styles",
                paragraphs: [
                    "Suitable styles may include Informal Upright, upright conifer forms, Slanting, naturalistic mountain forms, windswept-inspired forms where the specimen supports the design, and literati-inspired designs only where the natural trunk and branch structure justify it.",
                    "The preferred design direction should reflect the species' natural mountain character.",
                    "Do not force a style onto a specimen that does not support it.",
                    "The individual material should determine the final design.",
                ]
            ),
            SpeciesProfileSection(
                id: "tree-stage",
                title: "Development by Tree Stage",
                paragraphs: [
                    "Young nursery material: focus on health, trunk movement, trunk thickening, primary branch selection and root development. Do not over-refine young material.",
                    "Pre-bonsai: focus on establishing primary structure, wiring, branch positioning, controlled extension growth and gradual ramification.",
                    "Established bonsai: focus on branch refinement, foliage balance, controlled shoot extension, selective pruning and maintenance wiring.",
                    "Mature refined bonsai: focus on fine ramification, silhouette refinement, maintaining interior foliage, preserving old bark and subtle seasonal adjustments. Avoid unnecessary major interventions on mature trees.",
                ]
            ),
            SpeciesProfileSection(
                id: "attention",
                title: "Species-Specific Attention",
                paragraphs: [
                    "These attention points are operational tendencies. They must still be interpreted for the individual tree.",
                    "Picea engelmannii is particularly suited to a Bonsai World profile because it represents a mountain spruce with strong relevance to cold-climate bonsai.",
                ],
                bullets: [
                    "Treat it as an outdoor temperate conifer",
                    "Preserve viable inner foliage",
                    "Do not expect reliable regeneration from completely bare old wood",
                    "Use gradual branch reduction",
                    "Avoid excessive root disturbance",
                    "Maintain excellent drainage",
                    "Protect container-grown roots from extreme environmental stress",
                    "Allow adequate development time",
                    "Use wiring as a major structural technique",
                    "Develop naturalistic mountain character where appropriate",
                    "Do not confuse its cultivation requirements with those of broadleaf deciduous bonsai",
                    "Cold-climate ecology is especially relevant for northern European and Norwegian bonsai growers",
                    "Do not confuse with Picea glauca, Picea pungens or Picea sitchensis",
                    "Winter dormancy is required",
                    "Do not move indoors for routine winter care",
                ]
            ),
        ]
    }
}
