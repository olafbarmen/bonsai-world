//
//  LarixMarschlinsiiSpeciesProfile.swift
//  Bonsai World
//
//  Species Profile — Larix × marschlinsii (Hybrid Larch / Dunkeld Larch).
//  Hybrid of Larix decidua × Larix kaempferi. Synonym: Larix × eurolepis.
//  Knowledge status: Reviewed.
//

import Foundation

enum LarixMarschlinsiiSpeciesProfile {
    /// Binomial used by Botanical Library / ``SpeciesPreviewData``.
    static let botanicalLibraryName = "Larix × marschlinsii"
    /// Scientific name for Species Profile display (binomial; authorship in taxonomic sections).
    static let scientificName = "Larix × marschlinsii"

    static var profile: SpeciesProfile {
        SpeciesProfile(
            speciesID: BotanicalKnowledgeIDs.larixMarschlinsii,
            scientificName: scientificName,
            commonNames: ["Hybrid Larch", "Dunkeld Larch", "Hybridlerk"],
            synonyms: [
                "Larix × eurolepis",
                "Larix x eurolepis",
                "Larix x marschlinsii",
            ],
            family: "Pinaceae",
            plantType: "Deciduous conifer · Hybrid",
            originSummary: "Artificial hybrid of European Larch and Japanese Larch.",
            knowledgeStatus: .reviewed,
            traits: traits,
            foliageSizeLabel: "Needle size",
            foliageReductionLabel: "Needle reduction",
            summaryLine: "Deciduous conifer · Very vigorous growth · Strong development potential · Excellent bonsai potential",
            attentionHighlights: [
                "Strong growth — watch excessive extension and rapid branch thickening",
                "Hybrid vigour — do not assume every tree grows identically, but expect potentially strong development",
                "Wiring — monitor carefully for wire marks during active growth",
                "Root development — monitor for congestion and declining substrate structure",
                "Development potential — use strong growth deliberately when building trunk and branches",
                "Refinement — reduce uncontrolled extension once structural objectives have been achieved",
                "Winter — protect the root system from severe freezing in shallow bonsai containers",
                "Water demand — monitor carefully during warm and windy active growth periods",
            ],
            sections: sections,
            principleNote: """
            Hybrid Larch is a vigorous deciduous conifer, but every individual tree must still be managed according to its own health, development stage, root condition, environment and current growth.

            The hybrid profile provides knowledge about general tendencies associated with Larix × marschlinsii. It does not automatically dictate what should be done to every individual tree.

            Hybrid Larch should also not be treated simply as an average of European Larch and Japanese Larch.

            Individual hybrid trees can express characteristics from either parent in different ways, while strong hybrid vigour may influence growth rate, root development and overall response to cultivation.

            Observe the tree in front of you.
            """,
            sourcesNote: """
            Profile content is synthesised from recognised botanical, horticultural and bonsai authorities into Bonsai World editorial language.

            Taxonomy and hybrid parentage should be verified against recognised botanical authorities.

            Relevant sources may include: Plants of the World Online — Royal Botanic Gardens, Kew; Royal Horticultural Society; established dendrological references; regional forestry and botanical sources where relevant; peer-reviewed or academically recognised horticultural literature where available.

            Larix × eurolepis is retained as a recognised synonym. Larix × marschlinsii is the primary scientific name in Bonsai World.

            Bonsai World synthesises verified information into its own language, terminology, data model and operational philosophy. Do not copy external source wording.
            """
        )
    }

    /// Quick Reference — Bonsai World assessments for the hybrid baseline (not universal measurements; individuals may differ).
    private static let traits = SpeciesProfileTraits(
        deciduous: true,
        growthStrength: "Very strong",
        growthSpeed: "Fast",
        leafSize: "Small to medium, suitable for bonsai proportion",
        foliageReduction: "Result of balanced cultivation — not a single isolated technique",
        ramificationPotential: "High potential",
        backBudding: "Good to strong potential when healthy and managed correctly",
        rootDevelopment: "Strong",
        nebariPotential: "Good potential",
        trunkDevelopment: "Very fast potential",
        barkDevelopment: "Increasing character with age",
        wiring: "Suitable — monitor regularly",
        defoliation: "Not applicable in the broadleaf bonsai sense",
        airLayering: "Possible on suitable material — individual decision",
        threadGrafting: "Suitable where structural replacement is required",
        rootGrafting: "Suitable where appropriate",
        beginnerSuitability: "Medium to high",
        bonsaiSuitability: "Excellent",
        difficulty: "Beginner to Advanced",
        winterDormancyRequired: true,
        winterHardiness: "High",
        rootFrostSensitivity: "Moderate to significant in shallow bonsai containers"
    )

    private static var sections: [SpeciesProfileSection] {
        [
            SpeciesProfileSection(
                id: "taxonomic-context",
                title: "Taxonomic Context",
                paragraphs: [
                    "Larix × marschlinsii is the accepted scientific name used in the Bonsai World Species Library.",
                    "Botanical authority (for reference only, not shown in list title): Coaz.",
                    "Hybrid status: Artificial hybrid. Parentage: Larix decidua × Larix kaempferi (European Larch × Japanese Larch).",
                    "Recognised synonym: Larix × eurolepis. The synonym may appear in older literature and nursery material; Bonsai World resolves both names to this Species Profile.",
                    "Common names: Hybrid Larch (primary), Dunkeld Larch, Hybridlerk (Norwegian).",
                    "Family: Pinaceae. Type: Deciduous conifer.",
                    "Bonsai World hierarchy: Species / hybrid → cultivar or selection where verified → Individual Tree.",
                ]
            ),
            SpeciesProfileSection(
                id: "overview",
                title: "Species Overview",
                paragraphs: [
                    "Larix × marschlinsii, commonly known as Hybrid Larch or Dunkeld Larch, is a hybrid between European Larch, Larix decidua, and Japanese Larch, Larix kaempferi.",
                    "It is a deciduous conifer, producing soft needles during the growing season before turning autumn colour and shedding its foliage for winter dormancy.",
                    "The hybrid is particularly notable for strong growth and hybrid vigour. In favourable conditions it can grow very rapidly and may develop trunk thickness and structural mass faster than many slower-growing bonsai species.",
                    "For bonsai, this makes Hybrid Larch especially valuable during the development stage.",
                    "Strong growth can be deliberately used to develop trunk diameter, primary branches, sacrifice branches, root systems, nebari and overall structural mass.",
                    "However, the same vigour must be controlled during refinement. A tree that is allowed to grow freely for development may require a very different management strategy once the desired trunk and primary branch structure has been established.",
                    "Hybrid Larch is therefore particularly well suited to the Bonsai World development model: grow where development is required; control where refinement is required.",
                ],
                bullets: [
                    "Deciduous conifer",
                    "Hybrid between European Larch and Japanese Larch",
                    "Strong hybrid vigour",
                    "Fast growth potential",
                    "Strong trunk development potential",
                    "Good response to developmental cultivation",
                    "Fine needle structure suitable for bonsai",
                    "Strong potential for ramification",
                    "Attractive deciduous seasonal character",
                    "Suitable for structural pruning",
                    "Suitable for wiring",
                    "Strong development potential from young material",
                    "Good candidate for both development and refinement",
                    "Requires winter dormancy",
                    "Root systems require protection from severe freezing in shallow containers",
                ]
            ),
            SpeciesProfileSection(
                id: "hybrid-character",
                title: "Hybrid Character",
                paragraphs: [
                    "Hybrid Larch should not be understood as simply having fixed characteristics halfway between its two parent species.",
                    "Individual trees may show variation. Some characteristics may appear closer to European Larch. Others may appear closer to Japanese Larch.",
                    "The hybrid can also show strong hybrid vigour, particularly during development.",
                    "For Bonsai World purposes, the hybrid identity should therefore be treated as useful horticultural context rather than a rigid prediction of behaviour.",
                    "Operational decisions should continue to depend on individual growth strength, root condition, development stage, branch structure, climate, container size, recent work and current health.",
                ]
            ),
            SpeciesProfileSection(
                id: "natural-growth",
                title: "Natural Growth",
                paragraphs: [
                    "Hybrid Larch is capable of strong and rapid annual growth. This vigour is one of its most important characteristics for bonsai development.",
                    "Young material can rapidly increase in height, trunk diameter, branch thickness and root mass.",
                    "During development, this growth can be used deliberately rather than constantly suppressed.",
                    "Strong extension growth may be useful when additional thickness is required. Sacrifice branches can be particularly useful for accelerating trunk development. Primary branches may also be allowed to extend where additional thickness is required.",
                    "Once sufficient structural development has been achieved, the management strategy should gradually shift toward refinement.",
                    "During refinement, excessive extension can become undesirable because it may cause coarse branch structure, excessive internode extension, rapid branch thickening, loss of silhouette and loss of proportional structure.",
                    "Strong growth is therefore both an advantage and a management responsibility.",
                ]
            ),
            SpeciesProfileSection(
                id: "needles",
                title: "Needles",
                paragraphs: [
                    "Hybrid Larch produces soft, deciduous needles.",
                    "The needles are borne in characteristic clusters on short shoots, while young extension growth also carries needles along the developing shoot.",
                    "The foliage provides a lighter and more delicate visual character than many evergreen conifers.",
                    "During autumn, the needles change colour before being shed for winter. This seasonal cycle is an important part of the species identity and bonsai presentation.",
                    "Needle size and density are influenced by tree vigour, branch strength, development stage, available resources, pruning strategy, container size, root development and light exposure.",
                    "Needle reduction should therefore be considered primarily as a result of balanced bonsai cultivation and branch development rather than a single isolated technique.",
                ]
            ),
            SpeciesProfileSection(
                id: "autumn-colour",
                title: "Autumn Colour",
                paragraphs: [
                    "As a deciduous conifer, Hybrid Larch develops seasonal autumn colour before losing its needles.",
                    "Autumn presentation can be an important aesthetic feature of the species.",
                    "The exact intensity and timing of autumn colour will depend on genetics, climate, seasonal temperatures, light, tree health and growing conditions.",
                    "Do not treat a specific autumn colour or calendar date as guaranteed for every tree.",
                ]
            ),
            SpeciesProfileSection(
                id: "bark-trunk",
                title: "Bark & Trunk",
                paragraphs: [
                    "Hybrid Larch has strong potential for trunk development.",
                    "During the early stages, bark is relatively smooth. As the tree matures, bark texture and trunk character become increasingly important to the visual quality of the bonsai.",
                    "Strong growth can be deliberately used to accelerate trunk development.",
                    "Useful development approaches may include sacrifice branches, controlled extension growth, ground development where appropriate, large development containers, strategic trunk cuts and repeated grow-and-cut cycles.",
                    "The objective should not simply be maximum trunk thickness. The objective is controlled development of taper, movement, trunk line, branch transitions, root flare and overall proportion.",
                    "Once the required trunk structure has been achieved, priorities should shift toward branch structure and refinement.",
                ]
            ),
            SpeciesProfileSection(
                id: "roots-nebari",
                title: "Roots & Nebari",
                paragraphs: [
                    "Hybrid Larch has strong root development potential.",
                    "Root development should be considered from an early stage rather than treated only as a future repotting task.",
                    "The objective should be to develop a balanced and functional root system capable of supporting the intended bonsai design.",
                    "Nebari potential is generally good when root structure is deliberately managed.",
                    "Useful approaches may include root selection, radial root positioning, removal of unsuitable dominant roots, controlled container development, progressive root pruning, early correction of crossing roots and root-over-rock development where suitable.",
                    "The objective should be a stable and visually convincing root base rather than simply maximum root quantity.",
                ]
            ),
            SpeciesProfileSection(
                id: "light",
                title: "Light",
                paragraphs: [
                    "Hybrid Larch is an outdoor bonsai species and requires strong light for healthy development.",
                    "Strong light generally supports vigorous growth, needle health, bud development, structural development and general tree strength.",
                    "However, light exposure must always be considered together with temperature, wind, water availability, root condition, container size, recent work and development stage.",
                    "A healthy established tree with a strong root system can tolerate conditions that may be unsuitable for recently repotted trees, newly collected material, weak trees, trees with reduced roots or trees in very shallow containers.",
                    "Species information is guidance, not a replacement for observing the individual tree.",
                ]
            ),
            SpeciesProfileSection(
                id: "wind",
                title: "Wind",
                paragraphs: [
                    "Hybrid Larch should be protected from conditions where excessive wind creates unnecessary stress.",
                    "Wind can increase transpiration and water demand.",
                    "Particular attention should be given to shallow containers, newly developing foliage, recently repotted trees, trees with reduced root systems, hot weather and strong drying winds.",
                    "Strong light combined with wind and limited root volume can significantly increase monitoring requirements.",
                ]
            ),
            SpeciesProfileSection(
                id: "watering",
                title: "Watering",
                paragraphs: [
                    "Hybrid Larch can have a high water demand during active growth.",
                    "The substrate should remain appropriately moist while maintaining sufficient drainage and aeration.",
                    "General principle: moist, well-drained and well-aerated substrate.",
                    "Watering frequency must depend on temperature, sun exposure, wind, rain, container size, substrate composition, particle size, root mass, tree size, development stage and current growth activity.",
                    "Do not water according to a fixed timetable. Water according to the condition of the tree and substrate.",
                    "A vigorous tree in active growth may have a significantly higher water demand than the same tree during dormancy or after major root work.",
                ]
            ),
            SpeciesProfileSection(
                id: "soil",
                title: "Soil",
                paragraphs: [
                    "Hybrid Larch benefits from a stable and well-draining bonsai substrate with sufficient moisture retention.",
                    "The ideal substrate depends on climate, rainfall, watering frequency, container depth, tree development stage, root density and root condition.",
                    "Important substrate characteristics include good drainage, good aeration, appropriate moisture retention, stable particle structure and suitable particle size for the tree and development stage.",
                    "Bonsai World does not prescribe one universal soil recipe for this species.",
                    "Substrate selection should be connected to the individual tree and growing environment.",
                ]
            ),
            SpeciesProfileSection(
                id: "fertilizing",
                title: "Fertilizing",
                paragraphs: [
                    "Hybrid Larch can make strong use of available nutrients during active development.",
                    "Fertilization should depend on tree health, development stage, current growth, season, root condition, recent work and development objectives.",
                    "A tree being developed for trunk or branch structure may support stronger feeding than a refined tree where controlled growth is the priority.",
                    "Strong fertilization should not automatically be applied simply because Hybrid Larch is vigorous.",
                    "Feed the tree you are growing, not simply the hybrid profile you have selected.",
                ]
            ),
            SpeciesProfileSection(
                id: "pruning",
                title: "Pruning",
                paragraphs: [
                    "Pruning strategy should depend strongly on development stage.",
                    "During development, strong extension growth may be deliberately allowed where additional thickness is required. Once sufficient thickness has been achieved, growth can be reduced according to the structural plan.",
                    "During refinement, pruning can be used to maintain silhouette, develop branch structure, control excessive extension, maintain proportional growth, improve light penetration, prevent unnecessary thickening and improve branch hierarchy.",
                    "Do not apply refinement pruning to a tree that still requires major structural development unless that trade-off is intentional.",
                ]
            ),
            SpeciesProfileSection(
                id: "ramification",
                title: "Ramification",
                paragraphs: [
                    "Hybrid Larch has strong potential for developing branch structure and ramification.",
                    "The main challenge is balancing vigour, extension growth, branch thickness, bud development and fine ramification.",
                    "During development: allow selected shoots to extend where additional structural thickness is required.",
                    "During refinement: control excessive extension once the desired branch structure has been established.",
                    "Fine branch development should not be forced at the expense of the overall structural hierarchy.",
                ]
            ),
            SpeciesProfileSection(
                id: "back-budding",
                title: "Back-budding",
                paragraphs: [
                    "Hybrid Larch has useful back-budding potential, but it should not be treated as guaranteed.",
                    "Bud development depends on factors including tree health, branch strength, age and condition of the branch, light availability, season, pruning history and overall vigour.",
                    "When rebuilding branch structure, monitor the actual response of the individual tree rather than assuming that new buds will automatically appear in every desired position.",
                ]
            ),
            SpeciesProfileSection(
                id: "wiring",
                title: "Wiring",
                paragraphs: [
                    "Hybrid Larch can be wired successfully.",
                    "Wiring may be useful for primary branch positioning, secondary branch development, trunk movement and structural refinement.",
                    "However, strong growth can cause branches to increase in thickness relatively quickly. Wire should therefore be monitored regularly.",
                    "The risk of wire marks increases when growth is strong, branches are thickening rapidly, the tree is heavily fertilized or the tree is in active development.",
                    "Wiring should be considered a temporary structural tool. The tree should not be left unchecked simply because the initial wire placement was correct.",
                ]
            ),
            SpeciesProfileSection(
                id: "defoliation",
                title: "Defoliation",
                paragraphs: [
                    "Hybrid Larch should not be managed using broadleaf defoliation logic.",
                    "Needle management and foliage refinement should instead be approached through species-appropriate pruning and shoot management.",
                    "Avoid importing techniques directly from deciduous broadleaf species without considering the biological differences of Larix.",
                ]
            ),
            SpeciesProfileSection(
                id: "repotting",
                title: "Repotting",
                paragraphs: [
                    "Repotting requirements should depend on root development, root density, container size, substrate condition, tree health, development stage and climate.",
                    "A young development tree may require different root management from a mature refined bonsai.",
                    "Hybrid Larch can respond well to appropriate root work when healthy, but tolerance does not mean unlimited tolerance.",
                    "Major root reduction should always be balanced against tree health, remaining root mass, seasonal timing and aftercare conditions.",
                    "Repot when the tree and root system indicate that it is appropriate, using species-specific seasonal knowledge as guidance rather than as a rigid calendar rule.",
                ]
            ),
            SpeciesProfileSection(
                id: "trunk-development",
                title: "Trunk Development",
                paragraphs: [
                    "Hybrid Larch is particularly valuable for trunk development because of its strong growth potential.",
                    "During development, useful approaches may include sacrifice branches, controlled extension growth, ground growing where appropriate, large development containers, grow-and-cut development and strategic trunk cuts.",
                    "The objective should be controlled trunk development rather than uncontrolled size.",
                    "Develop taper, movement, trunk line, proportion and root flare.",
                    "Once the required trunk structure has been achieved, priorities should gradually shift toward branch refinement.",
                    "Grow where thickness is needed. Control where refinement is required.",
                ]
            ),
            SpeciesProfileSection(
                id: "nebari-development",
                title: "Nebari Development",
                paragraphs: [
                    "Nebari should be developed from an early stage.",
                    "Potential techniques include root pruning, radial root positioning, root selection, controlled container development, progressive correction of root defects, root grafting where appropriate and root-over-rock development.",
                    "The objective should be a balanced radial root structure and convincing visual connection between trunk and substrate.",
                    "Avoid treating a large quantity of roots as automatically equal to good nebari.",
                ]
            ),
            SpeciesProfileSection(
                id: "grafting",
                title: "Grafting",
                paragraphs: [
                    "Grafting may be relevant where existing material does not provide the desired branch or root structure.",
                    "Potential applications may include root grafting, approach grafting and branch grafting where appropriate.",
                    "Detailed grafting procedures should belong in Bonsai World Propagation Knowledge Articles and be linked from this profile rather than duplicated here.",
                    "Any graft performed on an individual tree should be documented in Shaping History.",
                ]
            ),
            SpeciesProfileSection(
                id: "air-layering",
                title: "Air Layering",
                paragraphs: [
                    "Air layering may be possible on suitable material, but should be treated as an individual propagation decision rather than a routine bonsai technique.",
                    "Potential uses include separating a desirable upper section, recovering useful material from a larger tree and creating a new starting point from an existing branch or trunk section.",
                    "Success depends on timing, tree health, technique and aftercare.",
                    "Detailed procedures belong in Bonsai World Propagation Knowledge Articles.",
                ]
            ),
            SpeciesProfileSection(
                id: "propagation",
                title: "Propagation",
                paragraphs: [
                    "Potential propagation approaches may include seed, cuttings where appropriate, grafting and air layering where appropriate.",
                    "Because Hybrid Larch is a hybrid, propagation method matters when the objective is to reproduce specific characteristics.",
                    "Seed-grown offspring should not automatically be assumed to reproduce the exact characteristics of the parent tree.",
                    "Detailed propagation procedures should be maintained separately in Propagation Knowledge Articles.",
                ]
            ),
            SpeciesProfileSection(
                id: "cultivars",
                title: "Cultivars & Selected Forms",
                paragraphs: [
                    "Larix × marschlinsii is primarily represented in cultivation as Hybrid Larch material rather than through a large number of widely established bonsai cultivars.",
                    "For Bonsai World purposes, cultivar information should therefore be handled conservatively.",
                    "The Species Profile should focus primarily on the hybrid itself.",
                    "Do not artificially create a large cultivar catalogue simply to match species that have many horticultural selections.",
                    "Where verified named cultivars or selections are added in the future, they should only be included when their identity is well established, their botanical naming is verified, their characteristics are sufficiently documented and they are relevant to bonsai or horticultural cultivation.",
                    "For most bonsai purposes, seedling or nursery-grown Hybrid Larch material may be more relevant than named cultivars.",
                ]
            ),
            SpeciesProfileSection(
                id: "pests",
                title: "Pests & Problems",
                paragraphs: [
                    "Potential problems can include aphids and other sap-feeding insects, mites, caterpillars, fungal foliage problems, root problems associated with excessive moisture, root problems associated with poor aeration, stress caused by drought, damage associated with unsuitable winter protection and wire marks during rapid growth.",
                    "The exact risk depends heavily on local climate and growing conditions.",
                    "Diagnosis and treatment knowledge should be maintained separately in Care → Pest Management and linked from this Species Profile.",
                    "Prefer problem-specific sources rather than one undifferentiated list.",
                ]
            ),
            SpeciesProfileSection(
                id: "seasonal",
                title: "Seasonal Profile",
                paragraphs: [
                    "Spring: a major period of activity. Monitor bud break, new needle development, water demand, rapid extension growth, fertilization decisions, wiring requirements and structural pruning decisions. New growth should be managed according to the development objective of the tree. Do not automatically suppress strong growth that is intentionally being used for development.",
                    "Summer: can be a period of strong active growth. Monitor water demand, wind exposure, heat stress, extension growth, branch thickening, wire marks, fertilization and structural development. Strong growth may be useful during development but should be monitored carefully during refinement.",
                    "Autumn: the transition toward dormancy. Needles develop seasonal colour before shedding. Water demand gradually changes as active growth slows. Major management decisions should consider tree health, climate, dormancy progression, root condition and planned winter protection.",
                    "Winter: Hybrid Larch is dormant and requires a winter dormancy period. The primary bonsai concern is not simply the air temperature. The root system in a shallow bonsai container can be more exposed than the root system of a tree growing in open ground.",
                    "Winter protection should consider temperature, duration of freezing, wind, container size, root mass, root condition, soil moisture and location. Avoid using one universal temperature alarm for every tree. Winter management should respond to the actual exposure and condition of the individual bonsai.",
                ]
            ),
            SpeciesProfileSection(
                id: "styles",
                title: "Bonsai Styles",
                paragraphs: [
                    "Hybrid Larch is adaptable and can be developed into many bonsai forms.",
                    "Potential styles include informal upright, formal upright where material supports it, slanting, multiple trunk, twin trunk, group planting, root-over-rock and literati where appropriate material exists.",
                    "The final style should be determined primarily by the material.",
                    "Do not force every Hybrid Larch into the same design simply because the species is capable of multiple styles.",
                ]
            ),
            SpeciesProfileSection(
                id: "tree-stage",
                title: "Development by Tree Stage",
                paragraphs: [
                    "Seedling: establish healthy roots, build vigour, develop early trunk direction and begin root selection where appropriate.",
                    "Young material: build trunk potential, develop root structure, establish primary movement and identify useful sacrifice branches.",
                    "Nursery stock: assess existing trunk character, improve root structure, select primary branches and begin long-term design direction.",
                    "Pre-bonsai: establish trunk line, develop taper, select primary branches, develop nebari and begin structural refinement.",
                    "In training: continue branch development, develop ramification, improve trunk where still required, use wiring and pruning strategically and maintain healthy root development.",
                    "Refinement: fine branch development, controlled extension growth, improved silhouette, needle proportion, branch hierarchy and seasonal presentation.",
                    "Exhibition: maintain refined structure, maintain tree health, maintain seasonal presentation and avoid unnecessary major intervention.",
                ]
            ),
            SpeciesProfileSection(
                id: "attention",
                title: "Species-Specific Attention",
                paragraphs: [
                    "These attention points are tendencies that Bonsai World can use operationally. They must still be interpreted for the individual tree.",
                ],
                bullets: [
                    "Strong growth — watch excessive extension and rapid branch thickening",
                    "Hybrid vigour — do not assume every tree grows identically, but expect potentially strong development",
                    "Wiring — monitor carefully for wire marks during active growth",
                    "Root development — monitor for congestion and declining substrate structure",
                    "Development potential — use strong growth deliberately when building trunk and branches",
                    "Refinement — reduce uncontrolled extension once structural objectives have been achieved",
                    "Winter — protect the root system from severe freezing in shallow bonsai containers",
                    "Water demand — monitor carefully during warm and windy active growth periods",
                ]
            ),
        ]
    }
}
