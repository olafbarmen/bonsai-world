//
//  TaxusMediaSpeciesProfile.swift
//  Bonsai World
//
//  Species Profile — Taxus × media (Hybrid Yew / Anglo-Japanese Yew).
//  Horticultural hybrid of Taxus baccata × Taxus cuspidata. Knowledge status: Reviewed.
//  Separate from both parent species and from other Taxus taxa.
//

import Foundation

enum TaxusMediaSpeciesProfile {
    /// Identity used by Botanical Library / ``SpeciesPreviewData``.
    static let botanicalLibraryName = "Taxus x media"
    /// Scientific name for Species Profile display (hybrid formula with multiplication sign).
    static let scientificName = "Taxus × media"

    static var profile: SpeciesProfile {
        SpeciesProfile(
            speciesID: BotanicalKnowledgeIDs.taxusMedia,
            scientificName: scientificName,
            commonNames: ["Hybrid Yew", "Anglo-Japanese Yew"],
            synonyms: ["Taxus x media"],
            family: "Taxaceae",
            plantType: "Evergreen conifer · Horticultural hybrid",
            originSummary: "Artificial horticultural hybrid of Taxus baccata and Taxus cuspidata.",
            knowledgeStatus: .reviewed,
            traits: traits,
            foliageSizeLabel: "Foliage",
            foliageReductionLabel: "Foliage management",
            summaryLine: "Evergreen hybrid · Dark green needles · Strong regenerative potential · Excellent nursery bonsai material · Flexible wood · Many cultivars · Highly toxic if eaten",
            attentionHighlights: [
                "Hybrid yew is an evergreen horticultural hybrid with excellent bonsai suitability for many nursery forms",
                "It is distinct from Taxus baccata and Taxus cuspidata; do not merge identities",
                "Many cultivars exist — do not treat cultivar traits as hybrid-wide guarantees",
                "Regenerative potential is generally good, like the parent species, but is not guaranteed",
                "Deadwood is a major design strength when live veins are respected",
                "Bright outdoor light supports compact growth; shade tolerance is not a reason for deep shade",
                "Avoid permanently wet substrates",
                "Major root work and major top work should normally be separated",
                "All Taxus material is highly toxic if eaten",
                "Long-term refinement is often more valuable than forcing rapid development",
                "Winter dormancy is required",
                "Do not move indoors for routine winter care",
            ],
            sections: sections,
            principleNote: """
            Taxus × media is more tolerant of structural intervention than many conifers, but this does not mean that it should be treated aggressively without regard to tree health.

            Preserve healthy foliage and viable growth points. Avoid removing too much productive foliage at once. Separate major structural work from unnecessary root disturbance. Allow recovery after major interventions.

            Use the tree's natural ability to regenerate rather than repeatedly forcing it. Develop branch structure progressively. Protect important live veins when creating or refining deadwood.

            Do not describe the hybrid as indestructible.

            Do not promise guaranteed back-budding.

            Do not recommend extreme pruning as a default technique.

            Do not invent cultivar traits as hybrid-wide characteristics. Assess the individual plant, including any named selection.

            Do not use Taxus baccata or Taxus cuspidata as alternative identities. Do not merge this profile with either parent species.

            The individual tree must always be assessed according to health, age, cultivar, climate, cultivation technique and recent work.

            The objective is: Healthy foliage · Progressive structure · Convincing live-vein and deadwood character · Sustainable long-term refinement
            """,
            sourcesNote: """
            Profile content is synthesised from recognised botanical, horticultural and bonsai authorities into Bonsai World editorial language.

            Botanical and horticultural identity draws on accepted hybrid nomenclature for Taxus × media Rehder (Taxus baccata × Taxus cuspidata), family Taxaceae, genus Taxus, as an artificial horticultural hybrid widely used in temperate ornamental planting and nursery trade.

            Horticultural reference includes established guidance for hybrid yew / Anglo-Japanese yew on evergreen habit, growth character, toxicity and susceptibility to waterlogging, recognising that many named cultivars exist and must not be generalised as species-wide traits.

            Bonsai-specific cultivation and refinement knowledge draws on established bonsai references and recognised professional practice with Taxus experience. Where guidance reflects general yew bonsai practice rather than hybrid-specific research, it is phrased as cultivation guidance rather than botanical fact.

            Verified botanical information, horticultural information and bonsai-specific practice are kept distinct. Do not copy source wording.
            """
        )
    }

    private static let traits = SpeciesProfileTraits(
        deciduous: false,
        growthStrength: "Slow to Moderate",
        growthSpeed: "Slow to Moderate — strongly climate, cultivar and cultivation dependent",
        leafSize: "Evergreen · Dark green needle-like foliage · Flattened needles; density varies by selection",
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
        beginnerSuitability: "Moderate to Good — many nursery forms are accessible",
        bonsaiSuitability: "Excellent for many nursery forms",
        difficulty: "Intermediate",
        winterDormancyRequired: true,
        winterHardiness: "High for most temperate outdoor selections — outdoor evergreen requiring seasonal cold exposure",
        rootFrostSensitivity: "Moderate in shallow bonsai containers"
    )

    private static var sections: [SpeciesProfileSection] {
        [
            SpeciesProfileSection(
                id: "taxonomic-context",
                title: "Taxonomic Context",
                paragraphs: [
                    "Taxus × media is an artificial horticultural hybrid in the yew family (Taxaceae), genus Taxus, resulting from Taxus baccata × Taxus cuspidata.",
                    "Primary Bonsai World display identity: Taxus × media · Hybrid Yew (also known as Anglo-Japanese Yew).",
                    "Botanical Library / PreviewData identity string: Taxus x media (ASCII x form used for library matching).",
                    "Family: Taxaceae. Genus: Taxus. Plant type: evergreen conifer · horticultural hybrid.",
                    "The hybrid is widely cultivated and is represented by many named cultivars; cultivar characters must not be treated as hybrid-wide guarantees.",
                    "Do not use Taxus baccata or Taxus cuspidata as alternative identities. Do not merge this profile with either parent species.",
                    "Maintain a clear distinction between Taxus × media, Taxus baccata, Taxus cuspidata, Taxus canadensis, Taxus wallichiana and Taxus floridana.",
                    "Bonsai World hierarchy: Hybrid / species-level identity → cultivar / horticultural selection → Individual Tree.",
                ]
            ),
            SpeciesProfileSection(
                id: "overview",
                title: "Species Overview",
                paragraphs: [
                    "Taxus × media is an evergreen horticultural hybrid combining European and Japanese yew parentage.",
                    "It is widely available as nursery material and offers dense evergreen foliage, flexible wood, useful regenerative capacity and strong potential for mature bonsai character.",
                    "For bonsai, many nursery forms are particularly valuable because they combine evergreen foliage, relatively compact needle growth, strong branch flexibility, good response to structural pruning, useful capacity for producing new shoots on older wood when healthy, exceptional deadwood potential and excellent longevity.",
                    "Hybrid yew should be treated as a long-term refinement subject rather than material that must be forced into rapid development.",
                    "Because numerous cultivars exist, growth habit, needle density and vigour can vary; always assess the individual plant rather than assuming a single hybrid-wide type.",
                    "Hybrid characteristics are potential, not universal guarantees. Results depend on health, age, cultivar, climate and cultivation technique.",
                ],
                bullets: [
                    "Evergreen conifer · Horticultural hybrid",
                    "Taxaceae · Taxus",
                    "Hybrid of Taxus baccata × Taxus cuspidata",
                    "Excellent bonsai suitability for many nursery forms",
                    "Slow to moderate growth",
                    "Dark green needle-like foliage",
                    "Good regenerative potential on healthy material — not guaranteed",
                    "Excellent deadwood potential",
                    "Flexible wood suitable for wiring",
                    "Many cultivars — do not generalise cultivar traits",
                    "Highly toxic if eaten",
                    "Requires outdoor cultivation and seasonal cold exposure",
                    "Distinct from Taxus baccata and Taxus cuspidata",
                ]
            ),
            SpeciesProfileSection(
                id: "natural-growth",
                title: "Growth and Vigour",
                paragraphs: [
                    "Taxus × media is generally slow to moderate growing in bonsai culture.",
                    "Growth rate depends strongly on climate, light, root health, nutrition, container size, water availability, tree maturity, previous pruning intensity and cultivar.",
                    "Young healthy plants may produce stronger extension growth than mature refined trees.",
                    "Avoid fixed annual growth expectations.",
                    "The objective is: Useful development growth · Progressive control · Preserved productive foliage.",
                ]
            ),
            SpeciesProfileSection(
                id: "foliage",
                title: "Foliage",
                paragraphs: [
                    "Foliage is evergreen, with dark green, flattened needles. Needle length and density vary among selections.",
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
                    "Taxus × media tolerates a relatively broad range of light conditions compared with many conifers.",
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
                    "Established hybrid yew can tolerate exposed conditions, but bonsai containers are more vulnerable than trees growing in the ground.",
                    "Consider wind desiccation, rapid moisture loss, branch movement, pot stability and winter exposure.",
                    "Protect newly repotted trees and weakened specimens from excessive wind.",
                ]
            ),
            SpeciesProfileSection(
                id: "watering",
                title: "Watering",
                paragraphs: [
                    "Taxus × media prefers consistent moisture, good drainage, oxygenated roots, avoidance of prolonged drought and avoidance of waterlogged substrate.",
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
                    "Taxus × media responds to appropriate nutrition during active growth.",
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
                    "Pruning is a major tool for hybrid yew bonsai development.",
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
                    "Taxus × media generally shows good regenerative potential comparable to its parent species and can produce new growth from older branches and wood when the tree is healthy.",
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
                    "Hybrid yew can develop dense secondary and tertiary branching when repeatedly developed from healthy shoots.",
                    "Best results come from controlled extension growth, selective pruning, preserving useful interior shoots, allowing recovery between major structural interventions and maintaining adequate light throughout the crown.",
                    "The hybrid can become very refined over time.",
                ]
            ),
            SpeciesProfileSection(
                id: "wiring",
                title: "Wiring",
                paragraphs: [
                    "Taxus × media has flexible wood and is highly suitable for wiring and branch positioning.",
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
                    "The hybrid is highly suitable for jins, shari, hollow trunks, natural deadwood features and dramatic transitions between live vein and deadwood.",
                    "Taxus wood is dense and durable and can hold strong deadwood character.",
                    "Deadwood should still be developed with restraint.",
                    "Avoid creating artificial-looking deadwood simply because the plant tolerates carving.",
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
                    "Propagation may include cuttings and nursery-grown material; seed is less relevant for preserving a named hybrid or cultivar identity.",
                    "Cuttings are particularly relevant for horticultural propagation of hybrid yew, but rooting success depends on material, timing and conditions.",
                    "Do not present one propagation method as universally superior.",
                    "Distinguish hybrid propagation from cultivar propagation. Do not imply that seedlings reproduce a named cultivar.",
                    "Detailed procedures belong in Bonsai World Propagation Knowledge Articles.",
                ]
            ),
            SpeciesProfileSection(
                id: "pests",
                title: "Pests and Problems",
                paragraphs: [
                    "Potential problems include root problems from waterlogging, drought stress, bronze or reddish foliage associated with poor growing conditions, common container-related stress, occasional pest pressure and damage caused by unsuitable winter or summer conditions.",
                    "Healthy, appropriately cultivated hybrid yew is generally robust.",
                    "Present these as conditions to monitor rather than guaranteed problems.",
                    "Do not create an unnecessarily long pest list.",
                    "Diagnosis and treatment belong in Care → Pest Management and Care → Disease & Problems.",
                ]
            ),
            SpeciesProfileSection(
                id: "toxicity",
                title: "Toxicity and Safety",
                paragraphs: [
                    "Taxus × media is highly toxic if eaten, as with all Taxus.",
                    "Foliage is toxic. Seeds are highly poisonous. Wood is also considered toxic.",
                    "The red fleshy aril surrounding the seed is the exception traditionally described as non-toxic, but the seed itself is highly poisonous.",
                    "Ingestion must be prevented. Pets and grazing animals are at particular risk. Children should not have access to plant material.",
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
                    "Do not invent a rigid winter protection schedule. The hybrid should remain outdoors through winter in climates suited to temperate Taxus.",
                ]
            ),
            SpeciesProfileSection(
                id: "styles",
                title: "Bonsai Styles",
                paragraphs: [
                    "Taxus × media is suitable for Informal Upright, Slanting, Literati, Windswept, naturalistic, deadwood-focused designs, multi-trunk where appropriate and dramatic aged forms.",
                    "Formal Upright may also be possible on suitable material, but the hybrid is particularly convincing when aged trunk, flexible branches and deadwood characteristics are allowed to contribute to the design.",
                    "Nursery habit and cultivar form strongly influence which styles are natural; the individual material should determine the final design.",
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
                    "Hybrid yew should be presented as a long-term refinement subject with strong nursery availability, excellent deadwood potential and good regenerative character when cultivated carefully — without treating any cultivar as representing the entire hybrid.",
                ],
                bullets: [
                    "Hybrid yew is an evergreen horticultural hybrid with excellent bonsai suitability for many nursery forms",
                    "It is distinct from Taxus baccata and Taxus cuspidata",
                    "Many cultivars exist — do not invent cultivar traits as hybrid-wide",
                    "Regenerative potential is generally good but not guaranteed",
                    "Deadwood is a major design strength",
                    "Live-vein development must be respected when carving",
                    "Bonsai still require adequate light for healthy compact growth",
                    "Avoid permanently wet substrates",
                    "Major root work and major top work should normally be separated",
                    "All Taxus material is highly toxic if eaten",
                    "Long-term refinement is often more valuable than forcing rapid development",
                    "Winter dormancy is required",
                    "Do not move indoors for routine winter care",
                ]
            ),
        ]
    }
}
