//
//  DesignGuidelines.swift
//  Bonsai World
//
//  Knowledge → Bonsai Handbook → Design Guidelines.
//  Shape areas show excerpts and link here.
//

import Foundation

enum DesignGuidelineSection: String, CaseIterable, Identifiable, Hashable, Sendable {
    case frontSelection
    case overallSilhouette
    case nebari
    case trunk
    case trunkMovement
    case taper
    case primaryBranches
    case secondaryBranches
    case ramification
    case apex
    case branchDevelopment
    case grafting
    case deadwood
    case wiring

    var id: Self { self }

    var title: String {
        switch self {
        case .frontSelection: "Front Selection"
        case .overallSilhouette: "Overall Silhouette"
        case .nebari: "Nebari"
        case .trunk: "Trunk"
        case .trunkMovement: "Trunk Movement"
        case .taper: "Taper"
        case .primaryBranches: "Primary Branches"
        case .secondaryBranches: "Secondary Branches"
        case .ramification: "Ramification"
        case .apex: "Apex"
        case .branchDevelopment: "Branch Development"
        case .grafting: "Grafting"
        case .deadwood: "Jin, Shari, Deadwood"
        case .wiring: "Wiring and Bending"
        }
    }
}

struct DesignGuidelineEntry: Hashable, Sendable {
    var section: DesignGuidelineSection
    var excerpt: String
    var paragraphs: [String]
    var onTheTree: String
}

enum DesignGuidelines {
    static let chapterTitle = "Design Guidelines"

    static let introduction: [String] = [
        "These are guidelines, not laws. They help you see. They are stronger when you are building a classical tree or preparing for exhibition, and weaker on yamadori, bunjin, and material that already has character. A young tree follows them more closely. An old tree may break them when the break is readable.",
        "Use them as a check, not as a recipe. Bonsai Forms, Styles & Silhouette teaches how the whole tree is read. Bonsai Artistry & the Bonsai Eye trains the judgement that decides which guideline the tree should follow."
    ]

    static let entries: [DesignGuidelineEntry] = [
        DesignGuidelineEntry(
            section: .frontSelection,
            excerpt: "Choose the front first. Everything else is read from that view.",
            paragraphs: [
                "Choose the front first. Nebari, movement, first branch, and apex are all read from that view.",
                "A slight lean toward the viewer invites. Eye-poking roots or branches — aimed straight at the viewer — close the tree instead."
            ],
            onTheTree: "If the front is undecided, do not lock branch decisions yet."
        ),
        DesignGuidelineEntry(
            section: .overallSilhouette,
            excerpt: "An uneven triangle, not a Christmas tree. Flow from base to apex; one crown.",
            paragraphs: [
                "The outline should be an uneven triangle, not a symmetrical Christmas tree. The longest and shortest sides create tension.",
                "Flow should run from nebari and the first trunk movement through to the apex. An apex that turns back on the trunk, or a trunk line that folds into a C-curve, stops the eye.",
                "One apex. Competing tops split the tree. Keep a second crown only when the material makes that reading honest — twin trunk, group, or a break you are choosing to keep.",
                "Bonsai Forms, Styles & Silhouette develops this outline as composition: triangle as a guide, not geometry to copy."
            ],
            onTheTree: "Check the outline before you check individual branches."
        ),
        DesignGuidelineEntry(
            section: .nebari,
            excerpt: "The base anchors the tree. Roots radiate; nothing points at the viewer.",
            paragraphs: [
                "The base must anchor the tree. A straight trunk with no flare looks planted, not rooted.",
                "Roots should radiate from the flare. Gaps in the nebari, one dominant root, or roots aimed at the viewer all weigh down the front."
            ],
            onTheTree: "Walk around the base before you commit to the front."
        ),
        DesignGuidelineEntry(
            section: .trunk,
            excerpt: "Taper up. Ratios are a start, not a target. Twin trunks divide at the base.",
            paragraphs: [
                "Taper as the trunk rises. Reverse taper — thicker higher up — is one of the few guidelines we hold firmly, unless deadwood, jin, or a clear break explains it.",
                "Height versus thickness is a starting point, not a target. Classical teaching often uses about six times the trunk caliper. Squat trees, cascades, and massive trunks can be shorter; bunjin and slender literati can be taller. Judge by expression, not by the ruler.",
                "For formal and informal upright, the apex sits roughly over the base. Cascade and slanted trees follow a different axis.",
                "Twin trunks should divide at the base, not as a fork halfway up."
            ],
            onTheTree: "If the trunk already has character, do not chase a textbook ratio."
        ),
        DesignGuidelineEntry(
            section: .trunkMovement,
            excerpt: "Clear curves, not ornament. No pigeon breast. The line must not fold into a C.",
            paragraphs: [
                "Movement should be readable from the sides, not as a belly toward the viewer. That forward bulge is pigeon breast — it flattens the tree.",
                "In informal upright, fewer and clearer curves. Too many S-bends become ornament. Curves should tighten as the tree rises; that rhythm belongs with branch placement.",
                "The line must not move back on itself. A trunk that returns into a C-curve loses flow."
            ],
            onTheTree: "Trace the line from base to apex with one finger. If it loops, simplify."
        ),
        DesignGuidelineEntry(
            section: .taper,
            excerpt: "Thin as it rises. Reverse taper needs a reason. Branches must not overpower the trunk.",
            paragraphs: [
                "The trunk should thin as it ascends. Reverse taper is a structural problem unless the story of the tree accounts for it.",
                "Branch caliper must stay in proportion to the trunk at the point where the branch sits. A branch thicker than about one third of the trunk there will overpower the stem. An old low branch may be the exception when that thickness is the evidence of age."
            ],
            onTheTree: "Compare each primary to the trunk beside it, not to an average of the whole tree."
        ),
        DesignGuidelineEntry(
            section: .primaryBranches,
            excerpt: "One per position. Alternate. Outside the curve. Air between the tiers.",
            paragraphs: [
                "One branch per position. No wheel-and-spoke, no whorl, no bar branches (two branches opposite each other at the same height).",
                "No crossing — branch over branch, or branch across the trunk — unless you are hiding it in depth or removing it later.",
                "No eye-poking branches. The first and second branches may sit slightly forward of the mid-line to open the tree; they should not point at the face.",
                "First branch at about one third of the height is a teaching scaffold for a young classical tree. On old material, cascade, and trees that already have structure: read the tree, not the third.",
                "Succeeding branches at about one third of the remaining distance — same caveat.",
                "Left / right / back as the first three positions, roughly 120° apart. The back branch is not directly behind the trunk.",
                "Branches sit on the outside of the curves, not in the belly.",
                "They should alternate visually. Parallel branches in the same plane read as a ladder, not as a tree.",
                "They diminish in size and caliper as they rise. The apex is the young part of the tree.",
                "Leave space between the tiers — enough air that the eye can pass through. Continuous pads without negative space become a bush."
            ],
            onTheTree: "If a branch fights the trunk, the branch usually goes."
        ),
        DesignGuidelineEntry(
            section: .secondaryBranches,
            excerpt: "Same logic as primaries. Build a pad; no shoots straight up or down through it.",
            paragraphs: [
                "Secondary branches follow the same logic as primaries: alternate left and right, build the pad.",
                "Do not let secondaries run straight up or straight down through the pad. That destroys the plane of the foliage."
            ],
            onTheTree: "A pad is a plane with depth, not a cluster of twigs."
        ),
        DesignGuidelineEntry(
            section: .ramification,
            excerpt: "Denser, smaller, still with gaps. Stop before the outline goes solid.",
            paragraphs: [
                "Finer branching continues the same diminution: shorter, thinner, more frequent as you move out and up.",
                "Negative space still matters at this scale. Ramification should densify the pad, not fill every gap."
            ],
            onTheTree: "Stop before the silhouette turns solid."
        ),
        DesignGuidelineEntry(
            section: .apex,
            excerpt: "One apex, over the base on uprights, slightly toward the viewer. The crown may rise.",
            paragraphs: [
                "One apex, finishing in the direction set by the base.",
                "It should lean slightly toward the viewer. On formal and informal upright, it sits over the base.",
                "Near and in the apex, branches may be horizontal or even rise. That is the young part of the tree; forcing every tip down makes the crown look old in the wrong way."
            ],
            onTheTree: "If two tops compete, choose."
        ),
        DesignGuidelineEntry(
            section: .branchDevelopment,
            excerpt: "Down and out for age; the crown stays younger. Cascade is not a mirrored upright.",
            paragraphs: [
                "Age is read in angle. Down and out reads old; ascending reads young. Wire down when you want the illusion of age. Leave the crown freer.",
                "Cascade follows the same branch logic as an upright, except the trunk moves down. Do not mirror an upright and call it cascade.",
                "In twin trees or groups, no branches between the trunks that cross the stems. The outside of both trees builds the silhouette."
            ],
            onTheTree: "Development stage first, then style, then these guidelines."
        ),
        DesignGuidelineEntry(
            section: .grafting,
            excerpt: "The join should disappear, or sit low in the nebari.",
            paragraphs: [
                "A graft should disappear. Match understock and scion so the join is quiet, or place it low enough to lose it in the nebari.",
                "A visible graft collar is a design problem, not only a technical one."
            ],
            onTheTree: "If the join will always show, plan the front so it does not sit on the viewing line."
        ),
        DesignGuidelineEntry(
            section: .deadwood,
            excerpt: "Deadwood must be visible from the front.",
            paragraphs: [
                "Jin and shari should be seen, not hidden in foliage. Deadwood is character, not decoration behind a pad.",
                "Deadwood in this Handbook develops jin, shari and uro as story — not as carving for its own sake."
            ],
            onTheTree: "If you cannot see the deadwood from the front, it is not doing any work."
        ),
        DesignGuidelineEntry(
            section: .wiring,
            excerpt: "Wire to set readable movement. Do not add curves just because you can.",
            paragraphs: [
                "Wiring is how you set angle and flow. It serves the guidelines above; it is not a separate aesthetic.",
                "Bend for movement that can be read. Do not add curves because wire makes it possible."
            ],
            onTheTree: "If the wire is the only reason for the curve, the curve is probably too much."
        )
    ]

    static func entry(for section: DesignGuidelineSection) -> DesignGuidelineEntry {
        guard let match = entries.first(where: { $0.section == section }) else {
            preconditionFailure("Missing Design Guidelines entry for \(section.rawValue)")
        }
        return match
    }

    static func section(for area: ShapingAreaID) -> DesignGuidelineSection {
        switch area {
        case .frontSelection: .frontSelection
        case .overallSilhouette: .overallSilhouette
        case .nebari: .nebari
        case .trunk: .trunk
        case .trunkMovement: .trunkMovement
        case .taper: .taper
        case .primaryBranches: .primaryBranches
        case .secondaryBranches: .secondaryBranches
        case .ramification: .ramification
        case .apex: .apex
        case .branchDevelopment: .branchDevelopment
        case .grafting, .threadGrafting: .grafting
        case .deadwood, .shari, .jin: .deadwood
        case .wiring, .bending: .wiring
        }
    }

    static func excerpt(for area: ShapingAreaID) -> String {
        entry(for: section(for: area)).excerpt
    }
}
