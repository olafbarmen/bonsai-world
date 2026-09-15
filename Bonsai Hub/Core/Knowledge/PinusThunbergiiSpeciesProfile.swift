//
//  PinusThunbergiiSpeciesProfile.swift
//  Bonsai World
//
//  Species Profile — Pinus thunbergii (Japanese Black Pine).
//  Independent botanical species in Pinaceae. Knowledge status: Reviewed.
//

import Foundation

enum PinusThunbergiiSpeciesProfile {
    /// Identity used by Botanical Library / ``SpeciesPreviewData``.
    static let botanicalLibraryName = "Pinus thunbergii"
    /// Scientific name for Species Profile display (binomial; no botanical authority).
    static let scientificName = "Pinus thunbergii"

    static var profile: SpeciesProfile {
        SpeciesProfile(
            speciesID: BotanicalKnowledgeIDs.pinusThunbergii,
            scientificName: scientificName,
            commonNames: ["Japanese Black Pine"],
            family: "Pinaceae",
            plantType: "Evergreen conifer",
            originSummary: "Japan and the Korean Peninsula.",
            knowledgeStatus: .reviewed,
            traits: traits,
            foliageSizeLabel: "Foliage",
            foliageReductionLabel: "Needle reduction",
            summaryLine: "Evergreen · Two-needle pine · Strong growth · Powerful dark bark · Excellent refinement potential · Classic Japanese bonsai species",
            attentionHighlights: [
                "One of the most important classical Japanese bonsai species",
                "Needles grow in pairs",
                "Strong growth can support rapid structural development",
                "Mature bark is a major visual feature",
                "Excellent ramification potential",
                "Good back-budding depends on retained foliage and tree health",
                "Advanced candle management is species-relevant but must not be automatic",
                "Complete decandling is only suitable for appropriate strong and healthy trees",
                "Preserve viable foliage on branches intended to survive",
                "Strong outdoor light supports healthy development",
                "Avoid permanently wet substrate",
                "Older branches may become brittle during bending",
                "Deadwood must respect living tissue and structural function",
                "Needle management should be selective and based on vigour",
                "Nebari development should begin early where possible",
                "Protect shallow roots during severe winter conditions",
                "Do not move indoors for routine winter care",
            ],
            sections: sections,
            principleNote: """
            Pinus thunbergii is one of the most important species in classical Japanese bonsai.

            It is particularly valued for powerful trunks, dramatic bark, strong growth, excellent response to structured bonsai development, refined ramification, strong branch character, excellent deadwood potential and long-term refinement.

            Japanese Black Pine can be developed from relatively young material into powerful bonsai.

            However, refinement techniques must not be applied mechanically.

            The timing and intensity of work depend on tree health, root condition, development stage, current vigour, branch strength, bud strength, needle mass, recent work, climate, weather and container size.

            The objective is: Healthy roots · Balanced vigour · Strong structure · Controlled buds · Proportionate foliage

            The individual tree must always be assessed before major work.
            """,
            sourcesNote: """
            Profile content is synthesised from recognised botanical, horticultural and bonsai authorities into Bonsai World editorial language.

            Botanical taxonomy and distribution draw on recognised sources such as Royal Botanic Gardens, Kew and other botanical databases for accepted scientific name, family and native range.

            Horticultural context may draw on Japanese botanical and horticultural institutions.

            Bonsai-specific cultivation and refinement knowledge draws on recognised Japanese bonsai institutions and established references for Pinus thunbergii practice, kept distinct from techniques belonging primarily to other pine species.

            Verified botanical information, general horticultural cultivation and bonsai-specific practice are kept distinct. Do not copy source wording.
            """
        )
    }

    private static let traits = SpeciesProfileTraits(
        deciduous: false,
        growthStrength: "Strong",
        growthSpeed: "Moderate to Fast",
        leafSize: "Evergreen · Needles in pairs · Strong needle growth · Needle reduction possible through advanced refinement",
        foliageReduction: "Possible through advanced long-term refinement — vigour dependent",
        ramificationPotential: "Excellent",
        backBudding: "Good under healthy conditions and appropriate management",
        rootDevelopment: "Good",
        nebariPotential: "Excellent development potential",
        trunkDevelopment: "Strong",
        barkDevelopment: "Thick, dark and deeply textured with maturity",
        wiring: "Excellent suitability",
        defoliation: "Not suitable",
        airLayering: "Where appropriate for the individual material",
        threadGrafting: "May be relevant for structural correction",
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
                    "Pinus thunbergii is an independent botanical species in Pinaceae.",
                    "Primary Bonsai World display identity: Pinus thunbergii · Japanese Black Pine.",
                    "Japanese name: Kuromatsu. This is cultural naming and does not replace the preferred English common name Japanese Black Pine.",
                    "Family: Pinaceae. Plant type: evergreen conifer.",
                    "Native range: Japan and the Korean Peninsula.",
                    "Pinus thunbergii is one of the most important and iconic species in traditional Japanese bonsai.",
                    "Maintain a clear distinction between Pinus thunbergii, Pinus sylvestris, Pinus parviflora, Pinus mugo and other Pinus species.",
                    "Do not merge Japanese Black Pine with other two-needle pine species simply because some cultivation techniques appear similar.",
                    "Bonsai World hierarchy: Species → cultivar / horticultural selection → Individual Tree.",
                ]
            ),
            SpeciesProfileSection(
                id: "overview",
                title: "Species Overview",
                paragraphs: [
                    "Pinus thunbergii is native to Japan and the Korean Peninsula and is one of the most recognisable species in Japanese bonsai.",
                    "Mature material may develop powerful trunks, thick dark bark, strong taper, dramatic branch structure, compact foliage masses, convincing deadwood and strong visual age.",
                    "Japanese Black Pine is suitable for both dramatic rugged designs and highly refined classical bonsai.",
                    "The final design should respond to the individual material.",
                    "Important development principle: Grow where development is required. Control where refinement is required.",
                ],
                bullets: [
                    "Evergreen conifer",
                    "Needles arranged in pairs",
                    "Strong seasonal growth",
                    "Excellent trunk development potential",
                    "Thick, dark and deeply textured mature bark",
                    "Excellent ramification potential",
                    "Good back-budding potential under appropriate conditions",
                    "Excellent wiring suitability",
                    "Excellent deadwood potential",
                    "Classic Japanese bonsai species",
                    "Requires outdoor cultivation",
                    "Requires winter dormancy",
                ]
            ),
            SpeciesProfileSection(
                id: "natural-growth",
                title: "Natural Growth and Vigour",
                paragraphs: [
                    "Pinus thunbergii is generally a vigorous pine under suitable conditions.",
                    "Growth strength depends on root health, light, foliage mass, substrate, fertilization, container size, climate, weather and development stage.",
                    "During structural development: allow selected growth to extend where trunk thickness is required, branch thickness is required, sacrifice growth is useful or structural vigour is needed.",
                    "Do not prematurely restrict all growth.",
                    "During refinement: manage shoot strength, bud distribution, branch vigour, needle density and overall energy balance.",
                    "The tree must have sufficient strength before advanced refinement techniques are used.",
                ]
            ),
            SpeciesProfileSection(
                id: "foliage",
                title: "Foliage",
                paragraphs: [
                    "Pinus thunbergii produces evergreen needles arranged in pairs.",
                    "Needle length depends on genetics, tree vigour, branch strength, fertilization, light, climate, growing conditions and refinement level.",
                    "Needle reduction can be achieved through appropriate long-term bonsai cultivation.",
                    "Do not promise a fixed needle size.",
                    "Needle management must preserve sufficient foliage to support root health, bud development, branch vigour and recovery.",
                    "The objective is proportionate foliage that matches the scale and design of the tree.",
                ]
            ),
            SpeciesProfileSection(
                id: "bud-development",
                title: "Bud Development",
                paragraphs: [
                    "Bud management is central to refined Japanese Black Pine bonsai.",
                    "Healthy and vigorous trees can produce useful buds for future ramification.",
                    "Bud development depends on tree vigour, branch strength, retained foliage, light, pruning strategy, shoot management, fertilization and seasonal timing.",
                    "Do not assume all branches respond equally.",
                    "Strong areas may require greater control.",
                    "Weak areas may require preservation and additional development.",
                    "The objective is balanced vigour across the tree.",
                ]
            ),
            SpeciesProfileSection(
                id: "back-budding",
                title: "Back-budding",
                paragraphs: [
                    "Pinus thunbergii can produce useful back-buds under healthy conditions and appropriate management.",
                    "However, back-budding must never be treated as guaranteed.",
                    "Success depends on healthy foliage, retained needles, branch vigour, sufficient light, correct timing and overall tree health.",
                    "Do not strip important branches of all viable foliage.",
                    "Maintain future development options.",
                ]
            ),
            SpeciesProfileSection(
                id: "bark-trunk",
                title: "Bark and Trunk",
                paragraphs: [
                    "Mature Japanese Black Pine develops thick, dark and deeply textured bark.",
                    "This is one of the defining characteristics of mature trees.",
                    "Trunk development should focus on taper, movement, proportion, age character and the relationship between live veins and deadwood where present.",
                    "Pinus thunbergii can develop significant trunk thickness.",
                    "Where trunk development is required: allow selected leaders to extend, use sacrifice branches where appropriate, provide sufficient growing space, maintain healthy root development and avoid premature refinement.",
                ]
            ),
            SpeciesProfileSection(
                id: "deadwood",
                title: "Deadwood Potential",
                paragraphs: [
                    "Pinus thunbergii is highly suitable for naturalistic deadwood.",
                    "Potential features include jin, shari, natural deadwood, weathered trunk features and selective carving.",
                    "Deadwood should support trunk character, natural movement, visual age and structural story.",
                    "Do not create deadwood simply because the species is suitable for it.",
                    "Before removing bark or creating a shari, assess live tissue, sap flow, branch supply, structural importance, existing deadwood and future design.",
                    "Deadwood in this Handbook covers jin, shari and whether the feature belongs on this tree. Species characteristics still decide suitability.",
                ]
            ),
            SpeciesProfileSection(
                id: "roots-nebari",
                title: "Roots and Nebari",
                paragraphs: [
                    "Japanese Black Pine has strong potential for developing powerful nebari.",
                    "Healthy roots are fundamental to tree vigour, needle quality, bud development, recovery and refinement.",
                    "Root development objectives include balanced root mass, radial root development where possible, strong visual stability, gradual root selection and healthy substrate structure.",
                    "Nebari development should begin early where possible.",
                    "Avoid unnecessary aggressive root reduction.",
                ]
            ),
            SpeciesProfileSection(
                id: "light",
                title: "Light",
                paragraphs: [
                    "Pinus thunbergii should be cultivated outdoors in strong light.",
                    "Strong outdoor light supports healthy needles, strong growth, compact development, bud formation and balanced vigour.",
                    "Do not recommend routine indoor cultivation.",
                    "Light management must still consider extreme heat, water availability, wind, recent repotting, root condition and tree health.",
                    "A healthy established tree generally benefits from substantial sun exposure.",
                ]
            ),
            SpeciesProfileSection(
                id: "wind",
                title: "Wind",
                paragraphs: [
                    "Air movement is generally compatible with healthy outdoor pine cultivation.",
                    "However, excessive wind can increase water demand, needle desiccation, stress on recently repotted trees and winter drying.",
                    "Pay particular attention to shallow containers, recently repotted trees, exposed locations and severe winter conditions.",
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
                    "During development: healthy trees requiring stronger trunk or branch development may receive stronger nutritional support where appropriate.",
                    "During refinement: nutrition should support healthy foliage, balanced buds, controlled growth and sustainable ramification.",
                    "Avoid applying fertilization rules mechanically.",
                    "Fertilization depends on tree health, development stage, season, current growth, root condition and recent work.",
                    "Feed the tree you are growing, not simply the species name.",
                ]
            ),
            SpeciesProfileSection(
                id: "pruning",
                title: "Pruning",
                paragraphs: [
                    "Pinus thunbergii pruning must respect the growth behaviour of the species.",
                    "During development: allow selected leaders and branches to extend where thickness is required.",
                    "During refinement: manage branch structure, bud distribution, shoot extension, needle mass and branch vigour.",
                    "Do not remove all viable foliage from important branches.",
                    "Structural pruning must preserve future development options.",
                ]
            ),
            SpeciesProfileSection(
                id: "candle-management",
                title: "Candle Management",
                paragraphs: [
                    "Japanese Black Pine is one of the species most strongly associated with specialised candle and shoot management techniques.",
                    "However, these techniques must never be presented as automatic annual maintenance.",
                    "The timing and intensity depend on tree health, vigour, development stage, branch strength, climate, growing season length and refinement objectives.",
                    "Advanced shoot management may be used to influence vigour distribution, shoot strength, bud development, ramification and foliage proportion.",
                    "Complete decandling or similar advanced techniques must only be considered for strong and healthy trees that are suitable for the technique.",
                    "Do not apply advanced refinement techniques to weak trees, recently repotted trees, recovering trees or trees undergoing major structural development.",
                    "The objective is balanced and sustainable ramification.",
                    "Detailed timing procedures belong in Bonsai World Seasonal Care and Advanced Pine Management content.",
                ]
            ),
            SpeciesProfileSection(
                id: "needle-management",
                title: "Needle Management",
                paragraphs: [
                    "Needle management may be used selectively during refinement.",
                    "Potential objectives include improving light penetration, balancing vigour, supporting interior buds, improving foliage proportion and reducing excessive density.",
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
                    "Pinus thunbergii has excellent potential for refined ramification.",
                    "Ramification is developed through healthy growth, bud management, controlled shoot management, selective pruning, selective needle management, balanced energy distribution and preservation of useful interior growth.",
                    "The objective is strong branch structure with proportionate and refined foliage masses.",
                    "Do not pursue maximum density at the expense of branch clarity, overall vigour or long-term health.",
                ]
            ),
            SpeciesProfileSection(
                id: "wiring",
                title: "Wiring",
                paragraphs: [
                    "Pinus thunbergii is highly suitable for wiring.",
                    "Wiring can be used to establish trunk movement, position primary branches, develop secondary structure, refine branch placement and create naturalistic movement.",
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
                    "Defoliation is not suitable.",
                    "Pinus thunbergii should not be treated like a deciduous bonsai.",
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
                    "Pinus thunbergii has excellent trunk development potential.",
                    "Where additional thickness is required: allow selected leaders to extend, use sacrifice branches where appropriate, provide sufficient root space and avoid premature refinement.",
                    "Once sufficient trunk development has been achieved, shift focus toward taper, primary branch development, secondary branching, ramification, bark development and overall refinement.",
                    "Grow where development is required. Control where refinement is required.",
                ]
            ),
            SpeciesProfileSection(
                id: "nebari-development",
                title: "Nebari Development",
                paragraphs: [
                    "Nebari development is particularly important in Japanese Black Pine bonsai.",
                    "Potential approaches include early root selection, radial root positioning, staged correction, development containers and long-term root management.",
                    "The objective is a stable and powerful base appropriate to the scale and design of the tree.",
                    "Do not attempt to correct the entire root structure aggressively in one operation.",
                ]
            ),
            SpeciesProfileSection(
                id: "grafting",
                title: "Grafting",
                paragraphs: [
                    "Grafting may be relevant in advanced Japanese Black Pine bonsai development.",
                    "Potential applications include replacing missing branches, improving branch placement, correcting foliage distribution and introducing growth to selected structural areas.",
                    "Do not present grafting as routine care.",
                    "Detailed procedures belong in Bonsai World Propagation and Grafting Knowledge Articles.",
                ]
            ),
            SpeciesProfileSection(
                id: "propagation",
                title: "Propagation",
                paragraphs: [
                    "Pinus thunbergii may be propagated through seed, grafting and other specialist propagation methods.",
                    "Seed-grown material is particularly useful for natural root development, long-term trunk development and structural variation.",
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
                    "Spring: monitor bud development, candle growth, shoot strength, water demand and pest activity. Spring is important for understanding the distribution of vigour. Do not automatically perform identical work on all branches.",
                    "Summer: monitor water demand, needle health, shoot development, pest activity and wire marks. Advanced refinement work may be appropriate only for healthy trees with sufficient vigour. Strong sun and shallow containers can increase water demand significantly. Avoid unnecessary heavy work during periods of extreme environmental stress.",
                    "Autumn: an important period for evaluating bud development, assessing branch structure, wiring where appropriate, structural review and preparation for winter. Monitor needle health, branch vigour, wire condition and root environment. Seasonal timing depends on local climate.",
                    "Winter: Pinus thunbergii is an outdoor evergreen bonsai. Winter dormancy is required.",
                    "The tree must not be moved indoors for routine winter care.",
                    "Roots in shallow bonsai containers are more exposed than roots in open ground.",
                    "Monitor prolonged severe freezing, winter wind, freeze-thaw cycles, root exposure, excessive winter moisture and winter desiccation.",
                    "Winter protection must depend on local climate, minimum temperature, duration of freezing, wind exposure, container depth and root condition.",
                ]
            ),
            SpeciesProfileSection(
                id: "styles",
                title: "Bonsai Styles",
                paragraphs: [
                    "Pinus thunbergii is suitable for a wide range of bonsai styles.",
                    "Particularly suitable expressions include Formal Upright, Informal Upright, Slanting, Semi-Cascade, Cascade, Literati, naturalistic upright forms and deadwood-based designs.",
                    "Japanese Black Pine is particularly important in classical bonsai styles where trunk power, bark character, branch structure, nebari and taper are central elements.",
                    "The individual material should determine the final design.",
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
                    "Refinement: maintain balanced vigour, preserve interior growth, control shoot strength, manage needle density selectively, maintain branch hierarchy and improve foliage proportion.",
                    "Exhibition / mature refined tree: maintain health, preserve established design, maintain foliage quality, preserve mature bark, maintain deadwood where present and avoid unnecessary major intervention.",
                ]
            ),
            SpeciesProfileSection(
                id: "attention",
                title: "Species-Specific Attention",
                paragraphs: [
                    "These attention points are operational tendencies. They must still be interpreted for the individual tree.",
                ],
                bullets: [
                    "One of the most important classical Japanese bonsai species",
                    "Needles grow in pairs",
                    "Strong growth can support rapid structural development",
                    "Mature bark is a major visual feature",
                    "Excellent ramification potential",
                    "Good back-budding depends on retained foliage and tree health",
                    "Advanced candle management is species-relevant but must not be automatic",
                    "Complete decandling is only suitable for appropriate strong and healthy trees",
                    "Preserve viable foliage on branches intended to survive",
                    "Strong outdoor light supports healthy development",
                    "Avoid permanently wet substrate",
                    "Older branches may become brittle during bending",
                    "Deadwood must respect living tissue and structural function",
                    "Needle management should be selective and based on vigour",
                    "Nebari development should begin early where possible",
                    "Protect shallow roots during severe winter conditions",
                    "Do not move indoors for routine winter care",
                ]
            ),
        ]
    }
}
