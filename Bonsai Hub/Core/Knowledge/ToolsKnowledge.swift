//
//  ToolsKnowledge.swift
//  Bonsai World
//
//  Knowledge → Bonsai Handbook → Tools & Equipment.
//  Buy tools for the work you do, not for the image of the artist you want to be.
//

import Foundation

struct ToolsKnowledgeCallout: Identifiable, Hashable, Sendable {
    var id: String
    var title: String
    var body: String
}

struct ToolsKnowledgeSection: Identifiable, Hashable, Sendable {
    var id: String
    var heading: String
    var paragraphs: [String]
    var bullets: [String]
    var callouts: [ToolsKnowledgeCallout]
}

struct ToolsKnowledgeLesson: Identifiable, Hashable, Sendable {
    var id: String
    var number: Int
    var title: String
    var summary: String
    var sections: [ToolsKnowledgeSection]
}

enum ToolsKnowledge {
    static let chapterTitle = "Tools & Equipment"

    static let openingLine =
        "Understanding the tools of bonsai — from the essential beginner kit to specialised equipment for advanced work."

    static let disclaimer =
        "Selection depends on frequency of use, type of work, tree size, material, budget, precision and maintenance habits. Function first. Quality second. Brand last."

    static let lessons: [ToolsKnowledgeLesson] = [
        overview,
        cuttingTools,
        branchCutters,
        wireTools,
        rootAndSoil,
        saws,
        deadwoodAndCarving,
        wateringEquipment,
        qualityAndFit,
        careAndSafety,
        buildingAKit,
        practice,
        quickGuides
    ]

    static func lesson(id: String) -> ToolsKnowledgeLesson? {
        lessons.first { $0.id == id }
    }

    // MARK: - 01 Overview

    private static let overview = ToolsKnowledgeLesson(
        id: "overview",
        number: 1,
        title: "Overview",
        summary: "Buy tools for the work you do, not for the image of the artist you want to be.",
        sections: [
            ToolsKnowledgeSection(
                id: "introduction",
                heading: "Tools are extensions of the hand",
                paragraphs: [
                    "Bonsai can be practised with relatively few tools. A beginner does not need every cutter, every saw, every carving machine and every specialised instrument. The goal is to gradually build a collection based on the work being performed.",
                    "Bonsai tools help the artist cut, prune, wire, work roots, carve, clean, repot and maintain. Different tools are designed for different materials. Using the wrong tool can damage the tool, damage the tree, produce poor cuts and increase physical effort.",
                    "The correct tool can improve precision, reduce damage, make work easier, improve safety, support cleaner cuts and improve efficiency. Owning more tools does not automatically make someone a better bonsai artist. Tools are not collected simply because they look professional. Every tool should have a purpose."
                ],
                bullets: [],
                callouts: [
                    ToolsKnowledgeCallout(
                        id: "buy-for-work",
                        title: "Bonsai World principle",
                        body: "Buy tools for the work you do, not for the image of the artist you want to be."
                    ),
                    ToolsKnowledgeCallout(
                        id: "best-tool",
                        title: "Bonsai World principle",
                        body: "The best tool is the one that performs the required work cleanly, safely and with control."
                    )
                ]
            ),
            ToolsKnowledgeSection(
                id: "starter",
                heading: "The beginner tool kit",
                paragraphs: [
                    "A practical beginner kit may include general pruning scissors, a branch cutter or concave cutter, a wire cutter, a root rake or root hook, a basic saw, and a chopstick or soil tool.",
                    "This is only a starting point. A beginner does not need every specialist tool."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )

    // MARK: - 02 Cutting Tools

    private static let cuttingTools = ToolsKnowledgeLesson(
        id: "cutting",
        number: 2,
        title: "Cutting Tools",
        summary: "Different scissors suit different hands and different work. Do not use delicate scissors beyond their capacity.",
        sections: [
            ToolsKnowledgeSection(
                id: "scissors",
                heading: "Bonsai scissors",
                paragraphs: [
                    "Bonsai scissors are used for shoots, leaves, fine branches and detailed work. Short blades, long handles, fine tips and general-purpose scissors all exist because the work differs.",
                    "Different scissors may suit different hands and different work. Pruning in this Handbook covers when and why to cut — this chapter covers with what."
                ],
                bullets: [],
                callouts: []
            ),
            ToolsKnowledgeSection(
                id: "long-handle",
                heading: "Long-handle scissors",
                paragraphs: [
                    "Long handles can help reach interior shoots, dense branching and difficult areas. Precision and visibility still matter. Reach is not a reason to cut what you cannot see clearly."
                ],
                bullets: [],
                callouts: []
            ),
            ToolsKnowledgeSection(
                id: "bud",
                heading: "Bud scissors",
                paragraphs: [
                    "Bud scissors are for small shoots, buds and fine detail. Emphasise precision. Do not use delicate scissors for material beyond their intended capacity."
                ],
                bullets: [],
                callouts: []
            ),
            ToolsKnowledgeSection(
                id: "leaf",
                heading: "Leaf cutters",
                paragraphs: [
                    "Leaf cutters may be used in defoliation and leaf trimming. Whether to defoliate is a pruning decision, not a tool decision. Pruning — Defoliation and Leaf Reduction cover that judgement.",
                ],
                bullets: [],
                callouts: []
            )
        ]
    )

    // MARK: - 03 Branch Cutters

    private static let branchCutters = ToolsKnowledgeLesson(
        id: "branch-cutters",
        number: 3,
        title: "Branch Cutters",
        summary: "Concave cutters are not magic healing tools. Never force a cutter beyond its intended use.",
        sections: [
            ToolsKnowledgeSection(
                id: "concave",
                heading: "Concave cutters",
                paragraphs: [
                    "Concave cutters are used for branch removal. The cut shape may heal more cleanly and reduce protruding branch stubs.",
                    "Concave cutters are not magic healing tools. Correct placement and aftercare remain important."
                ],
                bullets: [],
                callouts: []
            ),
            ToolsKnowledgeSection(
                id: "spherical",
                heading: "Spherical concave cutters",
                paragraphs: [
                    "Spherical or rounded cutters may be used for removing branch material and creating particular wound shapes. They differ from standard concave cutters.",
                    "Do not encourage excessive removal simply because the tool can take more wood."
                ],
                bullets: [],
                callouts: []
            ),
            ToolsKnowledgeSection(
                id: "knob",
                heading: "Knob cutters",
                paragraphs: [
                    "Knob cutters may be used for knobs, stubs and protruding wood. Emphasise control. Do not remove unnecessary material simply because the tool makes it possible."
                ],
                bullets: [],
                callouts: []
            ),
            ToolsKnowledgeSection(
                id: "branch",
                heading: "Branch cutters",
                paragraphs: [
                    "Branch cutters may provide more strength for larger material and heavier pruning. Tool capacity matters. Never force a tool beyond its intended use."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )

    // MARK: - 04 Wire Tools

    private static let wireTools = ToolsKnowledgeLesson(
        id: "wire",
        number: 4,
        title: "Wire Tools",
        summary: "Do not use bonsai scissors to cut wire. Wiring in this Handbook covers why and how to wire.",
        sections: [
            ToolsKnowledgeSection(
                id: "cutters",
                heading: "Wire cutters",
                paragraphs: [
                    "Dedicated wire cutters are useful for copper wire, aluminium wire and different wire thicknesses.",
                    "Do not use bonsai scissors to cut wire."
                ],
                bullets: [],
                callouts: []
            ),
            ToolsKnowledgeSection(
                id: "wiring",
                heading: "Wiring equipment",
                paragraphs: [
                    "Aluminium wire, copper wire, wire cutters and pliers where appropriate are tools for branch positioning. Wiring in this Handbook covers application, timing and tree safety."
                ],
                bullets: [],
                callouts: []
            ),
            ToolsKnowledgeSection(
                id: "raffia",
                heading: "Raffia",
                paragraphs: [
                    "Raffia may support major bends. Conceptually it can provide fibre support, moisture, compression and protection.",
                    "Wiring covers advanced bending. Raffia is equipment for that work — not a reason to force a branch."
                ],
                bullets: [],
                callouts: []
            ),
            ToolsKnowledgeSection(
                id: "guy",
                heading: "Guy wires and anchoring",
                paragraphs: [
                    "Equipment used for pulling branches, changing branch angle and controlled movement. Emphasise gradual adjustment and tree monitoring."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )

    // MARK: - 05 Root & Soil Tools

    private static let rootAndSoil = ToolsKnowledgeLesson(
        id: "root-soil",
        number: 5,
        title: "Root & Soil Tools",
        summary: "A simple tool can be the correct tool. Avoid aggressive raking around fine roots.",
        sections: [
            ToolsKnowledgeSection(
                id: "root-cutters",
                heading: "Root cutters",
                paragraphs: [
                    "Root cutters are used for root pruning, root reduction and repotting. Repotting in this Handbook covers when and how much to cut."
                ],
                bullets: [],
                callouts: []
            ),
            ToolsKnowledgeSection(
                id: "rakes",
                heading: "Root rakes",
                paragraphs: [
                    "Root rakes help remove old substrate, separate roots and understand root structure. Avoid aggressive use around fine roots."
                ],
                bullets: [],
                callouts: []
            ),
            ToolsKnowledgeSection(
                id: "hooks",
                heading: "Root hooks",
                paragraphs: [
                    "Root hooks can help work through dense root systems. Different sizes may suit different tree sizes."
                ],
                bullets: [],
                callouts: []
            ),
            ToolsKnowledgeSection(
                id: "chopstick",
                heading: "Chopsticks and soil tools",
                paragraphs: [
                    "Simple tools with major value: working substrate between roots, removing air pockets and guiding soil."
                ],
                bullets: [],
                callouts: [
                    ToolsKnowledgeCallout(
                        id: "simple-correct",
                        title: "Bonsai World principle",
                        body: "A simple tool can be the correct tool."
                    )
                ]
            ),
            ToolsKnowledgeSection(
                id: "repotting-kit",
                heading: "Repotting equipment",
                paragraphs: [
                    "A practical repotting set may include a root rake, root hook, root scissors, soil scoop, screens, wire and chopsticks. Repotting covers the work. This chapter covers the instruments."
                ],
                bullets: [],
                callouts: []
            ),
            ToolsKnowledgeSection(
                id: "sieves",
                heading: "Soil sieves",
                paragraphs: [
                    "Sieves are used for removing dust, separating particle sizes and creating consistency. Soil & Substrate in this Handbook explains why particle size matters."
                ],
                bullets: [],
                callouts: []
            ),
            ToolsKnowledgeSection(
                id: "scoops",
                heading: "Soil scoops",
                paragraphs: [
                    "Scoops make potting more efficient. Different sizes may be useful depending on pot size, particle size and working environment."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )

    // MARK: - 06 Saws

    private static let saws = ToolsKnowledgeLesson(
        id: "saws",
        number: 6,
        title: "Saws",
        summary: "Blade sharpness, tooth pattern and controlled cutting matter more than the size of the saw.",
        sections: [
            ToolsKnowledgeSection(
                id: "bonsai-saws",
                heading: "Bonsai saws",
                paragraphs: [
                    "Fine saws, folding saws and larger pruning saws all exist. Blade sharpness, correct tooth pattern and controlled cutting matter.",
                    "A saw is for wood the cutters cannot take cleanly. It is not a faster cutter."
                ],
                bullets: [],
                callouts: []
            ),
            ToolsKnowledgeSection(
                id: "root-saws",
                heading: "Root saws",
                paragraphs: [
                    "Root saws have specialised use in some root work. Cleaning and tool hygiene matter especially below the surface."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )

    // MARK: - 07 Deadwood & Carving

    private static let deadwoodAndCarving = ToolsKnowledgeLesson(
        id: "deadwood",
        number: 7,
        title: "Deadwood & Carving",
        summary: "Power tools are not a shortcut to artistic quality. The faster the tool removes material, the more important control becomes.",
        sections: [
            ToolsKnowledgeSection(
                id: "deadwood-tools",
                heading: "Deadwood tools",
                paragraphs: [
                    "Tools used for bark removal, fibre work and deadwood refinement belong with jin, shari and carving knowledge. Deadwood covers whether the feature belongs on the tree. Design Guidelines cover deadwood as character, not decoration.",
                    "Do not create artificial deadwood everywhere simply because the tools exist."
                ],
                bullets: [],
                callouts: []
            ),
            ToolsKnowledgeSection(
                id: "jin-pliers",
                heading: "Jin pliers",
                paragraphs: [
                    "Jin pliers are used for peeling, splitting and manipulating wood fibres. Emphasise tree preservation."
                ],
                bullets: [],
                callouts: []
            ),
            ToolsKnowledgeSection(
                id: "carving",
                heading: "Carving tools",
                paragraphs: [
                    "Hand carving tools, rotary tools and power carving equipment exist. Advanced carving requires knowledge, control and respect for the tree.",
                    "Do not present power tools as a shortcut to artistic quality."
                ],
                bullets: [],
                callouts: []
            ),
            ToolsKnowledgeSection(
                id: "rotary",
                heading: "Rotary tools",
                paragraphs: [
                    "Rotary tools may be used for removing wood, refining deadwood and creating texture. Discuss speed, control, safety, eye protection and dust management."
                ],
                bullets: [],
                callouts: []
            ),
            ToolsKnowledgeSection(
                id: "power",
                heading: "Power tools",
                paragraphs: [
                    "Power tools may be useful for large material, heavy carving and advanced deadwood work. They introduce increased risk, less margin for error and faster irreversible mistakes."
                ],
                bullets: [],
                callouts: [
                    ToolsKnowledgeCallout(
                        id: "faster-control",
                        title: "Bonsai World principle",
                        body: "The faster the tool removes material, the more important control becomes."
                    )
                ]
            )
        ]
    )

    // MARK: - 08 Watering Equipment

    private static let wateringEquipment = ToolsKnowledgeLesson(
        id: "watering",
        number: 8,
        title: "Watering Equipment",
        summary: "Automation can deliver water. Only observation can understand the tree.",
        sections: [
            ToolsKnowledgeSection(
                id: "delivery",
                heading: "Delivering water properly",
                paragraphs: [
                    "Watering cans, fine rose attachments, hoses, spray nozzles and automated irrigation are ways to deliver water. Watering in this Handbook covers when and why."
                ],
                bullets: [],
                callouts: []
            ),
            ToolsKnowledgeSection(
                id: "automation",
                heading: "Automated watering",
                paragraphs: [
                    "Automation may help with larger collections, busy schedules and consistent watering. Automation does not replace observation."
                ],
                bullets: [],
                callouts: [
                    ToolsKnowledgeCallout(
                        id: "automation-observe",
                        title: "Bonsai World principle",
                        body: "Automation can deliver water. Only observation can understand the tree."
                    )
                ]
            )
        ]
    )

    // MARK: - 09 Quality & Fit

    private static let qualityAndFit = ToolsKnowledgeLesson(
        id: "quality",
        number: 9,
        title: "Quality & Fit",
        summary: "Judge the tool by function, quality and suitability. A traditional Japanese tool is not automatically the correct choice.",
        sections: [
            ToolsKnowledgeSection(
                id: "carbon",
                heading: "Carbon steel",
                paragraphs: [
                    "Carbon steel can take a very sharp edge. It also requires maintenance and carries rust risk."
                ],
                bullets: [],
                callouts: []
            ),
            ToolsKnowledgeSection(
                id: "stainless",
                heading: "Stainless steel",
                paragraphs: [
                    "Stainless steel offers greater corrosion resistance and a different maintenance habit. Material selection should relate to use and maintenance — not to a brand story."
                ],
                bullets: [],
                callouts: []
            ),
            ToolsKnowledgeSection(
                id: "japanese",
                heading: "Japanese and modern tools",
                paragraphs: [
                    "Traditional Japanese bonsai tools have a strong history and are often highly regarded. A traditional tool is not automatically the correct choice.",
                    "Modern tools may offer different ergonomics, materials and manufacturing approaches. Judge the tool by function, quality and suitability. Do not present expensive Japanese tools as automatically superior."
                ],
                bullets: [],
                callouts: []
            ),
            ToolsKnowledgeSection(
                id: "levels",
                heading: "Entry, mid-range and professional",
                paragraphs: [
                    "A beginner may benefit more from a few reliable tools than from a large collection of cheap specialised tools.",
                    "Advanced users may justify premium tools when frequency of use is high, precision is important and durability matters."
                ],
                bullets: [],
                callouts: []
            ),
            ToolsKnowledgeSection(
                id: "ergonomics",
                heading: "The tool must fit the user",
                paragraphs: [
                    "Consider hand size, grip, tool weight and repetitive work. The same tool may feel excellent for one person and unsuitable for another."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )

    // MARK: - 10 Care & Safety

    private static let careAndSafety = ToolsKnowledgeLesson(
        id: "care-safety",
        number: 10,
        title: "Care & Safety",
        summary: "A sharp tool often requires less force. Never sacrifice safety for speed.",
        sections: [
            ToolsKnowledgeSection(
                id: "maintenance",
                heading: "Protecting precision",
                paragraphs: [
                    "Cleaning, drying, rust prevention, lubrication and storage extend tool life. Regular maintenance is part of owning a tool — not an optional extra."
                ],
                bullets: [],
                callouts: []
            ),
            ToolsKnowledgeSection(
                id: "cleaning",
                heading: "Cleaning between trees and tasks",
                paragraphs: [
                    "Cleaning tools can reduce the transfer of sap, dirt and plant material. Where disease or pests are suspected, hygiene becomes especially important. Tree Health belongs in that judgement."
                ],
                bullets: [],
                callouts: []
            ),
            ToolsKnowledgeSection(
                id: "sharpening",
                heading: "Maintaining cutting quality",
                paragraphs: [
                    "Sharp tools can improve cut quality, reduce crushing and require less force. Stones, files and professional sharpening all exist.",
                    "Do not sharpen precision tools aggressively without understanding the blade geometry."
                ],
                bullets: [],
                callouts: []
            ),
            ToolsKnowledgeSection(
                id: "storage",
                heading: "Organisation and protection",
                paragraphs: [
                    "Tool rolls, toolboxes, drawers and dry storage all work if the tools are clean, dry and protected. Inventory → Tools is the stock record in the programme."
                ],
                bullets: [],
                callouts: []
            ),
            ToolsKnowledgeSection(
                id: "safety",
                heading: "Protecting the artist",
                paragraphs: [
                    "Consider sharp blades, cutting direction, a stable working position, eye protection, gloves where appropriate and power tool safety. Never sacrifice safety for speed."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )

    // MARK: - 11 Building a Kit

    private static let buildingAKit = ToolsKnowledgeLesson(
        id: "building-a-kit",
        number: 11,
        title: "Building a Kit",
        summary: "Buy the next tool when your current work repeatedly requires it. Do not build a collection from fear of missing out.",
        sections: [
            ToolsKnowledgeSection(
                id: "beginner-buying",
                heading: "Beginner buying strategy",
                paragraphs: [
                    "Build slowly. A useful sequence may be scissors, then a branch cutting tool, then a wire cutter, then a root tool, then a saw. Add specialist tools according to actual needs."
                ],
                bullets: [],
                callouts: []
            ),
            ToolsKnowledgeSection(
                id: "intermediate",
                heading: "Intermediate development",
                paragraphs: [
                    "Possible additions may include a knob cutter, jin pliers, better root tools, more specialised scissors, additional saws and soil sieves — when the work repeatedly asks for them."
                ],
                bullets: [],
                callouts: []
            ),
            ToolsKnowledgeSection(
                id: "advanced",
                heading: "Advanced collections",
                paragraphs: [
                    "Advanced collections may include tools selected for specific carving work, large tree work, fine refinement, exhibition preparation and specialist deadwood work.",
                    "They should still remain purpose-driven."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )

    // MARK: - 12 Practice

    private static let practice = ToolsKnowledgeLesson(
        id: "practice",
        number: 12,
        title: "Practice",
        summary: "The question is not what professionals own. The question is what tool gives the greatest control over this task.",
        sections: [
            ToolsKnowledgeSection(
                id: "mistakes",
                heading: "Common beginner mistakes",
                paragraphs: [
                    "Buying too many tools too early. Using scissors to cut wire. Forcing tools beyond their capacity. Ignoring cleaning and maintenance. Buying specialised tools without understanding their purpose.",
                    "Assuming expensive tools automatically improve skill. Using power tools without adequate safety. Using the wrong tool because it is nearby. Allowing tools to rust. Thinking tool ownership equals experience."
                ],
                bullets: [],
                callouts: []
            ),
            ToolsKnowledgeSection(
                id: "advanced-thinking",
                heading: "Tool selection as part of technique",
                paragraphs: [
                    "Advanced artists select tools based on the exact work. They consider material thickness, wood type, tree position, precision and risk.",
                    "The goal is not what tool professionals own. The question is what tool gives the greatest control over this task."
                ],
                bullets: [],
                callouts: []
            ),
            ToolsKnowledgeSection(
                id: "framework",
                heading: "Practical tool selection framework",
                paragraphs: [
                    "Choose the least aggressive effective tool. Check condition. Work with control. Clean and store."
                ],
                bullets: [
                    "Identify the task.",
                    "Identify the material.",
                    "Determine the required precision.",
                    "Choose the least aggressive effective tool.",
                    "Check tool condition.",
                    "Prepare the work area.",
                    "Perform the work with control.",
                    "Clean and store the tool."
                ],
                callouts: []
            ),
            ToolsKnowledgeSection(
                id: "paths",
                heading: "Beginner, intermediate and advanced",
                paragraphs: [
                    "Beginner — essential tools; basic maintenance; safe use.",
                    "Intermediate — specialist tools; root tools; wiring equipment; tool selection.",
                    "Advanced — precision tools; deadwood tools; carving equipment; collection-specific equipment."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )

    // MARK: - 13 Quick Guides

    private static let quickGuides = ToolsKnowledgeLesson(
        id: "quick-guides",
        number: 13,
        title: "Quick Guides",
        summary: "The most important tool remains the judgement that decides what should be done to the tree — and what should be left untouched.",
        sections: [
            ToolsKnowledgeSection(
                id: "cards",
                heading: "Knowledge cards",
                paragraphs: [],
                bullets: [],
                callouts: [
                    ToolsKnowledgeCallout(
                        id: "card-function",
                        title: "Function first",
                        body: "Buy the tool for the work you actually do."
                    ),
                    ToolsKnowledgeCallout(
                        id: "card-force",
                        title: "Do not force tools",
                        body: "The wrong tool becomes dangerous when forced."
                    ),
                    ToolsKnowledgeCallout(
                        id: "card-sharp",
                        title: "Sharp is controlled",
                        body: "A sharp tool often requires less force."
                    ),
                    ToolsKnowledgeCallout(
                        id: "card-maintain",
                        title: "Maintain your tools",
                        body: "Good tools become better investments when maintained."
                    ),
                    ToolsKnowledgeCallout(
                        id: "card-simple",
                        title: "Simple can be correct",
                        body: "Not every bonsai task requires a specialist instrument."
                    )
                ]
            ),
            ToolsKnowledgeSection(
                id: "connections",
                heading: "Connections to other Bonsai World knowledge",
                paragraphs: [
                    "Pruning — scissors, cutters and saws.",
                    "Wiring — wire cutters, pliers and raffia.",
                    "Repotting — root tools, soil tools and sieves.",
                    "Soil & Substrate — screening and preparation.",
                    "Watering — watering cans, roses and automation.",
                    "Deadwood — jin, shari, uro and whether carving should happen. Design Guidelines cover deadwood as character visible from the front. This chapter covers jin pliers, carving tools and rotary equipment as instruments.",
                    "Advanced Techniques — when carving, hollowing and major bends are justified.",
                    "Tree Health — tool hygiene and disease prevention.",
                    "Inventory → Tools is the stock record in the programme."
                ],
                bullets: [],
                callouts: []
            ),
            ToolsKnowledgeSection(
                id: "advisor",
                heading: "Future: Tool Advisor",
                paragraphs: [
                    "A future tool could take task, tree size, material size and experience level, then suggest an essential tool, an optional specialist tool and an alternative — and explain why.",
                    "It should not simply say buy this tool. It should explain possible options, precision requirements and potential risks. The purpose is education, not product sales."
                ],
                bullets: [],
                callouts: []
            ),
            ToolsKnowledgeSection(
                id: "philosophy",
                heading: "Bonsai World philosophy",
                paragraphs: [
                    "A bonsai artist is not defined by the number of tools they own. Tools are not symbols of experience. They are instruments of intention.",
                    "The right tool makes the work more precise. A well-maintained tool makes the work more predictable. But the most important tool remains the judgement that decides what should be done to the tree — and what should be left untouched."
                ],
                bullets: [],
                callouts: []
            )
        ]
    )
}
