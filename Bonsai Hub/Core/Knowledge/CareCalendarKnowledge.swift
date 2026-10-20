//
//  CareCalendarKnowledge.swift
//  Bonsai World
//
//  Knowledge → Care Calendar.
//  Written for a northern temperate year. Hemisphere turns the year.
//  Season moves each phase inside that year. The tree decides the day.
//

import Foundation

struct CareCalendarTaskGroup: Identifiable, Hashable, Sendable {
    var id: String
    var title: String
    var line: String
}

struct CareCalendarChapter: Identifiable, Hashable, Sendable {
    var id: String
    var temperateMonth: Int
    var phase: String
    var summary: String
    /// Short note under the task lines.
    var note: String
    var tasks: [CareCalendarTaskGroup]
}

struct CareCalendarEntry: Identifiable, Hashable, Sendable {
    var id: String
    var title: String
    var subtitle: String
    /// The phase started in an earlier month and is still the right reading.
    var continues: Bool
    var chapters: [CareCalendarChapter]
}

enum CareCalendarKnowledge {
    static let pageTitle = "Care Calendar"

    static let openingLine =
        "A temperate year, placed on your garden. The phase is a guide. The tree and the weather decide the day."

    static let disclaimer =
        "How to repot, prune, wire, water, and feed lives in the Handbook. Species Library stays specific to the tree. This page does not create Tasks."

    static let temperateChapters: [CareCalendarChapter] = [
        midwinter, lateWinter, earlySpring, spring, lateSpring,
        earlySummer, highSummer, lateSummer, earlyAutumn, autumn,
        lateAutumn, earlyWinter
    ]

    static let tropicalChapters: [CareCalendarChapter] = [
        tropicalGrowing, tropicalPause, tropicalFlush, tropicalCool
    ]

    static func contextLine(
        gardenName: String?,
        hemisphere: GardenHemisphere?,
        season: GardenSeason?
    ) -> String {
        guard let hemisphere, let season else {
            return "Set Hemisphere and Season on the default Garden. Until then this page shows a northern temperate year."
        }
        let named = gardenName.map { "\($0) — " } ?? ""
        let place = "\(named)\(hemisphere.title) · \(season.title)."
        switch season {
        case .tropical:
            return "\(place) There is no winter dormancy to put on the calendar. Act when the tree is growing."
        case .subtropical:
            return "\(place) \(season.summary)"
        case .temperate, .cold, .mild:
            let turn = hemisphere == .southern ? " Southern shifts the year by six months." : ""
            return "\(place) \(season.summary)\(turn)"
        }
    }

    static func entries(hemisphere: GardenHemisphere?, season: GardenSeason?) -> [CareCalendarEntry] {
        let resolvedHemisphere = hemisphere ?? .northern
        let resolvedSeason = season ?? .temperate
        if resolvedSeason == .tropical {
            return tropicalChapters.map { chapter in
                CareCalendarEntry(
                    id: chapter.id,
                    title: chapter.phase,
                    subtitle: chapter.summary,
                    continues: false,
                    chapters: [chapter]
                )
            }
        }

        return (1...12).map { localMonth in
            let northern = northernEquivalent(localMonth: localMonth, hemisphere: resolvedHemisphere)
            let direct = chapters(centeredOn: northern, season: resolvedSeason)
            if direct.isEmpty {
                let carried = carryingChapters(before: northern, season: resolvedSeason)
                return CareCalendarEntry(
                    id: "local-\(localMonth)",
                    title: monthName(localMonth),
                    subtitle: carried.first.map { "Still \($0.phase)" } ?? "Quiet",
                    continues: true,
                    chapters: carried
                )
            }
            return CareCalendarEntry(
                id: "local-\(localMonth)",
                title: monthName(localMonth),
                subtitle: direct.map(\.phase).joined(separator: " · "),
                continues: false,
                chapters: direct
            )
        }
    }

    /// The reading for this calendar day. Tropical has no month to land on.
    static func entry(
        on date: Date,
        hemisphere: GardenHemisphere?,
        season: GardenSeason?,
        calendar: Calendar = .current
    ) -> CareCalendarEntry? {
        let month = calendar.component(.month, from: date)
        return entries(hemisphere: hemisphere, season: season).first { $0.id == "local-\(month)" }
    }

    /// Extra line when a subtropical cool season is showing a temperate winter phase.
    static func seasonNote(season: GardenSeason?, chapters: [CareCalendarChapter]) -> String? {
        guard season == .subtropical else { return nil }
        let cool = chapters.contains { [11, 12, 1, 2].contains($0.temperateMonth) }
        guard cool else { return nil }
        return "In a subtropical garden this is a cool season, not a frozen dormancy. If the tree is still growing, keep light water and a light feed. Save major root work for a strong flush."
    }

    static func monthName(_ month: Int) -> String {
        var components = DateComponents()
        components.month = month
        components.day = 1
        components.year = 2000
        let calendar = Calendar(identifier: .gregorian)
        guard let date = calendar.date(from: components) else { return "\(month)" }
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "MMMM"
        return formatter.string(from: date)
    }

    // MARK: - Clock

    /// Southern July reads as northern January.
    static func northernEquivalent(localMonth: Int, hemisphere: GardenHemisphere) -> Int {
        switch hemisphere {
        case .northern:
            localMonth
        case .southern:
            ((localMonth - 1 + 6) % 12) + 1
        }
    }

    /// Where a temperate phase sits in a northern year for this season.
    static func northernCenter(temperateMonth: Int, season: GardenSeason) -> Int {
        switch season {
        case .temperate, .subtropical, .tropical:
            temperateMonth
        case .cold:
            switch temperateMonth {
            case 3: 4
            case 4: 5
            case 5: 6
            case 6: 7
            case 7: 7
            case 9: 8
            case 10: 9
            case 11: 10
            default: temperateMonth
            }
        case .mild:
            switch temperateMonth {
            case 2: 1
            case 3: 2
            case 4: 3
            case 5: 4
            case 6: 5
            case 7: 6
            case 10: 11
            case 11: 11
            default: temperateMonth
            }
        }
    }

    private static func chapters(centeredOn northernMonth: Int, season: GardenSeason) -> [CareCalendarChapter] {
        temperateChapters.filter { northernCenter(temperateMonth: $0.temperateMonth, season: season) == northernMonth }
    }

    private static func carryingChapters(before northernMonth: Int, season: GardenSeason) -> [CareCalendarChapter] {
        for step in 1...4 {
            let earlier = ((northernMonth - 1 - step) + 12) % 12 + 1
            let found = chapters(centeredOn: earlier, season: season)
            if !found.isEmpty { return found }
        }
        return []
    }

    private static func month(
        id: String,
        temperateMonth: Int,
        phase: String,
        summary: String,
        note: String,
        all: String,
        deciduous: String,
        pine: String,
        juniper: String,
        flowering: String,
        indoor: String,
        fertilizing: String
    ) -> CareCalendarChapter {
        let lines: [(String, String, String)] = [
            ("all", "All trees", all),
            ("deciduous", "Deciduous", deciduous),
            ("pine", "Pine", pine),
            ("juniper", "Juniper", juniper),
            ("flowering", "Flowering", flowering),
            ("indoor", "Indoor", indoor),
            ("fertilizing", "Fertilizing", fertilizing)
        ]
        return CareCalendarChapter(
            id: id,
            temperateMonth: temperateMonth,
            phase: phase,
            summary: summary,
            note: note,
            tasks: lines.map { key, title, line in
                CareCalendarTaskGroup(id: "\(id)-\(key)", title: title, line: line)
            }
        )
    }

    // MARK: - Temperate year

    private static let midwinter = month(
        id: "midwinter",
        temperateMonth: 1,
        phase: "Midwinter",
        summary: "The outdoor year is quiet. Prepare the bench, and keep indoor trees from drying out.",
        note: "A frozen pot does not need a summer watering. Wind and sun on frozen soil do the damage. Roots still need the ball not to desiccate, so check a pot that sits in a dry wind.",
        all: "Confirm the winter cover. Water only when the medium is dry and not frozen.",
        deciduous: "Read the bare structure and plan spring cuts. Leave the saw in a hard freeze. Larch is bare too. Bend it only when the wood is no longer brittle.",
        pine: "No candle work. Decide which trees are single-flush and which are two-flush before spring.",
        juniper: "No tip pinching. Keep wet foliage off the cover.",
        flowering: "Leave the flower buds. They are next year's bloom.",
        indoor: "Brightest window. A fortnightly look. Scale and mealybug like dry heated air.",
        fertilizing: "None outdoors. None indoors while growth has stopped."
    )

    private static let lateWinter = month(
        id: "late-winter",
        temperateMonth: 2,
        phase: "Late winter",
        summary: "Buds may swell. Growth has not started.",
        note: "A swelling bud is a reason to watch, not a repot date. Feed before growth has nowhere useful to go.",
        all: "Keep sun off a frozen root ball. Wait to repot until the ball is frost-free and the tree is moving.",
        deciduous: "Wire while buds are still tight. Bend later, when sap is up. Larch can be wired in this window if the branches are pliable.",
        pine: "Do not pinch. Scion wood for grafting can be cut now and kept cool.",
        juniper: "Still no hedge pinching. Repot only a failed pot, and only as foliage color starts to shift.",
        flowering: "Do not cut shoots that carry this spring's flowers.",
        indoor: "Water as the medium dries. Rinse dusty leaves. Dense shop soil can move to an open mix before a soft flush.",
        fertilizing: "None on dormant outdoor trees."
    )

    private static let earlySpring = month(
        id: "early-spring",
        temperateMonth: 3,
        phase: "Early spring",
        summary: "Repot when buds swell and the soil is frost-free. Deciduous trees first.",
        note: "After a repot, give light without hard sun and wind. One frost night means cover what you have already brought forward. Do not feed until the new shoots open.",
        all: "Repot only a frost-free root ball. Clear weeds and dead leaves from pots that are staying put.",
        deciduous: "Repot when buds swell, before the leaves open. Young packed pots before old settled trees. Larch repots with them.",
        pine: "Wait until the deciduous repots are done. Keep part of the root ball. Do not bare-root, and do not pinch candles yet.",
        juniper: "Repot a packed pot when the foliage color shifts. Do not hard-prune in the same season. Leave green on every branch you keep.",
        flowering: "Azalea and similar bloomers repot after flowering, not in this general deciduous window.",
        indoor: "Trim what is extending. Hold kinds you want to flower or fruit.",
        fertilizing: "None until shoots open. None for two to four weeks after a repot."
    )

    private static let spring = month(
        id: "spring",
        temperateMonth: 4,
        phase: "Spring",
        summary: "Growth is underway. Finish repotting, and watch new wire.",
        note: "Shoots thicken fast. Wire that was safe last month can bite this month. Your last frost, not a date, decides when winter cover comes off.",
        all: "Bring trees out when your nights are past the worst frost. Check wire every week.",
        deciduous: "Finish repotting. Dead wood shows against the new break. Rub buds you do not want.",
        pine: "Repot before the candles elongate. No candle cut, and no needle plucking on a tree just repotted.",
        juniper: "Cut long shoots back into the pad with scissors. Do not pinch every tip. Last year's wood can be set as cuttings.",
        flowering: "After bloom, cut azalea, cherry, and apple back to shape. That is their prune.",
        indoor: "Trim extension. Leave flower and fruit kinds until the display is finished.",
        fertilizing: "A light feed about every fortnight on trees that are actually growing. Developing trees can take more nitrogen. Skip dormant trees and fresh repots."
    )

    private static let lateSpring = month(
        id: "late-spring",
        temperateMonth: 5,
        phase: "Late spring",
        summary: "Trim what is strong. Leave what is weak or still building the trunk.",
        note: "A refined tree and a tree you still want thicker are not on the same cut. Repeating a short cut builds twigs. Letting the shoot run builds the trunk.",
        all: "Water by the pot. Deciduous trees in leaf drink more than pine and juniper. Shade a tree that flags at noon.",
        deciduous: "Refined trees can come back to one or two leaves. Weak trees keep the extension. On a refined Japanese maple, keep the first two leaves as the bud opens. Beech flushes once. Do not defoliate it.",
        pine: "Single-flush: pinch candles with the fingers when they have extended, strong zones first. Scissors brown the needle tips. Two-flush: leave the candles. Decandling is later.",
        juniper: "Cut runners back inside the pad. Thin a pad that has closed up. Never strip a branch bare.",
        flowering: "The after-bloom cut is done. Leave the shoots that will flower next year.",
        indoor: "Trim extension. Hold fruiting kinds.",
        fertilizing: "Developing trees every other week. Hold refined trees you do not want coarse. Stop feed on a two-flush pine about four weeks before decandling. None for two to four weeks after a repot."
    )

    private static let earlySummer = month(
        id: "early-summer",
        temperateMonth: 6,
        phase: "Early summer",
        summary: "Water first. Feed trees that are still growing.",
        note: "A bone-dry pot often needs two passes. Partial defoliation is a technique for a strong tree that is known to answer, not a habit. Beech is not one of them.",
        all: "Water is the job. Rinse dust off the foliage. Look for caterpillars and mite.",
        deciduous: "Cut shoots that run past the design on trees that flush all season. Full or partial defoliation only on a strong, healthy tree around midsummer.",
        pine: "Two-flush pines on strong trees can be decandled as candles finish, weak zones left, medium zones before strong zones. Do not decandle a weak tree. Single-flush pinching should be finished or finishing.",
        juniper: "A second cut of shoots that have run out of the pad.",
        flowering: "Next year's flower buds are setting. Stop pruning those shoots.",
        indoor: "Same trim. More water in a hot room, and a look under the leaf for mite.",
        fertilizing: "Keep feeding trees that are still extending. Pause if heat stops the tree. No feed on a pine just decandled."
    )

    private static let highSummer = month(
        id: "high-summer",
        temperateMonth: 7,
        phase: "High summer",
        summary: "Keep the pots wet and the wire honest. Little new design.",
        note: "Above about 32 °C many trees pause. Leaves are how they cool. That pause is common in a mild or subtropical summer and rare in a cold one.",
        all: "Morning water, and again if the pot is light. Cut off wire where bark has rolled over it. Do not unwind it through the scar.",
        deciduous: "If the tree is stalled in heat, leave the foliage. Trim only shoots that have run past the outline.",
        pine: "Decandling of smaller or later two-flush pines can run into this month. Leave the second flush alone until it hardens.",
        juniper: "One more cut of runners if they have run. No structural prune in heat.",
        flowering: "Leave them.",
        indoor: "Hot dry air brings spider mite. Rinse, and look under the leaf.",
        fertilizing: "Stop if the tree has stalled in heat. Otherwise a light feed only on trees still growing."
    )

    private static let lateSummer = month(
        id: "late-summer",
        temperateMonth: 8,
        phase: "Late summer",
        summary: "Leave next year's flowers. Take wire off before it scars.",
        note: "Feed the tree does not use now is stored for spring. It will not repair a weak tree this month. Photograph trees while they are still in leaf.",
        all: "If wire has marked the bark, cut it off and let the tree grow.",
        deciduous: "Most need no trim. Early-spring flowerers are under Flowering.",
        pine: "When a second flush hardens, feed can return on decandled pines. No decandling of a weak tree. Heavy cuts of old wood wait for cooler weeks.",
        juniper: "Only soft tips that are still running.",
        flowering: "Do not cut azalea, camellia, apple, or stone fruits if you want flowers next year.",
        indoor: "Watch heat and mite.",
        fertilizing: "Resume on decandled pines once the second flush has hardened. From here, feed is lower in nitrogen."
    )

    private static let earlyAutumn = month(
        id: "early-autumn",
        temperateMonth: 9,
        phase: "Early autumn",
        summary: "Color and fruit. Less water. The last feed, then stop.",
        note: "A late repot is a gamble where winter comes hard. If you do it, leave at least half the root ball and plan on frost cover. Ease water gradually if you want deeper autumn color.",
        all: "Water less often as the days cool. Still check shallow pots and trees in fruit. Pests feed up before winter.",
        deciduous: "Thin fruit while it is small if the tree matters more than the crop. Structural prune waits until leaf drop.",
        pine: "Pluck the oldest needles so light reaches the inner buds. Where three shoots leave one point, keep two of similar strength.",
        juniper: "Maintenance only. A mild end to this phase is the last reasonable window to collect pine, spruce, and juniper.",
        flowering: "No pruning of shoots that will bloom next spring.",
        indoor: "Bring them in before frost. Check for insects first.",
        fertilizing: "A light, lower-nitrogen feed every second or third week on trees still in the plan. Stop by the end of this phase in a temperate climate. None on a fresh repot."
    )

    private static let autumn = month(
        id: "autumn",
        temperateMonth: 10,
        phase: "Autumn",
        summary: "Let the color finish. Stop feeding. Prepare the winter place.",
        note: "Drainage you arranged in spring is what saves the root in a wet autumn. Do not leave a pot standing in a saucer of rain.",
        all: "Less water. Cut off wire that has finished. Do not unwind it.",
        deciduous: "After leaf drop, and once sap has left the shoots, cut back to the line you want. Larch wires well as the needles drop.",
        pine: "Finish old-needle plucking. Wire from now until frost makes the wood brittle.",
        juniper: "Wire and structural work belong now, not in the soft flush. Leave green on every branch you keep.",
        flowering: "Leave the flower buds.",
        indoor: "Already inside. Move them off a cold night in stages. Look for scale.",
        fertilizing: "None for deciduous trees. A last low-nitrogen feed for conifers only if they are still mildly active."
    )

    private static let lateAutumn = month(
        id: "late-autumn",
        temperateMonth: 11,
        phase: "Late autumn",
        summary: "Clear the bench. Move trees before the hard frost.",
        note: "Folded dead leaves are winter housing for insects. Cold wood snaps, so wire only with patience, or wait.",
        all: "Clear leaves off the soil and the benches. Place trees where one lift puts them under cover.",
        deciduous: "You can still read the branches. Do not tidy off buds you meant to keep.",
        pine: "No candle work. A last look at old needles and wire.",
        juniper: "Same. Do not strip foliage.",
        flowering: "Leave the buds.",
        indoor: "Less water as the room cools. Keep checking pests.",
        fertilizing: "None."
    )

    private static let earlyWinter = month(
        id: "early-winter",
        temperateMonth: 12,
        phase: "Early winter",
        summary: "Almost no water outside. A little attention inside.",
        note: "A favorite ceramic pot can come off a tree with a firm root ball and stay dry indoors. The tree can sit winter in a plain box. Soaked ornamental pots are what crack.",
        all: "Do not water a moist outdoor tree. Raise pots out of meltwater that freezes at night. Shelter wind and sun.",
        deciduous: "Plan the spring repot order. Deciduous trees first.",
        pine: "Plan single-flush pinch against two-flush decandle. Do neither now.",
        juniper: "Check that covers are not holding wet foliage.",
        flowering: "Buds are next year's flower. Do not tidy them off.",
        indoor: "A look every couple of weeks. Cooler air means less water. Dry air is the usual problem.",
        fertilizing: "None."
    )

    // MARK: - Tropical year

    private static let tropicalGrowing = month(
        id: "tropical-growing",
        temperateMonth: 0,
        phase: "Growing strongly",
        summary: "When shoots are extending, this is the time for trim, feed, and root work.",
        note: "A tropical bonsai takes its orders from light, warmth, and water. Do the strong work in a strong flush.",
        all: "Water when the medium starts to dry. Watch wire. Shoots thicken quickly.",
        deciduous: "Cut back to the outline while the tree is healthy enough to answer. A tree you want thicker should run.",
        pine: "If you grow pine here, work it on its own flush, not on a winter date. Pinch or decandle only a strong tree.",
        juniper: "Cut runners back into the pad a few times while it grows. Do not pinch every tip, and do not strip a branch.",
        flowering: "Prune after the display, or you remove the next one.",
        indoor: "A bright window or a grow light matters more than the name of the month.",
        fertilizing: "Light and often while new leaves are being made. Stop when extension stops. No feed in the weeks after a repot."
    )

    private static let tropicalPause = month(
        id: "tropical-pause",
        temperateMonth: 0,
        phase: "Hot or dry pause",
        summary: "Some trees stop when it is too hot or the season turns dry.",
        note: "A pause is not a temperate winter. Do not try to restart a stopped tree with fertilizer.",
        all: "Match water to the stop. Shade a pot in full sun. A flooded pot after heavy rain needs a more open mix.",
        deciduous: "No hard prune and no repot while growth has stopped.",
        pine: "Leave candles and needles alone until the tree is growing again.",
        juniper: "No structural cut. Keep the roots from cooking or sitting wet.",
        flowering: "Hold the scissors.",
        indoor: "Dry air brings spider mite and scale. Rinse, and look under the leaf.",
        fertilizing: "None while the tree is standing still."
    )

    private static let tropicalFlush = month(
        id: "tropical-flush",
        temperateMonth: 0,
        phase: "New flush",
        summary: "A new break after rain, or after a rest, is when shape is set.",
        note: "Cut a shoot that has hardened enough to see. A brand-new soft leaf is not ready.",
        all: "Resume a light feed when the new leaves have expanded. Check drainage after heavy rain.",
        deciduous: "Reduce to the length the design needs, and let the next wave build the twig.",
        pine: "Balance strong and weak zones. Do not treat every pine as a two-flush black pine.",
        juniper: "Thin a pad that has closed. Cut runners. Leave green on every branch you keep.",
        flowering: "Wait until this flush's flowers are done before you cut.",
        indoor: "Same cuts if the tree is flushing on a windowsill. Keep a new cutting shaded until it is growing on its own roots.",
        fertilizing: "Light feed once the new leaves have opened. Developing trees can take a little more."
    )

    private static let tropicalCool = month(
        id: "tropical-cool",
        temperateMonth: 0,
        phase: "Cool nights",
        summary: "Cool weather slows tropicals. It does not turn them into pines.",
        note: "Many tropicals stall well before a frost. Save repotting and heavy cuts for the next strong flush unless the pot has failed.",
        all: "Water by the weight of the pot. A cool tropical sits wet for too long on a summer rhythm.",
        deciduous: "No hard prune while the tree is standing still.",
        pine: "No candle work just because the calendar says winter or summer.",
        juniper: "Leave the pads. Check they are not staying wet in a cool room.",
        flowering: "Leave buds that are already set.",
        indoor: "Best light in the house. Quarantine anything that comes in from outdoors. One forecast frost is enough to move a tender tree.",
        fertilizing: "None while there is no growth."
    )
}
