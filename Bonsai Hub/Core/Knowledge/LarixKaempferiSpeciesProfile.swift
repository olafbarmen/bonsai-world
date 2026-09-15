//
//  LarixKaempferiSpeciesProfile.swift
//  Bonsai World
//
//  Species Profile — Larix kaempferi (Lamb.) Carrière (Japanese Larch).
//  Botanical verification + bonsai knowledge + bud-aware deciduous-conifer pass.
//  Knowledge status: Reviewed.
//

import Foundation

enum LarixKaempferiSpeciesProfile {
    /// Binomial used by Botanical Library / ``SpeciesPreviewData``.
    static let botanicalLibraryName = "Larix kaempferi"
    /// Scientific name for Species Profile display (binomial; authorship in taxonomic sections).
    static let scientificName = "Larix kaempferi"

    static var profile: SpeciesProfile {
        SpeciesProfile(
            speciesID: BotanicalKnowledgeIDs.larixKaempferi,
            scientificName: scientificName,
            commonNames: ["Japanese Larch"],
            synonyms: ["Larix leptolepis"],
            family: "Pinaceae",
            plantType: "Deciduous conifer",
            originSummary: "Central Japan",
            knowledgeStatus: .reviewed,
            traits: traits,
            foliageSizeLabel: "Needle size",
            foliageReductionLabel: "Needle reduction",
            summaryLine: "Deciduous conifer · Moderate to strong growth · Excellent bonsai suitability",
            attentionHighlights: [
                "Larix kaempferi is a deciduous conifer — not an evergreen and not a broadleaf deciduous tree",
                "Existing buds are structurally important",
                "Do not assume unlimited back-budding from old bare wood",
                "Protect future structure before removing existing structure",
                "Strong growth can be used for development",
                "Ramification potential is high",
                "Wiring potential is high — protect buds from mechanical damage",
                "Bark character increases with age",
                "Winter silhouette is a major aesthetic feature",
                "Indoor overwintering is inappropriate",
                "Root protection is contextual in shallow containers",
                "Individual tree condition remains the final decision layer",
            ],
            sections: sections,
            principleNote: """
            Larix kaempferi must be managed with awareness of its existing buds.

            Structural work must consider existing buds, living branch tissue and future growth direction.

            Do not assume that cutting back will automatically create new buds wherever required.

            Larch development should protect useful buds and viable growth points.

            Before removing a branch, a shoot or a terminal section, evaluate existing buds, branch viability, future structural options and whether replacement growth already exists.

            A major design principle is: do not remove future structure before replacement structure is secure.

            Species information provides knowledge and tendencies. Cultivar information provides additional characteristics. Individual tree condition remains the final decision layer.
            """,
            sourcesNote: """
            Profile content is synthesised from recognised botanical, horticultural and bonsai authorities into Bonsai World editorial language.

            Botanical taxonomy and distribution — Royal Botanic Gardens, Kew (Plants of the World Online) for accepted scientific name, family, native range and synonyms (including Larix leptolepis).

            Horticultural information — Royal Horticultural Society; recognised botanical gardens and arboreta; university horticultural collections; Trees and Shrubs Online for cultivar identity, growth habit, needle characteristics and branch characteristics.

            Bonsai-specific information — established bonsai organisations, recognised bonsai professionals, specialist bonsai publications and long-standing educational resources.

            Bonsai World synthesises verified information into its own language, terminology, data model and operational philosophy. Do not copy external source wording.
            """
        )
    }

    /// Quick Reference — Bonsai World assessments for the species baseline (not universal measurements; cultivars and individuals may differ).
    private static let traits = SpeciesProfileTraits(
        deciduous: true,
        growthStrength: "Moderate to Strong",
        growthSpeed: "Moderate to Fast",
        leafSize: "Short to Medium",
        foliageReduction: "Limited — natural scale is important",
        ramificationPotential: "High potential",
        backBudding: "Limited and must not be assumed",
        rootDevelopment: "Strong potential",
        nebariPotential: "Good development potential",
        trunkDevelopment: "Strong potential",
        barkDevelopment: "High age-character potential",
        wiring: "Very suitable",
        defoliation: "Not applicable as broadleaf defoliation — needles shed naturally each year",
        airLayering: "May be suitable where timing, health and aftercare support it",
        threadGrafting: "Suitable where structural replacement is required",
        rootGrafting: "Suitable where appropriate",
        beginnerSuitability: "Moderate",
        bonsaiSuitability: "Excellent",
        difficulty: "Intermediate",
        winterDormancyRequired: true,
        winterHardiness: "High",
        rootFrostSensitivity: "Moderate in shallow bonsai containers"
    )

    private static var sections: [SpeciesProfileSection] {
        [
            SpeciesProfileSection(
                id: "taxonomic-context",
                title: "Taxonomic Context",
                paragraphs: [
                    "Larix kaempferi (Lamb.) Carrière is an accepted species in Pinaceae.",
                    "Accepted name status: Accepted.",
                    "Important historical and horticultural synonym: Larix leptolepis. The older name may still appear in older bonsai literature, older nursery material and historical horticultural references.",
                    "Bonsai World resolves Larix kaempferi and Larix leptolepis to the same Species Profile. Do not create duplicate species records.",
                    "Bonsai World hierarchy: Species → cultivar / horticultural selection → Individual Tree.",
                    "Do not confuse the straight species, named cultivars and individual tree condition.",
                ]
            ),
            SpeciesProfileSection(
                id: "overview",
                title: "Species Overview",
                paragraphs: [
                    "Larix kaempferi (Lamb.) Carrière, commonly known as Japanese Larch, is a deciduous conifer native to Central Japan.",
                    "It is a strong-growing larch species that is highly suitable for bonsai. It is capable of strong trunk development and refined branch structure, and it is highly seasonal in appearance.",
                    "The species is particularly valuable for strong spring growth, soft fresh foliage, fine needle texture, mature winter silhouette, seasonal autumn colour, powerful aged bark and strong natural bonsai character.",
                    "The winter silhouette is particularly important. A Japanese Larch bonsai must remain visually convincing even after the needles have fallen.",
                    "Do not classify Larix kaempferi as an evergreen conifer or as a deciduous broadleaf tree. Needles emerge in spring and are shed during autumn.",
                ],
                bullets: [
                    "Deciduous conifer (Pinaceae)",
                    "Native to Central Japan",
                    "Strong-growing larch with excellent bonsai suitability",
                    "Strong trunk and refined branch potential",
                    "Highly seasonal appearance",
                    "Winter silhouette is a major aesthetic feature",
                ]
            ),
            SpeciesProfileSection(
                id: "natural-growth",
                title: "Natural Growth",
                paragraphs: [
                    "Larix kaempferi can produce strong seasonal extension growth.",
                    "This growth can be used strategically for trunk development, primary branches, sacrifice branches and structural rebuilding.",
                    "During development: allow selected growth where thickness is required.",
                    "During refinement: control unnecessary extension while protecting useful buds and branch structure.",
                    "Grow where development is required. Control where refinement is required.",
                    "Do not repeatedly prune areas that still require thickness, taper or structural development.",
                ]
            ),
            SpeciesProfileSection(
                id: "needles",
                title: "Needles",
                paragraphs: [
                    "Larix kaempferi produces soft deciduous needles arranged in characteristic clusters on short shoots.",
                    "Foliage emerges in spring and falls in autumn. Needle characteristics are an important species feature.",
                    "Do not describe needle reduction as equivalent to broadleaf leaf reduction.",
                    "The visual objective is natural needle proportion, appropriate branch density and a convincing silhouette.",
                    "Needle size may vary according to vigor, shoot strength, growing conditions and development stage. Do not promise a fixed final needle size.",
                ]
            ),
            SpeciesProfileSection(
                id: "seasonal",
                title: "Seasonal Character",
                paragraphs: [
                    "Spring: bud swelling, bud break, fresh soft foliage and strong extension growth beginning. Protect fragile emerging growth. Avoid unnecessary disturbance of important buds.",
                    "Summer: active growth, shoot extension and branch thickening. Monitor water demand, wire marks, shoot development and structural balance.",
                    "Autumn: seasonal needle colour change, needle drop and increasing structural visibility. This period is part of the species' visual character.",
                    "Winter: the tree is leafless and the full branch architecture becomes visible. Winter is a major structural evaluation period for trunk line, taper, primary branches, secondary structure, bud distribution and future design options.",
                ]
            ),
            SpeciesProfileSection(
                id: "bud-management",
                title: "Bud Management",
                paragraphs: [
                    "Larix kaempferi development depends heavily on understanding existing buds, short shoots, long shoots and branch vitality.",
                    "Do not use generic deciduous broadleaf assumptions.",
                    "Before pruning a branch, evaluate where viable buds are located, whether useful replacement growth exists, whether the branch section beyond the cut is required, and whether future structure can be maintained.",
                    "Do not describe back-budding as guaranteed.",
                    "Avoid instructions such as “cut back hard and wait for new buds” unless the individual species-specific response is known and appropriate for that tree.",
                    "Secure future growth before removing present structure.",
                ]
            ),
            SpeciesProfileSection(
                id: "ramification",
                title: "Ramification",
                paragraphs: [
                    "Larix kaempferi has strong ramification potential.",
                    "Ramification must be developed while preserving branch hierarchy, bud availability, natural branch movement and needle scale.",
                    "The objective is clear primary branches, appropriate secondary branching, fine tertiary structure and a natural silhouette.",
                    "Do not pursue maximum branch density at the expense of structural clarity, light distribution or bud health.",
                ]
            ),
            SpeciesProfileSection(
                id: "trunk-development",
                title: "Trunk Development",
                paragraphs: [
                    "Larix kaempferi has strong potential for trunk development.",
                    "Potential methods include ground development, large development containers, sacrifice branches, controlled unrestricted growth and strategic trunk cuts where biologically appropriate.",
                    "Development should aim for taper, movement, natural transitions and mature bark potential.",
                    "Do not simply maximise trunk thickness. A powerful bonsai trunk requires thickness, taper, movement and branch integration.",
                ]
            ),
            SpeciesProfileSection(
                id: "bark",
                title: "Bark",
                paragraphs: [
                    "Bark development is an important mature characteristic.",
                    "Young trees may have relatively smoother bark. With age, bark can develop increased texture, rugged character and strong visual maturity.",
                    "Do not promise identical bark development for every tree. Bark character depends on age, genetics, growth history and growing conditions.",
                    "The mature trunk and bark should be treated as major visual strengths.",
                ]
            ),
            SpeciesProfileSection(
                id: "roots-nebari",
                title: "Roots & Nebari",
                paragraphs: [
                    "Larix kaempferi has good potential for root development.",
                    "Potential methods include root selection, radial root positioning, controlled root pruning, development containers, ground development and root grafting where appropriate.",
                    "Do not describe nebari development as automatic. The objective is a balanced and convincing root base.",
                    "Root work must remain proportional to tree health, root mass, development stage and recovery capacity.",
                ]
            ),
            SpeciesProfileSection(
                id: "light",
                title: "Light",
                paragraphs: [
                    "Larix kaempferi is an outdoor species. Healthy trees generally benefit from strong light.",
                    "Light recommendations must remain contextual.",
                    "Monitor needle condition, water demand, temperature, root moisture and wind exposure.",
                    "Do not use fixed environmental instructions without considering climate, container, tree health and seasonal conditions.",
                ]
            ),
            SpeciesProfileSection(
                id: "wind",
                title: "Wind",
                paragraphs: [
                    "Japanese Larch is generally a robust outdoor species.",
                    "Wind can increase transpiration, water demand and environmental stress.",
                    "Do not describe the species as immune to drying.",
                    "The operational principle is environmental demand versus root capacity and available moisture.",
                ]
            ),
            SpeciesProfileSection(
                id: "watering",
                title: "Watering",
                paragraphs: [
                    "Maintain appropriate moisture while preserving adequate oxygen around the roots.",
                    "Water demand depends on temperature, wind, rainfall, needle mass, container, substrate, root development, tree health and growth activity.",
                    "Avoid chronic waterlogging and repeated severe drying during active growth.",
                    "Do not use fixed watering schedules.",
                    "Water according to the condition of the tree and substrate, not according to the clock.",
                ]
            ),
            SpeciesProfileSection(
                id: "soil",
                title: "Soil",
                paragraphs: [
                    "Do not prescribe one universal soil recipe.",
                    "The substrate should provide drainage, aeration, appropriate moisture retention and stable structure.",
                    "The final mix depends on climate, rainfall, watering frequency, container, tree stage, root density and local environment.",
                    "Bonsai World should later determine recommendations from species, cultivar, tree stage, climate and growing environment.",
                ]
            ),
            SpeciesProfileSection(
                id: "fertilizing",
                title: "Fertilizing",
                paragraphs: [
                    "Feed the tree you are growing, not simply the species you have.",
                    "Nutrition depends on health, current vigor, development stage, root condition, season and desired development.",
                    "During development, nutrition may support trunk growth, branch development and structural growth.",
                    "During refinement, avoid unnecessary coarse extension.",
                    "Do not weaken the tree intentionally to reduce needle size.",
                ]
            ),
            SpeciesProfileSection(
                id: "pruning",
                title: "Pruning",
                paragraphs: [
                    "Development pruning: allow selected growth where required for trunk development, primary branches and structural rebuilding. Use sacrifice growth where appropriate. Protect useful buds. Do not remove structural sections without evaluating replacement growth.",
                    "Refinement pruning: control extension where required for branch proportion, ramification, silhouette and structural density.",
                    "Pruning decisions must consider existing buds, branch vitality, tree vigor, development stage and future structure.",
                    "Do not use universal shoot-cutting instructions.",
                ]
            ),
            SpeciesProfileSection(
                id: "back-budding",
                title: "Back-budding",
                paragraphs: [
                    "Do not rate Larix kaempferi as a generic high back-budding species.",
                    "Back-budding must be described conservatively.",
                    "The presence of existing buds and viable branch structure should guide major structural decisions.",
                    "Do not remove a branch because new growth is assumed to appear from old, bare wood.",
                    "Where structural replacement is required, evaluate existing buds, existing shoots, alternative branch development and grafting where appropriate.",
                    "Secure future growth before removing present structure.",
                ]
            ),
            SpeciesProfileSection(
                id: "wiring",
                title: "Wiring",
                paragraphs: [
                    "Larix kaempferi is highly suitable for wiring.",
                    "Younger branches can be flexible. Older branches may become more rigid and more brittle.",
                    "Potential risks include branch breakage, wire marks and rapid thickening during active growth.",
                    "Do not use fixed wire removal schedules. Monitor branch thickening, bark response and wire pressure.",
                    "Winter wiring may be advantageous for structural visibility. Protect buds from mechanical damage.",
                ]
            ),
            SpeciesProfileSection(
                id: "defoliation",
                title: "Foliage Management",
                paragraphs: [
                    "Do not apply broadleaf defoliation logic to Larix kaempferi.",
                    "The species naturally sheds its needles annually.",
                    "Needle removal or foliage manipulation must not automatically be called defoliation in the same sense used for broadleaf deciduous bonsai.",
                    "Do not create a standard annual defoliation recommendation.",
                    "Foliage management should focus on shoot strength, bud development, branch balance and structural refinement.",
                    "Tree health remains the priority.",
                ]
            ),
            SpeciesProfileSection(
                id: "repotting",
                title: "Repotting",
                paragraphs: [
                    "Repotting decisions depend on root development, substrate condition, container, tree health, development stage and climate.",
                    "Do not use fixed repotting intervals.",
                    "Repotting timing must consider dormancy, bud development, local climate and individual tree condition.",
                    "Avoid unnecessary aggressive root reduction.",
                    "Species tolerance does not replace assessment of the individual root system.",
                ]
            ),
            SpeciesProfileSection(
                id: "grafting",
                title: "Grafting",
                paragraphs: [
                    "Relevant techniques may include approach grafting, thread grafting and root grafting.",
                    "Common bonsai use cases include adding missing branches, improving root structure and correcting structural limitations.",
                    "Grafting should be considered where natural bud development cannot reasonably solve a structural problem.",
                    "All grafting work must be recorded in Shaping History.",
                ]
            ),
            SpeciesProfileSection(
                id: "air-layering",
                title: "Air Layering",
                paragraphs: [
                    "Air layering may be useful for creating new bonsai material, separating desirable trunk sections and correcting overly long material.",
                    "Success depends on timing, tree health, technique and aftercare.",
                    "Detailed procedures belong in Propagation Knowledge Articles.",
                ]
            ),
            SpeciesProfileSection(
                id: "propagation",
                title: "Propagation",
                paragraphs: [
                    "Potential methods may include seed, cuttings where appropriate, grafting and air layering where appropriate.",
                    "Do not assume all methods are equally suitable for all cultivars.",
                    "Seed-grown offspring do not preserve cultivar identity. Named cultivars require vegetative propagation.",
                ]
            ),
            SpeciesProfileSection(
                id: "pests",
                title: "Pests & Problems",
                paragraphs: [
                    "Potential issues may include aphids, adelgids, mites, caterpillars, sawflies, needle diseases and root problems associated with unsuitable moisture.",
                    "This section is not a diagnostic system.",
                    "Diagnosis and treatment belong in Care → Pest & Problem Management.",
                    "The Species Profile should link to relevant problem knowledge as that system develops.",
                ]
            ),
            SpeciesProfileSection(
                id: "winter-dormancy",
                title: "Winter Dormancy",
                paragraphs: [
                    "Winter dormancy is required. Larix kaempferi is an outdoor species.",
                    "Do not recommend indoor winter storage or indoor overwintering.",
                    "Container-grown bonsai roots may be more exposed than roots in open ground.",
                    "Winter protection requirements depend on local climate, container size, root exposure, wind, freeze-thaw cycles and tree health.",
                    "Do not use one universal temperature threshold.",
                ]
            ),
            SpeciesProfileSection(
                id: "styles",
                title: "Bonsai Styles",
                paragraphs: [
                    "Larix kaempferi is highly versatile.",
                    "Suitable styles may include informal upright, formal upright where material supports it, slanting, twin trunk, multiple trunk, clump, literati where material supports it, naturalistic conifer forms, medium bonsai and large bonsai.",
                    "The individual material determines the design. Do not force every tree into the same style.",
                ]
            ),
            SpeciesProfileSection(
                id: "tree-stage",
                title: "Development by Tree Stage",
                paragraphs: [
                    "Seedling: establish healthy roots, early trunk direction and root structure.",
                    "Nursery stock: develop nebari, trunk and primary branches.",
                    "Pre-bonsai: establish trunk line, taper, primary branches, bud distribution and structural direction.",
                    "In training: continue structural development while improving branch hierarchy, bud distribution and ramification.",
                    "Refinement: focus on branch structure, fine ramification, bud management and seasonal silhouette.",
                    "Exhibition: maintain health, branch clarity and seasonal presentation. Avoid unnecessary major intervention.",
                ]
            ),
            SpeciesProfileSection(
                id: "attention",
                title: "Species-Specific Attention",
                paragraphs: [
                    "These are tendencies. They are not automatic warnings.",
                ],
                bullets: [
                    "Larix kaempferi is a deciduous conifer",
                    "Existing buds are structurally important",
                    "Do not assume unlimited back-budding from old bare wood",
                    "Protect future structure before removing existing structure",
                    "Strong growth can be used for development",
                    "Ramification potential is high",
                    "Wiring potential is high",
                    "Bark character increases with age",
                    "Winter silhouette is a major aesthetic feature",
                    "Indoor overwintering is inappropriate",
                    "Root protection is contextual in shallow containers",
                    "Individual tree condition remains the final decision layer",
                ]
            ),
            SpeciesProfileSection(
                id: "cultivars-intro",
                title: "Cultivars",
                paragraphs: [
                    "This is a curated Bonsai World Cultivar Collection — not a complete nursery catalogue.",
                    "Cultivars are included only where they have clear horticultural identity, reliable documentation, distinct characteristics and potential relevance to bonsai.",
                    "Species baseline → cultivar modifier → individual tree. Cultivar information must never overwrite individual tree observations.",
                    "For Larix kaempferi, the straight species may often provide greater bonsai development value than dwarf or ornamental landscape cultivars.",
                    "A tree with strong nebari, interesting trunk movement, good taper, useful bud distribution, strong branch structure and mature bark potential may have greater bonsai potential than a named cultivar selected primarily for ornamental garden characteristics.",
                    "Cultivar identity is an additional knowledge layer. It is not an automatic bonsai quality rating.",
                    "Possible category filters: Dwarf Growth, Blue Foliage, Contorted Growth, Weeping Growth, Structural Cultivars. Categories must not replace actual cultivar identity.",
                ]
            ),
            SpeciesProfileSection(
                id: "cultivar-blue-dwarf",
                title: "Cultivar — 'Blue Dwarf'",
                paragraphs: [
                    "Primary characteristic: dwarf growth habit with blue or silvery-blue needle character and compact form.",
                    "Growth habit: compact / dwarf.",
                    "Needle characteristics: blue to silvery-blue tone relative to the straight species.",
                    "Branch characteristics: further verification required for internode behaviour and long-term branch architecture.",
                    "Seasonal characteristics: deciduous needle cycle retained.",
                    "Development suitability: compact nursery growth does not automatically mean superior bonsai development. Evaluate branch structure, internode behaviour and long-term development potential.",
                    "Refinement suitability: further cultivar verification required.",
                    "Known bonsai strengths: compact scale and distinctive needle colour may support specialised designs.",
                    "Potential challenges: ornamental compactness may limit structural development options compared with vigorous straight-species material.",
                    "Important differences from the straight species: reduced vigor / compact habit and blue needle character.",
                    "Verification status: curated priority cultivar — horticultural identity documented; operational bonsai detail pending retained sources.",
                ]
            ),
            SpeciesProfileSection(
                id: "cultivar-diana",
                title: "Cultivar — 'Diana'",
                paragraphs: [
                    "Primary characteristic: distinctive contorted branch character.",
                    "Growth habit: contorted / twisting branch growth.",
                    "Growth strength: further cultivar verification required relative to the straight species.",
                    "Needle characteristics: further cultivar verification required for precise claims.",
                    "Branch characteristics: contorted movement is a defining feature and may be part of primary bonsai value.",
                    "Seasonal characteristics: deciduous needle cycle retained; winter silhouette emphasises contorted structure.",
                    "Development suitability: do not force the cultivar into conventional straight-trunk architecture.",
                    "Refinement suitability: evaluate natural branch character first.",
                    "Known bonsai strengths: distinctive movement and structural personality.",
                    "Potential challenges: conventional upright design assumptions may fight the natural habit.",
                    "Important differences from the straight species: contorted branch architecture.",
                    "Verification status: curated priority cultivar — evaluate natural character first; further operational detail pending retained sources.",
                ]
            ),
            SpeciesProfileSection(
                id: "cultivar-pendula",
                title: "Cultivar — 'Pendula'",
                paragraphs: [
                    "Primary characteristic: pendulous / weeping growth habit.",
                    "Growth habit: weeping branch structure.",
                    "Growth strength: further cultivar verification required.",
                    "Needle characteristics: further cultivar verification required for precise claims.",
                    "Branch characteristics: cascading or pendulous movement with specialised design implications.",
                    "Seasonal characteristics: deciduous needle cycle retained; winter silhouette emphasises hanging architecture.",
                    "Development suitability: the natural cascading habit may support specialised designs. Do not automatically apply standard upright design assumptions.",
                    "Refinement suitability: design should follow the weeping habit rather than suppress it without purpose.",
                    "Known bonsai strengths: natural cascade / weeping character.",
                    "Potential challenges: upright styling may conflict with cultivar habit.",
                    "Important differences from the straight species: pendulous growth habit.",
                    "Verification status: curated priority cultivar — further operational bonsai detail pending retained sources.",
                ]
            ),
            SpeciesProfileSection(
                id: "cultivar-wolterdingen",
                title: "Cultivar — 'Wolterdingen'",
                paragraphs: [
                    "Include only after sufficient verification.",
                    "Focus areas pending verification: compact growth, branch density, needle characteristics and bonsai development potential.",
                    "Growth habit / growth strength / needle characteristics / branch characteristics / bonsai suitability: further cultivar verification required.",
                    "Important differences from the straight species: further cultivar verification required.",
                    "Verification status: curated candidate — further verification required. Do not invent suitability.",
                ]
            ),
            SpeciesProfileSection(
                id: "cultivar-blue-rabbit",
                title: "Cultivar — 'Blue Rabbit'",
                paragraphs: [
                    "Include only after sufficient verification.",
                    "Focus areas pending verification: growth habit, structural character and bonsai relevance.",
                    "Growth habit / growth strength / needle characteristics / bonsai suitability: further cultivar verification required.",
                    "Important differences from the straight species: further cultivar verification required.",
                    "Verification status: curated candidate — further verification required. Do not invent suitability.",
                ]
            ),
            SpeciesProfileSection(
                id: "cultivar-nana",
                title: "Cultivar — 'Nana'",
                paragraphs: [
                    "Include only after current cultivar identity and horticultural status are verified.",
                    "Do not assume all plants historically sold as 'Nana' represent identical material.",
                    "Growth habit / growth strength / needle characteristics / bonsai suitability: further cultivar verification required.",
                    "Important differences from the straight species: further cultivar verification required.",
                    "Verification status: curated candidate — identity and horticultural status require verification. Do not invent suitability.",
                ]
            ),
            SpeciesProfileSection(
                id: "cultivar-selection",
                title: "Cultivar Selection Principle",
                paragraphs: [
                    "For Larix kaempferi, the straight species may often provide greater bonsai development value than dwarf or ornamental landscape cultivars.",
                    "Species baseline → cultivar modifier → individual tree.",
                    "Example: species baseline moderate to strong growth; cultivar tendency compact growth; individual tree currently producing extremely strong extension — the individual tree condition remains operationally dominant.",
                    "Cultivar information must never overwrite individual tree observations.",
                ]
            ),
        ]
    }
}
