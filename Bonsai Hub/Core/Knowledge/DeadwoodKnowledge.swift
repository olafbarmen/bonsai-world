//
//  DeadwoodKnowledge.swift
//  Bonsai World
//
//  Knowledge → Bonsai Handbook → Deadwood.
//  Understanding jin, shari, uro and natural character. Not a carving manual.
//

import Foundation

struct DeadwoodCallout: Identifiable, Hashable, Sendable {
    var id: String
    var title: String
    var body: String
}

struct DeadwoodSection: Identifiable, Hashable, Sendable {
    var id: String
    var heading: String
    var paragraphs: [String]
    var bullets: [String]
    var callouts: [DeadwoodCallout]
}

struct DeadwoodLesson: Identifiable, Hashable, Sendable {
    var id: String
    var number: Int
    var title: String
    var summary: String
    var sections: [DeadwoodSection]
}

enum DeadwoodKnowledge {
    static let chapterTitle = "Deadwood"

    static let openingLine =
        "Understanding jin, shari, uro and natural character in bonsai design."

    static let disclaimer =
        "This chapter teaches understanding before technique. It is not a power-tool manual and does not prescribe machines, bits, chemicals or preservation products. Deadwood should tell the story of the tree. It should not look like decoration added after the story was finished."

    static let lessons: [DeadwoodLesson] = [
        overview,
        readingTheTree,
        jin,
        shari,
        uro,
        speciesAndHealth,
        designMovementAndAge,
        lifeDeathAndLanguage,
        carvingTextureAndScale,
        weatheringAndPreservation,
        displayAndRestraint,
        practice,
        quickGuides
    ]

    static func lesson(id: String) -> DeadwoodLesson? {
        lessons.first { $0.id == id }
    }

    // MARK: - 01 Overview

    private static let overview = DeadwoodLesson(
        id: "overview",
        number: 1,
        title: "Overview",
        summary: "Deadwood should tell the story of the tree. It should not look like decoration added after the story was finished.",
        sections: [
            DeadwoodSection(
                id: "introduction",
                heading: "A consequence of the tree's life",
                paragraphs: [
                    "Deadwood is one of the most powerful visual elements in bonsai. Used well, it can suggest age, survival, harsh conditions, damage, natural change and the passage of time. Used poorly, it can make a tree appear artificial, overworked, confused or unnatural.",
                    "The purpose of deadwood is not simply to make a tree look older. Its purpose is to become part of the tree's visual story. Before creating or modifying deadwood, ask what happened to this tree — or more accurately, what could naturally have happened to a tree like this."
                ],
                bullets: [],
                callouts: [
                    DeadwoodCallout(
                        id: "consequence",
                        title: "Bonsai World principle",
                        body: "Deadwood is most convincing when it feels like a consequence of the tree's life."
                    ),
                    DeadwoodCallout(
                        id: "story",
                        title: "Bonsai World principle",
                        body: "Deadwood should tell the story of the tree. It should not look like decoration added after the story was finished."
                    )
                ]
            ),
            DeadwoodSection(
                id: "living-and-dead",
                heading: "Living structure and dead structure",
                paragraphs: [
                    "A bonsai is a living plant. Deadwood is dead, weathered or naturally exposed wood that remains part of that plant. In bonsai it may appear as a dead branch, exposed trunk wood, a hollow, a scarred section or weathered remains of former growth.",
                    "Deadwood should be understood as part of the tree. Not as a separate decoration applied to its surface."
                ],
                bullets: [],
                callouts: []
            ),
            DeadwoodSection(
                id: "why",
                heading: "Why deadwood is used",
                paragraphs: [
                    "Deadwood may help communicate age: the tree has existed through time and change. Survival: the tree has lost part of its structure but continued to live. Character: the tree may appear more individual and recognisable. Contrast: living foliage and living veins may stand against old dead structure. Movement: deadwood may help reveal direction through the trunk.",
                    "Deadwood is not required for an impressive bonsai. Many excellent bonsai do not need any deadwood."
                ],
                bullets: [],
                callouts: [
                    DeadwoodCallout(
                        id: "not-required",
                        title: "Bonsai World principle",
                        body: "Add deadwood because the tree benefits from it. Not because bonsai is expected to have it."
                    )
                ]
            )
        ]
    )

    // MARK: - 02 Reading the Tree

    private static let readingTheTree = DeadwoodLesson(
        id: "reading-the-tree",
        number: 2,
        title: "Reading the Tree",
        summary: "The tree may already contain the beginning of its own story.",
        sections: [
            DeadwoodSection(
                id: "observe",
                heading: "Deadwood begins with observation",
                paragraphs: [
                    "Before creating deadwood, study natural scars, existing dead branches, broken sections, old pruning scars, trunk movement, existing hollows and natural live veins.",
                    "Ask whether the tree already suggests a story. Often the most convincing deadwood begins with something already present."
                ],
                bullets: [],
                callouts: []
            ),
            DeadwoodSection(
                id: "natural",
                heading: "Work with what already exists",
                paragraphs: [
                    "Natural deadwood is often the strongest starting point: naturally dead branches, old scars, storm damage, broken leaders, weathered trunk sections.",
                    "Where appropriate, existing character should be preserved rather than removed and recreated. The artist should not automatically ask where deadwood can be added. Ask what this tree already offers."
                ],
                bullets: [],
                callouts: [
                    DeadwoodCallout(
                        id: "already",
                        title: "Bonsai World principle",
                        body: "The tree may already contain the beginning of its own story."
                    )
                ]
            )
        ]
    )

    // MARK: - 03 Jin

    private static let jin = DeadwoodLesson(
        id: "jin",
        number: 3,
        title: "Jin",
        summary: "A jin is a dead branch or branch section. Believable character matters more than perfect geometry.",
        sections: [
            DeadwoodSection(
                id: "dead-branch",
                heading: "The dead branch",
                paragraphs: [
                    "Jin represents a branch or branch section that is no longer living. A convincing jin should relate to branch position, tree movement, existing structure, species and natural exposure.",
                    "A jin should not simply appear as a smooth pointed stick attached to a trunk. Natural dead branches often show irregularity, fibre, breakage, weathering and direction.",
                    "The purpose is to create believable character. Not perfect geometry. Pruning covers whether a dead branch should remain as structure or be removed. This lesson asks whether the remaining wood still tells a story."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )

    // MARK: - 04 Shari

    private static let shari = DeadwoodLesson(
        id: "shari",
        number: 4,
        title: "Shari",
        summary: "Exposed deadwood along the trunk should follow the tree. It should not become a decorative stripe.",
        sections: [
            DeadwoodSection(
                id: "exposed",
                heading: "Exposed deadwood along the trunk",
                paragraphs: [
                    "Shari is an area of exposed deadwood along the trunk or major structure. A shari may follow trunk movement, reveal live veins, suggest historical damage and strengthen visual age.",
                    "The relationship between living vein and deadwood is often visually important. A convincing shari should feel connected to the structure of the tree.",
                    "Avoid treating shari as a random decorative stripe. If the line does not follow grain, movement or a believable event, the eye will read it as drawing rather than history."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )

    // MARK: - 05 Uro

    private static let uro = DeadwoodLesson(
        id: "uro",
        number: 5,
        title: "Uro",
        summary: "A hollow can add depth and age. It should not become the subject of the tree.",
        sections: [
            DeadwoodSection(
                id: "hollows",
                heading: "Hollows and natural cavities",
                paragraphs: [
                    "An uro may suggest an old branch loss, decay, natural damage or long-term weathering. Hollows can add depth, age and visual interest.",
                    "An artificial hollow can quickly become distracting if it appears too clean, too symmetrical, too deep for the tree, or unrelated to the surrounding structure.",
                    "The hollow should support the tree. The tree should not become a frame for displaying the hollow. Advanced Techniques asks whether hollowing is justified. This lesson asks whether the cavity still belongs to the story."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )

    // MARK: - 06 Species & Health

    private static let speciesAndHealth = DeadwoodLesson(
        id: "species-health",
        number: 6,
        title: "Species & Health",
        summary: "The living tree comes before the deadwood design. Species knowledge should guide the decision.",
        sections: [
            DeadwoodSection(
                id: "species",
                heading: "Not every species uses deadwood in the same way",
                paragraphs: [
                    "Deadwood can be especially visually important on species where natural deadwood persists, weathers visibly and becomes part of the tree's natural appearance. Other species may decay differently, heal differently, or appear less convincing with extensive artificial deadwood.",
                    "Consider the natural behaviour of the species, bark characteristics, wood characteristics, natural habitat and how dead branches normally age. Species Library belongs in that judgement."
                ],
                bullets: [],
                callouts: []
            ),
            DeadwoodSection(
                id: "health",
                heading: "Design must respect biology",
                paragraphs: [
                    "Deadwood work must never be treated as purely visual. Living tissue supports the tree. Deadwood is not separate from the biological structure surrounding it.",
                    "Before major work, consider tree health, tree strength, existing live structure, recent work and recovery needs. Do not perform unnecessary major work on a weak tree. Tree Health covers diagnosis and recovery. Advanced Techniques covers why stacking major work is a problem."
                ],
                bullets: [],
                callouts: [
                    DeadwoodCallout(
                        id: "living-first",
                        title: "Bonsai World principle",
                        body: "The living tree comes before the deadwood design."
                    )
                ]
            )
        ]
    )

    // MARK: - 07 Design, Movement & Age

    private static let designMovementAndAge = DeadwoodLesson(
        id: "design-movement-age",
        number: 7,
        title: "Design, Movement & Age",
        summary: "Deadwood can support age. It cannot replace it. Follow the tree.",
        sections: [
            DeadwoodSection(
                id: "composition",
                heading: "Deadwood must support the composition",
                paragraphs: [
                    "Deadwood can influence direction, movement, balance, age and visual weight. Ask whether it improves the silhouette, strengthens the story, competes with the living structure, or leaves the eye unsure where to look.",
                    "Deadwood should normally help guide the eye through the composition. It should not create unnecessary visual noise. Design Guidelines and Bonsai Artistry & the Bonsai Eye belong in that reading."
                ],
                bullets: [],
                callouts: []
            ),
            DeadwoodSection(
                id: "movement",
                heading: "Follow the tree",
                paragraphs: [
                    "Deadwood often becomes more convincing when it follows trunk movement, existing grain, natural fractures and structural changes.",
                    "Avoid adding movement that contradicts the character of the tree. The best result often comes from understanding the existing structure, then revealing or strengthening what is already suggested. Wiring covers living movement. This lesson covers whether deadwood still belongs to that movement."
                ],
                bullets: [],
                callouts: []
            ),
            DeadwoodSection(
                id: "age",
                heading: "Age is more than damage",
                paragraphs: [
                    "Deadwood can suggest age. Deadwood alone does not make a tree look old. Visual age also comes from trunk development, nebari, branch structure, bark, ramification and silhouette.",
                    "A young-looking trunk with excessive artificial deadwood may create a contradiction."
                ],
                bullets: [],
                callouts: [
                    DeadwoodCallout(
                        id: "cannot-replace",
                        title: "Bonsai World principle",
                        body: "Deadwood can support age. It cannot replace it."
                    )
                ]
            )
        ]
    )

    // MARK: - 08 Life, Death & Visual Language

    private static let lifeDeathAndLanguage = DeadwoodLesson(
        id: "life-death-language",
        number: 8,
        title: "Life, Death & Visual Language",
        summary: "The living structure must remain understandable. Deadwood must belong to the tree's visual language.",
        sections: [
            DeadwoodSection(
                id: "contrast",
                heading: "Living veins and dead structure",
                paragraphs: [
                    "One of the strongest visual effects in deadwood bonsai is the contrast between living growth and old dead structure. This contrast can create a powerful sense of survival, movement and time.",
                    "The living structure must remain visually understandable. Do not create so much deadwood that the tree's living structure becomes confusing."
                ],
                bullets: [],
                callouts: []
            ),
            DeadwoodSection(
                id: "language",
                heading: "Naturalistic and stylised deadwood",
                paragraphs: [
                    "Deadwood may be highly naturalistic, or more deliberately stylised. The choice should remain consistent with the overall character of the tree.",
                    "A highly refined formal tree and a rugged mountain-style tree may use deadwood differently. Ask what visual language this tree already has — then whether the deadwood belongs to that language. Design Guidelines are strongest on classical trees. Bonsai Artistry decides when a guideline should yield."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )

    // MARK: - 09 Carving, Texture, Scale & Balance

    private static let carvingTextureAndScale = DeadwoodLesson(
        id: "carving-texture-scale",
        number: 9,
        title: "Carving, Texture & Scale",
        summary: "Carving should reveal character. Not demonstrate that carving was performed.",
        sections: [
            DeadwoodSection(
                id: "carving",
                heading: "Reveal, do not decorate",
                paragraphs: [
                    "Carving may be used to refine existing deadwood, reveal natural grain, improve transitions, reduce artificial surfaces and develop existing scars. The purpose should not be adding complexity for its own sake.",
                    "Tools & Equipment covers carving equipment and why power is not a shortcut to artistic quality. Advanced Techniques asks whether major removal is justified. This lesson asks what the wood should say."
                ],
                bullets: [],
                callouts: [
                    DeadwoodCallout(
                        id: "reveal",
                        title: "Bonsai World principle",
                        body: "Carving should reveal character. Not demonstrate that carving was performed."
                    )
                ]
            ),
            DeadwoodSection(
                id: "texture",
                heading: "Avoiding artificial surfaces",
                paragraphs: [
                    "Natural deadwood rarely appears perfectly smooth, perfectly symmetrical or perfectly repeated. Natural texture may suggest fibre, weathering, breakage, erosion and age.",
                    "Texture should support the scale of the tree. Fine trees may require finer visual detail. Large rugged trees may support stronger texture. Avoid using one repeated texture across every area."
                ],
                bullets: [],
                callouts: []
            ),
            DeadwoodSection(
                id: "scale-balance",
                heading: "Deadwood must belong to the tree",
                paragraphs: [
                    "The size of deadwood should make sense relative to trunk size, tree age, species and overall design. Too little may have no visual purpose. Too much may dominate the composition. Step back and ask whether the tree is still the subject, or whether the deadwood has become the subject.",
                    "A common mistake is adding more, and then more. Not every branch needs a jin. Not every trunk needs shari. Not every scar needs enhancement. Negative space and living structure are part of the composition."
                ],
                bullets: [],
                callouts: [
                    DeadwoodCallout(
                        id: "untouched",
                        title: "Bonsai World principle",
                        body: "What is left untouched can be as important as what is carved."
                    )
                ]
            )
        ]
    )

    // MARK: - 10 Weathering, Preservation & Water

    private static let weatheringAndPreservation = DeadwoodLesson(
        id: "weathering-preservation",
        number: 10,
        title: "Weathering & Preservation",
        summary: "Deadwood requires observation. Not automatic treatment. Do not force decades of character into one session.",
        sections: [
            DeadwoodSection(
                id: "time",
                heading: "Deadwood should feel believable",
                paragraphs: [
                    "Natural deadwood changes over time. It may be affected by rain, sun, wind, frost and natural weathering. The visual goal should not necessarily be to create an instantly finished appearance.",
                    "Allow the design to develop. Avoid trying to force decades of character into one session."
                ],
                bullets: [],
                callouts: []
            ),
            DeadwoodSection(
                id: "preservation",
                heading: "Protecting the dead structure",
                paragraphs: [
                    "Deadwood may require maintenance depending on species, climate, exposure and the condition of the wood. Deadwood requires observation. Not automatic treatment.",
                    "Specific preservation methods and products are not universal requirements. Species and local conditions may differ. This chapter does not name products."
                ],
                bullets: [],
                callouts: []
            ),
            DeadwoodSection(
                id: "water",
                heading: "Moisture and exposure",
                paragraphs: [
                    "Moisture exposure can influence how deadwood changes. Consider rain exposure, drainage, air movement and local climate. Observe changes, decay and surface condition.",
                    "Deadwood care should remain connected to the health and environment of the entire tree. Seasonal Care & Protection and Watering belong in that context."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )

    // MARK: - 11 Display & When Not To

    private static let displayAndRestraint = DeadwoodLesson(
        id: "display-and-restraint",
        number: 11,
        title: "Display & When Not To",
        summary: "A missing feature is not always a missing opportunity. The complete composition must remain stronger.",
        sections: [
            DeadwoodSection(
                id: "display",
                heading: "How deadwood changes the presentation",
                paragraphs: [
                    "Deadwood may influence viewing angle, front selection, visual balance, pot choice and overall character. A dramatic deadwood feature may help determine the most effective front.",
                    "Do not choose a front only because it displays the most deadwood. The complete composition must remain stronger. Design Guidelines: deadwood must be visible from the front if it is doing any work. Display & Presentation covers the composed tree."
                ],
                bullets: [],
                callouts: []
            ),
            DeadwoodSection(
                id: "when-not",
                heading: "Knowing when to leave the tree alone",
                paragraphs: [
                    "Deadwood may not be appropriate when the tree is weak, the design does not require it, the species does not support the intended appearance, existing structure is already visually complete, or deadwood would distract from natural character.",
                    "Doing nothing can be the correct design decision."
                ],
                bullets: [],
                callouts: [
                    DeadwoodCallout(
                        id: "missing",
                        title: "Bonsai World principle",
                        body: "A missing feature is not always a missing opportunity."
                    )
                ]
            )
        ]
    )

    // MARK: - 12 Practice

    private static let practice = DeadwoodLesson(
        id: "practice",
        number: 12,
        title: "Practice",
        summary: "Before changing deadwood, ask whether the tree needs it — and whether leaving it unchanged would be stronger.",
        sections: [
            DeadwoodSection(
                id: "mistakes",
                heading: "Common deadwood mistakes",
                paragraphs: [
                    "Adding deadwood to make a tree look instantly old. Creating perfectly smooth or symmetrical jin. Adding shari without considering trunk movement. Creating deadwood unrelated to the tree's story. Ignoring the living structure.",
                    "Doing major deadwood work on a weak tree. Adding too much. Repeating identical textures. Allowing deadwood to dominate the composition. Trying to make a new tree look ancient overnight."
                ],
                bullets: [],
                callouts: []
            ),
            DeadwoodSection(
                id: "framework",
                heading: "The deadwood decision framework",
                paragraphs: [
                    "Before creating or changing deadwood, walk these questions. The last question is as important as the first."
                ],
                bullets: [
                    "Does this tree need deadwood?",
                    "What natural event could this feature represent?",
                    "Does the species support this appearance?",
                    "Is the tree healthy enough?",
                    "Does the feature follow the tree's structure?",
                    "Does it improve the design?",
                    "Will it still make sense when the tree develops further?",
                    "Would leaving the tree unchanged produce a stronger result?"
                ],
                callouts: []
            ),
            DeadwoodSection(
                id: "paths",
                heading: "Beginner, intermediate and advanced",
                paragraphs: [
                    "Beginner — learn to recognise jin, shari and uro. Observe natural deadwood. Understand why less is often more. Do not feel pressure to create deadwood.",
                    "Intermediate — develop design judgement, the relationship between deadwood and trunk movement, and understanding of species suitability.",
                    "Advanced — natural storytelling, complex relationships between living veins and deadwood, and long-term refinement and integration."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )

    // MARK: - 13 Quick Guides

    private static let quickGuides = DeadwoodLesson(
        id: "quick-guides",
        number: 13,
        title: "Quick Guides",
        summary: "The most convincing deadwood does not ask the viewer to look at what was carved. It makes the viewer think something happened to this tree.",
        sections: [
            DeadwoodSection(
                id: "cards",
                heading: "Quick knowledge cards",
                paragraphs: [],
                bullets: [],
                callouts: [
                    DeadwoodCallout(
                        id: "card-story",
                        title: "Tell the tree's story",
                        body: "Deadwood should feel like part of the tree's history."
                    ),
                    DeadwoodCallout(
                        id: "card-life",
                        title: "Life comes first",
                        body: "The living tree is more important than the deadwood."
                    ),
                    DeadwoodCallout(
                        id: "card-less",
                        title: "Less can be stronger",
                        body: "Deadwood does not need to appear everywhere."
                    ),
                    DeadwoodCallout(
                        id: "card-follow",
                        title: "Follow the structure",
                        body: "Grain, movement and existing character often provide the best direction."
                    ),
                    DeadwoodCallout(
                        id: "card-time",
                        title: "Do not fake time",
                        body: "Character develops through design, growth and observation."
                    )
                ]
            ),
            DeadwoodSection(
                id: "connections",
                heading: "Connections to other Bonsai World knowledge",
                paragraphs: [
                    "Design Guidelines — composition, movement, balance and whether deadwood is visible from the front.",
                    "Bonsai Forms, Styles & Silhouette — whether deadwood supports the silhouette or becomes the subject.",
                    "Bonsai Artistry & the Bonsai Eye — whether the feature still looks like a convincing tree.",
                    "Advanced Techniques — carving, hollowing and whether major work is justified.",
                    "Pruning — branch selection and dead branch decisions.",
                    "Wiring — structural movement and design development.",
                    "Tree Health — tree strength, recovery and living tissue.",
                    "Species Library — species suitability and how deadwood ages on this plant.",
                    "Tools & Equipment — carving equipment; power is not a shortcut to quality.",
                    "Display & Presentation — front, viewing angle and whether deadwood has become the subject.",
                    "Bonsai Material & Sourcing — yamadori recovery: existing deadwood may already tell the story. Do not improve it until recovery and character are understood.",
                ],
                bullets: [],
                callouts: []
            ),
            DeadwoodSection(
                id: "closing",
                heading: "Final Bonsai World principle",
                paragraphs: [
                    "Deadwood is not the absence of life. In bonsai, it can become evidence of life. A broken branch. A lost leader. A damaged trunk. A tree that continued to grow.",
                    "The purpose of deadwood is not to make a bonsai look older than it is. It is to help the tree communicate character, survival and time.",
                    "The most convincing deadwood does not ask: look what was carved. It makes the viewer think: something happened to this tree."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )
}
