//
//  PiceaOmorikaSpeciesProfile.swift
//  Bonsai World
//
//  Species Profile — Picea omorika (Serbian Spruce).
//  Independent botanical species in Pinaceae. Knowledge status: Reviewed.
//  Separate from Picea abies, Picea orientalis, Picea glauca, Picea engelmannii and Picea pungens.
//

import Foundation

enum PiceaOmorikaSpeciesProfile {
    /// Identity used by Botanical Library / ``SpeciesPreviewData``.
    static let botanicalLibraryName = "Picea omorika"
    /// Scientific name for Species Profile display (binomial; no botanical authority).
    static let scientificName = "Picea omorika"

    static var profile: SpeciesProfile {
        SpeciesProfile(
            speciesID: BotanicalKnowledgeIDs.piceaOmorika,
            scientificName: scientificName,
            commonNames: ["Serbian Spruce"],
            family: "Pinaceae",
            plantType: "Evergreen conifer",
            originSummary: "A very restricted natural range in the western Balkans, particularly in Serbia and Bosnia and Herzegovina.",
            knowledgeStatus: .reviewed,
            traits: traits,
            foliageSizeLabel: "Foliage",
            foliageReductionLabel: "Needle reduction",
            summaryLine: "Evergreen · Narrow elegant crown · Short two-tone needles · Strong apical growth · Naturally pendulous lower branches · Upright and naturalistic conifer designs",
            attentionHighlights: [
                "Respect its naturally narrow crown",
                "Use its tiered branch structure where appropriate",
                "Preserve the characteristic descending lower branches",
                "Control strong apical growth",
                "Protect weaker lower and interior branches",
                "Preserve viable inner foliage",
                "Do not expect reliable regeneration from completely bare old wood",
                "Use gradual branch reduction",
                "Maintain excellent substrate drainage and aeration",
                "Use wiring to establish natural conifer branch structure",
                "Allow sufficient time for fine ramification",
                "Avoid forcing the species into a broad, heavy silhouette",
                "Do not confuse with Picea abies, Picea orientalis, Picea glauca, Picea engelmannii or Picea pungens",
                "Winter dormancy is required",
                "Do not move indoors for routine winter care",
            ],
            sections: sections,
            principleNote: """
            Picea omorika has strong apical dominance.

            The strongest growth is generally concentrated toward the upper and outer parts of the tree.

            Bonsai development must therefore actively manage the balance between apex, upper branches, middle branches, lower branches and interior growth.

            Do not allow the apex to dominate indefinitely if the objective is balanced bonsai structure.

            At the same time, do not respond with excessive pruning.

            Picea omorika must also be treated as a spruce with limited ability to regenerate from completely bare old wood.

            Preserve healthy foliage and viable buds.

            Do not assume that severe cuts into bare old wood will reliably produce new shoots.

            Development should favour gradual branch reduction and preservation of useful inner growth.

            The individual tree must always be assessed according to health, root condition, vigour, retained foliage, branch strength, development stage, climate, seasonal conditions and recent work.

            The objective is: Balanced vigour · Preserved foliage · Narrow elegant architecture · Sustainable long-term refinement
            """,
            sourcesNote: """
            Profile content is synthesised from recognised botanical, horticultural and bonsai authorities into Bonsai World editorial language.

            Botanical taxonomy and distribution draw primarily on Royal Botanic Gardens, Kew — Plants of the World Online for the accepted scientific name Picea omorika, family Pinaceae, genus Picea, native distribution and taxonomic information.

            Horticultural, forestry and morphology context may draw on recognised European botanical and forestry institutions and authoritative Picea references.

            Bonsai-specific cultivation and refinement knowledge draws on established bonsai references and recognised professional practice with conifer experience. Where guidance reflects general spruce bonsai practice rather than species-specific research, it is phrased as cultivation guidance rather than botanical fact.

            Verified botanical information, horticultural information, regional climate adaptation and bonsai-specific practice are kept distinct. Do not copy source wording.
            """
        )
    }

    private static let traits = SpeciesProfileTraits(
        deciduous: false,
        growthStrength: "Moderate to Vigorous, with strong apical dominance",
        growthSpeed: "Moderate to Vigorous when established — strongly climate and site dependent",
        leafSize: "Evergreen · Short, fine needles · Dark green above, paler below",
        foliageReduction: "Proportion develops through cultivation — vigour dependent",
        ramificationPotential: "Fine branching possible with gradual development",
        backBudding: "Limited and unreliable from completely bare old wood",
        rootDevelopment: "Moderate",
        nebariPotential: "Moderate potential with gradual improvement",
        trunkDevelopment: "Long-term — preserve natural slender taper",
        barkDevelopment: "Greater texture and character with age",
        wiring: "Useful for establishing branch structure and natural cascading/descending branch character",
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
                    "Picea omorika is an independent botanical species in the pine family (Pinaceae), genus Picea.",
                    "Primary Bonsai World display identity: Picea omorika · Serbian Spruce.",
                    "Family: Pinaceae. Genus: Picea. Plant type: evergreen conifer.",
                    "Native range: a very restricted natural range in the western Balkans, particularly in Serbia and Bosnia and Herzegovina.",
                    "Do not confuse Picea omorika with Picea abies (Norway Spruce), Picea orientalis (Oriental Spruce), Picea glauca (White Spruce), Picea engelmannii (Engelmann Spruce) or Picea pungens (Blue Spruce).",
                    "Bonsai World hierarchy: Species → cultivar / horticultural selection → Individual Tree.",
                ]
            ),
            SpeciesProfileSection(
                id: "overview",
                title: "Species Overview",
                paragraphs: [
                    "Picea omorika, commonly known as Serbian Spruce, is an evergreen conifer with a highly distinctive natural form.",
                    "It has a very restricted natural distribution in the western Balkans and is considered a geographically restricted species.",
                    "The species is characterised by a narrow, slender crown and a relatively thin trunk compared with the overall height of mature trees.",
                    "Branches are typically arranged in tiers, with lower branches tending to become pendulous. This architecture is particularly valuable for bonsai because the natural form already contains many of the visual characteristics desired in a mature conifer design.",
                    "The needles are short and relatively fine, with a distinctive two-tone appearance: dark green upper surfaces and much paler lower surfaces. When viewed from different angles, this can create a characteristic silver-green effect.",
                    "Picea omorika can develop attractive mature bark and a strongly tapered trunk.",
                    "For bonsai, the species should be developed gradually, taking advantage of its natural slender architecture rather than attempting to force it into a broad, heavy form.",
                ],
                bullets: [
                    "Evergreen conifer",
                    "Restricted western Balkan native range",
                    "Narrow, slender crown",
                    "Strong apical dominance",
                    "Tiered branches with pendulous lower branches",
                    "Short, fine two-tone needles",
                    "Limited back-budding from bare old wood",
                    "Fine ramification possible with gradual development",
                    "High cold tolerance",
                    "Requires outdoor cultivation",
                    "Requires winter dormancy",
                    "Distinct from Norway, Oriental, White, Engelmann and Blue spruce",
                ]
            ),
            SpeciesProfileSection(
                id: "cultivars",
                title: "Cultivars and Forms",
                paragraphs: [
                    "Picea omorika is primarily used in bonsai as the botanical species.",
                    "Do not invent cultivar-specific characteristics and present them as characteristics of the species.",
                    "Horticultural selections may differ in compactness and growth habit where such selections exist.",
                    "Do not create unnecessary separate Species Library profiles for minor individual variation.",
                    "The primary Species Profile remains Picea omorika.",
                ]
            ),
            SpeciesProfileSection(
                id: "natural-growth",
                title: "Natural Growth and Vigour",
                paragraphs: [
                    "Picea omorika can show good growth when established under suitable conditions.",
                    "Strong apical growth is an important characteristic.",
                    "Growth is influenced by light, temperature, water, nutrition, root health, container size, substrate, local climate and seasonal conditions.",
                    "Do not provide a universal annual growth rate.",
                    "During development, controlled extension growth can be used for trunk and branch development.",
                    "During refinement, apical vigour should be balanced against weaker interior and lower branches.",
                    "The objective is: Controlled apical vigour · Strengthened lower growth · Progressive development.",
                ]
            ),
            SpeciesProfileSection(
                id: "foliage",
                title: "Foliage and Needles",
                paragraphs: [
                    "Needles are short, relatively fine and evergreen.",
                    "The upper surface is dark green while the lower surface is noticeably paler, producing a characteristic two-tone appearance that can contribute strongly to the visual identity of the bonsai.",
                    "Do not remove excessive interior foliage.",
                    "Maintain healthy foliage on branches that are being developed or retained.",
                    "Because lower branches can be weaker than the apex, indiscriminate foliage removal may further weaken them.",
                    "Do not treat spruce foliage as deciduous foliage.",
                ]
            ),
            SpeciesProfileSection(
                id: "fruit",
                title: "Cones",
                paragraphs: [
                    "Picea omorika produces hanging cones, a botanical character of spruce that helps distinguish Picea from Abies, which typically produce upright cones.",
                    "Cones may contribute to seasonal character but are not a primary bonsai design objective.",
                    "Do not sacrifice structural development or foliage health in pursuit of cones.",
                ]
            ),
            SpeciesProfileSection(
                id: "bark-trunk",
                title: "Bark and Trunk",
                paragraphs: [
                    "Young bark is relatively smooth. With age, the bark develops greater texture and character.",
                    "The species naturally develops a slender trunk and narrow crown. This can be highly effective in bonsai.",
                    "Allow sufficient growth during trunk development rather than prematurely maintaining a finished silhouette.",
                    "The natural taper and elegant vertical architecture should be preserved where possible.",
                    "Distinguish clearly between trunk development, primary branch development, balancing apical dominance, secondary branching, fine ramification and maintenance.",
                ]
            ),
            SpeciesProfileSection(
                id: "roots-nebari",
                title: "Roots and Nebari",
                paragraphs: [
                    "Develop a balanced radial root system gradually.",
                    "Priorities include healthy fine roots, radial distribution, stable anchoring, gradual nebari development and avoidance of major crossing roots.",
                    "Do not perform aggressive root reduction simply to improve appearance.",
                    "Maintain good substrate aeration and avoid prolonged oxygen-poor conditions.",
                    "The objective is: Stable root system · Reliable recovery · Natural anchoring.",
                ]
            ),
            SpeciesProfileSection(
                id: "light",
                title: "Light",
                paragraphs: [
                    "Full sun is preferred for strong and balanced development.",
                    "Adequate light supports compact foliage, strong branch development, balanced growth and healthy needle production.",
                    "Because the species has strong apical dominance, good light is particularly important for maintaining healthy lower and interior growth.",
                    "The tree should be cultivated outdoors.",
                    "Do not recommend permanent indoor cultivation.",
                ]
            ),
            SpeciesProfileSection(
                id: "wind",
                title: "Wind",
                paragraphs: [
                    "The species is adapted to mountainous European conditions.",
                    "However, bonsai containers expose the root system to greater environmental fluctuations than trees growing in the ground.",
                    "Strong wind can increase water loss and destabilise shallow containers.",
                    "Secure the tree appropriately and monitor moisture during prolonged windy weather.",
                    "Do not interpret wind tolerance as unlimited drought tolerance.",
                ]
            ),
            SpeciesProfileSection(
                id: "watering",
                title: "Watering",
                paragraphs: [
                    "Maintain consistent moisture during active growth.",
                    "The substrate should drain freely while retaining enough moisture to support healthy growth.",
                    "Avoid prolonged stagnant saturation, repeated severe drying and large uncontrolled moisture fluctuations.",
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
                    "Do not use heavy, compacted soil.",
                    "Do not prescribe one universal soil recipe.",
                    "Adapt substrate characteristics to the local climate, container size and watering regime.",
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
                    "During refinement, nutrition should be controlled to prevent unnecessarily coarse extension growth.",
                    "Pay particular attention to the difference in vigour between the apex and lower branches.",
                    "Avoid fixed universal fertilizer doses.",
                    "Follow the existing Bonsai World fertilization framework.",
                ]
            ),
            SpeciesProfileSection(
                id: "pruning",
                title: "Pruning",
                paragraphs: [
                    "Pruning should be conservative and strategic.",
                    "Important objectives: establish trunk structure; establish primary branches; control apical dominance; preserve lower and interior growth; develop secondary branches; refine ramification.",
                    "Do not repeatedly remove strong growth from the apex while neglecting the overall energy balance of the tree.",
                    "Avoid cutting important branches back into completely bare old wood.",
                    "Large structural cuts should only be performed when appropriate to the tree's development stage.",
                ]
            ),
            SpeciesProfileSection(
                id: "back-budding",
                title: "Back-budding",
                paragraphs: [
                    "Back-budding should be described conservatively.",
                    "Picea omorika should not be expected to reliably regenerate from completely bare old wood.",
                    "New growth is most dependable where viable buds and foliage remain.",
                    "Therefore: retain useful interior shoots, preserve foliage close to important branch junctions, reduce branches progressively, avoid stripping branches completely and develop secondary branching from existing viable growth.",
                    "Never promise predictable back-budding.",
                ]
            ),
            SpeciesProfileSection(
                id: "ramification",
                title: "Ramification",
                paragraphs: [
                    "Fine ramification can be developed with time.",
                    "The main challenge is balancing strong apical growth with the development of weaker lower and interior branches.",
                    "Ramification should therefore focus on controlled extension growth, selective pruning, branch positioning, preservation of interior shoots and gradual subdivision.",
                    "Do not attempt to create excessive ramification too early.",
                    "The objective is: Natural branch hierarchy · Balanced vigour · Sustainable fine branching.",
                ]
            ),
            SpeciesProfileSection(
                id: "wiring",
                title: "Wiring",
                paragraphs: [
                    "Wiring is an important structural technique for this species.",
                    "Use wiring to establish trunk movement, primary branch placement, secondary branching, downward branch character and natural tiering.",
                    "The naturally pendulous character of lower branches can be incorporated into the design.",
                    "Do not force every branch into a horizontal position.",
                    "Monitor wire carefully during active growth.",
                    "Remove or adjust wire before it causes permanent scarring.",
                ]
            ),
            SpeciesProfileSection(
                id: "deadwood-potential",
                title: "Deadwood",
                paragraphs: [
                    "Deadwood can be incorporated where it reflects the natural history of the tree.",
                    "Suitable specimens may support restrained jin, naturally damaged branches and subtle weathered features.",
                    "Avoid excessive carving.",
                    "The deadwood should remain proportionate to the slender trunk and elegant character of the species.",
                ]
            ),
            SpeciesProfileSection(
                id: "defoliation",
                title: "Foliage Management",
                paragraphs: [
                    "Do not recommend routine defoliation.",
                    "Picea omorika is an evergreen conifer.",
                    "Foliage management should focus on maintaining healthy needles, preserving interior foliage, balancing strong and weak areas, improving light penetration where appropriate and controlling excessive extension growth.",
                    "Avoid excessive removal of lower or interior foliage.",
                    "Because lower branches can be weaker than the apex, indiscriminate foliage removal may further weaken them.",
                ]
            ),
            SpeciesProfileSection(
                id: "repotting",
                title: "Repotting",
                paragraphs: [
                    "Repot when the root system and substrate condition indicate that intervention is necessary.",
                    "Do not repot solely according to a fixed calendar interval.",
                    "Priorities: preserve healthy fine roots, maintain good drainage, maintain oxygen availability, remove only appropriate amounts of old substrate, avoid unnecessary root disturbance and secure the tree firmly.",
                    "Repotting timing should be adapted to local climate and physiological condition.",
                    "Avoid aggressive root work on weak or stressed trees.",
                ]
            ),
            SpeciesProfileSection(
                id: "trunk-development",
                title: "Trunk Development",
                paragraphs: [
                    "The natural slender form of Picea omorika should influence trunk development.",
                    "During early development, allow sufficient growth to build trunk diameter and taper.",
                    "Do not attempt to maintain a highly refined silhouette while simultaneously expecting rapid trunk thickening.",
                    "Stage 1 — Establishment: build a healthy root system and strong growth.",
                    "Stage 2 — Trunk development: allow controlled extension growth to increase trunk diameter and establish taper.",
                    "Stage 3 — Primary structure: select and position the major branches.",
                    "Stage 4 — Balance: control apical dominance and strengthen useful lower/interior branches.",
                    "Stage 5 — Secondary branching: develop branch subdivision while preserving sufficient foliage.",
                    "Stage 6 — Refinement: control extension growth and improve fine ramification.",
                    "Stage 7 — Maintenance: maintain structure through selective pruning and wiring.",
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
                    "Picea omorika is commonly propagated from seed in horticultural and forestry contexts.",
                    "Seed propagation should be described as a long-term method.",
                    "Do not present propagation as a rapid route to finished bonsai.",
                    "Specialist propagation methods may be mentioned where reliable sources support them, but should not be presented as standard bonsai practice.",
                    "Detailed procedures belong in Bonsai World Propagation Knowledge Articles.",
                ]
            ),
            SpeciesProfileSection(
                id: "pests",
                title: "Pests and Problems",
                paragraphs: [
                    "Potential problems include aphids, spruce-associated insect pests, spider mites under hot and dry conditions, fungal diseases, root problems caused by poor drainage, drought stress, winter drying, wire scarring, excessive apical dominance and loss of weak lower branches through excessive shading.",
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
                    "Spring: buds and new shoots begin developing. Monitor strong apical extension. Begin appropriate seasonal feeding. Review wiring. Increase watering as growth increases. Preserve developing lower and interior shoots.",
                    "Summer: maintain consistent moisture. Monitor strong extension growth. Balance the development of upper and lower branches. Protect container roots from excessive heat where necessary. Avoid heavy structural work when the tree is stressed.",
                    "Autumn: new growth gradually hardens. Review branch structure. Complete appropriate wiring adjustments. Adjust feeding according to the existing Bonsai World seasonal framework. Prepare for winter.",
                    "Winter: maintain outdoor dormancy. Protect the root system from extreme container temperature fluctuations. Monitor winter drying during cold, dry and windy periods. Avoid unnecessary root disturbance.",
                    "The tree should remain outdoors through winter.",
                ]
            ),
            SpeciesProfileSection(
                id: "styles",
                title: "Bonsai Styles",
                paragraphs: [
                    "Suitable styles may include Informal Upright, Upright, Slanting, naturalistic conifer, slender mountain forms, windswept forms where supported by the specimen and literati-inspired designs where the trunk character justifies it.",
                    "The species' natural narrow crown and tiered branch structure should strongly influence the design.",
                    "Do not force it into an artificially broad or heavy crown.",
                    "The individual material should determine the final design.",
                ]
            ),
            SpeciesProfileSection(
                id: "tree-stage",
                title: "Development by Tree Stage",
                paragraphs: [
                    "Young nursery material: focus on health, trunk movement, trunk thickening, root development and initial branch selection. Do not over-refine young material.",
                    "Pre-bonsai: focus on trunk taper, primary branch structure, wiring, branch positioning and controlling apical dominance.",
                    "Established bonsai: focus on secondary branching, foliage balance, lower-branch strength, controlled extension growth, selective pruning and maintenance wiring.",
                    "Mature refined bonsai: focus on fine ramification, silhouette refinement, preservation of interior foliage, mature bark, maintaining branch hierarchy and subtle seasonal refinement. Avoid unnecessary major interventions on mature trees.",
                ]
            ),
            SpeciesProfileSection(
                id: "attention",
                title: "Species-Specific Attention",
                paragraphs: [
                    "These attention points are operational tendencies. They must still be interpreted for the individual tree.",
                    "Picea omorika has a distinctive architecture that should be used as a major design advantage.",
                ],
                bullets: [
                    "Respect its naturally narrow crown",
                    "Use its tiered branch structure where appropriate",
                    "Preserve the characteristic descending lower branches",
                    "Control strong apical growth",
                    "Protect weaker lower and interior branches",
                    "Preserve viable inner foliage",
                    "Do not expect reliable regeneration from completely bare old wood",
                    "Use gradual branch reduction",
                    "Maintain excellent substrate drainage and aeration",
                    "Use wiring to establish natural conifer branch structure",
                    "Allow sufficient time for fine ramification",
                    "Avoid forcing the species into a broad, heavy silhouette",
                    "Especially suitable for refined naturalistic conifer bonsai",
                    "Do not confuse with Picea abies, Picea orientalis, Picea glauca, Picea engelmannii or Picea pungens",
                    "Winter dormancy is required",
                    "Do not move indoors for routine winter care",
                ]
            ),
        ]
    }
}
