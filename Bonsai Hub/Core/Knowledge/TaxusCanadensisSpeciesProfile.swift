//
//  TaxusCanadensisSpeciesProfile.swift
//  Bonsai World
//
//  Species Profile — Taxus canadensis (Canada Yew / Canadian Yew).
//  Independent botanical species in Taxaceae. Knowledge status: Reviewed.
//  Separate from Taxus baccata, Taxus cuspidata, Taxus × media and other Taxus.
//

import Foundation

enum TaxusCanadensisSpeciesProfile {
    /// Identity used by Botanical Library / ``SpeciesPreviewData``.
    static let botanicalLibraryName = "Taxus canadensis"
    /// Scientific name for Species Profile display (binomial; no botanical authority).
    static let scientificName = "Taxus canadensis"

    static var profile: SpeciesProfile {
        SpeciesProfile(
            speciesID: BotanicalKnowledgeIDs.taxusCanadensis,
            scientificName: scientificName,
            commonNames: ["Canada Yew", "Canadian Yew"],
            family: "Taxaceae",
            plantType: "Evergreen conifer",
            originSummary: "Eastern North America, from Newfoundland and the Great Lakes region south through the northeastern United States into the Appalachians.",
            knowledgeStatus: .reviewed,
            traits: traits,
            foliageSizeLabel: "Foliage",
            foliageReductionLabel: "Foliage management",
            summaryLine: "Evergreen · Spreading to shrubby habit · Shade-tolerant · Cold-hardy · Good regenerative potential · Outdoor bonsai · Highly toxic if eaten",
            attentionHighlights: [
                "Canada yew is an evergreen conifer with a naturally lower, more spreading or shrubby habit than many tree-form yews",
                "It is shade-tolerant and cold-hardy, but bonsai still need adequate light for compact growth",
                "It remains an outdoor bonsai species requiring seasonal cold exposure",
                "Regenerative potential is good for Taxus but must not be treated as guaranteed",
                "Deadwood can be a design strength when live veins are respected",
                "Avoid permanently wet substrates",
                "Major root work and major top work should normally be separated",
                "Canada yew is highly toxic if eaten",
                "Long-term refinement suits the species' natural character",
                "Do not merge with Taxus baccata, Taxus cuspidata, Taxus × media or other Taxus",
                "Winter dormancy is required",
                "Do not move indoors for routine winter care",
            ],
            sections: sections,
            principleNote: """
            Taxus canadensis is more tolerant of structural intervention than many conifers, but this does not mean that it should be treated aggressively without regard to tree health.

            Preserve healthy foliage and viable growth points. Avoid removing too much productive foliage at once. Separate major structural work from unnecessary root disturbance. Allow recovery after major interventions.

            Use the tree's natural ability to regenerate rather than repeatedly forcing it. Develop branch structure progressively. Protect important live veins when creating or refining deadwood.

            Respect the species' often spreading or shrubby natural habit when choosing design direction; do not force every plant into a tall tree-form silhouette.

            Do not describe the species as indestructible.

            Do not promise guaranteed back-budding.

            Do not recommend extreme pruning as a default technique.

            Do not use Taxus baccata, Taxus cuspidata or Taxus × media as alternative identities. Do not merge this profile with other Taxus species.

            The individual tree must always be assessed according to health, age, climate, cultivation technique and recent work.

            The objective is: Healthy foliage · Progressive structure · Convincing live-vein and deadwood character · Sustainable long-term refinement
            """,
            sourcesNote: """
            Profile content is synthesised from recognised botanical, horticultural and bonsai authorities into Bonsai World editorial language.

            Botanical taxonomy and distribution draw primarily on Royal Botanic Gardens, Kew — Plants of the World Online and standard North American floristic references for Taxus canadensis: accepted species status, family Taxaceae, genus Taxus, and native distribution across eastern North America from Newfoundland and the Great Lakes region south through the northeastern United States into the Appalachians.

            Horticultural reference includes established guidance for Canada yew on evergreen habit, shade tolerance, cold hardiness, growth character, toxicity and susceptibility to waterlogging.

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
        backBudding: "Good potential for Taxus on established healthy material — not guaranteed; claim conservatively",
        rootDevelopment: "Moderate to Good with progressive management",
        nebariPotential: "Good potential with progressive development",
        trunkDevelopment: "Long-term — often lower, spreading character in nature; allow extension during structural development",
        barkDevelopment: "Brown to reddish-brown · Attractive mature texture",
        wiring: "Highly suitable — flexible wood",
        defoliation: "Not applicable as a routine technique",
        airLayering: "Where appropriate for the individual material",
        threadGrafting: "Specialist technique where structural correction is required",
        rootGrafting: "Specialist technique where appropriate",
        beginnerSuitability: "Moderate",
        bonsaiSuitability: "Good to Excellent — especially for naturalistic and spreading forms",
        difficulty: "Intermediate",
        winterDormancyRequired: true,
        winterHardiness: "High — cold-hardy outdoor evergreen requiring seasonal cold exposure",
        rootFrostSensitivity: "Moderate in shallow bonsai containers"
    )

    private static var sections: [SpeciesProfileSection] {
        [
            SpeciesProfileSection(
                id: "taxonomic-context",
                title: "Taxonomic Context",
                paragraphs: [
                    "Taxus canadensis is an independent botanical species in the yew family (Taxaceae), genus Taxus.",
                    "Primary Bonsai World display identity: Taxus canadensis · Canada Yew.",
                    "Family: Taxaceae. Genus: Taxus. Plant type: evergreen conifer.",
                    "Native range: eastern North America, from Newfoundland and the Great Lakes region south through the northeastern United States into the Appalachians.",
                    "Taxus canadensis is an accepted species distinct from European, Japanese, hybrid and Asian Taxus taxa.",
                    "Do not use Taxus baccata, Taxus cuspidata or Taxus × media as alternative identities. Do not merge this profile with other Taxus species.",
                    "Maintain a clear distinction between Taxus canadensis, Taxus baccata, Taxus cuspidata, Taxus × media, Taxus wallichiana and Taxus floridana.",
                    "Bonsai World hierarchy: Species → cultivar / horticultural selection → Individual Tree.",
                ]
            ),
            SpeciesProfileSection(
                id: "overview",
                title: "Species Overview",
                paragraphs: [
                    "Taxus canadensis is an evergreen conifer native to eastern North America.",
                    "In nature it often forms a lower, more spreading or shrubby habit than the taller tree-form expression commonly associated with some other yews, while still offering dense evergreen foliage, flexible wood and useful regenerative capacity for bonsai.",
                    "For bonsai, the species is valuable for naturalistic, spreading and multi-stem designs, shade-tolerant outdoor culture and long-term refinement of evergreen character.",
                    "Canada yew is cold-hardy and shade-tolerant, but container bonsai still require adequate light for healthy compact growth and must remain outdoors with seasonal cold exposure.",
                    "Species characteristics are potential, not universal guarantees. Results depend on health, age, climate and cultivation technique.",
                ],
                bullets: [
                    "Evergreen conifer",
                    "Taxaceae · Taxus",
                    "Native to eastern North America",
                    "Often lower, spreading or shrubby habit in nature",
                    "Shade-tolerant and cold-hardy",
                    "Outdoor bonsai requiring seasonal cold",
                    "Slow to moderate growth",
                    "Dark green needle-like foliage",
                    "Good regenerative potential on healthy material — claim conservatively",
                    "Useful deadwood potential",
                    "Flexible wood suitable for wiring",
                    "Highly toxic if eaten",
                    "Distinct from baccata, cuspidata, media, wallichiana and floridana",
                ]
            ),
            SpeciesProfileSection(
                id: "natural-growth",
                title: "Growth and Vigour",
                paragraphs: [
                    "Taxus canadensis is generally slow to moderate growing in bonsai culture.",
                    "Growth rate depends strongly on climate, light, root health, nutrition, container size, water availability, tree maturity and previous pruning intensity.",
                    "Young healthy plants may produce stronger extension growth than mature refined trees.",
                    "Natural spreading habit should influence expectations for trunk height and canopy architecture.",
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
                    "Trunks may remain relatively low or multi-stemmed compared with strongly arborescent yews; aged bark, irregular form and deadwood can still create powerful bonsai character.",
                    "The trunk and base can become visually convincing even when overall stature remains modest.",
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
                    "Taxus canadensis is notably shade-tolerant compared with many conifers.",
                    "For bonsai, bright light remains important for compact growth.",
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
                    "Established Canada yew can tolerate exposed conditions, but bonsai containers are more vulnerable than trees growing in the ground.",
                    "Consider wind desiccation, rapid moisture loss, branch movement, pot stability and winter exposure.",
                    "Protect newly repotted trees and weakened specimens from excessive wind.",
                ]
            ),
            SpeciesProfileSection(
                id: "watering",
                title: "Watering",
                paragraphs: [
                    "Taxus canadensis prefers consistent moisture, good drainage, oxygenated roots, avoidance of prolonged drought and avoidance of waterlogged substrate.",
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
                    "Taxus canadensis responds to appropriate nutrition during active growth.",
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
                    "Pruning is a major tool for Canada yew bonsai development.",
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
                    "Taxus canadensis has useful regenerative ability typical of Taxus and can produce new growth from older branches and wood when the tree is healthy.",
                    "Claims should remain conservative: good potential is not the same as guaranteed response.",
                    "Very weak branches may not respond. Severely shaded interior wood may be less productive. Old branches should not automatically be assumed to regenerate.",
                    "Health and retained foliage are important.",
                    "Avoid absolute statements such as always back-buds from old wood.",
                ]
            ),
            SpeciesProfileSection(
                id: "ramification",
                title: "Ramification",
                paragraphs: [
                    "Canada yew can develop dense secondary and tertiary branching when repeatedly developed from healthy shoots.",
                    "Best results come from controlled extension growth, selective pruning, preserving useful interior shoots, allowing recovery between major structural interventions and maintaining adequate light throughout the crown.",
                    "The species can become refined over time, often with a naturalistic spreading silhouette.",
                ]
            ),
            SpeciesProfileSection(
                id: "wiring",
                title: "Wiring",
                paragraphs: [
                    "Taxus canadensis has flexible wood and is highly suitable for wiring and branch positioning.",
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
                    "Canada yew is suitable for jins, shari, natural deadwood features and transitions between live vein and deadwood, particularly in naturalistic designs.",
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
                    "Stage 2 — Structural Development: trunk movement, taper, primary branches, major bends, initial deadwood decisions; respect spreading or multi-stem tendencies where natural.",
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
                    "Healthy, appropriately cultivated Canada yew is generally robust.",
                    "Present these as conditions to monitor rather than guaranteed problems.",
                    "Do not create an unnecessarily long pest list.",
                    "Diagnosis and treatment belong in Care → Pest Management and Care → Disease & Problems.",
                ]
            ),
            SpeciesProfileSection(
                id: "toxicity",
                title: "Toxicity and Safety",
                paragraphs: [
                    "Taxus canadensis is highly toxic if eaten, as with all Taxus.",
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
                    "Do not invent a rigid winter protection schedule. The species should remain outdoors through winter.",
                ]
            ),
            SpeciesProfileSection(
                id: "styles",
                title: "Bonsai Styles",
                paragraphs: [
                    "Taxus canadensis is suitable for Informal Upright, Slanting, Windswept, naturalistic, multi-trunk, raft-like and spreading forms, and deadwood-focused designs where the material supports them.",
                    "Literati and tall formal tree silhouettes may be less natural for many specimens given the species' often lower habit; the individual material should determine the final design.",
                    "Naturalistic and forest-related compositions can be particularly convincing.",
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
                    "Canada yew should be presented as a cold-hardy, shade-tolerant outdoor Taxus with often spreading natural habit and good regenerative potential when cultivated carefully — without overstating back-budding certainty.",
                ],
                bullets: [
                    "Canada yew is an evergreen conifer with good bonsai potential",
                    "Often lower, spreading or shrubby habit than tree-form yews",
                    "Shade-tolerant and cold-hardy, but still outdoor bonsai",
                    "Regenerative ability is good for Taxus but not guaranteed",
                    "Deadwood can be a design strength",
                    "Live-vein development must be respected when carving",
                    "Bonsai still require adequate light for healthy compact growth",
                    "Avoid permanently wet substrates",
                    "Major root work and major top work should normally be separated",
                    "Canada yew is highly toxic if eaten",
                    "Do not merge with other Taxus species",
                    "Winter dormancy is required",
                    "Do not move indoors for routine winter care",
                ]
            ),
        ]
    }
}
