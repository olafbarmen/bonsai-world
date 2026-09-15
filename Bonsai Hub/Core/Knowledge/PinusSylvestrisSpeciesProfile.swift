//
//  PinusSylvestrisSpeciesProfile.swift
//  Bonsai World
//
//  Species Profile — Pinus sylvestris (Scots Pine).
//  Independent botanical species in Pinaceae. Knowledge status: Reviewed.
//

import Foundation

enum PinusSylvestrisSpeciesProfile {
    /// Identity used by Botanical Library / ``SpeciesPreviewData``.
    static let botanicalLibraryName = "Pinus sylvestris"
    /// Scientific name for Species Profile display (binomial; no botanical authority).
    static let scientificName = "Pinus sylvestris"

    static var profile: SpeciesProfile {
        SpeciesProfile(
            speciesID: BotanicalKnowledgeIDs.pinusSylvestris,
            scientificName: scientificName,
            commonNames: ["Scots Pine"],
            family: "Pinaceae",
            plantType: "Evergreen conifer",
            originSummary: "Native across large parts of Europe and northern Asia.",
            knowledgeStatus: .reviewed,
            traits: traits,
            foliageSizeLabel: "Foliage",
            foliageReductionLabel: "Needle reduction",
            summaryLine: "Evergreen · Two-needle pine · Strong trunk character · Orange upper bark · Excellent naturalistic bonsai potential · Hardy",
            attentionHighlights: [
                "One of Europe's most important native bonsai pine species",
                "Needles grow in pairs",
                "Mature upper bark develops attractive orange to reddish tones",
                "Strong naturalistic bonsai potential",
                "Do not apply generic pine techniques automatically",
                "Do not automatically use Japanese Black Pine decandling methods",
                "Good back-budding potential depends on retained foliage and tree health",
                "Preserve viable needles on branches intended to survive",
                "Strong outdoor light supports healthy development",
                "Avoid permanently wet substrate",
                "Older branches may become brittle during bending",
                "Deadwood must respect living tissue and structural function",
                "Needle management should be selective and based on vigour",
                "Protect shallow roots during severe winter conditions",
                "Do not move indoors for routine winter care",
            ],
            sections: sections,
            principleNote: """
            Pinus sylvestris is one of the most important and versatile pine species for bonsai in northern and central Europe.

            It is particularly valued for rugged trunk character, attractive mature bark, orange to reddish tones in the upper bark, naturally compact potential, good response to bonsai cultivation, strong naturalistic character, suitability for collected and cultivated material, and excellent deadwood potential.

            However, Scots Pine bonsai should not be managed through generic "pine rules".

            The timing and intensity of work must depend on tree health, development stage, current vigour, number of needle sets, bud strength, branch strength, root condition, recent work, climate and weather.

            The objective is: Healthy needles · Balanced buds · Strong root system · Controlled ramification · Convincing natural structure

            The individual tree must always be assessed before major work.
            """,
            sourcesNote: """
            Profile content is synthesised from recognised botanical, horticultural and bonsai authorities into Bonsai World editorial language.

            Botanical taxonomy and distribution draw on recognised sources such as Royal Botanic Gardens, Kew and other botanical databases for accepted scientific name, family and native range.

            Horticultural and forestry context may draw on recognised European botanical, forestry and horticultural institutions.

            Bonsai-specific cultivation and refinement knowledge draws on established bonsai references and recognised professionals for Pinus sylvestris practice, kept distinct from techniques belonging primarily to other pine species.

            Verified botanical information, general horticultural cultivation and bonsai-specific practice are kept distinct. Do not copy source wording.
            """
        )
    }

    private static let traits = SpeciesProfileTraits(
        deciduous: false,
        growthStrength: "Moderate",
        growthSpeed: "Moderate",
        leafSize: "Evergreen · Needles in pairs · Good needle reduction potential under bonsai cultivation",
        foliageReduction: "Good potential under bonsai cultivation — vigour dependent",
        ramificationPotential: "Good to Excellent",
        backBudding: "Good when healthy and managed correctly",
        rootDevelopment: "Good",
        nebariPotential: "Good development potential",
        trunkDevelopment: "Moderate",
        barkDevelopment: "Orange to reddish upper bark with maturity",
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
                    "Pinus sylvestris is an independent botanical species in Pinaceae.",
                    "Primary Bonsai World display identity: Pinus sylvestris · Scots Pine.",
                    "Norwegian name: Furu. This is language support and does not replace the preferred English common name Scots Pine.",
                    "Family: Pinaceae. Plant type: evergreen conifer.",
                    "Native range: large parts of Europe and northern Asia.",
                    "Pinus sylvestris is one of the most important pine species used for bonsai in Europe.",
                    "Maintain a clear distinction between Pinus sylvestris, Pinus parviflora, Pinus mugo, Pinus thunbergii and other Pinus species.",
                    "Do not merge species because they share similar pine cultivation techniques. Different pine species have different growth patterns and management requirements.",
                    "Bonsai World hierarchy: Species → cultivar / horticultural selection → Individual Tree.",
                ]
            ),
            SpeciesProfileSection(
                id: "overview",
                title: "Species Overview",
                paragraphs: [
                    "Pinus sylvestris is a widespread Eurasian pine and one of the most important native bonsai species in Europe.",
                    "It is particularly suitable for bonsai because mature material can develop powerful trunks, natural movement, rugged bark, compact foliage, convincing deadwood and strong visual age.",
                    "Scots Pine is especially suited to bonsai designs that retain a natural relationship with the species.",
                    "It is often most convincing when the design respects natural trunk movement, irregular branch placement, asymmetry, open spaces and age character.",
                    "Do not force every Pinus sylvestris into a highly symmetrical or heavily manicured design.",
                    "Important development principle: Grow where development is required. Control where refinement is required.",
                ],
                bullets: [
                    "Evergreen conifer",
                    "Needles arranged in pairs",
                    "Strong naturalistic bonsai potential",
                    "Attractive orange to reddish upper bark with maturity",
                    "Good ramification potential",
                    "Good back-budding potential under appropriate conditions",
                    "Excellent wiring suitability",
                    "Excellent deadwood potential",
                    "Hardy temperate species",
                    "Requires strong outdoor light",
                    "Requires winter dormancy",
                    "Requires a well-drained root environment",
                ]
            ),
            SpeciesProfileSection(
                id: "natural-growth",
                title: "Natural Growth and Vigour",
                paragraphs: [
                    "Pinus sylvestris generally develops moderate seasonal growth.",
                    "Vigour depends strongly on root health, light, needle mass, substrate, fertilization, container size, climate, weather and development stage.",
                    "During structural development: allow selected branches and leaders to extend where trunk thickness is required, branch thickness is required, sacrifice growth is useful or additional vigour is needed.",
                    "Do not continuously restrict all growth.",
                    "During refinement: manage shoot extension, bud distribution, branch strength, needle density and overall energy balance.",
                    "Do not attempt to maintain maximum compactness at the expense of long-term vigour.",
                ]
            ),
            SpeciesProfileSection(
                id: "foliage",
                title: "Foliage",
                paragraphs: [
                    "Pinus sylvestris has evergreen needles arranged in pairs.",
                    "Needle length varies according to genetics, tree vigour, branch strength, fertilization, light, growing conditions and refinement level.",
                    "Under appropriate bonsai cultivation, needle size can become more proportionate to the design.",
                    "Do not promise a fixed needle size.",
                    "Needle management must preserve sufficient foliage to support root health, bud development, branch vigour and overall recovery.",
                    "The objective is proportionate foliage — not the smallest possible needles at any cost.",
                ]
            ),
            SpeciesProfileSection(
                id: "bud-development",
                title: "Bud Development",
                paragraphs: [
                    "Bud management is central to refined Scots Pine bonsai.",
                    "Healthy trees can develop useful buds for future branch structure.",
                    "Bud response depends on vigour, branch strength, light, needle retention, pruning timing, fertilization and overall health.",
                    "Avoid assuming that every branch will respond equally.",
                    "Strong areas may require greater control than weaker areas.",
                    "The objective is balanced energy distribution across the tree.",
                ]
            ),
            SpeciesProfileSection(
                id: "back-budding",
                title: "Back-budding",
                paragraphs: [
                    "Pinus sylvestris can develop useful back-buds when healthy and managed correctly.",
                    "However, back-budding must never be treated as guaranteed.",
                    "Success depends on healthy foliage, retained needles, sufficient light, branch vigour, correct timing and overall tree health.",
                    "Do not strip a branch of all useful foliage and assume that it will automatically regenerate.",
                    "Maintain options for future development.",
                ]
            ),
            SpeciesProfileSection(
                id: "bark-trunk",
                title: "Bark and Trunk",
                paragraphs: [
                    "Mature Pinus sylvestris develops one of its most recognisable visual characteristics: orange to reddish bark on upper trunk and branches.",
                    "The bark can become an important component of the mature bonsai design.",
                    "Trunk development should focus on taper, movement, proportion, age character and the relationship between live trunk and deadwood.",
                    "Young material may require substantial development before refinement.",
                    "Do not prematurely restrict useful extension growth.",
                ]
            ),
            SpeciesProfileSection(
                id: "deadwood",
                title: "Deadwood Potential",
                paragraphs: [
                    "Pinus sylvestris is highly suitable for naturalistic deadwood.",
                    "Potential features include jin, shari, natural deadwood, weathered trunk features and selective carving.",
                    "Deadwood should support the story and structure of the individual tree.",
                    "It must not become decoration added simply because pine bonsai can have deadwood.",
                    "Before removing bark or creating a shari, assess live tissue, sap flow, branch supply, structural importance, existing deadwood and future design.",
                    "Deadwood in this Handbook covers jin, shari and whether the feature belongs on this tree. Species characteristics still decide suitability.",
                ]
            ),
            SpeciesProfileSection(
                id: "roots-nebari",
                title: "Roots and Nebari",
                paragraphs: [
                    "Healthy roots are fundamental to vigour, needle quality, bud development, recovery and refinement.",
                    "Root development objectives include balanced root mass, radial root development where possible, stable trunk support, gradual root selection and long-term substrate health.",
                    "Do not promise exceptional nebari automatically.",
                    "Good nebari can be developed through early root selection, appropriate growing space, staged repotting and long-term cultivation.",
                    "Avoid unnecessary aggressive root reduction.",
                ]
            ),
            SpeciesProfileSection(
                id: "light",
                title: "Light",
                paragraphs: [
                    "Pinus sylvestris should be cultivated outdoors in strong light.",
                    "Strong light supports healthy needles, bud development, compact growth, balanced vigour and back-budding potential.",
                    "Do not recommend routine indoor cultivation.",
                    "Light management must still consider extreme heat, water availability, wind, recent repotting, root condition and tree health.",
                    "A healthy established tree generally benefits from substantial outdoor sun exposure.",
                ]
            ),
            SpeciesProfileSection(
                id: "wind",
                title: "Wind",
                paragraphs: [
                    "Air movement is generally compatible with healthy outdoor pine cultivation.",
                    "However, strong wind can increase water demand, needle desiccation, stress on recently repotted trees and winter drying.",
                    "Pay particular attention to shallow containers, recently repotted trees, exposed locations and severe winter conditions.",
                ]
            ),
            SpeciesProfileSection(
                id: "watering",
                title: "Watering",
                paragraphs: [
                    "General principle: Water thoroughly when required · Allow appropriate aeration · Never maintain permanently saturated substrate.",
                    "Watering frequency depends on weather, temperature, wind, sunlight, container size, substrate, root mass, tree health and development stage.",
                    "Do not water according to a fixed timetable.",
                    "Water according to the condition of the substrate and the individual tree.",
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
                    "Fertilization must support the current development objective.",
                    "During development: healthy trees requiring stronger trunk or branch development may receive greater nutritional support where appropriate.",
                    "During refinement: nutrition should support healthy needles, controlled growth, balanced buds and sustainable ramification.",
                    "Avoid applying fertilization rules mechanically.",
                    "Fertilization depends on tree health, development stage, season, current growth, root condition and recent work.",
                    "Feed the tree you are growing, not simply the species name.",
                ]
            ),
            SpeciesProfileSection(
                id: "pruning",
                title: "Pruning",
                paragraphs: [
                    "Pinus sylvestris pruning must respect the species' growth behaviour.",
                    "Pruning should not be approached in the same way as deciduous pruning.",
                    "During development: allow selected leaders and branches to extend where thickness is required.",
                    "During refinement: manage branch structure, bud distribution, extension growth, needle mass and overall vigour.",
                    "Avoid removing all foliage from important branches.",
                    "Do not assume a branch will reliably regenerate from bare wood.",
                    "Structural pruning must preserve future development options.",
                ]
            ),
            SpeciesProfileSection(
                id: "candle-management",
                title: "Candle Management",
                paragraphs: [
                    "Scots Pine should not automatically be managed using the same candle techniques used for Japanese Black Pine.",
                    "The timing and method of shoot management must reflect Pinus sylvestris growth behaviour and the individual tree's vigour.",
                    "Do not automatically apply complete decandling techniques simply because the tree is a pine.",
                    "Manage shoots according to tree health, development stage, bud strength, branch strength and desired level of refinement.",
                    "The objective is balanced and sustainable ramification.",
                    "Detailed timing procedures belong in Bonsai World seasonal care and advanced pine management content.",
                ]
            ),
            SpeciesProfileSection(
                id: "needle-management",
                title: "Needle Management",
                paragraphs: [
                    "Needle management may be used as part of refinement.",
                    "Potential objectives include improving light penetration, balancing branch vigour, improving bud development and reducing excessive density.",
                    "Needle removal must not weaken the tree unnecessarily.",
                    "Never treat needle removal as automatic annual maintenance.",
                    "The intensity depends on tree vigour, branch strength, development stage, needle density and desired refinement.",
                    "Weak areas should not be treated like strong areas.",
                ]
            ),
            SpeciesProfileSection(
                id: "ramification",
                title: "Ramification",
                paragraphs: [
                    "Pinus sylvestris has strong potential for refined ramification.",
                    "Ramification is developed through healthy growth, appropriate bud management, selective pruning, needle management where appropriate, balanced energy distribution and preservation of interior growth.",
                    "The objective is a convincing branch structure with proportionate foliage masses.",
                    "Do not pursue maximum density at the expense of branch clarity.",
                ]
            ),
            SpeciesProfileSection(
                id: "wiring",
                title: "Wiring",
                paragraphs: [
                    "Pinus sylvestris is highly suitable for wiring.",
                    "Wiring can be used to establish trunk movement, position primary branches, develop secondary structure, refine branch placement and create naturalistic movement.",
                    "Monitor wire carefully.",
                    "Before significant bends, assess branch thickness, flexibility, age, health, existing stress and structural importance.",
                    "Older pine branches can be brittle.",
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
                    "Pinus sylvestris should not be treated like a deciduous bonsai.",
                    "Needles are essential to the tree's energy balance.",
                    "Use selective needle management, shoot management, bud selection and branch pruning.",
                    "Do not remove all needles from healthy branches as a refinement technique.",
                ]
            ),
            SpeciesProfileSection(
                id: "repotting",
                title: "Repotting",
                paragraphs: [
                    "Repotting frequency depends on root development, substrate condition, drainage, container size, tree health and development stage.",
                    "Do not establish a rigid calendar rule.",
                    "Pines can be sensitive to excessive root disturbance.",
                    "Avoid unnecessary aggressive root removal, removing all established root mass, and combining major root work with multiple major stresses.",
                    "Preserve sufficient healthy roots.",
                    "Recovery must be assessed according to the individual tree and growing conditions.",
                ]
            ),
            SpeciesProfileSection(
                id: "trunk-development",
                title: "Trunk Development",
                paragraphs: [
                    "Pinus sylvestris requires patience for convincing trunk development.",
                    "Where trunk thickness is still required: allow selected leaders to extend, use sacrifice branches where appropriate, provide sufficient root space and avoid premature refinement.",
                    "Once the required trunk structure is achieved, shift focus toward primary branch development, secondary branching, ramification, bark character and overall refinement.",
                    "Grow where development is required. Control where refinement is required.",
                ]
            ),
            SpeciesProfileSection(
                id: "nebari-development",
                title: "Nebari Development",
                paragraphs: [
                    "Nebari should be developed gradually.",
                    "Potential approaches include early root selection, radial root positioning, staged correction and appropriate development containers.",
                    "The objective is a stable and convincing base appropriate to the individual design.",
                    "Do not force identical nebari expectations onto all naturalistic Scots Pine material.",
                    "Some rugged collected material may have unconventional but visually convincing root structures.",
                ]
            ),
            SpeciesProfileSection(
                id: "grafting",
                title: "Grafting",
                paragraphs: [
                    "Grafting may be relevant in advanced development where a branch is missing, foliage distribution requires correction or a structural area requires new growth.",
                    "Do not present grafting as routine care.",
                    "Detailed procedures belong in Bonsai World Propagation and Grafting Knowledge Articles.",
                ]
            ),
            SpeciesProfileSection(
                id: "propagation",
                title: "Propagation",
                paragraphs: [
                    "Pinus sylvestris may be propagated through seed, grafting where appropriate and other specialist propagation methods.",
                    "Seed-grown material is particularly useful for natural root development, long-term trunk development and genetic variation.",
                    "Detailed propagation procedures belong in Bonsai World Propagation Knowledge Articles.",
                ]
            ),
            SpeciesProfileSection(
                id: "pests",
                title: "Pests and Problems",
                paragraphs: [
                    "Relevant risks may include aphids, scale insects, mites, caterpillars and other needle-feeding insects, fungal needle diseases, root problems caused by poor drainage, stress-related needle loss and winter desiccation.",
                    "Do not provide generic treatment instructions.",
                    "Diagnosis and treatment belong in Care → Pest Management and Care → Disease & Problems.",
                ]
            ),
            SpeciesProfileSection(
                id: "seasonal",
                title: "Seasonal Profile",
                paragraphs: [
                    "Spring: monitor bud development, shoot extension, water demand, tree vigour and pest activity. Spring is important for understanding the distribution of vigour. Do not automatically perform identical work on all branches.",
                    "Summer: monitor water demand, needle health, shoot development, pest activity and wire marks. Strong sunlight may increase water demand significantly in shallow containers. Avoid unnecessary heavy work during periods of extreme environmental stress.",
                    "Autumn: an important period for evaluating bud development, assessing branch structure, wiring, structural work where appropriate and preparing for winter. Monitor needle health, branch vigour, wire condition and root environment. Seasonal timing depends on local climate.",
                    "Winter: Pinus sylvestris is an outdoor evergreen bonsai. Winter dormancy is required.",
                    "The species is generally hardy, but bonsai roots in shallow containers are more exposed than roots in open ground.",
                    "Monitor prolonged severe freezing, winter wind, freeze-thaw cycles, root exposure, excessive winter moisture and winter desiccation.",
                    "Do not move the tree indoors for routine winter care.",
                    "Winter protection must depend on local climate, minimum temperature, duration of freezing, wind exposure, container depth and root condition.",
                ]
            ),
            SpeciesProfileSection(
                id: "styles",
                title: "Bonsai Styles",
                paragraphs: [
                    "Pinus sylvestris is suitable for a wide range of styles.",
                    "Particularly suitable expressions include Informal Upright, Slanting, Literati, Semi-Cascade, Cascade, naturalistic upright forms, deadwood-based designs and collected mountain material designs.",
                    "The individual material should determine the final design.",
                    "Pinus sylvestris is often particularly convincing when the design retains asymmetry, natural movement, irregularity, open spaces and visual age.",
                    "Do not force symmetrical styling where the material naturally suggests otherwise.",
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
                    "Refinement: maintain balanced buds, preserve interior growth, control extension, manage needle density where appropriate and maintain branch hierarchy.",
                    "Exhibition / mature refined tree: maintain health, preserve established design, maintain needle quality, preserve bark character, maintain deadwood where present and avoid unnecessary major intervention.",
                ]
            ),
            SpeciesProfileSection(
                id: "attention",
                title: "Species-Specific Attention",
                paragraphs: [
                    "These attention points are operational tendencies. They must still be interpreted for the individual tree.",
                ],
                bullets: [
                    "One of Europe's most important native bonsai pine species",
                    "Needles grow in pairs",
                    "Mature upper bark develops attractive orange to reddish tones",
                    "Strong naturalistic bonsai potential",
                    "Do not apply generic pine techniques automatically",
                    "Do not automatically use Japanese Black Pine decandling methods",
                    "Good back-budding potential depends on retained foliage and tree health",
                    "Preserve viable needles on branches intended to survive",
                    "Strong outdoor light supports healthy development",
                    "Avoid permanently wet substrate",
                    "Older branches may become brittle during bending",
                    "Deadwood must respect living tissue and structural function",
                    "Needle management should be selective and based on vigour",
                    "Protect shallow roots during severe winter conditions",
                    "Do not move indoors for routine winter care",
                ]
            ),
        ]
    }
}
