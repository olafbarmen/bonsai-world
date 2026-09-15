//
//  ChamaecyparisNootkatensisSpeciesProfile.swift
//  Bonsai World
//
//  Species Profile — Chamaecyparis nootkatensis (Nootka Cypress).
//  Independent botanical species in Cupressaceae. Knowledge status: Reviewed.
//  Primary Bonsai World identity retained as Chamaecyparis nootkatensis for Botanical Library consistency.
//  Separate from C. lawsoniana, C. obtusa, C. pisifera and named cultivars.
//

import Foundation

enum ChamaecyparisNootkatensisSpeciesProfile {
    /// Identity used by Botanical Library / ``SpeciesPreviewData``.
    static let botanicalLibraryName = "Chamaecyparis nootkatensis"
    /// Scientific name for Species Profile display (binomial; no botanical authority).
    static let scientificName = "Chamaecyparis nootkatensis"

    static var profile: SpeciesProfile {
        SpeciesProfile(
            speciesID: BotanicalKnowledgeIDs.chamaecyparisNootkatensis,
            scientificName: scientificName,
            commonNames: ["Nootka Cypress", "Yellow-Cedar"],
            family: "Cupressaceae",
            plantType: "Evergreen conifer",
            originSummary: "Western North America, from coastal Alaska and British Columbia south through the Pacific Northwest and into northern California.",
            knowledgeStatus: .reviewed,
            traits: traits,
            foliageSizeLabel: "Foliage",
            foliageReductionLabel: "Foliage management",
            summaryLine: "Evergreen · Strongly pendulous branchlets · Scale-like foliage · Very high cold hardiness · Naturalistic and windswept potential · Outdoor cultivation required",
            attentionHighlights: [
                "Respect its naturally pendulous branches",
                "Use downward branch movement as a design advantage",
                "Preserve the species' rugged, northern character",
                "Treat it as a cold-hardy outdoor conifer",
                "Preserve viable inner foliage",
                "Do not expect reliable regeneration from completely bare old wood",
                "Avoid excessive foliage stripping",
                "Maintain three-dimensional branch structure",
                "Maintain excellent substrate drainage and aeration",
                "Use wiring to refine rather than contradict natural branch direction",
                "Monitor wires carefully",
                "Allow adequate time for ramification",
                "Use natural deadwood where supported by the specimen",
                "Distinguish species characteristics from cultivar characteristics",
                "Do not confuse with Chamaecyparis lawsoniana, C. obtusa or C. pisifera",
                "Winter dormancy is required",
                "Do not move indoors for routine winter care",
            ],
            sections: sections,
            principleNote: """
            Chamaecyparis nootkatensis must be treated as an evergreen conifer with limited and unpredictable ability to regenerate from completely bare old wood.

            Do not assume that hard pruning into old, leafless branches will reliably produce new shoots.

            Preserve healthy foliage, viable buds, useful inner shoots and structurally important branch sections.

            Its naturally pendulous growth should also influence pruning and wiring decisions.

            Do not automatically force branches upward or horizontally if their natural downward character contributes to the design.

            Development should favour: gradual branch reduction · preservation of inner growth · controlled extension growth · progressive ramification · careful wiring · conservative structural pruning.

            Do not present back-budding as guaranteed.

            Do not transfer cultivar-specific foliage colours or growth habits to the species without qualification.

            The individual tree must always be assessed according to health, vigour, foliage density, root condition, development stage, climate and recent work.

            The objective is: Natural pendulous character · Healthy foliage · Three-dimensional branch structure · Progressive refinement · Sustainable long-term development
            """,
            sourcesNote: """
            Profile content is synthesised from recognised botanical, horticultural and bonsai authorities into Bonsai World editorial language.

            Botanical taxonomy and distribution draw primarily on Royal Botanic Gardens, Kew — Plants of the World Online. Kew currently accepts Callitropsis nootkatensis; Chamaecyparis nootkatensis, Cupressus nootkatensis and Xanthocyparis nootkatensis appear among synonym and alternative treatments. Bonsai World retains Chamaecyparis nootkatensis as the primary scientific identity for Botanical Library consistency within the existing Chamaecyparis group.

            Horticultural and forestry context may draw on recognised North American botanical and forestry institutions for cool, moist western ecology, longevity and morphology.

            Bonsai-specific cultivation and refinement knowledge draws on established bonsai references and recognised professional practice with conifer experience. Where guidance reflects general conifer bonsai practice rather than species-specific research, it is phrased as cultivation guidance rather than botanical fact.

            Verified botanical information, horticultural information, taxonomic synonymy and bonsai-specific practice are kept distinct. Do not copy source wording.
            """
        )
    }

    private static let traits = SpeciesProfileTraits(
        deciduous: false,
        growthStrength: "Slow to Moderate",
        growthSpeed: "Slow to Moderate — long-term development characteristic",
        leafSize: "Evergreen · Scale-like foliage · Green to blue-green",
        foliageReduction: "Not applicable",
        ramificationPotential: "Fine branching possible with gradual development",
        backBudding: "Limited and unreliable from completely bare old wood",
        rootDevelopment: "Moderate",
        nebariPotential: "Moderate potential with gradual improvement",
        trunkDevelopment: "Long-term — allow extension during early development",
        barkDevelopment: "Strong mature character with age",
        wiring: "Useful for structural development and pendulous branch positioning",
        defoliation: "Not applicable as a routine technique",
        airLayering: "Where appropriate for the individual material",
        threadGrafting: "Specialist technique where structural correction is required",
        rootGrafting: "Specialist technique where appropriate",
        beginnerSuitability: "Low to Moderate",
        bonsaiSuitability: "Good for naturalistic and windswept forms",
        difficulty: "Advanced",
        winterDormancyRequired: true,
        winterHardiness: "Very High",
        rootFrostSensitivity: "Moderate in shallow bonsai containers"
    )

    private static var sections: [SpeciesProfileSection] {
        [
            SpeciesProfileSection(
                id: "taxonomic-context",
                title: "Taxonomic Context",
                paragraphs: [
                    "Chamaecyparis nootkatensis is treated in Bonsai World as an independent botanical species in the cypress family (Cupressaceae), genus Chamaecyparis.",
                    "Primary Bonsai World display identity: Chamaecyparis nootkatensis · Nootka Cypress.",
                    "Widely used common name also recognised: Yellow-Cedar.",
                    "Family: Cupressaceae. Genus (Bonsai World primary identity): Chamaecyparis. Plant type: evergreen conifer.",
                    "Native range: western North America, from coastal Alaska and British Columbia south through the Pacific Northwest and into northern California.",
                    "Some modern botanical treatments place this species in Callitropsis or Cupressus. Kew currently accepts Callitropsis nootkatensis, with Chamaecyparis nootkatensis among synonym and alternative classifications.",
                    "Bonsai World retains Chamaecyparis nootkatensis as the primary scientific name because this is the name used by the existing Botanical Library record and maintains consistency with the Chamaecyparis group already represented in Bonsai World.",
                    "Do not silently replace the existing species identity with a different genus. Present alternative taxonomy only as synonym or alternative classification information.",
                    "Do not confuse Chamaecyparis nootkatensis with Chamaecyparis lawsoniana (Lawson Cypress), Chamaecyparis obtusa (Hinoki Cypress) or Chamaecyparis pisifera (Sawara Cypress).",
                    "Bonsai World hierarchy: Species → cultivar / horticultural selection → Individual Tree.",
                ]
            ),
            SpeciesProfileSection(
                id: "overview",
                title: "Species Overview",
                paragraphs: [
                    "Chamaecyparis nootkatensis is an evergreen conifer native to the cool and moist regions of western North America.",
                    "Its natural range extends from Alaska and British Columbia south through the Pacific Northwest and into northern California.",
                    "The species is strongly associated with cool mountain and coastal environments.",
                    "It is a long-lived tree and can develop substantial trunks and highly characterful mature bark.",
                    "One of its most important visual characteristics is its naturally pendulous branch structure. The main branches often extend outward and downward, while the smaller branchlets can hang gracefully.",
                    "This architecture gives the species considerable bonsai potential.",
                    "The foliage consists of small scale-like leaves arranged on flattened or somewhat angular branchlets. Foliage colour is generally green to blue-green, depending on provenance and growing conditions.",
                    "The species naturally develops narrow to broadly conical forms, but individual trees exposed to wind, snow and difficult terrain can develop much more irregular architecture. These natural forms can be particularly valuable as bonsai material.",
                    "The species should be approached as a slow-to-moderate-growing, cold-hardy conifer where natural character is a major design asset.",
                ],
                bullets: [
                    "Evergreen conifer",
                    "Cupressaceae · Chamaecyparis (Bonsai World primary identity)",
                    "Cool, moist western North American ecology",
                    "Strongly pendulous branchlets",
                    "Scale-like foliage",
                    "Very high cold hardiness",
                    "Long-lived with strong mature bark potential",
                    "Limited back-budding from bare old wood",
                    "Requires outdoor cultivation",
                    "Requires winter dormancy",
                    "Distinct from Lawson, Hinoki and Sawara Cypress",
                ]
            ),
            SpeciesProfileSection(
                id: "cultivars",
                title: "Cultivars and Forms",
                paragraphs: [
                    "Chamaecyparis nootkatensis is primarily used in bonsai as the botanical species.",
                    "Named horticultural selections may differ in foliage colour, vigour, growth habit and density.",
                    "Do not invent cultivar-specific characteristics and present them as characteristics of the species.",
                    "Do not create unnecessary separate Species Library profiles for minor individual variation.",
                    "The primary Species Profile remains Chamaecyparis nootkatensis.",
                    "Only create separate profiles where a distinct cultivar has a clear and established independent bonsai identity.",
                ]
            ),
            SpeciesProfileSection(
                id: "natural-growth",
                title: "Natural Growth and Vigour",
                paragraphs: [
                    "Chamaecyparis nootkatensis is generally slow to moderate in growth rate.",
                    "Growth depends on climate, light, water, nutrition, root health, container size, substrate and seasonal conditions.",
                    "Do not provide a universal annual growth rate.",
                    "The relatively slow development should be treated as a long-term bonsai characteristic.",
                    "During trunk development, allow appropriate extension growth.",
                    "During refinement, control extension gradually rather than relying on severe pruning.",
                    "The objective is: Useful development growth · Progressive control · Preserved natural character.",
                ]
            ),
            SpeciesProfileSection(
                id: "foliage",
                title: "Foliage",
                paragraphs: [
                    "The foliage consists of small, scale-like leaves.",
                    "Foliage is generally green to blue-green.",
                    "Branchlets can have a flattened appearance, contributing to the species' characteristic layered visual texture.",
                    "Preserve healthy interior foliage wherever it supports future branch development.",
                    "Do not excessively strip inner foliage simply to create open-looking pads.",
                    "The natural foliage structure should remain visible as part of the species' character.",
                    "Do not transfer the foliage colour or texture of a particular cultivar to the species as a whole.",
                ]
            ),
            SpeciesProfileSection(
                id: "bark-trunk",
                title: "Bark and Trunk",
                paragraphs: [
                    "Young bark is relatively smooth and grey-brown.",
                    "With age, bark becomes more textured and can develop strong mature character.",
                    "The species is long-lived and capable of developing substantial trunks.",
                    "During bonsai development, allow sufficient growth to establish trunk diameter, taper, movement and primary branch structure.",
                    "Do not prematurely maintain a finished silhouette when trunk development remains the priority.",
                ]
            ),
            SpeciesProfileSection(
                id: "roots-nebari",
                title: "Roots and Nebari",
                paragraphs: [
                    "Develop a balanced radial root system gradually.",
                    "Priorities include healthy fine roots, radial distribution, stable anchoring, gradual nebari improvement and avoidance of major crossing roots.",
                    "Do not perform aggressive root reduction simply for cosmetic reasons.",
                    "Maintain excellent drainage and root-zone oxygen availability.",
                    "The objective is: Stable root system · Reliable recovery · Natural anchoring.",
                ]
            ),
            SpeciesProfileSection(
                id: "light",
                title: "Light",
                paragraphs: [
                    "Full sun is preferred for strong and compact development.",
                    "The species can tolerate some partial shade, particularly in cool and moist climates.",
                    "Adequate light supports healthy foliage, compact growth, strong branch development, balanced growth and good interior shoot health.",
                    "Avoid prolonged deep shade.",
                    "Cultivate outdoors.",
                    "Do not recommend permanent indoor cultivation.",
                ]
            ),
            SpeciesProfileSection(
                id: "wind",
                title: "Wind",
                paragraphs: [
                    "Wind is an important part of the natural ecology of Nootka Cypress.",
                    "The species can develop highly characterful forms under exposed conditions.",
                    "However, bonsai containers have restricted root systems and can dry quickly during strong wind.",
                    "Strong wind can also mechanically stress the naturally pendulous branch structure.",
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
                    "The species naturally occurs in cool and moist environments, but bonsai cultivation still requires an open, well-aerated root environment.",
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
                    "The species' preference for cool, moist natural environments does not mean bonsai roots should remain in stagnant, oxygen-poor soil.",
                    "Do not prescribe one universal soil recipe.",
                    "Adapt substrate characteristics to local climate, container size and watering conditions.",
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
                    "Because the species is not naturally a rapid-growth subject, do not attempt to force excessive growth through extreme fertilization.",
                    "During refinement, nutrition should be controlled to maintain balanced growth.",
                    "Follow the existing Bonsai World fertilization framework.",
                    "Avoid fixed universal fertilizer doses.",
                ]
            ),
            SpeciesProfileSection(
                id: "pruning",
                title: "Pruning",
                paragraphs: [
                    "Pruning should be conservative and developmental.",
                    "Priorities: establish trunk structure; establish primary branches; preserve useful inner growth; respect naturally pendulous branch architecture; control unwanted extension; develop secondary branching; refine ramification.",
                    "Avoid severe cuts into completely bare old wood.",
                    "Do not repeatedly shear the outer foliage without considering the underlying branch structure.",
                    "Large structural cuts should be carefully planned and performed only when appropriate to the development stage.",
                ]
            ),
            SpeciesProfileSection(
                id: "back-budding",
                title: "Back-budding",
                paragraphs: [
                    "Back-budding must be described conservatively.",
                    "Do not rely on the species producing new shoots from completely bare old wood.",
                    "New growth is most dependable where viable foliage and buds remain.",
                    "Therefore: retain inner foliage, preserve useful shoots near branch junctions, shorten branches progressively, avoid stripping branches completely and develop ramification from existing viable growth.",
                    "Never promise predictable back-budding.",
                ]
            ),
            SpeciesProfileSection(
                id: "ramification",
                title: "Ramification",
                paragraphs: [
                    "Fine ramification can be developed with patience.",
                    "The natural pendulous architecture should be maintained while developing secondary and tertiary branching.",
                    "Focus on selective pruning, controlled extension growth, branch positioning, preservation of inner shoots, progressive subdivision and maintaining adequate light penetration.",
                    "Do not create dense outer foliage shells that hide the branch structure.",
                    "The objective is a three-dimensional branch structure rather than a flat outer shell.",
                ]
            ),
            SpeciesProfileSection(
                id: "wiring",
                title: "Wiring",
                paragraphs: [
                    "Wiring is an important structural technique for this species.",
                    "Use wiring to establish trunk movement, primary branch placement, secondary branch structure, downward branch positioning and natural pendulous branch character.",
                    "Do not automatically wire every branch upward.",
                    "Where the tree naturally produces hanging branchlets, wiring should refine rather than contradict that character.",
                    "Handle scale foliage and young branchlets carefully.",
                    "Monitor wire regularly during active growth.",
                    "Remove or adjust wire before permanent scarring develops.",
                ]
            ),
            SpeciesProfileSection(
                id: "deadwood-potential",
                title: "Deadwood",
                paragraphs: [
                    "Natural deadwood can be highly appropriate for mature specimens.",
                    "The species' long life and exposure to snow, wind and difficult mountain environments can produce naturally characterful dead branches and weathered wood.",
                    "When creating or refining deadwood: follow natural grain, preserve structural strength, keep proportions appropriate, avoid excessive carving and use natural damage as inspiration.",
                    "Deadwood should support the tree's natural story rather than become a decorative feature disconnected from the trunk and branch structure.",
                ]
            ),
            SpeciesProfileSection(
                id: "defoliation",
                title: "Foliage Management",
                paragraphs: [
                    "Do not recommend routine defoliation.",
                    "This is an evergreen conifer.",
                    "Foliage management should focus on maintaining healthy scale foliage, preserving interior shoots, balancing strong and weak areas, maintaining adequate light penetration, controlling excessive density and developing three-dimensional foliage masses.",
                    "Avoid creating a flat outer shell of foliage.",
                    "The pendulous branch structure should remain visually readable beneath the foliage.",
                ]
            ),
            SpeciesProfileSection(
                id: "repotting",
                title: "Repotting",
                paragraphs: [
                    "Repot when the root system or substrate condition indicates that intervention is necessary.",
                    "Do not repot solely because a fixed calendar interval has elapsed.",
                    "Priorities: preserve healthy fine roots, maintain drainage, maintain oxygen availability, remove only appropriate amounts of old substrate, avoid unnecessary root disturbance and secure the tree firmly.",
                    "Repotting timing should be adapted to local climate and physiological condition.",
                    "Avoid aggressive root work on weak, stressed or recently collected specimens.",
                ]
            ),
            SpeciesProfileSection(
                id: "trunk-development",
                title: "Trunk Development",
                paragraphs: [
                    "Chamaecyparis nootkatensis should be developed with patience.",
                    "Its relatively slow growth makes long-term planning important.",
                    "Stage 1 — Establishment: build a strong root system and healthy growth.",
                    "Stage 2 — Trunk development: allow controlled extension growth to establish trunk diameter and taper.",
                    "Stage 3 — Primary structure: select and position major branches.",
                    "Stage 4 — Branch character: establish the natural descending and pendulous branch architecture.",
                    "Stage 5 — Secondary branching: develop branch subdivision while preserving sufficient foliage.",
                    "Stage 6 — Refinement: control extension growth and improve fine ramification.",
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
                    "Chamaecyparis nootkatensis can be propagated from seed and by vegetative methods.",
                    "Seed propagation produces genetic variation.",
                    "Vegetative propagation is important when maintaining selected horticultural forms.",
                    "Distinguish species propagation from cultivar propagation. Do not imply that seedlings reproduce named cultivars.",
                    "Describe propagation as a long-term process. Do not present propagation as a rapid route to finished bonsai.",
                    "Detailed procedures belong in Bonsai World Propagation Knowledge Articles.",
                ]
            ),
            SpeciesProfileSection(
                id: "pests",
                title: "Pests and Problems",
                paragraphs: [
                    "Potential problems include aphids, scale insects, spider mites under hot and dry conditions, cypress-associated insect pests, fungal diseases, root problems caused by poor drainage, drought stress, winter drying, excessive foliage density, interior dieback from inadequate light and wire scarring.",
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
                    "Spring: new growth begins developing. Monitor emerging shoots. Begin appropriate seasonal feeding. Review wiring. Increase watering as growth increases. Preserve useful interior shoots.",
                    "Summer: maintain consistent moisture. Monitor foliage density. Maintain good airflow. Protect the root zone from excessive heat where necessary. Monitor naturally pendulous branches for unwanted growth changes. Avoid heavy structural work during periods of environmental stress.",
                    "Autumn: new growth gradually hardens. Review branch structure. Complete appropriate wiring adjustments. Adjust feeding according to the existing Bonsai World seasonal framework. Prepare for winter.",
                    "Winter: maintain outdoor cultivation and dormancy. Protect container roots from extreme temperature fluctuations. Monitor winter drying during cold, dry and windy periods. Avoid unnecessary root disturbance.",
                    "The species should remain outdoors through winter.",
                ]
            ),
            SpeciesProfileSection(
                id: "styles",
                title: "Bonsai Styles",
                paragraphs: [
                    "Suitable styles may include Informal Upright, Upright, Slanting, naturalistic, windswept, cascading-inspired forms, semi-cascade-inspired forms and literati-inspired forms where supported by the specimen.",
                    "The species' naturally descending branches should be treated as a major design advantage.",
                    "Do not force the tree into a rigid horizontal branch structure when its natural architecture supports a more graceful downward flow.",
                    "Naturalistic and weather-exposed designs can be particularly convincing.",
                    "The individual material should determine the final design.",
                ]
            ),
            SpeciesProfileSection(
                id: "tree-stage",
                title: "Development by Tree Stage",
                paragraphs: [
                    "Young nursery material: focus on health, trunk movement, trunk development, root development and initial branch selection. Do not over-refine young material.",
                    "Pre-bonsai: focus on trunk taper, primary branch structure, wiring, branch positioning and establishing natural downward branch character.",
                    "Established bonsai: focus on secondary branching, foliage balance, controlled extension, selective pruning, maintenance wiring and preserving pendulous branch structure.",
                    "Mature refined bonsai: focus on fine ramification, silhouette refinement, preservation of interior shoots, mature bark, natural deadwood character and subtle seasonal refinement. Avoid unnecessary major interventions on mature trees.",
                ]
            ),
            SpeciesProfileSection(
                id: "attention",
                title: "Species-Specific Attention",
                paragraphs: [
                    "These attention points are operational tendencies. They must still be interpreted for the individual tree.",
                    "Chamaecyparis nootkatensis has a highly distinctive natural architecture that should be central to its Bonsai World profile.",
                    "The species can be particularly compelling when developed as an old, weather-exposed tree rather than as an artificially geometric conifer.",
                ],
                bullets: [
                    "Respect its naturally pendulous branches",
                    "Use downward branch movement as a design advantage",
                    "Preserve the species' rugged, northern character",
                    "Treat it as a cold-hardy outdoor conifer",
                    "Preserve viable inner foliage",
                    "Do not expect reliable regeneration from completely bare old wood",
                    "Avoid excessive foliage stripping",
                    "Maintain three-dimensional branch structure",
                    "Maintain excellent substrate drainage and aeration",
                    "Use wiring to refine rather than contradict natural branch direction",
                    "Monitor wires carefully",
                    "Allow adequate time for ramification",
                    "Use natural deadwood where supported by the specimen",
                    "Distinguish species characteristics from cultivar characteristics",
                    "Do not confuse with Chamaecyparis lawsoniana, C. obtusa or C. pisifera",
                    "Winter dormancy is required",
                    "Do not move indoors for routine winter care",
                ]
            ),
        ]
    }
}
