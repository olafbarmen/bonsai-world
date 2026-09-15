//
//  TaxusCuspidataSpeciesProfile.swift
//  Bonsai World
//
//  Species Profile — Taxus cuspidata (Japanese Yew).
//  Independent botanical species in Taxaceae. Knowledge status: Reviewed.
//  Separate from Taxus baccata, Taxus × media and named cultivars.
//

import Foundation

enum TaxusCuspidataSpeciesProfile {
    /// Identity used by Botanical Library / ``SpeciesPreviewData``.
    static let botanicalLibraryName = "Taxus cuspidata"
    /// Scientific name for Species Profile display (binomial; no botanical authority).
    static let scientificName = "Taxus cuspidata"

    static var profile: SpeciesProfile {
        SpeciesProfile(
            speciesID: BotanicalKnowledgeIDs.taxusCuspidata,
            scientificName: scientificName,
            commonNames: ["Japanese Yew"],
            family: "Taxaceae",
            plantType: "Evergreen conifer",
            originSummary: "Southern Russian Far East, Korea, northern China and Japan.",
            knowledgeStatus: .reviewed,
            traits: traits,
            foliageSizeLabel: "Foliage",
            foliageReductionLabel: "Foliage management",
            summaryLine: "Evergreen · Dark green needles · Strong regenerative potential · Excellent deadwood · Flexible wood · Long-term refinement species · Highly toxic if eaten",
            attentionHighlights: [
                "Japanese yew is an evergreen conifer with excellent bonsai potential",
                "It has stronger regenerative ability than many conifers but is not immune to over-pruning",
                "Back-budding can be very useful on healthy established material",
                "Deadwood is a major design strength",
                "Live-vein development must be respected when carving",
                "The species tolerates a broad range of light conditions, but bonsai still require adequate light for healthy compact growth",
                "Avoid permanently wet substrates",
                "Major root work and major top work should normally be separated",
                "Japanese yew is highly toxic if eaten",
                "Long-term refinement is often more valuable than forcing rapid development",
                "Do not merge with Taxus baccata or treat as a cultivar of European yew",
                "Winter dormancy is required",
                "Do not move indoors for routine winter care",
            ],
            sections: sections,
            principleNote: """
            Taxus cuspidata is more tolerant of structural intervention than many conifers, but this does not mean that it should be treated aggressively without regard to tree health.

            Preserve healthy foliage and viable growth points. Avoid removing too much productive foliage at once. Separate major structural work from unnecessary root disturbance. Allow recovery after major interventions.

            Use the tree's natural ability to regenerate rather than repeatedly forcing it. Develop branch structure progressively. Protect important live veins when creating or refining deadwood.

            Do not describe the species as indestructible.

            Do not promise guaranteed back-budding.

            Do not recommend extreme pruning as a default technique.

            Do not use Taxus baccata as an alternative identity. Do not merge this profile with European Yew.

            The individual tree must always be assessed according to health, age, cultivar, climate, cultivation technique and recent work.

            The objective is: Healthy foliage · Progressive structure · Convincing live-vein and deadwood character · Sustainable long-term refinement
            """,
            sourcesNote: """
            Profile content is synthesised from recognised botanical, horticultural and bonsai authorities into Bonsai World editorial language.

            Botanical taxonomy and distribution draw primarily on Royal Botanic Gardens, Kew — Plants of the World Online for Taxus cuspidata Siebold & Zucc.: accepted species status, family Taxaceae, genus Taxus, native distribution (southern Russian Far East to northern China and Japan, including Korea, the Kuril Islands, Manchuria, Primorye and Sakhalin) and accepted infraspecific taxa.

            Horticultural reference includes Royal Horticultural Society guidance for Taxus cuspidata / Japanese yew on evergreen habit, hardiness, growth characteristics, toxicity and susceptibility to waterlogging.

            Bonsai-specific cultivation and refinement knowledge draws on established bonsai references and recognised professional practice with Taxus experience. Where guidance reflects general yew bonsai practice rather than species-specific research, it is phrased as cultivation guidance rather than botanical fact.

            Verified botanical information, horticultural information and bonsai-specific practice are kept distinct. Do not copy source wording.
            """
        )
    }

    private static let traits = SpeciesProfileTraits(
        deciduous: false,
        growthStrength: "Slow to Moderate",
        growthSpeed: "Slow to Moderate — strongly climate and cultivation dependent",
        leafSize: "Evergreen · Dark green needle-like foliage · Relatively short, flattened needles",
        foliageReduction: "Not applicable",
        ramificationPotential: "Good with controlled development",
        backBudding: "Good potential compared with many conifers, especially on established healthy material — not guaranteed",
        rootDevelopment: "Moderate to Good with progressive management",
        nebariPotential: "Good potential with progressive development",
        trunkDevelopment: "Long-term — allow extension during structural development",
        barkDevelopment: "Brown to reddish-brown · Attractive mature texture",
        wiring: "Highly suitable — flexible wood",
        defoliation: "Not applicable as a routine technique",
        airLayering: "Where appropriate for the individual material",
        threadGrafting: "Specialist technique where structural correction is required",
        rootGrafting: "Specialist technique where appropriate",
        beginnerSuitability: "Moderate",
        bonsaiSuitability: "Excellent",
        difficulty: "Intermediate",
        winterDormancyRequired: true,
        winterHardiness: "High — outdoor evergreen requiring seasonal cold exposure",
        rootFrostSensitivity: "Moderate in shallow bonsai containers"
    )

    private static var sections: [SpeciesProfileSection] {
        [
            SpeciesProfileSection(
                id: "taxonomic-context",
                title: "Taxonomic Context",
                paragraphs: [
                    "Taxus cuspidata is an independent botanical species in the yew family (Taxaceae), genus Taxus.",
                    "Primary Bonsai World display identity: Taxus cuspidata · Japanese Yew.",
                    "Botanical authority: Siebold & Zucc.",
                    "Family: Taxaceae. Genus: Taxus. Plant type: evergreen conifer.",
                    "Native range: southern Russian Far East, Korea, northern China and Japan (including the Kuril Islands, Manchuria, Primorye and Sakhalin according to Kew).",
                    "Taxus cuspidata is an accepted species according to Kew Plants of the World Online.",
                    "Do not use Taxus baccata as an alternative identity. Do not merge this profile with Taxus baccata. Do not treat Japanese yew as merely a cultivar or form of European yew.",
                    "Maintain a clear distinction between Taxus cuspidata, Taxus baccata, Taxus × media and other Taxus species.",
                    "Bonsai World hierarchy: Species → cultivar / horticultural selection → Individual Tree.",
                ]
            ),
            SpeciesProfileSection(
                id: "overview",
                title: "Species Overview",
                paragraphs: [
                    "Taxus cuspidata is an evergreen conifer native to temperate regions of the Russian Far East, Korea, northern China and Japan.",
                    "It is a long-lived yew with dense evergreen foliage, flexible wood, strong regenerative capacity and excellent potential for developing mature bonsai character.",
                    "For bonsai, the species is particularly valuable because it combines evergreen foliage, relatively compact needle growth, strong branch flexibility, good response to structural pruning, useful capacity for producing new shoots on older wood when healthy, exceptional deadwood potential, strong tolerance of a range of light conditions and excellent longevity.",
                    "Japanese yew should be treated as a long-term refinement species rather than a species that must be forced into rapid development.",
                    "Its combination of live veins, deadwood and dark evergreen foliage can create extremely old-looking bonsai.",
                    "Species characteristics are potential, not universal guarantees. Results depend on health, age, cultivar, climate and cultivation technique.",
                ],
                bullets: [
                    "Evergreen conifer",
                    "Taxaceae · Taxus",
                    "Native to southern Russian Far East, Korea, northern China and Japan",
                    "Excellent bonsai suitability",
                    "Slow to moderate growth",
                    "Dark green needle-like foliage",
                    "Good regenerative potential on healthy material",
                    "Excellent deadwood potential",
                    "Flexible wood suitable for wiring",
                    "Highly toxic if eaten",
                    "Requires outdoor cultivation and seasonal cold exposure",
                    "Distinct from Taxus baccata",
                ]
            ),
            SpeciesProfileSection(
                id: "natural-growth",
                title: "Growth and Vigour",
                paragraphs: [
                    "Taxus cuspidata is generally slow to moderate growing in bonsai culture.",
                    "Growth rate depends strongly on climate, light, root health, nutrition, container size, water availability, tree maturity and previous pruning intensity.",
                    "Young healthy plants may produce stronger extension growth than mature refined trees.",
                    "Avoid fixed annual growth expectations.",
                    "The objective is: Useful development growth · Progressive control · Preserved productive foliage.",
                ]
            ),
            SpeciesProfileSection(
                id: "foliage",
                title: "Foliage",
                paragraphs: [
                    "Foliage is evergreen, with dark green, relatively short, flattened needles.",
                    "Dense foliage can develop when the tree is grown strongly and is suitable for compact bonsai crowns.",
                    "Foliage density must be balanced with adequate light and ventilation.",
                    "Do not recommend indiscriminate removal of foliage simply to create density.",
                    "Preserve healthy foliage as the foundation for recovery and refinement.",
                ]
            ),
            SpeciesProfileSection(
                id: "bark-trunk",
                title: "Bark and Trunk",
                paragraphs: [
                    "Bark develops attractive mature brown to reddish-brown character.",
                    "Older specimens can develop strongly aged trunks with fissuring, irregular bark, hollowed areas, deadwood and contrasting live and dead tissue.",
                    "The trunk can become visually powerful even when the tree is relatively compact.",
                ]
            ),
            SpeciesProfileSection(
                id: "roots-nebari",
                title: "Roots and Nebari",
                paragraphs: [
                    "The root system is capable of developing strong bonsai nebari when managed progressively.",
                    "Maintain healthy feeder roots. Avoid excessive root removal. Improve radial root structure progressively.",
                    "Avoid waterlogging and maintain good substrate aeration.",
                    "Do not combine severe root reduction with major top work unless there is a clear horticultural reason.",
                    "Root development should be treated as a long-term process.",
                    "The objective is: Stable root system · Progressive nebari · Reliable recovery.",
                ]
            ),
            SpeciesProfileSection(
                id: "light",
                title: "Light",
                paragraphs: [
                    "Taxus cuspidata tolerates a relatively broad range of light conditions compared with many conifers.",
                    "For bonsai, bright light is important for compact growth.",
                    "Morning and filtered light can be useful in hotter conditions.",
                    "Excessive heat combined with container stress should be avoided.",
                    "Dense foliage requires adequate light penetration. Heavily shaded interiors can lose productive growth.",
                    "Do not describe shade tolerance as meaning that bonsai should be kept in deep shade.",
                    "Cultivate outdoors. Do not recommend permanent indoor cultivation.",
                ]
            ),
            SpeciesProfileSection(
                id: "wind",
                title: "Wind",
                paragraphs: [
                    "Established Japanese yew can tolerate exposed conditions, but bonsai containers are more vulnerable than trees growing in the ground.",
                    "Consider wind desiccation, rapid moisture loss, branch movement, pot stability and winter exposure.",
                    "Protect newly repotted trees and weakened specimens from excessive wind.",
                ]
            ),
            SpeciesProfileSection(
                id: "watering",
                title: "Watering",
                paragraphs: [
                    "Taxus cuspidata prefers consistent moisture, good drainage, oxygenated roots, avoidance of prolonged drought and avoidance of waterlogged substrate.",
                    "Waterlogging can cause root problems in yew.",
                    "Water according to substrate moisture, temperature, wind, light, tree size, pot size, season and root activity.",
                    "Do not provide a fixed watering timetable.",
                    "Never specify water every X days as a universal rule.",
                    "Use the existing Bonsai World watering guidance framework.",
                ]
            ),
            SpeciesProfileSection(
                id: "soil",
                title: "Soil and Substrate",
                paragraphs: [
                    "Recommend a well-draining bonsai substrate that combines drainage, air-filled pore space, moisture retention and structural stability.",
                    "Avoid heavy, permanently wet substrates.",
                    "The exact substrate composition may vary according to local climate and cultivation system.",
                    "The primary objective is a healthy balance between moisture and oxygen at the roots.",
                    "Do not prescribe one universal soil recipe.",
                    "Follow Bonsai World Soil Module principles.",
                ]
            ),
            SpeciesProfileSection(
                id: "fertilizing",
                title: "Fertilizing",
                paragraphs: [
                    "Taxus cuspidata responds to appropriate nutrition during active growth.",
                    "Recommend moderate, consistent feeding during active growth, reduced feeding when growth naturally slows, and adjustment according to tree health and development stage.",
                    "Avoid excessive nitrogen on refined trees when compact growth is desired.",
                    "Do not provide a rigid fertilizer calendar.",
                    "Follow the existing Bonsai World fertilization framework.",
                ]
            ),
            SpeciesProfileSection(
                id: "pruning",
                title: "Pruning",
                paragraphs: [
                    "Pruning is a major tool for Japanese yew bonsai development.",
                    "Structural pruning is used to establish trunk direction, primary branches, major movement and branch placement.",
                    "Development pruning is used to shorten extension growth, encourage secondary branching, redirect growth and improve silhouette.",
                    "Refinement pruning is used to maintain compact pads, improve ramification, remove unwanted extension growth and maintain interior structure.",
                    "Taxus can tolerate substantial pruning when healthy, but major interventions should still be staged.",
                    "Avoid removing all foliage from an important branch simply because yew has strong regenerative ability.",
                ]
            ),
            SpeciesProfileSection(
                id: "back-budding",
                title: "Back-budding",
                paragraphs: [
                    "Taxus cuspidata has useful regenerative ability and can produce new growth from older branches and wood when the tree is healthy.",
                    "This is one of its important advantages as bonsai material.",
                    "However, back-budding is not guaranteed. Very weak branches may not respond. Severely shaded interior wood may be less productive. Old branches should not automatically be assumed to regenerate.",
                    "Health and retained foliage are important.",
                    "Avoid absolute statements such as always back-buds from old wood.",
                ]
            ),
            SpeciesProfileSection(
                id: "ramification",
                title: "Ramification",
                paragraphs: [
                    "Japanese yew can develop dense secondary and tertiary branching when repeatedly developed from healthy shoots.",
                    "Best results come from controlled extension growth, selective pruning, preserving useful interior shoots, allowing recovery between major structural interventions and maintaining adequate light throughout the crown.",
                    "The species can become very refined over time.",
                ]
            ),
            SpeciesProfileSection(
                id: "wiring",
                title: "Wiring",
                paragraphs: [
                    "Taxus cuspidata has flexible wood and is highly suitable for wiring and branch positioning.",
                    "Wire useful branches while young and flexible. Use guy wires where appropriate.",
                    "Bend older branches carefully. Check wire regularly. Remove wire before it becomes deeply embedded.",
                    "Because yew can develop substantial bark and branch thickening over time, wire marks can become permanent if ignored.",
                    "Use progressive bending rather than forcing large bends in a single operation.",
                ]
            ),
            SpeciesProfileSection(
                id: "deadwood-potential",
                title: "Deadwood",
                paragraphs: [
                    "Deadwood is one of the major strengths of Taxus.",
                    "The species is highly suitable for jins, shari, hollow trunks, natural deadwood features and dramatic transitions between live vein and deadwood.",
                    "Taxus wood is dense and durable and can hold strong deadwood character.",
                    "Deadwood should still be developed with restraint.",
                    "Avoid creating artificial-looking deadwood simply because the species tolerates carving.",
                    "Preserve convincing live-vein flow.",
                ]
            ),
            SpeciesProfileSection(
                id: "defoliation",
                title: "Foliage Management",
                paragraphs: [
                    "Do not recommend routine full defoliation.",
                    "Instead emphasise selective shoot reduction, removal of weak or unnecessary growth, maintaining healthy foliage, opening congested areas, allowing light into the interior and preserving sufficient foliage to support recovery.",
                    "The objective is controlled density, not maximum density.",
                ]
            ),
            SpeciesProfileSection(
                id: "repotting",
                title: "Repotting",
                paragraphs: [
                    "Repotting should be based on root development, substrate condition, drainage, tree health, container size and development stage.",
                    "Do not prescribe a fixed two-year or three-year schedule.",
                    "Use conservative root work on older or heavily refined specimens.",
                    "Avoid combining major root reduction with major trunk or branch work unless necessary.",
                    "After repotting: protect from excessive wind, maintain appropriate moisture, avoid unnecessary additional stress and allow recovery before heavy pruning or wiring.",
                ]
            ),
            SpeciesProfileSection(
                id: "trunk-development",
                title: "Trunk Development",
                paragraphs: [
                    "For developing material, prioritise trunk health, trunk movement, taper, primary branch placement, nebari and eventual ramification.",
                    "Allow appropriate extension growth when building trunk and branch thickness.",
                    "Do not prematurely refine young material that still requires substantial structural development.",
                    "For mature material, transition gradually from extension growth to refinement.",
                    "Stage 1 — Establishment: root health, trunk health, strong growth, basic structural direction; avoid premature refinement.",
                    "Stage 2 — Structural Development: trunk movement, taper, primary branches, major bends, initial deadwood decisions.",
                    "Stage 3 — Branch Development: secondary branches, controlled extension, back-budding opportunities, ramification.",
                    "Stage 4 — Refinement: compact foliage, tertiary branching, silhouette, selective pruning, detailed wiring, controlled deadwood refinement.",
                    "Stage 5 — Mature Bonsai: maintaining health, preserving live veins, maintaining ramification, subtle silhouette adjustments, careful root management, long-term preservation of aged character.",
                ]
            ),
            SpeciesProfileSection(
                id: "nebari-development",
                title: "Nebari Development",
                paragraphs: [
                    "Nebari development should be gradual.",
                    "Priorities include early root planning, staged correction, development containers where appropriate and progressive refinement.",
                    "Do not force identical nebari expectations onto every tree.",
                    "The objective is: Stable anchoring · Natural base · Healthy feeder roots.",
                ]
            ),
            SpeciesProfileSection(
                id: "propagation",
                title: "Propagation",
                paragraphs: [
                    "Propagation may include seed, cuttings and nursery-grown material.",
                    "Cuttings are particularly relevant for horticultural propagation of yew, but rooting success depends on material, timing and conditions.",
                    "Seed propagation is slower and produces genetic variation.",
                    "Do not present one propagation method as universally superior.",
                    "Distinguish species propagation from cultivar propagation. Do not imply that seedlings reproduce a named cultivar.",
                    "Detailed procedures belong in Bonsai World Propagation Knowledge Articles.",
                ]
            ),
            SpeciesProfileSection(
                id: "pests",
                title: "Pests and Problems",
                paragraphs: [
                    "Potential problems include root problems from waterlogging, drought stress, bronze or reddish foliage associated with poor growing conditions, common container-related stress, occasional pest pressure and damage caused by unsuitable winter or summer conditions.",
                    "Healthy, appropriately cultivated yew is generally robust.",
                    "Present these as conditions to monitor rather than guaranteed problems.",
                    "Do not create an unnecessarily long pest list.",
                    "Diagnosis and treatment belong in Care → Pest Management and Care → Disease & Problems.",
                ]
            ),
            SpeciesProfileSection(
                id: "toxicity",
                title: "Toxicity and Safety",
                paragraphs: [
                    "Taxus cuspidata is highly toxic if eaten.",
                    "Foliage is toxic. Seeds are highly poisonous. Wood is also considered toxic.",
                    "The red fleshy aril surrounding the seed is the exception traditionally described as non-toxic, but the seed itself is highly poisonous.",
                    "Ingestion must be prevented. Pets and grazing animals are at particular risk. Children should not have access to plant material.",
                    "RHS specifically lists Taxus cuspidata as toxic if eaten and toxic to pets.",
                    "Handle pruning waste responsibly.",
                    "Do not provide toxic-dose calculations. Do not provide instructions for poisoning or extraction of toxins.",
                ]
            ),
            SpeciesProfileSection(
                id: "seasonal",
                title: "Seasonal Profile",
                paragraphs: [
                    "Spring: renewed shoot growth; active root development; useful period for structural evaluation; monitor moisture carefully as growth begins.",
                    "Summer: active growth and refinement; monitor heat and container moisture; maintain adequate light; avoid unnecessary stress during extreme heat.",
                    "Autumn: growth gradually slows; prepare for winter conditions; reduce feeding as appropriate; maintain healthy foliage.",
                    "Winter: evergreen; outdoor winter dormancy or rest is important; protect containers from extreme root-zone temperature swings; avoid prolonged waterlogging; monitor winter desiccation.",
                    "Do not invent a rigid winter protection schedule. The species should remain outdoors through winter.",
                ]
            ),
            SpeciesProfileSection(
                id: "styles",
                title: "Bonsai Styles",
                paragraphs: [
                    "Taxus cuspidata is suitable for Informal Upright, Slanting, Literati, Windswept, naturalistic, deadwood-focused designs, multi-trunk where appropriate and dramatic aged forms.",
                    "Formal Upright may also be possible on suitable material, but the species is particularly convincing when its aged trunk, flexible branches and deadwood characteristics are allowed to contribute to the design.",
                    "The individual material should determine the final design.",
                ]
            ),
            SpeciesProfileSection(
                id: "tree-stage",
                title: "Development by Tree Stage",
                paragraphs: [
                    "Stage 1 — Establishment: focus on root health, trunk health, strong growth, basic structural direction and avoiding premature refinement.",
                    "Stage 2 — Structural Development: focus on trunk movement, taper, primary branches, major bends and initial deadwood decisions.",
                    "Stage 3 — Branch Development: focus on secondary branches, controlled extension, back-budding opportunities and ramification.",
                    "Stage 4 — Refinement: focus on compact foliage, tertiary branching, silhouette, selective pruning, detailed wiring and controlled deadwood refinement.",
                    "Stage 5 — Mature Bonsai: focus on maintaining health, preserving live veins, maintaining ramification, subtle silhouette adjustments, careful root management and long-term preservation of aged character.",
                ]
            ),
            SpeciesProfileSection(
                id: "attention",
                title: "Species-Specific Attention",
                paragraphs: [
                    "These attention points are operational tendencies. They must still be interpreted for the individual tree.",
                    "Japanese yew should be presented as a long-term refinement species with exceptional deadwood and regenerative potential when cultivated carefully.",
                ],
                bullets: [
                    "Japanese yew is an evergreen conifer with excellent bonsai potential",
                    "It has stronger regenerative ability than many conifers but is not immune to over-pruning",
                    "Back-budding can be very useful on healthy established material",
                    "Deadwood is a major design strength",
                    "Live-vein development must be respected when carving",
                    "The species tolerates a broad range of light conditions, but bonsai still require adequate light for healthy compact growth",
                    "Avoid permanently wet substrates",
                    "Major root work and major top work should normally be separated",
                    "Japanese yew is highly toxic if eaten",
                    "Long-term refinement is often more valuable than forcing rapid development",
                    "Do not merge with Taxus baccata",
                    "Winter dormancy is required",
                    "Do not move indoors for routine winter care",
                ]
            ),
        ]
    }
}
