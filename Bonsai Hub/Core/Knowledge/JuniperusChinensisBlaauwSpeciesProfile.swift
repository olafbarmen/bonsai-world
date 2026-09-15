//
//  JuniperusChinensisBlaauwSpeciesProfile.swift
//  Bonsai World
//
//  Species Profile — Juniperus chinensis 'Blaauw' (Blaauw Juniper).
//  Independent Bonsai World profile for a cultivar / horticultural selection of
//  Juniperus chinensis. Knowledge status: Reviewed (complete editorial content).
//

import Foundation

enum JuniperusChinensisBlaauwSpeciesProfile {
    static let parentSpeciesName = "Juniperus chinensis"
    static let cultivarName = "Blaauw"
    /// Scientific name for Species Profile display.
    static let scientificName = "Juniperus chinensis 'Blaauw'"

    static var profile: SpeciesProfile {
        SpeciesProfile(
            speciesID: BotanicalKnowledgeIDs.juniperusChinensis,
            cultivarID: BotanicalKnowledgeIDs.juniperusChinensisBlaauw,
            scientificName: scientificName,
            commonNames: ["Blaauw Juniper"],
            synonyms: [
                "Juniperus × media 'Blaauw'",
                "Juniperus x media 'Blaauw'",
                "Juniperus media 'Blaauw'",
            ],
            family: "Cupressaceae",
            plantType: "Evergreen conifer",
            originSummary: "Cultivated horticultural selection associated with Juniperus chinensis",
            knowledgeStatus: .reviewed,
            traits: traits,
            foliageSizeLabel: "Foliage",
            foliageReductionLabel: "Foliage management",
            summaryLine: "Evergreen · Blue-grey foliage · Ascending branches · Vigorous growth · Strong structural potential",
            attentionHighlights: [
                "Use the naturally ascending branch structure as a design advantage",
                "Preserve healthy foliage on branches intended to remain viable",
                "Do not assume reliable budding from completely bare old wood",
                "Avoid permanently wet substrate",
                "Strong light supports healthy growth and foliage quality",
                "Monitor wire carefully on actively thickening branches",
                "Use extension growth strategically during development",
                "Do not use deciduous defoliation techniques",
                "Avoid excessive foliage congestion",
                "Protect shallow root systems during severe winter conditions",
                "Do not move the tree indoors as routine winter care",
            ],
            sections: sections,
            principleNote: """
            Juniperus chinensis 'Blaauw' is a vigorous evergreen conifer with a distinctive upright and ascending branch structure.

            Its blue-grey foliage and architectural growth habit can make it particularly interesting as bonsai material.

            However, species and cultivar information must never be interpreted as a fixed care calendar.

            The individual tree must always be assessed according to health, root condition, development stage, foliage density, recent work, climate, weather, container size and current vigour.

            A healthy development-stage tree may require very different management from a refined, recently repotted, weak or recovering tree.

            The profile provides tendencies and decision support. It does not automatically determine what must be done to every individual tree.
            """,
            sourcesNote: """
            Profile content is synthesised from recognised botanical and horticultural authorities into Bonsai World editorial language.

            Horticultural cultivar identity and naming may draw on the Royal Horticultural Society and recognised botanical databases. Parent-species context may draw on Royal Botanic Gardens, Kew. Bonsai-specific management draws on established bonsai references, applied to this cultivar rather than copied from other Chinese Juniper selections.

            Where historical synonyms or alternative placements (for example under Juniperus × media) appear in older references, Bonsai World retains Juniperus chinensis 'Blaauw' as the primary display identity and resolves those synonyms to this single profile. Do not copy source wording. Do not create duplicate Species Profiles for alternative names.
            """
        )
    }

    private static let traits = SpeciesProfileTraits(
        deciduous: false,
        growthStrength: "Moderate to Strong",
        growthSpeed: "Moderate",
        leafSize: "Evergreen · Mainly scale-like · Blue-grey",
        foliageReduction: "Preserve viable foliage — manage density carefully",
        ramificationPotential: "Good",
        backBudding: "Moderate — foliage must be retained",
        rootDevelopment: "Good",
        nebariPotential: "Good development potential",
        trunkDevelopment: "Moderate",
        barkDevelopment: "Increasing character with age and development",
        wiring: "Suitable — monitor carefully",
        defoliation: "Not suitable as a deciduous-style technique",
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
                    "Juniperus chinensis 'Blaauw' is a named horticultural cultivar associated with Juniperus chinensis.",
                    "Profile type: Cultivar / Horticultural Selection. It is not a separate botanical species.",
                    "Parent species: Juniperus chinensis (Chinese Juniper), family Cupressaceae.",
                    "Primary Bonsai World display identity: Juniperus chinensis 'Blaauw' · Blaauw Juniper.",
                    "Older and alternative horticultural references may place 'Blaauw' under related hybrid names such as Juniperus × media. Those names are retained as synonyms for search and resolve to this single Species Profile. Do not create duplicate profiles.",
                    "Do not assume that care information for Itoigawa, Kishu, Shimpaku or other Chinese Juniper selections applies identically to Blaauw.",
                ]
            ),
            SpeciesProfileSection(
                id: "overview",
                title: "Species Overview",
                paragraphs: [
                    "Juniperus chinensis 'Blaauw' is a distinctive blue-grey Chinese Juniper cultivar with strongly ascending branches and a naturally architectural growth habit.",
                    "The foliage is primarily scale-like and develops in broad, plume-like sprays.",
                    "As bonsai material, Blaauw can provide useful structural characteristics that differ from the very compact foliage selections commonly associated with Shimpaku or Itoigawa material.",
                    "Its growth habit can support a range of designs, particularly where strong branch movement, open structure and architectural character are desirable.",
                    "Blaauw should not be forced into an artificial imitation of compact Shimpaku-style foliage pads. The natural characteristics of the cultivar should be used as part of the design.",
                ],
                bullets: [
                    "Evergreen conifer",
                    "Blue-grey foliage",
                    "Mainly scale-like foliage",
                    "Strongly ascending branches",
                    "Architectural growth habit",
                    "Moderate to strong vigour",
                    "Good structural wiring potential",
                    "Good development potential",
                    "Foliage must be retained on branches intended to remain viable",
                    "Requires strong outdoor light",
                    "Requires winter dormancy",
                    "Performs best in a well-drained root environment",
                ]
            ),
            SpeciesProfileSection(
                id: "natural-growth",
                title: "Natural Growth and Vigour",
                paragraphs: [
                    "Blaauw generally develops with a distinctive upright and ascending branch structure.",
                    "The cultivar has moderate to strong growth when healthy and properly cultivated.",
                    "Vigour depends on root development, substrate, container size, light, fertilization, temperature, water availability, climate and development stage.",
                    "During development: allow selected areas to extend where increased thickness is required. Use vigorous growth strategically. Do not repeatedly prune every shoot simply to maintain a compact silhouette.",
                    "During refinement: control extension more carefully, maintain branch hierarchy and foliage distribution, and avoid allowing one area — particularly the apex — to permanently dominate the rest of the tree.",
                ]
            ),
            SpeciesProfileSection(
                id: "foliage",
                title: "Foliage",
                paragraphs: [
                    "Blaauw is primarily characterised by blue-grey, mainly scale-like foliage arranged in broad plume-like sprays. The foliage is an important part of the cultivar's visual identity.",
                    "Colour and density may vary depending on light, season, health, nutrition, growth strength and environmental conditions.",
                    "Healthy foliage should be preserved. Do not treat juniper foliage as though it can always regenerate after complete removal.",
                    "Branches intended to survive should retain healthy foliage.",
                    "Pruning and foliage management should maintain branch viability, interior light, air movement, healthy foliage distribution and future growing points.",
                    "Do not recommend indiscriminate stripping of interior foliage. Do not treat the foliage like a hedge.",
                    "The objective is functional and healthy foliage distribution, not maximum density.",
                ]
            ),
            SpeciesProfileSection(
                id: "bark-trunk",
                title: "Bark and Trunk",
                paragraphs: [
                    "Young Blaauw material may initially have relatively uniform nursery characteristics. With age and development, trunk movement, bark character and branch structure become increasingly important.",
                    "The naturally ascending branch habit can be useful for informal upright bonsai, upright architectural compositions, slanting forms where material allows, naturalistic conifer designs and compositions with strong branch movement.",
                    "Do not state that every Blaauw tree must become an upright bonsai. The existing trunk and branch structure must influence the final design.",
                    "Grow where thickness is required. Control where refinement is required.",
                ]
            ),
            SpeciesProfileSection(
                id: "roots-nebari",
                title: "Roots and Nebari",
                paragraphs: [
                    "Healthy root development is essential to long-term bonsai success.",
                    "Consider radial root development, early root selection, avoiding severe root congestion, appropriate substrate, container development and gradual correction of unsuitable roots.",
                    "Good nebari can be developed through early root management, long-term cultivation and appropriate root selection. Do not promise exceptional nebari automatically.",
                    "A healthy root system supports foliage density, vigour, recovery and structural development.",
                ]
            ),
            SpeciesProfileSection(
                id: "light",
                title: "Light",
                paragraphs: [
                    "Juniperus chinensis 'Blaauw' should generally be cultivated outdoors with strong light.",
                    "Healthy, established trees benefit from substantial light exposure. Strong light can support healthy foliage, compact growth, balanced vigour, foliage colour and interior strength.",
                    "Light management must always consider temperature, wind, root condition, recent repotting, water availability, container size and tree health.",
                    "A recently repotted or weakened tree should not automatically be managed in the same way as a vigorous, established tree.",
                ]
            ),
            SpeciesProfileSection(
                id: "wind",
                title: "Wind",
                paragraphs: [
                    "Wind can provide useful airflow but can also increase water demand.",
                    "Benefits may include improved air movement, faster foliage drying and reduced stagnant conditions.",
                    "Risks include increased transpiration, faster rootball drying, winter desiccation, stress after repotting and increased water demand in shallow containers.",
                    "Strong wind and strong sun together can significantly increase monitoring requirements.",
                ]
            ),
            SpeciesProfileSection(
                id: "watering",
                title: "Watering",
                paragraphs: [
                    "Juniperus chinensis 'Blaauw' requires a balanced approach to watering.",
                    "General principle: moist when required, well drained, never permanently saturated.",
                    "Watering frequency must depend on weather, temperature, wind, sun exposure, container size, substrate particle size, root mass, tree health, development stage and seasonal activity.",
                    "Do not water according to a fixed timetable. Water according to the condition of the substrate and tree.",
                    "Established garden junipers may tolerate drought differently from bonsai growing in shallow containers. A bonsai root system can dry rapidly.",
                    "At the same time, permanently saturated conditions can damage root health.",
                ]
            ),
            SpeciesProfileSection(
                id: "soil",
                title: "Soil",
                paragraphs: [
                    "Do not prescribe one universal soil recipe.",
                    "Desired characteristics include excellent drainage, strong aeration, stable particle structure, appropriate moisture retention and long-term root health.",
                    "The final soil mix must depend on local climate, rainfall, watering habits, pot depth, tree size, development stage and root condition.",
                    "Follow Bonsai World Soil Module principles. Do not duplicate the Soil Module here.",
                ]
            ),
            SpeciesProfileSection(
                id: "fertilizing",
                title: "Fertilizing",
                paragraphs: [
                    "Fertilization should support the current objective of the individual tree.",
                    "During development, healthy trees being developed for trunk or branch thickness may receive stronger nutritional support where increased growth is desirable.",
                    "During refinement, nutrition should support health while avoiding unnecessary coarse or unbalanced growth.",
                    "Fertilization must depend on tree health, development stage, season, current growth, root condition and recent repotting.",
                    "Do not fertilize a weak or severely stressed tree simply because Blaauw can grow vigorously.",
                    "Feed the tree you are growing, not simply the cultivar name.",
                ]
            ),
            SpeciesProfileSection(
                id: "pruning",
                title: "Pruning",
                paragraphs: [
                    "Junipers do not behave like deciduous trees. Do not assume that a completely bare branch will reliably regenerate.",
                    "Healthy foliage should remain on branches intended to remain viable.",
                    "During development: allow selected shoots and branches to extend where thickness is required. Use growth to develop trunk thickness, primary branches and secondary structure.",
                    "During refinement: control excessive extension, maintain branch hierarchy and foliage distribution, preserve interior growth where possible, and reduce congestion gradually.",
                    "Avoid removing excessive foliage from weak trees.",
                    "The objective is to maintain branch viability, light penetration, future design options, balanced vigour and clear structure.",
                    "Do not recommend aggressive stripping as routine maintenance.",
                ]
            ),
            SpeciesProfileSection(
                id: "back-budding",
                title: "Back-budding",
                paragraphs: [
                    "New growth may develop under favourable conditions, but back-budding should not be treated as guaranteed.",
                    "Do not promise new growth from completely bare old wood.",
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
                    "The challenge is maintaining compact structure without causing interior weakening, excessive shading, long bare sections or uncontrolled outer growth.",
                    "Do not describe maximum foliage density as the goal. Healthy functional ramification is the goal.",
                ]
            ),
            SpeciesProfileSection(
                id: "wiring",
                title: "Wiring",
                paragraphs: [
                    "Juniperus chinensis 'Blaauw' is suitable for structural wiring.",
                    "Wiring can be used to position primary branches, improve branch spacing, establish hierarchy, create movement, reduce a uniform nursery appearance and support a natural bonsai composition.",
                    "Monitor wire carefully. Growing branches can thicken and wire marks may become permanent.",
                    "Before applying strong bends, assess branch thickness, flexibility, age, health, existing stress and intended movement.",
                    "Do not automatically recommend aggressive bending. Use controlled movement appropriate to the individual branch.",
                ]
            ),
            SpeciesProfileSection(
                id: "defoliation",
                title: "Defoliation",
                paragraphs: [
                    "Defoliation is not suitable as a deciduous-style technique.",
                    "Juniper foliage should not be managed using deciduous defoliation principles.",
                    "Foliage management should instead focus on selective pruning, shoot control, density management, removal of unhealthy or unwanted growth and preservation of viable foliage.",
                    "Never present complete defoliation as a standard technique.",
                ]
            ),
            SpeciesProfileSection(
                id: "repotting",
                title: "Repotting",
                paragraphs: [
                    "Repotting frequency must depend on root development, substrate condition, drainage, container size, tree health and development stage.",
                    "Do not establish a rigid calendar rule.",
                    "A development tree may require different root management from a mature refined tree.",
                    "Avoid unnecessary excessive root removal. Do not automatically combine major root work with multiple other major stresses.",
                    "Recovery management must consider the individual tree and growing conditions.",
                ]
            ),
            SpeciesProfileSection(
                id: "trunk-development",
                title: "Trunk Development",
                paragraphs: [
                    "Blaauw can be useful for developing substantial and architectural trunk and branch structures.",
                    "During development, possible approaches include allowing selected leaders to extend, allowing selected branches to extend, sacrifice growth where appropriate, larger development containers, staged structural pruning and gradual trunk selection.",
                    "Do not present one development method as mandatory.",
                    "Once sufficient development has been achieved, gradually shift focus toward branch structure, ramification, foliage distribution, silhouette and refinement.",
                    "Grow where development is required. Control where refinement is required.",
                ]
            ),
            SpeciesProfileSection(
                id: "nebari-development",
                title: "Nebari Development",
                paragraphs: [
                    "Nebari should be considered early.",
                    "Potential approaches include early root selection, radial root positioning, appropriate container development, gradual correction of crossing roots and management of dominant roots.",
                    "The objective is a stable and visually convincing root base — not simply a large quantity of roots.",
                ]
            ),
            SpeciesProfileSection(
                id: "grafting",
                title: "Grafting",
                paragraphs: [
                    "Grafting may be relevant where a branch is missing, foliage distribution requires correction or structural improvement is needed.",
                    "Do not present grafting as routine care.",
                    "Detailed procedures belong in Bonsai World Propagation and Grafting Knowledge Articles.",
                    "The Species Profile explains relevance without duplicating complete procedural instructions.",
                ]
            ),
            SpeciesProfileSection(
                id: "propagation",
                title: "Propagation",
                paragraphs: [
                    "Blaauw is a named horticultural cultivar.",
                    "Propagation intended to preserve cultivar characteristics should use vegetative propagation rather than seed.",
                    "Relevant methods may include cuttings and other appropriate vegetative techniques.",
                    "Seedlings should not be expected to reproduce the cultivar reliably.",
                    "Detailed propagation procedures belong in Bonsai World Propagation Knowledge Articles.",
                ]
            ),
            SpeciesProfileSection(
                id: "pests",
                title: "Pests and Problems",
                paragraphs: [
                    "Relevant risks may include aphids, scale insects, mites, caterpillars and foliage-feeding pests, root problems associated with excessive moisture, Phytophthora and other root-related disease risks, canker and branch problems, environmental foliage browning, and interior decline caused by excessive density or poor light penetration.",
                    "Do not provide one generic treatment list.",
                    "Diagnosis and treatment belong in Care → Pest Management and Care → Disease & Problems.",
                    "This Species Profile identifies tendencies and should link to dedicated knowledge as that system develops.",
                ]
            ),
            SpeciesProfileSection(
                id: "seasonal",
                title: "Seasonal Profile",
                paragraphs: [
                    "Spring: increasing activity. Monitor new growth, water demand, structural decisions, wiring, wire marks and pest activity. Use seasonal timing as guidance rather than a rigid calendar.",
                    "Summer: active growth. Monitor water demand, strong sunlight, wind exposure, foliage health, wire marks and pest activity. Maintain healthy foliage while controlling excessive extension where refinement requires it.",
                    "Autumn: growth gradually slows. Review structure, foliage density, wire condition and overall health before winter. Avoid unnecessary major stress as the tree prepares for winter.",
                    "Winter: Juniperus chinensis 'Blaauw' remains an outdoor evergreen bonsai. Winter dormancy remains important.",
                    "The primary bonsai concern is protection of the root system during severe or prolonged freezing, particularly in shallow containers. Also monitor winter wind, desiccation, freeze-thaw cycles and excessive moisture in cold substrate.",
                    "Do not move the tree indoors for routine winter cultivation. Winter protection must depend on minimum temperatures, duration of freezing, wind, container depth, root condition and local climate.",
                ]
            ),
            SpeciesProfileSection(
                id: "styles",
                title: "Bonsai Styles",
                paragraphs: [
                    "Blaauw can be suitable for several bonsai styles depending on the individual material.",
                    "Potential styles include Informal Upright, Formal Upright where the material supports it, Slanting, Literati in suitable slender material, naturalistic upright forms and Group Planting.",
                    "Do not state that every tree is suitable for every style. The material must determine the final design.",
                    "Use the cultivar's naturally ascending and architectural branch habit as an advantage.",
                ]
            ),
            SpeciesProfileSection(
                id: "tree-stage",
                title: "Development by Tree Stage",
                paragraphs: [
                    "Young material: establish healthy roots, build vigour, establish trunk direction and begin structural planning.",
                    "Nursery material: identify trunk potential, identify useful primary branches, evaluate possible front, remove only clearly unnecessary structural problems and preserve useful future options.",
                    "Pre-bonsai: establish trunk line, establish primary branches, develop root base and begin controlled branch structure.",
                    "In training: branch development, foliage distribution, ramification, wiring and refinement of branch hierarchy.",
                    "Refinement: controlled foliage structure, compact branch development, balanced silhouette, careful extension control and preservation of interior growth.",
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
                    "Use the naturally ascending branch structure as a design advantage",
                    "Preserve healthy foliage on branches intended to remain viable",
                    "Do not assume reliable budding from completely bare old wood",
                    "Avoid permanently wet substrate",
                    "Strong light supports healthy growth and foliage quality",
                    "Monitor wire carefully on actively thickening branches",
                    "Use extension growth strategically during development",
                    "Do not use deciduous defoliation techniques",
                    "Avoid excessive foliage congestion",
                    "Protect shallow root systems during severe winter conditions",
                    "Do not move the tree indoors as routine winter care",
                ]
            ),
        ]
    }
}
