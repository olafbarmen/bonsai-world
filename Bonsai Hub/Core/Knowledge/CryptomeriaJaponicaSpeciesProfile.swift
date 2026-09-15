//
//  CryptomeriaJaponicaSpeciesProfile.swift
//  Bonsai World
//
//  Species Profile — Cryptomeria japonica (Japanese Cedar).
//  Independent botanical species in Cupressaceae. Knowledge status: Reviewed.
//  Separate from Cedrus and other Cupressaceae species.
//

import Foundation

enum CryptomeriaJaponicaSpeciesProfile {
    /// Identity used by Botanical Library / ``SpeciesPreviewData``.
    static let botanicalLibraryName = "Cryptomeria japonica"
    /// Scientific name for Species Profile display (binomial; no botanical authority).
    static let scientificName = "Cryptomeria japonica"

    static var profile: SpeciesProfile {
        SpeciesProfile(
            speciesID: BotanicalKnowledgeIDs.cryptomeriaJaponica,
            scientificName: scientificName,
            commonNames: ["Japanese Cedar", "Japanese Cryptomeria", "Sugi"],
            family: "Cupressaceae",
            plantType: "Conifer",
            originSummary: "Japan.",
            knowledgeStatus: .reviewed,
            traits: traits,
            foliageSizeLabel: "Foliage",
            foliageReductionLabel: "Leaf reduction",
            summaryLine: "Evergreen · Conifer · Japanese species · Fine textured foliage · Strong vertical growth · Attractive fibrous bark · Good ramification potential · Long-lived · Suitable for refined and naturalistic bonsai",
            attentionHighlights: [
                "Cryptomeria japonica is a conifer",
                "Common name Japanese Cedar does not mean it belongs to Cedrus",
                "Requires winter dormancy",
                "Outdoor cultivation is required",
                "Fine textured foliage is a defining feature",
                "Preserve useful interior foliage",
                "Do not assume bare old wood will reliably produce new growth",
                "Avoid repeated severe drying",
                "Avoid permanently stagnant roots",
                "Do not use uniform hedge-like shearing as the primary refinement method",
                "Young branches are generally easier to wire than older branches",
                "Avoid forcing rigid branches",
                "Mature fibrous bark develops naturally with age",
                "Do not artificially damage healthy bark",
                "Shallow bonsai roots require protection during prolonged severe freezing",
                "Respect the species' distinctive Japanese conifer character",
            ],
            sections: sections,
            principleNote: """
            Cryptomeria japonica should be developed as a conifer with respect for its distinctive natural character.

            Important visual characteristics include upright growth, fine textured foliage, soft visual foliage masses, reddish to brown fibrous bark with age and strong trunk presence in mature material.

            Avoid styling Cryptomeria as though it were a Juniperus species, a Pinus species or a generic scale-foliage conifer.

            The objective is: Natural conifer structure · Healthy foliage · Clear trunk line · Progressive ramification · Mature bark character.

            The individual tree must always be assessed according to climate, tree condition, vigour, development stage and winter temperatures.
            """,
            sourcesNote: """
            Profile content is synthesised from recognised botanical, horticultural and bonsai authorities into Bonsai World editorial language.

            Botanical taxonomy and distribution draw on recognised sources such as Royal Botanic Gardens, Kew and other botanical databases for accepted scientific name, family and native range.

            Horticultural context may draw on recognised Japanese botanical and forestry institutions, horticultural institutions and authoritative Cryptomeria references.

            Bonsai-specific cultivation and refinement knowledge draws on established bonsai references and recognised professional practice with Cryptomeria experience, kept distinct from Cedrus and other Cupressaceae species.

            Verified botanical information, horticultural information, regional climate adaptation and bonsai-specific practice are kept distinct. Do not copy source wording.
            """
        )
    }

    private static let traits = SpeciesProfileTraits(
        deciduous: false,
        growthStrength: "Moderate to Strong",
        growthSpeed: "Moderate",
        leafSize: "Evergreen conifer · Awl-shaped foliage arranged densely around the shoots",
        foliageReduction: "Not applicable",
        ramificationPotential: "Good",
        backBudding: "Moderate to Good",
        rootDevelopment: "Good",
        nebariPotential: "Good potential",
        trunkDevelopment: "Moderate",
        barkDevelopment: "Excellent mature character",
        wiring: "Good",
        defoliation: "Not applicable",
        airLayering: "Where appropriate for the individual material",
        threadGrafting: "Where structural correction is required",
        rootGrafting: "Where appropriate",
        beginnerSuitability: "Moderate",
        bonsaiSuitability: "Good",
        difficulty: "Intermediate",
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
                    "Cryptomeria japonica is an independent botanical species in the cypress family (Cupressaceae).",
                    "Primary Bonsai World display identity: Cryptomeria japonica · Japanese Cedar.",
                    "Japanese Cryptomeria and Sugi may be used as supporting terminology. They do not replace Japanese Cedar as the preferred English common name.",
                    "Family: Cupressaceae. Plant type: conifer.",
                    "Native range: Japan.",
                    "Despite its common English name, Japanese Cedar, it is not a true cedar and should not be confused with species in the genus Cedrus.",
                    "Do not confuse Cryptomeria japonica with Cedrus species.",
                    "Bonsai World hierarchy: Species → cultivar / horticultural selection → Individual Tree.",
                ]
            ),
            SpeciesProfileSection(
                id: "overview",
                title: "Species Overview",
                paragraphs: [
                    "Cryptomeria japonica is Japan's national tree and an important evergreen conifer in Japanese forestry, horticulture and bonsai.",
                    "Cryptomeria japonica is particularly relevant to Bonsai World because it is one of Japan's most important native conifers, an established bonsai species, botanically and visually distinct from true cedars, capable of developing attractive mature bark and well suited to long-term bonsai development.",
                    "For bonsai, Cryptomeria japonica is valued for fine foliage texture, elegant vertical structure, mature fibrous bark, strong Japanese landscape character and potential for dense, controlled ramification.",
                    "The species can be developed as both formal, refined bonsai and naturalistic conifer bonsai.",
                    "The individual material should determine the final design.",
                ],
                bullets: [
                    "Evergreen",
                    "Conifer",
                    "Japanese species",
                    "Fine textured foliage",
                    "Requires winter dormancy",
                    "Outdoor cultivation required",
                    "Moderate growth",
                    "Good ramification potential",
                    "Moderate to good back-budding",
                    "Attractive mature bark",
                    "Strong long-term development potential",
                    "Produces cones",
                    "Suitable for refined and naturalistic bonsai",
                ]
            ),
            SpeciesProfileSection(
                id: "cultivars",
                title: "Cultivars and Forms",
                paragraphs: [
                    "Cryptomeria japonica is primarily used in bonsai as the botanical species.",
                    "Horticultural cultivars may differ in foliage density, growth habit and branch character.",
                    "Do not create unnecessary separate Species Library profiles for minor individual variation.",
                    "The primary Species Profile remains Cryptomeria japonica.",
                    "Only create separate profiles where a distinct cultivar or form has a clear and established independent bonsai identity.",
                ]
            ),
            SpeciesProfileSection(
                id: "natural-growth",
                title: "Natural Growth and Vigour",
                paragraphs: [
                    "Cryptomeria japonica can grow steadily when roots are healthy, moisture is appropriately managed, light is sufficient, temperatures are favourable and root space is available.",
                    "During structural development: allow selected growth to extend where trunk thickness is required, taper is required or branches require development.",
                    "During refinement: control excessive extension, coarse growth, congested foliage and loss of interior structure.",
                    "Do not suppress useful vigorous growth prematurely.",
                    "The objective is: Healthy development · Clear structure · Controlled refinement.",
                ]
            ),
            SpeciesProfileSection(
                id: "foliage",
                title: "Foliage",
                paragraphs: [
                    "Cryptomeria japonica has distinctive awl-shaped foliage arranged densely around the shoots.",
                    "The foliage should be managed to preserve healthy interior growth, balanced vigour, useful branch structure and clear foliage masses.",
                    "Avoid repeated hard clipping into old bare areas, removing all useful interior foliage and treating foliage management as generic hedge trimming.",
                    "The objective is: Healthy foliage · Progressive ramification · Visible branch structure.",
                ]
            ),
            SpeciesProfileSection(
                id: "flowering",
                title: "Flowering",
                paragraphs: [
                    "Flowering is not applicable for Cryptomeria japonica as a bonsai design feature.",
                    "Do not treat flowering as a styling priority.",
                ]
            ),
            SpeciesProfileSection(
                id: "fruit",
                title: "Cones",
                paragraphs: [
                    "Cryptomeria japonica produces cones.",
                    "Cones may form part of the species' natural character but are not a primary bonsai design objective.",
                    "Do not sacrifice structural development or ramification in pursuit of cone production.",
                ]
            ),
            SpeciesProfileSection(
                id: "bark-trunk",
                title: "Bark and Trunk",
                paragraphs: [
                    "Mature Cryptomeria japonica can develop attractive fibrous bark. Mature bark character is excellent.",
                    "Trunk development should focus on sufficient thickness, believable taper, natural movement and mature proportions.",
                    "Bark character should develop naturally.",
                    "Do not artificially damage healthy bark to simulate age.",
                    "The objective is: Natural maturity · Strong trunk character · Healthy bark.",
                ]
            ),
            SpeciesProfileSection(
                id: "roots-nebari",
                title: "Roots and Nebari",
                paragraphs: [
                    "Healthy roots support foliage health, recovery, trunk development, branch development and long-term container cultivation.",
                    "Root development is good. Objectives include balanced roots, stable anchoring, gradual radial development and progressive nebari improvement.",
                    "Avoid unnecessary aggressive root reduction.",
                    "The objective is: Healthy roots · Stable growth · Long-term development.",
                ]
            ),
            SpeciesProfileSection(
                id: "light",
                title: "Light",
                paragraphs: [
                    "Cryptomeria japonica should be cultivated outdoors with good access to light.",
                    "Adequate light supports healthy foliage, compact growth, interior branch development and balanced vigour.",
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
                    "Strong or drying wind can increase water demand, stress foliage, dry shallow containers and increase winter exposure.",
                    "Monitor carefully during warm dry wind, prolonged dry periods and exposed winter conditions.",
                ]
            ),
            SpeciesProfileSection(
                id: "watering",
                title: "Watering",
                paragraphs: [
                    "General principle: Maintain reliable moisture · Avoid repeated severe drying · Avoid permanently stagnant conditions · Maintain healthy root aeration.",
                    "Water demand is moderate.",
                    "Water demand depends on temperature, sunlight, wind, foliage mass, container size, substrate and root mass.",
                    "Do not water according to a fixed timetable.",
                    "The objective is: Consistent healthy moisture · Healthy roots · Stable vigour.",
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
                    "Fertilization should support healthy foliage, trunk development, branch development, ramification and recovery.",
                    "During structural development: support healthy growth where development is required.",
                    "During refinement: avoid excessive feeding that produces overly coarse extension, excessively vigorous outer growth or loss of compact structure.",
                    "Key principle: Feed according to tree health and development objective.",
                ]
            ),
            SpeciesProfileSection(
                id: "pruning",
                title: "Pruning",
                paragraphs: [
                    "Pruning can be used for structural development, branch selection, branch replacement, foliage management and silhouette refinement. Pruning response is good with species-specific considerations.",
                    "Before heavy pruning assess branch age, foliage distribution, available replacement growth and tree vigour.",
                    "Avoid cutting back blindly into old bare wood.",
                    "The objective is: Purposeful development · Healthy interior growth · Controlled refinement.",
                ]
            ),
            SpeciesProfileSection(
                id: "back-budding",
                title: "Back-budding",
                paragraphs: [
                    "Cryptomeria japonica can produce useful new growth, but response depends on tree health, vigour, branch age, available foliage, light penetration and pruning strategy. Back-budding is moderate to good.",
                    "Do not assume that completely bare old wood will reliably produce new growth.",
                    "When pruning: preserve useful interior foliage, retain possible replacement shoots and avoid unnecessarily stripping branches.",
                    "The objective is: Controlled renewal · Preservation of useful growth · Gradual refinement.",
                ]
            ),
            SpeciesProfileSection(
                id: "ramification",
                title: "Ramification",
                paragraphs: [
                    "Ramification should be developed through repeated healthy growth cycles, selective pruning, shoot selection, branch selection and preservation of interior growth. Ramification potential is good.",
                    "Avoid uniform shearing, dense outer foliage with empty interiors and repeated removal of useful inner shoots.",
                    "The objective is: Natural branch hierarchy · Healthy interior growth · Controlled foliage masses.",
                ]
            ),
            SpeciesProfileSection(
                id: "wiring",
                title: "Wiring",
                paragraphs: [
                    "Young branches are generally easier to position. Wiring response is good.",
                    "Wiring can be used for branch direction, structural placement and refinement of young growth.",
                    "Before major bends assess branch thickness, flexibility, age, health and structural importance.",
                    "Monitor wire carefully.",
                    "Avoid damaging the bark.",
                    "Avoid forcing rigid branches.",
                    "Pruning and directional growth should be considered alongside wiring.",
                ]
            ),
            SpeciesProfileSection(
                id: "deadwood-potential",
                title: "Deadwood",
                paragraphs: [
                    "Natural deadwood may occasionally contribute to mature conifer character. Deadwood potential is moderate.",
                    "However, deadwood should be justified by the individual tree, excessive artificial jin or shari should be avoided and natural structure should remain the priority.",
                    "The objective is: Species-appropriate age · Natural character · Believable structure.",
                ]
            ),
            SpeciesProfileSection(
                id: "defoliation",
                title: "Foliage Management",
                paragraphs: [
                    "Deciduous-style defoliation is not applicable.",
                    "Foliage management should focus on shoot selection, selective pruning, branch selection, vigour management and preservation of useful interior foliage.",
                    "Avoid excessive stripping, repeated uniform shearing and removing all useful interior growth.",
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
                    "Cryptomeria japonica should be allowed sufficient growth during the structural development phase.",
                    "Where additional thickness is required: allow selected leaders to extend, provide sufficient root space, use development containers where appropriate and avoid premature refinement.",
                    "Leader development should support taper, trunk thickness, natural movement and believable proportions.",
                    "Once sufficient trunk development has been achieved, shift focus toward branch hierarchy, foliage refinement, ramification and mature bark.",
                ]
            ),
            SpeciesProfileSection(
                id: "nebari-development",
                title: "Nebari Development",
                paragraphs: [
                    "Nebari should be developed gradually.",
                    "Potential approaches include early root selection, radial root planning, staged correction, suitable development containers and gradual refinement.",
                    "The objective is a stable and visually convincing base appropriate to a mature conifer.",
                ]
            ),
            SpeciesProfileSection(
                id: "propagation",
                title: "Propagation",
                paragraphs: [
                    "Cryptomeria japonica may be propagated using established horticultural methods including seed, cuttings and selected vegetative propagation methods.",
                    "Seed-grown material may offer genetic variation, early root planning and natural trunk development opportunities.",
                    "Detailed procedures belong in Bonsai World Propagation Knowledge Articles.",
                ]
            ),
            SpeciesProfileSection(
                id: "pests",
                title: "Pests and Problems",
                paragraphs: [
                    "Relevant risks may include scale insects, spider mites, foliage diseases, fungal problems, root problems caused by poor substrate aeration, drought stress and winter damage in exposed containers.",
                    "Do not provide generic treatment instructions.",
                    "Diagnosis and treatment belong in Care → Pest Management and Care → Disease & Problems.",
                ]
            ),
            SpeciesProfileSection(
                id: "seasonal",
                title: "Seasonal Profile",
                paragraphs: [
                    "Spring: monitor new growth, foliage health, watering demand, vigour and structural priorities. Spring is important for evaluating branch development, ramification, root health and recovery from winter. Coordinate major work with local climate and individual tree condition.",
                    "Summer: monitor watering demand, foliage health, shoot extension, pest activity and wire marks. Strong growth should be managed according to whether shoots are required for trunk development, branch development or refinement. Do not suppress useful vigorous growth unnecessarily.",
                    "Autumn is important for evaluating foliage health, reviewing branch structure, assessing growth and preparing for winter. Local climate and tree condition determine timing. Do not apply one universal autumn schedule.",
                    "Winter: Cryptomeria japonica requires winter dormancy.",
                    "Winter management depends on local minimum temperatures, duration of freezing, wind exposure, container depth, root protection and tree health.",
                    "Shallow bonsai roots are more exposed to severe cold than roots growing in open ground.",
                    "Protect the root system when required. Do not maintain indoors as a substitute for winter dormancy.",
                ]
            ),
            SpeciesProfileSection(
                id: "styles",
                title: "Bonsai Styles",
                paragraphs: [
                    "Cryptomeria japonica is particularly suitable for Formal Upright, Informal Upright, Slanting, Multi-trunk, Clump Style, Naturalistic Bonsai and Forest Style.",
                    "It is especially effective when styling emphasises vertical structure, clear trunk lines, natural foliage masses, mature bark and species-appropriate branching.",
                    "The individual material should determine the final design.",
                ]
            ),
            SpeciesProfileSection(
                id: "tree-stage",
                title: "Development by Tree Stage",
                paragraphs: [
                    "Young material: establish healthy roots, develop trunk thickness, establish movement where appropriate and begin structural development.",
                    "Nursery material: evaluate trunk potential, identify useful branches, establish design direction and begin structural correction.",
                    "Pre-bonsai: develop trunk, establish primary branches, improve root structure, build taper and build vigour.",
                    "In training: develop secondary branches, improve branch hierarchy, build ramification and preserve useful interior foliage.",
                    "Refinement: maintain balanced vigour, improve branch structure, control excessive extension, preserve interior foliage and maintain visible structure.",
                    "Exhibition / mature refined tree: maintain health, preserve established structure, maintain balanced foliage masses, preserve mature bark character and avoid unnecessary major intervention.",
                ]
            ),
            SpeciesProfileSection(
                id: "attention",
                title: "Species-Specific Attention",
                paragraphs: [
                    "These attention points are operational tendencies. They must still be interpreted for the individual tree.",
                ],
                bullets: [
                    "Cryptomeria japonica is a conifer",
                    "Common name Japanese Cedar does not mean it belongs to Cedrus",
                    "Requires winter dormancy",
                    "Outdoor cultivation is required",
                    "Fine textured foliage is a defining feature",
                    "Preserve useful interior foliage",
                    "Do not assume bare old wood will reliably produce new growth",
                    "Avoid repeated severe drying",
                    "Avoid permanently stagnant roots",
                    "Do not use uniform hedge-like shearing as the primary refinement method",
                    "Young branches are generally easier to wire than older branches",
                    "Avoid forcing rigid branches",
                    "Mature fibrous bark develops naturally with age",
                    "Do not artificially damage healthy bark",
                    "Shallow bonsai roots require protection during prolonged severe freezing",
                    "Respect the species' distinctive Japanese conifer character",
                ]
            ),
        ]
    }
}
