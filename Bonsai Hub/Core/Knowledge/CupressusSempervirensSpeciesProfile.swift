//
//  CupressusSempervirensSpeciesProfile.swift
//  Bonsai World
//
//  Species Profile — Cupressus sempervirens (Italian Cypress / Mediterranean Cypress).
//  Independent botanical species in Cupressaceae. Knowledge status: Reviewed.
//  Separate from C. arizonica, C. macrocarpa, Cupressus × leylandii, Chamaecyparis and named cultivars.
//

import Foundation

enum CupressusSempervirensSpeciesProfile {
    /// Identity used by Botanical Library / ``SpeciesPreviewData``.
    static let botanicalLibraryName = "Cupressus sempervirens"
    /// Scientific name for Species Profile display (binomial; no botanical authority).
    static let scientificName = "Cupressus sempervirens"

    static var profile: SpeciesProfile {
        SpeciesProfile(
            speciesID: BotanicalKnowledgeIDs.cupressusSempervirens,
            scientificName: scientificName,
            commonNames: ["Italian Cypress", "Mediterranean Cypress"],
            family: "Cupressaceae",
            plantType: "Evergreen conifer",
            originSummary: "The eastern Mediterranean region and adjacent western Asia.",
            knowledgeStatus: .reviewed,
            traits: traits,
            foliageSizeLabel: "Foliage",
            foliageReductionLabel: "Foliage management",
            summaryLine: "Evergreen · Mediterranean scale foliage · Columnar horticultural forms exist · Outdoor cultivation required",
            attentionHighlights: [
                "Treat it as an outdoor evergreen conifer",
                "Do not treat narrowly columnar cultivar habit as universal for the species",
                "Manage container moisture carefully despite Mediterranean landscape tolerance",
                "Preserve viable inner foliage",
                "Do not expect reliable regeneration from completely bare old wood",
                "Avoid excessive shearing of the outer foliage",
                "Maintain three-dimensional branch structure",
                "Control foliage density so that interior shoots remain healthy",
                "Use progressive branch reduction",
                "Maintain excellent substrate drainage and aeration",
                "Monitor wire carefully",
                "Allow adequate time for ramification",
                "Distinguish species characteristics from cultivar characteristics",
                "Do not confuse with Cupressus arizonica, C. macrocarpa, Leyland Cypress or Chamaecyparis",
                "Winter dormancy is required where winters are cold",
                "Do not move indoors for routine winter care",
            ],
            sections: sections,
            principleNote: """
            Cupressus sempervirens must be treated as an evergreen conifer with limited and unpredictable ability to regenerate from completely bare old wood.

            Do not assume that hard pruning into old, leafless branches will reliably produce new shoots.

            Preserve healthy foliage, viable buds, useful inner shoots and structurally important branch sections.

            Strongly columnar horticultural forms exist, but narrowly columnar cultivar habit must not be transferred to the species as a universal characteristic.

            Although Italian Cypress shows heat and drought tolerance relative among cypresses in landscape settings, bonsai containers still need careful moisture management with excellent drainage.

            Development should favour: gradual branch reduction · preservation of inner growth · controlled extension growth · progressive ramification · careful wiring · conservative structural pruning.

            Do not recommend treating this species like a freely back-budding deciduous bonsai.

            Do not present back-budding as guaranteed.

            Do not transfer cultivar-specific foliage colours or growth habits to the species without qualification.

            The individual tree must always be assessed according to health, vigour, foliage density, root condition, development stage, climate and recent work.

            The objective is: Healthy foliage · Three-dimensional branch structure · Progressive refinement · Sustainable long-term development
            """,
            sourcesNote: """
            Profile content is synthesised from recognised botanical, horticultural and bonsai authorities into Bonsai World editorial language.

            Botanical taxonomy and distribution draw primarily on Royal Botanic Gardens, Kew — Plants of the World Online and related botanical references for Cupressus sempervirens, family Cupressaceae, native distribution and taxonomic context.

            Horticultural context may draw on recognised forestry, horticultural and botanical institutions. Authoritative horticultural sources should be used when discussing named cultivars, including strongly columnar selections.

            Bonsai-specific cultivation and refinement knowledge draws on established bonsai references and recognised professional practice with conifer experience. Where guidance reflects general conifer bonsai practice rather than species-specific research, it is phrased as cultivation guidance rather than botanical fact.

            Verified botanical information, horticultural information, cultivar-specific horticulture and bonsai-specific practice are kept distinct. Do not copy source wording.
            """
        )
    }

    private static let traits = SpeciesProfileTraits(
        deciduous: false,
        growthStrength: "Moderate to Vigorous depending on conditions",
        growthSpeed: "Moderate to Vigorous — strongly climate and site dependent",
        leafSize: "Evergreen · Scale-like foliage · Dark green to grey-green (variable)",
        foliageReduction: "Not applicable",
        ramificationPotential: "Dense fine branching possible with gradual development",
        backBudding: "Limited and unreliable from completely bare old wood",
        rootDevelopment: "Moderate",
        nebariPotential: "Moderate potential with gradual improvement",
        trunkDevelopment: "Long-term — allow extension during early development",
        barkDevelopment: "Fibrous, fissured character with age",
        wiring: "Useful for structural development and foliage positioning",
        defoliation: "Not applicable as a routine technique",
        airLayering: "Where appropriate for the individual material",
        threadGrafting: "Specialist technique where structural correction is required",
        rootGrafting: "Specialist technique where appropriate",
        beginnerSuitability: "Low to Moderate",
        bonsaiSuitability: "Good — upright, columnar and naturalistic forms where material supports them",
        difficulty: "Advanced",
        winterDormancyRequired: true,
        winterHardiness: "Moderate — climate dependent",
        rootFrostSensitivity: "Moderate in shallow bonsai containers"
    )

    private static var sections: [SpeciesProfileSection] {
        [
            SpeciesProfileSection(
                id: "taxonomic-context",
                title: "Taxonomic Context",
                paragraphs: [
                    "Cupressus sempervirens is an independent botanical species in the cypress family (Cupressaceae), genus Cupressus.",
                    "Primary Bonsai World display identity: Cupressus sempervirens · Italian Cypress.",
                    "Mediterranean Cypress may be used as supporting terminology. It does not replace Italian Cypress as the primary common name.",
                    "Family: Cupressaceae. Genus: Cupressus. Plant type: evergreen conifer.",
                    "Native range: the eastern Mediterranean region and adjacent western Asia.",
                    "Do not confuse Cupressus sempervirens with Cupressus arizonica (Arizona Cypress), Cupressus macrocarpa (Monterey Cypress), Cupressus × leylandii (Leyland Cypress) or Chamaecyparis species.",
                    "The profile must use Cupressus sempervirens as the species identity even where horticultural sources use cultivar names extensively.",
                    "Do not transfer cultivar-specific foliage colours or growth habits — including narrowly columnar habit — to the species without qualification.",
                    "Bonsai World hierarchy: Species → cultivar / horticultural selection → Individual Tree.",
                ]
            ),
            SpeciesProfileSection(
                id: "overview",
                title: "Species Overview",
                paragraphs: [
                    "Cupressus sempervirens is an evergreen conifer native to the eastern Mediterranean region and adjacent western Asia.",
                    "It is widely cultivated as an ornamental tree and is strongly associated with Mediterranean landscapes.",
                    "Foliage consists of scale-like leaves arranged closely around the shoots. Colour is generally dark green to grey-green and can vary among individuals and horticultural selections.",
                    "Strongly columnar horticultural forms are common in gardens, but that narrowly columnar habit must not be treated as universal for the botanical species.",
                    "Relative among cypresses, Italian Cypress shows useful heat and drought tolerance in landscape settings. In bonsai containers, careful moisture management with excellent drainage remains essential.",
                    "Natural mature trees can become tall and substantial. Bonsai material should be selected carefully according to the intended final size.",
                    "Dense growth can develop, but dense foliage should not be achieved by cutting into old, leafless wood.",
                    "Upright, columnar and naturalistic forms can all be suitable where the individual material supports the design.",
                ],
                bullets: [
                    "Evergreen conifer",
                    "Cupressaceae · Cupressus",
                    "Eastern Mediterranean and adjacent western Asia",
                    "Scale-like foliage",
                    "Strongly columnar horticultural forms exist — not universal for the species",
                    "Mediterranean character",
                    "Heat and drought tolerance relative among cypresses — containers still need careful moisture management",
                    "Limited back-budding from bare old wood",
                    "Suitable for upright, columnar and naturalistic forms where material supports them",
                    "Requires outdoor cultivation",
                    "Distinct from Arizona Cypress, Monterey Cypress, Leyland Cypress and Chamaecyparis",
                ]
            ),
            SpeciesProfileSection(
                id: "cultivars",
                title: "Cultivars and Forms",
                paragraphs: [
                    "Cupressus sempervirens is primarily represented in bonsai by the botanical species.",
                    "Named horticultural selections may differ significantly in crown shape, columnar intensity, foliage colour, vigour and density.",
                    "Do not invent cultivar-specific characteristics and present them as characteristics of the species.",
                    "Do not describe narrowly columnar cultivar habit as representative of the species as a whole.",
                    "Do not create unnecessary separate Species Library profiles for minor individual variation.",
                    "The primary Species Profile remains Cupressus sempervirens.",
                    "Only create separate profiles where a distinct cultivar has a clear and established independent bonsai identity.",
                ]
            ),
            SpeciesProfileSection(
                id: "natural-growth",
                title: "Natural Growth and Vigour",
                paragraphs: [
                    "Cupressus sempervirens can grow moderately to vigorously when well established.",
                    "Growth depends on light, temperature, water, nutrition, root health, container size, substrate, local climate and seasonal conditions.",
                    "Growth can be useful during trunk development, but uncontrolled extension growth can quickly produce dense and coarse areas.",
                    "During refinement, growth should be controlled progressively rather than through severe pruning.",
                    "The objective is: Useful development growth · Progressive control · Healthy foliage density.",
                ]
            ),
            SpeciesProfileSection(
                id: "foliage",
                title: "Foliage",
                paragraphs: [
                    "The foliage consists primarily of small, overlapping scale-like leaves.",
                    "Colour is generally dark green to grey-green and can vary among horticultural forms.",
                    "Do not transfer the foliage colour or texture of a particular cultivar to the species as a whole.",
                    "The foliage creates a naturally dense surface and can produce attractive pads when developed carefully.",
                    "Avoid excessive removal of interior foliage.",
                    "Preserve viable inner shoots wherever they contribute to future branch structure.",
                ]
            ),
            SpeciesProfileSection(
                id: "bark-trunk",
                title: "Bark and Trunk",
                paragraphs: [
                    "Young bark is relatively smooth. With age, bark becomes more fibrous, fissured and characterful.",
                    "The species can develop attractive mature trunks with strong vertical character.",
                    "Allow sufficient growth during trunk development to establish taper, movement, diameter and primary branch structure.",
                    "Do not prematurely maintain a finished silhouette if trunk development is still the priority.",
                ]
            ),
            SpeciesProfileSection(
                id: "roots-nebari",
                title: "Roots and Nebari",
                paragraphs: [
                    "Develop a balanced radial root system gradually.",
                    "Priorities include healthy fine roots, radial distribution, stable anchoring, gradual nebari improvement and avoidance of major crossing roots.",
                    "Do not perform aggressive root reduction merely for cosmetic purposes.",
                    "Maintain good aeration and drainage.",
                    "The objective is: Stable root system · Reliable recovery · Natural anchoring.",
                ]
            ),
            SpeciesProfileSection(
                id: "light",
                title: "Light",
                paragraphs: [
                    "Full sun is generally preferred for strong, compact growth.",
                    "Light also affects foliage density and branch strength.",
                    "Adequate light supports compact growth, dense but healthy foliage, stronger shoots and balanced branch development.",
                    "Insufficient light may produce weaker, more elongated growth and reduce inner foliage quality.",
                    "Cultivate outdoors.",
                    "Do not recommend permanent indoor cultivation.",
                ]
            ),
            SpeciesProfileSection(
                id: "wind",
                title: "Wind",
                paragraphs: [
                    "Italian Cypress can tolerate exposed conditions once established, but container-grown bonsai remain vulnerable to rapid moisture loss.",
                    "Strong wind can increase transpiration, dry the substrate rapidly, mechanically stress branches and destabilise shallow containers.",
                    "Secure the tree appropriately and monitor moisture during prolonged windy weather.",
                    "Do not confuse landscape exposure or Mediterranean drought tolerance with container drought tolerance.",
                ]
            ),
            SpeciesProfileSection(
                id: "watering",
                title: "Watering",
                paragraphs: [
                    "Maintain consistent moisture during active growth.",
                    "The substrate should remain appropriately moist while still providing strong drainage and oxygen availability.",
                    "Although the species shows heat and drought tolerance relative among cypresses in landscape settings, bonsai containers still need careful moisture management.",
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
                    "Do not use compacted or poorly aerated soil.",
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
                    "During refinement, nutrition should be controlled to avoid unnecessarily coarse growth.",
                    "Avoid using excessive fertilizer to force dense foliage.",
                    "Follow the existing Bonsai World fertilization framework.",
                    "Do not prescribe fixed universal fertilizer doses.",
                ]
            ),
            SpeciesProfileSection(
                id: "pruning",
                title: "Pruning",
                paragraphs: [
                    "Pruning should be conservative and developmental.",
                    "Priorities: establish trunk structure; establish primary branches; preserve useful inner growth; control unwanted extension; develop secondary branching; refine foliage pads.",
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
                    "Do not rely on Cupressus sempervirens producing new shoots from completely bare old branches.",
                    "New growth is most dependable where viable foliage and buds remain.",
                    "Therefore: retain inner foliage, shorten branches progressively, preserve useful shoots near branch junctions, avoid stripping branches completely and develop ramification from existing viable growth.",
                    "Never promise predictable back-budding.",
                ]
            ),
            SpeciesProfileSection(
                id: "ramification",
                title: "Ramification",
                paragraphs: [
                    "The species can develop dense and fine branching with gradual work.",
                    "Ramification should be developed progressively.",
                    "Focus on selective pruning, controlled extension growth, branch positioning, preservation of inner shoots, gradual subdivision and maintaining adequate light penetration.",
                    "Do not create overly dense pads at the expense of inner branch health.",
                    "The objective is a three-dimensional branch structure rather than a flat outer shell.",
                ]
            ),
            SpeciesProfileSection(
                id: "wiring",
                title: "Wiring",
                paragraphs: [
                    "Wiring is useful for trunk movement, primary branch placement, secondary branch structure, downward branch positioning and creating layered foliage masses.",
                    "The natural branch architecture should guide the design.",
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
                    "Deadwood can be effective on suitable specimens, particularly where it reflects natural branch loss or environmental damage.",
                    "Use restrained deadwood techniques.",
                    "When creating deadwood: follow the natural grain, keep proportions appropriate, preserve structural strength, avoid excessive carving and allow weathering to contribute to the appearance.",
                    "Naturalistic deadwood can complement the species' evergreen conifer character.",
                ]
            ),
            SpeciesProfileSection(
                id: "defoliation",
                title: "Foliage Management",
                paragraphs: [
                    "Do not recommend routine defoliation.",
                    "This is an evergreen conifer.",
                    "Foliage management should focus on maintaining healthy scale foliage, preserving inner shoots, balancing strong and weak areas, improving light penetration, controlling excessive density and developing three-dimensional foliage masses.",
                    "Avoid creating dense outer shells that shade and weaken the interior.",
                    "Where foliage is removed, retain enough healthy growth to support the branch.",
                ]
            ),
            SpeciesProfileSection(
                id: "repotting",
                title: "Repotting",
                paragraphs: [
                    "Repot when the root system and substrate condition indicate that intervention is necessary.",
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
                    "Cupressus sempervirens can be propagated by seed, cuttings and specialist horticultural methods.",
                    "Seed propagation produces genetic variation and should not be expected to reproduce specific horticultural forms.",
                    "Cuttings are commonly used for maintaining desirable horticultural selections.",
                    "Distinguish species propagation from cultivar propagation. Do not imply that seedlings reproduce a named cultivar.",
                    "Describe propagation as a long-term process. Do not present propagation as a rapid route to finished bonsai.",
                    "Detailed procedures belong in Bonsai World Propagation Knowledge Articles.",
                ]
            ),
            SpeciesProfileSection(
                id: "pests",
                title: "Pests and Problems",
                paragraphs: [
                    "Potential problems include aphids, scale insects, spider mites, cypress-associated insect pests, fungal diseases, root problems caused by poor drainage, drought stress in containers, excessive foliage density, interior dieback caused by poor light penetration and wire scarring.",
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
                    "Summer: maintain consistent moisture. Monitor foliage density. Maintain good airflow. Watch for excessive heat and container drought stress. Control unwanted extension growth where appropriate. Avoid heavy structural work during periods of environmental stress.",
                    "Autumn: new growth gradually hardens. Review branch structure. Complete appropriate wiring adjustments. Adjust feeding according to the existing Bonsai World seasonal framework. Prepare for winter.",
                    "Winter: maintain outdoor cultivation. Protect container roots from extreme temperature fluctuations. Monitor winter drying during cold, dry and windy periods. Avoid unnecessary root disturbance.",
                    "The species should remain outdoors through winter.",
                ]
            ),
            SpeciesProfileSection(
                id: "styles",
                title: "Bonsai Styles",
                paragraphs: [
                    "Suitable styles may include Upright, Informal Upright, columnar forms, naturalistic conifer and layered conifer forms where supported by the specimen.",
                    "Upright and columnar designs can suit material with strong vertical character, but narrowly columnar cultivar habit must not be assumed for every tree.",
                    "Avoid forcing an excessively dense, geometric silhouette.",
                    "The final design should retain visible branch structure beneath the foliage.",
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
                    "Cupressus sempervirens should be presented as a Mediterranean scale-foliaged evergreen conifer with limited bare-wood regeneration.",
                ],
                bullets: [
                    "Treat it as an outdoor evergreen conifer",
                    "Do not treat narrowly columnar cultivar habit as universal for the species",
                    "Manage container moisture carefully despite Mediterranean landscape tolerance",
                    "Preserve viable inner foliage",
                    "Do not expect reliable regeneration from completely bare old wood",
                    "Avoid excessive shearing of the outer foliage",
                    "Maintain three-dimensional branch structure",
                    "Control foliage density so that interior shoots remain healthy",
                    "Use progressive branch reduction",
                    "Maintain excellent substrate drainage and aeration",
                    "Monitor wire carefully",
                    "Allow adequate time for ramification",
                    "Distinguish species characteristics from cultivar characteristics",
                    "Do not confuse with Cupressus arizonica, C. macrocarpa, Leyland Cypress or Chamaecyparis",
                    "Winter dormancy is required where winters are cold",
                    "Do not move indoors for routine winter care",
                ]
            ),
        ]
    }
}
