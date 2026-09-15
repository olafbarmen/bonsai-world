//
//  QuercusSuberSpeciesProfile.swift
//  Bonsai World
//
//  Species Profile — Quercus suber (Cork Oak).
//  Independent botanical species in Fagaceae. Knowledge status: Reviewed.
//  Separate from Quercus ilex, Quercus robur and other Quercus species.
//

import Foundation

enum QuercusSuberSpeciesProfile {
    /// Identity used by Botanical Library / ``SpeciesPreviewData``.
    static let botanicalLibraryName = "Quercus suber"
    /// Scientific name for Species Profile display (binomial; no botanical authority).
    static let scientificName = "Quercus suber"

    static var profile: SpeciesProfile {
        SpeciesProfile(
            speciesID: BotanicalKnowledgeIDs.quercusSuber,
            scientificName: scientificName,
            commonNames: ["Cork Oak", "Mediterranean Cork Oak"],
            family: "Fagaceae",
            plantType: "Evergreen Mediterranean oak",
            originSummary: "Western Mediterranean region.",
            knowledgeStatus: .reviewed,
            traits: traits,
            foliageSizeLabel: "Foliage",
            foliageReductionLabel: "Leaf reduction",
            summaryLine: "Evergreen · Distinctive cork bark · Leathery foliage · Rugged trunk character · Strong mature bonsai potential · Mediterranean appearance · Good ramification potential · Excellent naturalistic bonsai character",
            attentionHighlights: [
                "Quercus suber is an evergreen Mediterranean oak",
                "Distinctive cork bark is its most important visual species characteristic",
                "Mature bark develops over time and cannot replace proper structural development",
                "Strong light supports healthy compact growth",
                "Leaf size varies according to individual genetics and vigour",
                "Back-budding depends on health and vigour",
                "Preserve useful interior growth",
                "Dense foliage must not be allowed to weaken internal structure",
                "Do not confuse Mediterranean drought adaptation with tolerance for repeated severe drying in bonsai containers",
                "Complete defoliation is not routine management",
                "Young branches are more suitable for wiring than older rigid branches",
                "Monitor wire carefully",
                "Avoid permanently saturated roots",
                "Avoid prolonged severe freezing where roots are exposed",
                "Shallow bonsai roots are especially vulnerable during winter cold",
                "Do not move indoors for permanent cultivation",
            ],
            sections: sections,
            principleNote: """
            Quercus suber is one of the most visually distinctive Mediterranean species used for bonsai.

            Its greatest bonsai strength is the combination of distinctive cork bark, rugged trunk, evergreen foliage and Mediterranean character.

            The species can create a strong impression of age even at relatively compact bonsai sizes.

            However: do not rely on bark alone to create a convincing bonsai.

            The tree must still have believable trunk movement, appropriate taper, convincing branch structure, healthy foliage and balanced proportions.

            The objective is: Natural mature oak character · Strong living structure · Compact evergreen foliage · Distinctive cork bark.

            The individual tree must always be assessed according to climate, tree condition, vigour, development stage and winter temperatures.
            """,
            sourcesNote: """
            Profile content is synthesised from recognised botanical, horticultural and bonsai authorities into Bonsai World editorial language.

            Botanical taxonomy and distribution draw on recognised sources such as Royal Botanic Gardens, Kew and other botanical databases for accepted scientific name, family and native range.

            Horticultural context may draw on recognised Mediterranean botanical gardens and arboreta, horticultural institutions and authoritative oak horticultural references.

            Bonsai-specific cultivation and refinement knowledge draws on established bonsai references and recognised professional practice with Mediterranean species experience, kept distinct from Quercus ilex, Quercus robur and other Quercus species.

            Verified botanical information, Mediterranean horticultural information, regional climate adaptation and bonsai-specific practice are kept distinct. Do not copy source wording.
            """
        )
    }

    private static let traits = SpeciesProfileTraits(
        deciduous: false,
        growthStrength: "Moderate",
        growthSpeed: "Moderate",
        leafSize: "Evergreen · Leathery leaves",
        foliageReduction: "Selective leaf management possible · Complete defoliation not routine",
        ramificationPotential: "Good",
        backBudding: "Good under healthy conditions",
        rootDevelopment: "Good",
        nebariPotential: "Good to Excellent potential",
        trunkDevelopment: "Moderate",
        barkDevelopment: "Exceptional mature character",
        wiring: "Good",
        defoliation: "Selective leaf management possible · Complete defoliation not routine",
        airLayering: "Where appropriate for the individual material",
        threadGrafting: "Where structural correction is required",
        rootGrafting: "Where appropriate",
        beginnerSuitability: "Moderate",
        bonsaiSuitability: "Excellent",
        difficulty: "Intermediate",
        winterDormancyRequired: true,
        winterHardiness: "Seasonal rest required",
        rootFrostSensitivity: "Moderate to High during prolonged severe freezing, especially in shallow bonsai containers"
    )

    private static var sections: [SpeciesProfileSection] {
        [
            SpeciesProfileSection(
                id: "taxonomic-context",
                title: "Taxonomic Context",
                paragraphs: [
                    "Quercus suber is an independent botanical species in the beech family (Fagaceae).",
                    "Primary Bonsai World display identity: Quercus suber · Cork Oak.",
                    "Mediterranean Cork Oak may be used as supporting terminology. It does not replace Cork Oak as the primary common name.",
                    "Family: Fagaceae. Plant type: evergreen Mediterranean oak.",
                    "Native range: western Mediterranean region.",
                    "Do not confuse Quercus suber with Quercus ilex, Quercus robur or other Quercus species.",
                    "Do not confuse the characteristic cork bark with ordinary mature oak bark.",
                    "Bonsai World hierarchy: Species → cultivar / horticultural selection → Individual Tree.",
                ]
            ),
            SpeciesProfileSection(
                id: "overview",
                title: "Species Overview",
                paragraphs: [
                    "Quercus suber is an evergreen oak native primarily to the western Mediterranean region.",
                    "It is best known for its thick, distinctive cork-producing bark.",
                    "For bonsai, the species is valued for exceptional bark character, rugged trunks, evergreen foliage, natural Mediterranean appearance and potential for mature visual character.",
                    "The bark becomes an important part of the bonsai design.",
                    "However, bark development varies according to tree age, genetics, growth conditions, trunk development and individual material.",
                    "Do not promise mature cork bark characteristics on young material.",
                    "The objective is to develop a convincing mature tree while allowing bark character to develop naturally.",
                ],
                bullets: [
                    "Evergreen Mediterranean oak",
                    "Member of the Fagaceae family",
                    "Distinctive cork-producing bark",
                    "Leathery evergreen foliage",
                    "Moderate growth",
                    "Good ramification potential",
                    "Good back-budding under healthy conditions",
                    "Excellent mature trunk character",
                    "Strong naturalistic bonsai potential",
                    "Requires outdoor cultivation",
                    "Seasonal rest required",
                    "Shallow roots require protection during prolonged severe freezing",
                ]
            ),
            SpeciesProfileSection(
                id: "cultivars",
                title: "Cultivars and Forms",
                paragraphs: [
                    "Quercus suber is primarily used in bonsai as the botanical species.",
                    "Individual trees may vary in bark development, leaf size, growth vigour, branching density, trunk character and foliage density.",
                    "Do not create unnecessary separate Species Library profiles for minor variation.",
                    "The primary Species Profile remains Quercus suber.",
                    "Only create separate profiles where a distinct cultivar or form has a clear and established independent bonsai identity.",
                ]
            ),
            SpeciesProfileSection(
                id: "natural-growth",
                title: "Natural Growth and Vigour",
                paragraphs: [
                    "Quercus suber generally develops at a moderate pace when healthy.",
                    "Growth strength depends on temperature, light, root health, root space, watering, fertilization and development stage.",
                    "During structural development: allow selected growth to extend where trunk thickness is required, branch thickness is required or taper is being developed.",
                    "During refinement: control excessively long shoots, coarse extension, unnecessary vertical growth and branch congestion.",
                    "The objective is: Useful extension during development · Controlled compact growth during refinement.",
                ]
            ),
            SpeciesProfileSection(
                id: "foliage",
                title: "Foliage",
                paragraphs: [
                    "Evergreen leathery foliage is one of the defining characteristics of Quercus suber.",
                    "Leaf size and appearance depend on individual genetics, vigour, fertilization, light, pruning and development stage.",
                    "The objective is healthy foliage, natural visual scale, visible branch structure and compact proportions.",
                    "Avoid excessive fertilization where it produces overly vigorous shoots, coarse extension or unnecessarily large foliage.",
                    "Complete defoliation should not be presented as routine management.",
                    "Selective leaf management may be used where appropriate for healthy trees and specific refinement objectives.",
                ]
            ),
            SpeciesProfileSection(
                id: "flowering",
                title: "Flowering",
                paragraphs: [
                    "Flowering is of low ornamental importance for bonsai.",
                    "Flowers should be viewed as part of the species' seasonal character rather than a design objective.",
                    "Do not sacrifice structural development or ramification in pursuit of flowering.",
                ]
            ),
            SpeciesProfileSection(
                id: "fruit",
                title: "Fruit",
                paragraphs: [
                    "Fruiting is of moderate ornamental importance. Cork Oak may produce acorns.",
                    "Acorn production depends on tree maturity, health, flowering, pollination and seasonal conditions.",
                    "Fruit is not required for a convincing Cork Oak bonsai.",
                    "Heavy fruit loads can consume resources and should be evaluated against tree health and development objectives.",
                ]
            ),
            SpeciesProfileSection(
                id: "bark-trunk",
                title: "Bark and Trunk",
                paragraphs: [
                    "The bark is one of the defining features of Quercus suber. Mature bark character is exceptional.",
                    "Mature material can develop thick cork bark, deep texture, rugged trunk character, natural irregularity and strong visual age.",
                    "Bark development should be allowed to occur naturally.",
                    "Do not attempt to artificially reproduce mature cork bark through carving or surface damage.",
                    "The trunk should be developed according to the individual material.",
                    "The objective is natural age and mature character rather than manufactured texture.",
                ]
            ),
            SpeciesProfileSection(
                id: "roots-nebari",
                title: "Roots and Nebari",
                paragraphs: [
                    "Healthy roots support vigour, recovery, back-budding, ramification and long-term health.",
                    "Root development is good. Objectives include balanced roots, radial development, stable surface roots and gradual nebari improvement.",
                    "Root correction should be gradual.",
                    "Avoid unnecessary aggressive root reduction.",
                    "The objective is a strong and visually convincing base appropriate to a mature Mediterranean oak.",
                ]
            ),
            SpeciesProfileSection(
                id: "light",
                title: "Light",
                paragraphs: [
                    "Quercus suber requires strong outdoor light.",
                    "Adequate light supports healthy evergreen foliage, compact growth, ramification, branch development and overall vigour.",
                    "The exact growing position depends on local climate, seasonal temperatures, tree health and development stage.",
                    "Do not recommend permanent indoor cultivation.",
                ]
            ),
            SpeciesProfileSection(
                id: "wind",
                title: "Wind",
                paragraphs: [
                    "Moderate air movement is beneficial.",
                    "Strong wind may increase water demand, dry shallow containers, increase winter stress and damage vulnerable growth.",
                    "Monitor trees during prolonged wind, dry conditions, cold periods and rapid weather changes.",
                ]
            ),
            SpeciesProfileSection(
                id: "watering",
                title: "Watering",
                paragraphs: [
                    "General principle: Maintain healthy moisture levels · Avoid permanent saturation · Avoid repeated severe drought · Maintain root aeration.",
                    "Water demand is moderate.",
                    "Although Quercus suber is adapted to Mediterranean conditions, do not confuse drought tolerance in nature with tolerance for repeated severe drying in a shallow bonsai container.",
                    "Watering frequency depends on temperature, sunlight, wind, container size, substrate, root mass, foliage mass and development stage.",
                    "Do not water according to a fixed timetable.",
                ]
            ),
            SpeciesProfileSection(
                id: "soil",
                title: "Soil",
                paragraphs: [
                    "Do not prescribe one universal soil recipe.",
                    "Desired characteristics include good drainage, strong aeration, stable particle structure, appropriate moisture retention and healthy root development.",
                    "The final soil mix depends on local climate, rainfall, watering habits, container depth, tree size, development stage and root condition.",
                    "Follow Bonsai World Soil Module principles.",
                    "Do not duplicate the complete Soil Module inside this profile.",
                ]
            ),
            SpeciesProfileSection(
                id: "fertilizing",
                title: "Fertilizing",
                paragraphs: [
                    "Fertilization should support healthy evergreen foliage, trunk development, branch development, ramification and recovery after work.",
                    "During structural development: healthy trees may receive stronger nutritional support where appropriate.",
                    "During refinement: avoid excessive fertilization that produces coarse shoots, excessive extension or unnecessarily large foliage.",
                    "Key principle: Feed according to tree condition and development objective.",
                    "Mediterranean adaptation should not be interpreted as a reason to underfeed a healthy bonsai.",
                ]
            ),
            SpeciesProfileSection(
                id: "pruning",
                title: "Pruning",
                paragraphs: [
                    "Quercus suber responds to controlled pruning when healthy. Pruning response is good.",
                    "Pruning can be used for structural development, branch selection, branch replacement, ramification and silhouette refinement.",
                    "During development: allow selected shoots to extend where thickness or taper is required.",
                    "During refinement: use controlled pruning and shoot selection to maintain compact proportions, useful ramification, branch hierarchy and visible internal structure.",
                    "Do not repeatedly shorten all growth uniformly.",
                    "The objective is: Purposeful development · Controlled refinement · Healthy regenerative capacity.",
                ]
            ),
            SpeciesProfileSection(
                id: "back-budding",
                title: "Back-budding",
                paragraphs: [
                    "Quercus suber can produce useful new growth from existing branches and older structure. Back-budding is good under healthy conditions.",
                    "Response depends on tree health, vigour, light, branch condition, pruning strategy and root health.",
                    "Do not describe back-budding as guaranteed.",
                    "Preserve useful interior growth whenever possible.",
                    "Avoid repeatedly removing all foliage from important interior branch sections.",
                    "The objective is a healthy branch system capable of renewal and progressive refinement.",
                ]
            ),
            SpeciesProfileSection(
                id: "ramification",
                title: "Ramification",
                paragraphs: [
                    "Fine ramification can be developed through repeated healthy growth cycles, controlled pruning, shoot selection, branch selection and preservation of useful interior growth. Ramification potential is good.",
                    "Do not create dense outer foliage while allowing the internal branch system to weaken.",
                    "Maintain branch hierarchy, natural spacing, useful interior growth and sufficient light penetration.",
                    "The objective is compact foliage supported by believable internal structure.",
                ]
            ),
            SpeciesProfileSection(
                id: "wiring",
                title: "Wiring",
                paragraphs: [
                    "Young and flexible branches can be wired. Wiring response is good.",
                    "Wiring can be used to establish movement, improve branch placement, position secondary branches and develop branch structure.",
                    "Older branches may become increasingly rigid.",
                    "Before major bends, assess branch thickness, flexibility, age, health and structural importance.",
                    "Monitor wire carefully.",
                    "Do not force rigid branches into extreme bends.",
                ]
            ),
            SpeciesProfileSection(
                id: "deadwood-potential",
                title: "Deadwood",
                paragraphs: [
                    "Deadwood may be incorporated where naturally appropriate. Deadwood potential is moderate.",
                    "The living trunk and distinctive bark should remain the primary visual feature.",
                    "Deadwood should only be used where it supports the natural design, reflects the individual material, contributes to believable age and does not compromise structural stability.",
                    "Avoid excessive artificial carving.",
                    "The objective is natural maturity rather than artificial damage.",
                ]
            ),
            SpeciesProfileSection(
                id: "defoliation",
                title: "Defoliation and Leaf Management",
                paragraphs: [
                    "Selective leaf management is possible. Complete defoliation is not routine management.",
                    "Leaf management should primarily focus on shoot selection, pruning, balanced fertilization, adequate light and vigour management.",
                    "Selective removal of individual leaves may be appropriate for specific refinement objectives on healthy trees.",
                    "Do not present complete defoliation as standard maintenance.",
                    "Do not apply aggressive foliage removal to weak trees, stressed trees, recently repotted trees or trees recovering from major work.",
                ]
            ),
            SpeciesProfileSection(
                id: "repotting",
                title: "Repotting",
                paragraphs: [
                    "Repotting frequency depends on root development, substrate condition, drainage, container size, tree health and development stage.",
                    "Do not establish a rigid calendar rule.",
                    "Avoid unnecessary aggressive root reduction, excessive removal of functioning roots, and combining major root work with multiple major stresses.",
                    "Preserve sufficient healthy roots.",
                    "Repotting decisions should be based on root condition, substrate performance and overall tree health.",
                    "Timing must account for local climate, active growth cycle, seasonal temperatures and individual tree condition.",
                ]
            ),
            SpeciesProfileSection(
                id: "trunk-development",
                title: "Trunk Development",
                paragraphs: [
                    "Quercus suber can develop strong mature trunk character.",
                    "Where additional thickness is required: allow selected leaders to extend, provide sufficient root space, use development containers where appropriate and avoid premature refinement.",
                    "Do not expect mature cork bark characteristics to replace structural development.",
                    "A convincing bonsai still requires taper, trunk movement, branch hierarchy, healthy roots and proportional structure.",
                    "Once sufficient trunk development has been achieved, shift focus toward taper, branch hierarchy, ramification, bark development and compact proportions.",
                ]
            ),
            SpeciesProfileSection(
                id: "nebari-development",
                title: "Nebari Development",
                paragraphs: [
                    "Nebari should be developed gradually.",
                    "Potential approaches include early root selection, radial root planning, staged root correction, appropriate development containers and gradual refinement of surface roots.",
                    "The objective is a strong and visually convincing oak base.",
                ]
            ),
            SpeciesProfileSection(
                id: "propagation",
                title: "Propagation",
                paragraphs: [
                    "Quercus suber may be propagated using established horticultural methods including seed and layering.",
                    "Seed-grown material may offer genetic variation, strong root development and opportunities for early structural planning.",
                    "Detailed procedures belong in Bonsai World Propagation Knowledge Articles.",
                ]
            ),
            SpeciesProfileSection(
                id: "pests",
                title: "Pests and Problems",
                paragraphs: [
                    "Relevant risks may include scale insects, aphids, spider mites, fungal leaf problems, root problems caused by poor drainage, drought stress in shallow containers, winter stress and root damage during prolonged severe freezing.",
                    "Do not provide generic treatment instructions.",
                    "Diagnosis and treatment belong in Care → Pest Management and Care → Disease & Problems.",
                ]
            ),
            SpeciesProfileSection(
                id: "seasonal",
                title: "Seasonal Profile",
                paragraphs: [
                    "Spring: monitor new growth, watering demand, overall vigour, pest activity and branch development. Spring is important for assessing structural priorities, ramification, root health and recovery from winter. Major work should be coordinated with local climate and tree condition.",
                    "Summer: monitor watering demand, shoot growth, foliage health, pest activity and wire marks. Strong growth should be managed according to whether shoots are intended for structural development, branch development or refinement. Do not suppress all vigorous growth where development is still required.",
                    "Autumn is important for evaluating seasonal growth, reviewing branch structure, assessing overall health and preparing for cooler conditions. Growth activity depends strongly on local climate. Do not apply one universal autumn schedule.",
                    "Winter: Quercus suber should receive appropriate outdoor seasonal conditions.",
                    "Do not describe Quercus suber as universally frost hardy.",
                    "Winter management depends strongly on local minimum temperatures, duration of freezing, wind exposure, container depth, root protection and tree health.",
                    "Cold tolerance also depends on moisture conditions.",
                    "A tree growing in a shallow bonsai container has significantly less root protection than a tree growing in open ground.",
                    "Shallow bonsai roots are significantly more exposed to cold than roots in open ground.",
                    "Protect the root system when required. Do not maintain permanently indoors as a substitute for appropriate seasonal cultivation.",
                ]
            ),
            SpeciesProfileSection(
                id: "styles",
                title: "Bonsai Styles",
                paragraphs: [
                    "Quercus suber is particularly suitable for Informal Upright, Slanting, Multi-trunk Style, Clump Style, Naturalistic Bonsai and Mediterranean Naturalistic Style.",
                    "It is especially effective when styling emphasises distinctive bark, powerful trunk structure, natural branch movement, compact evergreen foliage and aged Mediterranean character.",
                    "The individual material should determine the final design.",
                ]
            ),
            SpeciesProfileSection(
                id: "tree-stage",
                title: "Development by Tree Stage",
                paragraphs: [
                    "Young material: establish healthy roots, develop trunk thickness, establish movement and begin structural development.",
                    "Nursery material: evaluate trunk potential, identify useful branches, establish a design direction and begin structural correction.",
                    "Pre-bonsai: develop trunk, establish primary branches, improve root structure, build taper and build vigour.",
                    "In training: develop secondary branches, improve branch hierarchy, build ramification and preserve interior growth.",
                    "Refinement: maintain balanced vigour, improve tertiary ramification, control shoot extension, maintain compact proportions and preserve visible structure.",
                    "Exhibition / mature refined tree: maintain health, preserve established structure, maintain balanced ramification, preserve mature bark character and avoid unnecessary major intervention.",
                ]
            ),
            SpeciesProfileSection(
                id: "attention",
                title: "Species-Specific Attention",
                paragraphs: [
                    "These attention points are operational tendencies. They must still be interpreted for the individual tree.",
                ],
                bullets: [
                    "Quercus suber is an evergreen Mediterranean oak",
                    "Distinctive cork bark is its most important visual species characteristic",
                    "Mature bark develops over time and cannot replace proper structural development",
                    "Strong light supports healthy compact growth",
                    "Leaf size varies according to individual genetics and vigour",
                    "Back-budding depends on health and vigour",
                    "Preserve useful interior growth",
                    "Dense foliage must not be allowed to weaken internal structure",
                    "Do not confuse Mediterranean drought adaptation with tolerance for repeated severe drying in bonsai containers",
                    "Complete defoliation is not routine management",
                    "Young branches are more suitable for wiring than older rigid branches",
                    "Monitor wire carefully",
                    "Avoid permanently saturated roots",
                    "Avoid prolonged severe freezing where roots are exposed",
                    "Shallow bonsai roots are especially vulnerable during winter cold",
                    "Do not move indoors for permanent cultivation",
                ]
            ),
        ]
    }
}
