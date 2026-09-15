//
//  AcerCampestreSpeciesProfile.swift
//  Bonsai World
//
//  Species Profile — Acer campestre L. (Field Maple).
//  Botanical verification + bonsai knowledge + cultivar architecture pass.
//  Knowledge status: Reviewed.
//

import Foundation

enum AcerCampestreSpeciesProfile {
    /// Binomial used by Botanical Library / ``SpeciesPreviewData``.
    static let botanicalLibraryName = "Acer campestre"
    /// Scientific name for Species Profile display (binomial; authorship in taxonomic sections).
    static let scientificName = "Acer campestre"

    static var profile: SpeciesProfile {
        SpeciesProfile(
            speciesID: BotanicalKnowledgeIDs.acerCampestre,
            scientificName: scientificName,
            commonNames: ["Field Maple"],
            family: "Sapindaceae",
            plantType: "Deciduous tree",
            originSummary: "Europe to Iran, Northern Algeria",
            knowledgeStatus: .reviewed,
            traits: traits,
            summaryLine: "Deciduous · Moderate to strong growth · Excellent bonsai suitability",
            attentionHighlights: [
                "Strong development potential — direct growth rather than automatically suppressing it",
                "High back-budding potential — still not guaranteed",
                "High ramification potential — preserve branch clarity and proportion",
                "Trunk development may benefit from sacrifice growth",
                "Bark character increases with age",
                "Nebari development should be managed intentionally",
                "Do not treat the species as indestructible",
                "Root condition remains important despite adaptability",
                "Individual tree condition remains the final decision layer",
            ],
            sections: sections,
            principleNote: """
            Acer campestre is one of the strongest European deciduous species for bonsai development.

            Its major strengths include strong structural development potential, good response to pruning, high ramification potential, useful back-budding potential, strong root development, good nebari potential, naturally suitable leaf proportions, increasing bark character with age and good adaptation to temperate climates.

            However, the species should not be treated as indestructible.

            Its tolerance depends on individual health, root condition, recent work, climate, container and development stage.

            The species profile provides the baseline.

            The individual tree determines the operational decision.
            """,
            sourcesNote: """
            Profile content is synthesised from recognised botanical, horticultural and bonsai authorities into Bonsai World editorial language.

            Botanical taxonomy and distribution — Royal Botanic Gardens, Kew (Plants of the World Online) for accepted scientific name, family, native range and accepted infraspecific taxa.

            Horticultural information — Royal Horticultural Society; recognised botanical gardens and arboreta; university horticultural collections; established tree reference resources for cultivar identity, growth habit, leaf characteristics and seasonal characteristics.

            Bonsai-specific information — established bonsai organisations, recognised bonsai professionals, specialist bonsai publications and long-standing educational resources.

            Bonsai World synthesises verified information into its own language, terminology, data model and operational philosophy. Do not copy external source wording.
            """
        )
    }

    /// Quick Reference — Bonsai World assessments for the species baseline (not universal measurements).
    private static let traits = SpeciesProfileTraits(
        deciduous: true,
        growthStrength: "Moderate to Strong",
        growthSpeed: "Moderate to Strong",
        leafSize: "Small to Medium",
        foliageReduction: "Good potential — naturally suitable proportions",
        ramificationPotential: "High potential",
        backBudding: "High potential",
        rootDevelopment: "Strong",
        nebariPotential: "High development potential",
        trunkDevelopment: "Strong potential",
        barkDevelopment: "High age-character potential",
        wiring: "Suitable",
        defoliation: "Selective — healthy established trees only",
        airLayering: "Suitable",
        threadGrafting: "Suitable",
        rootGrafting: "Suitable",
        beginnerSuitability: "High",
        bonsaiSuitability: "Excellent",
        difficulty: "Beginner to Intermediate",
        winterDormancyRequired: true,
        winterHardiness: "High",
        rootFrostSensitivity: "Moderate in shallow containers"
    )

    private static var sections: [SpeciesProfileSection] {
        [
            SpeciesProfileSection(
                id: "taxonomic-context",
                title: "Taxonomic Context",
                paragraphs: [
                    "Acer campestre L. contains recognised infraspecific botanical variation.",
                    "Do not confuse species, botanical subspecies, cultivars and nursery selections — these are different classification layers.",
                    "Bonsai World hierarchy: Species → botanical infraspecific variation where relevant → cultivar / horticultural selection → Individual Tree.",
                    "The Individual Tree should always store the most precise verified identity available.",
                    "Example: Species Acer campestre; Cultivar 'Elsrijk'; Individual tree ACM ELS 2026 001.",
                    "Do not automatically assign a cultivar where the tree is only identified as Acer campestre.",
                ]
            ),
            SpeciesProfileSection(
                id: "overview",
                title: "Species Overview",
                paragraphs: [
                    "Acer campestre L., commonly known as Field Maple, is a deciduous maple in the Sapindaceae family.",
                    "It is native across a broad area from Europe to Iran and Northern Algeria.",
                    "In its natural growth form it is a medium-sized tree and a highly adaptable temperate species.",
                    "It is one of the strongest European maple species for bonsai development.",
                    "Major bonsai strengths include good trunk development, strong branch development, high ramification potential, useful back-budding, good nebari development potential, naturally suitable foliage proportions and increasing bark character with age.",
                    "Acer campestre is particularly suitable where the goal is mature deciduous character, powerful trunk development, natural bark character, dense ramification and strong nebari.",
                    "Do not describe the species as a European substitute for Acer palmatum. The aesthetic character is fundamentally different.",
                ],
                bullets: [
                    "Deciduous maple (Sapindaceae)",
                    "Native: Europe to Iran, Northern Algeria",
                    "Strong European bonsai development species",
                    "High ramification and back-budding potential",
                    "Strong root and nebari potential",
                    "Bark character increases with age",
                    "Not an Acer palmatum substitute",
                ]
            ),
            SpeciesProfileSection(
                id: "natural-growth",
                title: "Natural Growth",
                paragraphs: [
                    "Acer campestre can develop strong growth under favourable conditions.",
                    "Growth may support trunk development, primary branch development, sacrifice branch development and structural rebuilding.",
                    "During development: allow selected growth where thickness is required. During refinement: control extension where structure and proportion are established.",
                    "Grow where development is required. Control where refinement is required.",
                    "Do not over-prune development material. Repeated cutting can slow trunk development, branch thickening and structural progress.",
                ]
            ),
            SpeciesProfileSection(
                id: "leaves",
                title: "Leaves",
                paragraphs: [
                    "Acer campestre typically produces palmately lobed leaves.",
                    "The leaves are generally smaller than many broad-leaved deciduous bonsai species, suitable for a wide range of bonsai sizes, and naturally capable of developing good visual proportion.",
                    "Leaf characteristics can vary according to individual genetics, growing conditions, vigor, shoot management and cultivar.",
                    "Do not promise a fixed final leaf size. Leaf reduction and visual proportion depend on ramification, shoot management, tree vigor, root condition, container and development stage.",
                    "The objective is visual proportion — not simply the smallest possible leaf.",
                ]
            ),
            SpeciesProfileSection(
                id: "flowers-seeds",
                title: "Flowers & Seeds",
                paragraphs: [
                    "Acer campestre produces small greenish flowers in spring, followed by typical winged maple fruits.",
                    "Flowering and fruiting are not normally the primary bonsai feature.",
                    "Seed-grown offspring naturally contain genetic variation. Seed propagation must not be assumed to reproduce named cultivar characteristics.",
                    "Named cultivars require appropriate vegetative propagation to maintain cultivar identity.",
                ]
            ),
            SpeciesProfileSection(
                id: "bark-trunk",
                title: "Bark & Trunk",
                paragraphs: [
                    "Young Acer campestre bark is relatively smooth. With age, the bark develops increasing visual character.",
                    "Do not promise identical bark development on every tree. Bark character depends on age, genetics, growing conditions and development history.",
                    "Mature aesthetic potential includes increasing bark texture, strong trunk proportions, natural trunk movement and mature deciduous appearance.",
                    "This distinguishes Acer campestre from Acer palmatum and Acer japonicum. The species can support a more rugged and mature visual expression.",
                ]
            ),
            SpeciesProfileSection(
                id: "roots-nebari",
                title: "Roots & Nebari",
                paragraphs: [
                    "Acer campestre has strong potential for root development. It is particularly valuable for bonsai where nebari development is an important design objective.",
                    "Potential methods include root selection, radial root positioning, controlled root pruning, development containers, ground development and root grafting where appropriate.",
                    "Do not describe nebari as automatic. The objective is a balanced radial root base with a convincing transition into the trunk.",
                    "Root work must remain proportional to tree health, root mass, development stage and recovery capacity.",
                ]
            ),
            SpeciesProfileSection(
                id: "light",
                title: "Light",
                paragraphs: [
                    "Acer campestre is generally adaptable to bright growing conditions. Healthy established trees may tolerate substantial light.",
                    "Light tolerance must still be considered together with temperature, root moisture, wind, container size and tree health.",
                    "Do not use full sun as an unconditional operational instruction.",
                    "Provide the strongest appropriate light for the individual tree and environment while monitoring foliage response and water demand.",
                ]
            ),
            SpeciesProfileSection(
                id: "wind",
                title: "Wind",
                paragraphs: [
                    "Acer campestre can tolerate exposed conditions relatively well compared with some more delicate maple species.",
                    "However, wind still increases transpiration, water demand and environmental stress.",
                    "Do not describe the species as immune to drying conditions.",
                    "The operational concern is always environmental demand versus root capacity and available moisture.",
                ]
            ),
            SpeciesProfileSection(
                id: "watering",
                title: "Watering",
                paragraphs: [
                    "Maintain appropriate moisture while preserving adequate oxygen around the roots.",
                    "Water demand depends on temperature, wind, rainfall, leaf mass, container, substrate, root development and tree health.",
                    "Avoid chronic waterlogging and repeated severe drying during active growth.",
                    "Do not use fixed watering schedules. Water according to the condition of the tree and substrate, not according to the clock.",
                ]
            ),
            SpeciesProfileSection(
                id: "soil",
                title: "Soil",
                paragraphs: [
                    "Do not prescribe one universal Acer campestre soil recipe.",
                    "The substrate should provide drainage, aeration, appropriate moisture retention and stable structure.",
                    "The final mix depends on climate, rainfall, watering frequency, container size, tree stage, root density and local environment.",
                    "Acer campestre may be adaptable to a range of soil conditions in the landscape. However, bonsai substrate requirements are more specific.",
                    "Do not directly translate landscape soil tolerance into a bonsai soil recipe.",
                    "Bonsai World should later generate soil recommendations from species, cultivar, tree stage, climate and growing environment.",
                ]
            ),
            SpeciesProfileSection(
                id: "fertilizing",
                title: "Fertilizing",
                paragraphs: [
                    "Feed the tree you are growing, not simply the species you have.",
                    "Nutrition depends on health, current vigor, development stage, root condition, season and desired development.",
                    "During development, nutrition may support trunk thickening, branch development and structural growth.",
                    "During refinement, avoid unnecessary coarse extension.",
                    "Do not intentionally weaken the tree simply to reduce leaf size.",
                ]
            ),
            SpeciesProfileSection(
                id: "pruning",
                title: "Pruning",
                paragraphs: [
                    "Development pruning: allow selected growth where required for trunk development, primary branches and structural rebuilding. Use sacrifice growth where appropriate. Do not repeatedly cut areas that still require thickness.",
                    "Refinement pruning: control extension where required for ramification, branch proportion, silhouette and internode management.",
                    "Do not use a universal cut-back-to-two-leaves rule.",
                    "Pruning decisions depend on tree vigor, branch position, development stage, desired thickness and existing branch structure.",
                ]
            ),
            SpeciesProfileSection(
                id: "back-budding",
                title: "Back-Budding",
                paragraphs: [
                    "Acer campestre generally has strong back-budding potential. This is one of its major bonsai strengths.",
                    "Do not present back-budding as guaranteed. Response depends on tree health, branch age, available vigor, light, season, root condition and previous pruning.",
                    "The species may provide useful opportunities for structural rebuilding, branch replacement and ramification development.",
                    "Do not remove critical branches solely because new buds are expected.",
                ]
            ),
            SpeciesProfileSection(
                id: "ramification",
                title: "Ramification",
                paragraphs: [
                    "Acer campestre has high potential for refined deciduous ramification. This is a major bonsai strength.",
                    "Successful refinement depends on controlled extension, correct pruning timing, light distribution, branch health and appropriate vigor management.",
                    "The objective is branch hierarchy, appropriate taper, fine secondary branching, controlled internodes and a convincing silhouette.",
                    "Do not pursue maximum branch density at the expense of branch clarity, proportion and natural structure.",
                ]
            ),
            SpeciesProfileSection(
                id: "wiring",
                title: "Wiring",
                paragraphs: [
                    "Wiring is suitable. Younger branches are generally easier to position. Older branches become increasingly rigid.",
                    "Potential risks include bark damage, wire marks, branch breakage and rapid branch thickening.",
                    "Do not use fixed wire removal schedules. Monitor the actual branch.",
                    "Remove wire according to thickening, bark response and position stability.",
                ]
            ),
            SpeciesProfileSection(
                id: "defoliation",
                title: "Defoliation",
                paragraphs: [
                    "Defoliation may be used selectively on healthy established trees where appropriate.",
                    "Potential objectives may include vigor balancing, light penetration, ramification management and leaf proportion management.",
                    "Do not present complete annual defoliation as standard practice.",
                    "Do not defoliate weak trees, recently repotted trees or recovering trees.",
                    "Selective approaches may be preferable depending on development stage, tree vigor and individual objective. Tree health is more important than leaf reduction.",
                ]
            ),
            SpeciesProfileSection(
                id: "repotting",
                title: "Repotting",
                paragraphs: [
                    "Repotting decisions depend on root development, substrate condition, container, tree health, development stage and climate.",
                    "Do not use fixed repotting intervals.",
                    "A development tree may require a different strategy from a refined tree.",
                    "Avoid unnecessary aggressive root reduction.",
                    "Species tolerance does not replace assessment of the individual root system.",
                ]
            ),
            SpeciesProfileSection(
                id: "trunk-development",
                title: "Trunk Development",
                paragraphs: [
                    "Acer campestre has strong potential for trunk development.",
                    "Potential methods include ground development, large development containers, sacrifice branches, strategic trunk cuts and controlled unrestricted growth.",
                    "Development should aim for taper, movement, proportion and natural transition.",
                    "Do not simply maximise trunk thickness. A powerful bonsai trunk requires controlled structure.",
                ]
            ),
            SpeciesProfileSection(
                id: "nebari-development",
                title: "Nebari Development",
                paragraphs: [
                    "Acer campestre should be identified as having high nebari development potential.",
                    "Potential methods include root selection, radial root positioning, controlled root pruning, ground development, development containers and root grafting where appropriate.",
                    "The existing root structure determines the correct strategy.",
                    "The objective is a convincing and balanced root base.",
                ]
            ),
            SpeciesProfileSection(
                id: "grafting",
                title: "Grafting",
                paragraphs: [
                    "Relevant techniques include approach grafting, thread grafting and root grafting.",
                    "Common bonsai use cases include adding missing branches, improving root structure and correcting structural limitations.",
                    "Do not present grafting as default.",
                    "All work must be recorded in Shaping History.",
                ]
            ),
            SpeciesProfileSection(
                id: "air-layering",
                title: "Air Layering",
                paragraphs: [
                    "Air layering may be useful for creating new bonsai material, separating desirable trunk sections, correcting overly long material and creating independent trees from suitable branches.",
                    "Success depends on timing, tree health, technique and aftercare.",
                    "Detailed procedures belong in Propagation Knowledge Articles.",
                ]
            ),
            SpeciesProfileSection(
                id: "propagation",
                title: "Propagation",
                paragraphs: [
                    "Potential methods include seed, cuttings where appropriate, air layering and grafting.",
                    "Do not assume all methods are equally appropriate for every cultivar.",
                    "Seed-grown offspring must not automatically inherit a cultivar name. Named cultivar identity requires appropriate vegetative propagation.",
                ]
            ),
            SpeciesProfileSection(
                id: "pests",
                title: "Pests & Problems",
                paragraphs: [
                    "Potential issues may include aphids, mites, scale insects, caterpillars, gall mites, tar spot, Verticillium wilt and root problems associated with unsuitable moisture.",
                    "Do not use this section as a diagnostic system.",
                    "Diagnosis and treatment belong in Care → Pest & Problem Management. The Species Profile should link to relevant problem knowledge.",
                ]
            ),
            SpeciesProfileSection(
                id: "seasonal",
                title: "Seasonal Profile",
                paragraphs: [
                    "Spring: monitor bud break, rapid growth, water demand, structural pruning opportunities, wiring and fertilizing decisions.",
                    "Summer: monitor strong extension, water demand, wire marks, shoot management and vigor balancing.",
                    "Autumn: monitor leaf colour, reduced growth, changing water demand and preparation for dormancy.",
                    "Winter: dormancy is required. Monitor root exposure, prolonged severe freezing, container size and root condition.",
                    "Do not use one universal temperature threshold. Local climate and individual conditions determine protection requirements.",
                ]
            ),
            SpeciesProfileSection(
                id: "styles",
                title: "Bonsai Styles",
                paragraphs: [
                    "Acer campestre is highly versatile.",
                    "Suitable forms may include informal upright, formal upright where material supports it, twin trunk, multiple trunk, clump, broom style, root-over-rock, medium bonsai and large bonsai.",
                    "Smaller bonsai may also be possible where material and leaf proportion support the scale.",
                    "Do not force every tree into the same style. The individual material determines the design.",
                ]
            ),
            SpeciesProfileSection(
                id: "tree-stage",
                title: "Development by Tree Stage",
                paragraphs: [
                    "Seedling: establish healthy roots, early trunk direction and root structure.",
                    "Nursery Stock: develop nebari, trunk and primary branches.",
                    "Pre-bonsai: establish trunk line, taper, primary branches and structural direction.",
                    "In Training: continue structural development while beginning controlled ramification.",
                    "Refinement: focus on branch hierarchy, fine ramification, leaf proportion and mature silhouette.",
                    "Exhibition: maintain health, ramification and seasonal quality. Avoid unnecessary major work.",
                ]
            ),
            SpeciesProfileSection(
                id: "attention",
                title: "Species-Specific Attention",
                paragraphs: [
                    "These are tendencies. They are not automatic warnings.",
                ],
                bullets: [
                    "Acer campestre has strong development potential",
                    "Back-budding potential is generally high",
                    "Ramification potential is generally high",
                    "Trunk development may benefit from sacrifice growth",
                    "Bark character increases with age",
                    "Nebari development should be managed intentionally",
                    "Strong growth should be directed rather than automatically suppressed",
                    "The species should not be treated as indestructible",
                    "Root condition remains important despite the species' adaptability",
                    "Individual tree condition remains the final decision layer",
                ]
            ),
            SpeciesProfileSection(
                id: "cultivars-intro",
                title: "Cultivars",
                paragraphs: [
                    "This is a curated Bonsai World Cultivar Collection — not a complete nursery catalogue.",
                    "Cultivars should only be included where they have clear horticultural identity, reliable documentation, distinct characteristics and potential relevance to bonsai.",
                    "Species baseline → cultivar modifier → individual tree. Cultivar information must never overwrite individual tree observations.",
                    "For Acer campestre, the straight species may often provide greater bonsai development value than ornamental landscape cultivars.",
                    "A tree with strong nebari, interesting trunk, good taper, strong branch structure and useful leaf proportion may have greater bonsai potential than a named cultivar selected primarily for ornamental landscaping.",
                    "Cultivar identity is an additional knowledge layer — not an automatic quality rating.",
                    "Possible category filters: Compact Growth, Variegated Foliage, Structural Growth, Landscape Selections, Specialist Cultivars. Categories must not replace actual cultivar identity.",
                ]
            ),
            SpeciesProfileSection(
                id: "cultivar-elsrijk",
                title: "Acer campestre 'Elsrijk'",
                paragraphs: [
                    "Growth habit: dense growth habit with neat crown structure and a strong upright or conical tendency (verify retained horticultural sources).",
                    "Growth strength: further cultivar verification required relative to the straight species.",
                    "Leaf characteristics: green foliage; yellow autumn colour commonly reported.",
                    "Seasonal characteristics: yellow autumn colour.",
                    "Ramification potential: further cultivar verification required for internode behaviour and branch density.",
                    "Development suitability: evaluate carefully — landscape popularity does not automatically mean superior bonsai material.",
                    "Refinement suitability: further cultivar verification required.",
                    "Known bonsai strengths: structural growth habit may be of interest; verify before operational inheritance.",
                    "Potential challenges: do not assume landscape popularity equals bonsai superiority. Evaluate internode behaviour, branch density, leaf proportion and development suitability.",
                    "Important differences from the straight species: denser / neater structural habit in landscape use; bonsai-specific differences require verification.",
                    "Verification status: curated priority cultivar.",
                    "Further cultivar verification required for internode behaviour, branch density, leaf proportion and development suitability.",
                ]
            ),
            SpeciesProfileSection(
                id: "cultivar-carnival",
                title: "Acer campestre 'Carnival'",
                paragraphs: [
                    "Potential distinguishing characteristics may include variegated foliage — verify carefully with retained sources.",
                    "Growth habit / growth strength: further cultivar verification required.",
                    "Leaf characteristics: variegation may be present; verify.",
                    "Important Bonsai World consideration: variegated cultivars may have different vigor, light sensitivity and development speed.",
                    "Do not automatically apply straight-species development expectations.",
                    "Development / refinement suitability / known bonsai strengths: further cultivar verification required.",
                    "Potential challenges: variegation-related sensitivity and vigor differences.",
                    "Important differences from the straight species: possible variegation and associated sensitivity.",
                    "Verification status: curated priority cultivar — verify carefully.",
                    "Further cultivar verification required — do not invent suitability.",
                ]
            ),
            SpeciesProfileSection(
                id: "cultivar-pulverulentum",
                title: "Acer campestre 'Pulverulentum'",
                paragraphs: [
                    "Include only after identity and horticultural characteristics are sufficiently verified.",
                    "Focus on variegation characteristics, growth strength and bonsai suitability.",
                    "Growth habit / leaf characteristics / bonsai suitability: further cultivar verification required.",
                    "Do not invent suitability.",
                    "Important differences from the straight species: further cultivar verification required.",
                    "Verification status: identity and horticultural characteristics pending retained sources.",
                    "Further cultivar verification required — do not invent suitability.",
                ]
            ),
            SpeciesProfileSection(
                id: "cultivar-nanum",
                title: "Acer campestre 'Nanum'",
                paragraphs: [
                    "Include only after identity and current horticultural status are verified.",
                    "Focus on compact growth, development speed and leaf proportion.",
                    "Do not assume compact growth automatically means superior bonsai material.",
                    "Growth habit / growth strength / ramification / bonsai suitability: further cultivar verification required.",
                    "Important differences from the straight species: possible compactness — verify before operational claims.",
                    "Verification status: identity and current horticultural status pending retained sources.",
                    "Further cultivar verification required.",
                ]
            ),
            SpeciesProfileSection(
                id: "cultivar-selection",
                title: "Cultivar Selection Principle",
                paragraphs: [
                    "For Acer campestre, the straight species may often provide greater bonsai development value than ornamental landscape cultivars.",
                    "Species baseline → cultivar modifier → individual tree.",
                    "Example: species baseline strong growth potential; cultivar tendency more compact growth; individual tree currently extremely vigorous — the individual tree condition remains operationally dominant.",
                    "Cultivar information must never overwrite individual tree observations.",
                ]
            )
        ]
    }
}
