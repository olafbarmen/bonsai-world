//
//  BuxusSempervirensSpeciesProfile.swift
//  Bonsai World
//
//  Species Profile — Buxus sempervirens (European Box).
//  Independent botanical species in Buxaceae. Knowledge status: Reviewed.
//  Separate from Japanese Box, Chinese Box and other Buxus species.
//

import Foundation

enum BuxusSempervirensSpeciesProfile {
    /// Identity used by Botanical Library / ``SpeciesPreviewData``.
    static let botanicalLibraryName = "Buxus sempervirens"
    /// Scientific name for Species Profile display (binomial; no botanical authority).
    static let scientificName = "Buxus sempervirens"

    static var profile: SpeciesProfile {
        SpeciesProfile(
            speciesID: BotanicalKnowledgeIDs.buxusSempervirens,
            scientificName: scientificName,
            commonNames: ["European Box", "Common Box", "Boxwood"],
            family: "Buxaceae",
            plantType: "Evergreen broadleaf shrub or small tree",
            originSummary: "Europe, North Africa and Western Asia.",
            knowledgeStatus: .reviewed,
            traits: traits,
            foliageSizeLabel: "Foliage",
            foliageReductionLabel: "Leaf reduction",
            summaryLine: "Evergreen · Small leaves · Dense foliage · Excellent ramification · Strong response to pruning · Slow growth · Rugged mature trunks · Excellent refinement potential · Long-lived",
            attentionHighlights: [
                "Buxus sempervirens is an evergreen outdoor species",
                "Naturally small leaves are one of its greatest bonsai strengths",
                "Fine ramification develops through patient long-term work",
                "Slow growth means major structural mistakes can take time to correct",
                "Do not confuse dense foliage with refined structure",
                "Preserve useful interior growth",
                "Avoid hedge-like uniform trimming",
                "Strong healthy roots are essential for recovery and refinement",
                "Complete defoliation is not routine management",
                "Young branches are more suitable for wiring than older rigid branches",
                "Monitor wire carefully to avoid bark damage",
                "Avoid permanently saturated roots",
                "Watch for box-specific pests and diseases",
                "Shallow bonsai roots require additional protection during prolonged severe freezing",
                "Do not move indoors for permanent cultivation",
            ],
            sections: sections,
            principleNote: """
            Buxus sempervirens is one of the strongest species for refined broadleaf bonsai.

            Its greatest bonsai strengths are small leaves, dense branching, excellent pruning response, fine ramification and mature bark.

            The species develops slowly.

            This is both an advantage for refinement and a limitation during major structural development.

            Do not expect rapid trunk development.

            The objective is: Patience · Fine structure · Dense healthy ramification · Natural mature character.

            The individual tree must always be assessed according to climate, tree condition, vigour, development stage and winter temperatures.
            """,
            sourcesNote: """
            Profile content is synthesised from recognised botanical, horticultural and bonsai authorities into Bonsai World editorial language.

            Botanical taxonomy and distribution draw on recognised sources such as Royal Botanic Gardens, Kew and other botanical databases for accepted scientific name, family and native range.

            Horticultural context may draw on recognised botanical gardens and arboreta, horticultural institutions and authoritative Buxus horticultural references.

            Bonsai-specific cultivation and refinement knowledge draws on established bonsai references and recognised professional practice with Buxus experience, kept distinct from Japanese Box, Chinese Box and other Buxus species.

            Verified botanical information, horticultural information, regional climate adaptation and bonsai-specific practice are kept distinct. Do not copy source wording.
            """
        )
    }

    private static let traits = SpeciesProfileTraits(
        deciduous: false,
        growthStrength: "Slow",
        growthSpeed: "Slow",
        leafSize: "Evergreen · Small leaves",
        foliageReduction: "Not routine management",
        ramificationPotential: "Excellent",
        backBudding: "Good to Excellent under healthy conditions",
        rootDevelopment: "Moderate",
        nebariPotential: "Good potential",
        trunkDevelopment: "Slow",
        barkDevelopment: "Excellent mature character",
        wiring: "Good",
        defoliation: "Not routine management",
        airLayering: "Where appropriate for the individual material",
        threadGrafting: "Where structural correction is required",
        rootGrafting: "Where appropriate",
        beginnerSuitability: "Moderate",
        bonsaiSuitability: "Excellent",
        difficulty: "Intermediate",
        winterDormancyRequired: true,
        winterHardiness: "Seasonal rest required",
        rootFrostSensitivity: "Moderate during prolonged severe freezing, especially in shallow bonsai containers"
    )

    private static var sections: [SpeciesProfileSection] {
        [
            SpeciesProfileSection(
                id: "taxonomic-context",
                title: "Taxonomic Context",
                paragraphs: [
                    "Buxus sempervirens is an independent botanical species in the box family (Buxaceae).",
                    "Primary Bonsai World display identity: Buxus sempervirens · European Box.",
                    "Common Box and Boxwood may be used as supporting terminology. They do not replace European Box as the primary common name.",
                    "Family: Buxaceae. Plant type: evergreen broadleaf shrub or small tree.",
                    "Native range: Europe, North Africa and Western Asia.",
                    "Do not confuse Buxus sempervirens with Japanese Box, Chinese Box or other Buxus species.",
                    "Bonsai World hierarchy: Species → cultivar / horticultural selection → Individual Tree.",
                ]
            ),
            SpeciesProfileSection(
                id: "overview",
                title: "Species Overview",
                paragraphs: [
                    "Buxus sempervirens is an evergreen shrub or small tree native across parts of Europe, North Africa and Western Asia.",
                    "It is valued for bonsai because of naturally small leaves, dense growth, strong response to pruning, excellent ramification potential, mature bark character and long-lived structure.",
                    "European Box is particularly suited to refined bonsai where detailed branch development is important.",
                    "Its slow growth means that major structural mistakes may take a long time to correct.",
                    "Therefore: structural planning should be deliberate.",
                    "The objective is not rapid production.",
                    "The objective is gradual development toward a convincing mature tree.",
                ],
                bullets: [
                    "Evergreen broadleaf species",
                    "Member of the Buxaceae family",
                    "Naturally small leaves",
                    "Slow growth",
                    "Excellent ramification potential",
                    "Good to excellent back-budding under healthy conditions",
                    "Excellent response to pruning",
                    "Long-lived",
                    "Mature trunks can develop strong character",
                    "Suitable for highly refined bonsai",
                    "Outdoor cultivation required",
                    "Seasonal rest required",
                    "Slow recovery from major mistakes compared with fast-growing species",
                ]
            ),
            SpeciesProfileSection(
                id: "cultivars",
                title: "Cultivars and Forms",
                paragraphs: [
                    "Buxus sempervirens has numerous horticultural cultivars.",
                    "However: do not automatically create a separate Species Library profile for every garden cultivar.",
                    "The primary Species Profile remains Buxus sempervirens.",
                    "Cultivars may differ in leaf size, leaf colour, growth habit, vigour and branch density.",
                    "Only create separate profiles where a cultivar has a clear and established independent bonsai identity.",
                    "Do not confuse ornamental garden cultivar names with independent botanical species.",
                ]
            ),
            SpeciesProfileSection(
                id: "natural-growth",
                title: "Natural Growth and Vigour",
                paragraphs: [
                    "Buxus sempervirens is generally slow growing.",
                    "Growth strength depends on tree health, light, root condition, temperature, watering, fertilization and development stage.",
                    "During structural development: allow selected shoots to extend where branch thickness is required, trunk thickness is required or taper is being developed.",
                    "Do not continuously prune every shoot simply to maintain compact foliage.",
                    "During refinement: use controlled pruning and shoot selection to develop fine branching, compact foliage, branch hierarchy and a natural silhouette.",
                    "The objective is: Allow useful growth when development is required · Control growth when refinement is the objective.",
                ]
            ),
            SpeciesProfileSection(
                id: "foliage",
                title: "Foliage",
                paragraphs: [
                    "The naturally small evergreen leaves are one of the major strengths of Buxus sempervirens for bonsai.",
                    "Healthy foliage should be dense, evenly distributed, proportional to the tree and supported by healthy internal branching.",
                    "Avoid creating an artificial outer shell of foliage.",
                    "The objective is fine foliage supported by a believable internal branch system.",
                    "Leaf size and density depend on vigour, light, fertilization, pruning and development stage.",
                    "Do not use complete defoliation as routine management.",
                ]
            ),
            SpeciesProfileSection(
                id: "flowering",
                title: "Flowering",
                paragraphs: [
                    "Flowering is of low ornamental importance for bonsai.",
                    "Flowers should be viewed as part of the species' seasonal character rather than a design objective.",
                    "Do not sacrifice structural development or ramification in pursuit of flowering.",
                ]
            ),
            SpeciesProfileSection(
                id: "fruit",
                title: "Fruit",
                paragraphs: [
                    "Fruiting is of low ornamental importance for bonsai.",
                    "Fruit is not required for a convincing European Box bonsai.",
                    "Do not treat fruit production as a styling priority.",
                ]
            ),
            SpeciesProfileSection(
                id: "bark-trunk",
                title: "Bark and Trunk",
                paragraphs: [
                    "Mature Buxus sempervirens can develop highly attractive trunk character. Mature bark character is excellent.",
                    "Older trees may show rugged bark, aged texture, twisting trunks, natural movement and scars from old branches.",
                    "The species can develop impressive mature character despite relatively slow growth.",
                    "Trunk development should be approached patiently.",
                    "The objective is natural age developed over time rather than artificial exaggeration.",
                ]
            ),
            SpeciesProfileSection(
                id: "roots-nebari",
                title: "Roots and Nebari",
                paragraphs: [
                    "Healthy roots support vigour, recovery, back-budding, ramification and long-term health.",
                    "Root development is moderate. Root development should be approached gradually.",
                    "Objectives include balanced roots, stable radial development, healthy fine roots and gradual nebari improvement.",
                    "Avoid unnecessary aggressive root reduction.",
                    "Because the species grows slowly, major root mistakes may require significant recovery time.",
                    "The objective is a healthy stable root system that supports long-term refinement.",
                ]
            ),
            SpeciesProfileSection(
                id: "light",
                title: "Light",
                paragraphs: [
                    "Buxus sempervirens should be cultivated outdoors.",
                    "Adequate light supports healthy foliage, compact growth, ramification, branch development and overall vigour.",
                    "The ideal position depends on local climate, seasonal temperatures, summer intensity, tree health and development stage.",
                    "Do not recommend permanent indoor cultivation.",
                ]
            ),
            SpeciesProfileSection(
                id: "wind",
                title: "Wind",
                paragraphs: [
                    "Moderate air movement is beneficial.",
                    "Strong wind may increase water loss, dry shallow containers, increase winter stress and damage exposed foliage.",
                    "Monitor trees during prolonged wind, dry periods, severe cold and rapid weather changes.",
                ]
            ),
            SpeciesProfileSection(
                id: "watering",
                title: "Watering",
                paragraphs: [
                    "General principle: Maintain balanced moisture · Avoid permanent saturation · Avoid repeated severe drying · Maintain root aeration.",
                    "Water demand is moderate.",
                    "Watering frequency depends on temperature, sunlight, wind, container size, substrate, root mass, foliage mass and development stage.",
                    "Do not water according to a fixed timetable.",
                    "European Box should not be treated as either a permanently wet species or a drought-tolerant species that can repeatedly dry completely.",
                    "The objective is consistent healthy root conditions.",
                ]
            ),
            SpeciesProfileSection(
                id: "soil",
                title: "Soil",
                paragraphs: [
                    "Do not prescribe one universal soil recipe.",
                    "Desired characteristics include good drainage, strong aeration, stable particle structure, appropriate moisture retention and healthy fine-root development.",
                    "The final soil mix depends on local climate, rainfall, watering habits, container depth, tree size, development stage and root condition.",
                    "Follow Bonsai World Soil Module principles.",
                    "Do not duplicate the complete Soil Module inside this profile.",
                ]
            ),
            SpeciesProfileSection(
                id: "fertilizing",
                title: "Fertilizing",
                paragraphs: [
                    "Fertilization should support healthy foliage, structural development, branch development, ramification and recovery after work.",
                    "During structural development: healthy trees may receive stronger nutritional support where appropriate.",
                    "During refinement: avoid excessive fertilization that produces unnecessarily long shoots, coarse growth or excessive foliage density.",
                    "Key principle: Feed according to tree condition and development objective.",
                    "Slow natural growth should not be mistaken for poor health.",
                ]
            ),
            SpeciesProfileSection(
                id: "pruning",
                title: "Pruning",
                paragraphs: [
                    "Buxus sempervirens responds very well to controlled pruning. Pruning response is excellent.",
                    "Pruning can be used for structural development, branch selection, branch replacement, ramification and silhouette refinement.",
                    "During development: allow selected shoots to extend where thickness is required.",
                    "During refinement: use controlled pruning and shoot selection to maintain compact proportions, fine ramification, branch hierarchy and visible internal structure.",
                    "Avoid repeatedly trimming every surface shoot to the same outline.",
                    "The objective is natural branch development rather than hedge-like uniformity.",
                ]
            ),
            SpeciesProfileSection(
                id: "back-budding",
                title: "Back-budding",
                paragraphs: [
                    "Buxus sempervirens can respond well to pruning and may produce useful new growth on existing branches. Back-budding is good to excellent under healthy conditions.",
                    "Response depends on tree health, vigour, branch condition, available foliage, light and root health.",
                    "Do not describe back-budding as guaranteed.",
                    "Do not remove all useful interior foliage unnecessarily.",
                    "Repeated pruning without preserving internal growth can weaken branch structure.",
                    "The objective is a dense branch system capable of long-term renewal and refinement.",
                ]
            ),
            SpeciesProfileSection(
                id: "ramification",
                title: "Ramification",
                paragraphs: [
                    "Fine ramification is one of the principal strengths of Buxus sempervirens. Ramification potential is excellent.",
                    "Develop ramification through repeated healthy growth cycles, controlled pruning, shoot selection, branch selection and preservation of useful interior growth.",
                    "Avoid indiscriminate shearing, dense foliage shells, loss of branch hierarchy and unnecessary congestion.",
                    "The objective is fine, believable ramification rather than a uniformly trimmed hedge appearance.",
                ]
            ),
            SpeciesProfileSection(
                id: "wiring",
                title: "Wiring",
                paragraphs: [
                    "Young branches can be wired effectively. Wiring response is good.",
                    "Wiring can be used to establish movement, improve branch placement, position secondary branches and develop branch structure.",
                    "Older branches may become increasingly rigid.",
                    "Before major bends, assess branch thickness, flexibility, age, health and structural importance.",
                    "Monitor wire carefully.",
                    "Avoid allowing wire to mark the bark.",
                ]
            ),
            SpeciesProfileSection(
                id: "deadwood-potential",
                title: "Deadwood",
                paragraphs: [
                    "Deadwood may occur naturally and can contribute to mature character. Deadwood potential is moderate.",
                    "However, deadwood should not dominate the design.",
                    "Use deadwood where it reflects the existing material, supports the natural structure, contributes to believable age and does not compromise living tissue.",
                    "Avoid unnecessary artificial carving.",
                    "The objective is natural age rather than manufactured damage.",
                ]
            ),
            SpeciesProfileSection(
                id: "defoliation",
                title: "Defoliation and Leaf Management",
                paragraphs: [
                    "The naturally small leaves are already one of the species' strengths. Complete defoliation is not routine management.",
                    "Leaf management should primarily focus on pruning, shoot selection, balanced fertilization, adequate light and vigour management.",
                    "Do not present complete defoliation as standard management.",
                    "Do not apply aggressive foliage removal to weak trees, stressed trees, recently repotted trees or trees recovering from major work.",
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
                    "Repotting decisions should be based on root condition, substrate performance and overall tree health.",
                    "Timing must account for local climate, active growth cycle, seasonal temperatures and individual tree condition.",
                ]
            ),
            SpeciesProfileSection(
                id: "trunk-development",
                title: "Trunk Development",
                paragraphs: [
                    "Buxus sempervirens develops trunk thickness slowly.",
                    "Where additional thickness is required: allow selected leaders to extend, provide sufficient root space, use development containers where appropriate and avoid premature refinement.",
                    "Do not expect rapid correction of structural weaknesses.",
                    "Once sufficient trunk development has been achieved, shift focus toward taper, branch hierarchy, ramification, mature bark and compact proportions.",
                    "Key principle: Patience is essential.",
                    "Do not permanently restrict a tree that still requires major structural development.",
                ]
            ),
            SpeciesProfileSection(
                id: "nebari-development",
                title: "Nebari Development",
                paragraphs: [
                    "Nebari should be developed gradually.",
                    "Potential approaches include early root selection, radial root planning, staged root correction, appropriate development containers and gradual refinement of surface roots.",
                    "The objective is a stable and visually convincing base appropriate to a mature broadleaf bonsai.",
                ]
            ),
            SpeciesProfileSection(
                id: "propagation",
                title: "Propagation",
                paragraphs: [
                    "Buxus sempervirens may be propagated using established horticultural methods including cuttings, layering and seed.",
                    "Propagation method selection depends on the desired objective.",
                    "Vegetative propagation preserves the characteristics of selected material.",
                    "Seed-grown material may offer genetic variation.",
                    "Detailed procedures belong in Bonsai World Propagation Knowledge Articles.",
                ]
            ),
            SpeciesProfileSection(
                id: "pests",
                title: "Pests and Problems",
                paragraphs: [
                    "Relevant risks may include box tree moth, scale insects, spider mites, fungal diseases, box blight and other serious leaf and shoot diseases, root problems caused by poor drainage, drought stress, winter stress and damage caused by prolonged severe freezing in shallow containers.",
                    "Do not provide generic treatment instructions.",
                    "Diagnosis and treatment belong in Care → Pest Management and Care → Disease & Problems.",
                ]
            ),
            SpeciesProfileSection(
                id: "seasonal",
                title: "Seasonal Profile",
                paragraphs: [
                    "Spring: monitor new growth, overall vigour, watering demand, pest activity and branch development. Spring is important for assessing structural priorities, ramification, root health and recovery from winter. Major work should be coordinated with local climate and tree condition.",
                    "Summer: monitor watering demand, foliage health, pest activity, fungal disease risk, shoot growth and wire marks. Avoid assuming that slow growth means the tree requires constant intervention. Allow healthy growth where development is required.",
                    "Autumn is important for evaluating seasonal growth, reviewing branch structure, checking foliage health and preparing for cooler conditions. Do not apply one universal autumn schedule.",
                    "Winter: Buxus sempervirens should receive appropriate outdoor seasonal conditions.",
                    "Do not describe Buxus sempervirens as requiring permanent indoor protection. It is an outdoor species.",
                    "Winter management depends strongly on local minimum temperatures, duration of freezing, wind exposure, container depth, root protection, moisture conditions and tree health.",
                    "Shallow bonsai roots are more exposed to cold than roots in open ground.",
                    "Protect the root system when required. Do not maintain permanently indoors as a substitute for appropriate seasonal cultivation.",
                ]
            ),
            SpeciesProfileSection(
                id: "styles",
                title: "Bonsai Styles",
                paragraphs: [
                    "Buxus sempervirens is particularly suitable for Informal Upright, Slanting, Multi-trunk Style, Clump Style, Naturalistic Bonsai and Literati in suitable material.",
                    "It is especially effective when styling emphasises fine branching, compact foliage, mature bark, natural trunk movement and aged broadleaf character.",
                    "The individual material should determine the final design.",
                ]
            ),
            SpeciesProfileSection(
                id: "tree-stage",
                title: "Development by Tree Stage",
                paragraphs: [
                    "Young material: establish healthy roots, develop trunk thickness, establish movement and begin structural development.",
                    "Nursery material: evaluate trunk potential, identify useful branches, establish a design direction and begin structural correction.",
                    "Pre-bonsai: develop trunk, establish primary branches, improve root structure, build taper and build vigour.",
                    "In training: develop secondary branches, improve branch hierarchy, build ramification and preserve interior growth.",
                    "Refinement: maintain balanced vigour, improve tertiary ramification, control shoot extension, maintain compact proportions and preserve visible structure.",
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
                    "Buxus sempervirens is an evergreen outdoor species",
                    "Naturally small leaves are one of its greatest bonsai strengths",
                    "Fine ramification develops through patient long-term work",
                    "Slow growth means major structural mistakes can take time to correct",
                    "Do not confuse dense foliage with refined structure",
                    "Preserve useful interior growth",
                    "Avoid hedge-like uniform trimming",
                    "Strong healthy roots are essential for recovery and refinement",
                    "Complete defoliation is not routine management",
                    "Young branches are more suitable for wiring than older rigid branches",
                    "Monitor wire carefully to avoid bark damage",
                    "Avoid permanently saturated roots",
                    "Watch for box-specific pests and diseases",
                    "Shallow bonsai roots require additional protection during prolonged severe freezing",
                    "Do not move indoors for permanent cultivation",
                ]
            ),
        ]
    }
}
