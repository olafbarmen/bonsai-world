//
//  AcerPalmatumSpeciesProfile.swift
//  Bonsai World
//
//  Species Profile — Acer palmatum Thunb. (Japanese Maple).
//  Reference profile for species with a large curated cultivar collection.
//  Knowledge status: Reviewed.
//

import Foundation

enum AcerPalmatumSpeciesProfile {
    /// Binomial used by Botanical Library / ``SpeciesPreviewData``.
    static let botanicalLibraryName = "Acer palmatum"
    /// Scientific name for Species Profile display (binomial; authorship in taxonomic sections).
    static let scientificName = "Acer palmatum"

    static var profile: SpeciesProfile {
        SpeciesProfile(
            speciesID: BotanicalKnowledgeIDs.acerPalmatum,
            scientificName: scientificName,
            commonNames: ["Japanese Maple"],
            family: "Sapindaceae",
            plantType: "Deciduous tree or large shrub",
            originSummary: "Japan and Korea",
            knowledgeStatus: .reviewed,
            traits: traits,
            summaryLine: "Deciduous · Moderate to strong growth · Excellent bonsai suitability — cultivar dependent",
            attentionHighlights: [
                "Leaf scorch risk increases with excessive exposure, drying wind and insufficient moisture",
                "Cultivar differences can significantly affect growth and sensitivity",
                "Fine branches can become coarse if strong extension is not controlled",
                "Wiring requires monitoring during active growth",
                "Defoliation should be selective and tree-specific",
                "Root systems in shallow containers require protection during severe or prolonged freezing",
                "Named cultivar information must modify the species baseline where relevant",
                "Individual tree condition remains the final decision layer",
            ],
            sections: sections,
            principleNote: """
            Acer palmatum is one of the most important bonsai species, but it is not one uniform bonsai tree.

            The species includes substantial variation through natural variation, botanical variation, horticultural groups and cultivars.

            Cultivars may differ significantly in vigor, growth habit, leaf size, leaf colour, seasonal colour, internode length, branch density, sun tolerance, wind sensitivity and development speed.

            Therefore Acer palmatum care should not be interpreted as a universal instruction for every cultivar.

            The Species Profile provides the baseline.

            Cultivar information modifies that baseline.

            The individual tree remains the final decision layer.
            """,
            sourcesNote: """
            Profile content is synthesised from recognised botanical, horticultural and bonsai authorities into Bonsai World editorial language.

            Botanical taxonomy and distribution — Royal Botanic Gardens, Kew (Plants of the World Online) for accepted scientific name, family, native range and accepted infraspecific taxa.

            Horticultural information — Royal Horticultural Society for general horticultural characteristics, cultivar identity, habit, leaf and seasonal characteristics.

            Bonsai-specific information — established bonsai organisations, recognised bonsai professionals, long-standing educational resources and specialist bonsai publications.

            Bonsai World synthesises verified information into its own language, terminology, data model and operational philosophy. Do not copy external source wording.
            """
        )
    }

    /// Quick Reference — Bonsai World assessments for the species baseline (not universal measurements; cultivars may differ).
    private static let traits = SpeciesProfileTraits(
        deciduous: true,
        growthStrength: "Moderate to Strong",
        growthSpeed: "Moderate",
        leafSize: "Small to medium, cultivar dependent",
        foliageReduction: "Good potential — cultivar and cultivation dependent",
        ramificationPotential: "High potential",
        backBudding: "Good potential",
        rootDevelopment: "Moderate to Strong",
        nebariPotential: "Good development potential",
        trunkDevelopment: "Moderate potential",
        barkDevelopment: "Cultivar and age dependent",
        wiring: "Suitable — younger branches preferred",
        defoliation: "Selective — healthy established trees only",
        airLayering: "Suitable",
        threadGrafting: "Suitable",
        rootGrafting: "Suitable",
        beginnerSuitability: "Moderate",
        bonsaiSuitability: "Excellent",
        difficulty: "Intermediate to Advanced",
        winterDormancyRequired: true,
        winterHardiness: "High",
        rootFrostSensitivity: "Moderate to High in shallow containers"
    )

    private static var sections: [SpeciesProfileSection] {
        [
            SpeciesProfileSection(
                id: "taxonomic-context",
                title: "Taxonomic Context",
                paragraphs: [
                    "Acer palmatum Thunb. is an accepted species and contains recognised infraspecific botanical variation.",
                    "Botanical subspecies, horticultural groups and named cultivars are different classification layers and must not be confused.",
                    "Bonsai World hierarchy: Species → botanical infraspecific variation where relevant → cultivar / horticultural selection → individual tree.",
                    "The individual tree should store the most precise identity available (for example species Acer palmatum, cultivar 'Deshōjō', and the tree's own bonsai identity).",
                ]
            ),
            SpeciesProfileSection(
                id: "overview",
                title: "Species Overview",
                paragraphs: [
                    "Acer palmatum Thunb., commonly known as Japanese Maple, is a deciduous maple in the Sapindaceae family, native to Japan and Korea.",
                    "It is one of the most important species groups in ornamental horticulture and is widely used for bonsai.",
                    "Leaf and growth characteristics are highly variable. The species is capable of refined ramification and is highly valued for seasonal change, including autumn colour.",
                    "Natural aesthetic strengths often include fine branching, seasonal foliage, elegant trunk movement and a refined deciduous silhouette.",
                    "Growth rate and robustness vary significantly. Not every Acer palmatum is naturally delicate, and not every cultivar is slow growing.",
                    "Some cultivars are more vigorous and robust than others. Cultivar information must modify the species baseline where relevant.",
                ],
                bullets: [
                    "Deciduous maple (Sapindaceae)",
                    "Native to Japan and Korea",
                    "Highly variable leaf and growth characteristics",
                    "Important for traditional and modern bonsai",
                    "High potential for refined ramification",
                    "Strong seasonal ornamental value",
                    "Cultivar differences can be substantial",
                ]
            ),
            SpeciesProfileSection(
                id: "natural-growth",
                title: "Natural Growth",
                paragraphs: [
                    "Growth behaviour varies significantly within Acer palmatum.",
                    "The straight species can develop stronger growth than many compact ornamental cultivars.",
                    "Development: allow selected growth where required for trunk thickness, primary branches, sacrifice growth and structural rebuilding.",
                    "Refinement: control growth where required for ramification, branch proportion, internode management, leaf proportion and silhouette.",
                    "Grow where development is required. Control where refinement is required.",
                    "Do not apply identical pruning expectations to young development trees, mature bonsai, dwarf cultivars, vigorous green cultivars, red-leaved cultivars or variegated cultivars.",
                ]
            ),
            SpeciesProfileSection(
                id: "leaves",
                title: "Leaves",
                paragraphs: [
                    "Acer palmatum typically produces palmately lobed leaves. Leaf characteristics vary considerably in number of lobes, depth of lobing, leaf size, colour, texture and degree of dissection.",
                    "Straight-species foliage must not be confused with dissected cultivars. Use cultivar information where foliage characteristics are central to identity.",
                    "Leaf reduction depends on cultivar, tree vigor, ramification, shoot management, root condition, container size, development stage and overall cultivation.",
                    "Do not promise that all cultivars will reduce equally. The goal is visual proportion — not simply the smallest possible leaf.",
                ]
            ),
            SpeciesProfileSection(
                id: "flowers-seeds",
                title: "Flowers & Seeds",
                paragraphs: [
                    "Acer palmatum produces small spring flowers. Flower colour may range from reddish to purple-toned depending on the material.",
                    "Winged fruits follow flowering as part of the natural life cycle.",
                    "Flowering and fruiting are not normally the primary bonsai feature.",
                    "Seed-grown offspring should not be assumed to reproduce the characteristics of named cultivars. Cultivar identity is normally maintained through appropriate vegetative propagation.",
                ]
            ),
            SpeciesProfileSection(
                id: "bark-trunk",
                title: "Bark & Trunk",
                paragraphs: [
                    "Young Acer palmatum generally has relatively smooth bark. Bark and trunk character develop with age.",
                    "Do not promise rugged mature bark comparable to Acer campestre. Acer palmatum generally has a different visual character.",
                    "Aesthetic strength is often found in fine trunk movement, smooth to subtly textured bark, delicate branching, proportion and seasonal presentation.",
                    "Trunk development is possible but often slower than highly vigorous species such as Acer buergerianum. Cultivar vigor must be considered.",
                ]
            ),
            SpeciesProfileSection(
                id: "roots-nebari",
                title: "Roots & Nebari",
                paragraphs: [
                    "Acer palmatum has good potential for root and nebari development when managed intentionally. Nebari development should not be presented as automatic.",
                    "Potential techniques may include root selection, radial root positioning, controlled root pruning, development containers and root grafting where appropriate.",
                    "The objective is a balanced and convincing radial root base.",
                    "Root work must consider cultivar vigor. Weak or slow-growing cultivars may respond differently from vigorous green forms.",
                ]
            ),
            SpeciesProfileSection(
                id: "light",
                title: "Light",
                paragraphs: [
                    "Acer palmatum is often grown successfully in bright conditions. Healthy established trees may tolerate substantial light.",
                    "Leaf scorch risk increases depending on cultivar, leaf colour, leaf thickness, temperature, wind, root moisture, root condition and sudden exposure changes.",
                    "Some cultivars tolerate stronger sun than others. Red-leaved and variegated cultivars must not automatically be assumed to have identical light tolerance.",
                    "Avoid universal full-sun instructions. Environmental response must be observed individually.",
                    "Provide particular attention to strong summer sun, drying wind, shallow containers, recently repotted trees, weak trees and variegated foliage.",
                ]
            ),
            SpeciesProfileSection(
                id: "wind",
                title: "Wind",
                paragraphs: [
                    "Acer palmatum foliage can be affected by drying wind. Wind may increase transpiration, water demand, leaf-edge damage and leaf scorch risk.",
                    "Sensitivity varies by cultivar and growing conditions.",
                    "Interpret risk together with temperature, humidity, root moisture, container depth and leaf condition.",
                    "Do not classify the entire species as universally wind-sensitive.",
                ]
            ),
            SpeciesProfileSection(
                id: "watering",
                title: "Watering",
                paragraphs: [
                    "Maintain appropriate moisture and oxygen availability around the roots.",
                    "Water demand depends on cultivar, weather, temperature, wind, leaf mass, container, substrate, root development and tree health.",
                    "Avoid chronic waterlogging and repeated severe drying during active growth.",
                    "Do not prescribe fixed watering schedules. Water according to the condition of the tree and substrate, not according to the clock.",
                ]
            ),
            SpeciesProfileSection(
                id: "soil",
                title: "Soil",
                paragraphs: [
                    "Do not prescribe one universal Acer palmatum soil mix.",
                    "The substrate should provide drainage, aeration, appropriate moisture retention and stable structure.",
                    "The optimal mix depends on climate, rainfall, watering frequency, container size, cultivar, tree stage and root density.",
                    "Bonsai World may later generate soil recommendations from species, cultivar, tree stage, climate and growing location. Do not hardcode one recipe.",
                ]
            ),
            SpeciesProfileSection(
                id: "fertilizing",
                title: "Fertilizing",
                paragraphs: [
                    "Feed the tree you are growing, not simply the species you have.",
                    "Nutrition should depend on health, cultivar, development stage, desired growth, root condition and season.",
                    "Development trees may generally support stronger feeding than refined trees.",
                    "Avoid excessive feeding where it creates coarse internodes, excessive leaf size or unwanted extension.",
                    "Do not intentionally weaken a tree in pursuit of smaller leaves.",
                ]
            ),
            SpeciesProfileSection(
                id: "pruning",
                title: "Pruning",
                paragraphs: [
                    "Development pruning: allow growth where thickness is required for trunk development, primary branch development or structural rebuilding.",
                    "Refinement pruning: control extension where fine structure is required for ramification, silhouette, internode control, branch proportion and light penetration.",
                    "Do not use one fixed pruning formula for every cultivar. Avoid universal instructions such as always cutting back to two leaves.",
                    "Pruning points depend on branch thickness, tree vigor, cultivar, position and development goal.",
                ]
            ),
            SpeciesProfileSection(
                id: "back-budding",
                title: "Back-Budding",
                paragraphs: [
                    "Acer palmatum generally has useful back-budding potential. Response varies according to cultivar, tree health, branch age, light, pruning, season and root condition.",
                    "Do not treat back-budding as guaranteed.",
                    "Avoid planning structural work solely on the assumption that a new bud will appear in a specific location.",
                    "Cultivar-specific information may modify the baseline assessment.",
                ]
            ),
            SpeciesProfileSection(
                id: "ramification",
                title: "Ramification",
                paragraphs: [
                    "Acer palmatum has high potential for refined deciduous ramification and is particularly valued for elegant fine branching.",
                    "Successful ramification depends on controlled growth, correct development stage, branch health, light distribution, pruning strategy and cultivar vigor.",
                    "The goal is branch hierarchy, appropriate taper, controlled internodes, fine secondary branching and a convincing silhouette — not simply the maximum possible number of branches.",
                ]
            ),
            SpeciesProfileSection(
                id: "wiring",
                title: "Wiring",
                paragraphs: [
                    "Wiring is suitable. Younger branches are generally easier to position. Older branches may become increasingly rigid.",
                    "Potential risks include bark damage, wire marks, branch breakage and rapid growth around wire.",
                    "Cultivar differences must be respected. Monitor active branches.",
                    "Do not use fixed wire removal schedules. Wire removal should depend on actual growth.",
                ]
            ),
            SpeciesProfileSection(
                id: "defoliation",
                title: "Defoliation",
                paragraphs: [
                    "Defoliation may be used selectively on healthy, established Acer palmatum bonsai where appropriate.",
                    "Potential objectives include leaf size management, light penetration, ramification development and vigor balancing.",
                    "Defoliation is not automatically appropriate for every cultivar, every development stage, weak trees, recently repotted trees or recovering trees.",
                    "Avoid presenting complete annual defoliation as the default. Cultivar sensitivity must be considered.",
                    "Partial or selective techniques may sometimes be more appropriate than complete defoliation. Pruning — Defoliation covers the principle. This profile remains the species decision.",
                ]
            ),
            SpeciesProfileSection(
                id: "repotting",
                title: "Repotting",
                paragraphs: [
                    "Repotting decisions should depend on root development, substrate condition, container, tree health, cultivar vigor, development stage and climate.",
                    "Do not use a fixed repotting interval. A development tree may require different root management from a refined tree.",
                    "Avoid excessive root reduction. Tolerance for root work must not be presented as unlimited.",
                    "Species timing provides guidance. Individual root condition determines the operational decision.",
                ]
            ),
            SpeciesProfileSection(
                id: "trunk-development",
                title: "Trunk Development",
                paragraphs: [
                    "Acer palmatum can develop attractive trunks. Do not describe trunk development as uniformly fast.",
                    "Development speed depends strongly on cultivar, growing conditions, growing space and development strategy.",
                    "Possible methods include sacrifice growth, larger development containers, ground development and strategic trunk cuts.",
                    "The objective should preserve the species' natural elegant character.",
                ]
            ),
            SpeciesProfileSection(
                id: "nebari-development",
                title: "Nebari Development",
                paragraphs: [
                    "Potential methods include root selection, radial root positioning, root pruning, development containers and root grafting.",
                    "Do not apply every technique automatically. The existing material determines the correct strategy.",
                ]
            ),
            SpeciesProfileSection(
                id: "grafting",
                title: "Grafting",
                paragraphs: [
                    "Relevant techniques include approach grafting, thread grafting and root grafting.",
                    "Many named Acer palmatum cultivars are maintained through vegetative propagation. Do not imply that seedlings reliably reproduce cultivar characteristics.",
                    "Common bonsai use cases include adding a missing branch, improving root structure and correcting structural limitations.",
                    "Document all grafting work in Shaping History.",
                ]
            ),
            SpeciesProfileSection(
                id: "air-layering",
                title: "Air Layering",
                paragraphs: [
                    "Potential uses include creating new bonsai material, separating desirable trunk sections, correcting overly long trunks and developing independent material from branches.",
                    "Success depends on timing, tree health, cultivar, technique and aftercare.",
                    "Detailed instructions belong in Propagation Knowledge Articles.",
                ]
            ),
            SpeciesProfileSection(
                id: "propagation",
                title: "Propagation",
                paragraphs: [
                    "Potential methods may include seed, cuttings, air layering and grafting.",
                    "Seed-grown material should not automatically be labelled with the cultivar name of the parent.",
                    "Named cultivar identity requires appropriate propagation methods.",
                    "Keep detailed procedures outside the Species Profile.",
                ]
            ),
            SpeciesProfileSection(
                id: "pests",
                title: "Pests & Problems",
                paragraphs: [
                    "Potential issues may include aphids, mites, scale insects, caterpillars, leaf scorch, fungal leaf problems, root problems associated with unsuitable moisture and Verticillium wilt.",
                    "Do not use this section for diagnosis. Diagnosis and treatment belong in Care → Pest & Problem Management.",
                    "Species Profiles should link to relevant problem profiles.",
                ]
            ),
            SpeciesProfileSection(
                id: "seasonal",
                title: "Seasonal Profile",
                paragraphs: [
                    "Spring: monitor bud break, rapid foliage development, water demand, late frost risk, pruning decisions, wiring and fertilizing decisions.",
                    "Summer: monitor water demand, heat, drying wind, leaf scorch, excessive extension and wire marks.",
                    "Autumn: monitor seasonal colour, reduced growth, gradual changes in water demand and preparation for dormancy.",
                    "Winter: dormancy is required. Monitor root exposure, severe or prolonged freezing, wind, container size and root condition.",
                    "Do not use one universal temperature threshold. Cultivar and local climate must be considered.",
                ]
            ),
            SpeciesProfileSection(
                id: "styles",
                title: "Bonsai Styles",
                paragraphs: [
                    "Acer palmatum is highly versatile. Examples include informal upright, twin trunk, multiple trunk, clump, broom style, root-over-rock, and small, medium or large bonsai.",
                    "Some cultivars may be naturally better suited to particular forms.",
                    "Do not force cultivar architecture to match a style. The individual material determines the final design.",
                ]
            ),
            SpeciesProfileSection(
                id: "tree-stage",
                title: "Development by Tree Stage",
                paragraphs: [
                    "Seedling: establish healthy roots and early trunk structure.",
                    "Cutting: establish roots and early structure.",
                    "Nursery Stock: develop roots, trunk and primary branches.",
                    "Pre-bonsai: establish trunk line, primary branches and structural direction.",
                    "In Training: develop ramification while continuing structural development where needed.",
                    "Refinement: focus on fine ramification, leaf proportion, silhouette and branch hierarchy.",
                    "Exhibition: maintain health and refined structure. Avoid unnecessary major work.",
                ]
            ),
            SpeciesProfileSection(
                id: "attention",
                title: "Species-Specific Attention",
                paragraphs: [
                    "These are tendencies. They are not automatic warnings.",
                ],
                bullets: [
                    "Leaf scorch risk increases with excessive exposure, drying wind and insufficient moisture",
                    "Cultivar differences can significantly affect growth and sensitivity",
                    "Fine branches can become coarse if strong extension is not controlled",
                    "Wiring requires monitoring during active growth",
                    "Defoliation should be selective and tree-specific",
                    "Root systems in shallow containers require protection during severe or prolonged freezing",
                    "Named cultivar information must modify the species baseline where relevant",
                    "Individual tree condition remains the final decision layer",
                ]
            ),
            SpeciesProfileSection(
                id: "cultivars-intro",
                title: "Cultivars",
                paragraphs: [
                    "This is a curated Bonsai World Cultivar Collection — not an exhaustive nursery catalogue.",
                    "Cultivars are selected for historical bonsai relevance, common bonsai use, distinctive growth characteristics or particular development suitability.",
                    "Species baseline → cultivar modifier → individual tree. Cultivar information must never overwrite individual tree data.",
                    "Example: species baseline moderate growth; cultivar tendency compact growth; individual tree currently extremely vigorous — the individual tree condition remains operationally dominant.",
                    "Categories such as Fine Ramification, Compact / Small Leaf, Bark Character, Red Foliage, Seasonal Colour and Specialist / Display are filters only. A cultivar may belong to multiple categories.",
                ]
            ),
            SpeciesProfileSection(
                id: "cultivar-deshojo",
                title: "Acer palmatum 'Deshōjō'",
                paragraphs: [
                    "Growth habit: ornamental deciduous maple with strong seasonal foliage presentation.",
                    "Growth strength: further cultivar verification required relative to the straight species; do not automatically assume identical vigor.",
                    "Leaf characteristics: known primarily for strong red spring foliage and subsequent seasonal colour change.",
                    "Seasonal characteristics: strong ornamental character through spring and autumn presentation.",
                    "Ramification potential: further cultivar verification required.",
                    "Development suitability: further cultivar verification required.",
                    "Refinement suitability: often valued where seasonal presentation and refined deciduous character are priorities.",
                    "Known bonsai strengths: distinctive red spring foliage and ornamental seasonal change.",
                    "Potential challenges: light, heat and moisture management may require closer observation than for some green forms.",
                    "Important differences from the straight species: foliage colour and seasonal display are primary distinctions; growth behaviour must not be assumed identical.",
                    "Cultivar-specific notes: do not automatically inherit every Acer palmatum Quick Reference value.",
                    "Further cultivar verification required for detailed vigor, internode and ramification claims.",
                ],
                bullets: [
                    "Category filters: Red Foliage; Seasonal Colour; Specialist / Display",
                ]
            ),
            SpeciesProfileSection(
                id: "cultivar-shin-deshojo",
                title: "Acer palmatum 'Shin-deshōjō'",
                paragraphs: [
                    "Growth habit: red-leaved ornamental selection related in horticultural usage to deshōjō-type Japanese maples.",
                    "Important: include as a distinct cultivar. Do not merge automatically with 'Deshōjō'.",
                    "Leaf characteristics: red spring foliage is commonly associated with this selection.",
                    "Seasonal characteristics: ornamental colour change is a primary interest.",
                    "Development suitability / refinement suitability / ramification potential: further cultivar verification required.",
                    "Known bonsai strengths: specialist foliage presentation.",
                    "Potential challenges: do not assume identical behaviour to 'Deshōjō' or the straight species.",
                    "Important differences from the straight species: foliage colour focus; verified growth differences require retained sources.",
                    "Cultivar-specific notes: document differences only where verified.",
                    "Further cultivar verification required before detailed bonsai operational claims.",
                ],
                bullets: [
                    "Category filters: Red Foliage; Seasonal Colour",
                ]
            ),
            SpeciesProfileSection(
                id: "cultivar-kiyohime",
                title: "Acer palmatum 'Kiyohime'",
                paragraphs: [
                    "Growth habit: compact growth with fine proportions.",
                    "Growth strength: often more compact than vigorous green forms; verify before assigning high development speed.",
                    "Leaf characteristics: small foliage potential is a primary bonsai interest.",
                    "Seasonal characteristics: refined deciduous presentation.",
                    "Ramification potential: valued for fine proportions; further verification of operational details required.",
                    "Development suitability: generally less oriented to rapid trunk building than vigorous forms.",
                    "Refinement suitability: high interest for refined and small bonsai.",
                    "Known bonsai strengths: compact growth, small foliage potential, fine proportions.",
                    "Potential challenges: development speed may differ from vigorous Acer palmatum material.",
                    "Important differences from the straight species: compactness and scale suitability.",
                    "Cultivar-specific notes: verify cultivar-specific behaviour before assigning high vigor.",
                    "Further cultivar verification required for precise vigor and internode claims.",
                ],
                bullets: [
                    "Category filters: Compact / Small Leaf; Fine Ramification",
                ]
            ),
            SpeciesProfileSection(
                id: "cultivar-kiyohime-kotohime",
                title: "Acer palmatum 'Kiyohime Kotohime'",
                paragraphs: [
                    "Identity note: create as a separate profile only where horticultural identity is sufficiently verified.",
                    "Do not assume all nursery usage represents one standardised cultivar.",
                    "Growth habit / leaf characteristics / bonsai suitability: further cultivar verification required.",
                    "Important differences from the straight species: further cultivar verification required.",
                    "Cultivar-specific notes: retain as a named entry for identity tracking; do not invent operational characteristics.",
                    "Further cultivar verification required — horticultural status and standardised identity need retained sources.",
                ],
                bullets: [
                    "Category filters: Compact / Small Leaf",
                ]
            ),
            SpeciesProfileSection(
                id: "cultivar-kotohime",
                title: "Acer palmatum 'Kotohime'",
                paragraphs: [
                    "Growth habit: compact; important bonsai cultivar.",
                    "Growth strength: typically associated with compact rather than rapid development; further verification required.",
                    "Leaf characteristics: focus verification on leaf size and fine twigging.",
                    "Ramification potential: fine twigging is a primary interest.",
                    "Development suitability: often refinement-oriented; verify development speed.",
                    "Refinement suitability: high interest for small and refined bonsai.",
                    "Known bonsai strengths: fine twigging, compact growth, small leaf interest.",
                    "Potential challenges: trunk development may require patience relative to vigorous forms.",
                    "Important differences from the straight species: compactness and fine branching character.",
                    "Cultivar-specific notes: verify leaf size, fine twigging and development speed with retained sources.",
                    "Further cultivar verification required for detailed growth-speed claims.",
                ],
                bullets: [
                    "Category filters: Compact / Small Leaf; Fine Ramification",
                ]
            ),
            SpeciesProfileSection(
                id: "cultivar-mikawa-yatsubusa",
                title: "Acer palmatum 'Mikawa yatsubusa'",
                paragraphs: [
                    "Growth habit: compact with dense foliage and distinctive leaf arrangement.",
                    "Growth strength: do not automatically classify as easy for trunk development.",
                    "Leaf characteristics: dense foliage; distinctive arrangement is a recognised interest.",
                    "Ramification potential: dense branching character; verify operational details.",
                    "Development suitability: compactness may favour refinement over rapid trunk building.",
                    "Refinement suitability: high interest for dense, compact compositions.",
                    "Known bonsai strengths: dense foliage, compact habit, distinctive leaf arrangement.",
                    "Potential challenges: trunk development expectations should not match vigorous green forms by default.",
                    "Important differences from the straight species: density and compact habit.",
                    "Cultivar-specific notes: important bonsai and ornamental cultivar; avoid overstating trunk-building ease.",
                    "Further cultivar verification required for detailed vigor and trunk-development claims.",
                ],
                bullets: [
                    "Category filters: Compact / Small Leaf; Fine Ramification; Specialist / Display",
                ]
            ),
            SpeciesProfileSection(
                id: "cultivar-arakawa",
                title: "Acer palmatum 'Arakawa'",
                paragraphs: [
                    "Growth habit: deciduous maple selection valued primarily for corky bark development with age.",
                    "Growth strength: further cultivar verification required.",
                    "Leaf characteristics: generally maple foliage; bark is the primary distinguishing character.",
                    "Seasonal characteristics: mature trunk character becomes increasingly important over time.",
                    "Ramification potential: further cultivar verification required.",
                    "Development suitability: relevant where long-term bark character is part of the design goal.",
                    "Refinement suitability: further cultivar verification required.",
                    "Known bonsai strengths: corky bark development and mature trunk character.",
                    "Potential challenges: bark character develops with age and should not be expected immediately.",
                    "Important differences from the straight species: bark characteristics are distinctly emphasised versus typical smooth-to-subtle Acer palmatum bark.",
                    "Cultivar-specific notes: clearly distinguish bark character from the straight species.",
                    "Further cultivar verification required for growth-strength and ramification detail.",
                ],
                bullets: [
                    "Category filters: Bark Character",
                ]
            ),
            SpeciesProfileSection(
                id: "cultivar-seigen",
                title: "Acer palmatum 'Seigen'",
                paragraphs: [
                    "Growth habit: specialist ornamental cultivar.",
                    "Growth strength / ramification / development suitability: further cultivar verification required.",
                    "Leaf characteristics: foliage characteristics and colour development require verification.",
                    "Seasonal characteristics: ornamental foliage presentation is a primary interest.",
                    "Refinement suitability / bonsai suitability: further cultivar verification required.",
                    "Known bonsai strengths: specialist foliage interest where verified.",
                    "Potential challenges: do not assume identical tolerance or vigor to the straight species.",
                    "Important differences from the straight species: foliage character focus; verify before operational inheritance.",
                    "Cultivar-specific notes: verify foliage characteristics, colour development, bonsai suitability and growth behaviour.",
                    "Further cultivar verification required.",
                ],
                bullets: [
                    "Category filters: Seasonal Colour; Specialist / Display",
                ]
            ),
            SpeciesProfileSection(
                id: "cultivar-bloodgood",
                title: "Acer palmatum 'Bloodgood'",
                paragraphs: [
                    "Growth habit: well-known vigorous red-leaved cultivar widely used in gardens.",
                    "Growth strength: generally more vigorous than many compact bonsai cultivars.",
                    "Leaf characteristics: red foliage; leaf size often larger than compact dwarf cultivars.",
                    "Seasonal characteristics: strong red foliage interest.",
                    "Ramification potential: further cultivar verification required for bonsai-scale refinement claims.",
                    "Development suitability: may support stronger development than compact cultivars.",
                    "Refinement suitability: evaluate leaf size and vigor against intended bonsai scale.",
                    "Known bonsai strengths: vigor and red foliage for medium to larger material where appropriate.",
                    "Potential challenges: garden popularity does not automatically equal optimal small-bonsai suitability.",
                    "Important differences from the straight species and compact cultivars: vigor and leaf scale.",
                    "Cultivar-specific notes: document differences from compact bonsai cultivars; do not assume shohin suitability.",
                    "Further cultivar verification required for detailed bonsai ramification claims.",
                ],
                bullets: [
                    "Category filters: Red Foliage; Seasonal Colour",
                ]
            ),
            SpeciesProfileSection(
                id: "cultivar-osakazuki",
                title: "Acer palmatum 'Ōsakazuki'",
                paragraphs: [
                    "Growth habit: deciduous maple known for strong autumn colour and relatively large foliage.",
                    "Growth strength: further cultivar verification required.",
                    "Leaf characteristics: large foliage is a primary consideration for bonsai scale.",
                    "Seasonal characteristics: strong autumn colour.",
                    "Ramification / development / refinement suitability: evaluate against medium and large bonsai goals.",
                    "Known bonsai strengths: autumn colour for medium and large compositions.",
                    "Potential challenges: large foliage may make it less suitable for small bonsai.",
                    "Important differences from the straight species: foliage size and autumn presentation emphasis.",
                    "Cultivar-specific notes: do not present as automatically suitable for small bonsai.",
                    "Further cultivar verification required for growth-strength detail.",
                ],
                bullets: [
                    "Category filters: Seasonal Colour",
                ]
            ),
            SpeciesProfileSection(
                id: "cultivar-katsura",
                title: "Acer palmatum 'Katsura'",
                paragraphs: [
                    "Growth habit: foliage-oriented selection with distinctive seasonal foliage.",
                    "Growth strength: further cultivar verification required.",
                    "Leaf characteristics: distinctive seasonal leaf colour is the primary interest.",
                    "Seasonal characteristics: evaluate leaf colour development carefully.",
                    "Ramification / development suitability / bonsai scale suitability: further cultivar verification required.",
                    "Known bonsai strengths: seasonal foliage character where verified.",
                    "Potential challenges: light and environmental sensitivity considerations require observation.",
                    "Important differences from the straight species: seasonal foliage emphasis.",
                    "Cultivar-specific notes: evaluate leaf colour, growth habit and bonsai scale suitability with retained sources.",
                    "Further cultivar verification required.",
                ],
                bullets: [
                    "Category filters: Seasonal Colour; Specialist / Display",
                ]
            ),
            SpeciesProfileSection(
                id: "cultivar-sango-kaku",
                title: "Acer palmatum 'Sango-kaku'",
                paragraphs: [
                    "Growth habit: specialist cultivar.",
                    "Primary characteristic: coral-red young stems.",
                    "Growth strength: do not present as automatically equivalent to the straight species.",
                    "Leaf characteristics: further cultivar verification required.",
                    "Seasonal characteristics: stem colour is a major ornamental feature, especially in dormant and early-season presentation.",
                    "Ramification / development / refinement suitability: further cultivar verification required.",
                    "Known bonsai strengths: distinctive coral-red young stems.",
                    "Potential challenges: growth behaviour must be verified independently of stem colour.",
                    "Important differences from the straight species: stem colour and specialist display character.",
                    "Cultivar-specific notes: specialist cultivar — do not inherit species growth assumptions automatically.",
                    "Further cultivar verification required for growth behaviour.",
                ],
                bullets: [
                    "Category filters: Specialist / Display; Seasonal Colour",
                ]
            ),
            SpeciesProfileSection(
                id: "cultivar-orange-dream",
                title: "Acer palmatum 'Orange Dream'",
                paragraphs: [
                    "Growth habit: foliage-oriented specialist cultivar.",
                    "Growth strength: further cultivar verification required.",
                    "Leaf characteristics: seasonal colour is the primary focus.",
                    "Seasonal characteristics: distinctive seasonal foliage colour.",
                    "Ramification / development suitability: further cultivar verification required.",
                    "Refinement suitability / bonsai suitability: evaluate with attention to sensitivity.",
                    "Known bonsai strengths: seasonal colour presentation.",
                    "Potential challenges: sensitivity considerations — observe light, heat and drying carefully.",
                    "Important differences from the straight species: foliage colour focus.",
                    "Cultivar-specific notes: focus on seasonal colour, sensitivity considerations and bonsai suitability.",
                    "Further cultivar verification required.",
                ],
                bullets: [
                    "Category filters: Seasonal Colour; Specialist / Display",
                ]
            ),
            SpeciesProfileSection(
                id: "cultivar-beni-maiko",
                title: "Acer palmatum 'Beni Maiko'",
                paragraphs: [
                    "Identity and bonsai relevance: include only after cultivar identity and bonsai relevance are verified.",
                    "Growth habit / leaf characteristics / operational bonsai claims: further cultivar verification required.",
                    "Known associations in horticulture include red spring foliage interest, but retained sources are required before operational inheritance.",
                    "Important differences from the straight species: further cultivar verification required.",
                    "Cultivar-specific notes: retain named entry for tracking; do not invent unverified bonsai characteristics.",
                    "Further cultivar verification required — cultivar identity and bonsai relevance pending retained sources.",
                ],
                bullets: [
                    "Category filters: Red Foliage; Seasonal Colour",
                ]
            ),
            SpeciesProfileSection(
                id: "cultivar-kashima",
                title: "Acer palmatum 'Kashima'",
                paragraphs: [
                    "Growth habit: important compact cultivar.",
                    "Growth strength: associated with compact growth; verify before assigning rapid development claims.",
                    "Leaf characteristics: focus verification on leaf size and compactness.",
                    "Ramification potential: compact forms are often of interest for fine structure; verify details.",
                    "Development suitability: may favour smaller bonsai goals over rapid trunk building.",
                    "Refinement suitability: high interest where compactness is desired.",
                    "Known bonsai strengths: compactness and small-leaf interest.",
                    "Potential challenges: verify growth behaviour before applying vigorous-species strategies.",
                    "Important differences from the straight species: compactness and scale.",
                    "Cultivar-specific notes: verify compactness, leaf size, growth behaviour and ramification.",
                    "Further cultivar verification required.",
                ],
                bullets: [
                    "Category filters: Compact / Small Leaf; Fine Ramification",
                ]
            ),
            SpeciesProfileSection(
                id: "cultivar-selection",
                title: "Cultivar Selection Principle",
                paragraphs: [
                    "Species baseline provides knowledge and tendencies. Cultivar information provides additional characteristics. Individual tree condition remains the final decision layer.",
                    "Select cultivars for the intended bonsai objective — for example compact forms for small bonsai, bark-character forms for mature trunk interest, or foliage specialists for seasonal display.",
                    "The cultivar should influence the strategy. It should not dictate the strategy without considering the actual individual tree.",
                ]
            )
        ]
    }
}
