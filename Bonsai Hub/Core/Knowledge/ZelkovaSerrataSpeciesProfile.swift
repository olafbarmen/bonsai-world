//
//  ZelkovaSerrataSpeciesProfile.swift
//  Bonsai World
//
//  Species Profile — Zelkova serrata (Japanese Zelkova).
//  Independent botanical species in Ulmaceae. Knowledge status: Reviewed.
//

import Foundation

enum ZelkovaSerrataSpeciesProfile {
    /// Identity used by Botanical Library / ``SpeciesPreviewData``.
    static let botanicalLibraryName = "Zelkova serrata"
    /// Scientific name for Species Profile display (binomial; no botanical authority).
    static let scientificName = "Zelkova serrata"

    static var profile: SpeciesProfile {
        SpeciesProfile(
            speciesID: BotanicalKnowledgeIDs.zelkovaSerrata,
            scientificName: scientificName,
            commonNames: ["Japanese Zelkova"],
            family: "Ulmaceae",
            plantType: "Deciduous broadleaf tree",
            originSummary: "Temperate East Asia, including Japan, Korea, China and Taiwan.",
            knowledgeStatus: .reviewed,
            traits: traits,
            foliageSizeLabel: "Foliage",
            foliageReductionLabel: "Leaf reduction",
            summaryLine: "Deciduous · Fine branching · Serrated leaves · Smooth grey bark · Excellent ramification · Classic broom-style bonsai",
            attentionHighlights: [
                "One of the classic deciduous bonsai species",
                "Strong association with broom-style bonsai",
                "Excellent fine ramification potential",
                "Nebari is particularly important",
                "Do not confuse Zelkova with Chinese elm",
                "Strong growth should be used strategically during development",
                "Avoid premature refinement",
                "Avoid repeated pruning at exactly the same point",
                "Manage branch swelling carefully",
                "Selective defoliation may be possible on strong trees",
                "Strong outdoor light supports healthy development",
                "Avoid prolonged drought",
                "Avoid permanently wet substrate",
                "Protect shallow roots during severe winter conditions",
                "Do not move indoors for routine winter care",
            ],
            sections: sections,
            principleNote: """
            Zelkova serrata is one of the classic deciduous bonsai species of Japan.

            It is particularly associated with broom-style bonsai, fine ramification, dense branching, powerful nebari, smooth grey bark and an elegant winter silhouette.

            The species can develop an extremely refined branch structure. However, refinement should not be confused with constant pruning.

            A Zelkova that is continually restricted may lose the vigour required for branch development, wound healing, root health, ramification and long-term refinement.

            The objective is not simply to create the smallest possible leaves.

            The objective is: Healthy growth · Strong structure · Fine ramification · Convincing silhouette

            The individual tree must always be assessed according to health, root condition, development stage, trunk maturity, branch structure, recent work, climate, weather, container size and current vigour.
            """,
            sourcesNote: """
            Profile content is synthesised from recognised botanical, horticultural and bonsai authorities into Bonsai World editorial language.

            Botanical taxonomy and distribution draw on recognised sources such as Royal Botanic Gardens, Kew and other botanical databases for accepted scientific name, family and native range.

            Horticultural cultivation context may draw on the Royal Horticultural Society and recognised arboreta and horticultural institutions.

            Bonsai-specific cultivation and styling knowledge draws on established bonsai references and recognised Japanese bonsai institutional practice, including material associated with classic Keyaki / broom-style development.

            Verified botanical information, general horticultural cultivation and bonsai-specific practice are kept distinct. Do not copy source wording.
            """
        )
    }

    private static let traits = SpeciesProfileTraits(
        deciduous: true,
        growthStrength: "Strong to Moderate",
        growthSpeed: "Moderate to Fast",
        leafSize: "Deciduous · Simple serrated leaves · Good leaf reduction potential",
        foliageReduction: "Good potential — vigour and cultivation dependent",
        ramificationPotential: "Excellent",
        backBudding: "Good under healthy conditions",
        rootDevelopment: "Good",
        nebariPotential: "Excellent development potential",
        trunkDevelopment: "Moderate to Strong",
        barkDevelopment: "Attractive smooth grey bark",
        wiring: "Good",
        defoliation: "Possible selectively on strong, healthy trees",
        airLayering: "Where appropriate for the individual material",
        threadGrafting: "Where structural correction is required",
        rootGrafting: "Where appropriate",
        beginnerSuitability: "High",
        bonsaiSuitability: "Excellent",
        difficulty: "Beginner to Intermediate",
        winterDormancyRequired: true,
        winterHardiness: "Outdoor deciduous — climate dependent",
        rootFrostSensitivity: "Moderate in shallow bonsai containers"
    )

    private static var sections: [SpeciesProfileSection] {
        [
            SpeciesProfileSection(
                id: "taxonomic-context",
                title: "Taxonomic Context",
                paragraphs: [
                    "Zelkova serrata is an independent botanical species in the elm family (Ulmaceae).",
                    "Primary Bonsai World display identity: Zelkova serrata · Japanese Zelkova.",
                    "Japanese name: Keyaki. This is cultural naming and does not replace the primary common name Japanese Zelkova.",
                    "Family: Ulmaceae. Plant type: deciduous broadleaf tree.",
                    "Native range: temperate East Asia, including Japan, Korea, China and Taiwan.",
                    "Zelkova serrata belongs to the elm family but must not be confused with species commonly referred to as Chinese elm.",
                    "Maintain a clear distinction between Zelkova serrata, other Zelkova species, Ulmus species and Chinese elm material.",
                    "Do not merge species because of commercial naming or superficial similarity.",
                    "Bonsai World hierarchy: Species → cultivar / horticultural selection → Individual Tree.",
                ]
            ),
            SpeciesProfileSection(
                id: "overview",
                title: "Species Overview",
                paragraphs: [
                    "Zelkova serrata is a deciduous tree native to temperate East Asia.",
                    "It is highly valued as bonsai because of its naturally elegant growth habit, fine branching potential, serrated foliage, attractive bark, autumn colour and ability to develop convincing ramification.",
                    "In Japanese bonsai culture, Zelkova is particularly associated with the broom style.",
                    "A classic mature Zelkova bonsai may combine a powerful trunk base, strong radial nebari, a straight or slightly tapering trunk, a broad crown and extremely fine branch ramification.",
                    "However, Zelkova is not restricted to broom style. The individual material should determine the final design.",
                    "Important development principle: Grow where development is required. Control where refinement is required.",
                ],
                bullets: [
                    "Deciduous broadleaf tree",
                    "Member of the Ulmaceae family",
                    "Fine serrated leaves",
                    "Excellent ramification potential",
                    "Strong back-budding potential under healthy conditions",
                    "Excellent broom-style suitability",
                    "Attractive smooth grey bark",
                    "Good autumn colour",
                    "Strong nebari potential",
                    "Suitable for wiring",
                    "Requires outdoor cultivation",
                    "Requires winter dormancy",
                ]
            ),
            SpeciesProfileSection(
                id: "natural-growth",
                title: "Natural Growth and Vigour",
                paragraphs: [
                    "Zelkova serrata can produce strong seasonal growth.",
                    "Growth strength depends on root development, container size, substrate, light, fertilization, temperature, water availability, climate and development stage.",
                    "During development: allow selected shoots, leaders and branches to extend where trunk thickness is required, primary branches require development, sacrifice growth is useful or structural strength is needed.",
                    "Do not continually prune all new growth.",
                    "During refinement: control extension to maintain branch hierarchy, internode length, ramification, silhouette and balanced vigour.",
                    "The tree must have sufficient strength to support refinement.",
                ]
            ),
            SpeciesProfileSection(
                id: "foliage",
                title: "Foliage",
                paragraphs: [
                    "Zelkova serrata produces simple, sharply serrated deciduous leaves.",
                    "Healthy foliage should be well distributed, exposed to sufficient light and balanced across the canopy.",
                    "Leaf size can be influenced by bonsai cultivation and increasing ramification.",
                    "Do not promise a specific leaf size.",
                    "Leaf reduction depends on tree vigour, branch density, refinement, container cultivation, pruning strategy and growing conditions.",
                    "The objective is proportionate foliage that supports the overall design.",
                    "Do not pursue leaf reduction at the expense of tree health.",
                ]
            ),
            SpeciesProfileSection(
                id: "bark-trunk",
                title: "Bark and Trunk",
                paragraphs: [
                    "Zelkova serrata develops attractive smooth grey bark.",
                    "The bark is an important visual feature of mature bonsai.",
                    "Trunk development should focus on taper, movement where appropriate, proportion, trunk strength and the relationship between trunk and nebari.",
                    "Young material may require significant development before refinement begins.",
                    "Do not prematurely restrict useful growth.",
                    "Where trunk development is required: allow selected extension growth, use sacrifice branches where appropriate, provide sufficient root and growing space, and use staged pruning.",
                    "Once sufficient structural development has been achieved, shift gradually toward refinement.",
                ]
            ),
            SpeciesProfileSection(
                id: "roots-nebari",
                title: "Roots and Nebari",
                paragraphs: [
                    "Zelkova serrata has excellent potential for developing convincing nebari.",
                    "Nebari development should begin early.",
                    "Primary objectives include radial root distribution, strong visual stability, trunk integration, avoidance of dominant crossing roots and balanced root mass.",
                    "Potential approaches include early root selection, radial root positioning, development containers and staged root correction.",
                    "Do not remove large structural roots aggressively unless there is a clear reason.",
                    "Root development must remain balanced with the health of the tree.",
                ]
            ),
            SpeciesProfileSection(
                id: "light",
                title: "Light",
                paragraphs: [
                    "Zelkova serrata should be cultivated outdoors.",
                    "Strong light generally supports healthy foliage, balanced growth, compact internodes, ramification and autumn colour development.",
                    "Full sun is generally beneficial for healthy established trees.",
                    "However, light management must consider temperature, water availability, wind, container size, recent repotting and tree health.",
                    "During periods of extreme heat, shallow bonsai containers may dry rapidly.",
                    "Adjust placement according to the individual growing environment.",
                    "Do not recommend routine indoor cultivation.",
                ]
            ),
            SpeciesProfileSection(
                id: "wind",
                title: "Wind",
                paragraphs: [
                    "Air movement supports healthy outdoor cultivation.",
                    "However, excessive wind can increase water loss, leaf stress, drying of shallow substrates and winter desiccation.",
                    "Young trees and recently repotted trees may require greater protection.",
                    "Cold drying winds can be particularly stressful during winter.",
                    "The growing position must always be assessed in relation to climate, season, container depth and tree health.",
                ]
            ),
            SpeciesProfileSection(
                id: "watering",
                title: "Watering",
                paragraphs: [
                    "General principle: Even moisture when required · Good drainage · Never permanently saturated.",
                    "Watering frequency depends on weather, temperature, wind, sun exposure, container size, substrate structure, root mass, tree health, development stage and seasonal activity.",
                    "Zelkova can have significant water demand during active growth.",
                    "A shallow bonsai container may dry rapidly during warm and windy weather.",
                    "Do not water according to a fixed timetable.",
                    "Water according to the condition of the substrate and the individual tree.",
                    "Avoid both prolonged drought and permanently saturated substrate.",
                ]
            ),
            SpeciesProfileSection(
                id: "soil",
                title: "Soil",
                paragraphs: [
                    "Do not prescribe one universal soil recipe.",
                    "Desired characteristics include good drainage, good aeration, sufficient moisture retention, stable particle structure and healthy root development.",
                    "The final soil mix depends on local climate, rainfall, watering habits, container depth, tree size, development stage and root condition.",
                    "Follow Bonsai World Soil Module principles.",
                    "Do not duplicate the complete Soil Module inside this profile.",
                ]
            ),
            SpeciesProfileSection(
                id: "fertilizing",
                title: "Fertilizing",
                paragraphs: [
                    "Fertilization should support the current development objective.",
                    "During development: healthy trees requiring trunk or branch development may receive stronger nutritional support where appropriate.",
                    "During refinement: nutrition should maintain health, controlled growth and fine ramification.",
                    "Avoid creating unnecessarily coarse extension through excessive fertilization.",
                    "Fertilization depends on tree health, development stage, season, current growth, root condition and recent work.",
                    "Feed the tree you are growing, not simply the species name.",
                ]
            ),
            SpeciesProfileSection(
                id: "pruning",
                title: "Pruning",
                paragraphs: [
                    "Zelkova serrata responds well to structured pruning.",
                    "Pruning strategy must depend on the development stage.",
                    "During development: allow selected branches and shoots to extend where thickness is required. Do not shorten all shoots uniformly.",
                    "During refinement: use controlled pruning to maintain compact internodes, branch hierarchy, fine ramification, crown structure and balanced vigour.",
                    "Avoid creating repeated swelling at the same pruning point.",
                    "Long-term refinement requires attention to branch taper, branch thickness, internode structure and node swelling.",
                    "Do not repeatedly cut back to exactly the same point without considering long-term structure.",
                ]
            ),
            SpeciesProfileSection(
                id: "back-budding",
                title: "Back-budding",
                paragraphs: [
                    "Zelkova can produce useful new growth from older branches and trunk areas under healthy conditions.",
                    "However, back-budding depends on tree health, vigour, light, branch condition, pruning strategy and season.",
                    "Do not treat back-budding as guaranteed.",
                    "Use structural planning rather than relying on emergency back-budding.",
                ]
            ),
            SpeciesProfileSection(
                id: "ramification",
                title: "Ramification",
                paragraphs: [
                    "Zelkova serrata has excellent potential for fine ramification.",
                    "This is one of its defining bonsai characteristics.",
                    "Fine branching should be developed through healthy growth, repeated developmental cycles, controlled pruning, branch selection and balanced light distribution.",
                    "The objective is fine, proportionate ramification with a convincing winter silhouette.",
                    "The tree should not become an uncontrolled mass of branches.",
                    "Maintain branch hierarchy, taper, spacing, proportion and clarity of structure.",
                ]
            ),
            SpeciesProfileSection(
                id: "wiring",
                title: "Wiring",
                paragraphs: [
                    "Zelkova can be wired to establish branch direction, branch spacing, structural movement and crown development.",
                    "Wiring is particularly useful during structural development.",
                    "Fine mature ramification should increasingly be managed through pruning and selective positioning rather than unnecessary heavy wiring.",
                    "Monitor wire carefully.",
                    "Deciduous branches can thicken rapidly during active growth.",
                    "Remove or adjust wire before significant marking occurs.",
                    "Before strong bends, assess branch age, thickness, flexibility, health and development value.",
                    "Do not force branches beyond their natural capacity.",
                ]
            ),
            SpeciesProfileSection(
                id: "defoliation",
                title: "Defoliation",
                paragraphs: [
                    "Do not present complete defoliation as routine care.",
                    "Selective defoliation or leaf reduction techniques may be used on suitable healthy trees where refinement objectives justify the work.",
                    "Potential objectives include improving light penetration, encouraging secondary growth, improving proportion and managing leaf size.",
                    "Do not use defoliation on weak trees, recently repotted trees, stressed trees or trees requiring recovery.",
                    "The individual tree must have sufficient vigour before leaf reduction techniques are considered.",
                ]
            ),
            SpeciesProfileSection(
                id: "repotting",
                title: "Repotting",
                paragraphs: [
                    "Repotting frequency depends on root development, substrate condition, drainage, container size, tree health and development stage.",
                    "Do not establish a rigid calendar rule.",
                    "Root work should be stronger during development than during refinement only where the individual tree can support it.",
                    "Avoid combining excessive root reduction with multiple other major stresses.",
                    "Recovery must be based on the individual tree and growing conditions.",
                ]
            ),
            SpeciesProfileSection(
                id: "trunk-development",
                title: "Trunk Development",
                paragraphs: [
                    "Zelkova serrata can develop convincing trunks when given sufficient time and growing space.",
                    "Where trunk development is still required: allow selected leaders to extend, use sacrifice branches where appropriate, avoid premature refinement, provide sufficient root space and manage growth strategically.",
                    "Do not maintain a permanently compact silhouette when trunk thickness remains insufficient.",
                    "Once sufficient trunk development has been achieved, shift focus toward taper, primary branch structure, secondary branching, ramification and crown refinement.",
                    "Grow where development is required. Control where refinement is required.",
                ]
            ),
            SpeciesProfileSection(
                id: "nebari-development",
                title: "Nebari Development",
                paragraphs: [
                    "Nebari is particularly important in Zelkova bonsai.",
                    "A convincing mature tree often depends heavily on a stable and well-developed root base.",
                    "Development objectives include radial root distribution, visible surface roots where appropriate, visual stability and a strong connection between trunk and soil.",
                    "Nebari development should be considered early rather than treated as a late-stage correction.",
                ]
            ),
            SpeciesProfileSection(
                id: "propagation",
                title: "Propagation",
                paragraphs: [
                    "Zelkova serrata may be propagated through seed, cuttings from suitable material and other appropriate propagation methods.",
                    "Seed-grown material can provide useful genetic variation and natural trunk development.",
                    "Vegetative propagation may be useful when preserving specific horticultural characteristics.",
                    "Detailed propagation procedures belong in Bonsai World Propagation Knowledge Articles.",
                ]
            ),
            SpeciesProfileSection(
                id: "pests",
                title: "Pests and Problems",
                paragraphs: [
                    "Relevant risks may include aphids, scale insects, mites, foliage-feeding insects, fungal leaf problems, root problems caused by excessive moisture, environmental leaf scorch, drought stress and winter damage to shallow roots.",
                    "Potential disease risks may vary by region.",
                    "Do not provide generic treatment instructions.",
                    "Diagnosis and treatment belong in Care → Pest Management and Care → Disease & Problems.",
                ]
            ),
            SpeciesProfileSection(
                id: "seasonal",
                title: "Seasonal Profile",
                paragraphs: [
                    "Spring: monitor bud development, new growth, watering demand, branch extension and pest activity. Spring is an important period for structural growth, branch development and seasonal pruning decisions. Protect vulnerable new growth from damaging late frost where necessary.",
                    "Summer: monitor water demand, heat stress, leaf condition, shoot extension, wire marks and pest activity. Strong growth may be used strategically during development. During refinement, control excessive extension selectively. Avoid unnecessary heavy work during periods of significant heat or drought stress.",
                    "Autumn: monitor foliage health, autumn colour, branch structure, wire condition and winter preparation. As leaves fall, the branch structure becomes visible. This is an important period for evaluating branch hierarchy, taper, ramification and structural weaknesses.",
                    "Winter: Zelkova serrata is a deciduous outdoor bonsai. Winter dormancy is required. The bare branch structure can be evaluated clearly during winter.",
                    "Potential winter concerns include prolonged severe freezing, repeated freeze-thaw cycles, cold drying wind and shallow root exposure.",
                    "The root system of bonsai trees can be more vulnerable than the roots of trees growing in open ground.",
                    "Winter protection must depend on local climate, minimum temperatures, duration of freezing, wind exposure, container depth and tree health.",
                    "Do not move the tree indoors for routine winter care.",
                ]
            ),
            SpeciesProfileSection(
                id: "styles",
                title: "Bonsai Styles",
                paragraphs: [
                    "Zelkova serrata is particularly famous for Broom Style.",
                    "Other suitable styles may include Informal Upright, Slanting, naturalistic upright forms and clump forms where appropriate.",
                    "Broom Style is one of the most characteristic traditional expressions for mature Zelkova bonsai.",
                    "A classic broom-style structure should aim for a convincing trunk, stable nebari, an organised radial branch structure, progressive ramification and a balanced crown.",
                    "Do not force every Zelkova into broom style. The individual material must determine the final design.",
                ]
            ),
            SpeciesProfileSection(
                id: "tree-stage",
                title: "Development by Tree Stage",
                paragraphs: [
                    "Young material: establish healthy roots, build vigour, develop trunk direction and preserve structural options.",
                    "Nursery material: evaluate trunk potential, identify root structure, select useful branches and establish a design direction.",
                    "Pre-bonsai: develop trunk, establish primary branches, improve nebari and begin structural branch selection.",
                    "In training: develop secondary branches, improve branch hierarchy, build ramification and refine crown structure.",
                    "Refinement: maintain fine ramification, control internode length, maintain branch taper, improve winter silhouette and maintain balanced foliage distribution.",
                    "Exhibition / mature refined tree: maintain health, preserve established structure, maintain fine ramification, preserve bark and nebari quality and avoid unnecessary major intervention.",
                ]
            ),
            SpeciesProfileSection(
                id: "attention",
                title: "Species-Specific Attention",
                paragraphs: [
                    "These attention points are operational tendencies. They must still be interpreted for the individual tree.",
                ],
                bullets: [
                    "One of the classic deciduous bonsai species",
                    "Strong association with broom-style bonsai",
                    "Excellent fine ramification potential",
                    "Nebari is particularly important",
                    "Do not confuse Zelkova with Chinese elm",
                    "Strong growth should be used strategically during development",
                    "Avoid premature refinement",
                    "Avoid repeated pruning at exactly the same point",
                    "Manage branch swelling carefully",
                    "Selective defoliation may be possible on strong trees",
                    "Strong outdoor light supports healthy development",
                    "Avoid prolonged drought",
                    "Avoid permanently wet substrate",
                    "Protect shallow roots during severe winter conditions",
                    "Do not move indoors for routine winter care",
                ]
            ),
        ]
    }
}
