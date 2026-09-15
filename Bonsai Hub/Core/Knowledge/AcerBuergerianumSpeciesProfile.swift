//
//  AcerBuergerianumSpeciesProfile.swift
//  Bonsai World
//
//  Species Profile — Acer buergerianum Miq. (Trident Maple).
//  First fully revised reference profile (botanical verification + content accuracy).
//  Knowledge status: Reviewed.
//

import Foundation

enum AcerBuergerianumSpeciesProfile {
    /// Binomial used by Botanical Library / ``SpeciesPreviewData``.
    static let botanicalLibraryName = "Acer buergerianum"
    /// Scientific name for Species Profile display (binomial; authorship in taxonomic sections).
    static let scientificName = "Acer buergerianum"

    static var profile: SpeciesProfile {
        SpeciesProfile(
            speciesID: BotanicalKnowledgeIDs.acerBuergerianum,
            scientificName: scientificName,
            commonNames: ["Trident Maple", "Three-toothed Maple"],
            family: "Sapindaceae",
            plantType: "Deciduous tree",
            originSummary: "South and East China, Taiwan",
            knowledgeStatus: .reviewed,
            traits: traits,
            summaryLine: "Deciduous · Strong growth · Excellent bonsai suitability",
            attentionHighlights: [
                "Strong growth — monitor excessive extension, apex dominance and rapid branch thickening",
                "Strong root development — monitor root congestion, substrate condition and the need for root management",
                "High ramification potential — use controlled pruning to prevent fine structure from becoming unnecessarily coarse",
                "Wiring during active growth — monitor for wire marks",
                "High water demand during active growth — monitor drying, particularly in shallow containers and during wind or heat",
                "Winter dormancy — protect the root system appropriately during severe or prolonged freezing, particularly in shallow containers",
            ],
            sections: sections,
            principleNote: """
            Acer buergerianum is generally a vigorous and adaptable species with strong potential for bonsai development.

            However, individual trees can respond very differently depending on health, age, root condition, development stage, recent work and growing environment.

            Species characteristics should therefore guide decisions rather than automatically determine them.

            The Bonsai World Species Profile provides tendencies, capabilities and development knowledge.

            The individual tree always remains the primary source of operational decision-making.
            """,
            sourcesNote: """
            Profile content is synthesised from recognised botanical, horticultural and bonsai authorities into Bonsai World editorial language.

            Botanical taxonomy and distribution — Royal Botanic Gardens, Kew (Plants of the World Online); Flora of China / recognised botanical floras; World Flora Online where required.

            Horticultural information — Royal Horticultural Society; recognised arboreta and botanical gardens; other established horticultural authorities.

            Bonsai-specific information — established bonsai educational sources; recognised professional practitioners; long-standing bonsai organisations and educational publications.

            Bonsai World synthesises verified information into its own terminology and operational model. The visible profile remains readable and is not an academic bibliography. Do not copy external source wording.
            """
        )
    }

    /// Quick Reference — Bonsai World operational assessments (not absolute scientific measurements).
    private static let traits = SpeciesProfileTraits(
        deciduous: true,
        growthStrength: "Strong",
        growthSpeed: "Fast",
        leafSize: "Small to medium, reducible through cultivation",
        foliageReduction: "Good potential through cultivation — not guaranteed",
        ramificationPotential: "High potential",
        backBudding: "Strong potential",
        rootDevelopment: "Strong",
        nebariPotential: "Excellent development potential",
        trunkDevelopment: "Fast potential under strong cultivation",
        barkDevelopment: "Increasingly textured and attractive with age",
        wiring: "Suitable — monitor closely during active growth",
        defoliation: "Suitable for healthy, established trees",
        airLayering: "Suitable",
        threadGrafting: "Suitable",
        rootGrafting: "Suitable",
        beginnerSuitability: "High",
        bonsaiSuitability: "Excellent",
        difficulty: "Beginner to Advanced",
        winterDormancyRequired: true,
        winterHardiness: "High",
        rootFrostSensitivity: "Moderate to High in shallow containers"
    )

    private static var sections: [SpeciesProfileSection] {
        [
            SpeciesProfileSection(
                id: "overview",
                title: "Species Overview",
                paragraphs: [
                    "Acer buergerianum Miq., commonly known as Trident Maple (also Three-toothed Maple), is a deciduous maple in the Sapindaceae family.",
                    "It is characterised by predominantly three-lobed leaves and is capable of strong growth when healthy and appropriately cultivated.",
                    "The species is valued for bonsai because of its generally strong response to pruning and structural development, its capacity to develop strong root systems, and its potential for attractive trunk bases and mature bark.",
                    "It can support both development and refinement when managed according to the individual tree.",
                    "Strong root development, nebari potential, back-budding and leaf reduction are important species tendencies — not guarantees for every specimen.",
                ],
                bullets: [
                    "Deciduous maple (Sapindaceae)",
                    "Predominantly three-lobed leaves",
                    "Capable of strong growth",
                    "Generally strong response to pruning and structural work",
                    "Strong root-development potential",
                    "Attractive trunk-base (nebari) development potential",
                    "Useful for both development and refinement",
                    "Individual outcomes always depend on tree condition and cultivation",
                ]
            ),
            SpeciesProfileSection(
                id: "natural-growth",
                title: "Natural Growth",
                paragraphs: [
                    "Acer buergerianum is capable of vigorous growth, particularly when young and when supplied with adequate growing space, water, light and nutrition.",
                    "During development, this vigor can be deliberately used for trunk thickening, primary branch development, sacrifice branches, root development and structural rebuilding.",
                    "During refinement, the same vigor requires control so that extension growth does not compromise proportion, ramification and silhouette.",
                    "Development: allow selected areas to grow where additional thickness and structural development are required.",
                    "Refinement: control extension growth where finer ramification and proportion are required.",
                    "Grow where thickness is needed. Control where refinement is required.",
                ]
            ),
            SpeciesProfileSection(
                id: "leaves",
                title: "Leaves",
                paragraphs: [
                    "Leaves are usually three-lobed, with the central lobe generally more prominent.",
                    "Young foliage may show bronze or reddish tones. Summer foliage generally becomes deeper green.",
                    "Attractive autumn colour may include yellow, orange and red tones; colour expression varies between individual trees and seasons.",
                    "Leaf size can often be reduced through balanced cultivation and refinement. Influencing factors include tree vigor, ramification, shoot management, root development, container size, available resources, pruning and — where appropriate — defoliation.",
                    "Leaf reduction is not a guaranteed single technique. It is a consequence of balanced cultivation and refinement.",
                ]
            ),
            SpeciesProfileSection(
                id: "flowers-seeds",
                title: "Flowers & Seeds",
                paragraphs: [
                    "Acer buergerianum produces small yellow-green flowers in spring, appearing before or around leaf emergence.",
                    "Flowering is followed by winged fruits as part of the natural reproductive cycle.",
                    "Flowers and seeds are normally not the primary reason for growing Acer buergerianum as bonsai.",
                ]
            ),
            SpeciesProfileSection(
                id: "bark-trunk",
                title: "Bark & Trunk",
                paragraphs: [
                    "Young trees generally have relatively smooth bark.",
                    "Mature trees often develop increasingly textured and attractive bark, which can show flaking red-brown and orange-toned characteristics.",
                    "Trunk development is a major strength of the species. Strong extension growth can often be used deliberately to increase trunk diameter, develop trunk movement, support sacrifice-branch strategies and build primary structure.",
                    "Once the desired trunk structure is established, management priorities should shift toward branch structure, ramification, proportion, silhouette and fine growth.",
                ]
            ),
            SpeciesProfileSection(
                id: "roots-nebari",
                title: "Roots & Nebari",
                paragraphs: [
                    "Acer buergerianum has strong root development potential and can be highly responsive to intentional root management.",
                    "Its potential for developing an attractive radial root base is one of the major reasons it is valued for bonsai. Excellent nebari is not automatic.",
                    "Nebari development depends on early intervention, root selection, root positioning, root pruning, growing space, development strategy, tree health and repeated management over time.",
                    "Possible techniques — not requirements — include root pruning, radial root positioning, controlled container development, root grafting and root-over-rock development.",
                    "The objective is a stable and visually convincing radial root structure rather than simply a large quantity of roots.",
                ]
            ),
            SpeciesProfileSection(
                id: "light",
                title: "Light",
                paragraphs: [
                    "A healthy and established Acer buergerianum generally performs well in strong light and can tolerate substantial sun exposure.",
                    "Light requirements must be evaluated together with temperature, wind, root condition, water availability, container size, recent repotting and tree health.",
                    "A healthy, established tree may tolerate stronger conditions than a recently repotted tree, a weak tree, a tree with reduced roots, a newly collected tree, a tree in a shallow container, or a tree exposed to drying wind.",
                    "Species information is guidance. Observe the individual tree.",
                ]
            ),
            SpeciesProfileSection(
                id: "wind",
                title: "Wind",
                paragraphs: [
                    "Wind can increase transpiration, increase water demand, accelerate drying and raise stress in shallow containers.",
                    "Particular attention should be given to newly emerging foliage, recently repotted trees, trees with reduced root systems, shallow containers, hot weather and strong drying winds.",
                    "Acer buergerianum is not described here as universally wind-sensitive. The operational concern is increased water demand and drying risk.",
                ]
            ),
            SpeciesProfileSection(
                id: "watering",
                title: "Watering",
                paragraphs: [
                    "Acer buergerianum can have relatively high water demand during active growth, particularly under strong growing conditions.",
                    "Do not water according to a fixed timetable. Water according to the condition of the tree, substrate, weather, temperature, wind, root mass, container size, development stage and growth activity.",
                    "Maintain appropriate moisture and aeration. Avoid both chronic waterlogging and prolonged unnecessary drying during active growth.",
                    "Water according to the condition of the tree and substrate, not simply according to the clock.",
                ]
            ),
            SpeciesProfileSection(
                id: "soil",
                title: "Soil",
                paragraphs: [
                    "Desired substrate characteristics generally include good drainage, good aeration, appropriate water retention, stable particle structure and suitability for the individual growing environment.",
                    "The soil decision must depend on climate, watering habits, container, tree development stage, root density and local conditions.",
                    "Bonsai World does not prescribe one universal soil recipe for this species.",
                ]
            ),
            SpeciesProfileSection(
                id: "fertilizing",
                title: "Fertilizing",
                paragraphs: [
                    "Acer buergerianum is capable of making strong use of nutrients during active development.",
                    "Fertilization must depend on tree health, development stage, current growth, season, root condition, recent work and the desired development outcome.",
                    "Development trees may generally support stronger nutrition than refined trees. Refinement should avoid unnecessarily coarse growth.",
                    "Weak or recently disturbed trees should not automatically receive stronger fertilizer simply because Acer buergerianum is a vigorous species.",
                    "Feed the tree you are growing, not simply the species you have.",
                ]
            ),
            SpeciesProfileSection(
                id: "pruning",
                title: "Pruning",
                paragraphs: [
                    "Pruning is one of the major bonsai strengths of Acer buergerianum.",
                    "Development pruning: allow selected shoots to extend where trunk thickness, branch thickness or structural rebuilding is required. Reduce growth once the required thickness or structural objective has been achieved.",
                    "Refinement pruning: use controlled pruning to maintain silhouette, improve ramification, control branch thickness, improve light penetration, maintain branch hierarchy and control excessive extension.",
                    "The apex and upper branches may dominate if vigorous growth is not managed.",
                    "Specific pruning methods should remain adaptable to tree stage, branch position, desired thickness and tree vigor. Avoid fixed leaf-pair rules as universal instructions.",
                ]
            ),
            SpeciesProfileSection(
                id: "back-budding",
                title: "Back-Budding",
                paragraphs: [
                    "Acer buergerianum has strong back-budding potential and can often respond well to structural rebuilding.",
                    "This makes the species valuable for branch reconstruction, structural correction, ramification development and rebuilding selected areas.",
                    "Back-budding must never be treated as guaranteed. The result depends on tree health, season, branch condition, available vigor, light, previous pruning and root condition.",
                ]
            ),
            SpeciesProfileSection(
                id: "ramification",
                title: "Ramification",
                paragraphs: [
                    "Ramification potential is high. Acer buergerianum can develop dense branching when vigor is managed and repeated structural and refinement pruning is used appropriately.",
                    "The primary challenge is not simply generating new shoots. The challenge is controlling vigor so that fine branches do not become coarse faster than desired.",
                    "Development: allow selected extension where thickness is required. Refinement: control extension after the desired branch structure has been established.",
                ]
            ),
            SpeciesProfileSection(
                id: "wiring",
                title: "Wiring",
                paragraphs: [
                    "Branches can be wired successfully. Suitable — monitor closely.",
                    "Strong growth and branch thickening mean wires must be monitored regularly. Wire marks can develop quickly during active growth.",
                    "The Species Profile may identify a potential follow-up requirement. Individual Tree Care must determine whether a reminder is actually appropriate. This section alone does not generate automatic care tasks.",
                ]
            ),
            SpeciesProfileSection(
                id: "defoliation",
                title: "Defoliation",
                paragraphs: [
                    "Defoliation can be used as a refinement technique on healthy, well-established Acer buergerianum.",
                    "Possible objectives include leaf size management, encouraging additional branching, improving ramification and balancing overly strong areas.",
                    "Defoliation is not an automatic annual procedure, not a beginner default action, and not appropriate for every healthy-looking tree.",
                    "The decision depends on tree health, root condition, development stage, current vigor, season, previous work and desired development.",
                    "Weak, recovering or recently disturbed trees should not be treated in the same way as strong established trees.",
                ]
            ),
            SpeciesProfileSection(
                id: "repotting",
                title: "Repotting",
                paragraphs: [
                    "Repotting frequency should depend on root development, container size, substrate condition, tree health, development stage and climate. Avoid a fixed calendar rule.",
                    "A development tree may require different root management from a refined tree.",
                    "Acer buergerianum can respond well to root work when healthy and managed under appropriate conditions. Tolerance for root work does not mean unlimited tolerance.",
                    "Use species timing as guidance rather than an absolute operational rule. The individual tree and root system determine whether repotting is appropriate.",
                ]
            ),
            SpeciesProfileSection(
                id: "trunk-development",
                title: "Trunk Development",
                paragraphs: [
                    "Trunk development is a major strength of Acer buergerianum.",
                    "Possible approaches — not equally appropriate for every tree — include sacrifice branches, controlled extension, field or ground development where appropriate, larger development containers and strategic trunk cuts.",
                    "Grow where thickness is needed. Control where refinement is required.",
                ]
            ),
            SpeciesProfileSection(
                id: "nebari-development",
                title: "Nebari Development",
                paragraphs: [
                    "Nebari development is one of the strongest bonsai development areas for this species.",
                    "Potential techniques may include root pruning, root selection, radial root positioning, root grafting, controlled container development and root-over-rock development.",
                    "The objective is a convincing and stable radial root structure. Do not apply every technique by default. The chosen method must depend on the existing material and design goal.",
                ]
            ),
            SpeciesProfileSection(
                id: "grafting",
                title: "Grafting",
                paragraphs: [
                    "Relevant techniques include approach grafting, thread grafting and root grafting.",
                    "Common bonsai use cases include introducing a branch where an important branch is missing, improving root structure and correcting structural limitations.",
                    "Grafting should be considered when the existing structure cannot reasonably provide the desired design outcome. Where possible, natural development and back-budding potential should also be considered before selecting grafting.",
                    "All grafting work performed on an individual tree should be documented in Shaping History.",
                ]
            ),
            SpeciesProfileSection(
                id: "air-layering",
                title: "Air Layering",
                paragraphs: [
                    "Acer buergerianum can be propagated through air layering.",
                    "Air layering may be useful when a desirable section of a parent tree can become independent material, when existing material needs to be separated, or when a branch contains valuable trunk or branch characteristics.",
                    "Success depends on timing, technique, tree health and aftercare.",
                    "Detailed procedures belong in Propagation Knowledge Articles. The Species Profile should link to those procedures rather than duplicate full instructions.",
                ]
            ),
            SpeciesProfileSection(
                id: "propagation",
                title: "Propagation",
                paragraphs: [
                    "Potential propagation methods may include seed, cuttings, air layering and grafting.",
                    "Detailed propagation procedures should remain in dedicated Knowledge Articles. The Species Profile provides compatibility and overview — not a complete propagation manual.",
                ]
            ),
            SpeciesProfileSection(
                id: "pests",
                title: "Pests & Problems",
                paragraphs: [
                    "Potential issues may include aphids, scale insects, mites, caterpillars, leaf scorch, fungal leaf problems, root problems associated with unsuitable moisture conditions and Verticillium wilt.",
                    "This is not a diagnostic list. The Species Profile only identifies relevant potential problems.",
                    "Diagnosis and treatment belong in Care → Pest & Problem Management. Prefer one knowledge article per problem where appropriate.",
                ]
            ),
            SpeciesProfileSection(
                id: "seasonal",
                title: "Seasonal Profile",
                paragraphs: [
                    "Spring: bud break, rapid new growth, increasing water demand, pruning decisions, wiring monitoring and fertilization decisions.",
                    "Summer: active growth, higher water demand, extension growth, ramification development, wiring checks and heat and drying management.",
                    "Autumn: reduced growth, autumn colour, gradual reduction in water demand and preparation for dormancy.",
                    "Winter: dormancy and protection of the root system during severe or prolonged freezing, with particular attention to shallow bonsai containers.",
                    "Do not use one universal temperature threshold for all trees. Winter protection depends on temperature, duration of freezing, wind, container, root condition, tree health and location.",
                ]
            ),
            SpeciesProfileSection(
                id: "styles",
                title: "Bonsai Styles",
                paragraphs: [
                    "Acer buergerianum is versatile. Suitable possibilities — as examples rather than requirements — may include informal upright, multiple trunk, twin trunk, root-over-rock, group planting, and small, medium or large bonsai.",
                    "The final style should be determined by existing material, trunk movement, root structure, branch placement and natural character.",
                    "Do not force every Acer buergerianum into the same style.",
                ]
            ),
            SpeciesProfileSection(
                id: "tree-stage",
                title: "Development by Tree Stage",
                paragraphs: [
                    "Seedling: establish roots, vigor and early trunk direction.",
                    "Cutting: establish roots and begin structural development.",
                    "Nursery stock: develop trunk, roots and primary branch structure.",
                    "Pre-bonsai: establish trunk line, primary branches, nebari and structural direction.",
                    "In training: develop branches and ramification while continuing trunk development where still required.",
                    "Refinement: prioritise fine ramification, silhouette, proportion and controlled growth.",
                    "Exhibition: maintain refined structure and presentation while avoiding unnecessary major intervention.",
                    "Tree stage changes management priorities. The same species should not be managed identically at every stage.",
                ]
            ),
            SpeciesProfileSection(
                id: "attention",
                title: "Species-Specific Attention",
                paragraphs: [
                    "These are operational tendencies rather than automatic warnings. They must still be interpreted for the individual tree.",
                ],
                bullets: [
                    "Strong growth — monitor excessive extension, apex dominance and rapid branch thickening",
                    "Strong root development — monitor root congestion, substrate condition and the need for root management",
                    "High ramification potential — use controlled pruning to prevent fine structure from becoming unnecessarily coarse",
                    "Wiring during active growth — monitor for wire marks",
                    "High water demand during active growth — monitor drying, particularly in shallow containers and during wind or heat",
                    "Winter dormancy — protect the root system appropriately during severe or prolonged freezing, particularly in shallow containers",
                ]
            ),
            SpeciesProfileSection(
                id: "cultivars",
                title: "Cultivars",
                paragraphs: [
                    "Named Acer buergerianum cultivars exist in horticulture and bonsai collections. Cultivars may differ in vigor, leaf size, leaf colour, growth habit, internode behaviour, sensitivity and development speed.",
                    "Do not automatically transfer all species-level care characteristics to every cultivar.",
                    "Detailed cultivar entries are not expanded here until each claim is supported by retained botanical or horticultural sources. Marked for further verification before Reviewed status.",
                ]
            ),
        ]
    }
}
