//
//  PinusParvifloraSpeciesProfile.swift
//  Bonsai World
//
//  Species Profile — Pinus parviflora (Japanese White Pine).
//  Independent botanical species in Pinaceae. Knowledge status: Reviewed.
//

import Foundation

enum PinusParvifloraSpeciesProfile {
    /// Identity used by Botanical Library / ``SpeciesPreviewData``.
    static let botanicalLibraryName = "Pinus parviflora"
    /// Scientific name for Species Profile display (binomial; no botanical authority).
    static let scientificName = "Pinus parviflora"

    static var profile: SpeciesProfile {
        SpeciesProfile(
            speciesID: BotanicalKnowledgeIDs.pinusParviflora,
            scientificName: scientificName,
            commonNames: ["Japanese White Pine"],
            family: "Pinaceae",
            plantType: "Evergreen conifer",
            originSummary: "Japan.",
            knowledgeStatus: .reviewed,
            traits: traits,
            foliageSizeLabel: "Foliage",
            foliageReductionLabel: "Needle reduction",
            summaryLine: "Evergreen · Five-needle pine · Fine blue-green foliage · Slow to moderate growth · Excellent refinement potential · Classic Japanese bonsai species",
            attentionHighlights: [
                "One of the most important classical Japanese bonsai pine species",
                "Needles grow in bundles of five",
                "Naturally fine blue-green foliage is a major strength",
                "Growth is generally slower than vigorous two-needle pine species",
                "Do not apply generic pine techniques automatically",
                "Do not automatically use Japanese Black Pine decandling methods",
                "Back-budding depends on retained foliage and tree health",
                "Preserve viable needles on branches intended to survive",
                "Strong outdoor light supports healthy development",
                "Avoid permanently wet substrate",
                "Older branches may become brittle during bending",
                "Needle management should be selective and based on vigour",
                "Grafting can be important for advanced development and cultivar preservation",
                "Protect shallow roots during severe winter conditions",
                "Do not move indoors for routine winter care",
            ],
            sections: sections,
            principleNote: """
            Pinus parviflora is one of the most refined and highly regarded pine species used in bonsai.

            It is particularly valued for naturally fine needles, bundles of five needles, blue-green foliage, elegant branch structure, refined ramification, excellent suitability for mature bonsai and long-term development potential.

            Japanese White Pine generally rewards patient development.

            It should not be forced into rapid refinement through repeated heavy work.

            The species must be managed according to tree health, root condition, development stage, branch strength, bud strength, needle mass, recent work, climate, weather, container size and current vigour.

            The objective is: Healthy foliage · Balanced vigour · Fine ramification · Elegant branch structure · Long-term refinement
            """,
            sourcesNote: """
            Profile content is synthesised from recognised botanical, horticultural and bonsai authorities into Bonsai World editorial language.

            Botanical taxonomy and distribution draw on recognised sources such as Royal Botanic Gardens, Kew and other botanical databases for accepted scientific name, family and native range.

            Horticultural context may draw on Japanese botanical and horticultural institutions and recognised arboreta.

            Bonsai-specific cultivation and refinement knowledge draws on established Japanese bonsai institutions and recognised references for Pinus parviflora practice, kept distinct from techniques belonging primarily to other pine species.

            Verified botanical information, general horticultural cultivation and bonsai-specific practice are kept distinct. Do not copy source wording.
            """
        )
    }

    private static let traits = SpeciesProfileTraits(
        deciduous: false,
        growthStrength: "Slow to Moderate",
        growthSpeed: "Slow to Moderate",
        leafSize: "Evergreen · Needles in bundles of five · Fine blue-green to silvery-green appearance",
        foliageReduction: "Naturally fine — preserve vigour; do not force unnecessary reduction",
        ramificationPotential: "Excellent",
        backBudding: "Moderate to Good under healthy conditions and appropriate management",
        rootDevelopment: "Moderate",
        nebariPotential: "Good development potential",
        trunkDevelopment: "Slow",
        barkDevelopment: "Attractive mature bark and visual age with time",
        wiring: "Excellent suitability",
        defoliation: "Not suitable",
        airLayering: "Where appropriate for the individual material",
        threadGrafting: "Particularly relevant for structural correction",
        rootGrafting: "Where appropriate",
        beginnerSuitability: "Moderate",
        bonsaiSuitability: "Excellent",
        difficulty: "Intermediate to Advanced",
        winterDormancyRequired: true,
        winterHardiness: "Outdoor evergreen — climate dependent",
        rootFrostSensitivity: "Moderate in shallow bonsai containers"
    )

    private static var sections: [SpeciesProfileSection] {
        [
            SpeciesProfileSection(
                id: "taxonomic-context",
                title: "Taxonomic Context",
                paragraphs: [
                    "Pinus parviflora is an independent botanical species in Pinaceae.",
                    "Primary Bonsai World display identity: Pinus parviflora · Japanese White Pine.",
                    "Family: Pinaceae. Plant type: evergreen conifer.",
                    "Native range: Japan.",
                    "Pinus parviflora is one of the most important conifer species in traditional Japanese bonsai.",
                    "Maintain a clear distinction between Pinus parviflora, Pinus sylvestris, Pinus mugo, Pinus thunbergii and other white pine species.",
                    "Do not merge Japanese White Pine with other five-needle pines simply because their foliage appears similar.",
                    "Bonsai World hierarchy: Species → cultivar / horticultural selection → Individual Tree.",
                ]
            ),
            SpeciesProfileSection(
                id: "overview",
                title: "Species Overview",
                paragraphs: [
                    "Pinus parviflora is native to Japan and is one of the most important species in classical Japanese bonsai.",
                    "It is particularly valued for its naturally refined appearance.",
                    "Mature bonsai may combine fine needles, compact foliage, elegant branching, aged bark, powerful trunk character and a refined silhouette.",
                    "Japanese White Pine is often associated with highly refined bonsai, but young material should not be treated as finished material too early.",
                    "Structural development remains essential.",
                    "Important development principle: Grow where development is required. Control where refinement is required.",
                ],
                bullets: [
                    "Evergreen conifer",
                    "Needles arranged in bundles of five",
                    "Fine blue-green to silvery-green foliage",
                    "Excellent refinement potential",
                    "Slow to moderate growth",
                    "Excellent ramification potential",
                    "Suitable for detailed wiring",
                    "Classic Japanese bonsai species",
                    "Requires strong outdoor light",
                    "Requires winter dormancy",
                    "Requires a well-drained root environment",
                ]
            ),
            SpeciesProfileSection(
                id: "natural-growth",
                title: "Natural Growth and Vigour",
                paragraphs: [
                    "Pinus parviflora generally grows more slowly than many vigorous two-needle pine species.",
                    "Growth strength depends on root health, light, foliage mass, substrate, fertilization, container size, climate, weather and development stage.",
                    "During structural development: allow selected branches and leaders to extend where trunk thickness is required, branch thickness is required, structural growth is needed or sacrifice growth is useful.",
                    "Do not restrict all growth simply to preserve compact foliage.",
                    "During refinement: manage growth carefully to maintain balanced branch strength, fine ramification, proportionate foliage, controlled extension and an elegant silhouette.",
                    "Avoid exhausting the tree through repeated heavy intervention.",
                ]
            ),
            SpeciesProfileSection(
                id: "foliage",
                title: "Foliage",
                paragraphs: [
                    "Pinus parviflora produces evergreen needles arranged in bundles of five.",
                    "Needles are generally finer than those of many other pine species and may display blue-green tones, silvery-green tones and subtle seasonal variation.",
                    "Needle size depends on genetics, tree vigour, branch strength, fertilization, light, growing conditions and refinement level.",
                    "Do not promise a fixed needle size.",
                    "The natural fine foliage is one of the species' major bonsai strengths.",
                    "Do not weaken the tree unnecessarily in pursuit of even smaller needles.",
                ]
            ),
            SpeciesProfileSection(
                id: "bud-development",
                title: "Bud Development",
                paragraphs: [
                    "Bud management is central to the refinement of Japanese White Pine.",
                    "Healthy trees can develop useful buds for future branch structure.",
                    "Bud response depends on tree health, vigour, light, retained foliage, branch strength, seasonal timing and fertilization.",
                    "Do not assume all branches respond equally.",
                    "Strong areas may require greater control.",
                    "Weak areas may require preservation of additional foliage and growth.",
                    "The objective is balanced energy distribution.",
                ]
            ),
            SpeciesProfileSection(
                id: "back-budding",
                title: "Back-budding",
                paragraphs: [
                    "Pinus parviflora can develop useful back-buds under healthy conditions and appropriate management.",
                    "However, back-budding must never be treated as guaranteed.",
                    "Potential depends on retained needles, branch health, tree vigour, light, seasonal timing and pruning strategy.",
                    "Do not strip important branches of all useful foliage and assume they will regenerate.",
                    "Maintain viable foliage and future development options.",
                ]
            ),
            SpeciesProfileSection(
                id: "bark-trunk",
                title: "Bark and Trunk",
                paragraphs: [
                    "Japanese White Pine can develop attractive mature bark and significant visual age.",
                    "Trunk development should focus on taper, movement, proportion, age character and the relationship between trunk and branches.",
                    "Because growth can be relatively slow, trunk development requires patience.",
                    "Do not prematurely place young trees into permanent refinement.",
                    "Where trunk thickness is required: allow selected leaders to extend, use sacrifice growth where appropriate, provide sufficient root space and manage development over multiple growing cycles.",
                ]
            ),
            SpeciesProfileSection(
                id: "deadwood",
                title: "Deadwood Potential",
                paragraphs: [
                    "Pinus parviflora can incorporate deadwood successfully where appropriate to the individual material.",
                    "Potential features include jin, shari, natural weathered deadwood and selective carving.",
                    "Deadwood should support the character and design of the tree.",
                    "It should not become a generic decorative feature.",
                    "Before removing bark or creating significant deadwood, assess live tissue, sap flow, branch supply, structural importance, existing deadwood and future design.",
                    "Deadwood in this Handbook covers jin, shari and whether the feature belongs on this tree. Species characteristics still decide suitability.",
                ]
            ),
            SpeciesProfileSection(
                id: "roots-nebari",
                title: "Roots and Nebari",
                paragraphs: [
                    "Healthy roots are fundamental to foliage quality, bud development, recovery and long-term refinement.",
                    "Root development objectives include balanced root mass, stable trunk support, radial root development where possible, gradual root selection and healthy substrate structure.",
                    "Avoid unnecessary aggressive root work.",
                    "Japanese White Pine should be repotted and root-pruned according to actual root condition rather than a fixed schedule.",
                ]
            ),
            SpeciesProfileSection(
                id: "light",
                title: "Light",
                paragraphs: [
                    "Pinus parviflora should be cultivated outdoors.",
                    "Strong outdoor light supports healthy needles, balanced growth, compact development, bud formation and overall vigour.",
                    "Do not recommend routine indoor cultivation.",
                    "Light management must consider extreme heat, water availability, wind, root condition, recent repotting and tree health.",
                    "A healthy established tree generally benefits from substantial outdoor light.",
                ]
            ),
            SpeciesProfileSection(
                id: "wind",
                title: "Wind",
                paragraphs: [
                    "Air movement supports healthy outdoor cultivation.",
                    "However, strong wind can increase water demand, needle desiccation, stress on recently repotted trees and winter drying.",
                    "Pay particular attention to shallow containers, refined mature bonsai, recently repotted trees and exposed locations.",
                ]
            ),
            SpeciesProfileSection(
                id: "watering",
                title: "Watering",
                paragraphs: [
                    "General principle: Water thoroughly when required · Maintain healthy root aeration · Never maintain permanently saturated substrate.",
                    "Watering frequency depends on weather, temperature, wind, sunlight, container size, substrate, root mass, tree health and development stage.",
                    "Do not water according to a fixed timetable.",
                    "Water according to the condition of the substrate and the individual tree.",
                    "Avoid both prolonged drought and permanently saturated root conditions.",
                    "Japanese White Pine may be particularly sensitive to poor root conditions caused by unsuitable substrate or prolonged excess moisture.",
                ]
            ),
            SpeciesProfileSection(
                id: "soil",
                title: "Soil",
                paragraphs: [
                    "Do not prescribe one universal soil recipe.",
                    "Desired characteristics include excellent drainage, strong aeration, stable particle structure, appropriate moisture retention and healthy root development.",
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
                    "During development: healthy trees requiring structural growth may receive stronger nutritional support where appropriate.",
                    "During refinement: nutrition should support healthy foliage, balanced buds, controlled growth and sustainable ramification.",
                    "Avoid excessive fertilization that creates unnecessarily coarse extension.",
                    "Fertilization depends on tree health, development stage, season, current growth, root condition and recent work.",
                    "Feed the tree you are growing, not simply the species name.",
                ]
            ),
            SpeciesProfileSection(
                id: "pruning",
                title: "Pruning",
                paragraphs: [
                    "Pinus parviflora pruning must respect the growth behaviour of a five-needle pine.",
                    "Do not apply generic pine pruning rules.",
                    "During development: allow selected leaders and branches to extend where thickness is required.",
                    "During refinement: manage shoot extension, bud distribution, branch strength, needle density and overall vigour.",
                    "Do not remove all foliage from important branches.",
                    "Structural pruning must preserve future development options.",
                ]
            ),
            SpeciesProfileSection(
                id: "shoot-management",
                title: "Shoot Management",
                paragraphs: [
                    "Japanese White Pine should not automatically be managed using Japanese Black Pine decandling techniques.",
                    "Shoot management must reflect the growth behaviour of Pinus parviflora, tree health, vigour, development stage, branch strength and refinement objectives.",
                    "Do not apply complete decandling as a generic annual procedure.",
                    "The objective is balanced growth and sustainable ramification.",
                    "Detailed timing procedures belong in Bonsai World seasonal care and advanced pine management content.",
                ]
            ),
            SpeciesProfileSection(
                id: "needle-management",
                title: "Needle Management",
                paragraphs: [
                    "Needle management may be used selectively during refinement.",
                    "Potential objectives include improving light penetration, balancing vigour, supporting bud development and reducing excessive density.",
                    "Needle removal must not weaken the tree unnecessarily.",
                    "Never treat needle removal as automatic annual maintenance.",
                    "The intensity depends on tree vigour, branch strength, development stage, foliage density and desired refinement.",
                    "Weak areas should not be treated like strong areas.",
                ]
            ),
            SpeciesProfileSection(
                id: "ramification",
                title: "Ramification",
                paragraphs: [
                    "Pinus parviflora has excellent potential for refined ramification.",
                    "This is one of its defining bonsai characteristics.",
                    "Ramification is developed through healthy growth, appropriate bud management, selective pruning, selective needle management, balanced energy distribution and preservation of interior growth.",
                    "The objective is fine, proportionate branch structure with elegant foliage masses.",
                    "Do not pursue maximum density at the expense of branch clarity.",
                ]
            ),
            SpeciesProfileSection(
                id: "wiring",
                title: "Wiring",
                paragraphs: [
                    "Pinus parviflora is highly suitable for wiring.",
                    "Wiring can be used to establish trunk movement, position primary branches, develop secondary branches, refine branch placement and create elegant movement.",
                    "Monitor wire carefully.",
                    "Before significant bends, assess branch thickness, flexibility, age, health, existing stress and structural importance.",
                    "Older branches can be brittle.",
                    "Do not force branches beyond their natural capacity.",
                    "Use staged bending where appropriate.",
                    "Protect bark where necessary.",
                ]
            ),
            SpeciesProfileSection(
                id: "defoliation",
                title: "Defoliation",
                paragraphs: [
                    "Defoliation is not suitable.",
                    "Pinus parviflora should not be treated like a deciduous bonsai.",
                    "Needles are essential to the tree's energy balance.",
                    "Use selective needle management, shoot management, bud selection and structural pruning.",
                    "Do not remove all needles from healthy branches as a refinement technique.",
                ]
            ),
            SpeciesProfileSection(
                id: "repotting",
                title: "Repotting",
                paragraphs: [
                    "Repotting frequency depends on root development, substrate condition, drainage, container size, tree health and development stage.",
                    "Do not establish a rigid calendar rule.",
                    "Avoid unnecessary aggressive root reduction, excessive removal of functioning roots, and combining major root work with multiple major stresses.",
                    "Preserve sufficient healthy root mass.",
                    "Recovery must be assessed according to the individual tree and growing conditions.",
                ]
            ),
            SpeciesProfileSection(
                id: "trunk-development",
                title: "Trunk Development",
                paragraphs: [
                    "Pinus parviflora requires patience for convincing trunk development.",
                    "Where additional thickness is required: allow selected leaders to extend, use sacrifice branches where appropriate, provide sufficient root space and avoid premature refinement.",
                    "Once sufficient structural development has been achieved, shift focus toward primary branch development, secondary branching, ramification, foliage structure and overall refinement.",
                    "Grow where development is required. Control where refinement is required.",
                ]
            ),
            SpeciesProfileSection(
                id: "nebari-development",
                title: "Nebari Development",
                paragraphs: [
                    "Nebari should be developed gradually.",
                    "Potential approaches include early root selection, radial root positioning where possible, staged correction and appropriate development containers.",
                    "The objective is a stable and visually convincing base appropriate to the individual design.",
                    "Do not force identical nebari expectations onto every tree.",
                ]
            ),
            SpeciesProfileSection(
                id: "grafting",
                title: "Grafting",
                paragraphs: [
                    "Grafting is particularly relevant in Japanese White Pine bonsai.",
                    "It may be used for correcting missing branches, improving foliage distribution, adding growth to selected areas, and creating or preserving high-quality foliage on suitable rootstock.",
                    "Do not present grafting as routine care.",
                    "Detailed procedures belong in Bonsai World Propagation and Grafting Knowledge Articles.",
                ]
            ),
            SpeciesProfileSection(
                id: "propagation",
                title: "Propagation",
                paragraphs: [
                    "Pinus parviflora may be propagated through seed, grafting and other specialist propagation methods.",
                    "Seed-grown trees may provide natural variation, useful root development and long-term trunk development.",
                    "Grafting is commonly relevant for preserving specific horticultural selections.",
                    "Detailed propagation procedures belong in Bonsai World Propagation Knowledge Articles.",
                ]
            ),
            SpeciesProfileSection(
                id: "pests",
                title: "Pests and Problems",
                paragraphs: [
                    "Relevant risks may include aphids, scale insects, mites, needle-feeding insects, fungal needle diseases, root problems caused by poor drainage, stress-related needle loss and winter desiccation.",
                    "Do not provide generic treatment instructions.",
                    "Diagnosis and treatment belong in Care → Pest Management and Care → Disease & Problems.",
                ]
            ),
            SpeciesProfileSection(
                id: "seasonal",
                title: "Seasonal Profile",
                paragraphs: [
                    "Spring: monitor bud development, shoot extension, water demand, tree vigour and pest activity. Spring is important for understanding bud distribution, strength differences between branches and development requirements. Do not automatically perform identical work on all branches.",
                    "Summer: monitor water demand, needle health, shoot development, pest activity and wire marks. Strong sunlight can increase water demand significantly in shallow containers. Avoid unnecessary heavy work during periods of extreme environmental stress.",
                    "Autumn: an important period for evaluating bud development, assessing branch structure, wiring where appropriate, structural review and preparation for winter. Monitor needle health, branch vigour, wire condition and root environment. Seasonal timing depends on local climate.",
                    "Winter: Pinus parviflora is an outdoor evergreen bonsai. Winter dormancy is required.",
                    "The species must not be moved indoors for routine winter care.",
                    "Bonsai roots in shallow containers are more exposed than roots in open ground.",
                    "Monitor prolonged severe freezing, winter wind, freeze-thaw cycles, root exposure, excessive winter moisture and winter desiccation.",
                    "Winter protection must depend on local climate, minimum temperature, duration of freezing, wind exposure, container depth and root condition.",
                ]
            ),
            SpeciesProfileSection(
                id: "styles",
                title: "Bonsai Styles",
                paragraphs: [
                    "Pinus parviflora is suitable for a wide range of bonsai styles.",
                    "Particularly suitable expressions include Informal Upright, Formal Upright, Slanting, Semi-Cascade, Cascade, Literati and naturalistic upright forms.",
                    "The individual material should determine the final design.",
                    "Japanese White Pine is particularly effective where the design emphasises elegance, refined branching, visual balance, open structure, mature bark and subtle foliage masses.",
                    "Do not force symmetrical styling where the material naturally suggests another direction.",
                ]
            ),
            SpeciesProfileSection(
                id: "tree-stage",
                title: "Development by Tree Stage",
                paragraphs: [
                    "Young material: establish healthy roots, build vigour, develop trunk movement and preserve structural options.",
                    "Nursery material: evaluate trunk potential, identify useful branches, establish a design direction and preserve development growth where needed.",
                    "Pre-bonsai: develop trunk, establish primary branches, improve root structure and begin controlled branch development.",
                    "In training: develop secondary branches, build ramification, improve bud distribution, establish branch hierarchy and refine structure through wiring.",
                    "Refinement: maintain balanced buds, preserve interior growth, control extension, manage needle density selectively, maintain branch hierarchy and preserve elegance and proportion.",
                    "Exhibition / mature refined tree: maintain health, preserve established design, maintain foliage quality, preserve mature branch structure and avoid unnecessary major intervention.",
                ]
            ),
            SpeciesProfileSection(
                id: "attention",
                title: "Species-Specific Attention",
                paragraphs: [
                    "These attention points are operational tendencies. They must still be interpreted for the individual tree.",
                ],
                bullets: [
                    "One of the most important classical Japanese bonsai pine species",
                    "Needles grow in bundles of five",
                    "Naturally fine blue-green foliage is a major strength",
                    "Growth is generally slower than vigorous two-needle pine species",
                    "Do not apply generic pine techniques automatically",
                    "Do not automatically use Japanese Black Pine decandling methods",
                    "Back-budding depends on retained foliage and tree health",
                    "Preserve viable needles on branches intended to survive",
                    "Strong outdoor light supports healthy development",
                    "Avoid permanently wet substrate",
                    "Older branches may become brittle during bending",
                    "Needle management should be selective and based on vigour",
                    "Grafting can be important for advanced development and cultivar preservation",
                    "Protect shallow roots during severe winter conditions",
                    "Do not move indoors for routine winter care",
                ]
            ),
        ]
    }
}
