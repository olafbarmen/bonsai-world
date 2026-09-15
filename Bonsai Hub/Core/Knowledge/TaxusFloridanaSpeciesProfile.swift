//
//  TaxusFloridanaSpeciesProfile.swift
//  Bonsai World
//
//  Species Profile — Taxus floridana (Florida Yew).
//  Independent botanical species in Taxaceae. Knowledge status: Reviewed.
//  Rare restricted endemic. Prefer nursery material. Separate from other Taxus.
//

import Foundation

enum TaxusFloridanaSpeciesProfile {
    /// Identity used by Botanical Library / ``SpeciesPreviewData``.
    static let botanicalLibraryName = "Taxus floridana"
    /// Scientific name for Species Profile display (binomial; no botanical authority).
    static let scientificName = "Taxus floridana"

    static var profile: SpeciesProfile {
        SpeciesProfile(
            speciesID: BotanicalKnowledgeIDs.taxusFloridana,
            scientificName: scientificName,
            commonNames: ["Florida Yew"],
            family: "Taxaceae",
            plantType: "Evergreen conifer",
            originSummary: "A very restricted native range in northwestern Florida, USA.",
            knowledgeStatus: .reviewed,
            traits: traits,
            foliageSizeLabel: "Foliage",
            foliageReductionLabel: "Foliage management",
            summaryLine: "Evergreen · Restricted Florida endemic · Prefer nursery material · Regenerative Taxus character · Outdoor bonsai with climate care · Highly toxic if eaten",
            attentionHighlights: [
                "Florida yew is a rare, restricted endemic evergreen Taxus",
                "Emphasise nursery material; legal and ethical constraints apply to wild material",
                "It shares Taxus regenerative and deadwood character, but claims should remain careful",
                "May be less cold-hardy than northern Taxus — adapt outdoor culture to local climate",
                "Still an outdoor bonsai species; do not treat as a houseplant",
                "Avoid permanently wet substrates",
                "Major root work and major top work should normally be separated",
                "Florida yew is highly toxic if eaten",
                "Long-term refinement suits the species when material is legally available",
                "Do not merge with Taxus baccata, Taxus cuspidata, Taxus × media or other Taxus",
                "Seasonal rest outdoors is required; protect from unsuitable cold without inventing absolute hardiness zones",
            ],
            sections: sections,
            principleNote: """
            Taxus floridana shares the regenerative Taxus character that makes yews valuable for bonsai, but this does not mean that it should be treated aggressively without regard to tree health.

            Preserve healthy foliage and viable growth points. Avoid removing too much productive foliage at once. Separate major structural work from unnecessary root disturbance. Allow recovery after major interventions.

            Prefer nursery-grown material. The species has a very restricted native range; wild collection is subject to legal and ethical constraints and should not be assumed appropriate.

            Do not describe the species as indestructible.

            Do not promise guaranteed back-budding.

            Do not recommend extreme pruning as a default technique.

            Do not invent absolute hardiness-zone guarantees. Florida yew may be less cold-hardy than northern Taxus; adapt outdoor cultivation carefully to local climate.

            Do not use other Taxus species as alternative identities. Do not merge this profile with Taxus baccata, Taxus cuspidata, Taxus × media, Taxus canadensis or Taxus wallichiana.

            The individual tree must always be assessed according to health, age, climate, cultivation technique and recent work.

            The objective is: Healthy foliage · Progressive structure · Convincing live-vein and deadwood character · Sustainable long-term refinement
            """,
            sourcesNote: """
            Profile content is synthesised from recognised botanical, horticultural and bonsai authorities into Bonsai World editorial language.

            Botanical taxonomy and distribution draw primarily on Royal Botanic Gardens, Kew — Plants of the World Online and regional floristic references for Taxus floridana: accepted species status, family Taxaceae, genus Taxus, and a very restricted native range in northwestern Florida, USA.

            Horticultural and conservation context emphasises nursery material and legal, ethical sourcing for a rare restricted endemic. Cold-hardiness guidance is framed as climate adaptation rather than absolute hardiness-zone claims.

            Bonsai-specific cultivation and refinement knowledge draws on established bonsai references and recognised professional practice with Taxus experience. Where guidance reflects general yew bonsai practice rather than species-specific research, it is phrased as cultivation guidance rather than botanical fact.

            Verified botanical information, horticultural information and bonsai-specific practice are kept distinct. Do not copy source wording.
            """
        )
    }

    private static let traits = SpeciesProfileTraits(
        deciduous: false,
        growthStrength: "Slow to Moderate",
        growthSpeed: "Slow to Moderate — strongly climate and cultivation dependent",
        leafSize: "Evergreen · Dark green needle-like foliage · Flattened needles",
        foliageReduction: "Not applicable",
        ramificationPotential: "Good with controlled development",
        backBudding: "Good potential for Taxus on established healthy material — not guaranteed",
        rootDevelopment: "Moderate to Good with progressive management",
        nebariPotential: "Good potential with progressive development",
        trunkDevelopment: "Long-term — allow extension during structural development",
        barkDevelopment: "Brown to reddish-brown · Attractive mature texture",
        wiring: "Highly suitable — flexible wood",
        defoliation: "Not applicable as a routine technique",
        airLayering: "Where appropriate for the individual material",
        threadGrafting: "Specialist technique where structural correction is required",
        rootGrafting: "Specialist technique where appropriate",
        beginnerSuitability: "Moderate — limited availability; climate care required",
        bonsaiSuitability: "Good to Excellent where nursery material is available",
        difficulty: "Intermediate",
        winterDormancyRequired: true,
        winterHardiness: "May be less cold-hardy than northern Taxus — outdoor evergreen requiring seasonal rest adapted carefully to local climate",
        rootFrostSensitivity: "Moderate to High in shallow bonsai containers — protect from unsuitable cold"
    )

    private static var sections: [SpeciesProfileSection] {
        [
            SpeciesProfileSection(
                id: "taxonomic-context",
                title: "Taxonomic Context",
                paragraphs: [
                    "Taxus floridana is an independent botanical species in the yew family (Taxaceae), genus Taxus.",
                    "Primary Bonsai World display identity: Taxus floridana · Florida Yew.",
                    "Family: Taxaceae. Genus: Taxus. Plant type: evergreen conifer.",
                    "Native range: a very restricted area in northwestern Florida, USA.",
                    "Taxus floridana is a rare restricted endemic and must not be confused with other Taxus species.",
                    "Do not use Taxus baccata, Taxus cuspidata or Taxus × media as alternative identities. Do not merge this profile with other Taxus species.",
                    "Maintain a clear distinction between Taxus floridana, Taxus baccata, Taxus cuspidata, Taxus × media, Taxus canadensis and Taxus wallichiana.",
                    "Bonsai World hierarchy: Species → cultivar / horticultural selection → Individual Tree.",
                ]
            ),
            SpeciesProfileSection(
                id: "overview",
                title: "Species Overview",
                paragraphs: [
                    "Taxus floridana is an evergreen conifer endemic to a very restricted native range in northwestern Florida, USA.",
                    "It shares the core Taxus bonsai strengths of dense evergreen foliage, flexible wood, regenerative Taxus character and useful deadwood potential.",
                    "Because the species is rare and geographically restricted, emphasise nursery-grown material. Legal and ethical constraints apply to wild material.",
                    "Florida yew may be less cold-hardy than northern Taxus. Outdoor bonsai culture must be adapted carefully to local climate without inventing absolute hardiness-zone guarantees.",
                    "Species characteristics are potential, not universal guarantees. Results depend on health, age, climate and cultivation technique.",
                ],
                bullets: [
                    "Evergreen conifer",
                    "Taxaceae · Taxus",
                    "Restricted endemic of northwestern Florida, USA",
                    "Rare — prefer nursery material",
                    "Legal and ethical constraints on wild material",
                    "Slow to moderate growth",
                    "Dark green needle-like foliage",
                    "Regenerative Taxus character — not guaranteed",
                    "Useful deadwood potential",
                    "Flexible wood suitable for wiring",
                    "May be less cold-hardy than northern Taxus",
                    "Outdoor bonsai with climate adaptation",
                    "Highly toxic if eaten",
                    "Distinct from other Taxus species",
                ]
            ),
            SpeciesProfileSection(
                id: "natural-growth",
                title: "Growth and Vigour",
                paragraphs: [
                    "Taxus floridana is generally slow to moderate growing in bonsai culture.",
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
                    "Foliage is evergreen, with dark green, flattened needles.",
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
                    "Older specimens can develop aged trunks with fissuring, irregular bark, deadwood and contrasting live and dead tissue.",
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
                    "Taxus floridana tolerates a relatively broad range of light conditions compared with many conifers.",
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
                    "Established Florida yew can tolerate exposed conditions within its climatic range, but bonsai containers are more vulnerable than trees growing in the ground.",
                    "Consider wind desiccation, rapid moisture loss, branch movement, pot stability and seasonal exposure.",
                    "Protect newly repotted trees and weakened specimens from excessive wind.",
                ]
            ),
            SpeciesProfileSection(
                id: "watering",
                title: "Watering",
                paragraphs: [
                    "Taxus floridana prefers consistent moisture, good drainage, oxygenated roots, avoidance of prolonged drought and avoidance of waterlogged substrate.",
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
                    "Taxus floridana responds to appropriate nutrition during active growth.",
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
                    "Pruning is a major tool for Florida yew bonsai development.",
                    "Structural pruning is used to establish trunk direction, primary branches, major movement and branch placement.",
                    "Development pruning is used to shorten extension growth, encourage secondary branching, redirect growth and improve silhouette.",
                    "Refinement pruning is used to maintain compact pads, improve ramification, remove unwanted extension growth and maintain interior structure.",
                    "Taxus can tolerate substantial pruning when healthy, but major interventions should still be staged.",
                    "Avoid removing all foliage from an important branch simply because yew has regenerative ability.",
                ]
            ),
            SpeciesProfileSection(
                id: "back-budding",
                title: "Back-budding",
                paragraphs: [
                    "Taxus floridana has useful regenerative ability typical of Taxus and can produce new growth from older branches and wood when the tree is healthy.",
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
                    "Florida yew can develop dense secondary and tertiary branching when repeatedly developed from healthy shoots.",
                    "Best results come from controlled extension growth, selective pruning, preserving useful interior shoots, allowing recovery between major structural interventions and maintaining adequate light throughout the crown.",
                    "The species can become refined over time.",
                ]
            ),
            SpeciesProfileSection(
                id: "wiring",
                title: "Wiring",
                paragraphs: [
                    "Taxus floridana has flexible wood and is highly suitable for wiring and branch positioning.",
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
                    "Florida yew is suitable for jins, shari, natural deadwood features and transitions between live vein and deadwood.",
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
                    "Prefer nursery-propagated stock. Do not encourage wild collection from the restricted native range.",
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
                    "Healthy, appropriately cultivated Florida yew is generally robust within a suitable climate.",
                    "Present these as conditions to monitor rather than guaranteed problems.",
                    "Do not create an unnecessarily long pest list.",
                    "Diagnosis and treatment belong in Care → Pest Management and Care → Disease & Problems.",
                ]
            ),
            SpeciesProfileSection(
                id: "toxicity",
                title: "Toxicity and Safety",
                paragraphs: [
                    "Taxus floridana is highly toxic if eaten, as with all Taxus.",
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
                    "Autumn: growth gradually slows; prepare for winter conditions according to local climate; reduce feeding as appropriate; maintain healthy foliage.",
                    "Winter: evergreen; outdoor seasonal rest remains important; Florida yew may be less cold-hardy than northern Taxus — protect containers from unsuitable cold without inventing absolute hardiness zones; avoid prolonged waterlogging; monitor winter desiccation.",
                    "Do not invent a rigid winter protection schedule. Adapt outdoor culture carefully to local climate.",
                ]
            ),
            SpeciesProfileSection(
                id: "styles",
                title: "Bonsai Styles",
                paragraphs: [
                    "Taxus floridana is suitable for Informal Upright, Slanting, Literati, Windswept, naturalistic, deadwood-focused designs, multi-trunk where appropriate and dramatic aged forms.",
                    "Formal Upright may also be possible on suitable material, but the species is particularly convincing when aged trunk, flexible branches and deadwood characteristics are allowed to contribute to the design.",
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
                    "Florida yew should be presented as a rare restricted endemic Taxus with regenerative character, a preference for nursery material and careful outdoor climate adaptation.",
                ],
                bullets: [
                    "Florida yew is a rare restricted endemic evergreen Taxus",
                    "Prefer nursery material; legal and ethical constraints on wild material",
                    "Regenerative Taxus character — not guaranteed",
                    "May be less cold-hardy than northern Taxus",
                    "Deadwood can be a design strength",
                    "Live-vein development must be respected when carving",
                    "Bonsai still require adequate light for healthy compact growth",
                    "Avoid permanently wet substrates",
                    "Major root work and major top work should normally be separated",
                    "Florida yew is highly toxic if eaten",
                    "Do not merge with other Taxus species",
                    "Outdoor seasonal rest is required",
                    "Do not move indoors for routine winter care",
                ]
            ),
        ]
    }
}
