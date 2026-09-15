//
//  LarixDeciduaSpeciesProfile.swift
//  Bonsai World
//
//  Species Profile — Larix decidua Mill. (European Larch).
//  Botanical verification + bonsai knowledge + deciduous-conifer seasonal pass.
//  Knowledge status: Reviewed.
//

import Foundation

enum LarixDeciduaSpeciesProfile {
    /// Binomial used by Botanical Library / ``SpeciesPreviewData``.
    static let botanicalLibraryName = "Larix decidua"
    /// Scientific name for Species Profile display (binomial; authorship in taxonomic sections).
    static let scientificName = "Larix decidua"

    static var profile: SpeciesProfile {
        SpeciesProfile(
            speciesID: BotanicalKnowledgeIDs.larixDecidua,
            scientificName: scientificName,
            commonNames: ["European Larch", "Europalerk"],
            family: "Pinaceae",
            plantType: "Deciduous conifer",
            originSummary: "Central and southern Europe — primarily mountainous regions including the Alps, Sudeten Mountains and Carpathians",
            knowledgeStatus: .reviewed,
            traits: traits,
            foliageSizeLabel: "Needle size",
            foliageReductionLabel: "Needle reduction",
            summaryLine: "Deciduous conifer · Strong growth · Excellent bonsai potential",
            attentionHighlights: [
                "Strong growth — use vigour deliberately during development",
                "Fast branch thickening — monitor proportions and branch hierarchy",
                "Seasonal needle loss — winter silhouette becomes a major design feature",
                "Wiring — monitor regularly during active growth",
                "Strong root development — monitor substrate condition and root density",
                "Cold-hardy species — still protect roots appropriately in shallow containers",
                "High light preference — consider water demand and root condition",
                "Strong seasonal character — evaluate the tree across the entire year",
            ],
            sections: sections,
            principleNote: """
            European Larch is a vigorous and highly adaptable bonsai species, but its seasonal growth cycle must be respected.

            The species profile provides knowledge about the natural tendencies of Larix decidua, including its growth, response to pruning, root development and seasonal behaviour. It does not automatically determine what should be done to every individual tree.

            A healthy developing tree may tolerate substantially more structural work than a weak, recently collected, recently repotted or highly refined tree.

            Observe the individual tree. Use species knowledge as guidance.
            """,
            sourcesNote: """
            Profile content is synthesised from recognised botanical, horticultural and bonsai authorities into Bonsai World editorial language.

            Botanical taxonomy and distribution — Royal Botanic Gardens, Kew (Plants of the World Online); Artsdatabanken for status in Norway.

            Horticultural information — Royal Horticultural Society; Trees and Shrubs Online; recognised botanical gardens and arboreta.

            Bonsai-specific information — established bonsai organisations, recognised bonsai professionals, specialist bonsai publications and long-standing educational resources.

            Do not copy external source wording.

            Bonsai World synthesises verified information into its own language, terminology, data model and operational philosophy. Do not copy external source wording. Each significant botanical or horticultural claim should be traceable to a retained source reference before Reviewed status.
            """
        )
    }

    /// Quick Reference — Bonsai World assessments for the species baseline (not universal measurements; cultivars and individuals may differ).
    private static let traits = SpeciesProfileTraits(
        deciduous: true,
        growthStrength: "Strong",
        growthSpeed: "Fast",
        leafSize: "Small needles, naturally suitable for bonsai",
        foliageReduction: "Naturally suitable scale — not the primary refinement focus",
        ramificationPotential: "High potential",
        backBudding: "Moderate to strong potential",
        rootDevelopment: "Strong",
        nebariPotential: "Good to excellent potential",
        trunkDevelopment: "Fast",
        barkDevelopment: "High age-character potential",
        wiring: "Suitable — monitor regularly",
        defoliation: "Not generally used as a standard technique",
        airLayering: "Possible — not the primary propagation method",
        threadGrafting: "Suitable where structural replacement is required",
        rootGrafting: "Suitable where appropriate",
        beginnerSuitability: "High",
        bonsaiSuitability: "Excellent",
        difficulty: "Beginner to Advanced",
        winterDormancyRequired: true,
        winterHardiness: "High",
        rootFrostSensitivity: "Significant in shallow containers"
    )

    private static var sections: [SpeciesProfileSection] {
        [
            SpeciesProfileSection(
                id: "taxonomic-context",
                title: "Taxonomic Context",
                paragraphs: [
                    "Larix decidua Mill. is an accepted species in Pinaceae.",
                    "Accepted name status: Accepted. Botanical authority: Mill.",
                    "Common names: European Larch (English); Europalerk (Norwegian).",
                    "Native range: Central and southern European mountain regions, including the Alps, Sudeten Mountains and Carpathians.",
                    "Status in Norway: Introduced and widely cultivated.",
                    "Bonsai World hierarchy: Species → cultivar / horticultural selection → Individual Tree.",
                    "Do not confuse the straight species, named cultivars and individual tree condition.",
                ]
            ),
            SpeciesProfileSection(
                id: "overview",
                title: "Species Overview",
                paragraphs: [
                    "Larix decidua, commonly known as European Larch, is a deciduous conifer valued for its vigorous growth, fine seasonal character, attractive mature bark and strong potential for trunk and branch development.",
                    "Unlike evergreen conifers, European Larch produces soft green needles during the growing season, develops strong yellow to golden autumn colour and loses its foliage during autumn before entering winter dormancy.",
                    "This annual transformation gives the species several distinct visual phases: fresh spring growth, soft green summer foliage, golden autumn colour and a completely leafless winter silhouette.",
                    "The winter silhouette is particularly important in bonsai because the trunk, branch structure and ramification become fully visible.",
                    "European Larch is naturally a large tree, but its needle structure, response to cultivation and capacity for developing aged bark make it highly suitable for bonsai.",
                    "The species has been widely planted and cultivated in Norway and is highly relevant as bonsai material in Nordic conditions.",
                ],
                bullets: [
                    "Deciduous conifer",
                    "Strong and vigorous growth",
                    "Soft needles",
                    "Attractive golden autumn colour",
                    "Fine winter silhouette",
                    "Strong trunk development potential",
                    "Good potential for mature bark",
                    "Strong response to development cultivation",
                    "Suitable for individual trees and forest compositions",
                    "Naturally adapted to cold winter dormancy",
                    "Excellent material for both development and refinement",
                ]
            ),
            SpeciesProfileSection(
                id: "natural-growth",
                title: "Natural Growth",
                paragraphs: [
                    "European Larch is capable of strong extension growth, particularly when young and given sufficient root space, water, nutrition and sunlight.",
                    "During development, this vigour can be used deliberately to increase trunk diameter, develop sacrifice branches, build primary branch structure, strengthen the root system, develop nebari and produce movement and taper.",
                    "A larch should therefore not automatically be kept small simply because it is intended to become a bonsai.",
                    "During the development phase, controlled strong growth is often an advantage.",
                    "During refinement, however, growth must be managed more carefully. Long extension shoots can quickly alter branch proportions, reduce refinement and create unnecessary thickening.",
                    "Allow growth where development is required. Control growth where refinement is required.",
                ]
            ),
            SpeciesProfileSection(
                id: "needles",
                title: "Needles",
                paragraphs: [
                    "European Larch has soft, light green needles that are naturally small and visually well suited to bonsai.",
                    "Needles occur differently depending on shoot type: on long shoots they are arranged individually; on older short shoots they occur in characteristic clusters.",
                    "This creates a distinctive foliage structure and contributes to the light, delicate appearance of mature larch bonsai.",
                    "During autumn, the needles typically turn yellow before falling.",
                    "Needle size and density are influenced by tree vigour, root space, nutrition, shoot strength, light, development stage and overall cultivation.",
                    "Needle size should therefore be viewed as part of the overall balance of the tree rather than as the result of one isolated technique.",
                ]
            ),
            SpeciesProfileSection(
                id: "autumn-character",
                title: "Autumn Character",
                paragraphs: [
                    "Autumn is one of the defining visual characteristics of European Larch.",
                    "As the growing season ends, the green needles turn yellow to golden-yellow before falling.",
                    "This seasonal transition is an important part of the species' visual identity and should be considered when evaluating and designing the tree.",
                    "A larch bonsai should not be judged only during summer. The same tree can present four very different visual experiences throughout the year.",
                ]
            ),
            SpeciesProfileSection(
                id: "bark-trunk",
                title: "Bark & Trunk",
                paragraphs: [
                    "Young European Larch has relatively smooth bark. With age, the bark becomes increasingly textured and characterful.",
                    "Mature bark is one of the major visual strengths of the species.",
                    "European Larch also has excellent potential for trunk development.",
                    "During the development phase, useful techniques may include sacrifice branches, controlled extension growth, large growing containers, field growing where appropriate, ground development where appropriate, strategic trunk cuts and controlled directional growth.",
                    "Strong growth should be used intentionally to create taper and trunk movement rather than simply allowing unrestricted growth everywhere.",
                    "Once sufficient trunk development has been achieved, priorities can gradually move toward primary branch structure, secondary branching, ramification, silhouette and refinement.",
                ]
            ),
            SpeciesProfileSection(
                id: "roots-nebari",
                title: "Roots & Nebari",
                paragraphs: [
                    "European Larch can develop a strong root system and is capable of producing useful bonsai root structure when root development is considered from an early stage.",
                    "Root work should aim to develop radial root distribution, a stable trunk base, good surface-root presentation, efficient fine-root development and balance between root mass and canopy.",
                    "Nebari development should begin early rather than being postponed until the tree is already highly developed.",
                    "Potential techniques may include root pruning, radial root positioning, root selection, controlled container development, root grafting where appropriate, ground development and root-over-rock development where suitable.",
                    "The objective is not simply to produce a large quantity of roots. The objective is to create a balanced and useful root structure.",
                ]
            ),
            SpeciesProfileSection(
                id: "light",
                title: "Light",
                paragraphs: [
                    "European Larch performs best with strong outdoor light and is generally well suited to full sun when the tree is healthy and properly cultivated.",
                    "Strong light supports healthy growth, strong bud development, compact growth, needle development and general vigour.",
                    "Light exposure should always be interpreted together with temperature, wind, water availability, root condition, container size, recent repotting and development stage.",
                    "A healthy established tree can tolerate conditions that would be inappropriate for a recently repotted tree, a weakened tree, a tree with reduced roots, a newly collected tree or a tree in a very shallow container.",
                    "European Larch should be grown outdoors.",
                ]
            ),
            SpeciesProfileSection(
                id: "wind",
                title: "Wind",
                paragraphs: [
                    "European Larch is generally a robust outdoor species, but wind increases water loss and can significantly increase the monitoring requirement of bonsai in shallow containers.",
                    "Particular attention should be given to strong drying winds, newly emerging foliage, recently repotted trees, small bonsai containers, shallow containers and trees with reduced root systems.",
                    "Strong wind combined with sun and a shallow container can create rapid changes in substrate moisture.",
                    "Species information should therefore never replace observation of the actual tree and substrate.",
                ]
            ),
            SpeciesProfileSection(
                id: "watering",
                title: "Watering",
                paragraphs: [
                    "European Larch requires reliable water availability during active growth.",
                    "The species should not be treated as either permanently wet or drought tolerant.",
                    "General principle: moist, well-drained substrate with sufficient oxygen around the roots.",
                    "Watering frequency should depend on weather, temperature, wind, tree size, container size, substrate structure, root mass, seasonal growth and development stage.",
                    "Do not water according to a fixed timetable. Water according to the condition of the tree and substrate.",
                    "During periods of strong summer growth, water demand can increase significantly.",
                ]
            ),
            SpeciesProfileSection(
                id: "soil",
                title: "Soil",
                paragraphs: [
                    "European Larch benefits from a well-draining bonsai substrate capable of providing adequate moisture retention, good aeration and stable structure.",
                    "The ideal substrate will depend on the growing environment.",
                    "Important considerations include rainfall, temperature, watering frequency, container depth, tree size, root development and development stage.",
                    "A tree in early development can often be managed differently from a highly refined tree in a shallow exhibition container.",
                    "Bonsai World does not prescribe one universal soil recipe for this species.",
                ]
            ),
            SpeciesProfileSection(
                id: "fertilizing",
                title: "Fertilizing",
                paragraphs: [
                    "European Larch is a vigorous species and can make good use of nutrition during active development.",
                    "Fertilization should depend on tree health, development stage, current growth, season, root condition, recent work and desired development.",
                    "A developing tree can generally be managed for stronger growth than a highly refined tree.",
                    "During development, nutrition can support trunk thickening, sacrifice branch development, root development and primary branch construction.",
                    "During refinement, nutrition should be managed with greater attention to shoot strength, branch proportions, growth control and fine ramification.",
                    "A weak or recently disturbed tree should not automatically receive stronger fertilizer simply because European Larch is naturally vigorous.",
                    "Feed the tree you are growing, not simply the species name.",
                ]
            ),
            SpeciesProfileSection(
                id: "pruning",
                title: "Pruning",
                paragraphs: [
                    "European Larch is highly suitable for structural development and refinement through pruning. Pruning should always be linked to the developmental objective.",
                    "Development pruning: during development, extension growth may be deliberately allowed where additional thickness is required — for trunk thickening, branch thickening, sacrifice branch development and establishing primary structure. Once sufficient thickness has been achieved, the branch can be reduced according to the development plan.",
                    "Refinement pruning: during refinement, pruning can be used to maintain silhouette, control branch length, improve branch hierarchy, increase light penetration, manage vigour and develop fine ramification.",
                    "Pruning should not become an automatic repeated routine without considering the tree's current energy and development stage.",
                ]
            ),
            SpeciesProfileSection(
                id: "bud-development",
                title: "Bud Development & Back-budding",
                paragraphs: [
                    "European Larch has useful potential for producing buds and new growth, making it suitable for structural development and rebuilding.",
                    "However, back-budding should never be treated as guaranteed.",
                    "The result depends on factors including tree health, tree vigour, branch condition, age of the wood, light exposure, timing and previous work.",
                    "Do not remove important structural growth on the assumption that replacement buds will automatically appear exactly where desired.",
                    "When rebuilding a branch structure, existing buds and potential future growth points should be evaluated before major removal.",
                ]
            ),
            SpeciesProfileSection(
                id: "ramification",
                title: "Ramification",
                paragraphs: [
                    "European Larch has strong potential for developing refined branch structures.",
                    "The species is particularly attractive in winter because the complete branch structure becomes visible after needle fall.",
                    "Ramification development should focus on branch hierarchy, directional growth, controlled extension, light penetration, avoiding unnecessary thickening and maintaining taper from primary branches to fine shoots.",
                    "The goal is not maximum density. The goal is a believable and balanced branch structure.",
                ]
            ),
            SpeciesProfileSection(
                id: "wiring",
                title: "Wiring",
                paragraphs: [
                    "European Larch can be wired successfully and responds well to directional branch positioning.",
                    "Wiring can be useful for establishing primary branches, creating movement, improving branch placement, refining secondary structure and developing cascade or informal upright compositions.",
                    "Because branches and shoots can grow actively during the season, wires must be monitored regularly.",
                    "The main risks include wire marks, rapid thickening, bark damage, loss of branch movement and scarring on developing branches.",
                    "The required monitoring frequency depends on growth speed, branch thickness, tree vigour and season.",
                    "Strong growth requires more frequent inspection.",
                ]
            ),
            SpeciesProfileSection(
                id: "defoliation",
                title: "Defoliation",
                paragraphs: [
                    "European Larch should not be managed using broadleaf-style defoliation principles.",
                    "Complete defoliation should not be treated as a routine refinement technique.",
                    "The species' annual needle cycle, bud development and overall energy balance should be respected.",
                    "Needle and shoot management should instead be based on the specific development objective and the condition of the individual tree.",
                    "A healthy, vigorous tree can tolerate more work than a weak tree, a recently repotted tree, a recovering tree or a tree with reduced roots.",
                ]
            ),
            SpeciesProfileSection(
                id: "repotting",
                title: "Repotting",
                paragraphs: [
                    "European Larch generally responds well to appropriate root work when healthy, but repotting frequency should depend on the individual tree.",
                    "Consider root development, root density, substrate condition, container size, tree health, development stage and climate.",
                    "A young development tree may require more frequent root management than a mature refined tree.",
                    "Root work should be performed as part of the overall development plan rather than simply because a fixed number of years has passed.",
                    "Species-specific seasonal timing is useful guidance, but the actual tree and local climate must remain part of the decision.",
                ]
            ),
            SpeciesProfileSection(
                id: "trunk-development",
                title: "Trunk Development",
                paragraphs: [
                    "European Larch has excellent potential for rapid trunk development.",
                    "Useful approaches can include sacrifice branches, controlled extension growth, large development containers, field growing, ground development and strategic trunk reduction.",
                    "The trunk development plan should consider taper, movement, branch placement, future apex, nebari and final tree size.",
                    "Strong growth should be directed toward the parts of the tree where development is required.",
                    "Once trunk structure is established, growth can be progressively controlled.",
                ]
            ),
            SpeciesProfileSection(
                id: "nebari-development",
                title: "Nebari Development",
                paragraphs: [
                    "Nebari can become an important feature of European Larch bonsai.",
                    "Early development should focus on radial root distribution, removal of poorly positioned roots where appropriate, root balance, stable trunk flare and long-term visual integration between trunk and roots.",
                    "Potential advanced techniques may include root pruning, radial positioning, root grafting, controlled root development in larger containers and root-over-rock compositions.",
                    "The objective is a convincing and structurally balanced base.",
                ]
            ),
            SpeciesProfileSection(
                id: "grafting",
                title: "Grafting",
                paragraphs: [
                    "Grafting can be relevant when existing material does not provide the required branch or root structure.",
                    "Potential uses include root grafting, branch grafting, repairing structural weaknesses and improving nebari.",
                    "Grafting should be treated as a tree-specific development technique rather than a standard requirement for the species.",
                    "Any major grafting work should be documented in the individual tree's Shaping History.",
                ]
            ),
            SpeciesProfileSection(
                id: "air-layering",
                title: "Air Layering",
                paragraphs: [
                    "Air layering may be possible as a propagation or material-development technique, but it should not be treated as the primary propagation method for European Larch.",
                    "Success depends on timing, tree health, material condition, technique and subsequent aftercare.",
                    "Where a branch or trunk section has exceptional potential as independent bonsai material, air layering may be considered as part of a specific development plan.",
                ]
            ),
            SpeciesProfileSection(
                id: "propagation",
                title: "Propagation",
                paragraphs: [
                    "European Larch can be propagated through several methods.",
                    "Potential methods include seed, grafting and cuttings under suitable conditions.",
                    "Seed is particularly relevant for producing young development material, forest compositions, long-term trunk development and controlled root development.",
                    "Detailed propagation procedures belong in Propagation Knowledge Articles and should be linked from this profile rather than duplicated here.",
                ]
            ),
            SpeciesProfileSection(
                id: "pests",
                title: "Pests & Problems",
                paragraphs: [
                    "Potential problems can include aphids and other sap-feeding insects, adelgids, mites, caterpillars, fungal diseases, root problems associated with unsuitable substrate conditions, stress caused by drought and problems following excessive root disturbance.",
                    "European Larch can also experience environmental stress when strong growth is combined with insufficient water availability.",
                    "Diagnosis and treatment information should be maintained separately in Care → Pest Management.",
                    "The species profile should provide general risk context rather than detailed diagnosis and treatment procedures.",
                ]
            ),
            SpeciesProfileSection(
                id: "seasonal",
                title: "Seasonal Profile",
                paragraphs: [
                    "Spring: beginning of the active growth cycle. Key observations may include bud activity, new needle emergence, rapid shoot development, increasing water demand and increasing nutritional requirements. This is an important period for monitoring structural development.",
                    "Summer: the primary active growing period. Important considerations include water demand, shoot extension, fertilization, wire monitoring, branch development and ramification management. Strong growth can be used deliberately during the development phase. During refinement, extension growth may require more regular control.",
                    "Autumn: a major visual and developmental transition. The needles turn yellow to golden-yellow before falling. As growth slows, the underlying branch structure becomes increasingly visible. Autumn can therefore be an important period for evaluating silhouette, evaluating branch structure, reviewing wiring and planning future structural work.",
                    "Winter: European Larch is dormant. The tree must experience its natural winter dormancy cycle. The leafless winter period makes it possible to clearly evaluate trunk movement, branch structure, ramification, silhouette and structural defects.",
                    "Although the species is naturally cold hardy, a bonsai container does not provide the same root protection as open ground. Winter protection should consider minimum temperature, duration of freezing, wind, container size, root condition, tree health and exposure. Do not use one universal temperature threshold for every tree.",
                ]
            ),
            SpeciesProfileSection(
                id: "styles",
                title: "Bonsai Styles",
                paragraphs: [
                    "European Larch is highly versatile and can be developed into many bonsai forms.",
                    "Particularly suitable styles include informal upright, formal upright, slanting, cascade, semi-cascade, multiple trunk, twin trunk, clump, forest, naturalistic forms and root-over-rock where suitable.",
                    "Forest compositions are particularly convincing because larch can create highly believable woodland compositions and retains strong visual interest throughout the seasons.",
                    "The final style should always be determined by the individual material. Do not force every European Larch into the same design.",
                ]
            ),
            SpeciesProfileSection(
                id: "tree-stage",
                title: "Development by Tree Stage",
                paragraphs: [
                    "Seedling: establish a healthy root system, build vigour, develop early trunk movement and establish useful root direction.",
                    "Young propagated material: establish roots, build vigour and develop trunk and root structure.",
                    "Nursery stock: evaluate trunk, identify primary branches, improve root structure and establish the development plan.",
                    "Pre-bonsai: develop trunk line, develop primary branches, build nebari, create taper and begin structural refinement.",
                    "In training: branch development, ramification, trunk development where still required, wiring, pruning and root management.",
                    "Refinement: fine branch structure, ramification, silhouette, seasonal balance and controlled extension growth.",
                    "Exhibition: maintain refined structure, maintain health, maintain presentation and avoid unnecessary major intervention.",
                ]
            ),
            SpeciesProfileSection(
                id: "attention",
                title: "Species-Specific Attention",
                paragraphs: [
                    "These attention points represent tendencies Bonsai World can use operationally. They must still be interpreted for the individual tree.",
                ],
                bullets: [
                    "Strong growth — use vigour deliberately during development",
                    "Fast branch thickening — monitor proportions and branch hierarchy",
                    "Seasonal needle loss — winter silhouette becomes a major design feature",
                    "Wiring — monitor regularly during active growth",
                    "Strong root development — monitor substrate condition and root density",
                    "Cold-hardy species — still protect roots appropriately in shallow containers",
                    "High light preference — consider water demand and root condition",
                    "Strong seasonal character — evaluate the tree across the entire year",
                ]
            ),
            SpeciesProfileSection(
                id: "cultivars-intro",
                title: "Cultivars",
                paragraphs: [
                    "European Larch has a number of named cultivars, although for traditional bonsai the straight species is generally the most flexible starting point.",
                    "For Bonsai World, only cultivars with clear and distinct bonsai relevance should be included.",
                    "The Species Library should not become a general nursery cultivar database.",
                    "Species baseline → cultivar modifier → individual tree. Cultivar information must never overwrite individual tree observations.",
                ]
            ),
            SpeciesProfileSection(
                id: "cultivar-straight-species",
                title: "Straight Species — Larix decidua",
                paragraphs: [
                    "The standard species remains the most versatile choice for traditional bonsai development, large bonsai, medium bonsai, shohin development, forest compositions, informal upright styles and naturalistic designs.",
                    "For many bonsai purposes, the standard species should remain the primary recommendation.",
                ]
            ),
            SpeciesProfileSection(
                id: "cultivar-pendula",
                title: "Cultivar — 'Pendula'",
                paragraphs: [
                    "Primary characteristic: weeping European Larch — a pendulous form with naturally hanging branches.",
                    "Bonsai relevance: suitable for cascade, semi-cascade, informal designs and naturalistic weeping compositions.",
                    "The natural weeping habit can create highly characterful bonsai but may also require deliberate structural planning.",
                    "Material should always be evaluated individually rather than relying only on the cultivar name.",
                    "Verification status: curated priority cultivar — further operational detail pending retained sources.",
                ]
            ),
            SpeciesProfileSection(
                id: "cultivar-puli",
                title: "Cultivar — 'Puli'",
                paragraphs: [
                    "Primary characteristic: a strongly pendulous cultivar with a dense cascading growth habit.",
                    "When trained upward, the material can develop unusual architectural forms. When allowed to grow naturally, the growth habit is strongly cascading.",
                    "Bonsai relevance: particularly interesting for cascade, semi-cascade, informal upright with dramatic movement and experimental naturalistic designs.",
                    "Its natural growth pattern can provide movement that would take much longer to create artificially.",
                    "Verification status: curated priority cultivar — further operational detail pending retained sources.",
                ]
            ),
            SpeciesProfileSection(
                id: "cultivar-krejci",
                title: "Cultivar — 'Krejčí'",
                paragraphs: [
                    "Primary characteristic: an unusual cultivar characterised by irregular, twisted and highly individual growth.",
                    "Bonsai relevance: interesting for naturalistic bonsai, highly individual compositions, character-driven designs and experimental styling.",
                    "This cultivar is best treated as a specialist bonsai option rather than a universal recommendation.",
                    "Its greatest value lies in its unusual natural character.",
                    "Verification status: curated priority cultivar — further operational detail pending retained sources.",
                ]
            ),
            SpeciesProfileSection(
                id: "cultivar-other",
                title: "Other Cultivars",
                paragraphs: [
                    "European Larch has additional horticultural cultivars, including dwarf, upright and irregular forms.",
                    "Additional cultivars should only be added to Bonsai World when they provide useful and distinct bonsai knowledge.",
                    "The question should always be: does this cultivar provide meaningful and distinct bonsai value?",
                ]
            ),
            SpeciesProfileSection(
                id: "botanical-information",
                title: "Botanical Information",
                paragraphs: [
                    "Scientific name: Larix decidua.",
                    "Botanical authority: Mill.",
                    "Common name: European Larch.",
                    "Norwegian common name: Europalerk.",
                    "Family: Pinaceae. Genus: Larix.",
                    "Native range: Central and southern European mountain regions, including the Alps, Sudeten Mountains and Carpathians.",
                    "Status in Norway: Introduced and widely cultivated.",
                ]
            ),
        ]
    }
}
