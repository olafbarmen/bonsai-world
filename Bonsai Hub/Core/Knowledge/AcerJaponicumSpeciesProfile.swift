//
//  AcerJaponicumSpeciesProfile.swift
//  Bonsai World
//
//  Species Profile — Acer japonicum Thunb. (Full Moon Maple).
//  Botanical verification + bonsai knowledge + cultivar accuracy pass.
//  Knowledge status: Reviewed.
//

import Foundation

enum AcerJaponicumSpeciesProfile {
    /// Binomial used by Botanical Library / ``SpeciesPreviewData``.
    static let botanicalLibraryName = "Acer japonicum"
    /// Scientific name for Species Profile display (binomial; authorship in taxonomic sections).
    static let scientificName = "Acer japonicum"

    static var profile: SpeciesProfile {
        SpeciesProfile(
            speciesID: BotanicalKnowledgeIDs.acerJaponicum,
            scientificName: scientificName,
            commonNames: ["Full Moon Maple", "Japanese Maple", "Downy Japanese Maple"],
            family: "Sapindaceae",
            plantType: "Deciduous tree",
            originSummary: "Kuril Islands to Northern and Central Japan",
            knowledgeStatus: .reviewed,
            traits: traits,
            summaryLine: "Deciduous · Moderate growth · Good to excellent bonsai suitability — leaf scale matters",
            attentionHighlights: [
                "Large leaf scale should influence bonsai size decisions",
                "Growth may be slower than highly vigorous Acer species",
                "Major trunk development may require more patience",
                "Back-budding should not be assumed to be equivalent to Acer buergerianum",
                "Strong heat and drying conditions may affect foliage",
                "Leaf scale should not be reduced at the expense of health",
                "Cultivar identity must be verified carefully",
                "Some historical cultivar classifications may be incorrect",
                "Individual tree condition remains the final decision layer",
            ],
            sections: sections,
            principleNote: """
            Acer japonicum is particularly valued for large and distinctive foliage, deeply divided leaves in some forms, strong seasonal character, autumn colour and elegant deciduous structure.

            However, its bonsai development characteristics differ from the more vigorous Acer species.

            Acer japonicum should not automatically be managed as though it were Acer buergerianum or Acer palmatum.

            The species generally has different leaf scale, growth speed, development potential and ramification behaviour.

            Its greatest strength is often visual character rather than maximum development speed.

            The goal should be to develop the natural qualities of Acer japonicum.

            Do not force the species into the same refinement expectations as a small-leaved Acer palmatum cultivar.
            """,
            sourcesNote: """
            Profile content is synthesised from recognised botanical, horticultural and bonsai authorities into Bonsai World editorial language.

            Botanical taxonomy and distribution — Royal Botanic Gardens, Kew (Plants of the World Online) for accepted scientific name, family, native range and taxonomic identity.

            Horticultural information — Royal Horticultural Society; recognised botanical gardens and arboreta; Trees and Shrubs Online; university horticultural collections for cultivar identity, leaf characteristics, growth habit and seasonal characteristics.

            Bonsai-specific information — established bonsai organisations, recognised bonsai professionals, specialist bonsai publications and long-standing educational resources.

            Bonsai World synthesises verified information into its own language, terminology, operational philosophy and Species Knowledge architecture. Do not copy external source wording. Cultivar species attribution must be verified; historical nursery association is not sufficient.
            """
        )
    }

    /// Quick Reference — Bonsai World assessments for the species baseline (cultivars may differ).
    private static let traits = SpeciesProfileTraits(
        deciduous: true,
        growthStrength: "Moderate",
        growthSpeed: "Slow to Moderate",
        leafSize: "Medium to large, cultivar dependent",
        foliageReduction: "Limited to moderate — cultivar and tree dependent",
        ramificationPotential: "Moderate to High potential",
        backBudding: "Moderate potential",
        rootDevelopment: "Moderate",
        nebariPotential: "Good development potential",
        trunkDevelopment: "Slow to Moderate",
        barkDevelopment: "Moderate, age dependent",
        wiring: "Suitable — younger branches preferred",
        defoliation: "Selective — only where appropriate for healthy established trees",
        airLayering: "Suitable",
        threadGrafting: "Suitable",
        rootGrafting: "Suitable",
        beginnerSuitability: "Moderate",
        bonsaiSuitability: "Good to Excellent",
        difficulty: "Intermediate to Advanced",
        winterDormancyRequired: true,
        winterHardiness: "High",
        rootFrostSensitivity: "Moderate to High in shallow containers"
    )

    private static var sections: [SpeciesProfileSection] {
        [
            SpeciesProfileSection(
                id: "taxonomic-clarity",
                title: "Taxonomic Clarity",
                paragraphs: [
                    "Acer japonicum Thunb. is an accepted species. It belongs to a group of closely related Japanese maple species.",
                    "Do not automatically merge Acer japonicum with Acer palmatum, Acer shirasawanum or Acer sieboldianum. These must remain separate Species Profiles.",
                    "A horticultural or nursery source may occasionally use historical or alternative classifications. Bonsai World uses the currently accepted botanical identity as the primary reference.",
                    "Where historical naming is relevant, store it as a historical or horticultural naming note. Do not change the accepted Species identity.",
                    "Conceptual hierarchy: Species ≠ closely related species ≠ botanical taxa ≠ cultivars ≠ nursery trade names.",
                ]
            ),
            SpeciesProfileSection(
                id: "cultivar-misidentification",
                title: "Cultivar Misidentification Rule",
                paragraphs: [
                    "A named cultivar must not automatically be assigned to Acer japonicum because it is commonly sold under that species name. Cultivar identity must be verified.",
                    "Important example: do not automatically classify 'Aureum' as Acer japonicum. 'Aureum' has historically been associated with Acer japonicum in some horticultural contexts but requires correct species-level verification.",
                    "If the accepted horticultural identity is Acer shirasawanum 'Aureum', the cultivar belongs under Acer shirasawanum — not Acer japonicum. Do not duplicate it here.",
                    "Bonsai World prefers botanical and horticultural accuracy over nursery tradition.",
                ]
            ),
            SpeciesProfileSection(
                id: "overview",
                title: "Species Overview",
                paragraphs: [
                    "Acer japonicum Thunb., commonly known as Full Moon Maple (also Japanese Maple or Downy Japanese Maple), is a deciduous maple in the Sapindaceae family.",
                    "It is native from the Kuril Islands to Northern and Central Japan.",
                    "The species has distinctive palmately lobed foliage and strong seasonal interest. It is valuable for medium and larger bonsai.",
                    "It is generally less suitable for very small bonsai where leaf scale becomes visually disproportionate.",
                    "Particular value is often found in seasonal foliage, autumn colour, mature deciduous structure and naturalistic Japanese character.",
                    "Do not describe Acer japonicum as a miniature version of Acer palmatum.",
                ],
                bullets: [
                    "Deciduous maple (Sapindaceae)",
                    "Native: Kuril Islands to Northern and Central Japan",
                    "Distinctive palmately lobed foliage",
                    "Strong seasonal interest",
                    "Often best suited to medium and larger bonsai",
                    "Leaf scale must guide size decisions",
                    "Separate from Acer palmatum and Acer shirasawanum",
                ]
            ),
            SpeciesProfileSection(
                id: "natural-growth",
                title: "Natural Growth",
                paragraphs: [
                    "Acer japonicum generally develops with moderate vigor and may require more time for structural development than highly vigorous maples.",
                    "During development: allow selected growth where required for trunk development, primary branches and structural rebuilding. Do not over-prune development material.",
                    "During refinement: control unnecessary extension where required for branch proportion, ramification and silhouette.",
                    "Slow or moderate growth must be used deliberately.",
                    "Grow where development is required. Control where refinement is required.",
                ]
            ),
            SpeciesProfileSection(
                id: "leaves",
                title: "Leaves",
                paragraphs: [
                    "Foliage is a major species characteristic. Leaves are generally broad, palmately lobed and larger than many commonly used Acer palmatum bonsai forms.",
                    "Leaf shape and division may vary. Cultivars may have more deeply divided leaves, narrower lobes, different foliage density or different autumn colour.",
                    "Leaf scale must be considered when evaluating bonsai size. Do not assume that leaf reduction will make Acer japonicum suitable for very small bonsai.",
                    "Leaf reduction depends on individual genetics, cultivar, tree vigor, ramification, shoot management, root condition, container and development stage.",
                    "The goal is visual proportion — not maximum leaf reduction.",
                ]
            ),
            SpeciesProfileSection(
                id: "flowers-seeds",
                title: "Flowers & Seeds",
                paragraphs: [
                    "Acer japonicum produces purplish-red spring flowers in clusters, generally before or around leaf emergence.",
                    "Winged fruits follow flowering.",
                    "Flowers are not normally the primary bonsai feature.",
                    "Seed-grown offspring show natural variation and do not automatically reproduce named cultivar characteristics. Named cultivars generally require appropriate vegetative propagation to maintain identity.",
                ]
            ),
            SpeciesProfileSection(
                id: "bark-trunk",
                title: "Bark & Trunk",
                paragraphs: [
                    "Young trees generally have relatively smooth bark. Bark character develops gradually with age. Do not promise heavily textured mature bark.",
                    "Trunk character is generally better described through natural movement, proportion, mature structure and seasonal presentation.",
                    "Trunk development should be described as Slow to Moderate. Do not promise rapid trunk development.",
                    "Larger growing space and controlled extension may support structural development. Speed depends on individual genetics, cultivar, root health, growing conditions and development strategy.",
                ]
            ),
            SpeciesProfileSection(
                id: "roots-nebari",
                title: "Roots & Nebari",
                paragraphs: [
                    "Acer japonicum has good potential for root and nebari development when managed intentionally. Nebari development should not be described as automatic.",
                    "Potential techniques may include root selection, radial root positioning, controlled root pruning, development containers and root grafting where appropriate.",
                    "Root management must respect tree health, growth rate, root condition and cultivar vigor. Avoid aggressive assumptions.",
                    "The objective is a balanced and visually convincing radial root base.",
                ]
            ),
            SpeciesProfileSection(
                id: "light",
                title: "Light",
                paragraphs: [
                    "Acer japonicum generally benefits from bright outdoor conditions. Healthy established trees may tolerate substantial light depending on local climate and conditions.",
                    "Do not prescribe full sun as a universal instruction.",
                    "Foliage can be affected by excessive summer heat, strong sun, drying wind and root moisture stress.",
                    "Monitor leaf condition, leaf edges, water demand, heat exposure and wind exposure. Trees in shallow containers may respond differently from trees with large root systems.",
                ]
            ),
            SpeciesProfileSection(
                id: "wind",
                title: "Wind",
                paragraphs: [
                    "Wind can increase transpiration, water demand, leaf-edge drying and heat stress.",
                    "The effect depends on temperature, humidity, root moisture, container depth and leaf mass.",
                    "Do not classify the entire species as universally wind-sensitive. The operational concern is environmental stress and increased water demand.",
                ]
            ),
            SpeciesProfileSection(
                id: "watering",
                title: "Watering",
                paragraphs: [
                    "Maintain appropriate moisture while preserving adequate oxygen around the roots.",
                    "Watering requirements depend on weather, temperature, wind, container size, substrate, leaf mass, root development, growth activity and tree health.",
                    "Avoid chronic waterlogging and repeated severe drying during active growth.",
                    "Do not use fixed watering schedules. Water according to the condition of the tree and substrate, not according to the clock.",
                ]
            ),
            SpeciesProfileSection(
                id: "soil",
                title: "Soil",
                paragraphs: [
                    "Do not prescribe one universal soil recipe. Do not copy the soil strategy directly from another Acer species.",
                    "The substrate should provide drainage, aeration, appropriate moisture retention and stable structure.",
                    "The final mix depends on climate, rainfall, watering frequency, container, tree stage, root density and local environment.",
                    "Bonsai World Soil recommendations may later be generated from species, cultivar, tree stage, climate and growing environment.",
                ]
            ),
            SpeciesProfileSection(
                id: "fertilizing",
                title: "Fertilizing",
                paragraphs: [
                    "Feed the tree you are growing, not simply the species you have.",
                    "Nutrition depends on health, development stage, current vigor, root condition, season and development objective.",
                    "During development, nutrition may support structural growth. During refinement, avoid unnecessary coarse growth.",
                    "Do not intentionally weaken the tree to reduce leaf size. The objective is balanced proportion and long-term health.",
                ]
            ),
            SpeciesProfileSection(
                id: "pruning",
                title: "Pruning",
                paragraphs: [
                    "Development pruning: allow selected growth where required for trunk development, primary branches and structural rebuilding. Avoid repeatedly cutting areas that still require thickness.",
                    "Refinement pruning: control extension where required for silhouette, branch proportion, ramification and light distribution.",
                    "Do not use a universal cut-back-to-two-leaves rule.",
                    "Pruning decisions depend on branch position, development stage, tree vigor, desired thickness and individual growth pattern.",
                ]
            ),
            SpeciesProfileSection(
                id: "back-budding",
                title: "Back-Budding",
                paragraphs: [
                    "Acer japonicum has moderate back-budding potential. Do not present structural rebuilding potential as equivalent to Acer buergerianum.",
                    "Response depends on tree health, branch age, available vigor, light, season, root condition and previous pruning.",
                    "Do not plan major structural work solely on the assumption that a new bud will appear at a desired location.",
                    "Where branch replacement is critical, evaluate existing buds, natural growth potential, grafting and alternative design options.",
                ]
            ),
            SpeciesProfileSection(
                id: "ramification",
                title: "Ramification",
                paragraphs: [
                    "Acer japonicum has good potential for deciduous ramification. Refinement should respect the natural scale and character of the species.",
                    "The objective is not to create extremely fine ramification at the expense of tree health.",
                    "Focus on branch hierarchy, appropriate taper, controlled spacing, secondary branching and natural silhouette.",
                    "Cultivar differences may significantly modify ramification potential.",
                ]
            ),
            SpeciesProfileSection(
                id: "wiring",
                title: "Wiring",
                paragraphs: [
                    "Wiring is suitable. Younger branches are generally easier to position. Older branches may become increasingly rigid.",
                    "Potential risks include branch breakage, bark damage and wire marks.",
                    "Do not use fixed wire removal schedules. Monitor actual branch growth.",
                    "Wire should be removed according to branch thickening, bark response and required position.",
                ]
            ),
            SpeciesProfileSection(
                id: "defoliation",
                title: "Defoliation",
                paragraphs: [
                    "Defoliation may be used selectively on healthy and established trees where appropriate.",
                    "Do not assume that Acer japonicum should be defoliated using the same approach as Acer buergerianum.",
                    "Potential objectives include improving light distribution, balancing vigor and supporting selected refinement objectives.",
                    "Do not present complete annual defoliation as standard practice.",
                    "Leaf scale is partly a natural species characteristic. Do not compromise tree health in pursuit of artificially small leaves.",
                ]
            ),
            SpeciesProfileSection(
                id: "repotting",
                title: "Repotting",
                paragraphs: [
                    "Repotting decisions depend on root development, substrate condition, container, tree health, development stage and climate.",
                    "Do not use fixed repotting intervals.",
                    "Avoid describing the species as highly tolerant of unlimited root work.",
                    "Repotting timing should be guided by seasonal biology, root condition and individual tree health. The individual tree determines whether root work is appropriate.",
                ]
            ),
            SpeciesProfileSection(
                id: "trunk-development",
                title: "Trunk Development",
                paragraphs: [
                    "Acer japonicum should not be described as a rapid trunk-development species. Use Slow to Moderate structural development potential.",
                    "Possible strategies include larger development containers, ground development where appropriate, selected sacrifice growth and strategic trunk development.",
                    "The species may require patience. Do not force rapid development through excessive intervention.",
                ]
            ),
            SpeciesProfileSection(
                id: "nebari-development",
                title: "Nebari Development",
                paragraphs: [
                    "Potential techniques may include root selection, radial root positioning, controlled root pruning, development containers and root grafting where appropriate.",
                    "The method must depend on the existing material. The objective is a convincing and balanced root base.",
                ]
            ),
            SpeciesProfileSection(
                id: "grafting",
                title: "Grafting",
                paragraphs: [
                    "Relevant techniques include approach grafting, thread grafting and root grafting.",
                    "Common bonsai use cases include introducing an important missing branch, improving root structure and correcting structural limitations.",
                    "Do not present grafting as a default technique. Consider grafting when natural development cannot reasonably achieve the design objective.",
                    "All grafting work performed on an individual tree must be documented in Shaping History.",
                ]
            ),
            SpeciesProfileSection(
                id: "air-layering",
                title: "Air Layering",
                paragraphs: [
                    "Air layering may be useful for creating new material, separating desirable trunk sections, correcting overly long material and developing independent trees.",
                    "Success depends on timing, tree health, technique and aftercare.",
                    "Detailed procedures belong in Propagation Knowledge Articles.",
                ]
            ),
            SpeciesProfileSection(
                id: "propagation",
                title: "Propagation",
                paragraphs: [
                    "Potential propagation methods may include seed, air layering and grafting.",
                    "Cutting propagation should only be described where supported for the species or individual cultivar. Do not assume all methods are equally practical for all material.",
                    "Seed-grown material must not automatically inherit a named cultivar identity. Cultivar identity requires appropriate vegetative propagation.",
                ]
            ),
            SpeciesProfileSection(
                id: "pests",
                title: "Pests & Problems",
                paragraphs: [
                    "Potential issues may include aphids, mites, scale insects, caterpillars, leaf scorch, fungal leaf problems, root problems associated with unsuitable moisture and Verticillium wilt.",
                    "Do not present this as a diagnostic system. Diagnosis and treatment belong in Care → Pest & Problem Management.",
                    "The Species Profile should link to relevant problem knowledge.",
                ]
            ),
            SpeciesProfileSection(
                id: "seasonal",
                title: "Seasonal Profile",
                paragraphs: [
                    "Spring: monitor bud break, foliage emergence, flowering, increasing water demand, late frost and pruning decisions.",
                    "Summer: monitor water demand, heat, drying wind, leaf condition and excessive environmental stress.",
                    "Autumn: monitor seasonal colour, reduced growth, changing water demand and preparation for dormancy.",
                    "Winter: dormancy is required. Monitor root exposure, severe or prolonged freezing, wind, container size and root condition.",
                    "Do not use one universal temperature threshold.",
                ]
            ),
            SpeciesProfileSection(
                id: "styles",
                title: "Bonsai Styles",
                paragraphs: [
                    "Acer japonicum is generally best suited to informal upright, twin trunk, multiple trunk, clump, naturalistic deciduous forms, and medium or large bonsai.",
                    "Small bonsai may be possible for exceptional material. Leaf scale must be evaluated realistically.",
                    "Do not classify the species as universally suitable for very small bonsai. The individual material determines the final style.",
                ]
            ),
            SpeciesProfileSection(
                id: "tree-stage",
                title: "Development by Tree Stage",
                paragraphs: [
                    "Seedling: establish healthy roots and early trunk structure.",
                    "Nursery Stock: develop roots, trunk and primary branches.",
                    "Pre-bonsai: establish trunk line, primary branches and structural direction.",
                    "In Training: develop branch structure while continuing structural development where needed.",
                    "Refinement: focus on branch proportion, ramification, seasonal presentation and natural silhouette.",
                    "Exhibition: maintain health and mature structure. Avoid unnecessary major intervention.",
                ]
            ),
            SpeciesProfileSection(
                id: "attention",
                title: "Species-Specific Attention",
                paragraphs: [
                    "These are operational tendencies. They are not automatic warnings.",
                ],
                bullets: [
                    "Large leaf scale should influence bonsai size decisions",
                    "Growth may be slower than highly vigorous Acer species",
                    "Major trunk development may require more patience",
                    "Back-budding should not be assumed to be equivalent to Acer buergerianum",
                    "Strong heat and drying conditions may affect foliage",
                    "Leaf scale should not be reduced at the expense of health",
                    "Cultivar identity must be verified carefully",
                    "Some historical cultivar classifications may be incorrect",
                    "Individual tree condition remains the final decision layer",
                ]
            ),
            SpeciesProfileSection(
                id: "cultivars-intro",
                title: "Cultivars",
                paragraphs: [
                    "This is a curated cultivar collection — not a complete nursery catalogue.",
                    "Species baseline → cultivar modifier → individual tree. Cultivar information must never overwrite individual tree observations.",
                    "For Acer japonicum, individual material may often be more important than cultivar identity. A straight-species tree with strong nebari, interesting trunk movement, balanced branch structure and appropriate leaf proportion may have greater bonsai potential than a named cultivar selected primarily for garden foliage.",
                    "Cultivar information is an additional knowledge layer — not an automatic bonsai quality rating.",
                ]
            ),
            SpeciesProfileSection(
                id: "cultivar-vitifolium",
                title: "Acer japonicum 'Vitifolium'",
                paragraphs: [
                    "Growth habit: deciduous maple with broad foliage character.",
                    "Growth strength: moderate; further cultivar verification required for precise claims.",
                    "Leaf characteristics: broad foliage; large-leaf character is a primary consideration.",
                    "Seasonal characteristics: strong autumn colour.",
                    "Potential bonsai suitability: Good to Excellent for appropriate material.",
                    "Recommended scale: likely better suited to medium and large bonsai. Do not assume suitability for small bonsai.",
                    "Known bonsai strengths: autumn colour and broad foliage presence in larger compositions.",
                    "Potential challenges: leaf scale may dominate small compositions.",
                    "Important differences from the straight species: emphasised large-leaf and autumn-colour character.",
                    "Verification status: curated priority cultivar; retained source references still required for Reviewed status.",
                    "Further cultivar verification required for detailed growth-speed claims.",
                ]
            ),
            SpeciesProfileSection(
                id: "cultivar-aconitifolium",
                title: "Acer japonicum 'Aconitifolium'",
                paragraphs: [
                    "Growth habit: distinctive foliage form with deeply divided leaves.",
                    "Growth strength: further cultivar verification required.",
                    "Leaf characteristics: deeply divided foliage and distinctive leaf structure.",
                    "Seasonal characteristics: strong autumn colour.",
                    "Potential bonsai suitability: evaluate leaf scale and branching individually.",
                    "Recommended scale: do not assume that foliage structure alone makes the cultivar suitable for small bonsai.",
                    "Known bonsai strengths: distinctive deeply divided foliage and seasonal colour.",
                    "Potential challenges: leaf scale and branching must be assessed on the actual tree.",
                    "Important differences from the straight species: deeper leaf division and ornamental foliage emphasis.",
                    "Verification status: curated priority cultivar; further verification of operational bonsai detail required.",
                    "Further cultivar verification required.",
                ]
            ),
            SpeciesProfileSection(
                id: "cultivar-green-cascade",
                title: "Acer japonicum 'Green Cascade'",
                paragraphs: [
                    "Growth habit: strongly divided foliage with pendulous or cascading growth habit.",
                    "Growth strength: further cultivar verification required.",
                    "Leaf characteristics: strongly divided foliage.",
                    "Seasonal characteristics: ornamental deciduous presentation.",
                    "Potential bonsai suitability: distinctive design possibilities where cascading character is retained.",
                    "Recommended scale: evaluate individually; do not force conventional upright architecture.",
                    "Known bonsai strengths: natural cascading character and divided foliage.",
                    "Potential challenges: forcing upright form may fight the natural habit.",
                    "Important differences from the straight species: pendulous / cascading growth habit.",
                    "Verification status: curated priority cultivar; evaluate natural character first.",
                    "Further cultivar verification required for growth-strength detail.",
                ]
            ),
            SpeciesProfileSection(
                id: "cultivar-otaki",
                title: "Acer japonicum 'Otaki'",
                paragraphs: [
                    "Include only where cultivar identity and characteristics are sufficiently verified.",
                    "Focus verification on leaf character, growth habit and bonsai scale.",
                    "Growth habit / growth strength / operational bonsai claims: further cultivar verification required.",
                    "Important differences from the straight species: further cultivar verification required.",
                    "Verification status: identity and characteristics pending retained sources.",
                    "Further cultivar verification required — include operational detail only after sufficient verification.",
                ]
            ),
            SpeciesProfileSection(
                id: "cultivar-fairy-lights",
                title: "Acer japonicum 'Fairy Lights'",
                paragraphs: [
                    "Include only after sufficient verification.",
                    "Do not invent bonsai suitability.",
                    "Growth habit / leaf characteristics / bonsai suitability: further cultivar verification required.",
                    "Important differences from the straight species: further cultivar verification required.",
                    "Verification status: insufficient verified bonsai characteristics for operational inheritance.",
                    "Further cultivar verification required — do not invent bonsai suitability.",
                ]
            ),
            SpeciesProfileSection(
                id: "cultivar-rising-sun",
                title: "Acer japonicum 'Rising Sun'",
                paragraphs: [
                    "Include only after sufficient verification.",
                    "Document foliage and growth characteristics when retained sources are available.",
                    "Do not assume ornamental popularity equals bonsai suitability.",
                    "Growth habit / leaf characteristics / bonsai suitability: further cultivar verification required.",
                    "Important differences from the straight species: further cultivar verification required.",
                    "Verification status: ornamental popularity is not sufficient for bonsai operational claims.",
                    "Further cultivar verification required.",
                ]
            ),
            SpeciesProfileSection(
                id: "cultivar-exclusion",
                title: "Cultivar Exclusion",
                paragraphs: [
                    "'Aureum' is not included under Acer japonicum in this profile.",
                    "If authoritative horticultural sources identify the material as Acer shirasawanum 'Aureum', it belongs under Acer shirasawanum — not Acer japonicum.",
                    "Historical nursery association is not sufficient for species attribution.",
                ]
            ),
            SpeciesProfileSection(
                id: "cultivar-selection",
                title: "Cultivar Selection Principle",
                paragraphs: [
                    "For Acer japonicum, individual material may often be more important than cultivar identity.",
                    "A straight-species tree with strong nebari, interesting trunk movement, balanced branch structure and appropriate leaf proportion may have greater bonsai potential than a named cultivar selected primarily for garden foliage.",
                    "Cultivar information is an additional knowledge layer — not an automatic bonsai quality rating.",
                    "Species baseline → cultivar modifier → individual tree. Cultivar information must never overwrite individual tree observations.",
                ]
            )
        ]
    }
}
