//
//  AcaciaBaileyanaSpeciesProfile.swift
//  Bonsai World
//
//  Species Profile — Acacia baileyana (Cootamundra Wattle).
//  Independent botanical species in Fabaceae. Knowledge status: Reviewed.
//

import Foundation

enum AcaciaBaileyanaSpeciesProfile {
    /// Identity used by Botanical Library / ``SpeciesPreviewData``.
    static let botanicalLibraryName = "Acacia baileyana"
    /// Scientific name for Species Profile display (binomial; no botanical authority).
    static let scientificName = "Acacia baileyana"

    static var profile: SpeciesProfile {
        SpeciesProfile(
            speciesID: BotanicalKnowledgeIDs.acaciaBaileyana,
            scientificName: scientificName,
            commonNames: ["Cootamundra Wattle", "Bailey's Wattle"],
            synonyms: [],
            family: "Fabaceae",
            plantType: "Evergreen tree",
            originSummary: "South-eastern Australia; widely planted as an ornamental wattle.",
            knowledgeStatus: .reviewed,
            traits: traits,
            foliageSizeLabel: "Foliage",
            foliageReductionLabel: "Foliage management",
            summaryLine: "Evergreen · Fern-like foliage · Yellow flowers · Mild-climate Australian bonsai",
            attentionHighlights: ["Treat Acacia baileyana as an independent botanical species", "Protect from severe frost. Distinct from other Acacia. Fern-like bipinnate foliage defines character — do not force maple-like leaf reduction expectations.", "Preserve healthy foliage and viable growth points", "Do not promise guaranteed back-budding", "Avoid fixed watering timetables", "Do not prescribe one universal soil recipe", "Do not recommend routine defoliation", "Major root work and major top work should normally be separated", "Assess the individual tree by health, climate and development stage", "Provide frost-free or warm cultivation appropriate to the species", "Avoid sudden changes in light, water and temperature"],
            sections: sections,
            principleNote: """
            Acacia baileyana must be developed according to health, climate and progressive structure rather than forced by fixed recipes.

            Preserve productive growth. Do not promise guaranteed back-budding. Avoid fixed watering timetables and universal soil recipes.

            Protect from severe frost. Distinct from other Acacia. Fern-like bipinnate foliage defines character — do not force maple-like leaf reduction expectations.

            The objective is: Healthy growth · Progressive structure · Species-faithful character · Sustainable long-term refinement
            """,
            sourcesNote: """
            Profile content is synthesised from recognised botanical, horticultural and bonsai authorities into Bonsai World editorial language.

            Botanical taxonomy and distribution draw primarily on Royal Botanic Gardens, Kew — Plants of the World Online for the accepted scientific name Acacia baileyana, family Fabaceae, native distribution and taxonomic information.

            Bonsai-specific cultivation guidance draws on established bonsai practice and is phrased as cultivation guidance where it reflects general practice rather than species-specific research.

            Verified botanical information and bonsai-specific practice are kept distinct. Do not copy source wording.
            """
        )
    }

    private static let traits = SpeciesProfileTraits(
        deciduous: false,
        growthStrength: "Moderate — strongly climate and cultivation dependent",
        growthSpeed: "Moderate — strongly climate and cultivation dependent",
        leafSize: "Evergreen tree",
        foliageReduction: "Not applicable as a universal routine",
        ramificationPotential: "Good with progressive development",
        backBudding: "Good on healthy warm-growing material — not guaranteed",
        rootDevelopment: "Moderate with progressive management",
        nebariPotential: "Moderate to Good with progressive development",
        trunkDevelopment: "Long-term — allow extension during development",
        barkDevelopment: "Improves with age and cultivation",
        wiring: "Useful where wood flexibility allows — monitor carefully",
        defoliation: "Not applicable as a routine technique",
        airLayering: "Where appropriate for the individual material",
        threadGrafting: "Specialist technique where structural correction is required",
        rootGrafting: "Specialist technique where appropriate",
        beginnerSuitability: "Low to Moderate",
        bonsaiSuitability: "Good",
        difficulty: "Intermediate",
        winterDormancyRequired: false,
        winterHardiness: "Mild-climate outdoor; protect from severe frost — not a hard Nordic winter subject",
        rootFrostSensitivity: "Protect from cold; not a hardy outdoor Nordic bonsai subject"
    )

    private static var sections: [SpeciesProfileSection] {
        [
            SpeciesProfileSection(
                id: "taxonomic-context",
                title: "Taxonomic Context",
                paragraphs: [
                    "Acacia baileyana is an independent botanical species in Fabaceae.",
                    "Primary Bonsai World display identity: Acacia baileyana · Cootamundra Wattle.",
                    "Family: Fabaceae. Plant type: evergreen tree.",
                    "Native range / cultivation context: South-eastern Australia; widely planted as an ornamental wattle.",
                    "Protect from severe frost. Distinct from other Acacia. Fern-like bipinnate foliage defines character — do not force maple-like leaf reduction expectations.",
                    "Bonsai World hierarchy: Species → cultivar / horticultural selection → Individual Tree.",
                ]
            ),
            SpeciesProfileSection(
                id: "overview",
                title: "Species Overview",
                paragraphs: [
                    "Acacia baileyana (Cootamundra Wattle) is cultivated in bonsai for its species character, growth habit and long-term development potential.",
                    "Species-level guidance remains general. Do not transfer cultivar-specific traits to the species as a whole.",
                    "Development should favour progressive structure, preserved productive growth and climate-appropriate cultivation.",
                    "Assess climate carefully. Protect from conditions outside the species' reliable cultivation range.",
                ],
                bullets: ["Evergreen tree", "Fabaceae", "South-eastern Australia", "Reviewed Species Library profile", "Individual results depend on health, climate and cultivation"]
            ),
            SpeciesProfileSection(
                id: "natural-growth",
                title: "Growth and Vigour",
                paragraphs: [
                    "Growth rate and vigour depend on climate, light, water, nutrition, root health, container size, substrate, season and previous work.",
                    "Do not provide a universal annual growth rate.",
                    "During development, allow useful extension growth. During refinement, control extension progressively.",
                ]
            ),
            SpeciesProfileSection(
                id: "foliage",
                title: "Foliage",
                paragraphs: [
                    "Maintain healthy foliage appropriate to the species.",
                    "Balance density with light penetration and ventilation.",
                    "Do not strip productive growth merely to force a silhouette.",
                ]
            ),
            SpeciesProfileSection(
                id: "bark-trunk",
                title: "Bark and Trunk",
                paragraphs: [
                    "Allow sufficient time for trunk diameter, taper, movement and bark character to develop.",
                    "Do not prematurely maintain a finished silhouette while trunk development remains the priority.",
                ]
            ),
            SpeciesProfileSection(
                id: "roots-nebari",
                title: "Roots and Nebari",
                paragraphs: [
                    "Develop a balanced radial root system gradually.",
                    "Preserve healthy fine roots. Avoid aggressive root reduction solely for cosmetic reasons.",
                    "Maintain good drainage and oxygen availability.",
                ]
            ),
            SpeciesProfileSection(
                id: "light",
                title: "Light",
                paragraphs: [
                    "Provide light appropriate to compact, healthy growth for the species and climate.",
                    "Avoid prolonged deep shade that weakens interior growth.",
                    "Provide bright cultivation appropriate to a warm-climate or mild outdoor subject.",
                    "Protect from frost where winters exceed the species' reliable hardiness."
                ]
            ),
            SpeciesProfileSection(
                id: "wind",
                title: "Wind",
                paragraphs: [
                    "Container bonsai can dry and stress quickly in wind.",
                    "Secure the tree and monitor moisture during prolonged windy weather.",
                    "Protect newly repotted or weakened specimens.",
                ]
            ),
            SpeciesProfileSection(
                id: "watering",
                title: "Watering",
                paragraphs: [
                    "Water according to substrate moisture, temperature, wind, light, tree size, pot size, season and root activity.",
                    "Avoid prolonged stagnant saturation and repeated severe drying.",
                    "Do not provide a fixed watering timetable.",
                    "Use the existing Bonsai World watering guidance framework.",
                ]
            ),
            SpeciesProfileSection(
                id: "soil",
                title: "Soil",
                paragraphs: [
                    "Use an open, well-draining bonsai substrate with good oxygen availability and appropriate moisture retention.",
                    "Do not prescribe one universal soil recipe.",
                    "Adapt substrate to local climate, container size and watering regime.",
                    "Follow Bonsai World Soil Module principles.",
                ]
            ),
            SpeciesProfileSection(
                id: "fertilizing",
                title: "Fertilizing",
                paragraphs: [
                    "Fertilize according to development stage and tree condition.",
                    "Support useful growth during development; control nutrition during refinement when compact growth is desired.",
                    "Avoid fixed universal fertilizer doses.",
                    "Follow the existing Bonsai World fertilization framework.",
                ]
            ),
            SpeciesProfileSection(
                id: "pruning",
                title: "Pruning",
                paragraphs: [
                    "Prune for structure, controlled extension and progressive ramification.",
                    "Preserve useful interior growth.",
                    "Stage major interventions and allow recovery.",
                    "Avoid severe cuts into completely bare old wood when regeneration is uncertain.",
                ]
            ),
            SpeciesProfileSection(
                id: "back-budding",
                title: "Back-budding",
                paragraphs: [
                    "Back-budding must be described conservatively for Acacia baileyana.",
                    "New growth is most dependable where viable buds and healthy growth remain.",
                    "Never promise predictable back-budding.",
                ]
            ),
            SpeciesProfileSection(
                id: "ramification",
                title: "Ramification",
                paragraphs: [
                    "Develop secondary and tertiary branching progressively.",
                    "Maintain adequate light penetration and three-dimensional branch structure.",
                    "Avoid dense outer shells that weaken the interior.",
                ]
            ),
            SpeciesProfileSection(
                id: "wiring",
                title: "Wiring",
                paragraphs: [
                    "Wiring is useful for trunk movement and branch placement where wood flexibility allows.",
                    "Monitor wire regularly during active growth.",
                    "Remove or adjust wire before permanent scarring develops.",
                    "Use progressive bending rather than forcing unsafe bends.",
                ]
            ),
            SpeciesProfileSection(
                id: "deadwood-potential",
                title: "Deadwood",
                paragraphs: [
                    "Use deadwood only where it suits the individual tree and species character.",
                    "Keep proportions natural, preserve structural strength and avoid excessive carving.",
                ]
            ),
            SpeciesProfileSection(
                id: "defoliation",
                title: "Foliage Management",
                paragraphs: [
                    "Do not recommend routine full defoliation.",
                    "Focus on selective reduction, light penetration and sufficient retained foliage to support recovery.",
                ]
            ),
            SpeciesProfileSection(
                id: "repotting",
                title: "Repotting",
                paragraphs: [
                    "Repot when roots and substrate condition indicate need — not on a fixed calendar alone.",
                    "Use conservative root work on older or stressed trees.",
                    "Avoid combining major root reduction with major top work unless necessary.",
                    "Allow recovery after repotting.",
                ]
            ),
            SpeciesProfileSection(
                id: "trunk-development",
                title: "Trunk Development",
                paragraphs: [
                    "Stage 1 — Establishment: build root health and strong growth.",
                    "Stage 2 — Trunk development: allow controlled extension for diameter and taper.",
                    "Stage 3 — Primary structure: select and position major branches.",
                    "Stage 4 — Secondary branching: subdivide while preserving foliage.",
                    "Stage 5 — Refinement: control extension and improve silhouette.",
                    "Stage 6 — Maintenance: selective pruning and wiring to preserve structure.",
                ]
            ),
            SpeciesProfileSection(
                id: "nebari-development",
                title: "Nebari Development",
                paragraphs: [
                    "Improve radial root structure gradually.",
                    "Do not force identical nebari expectations onto every tree.",
                ]
            ),
            SpeciesProfileSection(
                id: "propagation",
                title: "Propagation",
                paragraphs: [
                    "Propagation may include seed, cuttings and nursery-grown material as appropriate to the species.",
                    "Seedlings vary genetically. Vegetative propagation maintains selected forms.",
                    "Do not present propagation as a rapid route to finished bonsai.",
                    "Detailed procedures belong in Bonsai World Propagation Knowledge Articles.",
                ]
            ),
            SpeciesProfileSection(
                id: "pests",
                title: "Pests and Problems",
                paragraphs: [
                    "Monitor for container stress, watering problems, pests and seasonal damage appropriate to the climate.",
                    "Present problems as conditions to monitor rather than guaranteed issues.",
                    "Diagnosis and treatment belong in Care → Pest Management and Care → Disease & Problems.",
                ]
            ),
            SpeciesProfileSection(
                id: "seasonal",
                title: "Seasonal Profile",
                paragraphs: [
                    "Spring: renew growth monitoring, review structure and increase water as activity rises.",
                    "Summer: maintain moisture and light balance; avoid unnecessary stress in extreme heat.",
                    "Autumn: harden growth and prepare for the coming season.",
                    "Winter: provide frost-free or mild-climate conditions appropriate to the species; avoid sudden environmental swings.",
                ]
            ),
            SpeciesProfileSection(
                id: "styles",
                title: "Bonsai Styles",
                paragraphs: [
                    "Suitable styles depend on the individual trunk and branch character and may include informal upright, slanting, naturalistic and other forms supported by the material.",
                    "The individual tree should determine the final design.",
                ]
            ),
            SpeciesProfileSection(
                id: "tree-stage",
                title: "Development by Tree Stage",
                paragraphs: [
                    "Young material: health, trunk direction and roots — avoid premature refinement.",
                    "Pre-bonsai: taper, primary branches and controlled extension.",
                    "Established bonsai: secondary branching, balance and maintenance wiring.",
                    "Mature bonsai: fine adjustment, health preservation and restrained intervention.",
                ]
            ),
            SpeciesProfileSection(
                id: "attention",
                title: "Species-Specific Attention",
                paragraphs: [
                    "These attention points are operational tendencies. They must still be interpreted for the individual tree.",
                ],
                bullets: ["Treat Acacia baileyana as an independent botanical species", "Protect from severe frost. Distinct from other Acacia. Fern-like bipinnate foliage defines character — do not force maple-like leaf reduction expectations.", "Preserve healthy foliage and viable growth points", "Do not promise guaranteed back-budding", "Avoid fixed watering timetables", "Do not prescribe one universal soil recipe", "Do not recommend routine defoliation", "Major root work and major top work should normally be separated", "Assess the individual tree by health, climate and development stage", "Provide frost-free or warm cultivation appropriate to the species", "Avoid sudden changes in light, water and temperature"]
            ),

        ]
    }
}
