//
//  CupressusLeylandiiSpeciesProfile.swift
//  Bonsai World
//
//  Species Profile — Cupressus × leylandii (Leyland Cypress).
//  Horticultural hybrid in Cupressaceae. Knowledge status: Reviewed.
//  Separate from parent species, other Cupressus, Chamaecyparis and named cultivars.
//

import Foundation

enum CupressusLeylandiiSpeciesProfile {
    /// Identity used by Botanical Library / ``SpeciesPreviewData``.
    static let botanicalLibraryName = "Cupressus x Leylandii"
    /// Scientific name for Species Profile display (hybrid formula; multiplication sign; no botanical authority).
    static let scientificName = "Cupressus × leylandii"

    static var profile: SpeciesProfile {
        SpeciesProfile(
            speciesID: BotanicalKnowledgeIDs.cupressusLeylandii,
            scientificName: scientificName,
            commonNames: ["Leyland Cypress"],
            synonyms: ["Cupressus x Leylandii", "× Cuprocyparis leylandii"],
            family: "Cupressaceae",
            plantType: "Evergreen conifer · Horticultural hybrid",
            originSummary: "Artificial horticultural hybrid, historically associated with Cupressus macrocarpa and Nootka Cypress (Callitropsis/Chamaecyparis nootkatensis).",
            knowledgeStatus: .reviewed,
            traits: traits,
            foliageSizeLabel: "Foliage",
            foliageReductionLabel: "Foliage management",
            summaryLine: "Evergreen · Horticultural hybrid · Very vigorous · Vigour control is the bonsai challenge · Outdoor cultivation required",
            attentionHighlights: [
                "Treat it as an outdoor evergreen conifer hybrid",
                "Vigour control is the primary bonsai challenge — not encouraging growth",
                "Do not shear into old leafless wood expecting recovery",
                "Preserve viable inner foliage",
                "Do not expect reliable regeneration from completely bare old wood",
                "Avoid hedge-style shearing without considering branch structure",
                "Maintain three-dimensional branch structure",
                "Control foliage density so that interior shoots remain healthy",
                "Use progressive branch reduction",
                "Maintain excellent substrate drainage and aeration",
                "Monitor wire carefully",
                "Do not transfer cultivar traits to the hybrid as a whole",
                "Often less refined as bonsai than classic Chamaecyparis or Taxus",
                "Do not confuse with parent species or other Cupressus",
                "Winter dormancy is required where winters are cold",
                "Do not move indoors for routine winter care",
            ],
            sections: sections,
            principleNote: """
            Cupressus × leylandii must be treated as an evergreen conifer horticultural hybrid with limited and unpredictable ability to regenerate from completely bare old wood.

            Do not assume that hard pruning into old, leafless branches will reliably produce new shoots.

            Do not shear into old leafless wood expecting recovery.

            Preserve healthy foliage, viable buds, useful inner shoots and structurally important branch sections.

            Leyland Cypress is a very vigorous hedge plant. In bonsai, the challenge is vigour control, not encouraging growth.

            Development should favour: gradual branch reduction · preservation of inner growth · controlled extension growth · progressive ramification · careful wiring · conservative structural pruning.

            Do not recommend treating this hybrid like a freely back-budding deciduous bonsai.

            Do not present back-budding as guaranteed.

            Do not transfer cultivar-specific foliage colours or growth habits to the hybrid as a whole.

            The individual tree must always be assessed according to health, vigour, foliage density, root condition, development stage, climate, horticultural form and recent work.

            The objective is: Healthy foliage · Controlled vigour · Three-dimensional branch structure · Progressive refinement · Sustainable long-term development
            """,
            sourcesNote: """
            Profile content is synthesised from recognised botanical, horticultural and bonsai authorities into Bonsai World editorial language.

            Botanical and horticultural taxonomy draw on recognised references for Cupressus × leylandii and alternative treatments including × Cuprocyparis leylandii and × Hesperotropsis. Bonsai World retains Cupressus × leylandii as the primary Species Library display identity, aligned with Botanical Library naming (Cupressus x Leylandii).

            Parentage is historically associated with Cupressus macrocarpa and Nootka Cypress (Callitropsis / Chamaecyparis nootkatensis). Parent-species guidance must not be transferred wholesale to the hybrid.

            Horticultural context may draw on recognised forestry, horticultural and botanical institutions. Authoritative horticultural sources should be used when discussing named cultivars.

            Bonsai-specific cultivation and refinement knowledge draws on established bonsai references and recognised professional practice with conifer experience. Where guidance reflects general conifer bonsai practice rather than hybrid-specific research, it is phrased as cultivation guidance rather than botanical fact.

            Verified botanical information, horticultural information, cultivar-specific horticulture and bonsai-specific practice are kept distinct. Do not copy source wording.
            """
        )
    }

    private static let traits = SpeciesProfileTraits(
        deciduous: false,
        growthStrength: "Very vigorous — strongly condition dependent",
        growthSpeed: "Vigorous — control is the bonsai challenge",
        leafSize: "Evergreen · Scale-like foliage · Green to yellow-green (variable by cultivar)",
        foliageReduction: "Not applicable",
        ramificationPotential: "Dense branching possible — structure must be developed deliberately",
        backBudding: "Limited and unreliable from completely bare old wood",
        rootDevelopment: "Moderate to Strong",
        nebariPotential: "Moderate potential with gradual improvement",
        trunkDevelopment: "Can thicken readily — control extension and keep structure deliberate",
        barkDevelopment: "Fibrous character with age",
        wiring: "Useful for structural development — monitor carefully on vigorous growth",
        defoliation: "Not applicable as a routine technique",
        airLayering: "Where appropriate for the individual material",
        threadGrafting: "Specialist technique where structural correction is required",
        rootGrafting: "Specialist technique where appropriate",
        beginnerSuitability: "Low",
        bonsaiSuitability: "Moderate — vigour and form dependent",
        difficulty: "Advanced",
        winterDormancyRequired: true,
        winterHardiness: "Moderate to High — climate dependent",
        rootFrostSensitivity: "Moderate in shallow bonsai containers"
    )

    private static var sections: [SpeciesProfileSection] {
        [
            SpeciesProfileSection(
                id: "taxonomic-context",
                title: "Taxonomic Context",
                paragraphs: [
                    "Cupressus × leylandii is an artificial horticultural hybrid in the cypress family (Cupressaceae).",
                    "Primary Bonsai World display identity: Cupressus × leylandii · Leyland Cypress, aligned with Botanical Library naming Cupressus x Leylandii.",
                    "Family: Cupressaceae. Plant type: evergreen conifer · horticultural hybrid.",
                    "Origin: artificial horticultural hybrid, historically associated with Cupressus macrocarpa and Nootka Cypress (Callitropsis / Chamaecyparis nootkatensis).",
                    "Alternative taxonomic treatments include × Cuprocyparis leylandii and × Hesperotropsis. Bonsai World retains Cupressus × leylandii as the primary Species Library identity for Botanical Library consistency.",
                    "Do not confuse Cupressus × leylandii with its parent species, with Cupressus arizonica, Cupressus sempervirens or with Chamaecyparis species treated as independent bonsai subjects.",
                    "The profile must use Cupressus × leylandii as the hybrid identity even where horticultural sources use cultivar names extensively.",
                    "Do not transfer cultivar-specific foliage colours or growth habits to the hybrid as a whole.",
                    "Bonsai World hierarchy: Hybrid taxon → cultivar / horticultural selection → Individual Tree.",
                ]
            ),
            SpeciesProfileSection(
                id: "overview",
                title: "Species Overview",
                paragraphs: [
                    "Cupressus × leylandii is a very vigorous evergreen horticultural hybrid widely used for hedges and screening.",
                    "It is not a wild species with a natural geographic range; it originated as an artificial hybrid historically associated with Monterey Cypress and Nootka Cypress parentage.",
                    "Foliage consists of scale-like leaves arranged closely around the shoots. Colour and texture can vary substantially among cultivars.",
                    "In bonsai, the primary challenge is vigour control rather than encouraging growth.",
                    "Limited regeneration from bare old wood means hedge-style shearing into leafless interior wood is a serious risk. Do not shear into old leafless wood expecting recovery.",
                    "Leyland Cypress is often a less refined bonsai subject than classic Chamaecyparis or Taxus. Suitability depends strongly on vigour management and the individual form.",
                    "Dense growth develops readily, but dense foliage should not be achieved by cutting into old, leafless wood.",
                ],
                bullets: [
                    "Evergreen conifer · Horticultural hybrid",
                    "Cupressaceae",
                    "Historically associated with Cupressus macrocarpa and Nootka Cypress",
                    "Very vigorous hedge plant",
                    "Bonsai challenge: vigour control, not encouraging growth",
                    "Scale-like foliage",
                    "Limited regeneration from bare old wood",
                    "Many cultivars — do not transfer cultivar traits to the hybrid as a whole",
                    "Often less refined bonsai subject than classic Chamaecyparis or Taxus",
                    "Requires outdoor cultivation",
                    "Distinct from parent species and other Cupressus",
                ]
            ),
            SpeciesProfileSection(
                id: "cultivars",
                title: "Cultivars and Forms",
                paragraphs: [
                    "Cupressus × leylandii has many named horticultural cultivars that may differ significantly in foliage colour, vigour, growth habit and density.",
                    "Do not invent cultivar-specific characteristics and present them as characteristics of the hybrid as a whole.",
                    "Do not describe cultivar-specific foliage as representative of all Leyland Cypress.",
                    "Do not create unnecessary separate Species Library profiles for minor individual variation.",
                    "The primary Species Profile remains Cupressus × leylandii.",
                    "Only create separate profiles where a distinct cultivar has a clear and established independent bonsai identity.",
                ]
            ),
            SpeciesProfileSection(
                id: "natural-growth",
                title: "Natural Growth and Vigour",
                paragraphs: [
                    "Leyland Cypress is typically very vigorous when cultivated under favourable conditions.",
                    "Growth depends on light, temperature, water, nutrition, root health, container size, substrate, local climate, seasonal conditions and horticultural form.",
                    "In bonsai, uncontrolled extension growth quickly produces coarse, dense and difficult structure.",
                    "During development and refinement, growth should be controlled progressively rather than through severe shearing.",
                    "The objective is: Controlled development growth · Progressive vigour management · Healthy foliage density.",
                ]
            ),
            SpeciesProfileSection(
                id: "foliage",
                title: "Foliage",
                paragraphs: [
                    "The foliage consists primarily of small, overlapping scale-like leaves.",
                    "Colour is generally green to yellow-green at a general hybrid level and can vary widely among cultivars.",
                    "Do not transfer the foliage colour or texture of a particular cultivar to the hybrid as a whole.",
                    "The foliage creates a naturally dense surface. Dense outer growth can rapidly shade the interior.",
                    "Avoid excessive removal of interior foliage.",
                    "Preserve viable inner shoots wherever they contribute to future branch structure.",
                ]
            ),
            SpeciesProfileSection(
                id: "bark-trunk",
                title: "Bark and Trunk",
                paragraphs: [
                    "Young bark is relatively smooth. With age, bark develops greater fibrous character.",
                    "Trunk diameter can increase readily because of strong vigour, but diameter alone does not create refined bonsai structure.",
                    "Allow sufficient growth during trunk development to establish taper, movement, diameter and primary branch structure, while keeping extension under control.",
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
                    "Leyland Cypress can tolerate exposed conditions once established, but container-grown bonsai remain vulnerable to rapid moisture loss.",
                    "Strong wind can increase transpiration, dry the substrate rapidly, mechanically stress branches and destabilise shallow containers.",
                    "Secure the tree appropriately and monitor moisture during prolonged windy weather.",
                    "Do not confuse exposure tolerance with drought tolerance.",
                ]
            ),
            SpeciesProfileSection(
                id: "watering",
                title: "Watering",
                paragraphs: [
                    "Maintain consistent moisture during active growth.",
                    "The substrate should remain appropriately moist while still providing strong drainage and oxygen availability.",
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
                    "During refinement, nutrition should be controlled carefully because Leyland Cypress is already very vigorous.",
                    "Avoid using excessive fertilizer to force dense foliage.",
                    "Follow the existing Bonsai World fertilization framework.",
                    "Do not prescribe fixed universal fertilizer doses.",
                ]
            ),
            SpeciesProfileSection(
                id: "pruning",
                title: "Pruning",
                paragraphs: [
                    "Pruning should be conservative and developmental, with strong emphasis on vigour control.",
                    "Priorities: establish trunk structure; establish primary branches; preserve useful inner growth; control unwanted extension; develop secondary branching; refine foliage pads.",
                    "Avoid severe cuts into completely bare old wood.",
                    "Do not repeatedly shear the outer foliage in hedge style without considering the underlying branch structure.",
                    "Do not shear into old leafless wood expecting recovery.",
                    "Large structural cuts should be carefully planned and performed only when appropriate to the development stage.",
                ]
            ),
            SpeciesProfileSection(
                id: "back-budding",
                title: "Back-budding",
                paragraphs: [
                    "Back-budding must be described conservatively.",
                    "Do not rely on Cupressus × leylandii producing new shoots from completely bare old branches.",
                    "New growth is most dependable where viable foliage and buds remain.",
                    "Therefore: retain inner foliage, shorten branches progressively, preserve useful shoots near branch junctions, avoid stripping branches completely and develop ramification from existing viable growth.",
                    "Never promise predictable back-budding.",
                    "Do not shear into old leafless wood expecting recovery.",
                ]
            ),
            SpeciesProfileSection(
                id: "ramification",
                title: "Ramification",
                paragraphs: [
                    "Dense branching can develop readily, but refined ramification still requires deliberate progressive work.",
                    "Focus on selective pruning, controlled extension growth, branch positioning, preservation of inner shoots, gradual subdivision and maintaining adequate light penetration.",
                    "Do not create overly dense pads at the expense of inner branch health.",
                    "The objective is a three-dimensional branch structure rather than a flat outer hedge shell.",
                ]
            ),
            SpeciesProfileSection(
                id: "wiring",
                title: "Wiring",
                paragraphs: [
                    "Wiring is useful for trunk movement, primary branch placement, secondary branch structure and creating layered foliage masses.",
                    "Vigorous growth can bite into wire quickly. Monitor wires regularly during active growth.",
                    "Use careful wiring around scale foliage and young shoots.",
                    "Remove or adjust wire before permanent scarring develops.",
                    "Do not force mature branches beyond their safe flexibility.",
                ]
            ),
            SpeciesProfileSection(
                id: "deadwood-potential",
                title: "Deadwood",
                paragraphs: [
                    "Deadwood may be used where it suits the individual tree.",
                    "Use restrained deadwood techniques.",
                    "When creating deadwood: follow the natural grain, keep proportions appropriate, preserve structural strength, avoid excessive carving and allow weathering to contribute to the appearance.",
                    "Naturalistic deadwood can complement evergreen conifer character, but deadwood alone does not compensate for uncontrolled vigour or poor branch structure.",
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
                    "During development, allow sufficient extension growth to build trunk diameter and taper, while keeping vigour under deliberate control.",
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
                    "Cupressus × leylandii is typically propagated vegetatively to maintain horticultural selections.",
                    "Seed propagation is not the normal route for reproducing named Leyland Cypress cultivars and should not be expected to reproduce a specific horticultural form.",
                    "Distinguish hybrid propagation from cultivar propagation. Do not imply that seedlings reproduce a named cultivar.",
                    "Describe propagation as a long-term process. Do not present propagation as a rapid route to finished bonsai.",
                    "Detailed procedures belong in Bonsai World Propagation Knowledge Articles.",
                ]
            ),
            SpeciesProfileSection(
                id: "pests",
                title: "Pests and Problems",
                paragraphs: [
                    "Potential problems include aphids, scale insects, spider mites, cypress-associated insect pests, fungal diseases, root problems caused by poor drainage, drought stress, excessive foliage density, interior dieback caused by poor light penetration, hedge-style shearing damage into bare wood and wire scarring.",
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
                    "Spring: new shoots begin developing. Monitor vigorous extension carefully. Begin appropriate seasonal feeding. Review wiring frequently. Increase watering as growth and transpiration increase. Preserve useful inner shoots.",
                    "Summer: maintain consistent moisture. Monitor foliage density closely. Maintain good airflow. Watch for excessive heat and drought stress. Control unwanted extension growth. Avoid heavy structural work during periods of environmental stress.",
                    "Autumn: new growth gradually hardens. Review branch structure. Complete appropriate wiring adjustments. Adjust feeding according to the existing Bonsai World seasonal framework. Prepare for winter.",
                    "Winter: maintain outdoor cultivation. Protect container roots from extreme temperature fluctuations. Monitor winter drying during cold, dry and windy periods. Avoid unnecessary root disturbance.",
                    "The hybrid should remain outdoors through winter.",
                ]
            ),
            SpeciesProfileSection(
                id: "styles",
                title: "Bonsai Styles",
                paragraphs: [
                    "Suitable styles may include Informal Upright, Upright, Slanting and naturalistic conifer forms where the individual material supports them.",
                    "Dense scale foliage can support foliage masses, but the design must avoid an artificial hedge-blob appearance.",
                    "The final design should retain visible branch structure beneath the foliage.",
                    "Cultivar-specific habits must not be presented as universal hybrid characteristics.",
                    "The individual material should determine the final design.",
                ]
            ),
            SpeciesProfileSection(
                id: "tree-stage",
                title: "Development by Tree Stage",
                paragraphs: [
                    "Young nursery material: focus on health, trunk movement, trunk thickening, root development, vigour control and initial branch selection. Do not over-refine young material.",
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
                    "Cupressus × leylandii should be presented honestly as a vigorous horticultural hybrid whose bonsai suitability depends on vigour control and form.",
                ],
                bullets: [
                    "Treat it as an outdoor evergreen conifer hybrid",
                    "Vigour control is the primary bonsai challenge — not encouraging growth",
                    "Do not shear into old leafless wood expecting recovery",
                    "Preserve viable inner foliage",
                    "Do not expect reliable regeneration from completely bare old wood",
                    "Avoid hedge-style shearing without considering branch structure",
                    "Maintain three-dimensional branch structure",
                    "Control foliage density so that interior shoots remain healthy",
                    "Use progressive branch reduction",
                    "Maintain excellent substrate drainage and aeration",
                    "Monitor wire carefully",
                    "Do not transfer cultivar traits to the hybrid as a whole",
                    "Often less refined as bonsai than classic Chamaecyparis or Taxus",
                    "Do not confuse with parent species or other Cupressus",
                    "Winter dormancy is required where winters are cold",
                    "Do not move indoors for routine winter care",
                ]
            ),
        ]
    }
}
