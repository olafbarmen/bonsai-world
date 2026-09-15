//
//  JuniperusProcumbensGreenMoundSpeciesProfile.swift
//  Bonsai World
//
//  Species Profile — Juniperus procumbens 'Green Mound' (Green Mound Juniper).
//  Independent Bonsai World profile for a cultivar of Juniperus procumbens.
//  Knowledge status: Reviewed (complete editorial content).
//

import Foundation

enum JuniperusProcumbensGreenMoundSpeciesProfile {
    static let parentSpeciesName = "Juniperus procumbens"
    static let cultivarName = "Green Mound"
    /// Scientific name for Species Profile display.
    static let scientificName = "Juniperus procumbens 'Green Mound'"

    static var profile: SpeciesProfile {
        SpeciesProfile(
            speciesID: BotanicalKnowledgeIDs.juniperusProcumbens,
            cultivarID: BotanicalKnowledgeIDs.juniperusProcumbensGreenMound,
            scientificName: scientificName,
            commonNames: ["Green Mound Juniper"],
            family: "Cupressaceae",
            plantType: "Evergreen conifer",
            originSummary: "Cultivated horticultural selection associated with a species native to Japan",
            knowledgeStatus: .reviewed,
            traits: traits,
            foliageSizeLabel: "Foliage",
            foliageReductionLabel: "Foliage management",
            summaryLine: "Evergreen · Low spreading growth · Dense foliage · Compact habit · Excellent small bonsai potential",
            attentionHighlights: [
                "Use the naturally spreading growth habit as a design advantage",
                "Preserve healthy foliage on branches intended to remain viable",
                "Do not assume reliable budding from completely bare old wood",
                "Avoid permanently wet substrate",
                "Strong outdoor light supports healthy growth",
                "Monitor water demand carefully in shallow containers",
                "Monitor wire carefully",
                "Use extension growth strategically during development",
                "Do not use deciduous defoliation techniques",
                "Avoid excessive foliage congestion",
                "Protect shallow root systems during severe winter conditions",
                "Do not move the tree indoors for routine winter care",
            ],
            sections: sections,
            principleNote: """
            Juniperus procumbens 'Green Mound' is a compact, spreading evergreen juniper with characteristics that can make it highly suitable for bonsai.

            Its naturally low and spreading growth habit differs significantly from upright Chinese Juniper cultivars. This should influence bonsai design.

            Do not attempt to force every Green Mound into an upright design simply because upright bonsai styles are common. The individual material must determine the design.

            The profile provides species and cultivar tendencies. It does not replace assessment of the individual tree.

            Management must always consider tree health, root condition, development stage, trunk structure, branch structure, foliage density, recent work, climate, weather, container size and current vigour.
            """,
            sourcesNote: """
            Profile content is synthesised from recognised botanical and horticultural authorities into Bonsai World editorial language.

            Parent-species context may draw on Royal Botanic Gardens, Kew and recognised botanical databases. Horticultural cultivar information may draw on the Royal Horticultural Society and established horticultural institutions. Bonsai-specific management draws on established bonsai references, applied to Juniperus procumbens selections rather than copied from Juniperus chinensis cultivars.

            Do not confuse this profile with Juniperus procumbens 'Nana'. Commercial naming may differ between sources; document naming relationships without creating duplicate Bonsai World profiles. Do not copy source wording.
            """
        )
    }

    private static let traits = SpeciesProfileTraits(
        deciduous: false,
        growthStrength: "Moderate",
        growthSpeed: "Slow to Moderate",
        leafSize: "Evergreen · Needle-like juvenile foliage · Dense and compact",
        foliageReduction: "Preserve viable foliage — manage density carefully",
        ramificationPotential: "Good",
        backBudding: "Limited to Moderate — foliage must be retained",
        rootDevelopment: "Good",
        nebariPotential: "Good development potential",
        trunkDevelopment: "Slow",
        barkDevelopment: "Character develops gradually with age",
        wiring: "Suitable — monitor carefully",
        defoliation: "Not suitable",
        airLayering: "Where appropriate for the individual material",
        threadGrafting: "May be relevant for structural correction",
        rootGrafting: "Where appropriate",
        beginnerSuitability: "High",
        bonsaiSuitability: "Excellent",
        difficulty: "Beginner to Advanced",
        winterDormancyRequired: true,
        winterHardiness: "High — outdoor evergreen",
        rootFrostSensitivity: "Moderate to Significant in shallow containers"
    )

    private static var sections: [SpeciesProfileSection] {
        [
            SpeciesProfileSection(
                id: "taxonomic-context",
                title: "Taxonomic Context",
                paragraphs: [
                    "Juniperus procumbens 'Green Mound' is a named horticultural cultivar associated with Juniperus procumbens.",
                    "Profile type: Cultivar / Horticultural Selection. It is not a separate botanical species.",
                    "Parent species: Juniperus procumbens, family Cupressaceae. Juniperus procumbens is a distinct botanical species from Juniperus chinensis.",
                    "Primary Bonsai World display identity: Juniperus procumbens 'Green Mound' · Green Mound Juniper.",
                    "Do not confuse this profile with Juniperus procumbens 'Nana'. If both are present in Bonsai World, they remain separate operational profiles unless verified evidence requires a future data-model relationship.",
                    "Do not automatically transfer care guidance from Juniperus chinensis cultivars to this profile.",
                ]
            ),
            SpeciesProfileSection(
                id: "overview",
                title: "Species Overview",
                paragraphs: [
                    "Juniperus procumbens 'Green Mound' is a compact evergreen juniper with a naturally low, spreading growth habit and dense foliage.",
                    "The cultivar is particularly suitable for bonsai because nursery material can often provide low trunk movement, spreading branches, compact proportions, dense evergreen foliage and natural potential for informal and cascading compositions.",
                    "Its growth habit can be particularly useful when developing informal upright bonsai, slanting bonsai, semi-cascade bonsai, cascade bonsai, naturalistic low-growing compositions and group plantings.",
                    "The naturally spreading character should be treated as an advantage. Do not automatically attempt to convert the material into a formal upright tree.",
                    "The strongest designs will normally develop from the existing characteristics of the trunk and branches.",
                ],
                bullets: [
                    "Evergreen conifer",
                    "Naturally low and spreading growth habit",
                    "Dense needle-like foliage",
                    "Compact proportions",
                    "Good bonsai potential",
                    "Suitable for wiring",
                    "Good ramification potential",
                    "Slow trunk development",
                    "Foliage must be retained on branches intended to survive",
                    "Requires strong outdoor light",
                    "Requires winter dormancy",
                    "Requires a well-drained root environment",
                ]
            ),
            SpeciesProfileSection(
                id: "natural-growth",
                title: "Natural Growth and Vigour",
                paragraphs: [
                    "Green Mound generally develops with a low and spreading habit.",
                    "Growth is usually slow to moderate depending on root development, container size, substrate, light, fertilization, temperature, water availability, climate and development stage.",
                    "During development: allow selected shoots and branches to extend where additional thickness is required. Do not continually restrict all growth simply to maintain compactness.",
                    "During refinement: control extension more carefully and maintain branch hierarchy, foliage distribution, interior health and compact proportions.",
                    "Because the tree naturally grows in a spreading form, structural development should respect the existing direction of the material.",
                ]
            ),
            SpeciesProfileSection(
                id: "foliage",
                title: "Foliage",
                paragraphs: [
                    "Green Mound develops dense evergreen foliage with a needle-like character. The foliage should be managed carefully.",
                    "Healthy foliage is essential to the continued viability of branches. Do not assume that completely bare old wood will reliably produce new growth.",
                    "When pruning, retain healthy foliage on branches intended to survive.",
                    "The objective is not maximum foliage density. The objective is healthy and functional foliage distribution.",
                    "Manage dense foliage to maintain light penetration, air movement, healthy interior growth, visible branch structure and future growing points.",
                    "Do not treat the foliage as a hedge. Do not shear the complete surface uniformly as a routine bonsai technique.",
                ]
            ),
            SpeciesProfileSection(
                id: "bark-trunk",
                title: "Bark and Trunk",
                paragraphs: [
                    "Young nursery material may initially have relatively thin trunks. Trunk development is generally gradual.",
                    "Useful characteristics may include naturally low trunk lines, branch movement, spreading structure, potential for dramatic angles and natural suitability for cascading development.",
                    "Significant trunk thickening requires time.",
                    "During development, use selected extension growth strategically. Possible approaches may include sacrifice branches, extended branch growth, larger development containers and staged structural development.",
                    "Do not present any single technique as mandatory. Once sufficient trunk development has been achieved, shift gradually toward refinement.",
                ]
            ),
            SpeciesProfileSection(
                id: "roots-nebari",
                title: "Roots and Nebari",
                paragraphs: [
                    "Root development should be managed from an early stage.",
                    "Important objectives include healthy root mass, radial root distribution where possible, stable trunk support and gradual correction of unsuitable roots.",
                    "Good nebari can be developed through early root selection and long-term cultivation. Do not promise exceptional nebari automatically.",
                    "Avoid excessive root reduction. A healthy root system is essential for vigour, foliage density, recovery and long-term refinement.",
                ]
            ),
            SpeciesProfileSection(
                id: "light",
                title: "Light",
                paragraphs: [
                    "Green Mound should generally be cultivated outdoors in strong light.",
                    "Healthy, established trees benefit from substantial light exposure. Strong outdoor light can support healthy foliage, compact growth, balanced vigour and stronger interior development.",
                    "Light management must always consider temperature, wind, root condition, recent repotting, container size, water availability and tree health.",
                    "Recently repotted, weak or stressed trees must not automatically be treated like strong established trees.",
                    "Do not recommend routine indoor cultivation.",
                ]
            ),
            SpeciesProfileSection(
                id: "wind",
                title: "Wind",
                paragraphs: [
                    "Wind can improve air movement but also increases water demand.",
                    "Benefits may include improved airflow, faster foliage drying and reduced stagnant conditions.",
                    "Risks may include increased transpiration, faster drying, winter desiccation and stress after repotting.",
                    "Particular attention is required for shallow containers, small bonsai, recently repotted trees and exposed growing positions.",
                    "Wind exposure should be understood as part of the total growing environment.",
                ]
            ),
            SpeciesProfileSection(
                id: "watering",
                title: "Watering",
                paragraphs: [
                    "Juniperus procumbens 'Green Mound' requires balanced watering.",
                    "General principle: moist when required, well drained, never permanently saturated.",
                    "Watering frequency depends on weather, temperature, wind, sun exposure, container size, substrate structure, root mass, tree health, development stage and seasonal activity.",
                    "Do not water according to a fixed timetable. Water according to the condition of the substrate and tree.",
                    "A bonsai in a shallow container can dry considerably faster than landscape-grown junipers. At the same time, constantly saturated substrate can reduce root health.",
                ]
            ),
            SpeciesProfileSection(
                id: "soil",
                title: "Soil",
                paragraphs: [
                    "Do not prescribe one universal soil recipe.",
                    "Desired characteristics include excellent drainage, good aeration, stable particle structure, sufficient moisture retention and long-term root health.",
                    "The final mix depends on local climate, rainfall, watering habits, pot depth, development stage and root condition.",
                    "Follow Bonsai World Soil Module principles. Do not duplicate the complete Soil Module inside this profile.",
                ]
            ),
            SpeciesProfileSection(
                id: "fertilizing",
                title: "Fertilizing",
                paragraphs: [
                    "Fertilization must support the objective of the individual tree.",
                    "During development, a healthy tree requiring trunk or branch growth may receive stronger nutritional support where appropriate.",
                    "During refinement, nutrition should support health while avoiding unnecessary coarse growth.",
                    "Fertilization depends on tree health, development stage, season, current growth, root condition and recent work.",
                    "Do not fertilize weak or severely stressed trees simply because active growth is desirable.",
                    "Feed the tree you are growing, not simply the cultivar name.",
                ]
            ),
            SpeciesProfileSection(
                id: "pruning",
                title: "Pruning",
                paragraphs: [
                    "Junipers should not be treated like deciduous trees. Do not assume that completely bare branches will reliably regenerate.",
                    "Healthy foliage should remain on branches intended to survive.",
                    "During development: allow selected branches and shoots to extend where thickness is required. Use growth to develop trunk thickness, primary branches and secondary branches.",
                    "During refinement: control excessive extension, maintain compact proportions, preserve interior growth where possible and reduce congestion gradually.",
                    "Avoid removing excessive foliage from weak trees.",
                    "The objective is to maintain branch viability, balanced vigour, interior foliage, future design options and clear branch structure.",
                ]
            ),
            SpeciesProfileSection(
                id: "back-budding",
                title: "Back-budding",
                paragraphs: [
                    "New growth can develop under favourable conditions, but back-budding should never be treated as guaranteed.",
                    "Do not promise new shoots from completely bare old wood.",
                    "Potential depends on tree health, retained foliage, branch condition, light, vigour, season and previous work.",
                    "Use foliage-preserving pruning strategies.",
                ]
            ),
            SpeciesProfileSection(
                id: "ramification",
                title: "Ramification",
                paragraphs: [
                    "Ramification potential is good.",
                    "Fine branch development requires healthy growth, controlled extension, selective pruning, good light distribution, branch selection and appropriate wiring.",
                    "Avoid allowing foliage to become so dense that the interior weakens.",
                    "The objective is healthy functional ramification — not simply maximum foliage density.",
                ]
            ),
            SpeciesProfileSection(
                id: "wiring",
                title: "Wiring",
                paragraphs: [
                    "Green Mound is suitable for wiring.",
                    "Its naturally spreading growth habit can make wiring particularly useful for establishing trunk movement, positioning primary branches, developing slanting forms, creating semi-cascade or cascade movement and improving branch spacing.",
                    "Monitor wire carefully. Wire marks can become permanent.",
                    "Before applying strong bends, assess branch thickness, flexibility, age, health and intended movement.",
                    "Do not automatically recommend aggressive bending. Use controlled movement appropriate to the individual branch.",
                ]
            ),
            SpeciesProfileSection(
                id: "defoliation",
                title: "Defoliation",
                paragraphs: [
                    "Defoliation is not suitable as a deciduous-style technique.",
                    "Juniper foliage should not be managed using deciduous defoliation principles.",
                    "Foliage management should instead focus on selective pruning, density management, shoot control, removal of unwanted growth and preservation of viable foliage.",
                    "Never present complete defoliation as a routine technique.",
                ]
            ),
            SpeciesProfileSection(
                id: "repotting",
                title: "Repotting",
                paragraphs: [
                    "Repotting frequency must depend on root development, substrate condition, drainage, container size, tree health and development stage.",
                    "Do not establish a rigid calendar rule.",
                    "Young development material may require different management from mature refined bonsai.",
                    "Avoid unnecessary excessive root removal. Do not automatically combine major root work with multiple other major stresses.",
                    "Recovery must be based on the individual tree and conditions.",
                ]
            ),
            SpeciesProfileSection(
                id: "trunk-development",
                title: "Trunk Development",
                paragraphs: [
                    "Trunk development is generally gradual.",
                    "The naturally spreading growth habit should be considered when planning trunk development.",
                    "Possible approaches include allowing selected branches to extend, sacrifice growth where appropriate, larger development containers, staged structural pruning and gradual trunk selection.",
                    "Do not repeatedly restrict growth if substantial structural development is still required.",
                    "Grow where development is required. Control where refinement is required.",
                ]
            ),
            SpeciesProfileSection(
                id: "nebari-development",
                title: "Nebari Development",
                paragraphs: [
                    "Nebari should be considered early.",
                    "Potential approaches include root selection, radial root positioning, container development, gradual correction of crossing roots and management of dominant roots.",
                    "The objective is a stable and visually convincing root base — not simply a large quantity of roots.",
                ]
            ),
            SpeciesProfileSection(
                id: "grafting",
                title: "Grafting",
                paragraphs: [
                    "Grafting may be relevant where a branch is missing, foliage distribution needs correction or structural improvement is required.",
                    "Do not present grafting as routine care.",
                    "Detailed procedures belong in Bonsai World Propagation and Grafting Knowledge Articles.",
                ]
            ),
            SpeciesProfileSection(
                id: "propagation",
                title: "Propagation",
                paragraphs: [
                    "Green Mound is a named horticultural cultivar.",
                    "Propagation intended to preserve cultivar characteristics should use vegetative propagation.",
                    "Relevant methods may include cuttings and other suitable vegetative techniques.",
                    "Seedlings should not be expected to reproduce the cultivar reliably.",
                    "Detailed propagation procedures belong in Bonsai World Propagation Knowledge Articles.",
                ]
            ),
            SpeciesProfileSection(
                id: "pests",
                title: "Pests and Problems",
                paragraphs: [
                    "Relevant risks may include aphids, scale insects, mites, caterpillars and foliage-feeding pests, root problems associated with excessive moisture, root-related diseases, branch or stem disease, foliage browning caused by environmental stress, and interior decline caused by excessive density or poor light.",
                    "Do not provide one generic treatment list.",
                    "Diagnosis and treatment belong in Care → Pest Management and Care → Disease & Problems.",
                    "This profile identifies tendencies and should link to detailed knowledge as that system develops.",
                ]
            ),
            SpeciesProfileSection(
                id: "seasonal",
                title: "Seasonal Profile",
                paragraphs: [
                    "Spring: increasing activity. Monitor new growth, water demand, root health, structural decisions, wiring, wire marks and pest activity. Use seasonal timing as guidance rather than a rigid calendar.",
                    "Summer: active growth. Monitor water demand, sunlight, wind exposure, foliage health, wire marks and pest activity. Maintain healthy foliage while controlling excessive extension where refinement requires it.",
                    "Autumn: growth gradually slows. Review overall structure, foliage density, wire condition and overall health before winter. Avoid unnecessary major stress as the tree prepares for winter.",
                    "Winter: Juniperus procumbens 'Green Mound' remains an outdoor evergreen bonsai. Winter dormancy remains important.",
                    "The primary bonsai concern is protection of the root system during severe or prolonged freezing, particularly in shallow containers. Also monitor winter wind, desiccation, freeze-thaw cycles and excessive moisture in cold substrate.",
                    "Do not move the tree indoors for routine winter cultivation. Winter protection depends on minimum temperatures, duration of freezing, wind, container depth, root condition and local climate.",
                ]
            ),
            SpeciesProfileSection(
                id: "styles",
                title: "Bonsai Styles",
                paragraphs: [
                    "Green Mound is particularly suitable for styles that make use of its naturally spreading growth habit.",
                    "Potential styles include Informal Upright, Slanting, Semi-Cascade, Cascade, Root-over-Rock where suitable, naturalistic forms and Group Planting.",
                    "Do not state that every tree is suitable for every style. The individual material must determine the final design.",
                    "The naturally spreading growth habit should be treated as a design advantage.",
                ]
            ),
            SpeciesProfileSection(
                id: "tree-stage",
                title: "Development by Tree Stage",
                paragraphs: [
                    "Young material: establish healthy roots, build vigour, establish trunk direction and preserve useful structural options.",
                    "Nursery material: evaluate trunk movement, identify useful branches, evaluate possible front and preserve future design options.",
                    "Pre-bonsai: establish trunk structure, establish primary branches, develop root base and begin controlled branch development.",
                    "In training: branch development, ramification, foliage distribution, wiring and refinement of branch hierarchy.",
                    "Refinement: compact foliage structure, controlled extension, healthy interior growth, balanced silhouette and careful branch refinement.",
                    "Exhibition / mature refined tree: maintain health, preserve established design, maintain foliage quality and avoid unnecessary major intervention.",
                ]
            ),
            SpeciesProfileSection(
                id: "attention",
                title: "Cultivar-Specific Attention",
                paragraphs: [
                    "These attention points are operational tendencies. They must still be interpreted for the individual tree.",
                ],
                bullets: [
                    "Use the naturally spreading growth habit as a design advantage",
                    "Preserve healthy foliage on branches intended to remain viable",
                    "Do not assume reliable budding from completely bare old wood",
                    "Avoid permanently wet substrate",
                    "Strong outdoor light supports healthy growth",
                    "Monitor water demand carefully in shallow containers",
                    "Monitor wire carefully",
                    "Use extension growth strategically during development",
                    "Do not use deciduous defoliation techniques",
                    "Avoid excessive foliage congestion",
                    "Protect shallow root systems during severe winter conditions",
                    "Do not move the tree indoors for routine winter care",
                ]
            ),
        ]
    }
}
