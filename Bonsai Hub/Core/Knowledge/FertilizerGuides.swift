//
//  FertilizerGuides.swift
//  Bonsai World
//
//  Knowledge → Fertilizer Guides — decision matrices, then short why.
//

import Foundation

struct KnowledgeGuideMatrixRow: Identifiable, Hashable, Sendable {
    var id: String
    var leading: String
    var cells: [String]

    init(id: String? = nil, leading: String, cells: [String]) {
        self.id = id ?? leading
        self.leading = leading
        self.cells = cells
    }
}

enum FertilizerGuides {
    static let chapterTitle = "Fertilizing"

    static let openingLine = "Feed the tree you are growing, not simply the month on the calendar."

    static let lookAtTheTree = "Then look at the tree. Is it actively growing? What is the species doing right now? What stage of the season are you in? Use the calendar as a guide, but let the tree's growth be the trigger."

    static let startingPointsNote = "These are starting points. Adjust according to the tree's development, health and current growth."

    static let rhythmNote = "Interval is rhythm for solid fertilizer, not a dose. Follow the product label for actual application rate and frequency."

    static let stageIntents: [(stage: String, action: String)] = [
        ("Development", "Feed for growth"),
        ("Establishment & Recovery", "Feed for establishment"),
        ("Refinement", "Feed for control")
    ]

    static let glanceColumnHeaders = [
        "Development",
        "Establishment & Recovery",
        "Refinement"
    ]

    static let glanceRows: [KnowledgeGuideMatrixRow] = [
        KnowledgeGuideMatrixRow(
            leading: "Main goal",
            cells: ["Build growth", "Build strength", "Control growth"]
        ),
        KnowledgeGuideMatrixRow(
            leading: "Nitrogen",
            cells: ["Higher", "Low", "Moderate–low"]
        ),
        KnowledgeGuideMatrixRow(
            leading: "Spring",
            cells: ["Start with active growth", "Wait for clear recovery", "Start with active growth"]
        ),
        KnowledgeGuideMatrixRow(
            leading: "Summer",
            cells: ["Feed regularly", "Keep conservative", "Feed moderately"]
        ),
        KnowledgeGuideMatrixRow(
            leading: "Late summer",
            cells: ["Gradually reduce", "Keep light", "Reduce earlier"]
        ),
        KnowledgeGuideMatrixRow(
            leading: "Fall",
            cells: ["Reduce", "Keep light", "Keep low"]
        ),
        KnowledgeGuideMatrixRow(
            leading: "Winter",
            cells: ["Stop", "Stop", "Stop"]
        ),
        KnowledgeGuideMatrixRow(
            leading: "Solid fertilizer interval",
            cells: ["4–6 weeks", "4–6 weeks", "4–6 weeks"]
        )
    ]

    static let glanceWhy = "A tree in development is fed to build trunk, branches and roots. A recovering tree is fed for stability, not extension. A refined tree is fed to keep internodes, needles and leaves in proportion."

    static let whenToFeedRows: [KnowledgeGuideMatrixRow] = [
        KnowledgeGuideMatrixRow(leading: "Dormant", cells: ["Stop"]),
        KnowledgeGuideMatrixRow(leading: "No visible growth", cells: ["Wait"]),
        KnowledgeGuideMatrixRow(leading: "Buds swelling", cells: ["Prepare to start"]),
        KnowledgeGuideMatrixRow(leading: "Buds opening", cells: ["Start according to stage"]),
        KnowledgeGuideMatrixRow(leading: "Active extension", cells: ["Feed according to stage"]),
        KnowledgeGuideMatrixRow(leading: "First flush hardened", cells: ["Adjust according to stage"]),
        KnowledgeGuideMatrixRow(leading: "Second flush developing", cells: ["Feed according to stage"]),
        KnowledgeGuideMatrixRow(leading: "After decandling", cells: ["Pause / Hold"]),
        KnowledgeGuideMatrixRow(leading: "Preparing for dormancy", cells: ["Stop"])
    ]

    static let whenToFeedWhy = "April does not automatically mean fertilize. Start when buds swell, candles extend, needles or leaves emerge, or a recovering tree has already made healthy new growth. Stop well before dormancy. Do not fertilize in winter."

    static let speciesColumnHeaders = [
        "Development",
        "Recovery",
        "Refinement",
        "Watch for"
    ]

    static let speciesRows: [KnowledgeGuideMatrixRow] = [
        KnowledgeGuideMatrixRow(
            leading: "Pine – Single Flush",
            cells: ["Moderate–higher", "Very cautious", "Low–moderate", "Candles & needle length"]
        ),
        KnowledgeGuideMatrixRow(
            leading: "Pine – Double Flush",
            cells: ["Moderate–higher", "Very cautious", "Low", "Candles & needle length"]
        ),
        KnowledgeGuideMatrixRow(
            leading: "Juniper",
            cells: ["Moderate–higher", "Very cautious", "Low–moderate", "New shoots"]
        ),
        KnowledgeGuideMatrixRow(
            leading: "Spruce / Fir",
            cells: ["Moderate–higher", "Very cautious", "Low–moderate", "New growth"]
        ),
        KnowledgeGuideMatrixRow(
            leading: "Larch",
            cells: ["Moderate–higher", "Low", "Moderate", "Needle emergence"]
        ),
        KnowledgeGuideMatrixRow(
            leading: "Japanese Maple",
            cells: ["Higher", "Low", "Low–moderate", "Shoot extension"]
        ),
        KnowledgeGuideMatrixRow(
            leading: "Trident Maple",
            cells: ["Higher", "Low", "Low–moderate", "Shoot extension"]
        ),
        KnowledgeGuideMatrixRow(
            leading: "Beech",
            cells: ["Moderate–higher", "Low", "Low–moderate", "Leaf & shoot growth"]
        )
    ]

    static let pineSingleFlush: [String] = [
        "Wait for the first flush to develop.",
        "Do not treat spring feeding like an ordinary deciduous tree.",
        "Summer feeding may increase once needles have hardened.",
        "Resume according to the development of the flush, not the month."
    ]

    static let pineDoubleFlush: [String] = [
        "Timing follows the development of the first flush.",
        "Summer feeding supports the second flush when appropriate.",
        "After decandling, pause feeding. About four weeks is a guide, not a timer — resume when the tree responds.",
        "Adjust feeding according to whether the tree is being developed or refined."
    ]

    static let pineWhy = "Pines are timed by the flush, not by the month. The question is what stage the current candles are in, and what you are trying to achieve."

    static let choosingRows: [KnowledgeGuideMatrixRow] = [
        KnowledgeGuideMatrixRow(leading: "Steady background feeding", cells: ["Organic pellets / cakes"]),
        KnowledgeGuideMatrixRow(leading: "More controlled nutrient supply", cells: ["Granular fertilizer"]),
        KnowledgeGuideMatrixRow(leading: "Fast or adjustable feeding", cells: ["Liquid fertilizer"]),
        KnowledgeGuideMatrixRow(leading: "Seasonal supplement", cells: ["Seaweed"]),
        KnowledgeGuideMatrixRow(leading: "Root / soil support", cells: ["Humic & micronutrient products"])
    ]

    static let choosingWhy = "Choose by function, not by brand. Seaweed and humic products support a programme; they are not a complete fertilizer. More frequent feeding is not necessarily better feeding."

    static let bottomLine = "Development needs growth. Recovery needs patience. Refinement needs control. The best fertilizer programme is the one that produces the growth you actually want."

    static let inDepthTitle = "In depth"
    static let inDepthLead = "For when you want to go a little further."

    static let inDepthStages: [FertilizerInDepthCard] = [
        FertilizerInDepthCard(
            id: "development",
            title: "Development",
            lead: "The goal is growth.",
            paragraphs: [
                "A tree being built needs enough nutrition to make roots, thicken the trunk, extend branches and develop structure.",
                "Higher nitrogen is generally right during strong growth. Do not be afraid of long shoots or larger internodes if they are helping you build the structure you need.",
                "Keep a regular rhythm through active growth. Solid organic fertilizer is usually the base."
            ]
        ),
        FertilizerInDepthCard(
            id: "establishment",
            title: "Establishment & Recovery",
            lead: "The goal is stability and roots.",
            paragraphs: [
                "A recently collected yamadori, or a tree recovering from major root work, is not a vigorous development tree.",
                "Let the root system establish before you push hard top growth. Start feeding only when recovery is clearly underway and healthy new growth is showing.",
                "Feed lighter than you would in development. Seaweed or humic and micronutrient products can help, but they do not replace balanced nutrition. When in doubt, feed less rather than more."
            ]
        ),
        FertilizerInDepthCard(
            id: "refinement",
            title: "Refinement",
            lead: "The goal is control.",
            paragraphs: [
                "A refined bonsai is no longer fed simply to make it grow as much as possible. You want controlled growth, good ramification, short internodes and proportionate leaves or needles.",
                "Use milder nitrogen than in development. Too much produces exactly what refinement is trying to avoid: long internodes and oversized foliage.",
                "The question changes from “How much growth can I get?” to “How much growth does this tree need?”"
            ]
        )
    ]

    static let inDepthStartSigns: [String] = [
        "Buds are swelling",
        "New leaves are opening",
        "Candles are extending",
        "New shoots are developing",
        "The tree has clearly resumed active growth after winter",
        "A recovering tree has established healthy new growth"
    ]

    static let inDepthStartParagraphs: [String] = [
        "Do not start simply because a month has arrived. Look for signs that the tree is actually growing.",
        "Timing depends on species, climate, location and the individual tree. In a cool temperate climate, start dates differ. The tree’s growth is the final trigger."
    ]

    static let inDepthStopParagraphs: [String] = [
        "As growth slows towards dormancy, reduce feeding. The last application should normally be finished well before the tree goes dormant.",
        "Active growth → feed according to the tree’s needs. Slowing growth → reduce. Dormancy → stop. Do not continue normal feeding through winter."
    ]

    static let inDepthTypes: [FertilizerInDepthCard] = [
        FertilizerInDepthCard(
            id: "organic",
            title: "Organic solid fertilizer",
            lead: "Steady background feeding.",
            paragraphs: [
                "Pellets or cakes release nutrients gradually and work well as a basic programme. Reapply according to the product and the tree’s growth. One rate is not correct for every fertilizer."
            ]
        ),
        FertilizerInDepthCard(
            id: "granular",
            title: "Granular fertilizer",
            lead: "Predictable and convenient.",
            paragraphs: [
                "The name — granular, pellet or otherwise — matters less than nutrient content, release behaviour and the instructions. Use the manufacturer’s rate. Do not invent a Bonsai World dosage."
            ]
        ),
        FertilizerInDepthCard(
            id: "liquid",
            title: "Liquid fertilizer",
            lead: "Faster or more adjustable.",
            paragraphs: [
                "Useful when you want a more controlled or quicker supply. It can sit beside a solid programme. It does not automatically make a better one. More frequent feeding is not necessarily better feeding."
            ]
        ),
        FertilizerInDepthCard(
            id: "seaweed",
            title: "Seaweed",
            lead: "A supporting input, not the main meal.",
            paragraphs: [
                "Use it through the growing season, especially when the tree is growing or recovering. Products vary — follow the label."
            ]
        ),
        FertilizerInDepthCard(
            id: "humic",
            title: "Humic & micronutrients",
            lead: "Support around repot and recovery.",
            paragraphs: [
                "Useful at repotting, establishment and recovery. They are not a complete fertilizer."
            ]
        )
    ]

    static let inDepthSpecies: [FertilizerInDepthCard] = [
        FertilizerInDepthCard(
            id: "pine",
            title: "Pines",
            lead: "Watch the candles, not the calendar.",
            paragraphs: [
                "Development can take stronger feeding when you want vigour. Refinement suffers from too much nitrogen — long needles and excessive extension.",
                "Single-flush pines: time summer solids around the hardening of the new candles.",
                "Double-flush pines follow the first flush; after decandling, pause feeding. About four weeks is a guide, not a timer. Yamadori pines stay conservative until healthy growth is clearly established."
            ]
        ),
        FertilizerInDepthCard(
            id: "juniper",
            title: "Junipers",
            lead: "Start once new growth is clearly underway.",
            paragraphs: [
                "Development trees can be fed more strongly when extension is wanted. Refined trees stay more moderate to keep compact structure. Collected or stressed junipers stay cautious until recovery is established."
            ]
        ),
        FertilizerInDepthCard(
            id: "spruce",
            title: "Spruce, fir & other conifers",
            lead: "The same principles as junipers, a step more cautious.",
            paragraphs: [
                "Feed by growth and stage, not a fixed calendar. Development can take stronger nutrition. Refinement stays moderate. Recovery always comes before pushing growth."
            ]
        ),
        FertilizerInDepthCard(
            id: "larch",
            title: "Larch",
            lead: "Between conifer and deciduous.",
            paragraphs: [
                "Begin when new needles are fully emerging and growth is established. Development can be fed more strongly. Refined trees move towards a more moderate regime as the season progresses. Reduce as dormancy approaches."
            ]
        ),
        FertilizerInDepthCard(
            id: "maple",
            title: "Japanese maple",
            lead: "Hungry in development, moderate in refinement.",
            paragraphs: [
                "A development tree can take stronger feeding while it is making structure. A refined maple should be fed more moderately — excessive growth makes long internodes and oversized leaves. Do not confuse vigour with good refinement."
            ]
        ),
        FertilizerInDepthCard(
            id: "beech",
            title: "Beech",
            lead: "Like other deciduous trees, a step more conservative than maple.",
            paragraphs: [
                "Feed during active growth. Development can take stronger nutrition. Refinement stays more moderate. For yamadori, roots still matter more than pushing foliage."
            ]
        )
    ]

    static let inDepthDecision: [FertilizerInDepthCard] = [
        FertilizerInDepthCard(
            id: "decision-stage",
            title: "What stage is the tree in?",
            bullets: [
                "Development → I want growth.",
                "Recovery → I want healthy establishment.",
                "Refinement → I want controlled growth."
            ]
        ),
        FertilizerInDepthCard(
            id: "decision-now",
            title: "What is the tree doing now?",
            bullets: [
                "Growing strongly → Normal feeding may be appropriate.",
                "Growing moderately → Moderate feeding may be appropriate.",
                "Barely growing or stressed → Do not push it.",
                "Approaching dormancy → Reduce and stop."
            ]
        ),
        FertilizerInDepthCard(
            id: "decision-species",
            title: "What does the species need?",
            bullets: [
                "Pine → Watch candle development.",
                "Juniper → Watch new shoots.",
                "Deciduous → Watch leaf and shoot development.",
                "Larch → Watch needle emergence and extension."
            ]
        )
    ]

    static let inDepthDecisionClose = "The answer comes from combining these observations."

    static let inDepthMistakes: [FertilizerInDepthCard] = [
        FertilizerInDepthCard(
            id: "mistake-calendar",
            title: "Feeding by calendar",
            paragraphs: [
                "April does not automatically mean fertilize. The tree’s growth is more important than the date."
            ]
        ),
        FertilizerInDepthCard(
            id: "mistake-recovery",
            title: "Feeding a recovering tree too hard",
            paragraphs: [
                "A tree rebuilding its roots is not a healthy development tree. More fertilizer does not mean faster recovery."
            ]
        ),
        FertilizerInDepthCard(
            id: "mistake-refinement",
            title: "Development feeding on a refined tree",
            paragraphs: [
                "If the goal is short internodes, compact foliage and fine ramification, maximum growth is not the objective."
            ]
        ),
        FertilizerInDepthCard(
            id: "mistake-late",
            title: "Continuing too late",
            paragraphs: [
                "As the tree approaches dormancy, growth slows. The feeding programme should slow with it."
            ]
        ),
        FertilizerInDepthCard(
            id: "mistake-supplements",
            title: "Treating supplements as fertilizer",
            paragraphs: [
                "Seaweed, humic substances and micronutrients can support a tree. They are not automatically a complete nutritional programme."
            ]
        )
    ]
}

struct FertilizerInDepthCard: Identifiable, Hashable, Sendable {
    var id: String
    var title: String
    var lead: String?
    var paragraphs: [String]
    var bullets: [String]

    init(
        id: String,
        title: String,
        lead: String? = nil,
        paragraphs: [String] = [],
        bullets: [String] = []
    ) {
        self.id = id
        self.title = title
        self.lead = lead
        self.paragraphs = paragraphs
        self.bullets = bullets
    }
}
