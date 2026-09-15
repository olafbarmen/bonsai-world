//
//  ChamaecyparisPisiferaSpeciesProfile.swift
//  Bonsai World
//
//  Species Profile — Chamaecyparis pisifera (Sawara Cypress).
//  Independent botanical species in Cupressaceae. Knowledge status: Reviewed.
//  Separate from C. lawsoniana, C. obtusa, C. nootkatensis, Cupressus and named cultivars.
//

import Foundation

enum ChamaecyparisPisiferaSpeciesProfile {
    /// Identity used by Botanical Library / ``SpeciesPreviewData``.
    static let botanicalLibraryName = "Chamaecyparis pisifera"
    /// Scientific name for Species Profile display (binomial; no botanical authority).
    static let scientificName = "Chamaecyparis pisifera"

    static var profile: SpeciesProfile {
        SpeciesProfile(
            speciesID: BotanicalKnowledgeIDs.chamaecyparisPisifera,
            scientificName: scientificName,
            commonNames: ["Sawara Cypress"],
            family: "Cupressaceae",
            plantType: "Evergreen conifer",
            originSummary: "Japan.",
            knowledgeStatus: .reviewed,
            traits: traits,
            foliageSizeLabel: "Foliage",
            foliageReductionLabel: "Foliage management",
            summaryLine: "Evergreen · Scale-like foliage · Dense branching potential · Strong horticultural diversity · Outdoor cultivation required",
            attentionHighlights: [
                "Treat the species separately from its cultivars",
                "Do not assume all forms have the same growth habit",
                "Do not assume all forms have the same foliage colour",
                "Preserve viable inner foliage",
                "Do not expect reliable regeneration from completely bare old wood",
                "Avoid excessive outer shearing",
                "Maintain three-dimensional branch structure",
                "Maintain excellent substrate drainage and aeration",
                "Use wiring to establish structure gradually",
                "Monitor wire carefully",
                "Allow adequate time for ramification",
                "Use natural architecture as the basis for design",
                "Keep cultivar-specific information in cultivar profiles where applicable",
                "Do not confuse with Chamaecyparis lawsoniana, C. obtusa, C. nootkatensis or Cupressus",
                "Winter dormancy is required",
                "Do not move indoors for routine winter care",
            ],
            sections: sections,
            principleNote: """
            Chamaecyparis pisifera must be treated as an evergreen conifer with limited and unpredictable ability to regenerate from completely bare old wood.

            Do not assume that hard pruning into old, leafless branches will reliably produce new shoots.

            Preserve healthy foliage, viable buds, useful inner shoots and structurally important branch sections.

            Development should favour: gradual branch reduction · preservation of inner growth · controlled extension growth · progressive ramification · careful wiring · conservative structural pruning.

            Do not treat this species like a freely back-budding deciduous bonsai.

            Do not present back-budding as guaranteed.

            Do not transfer cultivar-specific foliage colours, density, growth rate or habit to the species as a whole.

            The individual tree must always be assessed according to health, vigour, foliage density, root condition, development stage, climate, genetic form and recent work.

            The objective is: Healthy foliage · Three-dimensional branch structure · Progressive refinement · Clear species–cultivar distinction · Sustainable long-term development
            """,
            sourcesNote: """
            Profile content is synthesised from recognised botanical, horticultural and bonsai authorities into Bonsai World editorial language.

            Botanical taxonomy and distribution draw primarily on Royal Botanic Gardens, Kew — Plants of the World Online for the accepted scientific name Chamaecyparis pisifera, family Cupressaceae, genus Chamaecyparis, native distribution and taxonomic information.

            Horticultural context may draw on recognised forestry, horticultural and botanical institutions. Authoritative horticultural sources should be used when discussing named cultivars.

            Bonsai-specific cultivation and refinement knowledge draws on established bonsai references and recognised professional practice with conifer experience. Where guidance reflects general conifer bonsai practice rather than species-specific research, it is phrased as cultivation guidance rather than botanical fact.

            Verified botanical information, horticultural information, cultivar-specific horticulture and bonsai-specific practice are kept distinct. Do not copy source wording.
            """
        )
    }

    private static let traits = SpeciesProfileTraits(
        deciduous: false,
        growthStrength: "Moderate to Vigorous depending on form and growing conditions",
        growthSpeed: "Moderate to Vigorous — strongly form and climate dependent",
        leafSize: "Evergreen · Scale-like foliage · Green to blue-green at species level",
        foliageReduction: "Not applicable",
        ramificationPotential: "Dense and fine branching possible with gradual development",
        backBudding: "Limited and unreliable from completely bare old wood",
        rootDevelopment: "Moderate",
        nebariPotential: "Moderate potential with gradual improvement",
        trunkDevelopment: "Long-term — allow extension during early development",
        barkDevelopment: "Greater texture and character with age",
        wiring: "Useful for trunk and branch development",
        defoliation: "Not applicable as a routine technique",
        airLayering: "Where appropriate for the individual material",
        threadGrafting: "Specialist technique where structural correction is required",
        rootGrafting: "Specialist technique where appropriate",
        beginnerSuitability: "Low to Moderate",
        bonsaiSuitability: "Good",
        difficulty: "Advanced",
        winterDormancyRequired: true,
        winterHardiness: "High",
        rootFrostSensitivity: "Moderate in shallow bonsai containers"
    )

    private static var sections: [SpeciesProfileSection] {
        [
            SpeciesProfileSection(
                id: "taxonomic-context",
                title: "Taxonomic Context",
                paragraphs: [
                    "Chamaecyparis pisifera is an independent botanical species in the cypress family (Cupressaceae), genus Chamaecyparis.",
                    "Primary Bonsai World display identity: Chamaecyparis pisifera · Sawara Cypress.",
                    "Family: Cupressaceae. Genus: Chamaecyparis. Plant type: evergreen conifer.",
                    "Native range: Japan.",
                    "Do not confuse Chamaecyparis pisifera with Chamaecyparis lawsoniana (Lawson Cypress), Chamaecyparis obtusa (Hinoki Cypress), Chamaecyparis nootkatensis (Nootka Cypress) or Cupressus species.",
                    "Chamaecyparis pisifera has numerous horticultural cultivars with substantially different foliage colour, density, growth rate and habit.",
                    "Do not transfer cultivar characteristics to the species as a whole.",
                    "Named cultivars may be represented separately elsewhere in Bonsai World.",
                    "Bonsai World hierarchy: Species → cultivar / horticultural selection → Individual Tree.",
                ]
            ),
            SpeciesProfileSection(
                id: "overview",
                title: "Species Overview",
                paragraphs: [
                    "Chamaecyparis pisifera is an evergreen conifer native to Japan.",
                    "It is widely cultivated internationally and has produced a large number of horticultural selections.",
                    "The species naturally develops a conical to irregularly conical crown with horizontally spreading branches and dense branchlets.",
                    "Its foliage consists of scale-like leaves arranged closely around the branchlets.",
                    "Depending on the individual tree, foliage can appear relatively flat and fan-like or more three-dimensional. This foliage structure can produce fine visual texture in bonsai.",
                    "One of the most important considerations for Bonsai World is the distinction between the species and its many cultivars.",
                    "Cultivars of Sawara Cypress can differ dramatically in foliage colour, foliage density, growth rate, mature size, branch habit and crown shape.",
                    "Therefore, species-level guidance must remain general and should not assume the characteristics of a particular named selection.",
                    "Chamaecyparis pisifera can become a substantial tree in nature. During bonsai development, allow sufficient growth to establish trunk diameter and taper before beginning intensive refinement.",
                ],
                bullets: [
                    "Evergreen conifer",
                    "Cupressaceae · Chamaecyparis",
                    "Native to Japan",
                    "Scale-like foliage",
                    "Dense fine branching possible",
                    "Large horticultural cultivar diversity",
                    "Limited back-budding from bare old wood",
                    "High cold tolerance",
                    "Requires outdoor cultivation",
                    "Requires winter dormancy",
                    "Distinct from Lawson, Hinoki, Nootka Cypress and Cupressus",
                ]
            ),
            SpeciesProfileSection(
                id: "cultivars",
                title: "Cultivars and Forms",
                paragraphs: [
                    "Chamaecyparis pisifera is particularly important to represent accurately because of the large number of horticultural forms associated with the species.",
                    "Species-level foliage is generally green to blue-green scale foliage.",
                    "Cultivars may exhibit yellow, golden, blue, silver or other distinctive foliage characteristics, and may differ substantially in density, growth rate and habit.",
                    "Do not invent cultivar-specific characteristics and present them as characteristics of the species.",
                    "Do not describe cultivar-specific foliage as representative of the species.",
                    "Do not create unnecessary separate Species Library profiles for minor individual variation.",
                    "The primary Species Profile remains Chamaecyparis pisifera.",
                    "Only create separate profiles where a distinct cultivar has a clear and established independent bonsai identity.",
                    "Keep cultivar-specific information in cultivar profiles where applicable.",
                ]
            ),
            SpeciesProfileSection(
                id: "natural-growth",
                title: "Natural Growth and Vigour",
                paragraphs: [
                    "Growth can range from moderate to vigorous depending on the individual tree, environmental conditions and horticultural form.",
                    "Growth is influenced by light, temperature, water, nutrition, root health, container size, substrate, seasonal conditions and genetic form.",
                    "Do not provide a universal annual growth rate.",
                    "During development, appropriate extension growth can be used to build trunk and primary branches.",
                    "During refinement, growth should be progressively controlled.",
                    "The objective is: Useful development growth · Progressive control · Healthy foliage density.",
                ]
            ),
            SpeciesProfileSection(
                id: "foliage",
                title: "Foliage",
                paragraphs: [
                    "The foliage consists of small scale-like leaves arranged closely around the shoots.",
                    "Species-level foliage is generally green to blue-green.",
                    "However, horticultural cultivars exhibit a very wide range of foliage colours and textures.",
                    "Do not describe cultivar-specific foliage as representative of the species.",
                    "Preserve healthy interior foliage wherever it supports future branch development.",
                    "Do not excessively strip inner foliage simply to create open-looking pads.",
                ]
            ),
            SpeciesProfileSection(
                id: "bark-trunk",
                title: "Bark and Trunk",
                paragraphs: [
                    "Young bark is relatively smooth.",
                    "With age, bark develops greater texture and character.",
                    "The species can develop attractive mature trunks when given sufficient time.",
                    "During development, allow appropriate growth to establish trunk diameter, taper, movement and primary branch structure.",
                    "Do not prematurely maintain a finished silhouette while trunk development remains the priority.",
                ]
            ),
            SpeciesProfileSection(
                id: "roots-nebari",
                title: "Roots and Nebari",
                paragraphs: [
                    "Develop a balanced radial root system gradually.",
                    "Priorities include healthy fine roots, radial distribution, stable anchoring, gradual nebari improvement and avoidance of major crossing roots.",
                    "Do not perform aggressive root reduction solely for cosmetic reasons.",
                    "Maintain good drainage and oxygen availability.",
                    "The objective is: Stable root system · Reliable recovery · Natural anchoring.",
                ]
            ),
            SpeciesProfileSection(
                id: "light",
                title: "Light",
                paragraphs: [
                    "Full sun is preferred for strong and compact growth.",
                    "Adequate light supports dense healthy foliage, compact extension growth, stronger shoots, balanced branch development and healthy interior foliage.",
                    "Some forms may tolerate partial shade, but insufficient light can reduce density and weaken interior growth.",
                    "Cultivate outdoors.",
                    "Do not recommend permanent indoor cultivation.",
                ]
            ),
            SpeciesProfileSection(
                id: "wind",
                title: "Wind",
                paragraphs: [
                    "Sawara Cypress can tolerate exposed conditions once established.",
                    "However, bonsai containers have limited root volume and can dry rapidly during strong wind.",
                    "Strong wind can increase transpiration, dry the substrate, mechanically stress branches and destabilise shallow containers.",
                    "Secure the tree appropriately and monitor moisture during prolonged windy weather.",
                    "Do not confuse exposure tolerance with drought tolerance.",
                ]
            ),
            SpeciesProfileSection(
                id: "watering",
                title: "Watering",
                paragraphs: [
                    "Maintain consistent moisture during active growth.",
                    "The substrate should remain appropriately moist while retaining excellent drainage and oxygen availability.",
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
                    "Avoid compacted or poorly aerated soil.",
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
                    "During development, adequate nutrition supports shoot development, trunk thickening, branch development and root growth.",
                    "During refinement, nutrition should be controlled to avoid unnecessarily coarse growth.",
                    "Do not attempt to reproduce the characteristics of a named cultivar through fertilizer manipulation.",
                    "Follow the existing Bonsai World fertilization framework.",
                    "Avoid fixed universal fertilizer doses.",
                ]
            ),
            SpeciesProfileSection(
                id: "pruning",
                title: "Pruning",
                paragraphs: [
                    "Pruning should be conservative and developmental.",
                    "Priorities: establish trunk structure; establish primary branches; preserve useful inner growth; control unwanted extension; develop secondary branching; refine foliage masses.",
                    "Avoid severe cuts into completely bare old wood.",
                    "Do not repeatedly shear the outer foliage without considering the underlying branch structure.",
                    "Large structural cuts should be carefully planned and performed only when appropriate to the development stage.",
                ]
            ),
            SpeciesProfileSection(
                id: "back-budding",
                title: "Back-budding",
                paragraphs: [
                    "Back-budding should be described conservatively.",
                    "Do not rely on Chamaecyparis pisifera producing new shoots from completely bare old wood.",
                    "New growth is most dependable where viable foliage and buds remain.",
                    "Therefore: retain inner foliage, preserve useful shoots near branch junctions, shorten branches progressively, avoid stripping branches completely and develop ramification from existing viable growth.",
                    "Never promise predictable back-budding.",
                ]
            ),
            SpeciesProfileSection(
                id: "ramification",
                title: "Ramification",
                paragraphs: [
                    "The species can develop dense and fine branching.",
                    "Ramification should be developed progressively.",
                    "Focus on selective pruning, controlled extension growth, branch positioning, preservation of inner shoots, gradual subdivision and maintaining adequate light penetration.",
                    "Avoid allowing dense foliage pads to become flat outer shells.",
                    "The underlying branch structure should remain healthy and three-dimensional.",
                ]
            ),
            SpeciesProfileSection(
                id: "wiring",
                title: "Wiring",
                paragraphs: [
                    "Wiring is useful for trunk movement, primary branch placement, secondary branch structure, branch direction and development of layered foliage masses.",
                    "The individual tree's natural architecture should guide the design.",
                    "Use careful wiring around scale foliage and young shoots.",
                    "Monitor wires regularly during active growth.",
                    "Remove or adjust wire before permanent scarring develops.",
                    "Do not force mature branches beyond their safe flexibility.",
                ]
            ),
            SpeciesProfileSection(
                id: "deadwood-potential",
                title: "Deadwood",
                paragraphs: [
                    "Deadwood may be used where it suits the individual tree.",
                    "Use restraint.",
                    "When creating or refining deadwood: follow the natural grain, preserve structural strength, keep proportions appropriate, avoid excessive carving and use natural damage and ageing as inspiration.",
                    "Naturalistic deadwood can complement mature evergreen bonsai.",
                ]
            ),
            SpeciesProfileSection(
                id: "defoliation",
                title: "Foliage Management",
                paragraphs: [
                    "Do not recommend routine defoliation.",
                    "This is an evergreen conifer.",
                    "Foliage management should focus on maintaining healthy scale foliage, preserving interior shoots, balancing strong and weak areas, improving light penetration, controlling excessive density and developing three-dimensional foliage masses.",
                    "Avoid creating dense outer shells that shade the interior.",
                    "Where foliage is removed, retain sufficient healthy growth to support the branch.",
                ]
            ),
            SpeciesProfileSection(
                id: "repotting",
                title: "Repotting",
                paragraphs: [
                    "Repot when the root system or substrate condition indicates that intervention is necessary.",
                    "Do not repot solely because a fixed calendar interval has elapsed.",
                    "Priorities: preserve healthy fine roots, maintain good drainage, maintain oxygen availability, remove only appropriate amounts of old substrate, avoid unnecessary root disturbance and secure the tree firmly.",
                    "Repotting timing should be adapted to local climate and tree condition.",
                    "Avoid aggressive root work on weak or stressed specimens.",
                ]
            ),
            SpeciesProfileSection(
                id: "trunk-development",
                title: "Trunk Development",
                paragraphs: [
                    "During development, allow sufficient extension growth to build trunk diameter and taper.",
                    "Do not maintain a highly refined silhouette while simultaneously expecting rapid trunk development.",
                    "Stage 1 — Establishment: build a healthy root system and strong growth.",
                    "Stage 2 — Trunk development: allow controlled extension growth to increase trunk diameter and establish taper.",
                    "Stage 3 — Primary structure: select and position major branches.",
                    "Stage 4 — Secondary branching: develop branch subdivision while preserving sufficient foliage.",
                    "Stage 5 — Foliage refinement: develop three-dimensional foliage masses and improve light penetration.",
                    "Stage 6 — Final refinement: control extension growth and refine branch density.",
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
                    "Chamaecyparis pisifera can be propagated from seed, cuttings and other horticultural methods.",
                    "Seed propagation produces genetic variation.",
                    "Vegetative propagation is important for maintaining desirable horticultural forms.",
                    "Distinguish species propagation from cultivar propagation. Do not imply that seedlings reproduce a named cultivar.",
                    "Describe propagation as a long-term process. Do not present propagation as a rapid route to finished bonsai.",
                    "Detailed procedures belong in Bonsai World Propagation Knowledge Articles.",
                ]
            ),
            SpeciesProfileSection(
                id: "pests",
                title: "Pests and Problems",
                paragraphs: [
                    "Potential problems include aphids, scale insects, spider mites, cypress-associated insect pests, fungal diseases, root problems caused by poor drainage, drought stress, excessive foliage density, interior dieback caused by inadequate light and wire scarring.",
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
                    "Spring: new shoots begin developing. Monitor extension growth. Begin appropriate seasonal feeding. Review wiring. Increase watering as growth and transpiration increase. Preserve useful inner shoots.",
                    "Summer: maintain consistent moisture. Monitor foliage density. Maintain good airflow. Protect the root zone from excessive heat where necessary. Control unwanted extension growth where appropriate. Avoid heavy structural work during periods of environmental stress.",
                    "Autumn: new growth gradually hardens. Review branch structure. Complete appropriate wiring adjustments. Adjust feeding according to the existing Bonsai World seasonal framework. Prepare for winter.",
                    "Winter: maintain outdoor cultivation and dormancy. Protect container roots from extreme temperature fluctuations. Monitor winter drying during cold, dry and windy periods. Avoid unnecessary root disturbance.",
                    "The species should remain outdoors through winter.",
                ]
            ),
            SpeciesProfileSection(
                id: "styles",
                title: "Bonsai Styles",
                paragraphs: [
                    "Suitable styles may include Informal Upright, Upright, Slanting, naturalistic, layered conifer forms, windswept forms where supported by the specimen and literati-inspired forms where the trunk character justifies it.",
                    "The species' dense scale foliage can support refined foliage masses.",
                    "However, the final design should preserve visible branch structure and avoid an artificial green blob appearance.",
                    "Individual cultivars may have different natural habits, but cultivar-specific design characteristics must not be presented as universal species characteristics.",
                    "The individual material should determine the final design.",
                ]
            ),
            SpeciesProfileSection(
                id: "tree-stage",
                title: "Development by Tree Stage",
                paragraphs: [
                    "Young nursery material: focus on health, trunk movement, trunk thickening, root development and initial branch selection. Do not over-refine young material.",
                    "Pre-bonsai: focus on trunk taper, primary branch structure, wiring, branch positioning and controlled extension growth.",
                    "Established bonsai: focus on secondary branching, foliage balance, light penetration, controlled extension, selective pruning and maintenance wiring.",
                    "Mature refined bonsai: focus on fine ramification, layered foliage refinement, silhouette refinement, preservation of interior shoots, mature bark and subtle seasonal refinement. Avoid unnecessary major interventions on mature trees.",
                ]
            ),
            SpeciesProfileSection(
                id: "attention",
                title: "Species-Specific Attention",
                paragraphs: [
                    "These attention points are operational tendencies. They must still be interpreted for the individual tree.",
                    "Chamaecyparis pisifera is particularly important to represent accurately because of the large number of horticultural forms associated with the species.",
                    "The species should be presented as a versatile evergreen conifer rather than as a single visually uniform tree type.",
                ],
                bullets: [
                    "Treat the species separately from its cultivars",
                    "Do not assume all forms have the same growth habit",
                    "Do not assume all forms have the same foliage colour",
                    "Preserve viable inner foliage",
                    "Do not expect reliable regeneration from completely bare old wood",
                    "Avoid excessive outer shearing",
                    "Maintain three-dimensional branch structure",
                    "Maintain excellent substrate drainage and aeration",
                    "Use wiring to establish structure gradually",
                    "Monitor wire carefully",
                    "Allow adequate time for ramification",
                    "Use natural architecture as the basis for design",
                    "Keep cultivar-specific information in cultivar profiles where applicable",
                    "Do not confuse with Chamaecyparis lawsoniana, C. obtusa, C. nootkatensis or Cupressus",
                    "Winter dormancy is required",
                    "Do not move indoors for routine winter care",
                ]
            ),
        ]
    }
}
