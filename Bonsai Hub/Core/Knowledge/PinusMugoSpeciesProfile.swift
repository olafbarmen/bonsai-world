//
//  PinusMugoSpeciesProfile.swift
//  Bonsai World
//
//  Species Profile — Pinus mugo (Mountain Pine).
//  Independent botanical species in Pinaceae. Knowledge status: Reviewed.
//

import Foundation

enum PinusMugoSpeciesProfile {
    /// Identity used by Botanical Library / ``SpeciesPreviewData``.
    static let botanicalLibraryName = "Pinus mugo"
    /// Scientific name for Species Profile display (binomial; no botanical authority).
    static let scientificName = "Pinus mugo"

    static var profile: SpeciesProfile {
        SpeciesProfile(
            speciesID: BotanicalKnowledgeIDs.pinusMugo,
            scientificName: scientificName,
            commonNames: ["Mountain Pine"],
            family: "Pinaceae",
            plantType: "Evergreen conifer",
            originSummary: "Mountains and upland regions of central and southern Europe.",
            knowledgeStatus: .reviewed,
            traits: traits,
            foliageSizeLabel: "Foliage",
            foliageReductionLabel: "Needle reduction",
            summaryLine: "Evergreen · Two-needle pine · Naturally compact growth · Strong back-budding potential · Excellent rugged bonsai character · Hardy",
            attentionHighlights: [
                "Naturally variable growth habit",
                "Needles grow in pairs",
                "Naturally compact growth is a major bonsai advantage",
                "Excellent ramification potential",
                "Strong back-budding potential depends on retained foliage and tree health",
                "Do not apply generic pine techniques automatically",
                "Do not automatically use Japanese Black Pine decandling methods",
                "Preserve viable needles on branches intended to survive",
                "Strong outdoor light supports healthy development",
                "Avoid permanently wet substrate",
                "Older branches may become brittle during bending",
                "Deadwood must respect living tissue and structural function",
                "Needle management should be selective and based on vigour",
                "Natural mountain character should be respected in styling",
                "Protect shallow roots during severe winter conditions",
                "Do not move indoors for routine winter care",
            ],
            sections: sections,
            principleNote: """
            Pinus mugo is one of the most useful pine species for bonsai where compact growth, rugged character and strong ramification are desired.

            It is particularly valued for naturally compact growth, strong branch development, good back-budding potential, rugged mountain character, suitability for naturalistic designs, excellent potential for collected and developed material, and strong deadwood potential.

            However, Pinus mugo must not be managed through generic "pine rules".

            The intensity and timing of work depend on tree health, current vigour, development stage, branch strength, bud strength, retained foliage, root condition, recent work, climate and weather.

            The objective is: Healthy foliage · Strong roots · Balanced buds · Fine ramification · Convincing mountain character

            The individual tree must always be assessed before major work.
            """,
            sourcesNote: """
            Profile content is synthesised from recognised botanical, horticultural and bonsai authorities into Bonsai World editorial language.

            Botanical taxonomy and distribution draw on recognised sources such as Royal Botanic Gardens, Kew and other botanical databases for accepted scientific name, family and native range.

            Horticultural and alpine context may draw on European forestry and botanical institutions and recognised alpine and arboretum collections.

            Bonsai-specific cultivation and refinement knowledge draws on established bonsai references and recognised professionals for Pinus mugo practice, kept distinct from techniques belonging primarily to other pine species.

            Verified botanical information, general horticultural cultivation and bonsai-specific practice are kept distinct. Do not copy source wording.
            """
        )
    }

    private static let traits = SpeciesProfileTraits(
        deciduous: false,
        growthStrength: "Moderate",
        growthSpeed: "Slow to Moderate",
        leafSize: "Evergreen · Needles in pairs · Naturally compact growth potential",
        foliageReduction: "Proportionate foliage — preserve vigour; do not force maximum compactness",
        ramificationPotential: "Excellent",
        backBudding: "Very Good under healthy conditions and appropriate management",
        rootDevelopment: "Good",
        nebariPotential: "Good development potential",
        trunkDevelopment: "Slow to Moderate",
        barkDevelopment: "Rugged character and visual age with development",
        wiring: "Excellent suitability",
        defoliation: "Not suitable as a routine technique",
        airLayering: "Where appropriate for the individual material",
        threadGrafting: "May be relevant for structural correction",
        rootGrafting: "Where appropriate",
        beginnerSuitability: "Moderate",
        bonsaiSuitability: "Excellent",
        difficulty: "Intermediate",
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
                    "Pinus mugo is an independent botanical species in Pinaceae.",
                    "Primary Bonsai World display identity: Pinus mugo · Mountain Pine.",
                    "Family: Pinaceae. Plant type: evergreen conifer.",
                    "Native range: mountains and upland regions of central and southern Europe.",
                    "Pinus mugo is a distinct Eurasian mountain pine species with a naturally variable growth habit.",
                    "Maintain a clear distinction between Pinus mugo, Pinus sylvestris, Pinus parviflora, Pinus thunbergii and other Pinus species.",
                    "Do not merge Pinus mugo with dwarf pine cultivars or treat all commercially sold \"mugo pines\" as identical bonsai material.",
                    "Cultivars may have different growth habits and horticultural characteristics. Do not use cultivar names as part of the primary species identity.",
                    "Bonsai World hierarchy: Species → cultivar / horticultural selection → Individual Tree.",
                ]
            ),
            SpeciesProfileSection(
                id: "overview",
                title: "Species Overview",
                paragraphs: [
                    "Pinus mugo is a mountain pine native to European mountainous regions.",
                    "Its natural variation makes it particularly interesting for bonsai.",
                    "Depending on origin and growing conditions, material may display upright growth, spreading growth, low and compact growth, rugged trunks, irregular movement and dense branching.",
                    "This variation should be respected.",
                    "Do not force every Mountain Pine into the same silhouette.",
                    "The best bonsai design should respond to trunk character, natural movement, branch placement, existing age, root base and material origin.",
                    "Important development principle: Grow where development is required. Control where refinement is required.",
                ],
                bullets: [
                    "Evergreen conifer",
                    "Needles arranged in pairs",
                    "Naturally compact growth potential",
                    "Strong ramification potential",
                    "Very good back-budding potential under suitable conditions",
                    "Rugged mountain character",
                    "Excellent naturalistic bonsai potential",
                    "Excellent wiring suitability",
                    "Excellent deadwood potential",
                    "Hardy temperate species",
                    "Requires outdoor cultivation",
                    "Requires winter dormancy",
                ]
            ),
            SpeciesProfileSection(
                id: "natural-growth",
                title: "Natural Growth and Vigour",
                paragraphs: [
                    "Pinus mugo generally develops moderate growth.",
                    "Growth strength depends on root health, light, foliage mass, substrate, fertilization, container size, climate, weather and development stage.",
                    "During structural development: allow selected branches and leaders to extend where trunk thickness is required, branch thickness is required, sacrifice growth is useful or additional vigour is needed.",
                    "Do not continually restrict all new growth.",
                    "During refinement: manage shoot extension, bud distribution, branch strength, foliage density and overall energy balance.",
                    "Naturally compact growth is an advantage, but excessive intervention can still weaken the tree.",
                ]
            ),
            SpeciesProfileSection(
                id: "foliage",
                title: "Foliage",
                paragraphs: [
                    "Pinus mugo has evergreen needles arranged in pairs.",
                    "Needle length varies depending on genetics, tree vigour, branch strength, fertilization, light, cultivar or population characteristics, growing conditions and refinement level.",
                    "Do not promise a specific needle size.",
                    "The objective is proportionate foliage that supports branch development, bud formation, ramification and long-term health.",
                    "Do not weaken the tree in pursuit of maximum compactness.",
                ]
            ),
            SpeciesProfileSection(
                id: "bud-development",
                title: "Bud Development",
                paragraphs: [
                    "Bud development is central to refined Pinus mugo bonsai.",
                    "Healthy trees can develop useful buds for future branch structure.",
                    "Bud response depends on vigour, branch strength, retained foliage, light, pruning strategy and seasonal timing.",
                    "Do not assume all areas of the tree respond equally.",
                    "Strong areas may require more control.",
                    "Weak areas may require additional foliage and growth.",
                    "The objective is balanced energy distribution.",
                ]
            ),
            SpeciesProfileSection(
                id: "back-budding",
                title: "Back-budding",
                paragraphs: [
                    "Pinus mugo is valued for its potential to produce useful interior buds under healthy conditions and appropriate management.",
                    "However, back-budding must never be treated as guaranteed.",
                    "Success depends on tree health, retained needles, branch vigour, sufficient light, appropriate timing and balanced pruning.",
                    "Do not remove all viable foliage from important branches.",
                    "Preserve interior growth whenever it contributes to future design options.",
                ]
            ),
            SpeciesProfileSection(
                id: "bark-trunk",
                title: "Bark and Trunk",
                paragraphs: [
                    "Pinus mugo can develop strong and rugged trunk character.",
                    "Trunk development should focus on taper, movement, visual age, proportion and the relationship between trunk and branch structure.",
                    "Young material may require significant development.",
                    "Do not prematurely restrict useful sacrifice growth.",
                    "Mountain Pine often benefits from designs that preserve irregularity, asymmetry, natural movement and ruggedness.",
                ]
            ),
            SpeciesProfileSection(
                id: "deadwood",
                title: "Deadwood Potential",
                paragraphs: [
                    "Pinus mugo is highly suitable for naturalistic deadwood.",
                    "Potential features include jin, shari, natural deadwood, weathered trunk features and selective carving.",
                    "Deadwood should support the individual tree's structure and story.",
                    "Do not create deadwood simply because the species is suitable for it.",
                    "Before creating significant deadwood, assess live tissue, sap flow, branch supply, structural importance, existing features and future design.",
                    "Deadwood in this Handbook covers jin, shari and whether the feature belongs on this tree. Species characteristics still decide suitability.",
                ]
            ),
            SpeciesProfileSection(
                id: "roots-nebari",
                title: "Roots and Nebari",
                paragraphs: [
                    "Healthy roots are fundamental to foliage quality, bud development, recovery and refinement.",
                    "Root development objectives include balanced root mass, stable trunk support, radial root development where possible, gradual root selection and healthy substrate structure.",
                    "Do not remove functioning roots aggressively without a clear development reason.",
                    "Nebari expectations should reflect the individual material.",
                    "Natural mountain material may have irregular but visually convincing root structures.",
                ]
            ),
            SpeciesProfileSection(
                id: "light",
                title: "Light",
                paragraphs: [
                    "Pinus mugo should be cultivated outdoors in strong light.",
                    "Strong outdoor light supports healthy needles, compact growth, bud development, balanced vigour and ramification.",
                    "Do not recommend routine indoor cultivation.",
                    "Light management must consider extreme heat, water availability, wind, recent repotting, root condition and tree health.",
                ]
            ),
            SpeciesProfileSection(
                id: "wind",
                title: "Wind",
                paragraphs: [
                    "Air movement is generally beneficial for healthy outdoor cultivation.",
                    "However, excessive wind can increase water loss, needle desiccation, stress on recently repotted trees and winter drying.",
                    "Pay particular attention to shallow containers, exposed locations, recently repotted trees and severe winter conditions.",
                ]
            ),
            SpeciesProfileSection(
                id: "watering",
                title: "Watering",
                paragraphs: [
                    "General principle: Water thoroughly when required · Maintain healthy root aeration · Never maintain permanently saturated substrate.",
                    "Watering frequency depends on weather, temperature, wind, sunlight, container size, substrate, root mass, tree health and development stage.",
                    "Do not water according to a fixed timetable.",
                    "Water according to the substrate and individual tree.",
                    "Avoid both prolonged drought and permanently saturated root conditions.",
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
                    "During development: healthy trees requiring stronger structural growth may receive greater nutritional support where appropriate.",
                    "During refinement: nutrition should support healthy foliage, balanced buds, controlled growth and sustainable ramification.",
                    "Avoid excessive fertilization that creates unnecessarily coarse growth.",
                    "Fertilization depends on tree health, development stage, season, current growth, root condition and recent work.",
                    "Feed the tree you are growing, not simply the species name.",
                ]
            ),
            SpeciesProfileSection(
                id: "pruning",
                title: "Pruning",
                paragraphs: [
                    "Pinus mugo pruning must respect the species' growth behaviour.",
                    "Do not approach it using generic deciduous pruning methods.",
                    "During development: allow selected leaders and branches to extend where thickness is required.",
                    "During refinement: manage branch structure, bud distribution, extension growth, foliage density and overall vigour.",
                    "Do not remove all viable foliage from important branches.",
                    "Preserve interior growth where useful.",
                    "Structural pruning must preserve future development options.",
                ]
            ),
            SpeciesProfileSection(
                id: "shoot-management",
                title: "Shoot Management",
                paragraphs: [
                    "Shoot management should be based on tree health, current vigour, development stage, branch strength, bud distribution and refinement objectives.",
                    "Do not automatically apply Japanese Black Pine techniques simply because Pinus mugo is a two-needle pine.",
                    "Complete decandling should not be presented as generic annual maintenance.",
                    "The objective is balanced growth, healthy buds and sustainable ramification.",
                    "Detailed timing procedures belong in Bonsai World seasonal care and advanced pine management content.",
                ]
            ),
            SpeciesProfileSection(
                id: "needle-management",
                title: "Needle Management",
                paragraphs: [
                    "Needle management may be used selectively during refinement.",
                    "Potential objectives include improving light penetration, balancing vigour, supporting interior buds and reducing excessive density.",
                    "Needle removal must not weaken the tree unnecessarily.",
                    "Never treat needle removal as automatic annual maintenance.",
                    "The intensity depends on tree vigour, branch strength, development stage, foliage density and refinement objectives.",
                    "Weak areas should not be treated like strong areas.",
                ]
            ),
            SpeciesProfileSection(
                id: "ramification",
                title: "Ramification",
                paragraphs: [
                    "Pinus mugo has excellent potential for dense and refined ramification.",
                    "This is one of the species' major strengths.",
                    "Ramification is developed through healthy growth, bud management, selective pruning, selective needle management, balanced energy distribution and preservation of useful interior growth.",
                    "The objective is fine, proportionate branch structure with clear visual hierarchy.",
                    "Do not pursue maximum density at the expense of branch clarity.",
                ]
            ),
            SpeciesProfileSection(
                id: "wiring",
                title: "Wiring",
                paragraphs: [
                    "Pinus mugo is highly suitable for wiring.",
                    "Wiring can be used to establish trunk movement, position primary branches, develop secondary structure, refine branch placement and create rugged natural movement.",
                    "Monitor wire carefully.",
                    "Before significant bends, assess branch thickness, flexibility, age, health, existing stress and structural importance.",
                    "Older branches may be brittle.",
                    "Do not force branches beyond their natural capacity.",
                    "Use staged bending where appropriate.",
                    "Protect bark where necessary.",
                ]
            ),
            SpeciesProfileSection(
                id: "defoliation",
                title: "Defoliation",
                paragraphs: [
                    "Defoliation is not suitable as a routine technique.",
                    "Pinus mugo should not be treated like a deciduous bonsai.",
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
                    "Pinus mugo generally requires patience for major trunk development.",
                    "Where additional thickness is required: allow selected leaders to extend, use sacrifice branches where appropriate, provide sufficient root space and avoid premature refinement.",
                    "Once sufficient structural development has been achieved, shift focus toward primary branch development, secondary branching, ramification, bark character and overall refinement.",
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
                    "Natural mountain material may have irregular roots that should not automatically be corrected if they contribute positively to the character of the tree.",
                ]
            ),
            SpeciesProfileSection(
                id: "grafting",
                title: "Grafting",
                paragraphs: [
                    "Grafting may be relevant in advanced development where an important branch is missing, foliage distribution requires correction or a structural area requires new growth.",
                    "Do not present grafting as routine care.",
                    "Detailed procedures belong in Bonsai World Propagation and Grafting Knowledge Articles.",
                ]
            ),
            SpeciesProfileSection(
                id: "propagation",
                title: "Propagation",
                paragraphs: [
                    "Pinus mugo may be propagated through seed, grafting where appropriate and other specialist propagation methods.",
                    "Seed-grown material can provide natural variation, useful root development and long-term trunk development.",
                    "Cultivars are generally maintained through appropriate vegetative propagation methods.",
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
                    "Spring: monitor bud development, shoot extension, water demand, tree vigour and pest activity. Spring is important for understanding the distribution of vigour. Do not automatically perform identical work on all branches.",
                    "Summer: monitor water demand, needle health, shoot development, pest activity and wire marks. Strong sun and shallow containers can increase water demand significantly. Avoid unnecessary heavy work during periods of extreme environmental stress.",
                    "Autumn: an important period for evaluating bud development, assessing branch structure, wiring where appropriate, structural review and preparation for winter. Monitor needle health, branch vigour, wire condition and root environment. Seasonal timing depends on local climate.",
                    "Winter: Pinus mugo is an outdoor evergreen bonsai. Winter dormancy is required.",
                    "The species is generally hardy, but roots in shallow bonsai containers are more exposed than roots in open ground.",
                    "Monitor prolonged severe freezing, winter wind, freeze-thaw cycles, root exposure, excessive winter moisture and winter desiccation.",
                    "Do not move the tree indoors for routine winter care.",
                    "Winter protection must depend on local climate, minimum temperature, duration of freezing, wind exposure, container depth and root condition.",
                ]
            ),
            SpeciesProfileSection(
                id: "styles",
                title: "Bonsai Styles",
                paragraphs: [
                    "Pinus mugo is suitable for a wide range of bonsai styles.",
                    "Particularly suitable expressions include Informal Upright, Slanting, Semi-Cascade, Cascade, Literati, naturalistic upright forms, rugged mountain forms and deadwood-based designs.",
                    "The individual material should determine the final design.",
                    "Pinus mugo is often particularly convincing when the design preserves natural asymmetry, rugged movement, irregular branch placement, open spaces and visual age.",
                    "Do not force overly symmetrical styling where the material naturally suggests otherwise.",
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
                    "Refinement: maintain balanced buds, preserve interior growth, control extension, manage needle density selectively, maintain branch hierarchy and preserve natural character.",
                    "Exhibition / mature refined tree: maintain health, preserve established design, maintain foliage quality, preserve mature branch structure, maintain deadwood where present and avoid unnecessary major intervention.",
                ]
            ),
            SpeciesProfileSection(
                id: "attention",
                title: "Species-Specific Attention",
                paragraphs: [
                    "These attention points are operational tendencies. They must still be interpreted for the individual tree.",
                ],
                bullets: [
                    "Naturally variable growth habit",
                    "Needles grow in pairs",
                    "Naturally compact growth is a major bonsai advantage",
                    "Excellent ramification potential",
                    "Strong back-budding potential depends on retained foliage and tree health",
                    "Do not apply generic pine techniques automatically",
                    "Do not automatically use Japanese Black Pine decandling methods",
                    "Preserve viable needles on branches intended to survive",
                    "Strong outdoor light supports healthy development",
                    "Avoid permanently wet substrate",
                    "Older branches may become brittle during bending",
                    "Deadwood must respect living tissue and structural function",
                    "Needle management should be selective and based on vigour",
                    "Natural mountain character should be respected in styling",
                    "Protect shallow roots during severe winter conditions",
                    "Do not move indoors for routine winter care",
                ]
            ),
        ]
    }
}
