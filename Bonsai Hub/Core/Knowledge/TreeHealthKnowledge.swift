//
//  TreeHealthKnowledge.swift
//  Bonsai World
//
//  Knowledge → Bonsai Handbook → Tree Health.
//  Observe, investigate, then act. How-to for watering, soil, feeding and
//  repotting lives in those chapters. Care → Health is the practical surface.
//

import Foundation

struct TreeHealthCallout: Identifiable, Hashable, Sendable {
    var id: String
    var title: String
    var body: String
}

struct TreeHealthSection: Identifiable, Hashable, Sendable {
    var id: String
    var heading: String
    var paragraphs: [String]
    var bullets: [String]
    var callouts: [TreeHealthCallout]
}

struct TreeHealthLesson: Identifiable, Hashable, Sendable {
    var id: String
    var number: Int
    var title: String
    var summary: String
    var sections: [TreeHealthSection]
}

enum TreeHealthKnowledge {
    static let chapterTitle = "Tree Health"

    static let openingLine =
        "Understanding problems early and making better decisions for healthier bonsai."

    static let disclaimer =
        "Similar symptoms may have different causes. This chapter trains observation, not plant pathology. It does not prescribe chemical treatments. Species, season, climate and the tree’s history always matter. Care → Health is the practical surface in the programme."

    static let lessons: [TreeHealthLesson] = [
        overview,
        earlyWarning,
        diagnosticFramework,
        waterProblems,
        rootHealth,
        environmentalStress,
        nutrientProblems,
        pests,
        diseasesAndSymptoms,
        stressAfterWork,
        preventionAndResponse,
        practice,
        quickGuides
    ]

    static func lesson(id: String) -> TreeHealthLesson? {
        lessons.first { $0.id == id }
    }

    // MARK: - 01 Overview

    private static let overview = TreeHealthLesson(
        id: "overview",
        number: 1,
        title: "Overview",
        summary: "The best time to notice a problem is before it becomes a crisis.",
        sections: [
            TreeHealthSection(
                id: "communicating",
                heading: "A healthy bonsai is communicating",
                paragraphs: [
                    "Changes in leaves, needles, growth, bark, roots, soil and water use may provide important information. Good health management is not constantly searching for problems. It is learning what is normal.",
                    "When you understand how a healthy tree normally looks and behaves, unusual changes become easier to recognise.",
                    "Three questions organise this chapter. What is happening to my tree? What may be causing it? What should I do next?"
                ],
                bullets: [],
                callouts: [
                    TreeHealthCallout(
                        id: "before-crisis",
                        title: "Bonsai World principle",
                        body: "The best time to notice a problem is before it becomes a crisis."
                    )
                ]
            ),
            TreeHealthSection(
                id: "healthy",
                heading: "What does a healthy bonsai look like?",
                paragraphs: [
                    "A healthy bonsai generally shows characteristics appropriate for its species, its season and its development stage. Possible signs include appropriate growth, healthy foliage colour, stable water uptake, normal seasonal behaviour, strong root activity and no obvious pest damage.",
                    "Healthy does not mean constantly growing. Many trees naturally slow down during parts of the year. Always consider species, season and environment. Species Library describes seasonal behaviour. Garden → Trees holds the individual baseline."
                ],
                bullets: [],
                callouts: [
                    TreeHealthCallout(
                        id: "cause-first",
                        title: "Bonsai World principle",
                        body: "Do not treat a symptom before trying to understand the cause."
                    )
                ]
            ),
            TreeHealthSection(
                id: "baseline",
                heading: "Know what is normal",
                paragraphs: [
                    "Learn how much water a tree normally uses, how its foliage normally looks, when it grows, when it rests, and when it naturally changes colour. The more familiar you become with a tree, the easier it becomes to recognise change."
                ],
                bullets: [],
                callouts: [
                    TreeHealthCallout(
                        id: "know-the-tree",
                        title: "Bonsai World principle",
                        body: "Health problems are easier to recognise when you know the tree before it becomes unhealthy."
                    )
                ]
            )
        ]
    )

    // MARK: - 02 Early Warning Signs

    private static let earlyWarning = TreeHealthLesson(
        id: "early-warning",
        number: 2,
        title: "Early Warning Signs",
        summary: "One symptom does not automatically provide one diagnosis. Observe, investigate, then respond.",
        sections: [
            TreeHealthSection(
                id: "signs",
                heading: "Possible warning signs",
                paragraphs: [
                    "Unexpected leaf drop, yellowing, browning, wilting, weak growth, unusual spots, distorted leaves, pest activity and sudden changes in water consumption all deserve attention.",
                    "Yellow leaves do not automatically mean nutrient deficiency. Leaf drop does not automatically mean disease. Weak growth does not automatically mean lack of fertilizer. The user must investigate before treating."
                ],
                bullets: [],
                callouts: [
                    TreeHealthCallout(
                        id: "not-diagnosis",
                        title: "Bonsai World principle",
                        body: "Symptoms are information. They are not automatically diagnoses."
                    )
                ]
            )
        ]
    )

    // MARK: - 03 Diagnostic Framework

    private static let diagnosticFramework = TreeHealthLesson(
        id: "diagnostic-framework",
        number: 3,
        title: "Diagnostic Framework",
        summary: "Diagnosis begins with observation, not treatment.",
        sections: [
            TreeHealthSection(
                id: "questions",
                heading: "Before treating a problem, ask",
                paragraphs: [
                    "What exactly has changed? When did the change begin? Has anything changed in watering, environment, soil, fertilizing, temperature or light?",
                    "Is the problem affecting one leaf, one branch, part of the tree, or the entire tree? Can you see pests, damage, root problems or soil problems? Is this normal seasonal behaviour?"
                ],
                bullets: [
                    "What exactly has changed?",
                    "When did the change begin?",
                    "Has watering, environment, soil, fertilizing, temperature or light changed?",
                    "One leaf, one branch, part of the tree, or the entire tree?",
                    "Can you see pests, damage, root problems or soil problems?",
                    "Is this normal seasonal behaviour?"
                ],
                callouts: [
                    TreeHealthCallout(
                        id: "observation-first",
                        title: "Bonsai World principle",
                        body: "Diagnosis begins with observation, not treatment."
                    )
                ]
            )
        ]
    )

    // MARK: - 04 Water-Related Problems

    private static let waterProblems = TreeHealthLesson(
        id: "water-problems",
        number: 4,
        title: "Water-Related Problems",
        summary: "Both dry roots and damaged roots may wilt. The correct response depends on the cause.",
        sections: [
            TreeHealthSection(
                id: "too-much-too-little",
                heading: "Too much, too little or something else?",
                paragraphs: [
                    "Water-related problems are among the most common causes of bonsai stress. Possible issues include underwatering, prolonged waterlogging, poor drainage, uneven watering, and root damage affecting water uptake.",
                    "Symptoms may look similar. Both dry roots and damaged roots may lead to wilting. Adding more water to every wilting tree is a common mistake.",
                    "Watering in this Handbook covers observation of the tree and substrate. Soil & Substrate covers drainage and air. Repotting covers when the root environment itself is the problem. Care → Watering is the practical surface."
                ],
                bullets: [],
                callouts: [
                    TreeHealthCallout(
                        id: "wilt",
                        title: "Bonsai World principle",
                        body: "Wilting is a symptom. Drought and damaged roots can look the same from above."
                    )
                ]
            )
        ]
    )

    // MARK: - 05 Root Health

    private static let rootHealth = TreeHealthLesson(
        id: "root-health",
        number: 5,
        title: "Root Health",
        summary: "Many health problems begin below the soil surface. Do not disturb the roots to satisfy curiosity.",
        sections: [
            TreeHealthSection(
                id: "hidden",
                heading: "The hidden half of the tree",
                paragraphs: [
                    "Root problems may be associated with poor drainage, compacted soil, root damage, excessive moisture and repotting stress. A leaf problem may begin below the soil.",
                    "Roots should not be disturbed simply to check them. Root inspection should occur when there is a valid reason — declining vigour that other checks cannot explain, a known waterlogging event, or planned repotting.",
                    "Repotting and Soil & Substrate cover the work and the substrate. This lesson is the restraint: look at water use, drainage and the tree above ground first."
                ],
                bullets: [],
                callouts: [
                    TreeHealthCallout(
                        id: "curiosity",
                        title: "Bonsai World principle",
                        body: "Do not disturb the roots to satisfy curiosity."
                    )
                ]
            )
        ]
    )

    // MARK: - 06 Environmental Stress

    private static let environmentalStress = TreeHealthLesson(
        id: "environmental-stress",
        number: 6,
        title: "Environmental Stress",
        summary: "Not every damaged tree is diseased. Sometimes the environment is the problem.",
        sections: [
            TreeHealthSection(
                id: "environment",
                heading: "The tree responds to its environment",
                paragraphs: [
                    "Possible environmental stress includes excessive heat, frost, strong wind, sudden environmental change, insufficient light, and excessive sun for sensitive material.",
                    "Not every damaged tree is diseased. Sometimes the environment is the problem. Care → Seasonal Care and Care → Winter Care are the programme surfaces. Watering covers weather and wind as they change water use. Species Library remains species-specific."
                ],
                bullets: [],
                callouts: [
                    TreeHealthCallout(
                        id: "not-disease",
                        title: "Bonsai World principle",
                        body: "Not every damaged tree is diseased. Sometimes the environment is the problem."
                    )
                ]
            )
        ]
    )

    // MARK: - 07 Nutrient-Related Problems

    private static let nutrientProblems = TreeHealthLesson(
        id: "nutrient-problems",
        number: 7,
        title: "Nutrient-Related Problems",
        summary: "More fertilizer is not always the answer. Weak growth has more than one cause.",
        sections: [
            TreeHealthSection(
                id: "not-always-feed",
                heading: "More fertilizer is not always the answer",
                paragraphs: [
                    "Weak growth or leaf colour changes may be related to nutrient availability, root problems, soil conditions, watering or seasonal behaviour. Do not add fertilizer automatically.",
                    "Fertilizing in this Handbook and Fertilizer Guides cover feeding when the tree can use it. This lesson is the pause: yellow leaves and weak growth are not a feeding order. Care → Fertilizing is the practical surface."
                ],
                bullets: [],
                callouts: [
                    TreeHealthCallout(
                        id: "not-feed",
                        title: "Bonsai World principle",
                        body: "Do not use more fertilizer to solve weak growth until you understand the cause."
                    )
                ]
            )
        ]
    )

    // MARK: - 08 Pests

    private static let pests = TreeHealthLesson(
        id: "pests",
        number: 8,
        title: "Pests",
        summary: "The goal is recognition, monitoring and appropriate response — not an encyclopaedia of insects.",
        sections: [
            TreeHealthSection(
                id: "visitors",
                heading: "Recognising unwanted visitors",
                paragraphs: [
                    "Common pest categories on bonsai include aphids, scale insects, spider mites, mealybugs, caterpillars and other chewing insects. This is not an exhaustive catalogue.",
                    "Focus on recognising visible insects, leaf damage, sticky residue, distorted growth and fine webbing where relevant. Correct identification comes before any product. This chapter does not prescribe treatments."
                ],
                bullets: [],
                callouts: []
            ),
            TreeHealthSection(
                id: "inspection",
                heading: "Look closely",
                paragraphs: [
                    "Inspect new growth, undersides of leaves, branch junctions, bark and the soil surface. Early detection is usually easier to manage than a severe infestation.",
                    "Regular inspection is one of the most useful health tools. Bonsai Collection Management covers walking the benches. Care → Health lists trees that already need attention."
                ],
                bullets: [],
                callouts: [
                    TreeHealthCallout(
                        id: "early",
                        title: "Bonsai World principle",
                        body: "Small problems are easier to manage when they are found early."
                    )
                ]
            )
        ]
    )

    // MARK: - 09 Diseases & Visible Symptoms

    private static let diseasesAndSymptoms = TreeHealthLesson(
        id: "diseases-symptoms",
        number: 9,
        title: "Diseases & Visible Symptoms",
        summary: "Many symptoms that look like disease may be stress, roots or watering. Do not diagnose from one photograph.",
        sections: [
            TreeHealthSection(
                id: "disease",
                heading: "When the problem may be biological",
                paragraphs: [
                    "Possible problems may involve fungal issues, bacterial issues or other plant pathogens. Visible warning signs include persistent spots, unusual discolouration, dieback and unusual growth.",
                    "Many symptoms that look like disease may also be caused by environmental stress, root problems or watering problems. Do not diagnose based on one photograph or one symptom. This chapter does not name chemical protocols."
                ],
                bullets: [],
                callouts: []
            ),
            TreeHealthSection(
                id: "foliage",
                heading: "Leaf and needle problems",
                paragraphs: [
                    "Foliage is the most visible warning system: yellowing, browning, spots, wilting, premature leaf drop. Examine pattern, timing, location and speed of change.",
                    "Is the problem old foliage or new foliage? One branch or the whole tree? Patterns often provide more useful information than colour alone."
                ],
                bullets: [],
                callouts: []
            ),
            TreeHealthSection(
                id: "dieback",
                heading: "Branch dieback",
                paragraphs: [
                    "Branch dieback may be associated with damage, root problems, disease, environmental stress or structural problems. Investigate the wider tree. Cutting away the dead branch does not by itself solve the original problem."
                ],
                bullets: [],
                callouts: []
            ),
            TreeHealthSection(
                id: "bark",
                heading: "Bark and trunk",
                paragraphs: [
                    "Observe damage, cracks, unusual discolouration, insect activity and areas of dieback. Distinguish natural character from new or developing problems. Design Guidelines and Bonsai Artistry cover character that belongs on the tree."
                ],
                bullets: [],
                callouts: [
                    TreeHealthCallout(
                        id: "whole",
                        title: "Bonsai World principle",
                        body: "A leaf problem may begin below the soil. Check the whole tree."
                    )
                ]
            )
        ]
    )

    // MARK: - 10 Stress After Work

    private static let stressAfterWork = TreeHealthLesson(
        id: "stress-after-work",
        number: 10,
        title: "Stress After Work",
        summary: "The tree needs time to respond. Avoid adding unnecessary stress during recovery.",
        sections: [
            TreeHealthSection(
                id: "recovery",
                heading: "The tree needs time to respond",
                paragraphs: [
                    "Bonsai work may create temporary stress: repotting, heavy pruning, major wiring, styling, air layering. Recovery should be monitored. Avoid adding unnecessary additional stress during recovery.",
                    "Advanced Techniques covers why stacking major work is a problem. Repotting, Pruning and Wiring cover the work itself. Aftercare is observation, not a second round of technique. Care → Health shows trees marked Recovering."
                ],
                bullets: [],
                callouts: [
                    TreeHealthCallout(
                        id: "stack",
                        title: "Bonsai World principle",
                        body: "Do not stack treatments or major work without understanding their combined effect."
                    )
                ]
            )
        ]
    )

    // MARK: - 11 Prevention, Quarantine & Response

    private static let preventionAndResponse = TreeHealthLesson(
        id: "prevention-response",
        number: 11,
        title: "Prevention, Quarantine & Response",
        summary: "Intervention should be appropriate, targeted and necessary. Observation can be the correct response.",
        sections: [
            TreeHealthSection(
                id: "prevention",
                heading: "Prevention is part of bonsai care",
                paragraphs: [
                    "Healthy collection habits may include regular inspection, good airflow, appropriate watering, clean working practices, removing seriously affected material where appropriate, and monitoring new trees.",
                    "The goal is not a sterile collection. The goal is reducing unnecessary risk. Tools & Equipment covers tool hygiene. Bonsai Collection Management covers walking the benches."
                ],
                bullets: [],
                callouts: []
            ),
            TreeHealthSection(
                id: "quarantine",
                heading: "Protecting the rest of the collection",
                paragraphs: [
                    "New or potentially affected trees may require separation from the main collection. Quarantine can help reduce the spread of pests and disease. The exact approach depends on the suspected problem, the collection and the environment.",
                    "Bonsai Collection Management covers quarantine as a zone and as intake. Bonsai Material & Sourcing covers inspection before purchase. Quarantine is a location and a period of observation — not a health label on the tree profile."
                ],
                bullets: [],
                callouts: []
            ),
            TreeHealthSection(
                id: "treat",
                heading: "When to treat",
                paragraphs: [
                    "Before treatment, try to understand what problem is being treated. Avoid treating every tree preventively with unnecessary products. Intervention should be appropriate, targeted and necessary.",
                    "This chapter does not list products or doses. Identify the problem. Then choose a response you understand — including asking someone who does."
                ],
                bullets: [],
                callouts: []
            ),
            TreeHealthSection(
                id: "monitor",
                heading: "When to monitor",
                paragraphs: [
                    "Not every change requires action. Some changes are seasonal, temporary or minor. Ask: is the problem getting worse? Is the tree otherwise healthy? Is this normal for the species and season?"
                ],
                bullets: [],
                callouts: [
                    TreeHealthCallout(
                        id: "observation-work",
                        title: "Bonsai World principle",
                        body: "Observation is not doing nothing. Observation is collecting information."
                    )
                ]
            ),
            TreeHealthSection(
                id: "help",
                heading: "When to seek additional help",
                paragraphs: [
                    "Seek additional advice when the tree declines rapidly, the cause cannot be identified, valuable trees are involved, or a problem spreads through the collection.",
                    "Possible sources include experienced local bonsai artists, bonsai clubs and qualified horticultural professionals. The goal is not to pretend that every problem can be diagnosed from a checklist."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )

    // MARK: - 12 Practice

    private static let practice = TreeHealthLesson(
        id: "practice",
        number: 12,
        title: "Practice",
        summary: "Record what happened. Photograph the problem. Then watch whether it improves.",
        sections: [
            TreeHealthSection(
                id: "records",
                heading: "Health records",
                paragraphs: [
                    "Record symptoms, dates, changes, treatment where used, and recovery. That information may help identify patterns, repeated problems and successful approaches.",
                    "Garden → Trees is the profile. Health on the tree uses Thriving, Stable, Needs Attention and Recovering. Care → Health lists trees that need attention or are recovering, plus health tasks due. Do not invent a second health system."
                ],
                bullets: [],
                callouts: []
            ),
            TreeHealthSection(
                id: "photos",
                heading: "Photographing health problems",
                paragraphs: [
                    "Photograph the whole tree, the affected area, and close details where useful. Photographs help compare before, during and after. Media → Images is the photographic surface."
                ],
                bullets: [],
                callouts: []
            ),
            TreeHealthSection(
                id: "collection",
                heading: "Collection-wide health",
                paragraphs: [
                    "As a collection grows, health management becomes more difficult. Thinking in Healthy, Monitor, Treatment, Recovery and Quarantine can help you walk the benches.",
                    "Record the status the tree profile already understands so Dashboard, Care and Tasks stay in agreement: Thriving and Stable for trees with no known problem; Needs Attention when an issue is being watched or treated; Recovering when the tree is coming back from stress or work. Quarantine remains a place and a process, described in Bonsai Collection Management."
                ],
                bullets: [],
                callouts: []
            ),
            TreeHealthSection(
                id: "mistakes",
                heading: "Common health management mistakes",
                paragraphs: [
                    "Treating before understanding. Assuming every yellow leaf means nutrient deficiency. Adding more water to every wilting tree. Using more fertilizer to solve weak growth. Ignoring changes because the tree still looks mostly healthy.",
                    "Ignoring the roots. Treating symptoms but not the cause. Bringing potentially affected trees directly into the collection. Stacking multiple treatments without understanding their effect. Forgetting to monitor after intervention."
                ],
                bullets: [],
                callouts: []
            ),
            TreeHealthSection(
                id: "check",
                heading: "A simple tree health check",
                paragraphs: [
                    "When inspecting a bonsai, work through the whole tree. Foliage: does it look normal for the species and season? Growth: is development appropriate? Water use: has the requirement changed? Soil: is drainage behaving normally?",
                    "Trunk: visible changes or damage? Branches: unexpected dieback? Pests: insects or damage? Environment: has anything changed around the tree?"
                ],
                bullets: [
                    "Foliage — normal for species and season?",
                    "Growth — appropriate development?",
                    "Water use — has the requirement changed?",
                    "Soil — is drainage behaving normally?",
                    "Trunk — visible changes or damage?",
                    "Branches — unexpected dieback?",
                    "Pests — insects or damage?",
                    "Environment — has anything changed around the tree?"
                ],
                callouts: []
            ),
            TreeHealthSection(
                id: "paths",
                heading: "Beginner, intermediate and advanced",
                paragraphs: [
                    "Beginner — recognise normal behaviour, inspect trees, identify obvious warning signs. Like a change is a start. Why is the skill.",
                    "Intermediate — compare possible causes, identify patterns, monitor recovery. Use Care → Health and the tree’s record.",
                    "Advanced — species-specific understanding, collection-wide health awareness, better diagnostic judgement — including knowing when to seek help."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )

    // MARK: - 13 Quick Guides

    private static let quickGuides = TreeHealthLesson(
        id: "quick-guides",
        number: 13,
        title: "Quick Guides",
        summary: "A healthy bonsai is not a tree that never changes. It is a tree whose changes can be understood.",
        sections: [
            TreeHealthSection(
                id: "cards",
                heading: "Quick knowledge cards",
                paragraphs: [],
                bullets: [],
                callouts: [
                    TreeHealthCallout(
                        id: "card-look",
                        title: "Look before you treat",
                        body: "Symptoms are information. They are not automatically diagnoses."
                    ),
                    TreeHealthCallout(
                        id: "card-normal",
                        title: "Know your normal",
                        body: "The healthier your understanding of the tree, the earlier you notice change."
                    ),
                    TreeHealthCallout(
                        id: "card-whole",
                        title: "Check the whole tree",
                        body: "A leaf problem may begin below the soil."
                    ),
                    TreeHealthCallout(
                        id: "card-prevention",
                        title: "Prevention starts with observation",
                        body: "Regular inspection is one of the most useful health tools."
                    ),
                    TreeHealthCallout(
                        id: "card-after",
                        title: "Monitor after action",
                        body: "Treatment is not the end of the process."
                    )
                ]
            ),
            TreeHealthSection(
                id: "connections",
                heading: "Connections to other Bonsai World knowledge",
                paragraphs: [
                    "Watering — water stress and water uptake. Care → Watering is the practical surface.",
                    "Soil & Substrate — drainage and the root environment.",
                    "Repotting — root health and recovery after work. Care → Repotting is the seasonal surface.",
                    "Fertilizing — nutrient-related problems. Use Fertilizer Guides for practical feeding. Care → Fertilizing is the programme surface.",
                    "Care → Seasonal Care and Care → Winter Care — weather stress and seasonal change.",
                    "Seasonal Care & Protection — the annual rhythm, protection and why dates are not nature.",
                    "Bonsai Collection Management — health monitoring, quarantine and collection overview.",
                    "Deadwood — living tissue comes before deadwood design.",
                    "Advanced Techniques — recovery after major work; do not stack stress.",
                    "Pruning — do not prune a diagnosis away. Defoliation is not a treatment for a weak tree.",
                    "Wiring — stress, recovery, and when to avoid major work.",
                    "Bonsai Material & Sourcing — inspection before a tree joins the collection, and yamadori recovery after collection. New growth is not automatically full recovery.",
                    "Tools & Equipment — tool hygiene.",
                    "Species Library — what is normal for this species and season.",
                    "Garden → Trees — health status, history and notes.",
                    "Care → Health — Needs Attention, Recovering and health tasks.",
                    "Media → Images — photographs of the problem over time.",
                    "Dashboard — trees that need attention."
                ],
                bullets: [],
                callouts: []
            ),
            TreeHealthSection(
                id: "closing",
                heading: "Final Bonsai World principle",
                paragraphs: [
                    "A healthy bonsai is not a tree that never changes. It is a tree whose changes can be understood within the context of its species, season and environment.",
                    "Good health management does not mean treating every problem immediately. It means learning to observe, to investigate, to understand, and then to act with purpose.",
                    "The better you know your trees, the earlier you can recognise when something is no longer normal."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )
}
