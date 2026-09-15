//
//  AlnusGlutinosaSpeciesProfile.swift
//  Bonsai World
//
//  Species Profile — Alnus glutinosa (Black Alder).
//  Independent botanical species in Betulaceae. Knowledge status: Reviewed.
//  Separate from Alnus incana and other Alnus species.
//

import Foundation

enum AlnusGlutinosaSpeciesProfile {
    /// Identity used by Botanical Library / ``SpeciesPreviewData``.
    static let botanicalLibraryName = "Alnus glutinosa"
    /// Scientific name for Species Profile display (binomial; no botanical authority).
    static let scientificName = "Alnus glutinosa"

    static var profile: SpeciesProfile {
        SpeciesProfile(
            speciesID: BotanicalKnowledgeIDs.alnusGlutinosa,
            scientificName: scientificName,
            commonNames: ["Black Alder", "Common Alder"],
            family: "Betulaceae",
            plantType: "Deciduous broadleaf tree",
            originSummary: "Europe, northwestern Africa and western Asia.",
            knowledgeStatus: .reviewed,
            traits: traits,
            foliageSizeLabel: "Foliage",
            foliageReductionLabel: "Leaf reduction",
            summaryLine: "Deciduous · Strong growth · Moisture-tolerant · Rounded leaves · Attractive persistent cones · Good trunk development · Good ramification potential · Naturalistic bonsai potential",
            attentionHighlights: [
                "Strong-growing deciduous European species",
                "Naturally associated with moist environments",
                "Consistent moisture may be important during active growth",
                "Moisture tolerance does not mean permanently stagnant roots",
                "Bonsai root systems still require oxygen and appropriate drainage",
                "Good trunk development potential",
                "Good ramification potential",
                "Good back-budding potential under healthy conditions",
                "Back-budding is not guaranteed",
                "Preserve useful interior growth",
                "Strong growth should be used strategically",
                "Attractive persistent cones are an important species characteristic",
                "Avoid prolonged drought",
                "Avoid permanently anaerobic substrate conditions",
                "Older branches become increasingly rigid",
                "Defoliation is not routine management",
                "Winter dormancy is required",
                "Shallow bonsai roots are more exposed than roots in open ground",
                "Do not move indoors for routine winter care",
            ],
            sections: sections,
            principleNote: """
            Alnus glutinosa is strongly associated with moist ground, river margins, lakesides and wetlands. This ecological identity is important for bonsai cultivation.

            Do not interpret moisture tolerance as a recommendation to keep bonsai roots permanently waterlogged. A bonsai container has fundamentally different conditions from natural wet ground.

            The objective remains: Healthy roots · Adequate moisture · Good oxygen availability · Appropriate drainage.

            Black Alder can be an excellent bonsai species because of vigorous growth, strong recovery, good response to pruning, trunk development potential, attractive seasonal character and small woody cones that can remain on the tree.

            Its natural character is often best expressed through informal upright designs, naturalistic deciduous trees, multi-trunk compositions and riverside or wetland-inspired forms.

            The individual tree must always be assessed according to health, vigour, root condition, available growing space, development stage, climate, seasonal conditions and recent work.

            The objective is: Healthy roots · Strong structure · Balanced ramification · Convincing alder character
            """,
            sourcesNote: """
            Profile content is synthesised from recognised botanical, horticultural and bonsai authorities into Bonsai World editorial language.

            Botanical taxonomy and distribution draw on recognised sources such as Royal Botanic Gardens, Kew and other botanical databases for accepted scientific name, family and native range.

            Ecological and horticultural context may draw on recognised European botanical gardens, arboreta, forestry institutions and wetland and native tree organisations.

            Bonsai-specific cultivation and refinement knowledge draws on established bonsai references and recognised professional practice for Alnus species, kept distinct from Alnus incana and other alders.

            Verified botanical information, ecological information, general horticultural cultivation and bonsai-specific practice are kept distinct. Do not copy source wording.
            """
        )
    }

    private static let traits = SpeciesProfileTraits(
        deciduous: true,
        growthStrength: "Strong",
        growthSpeed: "Fast",
        leafSize: "Deciduous · Rounded to broadly ovate leaves",
        foliageReduction: "Possible only as an advanced technique on very strong trees and not required for routine management",
        ramificationPotential: "Good",
        backBudding: "Good under healthy conditions and correct pruning management",
        rootDevelopment: "Strong",
        nebariPotential: "Good potential",
        trunkDevelopment: "Strong",
        barkDevelopment: "Good mature character",
        wiring: "Good when branches are young",
        defoliation: "Possible only as an advanced technique on very strong trees and not required for routine management",
        airLayering: "Where appropriate for the individual material",
        threadGrafting: "Where structural correction is required",
        rootGrafting: "Where appropriate",
        beginnerSuitability: "Moderate",
        bonsaiSuitability: "Good to Excellent",
        difficulty: "Intermediate",
        winterDormancyRequired: true,
        winterHardiness: "Outdoor deciduous — winter dormancy required",
        rootFrostSensitivity: "Moderate in shallow bonsai containers"
    )

    private static var sections: [SpeciesProfileSection] {
        [
            SpeciesProfileSection(
                id: "taxonomic-context",
                title: "Taxonomic Context",
                paragraphs: [
                    "Alnus glutinosa is an independent botanical species in the birch family (Betulaceae).",
                    "Primary Bonsai World display identity: Alnus glutinosa · Black Alder.",
                    "Common Alder may be used as an alternative common name. It does not replace Black Alder as the primary common name.",
                    "European alder may be used as supporting descriptive terminology for landscape character. It does not replace the species identity Alnus glutinosa.",
                    "Family: Betulaceae. Plant type: deciduous broadleaf tree.",
                    "Native range: Europe, northwestern Africa and western Asia.",
                    "Maintain a clear distinction between Alnus glutinosa, Alnus incana, other Alnus species, named ornamental cultivars and horticultural hybrids.",
                    "Do not assume that all alder material behaves identically.",
                    "Do not confuse the species with ornamental alder cultivars.",
                    "Bonsai World hierarchy: Species → cultivar / horticultural selection → Individual Tree.",
                ]
            ),
            SpeciesProfileSection(
                id: "overview",
                title: "Species Overview",
                paragraphs: [
                    "Alnus glutinosa is a deciduous tree native across much of Europe and extending into northwestern Africa and western Asia.",
                    "It is commonly associated with riversides, wetlands, lake margins, damp woodland and moist soils.",
                    "Mature trees can develop substantial trunks, dark fissured bark, broad crowns, strong branches and persistent woody cones.",
                    "These characteristics provide strong potential for bonsai.",
                    "Black Alder is particularly interesting for bonsai because its seasonal identity extends beyond foliage.",
                    "The small woody cones can remain visible after leaf fall and contribute to winter interest, species recognition and natural character.",
                    "The strongest bonsai results usually come from respecting the species' naturally vigorous and somewhat rugged character.",
                ],
                bullets: [
                    "Deciduous European broadleaf tree",
                    "Strong and vigorous growth",
                    "Naturally associated with moist environments",
                    "Good tolerance of consistently moist conditions",
                    "Requires oxygenated bonsai root conditions",
                    "Rounded to broadly ovate leaves",
                    "Persistent woody cones",
                    "Good trunk development potential",
                    "Good ramification potential",
                    "Good back-budding under healthy conditions",
                    "Good root development",
                    "Good naturalistic bonsai potential",
                    "Requires outdoor cultivation",
                    "Requires winter dormancy",
                ]
            ),
            SpeciesProfileSection(
                id: "natural-growth",
                title: "Natural Growth and Vigour",
                paragraphs: [
                    "Alnus glutinosa can be a strong and fast-growing species under favourable conditions.",
                    "Growth strength depends on root health, light, available growing space, substrate, water availability, fertilization, climate and development stage.",
                    "During structural development: allow selected growth to extend where trunk thickness is required, branch thickness is required, taper is being developed or sacrifice growth is useful.",
                    "Because the species can grow strongly, it is important not to move into refinement too early.",
                    "During refinement: control shoot extension, internode length, branch density and vigour distribution.",
                    "The objective is: Use strength strategically · Control growth selectively.",
                ]
            ),
            SpeciesProfileSection(
                id: "foliage",
                title: "Foliage and Leaves",
                paragraphs: [
                    "Alnus glutinosa produces deciduous leaves that are generally rounded to broadly ovate.",
                    "Leaf size varies depending on vigour, fertilization, water availability, development stage and growing conditions.",
                    "The objective is not simply to force the smallest possible leaves.",
                    "The objective is foliage proportionate to the tree's trunk, branch structure and overall design.",
                    "Strong unrestricted growth may produce coarser foliage.",
                    "During refinement, manage vigour and pruning to support more balanced proportions.",
                ]
            ),
            SpeciesProfileSection(
                id: "cones",
                title: "Cones",
                paragraphs: [
                    "Black Alder produces small woody cones that are an important identifying characteristic.",
                    "These can contribute strongly to the bonsai's seasonal appearance.",
                    "Cones may remain visible after leaf fall and can provide winter interest, natural species character and additional texture.",
                    "Cone production depends on tree maturity, health, seasonal conditions and reproductive development.",
                    "Do not guarantee cone production every year.",
                    "Where cones are a desired display feature, avoid treating every shoot purely as disposable refinement growth.",
                    "The reproductive cycle should be considered when planning pruning.",
                ]
            ),
            SpeciesProfileSection(
                id: "bark-trunk",
                title: "Bark and Trunk",
                paragraphs: [
                    "Mature Alnus glutinosa can develop attractive dark and fissured bark.",
                    "Trunk development should focus on taper, proportion, natural movement, branch relationship and mature character.",
                    "Where additional thickness is required, allow selected leaders and sacrifice growth to extend.",
                    "Once sufficient development has been achieved, shift focus toward taper, branch hierarchy, ramification, bark development and overall proportion.",
                    "The objective is a convincing mature alder rather than a generic deciduous bonsai.",
                ]
            ),
            SpeciesProfileSection(
                id: "roots-nebari",
                title: "Roots and Nebari",
                paragraphs: [
                    "Healthy roots are fundamental to vigour, recovery, trunk development, branch development and long-term health.",
                    "Alnus glutinosa naturally tolerates moist environments well.",
                    "Bonsai roots must still receive adequate oxygen. Do not maintain permanently stagnant or anaerobic root conditions.",
                    "Root development objectives include balanced radial roots, stable tree support, healthy root density, appropriate moisture management and sustainable root structure.",
                    "Nebari development should be gradual. Young material offers the greatest opportunity for early root planning.",
                ]
            ),
            SpeciesProfileSection(
                id: "light",
                title: "Light",
                paragraphs: [
                    "Alnus glutinosa should be cultivated outdoors.",
                    "Strong outdoor light supports healthy foliage, strong growth, trunk development, ramification and overall vigour.",
                    "The exact position depends on local climate, temperature, tree condition and development stage.",
                    "During extreme summer conditions, monitor water demand, leaf stress and root-zone temperature.",
                    "Do not recommend permanent indoor cultivation.",
                ]
            ),
            SpeciesProfileSection(
                id: "wind",
                title: "Wind",
                paragraphs: [
                    "Moderate air movement is generally beneficial.",
                    "Strong and persistent wind can significantly increase water demand.",
                    "Pay particular attention to shallow bonsai containers, recently repotted trees, trees in strong active growth and unusually hot and dry weather.",
                    "The combination of high wind, strong sun and a shallow container can dry a bonsai root zone much faster than expected.",
                ]
            ),
            SpeciesProfileSection(
                id: "watering",
                title: "Watering",
                paragraphs: [
                    "General principle: Maintain reliable moisture · Water thoroughly when required · Preserve root aeration · Avoid prolonged drought · Avoid stagnant anaerobic conditions.",
                    "Water demand is typically moderate to high during active growth.",
                    "Alnus glutinosa generally tolerates and often appreciates more consistent moisture than many other temperate bonsai species.",
                    "Do not interpret this as a recommendation for permanently saturated substrate.",
                    "Watering frequency depends on temperature, sunlight, wind, foliage mass, container size, substrate, root mass and development stage.",
                    "Do not water according to a fixed timetable.",
                    "Water according to substrate condition, weather and the individual tree.",
                    "Avoid repeated severe drought, prolonged root dehydration and stagnant permanently waterlogged substrate.",
                ]
            ),
            SpeciesProfileSection(
                id: "soil",
                title: "Soil",
                paragraphs: [
                    "Do not prescribe one universal soil recipe.",
                    "Desired characteristics include good drainage, strong aeration, stable particle structure, reliable moisture retention and healthy root development.",
                    "For Alnus glutinosa, moisture retention may be particularly important depending on climate and cultivation conditions.",
                    "The root zone must still maintain adequate oxygen.",
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
                    "During structural development: healthy trees requiring strong growth may receive increased nutritional support where appropriate.",
                    "During refinement: nutrition should support healthy foliage, controlled shoot extension, branch development and sustainable ramification.",
                    "Avoid excessive fertilization where it produces unnecessarily coarse growth, excessively large foliage or disproportionate shoot extension.",
                    "Key principle: Feed according to development objective.",
                ]
            ),
            SpeciesProfileSection(
                id: "pruning",
                title: "Pruning",
                paragraphs: [
                    "Alnus glutinosa generally responds well to thoughtful pruning.",
                    "Pruning can be used for structural development, branch selection, branch replacement, ramification and silhouette refinement.",
                    "During structural development: allow selected leaders and branches to extend where thickness is required.",
                    "During refinement: use controlled pruning to develop secondary branches, tertiary branches and balanced branch density.",
                    "Because the species can grow strongly, do not repeatedly prune every area equally.",
                    "Manage strong areas while preserving weaker areas. The objective is balanced vigour.",
                ]
            ),
            SpeciesProfileSection(
                id: "back-budding",
                title: "Back-budding",
                paragraphs: [
                    "Alnus glutinosa can produce useful new growth following pruning.",
                    "This can support branch development, replacement branches, structural correction and ramification.",
                    "Back-budding must not be treated as guaranteed. Response depends on tree health, vigour, branch age, light, pruning strategy and root condition.",
                    "Preserve useful interior growth.",
                    "Do not remove all internal growth simply to create a clean silhouette.",
                ]
            ),
            SpeciesProfileSection(
                id: "ramification",
                title: "Ramification",
                paragraphs: [
                    "Alnus glutinosa has good potential for ramification.",
                    "Ramification develops through healthy growth, controlled pruning, shoot selection, branch selection and balanced vigour.",
                    "The objective is a convincing deciduous branch structure.",
                    "Avoid excessive density.",
                    "The finished tree should retain clear branch hierarchy, visible structure, natural spacing and proportionate foliage.",
                ]
            ),
            SpeciesProfileSection(
                id: "wiring",
                title: "Wiring",
                paragraphs: [
                    "Alnus glutinosa is generally suitable for wiring when branches are young.",
                    "Wiring can be used to establish primary branch placement, improve branch movement, position secondary branches and refine structure.",
                    "Older branches become more rigid.",
                    "Do not force major bends in mature branches without assessing flexibility, thickness, age, health and structural importance.",
                    "Monitor wire carefully during periods of strong growth.",
                ]
            ),
            SpeciesProfileSection(
                id: "deadwood-potential",
                title: "Deadwood Potential",
                paragraphs: [
                    "Deadwood is not the defining styling language of Alnus glutinosa bonsai.",
                    "Natural scars and weathered surfaces may contribute to age and riverside character where they already exist.",
                    "Do not add artificial jin or excessive exposed deadwood simply because the techniques are available.",
                    "Use natural features only where they support the individual tree's character and long-term design.",
                ]
            ),
            SpeciesProfileSection(
                id: "defoliation",
                title: "Defoliation and Leaf Management",
                paragraphs: [
                    "Do not present defoliation as standard maintenance.",
                    "Leaf management should primarily be achieved through pruning, vigour management, branch development and fertilization control.",
                    "Advanced leaf reduction techniques may be used by experienced growers on exceptionally healthy trees.",
                    "Do not apply aggressive leaf removal to weak trees, stressed trees, recently repotted trees or trees recovering from major work.",
                    "The objective is: Healthy growth · Sustainable refinement · Appropriate foliage proportion.",
                ]
            ),
            SpeciesProfileSection(
                id: "repotting",
                title: "Repotting",
                paragraphs: [
                    "Repotting frequency depends on root development, substrate condition, drainage, moisture retention, container size, tree health and development stage.",
                    "Do not establish a rigid calendar rule.",
                    "Avoid unnecessary aggressive root reduction, excessive removal of functioning roots, and combining major root work with multiple major stresses.",
                    "Preserve sufficient healthy roots.",
                    "Repotting decisions should be based on root condition, substrate performance and overall tree health.",
                ]
            ),
            SpeciesProfileSection(
                id: "trunk-development",
                title: "Trunk Development",
                paragraphs: [
                    "Alnus glutinosa has strong potential for trunk development.",
                    "Where additional thickness is required: allow selected leaders to extend, use sacrifice branches where appropriate, provide sufficient root space and avoid premature refinement.",
                    "Strong growth should be used strategically. Do not allow uncontrolled growth everywhere.",
                    "The purpose of strong growth should be clear: trunk thickening, branch thickening, taper development or structural development.",
                    "Once sufficient structure has been achieved, shift gradually toward refinement.",
                ]
            ),
            SpeciesProfileSection(
                id: "nebari-development",
                title: "Nebari Development",
                paragraphs: [
                    "Nebari should be developed gradually.",
                    "Potential approaches include early root selection, radial root planning, staged root correction, appropriate development containers and gradual improvement of surface roots.",
                    "The objective is a stable and visually convincing base appropriate to the individual tree.",
                    "Strong surface roots can contribute significantly to the appearance of a mature naturalistic alder.",
                ]
            ),
            SpeciesProfileSection(
                id: "propagation",
                title: "Propagation",
                paragraphs: [
                    "Alnus glutinosa may be propagated through seed, cuttings where suitable material and conditions permit, layering in appropriate situations and other established horticultural propagation methods.",
                    "Seed-grown material can be particularly valuable for early root planning, nebari development, trunk development and long-term structural design.",
                    "Detailed procedures belong in Bonsai World Propagation Knowledge Articles.",
                ]
            ),
            SpeciesProfileSection(
                id: "pests",
                title: "Pests and Problems",
                paragraphs: [
                    "Relevant risks may include aphids, leaf-feeding insects, scale insects, fungal leaf diseases, root problems caused by unsuitable substrate conditions, environmental stress and drought stress.",
                    "Do not provide generic treatment instructions.",
                    "Diagnosis and treatment belong in Care → Pest Management and Care → Disease & Problems.",
                ]
            ),
            SpeciesProfileSection(
                id: "seasonal",
                title: "Seasonal Profile",
                paragraphs: [
                    "Spring: monitor bud development, new shoot growth, overall vigour, water demand and pest activity. Spring is important for evaluating branch strength, structural development, seasonal planning and root work where appropriate. Strong and weak areas may require different management.",
                    "Summer: monitor water demand, substrate moisture, leaf health, pest activity, excessive shoot extension, wire marks and heat stress. Black Alder can have significant water requirements during strong active growth. Do not allow repeated severe drying. During refinement, manage excessive extension while preserving useful growth. Avoid unnecessary heavy work during extreme heat or drought stress.",
                    "Autumn is important for evaluating branch structure, reviewing overall vigour, observing cones and preparing for winter. As leaves fall, the branch structure becomes increasingly visible. This is an important period for evaluating branch hierarchy, silhouette, structural development and future design decisions. Persistent cones can contribute to seasonal character. Seasonal timing depends on local climate.",
                    "Winter: Alnus glutinosa is an outdoor deciduous tree. Winter dormancy is required. Do not move the tree into permanently warm indoor conditions.",
                    "Bonsai roots in shallow containers are more exposed than roots growing in open ground.",
                    "Monitor prolonged severe freezing, freeze-thaw cycles, root exposure and excessive winter moisture.",
                    "Winter protection depends on local climate, minimum temperatures, duration of freezing, container depth and root condition.",
                    "Protect the root system when required while maintaining natural dormancy.",
                ]
            ),
            SpeciesProfileSection(
                id: "styles",
                title: "Bonsai Styles",
                paragraphs: [
                    "Alnus glutinosa is particularly suitable for naturalistic deciduous styles.",
                    "Particularly suitable expressions include Informal Upright, Slanting, Multi-trunk Style, Clump Style, Forest / Group Planting and Naturalistic Landscape Tree Style.",
                    "Black Alder is especially effective when styling emphasises natural trunks, balanced crowns, visible branch structure, mature bark, moisture-landscape character and natural asymmetry.",
                    "The individual material should determine the final design.",
                ]
            ),
            SpeciesProfileSection(
                id: "tree-stage",
                title: "Development by Tree Stage",
                paragraphs: [
                    "Young material: establish healthy roots, develop nebari, build trunk thickness, establish movement and begin structural development.",
                    "Nursery material: evaluate trunk potential, identify useful branches, establish a design direction and begin structural correction where required.",
                    "Pre-bonsai: develop trunk, establish primary branches, improve root structure, begin branch hierarchy and build vigour.",
                    "In training: develop secondary branches, improve branch hierarchy, build sustainable ramification and manage foliage proportion.",
                    "Refinement: maintain balanced vigour, improve tertiary ramification, control shoot extension, maintain clear branch structure and preserve species character.",
                    "Exhibition / mature refined tree: maintain health, preserve established structure, maintain mature bark, maintain balanced ramification, preserve natural alder character and avoid unnecessary major intervention.",
                ]
            ),
            SpeciesProfileSection(
                id: "attention",
                title: "Species-Specific Attention",
                paragraphs: [
                    "These attention points are operational tendencies. They must still be interpreted for the individual tree.",
                ],
                bullets: [
                    "Strong-growing deciduous European species",
                    "Naturally associated with moist environments",
                    "Consistent moisture may be important during active growth",
                    "Moisture tolerance does not mean permanently stagnant roots",
                    "Bonsai root systems still require oxygen and appropriate drainage",
                    "Good trunk development potential",
                    "Good ramification potential",
                    "Good back-budding potential under healthy conditions",
                    "Back-budding is not guaranteed",
                    "Preserve useful interior growth",
                    "Strong growth should be used strategically",
                    "Attractive persistent cones are an important species characteristic",
                    "Avoid prolonged drought",
                    "Avoid permanently anaerobic substrate conditions",
                    "Older branches become increasingly rigid",
                    "Defoliation is not routine management",
                    "Winter dormancy is required",
                    "Shallow bonsai roots are more exposed than roots in open ground",
                    "Do not move indoors for routine winter care",
                ]
            ),
        ]
    }
}
