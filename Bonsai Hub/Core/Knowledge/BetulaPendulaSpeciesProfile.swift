//
//  BetulaPendulaSpeciesProfile.swift
//  Bonsai World
//
//  Species Profile — Betula pendula (Silver Birch).
//  Independent botanical species in Betulaceae. Knowledge status: Reviewed.
//  Separate from Betula pubescens and other Betula species.
//

import Foundation

enum BetulaPendulaSpeciesProfile {
    /// Identity used by Botanical Library / ``SpeciesPreviewData``.
    static let botanicalLibraryName = "Betula pendula"
    /// Scientific name for Species Profile display (binomial; no botanical authority).
    static let scientificName = "Betula pendula"

    static var profile: SpeciesProfile {
        SpeciesProfile(
            speciesID: BotanicalKnowledgeIDs.betulaPendula,
            scientificName: scientificName,
            commonNames: ["Silver Birch", "European White Birch", "Weeping Birch"],
            family: "Betulaceae",
            plantType: "Deciduous tree",
            originSummary: "Europe and parts of western and northern Asia.",
            knowledgeStatus: .reviewed,
            traits: traits,
            foliageSizeLabel: "Foliage",
            foliageReductionLabel: "Leaf reduction",
            summaryLine: "Deciduous · Hardy · Nordic relevance · Fine branching potential · Characteristic white bark · Graceful growth habit · Strong pioneer species character · Requires winter dormancy · Suitable for naturalistic bonsai",
            attentionHighlights: [
                "Betula pendula is particularly relevant to Nordic and northern European bonsai",
                "Requires winter dormancy",
                "Outdoor cultivation is required",
                "Pale bark is a defining visual feature",
                "Protect healthy bark",
                "Avoid artificial bark damage",
                "Naturalistic styling is particularly suitable",
                "Moderate back-budding should be qualified by health and branch condition",
                "Do not assume old bare branches will reliably regenerate",
                "Avoid repeated severe drying",
                "Avoid permanently saturated roots",
                "Fine ramification should be developed gradually",
                "Preserve useful interior growth",
                "Do not use complete defoliation as routine management",
                "Young branches are generally easier to wire than older branches",
                "Avoid forcing rigid branches",
                "Shallow bonsai roots require protection during prolonged severe freezing",
            ],
            sections: sections,
            principleNote: """
            Betula pendula should be developed with respect for its naturally elegant and often relatively light visual character.

            Its strongest bonsai characteristics include distinctive pale bark, graceful branch structure, fine foliage, naturalistic silhouette and strong northern European landscape identity.

            Avoid styling Betula pendula as though it were a heavy, densely ramified deciduous species such as Fagus, Carpinus or Acer.

            The objective is: Natural trunk character · Elegant branch structure · Controlled ramification · Visible bark · Light and believable silhouette.

            The individual tree must always be assessed according to climate, tree condition, vigour, development stage and winter temperatures.
            """,
            sourcesNote: """
            Profile content is synthesised from recognised botanical, horticultural and bonsai authorities into Bonsai World editorial language.

            Botanical taxonomy and distribution draw on recognised sources such as Royal Botanic Gardens, Kew and other botanical databases for accepted scientific name, family and native range.

            Horticultural context may draw on recognised Nordic and European botanical institutions, forestry institutions and authoritative Betula references.

            Bonsai-specific cultivation and refinement knowledge draws on established bonsai references and recognised professional practice with Betula experience, kept distinct from Betula pubescens and other Betula species.

            Verified botanical information, horticultural information, regional climate adaptation and bonsai-specific practice are kept distinct. Do not copy source wording.
            """
        )
    }

    private static let traits = SpeciesProfileTraits(
        deciduous: true,
        growthStrength: "Moderate to Strong",
        growthSpeed: "Moderate to Fast",
        leafSize: "Deciduous · Small to Medium",
        foliageReduction: "Not routine management",
        ramificationPotential: "Good",
        backBudding: "Moderate",
        rootDevelopment: "Moderate",
        nebariPotential: "Moderate potential",
        trunkDevelopment: "Moderate to Fast when grown freely",
        barkDevelopment: "Excellent and highly distinctive",
        wiring: "Moderate",
        defoliation: "Not routine management",
        airLayering: "Where appropriate for the individual material",
        threadGrafting: "Where structural correction is required",
        rootGrafting: "Where appropriate",
        beginnerSuitability: "Moderate",
        bonsaiSuitability: "Good",
        difficulty: "Intermediate to Advanced",
        winterDormancyRequired: true,
        winterHardiness: "Required",
        rootFrostSensitivity: "Moderate in shallow bonsai containers during prolonged severe freezing"
    )

    private static var sections: [SpeciesProfileSection] {
        [
            SpeciesProfileSection(
                id: "taxonomic-context",
                title: "Taxonomic Context",
                paragraphs: [
                    "Betula pendula is an independent botanical species in the birch family (Betulaceae).",
                    "Primary Bonsai World display identity: Betula pendula · Silver Birch.",
                    "European White Birch may be used as supporting terminology. It does not replace Silver Birch as the preferred English common name.",
                    "Weeping Birch should only be used cautiously because it may also refer to cultivated forms or other Betula species.",
                    "Family: Betulaceae. Plant type: deciduous tree.",
                    "Native range: Europe and parts of western and northern Asia.",
                    "Do not confuse Betula pendula with Betula pubescens.",
                    "Bonsai World hierarchy: Species → cultivar / horticultural selection → Individual Tree.",
                ]
            ),
            SpeciesProfileSection(
                id: "overview",
                title: "Species Overview",
                paragraphs: [
                    "Betula pendula is one of Europe's most recognisable deciduous trees and is especially important throughout northern Europe.",
                    "Betula pendula is particularly relevant to Bonsai World because it is one of the most recognisable native and naturalised trees across northern Europe, highly relevant to Nordic landscapes, immediately recognisable because of its bark, capable of producing elegant, naturalistic bonsai and particularly suited to landscape-inspired designs.",
                    "The species is known for characteristic pale bark, graceful branches, relatively fine foliage, rapid colonisation of open landscapes and strong seasonal character.",
                    "For bonsai, the species is often most convincing when developed with a naturalistic approach.",
                    "Strong features should be preserved rather than forcing the tree into a generic bonsai silhouette.",
                    "The most convincing designs often emphasise vertical movement, light branch structure, visible trunk, mature bark and natural asymmetry.",
                ],
                bullets: [
                    "Deciduous",
                    "Hardy",
                    "Strong Nordic relevance",
                    "Requires winter dormancy",
                    "Outdoor cultivation required",
                    "Characteristic white to pale bark",
                    "Fine foliage",
                    "Elegant natural growth",
                    "Moderate to strong vigour",
                    "Moderate back-budding",
                    "Good ramification potential",
                    "Naturalistic styling suitability",
                    "Long-term bark development",
                ]
            ),
            SpeciesProfileSection(
                id: "cultivars",
                title: "Cultivars and Forms",
                paragraphs: [
                    "Betula pendula is primarily used in bonsai as the botanical species.",
                    "Horticultural cultivars and weeping forms may differ in branch habit, bark character and foliage appearance.",
                    "Weeping Birch should only be used cautiously as terminology because it may also refer to cultivated forms or other Betula species.",
                    "Do not create unnecessary separate Species Library profiles for minor individual variation.",
                    "The primary Species Profile remains Betula pendula.",
                    "Only create separate profiles where a distinct cultivar or form has a clear and established independent bonsai identity.",
                ]
            ),
            SpeciesProfileSection(
                id: "natural-growth",
                title: "Natural Growth and Vigour",
                paragraphs: [
                    "Betula pendula can grow strongly under favourable conditions.",
                    "Growth depends on root health, water availability, light, temperature, root space and overall tree health.",
                    "During structural development: allow selected growth to extend where trunk thickness is required, taper is required or primary branches require development.",
                    "During refinement: control excessively long shoots, coarse branch development, congestion and loss of useful internal structure.",
                    "Do not permanently restrict useful development growth too early.",
                    "The objective is: Strong structural development when required · Controlled refinement when structure is established.",
                ]
            ),
            SpeciesProfileSection(
                id: "foliage",
                title: "Foliage",
                paragraphs: [
                    "Betula pendula has relatively small triangular foliage with characteristic serrated margins.",
                    "Foliage management should focus on healthy growth, branch development, shoot selection, balanced vigour and appropriate proportions.",
                    "Leaf size may vary according to genetics, vigour, fertilization, growing conditions and development stage.",
                    "Do not rely on aggressive defoliation as routine management.",
                    "The objective is: Healthy foliage · Natural proportions · Clear species character.",
                ]
            ),
            SpeciesProfileSection(
                id: "flowering",
                title: "Flowering",
                paragraphs: [
                    "Flowering is not a primary bonsai feature.",
                    "Catkins should be viewed as part of the species' seasonal character rather than a design objective.",
                    "Do not sacrifice structural development or ramification in pursuit of flowering.",
                ]
            ),
            SpeciesProfileSection(
                id: "fruit",
                title: "Fruit",
                paragraphs: [
                    "Fruit-bearing is not a primary bonsai feature.",
                    "Fruit is not required for a convincing Silver Birch bonsai.",
                    "Do not treat fruit production as a styling priority.",
                ]
            ),
            SpeciesProfileSection(
                id: "bark-trunk",
                title: "Bark and Trunk",
                paragraphs: [
                    "The bark of Betula pendula is one of the species' most important visual characteristics. Mature bark character is excellent and highly distinctive.",
                    "Mature bark can develop strong contrast between pale outer bark, darker fissures and markings and increasingly mature trunk character.",
                    "Trunk development should focus on sufficient thickness, believable taper, natural movement and appropriate proportions.",
                    "Do not artificially damage or remove healthy bark to simulate age.",
                    "Protect the natural bark character.",
                    "The objective is: Natural maturity · Visible bark · Elegant trunk presence.",
                ]
            ),
            SpeciesProfileSection(
                id: "roots-nebari",
                title: "Roots and Nebari",
                paragraphs: [
                    "Healthy roots support foliage health, recovery, trunk development, branch development and long-term container cultivation.",
                    "Root development is moderate. Objectives include balanced roots, stable anchoring, gradual radial development and progressive nebari improvement.",
                    "Root work should be staged carefully.",
                    "Avoid unnecessary aggressive root reduction.",
                    "The objective is: Healthy roots · Stable growth · Gradual base development.",
                ]
            ),
            SpeciesProfileSection(
                id: "light",
                title: "Light",
                paragraphs: [
                    "Betula pendula should be cultivated outdoors with good access to light.",
                    "Adequate light supports healthy foliage, compact branch development, strong seasonal growth and overall vigour.",
                    "The ideal position depends on local climate, summer temperatures, tree health and development stage.",
                    "Outdoor cultivation is required.",
                    "Do not recommend permanent indoor cultivation.",
                ]
            ),
            SpeciesProfileSection(
                id: "wind",
                title: "Wind",
                paragraphs: [
                    "Moderate air movement is beneficial.",
                    "Strong wind can increase water demand, stress foliage, dry shallow containers and increase winter exposure.",
                    "Monitor carefully during warm dry wind, prolonged dry conditions and exposed winter weather.",
                ]
            ),
            SpeciesProfileSection(
                id: "watering",
                title: "Watering",
                paragraphs: [
                    "General principle: Maintain reliable moisture · Avoid repeated severe drying · Avoid permanent saturation · Maintain healthy root aeration.",
                    "Water demand is moderate to high during active growth.",
                    "Betula pendula can have significant water demand during active growth.",
                    "Water demand depends on temperature, sunlight, wind, foliage mass, container size, substrate and root mass.",
                    "Do not water according to a fixed timetable.",
                    "The objective is: Consistent healthy moisture · Healthy roots · Stable growth.",
                ]
            ),
            SpeciesProfileSection(
                id: "soil",
                title: "Soil",
                paragraphs: [
                    "Do not prescribe one universal soil recipe.",
                    "Desired characteristics include good drainage, good aeration, sufficient moisture retention, stable particle structure and healthy root development.",
                    "The final substrate depends on local climate, rainfall, watering habits, container depth, tree size and development stage.",
                    "Follow Bonsai World Soil Module principles.",
                    "Do not duplicate the complete Soil Module inside this profile.",
                ]
            ),
            SpeciesProfileSection(
                id: "fertilizing",
                title: "Fertilizing",
                paragraphs: [
                    "Fertilization should support foliage health, trunk development, branch development, ramification and recovery.",
                    "During structural development: support healthy vigorous growth where thickness is required.",
                    "During refinement: avoid excessive feeding that produces overly long shoots, coarse growth, unnecessarily large foliage or loss of branch proportion.",
                    "Key principle: Feed according to tree health and development objective.",
                ]
            ),
            SpeciesProfileSection(
                id: "pruning",
                title: "Pruning",
                paragraphs: [
                    "Pruning can be used for structural development, branch selection, branch replacement, ramification and silhouette refinement. Pruning response is good with species-specific considerations.",
                    "When making structural changes: preserve useful interior growth, consider branch age, retain replacement options where possible and avoid repeated unnecessary heavy pruning.",
                    "During refinement: use controlled pruning and shoot selection to maintain branch hierarchy, light structure, natural proportions and visible trunk and bark.",
                    "Avoid uniform trimming.",
                    "The objective is: Purposeful development · Natural branching · Controlled refinement.",
                ]
            ),
            SpeciesProfileSection(
                id: "back-budding",
                title: "Back-budding",
                paragraphs: [
                    "Betula pendula can produce useful new growth, but response depends on tree health, vigour, branch age, available buds, pruning timing and light. Back-budding is moderate.",
                    "Do not assume that every bare or old branch will reliably produce new growth.",
                    "When structural pruning is required: preserve useful interior shoots, retain possible replacement branches and avoid unnecessary removal of viable structure.",
                    "The objective is: Controlled renewal · Preservation of options · Gradual refinement.",
                ]
            ),
            SpeciesProfileSection(
                id: "ramification",
                title: "Ramification",
                paragraphs: [
                    "Ramification should be developed through repeated healthy growth cycles, shoot selection, controlled pruning, branch selection and preservation of useful interior growth. Ramification potential is good.",
                    "Avoid uniform hedge-like trimming, excessive density and dense outer foliage with weak interiors.",
                    "The objective is: Natural branch hierarchy · Fine branching · Light visual structure.",
                ]
            ),
            SpeciesProfileSection(
                id: "wiring",
                title: "Wiring",
                paragraphs: [
                    "Young branches are generally easier to position than older branches. Wiring response is moderate.",
                    "Wiring can be used for branch direction, structural placement and correction of young growth.",
                    "Before major bends assess branch thickness, flexibility, age, health and structural importance.",
                    "Monitor wire carefully.",
                    "Avoid damaging the characteristic bark.",
                    "Avoid forcing rigid branches.",
                    "Pruning and directional growth should be considered alongside wiring.",
                ]
            ),
            SpeciesProfileSection(
                id: "deadwood-potential",
                title: "Deadwood",
                paragraphs: [
                    "Natural deadwood or old branch remnants can occasionally contribute to believable character. Deadwood potential is moderate in naturalistic material.",
                    "However, deadwood should be justified by the individual material, excessive artificial jin or shari is generally inappropriate and natural trunk and bark character should remain the priority.",
                    "The objective is: Natural age · Believable history · Species-appropriate character.",
                ]
            ),
            SpeciesProfileSection(
                id: "defoliation",
                title: "Foliage Management",
                paragraphs: [
                    "Complete defoliation is not routine management.",
                    "Foliage management should primarily focus on shoot selection, pruning, vigour control, balanced fertilization and adequate light.",
                    "Do not present complete defoliation as routine maintenance.",
                    "Do not apply aggressive foliage work to weak trees, stressed trees, recently repotted trees or trees recovering from major structural work.",
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
                    "Repotting decisions should be based on root condition, substrate performance and tree health.",
                    "Timing must account for local climate, winter conditions, active growth cycle and individual tree condition.",
                ]
            ),
            SpeciesProfileSection(
                id: "trunk-development",
                title: "Trunk Development",
                paragraphs: [
                    "Betula pendula can develop trunk thickness relatively quickly when allowed sufficient growth.",
                    "Where additional thickness is required: allow selected leaders to extend, provide sufficient root space, use development containers where appropriate and avoid premature refinement.",
                    "Leader development should support taper, trunk thickness, natural movement and believable proportions.",
                    "Once sufficient trunk development has been achieved, shift focus toward branch hierarchy, ramification, mature bark and refined proportions.",
                    "Key principle: Do not permanently restrict a tree that still requires major structural development.",
                ]
            ),
            SpeciesProfileSection(
                id: "nebari-development",
                title: "Nebari Development",
                paragraphs: [
                    "Nebari should be developed gradually.",
                    "Potential approaches include early root selection, radial root planning, staged correction, suitable development containers and gradual refinement.",
                    "The objective is a stable and visually convincing base appropriate to the species.",
                ]
            ),
            SpeciesProfileSection(
                id: "propagation",
                title: "Propagation",
                paragraphs: [
                    "Betula pendula may be propagated using established horticultural methods including seed and selected vegetative propagation methods where appropriate.",
                    "Seed-grown material may offer genetic variation, early root planning and natural trunk development opportunities.",
                    "Detailed procedures belong in Bonsai World Propagation Knowledge Articles.",
                ]
            ),
            SpeciesProfileSection(
                id: "pests",
                title: "Pests and Problems",
                paragraphs: [
                    "Relevant risks may include aphids, leaf-feeding insects, fungal leaf problems, drought stress, root problems caused by poor substrate aeration, stress caused by repeated drying and root stress during prolonged severe freezing.",
                    "Do not provide generic treatment instructions.",
                    "Diagnosis and treatment belong in Care → Pest Management and Care → Disease & Problems.",
                ]
            ),
            SpeciesProfileSection(
                id: "seasonal",
                title: "Seasonal Profile",
                paragraphs: [
                    "Spring: monitor bud development, new growth, watering demand, vigour and structural priorities. Spring is important for evaluating branch development, ramification, root health and recovery from winter. Coordinate major work with local climate and individual tree condition.",
                    "Summer: monitor watering demand, foliage health, shoot extension, pest activity and wire marks. Strong growth should be managed according to whether shoots are required for trunk development, branch development or refinement. Do not suppress useful vigorous growth unnecessarily.",
                    "Autumn is important for evaluating seasonal health, reviewing branch structure, assessing growth and preparing for dormancy. Autumn foliage colour may also contribute to the seasonal character of the species. Local climate and tree condition determine timing. Do not apply one universal autumn schedule.",
                    "Winter: Betula pendula requires winter dormancy.",
                    "Winter management depends on local minimum temperatures, duration of freezing, wind exposure, container depth, root protection and tree health.",
                    "Shallow bonsai roots are more exposed to severe cold than roots growing in open ground.",
                    "Protect the root system when required. Do not maintain indoors as a substitute for winter dormancy.",
                ]
            ),
            SpeciesProfileSection(
                id: "styles",
                title: "Bonsai Styles",
                paragraphs: [
                    "Betula pendula is particularly suitable for Informal Upright, Slanting, Multi-trunk, Clump Style, Naturalistic Bonsai and Forest Style.",
                    "It is especially effective when styling emphasises graceful movement, visible trunk, natural branch structure, light foliage and landscape character.",
                    "The individual material should determine the final design.",
                ]
            ),
            SpeciesProfileSection(
                id: "tree-stage",
                title: "Development by Tree Stage",
                paragraphs: [
                    "Young material: establish healthy roots, develop trunk thickness, establish natural movement and begin structural development.",
                    "Nursery material: evaluate trunk potential, identify useful branches, establish design direction and begin structural correction.",
                    "Pre-bonsai: develop trunk, establish primary branches, improve root structure, build taper and build vigour.",
                    "In training: develop secondary branches, improve branch hierarchy, build ramification and preserve useful interior growth.",
                    "Refinement: maintain balanced vigour, improve branch structure, control excessive extension, preserve light natural structure and maintain visible trunk and bark.",
                    "Exhibition / mature refined tree: maintain health, preserve established structure, maintain balanced ramification, preserve mature bark character and avoid unnecessary major intervention.",
                ]
            ),
            SpeciesProfileSection(
                id: "attention",
                title: "Species-Specific Attention",
                paragraphs: [
                    "These attention points are operational tendencies. They must still be interpreted for the individual tree.",
                ],
                bullets: [
                    "Betula pendula is particularly relevant to Nordic and northern European bonsai",
                    "Requires winter dormancy",
                    "Outdoor cultivation is required",
                    "Pale bark is a defining visual feature",
                    "Protect healthy bark",
                    "Avoid artificial bark damage",
                    "Naturalistic styling is particularly suitable",
                    "Moderate back-budding should be qualified by health and branch condition",
                    "Do not assume old bare branches will reliably regenerate",
                    "Avoid repeated severe drying",
                    "Avoid permanently saturated roots",
                    "Fine ramification should be developed gradually",
                    "Preserve useful interior growth",
                    "Do not use complete defoliation as routine management",
                    "Young branches are generally easier to wire than older branches",
                    "Avoid forcing rigid branches",
                    "Shallow bonsai roots require protection during prolonged severe freezing",
                ]
            ),
        ]
    }
}
