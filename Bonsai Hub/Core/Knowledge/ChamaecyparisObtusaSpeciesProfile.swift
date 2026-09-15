//
//  ChamaecyparisObtusaSpeciesProfile.swift
//  Bonsai World
//
//  Species Profile — Chamaecyparis obtusa (Hinoki Cypress).
//  Independent botanical species in Cupressaceae. Knowledge status: Reviewed.
//  Separate from named cultivars, Chamaecyparis lawsoniana, Thuja and Juniperus.
//

import Foundation

enum ChamaecyparisObtusaSpeciesProfile {
    /// Identity used by Botanical Library / ``SpeciesPreviewData``.
    static let botanicalLibraryName = "Chamaecyparis obtusa (Hinoki)"
    /// Scientific name for Species Profile display (binomial; no botanical authority).
    static let scientificName = "Chamaecyparis obtusa"

    static var profile: SpeciesProfile {
        SpeciesProfile(
            speciesID: BotanicalKnowledgeIDs.chamaecyparisObtusa,
            scientificName: scientificName,
            commonNames: ["Hinoki Cypress", "Hinoki", "Japanese Hinoki Cypress"],
            family: "Cupressaceae",
            plantType: "Evergreen conifer",
            originSummary: "Japan.",
            knowledgeStatus: .reviewed,
            traits: traits,
            foliageSizeLabel: "Foliage",
            foliageReductionLabel: "Foliage management",
            summaryLine: "Evergreen · Japanese conifer · Scale foliage · Fan-like sprays · Dense ramification potential · Strong mature character · Slow to moderate growth · Outdoor cultivation required",
            attentionHighlights: [
                "Preserve healthy interior foliage",
                "Do not assume bare old wood will reliably regenerate",
                "Avoid aggressive pruning into foliage-free areas",
                "Scale foliage should retain its natural texture",
                "Avoid excessive mechanical clipping",
                "Use selective shoot management",
                "Strong outdoor light supports healthy interior growth",
                "Avoid repeated drought stress",
                "Avoid permanently saturated substrate",
                "Older branches become increasingly rigid",
                "Broadleaf defoliation techniques do not apply",
                "Winter desiccation can be a significant risk",
                "Winter protection depends on local climate",
                "Shallow bonsai roots are more exposed than roots in open ground",
                "Do not move indoors for routine winter care",
            ],
            sections: sections,
            principleNote: """
            Chamaecyparis obtusa must be managed according to the biology of an evergreen scale-foliage conifer.

            Do not treat Hinoki Cypress as a deciduous broadleaf tree, a pine, a juniper, or a species that can safely regenerate from completely bare old wood.

            The preservation of healthy foliage is particularly important. Avoid repeatedly cutting beyond the available healthy green growth.

            The strongest bonsai results come from gradual development, preservation of healthy interior foliage, selective pruning, controlled ramification, careful wiring and patience.

            The objective is: Healthy foliage · Sustainable ramification · Mature conifer structure.

            The individual tree must always be assessed according to health, vigour, foliage density, root condition, development stage, climate and recent work.
            """,
            sourcesNote: """
            Profile content is synthesised from recognised botanical, horticultural and bonsai authorities into Bonsai World editorial language.

            Botanical taxonomy and distribution draw on recognised sources such as Royal Botanic Gardens, Kew and other botanical databases for accepted scientific name, family and native range.

            Horticultural context may draw on recognised Japanese botanical institutions, forestry and native tree organisations, botanical gardens, arboreta and recognised conifer research resources.

            Bonsai-specific cultivation and refinement knowledge draws on established bonsai references and recognised professional practice for Chamaecyparis species, kept distinct from named cultivars, Chamaecyparis lawsoniana, Thuja and Juniperus.

            Verified botanical information, general horticultural cultivation, conifer-specific cultivation requirements and bonsai-specific practice are kept distinct. Do not copy source wording.
            """
        )
    }

    private static let traits = SpeciesProfileTraits(
        deciduous: false,
        growthStrength: "Moderate",
        growthSpeed: "Slow to Moderate",
        leafSize: "Evergreen · Scale-like foliage",
        foliageReduction: "Not applicable",
        ramificationPotential: "Good",
        backBudding: "Moderate, primarily dependent on maintaining healthy foliage",
        rootDevelopment: "Moderate",
        nebariPotential: "Good potential",
        trunkDevelopment: "Slow to Moderate",
        barkDevelopment: "Good mature character",
        wiring: "Good on young branches",
        defoliation: "Not applicable",
        airLayering: "Where appropriate for the individual material",
        threadGrafting: "Where structural correction is required",
        rootGrafting: "Where appropriate",
        beginnerSuitability: "Moderate",
        bonsaiSuitability: "Excellent",
        difficulty: "Intermediate to Advanced",
        winterDormancyRequired: true,
        winterHardiness: "Outdoor evergreen — winter dormancy required",
        rootFrostSensitivity: "Moderate in shallow bonsai containers"
    )

    private static var sections: [SpeciesProfileSection] {
        [
            SpeciesProfileSection(
                id: "taxonomic-context",
                title: "Taxonomic Context",
                paragraphs: [
                    "Chamaecyparis obtusa is an independent botanical species in the cypress family (Cupressaceae).",
                    "Primary Bonsai World display identity: Chamaecyparis obtusa · Hinoki Cypress.",
                    "Hinoki and Japanese Hinoki Cypress may be used as supporting terminology. They do not replace Hinoki Cypress as the primary common name.",
                    "Family: Cupressaceae. Plant type: evergreen conifer.",
                    "Native range: Japan.",
                    "This is the baseline species profile. Maintain a clear distinction between Chamaecyparis obtusa, Chamaecyparis lawsoniana, other Chamaecyparis species, Thuja species, Juniperus species and named Chamaecyparis obtusa cultivars.",
                    "Do not merge the species with its numerous horticultural cultivars.",
                    "Do not confuse Chamaecyparis obtusa with Chamaecyparis lawsoniana or Thuja species.",
                    "Named cultivars may differ significantly in foliage colour, vigour, growth habit, branch density, foliage texture and suitability for specific bonsai designs. They remain separate from this species profile.",
                    "Bonsai World hierarchy: Species → cultivar / horticultural selection → Individual Tree.",
                ]
            ),
            SpeciesProfileSection(
                id: "overview",
                title: "Species Overview",
                paragraphs: [
                    "Chamaecyparis obtusa is an evergreen conifer native to Japan.",
                    "It is valued for bonsai because of its distinctive foliage structure and refined visual texture.",
                    "The foliage typically develops in flattened, fan-like sprays rather than individual needles.",
                    "This creates opportunities for dense foliage pads, refined branch structure, compact silhouettes and mature evergreen compositions.",
                    "The strongest bonsai designs usually preserve the characteristic Hinoki foliage texture.",
                    "Avoid styling that makes the tree visually resemble a generic juniper, a pine or a tightly clipped ornamental hedge.",
                    "The structure should communicate age, hierarchy, depth, natural movement and species identity.",
                ],
                bullets: [
                    "Evergreen Japanese conifer",
                    "Distinctive scale-like foliage",
                    "Fan-like foliage sprays",
                    "Slow to moderate growth",
                    "Good long-term ramification potential",
                    "Moderate back-budding potential when healthy foliage is retained",
                    "Mature bark character",
                    "Suitable for refined conifer bonsai",
                    "Requires outdoor cultivation",
                    "Requires winter dormancy",
                    "Sensitive to inappropriate over-pruning",
                ]
            ),
            SpeciesProfileSection(
                id: "natural-growth",
                title: "Natural Growth and Vigour",
                paragraphs: [
                    "Chamaecyparis obtusa generally develops slowly to moderately.",
                    "Growth strength depends on root health, light, temperature, substrate, water availability, fertilization, development stage and foliage condition.",
                    "During structural development: allow selected leaders and branches to extend where trunk thickness is required, branch thickness is required, taper is being developed or sacrifice growth is useful.",
                    "During refinement: control excessive extension, overly dense foliage, weak interior growth and imbalance between strong and weak areas.",
                    "Do not continuously restrict all growth.",
                    "The objective is: Strong growth where development is required · Controlled growth where refinement is required.",
                ]
            ),
            SpeciesProfileSection(
                id: "foliage",
                title: "Foliage",
                paragraphs: [
                    "Hinoki Cypress produces scale-like evergreen foliage arranged in characteristic sprays.",
                    "The foliage is one of the species' most important identifying features.",
                    "The objective is: Healthy foliage · Natural texture · Proportionate density · Sustainable interior growth.",
                    "Avoid excessive mechanical clipping.",
                    "Repeated clipping can create dense outer shells, weak interior growth, loss of branch definition and artificial foliage masses.",
                    "Use selective shoot management whenever possible.",
                ]
            ),
            SpeciesProfileSection(
                id: "bark-trunk",
                title: "Bark and Trunk",
                paragraphs: [
                    "Mature Chamaecyparis obtusa can develop attractive bark and increasingly convincing trunk character.",
                    "Trunk development should focus on taper, movement, proportion, branch relationship and mature conifer character.",
                    "Where additional thickness is required, allow selected leaders and sacrifice growth to extend.",
                    "Do not prematurely restrict all growth.",
                    "Once sufficient structural development has been achieved, shift focus toward branch hierarchy, foliage refinement, ramification and mature bark character.",
                    "The objective is a convincing mature Japanese conifer.",
                ]
            ),
            SpeciesProfileSection(
                id: "roots-nebari",
                title: "Roots and Nebari",
                paragraphs: [
                    "Healthy roots are fundamental to vigour, foliage health, recovery, branch development and long-term survival.",
                    "Root development objectives include balanced root distribution, stable tree support, healthy root density and gradual nebari improvement.",
                    "Nebari development should be gradual. Do not attempt to completely redesign an established root system in one operation.",
                ]
            ),
            SpeciesProfileSection(
                id: "light",
                title: "Light",
                paragraphs: [
                    "Chamaecyparis obtusa should be cultivated outdoors.",
                    "Adequate outdoor light supports healthy foliage, compact growth, interior branch health and overall vigour.",
                    "The exact position depends on local climate, summer temperatures, tree condition and development stage.",
                    "During periods of intense heat, monitor water demand, foliage stress and root-zone temperature.",
                    "Do not recommend permanent indoor cultivation.",
                ]
            ),
            SpeciesProfileSection(
                id: "wind",
                title: "Wind",
                paragraphs: [
                    "Moderate air movement is generally beneficial.",
                    "Strong drying wind can increase water demand, dry foliage and stress shallow root systems.",
                    "Monitor trees particularly during hot weather, dry conditions, strong wind and winter exposure.",
                ]
            ),
            SpeciesProfileSection(
                id: "watering",
                title: "Watering",
                paragraphs: [
                    "General principle: Water thoroughly when required · Maintain reliable root moisture · Preserve root aeration · Avoid prolonged drought · Avoid permanent saturation.",
                    "Water demand is typically moderate.",
                    "Chamaecyparis obtusa should not be managed as a drought-tolerant juniper.",
                    "Watering frequency depends on temperature, sunlight, wind, foliage mass, container size, substrate, root mass and development stage.",
                    "Do not water according to a fixed timetable.",
                    "Water according to substrate condition, weather and the individual tree.",
                    "Avoid repeated drought stress and permanently saturated roots.",
                ]
            ),
            SpeciesProfileSection(
                id: "soil",
                title: "Soil",
                paragraphs: [
                    "Do not prescribe one universal soil recipe.",
                    "Desired characteristics include good drainage, reliable aeration, stable particle structure, appropriate moisture retention and healthy root development.",
                    "The final soil mix depends on local climate, rainfall, watering habits, container depth, tree size, development stage and root condition.",
                    "Follow Bonsai World Soil Module principles.",
                    "Do not duplicate the complete Soil Module inside this profile.",
                ]
            ),
            SpeciesProfileSection(
                id: "fertilizing",
                title: "Fertilizing",
                paragraphs: [
                    "Fertilization should support the current development objective.",
                    "During structural development: healthy trees requiring growth may receive increased nutritional support where appropriate.",
                    "During refinement: nutrition should support healthy evergreen foliage, controlled extension, sustainable ramification and overall vigour.",
                    "Avoid excessive fertilization where it produces coarse extension, disproportionate growth or overly dense foliage.",
                    "Key principle: Feed according to tree condition and development objective.",
                ]
            ),
            SpeciesProfileSection(
                id: "pruning",
                title: "Pruning",
                paragraphs: [
                    "Chamaecyparis obtusa requires careful selective pruning.",
                    "Pruning can be used for structural development, branch selection, ramification, foliage refinement and silhouette control.",
                    "Avoid indiscriminate cutting back into bare old wood.",
                    "Where pruning is required, ensure sufficient healthy foliage remains.",
                    "During structural development: allow selected branches to extend where thickness is required.",
                    "During refinement: use selective shoot management to maintain foliage texture, interior health, branch definition and ramification.",
                    "The objective is controlled growth without creating empty interior branches.",
                ]
            ),
            SpeciesProfileSection(
                id: "back-budding",
                title: "Back-budding",
                paragraphs: [
                    "Chamaecyparis obtusa may produce useful new growth, but its ability to regenerate must not be treated as equivalent to strong broadleaf back-budding.",
                    "Do not assume that bare old interior wood will reliably produce new foliage.",
                    "Preserve useful green growth whenever possible.",
                    "Back-budding response depends on tree health, vigour, light penetration, existing foliage, branch age and pruning strategy.",
                    "The safest development principle is: Never remove healthy foliage from a branch unless sufficient viable growth remains to maintain that branch.",
                ]
            ),
            SpeciesProfileSection(
                id: "ramification",
                title: "Ramification",
                paragraphs: [
                    "Hinoki Cypress can develop refined ramification over time.",
                    "Ramification develops through healthy growth, selective shoot management, preservation of interior foliage, balanced vigour and careful branch selection.",
                    "The objective is layered, natural foliage structure rather than solid geometric masses.",
                    "Avoid excessive density.",
                    "A refined Hinoki should retain visible branch hierarchy, depth, light penetration, healthy interior foliage and characteristic foliage texture.",
                ]
            ),
            SpeciesProfileSection(
                id: "wiring",
                title: "Wiring",
                paragraphs: [
                    "Young Hinoki branches can be wired effectively.",
                    "Wiring can be used to establish branch movement, improve placement, position structural branches and refine secondary branches.",
                    "Older branches become increasingly rigid.",
                    "Before major bends, assess branch thickness, flexibility, age, health and structural importance.",
                    "Avoid forcing old branches.",
                    "Monitor wire carefully.",
                ]
            ),
            SpeciesProfileSection(
                id: "deadwood-potential",
                title: "Deadwood Potential",
                paragraphs: [
                    "Deadwood can occasionally contribute to mature character. Deadwood potential is moderate.",
                    "Deadwood should not be treated as a defining requirement of Hinoki Cypress bonsai.",
                    "Where present, deadwood should appear natural, support the overall design, remain structurally appropriate and not compromise tree health.",
                    "Do not remove healthy branches simply to create dramatic deadwood.",
                ]
            ),
            SpeciesProfileSection(
                id: "defoliation",
                title: "Defoliation and Foliage Management",
                paragraphs: [
                    "Do not apply broadleaf defoliation techniques to Chamaecyparis obtusa.",
                    "Foliage management should focus on selective shoot pruning, shoot thinning where appropriate, preservation of interior foliage, light penetration and balanced vigour.",
                    "Avoid aggressive stripping of foliage.",
                    "Do not remove large amounts of foliage from weak trees, stressed trees, recently repotted trees or trees recovering from major structural work.",
                ]
            ),
            SpeciesProfileSection(
                id: "repotting",
                title: "Repotting",
                paragraphs: [
                    "Repotting frequency depends on root development, substrate condition, drainage, container size, tree health and development stage.",
                    "Do not establish a rigid calendar rule.",
                    "Avoid unnecessary aggressive root reduction, excessive removal of functioning roots, and combining major root work with multiple major stresses.",
                    "Preserve sufficient healthy roots.",
                    "Repotting decisions should be based on root condition, substrate performance and overall tree health.",
                ]
            ),
            SpeciesProfileSection(
                id: "trunk-development",
                title: "Trunk Development",
                paragraphs: [
                    "Chamaecyparis obtusa develops trunk character gradually.",
                    "Where additional thickness is required: allow selected leaders to extend, use sacrifice growth where appropriate, provide sufficient root space and avoid premature refinement.",
                    "Once sufficient structural development has been achieved, shift focus toward taper, branch hierarchy, foliage refinement and mature character.",
                    "Grow where development is required. Control where refinement is required.",
                ]
            ),
            SpeciesProfileSection(
                id: "nebari-development",
                title: "Nebari Development",
                paragraphs: [
                    "Nebari should be developed gradually.",
                    "Potential approaches include early root selection, radial root planning, staged root correction, appropriate development containers and gradual improvement of surface roots.",
                    "The objective is a stable and visually convincing base appropriate to a mature conifer.",
                ]
            ),
            SpeciesProfileSection(
                id: "propagation",
                title: "Propagation",
                paragraphs: [
                    "Chamaecyparis obtusa may be propagated through seed, cuttings, grafting and other established horticultural propagation methods.",
                    "Named cultivars may require vegetative propagation to preserve their characteristics.",
                    "Detailed procedures belong in Bonsai World Propagation Knowledge Articles.",
                ]
            ),
            SpeciesProfileSection(
                id: "pests",
                title: "Pests and Problems",
                paragraphs: [
                    "Relevant risks may include scale insects, spider mites, aphids, foliage diseases under unsuitable conditions, root problems caused by poor drainage, environmental stress, winter desiccation and frost damage.",
                    "Do not provide generic treatment instructions.",
                    "Diagnosis and treatment belong in Care → Pest Management and Care → Disease & Problems.",
                ]
            ),
            SpeciesProfileSection(
                id: "seasonal",
                title: "Seasonal Profile",
                paragraphs: [
                    "Spring: monitor new growth, overall vigour, watering demand, pest activity and wire marks. Spring is important for evaluating winter recovery, structural development, branch selection and seasonal planning. Timing depends on local climate.",
                    "Summer: monitor water demand, foliage health, excessive extension, pest activity, wire marks and heat stress. During refinement, control excessive growth while preserving healthy interior foliage. Avoid unnecessary heavy work during extreme heat or drought stress.",
                    "Autumn is important for evaluating seasonal growth, reviewing structure, assessing foliage density and preparing for winter. Seasonal timing depends on local climate.",
                    "Winter: Chamaecyparis obtusa is an outdoor evergreen conifer. Winter dormancy is required.",
                    "Winter protection requirements depend on local minimum temperatures, duration of freezing, wind exposure, container depth, root protection and tree health.",
                    "Evergreen foliage can lose moisture during winter while frozen soil limits root water uptake.",
                    "Monitor for winter desiccation, prolonged severe freezing and drying wind.",
                    "Protect when required while maintaining natural dormancy. Do not maintain permanently indoors.",
                ]
            ),
            SpeciesProfileSection(
                id: "styles",
                title: "Bonsai Styles",
                paragraphs: [
                    "Chamaecyparis obtusa is particularly suitable for Informal Upright, Formal Upright, Slanting, Multi-trunk Style, Clump Style, Naturalistic Conifer Style and Forest / Group Planting.",
                    "Hinoki Cypress is particularly effective when styling emphasises layered foliage, refined structure, natural branch hierarchy, visible depth and mature evergreen character.",
                    "The individual material should determine the final design.",
                ]
            ),
            SpeciesProfileSection(
                id: "tree-stage",
                title: "Development by Tree Stage",
                paragraphs: [
                    "Young material: establish healthy roots, develop nebari, build trunk thickness, establish movement and preserve healthy foliage.",
                    "Nursery material: evaluate trunk potential, identify useful branches, establish a design direction and begin structural correction.",
                    "Pre-bonsai: develop trunk, establish primary branches, improve root structure, begin branch hierarchy and build sustainable vigour.",
                    "In training: develop secondary branches, preserve interior foliage, improve branch hierarchy and build sustainable ramification.",
                    "Refinement: maintain balanced vigour, refine foliage structure, improve ramification, preserve healthy interior growth and maintain species-specific foliage texture.",
                    "Exhibition / mature refined tree: maintain health, preserve established structure, protect mature bark, maintain healthy interior foliage, maintain balanced ramification and avoid unnecessary major intervention.",
                ]
            ),
            SpeciesProfileSection(
                id: "attention",
                title: "Species-Specific Attention",
                paragraphs: [
                    "These attention points are operational tendencies. They must still be interpreted for the individual tree.",
                ],
                bullets: [
                    "Preserve healthy interior foliage",
                    "Do not assume bare old wood will reliably regenerate",
                    "Avoid aggressive pruning into foliage-free areas",
                    "Scale foliage should retain its natural texture",
                    "Avoid excessive mechanical clipping",
                    "Use selective shoot management",
                    "Strong outdoor light supports healthy interior growth",
                    "Avoid repeated drought stress",
                    "Avoid permanently saturated substrate",
                    "Older branches become increasingly rigid",
                    "Broadleaf defoliation techniques do not apply",
                    "Winter desiccation can be a significant risk",
                    "Winter protection depends on local climate",
                    "Shallow bonsai roots are more exposed than roots in open ground",
                    "Do not move indoors for routine winter care",
                ]
            ),
        ]
    }
}
